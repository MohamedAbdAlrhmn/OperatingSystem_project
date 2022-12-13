
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
  800031:	e8 50 0d 00 00       	call   800d86 <libmain>
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
  800045:	e8 76 28 00 00       	call   8028c0 <sys_set_uheap_strategy>
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
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
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
  80009b:	68 e0 41 80 00       	push   $0x8041e0
  8000a0:	6a 16                	push   $0x16
  8000a2:	68 fc 41 80 00       	push   $0x8041fc
  8000a7:	e8 16 0e 00 00       	call   800ec2 <_panic>
	}

	int envID = sys_getenvid();
  8000ac:	e8 c1 25 00 00       	call   802672 <sys_getenvid>
  8000b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b4:	83 ec 0c             	sub    $0xc,%esp
  8000b7:	6a 00                	push   $0x0
  8000b9:	e8 40 20 00 00       	call   8020fe <malloc>
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
  8000e0:	e8 c6 22 00 00       	call   8023ab <sys_calculate_free_frames>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e8:	e8 5e 23 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	6a 01                	push   $0x1
  8000f8:	50                   	push   %eax
  8000f9:	68 13 42 80 00       	push   $0x804213
  8000fe:	e8 43 20 00 00       	call   802146 <smalloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if (ptr_allocations[0] != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800109:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80010c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800111:	74 14                	je     800127 <_main+0xef>
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 18 42 80 00       	push   $0x804218
  80011b:	6a 2a                	push   $0x2a
  80011d:	68 fc 41 80 00       	push   $0x8041fc
  800122:	e8 9b 0d 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  256+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800127:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80012a:	e8 7c 22 00 00       	call   8023ab <sys_calculate_free_frames>
  80012f:	29 c3                	sub    %eax,%ebx
  800131:	89 d8                	mov    %ebx,%eax
  800133:	3d 03 01 00 00       	cmp    $0x103,%eax
  800138:	74 14                	je     80014e <_main+0x116>
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	68 84 42 80 00       	push   $0x804284
  800142:	6a 2b                	push   $0x2b
  800144:	68 fc 41 80 00       	push   $0x8041fc
  800149:	e8 74 0d 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014e:	e8 f8 22 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800153:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 02 43 80 00       	push   $0x804302
  800160:	6a 2c                	push   $0x2c
  800162:	68 fc 41 80 00       	push   $0x8041fc
  800167:	e8 56 0d 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80016c:	e8 3a 22 00 00       	call   8023ab <sys_calculate_free_frames>
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800174:	e8 d2 22 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800179:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80017c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80017f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	e8 73 1f 00 00       	call   8020fe <malloc>
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
  8001a5:	68 20 43 80 00       	push   $0x804320
  8001aa:	6a 32                	push   $0x32
  8001ac:	68 fc 41 80 00       	push   $0x8041fc
  8001b1:	e8 0c 0d 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b6:	e8 90 22 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8001bb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 02 43 80 00       	push   $0x804302
  8001c8:	6a 34                	push   $0x34
  8001ca:	68 fc 41 80 00       	push   $0x8041fc
  8001cf:	e8 ee 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001d4:	e8 d2 21 00 00       	call   8023ab <sys_calculate_free_frames>
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001de:	39 c2                	cmp    %eax,%edx
  8001e0:	74 14                	je     8001f6 <_main+0x1be>
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	68 50 43 80 00       	push   $0x804350
  8001ea:	6a 35                	push   $0x35
  8001ec:	68 fc 41 80 00       	push   $0x8041fc
  8001f1:	e8 cc 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f6:	e8 b0 21 00 00       	call   8023ab <sys_calculate_free_frames>
  8001fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fe:	e8 48 22 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800203:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800209:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	50                   	push   %eax
  800210:	e8 e9 1e 00 00       	call   8020fe <malloc>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  80021b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80021e:	89 c2                	mov    %eax,%edx
  800220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800223:	01 c0                	add    %eax,%eax
  800225:	05 00 00 00 80       	add    $0x80000000,%eax
  80022a:	39 c2                	cmp    %eax,%edx
  80022c:	74 14                	je     800242 <_main+0x20a>
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	68 20 43 80 00       	push   $0x804320
  800236:	6a 3b                	push   $0x3b
  800238:	68 fc 41 80 00       	push   $0x8041fc
  80023d:	e8 80 0c 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800242:	e8 04 22 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800247:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80024a:	74 14                	je     800260 <_main+0x228>
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	68 02 43 80 00       	push   $0x804302
  800254:	6a 3d                	push   $0x3d
  800256:	68 fc 41 80 00       	push   $0x8041fc
  80025b:	e8 62 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800260:	e8 46 21 00 00       	call   8023ab <sys_calculate_free_frames>
  800265:	89 c2                	mov    %eax,%edx
  800267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026a:	39 c2                	cmp    %eax,%edx
  80026c:	74 14                	je     800282 <_main+0x24a>
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	68 50 43 80 00       	push   $0x804350
  800276:	6a 3e                	push   $0x3e
  800278:	68 fc 41 80 00       	push   $0x8041fc
  80027d:	e8 40 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800282:	e8 24 21 00 00       	call   8023ab <sys_calculate_free_frames>
  800287:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80028a:	e8 bc 21 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  80028f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800292:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800295:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	50                   	push   %eax
  80029c:	e8 5d 1e 00 00       	call   8020fe <malloc>
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8002a7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002aa:	89 c1                	mov    %eax,%ecx
  8002ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002af:	89 c2                	mov    %eax,%edx
  8002b1:	01 d2                	add    %edx,%edx
  8002b3:	01 d0                	add    %edx,%eax
  8002b5:	05 00 00 00 80       	add    $0x80000000,%eax
  8002ba:	39 c1                	cmp    %eax,%ecx
  8002bc:	74 14                	je     8002d2 <_main+0x29a>
  8002be:	83 ec 04             	sub    $0x4,%esp
  8002c1:	68 20 43 80 00       	push   $0x804320
  8002c6:	6a 44                	push   $0x44
  8002c8:	68 fc 41 80 00       	push   $0x8041fc
  8002cd:	e8 f0 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002d2:	e8 74 21 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8002d7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 02 43 80 00       	push   $0x804302
  8002e4:	6a 46                	push   $0x46
  8002e6:	68 fc 41 80 00       	push   $0x8041fc
  8002eb:	e8 d2 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002f0:	e8 b6 20 00 00       	call   8023ab <sys_calculate_free_frames>
  8002f5:	89 c2                	mov    %eax,%edx
  8002f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 50 43 80 00       	push   $0x804350
  800306:	6a 47                	push   $0x47
  800308:	68 fc 41 80 00       	push   $0x8041fc
  80030d:	e8 b0 0b 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800312:	e8 94 20 00 00       	call   8023ab <sys_calculate_free_frames>
  800317:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80031a:	e8 2c 21 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  80031f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800325:	01 c0                	add    %eax,%eax
  800327:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032a:	83 ec 0c             	sub    $0xc,%esp
  80032d:	50                   	push   %eax
  80032e:	e8 cb 1d 00 00       	call   8020fe <malloc>
  800333:	83 c4 10             	add    $0x10,%esp
  800336:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800339:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80033c:	89 c2                	mov    %eax,%edx
  80033e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800341:	c1 e0 02             	shl    $0x2,%eax
  800344:	05 00 00 00 80       	add    $0x80000000,%eax
  800349:	39 c2                	cmp    %eax,%edx
  80034b:	74 14                	je     800361 <_main+0x329>
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	68 20 43 80 00       	push   $0x804320
  800355:	6a 4d                	push   $0x4d
  800357:	68 fc 41 80 00       	push   $0x8041fc
  80035c:	e8 61 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800361:	e8 e5 20 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800366:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800369:	74 14                	je     80037f <_main+0x347>
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	68 02 43 80 00       	push   $0x804302
  800373:	6a 4f                	push   $0x4f
  800375:	68 fc 41 80 00       	push   $0x8041fc
  80037a:	e8 43 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80037f:	e8 27 20 00 00       	call   8023ab <sys_calculate_free_frames>
  800384:	89 c2                	mov    %eax,%edx
  800386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	74 14                	je     8003a1 <_main+0x369>
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	68 50 43 80 00       	push   $0x804350
  800395:	6a 50                	push   $0x50
  800397:	68 fc 41 80 00       	push   $0x8041fc
  80039c:	e8 21 0b 00 00       	call   800ec2 <_panic>

		//Allocate Shared 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003a1:	e8 05 20 00 00       	call   8023ab <sys_calculate_free_frames>
  8003a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a9:	e8 9d 20 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8003ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  8003b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b4:	01 c0                	add    %eax,%eax
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	50                   	push   %eax
  8003bc:	68 63 43 80 00       	push   $0x804363
  8003c1:	e8 80 1d 00 00       	call   802146 <smalloc>
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (ptr_allocations[5] != (uint32*)(USER_HEAP_START + 6*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8003cc:	8b 4d a0             	mov    -0x60(%ebp),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	01 c0                	add    %eax,%eax
  8003da:	05 00 00 00 80       	add    $0x80000000,%eax
  8003df:	39 c1                	cmp    %eax,%ecx
  8003e1:	74 14                	je     8003f7 <_main+0x3bf>
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	68 18 42 80 00       	push   $0x804218
  8003eb:	6a 56                	push   $0x56
  8003ed:	68 fc 41 80 00       	push   $0x8041fc
  8003f2:	e8 cb 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  512+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8003f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003fa:	e8 ac 1f 00 00       	call   8023ab <sys_calculate_free_frames>
  8003ff:	29 c3                	sub    %eax,%ebx
  800401:	89 d8                	mov    %ebx,%eax
  800403:	3d 03 02 00 00       	cmp    $0x203,%eax
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 84 42 80 00       	push   $0x804284
  800412:	6a 57                	push   $0x57
  800414:	68 fc 41 80 00       	push   $0x8041fc
  800419:	e8 a4 0a 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80041e:	e8 28 20 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800423:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800426:	74 14                	je     80043c <_main+0x404>
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	68 02 43 80 00       	push   $0x804302
  800430:	6a 58                	push   $0x58
  800432:	68 fc 41 80 00       	push   $0x8041fc
  800437:	e8 86 0a 00 00       	call   800ec2 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80043c:	e8 6a 1f 00 00       	call   8023ab <sys_calculate_free_frames>
  800441:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800444:	e8 02 20 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800449:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  80044c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044f:	89 c2                	mov    %eax,%edx
  800451:	01 d2                	add    %edx,%edx
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	50                   	push   %eax
  80045c:	e8 9d 1c 00 00       	call   8020fe <malloc>
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800467:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80046a:	89 c2                	mov    %eax,%edx
  80046c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046f:	c1 e0 03             	shl    $0x3,%eax
  800472:	05 00 00 00 80       	add    $0x80000000,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 20 43 80 00       	push   $0x804320
  800483:	6a 5e                	push   $0x5e
  800485:	68 fc 41 80 00       	push   $0x8041fc
  80048a:	e8 33 0a 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80048f:	e8 b7 1f 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800494:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800497:	74 14                	je     8004ad <_main+0x475>
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 02 43 80 00       	push   $0x804302
  8004a1:	6a 60                	push   $0x60
  8004a3:	68 fc 41 80 00       	push   $0x8041fc
  8004a8:	e8 15 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8004ad:	e8 f9 1e 00 00       	call   8023ab <sys_calculate_free_frames>
  8004b2:	89 c2                	mov    %eax,%edx
  8004b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b7:	39 c2                	cmp    %eax,%edx
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 50 43 80 00       	push   $0x804350
  8004c3:	6a 61                	push   $0x61
  8004c5:	68 fc 41 80 00       	push   $0x8041fc
  8004ca:	e8 f3 09 00 00       	call   800ec2 <_panic>

		//Allocate Shared 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004cf:	e8 d7 1e 00 00       	call   8023ab <sys_calculate_free_frames>
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004d7:	e8 6f 1f 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8004dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8004df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	01 d2                	add    %edx,%edx
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	6a 00                	push   $0x0
  8004ed:	50                   	push   %eax
  8004ee:	68 65 43 80 00       	push   $0x804365
  8004f3:	e8 4e 1c 00 00       	call   802146 <smalloc>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if (ptr_allocations[7] != (uint32*)(USER_HEAP_START + 11*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8004fe:	8b 4d a8             	mov    -0x58(%ebp),%ecx
  800501:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	c1 e0 02             	shl    $0x2,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	01 c0                	add    %eax,%eax
  80050d:	01 d0                	add    %edx,%eax
  80050f:	05 00 00 00 80       	add    $0x80000000,%eax
  800514:	39 c1                	cmp    %eax,%ecx
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 18 42 80 00       	push   $0x804218
  800520:	6a 67                	push   $0x67
  800522:	68 fc 41 80 00       	push   $0x8041fc
  800527:	e8 96 09 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80052c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052f:	e8 77 1e 00 00       	call   8023ab <sys_calculate_free_frames>
  800534:	29 c3                	sub    %eax,%ebx
  800536:	89 d8                	mov    %ebx,%eax
  800538:	3d 04 03 00 00       	cmp    $0x304,%eax
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 84 42 80 00       	push   $0x804284
  800547:	6a 68                	push   $0x68
  800549:	68 fc 41 80 00       	push   $0x8041fc
  80054e:	e8 6f 09 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800553:	e8 f3 1e 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800558:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 02 43 80 00       	push   $0x804302
  800565:	6a 69                	push   $0x69
  800567:	68 fc 41 80 00       	push   $0x8041fc
  80056c:	e8 51 09 00 00       	call   800ec2 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800571:	e8 35 1e 00 00       	call   8023ab <sys_calculate_free_frames>
  800576:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800579:	e8 cd 1e 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  80057e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800581:	8b 45 90             	mov    -0x70(%ebp),%eax
  800584:	83 ec 0c             	sub    $0xc,%esp
  800587:	50                   	push   %eax
  800588:	e8 9f 1b 00 00       	call   80212c <free>
  80058d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800590:	e8 b6 1e 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800595:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800598:	74 14                	je     8005ae <_main+0x576>
  80059a:	83 ec 04             	sub    $0x4,%esp
  80059d:	68 67 43 80 00       	push   $0x804367
  8005a2:	6a 73                	push   $0x73
  8005a4:	68 fc 41 80 00       	push   $0x8041fc
  8005a9:	e8 14 09 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ae:	e8 f8 1d 00 00       	call   8023ab <sys_calculate_free_frames>
  8005b3:	89 c2                	mov    %eax,%edx
  8005b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b8:	39 c2                	cmp    %eax,%edx
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 7e 43 80 00       	push   $0x80437e
  8005c4:	6a 74                	push   $0x74
  8005c6:	68 fc 41 80 00       	push   $0x8041fc
  8005cb:	e8 f2 08 00 00       	call   800ec2 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d0:	e8 d6 1d 00 00       	call   8023ab <sys_calculate_free_frames>
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005d8:	e8 6e 1e 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8005e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	50                   	push   %eax
  8005e7:	e8 40 1b 00 00       	call   80212c <free>
  8005ec:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005ef:	e8 57 1e 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 14                	je     80060d <_main+0x5d5>
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 67 43 80 00       	push   $0x804367
  800601:	6a 7b                	push   $0x7b
  800603:	68 fc 41 80 00       	push   $0x8041fc
  800608:	e8 b5 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80060d:	e8 99 1d 00 00       	call   8023ab <sys_calculate_free_frames>
  800612:	89 c2                	mov    %eax,%edx
  800614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800617:	39 c2                	cmp    %eax,%edx
  800619:	74 14                	je     80062f <_main+0x5f7>
  80061b:	83 ec 04             	sub    $0x4,%esp
  80061e:	68 7e 43 80 00       	push   $0x80437e
  800623:	6a 7c                	push   $0x7c
  800625:	68 fc 41 80 00       	push   $0x8041fc
  80062a:	e8 93 08 00 00       	call   800ec2 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80062f:	e8 77 1d 00 00       	call   8023ab <sys_calculate_free_frames>
  800634:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800637:	e8 0f 1e 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  80063c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80063f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	50                   	push   %eax
  800646:	e8 e1 1a 00 00       	call   80212c <free>
  80064b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80064e:	e8 f8 1d 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800653:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800656:	74 17                	je     80066f <_main+0x637>
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	68 67 43 80 00       	push   $0x804367
  800660:	68 83 00 00 00       	push   $0x83
  800665:	68 fc 41 80 00       	push   $0x8041fc
  80066a:	e8 53 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80066f:	e8 37 1d 00 00       	call   8023ab <sys_calculate_free_frames>
  800674:	89 c2                	mov    %eax,%edx
  800676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800679:	39 c2                	cmp    %eax,%edx
  80067b:	74 17                	je     800694 <_main+0x65c>
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	68 7e 43 80 00       	push   $0x80437e
  800685:	68 84 00 00 00       	push   $0x84
  80068a:	68 fc 41 80 00       	push   $0x8041fc
  80068f:	e8 2e 08 00 00       	call   800ec2 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800694:	e8 12 1d 00 00       	call   8023ab <sys_calculate_free_frames>
  800699:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069c:	e8 aa 1d 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8006a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8006a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006a7:	89 d0                	mov    %edx,%eax
  8006a9:	c1 e0 09             	shl    $0x9,%eax
  8006ac:	29 d0                	sub    %edx,%eax
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	50                   	push   %eax
  8006b2:	e8 47 1a 00 00       	call   8020fe <malloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8006bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006c5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ca:	39 c2                	cmp    %eax,%edx
  8006cc:	74 17                	je     8006e5 <_main+0x6ad>
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 20 43 80 00       	push   $0x804320
  8006d6:	68 8d 00 00 00       	push   $0x8d
  8006db:	68 fc 41 80 00       	push   $0x8041fc
  8006e0:	e8 dd 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006e5:	e8 61 1d 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8006ea:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006ed:	74 17                	je     800706 <_main+0x6ce>
  8006ef:	83 ec 04             	sub    $0x4,%esp
  8006f2:	68 02 43 80 00       	push   $0x804302
  8006f7:	68 8f 00 00 00       	push   $0x8f
  8006fc:	68 fc 41 80 00       	push   $0x8041fc
  800701:	e8 bc 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800706:	e8 a0 1c 00 00       	call   8023ab <sys_calculate_free_frames>
  80070b:	89 c2                	mov    %eax,%edx
  80070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800710:	39 c2                	cmp    %eax,%edx
  800712:	74 17                	je     80072b <_main+0x6f3>
  800714:	83 ec 04             	sub    $0x4,%esp
  800717:	68 50 43 80 00       	push   $0x804350
  80071c:	68 90 00 00 00       	push   $0x90
  800721:	68 fc 41 80 00       	push   $0x8041fc
  800726:	e8 97 07 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80072b:	e8 7b 1c 00 00       	call   8023ab <sys_calculate_free_frames>
  800730:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800733:	e8 13 1d 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800738:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80073b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80073e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	50                   	push   %eax
  800745:	e8 b4 19 00 00       	call   8020fe <malloc>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800750:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800753:	89 c2                	mov    %eax,%edx
  800755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800758:	c1 e0 02             	shl    $0x2,%eax
  80075b:	05 00 00 00 80       	add    $0x80000000,%eax
  800760:	39 c2                	cmp    %eax,%edx
  800762:	74 17                	je     80077b <_main+0x743>
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	68 20 43 80 00       	push   $0x804320
  80076c:	68 96 00 00 00       	push   $0x96
  800771:	68 fc 41 80 00       	push   $0x8041fc
  800776:	e8 47 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80077b:	e8 cb 1c 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800780:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800783:	74 17                	je     80079c <_main+0x764>
  800785:	83 ec 04             	sub    $0x4,%esp
  800788:	68 02 43 80 00       	push   $0x804302
  80078d:	68 98 00 00 00       	push   $0x98
  800792:	68 fc 41 80 00       	push   $0x8041fc
  800797:	e8 26 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80079c:	e8 0a 1c 00 00       	call   8023ab <sys_calculate_free_frames>
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a6:	39 c2                	cmp    %eax,%edx
  8007a8:	74 17                	je     8007c1 <_main+0x789>
  8007aa:	83 ec 04             	sub    $0x4,%esp
  8007ad:	68 50 43 80 00       	push   $0x804350
  8007b2:	68 99 00 00 00       	push   $0x99
  8007b7:	68 fc 41 80 00       	push   $0x8041fc
  8007bc:	e8 01 07 00 00       	call   800ec2 <_panic>

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007c1:	e8 e5 1b 00 00       	call   8023ab <sys_calculate_free_frames>
  8007c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007c9:	e8 7d 1c 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8007ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[10] = malloc(256*kilo - kilo);
		ptr_allocations[10] = smalloc("a", 256*kilo - kilo, 0);
  8007d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007d4:	89 d0                	mov    %edx,%eax
  8007d6:	c1 e0 08             	shl    $0x8,%eax
  8007d9:	29 d0                	sub    %edx,%eax
  8007db:	83 ec 04             	sub    $0x4,%esp
  8007de:	6a 00                	push   $0x0
  8007e0:	50                   	push   %eax
  8007e1:	68 8b 43 80 00       	push   $0x80438b
  8007e6:	e8 5b 19 00 00       	call   802146 <smalloc>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007f4:	89 c2                	mov    %eax,%edx
  8007f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f9:	c1 e0 09             	shl    $0x9,%eax
  8007fc:	89 c1                	mov    %eax,%ecx
  8007fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800801:	01 c8                	add    %ecx,%eax
  800803:	05 00 00 00 80       	add    $0x80000000,%eax
  800808:	39 c2                	cmp    %eax,%edx
  80080a:	74 17                	je     800823 <_main+0x7eb>
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 20 43 80 00       	push   $0x804320
  800814:	68 a0 00 00 00       	push   $0xa0
  800819:	68 fc 41 80 00       	push   $0x8041fc
  80081e:	e8 9f 06 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800823:	e8 23 1c 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800828:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80082b:	74 17                	je     800844 <_main+0x80c>
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	68 02 43 80 00       	push   $0x804302
  800835:	68 a1 00 00 00       	push   $0xa1
  80083a:	68 fc 41 80 00       	push   $0x8041fc
  80083f:	e8 7e 06 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 64+0+2) panic("Wrong allocation: %d", (freeFrames - sys_calculate_free_frames()));
  800844:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800847:	e8 5f 1b 00 00       	call   8023ab <sys_calculate_free_frames>
  80084c:	29 c3                	sub    %eax,%ebx
  80084e:	89 d8                	mov    %ebx,%eax
  800850:	83 f8 42             	cmp    $0x42,%eax
  800853:	74 21                	je     800876 <_main+0x83e>
  800855:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800858:	e8 4e 1b 00 00       	call   8023ab <sys_calculate_free_frames>
  80085d:	29 c3                	sub    %eax,%ebx
  80085f:	89 d8                	mov    %ebx,%eax
  800861:	50                   	push   %eax
  800862:	68 8d 43 80 00       	push   $0x80438d
  800867:	68 a2 00 00 00       	push   $0xa2
  80086c:	68 fc 41 80 00       	push   $0x8041fc
  800871:	e8 4c 06 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800876:	e8 30 1b 00 00       	call   8023ab <sys_calculate_free_frames>
  80087b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80087e:	e8 c8 1b 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800883:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	83 ec 0c             	sub    $0xc,%esp
  80088e:	50                   	push   %eax
  80088f:	e8 6a 18 00 00       	call   8020fe <malloc>
  800894:	83 c4 10             	add    $0x10,%esp
  800897:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80089a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80089d:	89 c2                	mov    %eax,%edx
  80089f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a2:	c1 e0 03             	shl    $0x3,%eax
  8008a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8008aa:	39 c2                	cmp    %eax,%edx
  8008ac:	74 17                	je     8008c5 <_main+0x88d>
  8008ae:	83 ec 04             	sub    $0x4,%esp
  8008b1:	68 20 43 80 00       	push   $0x804320
  8008b6:	68 a8 00 00 00       	push   $0xa8
  8008bb:	68 fc 41 80 00       	push   $0x8041fc
  8008c0:	e8 fd 05 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8008c5:	e8 81 1b 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8008ca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 02 43 80 00       	push   $0x804302
  8008d7:	68 aa 00 00 00       	push   $0xaa
  8008dc:	68 fc 41 80 00       	push   $0x8041fc
  8008e1:	e8 dc 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008e6:	e8 c0 1a 00 00       	call   8023ab <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 50 43 80 00       	push   $0x804350
  8008fc:	68 ab 00 00 00       	push   $0xab
  800901:	68 fc 41 80 00       	push   $0x8041fc
  800906:	e8 b7 05 00 00       	call   800ec2 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  80090b:	e8 9b 1a 00 00       	call   8023ab <sys_calculate_free_frames>
  800910:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800913:	e8 33 1b 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800918:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  80091b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091e:	c1 e0 02             	shl    $0x2,%eax
  800921:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	6a 00                	push   $0x0
  800929:	50                   	push   %eax
  80092a:	68 a2 43 80 00       	push   $0x8043a2
  80092f:	e8 12 18 00 00       	call   802146 <smalloc>
  800934:	83 c4 10             	add    $0x10,%esp
  800937:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  80093a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80093d:	89 c1                	mov    %eax,%ecx
  80093f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800942:	89 d0                	mov    %edx,%eax
  800944:	01 c0                	add    %eax,%eax
  800946:	01 d0                	add    %edx,%eax
  800948:	01 c0                	add    %eax,%eax
  80094a:	01 d0                	add    %edx,%eax
  80094c:	01 c0                	add    %eax,%eax
  80094e:	05 00 00 00 80       	add    $0x80000000,%eax
  800953:	39 c1                	cmp    %eax,%ecx
  800955:	74 17                	je     80096e <_main+0x936>
  800957:	83 ec 04             	sub    $0x4,%esp
  80095a:	68 20 43 80 00       	push   $0x804320
  80095f:	68 b2 00 00 00       	push   $0xb2
  800964:	68 fc 41 80 00       	push   $0x8041fc
  800969:	e8 54 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1024+1+2) panic("Wrong allocation: ");
  80096e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800971:	e8 35 1a 00 00       	call   8023ab <sys_calculate_free_frames>
  800976:	29 c3                	sub    %eax,%ebx
  800978:	89 d8                	mov    %ebx,%eax
  80097a:	3d 03 04 00 00       	cmp    $0x403,%eax
  80097f:	74 17                	je     800998 <_main+0x960>
  800981:	83 ec 04             	sub    $0x4,%esp
  800984:	68 50 43 80 00       	push   $0x804350
  800989:	68 b3 00 00 00       	push   $0xb3
  80098e:	68 fc 41 80 00       	push   $0x8041fc
  800993:	e8 2a 05 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800998:	e8 ae 1a 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 02 43 80 00       	push   $0x804302
  8009aa:	68 b4 00 00 00       	push   $0xb4
  8009af:	68 fc 41 80 00       	push   $0x8041fc
  8009b4:	e8 09 05 00 00       	call   800ec2 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009b9:	e8 ed 19 00 00       	call   8023ab <sys_calculate_free_frames>
  8009be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009c1:	e8 85 1a 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8009c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  8009c9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8009cc:	83 ec 0c             	sub    $0xc,%esp
  8009cf:	50                   	push   %eax
  8009d0:	e8 57 17 00 00       	call   80212c <free>
  8009d5:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009d8:	e8 6e 1a 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  8009dd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009e0:	74 17                	je     8009f9 <_main+0x9c1>
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	68 67 43 80 00       	push   $0x804367
  8009ea:	68 bf 00 00 00       	push   $0xbf
  8009ef:	68 fc 41 80 00       	push   $0x8041fc
  8009f4:	e8 c9 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009f9:	e8 ad 19 00 00       	call   8023ab <sys_calculate_free_frames>
  8009fe:	89 c2                	mov    %eax,%edx
  800a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a03:	39 c2                	cmp    %eax,%edx
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 7e 43 80 00       	push   $0x80437e
  800a0f:	68 c0 00 00 00       	push   $0xc0
  800a14:	68 fc 41 80 00       	push   $0x8041fc
  800a19:	e8 a4 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a1e:	e8 88 19 00 00       	call   8023ab <sys_calculate_free_frames>
  800a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a26:	e8 20 1a 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  800a2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a31:	83 ec 0c             	sub    $0xc,%esp
  800a34:	50                   	push   %eax
  800a35:	e8 f2 16 00 00       	call   80212c <free>
  800a3a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a3d:	e8 09 1a 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800a42:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a45:	74 17                	je     800a5e <_main+0xa26>
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	68 67 43 80 00       	push   $0x804367
  800a4f:	68 c7 00 00 00       	push   $0xc7
  800a54:	68 fc 41 80 00       	push   $0x8041fc
  800a59:	e8 64 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a5e:	e8 48 19 00 00       	call   8023ab <sys_calculate_free_frames>
  800a63:	89 c2                	mov    %eax,%edx
  800a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a68:	39 c2                	cmp    %eax,%edx
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 7e 43 80 00       	push   $0x80437e
  800a74:	68 c8 00 00 00       	push   $0xc8
  800a79:	68 fc 41 80 00       	push   $0x8041fc
  800a7e:	e8 3f 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 23 19 00 00       	call   8023ab <sys_calculate_free_frames>
  800a88:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 bb 19 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800a90:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800a93:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 8d 16 00 00       	call   80212c <free>
  800a9f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800aa2:	e8 a4 19 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800aa7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800aaa:	74 17                	je     800ac3 <_main+0xa8b>
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	68 67 43 80 00       	push   $0x804367
  800ab4:	68 cf 00 00 00       	push   $0xcf
  800ab9:	68 fc 41 80 00       	push   $0x8041fc
  800abe:	e8 ff 03 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800ac3:	e8 e3 18 00 00       	call   8023ab <sys_calculate_free_frames>
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	39 c2                	cmp    %eax,%edx
  800acf:	74 17                	je     800ae8 <_main+0xab0>
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	68 7e 43 80 00       	push   $0x80437e
  800ad9:	68 d0 00 00 00       	push   $0xd0
  800ade:	68 fc 41 80 00       	push   $0x8041fc
  800ae3:	e8 da 03 00 00       	call   800ec2 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800ae8:	e8 be 18 00 00       	call   8023ab <sys_calculate_free_frames>
  800aed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800af0:	e8 56 19 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800af5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[13] = malloc(1*Mega + 256*kilo - kilo);
  800af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800afb:	c1 e0 08             	shl    $0x8,%eax
  800afe:	89 c2                	mov    %eax,%edx
  800b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b03:	01 d0                	add    %edx,%eax
  800b05:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800b08:	83 ec 0c             	sub    $0xc,%esp
  800b0b:	50                   	push   %eax
  800b0c:	e8 ed 15 00 00       	call   8020fe <malloc>
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800b17:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b1a:	89 c1                	mov    %eax,%ecx
  800b1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b1f:	89 d0                	mov    %edx,%eax
  800b21:	01 c0                	add    %eax,%eax
  800b23:	01 d0                	add    %edx,%eax
  800b25:	c1 e0 08             	shl    $0x8,%eax
  800b28:	89 c2                	mov    %eax,%edx
  800b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b2d:	01 d0                	add    %edx,%eax
  800b2f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b34:	39 c1                	cmp    %eax,%ecx
  800b36:	74 17                	je     800b4f <_main+0xb17>
  800b38:	83 ec 04             	sub    $0x4,%esp
  800b3b:	68 20 43 80 00       	push   $0x804320
  800b40:	68 da 00 00 00       	push   $0xda
  800b45:	68 fc 41 80 00       	push   $0x8041fc
  800b4a:	e8 73 03 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b4f:	e8 f7 18 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800b54:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800b57:	74 17                	je     800b70 <_main+0xb38>
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	68 02 43 80 00       	push   $0x804302
  800b61:	68 dc 00 00 00       	push   $0xdc
  800b66:	68 fc 41 80 00       	push   $0x8041fc
  800b6b:	e8 52 03 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b70:	e8 36 18 00 00       	call   8023ab <sys_calculate_free_frames>
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b7a:	39 c2                	cmp    %eax,%edx
  800b7c:	74 17                	je     800b95 <_main+0xb5d>
  800b7e:	83 ec 04             	sub    $0x4,%esp
  800b81:	68 50 43 80 00       	push   $0x804350
  800b86:	68 dd 00 00 00       	push   $0xdd
  800b8b:	68 fc 41 80 00       	push   $0x8041fc
  800b90:	e8 2d 03 00 00       	call   800ec2 <_panic>

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800b95:	e8 11 18 00 00       	call   8023ab <sys_calculate_free_frames>
  800b9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b9d:	e8 a9 18 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ba8:	c1 e0 02             	shl    $0x2,%eax
  800bab:	83 ec 04             	sub    $0x4,%esp
  800bae:	6a 00                	push   $0x0
  800bb0:	50                   	push   %eax
  800bb1:	68 a4 43 80 00       	push   $0x8043a4
  800bb6:	e8 8b 15 00 00       	call   802146 <smalloc>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (ptr_allocations[14] != (uint32*)(USER_HEAP_START + 18*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800bc1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800bc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bc7:	89 d0                	mov    %edx,%eax
  800bc9:	c1 e0 03             	shl    $0x3,%eax
  800bcc:	01 d0                	add    %edx,%eax
  800bce:	01 c0                	add    %eax,%eax
  800bd0:	05 00 00 00 80       	add    $0x80000000,%eax
  800bd5:	39 c1                	cmp    %eax,%ecx
  800bd7:	74 17                	je     800bf0 <_main+0xbb8>
  800bd9:	83 ec 04             	sub    $0x4,%esp
  800bdc:	68 18 42 80 00       	push   $0x804218
  800be1:	68 e3 00 00 00       	push   $0xe3
  800be6:	68 fc 41 80 00       	push   $0x8041fc
  800beb:	e8 d2 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1024+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800bf0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800bf3:	e8 b3 17 00 00       	call   8023ab <sys_calculate_free_frames>
  800bf8:	29 c3                	sub    %eax,%ebx
  800bfa:	89 d8                	mov    %ebx,%eax
  800bfc:	3d 03 04 00 00       	cmp    $0x403,%eax
  800c01:	74 17                	je     800c1a <_main+0xbe2>
  800c03:	83 ec 04             	sub    $0x4,%esp
  800c06:	68 84 42 80 00       	push   $0x804284
  800c0b:	68 e4 00 00 00       	push   $0xe4
  800c10:	68 fc 41 80 00       	push   $0x8041fc
  800c15:	e8 a8 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c1a:	e8 2c 18 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800c1f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800c22:	74 17                	je     800c3b <_main+0xc03>
  800c24:	83 ec 04             	sub    $0x4,%esp
  800c27:	68 02 43 80 00       	push   $0x804302
  800c2c:	68 e5 00 00 00       	push   $0xe5
  800c31:	68 fc 41 80 00       	push   $0x8041fc
  800c36:	e8 87 02 00 00       	call   800ec2 <_panic>

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 6b 17 00 00       	call   8023ab <sys_calculate_free_frames>
  800c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c43:	e8 03 18 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	68 65 43 80 00       	push   $0x804365
  800c53:	ff 75 ec             	pushl  -0x14(%ebp)
  800c56:	e8 ac 15 00 00       	call   802207 <sget>
  800c5b:	83 c4 10             	add    $0x10,%esp
  800c5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (ptr_allocations[15] != (uint32*)(USER_HEAP_START + 3*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800c61:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c67:	89 c1                	mov    %eax,%ecx
  800c69:	01 c9                	add    %ecx,%ecx
  800c6b:	01 c8                	add    %ecx,%eax
  800c6d:	05 00 00 00 80       	add    $0x80000000,%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	74 17                	je     800c8d <_main+0xc55>
  800c76:	83 ec 04             	sub    $0x4,%esp
  800c79:	68 18 42 80 00       	push   $0x804218
  800c7e:	68 eb 00 00 00       	push   $0xeb
  800c83:	68 fc 41 80 00       	push   $0x8041fc
  800c88:	e8 35 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800c8d:	e8 19 17 00 00       	call   8023ab <sys_calculate_free_frames>
  800c92:	89 c2                	mov    %eax,%edx
  800c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	74 17                	je     800cb2 <_main+0xc7a>
  800c9b:	83 ec 04             	sub    $0x4,%esp
  800c9e:	68 84 42 80 00       	push   $0x804284
  800ca3:	68 ec 00 00 00       	push   $0xec
  800ca8:	68 fc 41 80 00       	push   $0x8041fc
  800cad:	e8 10 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800cb2:	e8 94 17 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800cb7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800cba:	74 17                	je     800cd3 <_main+0xc9b>
  800cbc:	83 ec 04             	sub    $0x4,%esp
  800cbf:	68 02 43 80 00       	push   $0x804302
  800cc4:	68 ed 00 00 00       	push   $0xed
  800cc9:	68 fc 41 80 00       	push   $0x8041fc
  800cce:	e8 ef 01 00 00       	call   800ec2 <_panic>

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800cd3:	e8 d3 16 00 00       	call   8023ab <sys_calculate_free_frames>
  800cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800cdb:	e8 6b 17 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800ce0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	68 13 42 80 00       	push   $0x804213
  800ceb:	ff 75 ec             	pushl  -0x14(%ebp)
  800cee:	e8 14 15 00 00       	call   802207 <sget>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (ptr_allocations[16] != (uint32*)(USER_HEAP_START + 10*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800cf9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800cfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800cff:	89 d0                	mov    %edx,%eax
  800d01:	c1 e0 02             	shl    $0x2,%eax
  800d04:	01 d0                	add    %edx,%eax
  800d06:	01 c0                	add    %eax,%eax
  800d08:	05 00 00 00 80       	add    $0x80000000,%eax
  800d0d:	39 c1                	cmp    %eax,%ecx
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 18 42 80 00       	push   $0x804218
  800d19:	68 f3 00 00 00       	push   $0xf3
  800d1e:	68 fc 41 80 00       	push   $0x8041fc
  800d23:	e8 9a 01 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800d28:	e8 7e 16 00 00       	call   8023ab <sys_calculate_free_frames>
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d32:	39 c2                	cmp    %eax,%edx
  800d34:	74 17                	je     800d4d <_main+0xd15>
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	68 84 42 80 00       	push   $0x804284
  800d3e:	68 f4 00 00 00       	push   $0xf4
  800d43:	68 fc 41 80 00       	push   $0x8041fc
  800d48:	e8 75 01 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800d4d:	e8 f9 16 00 00       	call   80244b <sys_pf_calculate_allocated_pages>
  800d52:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d55:	74 17                	je     800d6e <_main+0xd36>
  800d57:	83 ec 04             	sub    $0x4,%esp
  800d5a:	68 02 43 80 00       	push   $0x804302
  800d5f:	68 f5 00 00 00       	push   $0xf5
  800d64:	68 fc 41 80 00       	push   $0x8041fc
  800d69:	e8 54 01 00 00       	call   800ec2 <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT allocation (3) completed successfully.\n");
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	68 a8 43 80 00       	push   $0x8043a8
  800d76:	e8 fb 03 00 00       	call   801176 <cprintf>
  800d7b:	83 c4 10             	add    $0x10,%esp

	return;
  800d7e:	90                   	nop
}
  800d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800d8c:	e8 fa 18 00 00       	call   80268b <sys_getenvindex>
  800d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 d0                	add    %edx,%eax
  800d9e:	01 c0                	add    %eax,%eax
  800da0:	01 d0                	add    %edx,%eax
  800da2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800da9:	01 d0                	add    %edx,%eax
  800dab:	c1 e0 04             	shl    $0x4,%eax
  800dae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800db3:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800db8:	a1 20 50 80 00       	mov    0x805020,%eax
  800dbd:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800dc3:	84 c0                	test   %al,%al
  800dc5:	74 0f                	je     800dd6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800dc7:	a1 20 50 80 00       	mov    0x805020,%eax
  800dcc:	05 5c 05 00 00       	add    $0x55c,%eax
  800dd1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800dd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dda:	7e 0a                	jle    800de6 <libmain+0x60>
		binaryname = argv[0];
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8b 00                	mov    (%eax),%eax
  800de1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800de6:	83 ec 08             	sub    $0x8,%esp
  800de9:	ff 75 0c             	pushl  0xc(%ebp)
  800dec:	ff 75 08             	pushl  0x8(%ebp)
  800def:	e8 44 f2 ff ff       	call   800038 <_main>
  800df4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800df7:	e8 9c 16 00 00       	call   802498 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	68 0c 44 80 00       	push   $0x80440c
  800e04:	e8 6d 03 00 00       	call   801176 <cprintf>
  800e09:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800e0c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e11:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800e17:	a1 20 50 80 00       	mov    0x805020,%eax
  800e1c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800e22:	83 ec 04             	sub    $0x4,%esp
  800e25:	52                   	push   %edx
  800e26:	50                   	push   %eax
  800e27:	68 34 44 80 00       	push   $0x804434
  800e2c:	e8 45 03 00 00       	call   801176 <cprintf>
  800e31:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800e34:	a1 20 50 80 00       	mov    0x805020,%eax
  800e39:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800e3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800e44:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800e4a:	a1 20 50 80 00       	mov    0x805020,%eax
  800e4f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800e55:	51                   	push   %ecx
  800e56:	52                   	push   %edx
  800e57:	50                   	push   %eax
  800e58:	68 5c 44 80 00       	push   $0x80445c
  800e5d:	e8 14 03 00 00       	call   801176 <cprintf>
  800e62:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800e65:	a1 20 50 80 00       	mov    0x805020,%eax
  800e6a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	50                   	push   %eax
  800e74:	68 b4 44 80 00       	push   $0x8044b4
  800e79:	e8 f8 02 00 00       	call   801176 <cprintf>
  800e7e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	68 0c 44 80 00       	push   $0x80440c
  800e89:	e8 e8 02 00 00       	call   801176 <cprintf>
  800e8e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e91:	e8 1c 16 00 00       	call   8024b2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800e96:	e8 19 00 00 00       	call   800eb4 <exit>
}
  800e9b:	90                   	nop
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800ea4:	83 ec 0c             	sub    $0xc,%esp
  800ea7:	6a 00                	push   $0x0
  800ea9:	e8 a9 17 00 00       	call   802657 <sys_destroy_env>
  800eae:	83 c4 10             	add    $0x10,%esp
}
  800eb1:	90                   	nop
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <exit>:

void
exit(void)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800eba:	e8 fe 17 00 00       	call   8026bd <sys_exit_env>
}
  800ebf:	90                   	nop
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800ec8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ecb:	83 c0 04             	add    $0x4,%eax
  800ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ed1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	74 16                	je     800ef0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800eda:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800edf:	83 ec 08             	sub    $0x8,%esp
  800ee2:	50                   	push   %eax
  800ee3:	68 c8 44 80 00       	push   $0x8044c8
  800ee8:	e8 89 02 00 00       	call   801176 <cprintf>
  800eed:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ef0:	a1 00 50 80 00       	mov    0x805000,%eax
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	ff 75 08             	pushl  0x8(%ebp)
  800efb:	50                   	push   %eax
  800efc:	68 cd 44 80 00       	push   $0x8044cd
  800f01:	e8 70 02 00 00       	call   801176 <cprintf>
  800f06:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	83 ec 08             	sub    $0x8,%esp
  800f0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f12:	50                   	push   %eax
  800f13:	e8 f3 01 00 00       	call   80110b <vcprintf>
  800f18:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	6a 00                	push   $0x0
  800f20:	68 e9 44 80 00       	push   $0x8044e9
  800f25:	e8 e1 01 00 00       	call   80110b <vcprintf>
  800f2a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800f2d:	e8 82 ff ff ff       	call   800eb4 <exit>

	// should not return here
	while (1) ;
  800f32:	eb fe                	jmp    800f32 <_panic+0x70>

00800f34 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800f3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3f:	8b 50 74             	mov    0x74(%eax),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	39 c2                	cmp    %eax,%edx
  800f47:	74 14                	je     800f5d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800f49:	83 ec 04             	sub    $0x4,%esp
  800f4c:	68 ec 44 80 00       	push   $0x8044ec
  800f51:	6a 26                	push   $0x26
  800f53:	68 38 45 80 00       	push   $0x804538
  800f58:	e8 65 ff ff ff       	call   800ec2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800f64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f6b:	e9 c2 00 00 00       	jmp    801032 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	01 d0                	add    %edx,%eax
  800f7f:	8b 00                	mov    (%eax),%eax
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 08                	jne    800f8d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800f85:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800f88:	e9 a2 00 00 00       	jmp    80102f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800f8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f94:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800f9b:	eb 69                	jmp    801006 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800f9d:	a1 20 50 80 00       	mov    0x805020,%eax
  800fa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fab:	89 d0                	mov    %edx,%eax
  800fad:	01 c0                	add    %eax,%eax
  800faf:	01 d0                	add    %edx,%eax
  800fb1:	c1 e0 03             	shl    $0x3,%eax
  800fb4:	01 c8                	add    %ecx,%eax
  800fb6:	8a 40 04             	mov    0x4(%eax),%al
  800fb9:	84 c0                	test   %al,%al
  800fbb:	75 46                	jne    801003 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800fbd:	a1 20 50 80 00       	mov    0x805020,%eax
  800fc2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fcb:	89 d0                	mov    %edx,%eax
  800fcd:	01 c0                	add    %eax,%eax
  800fcf:	01 d0                	add    %edx,%eax
  800fd1:	c1 e0 03             	shl    $0x3,%eax
  800fd4:	01 c8                	add    %ecx,%eax
  800fd6:	8b 00                	mov    (%eax),%eax
  800fd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fdb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800fde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fe3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	01 c8                	add    %ecx,%eax
  800ff4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ff6:	39 c2                	cmp    %eax,%edx
  800ff8:	75 09                	jne    801003 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ffa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801001:	eb 12                	jmp    801015 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801003:	ff 45 e8             	incl   -0x18(%ebp)
  801006:	a1 20 50 80 00       	mov    0x805020,%eax
  80100b:	8b 50 74             	mov    0x74(%eax),%edx
  80100e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801011:	39 c2                	cmp    %eax,%edx
  801013:	77 88                	ja     800f9d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801015:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801019:	75 14                	jne    80102f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80101b:	83 ec 04             	sub    $0x4,%esp
  80101e:	68 44 45 80 00       	push   $0x804544
  801023:	6a 3a                	push   $0x3a
  801025:	68 38 45 80 00       	push   $0x804538
  80102a:	e8 93 fe ff ff       	call   800ec2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80102f:	ff 45 f0             	incl   -0x10(%ebp)
  801032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801035:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801038:	0f 8c 32 ff ff ff    	jl     800f70 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80103e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801045:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80104c:	eb 26                	jmp    801074 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80104e:	a1 20 50 80 00       	mov    0x805020,%eax
  801053:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801059:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80105c:	89 d0                	mov    %edx,%eax
  80105e:	01 c0                	add    %eax,%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	c1 e0 03             	shl    $0x3,%eax
  801065:	01 c8                	add    %ecx,%eax
  801067:	8a 40 04             	mov    0x4(%eax),%al
  80106a:	3c 01                	cmp    $0x1,%al
  80106c:	75 03                	jne    801071 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80106e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801071:	ff 45 e0             	incl   -0x20(%ebp)
  801074:	a1 20 50 80 00       	mov    0x805020,%eax
  801079:	8b 50 74             	mov    0x74(%eax),%edx
  80107c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80107f:	39 c2                	cmp    %eax,%edx
  801081:	77 cb                	ja     80104e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801089:	74 14                	je     80109f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80108b:	83 ec 04             	sub    $0x4,%esp
  80108e:	68 98 45 80 00       	push   $0x804598
  801093:	6a 44                	push   $0x44
  801095:	68 38 45 80 00       	push   $0x804538
  80109a:	e8 23 fe ff ff       	call   800ec2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80109f:	90                   	nop
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8010a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ab:	8b 00                	mov    (%eax),%eax
  8010ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8010b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b3:	89 0a                	mov    %ecx,(%edx)
  8010b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b8:	88 d1                	mov    %dl,%cl
  8010ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	8b 00                	mov    (%eax),%eax
  8010c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010cb:	75 2c                	jne    8010f9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8010cd:	a0 24 50 80 00       	mov    0x805024,%al
  8010d2:	0f b6 c0             	movzbl %al,%eax
  8010d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d8:	8b 12                	mov    (%edx),%edx
  8010da:	89 d1                	mov    %edx,%ecx
  8010dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010df:	83 c2 08             	add    $0x8,%edx
  8010e2:	83 ec 04             	sub    $0x4,%esp
  8010e5:	50                   	push   %eax
  8010e6:	51                   	push   %ecx
  8010e7:	52                   	push   %edx
  8010e8:	e8 fd 11 00 00       	call   8022ea <sys_cputs>
  8010ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	8b 40 04             	mov    0x4(%eax),%eax
  8010ff:	8d 50 01             	lea    0x1(%eax),%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	89 50 04             	mov    %edx,0x4(%eax)
}
  801108:	90                   	nop
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801114:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80111b:	00 00 00 
	b.cnt = 0;
  80111e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801125:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801134:	50                   	push   %eax
  801135:	68 a2 10 80 00       	push   $0x8010a2
  80113a:	e8 11 02 00 00       	call   801350 <vprintfmt>
  80113f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801142:	a0 24 50 80 00       	mov    0x805024,%al
  801147:	0f b6 c0             	movzbl %al,%eax
  80114a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801150:	83 ec 04             	sub    $0x4,%esp
  801153:	50                   	push   %eax
  801154:	52                   	push   %edx
  801155:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80115b:	83 c0 08             	add    $0x8,%eax
  80115e:	50                   	push   %eax
  80115f:	e8 86 11 00 00       	call   8022ea <sys_cputs>
  801164:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801167:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80116e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <cprintf>:

int cprintf(const char *fmt, ...) {
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80117c:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801183:	8d 45 0c             	lea    0xc(%ebp),%eax
  801186:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	83 ec 08             	sub    $0x8,%esp
  80118f:	ff 75 f4             	pushl  -0xc(%ebp)
  801192:	50                   	push   %eax
  801193:	e8 73 ff ff ff       	call   80110b <vcprintf>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80119e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    

008011a3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011a9:	e8 ea 12 00 00       	call   802498 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011ae:	8d 45 0c             	lea    0xc(%ebp),%eax
  8011b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bd:	50                   	push   %eax
  8011be:	e8 48 ff ff ff       	call   80110b <vcprintf>
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8011c9:	e8 e4 12 00 00       	call   8024b2 <sys_enable_interrupt>
	return cnt;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 14             	sub    $0x14,%esp
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8011e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011f1:	77 55                	ja     801248 <printnum+0x75>
  8011f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011f6:	72 05                	jb     8011fd <printnum+0x2a>
  8011f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fb:	77 4b                	ja     801248 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011fd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801200:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801203:	8b 45 18             	mov    0x18(%ebp),%eax
  801206:	ba 00 00 00 00       	mov    $0x0,%edx
  80120b:	52                   	push   %edx
  80120c:	50                   	push   %eax
  80120d:	ff 75 f4             	pushl  -0xc(%ebp)
  801210:	ff 75 f0             	pushl  -0x10(%ebp)
  801213:	e8 58 2d 00 00       	call   803f70 <__udivdi3>
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	ff 75 20             	pushl  0x20(%ebp)
  801221:	53                   	push   %ebx
  801222:	ff 75 18             	pushl  0x18(%ebp)
  801225:	52                   	push   %edx
  801226:	50                   	push   %eax
  801227:	ff 75 0c             	pushl  0xc(%ebp)
  80122a:	ff 75 08             	pushl  0x8(%ebp)
  80122d:	e8 a1 ff ff ff       	call   8011d3 <printnum>
  801232:	83 c4 20             	add    $0x20,%esp
  801235:	eb 1a                	jmp    801251 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	ff 75 0c             	pushl  0xc(%ebp)
  80123d:	ff 75 20             	pushl  0x20(%ebp)
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	ff d0                	call   *%eax
  801245:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801248:	ff 4d 1c             	decl   0x1c(%ebp)
  80124b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80124f:	7f e6                	jg     801237 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801251:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801254:	bb 00 00 00 00       	mov    $0x0,%ebx
  801259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125f:	53                   	push   %ebx
  801260:	51                   	push   %ecx
  801261:	52                   	push   %edx
  801262:	50                   	push   %eax
  801263:	e8 18 2e 00 00       	call   804080 <__umoddi3>
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	05 14 48 80 00       	add    $0x804814,%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	0f be c0             	movsbl %al,%eax
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	50                   	push   %eax
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	ff d0                	call   *%eax
  801281:	83 c4 10             	add    $0x10,%esp
}
  801284:	90                   	nop
  801285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80128d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801291:	7e 1c                	jle    8012af <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 50 08             	lea    0x8(%eax),%edx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	89 10                	mov    %edx,(%eax)
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8b 00                	mov    (%eax),%eax
  8012a5:	83 e8 08             	sub    $0x8,%eax
  8012a8:	8b 50 04             	mov    0x4(%eax),%edx
  8012ab:	8b 00                	mov    (%eax),%eax
  8012ad:	eb 40                	jmp    8012ef <getuint+0x65>
	else if (lflag)
  8012af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b3:	74 1e                	je     8012d3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8b 00                	mov    (%eax),%eax
  8012ba:	8d 50 04             	lea    0x4(%eax),%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 10                	mov    %edx,(%eax)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8b 00                	mov    (%eax),%eax
  8012c7:	83 e8 04             	sub    $0x4,%eax
  8012ca:	8b 00                	mov    (%eax),%eax
  8012cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d1:	eb 1c                	jmp    8012ef <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8b 00                	mov    (%eax),%eax
  8012d8:	8d 50 04             	lea    0x4(%eax),%edx
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	89 10                	mov    %edx,(%eax)
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	83 e8 04             	sub    $0x4,%eax
  8012e8:	8b 00                	mov    (%eax),%eax
  8012ea:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8012f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8012f8:	7e 1c                	jle    801316 <getint+0x25>
		return va_arg(*ap, long long);
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	8d 50 08             	lea    0x8(%eax),%edx
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	89 10                	mov    %edx,(%eax)
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8b 00                	mov    (%eax),%eax
  80130c:	83 e8 08             	sub    $0x8,%eax
  80130f:	8b 50 04             	mov    0x4(%eax),%edx
  801312:	8b 00                	mov    (%eax),%eax
  801314:	eb 38                	jmp    80134e <getint+0x5d>
	else if (lflag)
  801316:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131a:	74 1a                	je     801336 <getint+0x45>
		return va_arg(*ap, long);
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	8d 50 04             	lea    0x4(%eax),%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 10                	mov    %edx,(%eax)
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8b 00                	mov    (%eax),%eax
  80132e:	83 e8 04             	sub    $0x4,%eax
  801331:	8b 00                	mov    (%eax),%eax
  801333:	99                   	cltd   
  801334:	eb 18                	jmp    80134e <getint+0x5d>
	else
		return va_arg(*ap, int);
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8b 00                	mov    (%eax),%eax
  80133b:	8d 50 04             	lea    0x4(%eax),%edx
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	89 10                	mov    %edx,(%eax)
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 e8 04             	sub    $0x4,%eax
  80134b:	8b 00                	mov    (%eax),%eax
  80134d:	99                   	cltd   
}
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    

00801350 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	56                   	push   %esi
  801354:	53                   	push   %ebx
  801355:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801358:	eb 17                	jmp    801371 <vprintfmt+0x21>
			if (ch == '\0')
  80135a:	85 db                	test   %ebx,%ebx
  80135c:	0f 84 af 03 00 00    	je     801711 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	53                   	push   %ebx
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	ff d0                	call   *%eax
  80136e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801371:	8b 45 10             	mov    0x10(%ebp),%eax
  801374:	8d 50 01             	lea    0x1(%eax),%edx
  801377:	89 55 10             	mov    %edx,0x10(%ebp)
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	0f b6 d8             	movzbl %al,%ebx
  80137f:	83 fb 25             	cmp    $0x25,%ebx
  801382:	75 d6                	jne    80135a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801384:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801388:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80138f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801396:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80139d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a7:	8d 50 01             	lea    0x1(%eax),%edx
  8013aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	0f b6 d8             	movzbl %al,%ebx
  8013b2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8013b5:	83 f8 55             	cmp    $0x55,%eax
  8013b8:	0f 87 2b 03 00 00    	ja     8016e9 <vprintfmt+0x399>
  8013be:	8b 04 85 38 48 80 00 	mov    0x804838(,%eax,4),%eax
  8013c5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8013c7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8013cb:	eb d7                	jmp    8013a4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013cd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8013d1:	eb d1                	jmp    8013a4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8013da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013dd:	89 d0                	mov    %edx,%eax
  8013df:	c1 e0 02             	shl    $0x2,%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	01 c0                	add    %eax,%eax
  8013e6:	01 d8                	add    %ebx,%eax
  8013e8:	83 e8 30             	sub    $0x30,%eax
  8013eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8013ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8013f6:	83 fb 2f             	cmp    $0x2f,%ebx
  8013f9:	7e 3e                	jle    801439 <vprintfmt+0xe9>
  8013fb:	83 fb 39             	cmp    $0x39,%ebx
  8013fe:	7f 39                	jg     801439 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801400:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801403:	eb d5                	jmp    8013da <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801405:	8b 45 14             	mov    0x14(%ebp),%eax
  801408:	83 c0 04             	add    $0x4,%eax
  80140b:	89 45 14             	mov    %eax,0x14(%ebp)
  80140e:	8b 45 14             	mov    0x14(%ebp),%eax
  801411:	83 e8 04             	sub    $0x4,%eax
  801414:	8b 00                	mov    (%eax),%eax
  801416:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801419:	eb 1f                	jmp    80143a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80141b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80141f:	79 83                	jns    8013a4 <vprintfmt+0x54>
				width = 0;
  801421:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801428:	e9 77 ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80142d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801434:	e9 6b ff ff ff       	jmp    8013a4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801439:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80143a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80143e:	0f 89 60 ff ff ff    	jns    8013a4 <vprintfmt+0x54>
				width = precision, precision = -1;
  801444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801447:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80144a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801451:	e9 4e ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801456:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801459:	e9 46 ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	83 c0 04             	add    $0x4,%eax
  801464:	89 45 14             	mov    %eax,0x14(%ebp)
  801467:	8b 45 14             	mov    0x14(%ebp),%eax
  80146a:	83 e8 04             	sub    $0x4,%eax
  80146d:	8b 00                	mov    (%eax),%eax
  80146f:	83 ec 08             	sub    $0x8,%esp
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	50                   	push   %eax
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	ff d0                	call   *%eax
  80147b:	83 c4 10             	add    $0x10,%esp
			break;
  80147e:	e9 89 02 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801483:	8b 45 14             	mov    0x14(%ebp),%eax
  801486:	83 c0 04             	add    $0x4,%eax
  801489:	89 45 14             	mov    %eax,0x14(%ebp)
  80148c:	8b 45 14             	mov    0x14(%ebp),%eax
  80148f:	83 e8 04             	sub    $0x4,%eax
  801492:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801494:	85 db                	test   %ebx,%ebx
  801496:	79 02                	jns    80149a <vprintfmt+0x14a>
				err = -err;
  801498:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80149a:	83 fb 64             	cmp    $0x64,%ebx
  80149d:	7f 0b                	jg     8014aa <vprintfmt+0x15a>
  80149f:	8b 34 9d 80 46 80 00 	mov    0x804680(,%ebx,4),%esi
  8014a6:	85 f6                	test   %esi,%esi
  8014a8:	75 19                	jne    8014c3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8014aa:	53                   	push   %ebx
  8014ab:	68 25 48 80 00       	push   $0x804825
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 5e 02 00 00       	call   801719 <printfmt>
  8014bb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8014be:	e9 49 02 00 00       	jmp    80170c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8014c3:	56                   	push   %esi
  8014c4:	68 2e 48 80 00       	push   $0x80482e
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	ff 75 08             	pushl  0x8(%ebp)
  8014cf:	e8 45 02 00 00       	call   801719 <printfmt>
  8014d4:	83 c4 10             	add    $0x10,%esp
			break;
  8014d7:	e9 30 02 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8014dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014df:	83 c0 04             	add    $0x4,%eax
  8014e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8014e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e8:	83 e8 04             	sub    $0x4,%eax
  8014eb:	8b 30                	mov    (%eax),%esi
  8014ed:	85 f6                	test   %esi,%esi
  8014ef:	75 05                	jne    8014f6 <vprintfmt+0x1a6>
				p = "(null)";
  8014f1:	be 31 48 80 00       	mov    $0x804831,%esi
			if (width > 0 && padc != '-')
  8014f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014fa:	7e 6d                	jle    801569 <vprintfmt+0x219>
  8014fc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801500:	74 67                	je     801569 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	50                   	push   %eax
  801509:	56                   	push   %esi
  80150a:	e8 0c 03 00 00       	call   80181b <strnlen>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801515:	eb 16                	jmp    80152d <vprintfmt+0x1dd>
					putch(padc, putdat);
  801517:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	ff 75 0c             	pushl  0xc(%ebp)
  801521:	50                   	push   %eax
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	ff d0                	call   *%eax
  801527:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80152a:	ff 4d e4             	decl   -0x1c(%ebp)
  80152d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801531:	7f e4                	jg     801517 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801533:	eb 34                	jmp    801569 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801535:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801539:	74 1c                	je     801557 <vprintfmt+0x207>
  80153b:	83 fb 1f             	cmp    $0x1f,%ebx
  80153e:	7e 05                	jle    801545 <vprintfmt+0x1f5>
  801540:	83 fb 7e             	cmp    $0x7e,%ebx
  801543:	7e 12                	jle    801557 <vprintfmt+0x207>
					putch('?', putdat);
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	ff 75 0c             	pushl  0xc(%ebp)
  80154b:	6a 3f                	push   $0x3f
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	ff d0                	call   *%eax
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	eb 0f                	jmp    801566 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	53                   	push   %ebx
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	ff d0                	call   *%eax
  801563:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801566:	ff 4d e4             	decl   -0x1c(%ebp)
  801569:	89 f0                	mov    %esi,%eax
  80156b:	8d 70 01             	lea    0x1(%eax),%esi
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f be d8             	movsbl %al,%ebx
  801573:	85 db                	test   %ebx,%ebx
  801575:	74 24                	je     80159b <vprintfmt+0x24b>
  801577:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80157b:	78 b8                	js     801535 <vprintfmt+0x1e5>
  80157d:	ff 4d e0             	decl   -0x20(%ebp)
  801580:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801584:	79 af                	jns    801535 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801586:	eb 13                	jmp    80159b <vprintfmt+0x24b>
				putch(' ', putdat);
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	ff 75 0c             	pushl  0xc(%ebp)
  80158e:	6a 20                	push   $0x20
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	ff d0                	call   *%eax
  801595:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801598:	ff 4d e4             	decl   -0x1c(%ebp)
  80159b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80159f:	7f e7                	jg     801588 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8015a1:	e9 66 01 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8015af:	50                   	push   %eax
  8015b0:	e8 3c fd ff ff       	call   8012f1 <getint>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8015be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c4:	85 d2                	test   %edx,%edx
  8015c6:	79 23                	jns    8015eb <vprintfmt+0x29b>
				putch('-', putdat);
  8015c8:	83 ec 08             	sub    $0x8,%esp
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	6a 2d                	push   $0x2d
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	ff d0                	call   *%eax
  8015d5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8015d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015de:	f7 d8                	neg    %eax
  8015e0:	83 d2 00             	adc    $0x0,%edx
  8015e3:	f7 da                	neg    %edx
  8015e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8015eb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8015f2:	e9 bc 00 00 00       	jmp    8016b3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8015fd:	8d 45 14             	lea    0x14(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	e8 84 fc ff ff       	call   80128a <getuint>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80160c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80160f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801616:	e9 98 00 00 00       	jmp    8016b3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80161b:	83 ec 08             	sub    $0x8,%esp
  80161e:	ff 75 0c             	pushl  0xc(%ebp)
  801621:	6a 58                	push   $0x58
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	ff d0                	call   *%eax
  801628:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80162b:	83 ec 08             	sub    $0x8,%esp
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	6a 58                	push   $0x58
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	ff d0                	call   *%eax
  801638:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	ff 75 0c             	pushl  0xc(%ebp)
  801641:	6a 58                	push   $0x58
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	ff d0                	call   *%eax
  801648:	83 c4 10             	add    $0x10,%esp
			break;
  80164b:	e9 bc 00 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	6a 30                	push   $0x30
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	ff d0                	call   *%eax
  80165d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801660:	83 ec 08             	sub    $0x8,%esp
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	6a 78                	push   $0x78
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	ff d0                	call   *%eax
  80166d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801670:	8b 45 14             	mov    0x14(%ebp),%eax
  801673:	83 c0 04             	add    $0x4,%eax
  801676:	89 45 14             	mov    %eax,0x14(%ebp)
  801679:	8b 45 14             	mov    0x14(%ebp),%eax
  80167c:	83 e8 04             	sub    $0x4,%eax
  80167f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801681:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80168b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801692:	eb 1f                	jmp    8016b3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801694:	83 ec 08             	sub    $0x8,%esp
  801697:	ff 75 e8             	pushl  -0x18(%ebp)
  80169a:	8d 45 14             	lea    0x14(%ebp),%eax
  80169d:	50                   	push   %eax
  80169e:	e8 e7 fb ff ff       	call   80128a <getuint>
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8016ac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8016b3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8016b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ba:	83 ec 04             	sub    $0x4,%esp
  8016bd:	52                   	push   %edx
  8016be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016c1:	50                   	push   %eax
  8016c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	ff 75 08             	pushl  0x8(%ebp)
  8016ce:	e8 00 fb ff ff       	call   8011d3 <printnum>
  8016d3:	83 c4 20             	add    $0x20,%esp
			break;
  8016d6:	eb 34                	jmp    80170c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8016d8:	83 ec 08             	sub    $0x8,%esp
  8016db:	ff 75 0c             	pushl  0xc(%ebp)
  8016de:	53                   	push   %ebx
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	ff d0                	call   *%eax
  8016e4:	83 c4 10             	add    $0x10,%esp
			break;
  8016e7:	eb 23                	jmp    80170c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	6a 25                	push   $0x25
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	ff d0                	call   *%eax
  8016f6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016f9:	ff 4d 10             	decl   0x10(%ebp)
  8016fc:	eb 03                	jmp    801701 <vprintfmt+0x3b1>
  8016fe:	ff 4d 10             	decl   0x10(%ebp)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	48                   	dec    %eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	3c 25                	cmp    $0x25,%al
  801709:	75 f3                	jne    8016fe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80170b:	90                   	nop
		}
	}
  80170c:	e9 47 fc ff ff       	jmp    801358 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801711:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801712:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801715:	5b                   	pop    %ebx
  801716:	5e                   	pop    %esi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    

00801719 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80171f:	8d 45 10             	lea    0x10(%ebp),%eax
  801722:	83 c0 04             	add    $0x4,%eax
  801725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	ff 75 f4             	pushl  -0xc(%ebp)
  80172e:	50                   	push   %eax
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	e8 16 fc ff ff       	call   801350 <vprintfmt>
  80173a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80173d:	90                   	nop
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801743:	8b 45 0c             	mov    0xc(%ebp),%eax
  801746:	8b 40 08             	mov    0x8(%eax),%eax
  801749:	8d 50 01             	lea    0x1(%eax),%edx
  80174c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	8b 10                	mov    (%eax),%edx
  801757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175a:	8b 40 04             	mov    0x4(%eax),%eax
  80175d:	39 c2                	cmp    %eax,%edx
  80175f:	73 12                	jae    801773 <sprintputch+0x33>
		*b->buf++ = ch;
  801761:	8b 45 0c             	mov    0xc(%ebp),%eax
  801764:	8b 00                	mov    (%eax),%eax
  801766:	8d 48 01             	lea    0x1(%eax),%ecx
  801769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176c:	89 0a                	mov    %ecx,(%edx)
  80176e:	8b 55 08             	mov    0x8(%ebp),%edx
  801771:	88 10                	mov    %dl,(%eax)
}
  801773:	90                   	nop
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801782:	8b 45 0c             	mov    0xc(%ebp),%eax
  801785:	8d 50 ff             	lea    -0x1(%eax),%edx
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	01 d0                	add    %edx,%eax
  80178d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801797:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80179b:	74 06                	je     8017a3 <vsnprintf+0x2d>
  80179d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017a1:	7f 07                	jg     8017aa <vsnprintf+0x34>
		return -E_INVAL;
  8017a3:	b8 03 00 00 00       	mov    $0x3,%eax
  8017a8:	eb 20                	jmp    8017ca <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8017aa:	ff 75 14             	pushl  0x14(%ebp)
  8017ad:	ff 75 10             	pushl  0x10(%ebp)
  8017b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017b3:	50                   	push   %eax
  8017b4:	68 40 17 80 00       	push   $0x801740
  8017b9:	e8 92 fb ff ff       	call   801350 <vprintfmt>
  8017be:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8017c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017d2:	8d 45 10             	lea    0x10(%ebp),%eax
  8017d5:	83 c0 04             	add    $0x4,%eax
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8017db:	8b 45 10             	mov    0x10(%ebp),%eax
  8017de:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e1:	50                   	push   %eax
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	e8 89 ff ff ff       	call   801776 <vsnprintf>
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8017f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8017fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801805:	eb 06                	jmp    80180d <strlen+0x15>
		n++;
  801807:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80180a:	ff 45 08             	incl   0x8(%ebp)
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	84 c0                	test   %al,%al
  801814:	75 f1                	jne    801807 <strlen+0xf>
		n++;
	return n;
  801816:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801821:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801828:	eb 09                	jmp    801833 <strnlen+0x18>
		n++;
  80182a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80182d:	ff 45 08             	incl   0x8(%ebp)
  801830:	ff 4d 0c             	decl   0xc(%ebp)
  801833:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801837:	74 09                	je     801842 <strnlen+0x27>
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	8a 00                	mov    (%eax),%al
  80183e:	84 c0                	test   %al,%al
  801840:	75 e8                	jne    80182a <strnlen+0xf>
		n++;
	return n;
  801842:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801853:	90                   	nop
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	8d 50 01             	lea    0x1(%eax),%edx
  80185a:	89 55 08             	mov    %edx,0x8(%ebp)
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8d 4a 01             	lea    0x1(%edx),%ecx
  801863:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801866:	8a 12                	mov    (%edx),%dl
  801868:	88 10                	mov    %dl,(%eax)
  80186a:	8a 00                	mov    (%eax),%al
  80186c:	84 c0                	test   %al,%al
  80186e:	75 e4                	jne    801854 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801870:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801881:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801888:	eb 1f                	jmp    8018a9 <strncpy+0x34>
		*dst++ = *src;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8d 50 01             	lea    0x1(%eax),%edx
  801890:	89 55 08             	mov    %edx,0x8(%ebp)
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	8a 12                	mov    (%edx),%dl
  801898:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	8a 00                	mov    (%eax),%al
  80189f:	84 c0                	test   %al,%al
  8018a1:	74 03                	je     8018a6 <strncpy+0x31>
			src++;
  8018a3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8018a6:	ff 45 fc             	incl   -0x4(%ebp)
  8018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ac:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018af:	72 d9                	jb     80188a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8018b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8018c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018c6:	74 30                	je     8018f8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8018c8:	eb 16                	jmp    8018e0 <strlcpy+0x2a>
			*dst++ = *src++;
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	8d 50 01             	lea    0x1(%eax),%edx
  8018d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018d9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8018dc:	8a 12                	mov    (%edx),%dl
  8018de:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8018e0:	ff 4d 10             	decl   0x10(%ebp)
  8018e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018e7:	74 09                	je     8018f2 <strlcpy+0x3c>
  8018e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ec:	8a 00                	mov    (%eax),%al
  8018ee:	84 c0                	test   %al,%al
  8018f0:	75 d8                	jne    8018ca <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018fe:	29 c2                	sub    %eax,%edx
  801900:	89 d0                	mov    %edx,%eax
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801907:	eb 06                	jmp    80190f <strcmp+0xb>
		p++, q++;
  801909:	ff 45 08             	incl   0x8(%ebp)
  80190c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	8a 00                	mov    (%eax),%al
  801914:	84 c0                	test   %al,%al
  801916:	74 0e                	je     801926 <strcmp+0x22>
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8a 10                	mov    (%eax),%dl
  80191d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	38 c2                	cmp    %al,%dl
  801924:	74 e3                	je     801909 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8a 00                	mov    (%eax),%al
  80192b:	0f b6 d0             	movzbl %al,%edx
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f b6 c0             	movzbl %al,%eax
  801936:	29 c2                	sub    %eax,%edx
  801938:	89 d0                	mov    %edx,%eax
}
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80193f:	eb 09                	jmp    80194a <strncmp+0xe>
		n--, p++, q++;
  801941:	ff 4d 10             	decl   0x10(%ebp)
  801944:	ff 45 08             	incl   0x8(%ebp)
  801947:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80194a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80194e:	74 17                	je     801967 <strncmp+0x2b>
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	8a 00                	mov    (%eax),%al
  801955:	84 c0                	test   %al,%al
  801957:	74 0e                	je     801967 <strncmp+0x2b>
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 10                	mov    (%eax),%dl
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	38 c2                	cmp    %al,%dl
  801965:	74 da                	je     801941 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801967:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196b:	75 07                	jne    801974 <strncmp+0x38>
		return 0;
  80196d:	b8 00 00 00 00       	mov    $0x0,%eax
  801972:	eb 14                	jmp    801988 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	8a 00                	mov    (%eax),%al
  801979:	0f b6 d0             	movzbl %al,%edx
  80197c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197f:	8a 00                	mov    (%eax),%al
  801981:	0f b6 c0             	movzbl %al,%eax
  801984:	29 c2                	sub    %eax,%edx
  801986:	89 d0                	mov    %edx,%eax
}
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	8b 45 0c             	mov    0xc(%ebp),%eax
  801993:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801996:	eb 12                	jmp    8019aa <strchr+0x20>
		if (*s == c)
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019a0:	75 05                	jne    8019a7 <strchr+0x1d>
			return (char *) s;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	eb 11                	jmp    8019b8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8019a7:	ff 45 08             	incl   0x8(%ebp)
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	8a 00                	mov    (%eax),%al
  8019af:	84 c0                	test   %al,%al
  8019b1:	75 e5                	jne    801998 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8019b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8019c6:	eb 0d                	jmp    8019d5 <strfind+0x1b>
		if (*s == c)
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019d0:	74 0e                	je     8019e0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019d2:	ff 45 08             	incl   0x8(%ebp)
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	8a 00                	mov    (%eax),%al
  8019da:	84 c0                	test   %al,%al
  8019dc:	75 ea                	jne    8019c8 <strfind+0xe>
  8019de:	eb 01                	jmp    8019e1 <strfind+0x27>
		if (*s == c)
			break;
  8019e0:	90                   	nop
	return (char *) s;
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8019f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8019f8:	eb 0e                	jmp    801a08 <memset+0x22>
		*p++ = c;
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	8d 50 01             	lea    0x1(%eax),%edx
  801a00:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a06:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801a08:	ff 4d f8             	decl   -0x8(%ebp)
  801a0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801a0f:	79 e9                	jns    8019fa <memset+0x14>
		*p++ = c;

	return v;
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801a28:	eb 16                	jmp    801a40 <memcpy+0x2a>
		*d++ = *s++;
  801a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2d:	8d 50 01             	lea    0x1(%eax),%edx
  801a30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a36:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a39:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801a3c:	8a 12                	mov    (%edx),%dl
  801a3e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801a40:	8b 45 10             	mov    0x10(%ebp),%eax
  801a43:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a46:	89 55 10             	mov    %edx,0x10(%ebp)
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	75 dd                	jne    801a2a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a6a:	73 50                	jae    801abc <memmove+0x6a>
  801a6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a72:	01 d0                	add    %edx,%eax
  801a74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a77:	76 43                	jbe    801abc <memmove+0x6a>
		s += n;
  801a79:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a82:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801a85:	eb 10                	jmp    801a97 <memmove+0x45>
			*--d = *--s;
  801a87:	ff 4d f8             	decl   -0x8(%ebp)
  801a8a:	ff 4d fc             	decl   -0x4(%ebp)
  801a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a90:	8a 10                	mov    (%eax),%dl
  801a92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a95:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801a97:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a9d:	89 55 10             	mov    %edx,0x10(%ebp)
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	75 e3                	jne    801a87 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801aa4:	eb 23                	jmp    801ac9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801aa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa9:	8d 50 01             	lea    0x1(%eax),%edx
  801aac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aaf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab2:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ab5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ab8:	8a 12                	mov    (%edx),%dl
  801aba:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801abc:	8b 45 10             	mov    0x10(%ebp),%eax
  801abf:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ac2:	89 55 10             	mov    %edx,0x10(%ebp)
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	75 dd                	jne    801aa6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ae0:	eb 2a                	jmp    801b0c <memcmp+0x3e>
		if (*s1 != *s2)
  801ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae5:	8a 10                	mov    (%eax),%dl
  801ae7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aea:	8a 00                	mov    (%eax),%al
  801aec:	38 c2                	cmp    %al,%dl
  801aee:	74 16                	je     801b06 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801af3:	8a 00                	mov    (%eax),%al
  801af5:	0f b6 d0             	movzbl %al,%edx
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	8a 00                	mov    (%eax),%al
  801afd:	0f b6 c0             	movzbl %al,%eax
  801b00:	29 c2                	sub    %eax,%edx
  801b02:	89 d0                	mov    %edx,%eax
  801b04:	eb 18                	jmp    801b1e <memcmp+0x50>
		s1++, s2++;
  801b06:	ff 45 fc             	incl   -0x4(%ebp)
  801b09:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801b0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b12:	89 55 10             	mov    %edx,0x10(%ebp)
  801b15:	85 c0                	test   %eax,%eax
  801b17:	75 c9                	jne    801ae2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801b26:	8b 55 08             	mov    0x8(%ebp),%edx
  801b29:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2c:	01 d0                	add    %edx,%eax
  801b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801b31:	eb 15                	jmp    801b48 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	8a 00                	mov    (%eax),%al
  801b38:	0f b6 d0             	movzbl %al,%edx
  801b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3e:	0f b6 c0             	movzbl %al,%eax
  801b41:	39 c2                	cmp    %eax,%edx
  801b43:	74 0d                	je     801b52 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801b45:	ff 45 08             	incl   0x8(%ebp)
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b4e:	72 e3                	jb     801b33 <memfind+0x13>
  801b50:	eb 01                	jmp    801b53 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801b52:	90                   	nop
	return (void *) s;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801b5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801b65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b6c:	eb 03                	jmp    801b71 <strtol+0x19>
		s++;
  801b6e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	8a 00                	mov    (%eax),%al
  801b76:	3c 20                	cmp    $0x20,%al
  801b78:	74 f4                	je     801b6e <strtol+0x16>
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	8a 00                	mov    (%eax),%al
  801b7f:	3c 09                	cmp    $0x9,%al
  801b81:	74 eb                	je     801b6e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	8a 00                	mov    (%eax),%al
  801b88:	3c 2b                	cmp    $0x2b,%al
  801b8a:	75 05                	jne    801b91 <strtol+0x39>
		s++;
  801b8c:	ff 45 08             	incl   0x8(%ebp)
  801b8f:	eb 13                	jmp    801ba4 <strtol+0x4c>
	else if (*s == '-')
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	8a 00                	mov    (%eax),%al
  801b96:	3c 2d                	cmp    $0x2d,%al
  801b98:	75 0a                	jne    801ba4 <strtol+0x4c>
		s++, neg = 1;
  801b9a:	ff 45 08             	incl   0x8(%ebp)
  801b9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ba4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ba8:	74 06                	je     801bb0 <strtol+0x58>
  801baa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801bae:	75 20                	jne    801bd0 <strtol+0x78>
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	8a 00                	mov    (%eax),%al
  801bb5:	3c 30                	cmp    $0x30,%al
  801bb7:	75 17                	jne    801bd0 <strtol+0x78>
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	40                   	inc    %eax
  801bbd:	8a 00                	mov    (%eax),%al
  801bbf:	3c 78                	cmp    $0x78,%al
  801bc1:	75 0d                	jne    801bd0 <strtol+0x78>
		s += 2, base = 16;
  801bc3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801bc7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801bce:	eb 28                	jmp    801bf8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801bd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bd4:	75 15                	jne    801beb <strtol+0x93>
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	8a 00                	mov    (%eax),%al
  801bdb:	3c 30                	cmp    $0x30,%al
  801bdd:	75 0c                	jne    801beb <strtol+0x93>
		s++, base = 8;
  801bdf:	ff 45 08             	incl   0x8(%ebp)
  801be2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801be9:	eb 0d                	jmp    801bf8 <strtol+0xa0>
	else if (base == 0)
  801beb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bef:	75 07                	jne    801bf8 <strtol+0xa0>
		base = 10;
  801bf1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	8a 00                	mov    (%eax),%al
  801bfd:	3c 2f                	cmp    $0x2f,%al
  801bff:	7e 19                	jle    801c1a <strtol+0xc2>
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	8a 00                	mov    (%eax),%al
  801c06:	3c 39                	cmp    $0x39,%al
  801c08:	7f 10                	jg     801c1a <strtol+0xc2>
			dig = *s - '0';
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	8a 00                	mov    (%eax),%al
  801c0f:	0f be c0             	movsbl %al,%eax
  801c12:	83 e8 30             	sub    $0x30,%eax
  801c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c18:	eb 42                	jmp    801c5c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8a 00                	mov    (%eax),%al
  801c1f:	3c 60                	cmp    $0x60,%al
  801c21:	7e 19                	jle    801c3c <strtol+0xe4>
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8a 00                	mov    (%eax),%al
  801c28:	3c 7a                	cmp    $0x7a,%al
  801c2a:	7f 10                	jg     801c3c <strtol+0xe4>
			dig = *s - 'a' + 10;
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	8a 00                	mov    (%eax),%al
  801c31:	0f be c0             	movsbl %al,%eax
  801c34:	83 e8 57             	sub    $0x57,%eax
  801c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3a:	eb 20                	jmp    801c5c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8a 00                	mov    (%eax),%al
  801c41:	3c 40                	cmp    $0x40,%al
  801c43:	7e 39                	jle    801c7e <strtol+0x126>
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	3c 5a                	cmp    $0x5a,%al
  801c4c:	7f 30                	jg     801c7e <strtol+0x126>
			dig = *s - 'A' + 10;
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	83 e8 37             	sub    $0x37,%eax
  801c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c62:	7d 19                	jge    801c7d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801c64:	ff 45 08             	incl   0x8(%ebp)
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	0f af 45 10          	imul   0x10(%ebp),%eax
  801c6e:	89 c2                	mov    %eax,%edx
  801c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801c78:	e9 7b ff ff ff       	jmp    801bf8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801c7d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801c7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c82:	74 08                	je     801c8c <strtol+0x134>
		*endptr = (char *) s;
  801c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c87:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801c8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c90:	74 07                	je     801c99 <strtol+0x141>
  801c92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c95:	f7 d8                	neg    %eax
  801c97:	eb 03                	jmp    801c9c <strtol+0x144>
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <ltostr>:

void
ltostr(long value, char *str)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ca4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801cab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801cb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cb6:	79 13                	jns    801ccb <ltostr+0x2d>
	{
		neg = 1;
  801cb8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801cc5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801cc8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801cd3:	99                   	cltd   
  801cd4:	f7 f9                	idiv   %ecx
  801cd6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801cd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cdc:	8d 50 01             	lea    0x1(%eax),%edx
  801cdf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ce2:	89 c2                	mov    %eax,%edx
  801ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce7:	01 d0                	add    %edx,%eax
  801ce9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cec:	83 c2 30             	add    $0x30,%edx
  801cef:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801cf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801cf9:	f7 e9                	imul   %ecx
  801cfb:	c1 fa 02             	sar    $0x2,%edx
  801cfe:	89 c8                	mov    %ecx,%eax
  801d00:	c1 f8 1f             	sar    $0x1f,%eax
  801d03:	29 c2                	sub    %eax,%edx
  801d05:	89 d0                	mov    %edx,%eax
  801d07:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801d0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d12:	f7 e9                	imul   %ecx
  801d14:	c1 fa 02             	sar    $0x2,%edx
  801d17:	89 c8                	mov    %ecx,%eax
  801d19:	c1 f8 1f             	sar    $0x1f,%eax
  801d1c:	29 c2                	sub    %eax,%edx
  801d1e:	89 d0                	mov    %edx,%eax
  801d20:	c1 e0 02             	shl    $0x2,%eax
  801d23:	01 d0                	add    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	29 c1                	sub    %eax,%ecx
  801d29:	89 ca                	mov    %ecx,%edx
  801d2b:	85 d2                	test   %edx,%edx
  801d2d:	75 9c                	jne    801ccb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801d36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d39:	48                   	dec    %eax
  801d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801d3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d41:	74 3d                	je     801d80 <ltostr+0xe2>
		start = 1 ;
  801d43:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801d4a:	eb 34                	jmp    801d80 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d52:	01 d0                	add    %edx,%eax
  801d54:	8a 00                	mov    (%eax),%al
  801d56:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801d59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5f:	01 c2                	add    %eax,%edx
  801d61:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	01 c8                	add    %ecx,%eax
  801d69:	8a 00                	mov    (%eax),%al
  801d6b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801d6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d73:	01 c2                	add    %eax,%edx
  801d75:	8a 45 eb             	mov    -0x15(%ebp),%al
  801d78:	88 02                	mov    %al,(%edx)
		start++ ;
  801d7a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801d7d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d86:	7c c4                	jl     801d4c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801d88:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	01 d0                	add    %edx,%eax
  801d90:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801d93:	90                   	nop
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	e8 54 fa ff ff       	call   8017f8 <strlen>
  801da4:	83 c4 04             	add    $0x4,%esp
  801da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801daa:	ff 75 0c             	pushl  0xc(%ebp)
  801dad:	e8 46 fa ff ff       	call   8017f8 <strlen>
  801db2:	83 c4 04             	add    $0x4,%esp
  801db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801db8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801dbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801dc6:	eb 17                	jmp    801ddf <strcconcat+0x49>
		final[s] = str1[s] ;
  801dc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dce:	01 c2                	add    %eax,%edx
  801dd0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	01 c8                	add    %ecx,%eax
  801dd8:	8a 00                	mov    (%eax),%al
  801dda:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ddc:	ff 45 fc             	incl   -0x4(%ebp)
  801ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801de5:	7c e1                	jl     801dc8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801de7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801dee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801df5:	eb 1f                	jmp    801e16 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dfa:	8d 50 01             	lea    0x1(%eax),%edx
  801dfd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801e00:	89 c2                	mov    %eax,%edx
  801e02:	8b 45 10             	mov    0x10(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801e13:	ff 45 f8             	incl   -0x8(%ebp)
  801e16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e19:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e1c:	7c d9                	jl     801df7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801e1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e21:	8b 45 10             	mov    0x10(%ebp),%eax
  801e24:	01 d0                	add    %edx,%eax
  801e26:	c6 00 00             	movb   $0x0,(%eax)
}
  801e29:	90                   	nop
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801e2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801e38:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3b:	8b 00                	mov    (%eax),%eax
  801e3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	01 d0                	add    %edx,%eax
  801e49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e4f:	eb 0c                	jmp    801e5d <strsplit+0x31>
			*string++ = 0;
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	8d 50 01             	lea    0x1(%eax),%edx
  801e57:	89 55 08             	mov    %edx,0x8(%ebp)
  801e5a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	8a 00                	mov    (%eax),%al
  801e62:	84 c0                	test   %al,%al
  801e64:	74 18                	je     801e7e <strsplit+0x52>
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	8a 00                	mov    (%eax),%al
  801e6b:	0f be c0             	movsbl %al,%eax
  801e6e:	50                   	push   %eax
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	e8 13 fb ff ff       	call   80198a <strchr>
  801e77:	83 c4 08             	add    $0x8,%esp
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	75 d3                	jne    801e51 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	8a 00                	mov    (%eax),%al
  801e83:	84 c0                	test   %al,%al
  801e85:	74 5a                	je     801ee1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801e87:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8a:	8b 00                	mov    (%eax),%eax
  801e8c:	83 f8 0f             	cmp    $0xf,%eax
  801e8f:	75 07                	jne    801e98 <strsplit+0x6c>
		{
			return 0;
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	eb 66                	jmp    801efe <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801e98:	8b 45 14             	mov    0x14(%ebp),%eax
  801e9b:	8b 00                	mov    (%eax),%eax
  801e9d:	8d 48 01             	lea    0x1(%eax),%ecx
  801ea0:	8b 55 14             	mov    0x14(%ebp),%edx
  801ea3:	89 0a                	mov    %ecx,(%edx)
  801ea5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eac:	8b 45 10             	mov    0x10(%ebp),%eax
  801eaf:	01 c2                	add    %eax,%edx
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801eb6:	eb 03                	jmp    801ebb <strsplit+0x8f>
			string++;
  801eb8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	8a 00                	mov    (%eax),%al
  801ec0:	84 c0                	test   %al,%al
  801ec2:	74 8b                	je     801e4f <strsplit+0x23>
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	8a 00                	mov    (%eax),%al
  801ec9:	0f be c0             	movsbl %al,%eax
  801ecc:	50                   	push   %eax
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	e8 b5 fa ff ff       	call   80198a <strchr>
  801ed5:	83 c4 08             	add    $0x8,%esp
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	74 dc                	je     801eb8 <strsplit+0x8c>
			string++;
	}
  801edc:	e9 6e ff ff ff       	jmp    801e4f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ee1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee5:	8b 00                	mov    (%eax),%eax
  801ee7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eee:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ef9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801f06:	a1 04 50 80 00       	mov    0x805004,%eax
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	74 1f                	je     801f2e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801f0f:	e8 1d 00 00 00       	call   801f31 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	68 90 49 80 00       	push   $0x804990
  801f1c:	e8 55 f2 ff ff       	call   801176 <cprintf>
  801f21:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801f24:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801f2b:	00 00 00 
	}
}
  801f2e:	90                   	nop
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801f37:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801f3e:	00 00 00 
  801f41:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801f48:	00 00 00 
  801f4b:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801f52:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801f55:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801f5c:	00 00 00 
  801f5f:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801f66:	00 00 00 
  801f69:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801f70:	00 00 00 
	uint32 arr_size = 0;
  801f73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801f7a:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f84:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f89:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f8e:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801f93:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801f9a:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801f9d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fa4:	a1 20 51 80 00       	mov    0x805120,%eax
  801fa9:	c1 e0 04             	shl    $0x4,%eax
  801fac:	89 c2                	mov    %eax,%edx
  801fae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb1:	01 d0                	add    %edx,%eax
  801fb3:	48                   	dec    %eax
  801fb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801fb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fba:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbf:	f7 75 ec             	divl   -0x14(%ebp)
  801fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fc5:	29 d0                	sub    %edx,%eax
  801fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801fca:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fd4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801fd9:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fde:	83 ec 04             	sub    $0x4,%esp
  801fe1:	6a 06                	push   $0x6
  801fe3:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe6:	50                   	push   %eax
  801fe7:	e8 42 04 00 00       	call   80242e <sys_allocate_chunk>
  801fec:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801fef:	a1 20 51 80 00       	mov    0x805120,%eax
  801ff4:	83 ec 0c             	sub    $0xc,%esp
  801ff7:	50                   	push   %eax
  801ff8:	e8 b7 0a 00 00       	call   802ab4 <initialize_MemBlocksList>
  801ffd:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  802000:	a1 48 51 80 00       	mov    0x805148,%eax
  802005:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  802008:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80200b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  802012:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802015:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  80201c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802020:	75 14                	jne    802036 <initialize_dyn_block_system+0x105>
  802022:	83 ec 04             	sub    $0x4,%esp
  802025:	68 b5 49 80 00       	push   $0x8049b5
  80202a:	6a 33                	push   $0x33
  80202c:	68 d3 49 80 00       	push   $0x8049d3
  802031:	e8 8c ee ff ff       	call   800ec2 <_panic>
  802036:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802039:	8b 00                	mov    (%eax),%eax
  80203b:	85 c0                	test   %eax,%eax
  80203d:	74 10                	je     80204f <initialize_dyn_block_system+0x11e>
  80203f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802042:	8b 00                	mov    (%eax),%eax
  802044:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802047:	8b 52 04             	mov    0x4(%edx),%edx
  80204a:	89 50 04             	mov    %edx,0x4(%eax)
  80204d:	eb 0b                	jmp    80205a <initialize_dyn_block_system+0x129>
  80204f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802052:	8b 40 04             	mov    0x4(%eax),%eax
  802055:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80205a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80205d:	8b 40 04             	mov    0x4(%eax),%eax
  802060:	85 c0                	test   %eax,%eax
  802062:	74 0f                	je     802073 <initialize_dyn_block_system+0x142>
  802064:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802067:	8b 40 04             	mov    0x4(%eax),%eax
  80206a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80206d:	8b 12                	mov    (%edx),%edx
  80206f:	89 10                	mov    %edx,(%eax)
  802071:	eb 0a                	jmp    80207d <initialize_dyn_block_system+0x14c>
  802073:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802076:	8b 00                	mov    (%eax),%eax
  802078:	a3 48 51 80 00       	mov    %eax,0x805148
  80207d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802086:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802089:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802090:	a1 54 51 80 00       	mov    0x805154,%eax
  802095:	48                   	dec    %eax
  802096:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  80209b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80209f:	75 14                	jne    8020b5 <initialize_dyn_block_system+0x184>
  8020a1:	83 ec 04             	sub    $0x4,%esp
  8020a4:	68 e0 49 80 00       	push   $0x8049e0
  8020a9:	6a 34                	push   $0x34
  8020ab:	68 d3 49 80 00       	push   $0x8049d3
  8020b0:	e8 0d ee ff ff       	call   800ec2 <_panic>
  8020b5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8020bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020be:	89 10                	mov    %edx,(%eax)
  8020c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020c3:	8b 00                	mov    (%eax),%eax
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	74 0d                	je     8020d6 <initialize_dyn_block_system+0x1a5>
  8020c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8020ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020d1:	89 50 04             	mov    %edx,0x4(%eax)
  8020d4:	eb 08                	jmp    8020de <initialize_dyn_block_system+0x1ad>
  8020d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8020de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e1:	a3 38 51 80 00       	mov    %eax,0x805138
  8020e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8020f5:	40                   	inc    %eax
  8020f6:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8020fb:	90                   	nop
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802104:	e8 f7 fd ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  802109:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80210d:	75 07                	jne    802116 <malloc+0x18>
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
  802114:	eb 14                	jmp    80212a <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  802116:	83 ec 04             	sub    $0x4,%esp
  802119:	68 04 4a 80 00       	push   $0x804a04
  80211e:	6a 46                	push   $0x46
  802120:	68 d3 49 80 00       	push   $0x8049d3
  802125:	e8 98 ed ff ff       	call   800ec2 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802132:	83 ec 04             	sub    $0x4,%esp
  802135:	68 2c 4a 80 00       	push   $0x804a2c
  80213a:	6a 61                	push   $0x61
  80213c:	68 d3 49 80 00       	push   $0x8049d3
  802141:	e8 7c ed ff ff       	call   800ec2 <_panic>

00802146 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 38             	sub    $0x38,%esp
  80214c:	8b 45 10             	mov    0x10(%ebp),%eax
  80214f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802152:	e8 a9 fd ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  802157:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80215b:	75 0a                	jne    802167 <smalloc+0x21>
  80215d:	b8 00 00 00 00       	mov    $0x0,%eax
  802162:	e9 9e 00 00 00       	jmp    802205 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802167:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80216e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802174:	01 d0                	add    %edx,%eax
  802176:	48                   	dec    %eax
  802177:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80217a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217d:	ba 00 00 00 00       	mov    $0x0,%edx
  802182:	f7 75 f0             	divl   -0x10(%ebp)
  802185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802188:	29 d0                	sub    %edx,%eax
  80218a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80218d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802194:	e8 63 06 00 00       	call   8027fc <sys_isUHeapPlacementStrategyFIRSTFIT>
  802199:	85 c0                	test   %eax,%eax
  80219b:	74 11                	je     8021ae <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80219d:	83 ec 0c             	sub    $0xc,%esp
  8021a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8021a3:	e8 ce 0c 00 00       	call   802e76 <alloc_block_FF>
  8021a8:	83 c4 10             	add    $0x10,%esp
  8021ab:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8021ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b2:	74 4c                	je     802200 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8021b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b7:	8b 40 08             	mov    0x8(%eax),%eax
  8021ba:	89 c2                	mov    %eax,%edx
  8021bc:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8021c0:	52                   	push   %edx
  8021c1:	50                   	push   %eax
  8021c2:	ff 75 0c             	pushl  0xc(%ebp)
  8021c5:	ff 75 08             	pushl  0x8(%ebp)
  8021c8:	e8 b4 03 00 00       	call   802581 <sys_createSharedObject>
  8021cd:	83 c4 10             	add    $0x10,%esp
  8021d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8021d3:	83 ec 08             	sub    $0x8,%esp
  8021d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8021d9:	68 4f 4a 80 00       	push   $0x804a4f
  8021de:	e8 93 ef ff ff       	call   801176 <cprintf>
  8021e3:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8021e6:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8021ea:	74 14                	je     802200 <smalloc+0xba>
  8021ec:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8021f0:	74 0e                	je     802200 <smalloc+0xba>
  8021f2:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8021f6:	74 08                	je     802200 <smalloc+0xba>
			return (void*) mem_block->sva;
  8021f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fb:	8b 40 08             	mov    0x8(%eax),%eax
  8021fe:	eb 05                	jmp    802205 <smalloc+0xbf>
	}
	return NULL;
  802200:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80220d:	e8 ee fc ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802212:	83 ec 04             	sub    $0x4,%esp
  802215:	68 64 4a 80 00       	push   $0x804a64
  80221a:	68 ab 00 00 00       	push   $0xab
  80221f:	68 d3 49 80 00       	push   $0x8049d3
  802224:	e8 99 ec ff ff       	call   800ec2 <_panic>

00802229 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80222f:	e8 cc fc ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802234:	83 ec 04             	sub    $0x4,%esp
  802237:	68 88 4a 80 00       	push   $0x804a88
  80223c:	68 ef 00 00 00       	push   $0xef
  802241:	68 d3 49 80 00       	push   $0x8049d3
  802246:	e8 77 ec ff ff       	call   800ec2 <_panic>

0080224b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802251:	83 ec 04             	sub    $0x4,%esp
  802254:	68 b0 4a 80 00       	push   $0x804ab0
  802259:	68 03 01 00 00       	push   $0x103
  80225e:	68 d3 49 80 00       	push   $0x8049d3
  802263:	e8 5a ec ff ff       	call   800ec2 <_panic>

00802268 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80226e:	83 ec 04             	sub    $0x4,%esp
  802271:	68 d4 4a 80 00       	push   $0x804ad4
  802276:	68 0e 01 00 00       	push   $0x10e
  80227b:	68 d3 49 80 00       	push   $0x8049d3
  802280:	e8 3d ec ff ff       	call   800ec2 <_panic>

00802285 <shrink>:

}
void shrink(uint32 newSize)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80228b:	83 ec 04             	sub    $0x4,%esp
  80228e:	68 d4 4a 80 00       	push   $0x804ad4
  802293:	68 13 01 00 00       	push   $0x113
  802298:	68 d3 49 80 00       	push   $0x8049d3
  80229d:	e8 20 ec ff ff       	call   800ec2 <_panic>

008022a2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022a8:	83 ec 04             	sub    $0x4,%esp
  8022ab:	68 d4 4a 80 00       	push   $0x804ad4
  8022b0:	68 18 01 00 00       	push   $0x118
  8022b5:	68 d3 49 80 00       	push   $0x8049d3
  8022ba:	e8 03 ec ff ff       	call   800ec2 <_panic>

008022bf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
  8022c2:	57                   	push   %edi
  8022c3:	56                   	push   %esi
  8022c4:	53                   	push   %ebx
  8022c5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022d4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022d7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022da:	cd 30                	int    $0x30
  8022dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022e2:	83 c4 10             	add    $0x10,%esp
  8022e5:	5b                   	pop    %ebx
  8022e6:	5e                   	pop    %esi
  8022e7:	5f                   	pop    %edi
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    

008022ea <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	83 ec 04             	sub    $0x4,%esp
  8022f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8022f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	52                   	push   %edx
  802302:	ff 75 0c             	pushl  0xc(%ebp)
  802305:	50                   	push   %eax
  802306:	6a 00                	push   $0x0
  802308:	e8 b2 ff ff ff       	call   8022bf <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
}
  802310:	90                   	nop
  802311:	c9                   	leave  
  802312:	c3                   	ret    

00802313 <sys_cgetc>:

int
sys_cgetc(void)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 01                	push   $0x1
  802322:	e8 98 ff ff ff       	call   8022bf <syscall>
  802327:	83 c4 18             	add    $0x18,%esp
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80232f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	52                   	push   %edx
  80233c:	50                   	push   %eax
  80233d:	6a 05                	push   $0x5
  80233f:	e8 7b ff ff ff       	call   8022bf <syscall>
  802344:	83 c4 18             	add    $0x18,%esp
}
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	56                   	push   %esi
  80234d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80234e:	8b 75 18             	mov    0x18(%ebp),%esi
  802351:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802354:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	56                   	push   %esi
  80235e:	53                   	push   %ebx
  80235f:	51                   	push   %ecx
  802360:	52                   	push   %edx
  802361:	50                   	push   %eax
  802362:	6a 06                	push   $0x6
  802364:	e8 56 ff ff ff       	call   8022bf <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
}
  80236c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80236f:	5b                   	pop    %ebx
  802370:	5e                   	pop    %esi
  802371:	5d                   	pop    %ebp
  802372:	c3                   	ret    

00802373 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802376:	8b 55 0c             	mov    0xc(%ebp),%edx
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	52                   	push   %edx
  802383:	50                   	push   %eax
  802384:	6a 07                	push   $0x7
  802386:	e8 34 ff ff ff       	call   8022bf <syscall>
  80238b:	83 c4 18             	add    $0x18,%esp
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	ff 75 0c             	pushl  0xc(%ebp)
  80239c:	ff 75 08             	pushl  0x8(%ebp)
  80239f:	6a 08                	push   $0x8
  8023a1:	e8 19 ff ff ff       	call   8022bf <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 09                	push   $0x9
  8023ba:	e8 00 ff ff ff       	call   8022bf <syscall>
  8023bf:	83 c4 18             	add    $0x18,%esp
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 0a                	push   $0xa
  8023d3:	e8 e7 fe ff ff       	call   8022bf <syscall>
  8023d8:	83 c4 18             	add    $0x18,%esp
}
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 0b                	push   $0xb
  8023ec:	e8 ce fe ff ff       	call   8022bf <syscall>
  8023f1:	83 c4 18             	add    $0x18,%esp
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	ff 75 0c             	pushl  0xc(%ebp)
  802402:	ff 75 08             	pushl  0x8(%ebp)
  802405:	6a 0f                	push   $0xf
  802407:	e8 b3 fe ff ff       	call   8022bf <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
	return;
  80240f:	90                   	nop
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	ff 75 0c             	pushl  0xc(%ebp)
  80241e:	ff 75 08             	pushl  0x8(%ebp)
  802421:	6a 10                	push   $0x10
  802423:	e8 97 fe ff ff       	call   8022bf <syscall>
  802428:	83 c4 18             	add    $0x18,%esp
	return ;
  80242b:	90                   	nop
}
  80242c:	c9                   	leave  
  80242d:	c3                   	ret    

0080242e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	ff 75 10             	pushl  0x10(%ebp)
  802438:	ff 75 0c             	pushl  0xc(%ebp)
  80243b:	ff 75 08             	pushl  0x8(%ebp)
  80243e:	6a 11                	push   $0x11
  802440:	e8 7a fe ff ff       	call   8022bf <syscall>
  802445:	83 c4 18             	add    $0x18,%esp
	return ;
  802448:	90                   	nop
}
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 0c                	push   $0xc
  80245a:	e8 60 fe ff ff       	call   8022bf <syscall>
  80245f:	83 c4 18             	add    $0x18,%esp
}
  802462:	c9                   	leave  
  802463:	c3                   	ret    

00802464 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	ff 75 08             	pushl  0x8(%ebp)
  802472:	6a 0d                	push   $0xd
  802474:	e8 46 fe ff ff       	call   8022bf <syscall>
  802479:	83 c4 18             	add    $0x18,%esp
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 0e                	push   $0xe
  80248d:	e8 2d fe ff ff       	call   8022bf <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 13                	push   $0x13
  8024a7:	e8 13 fe ff ff       	call   8022bf <syscall>
  8024ac:	83 c4 18             	add    $0x18,%esp
}
  8024af:	90                   	nop
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 14                	push   $0x14
  8024c1:	e8 f9 fd ff ff       	call   8022bf <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
}
  8024c9:	90                   	nop
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_cputc>:


void
sys_cputc(const char c)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	83 ec 04             	sub    $0x4,%esp
  8024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024d8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	50                   	push   %eax
  8024e5:	6a 15                	push   $0x15
  8024e7:	e8 d3 fd ff ff       	call   8022bf <syscall>
  8024ec:	83 c4 18             	add    $0x18,%esp
}
  8024ef:	90                   	nop
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 16                	push   $0x16
  802501:	e8 b9 fd ff ff       	call   8022bf <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
}
  802509:	90                   	nop
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	ff 75 0c             	pushl  0xc(%ebp)
  80251b:	50                   	push   %eax
  80251c:	6a 17                	push   $0x17
  80251e:	e8 9c fd ff ff       	call   8022bf <syscall>
  802523:	83 c4 18             	add    $0x18,%esp
}
  802526:	c9                   	leave  
  802527:	c3                   	ret    

00802528 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802528:	55                   	push   %ebp
  802529:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80252b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	52                   	push   %edx
  802538:	50                   	push   %eax
  802539:	6a 1a                	push   $0x1a
  80253b:	e8 7f fd ff ff       	call   8022bf <syscall>
  802540:	83 c4 18             	add    $0x18,%esp
}
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802545:	55                   	push   %ebp
  802546:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	52                   	push   %edx
  802555:	50                   	push   %eax
  802556:	6a 18                	push   $0x18
  802558:	e8 62 fd ff ff       	call   8022bf <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
}
  802560:	90                   	nop
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802566:	8b 55 0c             	mov    0xc(%ebp),%edx
  802569:	8b 45 08             	mov    0x8(%ebp),%eax
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	52                   	push   %edx
  802573:	50                   	push   %eax
  802574:	6a 19                	push   $0x19
  802576:	e8 44 fd ff ff       	call   8022bf <syscall>
  80257b:	83 c4 18             	add    $0x18,%esp
}
  80257e:	90                   	nop
  80257f:	c9                   	leave  
  802580:	c3                   	ret    

00802581 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802581:	55                   	push   %ebp
  802582:	89 e5                	mov    %esp,%ebp
  802584:	83 ec 04             	sub    $0x4,%esp
  802587:	8b 45 10             	mov    0x10(%ebp),%eax
  80258a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80258d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802590:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802594:	8b 45 08             	mov    0x8(%ebp),%eax
  802597:	6a 00                	push   $0x0
  802599:	51                   	push   %ecx
  80259a:	52                   	push   %edx
  80259b:	ff 75 0c             	pushl  0xc(%ebp)
  80259e:	50                   	push   %eax
  80259f:	6a 1b                	push   $0x1b
  8025a1:	e8 19 fd ff ff       	call   8022bf <syscall>
  8025a6:	83 c4 18             	add    $0x18,%esp
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8025ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	52                   	push   %edx
  8025bb:	50                   	push   %eax
  8025bc:	6a 1c                	push   $0x1c
  8025be:	e8 fc fc ff ff       	call   8022bf <syscall>
  8025c3:	83 c4 18             	add    $0x18,%esp
}
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8025cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	51                   	push   %ecx
  8025d9:	52                   	push   %edx
  8025da:	50                   	push   %eax
  8025db:	6a 1d                	push   $0x1d
  8025dd:	e8 dd fc ff ff       	call   8022bf <syscall>
  8025e2:	83 c4 18             	add    $0x18,%esp
}
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	52                   	push   %edx
  8025f7:	50                   	push   %eax
  8025f8:	6a 1e                	push   $0x1e
  8025fa:	e8 c0 fc ff ff       	call   8022bf <syscall>
  8025ff:	83 c4 18             	add    $0x18,%esp
}
  802602:	c9                   	leave  
  802603:	c3                   	ret    

00802604 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802604:	55                   	push   %ebp
  802605:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802607:	6a 00                	push   $0x0
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 1f                	push   $0x1f
  802613:	e8 a7 fc ff ff       	call   8022bf <syscall>
  802618:	83 c4 18             	add    $0x18,%esp
}
  80261b:	c9                   	leave  
  80261c:	c3                   	ret    

0080261d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802620:	8b 45 08             	mov    0x8(%ebp),%eax
  802623:	6a 00                	push   $0x0
  802625:	ff 75 14             	pushl  0x14(%ebp)
  802628:	ff 75 10             	pushl  0x10(%ebp)
  80262b:	ff 75 0c             	pushl  0xc(%ebp)
  80262e:	50                   	push   %eax
  80262f:	6a 20                	push   $0x20
  802631:	e8 89 fc ff ff       	call   8022bf <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
}
  802639:	c9                   	leave  
  80263a:	c3                   	ret    

0080263b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	50                   	push   %eax
  80264a:	6a 21                	push   $0x21
  80264c:	e8 6e fc ff ff       	call   8022bf <syscall>
  802651:	83 c4 18             	add    $0x18,%esp
}
  802654:	90                   	nop
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80265a:	8b 45 08             	mov    0x8(%ebp),%eax
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	50                   	push   %eax
  802666:	6a 22                	push   $0x22
  802668:	e8 52 fc ff ff       	call   8022bf <syscall>
  80266d:	83 c4 18             	add    $0x18,%esp
}
  802670:	c9                   	leave  
  802671:	c3                   	ret    

00802672 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 02                	push   $0x2
  802681:	e8 39 fc ff ff       	call   8022bf <syscall>
  802686:	83 c4 18             	add    $0x18,%esp
}
  802689:	c9                   	leave  
  80268a:	c3                   	ret    

0080268b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 03                	push   $0x3
  80269a:	e8 20 fc ff ff       	call   8022bf <syscall>
  80269f:	83 c4 18             	add    $0x18,%esp
}
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 04                	push   $0x4
  8026b3:	e8 07 fc ff ff       	call   8022bf <syscall>
  8026b8:	83 c4 18             	add    $0x18,%esp
}
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <sys_exit_env>:


void sys_exit_env(void)
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 23                	push   $0x23
  8026cc:	e8 ee fb ff ff       	call   8022bf <syscall>
  8026d1:	83 c4 18             	add    $0x18,%esp
}
  8026d4:	90                   	nop
  8026d5:	c9                   	leave  
  8026d6:	c3                   	ret    

008026d7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
  8026da:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8026dd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026e0:	8d 50 04             	lea    0x4(%eax),%edx
  8026e3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	52                   	push   %edx
  8026ed:	50                   	push   %eax
  8026ee:	6a 24                	push   $0x24
  8026f0:	e8 ca fb ff ff       	call   8022bf <syscall>
  8026f5:	83 c4 18             	add    $0x18,%esp
	return result;
  8026f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802701:	89 01                	mov    %eax,(%ecx)
  802703:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	c9                   	leave  
  80270a:	c2 04 00             	ret    $0x4

0080270d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	ff 75 10             	pushl  0x10(%ebp)
  802717:	ff 75 0c             	pushl  0xc(%ebp)
  80271a:	ff 75 08             	pushl  0x8(%ebp)
  80271d:	6a 12                	push   $0x12
  80271f:	e8 9b fb ff ff       	call   8022bf <syscall>
  802724:	83 c4 18             	add    $0x18,%esp
	return ;
  802727:	90                   	nop
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <sys_rcr2>:
uint32 sys_rcr2()
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 25                	push   $0x25
  802739:	e8 81 fb ff ff       	call   8022bf <syscall>
  80273e:	83 c4 18             	add    $0x18,%esp
}
  802741:	c9                   	leave  
  802742:	c3                   	ret    

00802743 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802743:	55                   	push   %ebp
  802744:	89 e5                	mov    %esp,%ebp
  802746:	83 ec 04             	sub    $0x4,%esp
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80274f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	50                   	push   %eax
  80275c:	6a 26                	push   $0x26
  80275e:	e8 5c fb ff ff       	call   8022bf <syscall>
  802763:	83 c4 18             	add    $0x18,%esp
	return ;
  802766:	90                   	nop
}
  802767:	c9                   	leave  
  802768:	c3                   	ret    

00802769 <rsttst>:
void rsttst()
{
  802769:	55                   	push   %ebp
  80276a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80276c:	6a 00                	push   $0x0
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 28                	push   $0x28
  802778:	e8 42 fb ff ff       	call   8022bf <syscall>
  80277d:	83 c4 18             	add    $0x18,%esp
	return ;
  802780:	90                   	nop
}
  802781:	c9                   	leave  
  802782:	c3                   	ret    

00802783 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
  802786:	83 ec 04             	sub    $0x4,%esp
  802789:	8b 45 14             	mov    0x14(%ebp),%eax
  80278c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80278f:	8b 55 18             	mov    0x18(%ebp),%edx
  802792:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802796:	52                   	push   %edx
  802797:	50                   	push   %eax
  802798:	ff 75 10             	pushl  0x10(%ebp)
  80279b:	ff 75 0c             	pushl  0xc(%ebp)
  80279e:	ff 75 08             	pushl  0x8(%ebp)
  8027a1:	6a 27                	push   $0x27
  8027a3:	e8 17 fb ff ff       	call   8022bf <syscall>
  8027a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ab:	90                   	nop
}
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    

008027ae <chktst>:
void chktst(uint32 n)
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	ff 75 08             	pushl  0x8(%ebp)
  8027bc:	6a 29                	push   $0x29
  8027be:	e8 fc fa ff ff       	call   8022bf <syscall>
  8027c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c6:	90                   	nop
}
  8027c7:	c9                   	leave  
  8027c8:	c3                   	ret    

008027c9 <inctst>:

void inctst()
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 2a                	push   $0x2a
  8027d8:	e8 e2 fa ff ff       	call   8022bf <syscall>
  8027dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e0:	90                   	nop
}
  8027e1:	c9                   	leave  
  8027e2:	c3                   	ret    

008027e3 <gettst>:
uint32 gettst()
{
  8027e3:	55                   	push   %ebp
  8027e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	6a 00                	push   $0x0
  8027ee:	6a 00                	push   $0x0
  8027f0:	6a 2b                	push   $0x2b
  8027f2:	e8 c8 fa ff ff       	call   8022bf <syscall>
  8027f7:	83 c4 18             	add    $0x18,%esp
}
  8027fa:	c9                   	leave  
  8027fb:	c3                   	ret    

008027fc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8027fc:	55                   	push   %ebp
  8027fd:	89 e5                	mov    %esp,%ebp
  8027ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802802:	6a 00                	push   $0x0
  802804:	6a 00                	push   $0x0
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	6a 00                	push   $0x0
  80280c:	6a 2c                	push   $0x2c
  80280e:	e8 ac fa ff ff       	call   8022bf <syscall>
  802813:	83 c4 18             	add    $0x18,%esp
  802816:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802819:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80281d:	75 07                	jne    802826 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80281f:	b8 01 00 00 00       	mov    $0x1,%eax
  802824:	eb 05                	jmp    80282b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80282b:	c9                   	leave  
  80282c:	c3                   	ret    

0080282d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80282d:	55                   	push   %ebp
  80282e:	89 e5                	mov    %esp,%ebp
  802830:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802833:	6a 00                	push   $0x0
  802835:	6a 00                	push   $0x0
  802837:	6a 00                	push   $0x0
  802839:	6a 00                	push   $0x0
  80283b:	6a 00                	push   $0x0
  80283d:	6a 2c                	push   $0x2c
  80283f:	e8 7b fa ff ff       	call   8022bf <syscall>
  802844:	83 c4 18             	add    $0x18,%esp
  802847:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80284a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80284e:	75 07                	jne    802857 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802850:	b8 01 00 00 00       	mov    $0x1,%eax
  802855:	eb 05                	jmp    80285c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802857:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80285c:	c9                   	leave  
  80285d:	c3                   	ret    

0080285e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
  802861:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 00                	push   $0x0
  80286e:	6a 2c                	push   $0x2c
  802870:	e8 4a fa ff ff       	call   8022bf <syscall>
  802875:	83 c4 18             	add    $0x18,%esp
  802878:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80287b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80287f:	75 07                	jne    802888 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802881:	b8 01 00 00 00       	mov    $0x1,%eax
  802886:	eb 05                	jmp    80288d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802888:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80288d:	c9                   	leave  
  80288e:	c3                   	ret    

0080288f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80288f:	55                   	push   %ebp
  802890:	89 e5                	mov    %esp,%ebp
  802892:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802895:	6a 00                	push   $0x0
  802897:	6a 00                	push   $0x0
  802899:	6a 00                	push   $0x0
  80289b:	6a 00                	push   $0x0
  80289d:	6a 00                	push   $0x0
  80289f:	6a 2c                	push   $0x2c
  8028a1:	e8 19 fa ff ff       	call   8022bf <syscall>
  8028a6:	83 c4 18             	add    $0x18,%esp
  8028a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8028ac:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8028b0:	75 07                	jne    8028b9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8028b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028b7:	eb 05                	jmp    8028be <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8028b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028be:	c9                   	leave  
  8028bf:	c3                   	ret    

008028c0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8028c3:	6a 00                	push   $0x0
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 00                	push   $0x0
  8028cb:	ff 75 08             	pushl  0x8(%ebp)
  8028ce:	6a 2d                	push   $0x2d
  8028d0:	e8 ea f9 ff ff       	call   8022bf <syscall>
  8028d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8028d8:	90                   	nop
}
  8028d9:	c9                   	leave  
  8028da:	c3                   	ret    

008028db <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8028db:	55                   	push   %ebp
  8028dc:	89 e5                	mov    %esp,%ebp
  8028de:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8028df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028eb:	6a 00                	push   $0x0
  8028ed:	53                   	push   %ebx
  8028ee:	51                   	push   %ecx
  8028ef:	52                   	push   %edx
  8028f0:	50                   	push   %eax
  8028f1:	6a 2e                	push   $0x2e
  8028f3:	e8 c7 f9 ff ff       	call   8022bf <syscall>
  8028f8:	83 c4 18             	add    $0x18,%esp
}
  8028fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028fe:	c9                   	leave  
  8028ff:	c3                   	ret    

00802900 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802903:	8b 55 0c             	mov    0xc(%ebp),%edx
  802906:	8b 45 08             	mov    0x8(%ebp),%eax
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	52                   	push   %edx
  802910:	50                   	push   %eax
  802911:	6a 2f                	push   $0x2f
  802913:	e8 a7 f9 ff ff       	call   8022bf <syscall>
  802918:	83 c4 18             	add    $0x18,%esp
}
  80291b:	c9                   	leave  
  80291c:	c3                   	ret    

0080291d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80291d:	55                   	push   %ebp
  80291e:	89 e5                	mov    %esp,%ebp
  802920:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802923:	83 ec 0c             	sub    $0xc,%esp
  802926:	68 e4 4a 80 00       	push   $0x804ae4
  80292b:	e8 46 e8 ff ff       	call   801176 <cprintf>
  802930:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802933:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80293a:	83 ec 0c             	sub    $0xc,%esp
  80293d:	68 10 4b 80 00       	push   $0x804b10
  802942:	e8 2f e8 ff ff       	call   801176 <cprintf>
  802947:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80294a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80294e:	a1 38 51 80 00       	mov    0x805138,%eax
  802953:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802956:	eb 56                	jmp    8029ae <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802958:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80295c:	74 1c                	je     80297a <print_mem_block_lists+0x5d>
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 50 08             	mov    0x8(%eax),%edx
  802964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802967:	8b 48 08             	mov    0x8(%eax),%ecx
  80296a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296d:	8b 40 0c             	mov    0xc(%eax),%eax
  802970:	01 c8                	add    %ecx,%eax
  802972:	39 c2                	cmp    %eax,%edx
  802974:	73 04                	jae    80297a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802976:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 50 08             	mov    0x8(%eax),%edx
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 40 0c             	mov    0xc(%eax),%eax
  802986:	01 c2                	add    %eax,%edx
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 40 08             	mov    0x8(%eax),%eax
  80298e:	83 ec 04             	sub    $0x4,%esp
  802991:	52                   	push   %edx
  802992:	50                   	push   %eax
  802993:	68 25 4b 80 00       	push   $0x804b25
  802998:	e8 d9 e7 ff ff       	call   801176 <cprintf>
  80299d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029a6:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b2:	74 07                	je     8029bb <print_mem_block_lists+0x9e>
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 00                	mov    (%eax),%eax
  8029b9:	eb 05                	jmp    8029c0 <print_mem_block_lists+0xa3>
  8029bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c0:	a3 40 51 80 00       	mov    %eax,0x805140
  8029c5:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	75 8a                	jne    802958 <print_mem_block_lists+0x3b>
  8029ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d2:	75 84                	jne    802958 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8029d4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029d8:	75 10                	jne    8029ea <print_mem_block_lists+0xcd>
  8029da:	83 ec 0c             	sub    $0xc,%esp
  8029dd:	68 34 4b 80 00       	push   $0x804b34
  8029e2:	e8 8f e7 ff ff       	call   801176 <cprintf>
  8029e7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8029ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8029f1:	83 ec 0c             	sub    $0xc,%esp
  8029f4:	68 58 4b 80 00       	push   $0x804b58
  8029f9:	e8 78 e7 ff ff       	call   801176 <cprintf>
  8029fe:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802a01:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a05:	a1 40 50 80 00       	mov    0x805040,%eax
  802a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0d:	eb 56                	jmp    802a65 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802a0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a13:	74 1c                	je     802a31 <print_mem_block_lists+0x114>
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 50 08             	mov    0x8(%eax),%edx
  802a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1e:	8b 48 08             	mov    0x8(%eax),%ecx
  802a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a24:	8b 40 0c             	mov    0xc(%eax),%eax
  802a27:	01 c8                	add    %ecx,%eax
  802a29:	39 c2                	cmp    %eax,%edx
  802a2b:	73 04                	jae    802a31 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802a2d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	8b 50 08             	mov    0x8(%eax),%edx
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3d:	01 c2                	add    %eax,%edx
  802a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a42:	8b 40 08             	mov    0x8(%eax),%eax
  802a45:	83 ec 04             	sub    $0x4,%esp
  802a48:	52                   	push   %edx
  802a49:	50                   	push   %eax
  802a4a:	68 25 4b 80 00       	push   $0x804b25
  802a4f:	e8 22 e7 ff ff       	call   801176 <cprintf>
  802a54:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a5d:	a1 48 50 80 00       	mov    0x805048,%eax
  802a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a69:	74 07                	je     802a72 <print_mem_block_lists+0x155>
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 00                	mov    (%eax),%eax
  802a70:	eb 05                	jmp    802a77 <print_mem_block_lists+0x15a>
  802a72:	b8 00 00 00 00       	mov    $0x0,%eax
  802a77:	a3 48 50 80 00       	mov    %eax,0x805048
  802a7c:	a1 48 50 80 00       	mov    0x805048,%eax
  802a81:	85 c0                	test   %eax,%eax
  802a83:	75 8a                	jne    802a0f <print_mem_block_lists+0xf2>
  802a85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a89:	75 84                	jne    802a0f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802a8b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a8f:	75 10                	jne    802aa1 <print_mem_block_lists+0x184>
  802a91:	83 ec 0c             	sub    $0xc,%esp
  802a94:	68 70 4b 80 00       	push   $0x804b70
  802a99:	e8 d8 e6 ff ff       	call   801176 <cprintf>
  802a9e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802aa1:	83 ec 0c             	sub    $0xc,%esp
  802aa4:	68 e4 4a 80 00       	push   $0x804ae4
  802aa9:	e8 c8 e6 ff ff       	call   801176 <cprintf>
  802aae:	83 c4 10             	add    $0x10,%esp

}
  802ab1:	90                   	nop
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
  802ab7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802aba:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802ac1:	00 00 00 
  802ac4:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802acb:	00 00 00 
  802ace:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802ad5:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802ad8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802adf:	e9 9e 00 00 00       	jmp    802b82 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802ae4:	a1 50 50 80 00       	mov    0x805050,%eax
  802ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aec:	c1 e2 04             	shl    $0x4,%edx
  802aef:	01 d0                	add    %edx,%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	75 14                	jne    802b09 <initialize_MemBlocksList+0x55>
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	68 98 4b 80 00       	push   $0x804b98
  802afd:	6a 46                	push   $0x46
  802aff:	68 bb 4b 80 00       	push   $0x804bbb
  802b04:	e8 b9 e3 ff ff       	call   800ec2 <_panic>
  802b09:	a1 50 50 80 00       	mov    0x805050,%eax
  802b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b11:	c1 e2 04             	shl    $0x4,%edx
  802b14:	01 d0                	add    %edx,%eax
  802b16:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802b1c:	89 10                	mov    %edx,(%eax)
  802b1e:	8b 00                	mov    (%eax),%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	74 18                	je     802b3c <initialize_MemBlocksList+0x88>
  802b24:	a1 48 51 80 00       	mov    0x805148,%eax
  802b29:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802b2f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802b32:	c1 e1 04             	shl    $0x4,%ecx
  802b35:	01 ca                	add    %ecx,%edx
  802b37:	89 50 04             	mov    %edx,0x4(%eax)
  802b3a:	eb 12                	jmp    802b4e <initialize_MemBlocksList+0x9a>
  802b3c:	a1 50 50 80 00       	mov    0x805050,%eax
  802b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b44:	c1 e2 04             	shl    $0x4,%edx
  802b47:	01 d0                	add    %edx,%eax
  802b49:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b4e:	a1 50 50 80 00       	mov    0x805050,%eax
  802b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b56:	c1 e2 04             	shl    $0x4,%edx
  802b59:	01 d0                	add    %edx,%eax
  802b5b:	a3 48 51 80 00       	mov    %eax,0x805148
  802b60:	a1 50 50 80 00       	mov    0x805050,%eax
  802b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b68:	c1 e2 04             	shl    $0x4,%edx
  802b6b:	01 d0                	add    %edx,%eax
  802b6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b74:	a1 54 51 80 00       	mov    0x805154,%eax
  802b79:	40                   	inc    %eax
  802b7a:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802b7f:	ff 45 f4             	incl   -0xc(%ebp)
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b88:	0f 82 56 ff ff ff    	jb     802ae4 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802b8e:	90                   	nop
  802b8f:	c9                   	leave  
  802b90:	c3                   	ret    

00802b91 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802b91:	55                   	push   %ebp
  802b92:	89 e5                	mov    %esp,%ebp
  802b94:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b9f:	eb 19                	jmp    802bba <find_block+0x29>
	{
		if(va==point->sva)
  802ba1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ba4:	8b 40 08             	mov    0x8(%eax),%eax
  802ba7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802baa:	75 05                	jne    802bb1 <find_block+0x20>
		   return point;
  802bac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802baf:	eb 36                	jmp    802be7 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	8b 40 08             	mov    0x8(%eax),%eax
  802bb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802bba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802bbe:	74 07                	je     802bc7 <find_block+0x36>
  802bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	eb 05                	jmp    802bcc <find_block+0x3b>
  802bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  802bcf:	89 42 08             	mov    %eax,0x8(%edx)
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	8b 40 08             	mov    0x8(%eax),%eax
  802bd8:	85 c0                	test   %eax,%eax
  802bda:	75 c5                	jne    802ba1 <find_block+0x10>
  802bdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802be0:	75 bf                	jne    802ba1 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802be2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be7:	c9                   	leave  
  802be8:	c3                   	ret    

00802be9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802be9:	55                   	push   %ebp
  802bea:	89 e5                	mov    %esp,%ebp
  802bec:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802bef:	a1 40 50 80 00       	mov    0x805040,%eax
  802bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802bf7:	a1 44 50 80 00       	mov    0x805044,%eax
  802bfc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c02:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802c05:	74 24                	je     802c2b <insert_sorted_allocList+0x42>
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	8b 50 08             	mov    0x8(%eax),%edx
  802c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c10:	8b 40 08             	mov    0x8(%eax),%eax
  802c13:	39 c2                	cmp    %eax,%edx
  802c15:	76 14                	jbe    802c2b <insert_sorted_allocList+0x42>
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	8b 50 08             	mov    0x8(%eax),%edx
  802c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c20:	8b 40 08             	mov    0x8(%eax),%eax
  802c23:	39 c2                	cmp    %eax,%edx
  802c25:	0f 82 60 01 00 00    	jb     802d8b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802c2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c2f:	75 65                	jne    802c96 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802c31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c35:	75 14                	jne    802c4b <insert_sorted_allocList+0x62>
  802c37:	83 ec 04             	sub    $0x4,%esp
  802c3a:	68 98 4b 80 00       	push   $0x804b98
  802c3f:	6a 6b                	push   $0x6b
  802c41:	68 bb 4b 80 00       	push   $0x804bbb
  802c46:	e8 77 e2 ff ff       	call   800ec2 <_panic>
  802c4b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	89 10                	mov    %edx,(%eax)
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	8b 00                	mov    (%eax),%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	74 0d                	je     802c6c <insert_sorted_allocList+0x83>
  802c5f:	a1 40 50 80 00       	mov    0x805040,%eax
  802c64:	8b 55 08             	mov    0x8(%ebp),%edx
  802c67:	89 50 04             	mov    %edx,0x4(%eax)
  802c6a:	eb 08                	jmp    802c74 <insert_sorted_allocList+0x8b>
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	a3 44 50 80 00       	mov    %eax,0x805044
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	a3 40 50 80 00       	mov    %eax,0x805040
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c86:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c8b:	40                   	inc    %eax
  802c8c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c91:	e9 dc 01 00 00       	jmp    802e72 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	8b 50 08             	mov    0x8(%eax),%edx
  802c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ca2:	39 c2                	cmp    %eax,%edx
  802ca4:	77 6c                	ja     802d12 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802ca6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802caa:	74 06                	je     802cb2 <insert_sorted_allocList+0xc9>
  802cac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb0:	75 14                	jne    802cc6 <insert_sorted_allocList+0xdd>
  802cb2:	83 ec 04             	sub    $0x4,%esp
  802cb5:	68 d4 4b 80 00       	push   $0x804bd4
  802cba:	6a 6f                	push   $0x6f
  802cbc:	68 bb 4b 80 00       	push   $0x804bbb
  802cc1:	e8 fc e1 ff ff       	call   800ec2 <_panic>
  802cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc9:	8b 50 04             	mov    0x4(%eax),%edx
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	89 50 04             	mov    %edx,0x4(%eax)
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd8:	89 10                	mov    %edx,(%eax)
  802cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdd:	8b 40 04             	mov    0x4(%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 0d                	je     802cf1 <insert_sorted_allocList+0x108>
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	8b 55 08             	mov    0x8(%ebp),%edx
  802ced:	89 10                	mov    %edx,(%eax)
  802cef:	eb 08                	jmp    802cf9 <insert_sorted_allocList+0x110>
  802cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf4:	a3 40 50 80 00       	mov    %eax,0x805040
  802cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  802cff:	89 50 04             	mov    %edx,0x4(%eax)
  802d02:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d07:	40                   	inc    %eax
  802d08:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d0d:	e9 60 01 00 00       	jmp    802e72 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	8b 50 08             	mov    0x8(%eax),%edx
  802d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1b:	8b 40 08             	mov    0x8(%eax),%eax
  802d1e:	39 c2                	cmp    %eax,%edx
  802d20:	0f 82 4c 01 00 00    	jb     802e72 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802d26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d2a:	75 14                	jne    802d40 <insert_sorted_allocList+0x157>
  802d2c:	83 ec 04             	sub    $0x4,%esp
  802d2f:	68 0c 4c 80 00       	push   $0x804c0c
  802d34:	6a 73                	push   $0x73
  802d36:	68 bb 4b 80 00       	push   $0x804bbb
  802d3b:	e8 82 e1 ff ff       	call   800ec2 <_panic>
  802d40:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	89 50 04             	mov    %edx,0x4(%eax)
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	8b 40 04             	mov    0x4(%eax),%eax
  802d52:	85 c0                	test   %eax,%eax
  802d54:	74 0c                	je     802d62 <insert_sorted_allocList+0x179>
  802d56:	a1 44 50 80 00       	mov    0x805044,%eax
  802d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5e:	89 10                	mov    %edx,(%eax)
  802d60:	eb 08                	jmp    802d6a <insert_sorted_allocList+0x181>
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	a3 40 50 80 00       	mov    %eax,0x805040
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	a3 44 50 80 00       	mov    %eax,0x805044
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d80:	40                   	inc    %eax
  802d81:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d86:	e9 e7 00 00 00       	jmp    802e72 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802d91:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802d98:	a1 40 50 80 00       	mov    0x805040,%eax
  802d9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da0:	e9 9d 00 00 00       	jmp    802e42 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	8b 50 08             	mov    0x8(%eax),%edx
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 40 08             	mov    0x8(%eax),%eax
  802db9:	39 c2                	cmp    %eax,%edx
  802dbb:	76 7d                	jbe    802e3a <insert_sorted_allocList+0x251>
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	8b 50 08             	mov    0x8(%eax),%edx
  802dc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc6:	8b 40 08             	mov    0x8(%eax),%eax
  802dc9:	39 c2                	cmp    %eax,%edx
  802dcb:	73 6d                	jae    802e3a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802dcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd1:	74 06                	je     802dd9 <insert_sorted_allocList+0x1f0>
  802dd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd7:	75 14                	jne    802ded <insert_sorted_allocList+0x204>
  802dd9:	83 ec 04             	sub    $0x4,%esp
  802ddc:	68 30 4c 80 00       	push   $0x804c30
  802de1:	6a 7f                	push   $0x7f
  802de3:	68 bb 4b 80 00       	push   $0x804bbb
  802de8:	e8 d5 e0 ff ff       	call   800ec2 <_panic>
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 10                	mov    (%eax),%edx
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	89 10                	mov    %edx,(%eax)
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	8b 00                	mov    (%eax),%eax
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	74 0b                	je     802e0b <insert_sorted_allocList+0x222>
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	8b 55 08             	mov    0x8(%ebp),%edx
  802e08:	89 50 04             	mov    %edx,0x4(%eax)
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e11:	89 10                	mov    %edx,(%eax)
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e19:	89 50 04             	mov    %edx,0x4(%eax)
  802e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1f:	8b 00                	mov    (%eax),%eax
  802e21:	85 c0                	test   %eax,%eax
  802e23:	75 08                	jne    802e2d <insert_sorted_allocList+0x244>
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	a3 44 50 80 00       	mov    %eax,0x805044
  802e2d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e32:	40                   	inc    %eax
  802e33:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802e38:	eb 39                	jmp    802e73 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802e3a:	a1 48 50 80 00       	mov    0x805048,%eax
  802e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e46:	74 07                	je     802e4f <insert_sorted_allocList+0x266>
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	8b 00                	mov    (%eax),%eax
  802e4d:	eb 05                	jmp    802e54 <insert_sorted_allocList+0x26b>
  802e4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e54:	a3 48 50 80 00       	mov    %eax,0x805048
  802e59:	a1 48 50 80 00       	mov    0x805048,%eax
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	0f 85 3f ff ff ff    	jne    802da5 <insert_sorted_allocList+0x1bc>
  802e66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6a:	0f 85 35 ff ff ff    	jne    802da5 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802e70:	eb 01                	jmp    802e73 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802e72:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802e73:	90                   	nop
  802e74:	c9                   	leave  
  802e75:	c3                   	ret    

00802e76 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802e76:	55                   	push   %ebp
  802e77:	89 e5                	mov    %esp,%ebp
  802e79:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802e7c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e84:	e9 85 01 00 00       	jmp    80300e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e92:	0f 82 6e 01 00 00    	jb     803006 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ea1:	0f 85 8a 00 00 00    	jne    802f31 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802ea7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eab:	75 17                	jne    802ec4 <alloc_block_FF+0x4e>
  802ead:	83 ec 04             	sub    $0x4,%esp
  802eb0:	68 64 4c 80 00       	push   $0x804c64
  802eb5:	68 93 00 00 00       	push   $0x93
  802eba:	68 bb 4b 80 00       	push   $0x804bbb
  802ebf:	e8 fe df ff ff       	call   800ec2 <_panic>
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	8b 00                	mov    (%eax),%eax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	74 10                	je     802edd <alloc_block_FF+0x67>
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 00                	mov    (%eax),%eax
  802ed2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed5:	8b 52 04             	mov    0x4(%edx),%edx
  802ed8:	89 50 04             	mov    %edx,0x4(%eax)
  802edb:	eb 0b                	jmp    802ee8 <alloc_block_FF+0x72>
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	8b 40 04             	mov    0x4(%eax),%eax
  802ee3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 40 04             	mov    0x4(%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	74 0f                	je     802f01 <alloc_block_FF+0x8b>
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efb:	8b 12                	mov    (%edx),%edx
  802efd:	89 10                	mov    %edx,(%eax)
  802eff:	eb 0a                	jmp    802f0b <alloc_block_FF+0x95>
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 00                	mov    (%eax),%eax
  802f06:	a3 38 51 80 00       	mov    %eax,0x805138
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1e:	a1 44 51 80 00       	mov    0x805144,%eax
  802f23:	48                   	dec    %eax
  802f24:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	e9 10 01 00 00       	jmp    803041 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 40 0c             	mov    0xc(%eax),%eax
  802f37:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f3a:	0f 86 c6 00 00 00    	jbe    803006 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f40:	a1 48 51 80 00       	mov    0x805148,%eax
  802f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	8b 50 08             	mov    0x8(%eax),%edx
  802f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f51:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f57:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f61:	75 17                	jne    802f7a <alloc_block_FF+0x104>
  802f63:	83 ec 04             	sub    $0x4,%esp
  802f66:	68 64 4c 80 00       	push   $0x804c64
  802f6b:	68 9b 00 00 00       	push   $0x9b
  802f70:	68 bb 4b 80 00       	push   $0x804bbb
  802f75:	e8 48 df ff ff       	call   800ec2 <_panic>
  802f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7d:	8b 00                	mov    (%eax),%eax
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	74 10                	je     802f93 <alloc_block_FF+0x11d>
  802f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f86:	8b 00                	mov    (%eax),%eax
  802f88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f8b:	8b 52 04             	mov    0x4(%edx),%edx
  802f8e:	89 50 04             	mov    %edx,0x4(%eax)
  802f91:	eb 0b                	jmp    802f9e <alloc_block_FF+0x128>
  802f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f96:	8b 40 04             	mov    0x4(%eax),%eax
  802f99:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa1:	8b 40 04             	mov    0x4(%eax),%eax
  802fa4:	85 c0                	test   %eax,%eax
  802fa6:	74 0f                	je     802fb7 <alloc_block_FF+0x141>
  802fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fb1:	8b 12                	mov    (%edx),%edx
  802fb3:	89 10                	mov    %edx,(%eax)
  802fb5:	eb 0a                	jmp    802fc1 <alloc_block_FF+0x14b>
  802fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fba:	8b 00                	mov    (%eax),%eax
  802fbc:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd4:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd9:	48                   	dec    %eax
  802fda:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 50 08             	mov    0x8(%eax),%edx
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	01 c2                	add    %eax,%edx
  802fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fed:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff6:	2b 45 08             	sub    0x8(%ebp),%eax
  802ff9:	89 c2                	mov    %eax,%edx
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  803001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803004:	eb 3b                	jmp    803041 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803006:	a1 40 51 80 00       	mov    0x805140,%eax
  80300b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803012:	74 07                	je     80301b <alloc_block_FF+0x1a5>
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	8b 00                	mov    (%eax),%eax
  803019:	eb 05                	jmp    803020 <alloc_block_FF+0x1aa>
  80301b:	b8 00 00 00 00       	mov    $0x0,%eax
  803020:	a3 40 51 80 00       	mov    %eax,0x805140
  803025:	a1 40 51 80 00       	mov    0x805140,%eax
  80302a:	85 c0                	test   %eax,%eax
  80302c:	0f 85 57 fe ff ff    	jne    802e89 <alloc_block_FF+0x13>
  803032:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803036:	0f 85 4d fe ff ff    	jne    802e89 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80303c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803041:	c9                   	leave  
  803042:	c3                   	ret    

00803043 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803043:	55                   	push   %ebp
  803044:	89 e5                	mov    %esp,%ebp
  803046:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  803049:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803050:	a1 38 51 80 00       	mov    0x805138,%eax
  803055:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803058:	e9 df 00 00 00       	jmp    80313c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 40 0c             	mov    0xc(%eax),%eax
  803063:	3b 45 08             	cmp    0x8(%ebp),%eax
  803066:	0f 82 c8 00 00 00    	jb     803134 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80306c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306f:	8b 40 0c             	mov    0xc(%eax),%eax
  803072:	3b 45 08             	cmp    0x8(%ebp),%eax
  803075:	0f 85 8a 00 00 00    	jne    803105 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80307b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307f:	75 17                	jne    803098 <alloc_block_BF+0x55>
  803081:	83 ec 04             	sub    $0x4,%esp
  803084:	68 64 4c 80 00       	push   $0x804c64
  803089:	68 b7 00 00 00       	push   $0xb7
  80308e:	68 bb 4b 80 00       	push   $0x804bbb
  803093:	e8 2a de ff ff       	call   800ec2 <_panic>
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	8b 00                	mov    (%eax),%eax
  80309d:	85 c0                	test   %eax,%eax
  80309f:	74 10                	je     8030b1 <alloc_block_BF+0x6e>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 00                	mov    (%eax),%eax
  8030a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a9:	8b 52 04             	mov    0x4(%edx),%edx
  8030ac:	89 50 04             	mov    %edx,0x4(%eax)
  8030af:	eb 0b                	jmp    8030bc <alloc_block_BF+0x79>
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	8b 40 04             	mov    0x4(%eax),%eax
  8030b7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	8b 40 04             	mov    0x4(%eax),%eax
  8030c2:	85 c0                	test   %eax,%eax
  8030c4:	74 0f                	je     8030d5 <alloc_block_BF+0x92>
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 40 04             	mov    0x4(%eax),%eax
  8030cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030cf:	8b 12                	mov    (%edx),%edx
  8030d1:	89 10                	mov    %edx,(%eax)
  8030d3:	eb 0a                	jmp    8030df <alloc_block_BF+0x9c>
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	8b 00                	mov    (%eax),%eax
  8030da:	a3 38 51 80 00       	mov    %eax,0x805138
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f7:	48                   	dec    %eax
  8030f8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	e9 4d 01 00 00       	jmp    803252 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803108:	8b 40 0c             	mov    0xc(%eax),%eax
  80310b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80310e:	76 24                	jbe    803134 <alloc_block_BF+0xf1>
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	8b 40 0c             	mov    0xc(%eax),%eax
  803116:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803119:	73 19                	jae    803134 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80311b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 40 0c             	mov    0xc(%eax),%eax
  803128:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312e:	8b 40 08             	mov    0x8(%eax),%eax
  803131:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803134:	a1 40 51 80 00       	mov    0x805140,%eax
  803139:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80313c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803140:	74 07                	je     803149 <alloc_block_BF+0x106>
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	eb 05                	jmp    80314e <alloc_block_BF+0x10b>
  803149:	b8 00 00 00 00       	mov    $0x0,%eax
  80314e:	a3 40 51 80 00       	mov    %eax,0x805140
  803153:	a1 40 51 80 00       	mov    0x805140,%eax
  803158:	85 c0                	test   %eax,%eax
  80315a:	0f 85 fd fe ff ff    	jne    80305d <alloc_block_BF+0x1a>
  803160:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803164:	0f 85 f3 fe ff ff    	jne    80305d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80316a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80316e:	0f 84 d9 00 00 00    	je     80324d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803174:	a1 48 51 80 00       	mov    0x805148,%eax
  803179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80317c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803182:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803188:	8b 55 08             	mov    0x8(%ebp),%edx
  80318b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80318e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803192:	75 17                	jne    8031ab <alloc_block_BF+0x168>
  803194:	83 ec 04             	sub    $0x4,%esp
  803197:	68 64 4c 80 00       	push   $0x804c64
  80319c:	68 c7 00 00 00       	push   $0xc7
  8031a1:	68 bb 4b 80 00       	push   $0x804bbb
  8031a6:	e8 17 dd ff ff       	call   800ec2 <_panic>
  8031ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ae:	8b 00                	mov    (%eax),%eax
  8031b0:	85 c0                	test   %eax,%eax
  8031b2:	74 10                	je     8031c4 <alloc_block_BF+0x181>
  8031b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b7:	8b 00                	mov    (%eax),%eax
  8031b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031bc:	8b 52 04             	mov    0x4(%edx),%edx
  8031bf:	89 50 04             	mov    %edx,0x4(%eax)
  8031c2:	eb 0b                	jmp    8031cf <alloc_block_BF+0x18c>
  8031c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d2:	8b 40 04             	mov    0x4(%eax),%eax
  8031d5:	85 c0                	test   %eax,%eax
  8031d7:	74 0f                	je     8031e8 <alloc_block_BF+0x1a5>
  8031d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031dc:	8b 40 04             	mov    0x4(%eax),%eax
  8031df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031e2:	8b 12                	mov    (%edx),%edx
  8031e4:	89 10                	mov    %edx,(%eax)
  8031e6:	eb 0a                	jmp    8031f2 <alloc_block_BF+0x1af>
  8031e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	a3 48 51 80 00       	mov    %eax,0x805148
  8031f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803205:	a1 54 51 80 00       	mov    0x805154,%eax
  80320a:	48                   	dec    %eax
  80320b:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803210:	83 ec 08             	sub    $0x8,%esp
  803213:	ff 75 ec             	pushl  -0x14(%ebp)
  803216:	68 38 51 80 00       	push   $0x805138
  80321b:	e8 71 f9 ff ff       	call   802b91 <find_block>
  803220:	83 c4 10             	add    $0x10,%esp
  803223:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803226:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803229:	8b 50 08             	mov    0x8(%eax),%edx
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	01 c2                	add    %eax,%edx
  803231:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803234:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803237:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80323a:	8b 40 0c             	mov    0xc(%eax),%eax
  80323d:	2b 45 08             	sub    0x8(%ebp),%eax
  803240:	89 c2                	mov    %eax,%edx
  803242:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803245:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324b:	eb 05                	jmp    803252 <alloc_block_BF+0x20f>
	}
	return NULL;
  80324d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803252:	c9                   	leave  
  803253:	c3                   	ret    

00803254 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803254:	55                   	push   %ebp
  803255:	89 e5                	mov    %esp,%ebp
  803257:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80325a:	a1 28 50 80 00       	mov    0x805028,%eax
  80325f:	85 c0                	test   %eax,%eax
  803261:	0f 85 de 01 00 00    	jne    803445 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803267:	a1 38 51 80 00       	mov    0x805138,%eax
  80326c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80326f:	e9 9e 01 00 00       	jmp    803412 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803277:	8b 40 0c             	mov    0xc(%eax),%eax
  80327a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80327d:	0f 82 87 01 00 00    	jb     80340a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	8b 40 0c             	mov    0xc(%eax),%eax
  803289:	3b 45 08             	cmp    0x8(%ebp),%eax
  80328c:	0f 85 95 00 00 00    	jne    803327 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803296:	75 17                	jne    8032af <alloc_block_NF+0x5b>
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	68 64 4c 80 00       	push   $0x804c64
  8032a0:	68 e0 00 00 00       	push   $0xe0
  8032a5:	68 bb 4b 80 00       	push   $0x804bbb
  8032aa:	e8 13 dc ff ff       	call   800ec2 <_panic>
  8032af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b2:	8b 00                	mov    (%eax),%eax
  8032b4:	85 c0                	test   %eax,%eax
  8032b6:	74 10                	je     8032c8 <alloc_block_NF+0x74>
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	8b 00                	mov    (%eax),%eax
  8032bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c0:	8b 52 04             	mov    0x4(%edx),%edx
  8032c3:	89 50 04             	mov    %edx,0x4(%eax)
  8032c6:	eb 0b                	jmp    8032d3 <alloc_block_NF+0x7f>
  8032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d6:	8b 40 04             	mov    0x4(%eax),%eax
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	74 0f                	je     8032ec <alloc_block_NF+0x98>
  8032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e0:	8b 40 04             	mov    0x4(%eax),%eax
  8032e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e6:	8b 12                	mov    (%edx),%edx
  8032e8:	89 10                	mov    %edx,(%eax)
  8032ea:	eb 0a                	jmp    8032f6 <alloc_block_NF+0xa2>
  8032ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ef:	8b 00                	mov    (%eax),%eax
  8032f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803302:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803309:	a1 44 51 80 00       	mov    0x805144,%eax
  80330e:	48                   	dec    %eax
  80330f:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803317:	8b 40 08             	mov    0x8(%eax),%eax
  80331a:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80331f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803322:	e9 f8 04 00 00       	jmp    80381f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332a:	8b 40 0c             	mov    0xc(%eax),%eax
  80332d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803330:	0f 86 d4 00 00 00    	jbe    80340a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803336:	a1 48 51 80 00       	mov    0x805148,%eax
  80333b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803341:	8b 50 08             	mov    0x8(%eax),%edx
  803344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803347:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80334a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334d:	8b 55 08             	mov    0x8(%ebp),%edx
  803350:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803353:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803357:	75 17                	jne    803370 <alloc_block_NF+0x11c>
  803359:	83 ec 04             	sub    $0x4,%esp
  80335c:	68 64 4c 80 00       	push   $0x804c64
  803361:	68 e9 00 00 00       	push   $0xe9
  803366:	68 bb 4b 80 00       	push   $0x804bbb
  80336b:	e8 52 db ff ff       	call   800ec2 <_panic>
  803370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803373:	8b 00                	mov    (%eax),%eax
  803375:	85 c0                	test   %eax,%eax
  803377:	74 10                	je     803389 <alloc_block_NF+0x135>
  803379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337c:	8b 00                	mov    (%eax),%eax
  80337e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803381:	8b 52 04             	mov    0x4(%edx),%edx
  803384:	89 50 04             	mov    %edx,0x4(%eax)
  803387:	eb 0b                	jmp    803394 <alloc_block_NF+0x140>
  803389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338c:	8b 40 04             	mov    0x4(%eax),%eax
  80338f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803397:	8b 40 04             	mov    0x4(%eax),%eax
  80339a:	85 c0                	test   %eax,%eax
  80339c:	74 0f                	je     8033ad <alloc_block_NF+0x159>
  80339e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a1:	8b 40 04             	mov    0x4(%eax),%eax
  8033a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033a7:	8b 12                	mov    (%edx),%edx
  8033a9:	89 10                	mov    %edx,(%eax)
  8033ab:	eb 0a                	jmp    8033b7 <alloc_block_NF+0x163>
  8033ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b0:	8b 00                	mov    (%eax),%eax
  8033b2:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8033cf:	48                   	dec    %eax
  8033d0:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8033d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d8:	8b 40 08             	mov    0x8(%eax),%eax
  8033db:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8033e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e3:	8b 50 08             	mov    0x8(%eax),%edx
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	01 c2                	add    %eax,%edx
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f7:	2b 45 08             	sub    0x8(%ebp),%eax
  8033fa:	89 c2                	mov    %eax,%edx
  8033fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ff:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803405:	e9 15 04 00 00       	jmp    80381f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80340a:	a1 40 51 80 00       	mov    0x805140,%eax
  80340f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803412:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803416:	74 07                	je     80341f <alloc_block_NF+0x1cb>
  803418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341b:	8b 00                	mov    (%eax),%eax
  80341d:	eb 05                	jmp    803424 <alloc_block_NF+0x1d0>
  80341f:	b8 00 00 00 00       	mov    $0x0,%eax
  803424:	a3 40 51 80 00       	mov    %eax,0x805140
  803429:	a1 40 51 80 00       	mov    0x805140,%eax
  80342e:	85 c0                	test   %eax,%eax
  803430:	0f 85 3e fe ff ff    	jne    803274 <alloc_block_NF+0x20>
  803436:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343a:	0f 85 34 fe ff ff    	jne    803274 <alloc_block_NF+0x20>
  803440:	e9 d5 03 00 00       	jmp    80381a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803445:	a1 38 51 80 00       	mov    0x805138,%eax
  80344a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80344d:	e9 b1 01 00 00       	jmp    803603 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803455:	8b 50 08             	mov    0x8(%eax),%edx
  803458:	a1 28 50 80 00       	mov    0x805028,%eax
  80345d:	39 c2                	cmp    %eax,%edx
  80345f:	0f 82 96 01 00 00    	jb     8035fb <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803468:	8b 40 0c             	mov    0xc(%eax),%eax
  80346b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80346e:	0f 82 87 01 00 00    	jb     8035fb <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803477:	8b 40 0c             	mov    0xc(%eax),%eax
  80347a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80347d:	0f 85 95 00 00 00    	jne    803518 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803483:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803487:	75 17                	jne    8034a0 <alloc_block_NF+0x24c>
  803489:	83 ec 04             	sub    $0x4,%esp
  80348c:	68 64 4c 80 00       	push   $0x804c64
  803491:	68 fc 00 00 00       	push   $0xfc
  803496:	68 bb 4b 80 00       	push   $0x804bbb
  80349b:	e8 22 da ff ff       	call   800ec2 <_panic>
  8034a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	85 c0                	test   %eax,%eax
  8034a7:	74 10                	je     8034b9 <alloc_block_NF+0x265>
  8034a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ac:	8b 00                	mov    (%eax),%eax
  8034ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b1:	8b 52 04             	mov    0x4(%edx),%edx
  8034b4:	89 50 04             	mov    %edx,0x4(%eax)
  8034b7:	eb 0b                	jmp    8034c4 <alloc_block_NF+0x270>
  8034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bc:	8b 40 04             	mov    0x4(%eax),%eax
  8034bf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c7:	8b 40 04             	mov    0x4(%eax),%eax
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	74 0f                	je     8034dd <alloc_block_NF+0x289>
  8034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d1:	8b 40 04             	mov    0x4(%eax),%eax
  8034d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d7:	8b 12                	mov    (%edx),%edx
  8034d9:	89 10                	mov    %edx,(%eax)
  8034db:	eb 0a                	jmp    8034e7 <alloc_block_NF+0x293>
  8034dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e0:	8b 00                	mov    (%eax),%eax
  8034e2:	a3 38 51 80 00       	mov    %eax,0x805138
  8034e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ff:	48                   	dec    %eax
  803500:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803508:	8b 40 08             	mov    0x8(%eax),%eax
  80350b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803513:	e9 07 03 00 00       	jmp    80381f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351b:	8b 40 0c             	mov    0xc(%eax),%eax
  80351e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803521:	0f 86 d4 00 00 00    	jbe    8035fb <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803527:	a1 48 51 80 00       	mov    0x805148,%eax
  80352c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80352f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803532:	8b 50 08             	mov    0x8(%eax),%edx
  803535:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803538:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80353b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353e:	8b 55 08             	mov    0x8(%ebp),%edx
  803541:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803544:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803548:	75 17                	jne    803561 <alloc_block_NF+0x30d>
  80354a:	83 ec 04             	sub    $0x4,%esp
  80354d:	68 64 4c 80 00       	push   $0x804c64
  803552:	68 04 01 00 00       	push   $0x104
  803557:	68 bb 4b 80 00       	push   $0x804bbb
  80355c:	e8 61 d9 ff ff       	call   800ec2 <_panic>
  803561:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803564:	8b 00                	mov    (%eax),%eax
  803566:	85 c0                	test   %eax,%eax
  803568:	74 10                	je     80357a <alloc_block_NF+0x326>
  80356a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356d:	8b 00                	mov    (%eax),%eax
  80356f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803572:	8b 52 04             	mov    0x4(%edx),%edx
  803575:	89 50 04             	mov    %edx,0x4(%eax)
  803578:	eb 0b                	jmp    803585 <alloc_block_NF+0x331>
  80357a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357d:	8b 40 04             	mov    0x4(%eax),%eax
  803580:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803585:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803588:	8b 40 04             	mov    0x4(%eax),%eax
  80358b:	85 c0                	test   %eax,%eax
  80358d:	74 0f                	je     80359e <alloc_block_NF+0x34a>
  80358f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803592:	8b 40 04             	mov    0x4(%eax),%eax
  803595:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803598:	8b 12                	mov    (%edx),%edx
  80359a:	89 10                	mov    %edx,(%eax)
  80359c:	eb 0a                	jmp    8035a8 <alloc_block_NF+0x354>
  80359e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a1:	8b 00                	mov    (%eax),%eax
  8035a3:	a3 48 51 80 00       	mov    %eax,0x805148
  8035a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8035c0:	48                   	dec    %eax
  8035c1:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8035c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c9:	8b 40 08             	mov    0x8(%eax),%eax
  8035cc:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8035d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d4:	8b 50 08             	mov    0x8(%eax),%edx
  8035d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035da:	01 c2                	add    %eax,%edx
  8035dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035df:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8035e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e8:	2b 45 08             	sub    0x8(%ebp),%eax
  8035eb:	89 c2                	mov    %eax,%edx
  8035ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8035f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f6:	e9 24 02 00 00       	jmp    80381f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8035fb:	a1 40 51 80 00       	mov    0x805140,%eax
  803600:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803607:	74 07                	je     803610 <alloc_block_NF+0x3bc>
  803609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360c:	8b 00                	mov    (%eax),%eax
  80360e:	eb 05                	jmp    803615 <alloc_block_NF+0x3c1>
  803610:	b8 00 00 00 00       	mov    $0x0,%eax
  803615:	a3 40 51 80 00       	mov    %eax,0x805140
  80361a:	a1 40 51 80 00       	mov    0x805140,%eax
  80361f:	85 c0                	test   %eax,%eax
  803621:	0f 85 2b fe ff ff    	jne    803452 <alloc_block_NF+0x1fe>
  803627:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80362b:	0f 85 21 fe ff ff    	jne    803452 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803631:	a1 38 51 80 00       	mov    0x805138,%eax
  803636:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803639:	e9 ae 01 00 00       	jmp    8037ec <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80363e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803641:	8b 50 08             	mov    0x8(%eax),%edx
  803644:	a1 28 50 80 00       	mov    0x805028,%eax
  803649:	39 c2                	cmp    %eax,%edx
  80364b:	0f 83 93 01 00 00    	jae    8037e4 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803654:	8b 40 0c             	mov    0xc(%eax),%eax
  803657:	3b 45 08             	cmp    0x8(%ebp),%eax
  80365a:	0f 82 84 01 00 00    	jb     8037e4 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803663:	8b 40 0c             	mov    0xc(%eax),%eax
  803666:	3b 45 08             	cmp    0x8(%ebp),%eax
  803669:	0f 85 95 00 00 00    	jne    803704 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80366f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803673:	75 17                	jne    80368c <alloc_block_NF+0x438>
  803675:	83 ec 04             	sub    $0x4,%esp
  803678:	68 64 4c 80 00       	push   $0x804c64
  80367d:	68 14 01 00 00       	push   $0x114
  803682:	68 bb 4b 80 00       	push   $0x804bbb
  803687:	e8 36 d8 ff ff       	call   800ec2 <_panic>
  80368c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368f:	8b 00                	mov    (%eax),%eax
  803691:	85 c0                	test   %eax,%eax
  803693:	74 10                	je     8036a5 <alloc_block_NF+0x451>
  803695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803698:	8b 00                	mov    (%eax),%eax
  80369a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80369d:	8b 52 04             	mov    0x4(%edx),%edx
  8036a0:	89 50 04             	mov    %edx,0x4(%eax)
  8036a3:	eb 0b                	jmp    8036b0 <alloc_block_NF+0x45c>
  8036a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a8:	8b 40 04             	mov    0x4(%eax),%eax
  8036ab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b3:	8b 40 04             	mov    0x4(%eax),%eax
  8036b6:	85 c0                	test   %eax,%eax
  8036b8:	74 0f                	je     8036c9 <alloc_block_NF+0x475>
  8036ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bd:	8b 40 04             	mov    0x4(%eax),%eax
  8036c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036c3:	8b 12                	mov    (%edx),%edx
  8036c5:	89 10                	mov    %edx,(%eax)
  8036c7:	eb 0a                	jmp    8036d3 <alloc_block_NF+0x47f>
  8036c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cc:	8b 00                	mov    (%eax),%eax
  8036ce:	a3 38 51 80 00       	mov    %eax,0x805138
  8036d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e6:	a1 44 51 80 00       	mov    0x805144,%eax
  8036eb:	48                   	dec    %eax
  8036ec:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8036f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f4:	8b 40 08             	mov    0x8(%eax),%eax
  8036f7:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8036fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ff:	e9 1b 01 00 00       	jmp    80381f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803707:	8b 40 0c             	mov    0xc(%eax),%eax
  80370a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80370d:	0f 86 d1 00 00 00    	jbe    8037e4 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803713:	a1 48 51 80 00       	mov    0x805148,%eax
  803718:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371e:	8b 50 08             	mov    0x8(%eax),%edx
  803721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803724:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372a:	8b 55 08             	mov    0x8(%ebp),%edx
  80372d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803730:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803734:	75 17                	jne    80374d <alloc_block_NF+0x4f9>
  803736:	83 ec 04             	sub    $0x4,%esp
  803739:	68 64 4c 80 00       	push   $0x804c64
  80373e:	68 1c 01 00 00       	push   $0x11c
  803743:	68 bb 4b 80 00       	push   $0x804bbb
  803748:	e8 75 d7 ff ff       	call   800ec2 <_panic>
  80374d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803750:	8b 00                	mov    (%eax),%eax
  803752:	85 c0                	test   %eax,%eax
  803754:	74 10                	je     803766 <alloc_block_NF+0x512>
  803756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803759:	8b 00                	mov    (%eax),%eax
  80375b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80375e:	8b 52 04             	mov    0x4(%edx),%edx
  803761:	89 50 04             	mov    %edx,0x4(%eax)
  803764:	eb 0b                	jmp    803771 <alloc_block_NF+0x51d>
  803766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803769:	8b 40 04             	mov    0x4(%eax),%eax
  80376c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803771:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803774:	8b 40 04             	mov    0x4(%eax),%eax
  803777:	85 c0                	test   %eax,%eax
  803779:	74 0f                	je     80378a <alloc_block_NF+0x536>
  80377b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377e:	8b 40 04             	mov    0x4(%eax),%eax
  803781:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803784:	8b 12                	mov    (%edx),%edx
  803786:	89 10                	mov    %edx,(%eax)
  803788:	eb 0a                	jmp    803794 <alloc_block_NF+0x540>
  80378a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80378d:	8b 00                	mov    (%eax),%eax
  80378f:	a3 48 51 80 00       	mov    %eax,0x805148
  803794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8037ac:	48                   	dec    %eax
  8037ad:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8037b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b5:	8b 40 08             	mov    0x8(%eax),%eax
  8037b8:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8037bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c0:	8b 50 08             	mov    0x8(%eax),%edx
  8037c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c6:	01 c2                	add    %eax,%edx
  8037c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8037ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d4:	2b 45 08             	sub    0x8(%ebp),%eax
  8037d7:	89 c2                	mov    %eax,%edx
  8037d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037dc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8037df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e2:	eb 3b                	jmp    80381f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8037e4:	a1 40 51 80 00       	mov    0x805140,%eax
  8037e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f0:	74 07                	je     8037f9 <alloc_block_NF+0x5a5>
  8037f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f5:	8b 00                	mov    (%eax),%eax
  8037f7:	eb 05                	jmp    8037fe <alloc_block_NF+0x5aa>
  8037f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037fe:	a3 40 51 80 00       	mov    %eax,0x805140
  803803:	a1 40 51 80 00       	mov    0x805140,%eax
  803808:	85 c0                	test   %eax,%eax
  80380a:	0f 85 2e fe ff ff    	jne    80363e <alloc_block_NF+0x3ea>
  803810:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803814:	0f 85 24 fe ff ff    	jne    80363e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80381a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80381f:	c9                   	leave  
  803820:	c3                   	ret    

00803821 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803821:	55                   	push   %ebp
  803822:	89 e5                	mov    %esp,%ebp
  803824:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803827:	a1 38 51 80 00       	mov    0x805138,%eax
  80382c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80382f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803834:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803837:	a1 38 51 80 00       	mov    0x805138,%eax
  80383c:	85 c0                	test   %eax,%eax
  80383e:	74 14                	je     803854 <insert_sorted_with_merge_freeList+0x33>
  803840:	8b 45 08             	mov    0x8(%ebp),%eax
  803843:	8b 50 08             	mov    0x8(%eax),%edx
  803846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803849:	8b 40 08             	mov    0x8(%eax),%eax
  80384c:	39 c2                	cmp    %eax,%edx
  80384e:	0f 87 9b 01 00 00    	ja     8039ef <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803854:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803858:	75 17                	jne    803871 <insert_sorted_with_merge_freeList+0x50>
  80385a:	83 ec 04             	sub    $0x4,%esp
  80385d:	68 98 4b 80 00       	push   $0x804b98
  803862:	68 38 01 00 00       	push   $0x138
  803867:	68 bb 4b 80 00       	push   $0x804bbb
  80386c:	e8 51 d6 ff ff       	call   800ec2 <_panic>
  803871:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803877:	8b 45 08             	mov    0x8(%ebp),%eax
  80387a:	89 10                	mov    %edx,(%eax)
  80387c:	8b 45 08             	mov    0x8(%ebp),%eax
  80387f:	8b 00                	mov    (%eax),%eax
  803881:	85 c0                	test   %eax,%eax
  803883:	74 0d                	je     803892 <insert_sorted_with_merge_freeList+0x71>
  803885:	a1 38 51 80 00       	mov    0x805138,%eax
  80388a:	8b 55 08             	mov    0x8(%ebp),%edx
  80388d:	89 50 04             	mov    %edx,0x4(%eax)
  803890:	eb 08                	jmp    80389a <insert_sorted_with_merge_freeList+0x79>
  803892:	8b 45 08             	mov    0x8(%ebp),%eax
  803895:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80389a:	8b 45 08             	mov    0x8(%ebp),%eax
  80389d:	a3 38 51 80 00       	mov    %eax,0x805138
  8038a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8038b1:	40                   	inc    %eax
  8038b2:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8038b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038bb:	0f 84 a8 06 00 00    	je     803f69 <insert_sorted_with_merge_freeList+0x748>
  8038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c4:	8b 50 08             	mov    0x8(%eax),%edx
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8038cd:	01 c2                	add    %eax,%edx
  8038cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d2:	8b 40 08             	mov    0x8(%eax),%eax
  8038d5:	39 c2                	cmp    %eax,%edx
  8038d7:	0f 85 8c 06 00 00    	jne    803f69 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8038dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e0:	8b 50 0c             	mov    0xc(%eax),%edx
  8038e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8038e9:	01 c2                	add    %eax,%edx
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8038f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038f5:	75 17                	jne    80390e <insert_sorted_with_merge_freeList+0xed>
  8038f7:	83 ec 04             	sub    $0x4,%esp
  8038fa:	68 64 4c 80 00       	push   $0x804c64
  8038ff:	68 3c 01 00 00       	push   $0x13c
  803904:	68 bb 4b 80 00       	push   $0x804bbb
  803909:	e8 b4 d5 ff ff       	call   800ec2 <_panic>
  80390e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803911:	8b 00                	mov    (%eax),%eax
  803913:	85 c0                	test   %eax,%eax
  803915:	74 10                	je     803927 <insert_sorted_with_merge_freeList+0x106>
  803917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80391f:	8b 52 04             	mov    0x4(%edx),%edx
  803922:	89 50 04             	mov    %edx,0x4(%eax)
  803925:	eb 0b                	jmp    803932 <insert_sorted_with_merge_freeList+0x111>
  803927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392a:	8b 40 04             	mov    0x4(%eax),%eax
  80392d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803935:	8b 40 04             	mov    0x4(%eax),%eax
  803938:	85 c0                	test   %eax,%eax
  80393a:	74 0f                	je     80394b <insert_sorted_with_merge_freeList+0x12a>
  80393c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393f:	8b 40 04             	mov    0x4(%eax),%eax
  803942:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803945:	8b 12                	mov    (%edx),%edx
  803947:	89 10                	mov    %edx,(%eax)
  803949:	eb 0a                	jmp    803955 <insert_sorted_with_merge_freeList+0x134>
  80394b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394e:	8b 00                	mov    (%eax),%eax
  803950:	a3 38 51 80 00       	mov    %eax,0x805138
  803955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803958:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80395e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803961:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803968:	a1 44 51 80 00       	mov    0x805144,%eax
  80396d:	48                   	dec    %eax
  80396e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803976:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80397d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803980:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803987:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80398b:	75 17                	jne    8039a4 <insert_sorted_with_merge_freeList+0x183>
  80398d:	83 ec 04             	sub    $0x4,%esp
  803990:	68 98 4b 80 00       	push   $0x804b98
  803995:	68 3f 01 00 00       	push   $0x13f
  80399a:	68 bb 4b 80 00       	push   $0x804bbb
  80399f:	e8 1e d5 ff ff       	call   800ec2 <_panic>
  8039a4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ad:	89 10                	mov    %edx,(%eax)
  8039af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	85 c0                	test   %eax,%eax
  8039b6:	74 0d                	je     8039c5 <insert_sorted_with_merge_freeList+0x1a4>
  8039b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8039bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039c0:	89 50 04             	mov    %edx,0x4(%eax)
  8039c3:	eb 08                	jmp    8039cd <insert_sorted_with_merge_freeList+0x1ac>
  8039c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8039d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039df:	a1 54 51 80 00       	mov    0x805154,%eax
  8039e4:	40                   	inc    %eax
  8039e5:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8039ea:	e9 7a 05 00 00       	jmp    803f69 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8039ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f2:	8b 50 08             	mov    0x8(%eax),%edx
  8039f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039f8:	8b 40 08             	mov    0x8(%eax),%eax
  8039fb:	39 c2                	cmp    %eax,%edx
  8039fd:	0f 82 14 01 00 00    	jb     803b17 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a06:	8b 50 08             	mov    0x8(%eax),%edx
  803a09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  803a0f:	01 c2                	add    %eax,%edx
  803a11:	8b 45 08             	mov    0x8(%ebp),%eax
  803a14:	8b 40 08             	mov    0x8(%eax),%eax
  803a17:	39 c2                	cmp    %eax,%edx
  803a19:	0f 85 90 00 00 00    	jne    803aaf <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a22:	8b 50 0c             	mov    0xc(%eax),%edx
  803a25:	8b 45 08             	mov    0x8(%ebp),%eax
  803a28:	8b 40 0c             	mov    0xc(%eax),%eax
  803a2b:	01 c2                	add    %eax,%edx
  803a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a30:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803a33:	8b 45 08             	mov    0x8(%ebp),%eax
  803a36:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a40:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a4b:	75 17                	jne    803a64 <insert_sorted_with_merge_freeList+0x243>
  803a4d:	83 ec 04             	sub    $0x4,%esp
  803a50:	68 98 4b 80 00       	push   $0x804b98
  803a55:	68 49 01 00 00       	push   $0x149
  803a5a:	68 bb 4b 80 00       	push   $0x804bbb
  803a5f:	e8 5e d4 ff ff       	call   800ec2 <_panic>
  803a64:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6d:	89 10                	mov    %edx,(%eax)
  803a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a72:	8b 00                	mov    (%eax),%eax
  803a74:	85 c0                	test   %eax,%eax
  803a76:	74 0d                	je     803a85 <insert_sorted_with_merge_freeList+0x264>
  803a78:	a1 48 51 80 00       	mov    0x805148,%eax
  803a7d:	8b 55 08             	mov    0x8(%ebp),%edx
  803a80:	89 50 04             	mov    %edx,0x4(%eax)
  803a83:	eb 08                	jmp    803a8d <insert_sorted_with_merge_freeList+0x26c>
  803a85:	8b 45 08             	mov    0x8(%ebp),%eax
  803a88:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a90:	a3 48 51 80 00       	mov    %eax,0x805148
  803a95:	8b 45 08             	mov    0x8(%ebp),%eax
  803a98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a9f:	a1 54 51 80 00       	mov    0x805154,%eax
  803aa4:	40                   	inc    %eax
  803aa5:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803aaa:	e9 bb 04 00 00       	jmp    803f6a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803aaf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ab3:	75 17                	jne    803acc <insert_sorted_with_merge_freeList+0x2ab>
  803ab5:	83 ec 04             	sub    $0x4,%esp
  803ab8:	68 0c 4c 80 00       	push   $0x804c0c
  803abd:	68 4c 01 00 00       	push   $0x14c
  803ac2:	68 bb 4b 80 00       	push   $0x804bbb
  803ac7:	e8 f6 d3 ff ff       	call   800ec2 <_panic>
  803acc:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad5:	89 50 04             	mov    %edx,0x4(%eax)
  803ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  803adb:	8b 40 04             	mov    0x4(%eax),%eax
  803ade:	85 c0                	test   %eax,%eax
  803ae0:	74 0c                	je     803aee <insert_sorted_with_merge_freeList+0x2cd>
  803ae2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803ae7:	8b 55 08             	mov    0x8(%ebp),%edx
  803aea:	89 10                	mov    %edx,(%eax)
  803aec:	eb 08                	jmp    803af6 <insert_sorted_with_merge_freeList+0x2d5>
  803aee:	8b 45 08             	mov    0x8(%ebp),%eax
  803af1:	a3 38 51 80 00       	mov    %eax,0x805138
  803af6:	8b 45 08             	mov    0x8(%ebp),%eax
  803af9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803afe:	8b 45 08             	mov    0x8(%ebp),%eax
  803b01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b07:	a1 44 51 80 00       	mov    0x805144,%eax
  803b0c:	40                   	inc    %eax
  803b0d:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b12:	e9 53 04 00 00       	jmp    803f6a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b17:	a1 38 51 80 00       	mov    0x805138,%eax
  803b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b1f:	e9 15 04 00 00       	jmp    803f39 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b27:	8b 00                	mov    (%eax),%eax
  803b29:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2f:	8b 50 08             	mov    0x8(%eax),%edx
  803b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b35:	8b 40 08             	mov    0x8(%eax),%eax
  803b38:	39 c2                	cmp    %eax,%edx
  803b3a:	0f 86 f1 03 00 00    	jbe    803f31 <insert_sorted_with_merge_freeList+0x710>
  803b40:	8b 45 08             	mov    0x8(%ebp),%eax
  803b43:	8b 50 08             	mov    0x8(%eax),%edx
  803b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b49:	8b 40 08             	mov    0x8(%eax),%eax
  803b4c:	39 c2                	cmp    %eax,%edx
  803b4e:	0f 83 dd 03 00 00    	jae    803f31 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b57:	8b 50 08             	mov    0x8(%eax),%edx
  803b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5d:	8b 40 0c             	mov    0xc(%eax),%eax
  803b60:	01 c2                	add    %eax,%edx
  803b62:	8b 45 08             	mov    0x8(%ebp),%eax
  803b65:	8b 40 08             	mov    0x8(%eax),%eax
  803b68:	39 c2                	cmp    %eax,%edx
  803b6a:	0f 85 b9 01 00 00    	jne    803d29 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803b70:	8b 45 08             	mov    0x8(%ebp),%eax
  803b73:	8b 50 08             	mov    0x8(%eax),%edx
  803b76:	8b 45 08             	mov    0x8(%ebp),%eax
  803b79:	8b 40 0c             	mov    0xc(%eax),%eax
  803b7c:	01 c2                	add    %eax,%edx
  803b7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b81:	8b 40 08             	mov    0x8(%eax),%eax
  803b84:	39 c2                	cmp    %eax,%edx
  803b86:	0f 85 0d 01 00 00    	jne    803c99 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b8f:	8b 50 0c             	mov    0xc(%eax),%edx
  803b92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b95:	8b 40 0c             	mov    0xc(%eax),%eax
  803b98:	01 c2                	add    %eax,%edx
  803b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803ba0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ba4:	75 17                	jne    803bbd <insert_sorted_with_merge_freeList+0x39c>
  803ba6:	83 ec 04             	sub    $0x4,%esp
  803ba9:	68 64 4c 80 00       	push   $0x804c64
  803bae:	68 5c 01 00 00       	push   $0x15c
  803bb3:	68 bb 4b 80 00       	push   $0x804bbb
  803bb8:	e8 05 d3 ff ff       	call   800ec2 <_panic>
  803bbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc0:	8b 00                	mov    (%eax),%eax
  803bc2:	85 c0                	test   %eax,%eax
  803bc4:	74 10                	je     803bd6 <insert_sorted_with_merge_freeList+0x3b5>
  803bc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc9:	8b 00                	mov    (%eax),%eax
  803bcb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bce:	8b 52 04             	mov    0x4(%edx),%edx
  803bd1:	89 50 04             	mov    %edx,0x4(%eax)
  803bd4:	eb 0b                	jmp    803be1 <insert_sorted_with_merge_freeList+0x3c0>
  803bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd9:	8b 40 04             	mov    0x4(%eax),%eax
  803bdc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803be1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be4:	8b 40 04             	mov    0x4(%eax),%eax
  803be7:	85 c0                	test   %eax,%eax
  803be9:	74 0f                	je     803bfa <insert_sorted_with_merge_freeList+0x3d9>
  803beb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bee:	8b 40 04             	mov    0x4(%eax),%eax
  803bf1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bf4:	8b 12                	mov    (%edx),%edx
  803bf6:	89 10                	mov    %edx,(%eax)
  803bf8:	eb 0a                	jmp    803c04 <insert_sorted_with_merge_freeList+0x3e3>
  803bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bfd:	8b 00                	mov    (%eax),%eax
  803bff:	a3 38 51 80 00       	mov    %eax,0x805138
  803c04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c17:	a1 44 51 80 00       	mov    0x805144,%eax
  803c1c:	48                   	dec    %eax
  803c1d:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803c22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803c2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c2f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803c36:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c3a:	75 17                	jne    803c53 <insert_sorted_with_merge_freeList+0x432>
  803c3c:	83 ec 04             	sub    $0x4,%esp
  803c3f:	68 98 4b 80 00       	push   $0x804b98
  803c44:	68 5f 01 00 00       	push   $0x15f
  803c49:	68 bb 4b 80 00       	push   $0x804bbb
  803c4e:	e8 6f d2 ff ff       	call   800ec2 <_panic>
  803c53:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5c:	89 10                	mov    %edx,(%eax)
  803c5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c61:	8b 00                	mov    (%eax),%eax
  803c63:	85 c0                	test   %eax,%eax
  803c65:	74 0d                	je     803c74 <insert_sorted_with_merge_freeList+0x453>
  803c67:	a1 48 51 80 00       	mov    0x805148,%eax
  803c6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c6f:	89 50 04             	mov    %edx,0x4(%eax)
  803c72:	eb 08                	jmp    803c7c <insert_sorted_with_merge_freeList+0x45b>
  803c74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c77:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c7f:	a3 48 51 80 00       	mov    %eax,0x805148
  803c84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c8e:	a1 54 51 80 00       	mov    0x805154,%eax
  803c93:	40                   	inc    %eax
  803c94:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9c:	8b 50 0c             	mov    0xc(%eax),%edx
  803c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca2:	8b 40 0c             	mov    0xc(%eax),%eax
  803ca5:	01 c2                	add    %eax,%edx
  803ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803caa:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803cad:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cba:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803cc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cc5:	75 17                	jne    803cde <insert_sorted_with_merge_freeList+0x4bd>
  803cc7:	83 ec 04             	sub    $0x4,%esp
  803cca:	68 98 4b 80 00       	push   $0x804b98
  803ccf:	68 64 01 00 00       	push   $0x164
  803cd4:	68 bb 4b 80 00       	push   $0x804bbb
  803cd9:	e8 e4 d1 ff ff       	call   800ec2 <_panic>
  803cde:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce7:	89 10                	mov    %edx,(%eax)
  803ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  803cec:	8b 00                	mov    (%eax),%eax
  803cee:	85 c0                	test   %eax,%eax
  803cf0:	74 0d                	je     803cff <insert_sorted_with_merge_freeList+0x4de>
  803cf2:	a1 48 51 80 00       	mov    0x805148,%eax
  803cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  803cfa:	89 50 04             	mov    %edx,0x4(%eax)
  803cfd:	eb 08                	jmp    803d07 <insert_sorted_with_merge_freeList+0x4e6>
  803cff:	8b 45 08             	mov    0x8(%ebp),%eax
  803d02:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d07:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0a:	a3 48 51 80 00       	mov    %eax,0x805148
  803d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d19:	a1 54 51 80 00       	mov    0x805154,%eax
  803d1e:	40                   	inc    %eax
  803d1f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803d24:	e9 41 02 00 00       	jmp    803f6a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803d29:	8b 45 08             	mov    0x8(%ebp),%eax
  803d2c:	8b 50 08             	mov    0x8(%eax),%edx
  803d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d32:	8b 40 0c             	mov    0xc(%eax),%eax
  803d35:	01 c2                	add    %eax,%edx
  803d37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3a:	8b 40 08             	mov    0x8(%eax),%eax
  803d3d:	39 c2                	cmp    %eax,%edx
  803d3f:	0f 85 7c 01 00 00    	jne    803ec1 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803d45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d49:	74 06                	je     803d51 <insert_sorted_with_merge_freeList+0x530>
  803d4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d4f:	75 17                	jne    803d68 <insert_sorted_with_merge_freeList+0x547>
  803d51:	83 ec 04             	sub    $0x4,%esp
  803d54:	68 d4 4b 80 00       	push   $0x804bd4
  803d59:	68 69 01 00 00       	push   $0x169
  803d5e:	68 bb 4b 80 00       	push   $0x804bbb
  803d63:	e8 5a d1 ff ff       	call   800ec2 <_panic>
  803d68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d6b:	8b 50 04             	mov    0x4(%eax),%edx
  803d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d71:	89 50 04             	mov    %edx,0x4(%eax)
  803d74:	8b 45 08             	mov    0x8(%ebp),%eax
  803d77:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d7a:	89 10                	mov    %edx,(%eax)
  803d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d7f:	8b 40 04             	mov    0x4(%eax),%eax
  803d82:	85 c0                	test   %eax,%eax
  803d84:	74 0d                	je     803d93 <insert_sorted_with_merge_freeList+0x572>
  803d86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d89:	8b 40 04             	mov    0x4(%eax),%eax
  803d8c:	8b 55 08             	mov    0x8(%ebp),%edx
  803d8f:	89 10                	mov    %edx,(%eax)
  803d91:	eb 08                	jmp    803d9b <insert_sorted_with_merge_freeList+0x57a>
  803d93:	8b 45 08             	mov    0x8(%ebp),%eax
  803d96:	a3 38 51 80 00       	mov    %eax,0x805138
  803d9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  803da1:	89 50 04             	mov    %edx,0x4(%eax)
  803da4:	a1 44 51 80 00       	mov    0x805144,%eax
  803da9:	40                   	inc    %eax
  803daa:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803daf:	8b 45 08             	mov    0x8(%ebp),%eax
  803db2:	8b 50 0c             	mov    0xc(%eax),%edx
  803db5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803db8:	8b 40 0c             	mov    0xc(%eax),%eax
  803dbb:	01 c2                	add    %eax,%edx
  803dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc0:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803dc3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803dc7:	75 17                	jne    803de0 <insert_sorted_with_merge_freeList+0x5bf>
  803dc9:	83 ec 04             	sub    $0x4,%esp
  803dcc:	68 64 4c 80 00       	push   $0x804c64
  803dd1:	68 6b 01 00 00       	push   $0x16b
  803dd6:	68 bb 4b 80 00       	push   $0x804bbb
  803ddb:	e8 e2 d0 ff ff       	call   800ec2 <_panic>
  803de0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803de3:	8b 00                	mov    (%eax),%eax
  803de5:	85 c0                	test   %eax,%eax
  803de7:	74 10                	je     803df9 <insert_sorted_with_merge_freeList+0x5d8>
  803de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dec:	8b 00                	mov    (%eax),%eax
  803dee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803df1:	8b 52 04             	mov    0x4(%edx),%edx
  803df4:	89 50 04             	mov    %edx,0x4(%eax)
  803df7:	eb 0b                	jmp    803e04 <insert_sorted_with_merge_freeList+0x5e3>
  803df9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dfc:	8b 40 04             	mov    0x4(%eax),%eax
  803dff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803e04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e07:	8b 40 04             	mov    0x4(%eax),%eax
  803e0a:	85 c0                	test   %eax,%eax
  803e0c:	74 0f                	je     803e1d <insert_sorted_with_merge_freeList+0x5fc>
  803e0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e11:	8b 40 04             	mov    0x4(%eax),%eax
  803e14:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e17:	8b 12                	mov    (%edx),%edx
  803e19:	89 10                	mov    %edx,(%eax)
  803e1b:	eb 0a                	jmp    803e27 <insert_sorted_with_merge_freeList+0x606>
  803e1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e20:	8b 00                	mov    (%eax),%eax
  803e22:	a3 38 51 80 00       	mov    %eax,0x805138
  803e27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e3a:	a1 44 51 80 00       	mov    0x805144,%eax
  803e3f:	48                   	dec    %eax
  803e40:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803e45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e48:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803e4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e52:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803e59:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803e5d:	75 17                	jne    803e76 <insert_sorted_with_merge_freeList+0x655>
  803e5f:	83 ec 04             	sub    $0x4,%esp
  803e62:	68 98 4b 80 00       	push   $0x804b98
  803e67:	68 6e 01 00 00       	push   $0x16e
  803e6c:	68 bb 4b 80 00       	push   $0x804bbb
  803e71:	e8 4c d0 ff ff       	call   800ec2 <_panic>
  803e76:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803e7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e7f:	89 10                	mov    %edx,(%eax)
  803e81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e84:	8b 00                	mov    (%eax),%eax
  803e86:	85 c0                	test   %eax,%eax
  803e88:	74 0d                	je     803e97 <insert_sorted_with_merge_freeList+0x676>
  803e8a:	a1 48 51 80 00       	mov    0x805148,%eax
  803e8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e92:	89 50 04             	mov    %edx,0x4(%eax)
  803e95:	eb 08                	jmp    803e9f <insert_sorted_with_merge_freeList+0x67e>
  803e97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e9a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ea2:	a3 48 51 80 00       	mov    %eax,0x805148
  803ea7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eaa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eb1:	a1 54 51 80 00       	mov    0x805154,%eax
  803eb6:	40                   	inc    %eax
  803eb7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ebc:	e9 a9 00 00 00       	jmp    803f6a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803ec1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ec5:	74 06                	je     803ecd <insert_sorted_with_merge_freeList+0x6ac>
  803ec7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ecb:	75 17                	jne    803ee4 <insert_sorted_with_merge_freeList+0x6c3>
  803ecd:	83 ec 04             	sub    $0x4,%esp
  803ed0:	68 30 4c 80 00       	push   $0x804c30
  803ed5:	68 73 01 00 00       	push   $0x173
  803eda:	68 bb 4b 80 00       	push   $0x804bbb
  803edf:	e8 de cf ff ff       	call   800ec2 <_panic>
  803ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee7:	8b 10                	mov    (%eax),%edx
  803ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  803eec:	89 10                	mov    %edx,(%eax)
  803eee:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef1:	8b 00                	mov    (%eax),%eax
  803ef3:	85 c0                	test   %eax,%eax
  803ef5:	74 0b                	je     803f02 <insert_sorted_with_merge_freeList+0x6e1>
  803ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803efa:	8b 00                	mov    (%eax),%eax
  803efc:	8b 55 08             	mov    0x8(%ebp),%edx
  803eff:	89 50 04             	mov    %edx,0x4(%eax)
  803f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f05:	8b 55 08             	mov    0x8(%ebp),%edx
  803f08:	89 10                	mov    %edx,(%eax)
  803f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f10:	89 50 04             	mov    %edx,0x4(%eax)
  803f13:	8b 45 08             	mov    0x8(%ebp),%eax
  803f16:	8b 00                	mov    (%eax),%eax
  803f18:	85 c0                	test   %eax,%eax
  803f1a:	75 08                	jne    803f24 <insert_sorted_with_merge_freeList+0x703>
  803f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803f24:	a1 44 51 80 00       	mov    0x805144,%eax
  803f29:	40                   	inc    %eax
  803f2a:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803f2f:	eb 39                	jmp    803f6a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803f31:	a1 40 51 80 00       	mov    0x805140,%eax
  803f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f3d:	74 07                	je     803f46 <insert_sorted_with_merge_freeList+0x725>
  803f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f42:	8b 00                	mov    (%eax),%eax
  803f44:	eb 05                	jmp    803f4b <insert_sorted_with_merge_freeList+0x72a>
  803f46:	b8 00 00 00 00       	mov    $0x0,%eax
  803f4b:	a3 40 51 80 00       	mov    %eax,0x805140
  803f50:	a1 40 51 80 00       	mov    0x805140,%eax
  803f55:	85 c0                	test   %eax,%eax
  803f57:	0f 85 c7 fb ff ff    	jne    803b24 <insert_sorted_with_merge_freeList+0x303>
  803f5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f61:	0f 85 bd fb ff ff    	jne    803b24 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803f67:	eb 01                	jmp    803f6a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803f69:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803f6a:	90                   	nop
  803f6b:	c9                   	leave  
  803f6c:	c3                   	ret    
  803f6d:	66 90                	xchg   %ax,%ax
  803f6f:	90                   	nop

00803f70 <__udivdi3>:
  803f70:	55                   	push   %ebp
  803f71:	57                   	push   %edi
  803f72:	56                   	push   %esi
  803f73:	53                   	push   %ebx
  803f74:	83 ec 1c             	sub    $0x1c,%esp
  803f77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f87:	89 ca                	mov    %ecx,%edx
  803f89:	89 f8                	mov    %edi,%eax
  803f8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f8f:	85 f6                	test   %esi,%esi
  803f91:	75 2d                	jne    803fc0 <__udivdi3+0x50>
  803f93:	39 cf                	cmp    %ecx,%edi
  803f95:	77 65                	ja     803ffc <__udivdi3+0x8c>
  803f97:	89 fd                	mov    %edi,%ebp
  803f99:	85 ff                	test   %edi,%edi
  803f9b:	75 0b                	jne    803fa8 <__udivdi3+0x38>
  803f9d:	b8 01 00 00 00       	mov    $0x1,%eax
  803fa2:	31 d2                	xor    %edx,%edx
  803fa4:	f7 f7                	div    %edi
  803fa6:	89 c5                	mov    %eax,%ebp
  803fa8:	31 d2                	xor    %edx,%edx
  803faa:	89 c8                	mov    %ecx,%eax
  803fac:	f7 f5                	div    %ebp
  803fae:	89 c1                	mov    %eax,%ecx
  803fb0:	89 d8                	mov    %ebx,%eax
  803fb2:	f7 f5                	div    %ebp
  803fb4:	89 cf                	mov    %ecx,%edi
  803fb6:	89 fa                	mov    %edi,%edx
  803fb8:	83 c4 1c             	add    $0x1c,%esp
  803fbb:	5b                   	pop    %ebx
  803fbc:	5e                   	pop    %esi
  803fbd:	5f                   	pop    %edi
  803fbe:	5d                   	pop    %ebp
  803fbf:	c3                   	ret    
  803fc0:	39 ce                	cmp    %ecx,%esi
  803fc2:	77 28                	ja     803fec <__udivdi3+0x7c>
  803fc4:	0f bd fe             	bsr    %esi,%edi
  803fc7:	83 f7 1f             	xor    $0x1f,%edi
  803fca:	75 40                	jne    80400c <__udivdi3+0x9c>
  803fcc:	39 ce                	cmp    %ecx,%esi
  803fce:	72 0a                	jb     803fda <__udivdi3+0x6a>
  803fd0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fd4:	0f 87 9e 00 00 00    	ja     804078 <__udivdi3+0x108>
  803fda:	b8 01 00 00 00       	mov    $0x1,%eax
  803fdf:	89 fa                	mov    %edi,%edx
  803fe1:	83 c4 1c             	add    $0x1c,%esp
  803fe4:	5b                   	pop    %ebx
  803fe5:	5e                   	pop    %esi
  803fe6:	5f                   	pop    %edi
  803fe7:	5d                   	pop    %ebp
  803fe8:	c3                   	ret    
  803fe9:	8d 76 00             	lea    0x0(%esi),%esi
  803fec:	31 ff                	xor    %edi,%edi
  803fee:	31 c0                	xor    %eax,%eax
  803ff0:	89 fa                	mov    %edi,%edx
  803ff2:	83 c4 1c             	add    $0x1c,%esp
  803ff5:	5b                   	pop    %ebx
  803ff6:	5e                   	pop    %esi
  803ff7:	5f                   	pop    %edi
  803ff8:	5d                   	pop    %ebp
  803ff9:	c3                   	ret    
  803ffa:	66 90                	xchg   %ax,%ax
  803ffc:	89 d8                	mov    %ebx,%eax
  803ffe:	f7 f7                	div    %edi
  804000:	31 ff                	xor    %edi,%edi
  804002:	89 fa                	mov    %edi,%edx
  804004:	83 c4 1c             	add    $0x1c,%esp
  804007:	5b                   	pop    %ebx
  804008:	5e                   	pop    %esi
  804009:	5f                   	pop    %edi
  80400a:	5d                   	pop    %ebp
  80400b:	c3                   	ret    
  80400c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804011:	89 eb                	mov    %ebp,%ebx
  804013:	29 fb                	sub    %edi,%ebx
  804015:	89 f9                	mov    %edi,%ecx
  804017:	d3 e6                	shl    %cl,%esi
  804019:	89 c5                	mov    %eax,%ebp
  80401b:	88 d9                	mov    %bl,%cl
  80401d:	d3 ed                	shr    %cl,%ebp
  80401f:	89 e9                	mov    %ebp,%ecx
  804021:	09 f1                	or     %esi,%ecx
  804023:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804027:	89 f9                	mov    %edi,%ecx
  804029:	d3 e0                	shl    %cl,%eax
  80402b:	89 c5                	mov    %eax,%ebp
  80402d:	89 d6                	mov    %edx,%esi
  80402f:	88 d9                	mov    %bl,%cl
  804031:	d3 ee                	shr    %cl,%esi
  804033:	89 f9                	mov    %edi,%ecx
  804035:	d3 e2                	shl    %cl,%edx
  804037:	8b 44 24 08          	mov    0x8(%esp),%eax
  80403b:	88 d9                	mov    %bl,%cl
  80403d:	d3 e8                	shr    %cl,%eax
  80403f:	09 c2                	or     %eax,%edx
  804041:	89 d0                	mov    %edx,%eax
  804043:	89 f2                	mov    %esi,%edx
  804045:	f7 74 24 0c          	divl   0xc(%esp)
  804049:	89 d6                	mov    %edx,%esi
  80404b:	89 c3                	mov    %eax,%ebx
  80404d:	f7 e5                	mul    %ebp
  80404f:	39 d6                	cmp    %edx,%esi
  804051:	72 19                	jb     80406c <__udivdi3+0xfc>
  804053:	74 0b                	je     804060 <__udivdi3+0xf0>
  804055:	89 d8                	mov    %ebx,%eax
  804057:	31 ff                	xor    %edi,%edi
  804059:	e9 58 ff ff ff       	jmp    803fb6 <__udivdi3+0x46>
  80405e:	66 90                	xchg   %ax,%ax
  804060:	8b 54 24 08          	mov    0x8(%esp),%edx
  804064:	89 f9                	mov    %edi,%ecx
  804066:	d3 e2                	shl    %cl,%edx
  804068:	39 c2                	cmp    %eax,%edx
  80406a:	73 e9                	jae    804055 <__udivdi3+0xe5>
  80406c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80406f:	31 ff                	xor    %edi,%edi
  804071:	e9 40 ff ff ff       	jmp    803fb6 <__udivdi3+0x46>
  804076:	66 90                	xchg   %ax,%ax
  804078:	31 c0                	xor    %eax,%eax
  80407a:	e9 37 ff ff ff       	jmp    803fb6 <__udivdi3+0x46>
  80407f:	90                   	nop

00804080 <__umoddi3>:
  804080:	55                   	push   %ebp
  804081:	57                   	push   %edi
  804082:	56                   	push   %esi
  804083:	53                   	push   %ebx
  804084:	83 ec 1c             	sub    $0x1c,%esp
  804087:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80408b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80408f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804093:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804097:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80409b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80409f:	89 f3                	mov    %esi,%ebx
  8040a1:	89 fa                	mov    %edi,%edx
  8040a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040a7:	89 34 24             	mov    %esi,(%esp)
  8040aa:	85 c0                	test   %eax,%eax
  8040ac:	75 1a                	jne    8040c8 <__umoddi3+0x48>
  8040ae:	39 f7                	cmp    %esi,%edi
  8040b0:	0f 86 a2 00 00 00    	jbe    804158 <__umoddi3+0xd8>
  8040b6:	89 c8                	mov    %ecx,%eax
  8040b8:	89 f2                	mov    %esi,%edx
  8040ba:	f7 f7                	div    %edi
  8040bc:	89 d0                	mov    %edx,%eax
  8040be:	31 d2                	xor    %edx,%edx
  8040c0:	83 c4 1c             	add    $0x1c,%esp
  8040c3:	5b                   	pop    %ebx
  8040c4:	5e                   	pop    %esi
  8040c5:	5f                   	pop    %edi
  8040c6:	5d                   	pop    %ebp
  8040c7:	c3                   	ret    
  8040c8:	39 f0                	cmp    %esi,%eax
  8040ca:	0f 87 ac 00 00 00    	ja     80417c <__umoddi3+0xfc>
  8040d0:	0f bd e8             	bsr    %eax,%ebp
  8040d3:	83 f5 1f             	xor    $0x1f,%ebp
  8040d6:	0f 84 ac 00 00 00    	je     804188 <__umoddi3+0x108>
  8040dc:	bf 20 00 00 00       	mov    $0x20,%edi
  8040e1:	29 ef                	sub    %ebp,%edi
  8040e3:	89 fe                	mov    %edi,%esi
  8040e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040e9:	89 e9                	mov    %ebp,%ecx
  8040eb:	d3 e0                	shl    %cl,%eax
  8040ed:	89 d7                	mov    %edx,%edi
  8040ef:	89 f1                	mov    %esi,%ecx
  8040f1:	d3 ef                	shr    %cl,%edi
  8040f3:	09 c7                	or     %eax,%edi
  8040f5:	89 e9                	mov    %ebp,%ecx
  8040f7:	d3 e2                	shl    %cl,%edx
  8040f9:	89 14 24             	mov    %edx,(%esp)
  8040fc:	89 d8                	mov    %ebx,%eax
  8040fe:	d3 e0                	shl    %cl,%eax
  804100:	89 c2                	mov    %eax,%edx
  804102:	8b 44 24 08          	mov    0x8(%esp),%eax
  804106:	d3 e0                	shl    %cl,%eax
  804108:	89 44 24 04          	mov    %eax,0x4(%esp)
  80410c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804110:	89 f1                	mov    %esi,%ecx
  804112:	d3 e8                	shr    %cl,%eax
  804114:	09 d0                	or     %edx,%eax
  804116:	d3 eb                	shr    %cl,%ebx
  804118:	89 da                	mov    %ebx,%edx
  80411a:	f7 f7                	div    %edi
  80411c:	89 d3                	mov    %edx,%ebx
  80411e:	f7 24 24             	mull   (%esp)
  804121:	89 c6                	mov    %eax,%esi
  804123:	89 d1                	mov    %edx,%ecx
  804125:	39 d3                	cmp    %edx,%ebx
  804127:	0f 82 87 00 00 00    	jb     8041b4 <__umoddi3+0x134>
  80412d:	0f 84 91 00 00 00    	je     8041c4 <__umoddi3+0x144>
  804133:	8b 54 24 04          	mov    0x4(%esp),%edx
  804137:	29 f2                	sub    %esi,%edx
  804139:	19 cb                	sbb    %ecx,%ebx
  80413b:	89 d8                	mov    %ebx,%eax
  80413d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804141:	d3 e0                	shl    %cl,%eax
  804143:	89 e9                	mov    %ebp,%ecx
  804145:	d3 ea                	shr    %cl,%edx
  804147:	09 d0                	or     %edx,%eax
  804149:	89 e9                	mov    %ebp,%ecx
  80414b:	d3 eb                	shr    %cl,%ebx
  80414d:	89 da                	mov    %ebx,%edx
  80414f:	83 c4 1c             	add    $0x1c,%esp
  804152:	5b                   	pop    %ebx
  804153:	5e                   	pop    %esi
  804154:	5f                   	pop    %edi
  804155:	5d                   	pop    %ebp
  804156:	c3                   	ret    
  804157:	90                   	nop
  804158:	89 fd                	mov    %edi,%ebp
  80415a:	85 ff                	test   %edi,%edi
  80415c:	75 0b                	jne    804169 <__umoddi3+0xe9>
  80415e:	b8 01 00 00 00       	mov    $0x1,%eax
  804163:	31 d2                	xor    %edx,%edx
  804165:	f7 f7                	div    %edi
  804167:	89 c5                	mov    %eax,%ebp
  804169:	89 f0                	mov    %esi,%eax
  80416b:	31 d2                	xor    %edx,%edx
  80416d:	f7 f5                	div    %ebp
  80416f:	89 c8                	mov    %ecx,%eax
  804171:	f7 f5                	div    %ebp
  804173:	89 d0                	mov    %edx,%eax
  804175:	e9 44 ff ff ff       	jmp    8040be <__umoddi3+0x3e>
  80417a:	66 90                	xchg   %ax,%ax
  80417c:	89 c8                	mov    %ecx,%eax
  80417e:	89 f2                	mov    %esi,%edx
  804180:	83 c4 1c             	add    $0x1c,%esp
  804183:	5b                   	pop    %ebx
  804184:	5e                   	pop    %esi
  804185:	5f                   	pop    %edi
  804186:	5d                   	pop    %ebp
  804187:	c3                   	ret    
  804188:	3b 04 24             	cmp    (%esp),%eax
  80418b:	72 06                	jb     804193 <__umoddi3+0x113>
  80418d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804191:	77 0f                	ja     8041a2 <__umoddi3+0x122>
  804193:	89 f2                	mov    %esi,%edx
  804195:	29 f9                	sub    %edi,%ecx
  804197:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80419b:	89 14 24             	mov    %edx,(%esp)
  80419e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041a2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041a6:	8b 14 24             	mov    (%esp),%edx
  8041a9:	83 c4 1c             	add    $0x1c,%esp
  8041ac:	5b                   	pop    %ebx
  8041ad:	5e                   	pop    %esi
  8041ae:	5f                   	pop    %edi
  8041af:	5d                   	pop    %ebp
  8041b0:	c3                   	ret    
  8041b1:	8d 76 00             	lea    0x0(%esi),%esi
  8041b4:	2b 04 24             	sub    (%esp),%eax
  8041b7:	19 fa                	sbb    %edi,%edx
  8041b9:	89 d1                	mov    %edx,%ecx
  8041bb:	89 c6                	mov    %eax,%esi
  8041bd:	e9 71 ff ff ff       	jmp    804133 <__umoddi3+0xb3>
  8041c2:	66 90                	xchg   %ax,%ax
  8041c4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041c8:	72 ea                	jb     8041b4 <__umoddi3+0x134>
  8041ca:	89 d9                	mov    %ebx,%ecx
  8041cc:	e9 62 ff ff ff       	jmp    804133 <__umoddi3+0xb3>
