
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
  800045:	e8 51 28 00 00       	call   80289b <sys_set_uheap_strategy>
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
  80009b:	68 c0 41 80 00       	push   $0x8041c0
  8000a0:	6a 16                	push   $0x16
  8000a2:	68 dc 41 80 00       	push   $0x8041dc
  8000a7:	e8 16 0e 00 00       	call   800ec2 <_panic>
	}

	int envID = sys_getenvid();
  8000ac:	e8 9c 25 00 00       	call   80264d <sys_getenvid>
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
  8000e0:	e8 a1 22 00 00       	call   802386 <sys_calculate_free_frames>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e8:	e8 39 23 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	6a 01                	push   $0x1
  8000f8:	50                   	push   %eax
  8000f9:	68 f3 41 80 00       	push   $0x8041f3
  8000fe:	e8 43 20 00 00       	call   802146 <smalloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if (ptr_allocations[0] != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800109:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80010c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800111:	74 14                	je     800127 <_main+0xef>
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 f8 41 80 00       	push   $0x8041f8
  80011b:	6a 2a                	push   $0x2a
  80011d:	68 dc 41 80 00       	push   $0x8041dc
  800122:	e8 9b 0d 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  256+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800127:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80012a:	e8 57 22 00 00       	call   802386 <sys_calculate_free_frames>
  80012f:	29 c3                	sub    %eax,%ebx
  800131:	89 d8                	mov    %ebx,%eax
  800133:	3d 03 01 00 00       	cmp    $0x103,%eax
  800138:	74 14                	je     80014e <_main+0x116>
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	68 64 42 80 00       	push   $0x804264
  800142:	6a 2b                	push   $0x2b
  800144:	68 dc 41 80 00       	push   $0x8041dc
  800149:	e8 74 0d 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014e:	e8 d3 22 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800153:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 e2 42 80 00       	push   $0x8042e2
  800160:	6a 2c                	push   $0x2c
  800162:	68 dc 41 80 00       	push   $0x8041dc
  800167:	e8 56 0d 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80016c:	e8 15 22 00 00       	call   802386 <sys_calculate_free_frames>
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800174:	e8 ad 22 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
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
  8001a5:	68 00 43 80 00       	push   $0x804300
  8001aa:	6a 32                	push   $0x32
  8001ac:	68 dc 41 80 00       	push   $0x8041dc
  8001b1:	e8 0c 0d 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b6:	e8 6b 22 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  8001bb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 e2 42 80 00       	push   $0x8042e2
  8001c8:	6a 34                	push   $0x34
  8001ca:	68 dc 41 80 00       	push   $0x8041dc
  8001cf:	e8 ee 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001d4:	e8 ad 21 00 00       	call   802386 <sys_calculate_free_frames>
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001de:	39 c2                	cmp    %eax,%edx
  8001e0:	74 14                	je     8001f6 <_main+0x1be>
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	68 30 43 80 00       	push   $0x804330
  8001ea:	6a 35                	push   $0x35
  8001ec:	68 dc 41 80 00       	push   $0x8041dc
  8001f1:	e8 cc 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f6:	e8 8b 21 00 00       	call   802386 <sys_calculate_free_frames>
  8001fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fe:	e8 23 22 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
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
  800231:	68 00 43 80 00       	push   $0x804300
  800236:	6a 3b                	push   $0x3b
  800238:	68 dc 41 80 00       	push   $0x8041dc
  80023d:	e8 80 0c 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800242:	e8 df 21 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800247:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80024a:	74 14                	je     800260 <_main+0x228>
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	68 e2 42 80 00       	push   $0x8042e2
  800254:	6a 3d                	push   $0x3d
  800256:	68 dc 41 80 00       	push   $0x8041dc
  80025b:	e8 62 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800260:	e8 21 21 00 00       	call   802386 <sys_calculate_free_frames>
  800265:	89 c2                	mov    %eax,%edx
  800267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026a:	39 c2                	cmp    %eax,%edx
  80026c:	74 14                	je     800282 <_main+0x24a>
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	68 30 43 80 00       	push   $0x804330
  800276:	6a 3e                	push   $0x3e
  800278:	68 dc 41 80 00       	push   $0x8041dc
  80027d:	e8 40 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800282:	e8 ff 20 00 00       	call   802386 <sys_calculate_free_frames>
  800287:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80028a:	e8 97 21 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
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
  8002c1:	68 00 43 80 00       	push   $0x804300
  8002c6:	6a 44                	push   $0x44
  8002c8:	68 dc 41 80 00       	push   $0x8041dc
  8002cd:	e8 f0 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002d2:	e8 4f 21 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  8002d7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 e2 42 80 00       	push   $0x8042e2
  8002e4:	6a 46                	push   $0x46
  8002e6:	68 dc 41 80 00       	push   $0x8041dc
  8002eb:	e8 d2 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002f0:	e8 91 20 00 00       	call   802386 <sys_calculate_free_frames>
  8002f5:	89 c2                	mov    %eax,%edx
  8002f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 30 43 80 00       	push   $0x804330
  800306:	6a 47                	push   $0x47
  800308:	68 dc 41 80 00       	push   $0x8041dc
  80030d:	e8 b0 0b 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800312:	e8 6f 20 00 00       	call   802386 <sys_calculate_free_frames>
  800317:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80031a:	e8 07 21 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
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
  800350:	68 00 43 80 00       	push   $0x804300
  800355:	6a 4d                	push   $0x4d
  800357:	68 dc 41 80 00       	push   $0x8041dc
  80035c:	e8 61 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800361:	e8 c0 20 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800366:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800369:	74 14                	je     80037f <_main+0x347>
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	68 e2 42 80 00       	push   $0x8042e2
  800373:	6a 4f                	push   $0x4f
  800375:	68 dc 41 80 00       	push   $0x8041dc
  80037a:	e8 43 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80037f:	e8 02 20 00 00       	call   802386 <sys_calculate_free_frames>
  800384:	89 c2                	mov    %eax,%edx
  800386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	74 14                	je     8003a1 <_main+0x369>
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	68 30 43 80 00       	push   $0x804330
  800395:	6a 50                	push   $0x50
  800397:	68 dc 41 80 00       	push   $0x8041dc
  80039c:	e8 21 0b 00 00       	call   800ec2 <_panic>

		//Allocate Shared 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003a1:	e8 e0 1f 00 00       	call   802386 <sys_calculate_free_frames>
  8003a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a9:	e8 78 20 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  8003ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  8003b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b4:	01 c0                	add    %eax,%eax
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	50                   	push   %eax
  8003bc:	68 43 43 80 00       	push   $0x804343
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
  8003e6:	68 f8 41 80 00       	push   $0x8041f8
  8003eb:	6a 56                	push   $0x56
  8003ed:	68 dc 41 80 00       	push   $0x8041dc
  8003f2:	e8 cb 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  512+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8003f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003fa:	e8 87 1f 00 00       	call   802386 <sys_calculate_free_frames>
  8003ff:	29 c3                	sub    %eax,%ebx
  800401:	89 d8                	mov    %ebx,%eax
  800403:	3d 03 02 00 00       	cmp    $0x203,%eax
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 64 42 80 00       	push   $0x804264
  800412:	6a 57                	push   $0x57
  800414:	68 dc 41 80 00       	push   $0x8041dc
  800419:	e8 a4 0a 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80041e:	e8 03 20 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800423:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800426:	74 14                	je     80043c <_main+0x404>
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	68 e2 42 80 00       	push   $0x8042e2
  800430:	6a 58                	push   $0x58
  800432:	68 dc 41 80 00       	push   $0x8041dc
  800437:	e8 86 0a 00 00       	call   800ec2 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80043c:	e8 45 1f 00 00       	call   802386 <sys_calculate_free_frames>
  800441:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800444:	e8 dd 1f 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
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
  80047e:	68 00 43 80 00       	push   $0x804300
  800483:	6a 5e                	push   $0x5e
  800485:	68 dc 41 80 00       	push   $0x8041dc
  80048a:	e8 33 0a 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80048f:	e8 92 1f 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800494:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800497:	74 14                	je     8004ad <_main+0x475>
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 e2 42 80 00       	push   $0x8042e2
  8004a1:	6a 60                	push   $0x60
  8004a3:	68 dc 41 80 00       	push   $0x8041dc
  8004a8:	e8 15 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8004ad:	e8 d4 1e 00 00       	call   802386 <sys_calculate_free_frames>
  8004b2:	89 c2                	mov    %eax,%edx
  8004b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b7:	39 c2                	cmp    %eax,%edx
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 30 43 80 00       	push   $0x804330
  8004c3:	6a 61                	push   $0x61
  8004c5:	68 dc 41 80 00       	push   $0x8041dc
  8004ca:	e8 f3 09 00 00       	call   800ec2 <_panic>

		//Allocate Shared 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004cf:	e8 b2 1e 00 00       	call   802386 <sys_calculate_free_frames>
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004d7:	e8 4a 1f 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  8004dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8004df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	01 d2                	add    %edx,%edx
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	6a 00                	push   $0x0
  8004ed:	50                   	push   %eax
  8004ee:	68 45 43 80 00       	push   $0x804345
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
  80051b:	68 f8 41 80 00       	push   $0x8041f8
  800520:	6a 67                	push   $0x67
  800522:	68 dc 41 80 00       	push   $0x8041dc
  800527:	e8 96 09 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80052c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052f:	e8 52 1e 00 00       	call   802386 <sys_calculate_free_frames>
  800534:	29 c3                	sub    %eax,%ebx
  800536:	89 d8                	mov    %ebx,%eax
  800538:	3d 04 03 00 00       	cmp    $0x304,%eax
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 64 42 80 00       	push   $0x804264
  800547:	6a 68                	push   $0x68
  800549:	68 dc 41 80 00       	push   $0x8041dc
  80054e:	e8 6f 09 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800553:	e8 ce 1e 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800558:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 e2 42 80 00       	push   $0x8042e2
  800565:	6a 69                	push   $0x69
  800567:	68 dc 41 80 00       	push   $0x8041dc
  80056c:	e8 51 09 00 00       	call   800ec2 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800571:	e8 10 1e 00 00       	call   802386 <sys_calculate_free_frames>
  800576:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800579:	e8 a8 1e 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  80057e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800581:	8b 45 90             	mov    -0x70(%ebp),%eax
  800584:	83 ec 0c             	sub    $0xc,%esp
  800587:	50                   	push   %eax
  800588:	e8 9f 1b 00 00       	call   80212c <free>
  80058d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800590:	e8 91 1e 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800595:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800598:	74 14                	je     8005ae <_main+0x576>
  80059a:	83 ec 04             	sub    $0x4,%esp
  80059d:	68 47 43 80 00       	push   $0x804347
  8005a2:	6a 73                	push   $0x73
  8005a4:	68 dc 41 80 00       	push   $0x8041dc
  8005a9:	e8 14 09 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ae:	e8 d3 1d 00 00       	call   802386 <sys_calculate_free_frames>
  8005b3:	89 c2                	mov    %eax,%edx
  8005b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b8:	39 c2                	cmp    %eax,%edx
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 5e 43 80 00       	push   $0x80435e
  8005c4:	6a 74                	push   $0x74
  8005c6:	68 dc 41 80 00       	push   $0x8041dc
  8005cb:	e8 f2 08 00 00       	call   800ec2 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d0:	e8 b1 1d 00 00       	call   802386 <sys_calculate_free_frames>
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005d8:	e8 49 1e 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8005e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	50                   	push   %eax
  8005e7:	e8 40 1b 00 00       	call   80212c <free>
  8005ec:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005ef:	e8 32 1e 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 14                	je     80060d <_main+0x5d5>
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 47 43 80 00       	push   $0x804347
  800601:	6a 7b                	push   $0x7b
  800603:	68 dc 41 80 00       	push   $0x8041dc
  800608:	e8 b5 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80060d:	e8 74 1d 00 00       	call   802386 <sys_calculate_free_frames>
  800612:	89 c2                	mov    %eax,%edx
  800614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800617:	39 c2                	cmp    %eax,%edx
  800619:	74 14                	je     80062f <_main+0x5f7>
  80061b:	83 ec 04             	sub    $0x4,%esp
  80061e:	68 5e 43 80 00       	push   $0x80435e
  800623:	6a 7c                	push   $0x7c
  800625:	68 dc 41 80 00       	push   $0x8041dc
  80062a:	e8 93 08 00 00       	call   800ec2 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80062f:	e8 52 1d 00 00       	call   802386 <sys_calculate_free_frames>
  800634:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800637:	e8 ea 1d 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  80063c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80063f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	50                   	push   %eax
  800646:	e8 e1 1a 00 00       	call   80212c <free>
  80064b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80064e:	e8 d3 1d 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800653:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800656:	74 17                	je     80066f <_main+0x637>
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	68 47 43 80 00       	push   $0x804347
  800660:	68 83 00 00 00       	push   $0x83
  800665:	68 dc 41 80 00       	push   $0x8041dc
  80066a:	e8 53 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80066f:	e8 12 1d 00 00       	call   802386 <sys_calculate_free_frames>
  800674:	89 c2                	mov    %eax,%edx
  800676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800679:	39 c2                	cmp    %eax,%edx
  80067b:	74 17                	je     800694 <_main+0x65c>
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	68 5e 43 80 00       	push   $0x80435e
  800685:	68 84 00 00 00       	push   $0x84
  80068a:	68 dc 41 80 00       	push   $0x8041dc
  80068f:	e8 2e 08 00 00       	call   800ec2 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800694:	e8 ed 1c 00 00       	call   802386 <sys_calculate_free_frames>
  800699:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069c:	e8 85 1d 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
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
  8006d1:	68 00 43 80 00       	push   $0x804300
  8006d6:	68 8d 00 00 00       	push   $0x8d
  8006db:	68 dc 41 80 00       	push   $0x8041dc
  8006e0:	e8 dd 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006e5:	e8 3c 1d 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  8006ea:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006ed:	74 17                	je     800706 <_main+0x6ce>
  8006ef:	83 ec 04             	sub    $0x4,%esp
  8006f2:	68 e2 42 80 00       	push   $0x8042e2
  8006f7:	68 8f 00 00 00       	push   $0x8f
  8006fc:	68 dc 41 80 00       	push   $0x8041dc
  800701:	e8 bc 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800706:	e8 7b 1c 00 00       	call   802386 <sys_calculate_free_frames>
  80070b:	89 c2                	mov    %eax,%edx
  80070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800710:	39 c2                	cmp    %eax,%edx
  800712:	74 17                	je     80072b <_main+0x6f3>
  800714:	83 ec 04             	sub    $0x4,%esp
  800717:	68 30 43 80 00       	push   $0x804330
  80071c:	68 90 00 00 00       	push   $0x90
  800721:	68 dc 41 80 00       	push   $0x8041dc
  800726:	e8 97 07 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80072b:	e8 56 1c 00 00       	call   802386 <sys_calculate_free_frames>
  800730:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800733:	e8 ee 1c 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
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
  800767:	68 00 43 80 00       	push   $0x804300
  80076c:	68 96 00 00 00       	push   $0x96
  800771:	68 dc 41 80 00       	push   $0x8041dc
  800776:	e8 47 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80077b:	e8 a6 1c 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800780:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800783:	74 17                	je     80079c <_main+0x764>
  800785:	83 ec 04             	sub    $0x4,%esp
  800788:	68 e2 42 80 00       	push   $0x8042e2
  80078d:	68 98 00 00 00       	push   $0x98
  800792:	68 dc 41 80 00       	push   $0x8041dc
  800797:	e8 26 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80079c:	e8 e5 1b 00 00       	call   802386 <sys_calculate_free_frames>
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a6:	39 c2                	cmp    %eax,%edx
  8007a8:	74 17                	je     8007c1 <_main+0x789>
  8007aa:	83 ec 04             	sub    $0x4,%esp
  8007ad:	68 30 43 80 00       	push   $0x804330
  8007b2:	68 99 00 00 00       	push   $0x99
  8007b7:	68 dc 41 80 00       	push   $0x8041dc
  8007bc:	e8 01 07 00 00       	call   800ec2 <_panic>

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007c1:	e8 c0 1b 00 00       	call   802386 <sys_calculate_free_frames>
  8007c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007c9:	e8 58 1c 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
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
  8007e1:	68 6b 43 80 00       	push   $0x80436b
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
  80080f:	68 00 43 80 00       	push   $0x804300
  800814:	68 a0 00 00 00       	push   $0xa0
  800819:	68 dc 41 80 00       	push   $0x8041dc
  80081e:	e8 9f 06 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800823:	e8 fe 1b 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800828:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80082b:	74 17                	je     800844 <_main+0x80c>
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	68 e2 42 80 00       	push   $0x8042e2
  800835:	68 a1 00 00 00       	push   $0xa1
  80083a:	68 dc 41 80 00       	push   $0x8041dc
  80083f:	e8 7e 06 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 64+0+2) panic("Wrong allocation: %d", (freeFrames - sys_calculate_free_frames()));
  800844:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800847:	e8 3a 1b 00 00       	call   802386 <sys_calculate_free_frames>
  80084c:	29 c3                	sub    %eax,%ebx
  80084e:	89 d8                	mov    %ebx,%eax
  800850:	83 f8 42             	cmp    $0x42,%eax
  800853:	74 21                	je     800876 <_main+0x83e>
  800855:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800858:	e8 29 1b 00 00       	call   802386 <sys_calculate_free_frames>
  80085d:	29 c3                	sub    %eax,%ebx
  80085f:	89 d8                	mov    %ebx,%eax
  800861:	50                   	push   %eax
  800862:	68 6d 43 80 00       	push   $0x80436d
  800867:	68 a2 00 00 00       	push   $0xa2
  80086c:	68 dc 41 80 00       	push   $0x8041dc
  800871:	e8 4c 06 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800876:	e8 0b 1b 00 00       	call   802386 <sys_calculate_free_frames>
  80087b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80087e:	e8 a3 1b 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
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
  8008b1:	68 00 43 80 00       	push   $0x804300
  8008b6:	68 a8 00 00 00       	push   $0xa8
  8008bb:	68 dc 41 80 00       	push   $0x8041dc
  8008c0:	e8 fd 05 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8008c5:	e8 5c 1b 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  8008ca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 e2 42 80 00       	push   $0x8042e2
  8008d7:	68 aa 00 00 00       	push   $0xaa
  8008dc:	68 dc 41 80 00       	push   $0x8041dc
  8008e1:	e8 dc 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008e6:	e8 9b 1a 00 00       	call   802386 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 30 43 80 00       	push   $0x804330
  8008fc:	68 ab 00 00 00       	push   $0xab
  800901:	68 dc 41 80 00       	push   $0x8041dc
  800906:	e8 b7 05 00 00       	call   800ec2 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  80090b:	e8 76 1a 00 00       	call   802386 <sys_calculate_free_frames>
  800910:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800913:	e8 0e 1b 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800918:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  80091b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091e:	c1 e0 02             	shl    $0x2,%eax
  800921:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	6a 00                	push   $0x0
  800929:	50                   	push   %eax
  80092a:	68 82 43 80 00       	push   $0x804382
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
  80095a:	68 00 43 80 00       	push   $0x804300
  80095f:	68 b2 00 00 00       	push   $0xb2
  800964:	68 dc 41 80 00       	push   $0x8041dc
  800969:	e8 54 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1024+1+2) panic("Wrong allocation: ");
  80096e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800971:	e8 10 1a 00 00       	call   802386 <sys_calculate_free_frames>
  800976:	29 c3                	sub    %eax,%ebx
  800978:	89 d8                	mov    %ebx,%eax
  80097a:	3d 03 04 00 00       	cmp    $0x403,%eax
  80097f:	74 17                	je     800998 <_main+0x960>
  800981:	83 ec 04             	sub    $0x4,%esp
  800984:	68 30 43 80 00       	push   $0x804330
  800989:	68 b3 00 00 00       	push   $0xb3
  80098e:	68 dc 41 80 00       	push   $0x8041dc
  800993:	e8 2a 05 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800998:	e8 89 1a 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 e2 42 80 00       	push   $0x8042e2
  8009aa:	68 b4 00 00 00       	push   $0xb4
  8009af:	68 dc 41 80 00       	push   $0x8041dc
  8009b4:	e8 09 05 00 00       	call   800ec2 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009b9:	e8 c8 19 00 00       	call   802386 <sys_calculate_free_frames>
  8009be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009c1:	e8 60 1a 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  8009c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  8009c9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8009cc:	83 ec 0c             	sub    $0xc,%esp
  8009cf:	50                   	push   %eax
  8009d0:	e8 57 17 00 00       	call   80212c <free>
  8009d5:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009d8:	e8 49 1a 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  8009dd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009e0:	74 17                	je     8009f9 <_main+0x9c1>
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	68 47 43 80 00       	push   $0x804347
  8009ea:	68 bf 00 00 00       	push   $0xbf
  8009ef:	68 dc 41 80 00       	push   $0x8041dc
  8009f4:	e8 c9 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009f9:	e8 88 19 00 00       	call   802386 <sys_calculate_free_frames>
  8009fe:	89 c2                	mov    %eax,%edx
  800a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a03:	39 c2                	cmp    %eax,%edx
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 5e 43 80 00       	push   $0x80435e
  800a0f:	68 c0 00 00 00       	push   $0xc0
  800a14:	68 dc 41 80 00       	push   $0x8041dc
  800a19:	e8 a4 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a1e:	e8 63 19 00 00       	call   802386 <sys_calculate_free_frames>
  800a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a26:	e8 fb 19 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  800a2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a31:	83 ec 0c             	sub    $0xc,%esp
  800a34:	50                   	push   %eax
  800a35:	e8 f2 16 00 00       	call   80212c <free>
  800a3a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a3d:	e8 e4 19 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800a42:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a45:	74 17                	je     800a5e <_main+0xa26>
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	68 47 43 80 00       	push   $0x804347
  800a4f:	68 c7 00 00 00       	push   $0xc7
  800a54:	68 dc 41 80 00       	push   $0x8041dc
  800a59:	e8 64 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a5e:	e8 23 19 00 00       	call   802386 <sys_calculate_free_frames>
  800a63:	89 c2                	mov    %eax,%edx
  800a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a68:	39 c2                	cmp    %eax,%edx
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 5e 43 80 00       	push   $0x80435e
  800a74:	68 c8 00 00 00       	push   $0xc8
  800a79:	68 dc 41 80 00       	push   $0x8041dc
  800a7e:	e8 3f 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 fe 18 00 00       	call   802386 <sys_calculate_free_frames>
  800a88:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 96 19 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800a90:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800a93:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 8d 16 00 00       	call   80212c <free>
  800a9f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800aa2:	e8 7f 19 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800aa7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800aaa:	74 17                	je     800ac3 <_main+0xa8b>
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	68 47 43 80 00       	push   $0x804347
  800ab4:	68 cf 00 00 00       	push   $0xcf
  800ab9:	68 dc 41 80 00       	push   $0x8041dc
  800abe:	e8 ff 03 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800ac3:	e8 be 18 00 00       	call   802386 <sys_calculate_free_frames>
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	39 c2                	cmp    %eax,%edx
  800acf:	74 17                	je     800ae8 <_main+0xab0>
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	68 5e 43 80 00       	push   $0x80435e
  800ad9:	68 d0 00 00 00       	push   $0xd0
  800ade:	68 dc 41 80 00       	push   $0x8041dc
  800ae3:	e8 da 03 00 00       	call   800ec2 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800ae8:	e8 99 18 00 00       	call   802386 <sys_calculate_free_frames>
  800aed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800af0:	e8 31 19 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
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
  800b3b:	68 00 43 80 00       	push   $0x804300
  800b40:	68 da 00 00 00       	push   $0xda
  800b45:	68 dc 41 80 00       	push   $0x8041dc
  800b4a:	e8 73 03 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b4f:	e8 d2 18 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800b54:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800b57:	74 17                	je     800b70 <_main+0xb38>
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	68 e2 42 80 00       	push   $0x8042e2
  800b61:	68 dc 00 00 00       	push   $0xdc
  800b66:	68 dc 41 80 00       	push   $0x8041dc
  800b6b:	e8 52 03 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b70:	e8 11 18 00 00       	call   802386 <sys_calculate_free_frames>
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b7a:	39 c2                	cmp    %eax,%edx
  800b7c:	74 17                	je     800b95 <_main+0xb5d>
  800b7e:	83 ec 04             	sub    $0x4,%esp
  800b81:	68 30 43 80 00       	push   $0x804330
  800b86:	68 dd 00 00 00       	push   $0xdd
  800b8b:	68 dc 41 80 00       	push   $0x8041dc
  800b90:	e8 2d 03 00 00       	call   800ec2 <_panic>

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800b95:	e8 ec 17 00 00       	call   802386 <sys_calculate_free_frames>
  800b9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b9d:	e8 84 18 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ba8:	c1 e0 02             	shl    $0x2,%eax
  800bab:	83 ec 04             	sub    $0x4,%esp
  800bae:	6a 00                	push   $0x0
  800bb0:	50                   	push   %eax
  800bb1:	68 84 43 80 00       	push   $0x804384
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
  800bdc:	68 f8 41 80 00       	push   $0x8041f8
  800be1:	68 e3 00 00 00       	push   $0xe3
  800be6:	68 dc 41 80 00       	push   $0x8041dc
  800beb:	e8 d2 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1024+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800bf0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800bf3:	e8 8e 17 00 00       	call   802386 <sys_calculate_free_frames>
  800bf8:	29 c3                	sub    %eax,%ebx
  800bfa:	89 d8                	mov    %ebx,%eax
  800bfc:	3d 03 04 00 00       	cmp    $0x403,%eax
  800c01:	74 17                	je     800c1a <_main+0xbe2>
  800c03:	83 ec 04             	sub    $0x4,%esp
  800c06:	68 64 42 80 00       	push   $0x804264
  800c0b:	68 e4 00 00 00       	push   $0xe4
  800c10:	68 dc 41 80 00       	push   $0x8041dc
  800c15:	e8 a8 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c1a:	e8 07 18 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800c1f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800c22:	74 17                	je     800c3b <_main+0xc03>
  800c24:	83 ec 04             	sub    $0x4,%esp
  800c27:	68 e2 42 80 00       	push   $0x8042e2
  800c2c:	68 e5 00 00 00       	push   $0xe5
  800c31:	68 dc 41 80 00       	push   $0x8041dc
  800c36:	e8 87 02 00 00       	call   800ec2 <_panic>

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 46 17 00 00       	call   802386 <sys_calculate_free_frames>
  800c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c43:	e8 de 17 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	68 45 43 80 00       	push   $0x804345
  800c53:	ff 75 ec             	pushl  -0x14(%ebp)
  800c56:	e8 87 15 00 00       	call   8021e2 <sget>
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
  800c79:	68 f8 41 80 00       	push   $0x8041f8
  800c7e:	68 eb 00 00 00       	push   $0xeb
  800c83:	68 dc 41 80 00       	push   $0x8041dc
  800c88:	e8 35 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800c8d:	e8 f4 16 00 00       	call   802386 <sys_calculate_free_frames>
  800c92:	89 c2                	mov    %eax,%edx
  800c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	74 17                	je     800cb2 <_main+0xc7a>
  800c9b:	83 ec 04             	sub    $0x4,%esp
  800c9e:	68 64 42 80 00       	push   $0x804264
  800ca3:	68 ec 00 00 00       	push   $0xec
  800ca8:	68 dc 41 80 00       	push   $0x8041dc
  800cad:	e8 10 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800cb2:	e8 6f 17 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800cb7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800cba:	74 17                	je     800cd3 <_main+0xc9b>
  800cbc:	83 ec 04             	sub    $0x4,%esp
  800cbf:	68 e2 42 80 00       	push   $0x8042e2
  800cc4:	68 ed 00 00 00       	push   $0xed
  800cc9:	68 dc 41 80 00       	push   $0x8041dc
  800cce:	e8 ef 01 00 00       	call   800ec2 <_panic>

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800cd3:	e8 ae 16 00 00       	call   802386 <sys_calculate_free_frames>
  800cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800cdb:	e8 46 17 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800ce0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	68 f3 41 80 00       	push   $0x8041f3
  800ceb:	ff 75 ec             	pushl  -0x14(%ebp)
  800cee:	e8 ef 14 00 00       	call   8021e2 <sget>
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
  800d14:	68 f8 41 80 00       	push   $0x8041f8
  800d19:	68 f3 00 00 00       	push   $0xf3
  800d1e:	68 dc 41 80 00       	push   $0x8041dc
  800d23:	e8 9a 01 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800d28:	e8 59 16 00 00       	call   802386 <sys_calculate_free_frames>
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d32:	39 c2                	cmp    %eax,%edx
  800d34:	74 17                	je     800d4d <_main+0xd15>
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	68 64 42 80 00       	push   $0x804264
  800d3e:	68 f4 00 00 00       	push   $0xf4
  800d43:	68 dc 41 80 00       	push   $0x8041dc
  800d48:	e8 75 01 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800d4d:	e8 d4 16 00 00       	call   802426 <sys_pf_calculate_allocated_pages>
  800d52:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d55:	74 17                	je     800d6e <_main+0xd36>
  800d57:	83 ec 04             	sub    $0x4,%esp
  800d5a:	68 e2 42 80 00       	push   $0x8042e2
  800d5f:	68 f5 00 00 00       	push   $0xf5
  800d64:	68 dc 41 80 00       	push   $0x8041dc
  800d69:	e8 54 01 00 00       	call   800ec2 <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT allocation (3) completed successfully.\n");
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	68 88 43 80 00       	push   $0x804388
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
  800d8c:	e8 d5 18 00 00       	call   802666 <sys_getenvindex>
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
  800df7:	e8 77 16 00 00       	call   802473 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	68 ec 43 80 00       	push   $0x8043ec
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
  800e27:	68 14 44 80 00       	push   $0x804414
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
  800e58:	68 3c 44 80 00       	push   $0x80443c
  800e5d:	e8 14 03 00 00       	call   801176 <cprintf>
  800e62:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800e65:	a1 20 50 80 00       	mov    0x805020,%eax
  800e6a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	50                   	push   %eax
  800e74:	68 94 44 80 00       	push   $0x804494
  800e79:	e8 f8 02 00 00       	call   801176 <cprintf>
  800e7e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	68 ec 43 80 00       	push   $0x8043ec
  800e89:	e8 e8 02 00 00       	call   801176 <cprintf>
  800e8e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e91:	e8 f7 15 00 00       	call   80248d <sys_enable_interrupt>

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
  800ea9:	e8 84 17 00 00       	call   802632 <sys_destroy_env>
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
  800eba:	e8 d9 17 00 00       	call   802698 <sys_exit_env>
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
  800ee3:	68 a8 44 80 00       	push   $0x8044a8
  800ee8:	e8 89 02 00 00       	call   801176 <cprintf>
  800eed:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ef0:	a1 00 50 80 00       	mov    0x805000,%eax
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	ff 75 08             	pushl  0x8(%ebp)
  800efb:	50                   	push   %eax
  800efc:	68 ad 44 80 00       	push   $0x8044ad
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
  800f20:	68 c9 44 80 00       	push   $0x8044c9
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
  800f4c:	68 cc 44 80 00       	push   $0x8044cc
  800f51:	6a 26                	push   $0x26
  800f53:	68 18 45 80 00       	push   $0x804518
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
  80101e:	68 24 45 80 00       	push   $0x804524
  801023:	6a 3a                	push   $0x3a
  801025:	68 18 45 80 00       	push   $0x804518
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
  80108e:	68 78 45 80 00       	push   $0x804578
  801093:	6a 44                	push   $0x44
  801095:	68 18 45 80 00       	push   $0x804518
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
  8010e8:	e8 d8 11 00 00       	call   8022c5 <sys_cputs>
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
  80115f:	e8 61 11 00 00       	call   8022c5 <sys_cputs>
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
  8011a9:	e8 c5 12 00 00       	call   802473 <sys_disable_interrupt>
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
  8011c9:	e8 bf 12 00 00       	call   80248d <sys_enable_interrupt>
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
  801213:	e8 30 2d 00 00       	call   803f48 <__udivdi3>
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
  801263:	e8 f0 2d 00 00       	call   804058 <__umoddi3>
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	05 f4 47 80 00       	add    $0x8047f4,%eax
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
  8013be:	8b 04 85 18 48 80 00 	mov    0x804818(,%eax,4),%eax
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
  80149f:	8b 34 9d 60 46 80 00 	mov    0x804660(,%ebx,4),%esi
  8014a6:	85 f6                	test   %esi,%esi
  8014a8:	75 19                	jne    8014c3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8014aa:	53                   	push   %ebx
  8014ab:	68 05 48 80 00       	push   $0x804805
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
  8014c4:	68 0e 48 80 00       	push   $0x80480e
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
  8014f1:	be 11 48 80 00       	mov    $0x804811,%esi
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
  801f17:	68 70 49 80 00       	push   $0x804970
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
  801fe7:	e8 1d 04 00 00       	call   802409 <sys_allocate_chunk>
  801fec:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801fef:	a1 20 51 80 00       	mov    0x805120,%eax
  801ff4:	83 ec 0c             	sub    $0xc,%esp
  801ff7:	50                   	push   %eax
  801ff8:	e8 92 0a 00 00       	call   802a8f <initialize_MemBlocksList>
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
  802025:	68 95 49 80 00       	push   $0x804995
  80202a:	6a 33                	push   $0x33
  80202c:	68 b3 49 80 00       	push   $0x8049b3
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
  8020a4:	68 c0 49 80 00       	push   $0x8049c0
  8020a9:	6a 34                	push   $0x34
  8020ab:	68 b3 49 80 00       	push   $0x8049b3
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
  802119:	68 e4 49 80 00       	push   $0x8049e4
  80211e:	6a 46                	push   $0x46
  802120:	68 b3 49 80 00       	push   $0x8049b3
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
  802135:	68 0c 4a 80 00       	push   $0x804a0c
  80213a:	6a 61                	push   $0x61
  80213c:	68 b3 49 80 00       	push   $0x8049b3
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
  80215b:	75 07                	jne    802164 <smalloc+0x1e>
  80215d:	b8 00 00 00 00       	mov    $0x0,%eax
  802162:	eb 7c                	jmp    8021e0 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802164:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80216b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802171:	01 d0                	add    %edx,%eax
  802173:	48                   	dec    %eax
  802174:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802177:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217a:	ba 00 00 00 00       	mov    $0x0,%edx
  80217f:	f7 75 f0             	divl   -0x10(%ebp)
  802182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802185:	29 d0                	sub    %edx,%eax
  802187:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80218a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802191:	e8 41 06 00 00       	call   8027d7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802196:	85 c0                	test   %eax,%eax
  802198:	74 11                	je     8021ab <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80219a:	83 ec 0c             	sub    $0xc,%esp
  80219d:	ff 75 e8             	pushl  -0x18(%ebp)
  8021a0:	e8 ac 0c 00 00       	call   802e51 <alloc_block_FF>
  8021a5:	83 c4 10             	add    $0x10,%esp
  8021a8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8021ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021af:	74 2a                	je     8021db <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 40 08             	mov    0x8(%eax),%eax
  8021b7:	89 c2                	mov    %eax,%edx
  8021b9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8021bd:	52                   	push   %edx
  8021be:	50                   	push   %eax
  8021bf:	ff 75 0c             	pushl  0xc(%ebp)
  8021c2:	ff 75 08             	pushl  0x8(%ebp)
  8021c5:	e8 92 03 00 00       	call   80255c <sys_createSharedObject>
  8021ca:	83 c4 10             	add    $0x10,%esp
  8021cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8021d0:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8021d4:	74 05                	je     8021db <smalloc+0x95>
			return (void*)virtual_address;
  8021d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021d9:	eb 05                	jmp    8021e0 <smalloc+0x9a>
	}
	return NULL;
  8021db:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021e8:	e8 13 fd ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8021ed:	83 ec 04             	sub    $0x4,%esp
  8021f0:	68 30 4a 80 00       	push   $0x804a30
  8021f5:	68 a2 00 00 00       	push   $0xa2
  8021fa:	68 b3 49 80 00       	push   $0x8049b3
  8021ff:	e8 be ec ff ff       	call   800ec2 <_panic>

00802204 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80220a:	e8 f1 fc ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80220f:	83 ec 04             	sub    $0x4,%esp
  802212:	68 54 4a 80 00       	push   $0x804a54
  802217:	68 e6 00 00 00       	push   $0xe6
  80221c:	68 b3 49 80 00       	push   $0x8049b3
  802221:	e8 9c ec ff ff       	call   800ec2 <_panic>

00802226 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80222c:	83 ec 04             	sub    $0x4,%esp
  80222f:	68 7c 4a 80 00       	push   $0x804a7c
  802234:	68 fa 00 00 00       	push   $0xfa
  802239:	68 b3 49 80 00       	push   $0x8049b3
  80223e:	e8 7f ec ff ff       	call   800ec2 <_panic>

00802243 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802249:	83 ec 04             	sub    $0x4,%esp
  80224c:	68 a0 4a 80 00       	push   $0x804aa0
  802251:	68 05 01 00 00       	push   $0x105
  802256:	68 b3 49 80 00       	push   $0x8049b3
  80225b:	e8 62 ec ff ff       	call   800ec2 <_panic>

00802260 <shrink>:

}
void shrink(uint32 newSize)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802266:	83 ec 04             	sub    $0x4,%esp
  802269:	68 a0 4a 80 00       	push   $0x804aa0
  80226e:	68 0a 01 00 00       	push   $0x10a
  802273:	68 b3 49 80 00       	push   $0x8049b3
  802278:	e8 45 ec ff ff       	call   800ec2 <_panic>

0080227d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802283:	83 ec 04             	sub    $0x4,%esp
  802286:	68 a0 4a 80 00       	push   $0x804aa0
  80228b:	68 0f 01 00 00       	push   $0x10f
  802290:	68 b3 49 80 00       	push   $0x8049b3
  802295:	e8 28 ec ff ff       	call   800ec2 <_panic>

0080229a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	57                   	push   %edi
  80229e:	56                   	push   %esi
  80229f:	53                   	push   %ebx
  8022a0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022af:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022b2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022b5:	cd 30                	int    $0x30
  8022b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022bd:	83 c4 10             	add    $0x10,%esp
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5f                   	pop    %edi
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    

008022c5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	83 ec 04             	sub    $0x4,%esp
  8022cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8022d1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	52                   	push   %edx
  8022dd:	ff 75 0c             	pushl  0xc(%ebp)
  8022e0:	50                   	push   %eax
  8022e1:	6a 00                	push   $0x0
  8022e3:	e8 b2 ff ff ff       	call   80229a <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
}
  8022eb:	90                   	nop
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <sys_cgetc>:

int
sys_cgetc(void)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 01                	push   $0x1
  8022fd:	e8 98 ff ff ff       	call   80229a <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80230a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	52                   	push   %edx
  802317:	50                   	push   %eax
  802318:	6a 05                	push   $0x5
  80231a:	e8 7b ff ff ff       	call   80229a <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	56                   	push   %esi
  802328:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802329:	8b 75 18             	mov    0x18(%ebp),%esi
  80232c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80232f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802332:	8b 55 0c             	mov    0xc(%ebp),%edx
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	56                   	push   %esi
  802339:	53                   	push   %ebx
  80233a:	51                   	push   %ecx
  80233b:	52                   	push   %edx
  80233c:	50                   	push   %eax
  80233d:	6a 06                	push   $0x6
  80233f:	e8 56 ff ff ff       	call   80229a <syscall>
  802344:	83 c4 18             	add    $0x18,%esp
}
  802347:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80234a:	5b                   	pop    %ebx
  80234b:	5e                   	pop    %esi
  80234c:	5d                   	pop    %ebp
  80234d:	c3                   	ret    

0080234e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802351:	8b 55 0c             	mov    0xc(%ebp),%edx
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	52                   	push   %edx
  80235e:	50                   	push   %eax
  80235f:	6a 07                	push   $0x7
  802361:	e8 34 ff ff ff       	call   80229a <syscall>
  802366:	83 c4 18             	add    $0x18,%esp
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	ff 75 0c             	pushl  0xc(%ebp)
  802377:	ff 75 08             	pushl  0x8(%ebp)
  80237a:	6a 08                	push   $0x8
  80237c:	e8 19 ff ff ff       	call   80229a <syscall>
  802381:	83 c4 18             	add    $0x18,%esp
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 09                	push   $0x9
  802395:	e8 00 ff ff ff       	call   80229a <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 0a                	push   $0xa
  8023ae:	e8 e7 fe ff ff       	call   80229a <syscall>
  8023b3:	83 c4 18             	add    $0x18,%esp
}
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 0b                	push   $0xb
  8023c7:	e8 ce fe ff ff       	call   80229a <syscall>
  8023cc:	83 c4 18             	add    $0x18,%esp
}
  8023cf:	c9                   	leave  
  8023d0:	c3                   	ret    

008023d1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023d1:	55                   	push   %ebp
  8023d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	ff 75 0c             	pushl  0xc(%ebp)
  8023dd:	ff 75 08             	pushl  0x8(%ebp)
  8023e0:	6a 0f                	push   $0xf
  8023e2:	e8 b3 fe ff ff       	call   80229a <syscall>
  8023e7:	83 c4 18             	add    $0x18,%esp
	return;
  8023ea:	90                   	nop
}
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	ff 75 0c             	pushl  0xc(%ebp)
  8023f9:	ff 75 08             	pushl  0x8(%ebp)
  8023fc:	6a 10                	push   $0x10
  8023fe:	e8 97 fe ff ff       	call   80229a <syscall>
  802403:	83 c4 18             	add    $0x18,%esp
	return ;
  802406:	90                   	nop
}
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	ff 75 10             	pushl  0x10(%ebp)
  802413:	ff 75 0c             	pushl  0xc(%ebp)
  802416:	ff 75 08             	pushl  0x8(%ebp)
  802419:	6a 11                	push   $0x11
  80241b:	e8 7a fe ff ff       	call   80229a <syscall>
  802420:	83 c4 18             	add    $0x18,%esp
	return ;
  802423:	90                   	nop
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 0c                	push   $0xc
  802435:	e8 60 fe ff ff       	call   80229a <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
}
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	ff 75 08             	pushl  0x8(%ebp)
  80244d:	6a 0d                	push   $0xd
  80244f:	e8 46 fe ff ff       	call   80229a <syscall>
  802454:	83 c4 18             	add    $0x18,%esp
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 0e                	push   $0xe
  802468:	e8 2d fe ff ff       	call   80229a <syscall>
  80246d:	83 c4 18             	add    $0x18,%esp
}
  802470:	90                   	nop
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 13                	push   $0x13
  802482:	e8 13 fe ff ff       	call   80229a <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
}
  80248a:	90                   	nop
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 14                	push   $0x14
  80249c:	e8 f9 fd ff ff       	call   80229a <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
}
  8024a4:	90                   	nop
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	83 ec 04             	sub    $0x4,%esp
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024b3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	50                   	push   %eax
  8024c0:	6a 15                	push   $0x15
  8024c2:	e8 d3 fd ff ff       	call   80229a <syscall>
  8024c7:	83 c4 18             	add    $0x18,%esp
}
  8024ca:	90                   	nop
  8024cb:	c9                   	leave  
  8024cc:	c3                   	ret    

008024cd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024cd:	55                   	push   %ebp
  8024ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 16                	push   $0x16
  8024dc:	e8 b9 fd ff ff       	call   80229a <syscall>
  8024e1:	83 c4 18             	add    $0x18,%esp
}
  8024e4:	90                   	nop
  8024e5:	c9                   	leave  
  8024e6:	c3                   	ret    

008024e7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	ff 75 0c             	pushl  0xc(%ebp)
  8024f6:	50                   	push   %eax
  8024f7:	6a 17                	push   $0x17
  8024f9:	e8 9c fd ff ff       	call   80229a <syscall>
  8024fe:	83 c4 18             	add    $0x18,%esp
}
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802506:	8b 55 0c             	mov    0xc(%ebp),%edx
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	52                   	push   %edx
  802513:	50                   	push   %eax
  802514:	6a 1a                	push   $0x1a
  802516:	e8 7f fd ff ff       	call   80229a <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
}
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802523:	8b 55 0c             	mov    0xc(%ebp),%edx
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	52                   	push   %edx
  802530:	50                   	push   %eax
  802531:	6a 18                	push   $0x18
  802533:	e8 62 fd ff ff       	call   80229a <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
}
  80253b:	90                   	nop
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802541:	8b 55 0c             	mov    0xc(%ebp),%edx
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	52                   	push   %edx
  80254e:	50                   	push   %eax
  80254f:	6a 19                	push   $0x19
  802551:	e8 44 fd ff ff       	call   80229a <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
}
  802559:	90                   	nop
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
  80255f:	83 ec 04             	sub    $0x4,%esp
  802562:	8b 45 10             	mov    0x10(%ebp),%eax
  802565:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802568:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80256b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	6a 00                	push   $0x0
  802574:	51                   	push   %ecx
  802575:	52                   	push   %edx
  802576:	ff 75 0c             	pushl  0xc(%ebp)
  802579:	50                   	push   %eax
  80257a:	6a 1b                	push   $0x1b
  80257c:	e8 19 fd ff ff       	call   80229a <syscall>
  802581:	83 c4 18             	add    $0x18,%esp
}
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	52                   	push   %edx
  802596:	50                   	push   %eax
  802597:	6a 1c                	push   $0x1c
  802599:	e8 fc fc ff ff       	call   80229a <syscall>
  80259e:	83 c4 18             	add    $0x18,%esp
}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    

008025a3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8025a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	51                   	push   %ecx
  8025b4:	52                   	push   %edx
  8025b5:	50                   	push   %eax
  8025b6:	6a 1d                	push   $0x1d
  8025b8:	e8 dd fc ff ff       	call   80229a <syscall>
  8025bd:	83 c4 18             	add    $0x18,%esp
}
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	52                   	push   %edx
  8025d2:	50                   	push   %eax
  8025d3:	6a 1e                	push   $0x1e
  8025d5:	e8 c0 fc ff ff       	call   80229a <syscall>
  8025da:	83 c4 18             	add    $0x18,%esp
}
  8025dd:	c9                   	leave  
  8025de:	c3                   	ret    

008025df <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 1f                	push   $0x1f
  8025ee:	e8 a7 fc ff ff       	call   80229a <syscall>
  8025f3:	83 c4 18             	add    $0x18,%esp
}
  8025f6:	c9                   	leave  
  8025f7:	c3                   	ret    

008025f8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	6a 00                	push   $0x0
  802600:	ff 75 14             	pushl  0x14(%ebp)
  802603:	ff 75 10             	pushl  0x10(%ebp)
  802606:	ff 75 0c             	pushl  0xc(%ebp)
  802609:	50                   	push   %eax
  80260a:	6a 20                	push   $0x20
  80260c:	e8 89 fc ff ff       	call   80229a <syscall>
  802611:	83 c4 18             	add    $0x18,%esp
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802619:	8b 45 08             	mov    0x8(%ebp),%eax
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	50                   	push   %eax
  802625:	6a 21                	push   $0x21
  802627:	e8 6e fc ff ff       	call   80229a <syscall>
  80262c:	83 c4 18             	add    $0x18,%esp
}
  80262f:	90                   	nop
  802630:	c9                   	leave  
  802631:	c3                   	ret    

00802632 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802632:	55                   	push   %ebp
  802633:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802635:	8b 45 08             	mov    0x8(%ebp),%eax
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	50                   	push   %eax
  802641:	6a 22                	push   $0x22
  802643:	e8 52 fc ff ff       	call   80229a <syscall>
  802648:	83 c4 18             	add    $0x18,%esp
}
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 02                	push   $0x2
  80265c:	e8 39 fc ff ff       	call   80229a <syscall>
  802661:	83 c4 18             	add    $0x18,%esp
}
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 03                	push   $0x3
  802675:	e8 20 fc ff ff       	call   80229a <syscall>
  80267a:	83 c4 18             	add    $0x18,%esp
}
  80267d:	c9                   	leave  
  80267e:	c3                   	ret    

0080267f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80267f:	55                   	push   %ebp
  802680:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 04                	push   $0x4
  80268e:	e8 07 fc ff ff       	call   80229a <syscall>
  802693:	83 c4 18             	add    $0x18,%esp
}
  802696:	c9                   	leave  
  802697:	c3                   	ret    

00802698 <sys_exit_env>:


void sys_exit_env(void)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 23                	push   $0x23
  8026a7:	e8 ee fb ff ff       	call   80229a <syscall>
  8026ac:	83 c4 18             	add    $0x18,%esp
}
  8026af:	90                   	nop
  8026b0:	c9                   	leave  
  8026b1:	c3                   	ret    

008026b2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8026b2:	55                   	push   %ebp
  8026b3:	89 e5                	mov    %esp,%ebp
  8026b5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8026b8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026bb:	8d 50 04             	lea    0x4(%eax),%edx
  8026be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	52                   	push   %edx
  8026c8:	50                   	push   %eax
  8026c9:	6a 24                	push   $0x24
  8026cb:	e8 ca fb ff ff       	call   80229a <syscall>
  8026d0:	83 c4 18             	add    $0x18,%esp
	return result;
  8026d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026dc:	89 01                	mov    %eax,(%ecx)
  8026de:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	c9                   	leave  
  8026e5:	c2 04 00             	ret    $0x4

008026e8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	ff 75 10             	pushl  0x10(%ebp)
  8026f2:	ff 75 0c             	pushl  0xc(%ebp)
  8026f5:	ff 75 08             	pushl  0x8(%ebp)
  8026f8:	6a 12                	push   $0x12
  8026fa:	e8 9b fb ff ff       	call   80229a <syscall>
  8026ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802702:	90                   	nop
}
  802703:	c9                   	leave  
  802704:	c3                   	ret    

00802705 <sys_rcr2>:
uint32 sys_rcr2()
{
  802705:	55                   	push   %ebp
  802706:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 25                	push   $0x25
  802714:	e8 81 fb ff ff       	call   80229a <syscall>
  802719:	83 c4 18             	add    $0x18,%esp
}
  80271c:	c9                   	leave  
  80271d:	c3                   	ret    

0080271e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	83 ec 04             	sub    $0x4,%esp
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80272a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	50                   	push   %eax
  802737:	6a 26                	push   $0x26
  802739:	e8 5c fb ff ff       	call   80229a <syscall>
  80273e:	83 c4 18             	add    $0x18,%esp
	return ;
  802741:	90                   	nop
}
  802742:	c9                   	leave  
  802743:	c3                   	ret    

00802744 <rsttst>:
void rsttst()
{
  802744:	55                   	push   %ebp
  802745:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802747:	6a 00                	push   $0x0
  802749:	6a 00                	push   $0x0
  80274b:	6a 00                	push   $0x0
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	6a 28                	push   $0x28
  802753:	e8 42 fb ff ff       	call   80229a <syscall>
  802758:	83 c4 18             	add    $0x18,%esp
	return ;
  80275b:	90                   	nop
}
  80275c:	c9                   	leave  
  80275d:	c3                   	ret    

0080275e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
  802761:	83 ec 04             	sub    $0x4,%esp
  802764:	8b 45 14             	mov    0x14(%ebp),%eax
  802767:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80276a:	8b 55 18             	mov    0x18(%ebp),%edx
  80276d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802771:	52                   	push   %edx
  802772:	50                   	push   %eax
  802773:	ff 75 10             	pushl  0x10(%ebp)
  802776:	ff 75 0c             	pushl  0xc(%ebp)
  802779:	ff 75 08             	pushl  0x8(%ebp)
  80277c:	6a 27                	push   $0x27
  80277e:	e8 17 fb ff ff       	call   80229a <syscall>
  802783:	83 c4 18             	add    $0x18,%esp
	return ;
  802786:	90                   	nop
}
  802787:	c9                   	leave  
  802788:	c3                   	ret    

00802789 <chktst>:
void chktst(uint32 n)
{
  802789:	55                   	push   %ebp
  80278a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	6a 00                	push   $0x0
  802794:	ff 75 08             	pushl  0x8(%ebp)
  802797:	6a 29                	push   $0x29
  802799:	e8 fc fa ff ff       	call   80229a <syscall>
  80279e:	83 c4 18             	add    $0x18,%esp
	return ;
  8027a1:	90                   	nop
}
  8027a2:	c9                   	leave  
  8027a3:	c3                   	ret    

008027a4 <inctst>:

void inctst()
{
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	6a 2a                	push   $0x2a
  8027b3:	e8 e2 fa ff ff       	call   80229a <syscall>
  8027b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8027bb:	90                   	nop
}
  8027bc:	c9                   	leave  
  8027bd:	c3                   	ret    

008027be <gettst>:
uint32 gettst()
{
  8027be:	55                   	push   %ebp
  8027bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 2b                	push   $0x2b
  8027cd:	e8 c8 fa ff ff       	call   80229a <syscall>
  8027d2:	83 c4 18             	add    $0x18,%esp
}
  8027d5:	c9                   	leave  
  8027d6:	c3                   	ret    

008027d7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8027d7:	55                   	push   %ebp
  8027d8:	89 e5                	mov    %esp,%ebp
  8027da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 2c                	push   $0x2c
  8027e9:	e8 ac fa ff ff       	call   80229a <syscall>
  8027ee:	83 c4 18             	add    $0x18,%esp
  8027f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8027f4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8027f8:	75 07                	jne    802801 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8027fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ff:	eb 05                	jmp    802806 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802801:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802806:	c9                   	leave  
  802807:	c3                   	ret    

00802808 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
  80280b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80280e:	6a 00                	push   $0x0
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 2c                	push   $0x2c
  80281a:	e8 7b fa ff ff       	call   80229a <syscall>
  80281f:	83 c4 18             	add    $0x18,%esp
  802822:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802825:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802829:	75 07                	jne    802832 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80282b:	b8 01 00 00 00       	mov    $0x1,%eax
  802830:	eb 05                	jmp    802837 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802832:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802837:	c9                   	leave  
  802838:	c3                   	ret    

00802839 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
  80283c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80283f:	6a 00                	push   $0x0
  802841:	6a 00                	push   $0x0
  802843:	6a 00                	push   $0x0
  802845:	6a 00                	push   $0x0
  802847:	6a 00                	push   $0x0
  802849:	6a 2c                	push   $0x2c
  80284b:	e8 4a fa ff ff       	call   80229a <syscall>
  802850:	83 c4 18             	add    $0x18,%esp
  802853:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802856:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80285a:	75 07                	jne    802863 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80285c:	b8 01 00 00 00       	mov    $0x1,%eax
  802861:	eb 05                	jmp    802868 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802863:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802868:	c9                   	leave  
  802869:	c3                   	ret    

0080286a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
  80286d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 00                	push   $0x0
  802878:	6a 00                	push   $0x0
  80287a:	6a 2c                	push   $0x2c
  80287c:	e8 19 fa ff ff       	call   80229a <syscall>
  802881:	83 c4 18             	add    $0x18,%esp
  802884:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802887:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80288b:	75 07                	jne    802894 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80288d:	b8 01 00 00 00       	mov    $0x1,%eax
  802892:	eb 05                	jmp    802899 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802894:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802899:	c9                   	leave  
  80289a:	c3                   	ret    

0080289b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	ff 75 08             	pushl  0x8(%ebp)
  8028a9:	6a 2d                	push   $0x2d
  8028ab:	e8 ea f9 ff ff       	call   80229a <syscall>
  8028b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8028b3:	90                   	nop
}
  8028b4:	c9                   	leave  
  8028b5:	c3                   	ret    

008028b6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8028b6:	55                   	push   %ebp
  8028b7:	89 e5                	mov    %esp,%ebp
  8028b9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8028ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	6a 00                	push   $0x0
  8028c8:	53                   	push   %ebx
  8028c9:	51                   	push   %ecx
  8028ca:	52                   	push   %edx
  8028cb:	50                   	push   %eax
  8028cc:	6a 2e                	push   $0x2e
  8028ce:	e8 c7 f9 ff ff       	call   80229a <syscall>
  8028d3:	83 c4 18             	add    $0x18,%esp
}
  8028d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028d9:	c9                   	leave  
  8028da:	c3                   	ret    

008028db <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8028db:	55                   	push   %ebp
  8028dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8028de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	6a 00                	push   $0x0
  8028ea:	52                   	push   %edx
  8028eb:	50                   	push   %eax
  8028ec:	6a 2f                	push   $0x2f
  8028ee:	e8 a7 f9 ff ff       	call   80229a <syscall>
  8028f3:	83 c4 18             	add    $0x18,%esp
}
  8028f6:	c9                   	leave  
  8028f7:	c3                   	ret    

008028f8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8028f8:	55                   	push   %ebp
  8028f9:	89 e5                	mov    %esp,%ebp
  8028fb:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8028fe:	83 ec 0c             	sub    $0xc,%esp
  802901:	68 b0 4a 80 00       	push   $0x804ab0
  802906:	e8 6b e8 ff ff       	call   801176 <cprintf>
  80290b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80290e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802915:	83 ec 0c             	sub    $0xc,%esp
  802918:	68 dc 4a 80 00       	push   $0x804adc
  80291d:	e8 54 e8 ff ff       	call   801176 <cprintf>
  802922:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802925:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802929:	a1 38 51 80 00       	mov    0x805138,%eax
  80292e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802931:	eb 56                	jmp    802989 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802933:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802937:	74 1c                	je     802955 <print_mem_block_lists+0x5d>
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 50 08             	mov    0x8(%eax),%edx
  80293f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802942:	8b 48 08             	mov    0x8(%eax),%ecx
  802945:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802948:	8b 40 0c             	mov    0xc(%eax),%eax
  80294b:	01 c8                	add    %ecx,%eax
  80294d:	39 c2                	cmp    %eax,%edx
  80294f:	73 04                	jae    802955 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802951:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 50 08             	mov    0x8(%eax),%edx
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 40 0c             	mov    0xc(%eax),%eax
  802961:	01 c2                	add    %eax,%edx
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 40 08             	mov    0x8(%eax),%eax
  802969:	83 ec 04             	sub    $0x4,%esp
  80296c:	52                   	push   %edx
  80296d:	50                   	push   %eax
  80296e:	68 f1 4a 80 00       	push   $0x804af1
  802973:	e8 fe e7 ff ff       	call   801176 <cprintf>
  802978:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802981:	a1 40 51 80 00       	mov    0x805140,%eax
  802986:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298d:	74 07                	je     802996 <print_mem_block_lists+0x9e>
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	eb 05                	jmp    80299b <print_mem_block_lists+0xa3>
  802996:	b8 00 00 00 00       	mov    $0x0,%eax
  80299b:	a3 40 51 80 00       	mov    %eax,0x805140
  8029a0:	a1 40 51 80 00       	mov    0x805140,%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	75 8a                	jne    802933 <print_mem_block_lists+0x3b>
  8029a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ad:	75 84                	jne    802933 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8029af:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029b3:	75 10                	jne    8029c5 <print_mem_block_lists+0xcd>
  8029b5:	83 ec 0c             	sub    $0xc,%esp
  8029b8:	68 00 4b 80 00       	push   $0x804b00
  8029bd:	e8 b4 e7 ff ff       	call   801176 <cprintf>
  8029c2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8029c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8029cc:	83 ec 0c             	sub    $0xc,%esp
  8029cf:	68 24 4b 80 00       	push   $0x804b24
  8029d4:	e8 9d e7 ff ff       	call   801176 <cprintf>
  8029d9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8029dc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029e0:	a1 40 50 80 00       	mov    0x805040,%eax
  8029e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e8:	eb 56                	jmp    802a40 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ee:	74 1c                	je     802a0c <print_mem_block_lists+0x114>
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 50 08             	mov    0x8(%eax),%edx
  8029f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f9:	8b 48 08             	mov    0x8(%eax),%ecx
  8029fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802a02:	01 c8                	add    %ecx,%eax
  802a04:	39 c2                	cmp    %eax,%edx
  802a06:	73 04                	jae    802a0c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802a08:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 50 08             	mov    0x8(%eax),%edx
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 40 0c             	mov    0xc(%eax),%eax
  802a18:	01 c2                	add    %eax,%edx
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 40 08             	mov    0x8(%eax),%eax
  802a20:	83 ec 04             	sub    $0x4,%esp
  802a23:	52                   	push   %edx
  802a24:	50                   	push   %eax
  802a25:	68 f1 4a 80 00       	push   $0x804af1
  802a2a:	e8 47 e7 ff ff       	call   801176 <cprintf>
  802a2f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a38:	a1 48 50 80 00       	mov    0x805048,%eax
  802a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a44:	74 07                	je     802a4d <print_mem_block_lists+0x155>
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	eb 05                	jmp    802a52 <print_mem_block_lists+0x15a>
  802a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a52:	a3 48 50 80 00       	mov    %eax,0x805048
  802a57:	a1 48 50 80 00       	mov    0x805048,%eax
  802a5c:	85 c0                	test   %eax,%eax
  802a5e:	75 8a                	jne    8029ea <print_mem_block_lists+0xf2>
  802a60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a64:	75 84                	jne    8029ea <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802a66:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a6a:	75 10                	jne    802a7c <print_mem_block_lists+0x184>
  802a6c:	83 ec 0c             	sub    $0xc,%esp
  802a6f:	68 3c 4b 80 00       	push   $0x804b3c
  802a74:	e8 fd e6 ff ff       	call   801176 <cprintf>
  802a79:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802a7c:	83 ec 0c             	sub    $0xc,%esp
  802a7f:	68 b0 4a 80 00       	push   $0x804ab0
  802a84:	e8 ed e6 ff ff       	call   801176 <cprintf>
  802a89:	83 c4 10             	add    $0x10,%esp

}
  802a8c:	90                   	nop
  802a8d:	c9                   	leave  
  802a8e:	c3                   	ret    

00802a8f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a8f:	55                   	push   %ebp
  802a90:	89 e5                	mov    %esp,%ebp
  802a92:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802a95:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a9c:	00 00 00 
  802a9f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802aa6:	00 00 00 
  802aa9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802ab0:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802ab3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802aba:	e9 9e 00 00 00       	jmp    802b5d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802abf:	a1 50 50 80 00       	mov    0x805050,%eax
  802ac4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac7:	c1 e2 04             	shl    $0x4,%edx
  802aca:	01 d0                	add    %edx,%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	75 14                	jne    802ae4 <initialize_MemBlocksList+0x55>
  802ad0:	83 ec 04             	sub    $0x4,%esp
  802ad3:	68 64 4b 80 00       	push   $0x804b64
  802ad8:	6a 46                	push   $0x46
  802ada:	68 87 4b 80 00       	push   $0x804b87
  802adf:	e8 de e3 ff ff       	call   800ec2 <_panic>
  802ae4:	a1 50 50 80 00       	mov    0x805050,%eax
  802ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aec:	c1 e2 04             	shl    $0x4,%edx
  802aef:	01 d0                	add    %edx,%eax
  802af1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802af7:	89 10                	mov    %edx,(%eax)
  802af9:	8b 00                	mov    (%eax),%eax
  802afb:	85 c0                	test   %eax,%eax
  802afd:	74 18                	je     802b17 <initialize_MemBlocksList+0x88>
  802aff:	a1 48 51 80 00       	mov    0x805148,%eax
  802b04:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802b0a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802b0d:	c1 e1 04             	shl    $0x4,%ecx
  802b10:	01 ca                	add    %ecx,%edx
  802b12:	89 50 04             	mov    %edx,0x4(%eax)
  802b15:	eb 12                	jmp    802b29 <initialize_MemBlocksList+0x9a>
  802b17:	a1 50 50 80 00       	mov    0x805050,%eax
  802b1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1f:	c1 e2 04             	shl    $0x4,%edx
  802b22:	01 d0                	add    %edx,%eax
  802b24:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b29:	a1 50 50 80 00       	mov    0x805050,%eax
  802b2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b31:	c1 e2 04             	shl    $0x4,%edx
  802b34:	01 d0                	add    %edx,%eax
  802b36:	a3 48 51 80 00       	mov    %eax,0x805148
  802b3b:	a1 50 50 80 00       	mov    0x805050,%eax
  802b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b43:	c1 e2 04             	shl    $0x4,%edx
  802b46:	01 d0                	add    %edx,%eax
  802b48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4f:	a1 54 51 80 00       	mov    0x805154,%eax
  802b54:	40                   	inc    %eax
  802b55:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802b5a:	ff 45 f4             	incl   -0xc(%ebp)
  802b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b60:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b63:	0f 82 56 ff ff ff    	jb     802abf <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802b69:	90                   	nop
  802b6a:	c9                   	leave  
  802b6b:	c3                   	ret    

00802b6c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802b6c:	55                   	push   %ebp
  802b6d:	89 e5                	mov    %esp,%ebp
  802b6f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b7a:	eb 19                	jmp    802b95 <find_block+0x29>
	{
		if(va==point->sva)
  802b7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b7f:	8b 40 08             	mov    0x8(%eax),%eax
  802b82:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b85:	75 05                	jne    802b8c <find_block+0x20>
		   return point;
  802b87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b8a:	eb 36                	jmp    802bc2 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	8b 40 08             	mov    0x8(%eax),%eax
  802b92:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b95:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b99:	74 07                	je     802ba2 <find_block+0x36>
  802b9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b9e:	8b 00                	mov    (%eax),%eax
  802ba0:	eb 05                	jmp    802ba7 <find_block+0x3b>
  802ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  802baa:	89 42 08             	mov    %eax,0x8(%edx)
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	8b 40 08             	mov    0x8(%eax),%eax
  802bb3:	85 c0                	test   %eax,%eax
  802bb5:	75 c5                	jne    802b7c <find_block+0x10>
  802bb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802bbb:	75 bf                	jne    802b7c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802bbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bc2:	c9                   	leave  
  802bc3:	c3                   	ret    

00802bc4 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802bc4:	55                   	push   %ebp
  802bc5:	89 e5                	mov    %esp,%ebp
  802bc7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802bca:	a1 40 50 80 00       	mov    0x805040,%eax
  802bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802bd2:	a1 44 50 80 00       	mov    0x805044,%eax
  802bd7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802be0:	74 24                	je     802c06 <insert_sorted_allocList+0x42>
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	8b 50 08             	mov    0x8(%eax),%edx
  802be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802beb:	8b 40 08             	mov    0x8(%eax),%eax
  802bee:	39 c2                	cmp    %eax,%edx
  802bf0:	76 14                	jbe    802c06 <insert_sorted_allocList+0x42>
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 50 08             	mov    0x8(%eax),%edx
  802bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfb:	8b 40 08             	mov    0x8(%eax),%eax
  802bfe:	39 c2                	cmp    %eax,%edx
  802c00:	0f 82 60 01 00 00    	jb     802d66 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802c06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c0a:	75 65                	jne    802c71 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802c0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c10:	75 14                	jne    802c26 <insert_sorted_allocList+0x62>
  802c12:	83 ec 04             	sub    $0x4,%esp
  802c15:	68 64 4b 80 00       	push   $0x804b64
  802c1a:	6a 6b                	push   $0x6b
  802c1c:	68 87 4b 80 00       	push   $0x804b87
  802c21:	e8 9c e2 ff ff       	call   800ec2 <_panic>
  802c26:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	89 10                	mov    %edx,(%eax)
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	85 c0                	test   %eax,%eax
  802c38:	74 0d                	je     802c47 <insert_sorted_allocList+0x83>
  802c3a:	a1 40 50 80 00       	mov    0x805040,%eax
  802c3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c42:	89 50 04             	mov    %edx,0x4(%eax)
  802c45:	eb 08                	jmp    802c4f <insert_sorted_allocList+0x8b>
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	a3 44 50 80 00       	mov    %eax,0x805044
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	a3 40 50 80 00       	mov    %eax,0x805040
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c61:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c66:	40                   	inc    %eax
  802c67:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c6c:	e9 dc 01 00 00       	jmp    802e4d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	8b 50 08             	mov    0x8(%eax),%edx
  802c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7a:	8b 40 08             	mov    0x8(%eax),%eax
  802c7d:	39 c2                	cmp    %eax,%edx
  802c7f:	77 6c                	ja     802ced <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802c81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c85:	74 06                	je     802c8d <insert_sorted_allocList+0xc9>
  802c87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c8b:	75 14                	jne    802ca1 <insert_sorted_allocList+0xdd>
  802c8d:	83 ec 04             	sub    $0x4,%esp
  802c90:	68 a0 4b 80 00       	push   $0x804ba0
  802c95:	6a 6f                	push   $0x6f
  802c97:	68 87 4b 80 00       	push   $0x804b87
  802c9c:	e8 21 e2 ff ff       	call   800ec2 <_panic>
  802ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca4:	8b 50 04             	mov    0x4(%eax),%edx
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	89 50 04             	mov    %edx,0x4(%eax)
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb3:	89 10                	mov    %edx,(%eax)
  802cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb8:	8b 40 04             	mov    0x4(%eax),%eax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	74 0d                	je     802ccc <insert_sorted_allocList+0x108>
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	8b 40 04             	mov    0x4(%eax),%eax
  802cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc8:	89 10                	mov    %edx,(%eax)
  802cca:	eb 08                	jmp    802cd4 <insert_sorted_allocList+0x110>
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	a3 40 50 80 00       	mov    %eax,0x805040
  802cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cda:	89 50 04             	mov    %edx,0x4(%eax)
  802cdd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ce2:	40                   	inc    %eax
  802ce3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ce8:	e9 60 01 00 00       	jmp    802e4d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	8b 50 08             	mov    0x8(%eax),%edx
  802cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf6:	8b 40 08             	mov    0x8(%eax),%eax
  802cf9:	39 c2                	cmp    %eax,%edx
  802cfb:	0f 82 4c 01 00 00    	jb     802e4d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802d01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d05:	75 14                	jne    802d1b <insert_sorted_allocList+0x157>
  802d07:	83 ec 04             	sub    $0x4,%esp
  802d0a:	68 d8 4b 80 00       	push   $0x804bd8
  802d0f:	6a 73                	push   $0x73
  802d11:	68 87 4b 80 00       	push   $0x804b87
  802d16:	e8 a7 e1 ff ff       	call   800ec2 <_panic>
  802d1b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	89 50 04             	mov    %edx,0x4(%eax)
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	8b 40 04             	mov    0x4(%eax),%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	74 0c                	je     802d3d <insert_sorted_allocList+0x179>
  802d31:	a1 44 50 80 00       	mov    0x805044,%eax
  802d36:	8b 55 08             	mov    0x8(%ebp),%edx
  802d39:	89 10                	mov    %edx,(%eax)
  802d3b:	eb 08                	jmp    802d45 <insert_sorted_allocList+0x181>
  802d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d40:	a3 40 50 80 00       	mov    %eax,0x805040
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	a3 44 50 80 00       	mov    %eax,0x805044
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d56:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d5b:	40                   	inc    %eax
  802d5c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d61:	e9 e7 00 00 00       	jmp    802e4d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802d6c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802d73:	a1 40 50 80 00       	mov    0x805040,%eax
  802d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d7b:	e9 9d 00 00 00       	jmp    802e1d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 00                	mov    (%eax),%eax
  802d85:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	8b 50 08             	mov    0x8(%eax),%edx
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 40 08             	mov    0x8(%eax),%eax
  802d94:	39 c2                	cmp    %eax,%edx
  802d96:	76 7d                	jbe    802e15 <insert_sorted_allocList+0x251>
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	8b 50 08             	mov    0x8(%eax),%edx
  802d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da1:	8b 40 08             	mov    0x8(%eax),%eax
  802da4:	39 c2                	cmp    %eax,%edx
  802da6:	73 6d                	jae    802e15 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802da8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dac:	74 06                	je     802db4 <insert_sorted_allocList+0x1f0>
  802dae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db2:	75 14                	jne    802dc8 <insert_sorted_allocList+0x204>
  802db4:	83 ec 04             	sub    $0x4,%esp
  802db7:	68 fc 4b 80 00       	push   $0x804bfc
  802dbc:	6a 7f                	push   $0x7f
  802dbe:	68 87 4b 80 00       	push   $0x804b87
  802dc3:	e8 fa e0 ff ff       	call   800ec2 <_panic>
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	8b 10                	mov    (%eax),%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	89 10                	mov    %edx,(%eax)
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	74 0b                	je     802de6 <insert_sorted_allocList+0x222>
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 00                	mov    (%eax),%eax
  802de0:	8b 55 08             	mov    0x8(%ebp),%edx
  802de3:	89 50 04             	mov    %edx,0x4(%eax)
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dec:	89 10                	mov    %edx,(%eax)
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df4:	89 50 04             	mov    %edx,0x4(%eax)
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	8b 00                	mov    (%eax),%eax
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	75 08                	jne    802e08 <insert_sorted_allocList+0x244>
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	a3 44 50 80 00       	mov    %eax,0x805044
  802e08:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e0d:	40                   	inc    %eax
  802e0e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802e13:	eb 39                	jmp    802e4e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802e15:	a1 48 50 80 00       	mov    0x805048,%eax
  802e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e21:	74 07                	je     802e2a <insert_sorted_allocList+0x266>
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	eb 05                	jmp    802e2f <insert_sorted_allocList+0x26b>
  802e2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2f:	a3 48 50 80 00       	mov    %eax,0x805048
  802e34:	a1 48 50 80 00       	mov    0x805048,%eax
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	0f 85 3f ff ff ff    	jne    802d80 <insert_sorted_allocList+0x1bc>
  802e41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e45:	0f 85 35 ff ff ff    	jne    802d80 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802e4b:	eb 01                	jmp    802e4e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802e4d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802e4e:	90                   	nop
  802e4f:	c9                   	leave  
  802e50:	c3                   	ret    

00802e51 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802e51:	55                   	push   %ebp
  802e52:	89 e5                	mov    %esp,%ebp
  802e54:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802e57:	a1 38 51 80 00       	mov    0x805138,%eax
  802e5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e5f:	e9 85 01 00 00       	jmp    802fe9 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e6d:	0f 82 6e 01 00 00    	jb     802fe1 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	8b 40 0c             	mov    0xc(%eax),%eax
  802e79:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e7c:	0f 85 8a 00 00 00    	jne    802f0c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802e82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e86:	75 17                	jne    802e9f <alloc_block_FF+0x4e>
  802e88:	83 ec 04             	sub    $0x4,%esp
  802e8b:	68 30 4c 80 00       	push   $0x804c30
  802e90:	68 93 00 00 00       	push   $0x93
  802e95:	68 87 4b 80 00       	push   $0x804b87
  802e9a:	e8 23 e0 ff ff       	call   800ec2 <_panic>
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	74 10                	je     802eb8 <alloc_block_FF+0x67>
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	8b 00                	mov    (%eax),%eax
  802ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb0:	8b 52 04             	mov    0x4(%edx),%edx
  802eb3:	89 50 04             	mov    %edx,0x4(%eax)
  802eb6:	eb 0b                	jmp    802ec3 <alloc_block_FF+0x72>
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 40 04             	mov    0x4(%eax),%eax
  802ebe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 40 04             	mov    0x4(%eax),%eax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	74 0f                	je     802edc <alloc_block_FF+0x8b>
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 40 04             	mov    0x4(%eax),%eax
  802ed3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed6:	8b 12                	mov    (%edx),%edx
  802ed8:	89 10                	mov    %edx,(%eax)
  802eda:	eb 0a                	jmp    802ee6 <alloc_block_FF+0x95>
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef9:	a1 44 51 80 00       	mov    0x805144,%eax
  802efe:	48                   	dec    %eax
  802eff:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	e9 10 01 00 00       	jmp    80301c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f12:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f15:	0f 86 c6 00 00 00    	jbe    802fe1 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f1b:	a1 48 51 80 00       	mov    0x805148,%eax
  802f20:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 50 08             	mov    0x8(%eax),%edx
  802f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f32:	8b 55 08             	mov    0x8(%ebp),%edx
  802f35:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f3c:	75 17                	jne    802f55 <alloc_block_FF+0x104>
  802f3e:	83 ec 04             	sub    $0x4,%esp
  802f41:	68 30 4c 80 00       	push   $0x804c30
  802f46:	68 9b 00 00 00       	push   $0x9b
  802f4b:	68 87 4b 80 00       	push   $0x804b87
  802f50:	e8 6d df ff ff       	call   800ec2 <_panic>
  802f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f58:	8b 00                	mov    (%eax),%eax
  802f5a:	85 c0                	test   %eax,%eax
  802f5c:	74 10                	je     802f6e <alloc_block_FF+0x11d>
  802f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f61:	8b 00                	mov    (%eax),%eax
  802f63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f66:	8b 52 04             	mov    0x4(%edx),%edx
  802f69:	89 50 04             	mov    %edx,0x4(%eax)
  802f6c:	eb 0b                	jmp    802f79 <alloc_block_FF+0x128>
  802f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f71:	8b 40 04             	mov    0x4(%eax),%eax
  802f74:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7c:	8b 40 04             	mov    0x4(%eax),%eax
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	74 0f                	je     802f92 <alloc_block_FF+0x141>
  802f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f86:	8b 40 04             	mov    0x4(%eax),%eax
  802f89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f8c:	8b 12                	mov    (%edx),%edx
  802f8e:	89 10                	mov    %edx,(%eax)
  802f90:	eb 0a                	jmp    802f9c <alloc_block_FF+0x14b>
  802f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f95:	8b 00                	mov    (%eax),%eax
  802f97:	a3 48 51 80 00       	mov    %eax,0x805148
  802f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802faf:	a1 54 51 80 00       	mov    0x805154,%eax
  802fb4:	48                   	dec    %eax
  802fb5:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 50 08             	mov    0x8(%eax),%edx
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	01 c2                	add    %eax,%edx
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd1:	2b 45 08             	sub    0x8(%ebp),%eax
  802fd4:	89 c2                	mov    %eax,%edx
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdf:	eb 3b                	jmp    80301c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802fe1:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fed:	74 07                	je     802ff6 <alloc_block_FF+0x1a5>
  802fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	eb 05                	jmp    802ffb <alloc_block_FF+0x1aa>
  802ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffb:	a3 40 51 80 00       	mov    %eax,0x805140
  803000:	a1 40 51 80 00       	mov    0x805140,%eax
  803005:	85 c0                	test   %eax,%eax
  803007:	0f 85 57 fe ff ff    	jne    802e64 <alloc_block_FF+0x13>
  80300d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803011:	0f 85 4d fe ff ff    	jne    802e64 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  803017:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80301c:	c9                   	leave  
  80301d:	c3                   	ret    

0080301e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80301e:	55                   	push   %ebp
  80301f:	89 e5                	mov    %esp,%ebp
  803021:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  803024:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80302b:	a1 38 51 80 00       	mov    0x805138,%eax
  803030:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803033:	e9 df 00 00 00       	jmp    803117 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 40 0c             	mov    0xc(%eax),%eax
  80303e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803041:	0f 82 c8 00 00 00    	jb     80310f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	8b 40 0c             	mov    0xc(%eax),%eax
  80304d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803050:	0f 85 8a 00 00 00    	jne    8030e0 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803056:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305a:	75 17                	jne    803073 <alloc_block_BF+0x55>
  80305c:	83 ec 04             	sub    $0x4,%esp
  80305f:	68 30 4c 80 00       	push   $0x804c30
  803064:	68 b7 00 00 00       	push   $0xb7
  803069:	68 87 4b 80 00       	push   $0x804b87
  80306e:	e8 4f de ff ff       	call   800ec2 <_panic>
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 00                	mov    (%eax),%eax
  803078:	85 c0                	test   %eax,%eax
  80307a:	74 10                	je     80308c <alloc_block_BF+0x6e>
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	8b 00                	mov    (%eax),%eax
  803081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803084:	8b 52 04             	mov    0x4(%edx),%edx
  803087:	89 50 04             	mov    %edx,0x4(%eax)
  80308a:	eb 0b                	jmp    803097 <alloc_block_BF+0x79>
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	8b 40 04             	mov    0x4(%eax),%eax
  803092:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 40 04             	mov    0x4(%eax),%eax
  80309d:	85 c0                	test   %eax,%eax
  80309f:	74 0f                	je     8030b0 <alloc_block_BF+0x92>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 40 04             	mov    0x4(%eax),%eax
  8030a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030aa:	8b 12                	mov    (%edx),%edx
  8030ac:	89 10                	mov    %edx,(%eax)
  8030ae:	eb 0a                	jmp    8030ba <alloc_block_BF+0x9c>
  8030b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b3:	8b 00                	mov    (%eax),%eax
  8030b5:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cd:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d2:	48                   	dec    %eax
  8030d3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	e9 4d 01 00 00       	jmp    80322d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8030e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030e9:	76 24                	jbe    80310f <alloc_block_BF+0xf1>
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030f4:	73 19                	jae    80310f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8030f6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	8b 40 0c             	mov    0xc(%eax),%eax
  803103:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	8b 40 08             	mov    0x8(%eax),%eax
  80310c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80310f:	a1 40 51 80 00       	mov    0x805140,%eax
  803114:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803117:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80311b:	74 07                	je     803124 <alloc_block_BF+0x106>
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	eb 05                	jmp    803129 <alloc_block_BF+0x10b>
  803124:	b8 00 00 00 00       	mov    $0x0,%eax
  803129:	a3 40 51 80 00       	mov    %eax,0x805140
  80312e:	a1 40 51 80 00       	mov    0x805140,%eax
  803133:	85 c0                	test   %eax,%eax
  803135:	0f 85 fd fe ff ff    	jne    803038 <alloc_block_BF+0x1a>
  80313b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313f:	0f 85 f3 fe ff ff    	jne    803038 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803145:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803149:	0f 84 d9 00 00 00    	je     803228 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80314f:	a1 48 51 80 00       	mov    0x805148,%eax
  803154:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80315d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803160:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803163:	8b 55 08             	mov    0x8(%ebp),%edx
  803166:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803169:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80316d:	75 17                	jne    803186 <alloc_block_BF+0x168>
  80316f:	83 ec 04             	sub    $0x4,%esp
  803172:	68 30 4c 80 00       	push   $0x804c30
  803177:	68 c7 00 00 00       	push   $0xc7
  80317c:	68 87 4b 80 00       	push   $0x804b87
  803181:	e8 3c dd ff ff       	call   800ec2 <_panic>
  803186:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803189:	8b 00                	mov    (%eax),%eax
  80318b:	85 c0                	test   %eax,%eax
  80318d:	74 10                	je     80319f <alloc_block_BF+0x181>
  80318f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803192:	8b 00                	mov    (%eax),%eax
  803194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803197:	8b 52 04             	mov    0x4(%edx),%edx
  80319a:	89 50 04             	mov    %edx,0x4(%eax)
  80319d:	eb 0b                	jmp    8031aa <alloc_block_BF+0x18c>
  80319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a2:	8b 40 04             	mov    0x4(%eax),%eax
  8031a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ad:	8b 40 04             	mov    0x4(%eax),%eax
  8031b0:	85 c0                	test   %eax,%eax
  8031b2:	74 0f                	je     8031c3 <alloc_block_BF+0x1a5>
  8031b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031bd:	8b 12                	mov    (%edx),%edx
  8031bf:	89 10                	mov    %edx,(%eax)
  8031c1:	eb 0a                	jmp    8031cd <alloc_block_BF+0x1af>
  8031c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c6:	8b 00                	mov    (%eax),%eax
  8031c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8031cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e0:	a1 54 51 80 00       	mov    0x805154,%eax
  8031e5:	48                   	dec    %eax
  8031e6:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8031eb:	83 ec 08             	sub    $0x8,%esp
  8031ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8031f1:	68 38 51 80 00       	push   $0x805138
  8031f6:	e8 71 f9 ff ff       	call   802b6c <find_block>
  8031fb:	83 c4 10             	add    $0x10,%esp
  8031fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803201:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803204:	8b 50 08             	mov    0x8(%eax),%edx
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	01 c2                	add    %eax,%edx
  80320c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803212:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803215:	8b 40 0c             	mov    0xc(%eax),%eax
  803218:	2b 45 08             	sub    0x8(%ebp),%eax
  80321b:	89 c2                	mov    %eax,%edx
  80321d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803220:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803226:	eb 05                	jmp    80322d <alloc_block_BF+0x20f>
	}
	return NULL;
  803228:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80322d:	c9                   	leave  
  80322e:	c3                   	ret    

0080322f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80322f:	55                   	push   %ebp
  803230:	89 e5                	mov    %esp,%ebp
  803232:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803235:	a1 28 50 80 00       	mov    0x805028,%eax
  80323a:	85 c0                	test   %eax,%eax
  80323c:	0f 85 de 01 00 00    	jne    803420 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803242:	a1 38 51 80 00       	mov    0x805138,%eax
  803247:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80324a:	e9 9e 01 00 00       	jmp    8033ed <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80324f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803252:	8b 40 0c             	mov    0xc(%eax),%eax
  803255:	3b 45 08             	cmp    0x8(%ebp),%eax
  803258:	0f 82 87 01 00 00    	jb     8033e5 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80325e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803261:	8b 40 0c             	mov    0xc(%eax),%eax
  803264:	3b 45 08             	cmp    0x8(%ebp),%eax
  803267:	0f 85 95 00 00 00    	jne    803302 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80326d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803271:	75 17                	jne    80328a <alloc_block_NF+0x5b>
  803273:	83 ec 04             	sub    $0x4,%esp
  803276:	68 30 4c 80 00       	push   $0x804c30
  80327b:	68 e0 00 00 00       	push   $0xe0
  803280:	68 87 4b 80 00       	push   $0x804b87
  803285:	e8 38 dc ff ff       	call   800ec2 <_panic>
  80328a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	85 c0                	test   %eax,%eax
  803291:	74 10                	je     8032a3 <alloc_block_NF+0x74>
  803293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803296:	8b 00                	mov    (%eax),%eax
  803298:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80329b:	8b 52 04             	mov    0x4(%edx),%edx
  80329e:	89 50 04             	mov    %edx,0x4(%eax)
  8032a1:	eb 0b                	jmp    8032ae <alloc_block_NF+0x7f>
  8032a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a6:	8b 40 04             	mov    0x4(%eax),%eax
  8032a9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b1:	8b 40 04             	mov    0x4(%eax),%eax
  8032b4:	85 c0                	test   %eax,%eax
  8032b6:	74 0f                	je     8032c7 <alloc_block_NF+0x98>
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	8b 40 04             	mov    0x4(%eax),%eax
  8032be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c1:	8b 12                	mov    (%edx),%edx
  8032c3:	89 10                	mov    %edx,(%eax)
  8032c5:	eb 0a                	jmp    8032d1 <alloc_block_NF+0xa2>
  8032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ca:	8b 00                	mov    (%eax),%eax
  8032cc:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e4:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e9:	48                   	dec    %eax
  8032ea:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f2:	8b 40 08             	mov    0x8(%eax),%eax
  8032f5:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fd:	e9 f8 04 00 00       	jmp    8037fa <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803305:	8b 40 0c             	mov    0xc(%eax),%eax
  803308:	3b 45 08             	cmp    0x8(%ebp),%eax
  80330b:	0f 86 d4 00 00 00    	jbe    8033e5 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803311:	a1 48 51 80 00       	mov    0x805148,%eax
  803316:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331c:	8b 50 08             	mov    0x8(%eax),%edx
  80331f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803322:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803328:	8b 55 08             	mov    0x8(%ebp),%edx
  80332b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80332e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803332:	75 17                	jne    80334b <alloc_block_NF+0x11c>
  803334:	83 ec 04             	sub    $0x4,%esp
  803337:	68 30 4c 80 00       	push   $0x804c30
  80333c:	68 e9 00 00 00       	push   $0xe9
  803341:	68 87 4b 80 00       	push   $0x804b87
  803346:	e8 77 db ff ff       	call   800ec2 <_panic>
  80334b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 10                	je     803364 <alloc_block_NF+0x135>
  803354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80335c:	8b 52 04             	mov    0x4(%edx),%edx
  80335f:	89 50 04             	mov    %edx,0x4(%eax)
  803362:	eb 0b                	jmp    80336f <alloc_block_NF+0x140>
  803364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803367:	8b 40 04             	mov    0x4(%eax),%eax
  80336a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80336f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803372:	8b 40 04             	mov    0x4(%eax),%eax
  803375:	85 c0                	test   %eax,%eax
  803377:	74 0f                	je     803388 <alloc_block_NF+0x159>
  803379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337c:	8b 40 04             	mov    0x4(%eax),%eax
  80337f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803382:	8b 12                	mov    (%edx),%edx
  803384:	89 10                	mov    %edx,(%eax)
  803386:	eb 0a                	jmp    803392 <alloc_block_NF+0x163>
  803388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338b:	8b 00                	mov    (%eax),%eax
  80338d:	a3 48 51 80 00       	mov    %eax,0x805148
  803392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803395:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a5:	a1 54 51 80 00       	mov    0x805154,%eax
  8033aa:	48                   	dec    %eax
  8033ab:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8033b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b3:	8b 40 08             	mov    0x8(%eax),%eax
  8033b6:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8033bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033be:	8b 50 08             	mov    0x8(%eax),%edx
  8033c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c4:	01 c2                	add    %eax,%edx
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d2:	2b 45 08             	sub    0x8(%ebp),%eax
  8033d5:	89 c2                	mov    %eax,%edx
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8033dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e0:	e9 15 04 00 00       	jmp    8037fa <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8033e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8033ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f1:	74 07                	je     8033fa <alloc_block_NF+0x1cb>
  8033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f6:	8b 00                	mov    (%eax),%eax
  8033f8:	eb 05                	jmp    8033ff <alloc_block_NF+0x1d0>
  8033fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ff:	a3 40 51 80 00       	mov    %eax,0x805140
  803404:	a1 40 51 80 00       	mov    0x805140,%eax
  803409:	85 c0                	test   %eax,%eax
  80340b:	0f 85 3e fe ff ff    	jne    80324f <alloc_block_NF+0x20>
  803411:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803415:	0f 85 34 fe ff ff    	jne    80324f <alloc_block_NF+0x20>
  80341b:	e9 d5 03 00 00       	jmp    8037f5 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803420:	a1 38 51 80 00       	mov    0x805138,%eax
  803425:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803428:	e9 b1 01 00 00       	jmp    8035de <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80342d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803430:	8b 50 08             	mov    0x8(%eax),%edx
  803433:	a1 28 50 80 00       	mov    0x805028,%eax
  803438:	39 c2                	cmp    %eax,%edx
  80343a:	0f 82 96 01 00 00    	jb     8035d6 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803443:	8b 40 0c             	mov    0xc(%eax),%eax
  803446:	3b 45 08             	cmp    0x8(%ebp),%eax
  803449:	0f 82 87 01 00 00    	jb     8035d6 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	8b 40 0c             	mov    0xc(%eax),%eax
  803455:	3b 45 08             	cmp    0x8(%ebp),%eax
  803458:	0f 85 95 00 00 00    	jne    8034f3 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80345e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803462:	75 17                	jne    80347b <alloc_block_NF+0x24c>
  803464:	83 ec 04             	sub    $0x4,%esp
  803467:	68 30 4c 80 00       	push   $0x804c30
  80346c:	68 fc 00 00 00       	push   $0xfc
  803471:	68 87 4b 80 00       	push   $0x804b87
  803476:	e8 47 da ff ff       	call   800ec2 <_panic>
  80347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347e:	8b 00                	mov    (%eax),%eax
  803480:	85 c0                	test   %eax,%eax
  803482:	74 10                	je     803494 <alloc_block_NF+0x265>
  803484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803487:	8b 00                	mov    (%eax),%eax
  803489:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80348c:	8b 52 04             	mov    0x4(%edx),%edx
  80348f:	89 50 04             	mov    %edx,0x4(%eax)
  803492:	eb 0b                	jmp    80349f <alloc_block_NF+0x270>
  803494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803497:	8b 40 04             	mov    0x4(%eax),%eax
  80349a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80349f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a2:	8b 40 04             	mov    0x4(%eax),%eax
  8034a5:	85 c0                	test   %eax,%eax
  8034a7:	74 0f                	je     8034b8 <alloc_block_NF+0x289>
  8034a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ac:	8b 40 04             	mov    0x4(%eax),%eax
  8034af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b2:	8b 12                	mov    (%edx),%edx
  8034b4:	89 10                	mov    %edx,(%eax)
  8034b6:	eb 0a                	jmp    8034c2 <alloc_block_NF+0x293>
  8034b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bb:	8b 00                	mov    (%eax),%eax
  8034bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8034c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8034da:	48                   	dec    %eax
  8034db:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8034e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e3:	8b 40 08             	mov    0x8(%eax),%eax
  8034e6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8034eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ee:	e9 07 03 00 00       	jmp    8037fa <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034fc:	0f 86 d4 00 00 00    	jbe    8035d6 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803502:	a1 48 51 80 00       	mov    0x805148,%eax
  803507:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80350a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350d:	8b 50 08             	mov    0x8(%eax),%edx
  803510:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803513:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803516:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803519:	8b 55 08             	mov    0x8(%ebp),%edx
  80351c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80351f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803523:	75 17                	jne    80353c <alloc_block_NF+0x30d>
  803525:	83 ec 04             	sub    $0x4,%esp
  803528:	68 30 4c 80 00       	push   $0x804c30
  80352d:	68 04 01 00 00       	push   $0x104
  803532:	68 87 4b 80 00       	push   $0x804b87
  803537:	e8 86 d9 ff ff       	call   800ec2 <_panic>
  80353c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353f:	8b 00                	mov    (%eax),%eax
  803541:	85 c0                	test   %eax,%eax
  803543:	74 10                	je     803555 <alloc_block_NF+0x326>
  803545:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80354d:	8b 52 04             	mov    0x4(%edx),%edx
  803550:	89 50 04             	mov    %edx,0x4(%eax)
  803553:	eb 0b                	jmp    803560 <alloc_block_NF+0x331>
  803555:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803558:	8b 40 04             	mov    0x4(%eax),%eax
  80355b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803560:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803563:	8b 40 04             	mov    0x4(%eax),%eax
  803566:	85 c0                	test   %eax,%eax
  803568:	74 0f                	je     803579 <alloc_block_NF+0x34a>
  80356a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356d:	8b 40 04             	mov    0x4(%eax),%eax
  803570:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803573:	8b 12                	mov    (%edx),%edx
  803575:	89 10                	mov    %edx,(%eax)
  803577:	eb 0a                	jmp    803583 <alloc_block_NF+0x354>
  803579:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357c:	8b 00                	mov    (%eax),%eax
  80357e:	a3 48 51 80 00       	mov    %eax,0x805148
  803583:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803586:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80358c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803596:	a1 54 51 80 00       	mov    0x805154,%eax
  80359b:	48                   	dec    %eax
  80359c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8035a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a4:	8b 40 08             	mov    0x8(%eax),%eax
  8035a7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8035ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035af:	8b 50 08             	mov    0x8(%eax),%edx
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	01 c2                	add    %eax,%edx
  8035b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ba:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8035bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c3:	2b 45 08             	sub    0x8(%ebp),%eax
  8035c6:	89 c2                	mov    %eax,%edx
  8035c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8035ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d1:	e9 24 02 00 00       	jmp    8037fa <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8035d6:	a1 40 51 80 00       	mov    0x805140,%eax
  8035db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e2:	74 07                	je     8035eb <alloc_block_NF+0x3bc>
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	8b 00                	mov    (%eax),%eax
  8035e9:	eb 05                	jmp    8035f0 <alloc_block_NF+0x3c1>
  8035eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f0:	a3 40 51 80 00       	mov    %eax,0x805140
  8035f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8035fa:	85 c0                	test   %eax,%eax
  8035fc:	0f 85 2b fe ff ff    	jne    80342d <alloc_block_NF+0x1fe>
  803602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803606:	0f 85 21 fe ff ff    	jne    80342d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80360c:	a1 38 51 80 00       	mov    0x805138,%eax
  803611:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803614:	e9 ae 01 00 00       	jmp    8037c7 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361c:	8b 50 08             	mov    0x8(%eax),%edx
  80361f:	a1 28 50 80 00       	mov    0x805028,%eax
  803624:	39 c2                	cmp    %eax,%edx
  803626:	0f 83 93 01 00 00    	jae    8037bf <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80362c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362f:	8b 40 0c             	mov    0xc(%eax),%eax
  803632:	3b 45 08             	cmp    0x8(%ebp),%eax
  803635:	0f 82 84 01 00 00    	jb     8037bf <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363e:	8b 40 0c             	mov    0xc(%eax),%eax
  803641:	3b 45 08             	cmp    0x8(%ebp),%eax
  803644:	0f 85 95 00 00 00    	jne    8036df <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80364a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364e:	75 17                	jne    803667 <alloc_block_NF+0x438>
  803650:	83 ec 04             	sub    $0x4,%esp
  803653:	68 30 4c 80 00       	push   $0x804c30
  803658:	68 14 01 00 00       	push   $0x114
  80365d:	68 87 4b 80 00       	push   $0x804b87
  803662:	e8 5b d8 ff ff       	call   800ec2 <_panic>
  803667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366a:	8b 00                	mov    (%eax),%eax
  80366c:	85 c0                	test   %eax,%eax
  80366e:	74 10                	je     803680 <alloc_block_NF+0x451>
  803670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803673:	8b 00                	mov    (%eax),%eax
  803675:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803678:	8b 52 04             	mov    0x4(%edx),%edx
  80367b:	89 50 04             	mov    %edx,0x4(%eax)
  80367e:	eb 0b                	jmp    80368b <alloc_block_NF+0x45c>
  803680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803683:	8b 40 04             	mov    0x4(%eax),%eax
  803686:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80368b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368e:	8b 40 04             	mov    0x4(%eax),%eax
  803691:	85 c0                	test   %eax,%eax
  803693:	74 0f                	je     8036a4 <alloc_block_NF+0x475>
  803695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803698:	8b 40 04             	mov    0x4(%eax),%eax
  80369b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80369e:	8b 12                	mov    (%edx),%edx
  8036a0:	89 10                	mov    %edx,(%eax)
  8036a2:	eb 0a                	jmp    8036ae <alloc_block_NF+0x47f>
  8036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a7:	8b 00                	mov    (%eax),%eax
  8036a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8036c6:	48                   	dec    %eax
  8036c7:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8036cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cf:	8b 40 08             	mov    0x8(%eax),%eax
  8036d2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8036d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036da:	e9 1b 01 00 00       	jmp    8037fa <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8036df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8036e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036e8:	0f 86 d1 00 00 00    	jbe    8037bf <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8036ee:	a1 48 51 80 00       	mov    0x805148,%eax
  8036f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8036f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f9:	8b 50 08             	mov    0x8(%eax),%edx
  8036fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ff:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803702:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803705:	8b 55 08             	mov    0x8(%ebp),%edx
  803708:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80370b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80370f:	75 17                	jne    803728 <alloc_block_NF+0x4f9>
  803711:	83 ec 04             	sub    $0x4,%esp
  803714:	68 30 4c 80 00       	push   $0x804c30
  803719:	68 1c 01 00 00       	push   $0x11c
  80371e:	68 87 4b 80 00       	push   $0x804b87
  803723:	e8 9a d7 ff ff       	call   800ec2 <_panic>
  803728:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372b:	8b 00                	mov    (%eax),%eax
  80372d:	85 c0                	test   %eax,%eax
  80372f:	74 10                	je     803741 <alloc_block_NF+0x512>
  803731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803734:	8b 00                	mov    (%eax),%eax
  803736:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803739:	8b 52 04             	mov    0x4(%edx),%edx
  80373c:	89 50 04             	mov    %edx,0x4(%eax)
  80373f:	eb 0b                	jmp    80374c <alloc_block_NF+0x51d>
  803741:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803744:	8b 40 04             	mov    0x4(%eax),%eax
  803747:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80374c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80374f:	8b 40 04             	mov    0x4(%eax),%eax
  803752:	85 c0                	test   %eax,%eax
  803754:	74 0f                	je     803765 <alloc_block_NF+0x536>
  803756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803759:	8b 40 04             	mov    0x4(%eax),%eax
  80375c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80375f:	8b 12                	mov    (%edx),%edx
  803761:	89 10                	mov    %edx,(%eax)
  803763:	eb 0a                	jmp    80376f <alloc_block_NF+0x540>
  803765:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803768:	8b 00                	mov    (%eax),%eax
  80376a:	a3 48 51 80 00       	mov    %eax,0x805148
  80376f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803772:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803782:	a1 54 51 80 00       	mov    0x805154,%eax
  803787:	48                   	dec    %eax
  803788:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80378d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803790:	8b 40 08             	mov    0x8(%eax),%eax
  803793:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379b:	8b 50 08             	mov    0x8(%eax),%edx
  80379e:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a1:	01 c2                	add    %eax,%edx
  8037a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8037a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8037af:	2b 45 08             	sub    0x8(%ebp),%eax
  8037b2:	89 c2                	mov    %eax,%edx
  8037b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8037ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037bd:	eb 3b                	jmp    8037fa <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8037bf:	a1 40 51 80 00       	mov    0x805140,%eax
  8037c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037cb:	74 07                	je     8037d4 <alloc_block_NF+0x5a5>
  8037cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d0:	8b 00                	mov    (%eax),%eax
  8037d2:	eb 05                	jmp    8037d9 <alloc_block_NF+0x5aa>
  8037d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8037d9:	a3 40 51 80 00       	mov    %eax,0x805140
  8037de:	a1 40 51 80 00       	mov    0x805140,%eax
  8037e3:	85 c0                	test   %eax,%eax
  8037e5:	0f 85 2e fe ff ff    	jne    803619 <alloc_block_NF+0x3ea>
  8037eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ef:	0f 85 24 fe ff ff    	jne    803619 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8037f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037fa:	c9                   	leave  
  8037fb:	c3                   	ret    

008037fc <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8037fc:	55                   	push   %ebp
  8037fd:	89 e5                	mov    %esp,%ebp
  8037ff:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803802:	a1 38 51 80 00       	mov    0x805138,%eax
  803807:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80380a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80380f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803812:	a1 38 51 80 00       	mov    0x805138,%eax
  803817:	85 c0                	test   %eax,%eax
  803819:	74 14                	je     80382f <insert_sorted_with_merge_freeList+0x33>
  80381b:	8b 45 08             	mov    0x8(%ebp),%eax
  80381e:	8b 50 08             	mov    0x8(%eax),%edx
  803821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803824:	8b 40 08             	mov    0x8(%eax),%eax
  803827:	39 c2                	cmp    %eax,%edx
  803829:	0f 87 9b 01 00 00    	ja     8039ca <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80382f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803833:	75 17                	jne    80384c <insert_sorted_with_merge_freeList+0x50>
  803835:	83 ec 04             	sub    $0x4,%esp
  803838:	68 64 4b 80 00       	push   $0x804b64
  80383d:	68 38 01 00 00       	push   $0x138
  803842:	68 87 4b 80 00       	push   $0x804b87
  803847:	e8 76 d6 ff ff       	call   800ec2 <_panic>
  80384c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803852:	8b 45 08             	mov    0x8(%ebp),%eax
  803855:	89 10                	mov    %edx,(%eax)
  803857:	8b 45 08             	mov    0x8(%ebp),%eax
  80385a:	8b 00                	mov    (%eax),%eax
  80385c:	85 c0                	test   %eax,%eax
  80385e:	74 0d                	je     80386d <insert_sorted_with_merge_freeList+0x71>
  803860:	a1 38 51 80 00       	mov    0x805138,%eax
  803865:	8b 55 08             	mov    0x8(%ebp),%edx
  803868:	89 50 04             	mov    %edx,0x4(%eax)
  80386b:	eb 08                	jmp    803875 <insert_sorted_with_merge_freeList+0x79>
  80386d:	8b 45 08             	mov    0x8(%ebp),%eax
  803870:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803875:	8b 45 08             	mov    0x8(%ebp),%eax
  803878:	a3 38 51 80 00       	mov    %eax,0x805138
  80387d:	8b 45 08             	mov    0x8(%ebp),%eax
  803880:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803887:	a1 44 51 80 00       	mov    0x805144,%eax
  80388c:	40                   	inc    %eax
  80388d:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803892:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803896:	0f 84 a8 06 00 00    	je     803f44 <insert_sorted_with_merge_freeList+0x748>
  80389c:	8b 45 08             	mov    0x8(%ebp),%eax
  80389f:	8b 50 08             	mov    0x8(%eax),%edx
  8038a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8038a8:	01 c2                	add    %eax,%edx
  8038aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ad:	8b 40 08             	mov    0x8(%eax),%eax
  8038b0:	39 c2                	cmp    %eax,%edx
  8038b2:	0f 85 8c 06 00 00    	jne    803f44 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8038b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8038be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c4:	01 c2                	add    %eax,%edx
  8038c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c9:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8038cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038d0:	75 17                	jne    8038e9 <insert_sorted_with_merge_freeList+0xed>
  8038d2:	83 ec 04             	sub    $0x4,%esp
  8038d5:	68 30 4c 80 00       	push   $0x804c30
  8038da:	68 3c 01 00 00       	push   $0x13c
  8038df:	68 87 4b 80 00       	push   $0x804b87
  8038e4:	e8 d9 d5 ff ff       	call   800ec2 <_panic>
  8038e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ec:	8b 00                	mov    (%eax),%eax
  8038ee:	85 c0                	test   %eax,%eax
  8038f0:	74 10                	je     803902 <insert_sorted_with_merge_freeList+0x106>
  8038f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f5:	8b 00                	mov    (%eax),%eax
  8038f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038fa:	8b 52 04             	mov    0x4(%edx),%edx
  8038fd:	89 50 04             	mov    %edx,0x4(%eax)
  803900:	eb 0b                	jmp    80390d <insert_sorted_with_merge_freeList+0x111>
  803902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803905:	8b 40 04             	mov    0x4(%eax),%eax
  803908:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80390d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803910:	8b 40 04             	mov    0x4(%eax),%eax
  803913:	85 c0                	test   %eax,%eax
  803915:	74 0f                	je     803926 <insert_sorted_with_merge_freeList+0x12a>
  803917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391a:	8b 40 04             	mov    0x4(%eax),%eax
  80391d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803920:	8b 12                	mov    (%edx),%edx
  803922:	89 10                	mov    %edx,(%eax)
  803924:	eb 0a                	jmp    803930 <insert_sorted_with_merge_freeList+0x134>
  803926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803929:	8b 00                	mov    (%eax),%eax
  80392b:	a3 38 51 80 00       	mov    %eax,0x805138
  803930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803933:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803943:	a1 44 51 80 00       	mov    0x805144,%eax
  803948:	48                   	dec    %eax
  803949:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80394e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803951:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803958:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803962:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803966:	75 17                	jne    80397f <insert_sorted_with_merge_freeList+0x183>
  803968:	83 ec 04             	sub    $0x4,%esp
  80396b:	68 64 4b 80 00       	push   $0x804b64
  803970:	68 3f 01 00 00       	push   $0x13f
  803975:	68 87 4b 80 00       	push   $0x804b87
  80397a:	e8 43 d5 ff ff       	call   800ec2 <_panic>
  80397f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803988:	89 10                	mov    %edx,(%eax)
  80398a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80398d:	8b 00                	mov    (%eax),%eax
  80398f:	85 c0                	test   %eax,%eax
  803991:	74 0d                	je     8039a0 <insert_sorted_with_merge_freeList+0x1a4>
  803993:	a1 48 51 80 00       	mov    0x805148,%eax
  803998:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80399b:	89 50 04             	mov    %edx,0x4(%eax)
  80399e:	eb 08                	jmp    8039a8 <insert_sorted_with_merge_freeList+0x1ac>
  8039a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8039b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8039bf:	40                   	inc    %eax
  8039c0:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8039c5:	e9 7a 05 00 00       	jmp    803f44 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cd:	8b 50 08             	mov    0x8(%eax),%edx
  8039d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039d3:	8b 40 08             	mov    0x8(%eax),%eax
  8039d6:	39 c2                	cmp    %eax,%edx
  8039d8:	0f 82 14 01 00 00    	jb     803af2 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8039de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039e1:	8b 50 08             	mov    0x8(%eax),%edx
  8039e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8039ea:	01 c2                	add    %eax,%edx
  8039ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ef:	8b 40 08             	mov    0x8(%eax),%eax
  8039f2:	39 c2                	cmp    %eax,%edx
  8039f4:	0f 85 90 00 00 00    	jne    803a8a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8039fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039fd:	8b 50 0c             	mov    0xc(%eax),%edx
  803a00:	8b 45 08             	mov    0x8(%ebp),%eax
  803a03:	8b 40 0c             	mov    0xc(%eax),%eax
  803a06:	01 c2                	add    %eax,%edx
  803a08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a0b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a11:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803a18:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a26:	75 17                	jne    803a3f <insert_sorted_with_merge_freeList+0x243>
  803a28:	83 ec 04             	sub    $0x4,%esp
  803a2b:	68 64 4b 80 00       	push   $0x804b64
  803a30:	68 49 01 00 00       	push   $0x149
  803a35:	68 87 4b 80 00       	push   $0x804b87
  803a3a:	e8 83 d4 ff ff       	call   800ec2 <_panic>
  803a3f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a45:	8b 45 08             	mov    0x8(%ebp),%eax
  803a48:	89 10                	mov    %edx,(%eax)
  803a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4d:	8b 00                	mov    (%eax),%eax
  803a4f:	85 c0                	test   %eax,%eax
  803a51:	74 0d                	je     803a60 <insert_sorted_with_merge_freeList+0x264>
  803a53:	a1 48 51 80 00       	mov    0x805148,%eax
  803a58:	8b 55 08             	mov    0x8(%ebp),%edx
  803a5b:	89 50 04             	mov    %edx,0x4(%eax)
  803a5e:	eb 08                	jmp    803a68 <insert_sorted_with_merge_freeList+0x26c>
  803a60:	8b 45 08             	mov    0x8(%ebp),%eax
  803a63:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a68:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6b:	a3 48 51 80 00       	mov    %eax,0x805148
  803a70:	8b 45 08             	mov    0x8(%ebp),%eax
  803a73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a7a:	a1 54 51 80 00       	mov    0x805154,%eax
  803a7f:	40                   	inc    %eax
  803a80:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a85:	e9 bb 04 00 00       	jmp    803f45 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803a8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a8e:	75 17                	jne    803aa7 <insert_sorted_with_merge_freeList+0x2ab>
  803a90:	83 ec 04             	sub    $0x4,%esp
  803a93:	68 d8 4b 80 00       	push   $0x804bd8
  803a98:	68 4c 01 00 00       	push   $0x14c
  803a9d:	68 87 4b 80 00       	push   $0x804b87
  803aa2:	e8 1b d4 ff ff       	call   800ec2 <_panic>
  803aa7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803aad:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab0:	89 50 04             	mov    %edx,0x4(%eax)
  803ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab6:	8b 40 04             	mov    0x4(%eax),%eax
  803ab9:	85 c0                	test   %eax,%eax
  803abb:	74 0c                	je     803ac9 <insert_sorted_with_merge_freeList+0x2cd>
  803abd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803ac2:	8b 55 08             	mov    0x8(%ebp),%edx
  803ac5:	89 10                	mov    %edx,(%eax)
  803ac7:	eb 08                	jmp    803ad1 <insert_sorted_with_merge_freeList+0x2d5>
  803ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  803acc:	a3 38 51 80 00       	mov    %eax,0x805138
  803ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  803adc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ae2:	a1 44 51 80 00       	mov    0x805144,%eax
  803ae7:	40                   	inc    %eax
  803ae8:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803aed:	e9 53 04 00 00       	jmp    803f45 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803af2:	a1 38 51 80 00       	mov    0x805138,%eax
  803af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803afa:	e9 15 04 00 00       	jmp    803f14 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b02:	8b 00                	mov    (%eax),%eax
  803b04:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803b07:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0a:	8b 50 08             	mov    0x8(%eax),%edx
  803b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b10:	8b 40 08             	mov    0x8(%eax),%eax
  803b13:	39 c2                	cmp    %eax,%edx
  803b15:	0f 86 f1 03 00 00    	jbe    803f0c <insert_sorted_with_merge_freeList+0x710>
  803b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1e:	8b 50 08             	mov    0x8(%eax),%edx
  803b21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b24:	8b 40 08             	mov    0x8(%eax),%eax
  803b27:	39 c2                	cmp    %eax,%edx
  803b29:	0f 83 dd 03 00 00    	jae    803f0c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b32:	8b 50 08             	mov    0x8(%eax),%edx
  803b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b38:	8b 40 0c             	mov    0xc(%eax),%eax
  803b3b:	01 c2                	add    %eax,%edx
  803b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b40:	8b 40 08             	mov    0x8(%eax),%eax
  803b43:	39 c2                	cmp    %eax,%edx
  803b45:	0f 85 b9 01 00 00    	jne    803d04 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4e:	8b 50 08             	mov    0x8(%eax),%edx
  803b51:	8b 45 08             	mov    0x8(%ebp),%eax
  803b54:	8b 40 0c             	mov    0xc(%eax),%eax
  803b57:	01 c2                	add    %eax,%edx
  803b59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b5c:	8b 40 08             	mov    0x8(%eax),%eax
  803b5f:	39 c2                	cmp    %eax,%edx
  803b61:	0f 85 0d 01 00 00    	jne    803c74 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6a:	8b 50 0c             	mov    0xc(%eax),%edx
  803b6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b70:	8b 40 0c             	mov    0xc(%eax),%eax
  803b73:	01 c2                	add    %eax,%edx
  803b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b78:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b7b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b7f:	75 17                	jne    803b98 <insert_sorted_with_merge_freeList+0x39c>
  803b81:	83 ec 04             	sub    $0x4,%esp
  803b84:	68 30 4c 80 00       	push   $0x804c30
  803b89:	68 5c 01 00 00       	push   $0x15c
  803b8e:	68 87 4b 80 00       	push   $0x804b87
  803b93:	e8 2a d3 ff ff       	call   800ec2 <_panic>
  803b98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b9b:	8b 00                	mov    (%eax),%eax
  803b9d:	85 c0                	test   %eax,%eax
  803b9f:	74 10                	je     803bb1 <insert_sorted_with_merge_freeList+0x3b5>
  803ba1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba4:	8b 00                	mov    (%eax),%eax
  803ba6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ba9:	8b 52 04             	mov    0x4(%edx),%edx
  803bac:	89 50 04             	mov    %edx,0x4(%eax)
  803baf:	eb 0b                	jmp    803bbc <insert_sorted_with_merge_freeList+0x3c0>
  803bb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb4:	8b 40 04             	mov    0x4(%eax),%eax
  803bb7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bbf:	8b 40 04             	mov    0x4(%eax),%eax
  803bc2:	85 c0                	test   %eax,%eax
  803bc4:	74 0f                	je     803bd5 <insert_sorted_with_merge_freeList+0x3d9>
  803bc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc9:	8b 40 04             	mov    0x4(%eax),%eax
  803bcc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bcf:	8b 12                	mov    (%edx),%edx
  803bd1:	89 10                	mov    %edx,(%eax)
  803bd3:	eb 0a                	jmp    803bdf <insert_sorted_with_merge_freeList+0x3e3>
  803bd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd8:	8b 00                	mov    (%eax),%eax
  803bda:	a3 38 51 80 00       	mov    %eax,0x805138
  803bdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803beb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bf2:	a1 44 51 80 00       	mov    0x805144,%eax
  803bf7:	48                   	dec    %eax
  803bf8:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803bfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803c07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803c11:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c15:	75 17                	jne    803c2e <insert_sorted_with_merge_freeList+0x432>
  803c17:	83 ec 04             	sub    $0x4,%esp
  803c1a:	68 64 4b 80 00       	push   $0x804b64
  803c1f:	68 5f 01 00 00       	push   $0x15f
  803c24:	68 87 4b 80 00       	push   $0x804b87
  803c29:	e8 94 d2 ff ff       	call   800ec2 <_panic>
  803c2e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c37:	89 10                	mov    %edx,(%eax)
  803c39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c3c:	8b 00                	mov    (%eax),%eax
  803c3e:	85 c0                	test   %eax,%eax
  803c40:	74 0d                	je     803c4f <insert_sorted_with_merge_freeList+0x453>
  803c42:	a1 48 51 80 00       	mov    0x805148,%eax
  803c47:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c4a:	89 50 04             	mov    %edx,0x4(%eax)
  803c4d:	eb 08                	jmp    803c57 <insert_sorted_with_merge_freeList+0x45b>
  803c4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c52:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5a:	a3 48 51 80 00       	mov    %eax,0x805148
  803c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c69:	a1 54 51 80 00       	mov    0x805154,%eax
  803c6e:	40                   	inc    %eax
  803c6f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c77:	8b 50 0c             	mov    0xc(%eax),%edx
  803c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7d:	8b 40 0c             	mov    0xc(%eax),%eax
  803c80:	01 c2                	add    %eax,%edx
  803c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c85:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803c88:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803c92:	8b 45 08             	mov    0x8(%ebp),%eax
  803c95:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803c9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ca0:	75 17                	jne    803cb9 <insert_sorted_with_merge_freeList+0x4bd>
  803ca2:	83 ec 04             	sub    $0x4,%esp
  803ca5:	68 64 4b 80 00       	push   $0x804b64
  803caa:	68 64 01 00 00       	push   $0x164
  803caf:	68 87 4b 80 00       	push   $0x804b87
  803cb4:	e8 09 d2 ff ff       	call   800ec2 <_panic>
  803cb9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc2:	89 10                	mov    %edx,(%eax)
  803cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc7:	8b 00                	mov    (%eax),%eax
  803cc9:	85 c0                	test   %eax,%eax
  803ccb:	74 0d                	je     803cda <insert_sorted_with_merge_freeList+0x4de>
  803ccd:	a1 48 51 80 00       	mov    0x805148,%eax
  803cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  803cd5:	89 50 04             	mov    %edx,0x4(%eax)
  803cd8:	eb 08                	jmp    803ce2 <insert_sorted_with_merge_freeList+0x4e6>
  803cda:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce5:	a3 48 51 80 00       	mov    %eax,0x805148
  803cea:	8b 45 08             	mov    0x8(%ebp),%eax
  803ced:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cf4:	a1 54 51 80 00       	mov    0x805154,%eax
  803cf9:	40                   	inc    %eax
  803cfa:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803cff:	e9 41 02 00 00       	jmp    803f45 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803d04:	8b 45 08             	mov    0x8(%ebp),%eax
  803d07:	8b 50 08             	mov    0x8(%eax),%edx
  803d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  803d10:	01 c2                	add    %eax,%edx
  803d12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d15:	8b 40 08             	mov    0x8(%eax),%eax
  803d18:	39 c2                	cmp    %eax,%edx
  803d1a:	0f 85 7c 01 00 00    	jne    803e9c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803d20:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d24:	74 06                	je     803d2c <insert_sorted_with_merge_freeList+0x530>
  803d26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d2a:	75 17                	jne    803d43 <insert_sorted_with_merge_freeList+0x547>
  803d2c:	83 ec 04             	sub    $0x4,%esp
  803d2f:	68 a0 4b 80 00       	push   $0x804ba0
  803d34:	68 69 01 00 00       	push   $0x169
  803d39:	68 87 4b 80 00       	push   $0x804b87
  803d3e:	e8 7f d1 ff ff       	call   800ec2 <_panic>
  803d43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d46:	8b 50 04             	mov    0x4(%eax),%edx
  803d49:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4c:	89 50 04             	mov    %edx,0x4(%eax)
  803d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d55:	89 10                	mov    %edx,(%eax)
  803d57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d5a:	8b 40 04             	mov    0x4(%eax),%eax
  803d5d:	85 c0                	test   %eax,%eax
  803d5f:	74 0d                	je     803d6e <insert_sorted_with_merge_freeList+0x572>
  803d61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d64:	8b 40 04             	mov    0x4(%eax),%eax
  803d67:	8b 55 08             	mov    0x8(%ebp),%edx
  803d6a:	89 10                	mov    %edx,(%eax)
  803d6c:	eb 08                	jmp    803d76 <insert_sorted_with_merge_freeList+0x57a>
  803d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d71:	a3 38 51 80 00       	mov    %eax,0x805138
  803d76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d79:	8b 55 08             	mov    0x8(%ebp),%edx
  803d7c:	89 50 04             	mov    %edx,0x4(%eax)
  803d7f:	a1 44 51 80 00       	mov    0x805144,%eax
  803d84:	40                   	inc    %eax
  803d85:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8d:	8b 50 0c             	mov    0xc(%eax),%edx
  803d90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d93:	8b 40 0c             	mov    0xc(%eax),%eax
  803d96:	01 c2                	add    %eax,%edx
  803d98:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803d9e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803da2:	75 17                	jne    803dbb <insert_sorted_with_merge_freeList+0x5bf>
  803da4:	83 ec 04             	sub    $0x4,%esp
  803da7:	68 30 4c 80 00       	push   $0x804c30
  803dac:	68 6b 01 00 00       	push   $0x16b
  803db1:	68 87 4b 80 00       	push   $0x804b87
  803db6:	e8 07 d1 ff ff       	call   800ec2 <_panic>
  803dbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dbe:	8b 00                	mov    (%eax),%eax
  803dc0:	85 c0                	test   %eax,%eax
  803dc2:	74 10                	je     803dd4 <insert_sorted_with_merge_freeList+0x5d8>
  803dc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dc7:	8b 00                	mov    (%eax),%eax
  803dc9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803dcc:	8b 52 04             	mov    0x4(%edx),%edx
  803dcf:	89 50 04             	mov    %edx,0x4(%eax)
  803dd2:	eb 0b                	jmp    803ddf <insert_sorted_with_merge_freeList+0x5e3>
  803dd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dd7:	8b 40 04             	mov    0x4(%eax),%eax
  803dda:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ddf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803de2:	8b 40 04             	mov    0x4(%eax),%eax
  803de5:	85 c0                	test   %eax,%eax
  803de7:	74 0f                	je     803df8 <insert_sorted_with_merge_freeList+0x5fc>
  803de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dec:	8b 40 04             	mov    0x4(%eax),%eax
  803def:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803df2:	8b 12                	mov    (%edx),%edx
  803df4:	89 10                	mov    %edx,(%eax)
  803df6:	eb 0a                	jmp    803e02 <insert_sorted_with_merge_freeList+0x606>
  803df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dfb:	8b 00                	mov    (%eax),%eax
  803dfd:	a3 38 51 80 00       	mov    %eax,0x805138
  803e02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e15:	a1 44 51 80 00       	mov    0x805144,%eax
  803e1a:	48                   	dec    %eax
  803e1b:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803e20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803e2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e2d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803e34:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803e38:	75 17                	jne    803e51 <insert_sorted_with_merge_freeList+0x655>
  803e3a:	83 ec 04             	sub    $0x4,%esp
  803e3d:	68 64 4b 80 00       	push   $0x804b64
  803e42:	68 6e 01 00 00       	push   $0x16e
  803e47:	68 87 4b 80 00       	push   $0x804b87
  803e4c:	e8 71 d0 ff ff       	call   800ec2 <_panic>
  803e51:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803e57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e5a:	89 10                	mov    %edx,(%eax)
  803e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e5f:	8b 00                	mov    (%eax),%eax
  803e61:	85 c0                	test   %eax,%eax
  803e63:	74 0d                	je     803e72 <insert_sorted_with_merge_freeList+0x676>
  803e65:	a1 48 51 80 00       	mov    0x805148,%eax
  803e6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e6d:	89 50 04             	mov    %edx,0x4(%eax)
  803e70:	eb 08                	jmp    803e7a <insert_sorted_with_merge_freeList+0x67e>
  803e72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e75:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803e7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e7d:	a3 48 51 80 00       	mov    %eax,0x805148
  803e82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e8c:	a1 54 51 80 00       	mov    0x805154,%eax
  803e91:	40                   	inc    %eax
  803e92:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803e97:	e9 a9 00 00 00       	jmp    803f45 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803e9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ea0:	74 06                	je     803ea8 <insert_sorted_with_merge_freeList+0x6ac>
  803ea2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ea6:	75 17                	jne    803ebf <insert_sorted_with_merge_freeList+0x6c3>
  803ea8:	83 ec 04             	sub    $0x4,%esp
  803eab:	68 fc 4b 80 00       	push   $0x804bfc
  803eb0:	68 73 01 00 00       	push   $0x173
  803eb5:	68 87 4b 80 00       	push   $0x804b87
  803eba:	e8 03 d0 ff ff       	call   800ec2 <_panic>
  803ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec2:	8b 10                	mov    (%eax),%edx
  803ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec7:	89 10                	mov    %edx,(%eax)
  803ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  803ecc:	8b 00                	mov    (%eax),%eax
  803ece:	85 c0                	test   %eax,%eax
  803ed0:	74 0b                	je     803edd <insert_sorted_with_merge_freeList+0x6e1>
  803ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed5:	8b 00                	mov    (%eax),%eax
  803ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  803eda:	89 50 04             	mov    %edx,0x4(%eax)
  803edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  803ee3:	89 10                	mov    %edx,(%eax)
  803ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803eeb:	89 50 04             	mov    %edx,0x4(%eax)
  803eee:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef1:	8b 00                	mov    (%eax),%eax
  803ef3:	85 c0                	test   %eax,%eax
  803ef5:	75 08                	jne    803eff <insert_sorted_with_merge_freeList+0x703>
  803ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  803efa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803eff:	a1 44 51 80 00       	mov    0x805144,%eax
  803f04:	40                   	inc    %eax
  803f05:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803f0a:	eb 39                	jmp    803f45 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803f0c:	a1 40 51 80 00       	mov    0x805140,%eax
  803f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f18:	74 07                	je     803f21 <insert_sorted_with_merge_freeList+0x725>
  803f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f1d:	8b 00                	mov    (%eax),%eax
  803f1f:	eb 05                	jmp    803f26 <insert_sorted_with_merge_freeList+0x72a>
  803f21:	b8 00 00 00 00       	mov    $0x0,%eax
  803f26:	a3 40 51 80 00       	mov    %eax,0x805140
  803f2b:	a1 40 51 80 00       	mov    0x805140,%eax
  803f30:	85 c0                	test   %eax,%eax
  803f32:	0f 85 c7 fb ff ff    	jne    803aff <insert_sorted_with_merge_freeList+0x303>
  803f38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f3c:	0f 85 bd fb ff ff    	jne    803aff <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803f42:	eb 01                	jmp    803f45 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803f44:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803f45:	90                   	nop
  803f46:	c9                   	leave  
  803f47:	c3                   	ret    

00803f48 <__udivdi3>:
  803f48:	55                   	push   %ebp
  803f49:	57                   	push   %edi
  803f4a:	56                   	push   %esi
  803f4b:	53                   	push   %ebx
  803f4c:	83 ec 1c             	sub    $0x1c,%esp
  803f4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f5f:	89 ca                	mov    %ecx,%edx
  803f61:	89 f8                	mov    %edi,%eax
  803f63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f67:	85 f6                	test   %esi,%esi
  803f69:	75 2d                	jne    803f98 <__udivdi3+0x50>
  803f6b:	39 cf                	cmp    %ecx,%edi
  803f6d:	77 65                	ja     803fd4 <__udivdi3+0x8c>
  803f6f:	89 fd                	mov    %edi,%ebp
  803f71:	85 ff                	test   %edi,%edi
  803f73:	75 0b                	jne    803f80 <__udivdi3+0x38>
  803f75:	b8 01 00 00 00       	mov    $0x1,%eax
  803f7a:	31 d2                	xor    %edx,%edx
  803f7c:	f7 f7                	div    %edi
  803f7e:	89 c5                	mov    %eax,%ebp
  803f80:	31 d2                	xor    %edx,%edx
  803f82:	89 c8                	mov    %ecx,%eax
  803f84:	f7 f5                	div    %ebp
  803f86:	89 c1                	mov    %eax,%ecx
  803f88:	89 d8                	mov    %ebx,%eax
  803f8a:	f7 f5                	div    %ebp
  803f8c:	89 cf                	mov    %ecx,%edi
  803f8e:	89 fa                	mov    %edi,%edx
  803f90:	83 c4 1c             	add    $0x1c,%esp
  803f93:	5b                   	pop    %ebx
  803f94:	5e                   	pop    %esi
  803f95:	5f                   	pop    %edi
  803f96:	5d                   	pop    %ebp
  803f97:	c3                   	ret    
  803f98:	39 ce                	cmp    %ecx,%esi
  803f9a:	77 28                	ja     803fc4 <__udivdi3+0x7c>
  803f9c:	0f bd fe             	bsr    %esi,%edi
  803f9f:	83 f7 1f             	xor    $0x1f,%edi
  803fa2:	75 40                	jne    803fe4 <__udivdi3+0x9c>
  803fa4:	39 ce                	cmp    %ecx,%esi
  803fa6:	72 0a                	jb     803fb2 <__udivdi3+0x6a>
  803fa8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fac:	0f 87 9e 00 00 00    	ja     804050 <__udivdi3+0x108>
  803fb2:	b8 01 00 00 00       	mov    $0x1,%eax
  803fb7:	89 fa                	mov    %edi,%edx
  803fb9:	83 c4 1c             	add    $0x1c,%esp
  803fbc:	5b                   	pop    %ebx
  803fbd:	5e                   	pop    %esi
  803fbe:	5f                   	pop    %edi
  803fbf:	5d                   	pop    %ebp
  803fc0:	c3                   	ret    
  803fc1:	8d 76 00             	lea    0x0(%esi),%esi
  803fc4:	31 ff                	xor    %edi,%edi
  803fc6:	31 c0                	xor    %eax,%eax
  803fc8:	89 fa                	mov    %edi,%edx
  803fca:	83 c4 1c             	add    $0x1c,%esp
  803fcd:	5b                   	pop    %ebx
  803fce:	5e                   	pop    %esi
  803fcf:	5f                   	pop    %edi
  803fd0:	5d                   	pop    %ebp
  803fd1:	c3                   	ret    
  803fd2:	66 90                	xchg   %ax,%ax
  803fd4:	89 d8                	mov    %ebx,%eax
  803fd6:	f7 f7                	div    %edi
  803fd8:	31 ff                	xor    %edi,%edi
  803fda:	89 fa                	mov    %edi,%edx
  803fdc:	83 c4 1c             	add    $0x1c,%esp
  803fdf:	5b                   	pop    %ebx
  803fe0:	5e                   	pop    %esi
  803fe1:	5f                   	pop    %edi
  803fe2:	5d                   	pop    %ebp
  803fe3:	c3                   	ret    
  803fe4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803fe9:	89 eb                	mov    %ebp,%ebx
  803feb:	29 fb                	sub    %edi,%ebx
  803fed:	89 f9                	mov    %edi,%ecx
  803fef:	d3 e6                	shl    %cl,%esi
  803ff1:	89 c5                	mov    %eax,%ebp
  803ff3:	88 d9                	mov    %bl,%cl
  803ff5:	d3 ed                	shr    %cl,%ebp
  803ff7:	89 e9                	mov    %ebp,%ecx
  803ff9:	09 f1                	or     %esi,%ecx
  803ffb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803fff:	89 f9                	mov    %edi,%ecx
  804001:	d3 e0                	shl    %cl,%eax
  804003:	89 c5                	mov    %eax,%ebp
  804005:	89 d6                	mov    %edx,%esi
  804007:	88 d9                	mov    %bl,%cl
  804009:	d3 ee                	shr    %cl,%esi
  80400b:	89 f9                	mov    %edi,%ecx
  80400d:	d3 e2                	shl    %cl,%edx
  80400f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804013:	88 d9                	mov    %bl,%cl
  804015:	d3 e8                	shr    %cl,%eax
  804017:	09 c2                	or     %eax,%edx
  804019:	89 d0                	mov    %edx,%eax
  80401b:	89 f2                	mov    %esi,%edx
  80401d:	f7 74 24 0c          	divl   0xc(%esp)
  804021:	89 d6                	mov    %edx,%esi
  804023:	89 c3                	mov    %eax,%ebx
  804025:	f7 e5                	mul    %ebp
  804027:	39 d6                	cmp    %edx,%esi
  804029:	72 19                	jb     804044 <__udivdi3+0xfc>
  80402b:	74 0b                	je     804038 <__udivdi3+0xf0>
  80402d:	89 d8                	mov    %ebx,%eax
  80402f:	31 ff                	xor    %edi,%edi
  804031:	e9 58 ff ff ff       	jmp    803f8e <__udivdi3+0x46>
  804036:	66 90                	xchg   %ax,%ax
  804038:	8b 54 24 08          	mov    0x8(%esp),%edx
  80403c:	89 f9                	mov    %edi,%ecx
  80403e:	d3 e2                	shl    %cl,%edx
  804040:	39 c2                	cmp    %eax,%edx
  804042:	73 e9                	jae    80402d <__udivdi3+0xe5>
  804044:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804047:	31 ff                	xor    %edi,%edi
  804049:	e9 40 ff ff ff       	jmp    803f8e <__udivdi3+0x46>
  80404e:	66 90                	xchg   %ax,%ax
  804050:	31 c0                	xor    %eax,%eax
  804052:	e9 37 ff ff ff       	jmp    803f8e <__udivdi3+0x46>
  804057:	90                   	nop

00804058 <__umoddi3>:
  804058:	55                   	push   %ebp
  804059:	57                   	push   %edi
  80405a:	56                   	push   %esi
  80405b:	53                   	push   %ebx
  80405c:	83 ec 1c             	sub    $0x1c,%esp
  80405f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804063:	8b 74 24 34          	mov    0x34(%esp),%esi
  804067:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80406b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80406f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804073:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804077:	89 f3                	mov    %esi,%ebx
  804079:	89 fa                	mov    %edi,%edx
  80407b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80407f:	89 34 24             	mov    %esi,(%esp)
  804082:	85 c0                	test   %eax,%eax
  804084:	75 1a                	jne    8040a0 <__umoddi3+0x48>
  804086:	39 f7                	cmp    %esi,%edi
  804088:	0f 86 a2 00 00 00    	jbe    804130 <__umoddi3+0xd8>
  80408e:	89 c8                	mov    %ecx,%eax
  804090:	89 f2                	mov    %esi,%edx
  804092:	f7 f7                	div    %edi
  804094:	89 d0                	mov    %edx,%eax
  804096:	31 d2                	xor    %edx,%edx
  804098:	83 c4 1c             	add    $0x1c,%esp
  80409b:	5b                   	pop    %ebx
  80409c:	5e                   	pop    %esi
  80409d:	5f                   	pop    %edi
  80409e:	5d                   	pop    %ebp
  80409f:	c3                   	ret    
  8040a0:	39 f0                	cmp    %esi,%eax
  8040a2:	0f 87 ac 00 00 00    	ja     804154 <__umoddi3+0xfc>
  8040a8:	0f bd e8             	bsr    %eax,%ebp
  8040ab:	83 f5 1f             	xor    $0x1f,%ebp
  8040ae:	0f 84 ac 00 00 00    	je     804160 <__umoddi3+0x108>
  8040b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8040b9:	29 ef                	sub    %ebp,%edi
  8040bb:	89 fe                	mov    %edi,%esi
  8040bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040c1:	89 e9                	mov    %ebp,%ecx
  8040c3:	d3 e0                	shl    %cl,%eax
  8040c5:	89 d7                	mov    %edx,%edi
  8040c7:	89 f1                	mov    %esi,%ecx
  8040c9:	d3 ef                	shr    %cl,%edi
  8040cb:	09 c7                	or     %eax,%edi
  8040cd:	89 e9                	mov    %ebp,%ecx
  8040cf:	d3 e2                	shl    %cl,%edx
  8040d1:	89 14 24             	mov    %edx,(%esp)
  8040d4:	89 d8                	mov    %ebx,%eax
  8040d6:	d3 e0                	shl    %cl,%eax
  8040d8:	89 c2                	mov    %eax,%edx
  8040da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040de:	d3 e0                	shl    %cl,%eax
  8040e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040e8:	89 f1                	mov    %esi,%ecx
  8040ea:	d3 e8                	shr    %cl,%eax
  8040ec:	09 d0                	or     %edx,%eax
  8040ee:	d3 eb                	shr    %cl,%ebx
  8040f0:	89 da                	mov    %ebx,%edx
  8040f2:	f7 f7                	div    %edi
  8040f4:	89 d3                	mov    %edx,%ebx
  8040f6:	f7 24 24             	mull   (%esp)
  8040f9:	89 c6                	mov    %eax,%esi
  8040fb:	89 d1                	mov    %edx,%ecx
  8040fd:	39 d3                	cmp    %edx,%ebx
  8040ff:	0f 82 87 00 00 00    	jb     80418c <__umoddi3+0x134>
  804105:	0f 84 91 00 00 00    	je     80419c <__umoddi3+0x144>
  80410b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80410f:	29 f2                	sub    %esi,%edx
  804111:	19 cb                	sbb    %ecx,%ebx
  804113:	89 d8                	mov    %ebx,%eax
  804115:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804119:	d3 e0                	shl    %cl,%eax
  80411b:	89 e9                	mov    %ebp,%ecx
  80411d:	d3 ea                	shr    %cl,%edx
  80411f:	09 d0                	or     %edx,%eax
  804121:	89 e9                	mov    %ebp,%ecx
  804123:	d3 eb                	shr    %cl,%ebx
  804125:	89 da                	mov    %ebx,%edx
  804127:	83 c4 1c             	add    $0x1c,%esp
  80412a:	5b                   	pop    %ebx
  80412b:	5e                   	pop    %esi
  80412c:	5f                   	pop    %edi
  80412d:	5d                   	pop    %ebp
  80412e:	c3                   	ret    
  80412f:	90                   	nop
  804130:	89 fd                	mov    %edi,%ebp
  804132:	85 ff                	test   %edi,%edi
  804134:	75 0b                	jne    804141 <__umoddi3+0xe9>
  804136:	b8 01 00 00 00       	mov    $0x1,%eax
  80413b:	31 d2                	xor    %edx,%edx
  80413d:	f7 f7                	div    %edi
  80413f:	89 c5                	mov    %eax,%ebp
  804141:	89 f0                	mov    %esi,%eax
  804143:	31 d2                	xor    %edx,%edx
  804145:	f7 f5                	div    %ebp
  804147:	89 c8                	mov    %ecx,%eax
  804149:	f7 f5                	div    %ebp
  80414b:	89 d0                	mov    %edx,%eax
  80414d:	e9 44 ff ff ff       	jmp    804096 <__umoddi3+0x3e>
  804152:	66 90                	xchg   %ax,%ax
  804154:	89 c8                	mov    %ecx,%eax
  804156:	89 f2                	mov    %esi,%edx
  804158:	83 c4 1c             	add    $0x1c,%esp
  80415b:	5b                   	pop    %ebx
  80415c:	5e                   	pop    %esi
  80415d:	5f                   	pop    %edi
  80415e:	5d                   	pop    %ebp
  80415f:	c3                   	ret    
  804160:	3b 04 24             	cmp    (%esp),%eax
  804163:	72 06                	jb     80416b <__umoddi3+0x113>
  804165:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804169:	77 0f                	ja     80417a <__umoddi3+0x122>
  80416b:	89 f2                	mov    %esi,%edx
  80416d:	29 f9                	sub    %edi,%ecx
  80416f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804173:	89 14 24             	mov    %edx,(%esp)
  804176:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80417a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80417e:	8b 14 24             	mov    (%esp),%edx
  804181:	83 c4 1c             	add    $0x1c,%esp
  804184:	5b                   	pop    %ebx
  804185:	5e                   	pop    %esi
  804186:	5f                   	pop    %edi
  804187:	5d                   	pop    %ebp
  804188:	c3                   	ret    
  804189:	8d 76 00             	lea    0x0(%esi),%esi
  80418c:	2b 04 24             	sub    (%esp),%eax
  80418f:	19 fa                	sbb    %edi,%edx
  804191:	89 d1                	mov    %edx,%ecx
  804193:	89 c6                	mov    %eax,%esi
  804195:	e9 71 ff ff ff       	jmp    80410b <__umoddi3+0xb3>
  80419a:	66 90                	xchg   %ax,%ax
  80419c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041a0:	72 ea                	jb     80418c <__umoddi3+0x134>
  8041a2:	89 d9                	mov    %ebx,%ecx
  8041a4:	e9 62 ff ff ff       	jmp    80410b <__umoddi3+0xb3>
