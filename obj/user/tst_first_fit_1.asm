
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
  800031:	e8 c4 0b 00 00       	call   800bfa <libmain>
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
  800045:	e8 68 24 00 00       	call   8024b2 <sys_set_uheap_strategy>
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
  80005a:	a1 20 30 80 00       	mov    0x803020,%eax
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
  800083:	a1 20 30 80 00       	mov    0x803020,%eax
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
  80009b:	68 80 27 80 00       	push   $0x802780
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 9c 27 80 00       	push   $0x80279c
  8000a7:	e8 8a 0c 00 00       	call   800d36 <_panic>
	}

	int Mega = 1024*1024;
  8000ac:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b3:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	6a 00                	push   $0x0
  8000bf:	e8 ca 1c 00 00       	call   801d8e <malloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 c0 1e 00 00       	call   801f9d <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 58 1f 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000eb:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	50                   	push   %eax
  8000f2:	e8 97 1c 00 00       	call   801d8e <malloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8000fd:	8b 45 90             	mov    -0x70(%ebp),%eax
  800100:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800105:	74 14                	je     80011b <_main+0xe3>
  800107:	83 ec 04             	sub    $0x4,%esp
  80010a:	68 b4 27 80 00       	push   $0x8027b4
  80010f:	6a 26                	push   $0x26
  800111:	68 9c 27 80 00       	push   $0x80279c
  800116:	e8 1b 0c 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80011b:	e8 1d 1f 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800120:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800123:	3d 00 01 00 00       	cmp    $0x100,%eax
  800128:	74 14                	je     80013e <_main+0x106>
  80012a:	83 ec 04             	sub    $0x4,%esp
  80012d:	68 e4 27 80 00       	push   $0x8027e4
  800132:	6a 28                	push   $0x28
  800134:	68 9c 27 80 00       	push   $0x80279c
  800139:	e8 f8 0b 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  80013e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800141:	e8 57 1e 00 00       	call   801f9d <sys_calculate_free_frames>
  800146:	29 c3                	sub    %eax,%ebx
  800148:	89 d8                	mov    %ebx,%eax
  80014a:	83 f8 01             	cmp    $0x1,%eax
  80014d:	74 14                	je     800163 <_main+0x12b>
  80014f:	83 ec 04             	sub    $0x4,%esp
  800152:	68 01 28 80 00       	push   $0x802801
  800157:	6a 29                	push   $0x29
  800159:	68 9c 27 80 00       	push   $0x80279c
  80015e:	e8 d3 0b 00 00       	call   800d36 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800163:	e8 35 1e 00 00       	call   801f9d <sys_calculate_free_frames>
  800168:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80016b:	e8 cd 1e 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800170:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800176:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	50                   	push   %eax
  80017d:	e8 0c 1c 00 00       	call   801d8e <malloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800188:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80018b:	89 c2                	mov    %eax,%edx
  80018d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800190:	05 00 00 00 80       	add    $0x80000000,%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 b4 27 80 00       	push   $0x8027b4
  8001a1:	6a 2f                	push   $0x2f
  8001a3:	68 9c 27 80 00       	push   $0x80279c
  8001a8:	e8 89 0b 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8001ad:	e8 8b 1e 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8001b2:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001b5:	3d 00 01 00 00       	cmp    $0x100,%eax
  8001ba:	74 14                	je     8001d0 <_main+0x198>
  8001bc:	83 ec 04             	sub    $0x4,%esp
  8001bf:	68 e4 27 80 00       	push   $0x8027e4
  8001c4:	6a 31                	push   $0x31
  8001c6:	68 9c 27 80 00       	push   $0x80279c
  8001cb:	e8 66 0b 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001d0:	e8 c8 1d 00 00       	call   801f9d <sys_calculate_free_frames>
  8001d5:	89 c2                	mov    %eax,%edx
  8001d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001da:	39 c2                	cmp    %eax,%edx
  8001dc:	74 14                	je     8001f2 <_main+0x1ba>
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 01 28 80 00       	push   $0x802801
  8001e6:	6a 32                	push   $0x32
  8001e8:	68 9c 27 80 00       	push   $0x80279c
  8001ed:	e8 44 0b 00 00       	call   800d36 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f2:	e8 a6 1d 00 00       	call   801f9d <sys_calculate_free_frames>
  8001f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fa:	e8 3e 1e 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8001ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800205:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	50                   	push   %eax
  80020c:	e8 7d 1b 00 00       	call   801d8e <malloc>
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800217:	8b 45 98             	mov    -0x68(%ebp),%eax
  80021a:	89 c2                	mov    %eax,%edx
  80021c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021f:	01 c0                	add    %eax,%eax
  800221:	05 00 00 00 80       	add    $0x80000000,%eax
  800226:	39 c2                	cmp    %eax,%edx
  800228:	74 14                	je     80023e <_main+0x206>
  80022a:	83 ec 04             	sub    $0x4,%esp
  80022d:	68 b4 27 80 00       	push   $0x8027b4
  800232:	6a 38                	push   $0x38
  800234:	68 9c 27 80 00       	push   $0x80279c
  800239:	e8 f8 0a 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80023e:	e8 fa 1d 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800243:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800246:	3d 00 01 00 00       	cmp    $0x100,%eax
  80024b:	74 14                	je     800261 <_main+0x229>
  80024d:	83 ec 04             	sub    $0x4,%esp
  800250:	68 e4 27 80 00       	push   $0x8027e4
  800255:	6a 3a                	push   $0x3a
  800257:	68 9c 27 80 00       	push   $0x80279c
  80025c:	e8 d5 0a 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800261:	e8 37 1d 00 00       	call   801f9d <sys_calculate_free_frames>
  800266:	89 c2                	mov    %eax,%edx
  800268:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80026b:	39 c2                	cmp    %eax,%edx
  80026d:	74 14                	je     800283 <_main+0x24b>
  80026f:	83 ec 04             	sub    $0x4,%esp
  800272:	68 01 28 80 00       	push   $0x802801
  800277:	6a 3b                	push   $0x3b
  800279:	68 9c 27 80 00       	push   $0x80279c
  80027e:	e8 b3 0a 00 00       	call   800d36 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800283:	e8 15 1d 00 00       	call   801f9d <sys_calculate_free_frames>
  800288:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80028b:	e8 ad 1d 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800290:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800293:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800296:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	50                   	push   %eax
  80029d:	e8 ec 1a 00 00       	call   801d8e <malloc>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8002a8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002ab:	89 c1                	mov    %eax,%ecx
  8002ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b0:	89 c2                	mov    %eax,%edx
  8002b2:	01 d2                	add    %edx,%edx
  8002b4:	01 d0                	add    %edx,%eax
  8002b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8002bb:	39 c1                	cmp    %eax,%ecx
  8002bd:	74 14                	je     8002d3 <_main+0x29b>
  8002bf:	83 ec 04             	sub    $0x4,%esp
  8002c2:	68 b4 27 80 00       	push   $0x8027b4
  8002c7:	6a 41                	push   $0x41
  8002c9:	68 9c 27 80 00       	push   $0x80279c
  8002ce:	e8 63 0a 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8002d3:	e8 65 1d 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8002d8:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002db:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002e0:	74 14                	je     8002f6 <_main+0x2be>
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	68 e4 27 80 00       	push   $0x8027e4
  8002ea:	6a 43                	push   $0x43
  8002ec:	68 9c 27 80 00       	push   $0x80279c
  8002f1:	e8 40 0a 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002f6:	e8 a2 1c 00 00       	call   801f9d <sys_calculate_free_frames>
  8002fb:	89 c2                	mov    %eax,%edx
  8002fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800300:	39 c2                	cmp    %eax,%edx
  800302:	74 14                	je     800318 <_main+0x2e0>
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	68 01 28 80 00       	push   $0x802801
  80030c:	6a 44                	push   $0x44
  80030e:	68 9c 27 80 00       	push   $0x80279c
  800313:	e8 1e 0a 00 00       	call   800d36 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800318:	e8 80 1c 00 00       	call   801f9d <sys_calculate_free_frames>
  80031d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800320:	e8 18 1d 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800325:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800328:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032b:	01 c0                	add    %eax,%eax
  80032d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	50                   	push   %eax
  800334:	e8 55 1a 00 00       	call   801d8e <malloc>
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  80033f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800342:	89 c2                	mov    %eax,%edx
  800344:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800347:	c1 e0 02             	shl    $0x2,%eax
  80034a:	05 00 00 00 80       	add    $0x80000000,%eax
  80034f:	39 c2                	cmp    %eax,%edx
  800351:	74 14                	je     800367 <_main+0x32f>
  800353:	83 ec 04             	sub    $0x4,%esp
  800356:	68 b4 27 80 00       	push   $0x8027b4
  80035b:	6a 4a                	push   $0x4a
  80035d:	68 9c 27 80 00       	push   $0x80279c
  800362:	e8 cf 09 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800367:	e8 d1 1c 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  80036c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036f:	3d 00 02 00 00       	cmp    $0x200,%eax
  800374:	74 14                	je     80038a <_main+0x352>
  800376:	83 ec 04             	sub    $0x4,%esp
  800379:	68 e4 27 80 00       	push   $0x8027e4
  80037e:	6a 4c                	push   $0x4c
  800380:	68 9c 27 80 00       	push   $0x80279c
  800385:	e8 ac 09 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80038a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80038d:	e8 0b 1c 00 00       	call   801f9d <sys_calculate_free_frames>
  800392:	29 c3                	sub    %eax,%ebx
  800394:	89 d8                	mov    %ebx,%eax
  800396:	83 f8 01             	cmp    $0x1,%eax
  800399:	74 14                	je     8003af <_main+0x377>
  80039b:	83 ec 04             	sub    $0x4,%esp
  80039e:	68 01 28 80 00       	push   $0x802801
  8003a3:	6a 4d                	push   $0x4d
  8003a5:	68 9c 27 80 00       	push   $0x80279c
  8003aa:	e8 87 09 00 00       	call   800d36 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003af:	e8 e9 1b 00 00       	call   801f9d <sys_calculate_free_frames>
  8003b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b7:	e8 81 1c 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8003bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  8003bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003c2:	01 c0                	add    %eax,%eax
  8003c4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003c7:	83 ec 0c             	sub    $0xc,%esp
  8003ca:	50                   	push   %eax
  8003cb:	e8 be 19 00 00       	call   801d8e <malloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  8003d6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d9:	89 c1                	mov    %eax,%ecx
  8003db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003de:	89 d0                	mov    %edx,%eax
  8003e0:	01 c0                	add    %eax,%eax
  8003e2:	01 d0                	add    %edx,%eax
  8003e4:	01 c0                	add    %eax,%eax
  8003e6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003eb:	39 c1                	cmp    %eax,%ecx
  8003ed:	74 14                	je     800403 <_main+0x3cb>
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	68 b4 27 80 00       	push   $0x8027b4
  8003f7:	6a 53                	push   $0x53
  8003f9:	68 9c 27 80 00       	push   $0x80279c
  8003fe:	e8 33 09 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800403:	e8 35 1c 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800408:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80040b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800410:	74 14                	je     800426 <_main+0x3ee>
  800412:	83 ec 04             	sub    $0x4,%esp
  800415:	68 e4 27 80 00       	push   $0x8027e4
  80041a:	6a 55                	push   $0x55
  80041c:	68 9c 27 80 00       	push   $0x80279c
  800421:	e8 10 09 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800426:	e8 72 1b 00 00       	call   801f9d <sys_calculate_free_frames>
  80042b:	89 c2                	mov    %eax,%edx
  80042d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800430:	39 c2                	cmp    %eax,%edx
  800432:	74 14                	je     800448 <_main+0x410>
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	68 01 28 80 00       	push   $0x802801
  80043c:	6a 56                	push   $0x56
  80043e:	68 9c 27 80 00       	push   $0x80279c
  800443:	e8 ee 08 00 00       	call   800d36 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800448:	e8 50 1b 00 00       	call   801f9d <sys_calculate_free_frames>
  80044d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800450:	e8 e8 1b 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800455:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800458:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80045b:	89 c2                	mov    %eax,%edx
  80045d:	01 d2                	add    %edx,%edx
  80045f:	01 d0                	add    %edx,%eax
  800461:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	50                   	push   %eax
  800468:	e8 21 19 00 00       	call   801d8e <malloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800473:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800476:	89 c2                	mov    %eax,%edx
  800478:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047b:	c1 e0 03             	shl    $0x3,%eax
  80047e:	05 00 00 00 80       	add    $0x80000000,%eax
  800483:	39 c2                	cmp    %eax,%edx
  800485:	74 14                	je     80049b <_main+0x463>
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	68 b4 27 80 00       	push   $0x8027b4
  80048f:	6a 5c                	push   $0x5c
  800491:	68 9c 27 80 00       	push   $0x80279c
  800496:	e8 9b 08 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  768) panic("Wrong page file allocation: ");
  80049b:	e8 9d 1b 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8004a0:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004a3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 e4 27 80 00       	push   $0x8027e4
  8004b2:	6a 5e                	push   $0x5e
  8004b4:	68 9c 27 80 00       	push   $0x80279c
  8004b9:	e8 78 08 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004be:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004c1:	e8 d7 1a 00 00       	call   801f9d <sys_calculate_free_frames>
  8004c6:	29 c3                	sub    %eax,%ebx
  8004c8:	89 d8                	mov    %ebx,%eax
  8004ca:	83 f8 01             	cmp    $0x1,%eax
  8004cd:	74 14                	je     8004e3 <_main+0x4ab>
  8004cf:	83 ec 04             	sub    $0x4,%esp
  8004d2:	68 01 28 80 00       	push   $0x802801
  8004d7:	6a 5f                	push   $0x5f
  8004d9:	68 9c 27 80 00       	push   $0x80279c
  8004de:	e8 53 08 00 00       	call   800d36 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004e3:	e8 b5 1a 00 00       	call   801f9d <sys_calculate_free_frames>
  8004e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004eb:	e8 4d 1b 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8004f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004f6:	89 c2                	mov    %eax,%edx
  8004f8:	01 d2                	add    %edx,%edx
  8004fa:	01 d0                	add    %edx,%eax
  8004fc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004ff:	83 ec 0c             	sub    $0xc,%esp
  800502:	50                   	push   %eax
  800503:	e8 86 18 00 00       	call   801d8e <malloc>
  800508:	83 c4 10             	add    $0x10,%esp
  80050b:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  80050e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800511:	89 c1                	mov    %eax,%ecx
  800513:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800516:	89 d0                	mov    %edx,%eax
  800518:	c1 e0 02             	shl    $0x2,%eax
  80051b:	01 d0                	add    %edx,%eax
  80051d:	01 c0                	add    %eax,%eax
  80051f:	01 d0                	add    %edx,%eax
  800521:	05 00 00 00 80       	add    $0x80000000,%eax
  800526:	39 c1                	cmp    %eax,%ecx
  800528:	74 14                	je     80053e <_main+0x506>
  80052a:	83 ec 04             	sub    $0x4,%esp
  80052d:	68 b4 27 80 00       	push   $0x8027b4
  800532:	6a 65                	push   $0x65
  800534:	68 9c 27 80 00       	push   $0x80279c
  800539:	e8 f8 07 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  768) panic("Wrong page file allocation: ");
  80053e:	e8 fa 1a 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800543:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800546:	3d 00 03 00 00       	cmp    $0x300,%eax
  80054b:	74 14                	je     800561 <_main+0x529>
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	68 e4 27 80 00       	push   $0x8027e4
  800555:	6a 67                	push   $0x67
  800557:	68 9c 27 80 00       	push   $0x80279c
  80055c:	e8 d5 07 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  800561:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800564:	e8 34 1a 00 00       	call   801f9d <sys_calculate_free_frames>
  800569:	29 c3                	sub    %eax,%ebx
  80056b:	89 d8                	mov    %ebx,%eax
  80056d:	83 f8 01             	cmp    $0x1,%eax
  800570:	74 14                	je     800586 <_main+0x54e>
  800572:	83 ec 04             	sub    $0x4,%esp
  800575:	68 01 28 80 00       	push   $0x802801
  80057a:	6a 68                	push   $0x68
  80057c:	68 9c 27 80 00       	push   $0x80279c
  800581:	e8 b0 07 00 00       	call   800d36 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800586:	e8 12 1a 00 00       	call   801f9d <sys_calculate_free_frames>
  80058b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80058e:	e8 aa 1a 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800593:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800596:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800599:	83 ec 0c             	sub    $0xc,%esp
  80059c:	50                   	push   %eax
  80059d:	e8 2d 18 00 00       	call   801dcf <free>
  8005a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  8005a5:	e8 93 1a 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8005aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ad:	29 c2                	sub    %eax,%edx
  8005af:	89 d0                	mov    %edx,%eax
  8005b1:	3d 00 01 00 00       	cmp    $0x100,%eax
  8005b6:	74 14                	je     8005cc <_main+0x594>
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 14 28 80 00       	push   $0x802814
  8005c0:	6a 72                	push   $0x72
  8005c2:	68 9c 27 80 00       	push   $0x80279c
  8005c7:	e8 6a 07 00 00       	call   800d36 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005cc:	e8 cc 19 00 00       	call   801f9d <sys_calculate_free_frames>
  8005d1:	89 c2                	mov    %eax,%edx
  8005d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005d6:	39 c2                	cmp    %eax,%edx
  8005d8:	74 14                	je     8005ee <_main+0x5b6>
  8005da:	83 ec 04             	sub    $0x4,%esp
  8005dd:	68 2b 28 80 00       	push   $0x80282b
  8005e2:	6a 73                	push   $0x73
  8005e4:	68 9c 27 80 00       	push   $0x80279c
  8005e9:	e8 48 07 00 00       	call   800d36 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005ee:	e8 aa 19 00 00       	call   801f9d <sys_calculate_free_frames>
  8005f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005f6:	e8 42 1a 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8005fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005fe:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800601:	83 ec 0c             	sub    $0xc,%esp
  800604:	50                   	push   %eax
  800605:	e8 c5 17 00 00       	call   801dcf <free>
  80060a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  512) panic("Wrong page file free: ");
  80060d:	e8 2b 1a 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800612:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800615:	29 c2                	sub    %eax,%edx
  800617:	89 d0                	mov    %edx,%eax
  800619:	3d 00 02 00 00       	cmp    $0x200,%eax
  80061e:	74 14                	je     800634 <_main+0x5fc>
  800620:	83 ec 04             	sub    $0x4,%esp
  800623:	68 14 28 80 00       	push   $0x802814
  800628:	6a 7a                	push   $0x7a
  80062a:	68 9c 27 80 00       	push   $0x80279c
  80062f:	e8 02 07 00 00       	call   800d36 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800634:	e8 64 19 00 00       	call   801f9d <sys_calculate_free_frames>
  800639:	89 c2                	mov    %eax,%edx
  80063b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80063e:	39 c2                	cmp    %eax,%edx
  800640:	74 14                	je     800656 <_main+0x61e>
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	68 2b 28 80 00       	push   $0x80282b
  80064a:	6a 7b                	push   $0x7b
  80064c:	68 9c 27 80 00       	push   $0x80279c
  800651:	e8 e0 06 00 00       	call   800d36 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800656:	e8 42 19 00 00       	call   801f9d <sys_calculate_free_frames>
  80065b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80065e:	e8 da 19 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800663:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  800666:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800669:	83 ec 0c             	sub    $0xc,%esp
  80066c:	50                   	push   %eax
  80066d:	e8 5d 17 00 00       	call   801dcf <free>
  800672:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  800675:	e8 c3 19 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  80067a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067d:	29 c2                	sub    %eax,%edx
  80067f:	89 d0                	mov    %edx,%eax
  800681:	3d 00 03 00 00       	cmp    $0x300,%eax
  800686:	74 17                	je     80069f <_main+0x667>
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	68 14 28 80 00       	push   $0x802814
  800690:	68 82 00 00 00       	push   $0x82
  800695:	68 9c 27 80 00       	push   $0x80279c
  80069a:	e8 97 06 00 00       	call   800d36 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80069f:	e8 f9 18 00 00       	call   801f9d <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 2b 28 80 00       	push   $0x80282b
  8006b5:	68 83 00 00 00       	push   $0x83
  8006ba:	68 9c 27 80 00       	push   $0x80279c
  8006bf:	e8 72 06 00 00       	call   800d36 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 d4 18 00 00       	call   801f9d <sys_calculate_free_frames>
  8006c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 6c 19 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8006d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006d7:	89 d0                	mov    %edx,%eax
  8006d9:	c1 e0 09             	shl    $0x9,%eax
  8006dc:	29 d0                	sub    %edx,%eax
  8006de:	83 ec 0c             	sub    $0xc,%esp
  8006e1:	50                   	push   %eax
  8006e2:	e8 a7 16 00 00       	call   801d8e <malloc>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8006ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006f5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006fa:	39 c2                	cmp    %eax,%edx
  8006fc:	74 17                	je     800715 <_main+0x6dd>
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	68 b4 27 80 00       	push   $0x8027b4
  800706:	68 8c 00 00 00       	push   $0x8c
  80070b:	68 9c 27 80 00       	push   $0x80279c
  800710:	e8 21 06 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800715:	e8 23 19 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  80071a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80071d:	3d 80 00 00 00       	cmp    $0x80,%eax
  800722:	74 17                	je     80073b <_main+0x703>
  800724:	83 ec 04             	sub    $0x4,%esp
  800727:	68 e4 27 80 00       	push   $0x8027e4
  80072c:	68 8e 00 00 00       	push   $0x8e
  800731:	68 9c 27 80 00       	push   $0x80279c
  800736:	e8 fb 05 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80073b:	e8 5d 18 00 00       	call   801f9d <sys_calculate_free_frames>
  800740:	89 c2                	mov    %eax,%edx
  800742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800745:	39 c2                	cmp    %eax,%edx
  800747:	74 17                	je     800760 <_main+0x728>
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	68 01 28 80 00       	push   $0x802801
  800751:	68 8f 00 00 00       	push   $0x8f
  800756:	68 9c 27 80 00       	push   $0x80279c
  80075b:	e8 d6 05 00 00       	call   800d36 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800760:	e8 38 18 00 00       	call   801f9d <sys_calculate_free_frames>
  800765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800768:	e8 d0 18 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  80076d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  800770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800773:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800776:	83 ec 0c             	sub    $0xc,%esp
  800779:	50                   	push   %eax
  80077a:	e8 0f 16 00 00       	call   801d8e <malloc>
  80077f:	83 c4 10             	add    $0x10,%esp
  800782:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800785:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800788:	89 c2                	mov    %eax,%edx
  80078a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078d:	c1 e0 02             	shl    $0x2,%eax
  800790:	05 00 00 00 80       	add    $0x80000000,%eax
  800795:	39 c2                	cmp    %eax,%edx
  800797:	74 17                	je     8007b0 <_main+0x778>
  800799:	83 ec 04             	sub    $0x4,%esp
  80079c:	68 b4 27 80 00       	push   $0x8027b4
  8007a1:	68 95 00 00 00       	push   $0x95
  8007a6:	68 9c 27 80 00       	push   $0x80279c
  8007ab:	e8 86 05 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007b0:	e8 88 18 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8007b5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007b8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 e4 27 80 00       	push   $0x8027e4
  8007c7:	68 97 00 00 00       	push   $0x97
  8007cc:	68 9c 27 80 00       	push   $0x80279c
  8007d1:	e8 60 05 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007d6:	e8 c2 17 00 00       	call   801f9d <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 01 28 80 00       	push   $0x802801
  8007ec:	68 98 00 00 00       	push   $0x98
  8007f1:	68 9c 27 80 00       	push   $0x80279c
  8007f6:	e8 3b 05 00 00       	call   800d36 <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007fb:	e8 9d 17 00 00       	call   801f9d <sys_calculate_free_frames>
  800800:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800803:	e8 35 18 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800808:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  80080b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80080e:	89 d0                	mov    %edx,%eax
  800810:	c1 e0 08             	shl    $0x8,%eax
  800813:	29 d0                	sub    %edx,%eax
  800815:	83 ec 0c             	sub    $0xc,%esp
  800818:	50                   	push   %eax
  800819:	e8 70 15 00 00       	call   801d8e <malloc>
  80081e:	83 c4 10             	add    $0x10,%esp
  800821:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800824:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800827:	89 c2                	mov    %eax,%edx
  800829:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80082c:	c1 e0 09             	shl    $0x9,%eax
  80082f:	89 c1                	mov    %eax,%ecx
  800831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800834:	01 c8                	add    %ecx,%eax
  800836:	05 00 00 00 80       	add    $0x80000000,%eax
  80083b:	39 c2                	cmp    %eax,%edx
  80083d:	74 17                	je     800856 <_main+0x81e>
  80083f:	83 ec 04             	sub    $0x4,%esp
  800842:	68 b4 27 80 00       	push   $0x8027b4
  800847:	68 9e 00 00 00       	push   $0x9e
  80084c:	68 9c 27 80 00       	push   $0x80279c
  800851:	e8 e0 04 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800856:	e8 e2 17 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  80085b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80085e:	83 f8 40             	cmp    $0x40,%eax
  800861:	74 17                	je     80087a <_main+0x842>
  800863:	83 ec 04             	sub    $0x4,%esp
  800866:	68 e4 27 80 00       	push   $0x8027e4
  80086b:	68 a0 00 00 00       	push   $0xa0
  800870:	68 9c 27 80 00       	push   $0x80279c
  800875:	e8 bc 04 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80087a:	e8 1e 17 00 00       	call   801f9d <sys_calculate_free_frames>
  80087f:	89 c2                	mov    %eax,%edx
  800881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800884:	39 c2                	cmp    %eax,%edx
  800886:	74 17                	je     80089f <_main+0x867>
  800888:	83 ec 04             	sub    $0x4,%esp
  80088b:	68 01 28 80 00       	push   $0x802801
  800890:	68 a1 00 00 00       	push   $0xa1
  800895:	68 9c 27 80 00       	push   $0x80279c
  80089a:	e8 97 04 00 00       	call   800d36 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80089f:	e8 f9 16 00 00       	call   801f9d <sys_calculate_free_frames>
  8008a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a7:	e8 91 17 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8008ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  8008af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b2:	01 c0                	add    %eax,%eax
  8008b4:	83 ec 0c             	sub    $0xc,%esp
  8008b7:	50                   	push   %eax
  8008b8:	e8 d1 14 00 00       	call   801d8e <malloc>
  8008bd:	83 c4 10             	add    $0x10,%esp
  8008c0:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8008c3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008c6:	89 c2                	mov    %eax,%edx
  8008c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cb:	c1 e0 03             	shl    $0x3,%eax
  8008ce:	05 00 00 00 80       	add    $0x80000000,%eax
  8008d3:	39 c2                	cmp    %eax,%edx
  8008d5:	74 17                	je     8008ee <_main+0x8b6>
  8008d7:	83 ec 04             	sub    $0x4,%esp
  8008da:	68 b4 27 80 00       	push   $0x8027b4
  8008df:	68 a7 00 00 00       	push   $0xa7
  8008e4:	68 9c 27 80 00       	push   $0x80279c
  8008e9:	e8 48 04 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8008ee:	e8 4a 17 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8008f3:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008f6:	3d 00 02 00 00       	cmp    $0x200,%eax
  8008fb:	74 17                	je     800914 <_main+0x8dc>
  8008fd:	83 ec 04             	sub    $0x4,%esp
  800900:	68 e4 27 80 00       	push   $0x8027e4
  800905:	68 a9 00 00 00       	push   $0xa9
  80090a:	68 9c 27 80 00       	push   $0x80279c
  80090f:	e8 22 04 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800914:	e8 84 16 00 00       	call   801f9d <sys_calculate_free_frames>
  800919:	89 c2                	mov    %eax,%edx
  80091b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80091e:	39 c2                	cmp    %eax,%edx
  800920:	74 17                	je     800939 <_main+0x901>
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	68 01 28 80 00       	push   $0x802801
  80092a:	68 aa 00 00 00       	push   $0xaa
  80092f:	68 9c 27 80 00       	push   $0x80279c
  800934:	e8 fd 03 00 00       	call   800d36 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800939:	e8 5f 16 00 00       	call   801f9d <sys_calculate_free_frames>
  80093e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800941:	e8 f7 16 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800946:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  800949:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80094c:	c1 e0 02             	shl    $0x2,%eax
  80094f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800952:	83 ec 0c             	sub    $0xc,%esp
  800955:	50                   	push   %eax
  800956:	e8 33 14 00 00       	call   801d8e <malloc>
  80095b:	83 c4 10             	add    $0x10,%esp
  80095e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  800961:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800964:	89 c1                	mov    %eax,%ecx
  800966:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800969:	89 d0                	mov    %edx,%eax
  80096b:	01 c0                	add    %eax,%eax
  80096d:	01 d0                	add    %edx,%eax
  80096f:	01 c0                	add    %eax,%eax
  800971:	01 d0                	add    %edx,%eax
  800973:	01 c0                	add    %eax,%eax
  800975:	05 00 00 00 80       	add    $0x80000000,%eax
  80097a:	39 c1                	cmp    %eax,%ecx
  80097c:	74 17                	je     800995 <_main+0x95d>
  80097e:	83 ec 04             	sub    $0x4,%esp
  800981:	68 b4 27 80 00       	push   $0x8027b4
  800986:	68 b0 00 00 00       	push   $0xb0
  80098b:	68 9c 27 80 00       	push   $0x80279c
  800990:	e8 a1 03 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800995:	e8 a3 16 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  80099a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80099d:	3d 00 04 00 00       	cmp    $0x400,%eax
  8009a2:	74 17                	je     8009bb <_main+0x983>
  8009a4:	83 ec 04             	sub    $0x4,%esp
  8009a7:	68 e4 27 80 00       	push   $0x8027e4
  8009ac:	68 b2 00 00 00       	push   $0xb2
  8009b1:	68 9c 27 80 00       	push   $0x80279c
  8009b6:	e8 7b 03 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8009bb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8009be:	e8 da 15 00 00       	call   801f9d <sys_calculate_free_frames>
  8009c3:	29 c3                	sub    %eax,%ebx
  8009c5:	89 d8                	mov    %ebx,%eax
  8009c7:	83 f8 01             	cmp    $0x1,%eax
  8009ca:	74 17                	je     8009e3 <_main+0x9ab>
  8009cc:	83 ec 04             	sub    $0x4,%esp
  8009cf:	68 01 28 80 00       	push   $0x802801
  8009d4:	68 b3 00 00 00       	push   $0xb3
  8009d9:	68 9c 27 80 00       	push   $0x80279c
  8009de:	e8 53 03 00 00       	call   800d36 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009e3:	e8 b5 15 00 00       	call   801f9d <sys_calculate_free_frames>
  8009e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009eb:	e8 4d 16 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  8009f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8009f3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8009f6:	83 ec 0c             	sub    $0xc,%esp
  8009f9:	50                   	push   %eax
  8009fa:	e8 d0 13 00 00       	call   801dcf <free>
  8009ff:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800a02:	e8 36 16 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800a07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0a:	29 c2                	sub    %eax,%edx
  800a0c:	89 d0                	mov    %edx,%eax
  800a0e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800a13:	74 17                	je     800a2c <_main+0x9f4>
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	68 14 28 80 00       	push   $0x802814
  800a1d:	68 bd 00 00 00       	push   $0xbd
  800a22:	68 9c 27 80 00       	push   $0x80279c
  800a27:	e8 0a 03 00 00       	call   800d36 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2c:	e8 6c 15 00 00       	call   801f9d <sys_calculate_free_frames>
  800a31:	89 c2                	mov    %eax,%edx
  800a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a36:	39 c2                	cmp    %eax,%edx
  800a38:	74 17                	je     800a51 <_main+0xa19>
  800a3a:	83 ec 04             	sub    $0x4,%esp
  800a3d:	68 2b 28 80 00       	push   $0x80282b
  800a42:	68 be 00 00 00       	push   $0xbe
  800a47:	68 9c 27 80 00       	push   $0x80279c
  800a4c:	e8 e5 02 00 00       	call   800d36 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a51:	e8 47 15 00 00       	call   801f9d <sys_calculate_free_frames>
  800a56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a59:	e8 df 15 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800a5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  800a61:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800a64:	83 ec 0c             	sub    $0xc,%esp
  800a67:	50                   	push   %eax
  800a68:	e8 62 13 00 00       	call   801dcf <free>
  800a6d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800a70:	e8 c8 15 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800a75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a78:	29 c2                	sub    %eax,%edx
  800a7a:	89 d0                	mov    %edx,%eax
  800a7c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800a81:	74 17                	je     800a9a <_main+0xa62>
  800a83:	83 ec 04             	sub    $0x4,%esp
  800a86:	68 14 28 80 00       	push   $0x802814
  800a8b:	68 c5 00 00 00       	push   $0xc5
  800a90:	68 9c 27 80 00       	push   $0x80279c
  800a95:	e8 9c 02 00 00       	call   800d36 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a9a:	e8 fe 14 00 00       	call   801f9d <sys_calculate_free_frames>
  800a9f:	89 c2                	mov    %eax,%edx
  800aa1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800aa4:	39 c2                	cmp    %eax,%edx
  800aa6:	74 17                	je     800abf <_main+0xa87>
  800aa8:	83 ec 04             	sub    $0x4,%esp
  800aab:	68 2b 28 80 00       	push   $0x80282b
  800ab0:	68 c6 00 00 00       	push   $0xc6
  800ab5:	68 9c 27 80 00       	push   $0x80279c
  800aba:	e8 77 02 00 00       	call   800d36 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800abf:	e8 d9 14 00 00       	call   801f9d <sys_calculate_free_frames>
  800ac4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ac7:	e8 71 15 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800acc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800acf:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800ad2:	83 ec 0c             	sub    $0xc,%esp
  800ad5:	50                   	push   %eax
  800ad6:	e8 f4 12 00 00       	call   801dcf <free>
  800adb:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800ade:	e8 5a 15 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800ae3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ae6:	29 c2                	sub    %eax,%edx
  800ae8:	89 d0                	mov    %edx,%eax
  800aea:	3d 00 01 00 00       	cmp    $0x100,%eax
  800aef:	74 17                	je     800b08 <_main+0xad0>
  800af1:	83 ec 04             	sub    $0x4,%esp
  800af4:	68 14 28 80 00       	push   $0x802814
  800af9:	68 cd 00 00 00       	push   $0xcd
  800afe:	68 9c 27 80 00       	push   $0x80279c
  800b03:	e8 2e 02 00 00       	call   800d36 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800b08:	e8 90 14 00 00       	call   801f9d <sys_calculate_free_frames>
  800b0d:	89 c2                	mov    %eax,%edx
  800b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b12:	39 c2                	cmp    %eax,%edx
  800b14:	74 17                	je     800b2d <_main+0xaf5>
  800b16:	83 ec 04             	sub    $0x4,%esp
  800b19:	68 2b 28 80 00       	push   $0x80282b
  800b1e:	68 ce 00 00 00       	push   $0xce
  800b23:	68 9c 27 80 00       	push   $0x80279c
  800b28:	e8 09 02 00 00       	call   800d36 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800b2d:	e8 6b 14 00 00       	call   801f9d <sys_calculate_free_frames>
  800b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b35:	e8 03 15 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800b3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  800b3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b40:	c1 e0 06             	shl    $0x6,%eax
  800b43:	89 c2                	mov    %eax,%edx
  800b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b48:	01 d0                	add    %edx,%eax
  800b4a:	c1 e0 02             	shl    $0x2,%eax
  800b4d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800b50:	83 ec 0c             	sub    $0xc,%esp
  800b53:	50                   	push   %eax
  800b54:	e8 35 12 00 00       	call   801d8e <malloc>
  800b59:	83 c4 10             	add    $0x10,%esp
  800b5c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800b5f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b62:	89 c1                	mov    %eax,%ecx
  800b64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b67:	89 d0                	mov    %edx,%eax
  800b69:	01 c0                	add    %eax,%eax
  800b6b:	01 d0                	add    %edx,%eax
  800b6d:	c1 e0 08             	shl    $0x8,%eax
  800b70:	89 c2                	mov    %eax,%edx
  800b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b75:	01 d0                	add    %edx,%eax
  800b77:	05 00 00 00 80       	add    $0x80000000,%eax
  800b7c:	39 c1                	cmp    %eax,%ecx
  800b7e:	74 17                	je     800b97 <_main+0xb5f>
  800b80:	83 ec 04             	sub    $0x4,%esp
  800b83:	68 b4 27 80 00       	push   $0x8027b4
  800b88:	68 d8 00 00 00       	push   $0xd8
  800b8d:	68 9c 27 80 00       	push   $0x80279c
  800b92:	e8 9f 01 00 00       	call   800d36 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024+64) panic("Wrong page file allocation: ");
  800b97:	e8 a1 14 00 00       	call   80203d <sys_pf_calculate_allocated_pages>
  800b9c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800b9f:	3d 40 04 00 00       	cmp    $0x440,%eax
  800ba4:	74 17                	je     800bbd <_main+0xb85>
  800ba6:	83 ec 04             	sub    $0x4,%esp
  800ba9:	68 e4 27 80 00       	push   $0x8027e4
  800bae:	68 da 00 00 00       	push   $0xda
  800bb3:	68 9c 27 80 00       	push   $0x80279c
  800bb8:	e8 79 01 00 00       	call   800d36 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800bbd:	e8 db 13 00 00       	call   801f9d <sys_calculate_free_frames>
  800bc2:	89 c2                	mov    %eax,%edx
  800bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bc7:	39 c2                	cmp    %eax,%edx
  800bc9:	74 17                	je     800be2 <_main+0xbaa>
  800bcb:	83 ec 04             	sub    $0x4,%esp
  800bce:	68 01 28 80 00       	push   $0x802801
  800bd3:	68 db 00 00 00       	push   $0xdb
  800bd8:	68 9c 27 80 00       	push   $0x80279c
  800bdd:	e8 54 01 00 00       	call   800d36 <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800be2:	83 ec 0c             	sub    $0xc,%esp
  800be5:	68 38 28 80 00       	push   $0x802838
  800bea:	e8 fb 03 00 00       	call   800fea <cprintf>
  800bef:	83 c4 10             	add    $0x10,%esp

	return;
  800bf2:	90                   	nop
}
  800bf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf6:	5b                   	pop    %ebx
  800bf7:	5f                   	pop    %edi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800c00:	e8 78 16 00 00       	call   80227d <sys_getenvindex>
  800c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0b:	89 d0                	mov    %edx,%eax
  800c0d:	c1 e0 03             	shl    $0x3,%eax
  800c10:	01 d0                	add    %edx,%eax
  800c12:	01 c0                	add    %eax,%eax
  800c14:	01 d0                	add    %edx,%eax
  800c16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c1d:	01 d0                	add    %edx,%eax
  800c1f:	c1 e0 04             	shl    $0x4,%eax
  800c22:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800c27:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c2c:	a1 20 30 80 00       	mov    0x803020,%eax
  800c31:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800c37:	84 c0                	test   %al,%al
  800c39:	74 0f                	je     800c4a <libmain+0x50>
		binaryname = myEnv->prog_name;
  800c3b:	a1 20 30 80 00       	mov    0x803020,%eax
  800c40:	05 5c 05 00 00       	add    $0x55c,%eax
  800c45:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c4e:	7e 0a                	jle    800c5a <libmain+0x60>
		binaryname = argv[0];
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8b 00                	mov    (%eax),%eax
  800c55:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800c5a:	83 ec 08             	sub    $0x8,%esp
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	ff 75 08             	pushl  0x8(%ebp)
  800c63:	e8 d0 f3 ff ff       	call   800038 <_main>
  800c68:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800c6b:	e8 1a 14 00 00       	call   80208a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c70:	83 ec 0c             	sub    $0xc,%esp
  800c73:	68 9c 28 80 00       	push   $0x80289c
  800c78:	e8 6d 03 00 00       	call   800fea <cprintf>
  800c7d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c80:	a1 20 30 80 00       	mov    0x803020,%eax
  800c85:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800c8b:	a1 20 30 80 00       	mov    0x803020,%eax
  800c90:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c96:	83 ec 04             	sub    $0x4,%esp
  800c99:	52                   	push   %edx
  800c9a:	50                   	push   %eax
  800c9b:	68 c4 28 80 00       	push   $0x8028c4
  800ca0:	e8 45 03 00 00       	call   800fea <cprintf>
  800ca5:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800ca8:	a1 20 30 80 00       	mov    0x803020,%eax
  800cad:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800cb3:	a1 20 30 80 00       	mov    0x803020,%eax
  800cb8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800cbe:	a1 20 30 80 00       	mov    0x803020,%eax
  800cc3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800cc9:	51                   	push   %ecx
  800cca:	52                   	push   %edx
  800ccb:	50                   	push   %eax
  800ccc:	68 ec 28 80 00       	push   $0x8028ec
  800cd1:	e8 14 03 00 00       	call   800fea <cprintf>
  800cd6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800cd9:	a1 20 30 80 00       	mov    0x803020,%eax
  800cde:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	50                   	push   %eax
  800ce8:	68 44 29 80 00       	push   $0x802944
  800ced:	e8 f8 02 00 00       	call   800fea <cprintf>
  800cf2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800cf5:	83 ec 0c             	sub    $0xc,%esp
  800cf8:	68 9c 28 80 00       	push   $0x80289c
  800cfd:	e8 e8 02 00 00       	call   800fea <cprintf>
  800d02:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800d05:	e8 9a 13 00 00       	call   8020a4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800d0a:	e8 19 00 00 00       	call   800d28 <exit>
}
  800d0f:	90                   	nop
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800d18:	83 ec 0c             	sub    $0xc,%esp
  800d1b:	6a 00                	push   $0x0
  800d1d:	e8 27 15 00 00       	call   802249 <sys_destroy_env>
  800d22:	83 c4 10             	add    $0x10,%esp
}
  800d25:	90                   	nop
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <exit>:

void
exit(void)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800d2e:	e8 7c 15 00 00       	call   8022af <sys_exit_env>
}
  800d33:	90                   	nop
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d3c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d3f:	83 c0 04             	add    $0x4,%eax
  800d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d45:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800d4a:	85 c0                	test   %eax,%eax
  800d4c:	74 16                	je     800d64 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d4e:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800d53:	83 ec 08             	sub    $0x8,%esp
  800d56:	50                   	push   %eax
  800d57:	68 58 29 80 00       	push   $0x802958
  800d5c:	e8 89 02 00 00       	call   800fea <cprintf>
  800d61:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d64:	a1 00 30 80 00       	mov    0x803000,%eax
  800d69:	ff 75 0c             	pushl  0xc(%ebp)
  800d6c:	ff 75 08             	pushl  0x8(%ebp)
  800d6f:	50                   	push   %eax
  800d70:	68 5d 29 80 00       	push   $0x80295d
  800d75:	e8 70 02 00 00       	call   800fea <cprintf>
  800d7a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800d7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d80:	83 ec 08             	sub    $0x8,%esp
  800d83:	ff 75 f4             	pushl  -0xc(%ebp)
  800d86:	50                   	push   %eax
  800d87:	e8 f3 01 00 00       	call   800f7f <vcprintf>
  800d8c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d8f:	83 ec 08             	sub    $0x8,%esp
  800d92:	6a 00                	push   $0x0
  800d94:	68 79 29 80 00       	push   $0x802979
  800d99:	e8 e1 01 00 00       	call   800f7f <vcprintf>
  800d9e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800da1:	e8 82 ff ff ff       	call   800d28 <exit>

	// should not return here
	while (1) ;
  800da6:	eb fe                	jmp    800da6 <_panic+0x70>

00800da8 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800dae:	a1 20 30 80 00       	mov    0x803020,%eax
  800db3:	8b 50 74             	mov    0x74(%eax),%edx
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	39 c2                	cmp    %eax,%edx
  800dbb:	74 14                	je     800dd1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800dbd:	83 ec 04             	sub    $0x4,%esp
  800dc0:	68 7c 29 80 00       	push   $0x80297c
  800dc5:	6a 26                	push   $0x26
  800dc7:	68 c8 29 80 00       	push   $0x8029c8
  800dcc:	e8 65 ff ff ff       	call   800d36 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800dd8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ddf:	e9 c2 00 00 00       	jmp    800ea6 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	01 d0                	add    %edx,%eax
  800df3:	8b 00                	mov    (%eax),%eax
  800df5:	85 c0                	test   %eax,%eax
  800df7:	75 08                	jne    800e01 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800df9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800dfc:	e9 a2 00 00 00       	jmp    800ea3 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800e01:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e08:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e0f:	eb 69                	jmp    800e7a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e11:	a1 20 30 80 00       	mov    0x803020,%eax
  800e16:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e1f:	89 d0                	mov    %edx,%eax
  800e21:	01 c0                	add    %eax,%eax
  800e23:	01 d0                	add    %edx,%eax
  800e25:	c1 e0 03             	shl    $0x3,%eax
  800e28:	01 c8                	add    %ecx,%eax
  800e2a:	8a 40 04             	mov    0x4(%eax),%al
  800e2d:	84 c0                	test   %al,%al
  800e2f:	75 46                	jne    800e77 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e31:	a1 20 30 80 00       	mov    0x803020,%eax
  800e36:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e3f:	89 d0                	mov    %edx,%eax
  800e41:	01 c0                	add    %eax,%eax
  800e43:	01 d0                	add    %edx,%eax
  800e45:	c1 e0 03             	shl    $0x3,%eax
  800e48:	01 c8                	add    %ecx,%eax
  800e4a:	8b 00                	mov    (%eax),%eax
  800e4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e57:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	01 c8                	add    %ecx,%eax
  800e68:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e6a:	39 c2                	cmp    %eax,%edx
  800e6c:	75 09                	jne    800e77 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800e6e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e75:	eb 12                	jmp    800e89 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e77:	ff 45 e8             	incl   -0x18(%ebp)
  800e7a:	a1 20 30 80 00       	mov    0x803020,%eax
  800e7f:	8b 50 74             	mov    0x74(%eax),%edx
  800e82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e85:	39 c2                	cmp    %eax,%edx
  800e87:	77 88                	ja     800e11 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e89:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e8d:	75 14                	jne    800ea3 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e8f:	83 ec 04             	sub    $0x4,%esp
  800e92:	68 d4 29 80 00       	push   $0x8029d4
  800e97:	6a 3a                	push   $0x3a
  800e99:	68 c8 29 80 00       	push   $0x8029c8
  800e9e:	e8 93 fe ff ff       	call   800d36 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ea3:	ff 45 f0             	incl   -0x10(%ebp)
  800ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800eac:	0f 8c 32 ff ff ff    	jl     800de4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800eb2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800eb9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ec0:	eb 26                	jmp    800ee8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ec2:	a1 20 30 80 00       	mov    0x803020,%eax
  800ec7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ecd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ed0:	89 d0                	mov    %edx,%eax
  800ed2:	01 c0                	add    %eax,%eax
  800ed4:	01 d0                	add    %edx,%eax
  800ed6:	c1 e0 03             	shl    $0x3,%eax
  800ed9:	01 c8                	add    %ecx,%eax
  800edb:	8a 40 04             	mov    0x4(%eax),%al
  800ede:	3c 01                	cmp    $0x1,%al
  800ee0:	75 03                	jne    800ee5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ee2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ee5:	ff 45 e0             	incl   -0x20(%ebp)
  800ee8:	a1 20 30 80 00       	mov    0x803020,%eax
  800eed:	8b 50 74             	mov    0x74(%eax),%edx
  800ef0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ef3:	39 c2                	cmp    %eax,%edx
  800ef5:	77 cb                	ja     800ec2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800efa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800efd:	74 14                	je     800f13 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800eff:	83 ec 04             	sub    $0x4,%esp
  800f02:	68 28 2a 80 00       	push   $0x802a28
  800f07:	6a 44                	push   $0x44
  800f09:	68 c8 29 80 00       	push   $0x8029c8
  800f0e:	e8 23 fe ff ff       	call   800d36 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f13:	90                   	nop
  800f14:	c9                   	leave  
  800f15:	c3                   	ret    

00800f16 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	8d 48 01             	lea    0x1(%eax),%ecx
  800f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f27:	89 0a                	mov    %ecx,(%edx)
  800f29:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2c:	88 d1                	mov    %dl,%cl
  800f2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f31:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	8b 00                	mov    (%eax),%eax
  800f3a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f3f:	75 2c                	jne    800f6d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f41:	a0 24 30 80 00       	mov    0x803024,%al
  800f46:	0f b6 c0             	movzbl %al,%eax
  800f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4c:	8b 12                	mov    (%edx),%edx
  800f4e:	89 d1                	mov    %edx,%ecx
  800f50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f53:	83 c2 08             	add    $0x8,%edx
  800f56:	83 ec 04             	sub    $0x4,%esp
  800f59:	50                   	push   %eax
  800f5a:	51                   	push   %ecx
  800f5b:	52                   	push   %edx
  800f5c:	e8 7b 0f 00 00       	call   801edc <sys_cputs>
  800f61:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f70:	8b 40 04             	mov    0x4(%eax),%eax
  800f73:	8d 50 01             	lea    0x1(%eax),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f7c:	90                   	nop
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f88:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f8f:	00 00 00 
	b.cnt = 0;
  800f92:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f99:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f9c:	ff 75 0c             	pushl  0xc(%ebp)
  800f9f:	ff 75 08             	pushl  0x8(%ebp)
  800fa2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fa8:	50                   	push   %eax
  800fa9:	68 16 0f 80 00       	push   $0x800f16
  800fae:	e8 11 02 00 00       	call   8011c4 <vprintfmt>
  800fb3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800fb6:	a0 24 30 80 00       	mov    0x803024,%al
  800fbb:	0f b6 c0             	movzbl %al,%eax
  800fbe:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fc4:	83 ec 04             	sub    $0x4,%esp
  800fc7:	50                   	push   %eax
  800fc8:	52                   	push   %edx
  800fc9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fcf:	83 c0 08             	add    $0x8,%eax
  800fd2:	50                   	push   %eax
  800fd3:	e8 04 0f 00 00       	call   801edc <sys_cputs>
  800fd8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800fdb:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800fe2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <cprintf>:

int cprintf(const char *fmt, ...) {
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ff0:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800ff7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ffa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	83 ec 08             	sub    $0x8,%esp
  801003:	ff 75 f4             	pushl  -0xc(%ebp)
  801006:	50                   	push   %eax
  801007:	e8 73 ff ff ff       	call   800f7f <vcprintf>
  80100c:	83 c4 10             	add    $0x10,%esp
  80100f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801012:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80101d:	e8 68 10 00 00       	call   80208a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801022:	8d 45 0c             	lea    0xc(%ebp),%eax
  801025:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 f4             	pushl  -0xc(%ebp)
  801031:	50                   	push   %eax
  801032:	e8 48 ff ff ff       	call   800f7f <vcprintf>
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80103d:	e8 62 10 00 00       	call   8020a4 <sys_enable_interrupt>
	return cnt;
  801042:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801045:	c9                   	leave  
  801046:	c3                   	ret    

00801047 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	53                   	push   %ebx
  80104b:	83 ec 14             	sub    $0x14,%esp
  80104e:	8b 45 10             	mov    0x10(%ebp),%eax
  801051:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80105a:	8b 45 18             	mov    0x18(%ebp),%eax
  80105d:	ba 00 00 00 00       	mov    $0x0,%edx
  801062:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801065:	77 55                	ja     8010bc <printnum+0x75>
  801067:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80106a:	72 05                	jb     801071 <printnum+0x2a>
  80106c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106f:	77 4b                	ja     8010bc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801071:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801074:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801077:	8b 45 18             	mov    0x18(%ebp),%eax
  80107a:	ba 00 00 00 00       	mov    $0x0,%edx
  80107f:	52                   	push   %edx
  801080:	50                   	push   %eax
  801081:	ff 75 f4             	pushl  -0xc(%ebp)
  801084:	ff 75 f0             	pushl  -0x10(%ebp)
  801087:	e8 84 14 00 00       	call   802510 <__udivdi3>
  80108c:	83 c4 10             	add    $0x10,%esp
  80108f:	83 ec 04             	sub    $0x4,%esp
  801092:	ff 75 20             	pushl  0x20(%ebp)
  801095:	53                   	push   %ebx
  801096:	ff 75 18             	pushl  0x18(%ebp)
  801099:	52                   	push   %edx
  80109a:	50                   	push   %eax
  80109b:	ff 75 0c             	pushl  0xc(%ebp)
  80109e:	ff 75 08             	pushl  0x8(%ebp)
  8010a1:	e8 a1 ff ff ff       	call   801047 <printnum>
  8010a6:	83 c4 20             	add    $0x20,%esp
  8010a9:	eb 1a                	jmp    8010c5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8010ab:	83 ec 08             	sub    $0x8,%esp
  8010ae:	ff 75 0c             	pushl  0xc(%ebp)
  8010b1:	ff 75 20             	pushl  0x20(%ebp)
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	ff d0                	call   *%eax
  8010b9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010bc:	ff 4d 1c             	decl   0x1c(%ebp)
  8010bf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010c3:	7f e6                	jg     8010ab <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010c5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d3:	53                   	push   %ebx
  8010d4:	51                   	push   %ecx
  8010d5:	52                   	push   %edx
  8010d6:	50                   	push   %eax
  8010d7:	e8 44 15 00 00       	call   802620 <__umoddi3>
  8010dc:	83 c4 10             	add    $0x10,%esp
  8010df:	05 94 2c 80 00       	add    $0x802c94,%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	0f be c0             	movsbl %al,%eax
  8010e9:	83 ec 08             	sub    $0x8,%esp
  8010ec:	ff 75 0c             	pushl  0xc(%ebp)
  8010ef:	50                   	push   %eax
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	ff d0                	call   *%eax
  8010f5:	83 c4 10             	add    $0x10,%esp
}
  8010f8:	90                   	nop
  8010f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801101:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801105:	7e 1c                	jle    801123 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8b 00                	mov    (%eax),%eax
  80110c:	8d 50 08             	lea    0x8(%eax),%edx
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 10                	mov    %edx,(%eax)
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8b 00                	mov    (%eax),%eax
  801119:	83 e8 08             	sub    $0x8,%eax
  80111c:	8b 50 04             	mov    0x4(%eax),%edx
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	eb 40                	jmp    801163 <getuint+0x65>
	else if (lflag)
  801123:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801127:	74 1e                	je     801147 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8b 00                	mov    (%eax),%eax
  80112e:	8d 50 04             	lea    0x4(%eax),%edx
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	89 10                	mov    %edx,(%eax)
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8b 00                	mov    (%eax),%eax
  80113b:	83 e8 04             	sub    $0x4,%eax
  80113e:	8b 00                	mov    (%eax),%eax
  801140:	ba 00 00 00 00       	mov    $0x0,%edx
  801145:	eb 1c                	jmp    801163 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8b 00                	mov    (%eax),%eax
  80114c:	8d 50 04             	lea    0x4(%eax),%edx
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	89 10                	mov    %edx,(%eax)
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8b 00                	mov    (%eax),%eax
  801159:	83 e8 04             	sub    $0x4,%eax
  80115c:	8b 00                	mov    (%eax),%eax
  80115e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801163:	5d                   	pop    %ebp
  801164:	c3                   	ret    

00801165 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801168:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80116c:	7e 1c                	jle    80118a <getint+0x25>
		return va_arg(*ap, long long);
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8b 00                	mov    (%eax),%eax
  801173:	8d 50 08             	lea    0x8(%eax),%edx
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	89 10                	mov    %edx,(%eax)
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	8b 00                	mov    (%eax),%eax
  801180:	83 e8 08             	sub    $0x8,%eax
  801183:	8b 50 04             	mov    0x4(%eax),%edx
  801186:	8b 00                	mov    (%eax),%eax
  801188:	eb 38                	jmp    8011c2 <getint+0x5d>
	else if (lflag)
  80118a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118e:	74 1a                	je     8011aa <getint+0x45>
		return va_arg(*ap, long);
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	8b 00                	mov    (%eax),%eax
  801195:	8d 50 04             	lea    0x4(%eax),%edx
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	89 10                	mov    %edx,(%eax)
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8b 00                	mov    (%eax),%eax
  8011a2:	83 e8 04             	sub    $0x4,%eax
  8011a5:	8b 00                	mov    (%eax),%eax
  8011a7:	99                   	cltd   
  8011a8:	eb 18                	jmp    8011c2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8b 00                	mov    (%eax),%eax
  8011af:	8d 50 04             	lea    0x4(%eax),%edx
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	89 10                	mov    %edx,(%eax)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8b 00                	mov    (%eax),%eax
  8011bc:	83 e8 04             	sub    $0x4,%eax
  8011bf:	8b 00                	mov    (%eax),%eax
  8011c1:	99                   	cltd   
}
  8011c2:	5d                   	pop    %ebp
  8011c3:	c3                   	ret    

008011c4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	56                   	push   %esi
  8011c8:	53                   	push   %ebx
  8011c9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011cc:	eb 17                	jmp    8011e5 <vprintfmt+0x21>
			if (ch == '\0')
  8011ce:	85 db                	test   %ebx,%ebx
  8011d0:	0f 84 af 03 00 00    	je     801585 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 0c             	pushl  0xc(%ebp)
  8011dc:	53                   	push   %ebx
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	ff d0                	call   *%eax
  8011e2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e8:	8d 50 01             	lea    0x1(%eax),%edx
  8011eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	0f b6 d8             	movzbl %al,%ebx
  8011f3:	83 fb 25             	cmp    $0x25,%ebx
  8011f6:	75 d6                	jne    8011ce <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8011f8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8011fc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801203:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80120a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801211:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801218:	8b 45 10             	mov    0x10(%ebp),%eax
  80121b:	8d 50 01             	lea    0x1(%eax),%edx
  80121e:	89 55 10             	mov    %edx,0x10(%ebp)
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f b6 d8             	movzbl %al,%ebx
  801226:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801229:	83 f8 55             	cmp    $0x55,%eax
  80122c:	0f 87 2b 03 00 00    	ja     80155d <vprintfmt+0x399>
  801232:	8b 04 85 b8 2c 80 00 	mov    0x802cb8(,%eax,4),%eax
  801239:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80123b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80123f:	eb d7                	jmp    801218 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801241:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801245:	eb d1                	jmp    801218 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801247:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80124e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801251:	89 d0                	mov    %edx,%eax
  801253:	c1 e0 02             	shl    $0x2,%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	01 c0                	add    %eax,%eax
  80125a:	01 d8                	add    %ebx,%eax
  80125c:	83 e8 30             	sub    $0x30,%eax
  80125f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801262:	8b 45 10             	mov    0x10(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80126a:	83 fb 2f             	cmp    $0x2f,%ebx
  80126d:	7e 3e                	jle    8012ad <vprintfmt+0xe9>
  80126f:	83 fb 39             	cmp    $0x39,%ebx
  801272:	7f 39                	jg     8012ad <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801274:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801277:	eb d5                	jmp    80124e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801279:	8b 45 14             	mov    0x14(%ebp),%eax
  80127c:	83 c0 04             	add    $0x4,%eax
  80127f:	89 45 14             	mov    %eax,0x14(%ebp)
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	83 e8 04             	sub    $0x4,%eax
  801288:	8b 00                	mov    (%eax),%eax
  80128a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80128d:	eb 1f                	jmp    8012ae <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80128f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801293:	79 83                	jns    801218 <vprintfmt+0x54>
				width = 0;
  801295:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80129c:	e9 77 ff ff ff       	jmp    801218 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8012a1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8012a8:	e9 6b ff ff ff       	jmp    801218 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8012ad:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b2:	0f 89 60 ff ff ff    	jns    801218 <vprintfmt+0x54>
				width = precision, precision = -1;
  8012b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012be:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012c5:	e9 4e ff ff ff       	jmp    801218 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012ca:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012cd:	e9 46 ff ff ff       	jmp    801218 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d5:	83 c0 04             	add    $0x4,%eax
  8012d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8012db:	8b 45 14             	mov    0x14(%ebp),%eax
  8012de:	83 e8 04             	sub    $0x4,%eax
  8012e1:	8b 00                	mov    (%eax),%eax
  8012e3:	83 ec 08             	sub    $0x8,%esp
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	50                   	push   %eax
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	ff d0                	call   *%eax
  8012ef:	83 c4 10             	add    $0x10,%esp
			break;
  8012f2:	e9 89 02 00 00       	jmp    801580 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8012f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fa:	83 c0 04             	add    $0x4,%eax
  8012fd:	89 45 14             	mov    %eax,0x14(%ebp)
  801300:	8b 45 14             	mov    0x14(%ebp),%eax
  801303:	83 e8 04             	sub    $0x4,%eax
  801306:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801308:	85 db                	test   %ebx,%ebx
  80130a:	79 02                	jns    80130e <vprintfmt+0x14a>
				err = -err;
  80130c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80130e:	83 fb 64             	cmp    $0x64,%ebx
  801311:	7f 0b                	jg     80131e <vprintfmt+0x15a>
  801313:	8b 34 9d 00 2b 80 00 	mov    0x802b00(,%ebx,4),%esi
  80131a:	85 f6                	test   %esi,%esi
  80131c:	75 19                	jne    801337 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80131e:	53                   	push   %ebx
  80131f:	68 a5 2c 80 00       	push   $0x802ca5
  801324:	ff 75 0c             	pushl  0xc(%ebp)
  801327:	ff 75 08             	pushl  0x8(%ebp)
  80132a:	e8 5e 02 00 00       	call   80158d <printfmt>
  80132f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801332:	e9 49 02 00 00       	jmp    801580 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801337:	56                   	push   %esi
  801338:	68 ae 2c 80 00       	push   $0x802cae
  80133d:	ff 75 0c             	pushl  0xc(%ebp)
  801340:	ff 75 08             	pushl  0x8(%ebp)
  801343:	e8 45 02 00 00       	call   80158d <printfmt>
  801348:	83 c4 10             	add    $0x10,%esp
			break;
  80134b:	e9 30 02 00 00       	jmp    801580 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801350:	8b 45 14             	mov    0x14(%ebp),%eax
  801353:	83 c0 04             	add    $0x4,%eax
  801356:	89 45 14             	mov    %eax,0x14(%ebp)
  801359:	8b 45 14             	mov    0x14(%ebp),%eax
  80135c:	83 e8 04             	sub    $0x4,%eax
  80135f:	8b 30                	mov    (%eax),%esi
  801361:	85 f6                	test   %esi,%esi
  801363:	75 05                	jne    80136a <vprintfmt+0x1a6>
				p = "(null)";
  801365:	be b1 2c 80 00       	mov    $0x802cb1,%esi
			if (width > 0 && padc != '-')
  80136a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80136e:	7e 6d                	jle    8013dd <vprintfmt+0x219>
  801370:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801374:	74 67                	je     8013dd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801376:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801379:	83 ec 08             	sub    $0x8,%esp
  80137c:	50                   	push   %eax
  80137d:	56                   	push   %esi
  80137e:	e8 0c 03 00 00       	call   80168f <strnlen>
  801383:	83 c4 10             	add    $0x10,%esp
  801386:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801389:	eb 16                	jmp    8013a1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80138b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80138f:	83 ec 08             	sub    $0x8,%esp
  801392:	ff 75 0c             	pushl  0xc(%ebp)
  801395:	50                   	push   %eax
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	ff d0                	call   *%eax
  80139b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80139e:	ff 4d e4             	decl   -0x1c(%ebp)
  8013a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013a5:	7f e4                	jg     80138b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013a7:	eb 34                	jmp    8013dd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8013a9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013ad:	74 1c                	je     8013cb <vprintfmt+0x207>
  8013af:	83 fb 1f             	cmp    $0x1f,%ebx
  8013b2:	7e 05                	jle    8013b9 <vprintfmt+0x1f5>
  8013b4:	83 fb 7e             	cmp    $0x7e,%ebx
  8013b7:	7e 12                	jle    8013cb <vprintfmt+0x207>
					putch('?', putdat);
  8013b9:	83 ec 08             	sub    $0x8,%esp
  8013bc:	ff 75 0c             	pushl  0xc(%ebp)
  8013bf:	6a 3f                	push   $0x3f
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	ff d0                	call   *%eax
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	eb 0f                	jmp    8013da <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013cb:	83 ec 08             	sub    $0x8,%esp
  8013ce:	ff 75 0c             	pushl  0xc(%ebp)
  8013d1:	53                   	push   %ebx
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	ff d0                	call   *%eax
  8013d7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013da:	ff 4d e4             	decl   -0x1c(%ebp)
  8013dd:	89 f0                	mov    %esi,%eax
  8013df:	8d 70 01             	lea    0x1(%eax),%esi
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	0f be d8             	movsbl %al,%ebx
  8013e7:	85 db                	test   %ebx,%ebx
  8013e9:	74 24                	je     80140f <vprintfmt+0x24b>
  8013eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ef:	78 b8                	js     8013a9 <vprintfmt+0x1e5>
  8013f1:	ff 4d e0             	decl   -0x20(%ebp)
  8013f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013f8:	79 af                	jns    8013a9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013fa:	eb 13                	jmp    80140f <vprintfmt+0x24b>
				putch(' ', putdat);
  8013fc:	83 ec 08             	sub    $0x8,%esp
  8013ff:	ff 75 0c             	pushl  0xc(%ebp)
  801402:	6a 20                	push   $0x20
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	ff d0                	call   *%eax
  801409:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80140c:	ff 4d e4             	decl   -0x1c(%ebp)
  80140f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801413:	7f e7                	jg     8013fc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801415:	e9 66 01 00 00       	jmp    801580 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80141a:	83 ec 08             	sub    $0x8,%esp
  80141d:	ff 75 e8             	pushl  -0x18(%ebp)
  801420:	8d 45 14             	lea    0x14(%ebp),%eax
  801423:	50                   	push   %eax
  801424:	e8 3c fd ff ff       	call   801165 <getint>
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801435:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801438:	85 d2                	test   %edx,%edx
  80143a:	79 23                	jns    80145f <vprintfmt+0x29b>
				putch('-', putdat);
  80143c:	83 ec 08             	sub    $0x8,%esp
  80143f:	ff 75 0c             	pushl  0xc(%ebp)
  801442:	6a 2d                	push   $0x2d
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	ff d0                	call   *%eax
  801449:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80144c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801452:	f7 d8                	neg    %eax
  801454:	83 d2 00             	adc    $0x0,%edx
  801457:	f7 da                	neg    %edx
  801459:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80145c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80145f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801466:	e9 bc 00 00 00       	jmp    801527 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	ff 75 e8             	pushl  -0x18(%ebp)
  801471:	8d 45 14             	lea    0x14(%ebp),%eax
  801474:	50                   	push   %eax
  801475:	e8 84 fc ff ff       	call   8010fe <getuint>
  80147a:	83 c4 10             	add    $0x10,%esp
  80147d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801480:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801483:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80148a:	e9 98 00 00 00       	jmp    801527 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80148f:	83 ec 08             	sub    $0x8,%esp
  801492:	ff 75 0c             	pushl  0xc(%ebp)
  801495:	6a 58                	push   $0x58
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	ff d0                	call   *%eax
  80149c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80149f:	83 ec 08             	sub    $0x8,%esp
  8014a2:	ff 75 0c             	pushl  0xc(%ebp)
  8014a5:	6a 58                	push   $0x58
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	ff d0                	call   *%eax
  8014ac:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014af:	83 ec 08             	sub    $0x8,%esp
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	6a 58                	push   $0x58
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	ff d0                	call   *%eax
  8014bc:	83 c4 10             	add    $0x10,%esp
			break;
  8014bf:	e9 bc 00 00 00       	jmp    801580 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014c4:	83 ec 08             	sub    $0x8,%esp
  8014c7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ca:	6a 30                	push   $0x30
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	ff d0                	call   *%eax
  8014d1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	ff 75 0c             	pushl  0xc(%ebp)
  8014da:	6a 78                	push   $0x78
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	ff d0                	call   *%eax
  8014e1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e7:	83 c0 04             	add    $0x4,%eax
  8014ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8014ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f0:	83 e8 04             	sub    $0x4,%eax
  8014f3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8014ff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801506:	eb 1f                	jmp    801527 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	ff 75 e8             	pushl  -0x18(%ebp)
  80150e:	8d 45 14             	lea    0x14(%ebp),%eax
  801511:	50                   	push   %eax
  801512:	e8 e7 fb ff ff       	call   8010fe <getuint>
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80151d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801520:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801527:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80152b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152e:	83 ec 04             	sub    $0x4,%esp
  801531:	52                   	push   %edx
  801532:	ff 75 e4             	pushl  -0x1c(%ebp)
  801535:	50                   	push   %eax
  801536:	ff 75 f4             	pushl  -0xc(%ebp)
  801539:	ff 75 f0             	pushl  -0x10(%ebp)
  80153c:	ff 75 0c             	pushl  0xc(%ebp)
  80153f:	ff 75 08             	pushl  0x8(%ebp)
  801542:	e8 00 fb ff ff       	call   801047 <printnum>
  801547:	83 c4 20             	add    $0x20,%esp
			break;
  80154a:	eb 34                	jmp    801580 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80154c:	83 ec 08             	sub    $0x8,%esp
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	53                   	push   %ebx
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	ff d0                	call   *%eax
  801558:	83 c4 10             	add    $0x10,%esp
			break;
  80155b:	eb 23                	jmp    801580 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80155d:	83 ec 08             	sub    $0x8,%esp
  801560:	ff 75 0c             	pushl  0xc(%ebp)
  801563:	6a 25                	push   $0x25
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	ff d0                	call   *%eax
  80156a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80156d:	ff 4d 10             	decl   0x10(%ebp)
  801570:	eb 03                	jmp    801575 <vprintfmt+0x3b1>
  801572:	ff 4d 10             	decl   0x10(%ebp)
  801575:	8b 45 10             	mov    0x10(%ebp),%eax
  801578:	48                   	dec    %eax
  801579:	8a 00                	mov    (%eax),%al
  80157b:	3c 25                	cmp    $0x25,%al
  80157d:	75 f3                	jne    801572 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80157f:	90                   	nop
		}
	}
  801580:	e9 47 fc ff ff       	jmp    8011cc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801585:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801586:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801589:	5b                   	pop    %ebx
  80158a:	5e                   	pop    %esi
  80158b:	5d                   	pop    %ebp
  80158c:	c3                   	ret    

0080158d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801593:	8d 45 10             	lea    0x10(%ebp),%eax
  801596:	83 c0 04             	add    $0x4,%eax
  801599:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80159c:	8b 45 10             	mov    0x10(%ebp),%eax
  80159f:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a2:	50                   	push   %eax
  8015a3:	ff 75 0c             	pushl  0xc(%ebp)
  8015a6:	ff 75 08             	pushl  0x8(%ebp)
  8015a9:	e8 16 fc ff ff       	call   8011c4 <vprintfmt>
  8015ae:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015b1:	90                   	nop
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	8b 40 08             	mov    0x8(%eax),%eax
  8015bd:	8d 50 01             	lea    0x1(%eax),%edx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c9:	8b 10                	mov    (%eax),%edx
  8015cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ce:	8b 40 04             	mov    0x4(%eax),%eax
  8015d1:	39 c2                	cmp    %eax,%edx
  8015d3:	73 12                	jae    8015e7 <sprintputch+0x33>
		*b->buf++ = ch;
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	8b 00                	mov    (%eax),%eax
  8015da:	8d 48 01             	lea    0x1(%eax),%ecx
  8015dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e0:	89 0a                	mov    %ecx,(%edx)
  8015e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e5:	88 10                	mov    %dl,(%eax)
}
  8015e7:	90                   	nop
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    

008015ea <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	01 d0                	add    %edx,%eax
  801601:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801604:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80160b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80160f:	74 06                	je     801617 <vsnprintf+0x2d>
  801611:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801615:	7f 07                	jg     80161e <vsnprintf+0x34>
		return -E_INVAL;
  801617:	b8 03 00 00 00       	mov    $0x3,%eax
  80161c:	eb 20                	jmp    80163e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80161e:	ff 75 14             	pushl  0x14(%ebp)
  801621:	ff 75 10             	pushl  0x10(%ebp)
  801624:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801627:	50                   	push   %eax
  801628:	68 b4 15 80 00       	push   $0x8015b4
  80162d:	e8 92 fb ff ff       	call   8011c4 <vprintfmt>
  801632:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801638:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80163b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801646:	8d 45 10             	lea    0x10(%ebp),%eax
  801649:	83 c0 04             	add    $0x4,%eax
  80164c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80164f:	8b 45 10             	mov    0x10(%ebp),%eax
  801652:	ff 75 f4             	pushl  -0xc(%ebp)
  801655:	50                   	push   %eax
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	e8 89 ff ff ff       	call   8015ea <vsnprintf>
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801667:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801672:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801679:	eb 06                	jmp    801681 <strlen+0x15>
		n++;
  80167b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80167e:	ff 45 08             	incl   0x8(%ebp)
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	8a 00                	mov    (%eax),%al
  801686:	84 c0                	test   %al,%al
  801688:	75 f1                	jne    80167b <strlen+0xf>
		n++;
	return n;
  80168a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
  801692:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801695:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80169c:	eb 09                	jmp    8016a7 <strnlen+0x18>
		n++;
  80169e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016a1:	ff 45 08             	incl   0x8(%ebp)
  8016a4:	ff 4d 0c             	decl   0xc(%ebp)
  8016a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ab:	74 09                	je     8016b6 <strnlen+0x27>
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8a 00                	mov    (%eax),%al
  8016b2:	84 c0                	test   %al,%al
  8016b4:	75 e8                	jne    80169e <strnlen+0xf>
		n++;
	return n;
  8016b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016c7:	90                   	nop
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8d 50 01             	lea    0x1(%eax),%edx
  8016ce:	89 55 08             	mov    %edx,0x8(%ebp)
  8016d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016da:	8a 12                	mov    (%edx),%dl
  8016dc:	88 10                	mov    %dl,(%eax)
  8016de:	8a 00                	mov    (%eax),%al
  8016e0:	84 c0                	test   %al,%al
  8016e2:	75 e4                	jne    8016c8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016fc:	eb 1f                	jmp    80171d <strncpy+0x34>
		*dst++ = *src;
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	8d 50 01             	lea    0x1(%eax),%edx
  801704:	89 55 08             	mov    %edx,0x8(%ebp)
  801707:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170a:	8a 12                	mov    (%edx),%dl
  80170c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80170e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	84 c0                	test   %al,%al
  801715:	74 03                	je     80171a <strncpy+0x31>
			src++;
  801717:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80171a:	ff 45 fc             	incl   -0x4(%ebp)
  80171d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801720:	3b 45 10             	cmp    0x10(%ebp),%eax
  801723:	72 d9                	jb     8016fe <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801725:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801736:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80173a:	74 30                	je     80176c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80173c:	eb 16                	jmp    801754 <strlcpy+0x2a>
			*dst++ = *src++;
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8d 50 01             	lea    0x1(%eax),%edx
  801744:	89 55 08             	mov    %edx,0x8(%ebp)
  801747:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80174d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801750:	8a 12                	mov    (%edx),%dl
  801752:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801754:	ff 4d 10             	decl   0x10(%ebp)
  801757:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80175b:	74 09                	je     801766 <strlcpy+0x3c>
  80175d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	84 c0                	test   %al,%al
  801764:	75 d8                	jne    80173e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80176c:	8b 55 08             	mov    0x8(%ebp),%edx
  80176f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801772:	29 c2                	sub    %eax,%edx
  801774:	89 d0                	mov    %edx,%eax
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80177b:	eb 06                	jmp    801783 <strcmp+0xb>
		p++, q++;
  80177d:	ff 45 08             	incl   0x8(%ebp)
  801780:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	8a 00                	mov    (%eax),%al
  801788:	84 c0                	test   %al,%al
  80178a:	74 0e                	je     80179a <strcmp+0x22>
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 10                	mov    (%eax),%dl
  801791:	8b 45 0c             	mov    0xc(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	38 c2                	cmp    %al,%dl
  801798:	74 e3                	je     80177d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8a 00                	mov    (%eax),%al
  80179f:	0f b6 d0             	movzbl %al,%edx
  8017a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a5:	8a 00                	mov    (%eax),%al
  8017a7:	0f b6 c0             	movzbl %al,%eax
  8017aa:	29 c2                	sub    %eax,%edx
  8017ac:	89 d0                	mov    %edx,%eax
}
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017b3:	eb 09                	jmp    8017be <strncmp+0xe>
		n--, p++, q++;
  8017b5:	ff 4d 10             	decl   0x10(%ebp)
  8017b8:	ff 45 08             	incl   0x8(%ebp)
  8017bb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c2:	74 17                	je     8017db <strncmp+0x2b>
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	84 c0                	test   %al,%al
  8017cb:	74 0e                	je     8017db <strncmp+0x2b>
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8a 10                	mov    (%eax),%dl
  8017d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d5:	8a 00                	mov    (%eax),%al
  8017d7:	38 c2                	cmp    %al,%dl
  8017d9:	74 da                	je     8017b5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017df:	75 07                	jne    8017e8 <strncmp+0x38>
		return 0;
  8017e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e6:	eb 14                	jmp    8017fc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	8a 00                	mov    (%eax),%al
  8017ed:	0f b6 d0             	movzbl %al,%edx
  8017f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f3:	8a 00                	mov    (%eax),%al
  8017f5:	0f b6 c0             	movzbl %al,%eax
  8017f8:	29 c2                	sub    %eax,%edx
  8017fa:	89 d0                	mov    %edx,%eax
}
  8017fc:	5d                   	pop    %ebp
  8017fd:	c3                   	ret    

008017fe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	8b 45 0c             	mov    0xc(%ebp),%eax
  801807:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80180a:	eb 12                	jmp    80181e <strchr+0x20>
		if (*s == c)
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	8a 00                	mov    (%eax),%al
  801811:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801814:	75 05                	jne    80181b <strchr+0x1d>
			return (char *) s;
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	eb 11                	jmp    80182c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80181b:	ff 45 08             	incl   0x8(%ebp)
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	8a 00                	mov    (%eax),%al
  801823:	84 c0                	test   %al,%al
  801825:	75 e5                	jne    80180c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801827:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 04             	sub    $0x4,%esp
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80183a:	eb 0d                	jmp    801849 <strfind+0x1b>
		if (*s == c)
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	8a 00                	mov    (%eax),%al
  801841:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801844:	74 0e                	je     801854 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801846:	ff 45 08             	incl   0x8(%ebp)
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8a 00                	mov    (%eax),%al
  80184e:	84 c0                	test   %al,%al
  801850:	75 ea                	jne    80183c <strfind+0xe>
  801852:	eb 01                	jmp    801855 <strfind+0x27>
		if (*s == c)
			break;
  801854:	90                   	nop
	return (char *) s;
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801866:	8b 45 10             	mov    0x10(%ebp),%eax
  801869:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80186c:	eb 0e                	jmp    80187c <memset+0x22>
		*p++ = c;
  80186e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801871:	8d 50 01             	lea    0x1(%eax),%edx
  801874:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801877:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80187c:	ff 4d f8             	decl   -0x8(%ebp)
  80187f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801883:	79 e9                	jns    80186e <memset+0x14>
		*p++ = c;

	return v;
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801890:	8b 45 0c             	mov    0xc(%ebp),%eax
  801893:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80189c:	eb 16                	jmp    8018b4 <memcpy+0x2a>
		*d++ = *s++;
  80189e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a1:	8d 50 01             	lea    0x1(%eax),%edx
  8018a4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018ad:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018b0:	8a 12                	mov    (%edx),%dl
  8018b2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8018bd:	85 c0                	test   %eax,%eax
  8018bf:	75 dd                	jne    80189e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018de:	73 50                	jae    801930 <memmove+0x6a>
  8018e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e6:	01 d0                	add    %edx,%eax
  8018e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018eb:	76 43                	jbe    801930 <memmove+0x6a>
		s += n;
  8018ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018f9:	eb 10                	jmp    80190b <memmove+0x45>
			*--d = *--s;
  8018fb:	ff 4d f8             	decl   -0x8(%ebp)
  8018fe:	ff 4d fc             	decl   -0x4(%ebp)
  801901:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801904:	8a 10                	mov    (%eax),%dl
  801906:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801909:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80190b:	8b 45 10             	mov    0x10(%ebp),%eax
  80190e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801911:	89 55 10             	mov    %edx,0x10(%ebp)
  801914:	85 c0                	test   %eax,%eax
  801916:	75 e3                	jne    8018fb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801918:	eb 23                	jmp    80193d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80191a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191d:	8d 50 01             	lea    0x1(%eax),%edx
  801920:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801923:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801926:	8d 4a 01             	lea    0x1(%edx),%ecx
  801929:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80192c:	8a 12                	mov    (%edx),%dl
  80192e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801930:	8b 45 10             	mov    0x10(%ebp),%eax
  801933:	8d 50 ff             	lea    -0x1(%eax),%edx
  801936:	89 55 10             	mov    %edx,0x10(%ebp)
  801939:	85 c0                	test   %eax,%eax
  80193b:	75 dd                	jne    80191a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80194e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801951:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801954:	eb 2a                	jmp    801980 <memcmp+0x3e>
		if (*s1 != *s2)
  801956:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801959:	8a 10                	mov    (%eax),%dl
  80195b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195e:	8a 00                	mov    (%eax),%al
  801960:	38 c2                	cmp    %al,%dl
  801962:	74 16                	je     80197a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801964:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801967:	8a 00                	mov    (%eax),%al
  801969:	0f b6 d0             	movzbl %al,%edx
  80196c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80196f:	8a 00                	mov    (%eax),%al
  801971:	0f b6 c0             	movzbl %al,%eax
  801974:	29 c2                	sub    %eax,%edx
  801976:	89 d0                	mov    %edx,%eax
  801978:	eb 18                	jmp    801992 <memcmp+0x50>
		s1++, s2++;
  80197a:	ff 45 fc             	incl   -0x4(%ebp)
  80197d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801980:	8b 45 10             	mov    0x10(%ebp),%eax
  801983:	8d 50 ff             	lea    -0x1(%eax),%edx
  801986:	89 55 10             	mov    %edx,0x10(%ebp)
  801989:	85 c0                	test   %eax,%eax
  80198b:	75 c9                	jne    801956 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80198d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80199a:	8b 55 08             	mov    0x8(%ebp),%edx
  80199d:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a0:	01 d0                	add    %edx,%eax
  8019a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8019a5:	eb 15                	jmp    8019bc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	8a 00                	mov    (%eax),%al
  8019ac:	0f b6 d0             	movzbl %al,%edx
  8019af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b2:	0f b6 c0             	movzbl %al,%eax
  8019b5:	39 c2                	cmp    %eax,%edx
  8019b7:	74 0d                	je     8019c6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019b9:	ff 45 08             	incl   0x8(%ebp)
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019c2:	72 e3                	jb     8019a7 <memfind+0x13>
  8019c4:	eb 01                	jmp    8019c7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019c6:	90                   	nop
	return (void *) s;
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019e0:	eb 03                	jmp    8019e5 <strtol+0x19>
		s++;
  8019e2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	8a 00                	mov    (%eax),%al
  8019ea:	3c 20                	cmp    $0x20,%al
  8019ec:	74 f4                	je     8019e2 <strtol+0x16>
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	8a 00                	mov    (%eax),%al
  8019f3:	3c 09                	cmp    $0x9,%al
  8019f5:	74 eb                	je     8019e2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	3c 2b                	cmp    $0x2b,%al
  8019fe:	75 05                	jne    801a05 <strtol+0x39>
		s++;
  801a00:	ff 45 08             	incl   0x8(%ebp)
  801a03:	eb 13                	jmp    801a18 <strtol+0x4c>
	else if (*s == '-')
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	8a 00                	mov    (%eax),%al
  801a0a:	3c 2d                	cmp    $0x2d,%al
  801a0c:	75 0a                	jne    801a18 <strtol+0x4c>
		s++, neg = 1;
  801a0e:	ff 45 08             	incl   0x8(%ebp)
  801a11:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a1c:	74 06                	je     801a24 <strtol+0x58>
  801a1e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a22:	75 20                	jne    801a44 <strtol+0x78>
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8a 00                	mov    (%eax),%al
  801a29:	3c 30                	cmp    $0x30,%al
  801a2b:	75 17                	jne    801a44 <strtol+0x78>
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	40                   	inc    %eax
  801a31:	8a 00                	mov    (%eax),%al
  801a33:	3c 78                	cmp    $0x78,%al
  801a35:	75 0d                	jne    801a44 <strtol+0x78>
		s += 2, base = 16;
  801a37:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a3b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a42:	eb 28                	jmp    801a6c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a48:	75 15                	jne    801a5f <strtol+0x93>
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	8a 00                	mov    (%eax),%al
  801a4f:	3c 30                	cmp    $0x30,%al
  801a51:	75 0c                	jne    801a5f <strtol+0x93>
		s++, base = 8;
  801a53:	ff 45 08             	incl   0x8(%ebp)
  801a56:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a5d:	eb 0d                	jmp    801a6c <strtol+0xa0>
	else if (base == 0)
  801a5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a63:	75 07                	jne    801a6c <strtol+0xa0>
		base = 10;
  801a65:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	8a 00                	mov    (%eax),%al
  801a71:	3c 2f                	cmp    $0x2f,%al
  801a73:	7e 19                	jle    801a8e <strtol+0xc2>
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	8a 00                	mov    (%eax),%al
  801a7a:	3c 39                	cmp    $0x39,%al
  801a7c:	7f 10                	jg     801a8e <strtol+0xc2>
			dig = *s - '0';
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	8a 00                	mov    (%eax),%al
  801a83:	0f be c0             	movsbl %al,%eax
  801a86:	83 e8 30             	sub    $0x30,%eax
  801a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a8c:	eb 42                	jmp    801ad0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	8a 00                	mov    (%eax),%al
  801a93:	3c 60                	cmp    $0x60,%al
  801a95:	7e 19                	jle    801ab0 <strtol+0xe4>
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	8a 00                	mov    (%eax),%al
  801a9c:	3c 7a                	cmp    $0x7a,%al
  801a9e:	7f 10                	jg     801ab0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	8a 00                	mov    (%eax),%al
  801aa5:	0f be c0             	movsbl %al,%eax
  801aa8:	83 e8 57             	sub    $0x57,%eax
  801aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aae:	eb 20                	jmp    801ad0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	8a 00                	mov    (%eax),%al
  801ab5:	3c 40                	cmp    $0x40,%al
  801ab7:	7e 39                	jle    801af2 <strtol+0x126>
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8a 00                	mov    (%eax),%al
  801abe:	3c 5a                	cmp    $0x5a,%al
  801ac0:	7f 30                	jg     801af2 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	8a 00                	mov    (%eax),%al
  801ac7:	0f be c0             	movsbl %al,%eax
  801aca:	83 e8 37             	sub    $0x37,%eax
  801acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad3:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ad6:	7d 19                	jge    801af1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801ad8:	ff 45 08             	incl   0x8(%ebp)
  801adb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ade:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ae2:	89 c2                	mov    %eax,%edx
  801ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae7:	01 d0                	add    %edx,%eax
  801ae9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801aec:	e9 7b ff ff ff       	jmp    801a6c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801af1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801af2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801af6:	74 08                	je     801b00 <strtol+0x134>
		*endptr = (char *) s;
  801af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afb:	8b 55 08             	mov    0x8(%ebp),%edx
  801afe:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801b00:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b04:	74 07                	je     801b0d <strtol+0x141>
  801b06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b09:	f7 d8                	neg    %eax
  801b0b:	eb 03                	jmp    801b10 <strtol+0x144>
  801b0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <ltostr>:

void
ltostr(long value, char *str)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b1f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b2a:	79 13                	jns    801b3f <ltostr+0x2d>
	{
		neg = 1;
  801b2c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b36:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b39:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b3c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b47:	99                   	cltd   
  801b48:	f7 f9                	idiv   %ecx
  801b4a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b50:	8d 50 01             	lea    0x1(%eax),%edx
  801b53:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b56:	89 c2                	mov    %eax,%edx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 d0                	add    %edx,%eax
  801b5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b60:	83 c2 30             	add    $0x30,%edx
  801b63:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b68:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b6d:	f7 e9                	imul   %ecx
  801b6f:	c1 fa 02             	sar    $0x2,%edx
  801b72:	89 c8                	mov    %ecx,%eax
  801b74:	c1 f8 1f             	sar    $0x1f,%eax
  801b77:	29 c2                	sub    %eax,%edx
  801b79:	89 d0                	mov    %edx,%eax
  801b7b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b81:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b86:	f7 e9                	imul   %ecx
  801b88:	c1 fa 02             	sar    $0x2,%edx
  801b8b:	89 c8                	mov    %ecx,%eax
  801b8d:	c1 f8 1f             	sar    $0x1f,%eax
  801b90:	29 c2                	sub    %eax,%edx
  801b92:	89 d0                	mov    %edx,%eax
  801b94:	c1 e0 02             	shl    $0x2,%eax
  801b97:	01 d0                	add    %edx,%eax
  801b99:	01 c0                	add    %eax,%eax
  801b9b:	29 c1                	sub    %eax,%ecx
  801b9d:	89 ca                	mov    %ecx,%edx
  801b9f:	85 d2                	test   %edx,%edx
  801ba1:	75 9c                	jne    801b3f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ba3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801baa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bad:	48                   	dec    %eax
  801bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801bb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bb5:	74 3d                	je     801bf4 <ltostr+0xe2>
		start = 1 ;
  801bb7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801bbe:	eb 34                	jmp    801bf4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc6:	01 d0                	add    %edx,%eax
  801bc8:	8a 00                	mov    (%eax),%al
  801bca:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801bcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd3:	01 c2                	add    %eax,%edx
  801bd5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bdb:	01 c8                	add    %ecx,%eax
  801bdd:	8a 00                	mov    (%eax),%al
  801bdf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801be1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be7:	01 c2                	add    %eax,%edx
  801be9:	8a 45 eb             	mov    -0x15(%ebp),%al
  801bec:	88 02                	mov    %al,(%edx)
		start++ ;
  801bee:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801bf1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bfa:	7c c4                	jl     801bc0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801bfc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c02:	01 d0                	add    %edx,%eax
  801c04:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801c07:	90                   	nop
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c10:	ff 75 08             	pushl  0x8(%ebp)
  801c13:	e8 54 fa ff ff       	call   80166c <strlen>
  801c18:	83 c4 04             	add    $0x4,%esp
  801c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c1e:	ff 75 0c             	pushl  0xc(%ebp)
  801c21:	e8 46 fa ff ff       	call   80166c <strlen>
  801c26:	83 c4 04             	add    $0x4,%esp
  801c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c3a:	eb 17                	jmp    801c53 <strcconcat+0x49>
		final[s] = str1[s] ;
  801c3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c42:	01 c2                	add    %eax,%edx
  801c44:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	01 c8                	add    %ecx,%eax
  801c4c:	8a 00                	mov    (%eax),%al
  801c4e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c50:	ff 45 fc             	incl   -0x4(%ebp)
  801c53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c56:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c59:	7c e1                	jl     801c3c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c5b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c62:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c69:	eb 1f                	jmp    801c8a <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c6e:	8d 50 01             	lea    0x1(%eax),%edx
  801c71:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c74:	89 c2                	mov    %eax,%edx
  801c76:	8b 45 10             	mov    0x10(%ebp),%eax
  801c79:	01 c2                	add    %eax,%edx
  801c7b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c81:	01 c8                	add    %ecx,%eax
  801c83:	8a 00                	mov    (%eax),%al
  801c85:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c87:	ff 45 f8             	incl   -0x8(%ebp)
  801c8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c8d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c90:	7c d9                	jl     801c6b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c92:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c95:	8b 45 10             	mov    0x10(%ebp),%eax
  801c98:	01 d0                	add    %edx,%eax
  801c9a:	c6 00 00             	movb   $0x0,(%eax)
}
  801c9d:	90                   	nop
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ca3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801cac:	8b 45 14             	mov    0x14(%ebp),%eax
  801caf:	8b 00                	mov    (%eax),%eax
  801cb1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb8:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbb:	01 d0                	add    %edx,%eax
  801cbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cc3:	eb 0c                	jmp    801cd1 <strsplit+0x31>
			*string++ = 0;
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	8d 50 01             	lea    0x1(%eax),%edx
  801ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  801cce:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	8a 00                	mov    (%eax),%al
  801cd6:	84 c0                	test   %al,%al
  801cd8:	74 18                	je     801cf2 <strsplit+0x52>
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	8a 00                	mov    (%eax),%al
  801cdf:	0f be c0             	movsbl %al,%eax
  801ce2:	50                   	push   %eax
  801ce3:	ff 75 0c             	pushl  0xc(%ebp)
  801ce6:	e8 13 fb ff ff       	call   8017fe <strchr>
  801ceb:	83 c4 08             	add    $0x8,%esp
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	75 d3                	jne    801cc5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	8a 00                	mov    (%eax),%al
  801cf7:	84 c0                	test   %al,%al
  801cf9:	74 5a                	je     801d55 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  801cfe:	8b 00                	mov    (%eax),%eax
  801d00:	83 f8 0f             	cmp    $0xf,%eax
  801d03:	75 07                	jne    801d0c <strsplit+0x6c>
		{
			return 0;
  801d05:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0a:	eb 66                	jmp    801d72 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801d0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0f:	8b 00                	mov    (%eax),%eax
  801d11:	8d 48 01             	lea    0x1(%eax),%ecx
  801d14:	8b 55 14             	mov    0x14(%ebp),%edx
  801d17:	89 0a                	mov    %ecx,(%edx)
  801d19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d20:	8b 45 10             	mov    0x10(%ebp),%eax
  801d23:	01 c2                	add    %eax,%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d2a:	eb 03                	jmp    801d2f <strsplit+0x8f>
			string++;
  801d2c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	8a 00                	mov    (%eax),%al
  801d34:	84 c0                	test   %al,%al
  801d36:	74 8b                	je     801cc3 <strsplit+0x23>
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	8a 00                	mov    (%eax),%al
  801d3d:	0f be c0             	movsbl %al,%eax
  801d40:	50                   	push   %eax
  801d41:	ff 75 0c             	pushl  0xc(%ebp)
  801d44:	e8 b5 fa ff ff       	call   8017fe <strchr>
  801d49:	83 c4 08             	add    $0x8,%esp
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	74 dc                	je     801d2c <strsplit+0x8c>
			string++;
	}
  801d50:	e9 6e ff ff ff       	jmp    801cc3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d55:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d56:	8b 45 14             	mov    0x14(%ebp),%eax
  801d59:	8b 00                	mov    (%eax),%eax
  801d5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d62:	8b 45 10             	mov    0x10(%ebp),%eax
  801d65:	01 d0                	add    %edx,%eax
  801d67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d6d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801d7a:	83 ec 04             	sub    $0x4,%esp
  801d7d:	68 10 2e 80 00       	push   $0x802e10
  801d82:	6a 0e                	push   $0xe
  801d84:	68 4a 2e 80 00       	push   $0x802e4a
  801d89:	e8 a8 ef ff ff       	call   800d36 <_panic>

00801d8e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801d94:	a1 04 30 80 00       	mov    0x803004,%eax
  801d99:	85 c0                	test   %eax,%eax
  801d9b:	74 0f                	je     801dac <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801d9d:	e8 d2 ff ff ff       	call   801d74 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801da2:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801da9:	00 00 00 
	}
	if (size == 0) return NULL ;
  801dac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801db0:	75 07                	jne    801db9 <malloc+0x2b>
  801db2:	b8 00 00 00 00       	mov    $0x0,%eax
  801db7:	eb 14                	jmp    801dcd <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	68 58 2e 80 00       	push   $0x802e58
  801dc1:	6a 2e                	push   $0x2e
  801dc3:	68 4a 2e 80 00       	push   $0x802e4a
  801dc8:	e8 69 ef ff ff       	call   800d36 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801dd5:	83 ec 04             	sub    $0x4,%esp
  801dd8:	68 80 2e 80 00       	push   $0x802e80
  801ddd:	6a 49                	push   $0x49
  801ddf:	68 4a 2e 80 00       	push   $0x802e4a
  801de4:	e8 4d ef ff ff       	call   800d36 <_panic>

00801de9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 18             	sub    $0x18,%esp
  801def:	8b 45 10             	mov    0x10(%ebp),%eax
  801df2:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801df5:	83 ec 04             	sub    $0x4,%esp
  801df8:	68 a4 2e 80 00       	push   $0x802ea4
  801dfd:	6a 57                	push   $0x57
  801dff:	68 4a 2e 80 00       	push   $0x802e4a
  801e04:	e8 2d ef ff ff       	call   800d36 <_panic>

00801e09 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e0f:	83 ec 04             	sub    $0x4,%esp
  801e12:	68 cc 2e 80 00       	push   $0x802ecc
  801e17:	6a 60                	push   $0x60
  801e19:	68 4a 2e 80 00       	push   $0x802e4a
  801e1e:	e8 13 ef ff ff       	call   800d36 <_panic>

00801e23 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e29:	83 ec 04             	sub    $0x4,%esp
  801e2c:	68 f0 2e 80 00       	push   $0x802ef0
  801e31:	6a 7c                	push   $0x7c
  801e33:	68 4a 2e 80 00       	push   $0x802e4a
  801e38:	e8 f9 ee ff ff       	call   800d36 <_panic>

00801e3d <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e43:	83 ec 04             	sub    $0x4,%esp
  801e46:	68 18 2f 80 00       	push   $0x802f18
  801e4b:	68 86 00 00 00       	push   $0x86
  801e50:	68 4a 2e 80 00       	push   $0x802e4a
  801e55:	e8 dc ee ff ff       	call   800d36 <_panic>

00801e5a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e60:	83 ec 04             	sub    $0x4,%esp
  801e63:	68 3c 2f 80 00       	push   $0x802f3c
  801e68:	68 91 00 00 00       	push   $0x91
  801e6d:	68 4a 2e 80 00       	push   $0x802e4a
  801e72:	e8 bf ee ff ff       	call   800d36 <_panic>

00801e77 <shrink>:

}
void shrink(uint32 newSize)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e7d:	83 ec 04             	sub    $0x4,%esp
  801e80:	68 3c 2f 80 00       	push   $0x802f3c
  801e85:	68 96 00 00 00       	push   $0x96
  801e8a:	68 4a 2e 80 00       	push   $0x802e4a
  801e8f:	e8 a2 ee ff ff       	call   800d36 <_panic>

00801e94 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e9a:	83 ec 04             	sub    $0x4,%esp
  801e9d:	68 3c 2f 80 00       	push   $0x802f3c
  801ea2:	68 9b 00 00 00       	push   $0x9b
  801ea7:	68 4a 2e 80 00       	push   $0x802e4a
  801eac:	e8 85 ee ff ff       	call   800d36 <_panic>

00801eb1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	57                   	push   %edi
  801eb5:	56                   	push   %esi
  801eb6:	53                   	push   %ebx
  801eb7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ec6:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ec9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ecc:	cd 30                	int    $0x30
  801ece:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	5b                   	pop    %ebx
  801ed8:	5e                   	pop    %esi
  801ed9:	5f                   	pop    %edi
  801eda:	5d                   	pop    %ebp
  801edb:	c3                   	ret    

00801edc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ee8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	52                   	push   %edx
  801ef4:	ff 75 0c             	pushl  0xc(%ebp)
  801ef7:	50                   	push   %eax
  801ef8:	6a 00                	push   $0x0
  801efa:	e8 b2 ff ff ff       	call   801eb1 <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
}
  801f02:	90                   	nop
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 01                	push   $0x1
  801f14:	e8 98 ff ff ff       	call   801eb1 <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	52                   	push   %edx
  801f2e:	50                   	push   %eax
  801f2f:	6a 05                	push   $0x5
  801f31:	e8 7b ff ff ff       	call   801eb1 <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	56                   	push   %esi
  801f3f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f40:	8b 75 18             	mov    0x18(%ebp),%esi
  801f43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	56                   	push   %esi
  801f50:	53                   	push   %ebx
  801f51:	51                   	push   %ecx
  801f52:	52                   	push   %edx
  801f53:	50                   	push   %eax
  801f54:	6a 06                	push   $0x6
  801f56:	e8 56 ff ff ff       	call   801eb1 <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
}
  801f5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f61:	5b                   	pop    %ebx
  801f62:	5e                   	pop    %esi
  801f63:	5d                   	pop    %ebp
  801f64:	c3                   	ret    

00801f65 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	52                   	push   %edx
  801f75:	50                   	push   %eax
  801f76:	6a 07                	push   $0x7
  801f78:	e8 34 ff ff ff       	call   801eb1 <syscall>
  801f7d:	83 c4 18             	add    $0x18,%esp
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	ff 75 0c             	pushl  0xc(%ebp)
  801f8e:	ff 75 08             	pushl  0x8(%ebp)
  801f91:	6a 08                	push   $0x8
  801f93:	e8 19 ff ff ff       	call   801eb1 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 09                	push   $0x9
  801fac:	e8 00 ff ff ff       	call   801eb1 <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 0a                	push   $0xa
  801fc5:	e8 e7 fe ff ff       	call   801eb1 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 0b                	push   $0xb
  801fde:	e8 ce fe ff ff       	call   801eb1 <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	ff 75 0c             	pushl  0xc(%ebp)
  801ff4:	ff 75 08             	pushl  0x8(%ebp)
  801ff7:	6a 0f                	push   $0xf
  801ff9:	e8 b3 fe ff ff       	call   801eb1 <syscall>
  801ffe:	83 c4 18             	add    $0x18,%esp
	return;
  802001:	90                   	nop
}
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	ff 75 0c             	pushl  0xc(%ebp)
  802010:	ff 75 08             	pushl  0x8(%ebp)
  802013:	6a 10                	push   $0x10
  802015:	e8 97 fe ff ff       	call   801eb1 <syscall>
  80201a:	83 c4 18             	add    $0x18,%esp
	return ;
  80201d:	90                   	nop
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	ff 75 10             	pushl  0x10(%ebp)
  80202a:	ff 75 0c             	pushl  0xc(%ebp)
  80202d:	ff 75 08             	pushl  0x8(%ebp)
  802030:	6a 11                	push   $0x11
  802032:	e8 7a fe ff ff       	call   801eb1 <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
	return ;
  80203a:	90                   	nop
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 0c                	push   $0xc
  80204c:	e8 60 fe ff ff       	call   801eb1 <syscall>
  802051:	83 c4 18             	add    $0x18,%esp
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	ff 75 08             	pushl  0x8(%ebp)
  802064:	6a 0d                	push   $0xd
  802066:	e8 46 fe ff ff       	call   801eb1 <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 0e                	push   $0xe
  80207f:	e8 2d fe ff ff       	call   801eb1 <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
}
  802087:	90                   	nop
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 13                	push   $0x13
  802099:	e8 13 fe ff ff       	call   801eb1 <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
}
  8020a1:	90                   	nop
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 14                	push   $0x14
  8020b3:	e8 f9 fd ff ff       	call   801eb1 <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
}
  8020bb:	90                   	nop
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <sys_cputc>:


void
sys_cputc(const char c)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	83 ec 04             	sub    $0x4,%esp
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020ca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	50                   	push   %eax
  8020d7:	6a 15                	push   $0x15
  8020d9:	e8 d3 fd ff ff       	call   801eb1 <syscall>
  8020de:	83 c4 18             	add    $0x18,%esp
}
  8020e1:	90                   	nop
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 16                	push   $0x16
  8020f3:	e8 b9 fd ff ff       	call   801eb1 <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	90                   	nop
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	ff 75 0c             	pushl  0xc(%ebp)
  80210d:	50                   	push   %eax
  80210e:	6a 17                	push   $0x17
  802110:	e8 9c fd ff ff       	call   801eb1 <syscall>
  802115:	83 c4 18             	add    $0x18,%esp
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80211d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	52                   	push   %edx
  80212a:	50                   	push   %eax
  80212b:	6a 1a                	push   $0x1a
  80212d:	e8 7f fd ff ff       	call   801eb1 <syscall>
  802132:	83 c4 18             	add    $0x18,%esp
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80213a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	52                   	push   %edx
  802147:	50                   	push   %eax
  802148:	6a 18                	push   $0x18
  80214a:	e8 62 fd ff ff       	call   801eb1 <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
}
  802152:	90                   	nop
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802158:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	52                   	push   %edx
  802165:	50                   	push   %eax
  802166:	6a 19                	push   $0x19
  802168:	e8 44 fd ff ff       	call   801eb1 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	90                   	nop
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	83 ec 04             	sub    $0x4,%esp
  802179:	8b 45 10             	mov    0x10(%ebp),%eax
  80217c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80217f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802182:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	6a 00                	push   $0x0
  80218b:	51                   	push   %ecx
  80218c:	52                   	push   %edx
  80218d:	ff 75 0c             	pushl  0xc(%ebp)
  802190:	50                   	push   %eax
  802191:	6a 1b                	push   $0x1b
  802193:	e8 19 fd ff ff       	call   801eb1 <syscall>
  802198:	83 c4 18             	add    $0x18,%esp
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	52                   	push   %edx
  8021ad:	50                   	push   %eax
  8021ae:	6a 1c                	push   $0x1c
  8021b0:	e8 fc fc ff ff       	call   801eb1 <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	51                   	push   %ecx
  8021cb:	52                   	push   %edx
  8021cc:	50                   	push   %eax
  8021cd:	6a 1d                	push   $0x1d
  8021cf:	e8 dd fc ff ff       	call   801eb1 <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	52                   	push   %edx
  8021e9:	50                   	push   %eax
  8021ea:	6a 1e                	push   $0x1e
  8021ec:	e8 c0 fc ff ff       	call   801eb1 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 1f                	push   $0x1f
  802205:	e8 a7 fc ff ff       	call   801eb1 <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	6a 00                	push   $0x0
  802217:	ff 75 14             	pushl  0x14(%ebp)
  80221a:	ff 75 10             	pushl  0x10(%ebp)
  80221d:	ff 75 0c             	pushl  0xc(%ebp)
  802220:	50                   	push   %eax
  802221:	6a 20                	push   $0x20
  802223:	e8 89 fc ff ff       	call   801eb1 <syscall>
  802228:	83 c4 18             	add    $0x18,%esp
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	50                   	push   %eax
  80223c:	6a 21                	push   $0x21
  80223e:	e8 6e fc ff ff       	call   801eb1 <syscall>
  802243:	83 c4 18             	add    $0x18,%esp
}
  802246:	90                   	nop
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	50                   	push   %eax
  802258:	6a 22                	push   $0x22
  80225a:	e8 52 fc ff ff       	call   801eb1 <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 02                	push   $0x2
  802273:	e8 39 fc ff ff       	call   801eb1 <syscall>
  802278:	83 c4 18             	add    $0x18,%esp
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 03                	push   $0x3
  80228c:	e8 20 fc ff ff       	call   801eb1 <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 04                	push   $0x4
  8022a5:	e8 07 fc ff ff       	call   801eb1 <syscall>
  8022aa:	83 c4 18             	add    $0x18,%esp
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <sys_exit_env>:


void sys_exit_env(void)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 23                	push   $0x23
  8022be:	e8 ee fb ff ff       	call   801eb1 <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
}
  8022c6:	90                   	nop
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022cf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022d2:	8d 50 04             	lea    0x4(%eax),%edx
  8022d5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	52                   	push   %edx
  8022df:	50                   	push   %eax
  8022e0:	6a 24                	push   $0x24
  8022e2:	e8 ca fb ff ff       	call   801eb1 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
	return result;
  8022ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022f3:	89 01                	mov    %eax,(%ecx)
  8022f5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	c9                   	leave  
  8022fc:	c2 04 00             	ret    $0x4

008022ff <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	ff 75 10             	pushl  0x10(%ebp)
  802309:	ff 75 0c             	pushl  0xc(%ebp)
  80230c:	ff 75 08             	pushl  0x8(%ebp)
  80230f:	6a 12                	push   $0x12
  802311:	e8 9b fb ff ff       	call   801eb1 <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
	return ;
  802319:	90                   	nop
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <sys_rcr2>:
uint32 sys_rcr2()
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 25                	push   $0x25
  80232b:	e8 81 fb ff ff       	call   801eb1 <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 04             	sub    $0x4,%esp
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802341:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	50                   	push   %eax
  80234e:	6a 26                	push   $0x26
  802350:	e8 5c fb ff ff       	call   801eb1 <syscall>
  802355:	83 c4 18             	add    $0x18,%esp
	return ;
  802358:	90                   	nop
}
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <rsttst>:
void rsttst()
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 28                	push   $0x28
  80236a:	e8 42 fb ff ff       	call   801eb1 <syscall>
  80236f:	83 c4 18             	add    $0x18,%esp
	return ;
  802372:	90                   	nop
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	83 ec 04             	sub    $0x4,%esp
  80237b:	8b 45 14             	mov    0x14(%ebp),%eax
  80237e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802381:	8b 55 18             	mov    0x18(%ebp),%edx
  802384:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802388:	52                   	push   %edx
  802389:	50                   	push   %eax
  80238a:	ff 75 10             	pushl  0x10(%ebp)
  80238d:	ff 75 0c             	pushl  0xc(%ebp)
  802390:	ff 75 08             	pushl  0x8(%ebp)
  802393:	6a 27                	push   $0x27
  802395:	e8 17 fb ff ff       	call   801eb1 <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
	return ;
  80239d:	90                   	nop
}
  80239e:	c9                   	leave  
  80239f:	c3                   	ret    

008023a0 <chktst>:
void chktst(uint32 n)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	ff 75 08             	pushl  0x8(%ebp)
  8023ae:	6a 29                	push   $0x29
  8023b0:	e8 fc fa ff ff       	call   801eb1 <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b8:	90                   	nop
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <inctst>:

void inctst()
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 2a                	push   $0x2a
  8023ca:	e8 e2 fa ff ff       	call   801eb1 <syscall>
  8023cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d2:	90                   	nop
}
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <gettst>:
uint32 gettst()
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 2b                	push   $0x2b
  8023e4:	e8 c8 fa ff ff       	call   801eb1 <syscall>
  8023e9:	83 c4 18             	add    $0x18,%esp
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 2c                	push   $0x2c
  802400:	e8 ac fa ff ff       	call   801eb1 <syscall>
  802405:	83 c4 18             	add    $0x18,%esp
  802408:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80240b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80240f:	75 07                	jne    802418 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802411:	b8 01 00 00 00       	mov    $0x1,%eax
  802416:	eb 05                	jmp    80241d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802418:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80241d:	c9                   	leave  
  80241e:	c3                   	ret    

0080241f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
  802422:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 2c                	push   $0x2c
  802431:	e8 7b fa ff ff       	call   801eb1 <syscall>
  802436:	83 c4 18             	add    $0x18,%esp
  802439:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80243c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802440:	75 07                	jne    802449 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802442:	b8 01 00 00 00       	mov    $0x1,%eax
  802447:	eb 05                	jmp    80244e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802449:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244e:	c9                   	leave  
  80244f:	c3                   	ret    

00802450 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 2c                	push   $0x2c
  802462:	e8 4a fa ff ff       	call   801eb1 <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
  80246a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80246d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802471:	75 07                	jne    80247a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802473:	b8 01 00 00 00       	mov    $0x1,%eax
  802478:	eb 05                	jmp    80247f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80247a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 2c                	push   $0x2c
  802493:	e8 19 fa ff ff       	call   801eb1 <syscall>
  802498:	83 c4 18             	add    $0x18,%esp
  80249b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80249e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024a2:	75 07                	jne    8024ab <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a9:	eb 05                	jmp    8024b0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	ff 75 08             	pushl  0x8(%ebp)
  8024c0:	6a 2d                	push   $0x2d
  8024c2:	e8 ea f9 ff ff       	call   801eb1 <syscall>
  8024c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ca:	90                   	nop
}
  8024cb:	c9                   	leave  
  8024cc:	c3                   	ret    

008024cd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024cd:	55                   	push   %ebp
  8024ce:	89 e5                	mov    %esp,%ebp
  8024d0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024da:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dd:	6a 00                	push   $0x0
  8024df:	53                   	push   %ebx
  8024e0:	51                   	push   %ecx
  8024e1:	52                   	push   %edx
  8024e2:	50                   	push   %eax
  8024e3:	6a 2e                	push   $0x2e
  8024e5:	e8 c7 f9 ff ff       	call   801eb1 <syscall>
  8024ea:	83 c4 18             	add    $0x18,%esp
}
  8024ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	52                   	push   %edx
  802502:	50                   	push   %eax
  802503:	6a 2f                	push   $0x2f
  802505:	e8 a7 f9 ff ff       	call   801eb1 <syscall>
  80250a:	83 c4 18             	add    $0x18,%esp
}
  80250d:	c9                   	leave  
  80250e:	c3                   	ret    
  80250f:	90                   	nop

00802510 <__udivdi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	53                   	push   %ebx
  802514:	83 ec 1c             	sub    $0x1c,%esp
  802517:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80251b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80251f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802523:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802527:	89 ca                	mov    %ecx,%edx
  802529:	89 f8                	mov    %edi,%eax
  80252b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80252f:	85 f6                	test   %esi,%esi
  802531:	75 2d                	jne    802560 <__udivdi3+0x50>
  802533:	39 cf                	cmp    %ecx,%edi
  802535:	77 65                	ja     80259c <__udivdi3+0x8c>
  802537:	89 fd                	mov    %edi,%ebp
  802539:	85 ff                	test   %edi,%edi
  80253b:	75 0b                	jne    802548 <__udivdi3+0x38>
  80253d:	b8 01 00 00 00       	mov    $0x1,%eax
  802542:	31 d2                	xor    %edx,%edx
  802544:	f7 f7                	div    %edi
  802546:	89 c5                	mov    %eax,%ebp
  802548:	31 d2                	xor    %edx,%edx
  80254a:	89 c8                	mov    %ecx,%eax
  80254c:	f7 f5                	div    %ebp
  80254e:	89 c1                	mov    %eax,%ecx
  802550:	89 d8                	mov    %ebx,%eax
  802552:	f7 f5                	div    %ebp
  802554:	89 cf                	mov    %ecx,%edi
  802556:	89 fa                	mov    %edi,%edx
  802558:	83 c4 1c             	add    $0x1c,%esp
  80255b:	5b                   	pop    %ebx
  80255c:	5e                   	pop    %esi
  80255d:	5f                   	pop    %edi
  80255e:	5d                   	pop    %ebp
  80255f:	c3                   	ret    
  802560:	39 ce                	cmp    %ecx,%esi
  802562:	77 28                	ja     80258c <__udivdi3+0x7c>
  802564:	0f bd fe             	bsr    %esi,%edi
  802567:	83 f7 1f             	xor    $0x1f,%edi
  80256a:	75 40                	jne    8025ac <__udivdi3+0x9c>
  80256c:	39 ce                	cmp    %ecx,%esi
  80256e:	72 0a                	jb     80257a <__udivdi3+0x6a>
  802570:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802574:	0f 87 9e 00 00 00    	ja     802618 <__udivdi3+0x108>
  80257a:	b8 01 00 00 00       	mov    $0x1,%eax
  80257f:	89 fa                	mov    %edi,%edx
  802581:	83 c4 1c             	add    $0x1c,%esp
  802584:	5b                   	pop    %ebx
  802585:	5e                   	pop    %esi
  802586:	5f                   	pop    %edi
  802587:	5d                   	pop    %ebp
  802588:	c3                   	ret    
  802589:	8d 76 00             	lea    0x0(%esi),%esi
  80258c:	31 ff                	xor    %edi,%edi
  80258e:	31 c0                	xor    %eax,%eax
  802590:	89 fa                	mov    %edi,%edx
  802592:	83 c4 1c             	add    $0x1c,%esp
  802595:	5b                   	pop    %ebx
  802596:	5e                   	pop    %esi
  802597:	5f                   	pop    %edi
  802598:	5d                   	pop    %ebp
  802599:	c3                   	ret    
  80259a:	66 90                	xchg   %ax,%ax
  80259c:	89 d8                	mov    %ebx,%eax
  80259e:	f7 f7                	div    %edi
  8025a0:	31 ff                	xor    %edi,%edi
  8025a2:	89 fa                	mov    %edi,%edx
  8025a4:	83 c4 1c             	add    $0x1c,%esp
  8025a7:	5b                   	pop    %ebx
  8025a8:	5e                   	pop    %esi
  8025a9:	5f                   	pop    %edi
  8025aa:	5d                   	pop    %ebp
  8025ab:	c3                   	ret    
  8025ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8025b1:	89 eb                	mov    %ebp,%ebx
  8025b3:	29 fb                	sub    %edi,%ebx
  8025b5:	89 f9                	mov    %edi,%ecx
  8025b7:	d3 e6                	shl    %cl,%esi
  8025b9:	89 c5                	mov    %eax,%ebp
  8025bb:	88 d9                	mov    %bl,%cl
  8025bd:	d3 ed                	shr    %cl,%ebp
  8025bf:	89 e9                	mov    %ebp,%ecx
  8025c1:	09 f1                	or     %esi,%ecx
  8025c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8025c7:	89 f9                	mov    %edi,%ecx
  8025c9:	d3 e0                	shl    %cl,%eax
  8025cb:	89 c5                	mov    %eax,%ebp
  8025cd:	89 d6                	mov    %edx,%esi
  8025cf:	88 d9                	mov    %bl,%cl
  8025d1:	d3 ee                	shr    %cl,%esi
  8025d3:	89 f9                	mov    %edi,%ecx
  8025d5:	d3 e2                	shl    %cl,%edx
  8025d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025db:	88 d9                	mov    %bl,%cl
  8025dd:	d3 e8                	shr    %cl,%eax
  8025df:	09 c2                	or     %eax,%edx
  8025e1:	89 d0                	mov    %edx,%eax
  8025e3:	89 f2                	mov    %esi,%edx
  8025e5:	f7 74 24 0c          	divl   0xc(%esp)
  8025e9:	89 d6                	mov    %edx,%esi
  8025eb:	89 c3                	mov    %eax,%ebx
  8025ed:	f7 e5                	mul    %ebp
  8025ef:	39 d6                	cmp    %edx,%esi
  8025f1:	72 19                	jb     80260c <__udivdi3+0xfc>
  8025f3:	74 0b                	je     802600 <__udivdi3+0xf0>
  8025f5:	89 d8                	mov    %ebx,%eax
  8025f7:	31 ff                	xor    %edi,%edi
  8025f9:	e9 58 ff ff ff       	jmp    802556 <__udivdi3+0x46>
  8025fe:	66 90                	xchg   %ax,%ax
  802600:	8b 54 24 08          	mov    0x8(%esp),%edx
  802604:	89 f9                	mov    %edi,%ecx
  802606:	d3 e2                	shl    %cl,%edx
  802608:	39 c2                	cmp    %eax,%edx
  80260a:	73 e9                	jae    8025f5 <__udivdi3+0xe5>
  80260c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80260f:	31 ff                	xor    %edi,%edi
  802611:	e9 40 ff ff ff       	jmp    802556 <__udivdi3+0x46>
  802616:	66 90                	xchg   %ax,%ax
  802618:	31 c0                	xor    %eax,%eax
  80261a:	e9 37 ff ff ff       	jmp    802556 <__udivdi3+0x46>
  80261f:	90                   	nop

00802620 <__umoddi3>:
  802620:	55                   	push   %ebp
  802621:	57                   	push   %edi
  802622:	56                   	push   %esi
  802623:	53                   	push   %ebx
  802624:	83 ec 1c             	sub    $0x1c,%esp
  802627:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80262b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80262f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802633:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802637:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80263b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80263f:	89 f3                	mov    %esi,%ebx
  802641:	89 fa                	mov    %edi,%edx
  802643:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802647:	89 34 24             	mov    %esi,(%esp)
  80264a:	85 c0                	test   %eax,%eax
  80264c:	75 1a                	jne    802668 <__umoddi3+0x48>
  80264e:	39 f7                	cmp    %esi,%edi
  802650:	0f 86 a2 00 00 00    	jbe    8026f8 <__umoddi3+0xd8>
  802656:	89 c8                	mov    %ecx,%eax
  802658:	89 f2                	mov    %esi,%edx
  80265a:	f7 f7                	div    %edi
  80265c:	89 d0                	mov    %edx,%eax
  80265e:	31 d2                	xor    %edx,%edx
  802660:	83 c4 1c             	add    $0x1c,%esp
  802663:	5b                   	pop    %ebx
  802664:	5e                   	pop    %esi
  802665:	5f                   	pop    %edi
  802666:	5d                   	pop    %ebp
  802667:	c3                   	ret    
  802668:	39 f0                	cmp    %esi,%eax
  80266a:	0f 87 ac 00 00 00    	ja     80271c <__umoddi3+0xfc>
  802670:	0f bd e8             	bsr    %eax,%ebp
  802673:	83 f5 1f             	xor    $0x1f,%ebp
  802676:	0f 84 ac 00 00 00    	je     802728 <__umoddi3+0x108>
  80267c:	bf 20 00 00 00       	mov    $0x20,%edi
  802681:	29 ef                	sub    %ebp,%edi
  802683:	89 fe                	mov    %edi,%esi
  802685:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802689:	89 e9                	mov    %ebp,%ecx
  80268b:	d3 e0                	shl    %cl,%eax
  80268d:	89 d7                	mov    %edx,%edi
  80268f:	89 f1                	mov    %esi,%ecx
  802691:	d3 ef                	shr    %cl,%edi
  802693:	09 c7                	or     %eax,%edi
  802695:	89 e9                	mov    %ebp,%ecx
  802697:	d3 e2                	shl    %cl,%edx
  802699:	89 14 24             	mov    %edx,(%esp)
  80269c:	89 d8                	mov    %ebx,%eax
  80269e:	d3 e0                	shl    %cl,%eax
  8026a0:	89 c2                	mov    %eax,%edx
  8026a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026a6:	d3 e0                	shl    %cl,%eax
  8026a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026b0:	89 f1                	mov    %esi,%ecx
  8026b2:	d3 e8                	shr    %cl,%eax
  8026b4:	09 d0                	or     %edx,%eax
  8026b6:	d3 eb                	shr    %cl,%ebx
  8026b8:	89 da                	mov    %ebx,%edx
  8026ba:	f7 f7                	div    %edi
  8026bc:	89 d3                	mov    %edx,%ebx
  8026be:	f7 24 24             	mull   (%esp)
  8026c1:	89 c6                	mov    %eax,%esi
  8026c3:	89 d1                	mov    %edx,%ecx
  8026c5:	39 d3                	cmp    %edx,%ebx
  8026c7:	0f 82 87 00 00 00    	jb     802754 <__umoddi3+0x134>
  8026cd:	0f 84 91 00 00 00    	je     802764 <__umoddi3+0x144>
  8026d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026d7:	29 f2                	sub    %esi,%edx
  8026d9:	19 cb                	sbb    %ecx,%ebx
  8026db:	89 d8                	mov    %ebx,%eax
  8026dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8026e1:	d3 e0                	shl    %cl,%eax
  8026e3:	89 e9                	mov    %ebp,%ecx
  8026e5:	d3 ea                	shr    %cl,%edx
  8026e7:	09 d0                	or     %edx,%eax
  8026e9:	89 e9                	mov    %ebp,%ecx
  8026eb:	d3 eb                	shr    %cl,%ebx
  8026ed:	89 da                	mov    %ebx,%edx
  8026ef:	83 c4 1c             	add    $0x1c,%esp
  8026f2:	5b                   	pop    %ebx
  8026f3:	5e                   	pop    %esi
  8026f4:	5f                   	pop    %edi
  8026f5:	5d                   	pop    %ebp
  8026f6:	c3                   	ret    
  8026f7:	90                   	nop
  8026f8:	89 fd                	mov    %edi,%ebp
  8026fa:	85 ff                	test   %edi,%edi
  8026fc:	75 0b                	jne    802709 <__umoddi3+0xe9>
  8026fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802703:	31 d2                	xor    %edx,%edx
  802705:	f7 f7                	div    %edi
  802707:	89 c5                	mov    %eax,%ebp
  802709:	89 f0                	mov    %esi,%eax
  80270b:	31 d2                	xor    %edx,%edx
  80270d:	f7 f5                	div    %ebp
  80270f:	89 c8                	mov    %ecx,%eax
  802711:	f7 f5                	div    %ebp
  802713:	89 d0                	mov    %edx,%eax
  802715:	e9 44 ff ff ff       	jmp    80265e <__umoddi3+0x3e>
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	89 c8                	mov    %ecx,%eax
  80271e:	89 f2                	mov    %esi,%edx
  802720:	83 c4 1c             	add    $0x1c,%esp
  802723:	5b                   	pop    %ebx
  802724:	5e                   	pop    %esi
  802725:	5f                   	pop    %edi
  802726:	5d                   	pop    %ebp
  802727:	c3                   	ret    
  802728:	3b 04 24             	cmp    (%esp),%eax
  80272b:	72 06                	jb     802733 <__umoddi3+0x113>
  80272d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802731:	77 0f                	ja     802742 <__umoddi3+0x122>
  802733:	89 f2                	mov    %esi,%edx
  802735:	29 f9                	sub    %edi,%ecx
  802737:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80273b:	89 14 24             	mov    %edx,(%esp)
  80273e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802742:	8b 44 24 04          	mov    0x4(%esp),%eax
  802746:	8b 14 24             	mov    (%esp),%edx
  802749:	83 c4 1c             	add    $0x1c,%esp
  80274c:	5b                   	pop    %ebx
  80274d:	5e                   	pop    %esi
  80274e:	5f                   	pop    %edi
  80274f:	5d                   	pop    %ebp
  802750:	c3                   	ret    
  802751:	8d 76 00             	lea    0x0(%esi),%esi
  802754:	2b 04 24             	sub    (%esp),%eax
  802757:	19 fa                	sbb    %edi,%edx
  802759:	89 d1                	mov    %edx,%ecx
  80275b:	89 c6                	mov    %eax,%esi
  80275d:	e9 71 ff ff ff       	jmp    8026d3 <__umoddi3+0xb3>
  802762:	66 90                	xchg   %ax,%ax
  802764:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802768:	72 ea                	jb     802754 <__umoddi3+0x134>
  80276a:	89 d9                	mov    %ebx,%ecx
  80276c:	e9 62 ff ff ff       	jmp    8026d3 <__umoddi3+0xb3>
