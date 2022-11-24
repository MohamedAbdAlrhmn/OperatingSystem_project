
obj/user/tst_first_fit_3:     file format elf32-i386


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
  800031:	e8 a7 0d 00 00       	call   800ddd <libmain>
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
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 4b 26 00 00       	call   802695 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 40 80 00       	mov    0x804020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 40 80 00       	mov    0x804020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 60 29 80 00       	push   $0x802960
  8000a0:	6a 16                	push   $0x16
  8000a2:	68 7c 29 80 00       	push   $0x80297c
  8000a7:	e8 6d 0e 00 00       	call   800f19 <_panic>
	}

	int envID = sys_getenvid();
  8000ac:	e8 96 23 00 00       	call   802447 <sys_getenvid>
  8000b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b4:	83 ec 0c             	sub    $0xc,%esp
  8000b7:	6a 00                	push   $0x0
  8000b9:	e8 b3 1e 00 00       	call   801f71 <malloc>
  8000be:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000c1:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000c8:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  8000cf:	8d 55 8c             	lea    -0x74(%ebp),%edx
  8000d2:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 9b 20 00 00       	call   802180 <sys_calculate_free_frames>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e8:	e8 33 21 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	6a 01                	push   $0x1
  8000f8:	50                   	push   %eax
  8000f9:	68 93 29 80 00       	push   $0x802993
  8000fe:	e8 c9 1e 00 00       	call   801fcc <smalloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if (ptr_allocations[0] != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800109:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80010c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800111:	74 14                	je     800127 <_main+0xef>
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 98 29 80 00       	push   $0x802998
  80011b:	6a 2a                	push   $0x2a
  80011d:	68 7c 29 80 00       	push   $0x80297c
  800122:	e8 f2 0d 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  256+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800127:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80012a:	e8 51 20 00 00       	call   802180 <sys_calculate_free_frames>
  80012f:	29 c3                	sub    %eax,%ebx
  800131:	89 d8                	mov    %ebx,%eax
  800133:	3d 03 01 00 00       	cmp    $0x103,%eax
  800138:	74 14                	je     80014e <_main+0x116>
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	68 04 2a 80 00       	push   $0x802a04
  800142:	6a 2b                	push   $0x2b
  800144:	68 7c 29 80 00       	push   $0x80297c
  800149:	e8 cb 0d 00 00       	call   800f19 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014e:	e8 cd 20 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800153:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 82 2a 80 00       	push   $0x802a82
  800160:	6a 2c                	push   $0x2c
  800162:	68 7c 29 80 00       	push   $0x80297c
  800167:	e8 ad 0d 00 00       	call   800f19 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80016c:	e8 0f 20 00 00       	call   802180 <sys_calculate_free_frames>
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800174:	e8 a7 20 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800179:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80017c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80017f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	e8 e6 1d 00 00       	call   801f71 <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800191:	8b 45 90             	mov    -0x70(%ebp),%eax
  800194:	89 c2                	mov    %eax,%edx
  800196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800199:	05 00 00 00 80       	add    $0x80000000,%eax
  80019e:	39 c2                	cmp    %eax,%edx
  8001a0:	74 14                	je     8001b6 <_main+0x17e>
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 a0 2a 80 00       	push   $0x802aa0
  8001aa:	6a 32                	push   $0x32
  8001ac:	68 7c 29 80 00       	push   $0x80297c
  8001b1:	e8 63 0d 00 00       	call   800f19 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8001b6:	e8 65 20 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8001bb:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8001be:	3d 00 01 00 00       	cmp    $0x100,%eax
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 82 2a 80 00       	push   $0x802a82
  8001cd:	6a 34                	push   $0x34
  8001cf:	68 7c 29 80 00       	push   $0x80297c
  8001d4:	e8 40 0d 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001d9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8001dc:	e8 9f 1f 00 00       	call   802180 <sys_calculate_free_frames>
  8001e1:	29 c3                	sub    %eax,%ebx
  8001e3:	89 d8                	mov    %ebx,%eax
  8001e5:	83 f8 01             	cmp    $0x1,%eax
  8001e8:	74 14                	je     8001fe <_main+0x1c6>
  8001ea:	83 ec 04             	sub    $0x4,%esp
  8001ed:	68 d0 2a 80 00       	push   $0x802ad0
  8001f2:	6a 35                	push   $0x35
  8001f4:	68 7c 29 80 00       	push   $0x80297c
  8001f9:	e8 1b 0d 00 00       	call   800f19 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 7d 1f 00 00       	call   802180 <sys_calculate_free_frames>
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 15 20 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  80020b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  80020e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800211:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	50                   	push   %eax
  800218:	e8 54 1d 00 00       	call   801f71 <malloc>
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800223:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800226:	89 c2                	mov    %eax,%edx
  800228:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80022b:	01 c0                	add    %eax,%eax
  80022d:	05 00 00 00 80       	add    $0x80000000,%eax
  800232:	39 c2                	cmp    %eax,%edx
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 a0 2a 80 00       	push   $0x802aa0
  80023e:	6a 3b                	push   $0x3b
  800240:	68 7c 29 80 00       	push   $0x80297c
  800245:	e8 cf 0c 00 00       	call   800f19 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80024a:	e8 d1 1f 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  80024f:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800252:	3d 00 01 00 00       	cmp    $0x100,%eax
  800257:	74 14                	je     80026d <_main+0x235>
  800259:	83 ec 04             	sub    $0x4,%esp
  80025c:	68 82 2a 80 00       	push   $0x802a82
  800261:	6a 3d                	push   $0x3d
  800263:	68 7c 29 80 00       	push   $0x80297c
  800268:	e8 ac 0c 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80026d:	e8 0e 1f 00 00       	call   802180 <sys_calculate_free_frames>
  800272:	89 c2                	mov    %eax,%edx
  800274:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800277:	39 c2                	cmp    %eax,%edx
  800279:	74 14                	je     80028f <_main+0x257>
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	68 d0 2a 80 00       	push   $0x802ad0
  800283:	6a 3e                	push   $0x3e
  800285:	68 7c 29 80 00       	push   $0x80297c
  80028a:	e8 8a 0c 00 00       	call   800f19 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80028f:	e8 ec 1e 00 00       	call   802180 <sys_calculate_free_frames>
  800294:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800297:	e8 84 1f 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  80029c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  80029f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002a2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	50                   	push   %eax
  8002a9:	e8 c3 1c 00 00       	call   801f71 <malloc>
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8002b4:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002b7:	89 c1                	mov    %eax,%ecx
  8002b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002bc:	89 c2                	mov    %eax,%edx
  8002be:	01 d2                	add    %edx,%edx
  8002c0:	01 d0                	add    %edx,%eax
  8002c2:	05 00 00 00 80       	add    $0x80000000,%eax
  8002c7:	39 c1                	cmp    %eax,%ecx
  8002c9:	74 14                	je     8002df <_main+0x2a7>
  8002cb:	83 ec 04             	sub    $0x4,%esp
  8002ce:	68 a0 2a 80 00       	push   $0x802aa0
  8002d3:	6a 44                	push   $0x44
  8002d5:	68 7c 29 80 00       	push   $0x80297c
  8002da:	e8 3a 0c 00 00       	call   800f19 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8002df:	e8 3c 1f 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8002e4:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002e7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002ec:	74 14                	je     800302 <_main+0x2ca>
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	68 82 2a 80 00       	push   $0x802a82
  8002f6:	6a 46                	push   $0x46
  8002f8:	68 7c 29 80 00       	push   $0x80297c
  8002fd:	e8 17 0c 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800302:	e8 79 1e 00 00       	call   802180 <sys_calculate_free_frames>
  800307:	89 c2                	mov    %eax,%edx
  800309:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030c:	39 c2                	cmp    %eax,%edx
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 d0 2a 80 00       	push   $0x802ad0
  800318:	6a 47                	push   $0x47
  80031a:	68 7c 29 80 00       	push   $0x80297c
  80031f:	e8 f5 0b 00 00       	call   800f19 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800324:	e8 57 1e 00 00       	call   802180 <sys_calculate_free_frames>
  800329:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80032c:	e8 ef 1e 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800331:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800334:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800337:	01 c0                	add    %eax,%eax
  800339:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	e8 2c 1c 00 00       	call   801f71 <malloc>
  800345:	83 c4 10             	add    $0x10,%esp
  800348:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  80034b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80034e:	89 c2                	mov    %eax,%edx
  800350:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800353:	c1 e0 02             	shl    $0x2,%eax
  800356:	05 00 00 00 80       	add    $0x80000000,%eax
  80035b:	39 c2                	cmp    %eax,%edx
  80035d:	74 14                	je     800373 <_main+0x33b>
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	68 a0 2a 80 00       	push   $0x802aa0
  800367:	6a 4d                	push   $0x4d
  800369:	68 7c 29 80 00       	push   $0x80297c
  80036e:	e8 a6 0b 00 00       	call   800f19 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800373:	e8 a8 1e 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800378:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80037b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800380:	74 14                	je     800396 <_main+0x35e>
  800382:	83 ec 04             	sub    $0x4,%esp
  800385:	68 82 2a 80 00       	push   $0x802a82
  80038a:	6a 4f                	push   $0x4f
  80038c:	68 7c 29 80 00       	push   $0x80297c
  800391:	e8 83 0b 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  800396:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800399:	e8 e2 1d 00 00       	call   802180 <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 01             	cmp    $0x1,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 d0 2a 80 00       	push   $0x802ad0
  8003af:	6a 50                	push   $0x50
  8003b1:	68 7c 29 80 00       	push   $0x80297c
  8003b6:	e8 5e 0b 00 00       	call   800f19 <_panic>

		//Allocate Shared 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003bb:	e8 c0 1d 00 00       	call   802180 <sys_calculate_free_frames>
  8003c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003c3:	e8 58 1e 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8003c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  8003cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ce:	01 c0                	add    %eax,%eax
  8003d0:	83 ec 04             	sub    $0x4,%esp
  8003d3:	6a 01                	push   $0x1
  8003d5:	50                   	push   %eax
  8003d6:	68 e3 2a 80 00       	push   $0x802ae3
  8003db:	e8 ec 1b 00 00       	call   801fcc <smalloc>
  8003e0:	83 c4 10             	add    $0x10,%esp
  8003e3:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (ptr_allocations[5] != (uint32*)(USER_HEAP_START + 6*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8003e6:	8b 4d a0             	mov    -0x60(%ebp),%ecx
  8003e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ec:	89 d0                	mov    %edx,%eax
  8003ee:	01 c0                	add    %eax,%eax
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	01 c0                	add    %eax,%eax
  8003f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f9:	39 c1                	cmp    %eax,%ecx
  8003fb:	74 14                	je     800411 <_main+0x3d9>
  8003fd:	83 ec 04             	sub    $0x4,%esp
  800400:	68 98 29 80 00       	push   $0x802998
  800405:	6a 56                	push   $0x56
  800407:	68 7c 29 80 00       	push   $0x80297c
  80040c:	e8 08 0b 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  512+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800411:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800414:	e8 67 1d 00 00       	call   802180 <sys_calculate_free_frames>
  800419:	29 c3                	sub    %eax,%ebx
  80041b:	89 d8                	mov    %ebx,%eax
  80041d:	3d 03 02 00 00       	cmp    $0x203,%eax
  800422:	74 14                	je     800438 <_main+0x400>
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 04 2a 80 00       	push   $0x802a04
  80042c:	6a 57                	push   $0x57
  80042e:	68 7c 29 80 00       	push   $0x80297c
  800433:	e8 e1 0a 00 00       	call   800f19 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800438:	e8 e3 1d 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  80043d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800440:	74 14                	je     800456 <_main+0x41e>
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 82 2a 80 00       	push   $0x802a82
  80044a:	6a 58                	push   $0x58
  80044c:	68 7c 29 80 00       	push   $0x80297c
  800451:	e8 c3 0a 00 00       	call   800f19 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800456:	e8 25 1d 00 00       	call   802180 <sys_calculate_free_frames>
  80045b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80045e:	e8 bd 1d 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800463:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800466:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800469:	89 c2                	mov    %eax,%edx
  80046b:	01 d2                	add    %edx,%edx
  80046d:	01 d0                	add    %edx,%eax
  80046f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	50                   	push   %eax
  800476:	e8 f6 1a 00 00       	call   801f71 <malloc>
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800481:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800484:	89 c2                	mov    %eax,%edx
  800486:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800489:	c1 e0 03             	shl    $0x3,%eax
  80048c:	05 00 00 00 80       	add    $0x80000000,%eax
  800491:	39 c2                	cmp    %eax,%edx
  800493:	74 14                	je     8004a9 <_main+0x471>
  800495:	83 ec 04             	sub    $0x4,%esp
  800498:	68 a0 2a 80 00       	push   $0x802aa0
  80049d:	6a 5e                	push   $0x5e
  80049f:	68 7c 29 80 00       	push   $0x80297c
  8004a4:	e8 70 0a 00 00       	call   800f19 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  768) panic("Wrong page file allocation: ");
  8004a9:	e8 72 1d 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8004ae:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8004b1:	3d 00 03 00 00       	cmp    $0x300,%eax
  8004b6:	74 14                	je     8004cc <_main+0x494>
  8004b8:	83 ec 04             	sub    $0x4,%esp
  8004bb:	68 82 2a 80 00       	push   $0x802a82
  8004c0:	6a 60                	push   $0x60
  8004c2:	68 7c 29 80 00       	push   $0x80297c
  8004c7:	e8 4d 0a 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004cc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004cf:	e8 ac 1c 00 00       	call   802180 <sys_calculate_free_frames>
  8004d4:	29 c3                	sub    %eax,%ebx
  8004d6:	89 d8                	mov    %ebx,%eax
  8004d8:	83 f8 01             	cmp    $0x1,%eax
  8004db:	74 14                	je     8004f1 <_main+0x4b9>
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	68 d0 2a 80 00       	push   $0x802ad0
  8004e5:	6a 61                	push   $0x61
  8004e7:	68 7c 29 80 00       	push   $0x80297c
  8004ec:	e8 28 0a 00 00       	call   800f19 <_panic>

		//Allocate Shared 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004f1:	e8 8a 1c 00 00       	call   802180 <sys_calculate_free_frames>
  8004f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f9:	e8 22 1d 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8004fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  800501:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800504:	89 c2                	mov    %eax,%edx
  800506:	01 d2                	add    %edx,%edx
  800508:	01 d0                	add    %edx,%eax
  80050a:	83 ec 04             	sub    $0x4,%esp
  80050d:	6a 00                	push   $0x0
  80050f:	50                   	push   %eax
  800510:	68 e5 2a 80 00       	push   $0x802ae5
  800515:	e8 b2 1a 00 00       	call   801fcc <smalloc>
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if (ptr_allocations[7] != (uint32*)(USER_HEAP_START + 11*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800520:	8b 4d a8             	mov    -0x58(%ebp),%ecx
  800523:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	01 c0                	add    %eax,%eax
  80052f:	01 d0                	add    %edx,%eax
  800531:	05 00 00 00 80       	add    $0x80000000,%eax
  800536:	39 c1                	cmp    %eax,%ecx
  800538:	74 14                	je     80054e <_main+0x516>
  80053a:	83 ec 04             	sub    $0x4,%esp
  80053d:	68 98 29 80 00       	push   $0x802998
  800542:	6a 67                	push   $0x67
  800544:	68 7c 29 80 00       	push   $0x80297c
  800549:	e8 cb 09 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80054e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800551:	e8 2a 1c 00 00       	call   802180 <sys_calculate_free_frames>
  800556:	29 c3                	sub    %eax,%ebx
  800558:	89 d8                	mov    %ebx,%eax
  80055a:	3d 04 03 00 00       	cmp    $0x304,%eax
  80055f:	74 14                	je     800575 <_main+0x53d>
  800561:	83 ec 04             	sub    $0x4,%esp
  800564:	68 04 2a 80 00       	push   $0x802a04
  800569:	6a 68                	push   $0x68
  80056b:	68 7c 29 80 00       	push   $0x80297c
  800570:	e8 a4 09 00 00       	call   800f19 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800575:	e8 a6 1c 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  80057a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80057d:	74 14                	je     800593 <_main+0x55b>
  80057f:	83 ec 04             	sub    $0x4,%esp
  800582:	68 82 2a 80 00       	push   $0x802a82
  800587:	6a 69                	push   $0x69
  800589:	68 7c 29 80 00       	push   $0x80297c
  80058e:	e8 86 09 00 00       	call   800f19 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800593:	e8 e8 1b 00 00       	call   802180 <sys_calculate_free_frames>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80059b:	e8 80 1c 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8005a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  8005a3:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	50                   	push   %eax
  8005aa:	e8 03 1a 00 00       	call   801fb2 <free>
  8005af:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  8005b2:	e8 69 1c 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8005b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005ba:	29 c2                	sub    %eax,%edx
  8005bc:	89 d0                	mov    %edx,%eax
  8005be:	3d 00 01 00 00       	cmp    $0x100,%eax
  8005c3:	74 14                	je     8005d9 <_main+0x5a1>
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 e7 2a 80 00       	push   $0x802ae7
  8005cd:	6a 73                	push   $0x73
  8005cf:	68 7c 29 80 00       	push   $0x80297c
  8005d4:	e8 40 09 00 00       	call   800f19 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005d9:	e8 a2 1b 00 00       	call   802180 <sys_calculate_free_frames>
  8005de:	89 c2                	mov    %eax,%edx
  8005e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e3:	39 c2                	cmp    %eax,%edx
  8005e5:	74 14                	je     8005fb <_main+0x5c3>
  8005e7:	83 ec 04             	sub    $0x4,%esp
  8005ea:	68 fe 2a 80 00       	push   $0x802afe
  8005ef:	6a 74                	push   $0x74
  8005f1:	68 7c 29 80 00       	push   $0x80297c
  8005f6:	e8 1e 09 00 00       	call   800f19 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005fb:	e8 80 1b 00 00       	call   802180 <sys_calculate_free_frames>
  800600:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800603:	e8 18 1c 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800608:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  80060b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80060e:	83 ec 0c             	sub    $0xc,%esp
  800611:	50                   	push   %eax
  800612:	e8 9b 19 00 00       	call   801fb2 <free>
  800617:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  512) panic("Wrong page file free: ");
  80061a:	e8 01 1c 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  80061f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800622:	29 c2                	sub    %eax,%edx
  800624:	89 d0                	mov    %edx,%eax
  800626:	3d 00 02 00 00       	cmp    $0x200,%eax
  80062b:	74 14                	je     800641 <_main+0x609>
  80062d:	83 ec 04             	sub    $0x4,%esp
  800630:	68 e7 2a 80 00       	push   $0x802ae7
  800635:	6a 7b                	push   $0x7b
  800637:	68 7c 29 80 00       	push   $0x80297c
  80063c:	e8 d8 08 00 00       	call   800f19 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800641:	e8 3a 1b 00 00       	call   802180 <sys_calculate_free_frames>
  800646:	89 c2                	mov    %eax,%edx
  800648:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064b:	39 c2                	cmp    %eax,%edx
  80064d:	74 14                	je     800663 <_main+0x62b>
  80064f:	83 ec 04             	sub    $0x4,%esp
  800652:	68 fe 2a 80 00       	push   $0x802afe
  800657:	6a 7c                	push   $0x7c
  800659:	68 7c 29 80 00       	push   $0x80297c
  80065e:	e8 b6 08 00 00       	call   800f19 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800663:	e8 18 1b 00 00       	call   802180 <sys_calculate_free_frames>
  800668:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80066b:	e8 b0 1b 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800670:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  800673:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800676:	83 ec 0c             	sub    $0xc,%esp
  800679:	50                   	push   %eax
  80067a:	e8 33 19 00 00       	call   801fb2 <free>
  80067f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  800682:	e8 99 1b 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800687:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80068a:	29 c2                	sub    %eax,%edx
  80068c:	89 d0                	mov    %edx,%eax
  80068e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800693:	74 17                	je     8006ac <_main+0x674>
  800695:	83 ec 04             	sub    $0x4,%esp
  800698:	68 e7 2a 80 00       	push   $0x802ae7
  80069d:	68 83 00 00 00       	push   $0x83
  8006a2:	68 7c 29 80 00       	push   $0x80297c
  8006a7:	e8 6d 08 00 00       	call   800f19 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006ac:	e8 cf 1a 00 00       	call   802180 <sys_calculate_free_frames>
  8006b1:	89 c2                	mov    %eax,%edx
  8006b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b6:	39 c2                	cmp    %eax,%edx
  8006b8:	74 17                	je     8006d1 <_main+0x699>
  8006ba:	83 ec 04             	sub    $0x4,%esp
  8006bd:	68 fe 2a 80 00       	push   $0x802afe
  8006c2:	68 84 00 00 00       	push   $0x84
  8006c7:	68 7c 29 80 00       	push   $0x80297c
  8006cc:	e8 48 08 00 00       	call   800f19 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8006d1:	e8 aa 1a 00 00       	call   802180 <sys_calculate_free_frames>
  8006d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006d9:	e8 42 1b 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8006de:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8006e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	c1 e0 09             	shl    $0x9,%eax
  8006e9:	29 d0                	sub    %edx,%eax
  8006eb:	83 ec 0c             	sub    $0xc,%esp
  8006ee:	50                   	push   %eax
  8006ef:	e8 7d 18 00 00       	call   801f71 <malloc>
  8006f4:	83 c4 10             	add    $0x10,%esp
  8006f7:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8006fa:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006fd:	89 c2                	mov    %eax,%edx
  8006ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800702:	05 00 00 00 80       	add    $0x80000000,%eax
  800707:	39 c2                	cmp    %eax,%edx
  800709:	74 17                	je     800722 <_main+0x6ea>
  80070b:	83 ec 04             	sub    $0x4,%esp
  80070e:	68 a0 2a 80 00       	push   $0x802aa0
  800713:	68 8d 00 00 00       	push   $0x8d
  800718:	68 7c 29 80 00       	push   $0x80297c
  80071d:	e8 f7 07 00 00       	call   800f19 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800722:	e8 f9 1a 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800727:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80072a:	3d 80 00 00 00       	cmp    $0x80,%eax
  80072f:	74 17                	je     800748 <_main+0x710>
  800731:	83 ec 04             	sub    $0x4,%esp
  800734:	68 82 2a 80 00       	push   $0x802a82
  800739:	68 8f 00 00 00       	push   $0x8f
  80073e:	68 7c 29 80 00       	push   $0x80297c
  800743:	e8 d1 07 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800748:	e8 33 1a 00 00       	call   802180 <sys_calculate_free_frames>
  80074d:	89 c2                	mov    %eax,%edx
  80074f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800752:	39 c2                	cmp    %eax,%edx
  800754:	74 17                	je     80076d <_main+0x735>
  800756:	83 ec 04             	sub    $0x4,%esp
  800759:	68 d0 2a 80 00       	push   $0x802ad0
  80075e:	68 90 00 00 00       	push   $0x90
  800763:	68 7c 29 80 00       	push   $0x80297c
  800768:	e8 ac 07 00 00       	call   800f19 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80076d:	e8 0e 1a 00 00       	call   802180 <sys_calculate_free_frames>
  800772:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800775:	e8 a6 1a 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  80077a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80077d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800780:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800783:	83 ec 0c             	sub    $0xc,%esp
  800786:	50                   	push   %eax
  800787:	e8 e5 17 00 00       	call   801f71 <malloc>
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800792:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800795:	89 c2                	mov    %eax,%edx
  800797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80079a:	c1 e0 02             	shl    $0x2,%eax
  80079d:	05 00 00 00 80       	add    $0x80000000,%eax
  8007a2:	39 c2                	cmp    %eax,%edx
  8007a4:	74 17                	je     8007bd <_main+0x785>
  8007a6:	83 ec 04             	sub    $0x4,%esp
  8007a9:	68 a0 2a 80 00       	push   $0x802aa0
  8007ae:	68 96 00 00 00       	push   $0x96
  8007b3:	68 7c 29 80 00       	push   $0x80297c
  8007b8:	e8 5c 07 00 00       	call   800f19 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007bd:	e8 5e 1a 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8007c2:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8007c5:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007ca:	74 17                	je     8007e3 <_main+0x7ab>
  8007cc:	83 ec 04             	sub    $0x4,%esp
  8007cf:	68 82 2a 80 00       	push   $0x802a82
  8007d4:	68 98 00 00 00       	push   $0x98
  8007d9:	68 7c 29 80 00       	push   $0x80297c
  8007de:	e8 36 07 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007e3:	e8 98 19 00 00       	call   802180 <sys_calculate_free_frames>
  8007e8:	89 c2                	mov    %eax,%edx
  8007ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ed:	39 c2                	cmp    %eax,%edx
  8007ef:	74 17                	je     800808 <_main+0x7d0>
  8007f1:	83 ec 04             	sub    $0x4,%esp
  8007f4:	68 d0 2a 80 00       	push   $0x802ad0
  8007f9:	68 99 00 00 00       	push   $0x99
  8007fe:	68 7c 29 80 00       	push   $0x80297c
  800803:	e8 11 07 00 00       	call   800f19 <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800808:	e8 73 19 00 00       	call   802180 <sys_calculate_free_frames>
  80080d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800810:	e8 0b 1a 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800815:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  800818:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80081b:	89 d0                	mov    %edx,%eax
  80081d:	c1 e0 08             	shl    $0x8,%eax
  800820:	29 d0                	sub    %edx,%eax
  800822:	83 ec 0c             	sub    $0xc,%esp
  800825:	50                   	push   %eax
  800826:	e8 46 17 00 00       	call   801f71 <malloc>
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800831:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800834:	89 c2                	mov    %eax,%edx
  800836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800839:	c1 e0 09             	shl    $0x9,%eax
  80083c:	89 c1                	mov    %eax,%ecx
  80083e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800841:	01 c8                	add    %ecx,%eax
  800843:	05 00 00 00 80       	add    $0x80000000,%eax
  800848:	39 c2                	cmp    %eax,%edx
  80084a:	74 17                	je     800863 <_main+0x82b>
  80084c:	83 ec 04             	sub    $0x4,%esp
  80084f:	68 a0 2a 80 00       	push   $0x802aa0
  800854:	68 9f 00 00 00       	push   $0x9f
  800859:	68 7c 29 80 00       	push   $0x80297c
  80085e:	e8 b6 06 00 00       	call   800f19 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800863:	e8 b8 19 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800868:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80086b:	83 f8 40             	cmp    $0x40,%eax
  80086e:	74 17                	je     800887 <_main+0x84f>
  800870:	83 ec 04             	sub    $0x4,%esp
  800873:	68 82 2a 80 00       	push   $0x802a82
  800878:	68 a1 00 00 00       	push   $0xa1
  80087d:	68 7c 29 80 00       	push   $0x80297c
  800882:	e8 92 06 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800887:	e8 f4 18 00 00       	call   802180 <sys_calculate_free_frames>
  80088c:	89 c2                	mov    %eax,%edx
  80088e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800891:	39 c2                	cmp    %eax,%edx
  800893:	74 17                	je     8008ac <_main+0x874>
  800895:	83 ec 04             	sub    $0x4,%esp
  800898:	68 d0 2a 80 00       	push   $0x802ad0
  80089d:	68 a2 00 00 00       	push   $0xa2
  8008a2:	68 7c 29 80 00       	push   $0x80297c
  8008a7:	e8 6d 06 00 00       	call   800f19 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8008ac:	e8 cf 18 00 00       	call   802180 <sys_calculate_free_frames>
  8008b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008b4:	e8 67 19 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8008b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  8008bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008bf:	01 c0                	add    %eax,%eax
  8008c1:	83 ec 0c             	sub    $0xc,%esp
  8008c4:	50                   	push   %eax
  8008c5:	e8 a7 16 00 00       	call   801f71 <malloc>
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8008d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8008d3:	89 c2                	mov    %eax,%edx
  8008d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008d8:	c1 e0 03             	shl    $0x3,%eax
  8008db:	05 00 00 00 80       	add    $0x80000000,%eax
  8008e0:	39 c2                	cmp    %eax,%edx
  8008e2:	74 17                	je     8008fb <_main+0x8c3>
  8008e4:	83 ec 04             	sub    $0x4,%esp
  8008e7:	68 a0 2a 80 00       	push   $0x802aa0
  8008ec:	68 a8 00 00 00       	push   $0xa8
  8008f1:	68 7c 29 80 00       	push   $0x80297c
  8008f6:	e8 1e 06 00 00       	call   800f19 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8008fb:	e8 20 19 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800900:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800903:	3d 00 02 00 00       	cmp    $0x200,%eax
  800908:	74 17                	je     800921 <_main+0x8e9>
  80090a:	83 ec 04             	sub    $0x4,%esp
  80090d:	68 82 2a 80 00       	push   $0x802a82
  800912:	68 aa 00 00 00       	push   $0xaa
  800917:	68 7c 29 80 00       	push   $0x80297c
  80091c:	e8 f8 05 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800921:	e8 5a 18 00 00       	call   802180 <sys_calculate_free_frames>
  800926:	89 c2                	mov    %eax,%edx
  800928:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092b:	39 c2                	cmp    %eax,%edx
  80092d:	74 17                	je     800946 <_main+0x90e>
  80092f:	83 ec 04             	sub    $0x4,%esp
  800932:	68 d0 2a 80 00       	push   $0x802ad0
  800937:	68 ab 00 00 00       	push   $0xab
  80093c:	68 7c 29 80 00       	push   $0x80297c
  800941:	e8 d3 05 00 00       	call   800f19 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800946:	e8 35 18 00 00       	call   802180 <sys_calculate_free_frames>
  80094b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80094e:	e8 cd 18 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800953:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  800956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800959:	c1 e0 02             	shl    $0x2,%eax
  80095c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80095f:	83 ec 0c             	sub    $0xc,%esp
  800962:	50                   	push   %eax
  800963:	e8 09 16 00 00       	call   801f71 <malloc>
  800968:	83 c4 10             	add    $0x10,%esp
  80096b:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  80096e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800971:	89 c1                	mov    %eax,%ecx
  800973:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800976:	89 d0                	mov    %edx,%eax
  800978:	01 c0                	add    %eax,%eax
  80097a:	01 d0                	add    %edx,%eax
  80097c:	01 c0                	add    %eax,%eax
  80097e:	01 d0                	add    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	05 00 00 00 80       	add    $0x80000000,%eax
  800987:	39 c1                	cmp    %eax,%ecx
  800989:	74 17                	je     8009a2 <_main+0x96a>
  80098b:	83 ec 04             	sub    $0x4,%esp
  80098e:	68 a0 2a 80 00       	push   $0x802aa0
  800993:	68 b1 00 00 00       	push   $0xb1
  800998:	68 7c 29 80 00       	push   $0x80297c
  80099d:	e8 77 05 00 00       	call   800f19 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  8009a2:	e8 79 18 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8009a7:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8009aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8009af:	74 17                	je     8009c8 <_main+0x990>
  8009b1:	83 ec 04             	sub    $0x4,%esp
  8009b4:	68 82 2a 80 00       	push   $0x802a82
  8009b9:	68 b3 00 00 00       	push   $0xb3
  8009be:	68 7c 29 80 00       	push   $0x80297c
  8009c3:	e8 51 05 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: ");
  8009c8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8009cb:	e8 b0 17 00 00       	call   802180 <sys_calculate_free_frames>
  8009d0:	29 c3                	sub    %eax,%ebx
  8009d2:	89 d8                	mov    %ebx,%eax
  8009d4:	83 f8 02             	cmp    $0x2,%eax
  8009d7:	74 17                	je     8009f0 <_main+0x9b8>
  8009d9:	83 ec 04             	sub    $0x4,%esp
  8009dc:	68 d0 2a 80 00       	push   $0x802ad0
  8009e1:	68 b4 00 00 00       	push   $0xb4
  8009e6:	68 7c 29 80 00       	push   $0x80297c
  8009eb:	e8 29 05 00 00       	call   800f19 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009f0:	e8 8b 17 00 00       	call   802180 <sys_calculate_free_frames>
  8009f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009f8:	e8 23 18 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  8009fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  800a00:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800a03:	83 ec 0c             	sub    $0xc,%esp
  800a06:	50                   	push   %eax
  800a07:	e8 a6 15 00 00       	call   801fb2 <free>
  800a0c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800a0f:	e8 0c 18 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800a14:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800a17:	29 c2                	sub    %eax,%edx
  800a19:	89 d0                	mov    %edx,%eax
  800a1b:	3d 00 01 00 00       	cmp    $0x100,%eax
  800a20:	74 17                	je     800a39 <_main+0xa01>
  800a22:	83 ec 04             	sub    $0x4,%esp
  800a25:	68 e7 2a 80 00       	push   $0x802ae7
  800a2a:	68 be 00 00 00       	push   $0xbe
  800a2f:	68 7c 29 80 00       	push   $0x80297c
  800a34:	e8 e0 04 00 00       	call   800f19 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a39:	e8 42 17 00 00       	call   802180 <sys_calculate_free_frames>
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a43:	39 c2                	cmp    %eax,%edx
  800a45:	74 17                	je     800a5e <_main+0xa26>
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	68 fe 2a 80 00       	push   $0x802afe
  800a4f:	68 bf 00 00 00       	push   $0xbf
  800a54:	68 7c 29 80 00       	push   $0x80297c
  800a59:	e8 bb 04 00 00       	call   800f19 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a5e:	e8 1d 17 00 00       	call   802180 <sys_calculate_free_frames>
  800a63:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a66:	e8 b5 17 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800a6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  800a6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a71:	83 ec 0c             	sub    $0xc,%esp
  800a74:	50                   	push   %eax
  800a75:	e8 38 15 00 00       	call   801fb2 <free>
  800a7a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800a7d:	e8 9e 17 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800a82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800a85:	29 c2                	sub    %eax,%edx
  800a87:	89 d0                	mov    %edx,%eax
  800a89:	3d 00 01 00 00       	cmp    $0x100,%eax
  800a8e:	74 17                	je     800aa7 <_main+0xa6f>
  800a90:	83 ec 04             	sub    $0x4,%esp
  800a93:	68 e7 2a 80 00       	push   $0x802ae7
  800a98:	68 c6 00 00 00       	push   $0xc6
  800a9d:	68 7c 29 80 00       	push   $0x80297c
  800aa2:	e8 72 04 00 00       	call   800f19 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800aa7:	e8 d4 16 00 00       	call   802180 <sys_calculate_free_frames>
  800aac:	89 c2                	mov    %eax,%edx
  800aae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab1:	39 c2                	cmp    %eax,%edx
  800ab3:	74 17                	je     800acc <_main+0xa94>
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	68 fe 2a 80 00       	push   $0x802afe
  800abd:	68 c7 00 00 00       	push   $0xc7
  800ac2:	68 7c 29 80 00       	push   $0x80297c
  800ac7:	e8 4d 04 00 00       	call   800f19 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800acc:	e8 af 16 00 00       	call   802180 <sys_calculate_free_frames>
  800ad1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ad4:	e8 47 17 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800ad9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800adc:	8b 45 98             	mov    -0x68(%ebp),%eax
  800adf:	83 ec 0c             	sub    $0xc,%esp
  800ae2:	50                   	push   %eax
  800ae3:	e8 ca 14 00 00       	call   801fb2 <free>
  800ae8:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800aeb:	e8 30 17 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800af0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	3d 00 01 00 00       	cmp    $0x100,%eax
  800afc:	74 17                	je     800b15 <_main+0xadd>
  800afe:	83 ec 04             	sub    $0x4,%esp
  800b01:	68 e7 2a 80 00       	push   $0x802ae7
  800b06:	68 ce 00 00 00       	push   $0xce
  800b0b:	68 7c 29 80 00       	push   $0x80297c
  800b10:	e8 04 04 00 00       	call   800f19 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800b15:	e8 66 16 00 00       	call   802180 <sys_calculate_free_frames>
  800b1a:	89 c2                	mov    %eax,%edx
  800b1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b1f:	39 c2                	cmp    %eax,%edx
  800b21:	74 17                	je     800b3a <_main+0xb02>
  800b23:	83 ec 04             	sub    $0x4,%esp
  800b26:	68 fe 2a 80 00       	push   $0x802afe
  800b2b:	68 cf 00 00 00       	push   $0xcf
  800b30:	68 7c 29 80 00       	push   $0x80297c
  800b35:	e8 df 03 00 00       	call   800f19 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800b3a:	e8 41 16 00 00       	call   802180 <sys_calculate_free_frames>
  800b3f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b42:	e8 d9 16 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800b47:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[13] = malloc(1*Mega + 256*kilo - kilo);
  800b4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b4d:	c1 e0 08             	shl    $0x8,%eax
  800b50:	89 c2                	mov    %eax,%edx
  800b52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b55:	01 d0                	add    %edx,%eax
  800b57:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800b5a:	83 ec 0c             	sub    $0xc,%esp
  800b5d:	50                   	push   %eax
  800b5e:	e8 0e 14 00 00       	call   801f71 <malloc>
  800b63:	83 c4 10             	add    $0x10,%esp
  800b66:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800b69:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b6c:	89 c1                	mov    %eax,%ecx
  800b6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b71:	89 d0                	mov    %edx,%eax
  800b73:	01 c0                	add    %eax,%eax
  800b75:	01 d0                	add    %edx,%eax
  800b77:	c1 e0 08             	shl    $0x8,%eax
  800b7a:	89 c2                	mov    %eax,%edx
  800b7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	05 00 00 00 80       	add    $0x80000000,%eax
  800b86:	39 c1                	cmp    %eax,%ecx
  800b88:	74 17                	je     800ba1 <_main+0xb69>
  800b8a:	83 ec 04             	sub    $0x4,%esp
  800b8d:	68 a0 2a 80 00       	push   $0x802aa0
  800b92:	68 d9 00 00 00       	push   $0xd9
  800b97:	68 7c 29 80 00       	push   $0x80297c
  800b9c:	e8 78 03 00 00       	call   800f19 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256+64) panic("Wrong page file allocation: ");
  800ba1:	e8 7a 16 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800ba6:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800ba9:	3d 40 01 00 00       	cmp    $0x140,%eax
  800bae:	74 17                	je     800bc7 <_main+0xb8f>
  800bb0:	83 ec 04             	sub    $0x4,%esp
  800bb3:	68 82 2a 80 00       	push   $0x802a82
  800bb8:	68 db 00 00 00       	push   $0xdb
  800bbd:	68 7c 29 80 00       	push   $0x80297c
  800bc2:	e8 52 03 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800bc7:	e8 b4 15 00 00       	call   802180 <sys_calculate_free_frames>
  800bcc:	89 c2                	mov    %eax,%edx
  800bce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bd1:	39 c2                	cmp    %eax,%edx
  800bd3:	74 17                	je     800bec <_main+0xbb4>
  800bd5:	83 ec 04             	sub    $0x4,%esp
  800bd8:	68 d0 2a 80 00       	push   $0x802ad0
  800bdd:	68 dc 00 00 00       	push   $0xdc
  800be2:	68 7c 29 80 00       	push   $0x80297c
  800be7:	e8 2d 03 00 00       	call   800f19 <_panic>

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800bec:	e8 8f 15 00 00       	call   802180 <sys_calculate_free_frames>
  800bf1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800bf4:	e8 27 16 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800bf9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800bfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800bff:	c1 e0 02             	shl    $0x2,%eax
  800c02:	83 ec 04             	sub    $0x4,%esp
  800c05:	6a 00                	push   $0x0
  800c07:	50                   	push   %eax
  800c08:	68 0b 2b 80 00       	push   $0x802b0b
  800c0d:	e8 ba 13 00 00       	call   801fcc <smalloc>
  800c12:	83 c4 10             	add    $0x10,%esp
  800c15:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (ptr_allocations[14] != (uint32*)(USER_HEAP_START + 18*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800c18:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800c1b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c1e:	89 d0                	mov    %edx,%eax
  800c20:	c1 e0 03             	shl    $0x3,%eax
  800c23:	01 d0                	add    %edx,%eax
  800c25:	01 c0                	add    %eax,%eax
  800c27:	05 00 00 00 80       	add    $0x80000000,%eax
  800c2c:	39 c1                	cmp    %eax,%ecx
  800c2e:	74 17                	je     800c47 <_main+0xc0f>
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	68 98 29 80 00       	push   $0x802998
  800c38:	68 e2 00 00 00       	push   $0xe2
  800c3d:	68 7c 29 80 00       	push   $0x80297c
  800c42:	e8 d2 02 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1024+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800c47:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800c4a:	e8 31 15 00 00       	call   802180 <sys_calculate_free_frames>
  800c4f:	29 c3                	sub    %eax,%ebx
  800c51:	89 d8                	mov    %ebx,%eax
  800c53:	3d 04 04 00 00       	cmp    $0x404,%eax
  800c58:	74 17                	je     800c71 <_main+0xc39>
  800c5a:	83 ec 04             	sub    $0x4,%esp
  800c5d:	68 04 2a 80 00       	push   $0x802a04
  800c62:	68 e3 00 00 00       	push   $0xe3
  800c67:	68 7c 29 80 00       	push   $0x80297c
  800c6c:	e8 a8 02 00 00       	call   800f19 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c71:	e8 aa 15 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800c76:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800c79:	74 17                	je     800c92 <_main+0xc5a>
  800c7b:	83 ec 04             	sub    $0x4,%esp
  800c7e:	68 82 2a 80 00       	push   $0x802a82
  800c83:	68 e4 00 00 00       	push   $0xe4
  800c88:	68 7c 29 80 00       	push   $0x80297c
  800c8d:	e8 87 02 00 00       	call   800f19 <_panic>

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800c92:	e8 e9 14 00 00       	call   802180 <sys_calculate_free_frames>
  800c97:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c9a:	e8 81 15 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800c9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800ca2:	83 ec 08             	sub    $0x8,%esp
  800ca5:	68 e5 2a 80 00       	push   $0x802ae5
  800caa:	ff 75 ec             	pushl  -0x14(%ebp)
  800cad:	e8 3a 13 00 00       	call   801fec <sget>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (ptr_allocations[15] != (uint32*)(USER_HEAP_START + 3*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800cb8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800cbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800cbe:	89 c1                	mov    %eax,%ecx
  800cc0:	01 c9                	add    %ecx,%ecx
  800cc2:	01 c8                	add    %ecx,%eax
  800cc4:	05 00 00 00 80       	add    $0x80000000,%eax
  800cc9:	39 c2                	cmp    %eax,%edx
  800ccb:	74 17                	je     800ce4 <_main+0xcac>
  800ccd:	83 ec 04             	sub    $0x4,%esp
  800cd0:	68 98 29 80 00       	push   $0x802998
  800cd5:	68 ea 00 00 00       	push   $0xea
  800cda:	68 7c 29 80 00       	push   $0x80297c
  800cdf:	e8 35 02 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800ce4:	e8 97 14 00 00       	call   802180 <sys_calculate_free_frames>
  800ce9:	89 c2                	mov    %eax,%edx
  800ceb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cee:	39 c2                	cmp    %eax,%edx
  800cf0:	74 17                	je     800d09 <_main+0xcd1>
  800cf2:	83 ec 04             	sub    $0x4,%esp
  800cf5:	68 04 2a 80 00       	push   $0x802a04
  800cfa:	68 eb 00 00 00       	push   $0xeb
  800cff:	68 7c 29 80 00       	push   $0x80297c
  800d04:	e8 10 02 00 00       	call   800f19 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800d09:	e8 12 15 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800d0e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d11:	74 17                	je     800d2a <_main+0xcf2>
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	68 82 2a 80 00       	push   $0x802a82
  800d1b:	68 ec 00 00 00       	push   $0xec
  800d20:	68 7c 29 80 00       	push   $0x80297c
  800d25:	e8 ef 01 00 00       	call   800f19 <_panic>

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800d2a:	e8 51 14 00 00       	call   802180 <sys_calculate_free_frames>
  800d2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800d32:	e8 e9 14 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800d37:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800d3a:	83 ec 08             	sub    $0x8,%esp
  800d3d:	68 93 29 80 00       	push   $0x802993
  800d42:	ff 75 ec             	pushl  -0x14(%ebp)
  800d45:	e8 a2 12 00 00       	call   801fec <sget>
  800d4a:	83 c4 10             	add    $0x10,%esp
  800d4d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (ptr_allocations[16] != (uint32*)(USER_HEAP_START + 10*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800d50:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800d53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d56:	89 d0                	mov    %edx,%eax
  800d58:	c1 e0 02             	shl    $0x2,%eax
  800d5b:	01 d0                	add    %edx,%eax
  800d5d:	01 c0                	add    %eax,%eax
  800d5f:	05 00 00 00 80       	add    $0x80000000,%eax
  800d64:	39 c1                	cmp    %eax,%ecx
  800d66:	74 17                	je     800d7f <_main+0xd47>
  800d68:	83 ec 04             	sub    $0x4,%esp
  800d6b:	68 98 29 80 00       	push   $0x802998
  800d70:	68 f2 00 00 00       	push   $0xf2
  800d75:	68 7c 29 80 00       	push   $0x80297c
  800d7a:	e8 9a 01 00 00       	call   800f19 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800d7f:	e8 fc 13 00 00       	call   802180 <sys_calculate_free_frames>
  800d84:	89 c2                	mov    %eax,%edx
  800d86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d89:	39 c2                	cmp    %eax,%edx
  800d8b:	74 17                	je     800da4 <_main+0xd6c>
  800d8d:	83 ec 04             	sub    $0x4,%esp
  800d90:	68 04 2a 80 00       	push   $0x802a04
  800d95:	68 f3 00 00 00       	push   $0xf3
  800d9a:	68 7c 29 80 00       	push   $0x80297c
  800d9f:	e8 75 01 00 00       	call   800f19 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800da4:	e8 77 14 00 00       	call   802220 <sys_pf_calculate_allocated_pages>
  800da9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dac:	74 17                	je     800dc5 <_main+0xd8d>
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	68 82 2a 80 00       	push   $0x802a82
  800db6:	68 f4 00 00 00       	push   $0xf4
  800dbb:	68 7c 29 80 00       	push   $0x80297c
  800dc0:	e8 54 01 00 00       	call   800f19 <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT allocation (3) completed successfully.\n");
  800dc5:	83 ec 0c             	sub    $0xc,%esp
  800dc8:	68 10 2b 80 00       	push   $0x802b10
  800dcd:	e8 fb 03 00 00       	call   8011cd <cprintf>
  800dd2:	83 c4 10             	add    $0x10,%esp

	return;
  800dd5:	90                   	nop
}
  800dd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dd9:	5b                   	pop    %ebx
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800de3:	e8 78 16 00 00       	call   802460 <sys_getenvindex>
  800de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800deb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dee:	89 d0                	mov    %edx,%eax
  800df0:	c1 e0 03             	shl    $0x3,%eax
  800df3:	01 d0                	add    %edx,%eax
  800df5:	01 c0                	add    %eax,%eax
  800df7:	01 d0                	add    %edx,%eax
  800df9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e00:	01 d0                	add    %edx,%eax
  800e02:	c1 e0 04             	shl    $0x4,%eax
  800e05:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e0a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e0f:	a1 20 40 80 00       	mov    0x804020,%eax
  800e14:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800e1a:	84 c0                	test   %al,%al
  800e1c:	74 0f                	je     800e2d <libmain+0x50>
		binaryname = myEnv->prog_name;
  800e1e:	a1 20 40 80 00       	mov    0x804020,%eax
  800e23:	05 5c 05 00 00       	add    $0x55c,%eax
  800e28:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e31:	7e 0a                	jle    800e3d <libmain+0x60>
		binaryname = argv[0];
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	8b 00                	mov    (%eax),%eax
  800e38:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 0c             	pushl  0xc(%ebp)
  800e43:	ff 75 08             	pushl  0x8(%ebp)
  800e46:	e8 ed f1 ff ff       	call   800038 <_main>
  800e4b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800e4e:	e8 1a 14 00 00       	call   80226d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	68 74 2b 80 00       	push   $0x802b74
  800e5b:	e8 6d 03 00 00       	call   8011cd <cprintf>
  800e60:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800e63:	a1 20 40 80 00       	mov    0x804020,%eax
  800e68:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800e6e:	a1 20 40 80 00       	mov    0x804020,%eax
  800e73:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800e79:	83 ec 04             	sub    $0x4,%esp
  800e7c:	52                   	push   %edx
  800e7d:	50                   	push   %eax
  800e7e:	68 9c 2b 80 00       	push   $0x802b9c
  800e83:	e8 45 03 00 00       	call   8011cd <cprintf>
  800e88:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800e8b:	a1 20 40 80 00       	mov    0x804020,%eax
  800e90:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800e96:	a1 20 40 80 00       	mov    0x804020,%eax
  800e9b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800ea1:	a1 20 40 80 00       	mov    0x804020,%eax
  800ea6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800eac:	51                   	push   %ecx
  800ead:	52                   	push   %edx
  800eae:	50                   	push   %eax
  800eaf:	68 c4 2b 80 00       	push   $0x802bc4
  800eb4:	e8 14 03 00 00       	call   8011cd <cprintf>
  800eb9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ebc:	a1 20 40 80 00       	mov    0x804020,%eax
  800ec1:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	50                   	push   %eax
  800ecb:	68 1c 2c 80 00       	push   $0x802c1c
  800ed0:	e8 f8 02 00 00       	call   8011cd <cprintf>
  800ed5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	68 74 2b 80 00       	push   $0x802b74
  800ee0:	e8 e8 02 00 00       	call   8011cd <cprintf>
  800ee5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800ee8:	e8 9a 13 00 00       	call   802287 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800eed:	e8 19 00 00 00       	call   800f0b <exit>
}
  800ef2:	90                   	nop
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800efb:	83 ec 0c             	sub    $0xc,%esp
  800efe:	6a 00                	push   $0x0
  800f00:	e8 27 15 00 00       	call   80242c <sys_destroy_env>
  800f05:	83 c4 10             	add    $0x10,%esp
}
  800f08:	90                   	nop
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <exit>:

void
exit(void)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f11:	e8 7c 15 00 00       	call   802492 <sys_exit_env>
}
  800f16:	90                   	nop
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f1f:	8d 45 10             	lea    0x10(%ebp),%eax
  800f22:	83 c0 04             	add    $0x4,%eax
  800f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f28:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	74 16                	je     800f47 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f31:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	50                   	push   %eax
  800f3a:	68 30 2c 80 00       	push   $0x802c30
  800f3f:	e8 89 02 00 00       	call   8011cd <cprintf>
  800f44:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800f47:	a1 00 40 80 00       	mov    0x804000,%eax
  800f4c:	ff 75 0c             	pushl  0xc(%ebp)
  800f4f:	ff 75 08             	pushl  0x8(%ebp)
  800f52:	50                   	push   %eax
  800f53:	68 35 2c 80 00       	push   $0x802c35
  800f58:	e8 70 02 00 00       	call   8011cd <cprintf>
  800f5d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 f4             	pushl  -0xc(%ebp)
  800f69:	50                   	push   %eax
  800f6a:	e8 f3 01 00 00       	call   801162 <vcprintf>
  800f6f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800f72:	83 ec 08             	sub    $0x8,%esp
  800f75:	6a 00                	push   $0x0
  800f77:	68 51 2c 80 00       	push   $0x802c51
  800f7c:	e8 e1 01 00 00       	call   801162 <vcprintf>
  800f81:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800f84:	e8 82 ff ff ff       	call   800f0b <exit>

	// should not return here
	while (1) ;
  800f89:	eb fe                	jmp    800f89 <_panic+0x70>

00800f8b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800f91:	a1 20 40 80 00       	mov    0x804020,%eax
  800f96:	8b 50 74             	mov    0x74(%eax),%edx
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	39 c2                	cmp    %eax,%edx
  800f9e:	74 14                	je     800fb4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800fa0:	83 ec 04             	sub    $0x4,%esp
  800fa3:	68 54 2c 80 00       	push   $0x802c54
  800fa8:	6a 26                	push   $0x26
  800faa:	68 a0 2c 80 00       	push   $0x802ca0
  800faf:	e8 65 ff ff ff       	call   800f19 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800fb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800fbb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fc2:	e9 c2 00 00 00       	jmp    801089 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	01 d0                	add    %edx,%eax
  800fd6:	8b 00                	mov    (%eax),%eax
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	75 08                	jne    800fe4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800fdc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800fdf:	e9 a2 00 00 00       	jmp    801086 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800fe4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800feb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800ff2:	eb 69                	jmp    80105d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800ff4:	a1 20 40 80 00       	mov    0x804020,%eax
  800ff9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801002:	89 d0                	mov    %edx,%eax
  801004:	01 c0                	add    %eax,%eax
  801006:	01 d0                	add    %edx,%eax
  801008:	c1 e0 03             	shl    $0x3,%eax
  80100b:	01 c8                	add    %ecx,%eax
  80100d:	8a 40 04             	mov    0x4(%eax),%al
  801010:	84 c0                	test   %al,%al
  801012:	75 46                	jne    80105a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801014:	a1 20 40 80 00       	mov    0x804020,%eax
  801019:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80101f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801022:	89 d0                	mov    %edx,%eax
  801024:	01 c0                	add    %eax,%eax
  801026:	01 d0                	add    %edx,%eax
  801028:	c1 e0 03             	shl    $0x3,%eax
  80102b:	01 c8                	add    %ecx,%eax
  80102d:	8b 00                	mov    (%eax),%eax
  80102f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801032:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801035:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80103a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80103c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	01 c8                	add    %ecx,%eax
  80104b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80104d:	39 c2                	cmp    %eax,%edx
  80104f:	75 09                	jne    80105a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801051:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801058:	eb 12                	jmp    80106c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80105a:	ff 45 e8             	incl   -0x18(%ebp)
  80105d:	a1 20 40 80 00       	mov    0x804020,%eax
  801062:	8b 50 74             	mov    0x74(%eax),%edx
  801065:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801068:	39 c2                	cmp    %eax,%edx
  80106a:	77 88                	ja     800ff4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80106c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801070:	75 14                	jne    801086 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801072:	83 ec 04             	sub    $0x4,%esp
  801075:	68 ac 2c 80 00       	push   $0x802cac
  80107a:	6a 3a                	push   $0x3a
  80107c:	68 a0 2c 80 00       	push   $0x802ca0
  801081:	e8 93 fe ff ff       	call   800f19 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801086:	ff 45 f0             	incl   -0x10(%ebp)
  801089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80108f:	0f 8c 32 ff ff ff    	jl     800fc7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801095:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80109c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8010a3:	eb 26                	jmp    8010cb <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8010a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8010aa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8010b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8010b3:	89 d0                	mov    %edx,%eax
  8010b5:	01 c0                	add    %eax,%eax
  8010b7:	01 d0                	add    %edx,%eax
  8010b9:	c1 e0 03             	shl    $0x3,%eax
  8010bc:	01 c8                	add    %ecx,%eax
  8010be:	8a 40 04             	mov    0x4(%eax),%al
  8010c1:	3c 01                	cmp    $0x1,%al
  8010c3:	75 03                	jne    8010c8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8010c5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010c8:	ff 45 e0             	incl   -0x20(%ebp)
  8010cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8010d0:	8b 50 74             	mov    0x74(%eax),%edx
  8010d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010d6:	39 c2                	cmp    %eax,%edx
  8010d8:	77 cb                	ja     8010a5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8010da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010dd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8010e0:	74 14                	je     8010f6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8010e2:	83 ec 04             	sub    $0x4,%esp
  8010e5:	68 00 2d 80 00       	push   $0x802d00
  8010ea:	6a 44                	push   $0x44
  8010ec:	68 a0 2c 80 00       	push   $0x802ca0
  8010f1:	e8 23 fe ff ff       	call   800f19 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8010f6:	90                   	nop
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8010ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801102:	8b 00                	mov    (%eax),%eax
  801104:	8d 48 01             	lea    0x1(%eax),%ecx
  801107:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110a:	89 0a                	mov    %ecx,(%edx)
  80110c:	8b 55 08             	mov    0x8(%ebp),%edx
  80110f:	88 d1                	mov    %dl,%cl
  801111:	8b 55 0c             	mov    0xc(%ebp),%edx
  801114:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	8b 00                	mov    (%eax),%eax
  80111d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801122:	75 2c                	jne    801150 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801124:	a0 24 40 80 00       	mov    0x804024,%al
  801129:	0f b6 c0             	movzbl %al,%eax
  80112c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112f:	8b 12                	mov    (%edx),%edx
  801131:	89 d1                	mov    %edx,%ecx
  801133:	8b 55 0c             	mov    0xc(%ebp),%edx
  801136:	83 c2 08             	add    $0x8,%edx
  801139:	83 ec 04             	sub    $0x4,%esp
  80113c:	50                   	push   %eax
  80113d:	51                   	push   %ecx
  80113e:	52                   	push   %edx
  80113f:	e8 7b 0f 00 00       	call   8020bf <sys_cputs>
  801144:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	8b 40 04             	mov    0x4(%eax),%eax
  801156:	8d 50 01             	lea    0x1(%eax),%edx
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80115f:	90                   	nop
  801160:	c9                   	leave  
  801161:	c3                   	ret    

00801162 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80116b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801172:	00 00 00 
	b.cnt = 0;
  801175:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80117c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80117f:	ff 75 0c             	pushl  0xc(%ebp)
  801182:	ff 75 08             	pushl  0x8(%ebp)
  801185:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80118b:	50                   	push   %eax
  80118c:	68 f9 10 80 00       	push   $0x8010f9
  801191:	e8 11 02 00 00       	call   8013a7 <vprintfmt>
  801196:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801199:	a0 24 40 80 00       	mov    0x804024,%al
  80119e:	0f b6 c0             	movzbl %al,%eax
  8011a1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8011a7:	83 ec 04             	sub    $0x4,%esp
  8011aa:	50                   	push   %eax
  8011ab:	52                   	push   %edx
  8011ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011b2:	83 c0 08             	add    $0x8,%eax
  8011b5:	50                   	push   %eax
  8011b6:	e8 04 0f 00 00       	call   8020bf <sys_cputs>
  8011bb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8011be:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8011c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8011cb:	c9                   	leave  
  8011cc:	c3                   	ret    

008011cd <cprintf>:

int cprintf(const char *fmt, ...) {
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8011d3:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8011da:	8d 45 0c             	lea    0xc(%ebp),%eax
  8011dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	83 ec 08             	sub    $0x8,%esp
  8011e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e9:	50                   	push   %eax
  8011ea:	e8 73 ff ff ff       	call   801162 <vcprintf>
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8011f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801200:	e8 68 10 00 00       	call   80226d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801205:	8d 45 0c             	lea    0xc(%ebp),%eax
  801208:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	ff 75 f4             	pushl  -0xc(%ebp)
  801214:	50                   	push   %eax
  801215:	e8 48 ff ff ff       	call   801162 <vcprintf>
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801220:	e8 62 10 00 00       	call   802287 <sys_enable_interrupt>
	return cnt;
  801225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	53                   	push   %ebx
  80122e:	83 ec 14             	sub    $0x14,%esp
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801237:	8b 45 14             	mov    0x14(%ebp),%eax
  80123a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80123d:	8b 45 18             	mov    0x18(%ebp),%eax
  801240:	ba 00 00 00 00       	mov    $0x0,%edx
  801245:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801248:	77 55                	ja     80129f <printnum+0x75>
  80124a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80124d:	72 05                	jb     801254 <printnum+0x2a>
  80124f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801252:	77 4b                	ja     80129f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801254:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801257:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80125a:	8b 45 18             	mov    0x18(%ebp),%eax
  80125d:	ba 00 00 00 00       	mov    $0x0,%edx
  801262:	52                   	push   %edx
  801263:	50                   	push   %eax
  801264:	ff 75 f4             	pushl  -0xc(%ebp)
  801267:	ff 75 f0             	pushl  -0x10(%ebp)
  80126a:	e8 85 14 00 00       	call   8026f4 <__udivdi3>
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	83 ec 04             	sub    $0x4,%esp
  801275:	ff 75 20             	pushl  0x20(%ebp)
  801278:	53                   	push   %ebx
  801279:	ff 75 18             	pushl  0x18(%ebp)
  80127c:	52                   	push   %edx
  80127d:	50                   	push   %eax
  80127e:	ff 75 0c             	pushl  0xc(%ebp)
  801281:	ff 75 08             	pushl  0x8(%ebp)
  801284:	e8 a1 ff ff ff       	call   80122a <printnum>
  801289:	83 c4 20             	add    $0x20,%esp
  80128c:	eb 1a                	jmp    8012a8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80128e:	83 ec 08             	sub    $0x8,%esp
  801291:	ff 75 0c             	pushl  0xc(%ebp)
  801294:	ff 75 20             	pushl  0x20(%ebp)
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	ff d0                	call   *%eax
  80129c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80129f:	ff 4d 1c             	decl   0x1c(%ebp)
  8012a2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8012a6:	7f e6                	jg     80128e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012a8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8012ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b6:	53                   	push   %ebx
  8012b7:	51                   	push   %ecx
  8012b8:	52                   	push   %edx
  8012b9:	50                   	push   %eax
  8012ba:	e8 45 15 00 00       	call   802804 <__umoddi3>
  8012bf:	83 c4 10             	add    $0x10,%esp
  8012c2:	05 74 2f 80 00       	add    $0x802f74,%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	0f be c0             	movsbl %al,%eax
  8012cc:	83 ec 08             	sub    $0x8,%esp
  8012cf:	ff 75 0c             	pushl  0xc(%ebp)
  8012d2:	50                   	push   %eax
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	ff d0                	call   *%eax
  8012d8:	83 c4 10             	add    $0x10,%esp
}
  8012db:	90                   	nop
  8012dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012df:	c9                   	leave  
  8012e0:	c3                   	ret    

008012e1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8012e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8012e8:	7e 1c                	jle    801306 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8b 00                	mov    (%eax),%eax
  8012ef:	8d 50 08             	lea    0x8(%eax),%edx
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	89 10                	mov    %edx,(%eax)
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8b 00                	mov    (%eax),%eax
  8012fc:	83 e8 08             	sub    $0x8,%eax
  8012ff:	8b 50 04             	mov    0x4(%eax),%edx
  801302:	8b 00                	mov    (%eax),%eax
  801304:	eb 40                	jmp    801346 <getuint+0x65>
	else if (lflag)
  801306:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130a:	74 1e                	je     80132a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	8b 00                	mov    (%eax),%eax
  801311:	8d 50 04             	lea    0x4(%eax),%edx
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	89 10                	mov    %edx,(%eax)
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8b 00                	mov    (%eax),%eax
  80131e:	83 e8 04             	sub    $0x4,%eax
  801321:	8b 00                	mov    (%eax),%eax
  801323:	ba 00 00 00 00       	mov    $0x0,%edx
  801328:	eb 1c                	jmp    801346 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8b 00                	mov    (%eax),%eax
  80132f:	8d 50 04             	lea    0x4(%eax),%edx
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	89 10                	mov    %edx,(%eax)
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8b 00                	mov    (%eax),%eax
  80133c:	83 e8 04             	sub    $0x4,%eax
  80133f:	8b 00                	mov    (%eax),%eax
  801341:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801346:	5d                   	pop    %ebp
  801347:	c3                   	ret    

00801348 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80134b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80134f:	7e 1c                	jle    80136d <getint+0x25>
		return va_arg(*ap, long long);
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	8b 00                	mov    (%eax),%eax
  801356:	8d 50 08             	lea    0x8(%eax),%edx
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	89 10                	mov    %edx,(%eax)
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8b 00                	mov    (%eax),%eax
  801363:	83 e8 08             	sub    $0x8,%eax
  801366:	8b 50 04             	mov    0x4(%eax),%edx
  801369:	8b 00                	mov    (%eax),%eax
  80136b:	eb 38                	jmp    8013a5 <getint+0x5d>
	else if (lflag)
  80136d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801371:	74 1a                	je     80138d <getint+0x45>
		return va_arg(*ap, long);
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8b 00                	mov    (%eax),%eax
  801378:	8d 50 04             	lea    0x4(%eax),%edx
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	89 10                	mov    %edx,(%eax)
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8b 00                	mov    (%eax),%eax
  801385:	83 e8 04             	sub    $0x4,%eax
  801388:	8b 00                	mov    (%eax),%eax
  80138a:	99                   	cltd   
  80138b:	eb 18                	jmp    8013a5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8b 00                	mov    (%eax),%eax
  801392:	8d 50 04             	lea    0x4(%eax),%edx
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	89 10                	mov    %edx,(%eax)
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8b 00                	mov    (%eax),%eax
  80139f:	83 e8 04             	sub    $0x4,%eax
  8013a2:	8b 00                	mov    (%eax),%eax
  8013a4:	99                   	cltd   
}
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	56                   	push   %esi
  8013ab:	53                   	push   %ebx
  8013ac:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013af:	eb 17                	jmp    8013c8 <vprintfmt+0x21>
			if (ch == '\0')
  8013b1:	85 db                	test   %ebx,%ebx
  8013b3:	0f 84 af 03 00 00    	je     801768 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8013b9:	83 ec 08             	sub    $0x8,%esp
  8013bc:	ff 75 0c             	pushl  0xc(%ebp)
  8013bf:	53                   	push   %ebx
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	ff d0                	call   *%eax
  8013c5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cb:	8d 50 01             	lea    0x1(%eax),%edx
  8013ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	0f b6 d8             	movzbl %al,%ebx
  8013d6:	83 fb 25             	cmp    $0x25,%ebx
  8013d9:	75 d6                	jne    8013b1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8013db:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8013df:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8013e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8013ed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8013f4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	8d 50 01             	lea    0x1(%eax),%edx
  801401:	89 55 10             	mov    %edx,0x10(%ebp)
  801404:	8a 00                	mov    (%eax),%al
  801406:	0f b6 d8             	movzbl %al,%ebx
  801409:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80140c:	83 f8 55             	cmp    $0x55,%eax
  80140f:	0f 87 2b 03 00 00    	ja     801740 <vprintfmt+0x399>
  801415:	8b 04 85 98 2f 80 00 	mov    0x802f98(,%eax,4),%eax
  80141c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80141e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801422:	eb d7                	jmp    8013fb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801424:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801428:	eb d1                	jmp    8013fb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80142a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801431:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801434:	89 d0                	mov    %edx,%eax
  801436:	c1 e0 02             	shl    $0x2,%eax
  801439:	01 d0                	add    %edx,%eax
  80143b:	01 c0                	add    %eax,%eax
  80143d:	01 d8                	add    %ebx,%eax
  80143f:	83 e8 30             	sub    $0x30,%eax
  801442:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801445:	8b 45 10             	mov    0x10(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80144d:	83 fb 2f             	cmp    $0x2f,%ebx
  801450:	7e 3e                	jle    801490 <vprintfmt+0xe9>
  801452:	83 fb 39             	cmp    $0x39,%ebx
  801455:	7f 39                	jg     801490 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801457:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80145a:	eb d5                	jmp    801431 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80145c:	8b 45 14             	mov    0x14(%ebp),%eax
  80145f:	83 c0 04             	add    $0x4,%eax
  801462:	89 45 14             	mov    %eax,0x14(%ebp)
  801465:	8b 45 14             	mov    0x14(%ebp),%eax
  801468:	83 e8 04             	sub    $0x4,%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801470:	eb 1f                	jmp    801491 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801472:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801476:	79 83                	jns    8013fb <vprintfmt+0x54>
				width = 0;
  801478:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80147f:	e9 77 ff ff ff       	jmp    8013fb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801484:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80148b:	e9 6b ff ff ff       	jmp    8013fb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801490:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801491:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801495:	0f 89 60 ff ff ff    	jns    8013fb <vprintfmt+0x54>
				width = precision, precision = -1;
  80149b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014a1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8014a8:	e9 4e ff ff ff       	jmp    8013fb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8014ad:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8014b0:	e9 46 ff ff ff       	jmp    8013fb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8014b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b8:	83 c0 04             	add    $0x4,%eax
  8014bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8014be:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c1:	83 e8 04             	sub    $0x4,%eax
  8014c4:	8b 00                	mov    (%eax),%eax
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	50                   	push   %eax
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	ff d0                	call   *%eax
  8014d2:	83 c4 10             	add    $0x10,%esp
			break;
  8014d5:	e9 89 02 00 00       	jmp    801763 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8014da:	8b 45 14             	mov    0x14(%ebp),%eax
  8014dd:	83 c0 04             	add    $0x4,%eax
  8014e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8014e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e6:	83 e8 04             	sub    $0x4,%eax
  8014e9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8014eb:	85 db                	test   %ebx,%ebx
  8014ed:	79 02                	jns    8014f1 <vprintfmt+0x14a>
				err = -err;
  8014ef:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8014f1:	83 fb 64             	cmp    $0x64,%ebx
  8014f4:	7f 0b                	jg     801501 <vprintfmt+0x15a>
  8014f6:	8b 34 9d e0 2d 80 00 	mov    0x802de0(,%ebx,4),%esi
  8014fd:	85 f6                	test   %esi,%esi
  8014ff:	75 19                	jne    80151a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801501:	53                   	push   %ebx
  801502:	68 85 2f 80 00       	push   $0x802f85
  801507:	ff 75 0c             	pushl  0xc(%ebp)
  80150a:	ff 75 08             	pushl  0x8(%ebp)
  80150d:	e8 5e 02 00 00       	call   801770 <printfmt>
  801512:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801515:	e9 49 02 00 00       	jmp    801763 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80151a:	56                   	push   %esi
  80151b:	68 8e 2f 80 00       	push   $0x802f8e
  801520:	ff 75 0c             	pushl  0xc(%ebp)
  801523:	ff 75 08             	pushl  0x8(%ebp)
  801526:	e8 45 02 00 00       	call   801770 <printfmt>
  80152b:	83 c4 10             	add    $0x10,%esp
			break;
  80152e:	e9 30 02 00 00       	jmp    801763 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801533:	8b 45 14             	mov    0x14(%ebp),%eax
  801536:	83 c0 04             	add    $0x4,%eax
  801539:	89 45 14             	mov    %eax,0x14(%ebp)
  80153c:	8b 45 14             	mov    0x14(%ebp),%eax
  80153f:	83 e8 04             	sub    $0x4,%eax
  801542:	8b 30                	mov    (%eax),%esi
  801544:	85 f6                	test   %esi,%esi
  801546:	75 05                	jne    80154d <vprintfmt+0x1a6>
				p = "(null)";
  801548:	be 91 2f 80 00       	mov    $0x802f91,%esi
			if (width > 0 && padc != '-')
  80154d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801551:	7e 6d                	jle    8015c0 <vprintfmt+0x219>
  801553:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801557:	74 67                	je     8015c0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801559:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	50                   	push   %eax
  801560:	56                   	push   %esi
  801561:	e8 0c 03 00 00       	call   801872 <strnlen>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80156c:	eb 16                	jmp    801584 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80156e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801572:	83 ec 08             	sub    $0x8,%esp
  801575:	ff 75 0c             	pushl  0xc(%ebp)
  801578:	50                   	push   %eax
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	ff d0                	call   *%eax
  80157e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801581:	ff 4d e4             	decl   -0x1c(%ebp)
  801584:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801588:	7f e4                	jg     80156e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80158a:	eb 34                	jmp    8015c0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80158c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801590:	74 1c                	je     8015ae <vprintfmt+0x207>
  801592:	83 fb 1f             	cmp    $0x1f,%ebx
  801595:	7e 05                	jle    80159c <vprintfmt+0x1f5>
  801597:	83 fb 7e             	cmp    $0x7e,%ebx
  80159a:	7e 12                	jle    8015ae <vprintfmt+0x207>
					putch('?', putdat);
  80159c:	83 ec 08             	sub    $0x8,%esp
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	6a 3f                	push   $0x3f
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	ff d0                	call   *%eax
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	eb 0f                	jmp    8015bd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8015ae:	83 ec 08             	sub    $0x8,%esp
  8015b1:	ff 75 0c             	pushl  0xc(%ebp)
  8015b4:	53                   	push   %ebx
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	ff d0                	call   *%eax
  8015ba:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015bd:	ff 4d e4             	decl   -0x1c(%ebp)
  8015c0:	89 f0                	mov    %esi,%eax
  8015c2:	8d 70 01             	lea    0x1(%eax),%esi
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	0f be d8             	movsbl %al,%ebx
  8015ca:	85 db                	test   %ebx,%ebx
  8015cc:	74 24                	je     8015f2 <vprintfmt+0x24b>
  8015ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015d2:	78 b8                	js     80158c <vprintfmt+0x1e5>
  8015d4:	ff 4d e0             	decl   -0x20(%ebp)
  8015d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015db:	79 af                	jns    80158c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8015dd:	eb 13                	jmp    8015f2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8015df:	83 ec 08             	sub    $0x8,%esp
  8015e2:	ff 75 0c             	pushl  0xc(%ebp)
  8015e5:	6a 20                	push   $0x20
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	ff d0                	call   *%eax
  8015ec:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8015ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8015f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015f6:	7f e7                	jg     8015df <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8015f8:	e9 66 01 00 00       	jmp    801763 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	ff 75 e8             	pushl  -0x18(%ebp)
  801603:	8d 45 14             	lea    0x14(%ebp),%eax
  801606:	50                   	push   %eax
  801607:	e8 3c fd ff ff       	call   801348 <getint>
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801612:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161b:	85 d2                	test   %edx,%edx
  80161d:	79 23                	jns    801642 <vprintfmt+0x29b>
				putch('-', putdat);
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	ff 75 0c             	pushl  0xc(%ebp)
  801625:	6a 2d                	push   $0x2d
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	ff d0                	call   *%eax
  80162c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80162f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801635:	f7 d8                	neg    %eax
  801637:	83 d2 00             	adc    $0x0,%edx
  80163a:	f7 da                	neg    %edx
  80163c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80163f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801642:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801649:	e9 bc 00 00 00       	jmp    80170a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80164e:	83 ec 08             	sub    $0x8,%esp
  801651:	ff 75 e8             	pushl  -0x18(%ebp)
  801654:	8d 45 14             	lea    0x14(%ebp),%eax
  801657:	50                   	push   %eax
  801658:	e8 84 fc ff ff       	call   8012e1 <getuint>
  80165d:	83 c4 10             	add    $0x10,%esp
  801660:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801663:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801666:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80166d:	e9 98 00 00 00       	jmp    80170a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801672:	83 ec 08             	sub    $0x8,%esp
  801675:	ff 75 0c             	pushl  0xc(%ebp)
  801678:	6a 58                	push   $0x58
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	ff d0                	call   *%eax
  80167f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801682:	83 ec 08             	sub    $0x8,%esp
  801685:	ff 75 0c             	pushl  0xc(%ebp)
  801688:	6a 58                	push   $0x58
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	ff d0                	call   *%eax
  80168f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801692:	83 ec 08             	sub    $0x8,%esp
  801695:	ff 75 0c             	pushl  0xc(%ebp)
  801698:	6a 58                	push   $0x58
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	ff d0                	call   *%eax
  80169f:	83 c4 10             	add    $0x10,%esp
			break;
  8016a2:	e9 bc 00 00 00       	jmp    801763 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8016a7:	83 ec 08             	sub    $0x8,%esp
  8016aa:	ff 75 0c             	pushl  0xc(%ebp)
  8016ad:	6a 30                	push   $0x30
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	ff d0                	call   *%eax
  8016b4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8016b7:	83 ec 08             	sub    $0x8,%esp
  8016ba:	ff 75 0c             	pushl  0xc(%ebp)
  8016bd:	6a 78                	push   $0x78
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	ff d0                	call   *%eax
  8016c4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8016c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ca:	83 c0 04             	add    $0x4,%eax
  8016cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8016d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d3:	83 e8 04             	sub    $0x4,%eax
  8016d6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8016d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8016e2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8016e9:	eb 1f                	jmp    80170a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8016eb:	83 ec 08             	sub    $0x8,%esp
  8016ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8016f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8016f4:	50                   	push   %eax
  8016f5:	e8 e7 fb ff ff       	call   8012e1 <getuint>
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801700:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801703:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80170a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80170e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801711:	83 ec 04             	sub    $0x4,%esp
  801714:	52                   	push   %edx
  801715:	ff 75 e4             	pushl  -0x1c(%ebp)
  801718:	50                   	push   %eax
  801719:	ff 75 f4             	pushl  -0xc(%ebp)
  80171c:	ff 75 f0             	pushl  -0x10(%ebp)
  80171f:	ff 75 0c             	pushl  0xc(%ebp)
  801722:	ff 75 08             	pushl  0x8(%ebp)
  801725:	e8 00 fb ff ff       	call   80122a <printnum>
  80172a:	83 c4 20             	add    $0x20,%esp
			break;
  80172d:	eb 34                	jmp    801763 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	53                   	push   %ebx
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	ff d0                	call   *%eax
  80173b:	83 c4 10             	add    $0x10,%esp
			break;
  80173e:	eb 23                	jmp    801763 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801740:	83 ec 08             	sub    $0x8,%esp
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	6a 25                	push   $0x25
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	ff d0                	call   *%eax
  80174d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801750:	ff 4d 10             	decl   0x10(%ebp)
  801753:	eb 03                	jmp    801758 <vprintfmt+0x3b1>
  801755:	ff 4d 10             	decl   0x10(%ebp)
  801758:	8b 45 10             	mov    0x10(%ebp),%eax
  80175b:	48                   	dec    %eax
  80175c:	8a 00                	mov    (%eax),%al
  80175e:	3c 25                	cmp    $0x25,%al
  801760:	75 f3                	jne    801755 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801762:	90                   	nop
		}
	}
  801763:	e9 47 fc ff ff       	jmp    8013af <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801768:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801769:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176c:	5b                   	pop    %ebx
  80176d:	5e                   	pop    %esi
  80176e:	5d                   	pop    %ebp
  80176f:	c3                   	ret    

00801770 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801776:	8d 45 10             	lea    0x10(%ebp),%eax
  801779:	83 c0 04             	add    $0x4,%eax
  80177c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80177f:	8b 45 10             	mov    0x10(%ebp),%eax
  801782:	ff 75 f4             	pushl  -0xc(%ebp)
  801785:	50                   	push   %eax
  801786:	ff 75 0c             	pushl  0xc(%ebp)
  801789:	ff 75 08             	pushl  0x8(%ebp)
  80178c:	e8 16 fc ff ff       	call   8013a7 <vprintfmt>
  801791:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801794:	90                   	nop
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80179a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179d:	8b 40 08             	mov    0x8(%eax),%eax
  8017a0:	8d 50 01             	lea    0x1(%eax),%edx
  8017a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8017a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ac:	8b 10                	mov    (%eax),%edx
  8017ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b1:	8b 40 04             	mov    0x4(%eax),%eax
  8017b4:	39 c2                	cmp    %eax,%edx
  8017b6:	73 12                	jae    8017ca <sprintputch+0x33>
		*b->buf++ = ch;
  8017b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bb:	8b 00                	mov    (%eax),%eax
  8017bd:	8d 48 01             	lea    0x1(%eax),%ecx
  8017c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c3:	89 0a                	mov    %ecx,(%edx)
  8017c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c8:	88 10                	mov    %dl,(%eax)
}
  8017ca:	90                   	nop
  8017cb:	5d                   	pop    %ebp
  8017cc:	c3                   	ret    

008017cd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	01 d0                	add    %edx,%eax
  8017e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8017ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017f2:	74 06                	je     8017fa <vsnprintf+0x2d>
  8017f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017f8:	7f 07                	jg     801801 <vsnprintf+0x34>
		return -E_INVAL;
  8017fa:	b8 03 00 00 00       	mov    $0x3,%eax
  8017ff:	eb 20                	jmp    801821 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801801:	ff 75 14             	pushl  0x14(%ebp)
  801804:	ff 75 10             	pushl  0x10(%ebp)
  801807:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80180a:	50                   	push   %eax
  80180b:	68 97 17 80 00       	push   $0x801797
  801810:	e8 92 fb ff ff       	call   8013a7 <vprintfmt>
  801815:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80181e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801829:	8d 45 10             	lea    0x10(%ebp),%eax
  80182c:	83 c0 04             	add    $0x4,%eax
  80182f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801832:	8b 45 10             	mov    0x10(%ebp),%eax
  801835:	ff 75 f4             	pushl  -0xc(%ebp)
  801838:	50                   	push   %eax
  801839:	ff 75 0c             	pushl  0xc(%ebp)
  80183c:	ff 75 08             	pushl  0x8(%ebp)
  80183f:	e8 89 ff ff ff       	call   8017cd <vsnprintf>
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80184a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801855:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80185c:	eb 06                	jmp    801864 <strlen+0x15>
		n++;
  80185e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801861:	ff 45 08             	incl   0x8(%ebp)
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	8a 00                	mov    (%eax),%al
  801869:	84 c0                	test   %al,%al
  80186b:	75 f1                	jne    80185e <strlen+0xf>
		n++;
	return n;
  80186d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801878:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80187f:	eb 09                	jmp    80188a <strnlen+0x18>
		n++;
  801881:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801884:	ff 45 08             	incl   0x8(%ebp)
  801887:	ff 4d 0c             	decl   0xc(%ebp)
  80188a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80188e:	74 09                	je     801899 <strnlen+0x27>
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	8a 00                	mov    (%eax),%al
  801895:	84 c0                	test   %al,%al
  801897:	75 e8                	jne    801881 <strnlen+0xf>
		n++;
	return n;
  801899:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8018aa:	90                   	nop
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	8d 50 01             	lea    0x1(%eax),%edx
  8018b1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8018bd:	8a 12                	mov    (%edx),%dl
  8018bf:	88 10                	mov    %dl,(%eax)
  8018c1:	8a 00                	mov    (%eax),%al
  8018c3:	84 c0                	test   %al,%al
  8018c5:	75 e4                	jne    8018ab <strcpy+0xd>
		/* do nothing */;
	return ret;
  8018c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8018d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018df:	eb 1f                	jmp    801900 <strncpy+0x34>
		*dst++ = *src;
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	8d 50 01             	lea    0x1(%eax),%edx
  8018e7:	89 55 08             	mov    %edx,0x8(%ebp)
  8018ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ed:	8a 12                	mov    (%edx),%dl
  8018ef:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8018f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f4:	8a 00                	mov    (%eax),%al
  8018f6:	84 c0                	test   %al,%al
  8018f8:	74 03                	je     8018fd <strncpy+0x31>
			src++;
  8018fa:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8018fd:	ff 45 fc             	incl   -0x4(%ebp)
  801900:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801903:	3b 45 10             	cmp    0x10(%ebp),%eax
  801906:	72 d9                	jb     8018e1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801908:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801919:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80191d:	74 30                	je     80194f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80191f:	eb 16                	jmp    801937 <strlcpy+0x2a>
			*dst++ = *src++;
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8d 50 01             	lea    0x1(%eax),%edx
  801927:	89 55 08             	mov    %edx,0x8(%ebp)
  80192a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801930:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801933:	8a 12                	mov    (%edx),%dl
  801935:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801937:	ff 4d 10             	decl   0x10(%ebp)
  80193a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80193e:	74 09                	je     801949 <strlcpy+0x3c>
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	8a 00                	mov    (%eax),%al
  801945:	84 c0                	test   %al,%al
  801947:	75 d8                	jne    801921 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80194f:	8b 55 08             	mov    0x8(%ebp),%edx
  801952:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801955:	29 c2                	sub    %eax,%edx
  801957:	89 d0                	mov    %edx,%eax
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80195e:	eb 06                	jmp    801966 <strcmp+0xb>
		p++, q++;
  801960:	ff 45 08             	incl   0x8(%ebp)
  801963:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	8a 00                	mov    (%eax),%al
  80196b:	84 c0                	test   %al,%al
  80196d:	74 0e                	je     80197d <strcmp+0x22>
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	8a 10                	mov    (%eax),%dl
  801974:	8b 45 0c             	mov    0xc(%ebp),%eax
  801977:	8a 00                	mov    (%eax),%al
  801979:	38 c2                	cmp    %al,%dl
  80197b:	74 e3                	je     801960 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	8a 00                	mov    (%eax),%al
  801982:	0f b6 d0             	movzbl %al,%edx
  801985:	8b 45 0c             	mov    0xc(%ebp),%eax
  801988:	8a 00                	mov    (%eax),%al
  80198a:	0f b6 c0             	movzbl %al,%eax
  80198d:	29 c2                	sub    %eax,%edx
  80198f:	89 d0                	mov    %edx,%eax
}
  801991:	5d                   	pop    %ebp
  801992:	c3                   	ret    

00801993 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801996:	eb 09                	jmp    8019a1 <strncmp+0xe>
		n--, p++, q++;
  801998:	ff 4d 10             	decl   0x10(%ebp)
  80199b:	ff 45 08             	incl   0x8(%ebp)
  80199e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8019a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019a5:	74 17                	je     8019be <strncmp+0x2b>
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	8a 00                	mov    (%eax),%al
  8019ac:	84 c0                	test   %al,%al
  8019ae:	74 0e                	je     8019be <strncmp+0x2b>
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	8a 10                	mov    (%eax),%dl
  8019b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	38 c2                	cmp    %al,%dl
  8019bc:	74 da                	je     801998 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8019be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019c2:	75 07                	jne    8019cb <strncmp+0x38>
		return 0;
  8019c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c9:	eb 14                	jmp    8019df <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	8a 00                	mov    (%eax),%al
  8019d0:	0f b6 d0             	movzbl %al,%edx
  8019d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d6:	8a 00                	mov    (%eax),%al
  8019d8:	0f b6 c0             	movzbl %al,%eax
  8019db:	29 c2                	sub    %eax,%edx
  8019dd:	89 d0                	mov    %edx,%eax
}
  8019df:	5d                   	pop    %ebp
  8019e0:	c3                   	ret    

008019e1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 04             	sub    $0x4,%esp
  8019e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8019ed:	eb 12                	jmp    801a01 <strchr+0x20>
		if (*s == c)
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	8a 00                	mov    (%eax),%al
  8019f4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019f7:	75 05                	jne    8019fe <strchr+0x1d>
			return (char *) s;
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	eb 11                	jmp    801a0f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8019fe:	ff 45 08             	incl   0x8(%ebp)
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	84 c0                	test   %al,%al
  801a08:	75 e5                	jne    8019ef <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a1d:	eb 0d                	jmp    801a2c <strfind+0x1b>
		if (*s == c)
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	8a 00                	mov    (%eax),%al
  801a24:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a27:	74 0e                	je     801a37 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a29:	ff 45 08             	incl   0x8(%ebp)
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	8a 00                	mov    (%eax),%al
  801a31:	84 c0                	test   %al,%al
  801a33:	75 ea                	jne    801a1f <strfind+0xe>
  801a35:	eb 01                	jmp    801a38 <strfind+0x27>
		if (*s == c)
			break;
  801a37:	90                   	nop
	return (char *) s;
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801a49:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801a4f:	eb 0e                	jmp    801a5f <memset+0x22>
		*p++ = c;
  801a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a54:	8d 50 01             	lea    0x1(%eax),%edx
  801a57:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801a5f:	ff 4d f8             	decl   -0x8(%ebp)
  801a62:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801a66:	79 e9                	jns    801a51 <memset+0x14>
		*p++ = c;

	return v;
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801a7f:	eb 16                	jmp    801a97 <memcpy+0x2a>
		*d++ = *s++;
  801a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a84:	8d 50 01             	lea    0x1(%eax),%edx
  801a87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801a93:	8a 12                	mov    (%edx),%dl
  801a95:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801a97:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a9d:	89 55 10             	mov    %edx,0x10(%ebp)
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	75 dd                	jne    801a81 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801abb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801abe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801ac1:	73 50                	jae    801b13 <memmove+0x6a>
  801ac3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac9:	01 d0                	add    %edx,%eax
  801acb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801ace:	76 43                	jbe    801b13 <memmove+0x6a>
		s += n;
  801ad0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801ad6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801adc:	eb 10                	jmp    801aee <memmove+0x45>
			*--d = *--s;
  801ade:	ff 4d f8             	decl   -0x8(%ebp)
  801ae1:	ff 4d fc             	decl   -0x4(%ebp)
  801ae4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae7:	8a 10                	mov    (%eax),%dl
  801ae9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aec:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801aee:	8b 45 10             	mov    0x10(%ebp),%eax
  801af1:	8d 50 ff             	lea    -0x1(%eax),%edx
  801af4:	89 55 10             	mov    %edx,0x10(%ebp)
  801af7:	85 c0                	test   %eax,%eax
  801af9:	75 e3                	jne    801ade <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801afb:	eb 23                	jmp    801b20 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801afd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b00:	8d 50 01             	lea    0x1(%eax),%edx
  801b03:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b09:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b0c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b0f:	8a 12                	mov    (%edx),%dl
  801b11:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b13:	8b 45 10             	mov    0x10(%ebp),%eax
  801b16:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b19:	89 55 10             	mov    %edx,0x10(%ebp)
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	75 dd                	jne    801afd <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b34:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801b37:	eb 2a                	jmp    801b63 <memcmp+0x3e>
		if (*s1 != *s2)
  801b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b3c:	8a 10                	mov    (%eax),%dl
  801b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b41:	8a 00                	mov    (%eax),%al
  801b43:	38 c2                	cmp    %al,%dl
  801b45:	74 16                	je     801b5d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801b47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b4a:	8a 00                	mov    (%eax),%al
  801b4c:	0f b6 d0             	movzbl %al,%edx
  801b4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b52:	8a 00                	mov    (%eax),%al
  801b54:	0f b6 c0             	movzbl %al,%eax
  801b57:	29 c2                	sub    %eax,%edx
  801b59:	89 d0                	mov    %edx,%eax
  801b5b:	eb 18                	jmp    801b75 <memcmp+0x50>
		s1++, s2++;
  801b5d:	ff 45 fc             	incl   -0x4(%ebp)
  801b60:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801b63:	8b 45 10             	mov    0x10(%ebp),%eax
  801b66:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b69:	89 55 10             	mov    %edx,0x10(%ebp)
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	75 c9                	jne    801b39 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  801b80:	8b 45 10             	mov    0x10(%ebp),%eax
  801b83:	01 d0                	add    %edx,%eax
  801b85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801b88:	eb 15                	jmp    801b9f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	8a 00                	mov    (%eax),%al
  801b8f:	0f b6 d0             	movzbl %al,%edx
  801b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b95:	0f b6 c0             	movzbl %al,%eax
  801b98:	39 c2                	cmp    %eax,%edx
  801b9a:	74 0d                	je     801ba9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801b9c:	ff 45 08             	incl   0x8(%ebp)
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ba5:	72 e3                	jb     801b8a <memfind+0x13>
  801ba7:	eb 01                	jmp    801baa <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801ba9:	90                   	nop
	return (void *) s;
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801bb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801bbc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801bc3:	eb 03                	jmp    801bc8 <strtol+0x19>
		s++;
  801bc5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	8a 00                	mov    (%eax),%al
  801bcd:	3c 20                	cmp    $0x20,%al
  801bcf:	74 f4                	je     801bc5 <strtol+0x16>
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	8a 00                	mov    (%eax),%al
  801bd6:	3c 09                	cmp    $0x9,%al
  801bd8:	74 eb                	je     801bc5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	8a 00                	mov    (%eax),%al
  801bdf:	3c 2b                	cmp    $0x2b,%al
  801be1:	75 05                	jne    801be8 <strtol+0x39>
		s++;
  801be3:	ff 45 08             	incl   0x8(%ebp)
  801be6:	eb 13                	jmp    801bfb <strtol+0x4c>
	else if (*s == '-')
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	8a 00                	mov    (%eax),%al
  801bed:	3c 2d                	cmp    $0x2d,%al
  801bef:	75 0a                	jne    801bfb <strtol+0x4c>
		s++, neg = 1;
  801bf1:	ff 45 08             	incl   0x8(%ebp)
  801bf4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801bfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bff:	74 06                	je     801c07 <strtol+0x58>
  801c01:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c05:	75 20                	jne    801c27 <strtol+0x78>
  801c07:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0a:	8a 00                	mov    (%eax),%al
  801c0c:	3c 30                	cmp    $0x30,%al
  801c0e:	75 17                	jne    801c27 <strtol+0x78>
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	40                   	inc    %eax
  801c14:	8a 00                	mov    (%eax),%al
  801c16:	3c 78                	cmp    $0x78,%al
  801c18:	75 0d                	jne    801c27 <strtol+0x78>
		s += 2, base = 16;
  801c1a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c1e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c25:	eb 28                	jmp    801c4f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801c27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c2b:	75 15                	jne    801c42 <strtol+0x93>
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	8a 00                	mov    (%eax),%al
  801c32:	3c 30                	cmp    $0x30,%al
  801c34:	75 0c                	jne    801c42 <strtol+0x93>
		s++, base = 8;
  801c36:	ff 45 08             	incl   0x8(%ebp)
  801c39:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801c40:	eb 0d                	jmp    801c4f <strtol+0xa0>
	else if (base == 0)
  801c42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c46:	75 07                	jne    801c4f <strtol+0xa0>
		base = 10;
  801c48:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	8a 00                	mov    (%eax),%al
  801c54:	3c 2f                	cmp    $0x2f,%al
  801c56:	7e 19                	jle    801c71 <strtol+0xc2>
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	8a 00                	mov    (%eax),%al
  801c5d:	3c 39                	cmp    $0x39,%al
  801c5f:	7f 10                	jg     801c71 <strtol+0xc2>
			dig = *s - '0';
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	8a 00                	mov    (%eax),%al
  801c66:	0f be c0             	movsbl %al,%eax
  801c69:	83 e8 30             	sub    $0x30,%eax
  801c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c6f:	eb 42                	jmp    801cb3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	8a 00                	mov    (%eax),%al
  801c76:	3c 60                	cmp    $0x60,%al
  801c78:	7e 19                	jle    801c93 <strtol+0xe4>
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	8a 00                	mov    (%eax),%al
  801c7f:	3c 7a                	cmp    $0x7a,%al
  801c81:	7f 10                	jg     801c93 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	8a 00                	mov    (%eax),%al
  801c88:	0f be c0             	movsbl %al,%eax
  801c8b:	83 e8 57             	sub    $0x57,%eax
  801c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c91:	eb 20                	jmp    801cb3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	8a 00                	mov    (%eax),%al
  801c98:	3c 40                	cmp    $0x40,%al
  801c9a:	7e 39                	jle    801cd5 <strtol+0x126>
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	8a 00                	mov    (%eax),%al
  801ca1:	3c 5a                	cmp    $0x5a,%al
  801ca3:	7f 30                	jg     801cd5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	8a 00                	mov    (%eax),%al
  801caa:	0f be c0             	movsbl %al,%eax
  801cad:	83 e8 37             	sub    $0x37,%eax
  801cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb6:	3b 45 10             	cmp    0x10(%ebp),%eax
  801cb9:	7d 19                	jge    801cd4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801cbb:	ff 45 08             	incl   0x8(%ebp)
  801cbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc1:	0f af 45 10          	imul   0x10(%ebp),%eax
  801cc5:	89 c2                	mov    %eax,%edx
  801cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cca:	01 d0                	add    %edx,%eax
  801ccc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ccf:	e9 7b ff ff ff       	jmp    801c4f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801cd4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801cd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cd9:	74 08                	je     801ce3 <strtol+0x134>
		*endptr = (char *) s;
  801cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cde:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801ce3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ce7:	74 07                	je     801cf0 <strtol+0x141>
  801ce9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cec:	f7 d8                	neg    %eax
  801cee:	eb 03                	jmp    801cf3 <strtol+0x144>
  801cf0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <ltostr>:

void
ltostr(long value, char *str)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801cfb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d02:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d0d:	79 13                	jns    801d22 <ltostr+0x2d>
	{
		neg = 1;
  801d0f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d19:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d1c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d1f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d2a:	99                   	cltd   
  801d2b:	f7 f9                	idiv   %ecx
  801d2d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801d30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d33:	8d 50 01             	lea    0x1(%eax),%edx
  801d36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d39:	89 c2                	mov    %eax,%edx
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	01 d0                	add    %edx,%eax
  801d40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d43:	83 c2 30             	add    $0x30,%edx
  801d46:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801d48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d4b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d50:	f7 e9                	imul   %ecx
  801d52:	c1 fa 02             	sar    $0x2,%edx
  801d55:	89 c8                	mov    %ecx,%eax
  801d57:	c1 f8 1f             	sar    $0x1f,%eax
  801d5a:	29 c2                	sub    %eax,%edx
  801d5c:	89 d0                	mov    %edx,%eax
  801d5e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801d61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d64:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d69:	f7 e9                	imul   %ecx
  801d6b:	c1 fa 02             	sar    $0x2,%edx
  801d6e:	89 c8                	mov    %ecx,%eax
  801d70:	c1 f8 1f             	sar    $0x1f,%eax
  801d73:	29 c2                	sub    %eax,%edx
  801d75:	89 d0                	mov    %edx,%eax
  801d77:	c1 e0 02             	shl    $0x2,%eax
  801d7a:	01 d0                	add    %edx,%eax
  801d7c:	01 c0                	add    %eax,%eax
  801d7e:	29 c1                	sub    %eax,%ecx
  801d80:	89 ca                	mov    %ecx,%edx
  801d82:	85 d2                	test   %edx,%edx
  801d84:	75 9c                	jne    801d22 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801d86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801d8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d90:	48                   	dec    %eax
  801d91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801d94:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d98:	74 3d                	je     801dd7 <ltostr+0xe2>
		start = 1 ;
  801d9a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801da1:	eb 34                	jmp    801dd7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801da3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da9:	01 d0                	add    %edx,%eax
  801dab:	8a 00                	mov    (%eax),%al
  801dad:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801db0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db6:	01 c2                	add    %eax,%edx
  801db8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbe:	01 c8                	add    %ecx,%eax
  801dc0:	8a 00                	mov    (%eax),%al
  801dc2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801dc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dca:	01 c2                	add    %eax,%edx
  801dcc:	8a 45 eb             	mov    -0x15(%ebp),%al
  801dcf:	88 02                	mov    %al,(%edx)
		start++ ;
  801dd1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801dd4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dda:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ddd:	7c c4                	jl     801da3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801ddf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de5:	01 d0                	add    %edx,%eax
  801de7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801dea:	90                   	nop
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801df3:	ff 75 08             	pushl  0x8(%ebp)
  801df6:	e8 54 fa ff ff       	call   80184f <strlen>
  801dfb:	83 c4 04             	add    $0x4,%esp
  801dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e01:	ff 75 0c             	pushl  0xc(%ebp)
  801e04:	e8 46 fa ff ff       	call   80184f <strlen>
  801e09:	83 c4 04             	add    $0x4,%esp
  801e0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e1d:	eb 17                	jmp    801e36 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e22:	8b 45 10             	mov    0x10(%ebp),%eax
  801e25:	01 c2                	add    %eax,%edx
  801e27:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	01 c8                	add    %ecx,%eax
  801e2f:	8a 00                	mov    (%eax),%al
  801e31:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e33:	ff 45 fc             	incl   -0x4(%ebp)
  801e36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e39:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e3c:	7c e1                	jl     801e1f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801e3e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801e45:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801e4c:	eb 1f                	jmp    801e6d <strcconcat+0x80>
		final[s++] = str2[i] ;
  801e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e51:	8d 50 01             	lea    0x1(%eax),%edx
  801e54:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801e57:	89 c2                	mov    %eax,%edx
  801e59:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5c:	01 c2                	add    %eax,%edx
  801e5e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e64:	01 c8                	add    %ecx,%eax
  801e66:	8a 00                	mov    (%eax),%al
  801e68:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801e6a:	ff 45 f8             	incl   -0x8(%ebp)
  801e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e70:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e73:	7c d9                	jl     801e4e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801e75:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e78:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7b:	01 d0                	add    %edx,%eax
  801e7d:	c6 00 00             	movb   $0x0,(%eax)
}
  801e80:	90                   	nop
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801e86:	8b 45 14             	mov    0x14(%ebp),%eax
  801e89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e92:	8b 00                	mov    (%eax),%eax
  801e94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9e:	01 d0                	add    %edx,%eax
  801ea0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ea6:	eb 0c                	jmp    801eb4 <strsplit+0x31>
			*string++ = 0;
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	8d 50 01             	lea    0x1(%eax),%edx
  801eae:	89 55 08             	mov    %edx,0x8(%ebp)
  801eb1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb7:	8a 00                	mov    (%eax),%al
  801eb9:	84 c0                	test   %al,%al
  801ebb:	74 18                	je     801ed5 <strsplit+0x52>
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	8a 00                	mov    (%eax),%al
  801ec2:	0f be c0             	movsbl %al,%eax
  801ec5:	50                   	push   %eax
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	e8 13 fb ff ff       	call   8019e1 <strchr>
  801ece:	83 c4 08             	add    $0x8,%esp
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	75 d3                	jne    801ea8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	8a 00                	mov    (%eax),%al
  801eda:	84 c0                	test   %al,%al
  801edc:	74 5a                	je     801f38 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ede:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee1:	8b 00                	mov    (%eax),%eax
  801ee3:	83 f8 0f             	cmp    $0xf,%eax
  801ee6:	75 07                	jne    801eef <strsplit+0x6c>
		{
			return 0;
  801ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  801eed:	eb 66                	jmp    801f55 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801eef:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef2:	8b 00                	mov    (%eax),%eax
  801ef4:	8d 48 01             	lea    0x1(%eax),%ecx
  801ef7:	8b 55 14             	mov    0x14(%ebp),%edx
  801efa:	89 0a                	mov    %ecx,(%edx)
  801efc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f03:	8b 45 10             	mov    0x10(%ebp),%eax
  801f06:	01 c2                	add    %eax,%edx
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f0d:	eb 03                	jmp    801f12 <strsplit+0x8f>
			string++;
  801f0f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f12:	8b 45 08             	mov    0x8(%ebp),%eax
  801f15:	8a 00                	mov    (%eax),%al
  801f17:	84 c0                	test   %al,%al
  801f19:	74 8b                	je     801ea6 <strsplit+0x23>
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	8a 00                	mov    (%eax),%al
  801f20:	0f be c0             	movsbl %al,%eax
  801f23:	50                   	push   %eax
  801f24:	ff 75 0c             	pushl  0xc(%ebp)
  801f27:	e8 b5 fa ff ff       	call   8019e1 <strchr>
  801f2c:	83 c4 08             	add    $0x8,%esp
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	74 dc                	je     801f0f <strsplit+0x8c>
			string++;
	}
  801f33:	e9 6e ff ff ff       	jmp    801ea6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f38:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f39:	8b 45 14             	mov    0x14(%ebp),%eax
  801f3c:	8b 00                	mov    (%eax),%eax
  801f3e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f45:	8b 45 10             	mov    0x10(%ebp),%eax
  801f48:	01 d0                	add    %edx,%eax
  801f4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801f50:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801f5d:	83 ec 04             	sub    $0x4,%esp
  801f60:	68 f0 30 80 00       	push   $0x8030f0
  801f65:	6a 0e                	push   $0xe
  801f67:	68 2a 31 80 00       	push   $0x80312a
  801f6c:	e8 a8 ef ff ff       	call   800f19 <_panic>

00801f71 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801f77:	a1 04 40 80 00       	mov    0x804004,%eax
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	74 0f                	je     801f8f <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801f80:	e8 d2 ff ff ff       	call   801f57 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801f85:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801f8c:	00 00 00 
	}
	if (size == 0) return NULL ;
  801f8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f93:	75 07                	jne    801f9c <malloc+0x2b>
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9a:	eb 14                	jmp    801fb0 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801f9c:	83 ec 04             	sub    $0x4,%esp
  801f9f:	68 38 31 80 00       	push   $0x803138
  801fa4:	6a 2e                	push   $0x2e
  801fa6:	68 2a 31 80 00       	push   $0x80312a
  801fab:	e8 69 ef ff ff       	call   800f19 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	68 60 31 80 00       	push   $0x803160
  801fc0:	6a 49                	push   $0x49
  801fc2:	68 2a 31 80 00       	push   $0x80312a
  801fc7:	e8 4d ef ff ff       	call   800f19 <_panic>

00801fcc <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 18             	sub    $0x18,%esp
  801fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd5:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801fd8:	83 ec 04             	sub    $0x4,%esp
  801fdb:	68 84 31 80 00       	push   $0x803184
  801fe0:	6a 57                	push   $0x57
  801fe2:	68 2a 31 80 00       	push   $0x80312a
  801fe7:	e8 2d ef ff ff       	call   800f19 <_panic>

00801fec <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801ff2:	83 ec 04             	sub    $0x4,%esp
  801ff5:	68 ac 31 80 00       	push   $0x8031ac
  801ffa:	6a 60                	push   $0x60
  801ffc:	68 2a 31 80 00       	push   $0x80312a
  802001:	e8 13 ef ff ff       	call   800f19 <_panic>

00802006 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80200c:	83 ec 04             	sub    $0x4,%esp
  80200f:	68 d0 31 80 00       	push   $0x8031d0
  802014:	6a 7c                	push   $0x7c
  802016:	68 2a 31 80 00       	push   $0x80312a
  80201b:	e8 f9 ee ff ff       	call   800f19 <_panic>

00802020 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	68 f8 31 80 00       	push   $0x8031f8
  80202e:	68 86 00 00 00       	push   $0x86
  802033:	68 2a 31 80 00       	push   $0x80312a
  802038:	e8 dc ee ff ff       	call   800f19 <_panic>

0080203d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802043:	83 ec 04             	sub    $0x4,%esp
  802046:	68 1c 32 80 00       	push   $0x80321c
  80204b:	68 91 00 00 00       	push   $0x91
  802050:	68 2a 31 80 00       	push   $0x80312a
  802055:	e8 bf ee ff ff       	call   800f19 <_panic>

0080205a <shrink>:

}
void shrink(uint32 newSize)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802060:	83 ec 04             	sub    $0x4,%esp
  802063:	68 1c 32 80 00       	push   $0x80321c
  802068:	68 96 00 00 00       	push   $0x96
  80206d:	68 2a 31 80 00       	push   $0x80312a
  802072:	e8 a2 ee ff ff       	call   800f19 <_panic>

00802077 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80207d:	83 ec 04             	sub    $0x4,%esp
  802080:	68 1c 32 80 00       	push   $0x80321c
  802085:	68 9b 00 00 00       	push   $0x9b
  80208a:	68 2a 31 80 00       	push   $0x80312a
  80208f:	e8 85 ee ff ff       	call   800f19 <_panic>

00802094 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	57                   	push   %edi
  802098:	56                   	push   %esi
  802099:	53                   	push   %ebx
  80209a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020a9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020ac:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020af:	cd 30                	int    $0x30
  8020b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020b7:	83 c4 10             	add    $0x10,%esp
  8020ba:	5b                   	pop    %ebx
  8020bb:	5e                   	pop    %esi
  8020bc:	5f                   	pop    %edi
  8020bd:	5d                   	pop    %ebp
  8020be:	c3                   	ret    

008020bf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020cb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	52                   	push   %edx
  8020d7:	ff 75 0c             	pushl  0xc(%ebp)
  8020da:	50                   	push   %eax
  8020db:	6a 00                	push   $0x0
  8020dd:	e8 b2 ff ff ff       	call   802094 <syscall>
  8020e2:	83 c4 18             	add    $0x18,%esp
}
  8020e5:	90                   	nop
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 01                	push   $0x1
  8020f7:	e8 98 ff ff ff       	call   802094 <syscall>
  8020fc:	83 c4 18             	add    $0x18,%esp
}
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802104:	8b 55 0c             	mov    0xc(%ebp),%edx
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	52                   	push   %edx
  802111:	50                   	push   %eax
  802112:	6a 05                	push   $0x5
  802114:	e8 7b ff ff ff       	call   802094 <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	56                   	push   %esi
  802122:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802123:	8b 75 18             	mov    0x18(%ebp),%esi
  802126:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802129:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80212c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	56                   	push   %esi
  802133:	53                   	push   %ebx
  802134:	51                   	push   %ecx
  802135:	52                   	push   %edx
  802136:	50                   	push   %eax
  802137:	6a 06                	push   $0x6
  802139:	e8 56 ff ff ff       	call   802094 <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802144:	5b                   	pop    %ebx
  802145:	5e                   	pop    %esi
  802146:	5d                   	pop    %ebp
  802147:	c3                   	ret    

00802148 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80214b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	52                   	push   %edx
  802158:	50                   	push   %eax
  802159:	6a 07                	push   $0x7
  80215b:	e8 34 ff ff ff       	call   802094 <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	ff 75 0c             	pushl  0xc(%ebp)
  802171:	ff 75 08             	pushl  0x8(%ebp)
  802174:	6a 08                	push   $0x8
  802176:	e8 19 ff ff ff       	call   802094 <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 09                	push   $0x9
  80218f:	e8 00 ff ff ff       	call   802094 <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 0a                	push   $0xa
  8021a8:	e8 e7 fe ff ff       	call   802094 <syscall>
  8021ad:	83 c4 18             	add    $0x18,%esp
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 0b                	push   $0xb
  8021c1:	e8 ce fe ff ff       	call   802094 <syscall>
  8021c6:	83 c4 18             	add    $0x18,%esp
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	ff 75 0c             	pushl  0xc(%ebp)
  8021d7:	ff 75 08             	pushl  0x8(%ebp)
  8021da:	6a 0f                	push   $0xf
  8021dc:	e8 b3 fe ff ff       	call   802094 <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
	return;
  8021e4:	90                   	nop
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	ff 75 0c             	pushl  0xc(%ebp)
  8021f3:	ff 75 08             	pushl  0x8(%ebp)
  8021f6:	6a 10                	push   $0x10
  8021f8:	e8 97 fe ff ff       	call   802094 <syscall>
  8021fd:	83 c4 18             	add    $0x18,%esp
	return ;
  802200:	90                   	nop
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	ff 75 10             	pushl  0x10(%ebp)
  80220d:	ff 75 0c             	pushl  0xc(%ebp)
  802210:	ff 75 08             	pushl  0x8(%ebp)
  802213:	6a 11                	push   $0x11
  802215:	e8 7a fe ff ff       	call   802094 <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
	return ;
  80221d:	90                   	nop
}
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 0c                	push   $0xc
  80222f:	e8 60 fe ff ff       	call   802094 <syscall>
  802234:	83 c4 18             	add    $0x18,%esp
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	ff 75 08             	pushl  0x8(%ebp)
  802247:	6a 0d                	push   $0xd
  802249:	e8 46 fe ff ff       	call   802094 <syscall>
  80224e:	83 c4 18             	add    $0x18,%esp
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 0e                	push   $0xe
  802262:	e8 2d fe ff ff       	call   802094 <syscall>
  802267:	83 c4 18             	add    $0x18,%esp
}
  80226a:	90                   	nop
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 13                	push   $0x13
  80227c:	e8 13 fe ff ff       	call   802094 <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
}
  802284:	90                   	nop
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 14                	push   $0x14
  802296:	e8 f9 fd ff ff       	call   802094 <syscall>
  80229b:	83 c4 18             	add    $0x18,%esp
}
  80229e:	90                   	nop
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 04             	sub    $0x4,%esp
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022ad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	50                   	push   %eax
  8022ba:	6a 15                	push   $0x15
  8022bc:	e8 d3 fd ff ff       	call   802094 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	90                   	nop
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 16                	push   $0x16
  8022d6:	e8 b9 fd ff ff       	call   802094 <syscall>
  8022db:	83 c4 18             	add    $0x18,%esp
}
  8022de:	90                   	nop
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	ff 75 0c             	pushl  0xc(%ebp)
  8022f0:	50                   	push   %eax
  8022f1:	6a 17                	push   $0x17
  8022f3:	e8 9c fd ff ff       	call   802094 <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802300:	8b 55 0c             	mov    0xc(%ebp),%edx
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	52                   	push   %edx
  80230d:	50                   	push   %eax
  80230e:	6a 1a                	push   $0x1a
  802310:	e8 7f fd ff ff       	call   802094 <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
}
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80231d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	52                   	push   %edx
  80232a:	50                   	push   %eax
  80232b:	6a 18                	push   $0x18
  80232d:	e8 62 fd ff ff       	call   802094 <syscall>
  802332:	83 c4 18             	add    $0x18,%esp
}
  802335:	90                   	nop
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80233b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	52                   	push   %edx
  802348:	50                   	push   %eax
  802349:	6a 19                	push   $0x19
  80234b:	e8 44 fd ff ff       	call   802094 <syscall>
  802350:	83 c4 18             	add    $0x18,%esp
}
  802353:	90                   	nop
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 04             	sub    $0x4,%esp
  80235c:	8b 45 10             	mov    0x10(%ebp),%eax
  80235f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802362:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802365:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	6a 00                	push   $0x0
  80236e:	51                   	push   %ecx
  80236f:	52                   	push   %edx
  802370:	ff 75 0c             	pushl  0xc(%ebp)
  802373:	50                   	push   %eax
  802374:	6a 1b                	push   $0x1b
  802376:	e8 19 fd ff ff       	call   802094 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802383:	8b 55 0c             	mov    0xc(%ebp),%edx
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	52                   	push   %edx
  802390:	50                   	push   %eax
  802391:	6a 1c                	push   $0x1c
  802393:	e8 fc fc ff ff       	call   802094 <syscall>
  802398:	83 c4 18             	add    $0x18,%esp
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	51                   	push   %ecx
  8023ae:	52                   	push   %edx
  8023af:	50                   	push   %eax
  8023b0:	6a 1d                	push   $0x1d
  8023b2:	e8 dd fc ff ff       	call   802094 <syscall>
  8023b7:	83 c4 18             	add    $0x18,%esp
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	52                   	push   %edx
  8023cc:	50                   	push   %eax
  8023cd:	6a 1e                	push   $0x1e
  8023cf:	e8 c0 fc ff ff       	call   802094 <syscall>
  8023d4:	83 c4 18             	add    $0x18,%esp
}
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 1f                	push   $0x1f
  8023e8:	e8 a7 fc ff ff       	call   802094 <syscall>
  8023ed:	83 c4 18             	add    $0x18,%esp
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	6a 00                	push   $0x0
  8023fa:	ff 75 14             	pushl  0x14(%ebp)
  8023fd:	ff 75 10             	pushl  0x10(%ebp)
  802400:	ff 75 0c             	pushl  0xc(%ebp)
  802403:	50                   	push   %eax
  802404:	6a 20                	push   $0x20
  802406:	e8 89 fc ff ff       	call   802094 <syscall>
  80240b:	83 c4 18             	add    $0x18,%esp
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	50                   	push   %eax
  80241f:	6a 21                	push   $0x21
  802421:	e8 6e fc ff ff       	call   802094 <syscall>
  802426:	83 c4 18             	add    $0x18,%esp
}
  802429:	90                   	nop
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	50                   	push   %eax
  80243b:	6a 22                	push   $0x22
  80243d:	e8 52 fc ff ff       	call   802094 <syscall>
  802442:	83 c4 18             	add    $0x18,%esp
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 02                	push   $0x2
  802456:	e8 39 fc ff ff       	call   802094 <syscall>
  80245b:	83 c4 18             	add    $0x18,%esp
}
  80245e:	c9                   	leave  
  80245f:	c3                   	ret    

00802460 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 03                	push   $0x3
  80246f:	e8 20 fc ff ff       	call   802094 <syscall>
  802474:	83 c4 18             	add    $0x18,%esp
}
  802477:	c9                   	leave  
  802478:	c3                   	ret    

00802479 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 04                	push   $0x4
  802488:	e8 07 fc ff ff       	call   802094 <syscall>
  80248d:	83 c4 18             	add    $0x18,%esp
}
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <sys_exit_env>:


void sys_exit_env(void)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 23                	push   $0x23
  8024a1:	e8 ee fb ff ff       	call   802094 <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
}
  8024a9:	90                   	nop
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024b2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024b5:	8d 50 04             	lea    0x4(%eax),%edx
  8024b8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	52                   	push   %edx
  8024c2:	50                   	push   %eax
  8024c3:	6a 24                	push   $0x24
  8024c5:	e8 ca fb ff ff       	call   802094 <syscall>
  8024ca:	83 c4 18             	add    $0x18,%esp
	return result;
  8024cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024d6:	89 01                	mov    %eax,(%ecx)
  8024d8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	c9                   	leave  
  8024df:	c2 04 00             	ret    $0x4

008024e2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	ff 75 10             	pushl  0x10(%ebp)
  8024ec:	ff 75 0c             	pushl  0xc(%ebp)
  8024ef:	ff 75 08             	pushl  0x8(%ebp)
  8024f2:	6a 12                	push   $0x12
  8024f4:	e8 9b fb ff ff       	call   802094 <syscall>
  8024f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024fc:	90                   	nop
}
  8024fd:	c9                   	leave  
  8024fe:	c3                   	ret    

008024ff <sys_rcr2>:
uint32 sys_rcr2()
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 25                	push   $0x25
  80250e:	e8 81 fb ff ff       	call   802094 <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	83 ec 04             	sub    $0x4,%esp
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802524:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	50                   	push   %eax
  802531:	6a 26                	push   $0x26
  802533:	e8 5c fb ff ff       	call   802094 <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
	return ;
  80253b:	90                   	nop
}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <rsttst>:
void rsttst()
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 28                	push   $0x28
  80254d:	e8 42 fb ff ff       	call   802094 <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
	return ;
  802555:	90                   	nop
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	83 ec 04             	sub    $0x4,%esp
  80255e:	8b 45 14             	mov    0x14(%ebp),%eax
  802561:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802564:	8b 55 18             	mov    0x18(%ebp),%edx
  802567:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80256b:	52                   	push   %edx
  80256c:	50                   	push   %eax
  80256d:	ff 75 10             	pushl  0x10(%ebp)
  802570:	ff 75 0c             	pushl  0xc(%ebp)
  802573:	ff 75 08             	pushl  0x8(%ebp)
  802576:	6a 27                	push   $0x27
  802578:	e8 17 fb ff ff       	call   802094 <syscall>
  80257d:	83 c4 18             	add    $0x18,%esp
	return ;
  802580:	90                   	nop
}
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <chktst>:
void chktst(uint32 n)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	ff 75 08             	pushl  0x8(%ebp)
  802591:	6a 29                	push   $0x29
  802593:	e8 fc fa ff ff       	call   802094 <syscall>
  802598:	83 c4 18             	add    $0x18,%esp
	return ;
  80259b:	90                   	nop
}
  80259c:	c9                   	leave  
  80259d:	c3                   	ret    

0080259e <inctst>:

void inctst()
{
  80259e:	55                   	push   %ebp
  80259f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 2a                	push   $0x2a
  8025ad:	e8 e2 fa ff ff       	call   802094 <syscall>
  8025b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b5:	90                   	nop
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <gettst>:
uint32 gettst()
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 2b                	push   $0x2b
  8025c7:	e8 c8 fa ff ff       	call   802094 <syscall>
  8025cc:	83 c4 18             	add    $0x18,%esp
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 2c                	push   $0x2c
  8025e3:	e8 ac fa ff ff       	call   802094 <syscall>
  8025e8:	83 c4 18             	add    $0x18,%esp
  8025eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025ee:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025f2:	75 07                	jne    8025fb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f9:	eb 05                	jmp    802600 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802600:	c9                   	leave  
  802601:	c3                   	ret    

00802602 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 2c                	push   $0x2c
  802614:	e8 7b fa ff ff       	call   802094 <syscall>
  802619:	83 c4 18             	add    $0x18,%esp
  80261c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80261f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802623:	75 07                	jne    80262c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802625:	b8 01 00 00 00       	mov    $0x1,%eax
  80262a:	eb 05                	jmp    802631 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
  802636:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	6a 2c                	push   $0x2c
  802645:	e8 4a fa ff ff       	call   802094 <syscall>
  80264a:	83 c4 18             	add    $0x18,%esp
  80264d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802650:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802654:	75 07                	jne    80265d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802656:	b8 01 00 00 00       	mov    $0x1,%eax
  80265b:	eb 05                	jmp    802662 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802662:	c9                   	leave  
  802663:	c3                   	ret    

00802664 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
  802667:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	6a 00                	push   $0x0
  802672:	6a 00                	push   $0x0
  802674:	6a 2c                	push   $0x2c
  802676:	e8 19 fa ff ff       	call   802094 <syscall>
  80267b:	83 c4 18             	add    $0x18,%esp
  80267e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802681:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802685:	75 07                	jne    80268e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802687:	b8 01 00 00 00       	mov    $0x1,%eax
  80268c:	eb 05                	jmp    802693 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80268e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802693:	c9                   	leave  
  802694:	c3                   	ret    

00802695 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	ff 75 08             	pushl  0x8(%ebp)
  8026a3:	6a 2d                	push   $0x2d
  8026a5:	e8 ea f9 ff ff       	call   802094 <syscall>
  8026aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ad:	90                   	nop
}
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
  8026b3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c0:	6a 00                	push   $0x0
  8026c2:	53                   	push   %ebx
  8026c3:	51                   	push   %ecx
  8026c4:	52                   	push   %edx
  8026c5:	50                   	push   %eax
  8026c6:	6a 2e                	push   $0x2e
  8026c8:	e8 c7 f9 ff ff       	call   802094 <syscall>
  8026cd:	83 c4 18             	add    $0x18,%esp
}
  8026d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 00                	push   $0x0
  8026e4:	52                   	push   %edx
  8026e5:	50                   	push   %eax
  8026e6:	6a 2f                	push   $0x2f
  8026e8:	e8 a7 f9 ff ff       	call   802094 <syscall>
  8026ed:	83 c4 18             	add    $0x18,%esp
}
  8026f0:	c9                   	leave  
  8026f1:	c3                   	ret    
  8026f2:	66 90                	xchg   %ax,%ax

008026f4 <__udivdi3>:
  8026f4:	55                   	push   %ebp
  8026f5:	57                   	push   %edi
  8026f6:	56                   	push   %esi
  8026f7:	53                   	push   %ebx
  8026f8:	83 ec 1c             	sub    $0x1c,%esp
  8026fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8026ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802703:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802707:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80270b:	89 ca                	mov    %ecx,%edx
  80270d:	89 f8                	mov    %edi,%eax
  80270f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802713:	85 f6                	test   %esi,%esi
  802715:	75 2d                	jne    802744 <__udivdi3+0x50>
  802717:	39 cf                	cmp    %ecx,%edi
  802719:	77 65                	ja     802780 <__udivdi3+0x8c>
  80271b:	89 fd                	mov    %edi,%ebp
  80271d:	85 ff                	test   %edi,%edi
  80271f:	75 0b                	jne    80272c <__udivdi3+0x38>
  802721:	b8 01 00 00 00       	mov    $0x1,%eax
  802726:	31 d2                	xor    %edx,%edx
  802728:	f7 f7                	div    %edi
  80272a:	89 c5                	mov    %eax,%ebp
  80272c:	31 d2                	xor    %edx,%edx
  80272e:	89 c8                	mov    %ecx,%eax
  802730:	f7 f5                	div    %ebp
  802732:	89 c1                	mov    %eax,%ecx
  802734:	89 d8                	mov    %ebx,%eax
  802736:	f7 f5                	div    %ebp
  802738:	89 cf                	mov    %ecx,%edi
  80273a:	89 fa                	mov    %edi,%edx
  80273c:	83 c4 1c             	add    $0x1c,%esp
  80273f:	5b                   	pop    %ebx
  802740:	5e                   	pop    %esi
  802741:	5f                   	pop    %edi
  802742:	5d                   	pop    %ebp
  802743:	c3                   	ret    
  802744:	39 ce                	cmp    %ecx,%esi
  802746:	77 28                	ja     802770 <__udivdi3+0x7c>
  802748:	0f bd fe             	bsr    %esi,%edi
  80274b:	83 f7 1f             	xor    $0x1f,%edi
  80274e:	75 40                	jne    802790 <__udivdi3+0x9c>
  802750:	39 ce                	cmp    %ecx,%esi
  802752:	72 0a                	jb     80275e <__udivdi3+0x6a>
  802754:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802758:	0f 87 9e 00 00 00    	ja     8027fc <__udivdi3+0x108>
  80275e:	b8 01 00 00 00       	mov    $0x1,%eax
  802763:	89 fa                	mov    %edi,%edx
  802765:	83 c4 1c             	add    $0x1c,%esp
  802768:	5b                   	pop    %ebx
  802769:	5e                   	pop    %esi
  80276a:	5f                   	pop    %edi
  80276b:	5d                   	pop    %ebp
  80276c:	c3                   	ret    
  80276d:	8d 76 00             	lea    0x0(%esi),%esi
  802770:	31 ff                	xor    %edi,%edi
  802772:	31 c0                	xor    %eax,%eax
  802774:	89 fa                	mov    %edi,%edx
  802776:	83 c4 1c             	add    $0x1c,%esp
  802779:	5b                   	pop    %ebx
  80277a:	5e                   	pop    %esi
  80277b:	5f                   	pop    %edi
  80277c:	5d                   	pop    %ebp
  80277d:	c3                   	ret    
  80277e:	66 90                	xchg   %ax,%ax
  802780:	89 d8                	mov    %ebx,%eax
  802782:	f7 f7                	div    %edi
  802784:	31 ff                	xor    %edi,%edi
  802786:	89 fa                	mov    %edi,%edx
  802788:	83 c4 1c             	add    $0x1c,%esp
  80278b:	5b                   	pop    %ebx
  80278c:	5e                   	pop    %esi
  80278d:	5f                   	pop    %edi
  80278e:	5d                   	pop    %ebp
  80278f:	c3                   	ret    
  802790:	bd 20 00 00 00       	mov    $0x20,%ebp
  802795:	89 eb                	mov    %ebp,%ebx
  802797:	29 fb                	sub    %edi,%ebx
  802799:	89 f9                	mov    %edi,%ecx
  80279b:	d3 e6                	shl    %cl,%esi
  80279d:	89 c5                	mov    %eax,%ebp
  80279f:	88 d9                	mov    %bl,%cl
  8027a1:	d3 ed                	shr    %cl,%ebp
  8027a3:	89 e9                	mov    %ebp,%ecx
  8027a5:	09 f1                	or     %esi,%ecx
  8027a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8027ab:	89 f9                	mov    %edi,%ecx
  8027ad:	d3 e0                	shl    %cl,%eax
  8027af:	89 c5                	mov    %eax,%ebp
  8027b1:	89 d6                	mov    %edx,%esi
  8027b3:	88 d9                	mov    %bl,%cl
  8027b5:	d3 ee                	shr    %cl,%esi
  8027b7:	89 f9                	mov    %edi,%ecx
  8027b9:	d3 e2                	shl    %cl,%edx
  8027bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027bf:	88 d9                	mov    %bl,%cl
  8027c1:	d3 e8                	shr    %cl,%eax
  8027c3:	09 c2                	or     %eax,%edx
  8027c5:	89 d0                	mov    %edx,%eax
  8027c7:	89 f2                	mov    %esi,%edx
  8027c9:	f7 74 24 0c          	divl   0xc(%esp)
  8027cd:	89 d6                	mov    %edx,%esi
  8027cf:	89 c3                	mov    %eax,%ebx
  8027d1:	f7 e5                	mul    %ebp
  8027d3:	39 d6                	cmp    %edx,%esi
  8027d5:	72 19                	jb     8027f0 <__udivdi3+0xfc>
  8027d7:	74 0b                	je     8027e4 <__udivdi3+0xf0>
  8027d9:	89 d8                	mov    %ebx,%eax
  8027db:	31 ff                	xor    %edi,%edi
  8027dd:	e9 58 ff ff ff       	jmp    80273a <__udivdi3+0x46>
  8027e2:	66 90                	xchg   %ax,%ax
  8027e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8027e8:	89 f9                	mov    %edi,%ecx
  8027ea:	d3 e2                	shl    %cl,%edx
  8027ec:	39 c2                	cmp    %eax,%edx
  8027ee:	73 e9                	jae    8027d9 <__udivdi3+0xe5>
  8027f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027f3:	31 ff                	xor    %edi,%edi
  8027f5:	e9 40 ff ff ff       	jmp    80273a <__udivdi3+0x46>
  8027fa:	66 90                	xchg   %ax,%ax
  8027fc:	31 c0                	xor    %eax,%eax
  8027fe:	e9 37 ff ff ff       	jmp    80273a <__udivdi3+0x46>
  802803:	90                   	nop

00802804 <__umoddi3>:
  802804:	55                   	push   %ebp
  802805:	57                   	push   %edi
  802806:	56                   	push   %esi
  802807:	53                   	push   %ebx
  802808:	83 ec 1c             	sub    $0x1c,%esp
  80280b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80280f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802813:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802817:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80281b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80281f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802823:	89 f3                	mov    %esi,%ebx
  802825:	89 fa                	mov    %edi,%edx
  802827:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80282b:	89 34 24             	mov    %esi,(%esp)
  80282e:	85 c0                	test   %eax,%eax
  802830:	75 1a                	jne    80284c <__umoddi3+0x48>
  802832:	39 f7                	cmp    %esi,%edi
  802834:	0f 86 a2 00 00 00    	jbe    8028dc <__umoddi3+0xd8>
  80283a:	89 c8                	mov    %ecx,%eax
  80283c:	89 f2                	mov    %esi,%edx
  80283e:	f7 f7                	div    %edi
  802840:	89 d0                	mov    %edx,%eax
  802842:	31 d2                	xor    %edx,%edx
  802844:	83 c4 1c             	add    $0x1c,%esp
  802847:	5b                   	pop    %ebx
  802848:	5e                   	pop    %esi
  802849:	5f                   	pop    %edi
  80284a:	5d                   	pop    %ebp
  80284b:	c3                   	ret    
  80284c:	39 f0                	cmp    %esi,%eax
  80284e:	0f 87 ac 00 00 00    	ja     802900 <__umoddi3+0xfc>
  802854:	0f bd e8             	bsr    %eax,%ebp
  802857:	83 f5 1f             	xor    $0x1f,%ebp
  80285a:	0f 84 ac 00 00 00    	je     80290c <__umoddi3+0x108>
  802860:	bf 20 00 00 00       	mov    $0x20,%edi
  802865:	29 ef                	sub    %ebp,%edi
  802867:	89 fe                	mov    %edi,%esi
  802869:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80286d:	89 e9                	mov    %ebp,%ecx
  80286f:	d3 e0                	shl    %cl,%eax
  802871:	89 d7                	mov    %edx,%edi
  802873:	89 f1                	mov    %esi,%ecx
  802875:	d3 ef                	shr    %cl,%edi
  802877:	09 c7                	or     %eax,%edi
  802879:	89 e9                	mov    %ebp,%ecx
  80287b:	d3 e2                	shl    %cl,%edx
  80287d:	89 14 24             	mov    %edx,(%esp)
  802880:	89 d8                	mov    %ebx,%eax
  802882:	d3 e0                	shl    %cl,%eax
  802884:	89 c2                	mov    %eax,%edx
  802886:	8b 44 24 08          	mov    0x8(%esp),%eax
  80288a:	d3 e0                	shl    %cl,%eax
  80288c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802890:	8b 44 24 08          	mov    0x8(%esp),%eax
  802894:	89 f1                	mov    %esi,%ecx
  802896:	d3 e8                	shr    %cl,%eax
  802898:	09 d0                	or     %edx,%eax
  80289a:	d3 eb                	shr    %cl,%ebx
  80289c:	89 da                	mov    %ebx,%edx
  80289e:	f7 f7                	div    %edi
  8028a0:	89 d3                	mov    %edx,%ebx
  8028a2:	f7 24 24             	mull   (%esp)
  8028a5:	89 c6                	mov    %eax,%esi
  8028a7:	89 d1                	mov    %edx,%ecx
  8028a9:	39 d3                	cmp    %edx,%ebx
  8028ab:	0f 82 87 00 00 00    	jb     802938 <__umoddi3+0x134>
  8028b1:	0f 84 91 00 00 00    	je     802948 <__umoddi3+0x144>
  8028b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028bb:	29 f2                	sub    %esi,%edx
  8028bd:	19 cb                	sbb    %ecx,%ebx
  8028bf:	89 d8                	mov    %ebx,%eax
  8028c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8028c5:	d3 e0                	shl    %cl,%eax
  8028c7:	89 e9                	mov    %ebp,%ecx
  8028c9:	d3 ea                	shr    %cl,%edx
  8028cb:	09 d0                	or     %edx,%eax
  8028cd:	89 e9                	mov    %ebp,%ecx
  8028cf:	d3 eb                	shr    %cl,%ebx
  8028d1:	89 da                	mov    %ebx,%edx
  8028d3:	83 c4 1c             	add    $0x1c,%esp
  8028d6:	5b                   	pop    %ebx
  8028d7:	5e                   	pop    %esi
  8028d8:	5f                   	pop    %edi
  8028d9:	5d                   	pop    %ebp
  8028da:	c3                   	ret    
  8028db:	90                   	nop
  8028dc:	89 fd                	mov    %edi,%ebp
  8028de:	85 ff                	test   %edi,%edi
  8028e0:	75 0b                	jne    8028ed <__umoddi3+0xe9>
  8028e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028e7:	31 d2                	xor    %edx,%edx
  8028e9:	f7 f7                	div    %edi
  8028eb:	89 c5                	mov    %eax,%ebp
  8028ed:	89 f0                	mov    %esi,%eax
  8028ef:	31 d2                	xor    %edx,%edx
  8028f1:	f7 f5                	div    %ebp
  8028f3:	89 c8                	mov    %ecx,%eax
  8028f5:	f7 f5                	div    %ebp
  8028f7:	89 d0                	mov    %edx,%eax
  8028f9:	e9 44 ff ff ff       	jmp    802842 <__umoddi3+0x3e>
  8028fe:	66 90                	xchg   %ax,%ax
  802900:	89 c8                	mov    %ecx,%eax
  802902:	89 f2                	mov    %esi,%edx
  802904:	83 c4 1c             	add    $0x1c,%esp
  802907:	5b                   	pop    %ebx
  802908:	5e                   	pop    %esi
  802909:	5f                   	pop    %edi
  80290a:	5d                   	pop    %ebp
  80290b:	c3                   	ret    
  80290c:	3b 04 24             	cmp    (%esp),%eax
  80290f:	72 06                	jb     802917 <__umoddi3+0x113>
  802911:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802915:	77 0f                	ja     802926 <__umoddi3+0x122>
  802917:	89 f2                	mov    %esi,%edx
  802919:	29 f9                	sub    %edi,%ecx
  80291b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80291f:	89 14 24             	mov    %edx,(%esp)
  802922:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802926:	8b 44 24 04          	mov    0x4(%esp),%eax
  80292a:	8b 14 24             	mov    (%esp),%edx
  80292d:	83 c4 1c             	add    $0x1c,%esp
  802930:	5b                   	pop    %ebx
  802931:	5e                   	pop    %esi
  802932:	5f                   	pop    %edi
  802933:	5d                   	pop    %ebp
  802934:	c3                   	ret    
  802935:	8d 76 00             	lea    0x0(%esi),%esi
  802938:	2b 04 24             	sub    (%esp),%eax
  80293b:	19 fa                	sbb    %edi,%edx
  80293d:	89 d1                	mov    %edx,%ecx
  80293f:	89 c6                	mov    %eax,%esi
  802941:	e9 71 ff ff ff       	jmp    8028b7 <__umoddi3+0xb3>
  802946:	66 90                	xchg   %ax,%ax
  802948:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80294c:	72 ea                	jb     802938 <__umoddi3+0x134>
  80294e:	89 d9                	mov    %ebx,%ecx
  802950:	e9 62 ff ff ff       	jmp    8028b7 <__umoddi3+0xb3>
