
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
  800045:	e8 30 29 00 00       	call   80297a <sys_set_uheap_strategy>
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
  80009b:	68 a0 42 80 00       	push   $0x8042a0
  8000a0:	6a 16                	push   $0x16
  8000a2:	68 bc 42 80 00       	push   $0x8042bc
  8000a7:	e8 16 0e 00 00       	call   800ec2 <_panic>
	}

	int envID = sys_getenvid();
  8000ac:	e8 7b 26 00 00       	call   80272c <sys_getenvid>
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
  8000e0:	e8 80 23 00 00       	call   802465 <sys_calculate_free_frames>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e8:	e8 18 24 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	6a 01                	push   $0x1
  8000f8:	50                   	push   %eax
  8000f9:	68 d3 42 80 00       	push   $0x8042d3
  8000fe:	e8 90 20 00 00       	call   802193 <smalloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if (ptr_allocations[0] != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800109:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80010c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800111:	74 14                	je     800127 <_main+0xef>
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 d8 42 80 00       	push   $0x8042d8
  80011b:	6a 2a                	push   $0x2a
  80011d:	68 bc 42 80 00       	push   $0x8042bc
  800122:	e8 9b 0d 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  256+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800127:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80012a:	e8 36 23 00 00       	call   802465 <sys_calculate_free_frames>
  80012f:	29 c3                	sub    %eax,%ebx
  800131:	89 d8                	mov    %ebx,%eax
  800133:	3d 03 01 00 00       	cmp    $0x103,%eax
  800138:	74 14                	je     80014e <_main+0x116>
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	68 44 43 80 00       	push   $0x804344
  800142:	6a 2b                	push   $0x2b
  800144:	68 bc 42 80 00       	push   $0x8042bc
  800149:	e8 74 0d 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014e:	e8 b2 23 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800153:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 c2 43 80 00       	push   $0x8043c2
  800160:	6a 2c                	push   $0x2c
  800162:	68 bc 42 80 00       	push   $0x8042bc
  800167:	e8 56 0d 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80016c:	e8 f4 22 00 00       	call   802465 <sys_calculate_free_frames>
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800174:	e8 8c 23 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
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
  8001a5:	68 e0 43 80 00       	push   $0x8043e0
  8001aa:	6a 32                	push   $0x32
  8001ac:	68 bc 42 80 00       	push   $0x8042bc
  8001b1:	e8 0c 0d 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b6:	e8 4a 23 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  8001bb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 c2 43 80 00       	push   $0x8043c2
  8001c8:	6a 34                	push   $0x34
  8001ca:	68 bc 42 80 00       	push   $0x8042bc
  8001cf:	e8 ee 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001d4:	e8 8c 22 00 00       	call   802465 <sys_calculate_free_frames>
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001de:	39 c2                	cmp    %eax,%edx
  8001e0:	74 14                	je     8001f6 <_main+0x1be>
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	68 10 44 80 00       	push   $0x804410
  8001ea:	6a 35                	push   $0x35
  8001ec:	68 bc 42 80 00       	push   $0x8042bc
  8001f1:	e8 cc 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f6:	e8 6a 22 00 00       	call   802465 <sys_calculate_free_frames>
  8001fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fe:	e8 02 23 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
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
  800231:	68 e0 43 80 00       	push   $0x8043e0
  800236:	6a 3b                	push   $0x3b
  800238:	68 bc 42 80 00       	push   $0x8042bc
  80023d:	e8 80 0c 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800242:	e8 be 22 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800247:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80024a:	74 14                	je     800260 <_main+0x228>
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	68 c2 43 80 00       	push   $0x8043c2
  800254:	6a 3d                	push   $0x3d
  800256:	68 bc 42 80 00       	push   $0x8042bc
  80025b:	e8 62 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800260:	e8 00 22 00 00       	call   802465 <sys_calculate_free_frames>
  800265:	89 c2                	mov    %eax,%edx
  800267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026a:	39 c2                	cmp    %eax,%edx
  80026c:	74 14                	je     800282 <_main+0x24a>
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	68 10 44 80 00       	push   $0x804410
  800276:	6a 3e                	push   $0x3e
  800278:	68 bc 42 80 00       	push   $0x8042bc
  80027d:	e8 40 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800282:	e8 de 21 00 00       	call   802465 <sys_calculate_free_frames>
  800287:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80028a:	e8 76 22 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
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
  8002c1:	68 e0 43 80 00       	push   $0x8043e0
  8002c6:	6a 44                	push   $0x44
  8002c8:	68 bc 42 80 00       	push   $0x8042bc
  8002cd:	e8 f0 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002d2:	e8 2e 22 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  8002d7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 c2 43 80 00       	push   $0x8043c2
  8002e4:	6a 46                	push   $0x46
  8002e6:	68 bc 42 80 00       	push   $0x8042bc
  8002eb:	e8 d2 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002f0:	e8 70 21 00 00       	call   802465 <sys_calculate_free_frames>
  8002f5:	89 c2                	mov    %eax,%edx
  8002f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 10 44 80 00       	push   $0x804410
  800306:	6a 47                	push   $0x47
  800308:	68 bc 42 80 00       	push   $0x8042bc
  80030d:	e8 b0 0b 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800312:	e8 4e 21 00 00       	call   802465 <sys_calculate_free_frames>
  800317:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80031a:	e8 e6 21 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
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
  800350:	68 e0 43 80 00       	push   $0x8043e0
  800355:	6a 4d                	push   $0x4d
  800357:	68 bc 42 80 00       	push   $0x8042bc
  80035c:	e8 61 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800361:	e8 9f 21 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800366:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800369:	74 14                	je     80037f <_main+0x347>
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	68 c2 43 80 00       	push   $0x8043c2
  800373:	6a 4f                	push   $0x4f
  800375:	68 bc 42 80 00       	push   $0x8042bc
  80037a:	e8 43 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80037f:	e8 e1 20 00 00       	call   802465 <sys_calculate_free_frames>
  800384:	89 c2                	mov    %eax,%edx
  800386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	74 14                	je     8003a1 <_main+0x369>
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	68 10 44 80 00       	push   $0x804410
  800395:	6a 50                	push   $0x50
  800397:	68 bc 42 80 00       	push   $0x8042bc
  80039c:	e8 21 0b 00 00       	call   800ec2 <_panic>

		//Allocate Shared 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003a1:	e8 bf 20 00 00       	call   802465 <sys_calculate_free_frames>
  8003a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a9:	e8 57 21 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  8003ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  8003b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b4:	01 c0                	add    %eax,%eax
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	50                   	push   %eax
  8003bc:	68 23 44 80 00       	push   $0x804423
  8003c1:	e8 cd 1d 00 00       	call   802193 <smalloc>
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
  8003e6:	68 d8 42 80 00       	push   $0x8042d8
  8003eb:	6a 56                	push   $0x56
  8003ed:	68 bc 42 80 00       	push   $0x8042bc
  8003f2:	e8 cb 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  512+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8003f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003fa:	e8 66 20 00 00       	call   802465 <sys_calculate_free_frames>
  8003ff:	29 c3                	sub    %eax,%ebx
  800401:	89 d8                	mov    %ebx,%eax
  800403:	3d 03 02 00 00       	cmp    $0x203,%eax
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 44 43 80 00       	push   $0x804344
  800412:	6a 57                	push   $0x57
  800414:	68 bc 42 80 00       	push   $0x8042bc
  800419:	e8 a4 0a 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80041e:	e8 e2 20 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800423:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800426:	74 14                	je     80043c <_main+0x404>
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	68 c2 43 80 00       	push   $0x8043c2
  800430:	6a 58                	push   $0x58
  800432:	68 bc 42 80 00       	push   $0x8042bc
  800437:	e8 86 0a 00 00       	call   800ec2 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80043c:	e8 24 20 00 00       	call   802465 <sys_calculate_free_frames>
  800441:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800444:	e8 bc 20 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
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
  80047e:	68 e0 43 80 00       	push   $0x8043e0
  800483:	6a 5e                	push   $0x5e
  800485:	68 bc 42 80 00       	push   $0x8042bc
  80048a:	e8 33 0a 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80048f:	e8 71 20 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800494:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800497:	74 14                	je     8004ad <_main+0x475>
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 c2 43 80 00       	push   $0x8043c2
  8004a1:	6a 60                	push   $0x60
  8004a3:	68 bc 42 80 00       	push   $0x8042bc
  8004a8:	e8 15 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8004ad:	e8 b3 1f 00 00       	call   802465 <sys_calculate_free_frames>
  8004b2:	89 c2                	mov    %eax,%edx
  8004b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b7:	39 c2                	cmp    %eax,%edx
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 10 44 80 00       	push   $0x804410
  8004c3:	6a 61                	push   $0x61
  8004c5:	68 bc 42 80 00       	push   $0x8042bc
  8004ca:	e8 f3 09 00 00       	call   800ec2 <_panic>

		//Allocate Shared 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004cf:	e8 91 1f 00 00       	call   802465 <sys_calculate_free_frames>
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004d7:	e8 29 20 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  8004dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8004df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	01 d2                	add    %edx,%edx
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	6a 00                	push   $0x0
  8004ed:	50                   	push   %eax
  8004ee:	68 25 44 80 00       	push   $0x804425
  8004f3:	e8 9b 1c 00 00       	call   802193 <smalloc>
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
  80051b:	68 d8 42 80 00       	push   $0x8042d8
  800520:	6a 67                	push   $0x67
  800522:	68 bc 42 80 00       	push   $0x8042bc
  800527:	e8 96 09 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80052c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052f:	e8 31 1f 00 00       	call   802465 <sys_calculate_free_frames>
  800534:	29 c3                	sub    %eax,%ebx
  800536:	89 d8                	mov    %ebx,%eax
  800538:	3d 04 03 00 00       	cmp    $0x304,%eax
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 44 43 80 00       	push   $0x804344
  800547:	6a 68                	push   $0x68
  800549:	68 bc 42 80 00       	push   $0x8042bc
  80054e:	e8 6f 09 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800553:	e8 ad 1f 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800558:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 c2 43 80 00       	push   $0x8043c2
  800565:	6a 69                	push   $0x69
  800567:	68 bc 42 80 00       	push   $0x8042bc
  80056c:	e8 51 09 00 00       	call   800ec2 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800571:	e8 ef 1e 00 00       	call   802465 <sys_calculate_free_frames>
  800576:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800579:	e8 87 1f 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  80057e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800581:	8b 45 90             	mov    -0x70(%ebp),%eax
  800584:	83 ec 0c             	sub    $0xc,%esp
  800587:	50                   	push   %eax
  800588:	e8 ec 1b 00 00       	call   802179 <free>
  80058d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800590:	e8 70 1f 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800595:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800598:	74 14                	je     8005ae <_main+0x576>
  80059a:	83 ec 04             	sub    $0x4,%esp
  80059d:	68 27 44 80 00       	push   $0x804427
  8005a2:	6a 73                	push   $0x73
  8005a4:	68 bc 42 80 00       	push   $0x8042bc
  8005a9:	e8 14 09 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ae:	e8 b2 1e 00 00       	call   802465 <sys_calculate_free_frames>
  8005b3:	89 c2                	mov    %eax,%edx
  8005b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b8:	39 c2                	cmp    %eax,%edx
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 3e 44 80 00       	push   $0x80443e
  8005c4:	6a 74                	push   $0x74
  8005c6:	68 bc 42 80 00       	push   $0x8042bc
  8005cb:	e8 f2 08 00 00       	call   800ec2 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d0:	e8 90 1e 00 00       	call   802465 <sys_calculate_free_frames>
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005d8:	e8 28 1f 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8005e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	50                   	push   %eax
  8005e7:	e8 8d 1b 00 00       	call   802179 <free>
  8005ec:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005ef:	e8 11 1f 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 14                	je     80060d <_main+0x5d5>
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 27 44 80 00       	push   $0x804427
  800601:	6a 7b                	push   $0x7b
  800603:	68 bc 42 80 00       	push   $0x8042bc
  800608:	e8 b5 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80060d:	e8 53 1e 00 00       	call   802465 <sys_calculate_free_frames>
  800612:	89 c2                	mov    %eax,%edx
  800614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800617:	39 c2                	cmp    %eax,%edx
  800619:	74 14                	je     80062f <_main+0x5f7>
  80061b:	83 ec 04             	sub    $0x4,%esp
  80061e:	68 3e 44 80 00       	push   $0x80443e
  800623:	6a 7c                	push   $0x7c
  800625:	68 bc 42 80 00       	push   $0x8042bc
  80062a:	e8 93 08 00 00       	call   800ec2 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80062f:	e8 31 1e 00 00       	call   802465 <sys_calculate_free_frames>
  800634:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800637:	e8 c9 1e 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  80063c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80063f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	50                   	push   %eax
  800646:	e8 2e 1b 00 00       	call   802179 <free>
  80064b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80064e:	e8 b2 1e 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800653:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800656:	74 17                	je     80066f <_main+0x637>
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	68 27 44 80 00       	push   $0x804427
  800660:	68 83 00 00 00       	push   $0x83
  800665:	68 bc 42 80 00       	push   $0x8042bc
  80066a:	e8 53 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80066f:	e8 f1 1d 00 00       	call   802465 <sys_calculate_free_frames>
  800674:	89 c2                	mov    %eax,%edx
  800676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800679:	39 c2                	cmp    %eax,%edx
  80067b:	74 17                	je     800694 <_main+0x65c>
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	68 3e 44 80 00       	push   $0x80443e
  800685:	68 84 00 00 00       	push   $0x84
  80068a:	68 bc 42 80 00       	push   $0x8042bc
  80068f:	e8 2e 08 00 00       	call   800ec2 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800694:	e8 cc 1d 00 00       	call   802465 <sys_calculate_free_frames>
  800699:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069c:	e8 64 1e 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
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
  8006d1:	68 e0 43 80 00       	push   $0x8043e0
  8006d6:	68 8d 00 00 00       	push   $0x8d
  8006db:	68 bc 42 80 00       	push   $0x8042bc
  8006e0:	e8 dd 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006e5:	e8 1b 1e 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  8006ea:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006ed:	74 17                	je     800706 <_main+0x6ce>
  8006ef:	83 ec 04             	sub    $0x4,%esp
  8006f2:	68 c2 43 80 00       	push   $0x8043c2
  8006f7:	68 8f 00 00 00       	push   $0x8f
  8006fc:	68 bc 42 80 00       	push   $0x8042bc
  800701:	e8 bc 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800706:	e8 5a 1d 00 00       	call   802465 <sys_calculate_free_frames>
  80070b:	89 c2                	mov    %eax,%edx
  80070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800710:	39 c2                	cmp    %eax,%edx
  800712:	74 17                	je     80072b <_main+0x6f3>
  800714:	83 ec 04             	sub    $0x4,%esp
  800717:	68 10 44 80 00       	push   $0x804410
  80071c:	68 90 00 00 00       	push   $0x90
  800721:	68 bc 42 80 00       	push   $0x8042bc
  800726:	e8 97 07 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80072b:	e8 35 1d 00 00       	call   802465 <sys_calculate_free_frames>
  800730:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800733:	e8 cd 1d 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
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
  800767:	68 e0 43 80 00       	push   $0x8043e0
  80076c:	68 96 00 00 00       	push   $0x96
  800771:	68 bc 42 80 00       	push   $0x8042bc
  800776:	e8 47 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80077b:	e8 85 1d 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800780:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800783:	74 17                	je     80079c <_main+0x764>
  800785:	83 ec 04             	sub    $0x4,%esp
  800788:	68 c2 43 80 00       	push   $0x8043c2
  80078d:	68 98 00 00 00       	push   $0x98
  800792:	68 bc 42 80 00       	push   $0x8042bc
  800797:	e8 26 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80079c:	e8 c4 1c 00 00       	call   802465 <sys_calculate_free_frames>
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a6:	39 c2                	cmp    %eax,%edx
  8007a8:	74 17                	je     8007c1 <_main+0x789>
  8007aa:	83 ec 04             	sub    $0x4,%esp
  8007ad:	68 10 44 80 00       	push   $0x804410
  8007b2:	68 99 00 00 00       	push   $0x99
  8007b7:	68 bc 42 80 00       	push   $0x8042bc
  8007bc:	e8 01 07 00 00       	call   800ec2 <_panic>

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007c1:	e8 9f 1c 00 00       	call   802465 <sys_calculate_free_frames>
  8007c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007c9:	e8 37 1d 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
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
  8007e1:	68 4b 44 80 00       	push   $0x80444b
  8007e6:	e8 a8 19 00 00       	call   802193 <smalloc>
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
  80080f:	68 e0 43 80 00       	push   $0x8043e0
  800814:	68 a0 00 00 00       	push   $0xa0
  800819:	68 bc 42 80 00       	push   $0x8042bc
  80081e:	e8 9f 06 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800823:	e8 dd 1c 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800828:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80082b:	74 17                	je     800844 <_main+0x80c>
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	68 c2 43 80 00       	push   $0x8043c2
  800835:	68 a1 00 00 00       	push   $0xa1
  80083a:	68 bc 42 80 00       	push   $0x8042bc
  80083f:	e8 7e 06 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 64+0+2) panic("Wrong allocation: %d", (freeFrames - sys_calculate_free_frames()));
  800844:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800847:	e8 19 1c 00 00       	call   802465 <sys_calculate_free_frames>
  80084c:	29 c3                	sub    %eax,%ebx
  80084e:	89 d8                	mov    %ebx,%eax
  800850:	83 f8 42             	cmp    $0x42,%eax
  800853:	74 21                	je     800876 <_main+0x83e>
  800855:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800858:	e8 08 1c 00 00       	call   802465 <sys_calculate_free_frames>
  80085d:	29 c3                	sub    %eax,%ebx
  80085f:	89 d8                	mov    %ebx,%eax
  800861:	50                   	push   %eax
  800862:	68 4d 44 80 00       	push   $0x80444d
  800867:	68 a2 00 00 00       	push   $0xa2
  80086c:	68 bc 42 80 00       	push   $0x8042bc
  800871:	e8 4c 06 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800876:	e8 ea 1b 00 00       	call   802465 <sys_calculate_free_frames>
  80087b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80087e:	e8 82 1c 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
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
  8008b1:	68 e0 43 80 00       	push   $0x8043e0
  8008b6:	68 a8 00 00 00       	push   $0xa8
  8008bb:	68 bc 42 80 00       	push   $0x8042bc
  8008c0:	e8 fd 05 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8008c5:	e8 3b 1c 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  8008ca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 c2 43 80 00       	push   $0x8043c2
  8008d7:	68 aa 00 00 00       	push   $0xaa
  8008dc:	68 bc 42 80 00       	push   $0x8042bc
  8008e1:	e8 dc 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008e6:	e8 7a 1b 00 00       	call   802465 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 10 44 80 00       	push   $0x804410
  8008fc:	68 ab 00 00 00       	push   $0xab
  800901:	68 bc 42 80 00       	push   $0x8042bc
  800906:	e8 b7 05 00 00       	call   800ec2 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  80090b:	e8 55 1b 00 00       	call   802465 <sys_calculate_free_frames>
  800910:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800913:	e8 ed 1b 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800918:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  80091b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091e:	c1 e0 02             	shl    $0x2,%eax
  800921:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	6a 00                	push   $0x0
  800929:	50                   	push   %eax
  80092a:	68 62 44 80 00       	push   $0x804462
  80092f:	e8 5f 18 00 00       	call   802193 <smalloc>
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
  80095a:	68 e0 43 80 00       	push   $0x8043e0
  80095f:	68 b2 00 00 00       	push   $0xb2
  800964:	68 bc 42 80 00       	push   $0x8042bc
  800969:	e8 54 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1024+1+2) panic("Wrong allocation: ");
  80096e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800971:	e8 ef 1a 00 00       	call   802465 <sys_calculate_free_frames>
  800976:	29 c3                	sub    %eax,%ebx
  800978:	89 d8                	mov    %ebx,%eax
  80097a:	3d 03 04 00 00       	cmp    $0x403,%eax
  80097f:	74 17                	je     800998 <_main+0x960>
  800981:	83 ec 04             	sub    $0x4,%esp
  800984:	68 10 44 80 00       	push   $0x804410
  800989:	68 b3 00 00 00       	push   $0xb3
  80098e:	68 bc 42 80 00       	push   $0x8042bc
  800993:	e8 2a 05 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800998:	e8 68 1b 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 c2 43 80 00       	push   $0x8043c2
  8009aa:	68 b4 00 00 00       	push   $0xb4
  8009af:	68 bc 42 80 00       	push   $0x8042bc
  8009b4:	e8 09 05 00 00       	call   800ec2 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009b9:	e8 a7 1a 00 00       	call   802465 <sys_calculate_free_frames>
  8009be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009c1:	e8 3f 1b 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  8009c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  8009c9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8009cc:	83 ec 0c             	sub    $0xc,%esp
  8009cf:	50                   	push   %eax
  8009d0:	e8 a4 17 00 00       	call   802179 <free>
  8009d5:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009d8:	e8 28 1b 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  8009dd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009e0:	74 17                	je     8009f9 <_main+0x9c1>
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	68 27 44 80 00       	push   $0x804427
  8009ea:	68 bf 00 00 00       	push   $0xbf
  8009ef:	68 bc 42 80 00       	push   $0x8042bc
  8009f4:	e8 c9 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009f9:	e8 67 1a 00 00       	call   802465 <sys_calculate_free_frames>
  8009fe:	89 c2                	mov    %eax,%edx
  800a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a03:	39 c2                	cmp    %eax,%edx
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 3e 44 80 00       	push   $0x80443e
  800a0f:	68 c0 00 00 00       	push   $0xc0
  800a14:	68 bc 42 80 00       	push   $0x8042bc
  800a19:	e8 a4 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a1e:	e8 42 1a 00 00       	call   802465 <sys_calculate_free_frames>
  800a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a26:	e8 da 1a 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  800a2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a31:	83 ec 0c             	sub    $0xc,%esp
  800a34:	50                   	push   %eax
  800a35:	e8 3f 17 00 00       	call   802179 <free>
  800a3a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a3d:	e8 c3 1a 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800a42:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a45:	74 17                	je     800a5e <_main+0xa26>
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	68 27 44 80 00       	push   $0x804427
  800a4f:	68 c7 00 00 00       	push   $0xc7
  800a54:	68 bc 42 80 00       	push   $0x8042bc
  800a59:	e8 64 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a5e:	e8 02 1a 00 00       	call   802465 <sys_calculate_free_frames>
  800a63:	89 c2                	mov    %eax,%edx
  800a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a68:	39 c2                	cmp    %eax,%edx
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 3e 44 80 00       	push   $0x80443e
  800a74:	68 c8 00 00 00       	push   $0xc8
  800a79:	68 bc 42 80 00       	push   $0x8042bc
  800a7e:	e8 3f 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 dd 19 00 00       	call   802465 <sys_calculate_free_frames>
  800a88:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 75 1a 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800a90:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800a93:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 da 16 00 00       	call   802179 <free>
  800a9f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800aa2:	e8 5e 1a 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800aa7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800aaa:	74 17                	je     800ac3 <_main+0xa8b>
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	68 27 44 80 00       	push   $0x804427
  800ab4:	68 cf 00 00 00       	push   $0xcf
  800ab9:	68 bc 42 80 00       	push   $0x8042bc
  800abe:	e8 ff 03 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800ac3:	e8 9d 19 00 00       	call   802465 <sys_calculate_free_frames>
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	39 c2                	cmp    %eax,%edx
  800acf:	74 17                	je     800ae8 <_main+0xab0>
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	68 3e 44 80 00       	push   $0x80443e
  800ad9:	68 d0 00 00 00       	push   $0xd0
  800ade:	68 bc 42 80 00       	push   $0x8042bc
  800ae3:	e8 da 03 00 00       	call   800ec2 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800ae8:	e8 78 19 00 00       	call   802465 <sys_calculate_free_frames>
  800aed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800af0:	e8 10 1a 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
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
  800b3b:	68 e0 43 80 00       	push   $0x8043e0
  800b40:	68 da 00 00 00       	push   $0xda
  800b45:	68 bc 42 80 00       	push   $0x8042bc
  800b4a:	e8 73 03 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b4f:	e8 b1 19 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800b54:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800b57:	74 17                	je     800b70 <_main+0xb38>
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	68 c2 43 80 00       	push   $0x8043c2
  800b61:	68 dc 00 00 00       	push   $0xdc
  800b66:	68 bc 42 80 00       	push   $0x8042bc
  800b6b:	e8 52 03 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b70:	e8 f0 18 00 00       	call   802465 <sys_calculate_free_frames>
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b7a:	39 c2                	cmp    %eax,%edx
  800b7c:	74 17                	je     800b95 <_main+0xb5d>
  800b7e:	83 ec 04             	sub    $0x4,%esp
  800b81:	68 10 44 80 00       	push   $0x804410
  800b86:	68 dd 00 00 00       	push   $0xdd
  800b8b:	68 bc 42 80 00       	push   $0x8042bc
  800b90:	e8 2d 03 00 00       	call   800ec2 <_panic>

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800b95:	e8 cb 18 00 00       	call   802465 <sys_calculate_free_frames>
  800b9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b9d:	e8 63 19 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ba8:	c1 e0 02             	shl    $0x2,%eax
  800bab:	83 ec 04             	sub    $0x4,%esp
  800bae:	6a 00                	push   $0x0
  800bb0:	50                   	push   %eax
  800bb1:	68 64 44 80 00       	push   $0x804464
  800bb6:	e8 d8 15 00 00       	call   802193 <smalloc>
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
  800bdc:	68 d8 42 80 00       	push   $0x8042d8
  800be1:	68 e3 00 00 00       	push   $0xe3
  800be6:	68 bc 42 80 00       	push   $0x8042bc
  800beb:	e8 d2 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1024+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800bf0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800bf3:	e8 6d 18 00 00       	call   802465 <sys_calculate_free_frames>
  800bf8:	29 c3                	sub    %eax,%ebx
  800bfa:	89 d8                	mov    %ebx,%eax
  800bfc:	3d 03 04 00 00       	cmp    $0x403,%eax
  800c01:	74 17                	je     800c1a <_main+0xbe2>
  800c03:	83 ec 04             	sub    $0x4,%esp
  800c06:	68 44 43 80 00       	push   $0x804344
  800c0b:	68 e4 00 00 00       	push   $0xe4
  800c10:	68 bc 42 80 00       	push   $0x8042bc
  800c15:	e8 a8 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c1a:	e8 e6 18 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800c1f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800c22:	74 17                	je     800c3b <_main+0xc03>
  800c24:	83 ec 04             	sub    $0x4,%esp
  800c27:	68 c2 43 80 00       	push   $0x8043c2
  800c2c:	68 e5 00 00 00       	push   $0xe5
  800c31:	68 bc 42 80 00       	push   $0x8042bc
  800c36:	e8 87 02 00 00       	call   800ec2 <_panic>

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 25 18 00 00       	call   802465 <sys_calculate_free_frames>
  800c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c43:	e8 bd 18 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	68 25 44 80 00       	push   $0x804425
  800c53:	ff 75 ec             	pushl  -0x14(%ebp)
  800c56:	e8 e6 15 00 00       	call   802241 <sget>
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
  800c79:	68 d8 42 80 00       	push   $0x8042d8
  800c7e:	68 eb 00 00 00       	push   $0xeb
  800c83:	68 bc 42 80 00       	push   $0x8042bc
  800c88:	e8 35 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800c8d:	e8 d3 17 00 00       	call   802465 <sys_calculate_free_frames>
  800c92:	89 c2                	mov    %eax,%edx
  800c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	74 17                	je     800cb2 <_main+0xc7a>
  800c9b:	83 ec 04             	sub    $0x4,%esp
  800c9e:	68 44 43 80 00       	push   $0x804344
  800ca3:	68 ec 00 00 00       	push   $0xec
  800ca8:	68 bc 42 80 00       	push   $0x8042bc
  800cad:	e8 10 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800cb2:	e8 4e 18 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800cb7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800cba:	74 17                	je     800cd3 <_main+0xc9b>
  800cbc:	83 ec 04             	sub    $0x4,%esp
  800cbf:	68 c2 43 80 00       	push   $0x8043c2
  800cc4:	68 ed 00 00 00       	push   $0xed
  800cc9:	68 bc 42 80 00       	push   $0x8042bc
  800cce:	e8 ef 01 00 00       	call   800ec2 <_panic>

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800cd3:	e8 8d 17 00 00       	call   802465 <sys_calculate_free_frames>
  800cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800cdb:	e8 25 18 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800ce0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	68 d3 42 80 00       	push   $0x8042d3
  800ceb:	ff 75 ec             	pushl  -0x14(%ebp)
  800cee:	e8 4e 15 00 00       	call   802241 <sget>
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
  800d14:	68 d8 42 80 00       	push   $0x8042d8
  800d19:	68 f3 00 00 00       	push   $0xf3
  800d1e:	68 bc 42 80 00       	push   $0x8042bc
  800d23:	e8 9a 01 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800d28:	e8 38 17 00 00       	call   802465 <sys_calculate_free_frames>
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d32:	39 c2                	cmp    %eax,%edx
  800d34:	74 17                	je     800d4d <_main+0xd15>
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	68 44 43 80 00       	push   $0x804344
  800d3e:	68 f4 00 00 00       	push   $0xf4
  800d43:	68 bc 42 80 00       	push   $0x8042bc
  800d48:	e8 75 01 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800d4d:	e8 b3 17 00 00       	call   802505 <sys_pf_calculate_allocated_pages>
  800d52:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d55:	74 17                	je     800d6e <_main+0xd36>
  800d57:	83 ec 04             	sub    $0x4,%esp
  800d5a:	68 c2 43 80 00       	push   $0x8043c2
  800d5f:	68 f5 00 00 00       	push   $0xf5
  800d64:	68 bc 42 80 00       	push   $0x8042bc
  800d69:	e8 54 01 00 00       	call   800ec2 <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT allocation (3) completed successfully.\n");
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	68 68 44 80 00       	push   $0x804468
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
  800d8c:	e8 b4 19 00 00       	call   802745 <sys_getenvindex>
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
  800df7:	e8 56 17 00 00       	call   802552 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	68 cc 44 80 00       	push   $0x8044cc
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
  800e27:	68 f4 44 80 00       	push   $0x8044f4
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
  800e58:	68 1c 45 80 00       	push   $0x80451c
  800e5d:	e8 14 03 00 00       	call   801176 <cprintf>
  800e62:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800e65:	a1 20 50 80 00       	mov    0x805020,%eax
  800e6a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	50                   	push   %eax
  800e74:	68 74 45 80 00       	push   $0x804574
  800e79:	e8 f8 02 00 00       	call   801176 <cprintf>
  800e7e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	68 cc 44 80 00       	push   $0x8044cc
  800e89:	e8 e8 02 00 00       	call   801176 <cprintf>
  800e8e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e91:	e8 d6 16 00 00       	call   80256c <sys_enable_interrupt>

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
  800ea9:	e8 63 18 00 00       	call   802711 <sys_destroy_env>
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
  800eba:	e8 b8 18 00 00       	call   802777 <sys_exit_env>
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
  800ee3:	68 88 45 80 00       	push   $0x804588
  800ee8:	e8 89 02 00 00       	call   801176 <cprintf>
  800eed:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ef0:	a1 00 50 80 00       	mov    0x805000,%eax
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	ff 75 08             	pushl  0x8(%ebp)
  800efb:	50                   	push   %eax
  800efc:	68 8d 45 80 00       	push   $0x80458d
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
  800f20:	68 a9 45 80 00       	push   $0x8045a9
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
  800f4c:	68 ac 45 80 00       	push   $0x8045ac
  800f51:	6a 26                	push   $0x26
  800f53:	68 f8 45 80 00       	push   $0x8045f8
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
  80101e:	68 04 46 80 00       	push   $0x804604
  801023:	6a 3a                	push   $0x3a
  801025:	68 f8 45 80 00       	push   $0x8045f8
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
  80108e:	68 58 46 80 00       	push   $0x804658
  801093:	6a 44                	push   $0x44
  801095:	68 f8 45 80 00       	push   $0x8045f8
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
  8010e8:	e8 b7 12 00 00       	call   8023a4 <sys_cputs>
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
  80115f:	e8 40 12 00 00       	call   8023a4 <sys_cputs>
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
  8011a9:	e8 a4 13 00 00       	call   802552 <sys_disable_interrupt>
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
  8011c9:	e8 9e 13 00 00       	call   80256c <sys_enable_interrupt>
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
  801213:	e8 10 2e 00 00       	call   804028 <__udivdi3>
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
  801263:	e8 d0 2e 00 00       	call   804138 <__umoddi3>
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	05 d4 48 80 00       	add    $0x8048d4,%eax
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
  8013be:	8b 04 85 f8 48 80 00 	mov    0x8048f8(,%eax,4),%eax
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
  80149f:	8b 34 9d 40 47 80 00 	mov    0x804740(,%ebx,4),%esi
  8014a6:	85 f6                	test   %esi,%esi
  8014a8:	75 19                	jne    8014c3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8014aa:	53                   	push   %ebx
  8014ab:	68 e5 48 80 00       	push   $0x8048e5
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
  8014c4:	68 ee 48 80 00       	push   $0x8048ee
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
  8014f1:	be f1 48 80 00       	mov    $0x8048f1,%esi
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
  801f17:	68 50 4a 80 00       	push   $0x804a50
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
  801fe7:	e8 fc 04 00 00       	call   8024e8 <sys_allocate_chunk>
  801fec:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801fef:	a1 20 51 80 00       	mov    0x805120,%eax
  801ff4:	83 ec 0c             	sub    $0xc,%esp
  801ff7:	50                   	push   %eax
  801ff8:	e8 71 0b 00 00       	call   802b6e <initialize_MemBlocksList>
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
  802025:	68 75 4a 80 00       	push   $0x804a75
  80202a:	6a 33                	push   $0x33
  80202c:	68 93 4a 80 00       	push   $0x804a93
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
  8020a4:	68 a0 4a 80 00       	push   $0x804aa0
  8020a9:	6a 34                	push   $0x34
  8020ab:	68 93 4a 80 00       	push   $0x804a93
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
  802101:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802104:	e8 f7 fd ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  802109:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80210d:	75 07                	jne    802116 <malloc+0x18>
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
  802114:	eb 61                	jmp    802177 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  802116:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80211d:	8b 55 08             	mov    0x8(%ebp),%edx
  802120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802123:	01 d0                	add    %edx,%eax
  802125:	48                   	dec    %eax
  802126:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802129:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212c:	ba 00 00 00 00       	mov    $0x0,%edx
  802131:	f7 75 f0             	divl   -0x10(%ebp)
  802134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802137:	29 d0                	sub    %edx,%eax
  802139:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80213c:	e8 75 07 00 00       	call   8028b6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802141:	85 c0                	test   %eax,%eax
  802143:	74 11                	je     802156 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  802145:	83 ec 0c             	sub    $0xc,%esp
  802148:	ff 75 e8             	pushl  -0x18(%ebp)
  80214b:	e8 e0 0d 00 00       	call   802f30 <alloc_block_FF>
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  802156:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80215a:	74 16                	je     802172 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80215c:	83 ec 0c             	sub    $0xc,%esp
  80215f:	ff 75 f4             	pushl  -0xc(%ebp)
  802162:	e8 3c 0b 00 00       	call   802ca3 <insert_sorted_allocList>
  802167:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	8b 40 08             	mov    0x8(%eax),%eax
  802170:	eb 05                	jmp    802177 <malloc+0x79>
	}

    return NULL;
  802172:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	68 c4 4a 80 00       	push   $0x804ac4
  802187:	6a 6f                	push   $0x6f
  802189:	68 93 4a 80 00       	push   $0x804a93
  80218e:	e8 2f ed ff ff       	call   800ec2 <_panic>

00802193 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
  802196:	83 ec 38             	sub    $0x38,%esp
  802199:	8b 45 10             	mov    0x10(%ebp),%eax
  80219c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80219f:	e8 5c fd ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  8021a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021a8:	75 0a                	jne    8021b4 <smalloc+0x21>
  8021aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021af:	e9 8b 00 00 00       	jmp    80223f <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8021b4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8021bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c1:	01 d0                	add    %edx,%eax
  8021c3:	48                   	dec    %eax
  8021c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8021cf:	f7 75 f0             	divl   -0x10(%ebp)
  8021d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d5:	29 d0                	sub    %edx,%eax
  8021d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8021da:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8021e1:	e8 d0 06 00 00       	call   8028b6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	74 11                	je     8021fb <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8021ea:	83 ec 0c             	sub    $0xc,%esp
  8021ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8021f0:	e8 3b 0d 00 00       	call   802f30 <alloc_block_FF>
  8021f5:	83 c4 10             	add    $0x10,%esp
  8021f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8021fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ff:	74 39                	je     80223a <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  802201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802204:	8b 40 08             	mov    0x8(%eax),%eax
  802207:	89 c2                	mov    %eax,%edx
  802209:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80220d:	52                   	push   %edx
  80220e:	50                   	push   %eax
  80220f:	ff 75 0c             	pushl  0xc(%ebp)
  802212:	ff 75 08             	pushl  0x8(%ebp)
  802215:	e8 21 04 00 00       	call   80263b <sys_createSharedObject>
  80221a:	83 c4 10             	add    $0x10,%esp
  80221d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  802220:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802224:	74 14                	je     80223a <smalloc+0xa7>
  802226:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80222a:	74 0e                	je     80223a <smalloc+0xa7>
  80222c:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  802230:	74 08                	je     80223a <smalloc+0xa7>
			return (void*) mem_block->sva;
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	8b 40 08             	mov    0x8(%eax),%eax
  802238:	eb 05                	jmp    80223f <smalloc+0xac>
	}
	return NULL;
  80223a:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802247:	e8 b4 fc ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80224c:	83 ec 08             	sub    $0x8,%esp
  80224f:	ff 75 0c             	pushl  0xc(%ebp)
  802252:	ff 75 08             	pushl  0x8(%ebp)
  802255:	e8 0b 04 00 00       	call   802665 <sys_getSizeOfSharedObject>
  80225a:	83 c4 10             	add    $0x10,%esp
  80225d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  802260:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  802264:	74 76                	je     8022dc <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802266:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80226d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802273:	01 d0                	add    %edx,%eax
  802275:	48                   	dec    %eax
  802276:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802279:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80227c:	ba 00 00 00 00       	mov    $0x0,%edx
  802281:	f7 75 ec             	divl   -0x14(%ebp)
  802284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802287:	29 d0                	sub    %edx,%eax
  802289:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80228c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802293:	e8 1e 06 00 00       	call   8028b6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802298:	85 c0                	test   %eax,%eax
  80229a:	74 11                	je     8022ad <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80229c:	83 ec 0c             	sub    $0xc,%esp
  80229f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022a2:	e8 89 0c 00 00       	call   802f30 <alloc_block_FF>
  8022a7:	83 c4 10             	add    $0x10,%esp
  8022aa:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8022ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b1:	74 29                	je     8022dc <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 40 08             	mov    0x8(%eax),%eax
  8022b9:	83 ec 04             	sub    $0x4,%esp
  8022bc:	50                   	push   %eax
  8022bd:	ff 75 0c             	pushl  0xc(%ebp)
  8022c0:	ff 75 08             	pushl  0x8(%ebp)
  8022c3:	e8 ba 03 00 00       	call   802682 <sys_getSharedObject>
  8022c8:	83 c4 10             	add    $0x10,%esp
  8022cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8022ce:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8022d2:	74 08                	je     8022dc <sget+0x9b>
				return (void *)mem_block->sva;
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 40 08             	mov    0x8(%eax),%eax
  8022da:	eb 05                	jmp    8022e1 <sget+0xa0>
		}
	}
	return (void *)NULL;
  8022dc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
  8022e6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022e9:	e8 12 fc ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8022ee:	83 ec 04             	sub    $0x4,%esp
  8022f1:	68 e8 4a 80 00       	push   $0x804ae8
  8022f6:	68 f1 00 00 00       	push   $0xf1
  8022fb:	68 93 4a 80 00       	push   $0x804a93
  802300:	e8 bd eb ff ff       	call   800ec2 <_panic>

00802305 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80230b:	83 ec 04             	sub    $0x4,%esp
  80230e:	68 10 4b 80 00       	push   $0x804b10
  802313:	68 05 01 00 00       	push   $0x105
  802318:	68 93 4a 80 00       	push   $0x804a93
  80231d:	e8 a0 eb ff ff       	call   800ec2 <_panic>

00802322 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802328:	83 ec 04             	sub    $0x4,%esp
  80232b:	68 34 4b 80 00       	push   $0x804b34
  802330:	68 10 01 00 00       	push   $0x110
  802335:	68 93 4a 80 00       	push   $0x804a93
  80233a:	e8 83 eb ff ff       	call   800ec2 <_panic>

0080233f <shrink>:

}
void shrink(uint32 newSize)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802345:	83 ec 04             	sub    $0x4,%esp
  802348:	68 34 4b 80 00       	push   $0x804b34
  80234d:	68 15 01 00 00       	push   $0x115
  802352:	68 93 4a 80 00       	push   $0x804a93
  802357:	e8 66 eb ff ff       	call   800ec2 <_panic>

0080235c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802362:	83 ec 04             	sub    $0x4,%esp
  802365:	68 34 4b 80 00       	push   $0x804b34
  80236a:	68 1a 01 00 00       	push   $0x11a
  80236f:	68 93 4a 80 00       	push   $0x804a93
  802374:	e8 49 eb ff ff       	call   800ec2 <_panic>

00802379 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	57                   	push   %edi
  80237d:	56                   	push   %esi
  80237e:	53                   	push   %ebx
  80237f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	8b 55 0c             	mov    0xc(%ebp),%edx
  802388:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80238b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80238e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802391:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802394:	cd 30                	int    $0x30
  802396:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802399:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80239c:	83 c4 10             	add    $0x10,%esp
  80239f:	5b                   	pop    %ebx
  8023a0:	5e                   	pop    %esi
  8023a1:	5f                   	pop    %edi
  8023a2:	5d                   	pop    %ebp
  8023a3:	c3                   	ret    

008023a4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	83 ec 04             	sub    $0x4,%esp
  8023aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8023b0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	52                   	push   %edx
  8023bc:	ff 75 0c             	pushl  0xc(%ebp)
  8023bf:	50                   	push   %eax
  8023c0:	6a 00                	push   $0x0
  8023c2:	e8 b2 ff ff ff       	call   802379 <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
}
  8023ca:	90                   	nop
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_cgetc>:

int
sys_cgetc(void)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 01                	push   $0x1
  8023dc:	e8 98 ff ff ff       	call   802379 <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
}
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	52                   	push   %edx
  8023f6:	50                   	push   %eax
  8023f7:	6a 05                	push   $0x5
  8023f9:	e8 7b ff ff ff       	call   802379 <syscall>
  8023fe:	83 c4 18             	add    $0x18,%esp
}
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	56                   	push   %esi
  802407:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802408:	8b 75 18             	mov    0x18(%ebp),%esi
  80240b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80240e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802411:	8b 55 0c             	mov    0xc(%ebp),%edx
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	56                   	push   %esi
  802418:	53                   	push   %ebx
  802419:	51                   	push   %ecx
  80241a:	52                   	push   %edx
  80241b:	50                   	push   %eax
  80241c:	6a 06                	push   $0x6
  80241e:	e8 56 ff ff ff       	call   802379 <syscall>
  802423:	83 c4 18             	add    $0x18,%esp
}
  802426:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802429:	5b                   	pop    %ebx
  80242a:	5e                   	pop    %esi
  80242b:	5d                   	pop    %ebp
  80242c:	c3                   	ret    

0080242d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802430:	8b 55 0c             	mov    0xc(%ebp),%edx
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	52                   	push   %edx
  80243d:	50                   	push   %eax
  80243e:	6a 07                	push   $0x7
  802440:	e8 34 ff ff ff       	call   802379 <syscall>
  802445:	83 c4 18             	add    $0x18,%esp
}
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	ff 75 0c             	pushl  0xc(%ebp)
  802456:	ff 75 08             	pushl  0x8(%ebp)
  802459:	6a 08                	push   $0x8
  80245b:	e8 19 ff ff ff       	call   802379 <syscall>
  802460:	83 c4 18             	add    $0x18,%esp
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 09                	push   $0x9
  802474:	e8 00 ff ff ff       	call   802379 <syscall>
  802479:	83 c4 18             	add    $0x18,%esp
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 0a                	push   $0xa
  80248d:	e8 e7 fe ff ff       	call   802379 <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 0b                	push   $0xb
  8024a6:	e8 ce fe ff ff       	call   802379 <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	ff 75 0c             	pushl  0xc(%ebp)
  8024bc:	ff 75 08             	pushl  0x8(%ebp)
  8024bf:	6a 0f                	push   $0xf
  8024c1:	e8 b3 fe ff ff       	call   802379 <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
	return;
  8024c9:	90                   	nop
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	ff 75 0c             	pushl  0xc(%ebp)
  8024d8:	ff 75 08             	pushl  0x8(%ebp)
  8024db:	6a 10                	push   $0x10
  8024dd:	e8 97 fe ff ff       	call   802379 <syscall>
  8024e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e5:	90                   	nop
}
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	ff 75 10             	pushl  0x10(%ebp)
  8024f2:	ff 75 0c             	pushl  0xc(%ebp)
  8024f5:	ff 75 08             	pushl  0x8(%ebp)
  8024f8:	6a 11                	push   $0x11
  8024fa:	e8 7a fe ff ff       	call   802379 <syscall>
  8024ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802502:	90                   	nop
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 0c                	push   $0xc
  802514:	e8 60 fe ff ff       	call   802379 <syscall>
  802519:	83 c4 18             	add    $0x18,%esp
}
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	ff 75 08             	pushl  0x8(%ebp)
  80252c:	6a 0d                	push   $0xd
  80252e:	e8 46 fe ff ff       	call   802379 <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 0e                	push   $0xe
  802547:	e8 2d fe ff ff       	call   802379 <syscall>
  80254c:	83 c4 18             	add    $0x18,%esp
}
  80254f:	90                   	nop
  802550:	c9                   	leave  
  802551:	c3                   	ret    

00802552 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 13                	push   $0x13
  802561:	e8 13 fe ff ff       	call   802379 <syscall>
  802566:	83 c4 18             	add    $0x18,%esp
}
  802569:	90                   	nop
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    

0080256c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 14                	push   $0x14
  80257b:	e8 f9 fd ff ff       	call   802379 <syscall>
  802580:	83 c4 18             	add    $0x18,%esp
}
  802583:	90                   	nop
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <sys_cputc>:


void
sys_cputc(const char c)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	83 ec 04             	sub    $0x4,%esp
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802592:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	50                   	push   %eax
  80259f:	6a 15                	push   $0x15
  8025a1:	e8 d3 fd ff ff       	call   802379 <syscall>
  8025a6:	83 c4 18             	add    $0x18,%esp
}
  8025a9:	90                   	nop
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    

008025ac <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 16                	push   $0x16
  8025bb:	e8 b9 fd ff ff       	call   802379 <syscall>
  8025c0:	83 c4 18             	add    $0x18,%esp
}
  8025c3:	90                   	nop
  8025c4:	c9                   	leave  
  8025c5:	c3                   	ret    

008025c6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	ff 75 0c             	pushl  0xc(%ebp)
  8025d5:	50                   	push   %eax
  8025d6:	6a 17                	push   $0x17
  8025d8:	e8 9c fd ff ff       	call   802379 <syscall>
  8025dd:	83 c4 18             	add    $0x18,%esp
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	52                   	push   %edx
  8025f2:	50                   	push   %eax
  8025f3:	6a 1a                	push   $0x1a
  8025f5:	e8 7f fd ff ff       	call   802379 <syscall>
  8025fa:	83 c4 18             	add    $0x18,%esp
}
  8025fd:	c9                   	leave  
  8025fe:	c3                   	ret    

008025ff <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802602:	8b 55 0c             	mov    0xc(%ebp),%edx
  802605:	8b 45 08             	mov    0x8(%ebp),%eax
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	52                   	push   %edx
  80260f:	50                   	push   %eax
  802610:	6a 18                	push   $0x18
  802612:	e8 62 fd ff ff       	call   802379 <syscall>
  802617:	83 c4 18             	add    $0x18,%esp
}
  80261a:	90                   	nop
  80261b:	c9                   	leave  
  80261c:	c3                   	ret    

0080261d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802620:	8b 55 0c             	mov    0xc(%ebp),%edx
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	52                   	push   %edx
  80262d:	50                   	push   %eax
  80262e:	6a 19                	push   $0x19
  802630:	e8 44 fd ff ff       	call   802379 <syscall>
  802635:	83 c4 18             	add    $0x18,%esp
}
  802638:	90                   	nop
  802639:	c9                   	leave  
  80263a:	c3                   	ret    

0080263b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	83 ec 04             	sub    $0x4,%esp
  802641:	8b 45 10             	mov    0x10(%ebp),%eax
  802644:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802647:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80264a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80264e:	8b 45 08             	mov    0x8(%ebp),%eax
  802651:	6a 00                	push   $0x0
  802653:	51                   	push   %ecx
  802654:	52                   	push   %edx
  802655:	ff 75 0c             	pushl  0xc(%ebp)
  802658:	50                   	push   %eax
  802659:	6a 1b                	push   $0x1b
  80265b:	e8 19 fd ff ff       	call   802379 <syscall>
  802660:	83 c4 18             	add    $0x18,%esp
}
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	6a 00                	push   $0x0
  802670:	6a 00                	push   $0x0
  802672:	6a 00                	push   $0x0
  802674:	52                   	push   %edx
  802675:	50                   	push   %eax
  802676:	6a 1c                	push   $0x1c
  802678:	e8 fc fc ff ff       	call   802379 <syscall>
  80267d:	83 c4 18             	add    $0x18,%esp
}
  802680:	c9                   	leave  
  802681:	c3                   	ret    

00802682 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802685:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268b:	8b 45 08             	mov    0x8(%ebp),%eax
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	51                   	push   %ecx
  802693:	52                   	push   %edx
  802694:	50                   	push   %eax
  802695:	6a 1d                	push   $0x1d
  802697:	e8 dd fc ff ff       	call   802379 <syscall>
  80269c:	83 c4 18             	add    $0x18,%esp
}
  80269f:	c9                   	leave  
  8026a0:	c3                   	ret    

008026a1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8026a1:	55                   	push   %ebp
  8026a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8026a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	52                   	push   %edx
  8026b1:	50                   	push   %eax
  8026b2:	6a 1e                	push   $0x1e
  8026b4:	e8 c0 fc ff ff       	call   802379 <syscall>
  8026b9:	83 c4 18             	add    $0x18,%esp
}
  8026bc:	c9                   	leave  
  8026bd:	c3                   	ret    

008026be <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 00                	push   $0x0
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 1f                	push   $0x1f
  8026cd:	e8 a7 fc ff ff       	call   802379 <syscall>
  8026d2:	83 c4 18             	add    $0x18,%esp
}
  8026d5:	c9                   	leave  
  8026d6:	c3                   	ret    

008026d7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026da:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dd:	6a 00                	push   $0x0
  8026df:	ff 75 14             	pushl  0x14(%ebp)
  8026e2:	ff 75 10             	pushl  0x10(%ebp)
  8026e5:	ff 75 0c             	pushl  0xc(%ebp)
  8026e8:	50                   	push   %eax
  8026e9:	6a 20                	push   $0x20
  8026eb:	e8 89 fc ff ff       	call   802379 <syscall>
  8026f0:	83 c4 18             	add    $0x18,%esp
}
  8026f3:	c9                   	leave  
  8026f4:	c3                   	ret    

008026f5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026f5:	55                   	push   %ebp
  8026f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	50                   	push   %eax
  802704:	6a 21                	push   $0x21
  802706:	e8 6e fc ff ff       	call   802379 <syscall>
  80270b:	83 c4 18             	add    $0x18,%esp
}
  80270e:	90                   	nop
  80270f:	c9                   	leave  
  802710:	c3                   	ret    

00802711 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802711:	55                   	push   %ebp
  802712:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	50                   	push   %eax
  802720:	6a 22                	push   $0x22
  802722:	e8 52 fc ff ff       	call   802379 <syscall>
  802727:	83 c4 18             	add    $0x18,%esp
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 02                	push   $0x2
  80273b:	e8 39 fc ff ff       	call   802379 <syscall>
  802740:	83 c4 18             	add    $0x18,%esp
}
  802743:	c9                   	leave  
  802744:	c3                   	ret    

00802745 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	6a 03                	push   $0x3
  802754:	e8 20 fc ff ff       	call   802379 <syscall>
  802759:	83 c4 18             	add    $0x18,%esp
}
  80275c:	c9                   	leave  
  80275d:	c3                   	ret    

0080275e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 04                	push   $0x4
  80276d:	e8 07 fc ff ff       	call   802379 <syscall>
  802772:	83 c4 18             	add    $0x18,%esp
}
  802775:	c9                   	leave  
  802776:	c3                   	ret    

00802777 <sys_exit_env>:


void sys_exit_env(void)
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 23                	push   $0x23
  802786:	e8 ee fb ff ff       	call   802379 <syscall>
  80278b:	83 c4 18             	add    $0x18,%esp
}
  80278e:	90                   	nop
  80278f:	c9                   	leave  
  802790:	c3                   	ret    

00802791 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802791:	55                   	push   %ebp
  802792:	89 e5                	mov    %esp,%ebp
  802794:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802797:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80279a:	8d 50 04             	lea    0x4(%eax),%edx
  80279d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	52                   	push   %edx
  8027a7:	50                   	push   %eax
  8027a8:	6a 24                	push   $0x24
  8027aa:	e8 ca fb ff ff       	call   802379 <syscall>
  8027af:	83 c4 18             	add    $0x18,%esp
	return result;
  8027b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027bb:	89 01                	mov    %eax,(%ecx)
  8027bd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8027c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c3:	c9                   	leave  
  8027c4:	c2 04 00             	ret    $0x4

008027c7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8027c7:	55                   	push   %ebp
  8027c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 00                	push   $0x0
  8027ce:	ff 75 10             	pushl  0x10(%ebp)
  8027d1:	ff 75 0c             	pushl  0xc(%ebp)
  8027d4:	ff 75 08             	pushl  0x8(%ebp)
  8027d7:	6a 12                	push   $0x12
  8027d9:	e8 9b fb ff ff       	call   802379 <syscall>
  8027de:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e1:	90                   	nop
}
  8027e2:	c9                   	leave  
  8027e3:	c3                   	ret    

008027e4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8027e4:	55                   	push   %ebp
  8027e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 25                	push   $0x25
  8027f3:	e8 81 fb ff ff       	call   802379 <syscall>
  8027f8:	83 c4 18             	add    $0x18,%esp
}
  8027fb:	c9                   	leave  
  8027fc:	c3                   	ret    

008027fd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
  802800:	83 ec 04             	sub    $0x4,%esp
  802803:	8b 45 08             	mov    0x8(%ebp),%eax
  802806:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802809:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	50                   	push   %eax
  802816:	6a 26                	push   $0x26
  802818:	e8 5c fb ff ff       	call   802379 <syscall>
  80281d:	83 c4 18             	add    $0x18,%esp
	return ;
  802820:	90                   	nop
}
  802821:	c9                   	leave  
  802822:	c3                   	ret    

00802823 <rsttst>:
void rsttst()
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 28                	push   $0x28
  802832:	e8 42 fb ff ff       	call   802379 <syscall>
  802837:	83 c4 18             	add    $0x18,%esp
	return ;
  80283a:	90                   	nop
}
  80283b:	c9                   	leave  
  80283c:	c3                   	ret    

0080283d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	8b 45 14             	mov    0x14(%ebp),%eax
  802846:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802849:	8b 55 18             	mov    0x18(%ebp),%edx
  80284c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802850:	52                   	push   %edx
  802851:	50                   	push   %eax
  802852:	ff 75 10             	pushl  0x10(%ebp)
  802855:	ff 75 0c             	pushl  0xc(%ebp)
  802858:	ff 75 08             	pushl  0x8(%ebp)
  80285b:	6a 27                	push   $0x27
  80285d:	e8 17 fb ff ff       	call   802379 <syscall>
  802862:	83 c4 18             	add    $0x18,%esp
	return ;
  802865:	90                   	nop
}
  802866:	c9                   	leave  
  802867:	c3                   	ret    

00802868 <chktst>:
void chktst(uint32 n)
{
  802868:	55                   	push   %ebp
  802869:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	ff 75 08             	pushl  0x8(%ebp)
  802876:	6a 29                	push   $0x29
  802878:	e8 fc fa ff ff       	call   802379 <syscall>
  80287d:	83 c4 18             	add    $0x18,%esp
	return ;
  802880:	90                   	nop
}
  802881:	c9                   	leave  
  802882:	c3                   	ret    

00802883 <inctst>:

void inctst()
{
  802883:	55                   	push   %ebp
  802884:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	6a 00                	push   $0x0
  80288c:	6a 00                	push   $0x0
  80288e:	6a 00                	push   $0x0
  802890:	6a 2a                	push   $0x2a
  802892:	e8 e2 fa ff ff       	call   802379 <syscall>
  802897:	83 c4 18             	add    $0x18,%esp
	return ;
  80289a:	90                   	nop
}
  80289b:	c9                   	leave  
  80289c:	c3                   	ret    

0080289d <gettst>:
uint32 gettst()
{
  80289d:	55                   	push   %ebp
  80289e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 00                	push   $0x0
  8028a8:	6a 00                	push   $0x0
  8028aa:	6a 2b                	push   $0x2b
  8028ac:	e8 c8 fa ff ff       	call   802379 <syscall>
  8028b1:	83 c4 18             	add    $0x18,%esp
}
  8028b4:	c9                   	leave  
  8028b5:	c3                   	ret    

008028b6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8028b6:	55                   	push   %ebp
  8028b7:	89 e5                	mov    %esp,%ebp
  8028b9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 00                	push   $0x0
  8028c2:	6a 00                	push   $0x0
  8028c4:	6a 00                	push   $0x0
  8028c6:	6a 2c                	push   $0x2c
  8028c8:	e8 ac fa ff ff       	call   802379 <syscall>
  8028cd:	83 c4 18             	add    $0x18,%esp
  8028d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8028d3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8028d7:	75 07                	jne    8028e0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8028d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8028de:	eb 05                	jmp    8028e5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8028e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028e5:	c9                   	leave  
  8028e6:	c3                   	ret    

008028e7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8028e7:	55                   	push   %ebp
  8028e8:	89 e5                	mov    %esp,%ebp
  8028ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	6a 00                	push   $0x0
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 2c                	push   $0x2c
  8028f9:	e8 7b fa ff ff       	call   802379 <syscall>
  8028fe:	83 c4 18             	add    $0x18,%esp
  802901:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802904:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802908:	75 07                	jne    802911 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80290a:	b8 01 00 00 00       	mov    $0x1,%eax
  80290f:	eb 05                	jmp    802916 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802911:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802916:	c9                   	leave  
  802917:	c3                   	ret    

00802918 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802918:	55                   	push   %ebp
  802919:	89 e5                	mov    %esp,%ebp
  80291b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	6a 00                	push   $0x0
  802924:	6a 00                	push   $0x0
  802926:	6a 00                	push   $0x0
  802928:	6a 2c                	push   $0x2c
  80292a:	e8 4a fa ff ff       	call   802379 <syscall>
  80292f:	83 c4 18             	add    $0x18,%esp
  802932:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802935:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802939:	75 07                	jne    802942 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80293b:	b8 01 00 00 00       	mov    $0x1,%eax
  802940:	eb 05                	jmp    802947 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802942:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802947:	c9                   	leave  
  802948:	c3                   	ret    

00802949 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802949:	55                   	push   %ebp
  80294a:	89 e5                	mov    %esp,%ebp
  80294c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	6a 00                	push   $0x0
  802957:	6a 00                	push   $0x0
  802959:	6a 2c                	push   $0x2c
  80295b:	e8 19 fa ff ff       	call   802379 <syscall>
  802960:	83 c4 18             	add    $0x18,%esp
  802963:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802966:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80296a:	75 07                	jne    802973 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80296c:	b8 01 00 00 00       	mov    $0x1,%eax
  802971:	eb 05                	jmp    802978 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802973:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802978:	c9                   	leave  
  802979:	c3                   	ret    

0080297a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80297d:	6a 00                	push   $0x0
  80297f:	6a 00                	push   $0x0
  802981:	6a 00                	push   $0x0
  802983:	6a 00                	push   $0x0
  802985:	ff 75 08             	pushl  0x8(%ebp)
  802988:	6a 2d                	push   $0x2d
  80298a:	e8 ea f9 ff ff       	call   802379 <syscall>
  80298f:	83 c4 18             	add    $0x18,%esp
	return ;
  802992:	90                   	nop
}
  802993:	c9                   	leave  
  802994:	c3                   	ret    

00802995 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802995:	55                   	push   %ebp
  802996:	89 e5                	mov    %esp,%ebp
  802998:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802999:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80299c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80299f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	6a 00                	push   $0x0
  8029a7:	53                   	push   %ebx
  8029a8:	51                   	push   %ecx
  8029a9:	52                   	push   %edx
  8029aa:	50                   	push   %eax
  8029ab:	6a 2e                	push   $0x2e
  8029ad:	e8 c7 f9 ff ff       	call   802379 <syscall>
  8029b2:	83 c4 18             	add    $0x18,%esp
}
  8029b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029b8:	c9                   	leave  
  8029b9:	c3                   	ret    

008029ba <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8029bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 00                	push   $0x0
  8029c7:	6a 00                	push   $0x0
  8029c9:	52                   	push   %edx
  8029ca:	50                   	push   %eax
  8029cb:	6a 2f                	push   $0x2f
  8029cd:	e8 a7 f9 ff ff       	call   802379 <syscall>
  8029d2:	83 c4 18             	add    $0x18,%esp
}
  8029d5:	c9                   	leave  
  8029d6:	c3                   	ret    

008029d7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8029d7:	55                   	push   %ebp
  8029d8:	89 e5                	mov    %esp,%ebp
  8029da:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8029dd:	83 ec 0c             	sub    $0xc,%esp
  8029e0:	68 44 4b 80 00       	push   $0x804b44
  8029e5:	e8 8c e7 ff ff       	call   801176 <cprintf>
  8029ea:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8029ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8029f4:	83 ec 0c             	sub    $0xc,%esp
  8029f7:	68 70 4b 80 00       	push   $0x804b70
  8029fc:	e8 75 e7 ff ff       	call   801176 <cprintf>
  802a01:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802a04:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a08:	a1 38 51 80 00       	mov    0x805138,%eax
  802a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a10:	eb 56                	jmp    802a68 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802a12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a16:	74 1c                	je     802a34 <print_mem_block_lists+0x5d>
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 50 08             	mov    0x8(%eax),%edx
  802a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a21:	8b 48 08             	mov    0x8(%eax),%ecx
  802a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a27:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2a:	01 c8                	add    %ecx,%eax
  802a2c:	39 c2                	cmp    %eax,%edx
  802a2e:	73 04                	jae    802a34 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802a30:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 50 08             	mov    0x8(%eax),%edx
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a40:	01 c2                	add    %eax,%edx
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	8b 40 08             	mov    0x8(%eax),%eax
  802a48:	83 ec 04             	sub    $0x4,%esp
  802a4b:	52                   	push   %edx
  802a4c:	50                   	push   %eax
  802a4d:	68 85 4b 80 00       	push   $0x804b85
  802a52:	e8 1f e7 ff ff       	call   801176 <cprintf>
  802a57:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a60:	a1 40 51 80 00       	mov    0x805140,%eax
  802a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6c:	74 07                	je     802a75 <print_mem_block_lists+0x9e>
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	8b 00                	mov    (%eax),%eax
  802a73:	eb 05                	jmp    802a7a <print_mem_block_lists+0xa3>
  802a75:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7a:	a3 40 51 80 00       	mov    %eax,0x805140
  802a7f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a84:	85 c0                	test   %eax,%eax
  802a86:	75 8a                	jne    802a12 <print_mem_block_lists+0x3b>
  802a88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8c:	75 84                	jne    802a12 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802a8e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a92:	75 10                	jne    802aa4 <print_mem_block_lists+0xcd>
  802a94:	83 ec 0c             	sub    $0xc,%esp
  802a97:	68 94 4b 80 00       	push   $0x804b94
  802a9c:	e8 d5 e6 ff ff       	call   801176 <cprintf>
  802aa1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802aa4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802aab:	83 ec 0c             	sub    $0xc,%esp
  802aae:	68 b8 4b 80 00       	push   $0x804bb8
  802ab3:	e8 be e6 ff ff       	call   801176 <cprintf>
  802ab8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802abb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802abf:	a1 40 50 80 00       	mov    0x805040,%eax
  802ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac7:	eb 56                	jmp    802b1f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802ac9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802acd:	74 1c                	je     802aeb <print_mem_block_lists+0x114>
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 50 08             	mov    0x8(%eax),%edx
  802ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad8:	8b 48 08             	mov    0x8(%eax),%ecx
  802adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ade:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae1:	01 c8                	add    %ecx,%eax
  802ae3:	39 c2                	cmp    %eax,%edx
  802ae5:	73 04                	jae    802aeb <print_mem_block_lists+0x114>
			sorted = 0 ;
  802ae7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 50 08             	mov    0x8(%eax),%edx
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 40 0c             	mov    0xc(%eax),%eax
  802af7:	01 c2                	add    %eax,%edx
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 40 08             	mov    0x8(%eax),%eax
  802aff:	83 ec 04             	sub    $0x4,%esp
  802b02:	52                   	push   %edx
  802b03:	50                   	push   %eax
  802b04:	68 85 4b 80 00       	push   $0x804b85
  802b09:	e8 68 e6 ff ff       	call   801176 <cprintf>
  802b0e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802b17:	a1 48 50 80 00       	mov    0x805048,%eax
  802b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b23:	74 07                	je     802b2c <print_mem_block_lists+0x155>
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	eb 05                	jmp    802b31 <print_mem_block_lists+0x15a>
  802b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b31:	a3 48 50 80 00       	mov    %eax,0x805048
  802b36:	a1 48 50 80 00       	mov    0x805048,%eax
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	75 8a                	jne    802ac9 <print_mem_block_lists+0xf2>
  802b3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b43:	75 84                	jne    802ac9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802b45:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b49:	75 10                	jne    802b5b <print_mem_block_lists+0x184>
  802b4b:	83 ec 0c             	sub    $0xc,%esp
  802b4e:	68 d0 4b 80 00       	push   $0x804bd0
  802b53:	e8 1e e6 ff ff       	call   801176 <cprintf>
  802b58:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802b5b:	83 ec 0c             	sub    $0xc,%esp
  802b5e:	68 44 4b 80 00       	push   $0x804b44
  802b63:	e8 0e e6 ff ff       	call   801176 <cprintf>
  802b68:	83 c4 10             	add    $0x10,%esp

}
  802b6b:	90                   	nop
  802b6c:	c9                   	leave  
  802b6d:	c3                   	ret    

00802b6e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802b6e:	55                   	push   %ebp
  802b6f:	89 e5                	mov    %esp,%ebp
  802b71:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802b74:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802b7b:	00 00 00 
  802b7e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802b85:	00 00 00 
  802b88:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802b8f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802b92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b99:	e9 9e 00 00 00       	jmp    802c3c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802b9e:	a1 50 50 80 00       	mov    0x805050,%eax
  802ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba6:	c1 e2 04             	shl    $0x4,%edx
  802ba9:	01 d0                	add    %edx,%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	75 14                	jne    802bc3 <initialize_MemBlocksList+0x55>
  802baf:	83 ec 04             	sub    $0x4,%esp
  802bb2:	68 f8 4b 80 00       	push   $0x804bf8
  802bb7:	6a 46                	push   $0x46
  802bb9:	68 1b 4c 80 00       	push   $0x804c1b
  802bbe:	e8 ff e2 ff ff       	call   800ec2 <_panic>
  802bc3:	a1 50 50 80 00       	mov    0x805050,%eax
  802bc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bcb:	c1 e2 04             	shl    $0x4,%edx
  802bce:	01 d0                	add    %edx,%eax
  802bd0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802bd6:	89 10                	mov    %edx,(%eax)
  802bd8:	8b 00                	mov    (%eax),%eax
  802bda:	85 c0                	test   %eax,%eax
  802bdc:	74 18                	je     802bf6 <initialize_MemBlocksList+0x88>
  802bde:	a1 48 51 80 00       	mov    0x805148,%eax
  802be3:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802be9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802bec:	c1 e1 04             	shl    $0x4,%ecx
  802bef:	01 ca                	add    %ecx,%edx
  802bf1:	89 50 04             	mov    %edx,0x4(%eax)
  802bf4:	eb 12                	jmp    802c08 <initialize_MemBlocksList+0x9a>
  802bf6:	a1 50 50 80 00       	mov    0x805050,%eax
  802bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfe:	c1 e2 04             	shl    $0x4,%edx
  802c01:	01 d0                	add    %edx,%eax
  802c03:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c08:	a1 50 50 80 00       	mov    0x805050,%eax
  802c0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c10:	c1 e2 04             	shl    $0x4,%edx
  802c13:	01 d0                	add    %edx,%eax
  802c15:	a3 48 51 80 00       	mov    %eax,0x805148
  802c1a:	a1 50 50 80 00       	mov    0x805050,%eax
  802c1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c22:	c1 e2 04             	shl    $0x4,%edx
  802c25:	01 d0                	add    %edx,%eax
  802c27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2e:	a1 54 51 80 00       	mov    0x805154,%eax
  802c33:	40                   	inc    %eax
  802c34:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802c39:	ff 45 f4             	incl   -0xc(%ebp)
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c42:	0f 82 56 ff ff ff    	jb     802b9e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802c48:	90                   	nop
  802c49:	c9                   	leave  
  802c4a:	c3                   	ret    

00802c4b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802c4b:	55                   	push   %ebp
  802c4c:	89 e5                	mov    %esp,%ebp
  802c4e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	8b 00                	mov    (%eax),%eax
  802c56:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c59:	eb 19                	jmp    802c74 <find_block+0x29>
	{
		if(va==point->sva)
  802c5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c5e:	8b 40 08             	mov    0x8(%eax),%eax
  802c61:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c64:	75 05                	jne    802c6b <find_block+0x20>
		   return point;
  802c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c69:	eb 36                	jmp    802ca1 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	8b 40 08             	mov    0x8(%eax),%eax
  802c71:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c78:	74 07                	je     802c81 <find_block+0x36>
  802c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	eb 05                	jmp    802c86 <find_block+0x3b>
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
  802c86:	8b 55 08             	mov    0x8(%ebp),%edx
  802c89:	89 42 08             	mov    %eax,0x8(%edx)
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	8b 40 08             	mov    0x8(%eax),%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	75 c5                	jne    802c5b <find_block+0x10>
  802c96:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c9a:	75 bf                	jne    802c5b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802c9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ca1:	c9                   	leave  
  802ca2:	c3                   	ret    

00802ca3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802ca3:	55                   	push   %ebp
  802ca4:	89 e5                	mov    %esp,%ebp
  802ca6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802ca9:	a1 40 50 80 00       	mov    0x805040,%eax
  802cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802cb1:	a1 44 50 80 00       	mov    0x805044,%eax
  802cb6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802cbf:	74 24                	je     802ce5 <insert_sorted_allocList+0x42>
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	8b 50 08             	mov    0x8(%eax),%edx
  802cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cca:	8b 40 08             	mov    0x8(%eax),%eax
  802ccd:	39 c2                	cmp    %eax,%edx
  802ccf:	76 14                	jbe    802ce5 <insert_sorted_allocList+0x42>
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	8b 50 08             	mov    0x8(%eax),%edx
  802cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cda:	8b 40 08             	mov    0x8(%eax),%eax
  802cdd:	39 c2                	cmp    %eax,%edx
  802cdf:	0f 82 60 01 00 00    	jb     802e45 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802ce5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce9:	75 65                	jne    802d50 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802ceb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cef:	75 14                	jne    802d05 <insert_sorted_allocList+0x62>
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	68 f8 4b 80 00       	push   $0x804bf8
  802cf9:	6a 6b                	push   $0x6b
  802cfb:	68 1b 4c 80 00       	push   $0x804c1b
  802d00:	e8 bd e1 ff ff       	call   800ec2 <_panic>
  802d05:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0e:	89 10                	mov    %edx,(%eax)
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	74 0d                	je     802d26 <insert_sorted_allocList+0x83>
  802d19:	a1 40 50 80 00       	mov    0x805040,%eax
  802d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d21:	89 50 04             	mov    %edx,0x4(%eax)
  802d24:	eb 08                	jmp    802d2e <insert_sorted_allocList+0x8b>
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	a3 44 50 80 00       	mov    %eax,0x805044
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	a3 40 50 80 00       	mov    %eax,0x805040
  802d36:	8b 45 08             	mov    0x8(%ebp),%eax
  802d39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d40:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d45:	40                   	inc    %eax
  802d46:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d4b:	e9 dc 01 00 00       	jmp    802f2c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	8b 50 08             	mov    0x8(%eax),%edx
  802d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d59:	8b 40 08             	mov    0x8(%eax),%eax
  802d5c:	39 c2                	cmp    %eax,%edx
  802d5e:	77 6c                	ja     802dcc <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802d60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d64:	74 06                	je     802d6c <insert_sorted_allocList+0xc9>
  802d66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6a:	75 14                	jne    802d80 <insert_sorted_allocList+0xdd>
  802d6c:	83 ec 04             	sub    $0x4,%esp
  802d6f:	68 34 4c 80 00       	push   $0x804c34
  802d74:	6a 6f                	push   $0x6f
  802d76:	68 1b 4c 80 00       	push   $0x804c1b
  802d7b:	e8 42 e1 ff ff       	call   800ec2 <_panic>
  802d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d83:	8b 50 04             	mov    0x4(%eax),%edx
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	89 50 04             	mov    %edx,0x4(%eax)
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d92:	89 10                	mov    %edx,(%eax)
  802d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d97:	8b 40 04             	mov    0x4(%eax),%eax
  802d9a:	85 c0                	test   %eax,%eax
  802d9c:	74 0d                	je     802dab <insert_sorted_allocList+0x108>
  802d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da1:	8b 40 04             	mov    0x4(%eax),%eax
  802da4:	8b 55 08             	mov    0x8(%ebp),%edx
  802da7:	89 10                	mov    %edx,(%eax)
  802da9:	eb 08                	jmp    802db3 <insert_sorted_allocList+0x110>
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	a3 40 50 80 00       	mov    %eax,0x805040
  802db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db6:	8b 55 08             	mov    0x8(%ebp),%edx
  802db9:	89 50 04             	mov    %edx,0x4(%eax)
  802dbc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802dc1:	40                   	inc    %eax
  802dc2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802dc7:	e9 60 01 00 00       	jmp    802f2c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	8b 50 08             	mov    0x8(%eax),%edx
  802dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd5:	8b 40 08             	mov    0x8(%eax),%eax
  802dd8:	39 c2                	cmp    %eax,%edx
  802dda:	0f 82 4c 01 00 00    	jb     802f2c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802de0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de4:	75 14                	jne    802dfa <insert_sorted_allocList+0x157>
  802de6:	83 ec 04             	sub    $0x4,%esp
  802de9:	68 6c 4c 80 00       	push   $0x804c6c
  802dee:	6a 73                	push   $0x73
  802df0:	68 1b 4c 80 00       	push   $0x804c1b
  802df5:	e8 c8 e0 ff ff       	call   800ec2 <_panic>
  802dfa:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	89 50 04             	mov    %edx,0x4(%eax)
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	8b 40 04             	mov    0x4(%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 0c                	je     802e1c <insert_sorted_allocList+0x179>
  802e10:	a1 44 50 80 00       	mov    0x805044,%eax
  802e15:	8b 55 08             	mov    0x8(%ebp),%edx
  802e18:	89 10                	mov    %edx,(%eax)
  802e1a:	eb 08                	jmp    802e24 <insert_sorted_allocList+0x181>
  802e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1f:	a3 40 50 80 00       	mov    %eax,0x805040
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	a3 44 50 80 00       	mov    %eax,0x805044
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e35:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e3a:	40                   	inc    %eax
  802e3b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802e40:	e9 e7 00 00 00       	jmp    802f2c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802e4b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802e52:	a1 40 50 80 00       	mov    0x805040,%eax
  802e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e5a:	e9 9d 00 00 00       	jmp    802efc <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	8b 00                	mov    (%eax),%eax
  802e64:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	8b 50 08             	mov    0x8(%eax),%edx
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	8b 40 08             	mov    0x8(%eax),%eax
  802e73:	39 c2                	cmp    %eax,%edx
  802e75:	76 7d                	jbe    802ef4 <insert_sorted_allocList+0x251>
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	8b 50 08             	mov    0x8(%eax),%edx
  802e7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e80:	8b 40 08             	mov    0x8(%eax),%eax
  802e83:	39 c2                	cmp    %eax,%edx
  802e85:	73 6d                	jae    802ef4 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802e87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8b:	74 06                	je     802e93 <insert_sorted_allocList+0x1f0>
  802e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e91:	75 14                	jne    802ea7 <insert_sorted_allocList+0x204>
  802e93:	83 ec 04             	sub    $0x4,%esp
  802e96:	68 90 4c 80 00       	push   $0x804c90
  802e9b:	6a 7f                	push   $0x7f
  802e9d:	68 1b 4c 80 00       	push   $0x804c1b
  802ea2:	e8 1b e0 ff ff       	call   800ec2 <_panic>
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 10                	mov    (%eax),%edx
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	89 10                	mov    %edx,(%eax)
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	8b 00                	mov    (%eax),%eax
  802eb6:	85 c0                	test   %eax,%eax
  802eb8:	74 0b                	je     802ec5 <insert_sorted_allocList+0x222>
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec2:	89 50 04             	mov    %edx,0x4(%eax)
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecb:	89 10                	mov    %edx,(%eax)
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed3:	89 50 04             	mov    %edx,0x4(%eax)
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	8b 00                	mov    (%eax),%eax
  802edb:	85 c0                	test   %eax,%eax
  802edd:	75 08                	jne    802ee7 <insert_sorted_allocList+0x244>
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	a3 44 50 80 00       	mov    %eax,0x805044
  802ee7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802eec:	40                   	inc    %eax
  802eed:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802ef2:	eb 39                	jmp    802f2d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802ef4:	a1 48 50 80 00       	mov    0x805048,%eax
  802ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802efc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f00:	74 07                	je     802f09 <insert_sorted_allocList+0x266>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 00                	mov    (%eax),%eax
  802f07:	eb 05                	jmp    802f0e <insert_sorted_allocList+0x26b>
  802f09:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0e:	a3 48 50 80 00       	mov    %eax,0x805048
  802f13:	a1 48 50 80 00       	mov    0x805048,%eax
  802f18:	85 c0                	test   %eax,%eax
  802f1a:	0f 85 3f ff ff ff    	jne    802e5f <insert_sorted_allocList+0x1bc>
  802f20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f24:	0f 85 35 ff ff ff    	jne    802e5f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802f2a:	eb 01                	jmp    802f2d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802f2c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802f2d:	90                   	nop
  802f2e:	c9                   	leave  
  802f2f:	c3                   	ret    

00802f30 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802f30:	55                   	push   %ebp
  802f31:	89 e5                	mov    %esp,%ebp
  802f33:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802f36:	a1 38 51 80 00       	mov    0x805138,%eax
  802f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f3e:	e9 85 01 00 00       	jmp    8030c8 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 40 0c             	mov    0xc(%eax),%eax
  802f49:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f4c:	0f 82 6e 01 00 00    	jb     8030c0 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	8b 40 0c             	mov    0xc(%eax),%eax
  802f58:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f5b:	0f 85 8a 00 00 00    	jne    802feb <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802f61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f65:	75 17                	jne    802f7e <alloc_block_FF+0x4e>
  802f67:	83 ec 04             	sub    $0x4,%esp
  802f6a:	68 c4 4c 80 00       	push   $0x804cc4
  802f6f:	68 93 00 00 00       	push   $0x93
  802f74:	68 1b 4c 80 00       	push   $0x804c1b
  802f79:	e8 44 df ff ff       	call   800ec2 <_panic>
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 10                	je     802f97 <alloc_block_FF+0x67>
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	8b 00                	mov    (%eax),%eax
  802f8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f8f:	8b 52 04             	mov    0x4(%edx),%edx
  802f92:	89 50 04             	mov    %edx,0x4(%eax)
  802f95:	eb 0b                	jmp    802fa2 <alloc_block_FF+0x72>
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 40 04             	mov    0x4(%eax),%eax
  802f9d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 40 04             	mov    0x4(%eax),%eax
  802fa8:	85 c0                	test   %eax,%eax
  802faa:	74 0f                	je     802fbb <alloc_block_FF+0x8b>
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	8b 40 04             	mov    0x4(%eax),%eax
  802fb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb5:	8b 12                	mov    (%edx),%edx
  802fb7:	89 10                	mov    %edx,(%eax)
  802fb9:	eb 0a                	jmp    802fc5 <alloc_block_FF+0x95>
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	a3 38 51 80 00       	mov    %eax,0x805138
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd8:	a1 44 51 80 00       	mov    0x805144,%eax
  802fdd:	48                   	dec    %eax
  802fde:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	e9 10 01 00 00       	jmp    8030fb <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ff4:	0f 86 c6 00 00 00    	jbe    8030c0 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ffa:	a1 48 51 80 00       	mov    0x805148,%eax
  802fff:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 50 08             	mov    0x8(%eax),%edx
  803008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80300e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803011:	8b 55 08             	mov    0x8(%ebp),%edx
  803014:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803017:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80301b:	75 17                	jne    803034 <alloc_block_FF+0x104>
  80301d:	83 ec 04             	sub    $0x4,%esp
  803020:	68 c4 4c 80 00       	push   $0x804cc4
  803025:	68 9b 00 00 00       	push   $0x9b
  80302a:	68 1b 4c 80 00       	push   $0x804c1b
  80302f:	e8 8e de ff ff       	call   800ec2 <_panic>
  803034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803037:	8b 00                	mov    (%eax),%eax
  803039:	85 c0                	test   %eax,%eax
  80303b:	74 10                	je     80304d <alloc_block_FF+0x11d>
  80303d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803045:	8b 52 04             	mov    0x4(%edx),%edx
  803048:	89 50 04             	mov    %edx,0x4(%eax)
  80304b:	eb 0b                	jmp    803058 <alloc_block_FF+0x128>
  80304d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803050:	8b 40 04             	mov    0x4(%eax),%eax
  803053:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305b:	8b 40 04             	mov    0x4(%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 0f                	je     803071 <alloc_block_FF+0x141>
  803062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803065:	8b 40 04             	mov    0x4(%eax),%eax
  803068:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80306b:	8b 12                	mov    (%edx),%edx
  80306d:	89 10                	mov    %edx,(%eax)
  80306f:	eb 0a                	jmp    80307b <alloc_block_FF+0x14b>
  803071:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803074:	8b 00                	mov    (%eax),%eax
  803076:	a3 48 51 80 00       	mov    %eax,0x805148
  80307b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803087:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308e:	a1 54 51 80 00       	mov    0x805154,%eax
  803093:	48                   	dec    %eax
  803094:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	8b 50 08             	mov    0x8(%eax),%edx
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	01 c2                	add    %eax,%edx
  8030a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a7:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b0:	2b 45 08             	sub    0x8(%ebp),%eax
  8030b3:	89 c2                	mov    %eax,%edx
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8030bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030be:	eb 3b                	jmp    8030fb <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8030c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8030c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030cc:	74 07                	je     8030d5 <alloc_block_FF+0x1a5>
  8030ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d1:	8b 00                	mov    (%eax),%eax
  8030d3:	eb 05                	jmp    8030da <alloc_block_FF+0x1aa>
  8030d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030da:	a3 40 51 80 00       	mov    %eax,0x805140
  8030df:	a1 40 51 80 00       	mov    0x805140,%eax
  8030e4:	85 c0                	test   %eax,%eax
  8030e6:	0f 85 57 fe ff ff    	jne    802f43 <alloc_block_FF+0x13>
  8030ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f0:	0f 85 4d fe ff ff    	jne    802f43 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8030f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030fb:	c9                   	leave  
  8030fc:	c3                   	ret    

008030fd <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8030fd:	55                   	push   %ebp
  8030fe:	89 e5                	mov    %esp,%ebp
  803100:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  803103:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80310a:	a1 38 51 80 00       	mov    0x805138,%eax
  80310f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803112:	e9 df 00 00 00       	jmp    8031f6 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	8b 40 0c             	mov    0xc(%eax),%eax
  80311d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803120:	0f 82 c8 00 00 00    	jb     8031ee <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	8b 40 0c             	mov    0xc(%eax),%eax
  80312c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80312f:	0f 85 8a 00 00 00    	jne    8031bf <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803139:	75 17                	jne    803152 <alloc_block_BF+0x55>
  80313b:	83 ec 04             	sub    $0x4,%esp
  80313e:	68 c4 4c 80 00       	push   $0x804cc4
  803143:	68 b7 00 00 00       	push   $0xb7
  803148:	68 1b 4c 80 00       	push   $0x804c1b
  80314d:	e8 70 dd ff ff       	call   800ec2 <_panic>
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	85 c0                	test   %eax,%eax
  803159:	74 10                	je     80316b <alloc_block_BF+0x6e>
  80315b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315e:	8b 00                	mov    (%eax),%eax
  803160:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803163:	8b 52 04             	mov    0x4(%edx),%edx
  803166:	89 50 04             	mov    %edx,0x4(%eax)
  803169:	eb 0b                	jmp    803176 <alloc_block_BF+0x79>
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	8b 40 04             	mov    0x4(%eax),%eax
  803171:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803179:	8b 40 04             	mov    0x4(%eax),%eax
  80317c:	85 c0                	test   %eax,%eax
  80317e:	74 0f                	je     80318f <alloc_block_BF+0x92>
  803180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803183:	8b 40 04             	mov    0x4(%eax),%eax
  803186:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803189:	8b 12                	mov    (%edx),%edx
  80318b:	89 10                	mov    %edx,(%eax)
  80318d:	eb 0a                	jmp    803199 <alloc_block_BF+0x9c>
  80318f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803192:	8b 00                	mov    (%eax),%eax
  803194:	a3 38 51 80 00       	mov    %eax,0x805138
  803199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b1:	48                   	dec    %eax
  8031b2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	e9 4d 01 00 00       	jmp    80330c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c8:	76 24                	jbe    8031ee <alloc_block_BF+0xf1>
  8031ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031d3:	73 19                	jae    8031ee <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8031d5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	8b 40 08             	mov    0x8(%eax),%eax
  8031eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8031ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8031f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031fa:	74 07                	je     803203 <alloc_block_BF+0x106>
  8031fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ff:	8b 00                	mov    (%eax),%eax
  803201:	eb 05                	jmp    803208 <alloc_block_BF+0x10b>
  803203:	b8 00 00 00 00       	mov    $0x0,%eax
  803208:	a3 40 51 80 00       	mov    %eax,0x805140
  80320d:	a1 40 51 80 00       	mov    0x805140,%eax
  803212:	85 c0                	test   %eax,%eax
  803214:	0f 85 fd fe ff ff    	jne    803117 <alloc_block_BF+0x1a>
  80321a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80321e:	0f 85 f3 fe ff ff    	jne    803117 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803224:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803228:	0f 84 d9 00 00 00    	je     803307 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80322e:	a1 48 51 80 00       	mov    0x805148,%eax
  803233:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803239:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80323c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80323f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803242:	8b 55 08             	mov    0x8(%ebp),%edx
  803245:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803248:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80324c:	75 17                	jne    803265 <alloc_block_BF+0x168>
  80324e:	83 ec 04             	sub    $0x4,%esp
  803251:	68 c4 4c 80 00       	push   $0x804cc4
  803256:	68 c7 00 00 00       	push   $0xc7
  80325b:	68 1b 4c 80 00       	push   $0x804c1b
  803260:	e8 5d dc ff ff       	call   800ec2 <_panic>
  803265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803268:	8b 00                	mov    (%eax),%eax
  80326a:	85 c0                	test   %eax,%eax
  80326c:	74 10                	je     80327e <alloc_block_BF+0x181>
  80326e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803271:	8b 00                	mov    (%eax),%eax
  803273:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803276:	8b 52 04             	mov    0x4(%edx),%edx
  803279:	89 50 04             	mov    %edx,0x4(%eax)
  80327c:	eb 0b                	jmp    803289 <alloc_block_BF+0x18c>
  80327e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803281:	8b 40 04             	mov    0x4(%eax),%eax
  803284:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328c:	8b 40 04             	mov    0x4(%eax),%eax
  80328f:	85 c0                	test   %eax,%eax
  803291:	74 0f                	je     8032a2 <alloc_block_BF+0x1a5>
  803293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803296:	8b 40 04             	mov    0x4(%eax),%eax
  803299:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80329c:	8b 12                	mov    (%edx),%edx
  80329e:	89 10                	mov    %edx,(%eax)
  8032a0:	eb 0a                	jmp    8032ac <alloc_block_BF+0x1af>
  8032a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a5:	8b 00                	mov    (%eax),%eax
  8032a7:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032bf:	a1 54 51 80 00       	mov    0x805154,%eax
  8032c4:	48                   	dec    %eax
  8032c5:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8032ca:	83 ec 08             	sub    $0x8,%esp
  8032cd:	ff 75 ec             	pushl  -0x14(%ebp)
  8032d0:	68 38 51 80 00       	push   $0x805138
  8032d5:	e8 71 f9 ff ff       	call   802c4b <find_block>
  8032da:	83 c4 10             	add    $0x10,%esp
  8032dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8032e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e3:	8b 50 08             	mov    0x8(%eax),%edx
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	01 c2                	add    %eax,%edx
  8032eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ee:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8032f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f7:	2b 45 08             	sub    0x8(%ebp),%eax
  8032fa:	89 c2                	mov    %eax,%edx
  8032fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ff:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803305:	eb 05                	jmp    80330c <alloc_block_BF+0x20f>
	}
	return NULL;
  803307:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80330c:	c9                   	leave  
  80330d:	c3                   	ret    

0080330e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80330e:	55                   	push   %ebp
  80330f:	89 e5                	mov    %esp,%ebp
  803311:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803314:	a1 28 50 80 00       	mov    0x805028,%eax
  803319:	85 c0                	test   %eax,%eax
  80331b:	0f 85 de 01 00 00    	jne    8034ff <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803321:	a1 38 51 80 00       	mov    0x805138,%eax
  803326:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803329:	e9 9e 01 00 00       	jmp    8034cc <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80332e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803331:	8b 40 0c             	mov    0xc(%eax),%eax
  803334:	3b 45 08             	cmp    0x8(%ebp),%eax
  803337:	0f 82 87 01 00 00    	jb     8034c4 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80333d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803340:	8b 40 0c             	mov    0xc(%eax),%eax
  803343:	3b 45 08             	cmp    0x8(%ebp),%eax
  803346:	0f 85 95 00 00 00    	jne    8033e1 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80334c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803350:	75 17                	jne    803369 <alloc_block_NF+0x5b>
  803352:	83 ec 04             	sub    $0x4,%esp
  803355:	68 c4 4c 80 00       	push   $0x804cc4
  80335a:	68 e0 00 00 00       	push   $0xe0
  80335f:	68 1b 4c 80 00       	push   $0x804c1b
  803364:	e8 59 db ff ff       	call   800ec2 <_panic>
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	74 10                	je     803382 <alloc_block_NF+0x74>
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	8b 00                	mov    (%eax),%eax
  803377:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80337a:	8b 52 04             	mov    0x4(%edx),%edx
  80337d:	89 50 04             	mov    %edx,0x4(%eax)
  803380:	eb 0b                	jmp    80338d <alloc_block_NF+0x7f>
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	8b 40 04             	mov    0x4(%eax),%eax
  803388:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	8b 40 04             	mov    0x4(%eax),%eax
  803393:	85 c0                	test   %eax,%eax
  803395:	74 0f                	je     8033a6 <alloc_block_NF+0x98>
  803397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339a:	8b 40 04             	mov    0x4(%eax),%eax
  80339d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033a0:	8b 12                	mov    (%edx),%edx
  8033a2:	89 10                	mov    %edx,(%eax)
  8033a4:	eb 0a                	jmp    8033b0 <alloc_block_NF+0xa2>
  8033a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a9:	8b 00                	mov    (%eax),%eax
  8033ab:	a3 38 51 80 00       	mov    %eax,0x805138
  8033b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c8:	48                   	dec    %eax
  8033c9:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8033ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d1:	8b 40 08             	mov    0x8(%eax),%eax
  8033d4:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8033d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dc:	e9 f8 04 00 00       	jmp    8038d9 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8033e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033ea:	0f 86 d4 00 00 00    	jbe    8034c4 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8033f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8033f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fb:	8b 50 08             	mov    0x8(%eax),%edx
  8033fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803401:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803407:	8b 55 08             	mov    0x8(%ebp),%edx
  80340a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80340d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803411:	75 17                	jne    80342a <alloc_block_NF+0x11c>
  803413:	83 ec 04             	sub    $0x4,%esp
  803416:	68 c4 4c 80 00       	push   $0x804cc4
  80341b:	68 e9 00 00 00       	push   $0xe9
  803420:	68 1b 4c 80 00       	push   $0x804c1b
  803425:	e8 98 da ff ff       	call   800ec2 <_panic>
  80342a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342d:	8b 00                	mov    (%eax),%eax
  80342f:	85 c0                	test   %eax,%eax
  803431:	74 10                	je     803443 <alloc_block_NF+0x135>
  803433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803436:	8b 00                	mov    (%eax),%eax
  803438:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80343b:	8b 52 04             	mov    0x4(%edx),%edx
  80343e:	89 50 04             	mov    %edx,0x4(%eax)
  803441:	eb 0b                	jmp    80344e <alloc_block_NF+0x140>
  803443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803446:	8b 40 04             	mov    0x4(%eax),%eax
  803449:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80344e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803451:	8b 40 04             	mov    0x4(%eax),%eax
  803454:	85 c0                	test   %eax,%eax
  803456:	74 0f                	je     803467 <alloc_block_NF+0x159>
  803458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345b:	8b 40 04             	mov    0x4(%eax),%eax
  80345e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803461:	8b 12                	mov    (%edx),%edx
  803463:	89 10                	mov    %edx,(%eax)
  803465:	eb 0a                	jmp    803471 <alloc_block_NF+0x163>
  803467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346a:	8b 00                	mov    (%eax),%eax
  80346c:	a3 48 51 80 00       	mov    %eax,0x805148
  803471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803474:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80347a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803484:	a1 54 51 80 00       	mov    0x805154,%eax
  803489:	48                   	dec    %eax
  80348a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80348f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803492:	8b 40 08             	mov    0x8(%eax),%eax
  803495:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80349a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349d:	8b 50 08             	mov    0x8(%eax),%edx
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	01 c2                	add    %eax,%edx
  8034a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a8:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8034ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8034b4:	89 c2                	mov    %eax,%edx
  8034b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b9:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8034bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bf:	e9 15 04 00 00       	jmp    8038d9 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8034c4:	a1 40 51 80 00       	mov    0x805140,%eax
  8034c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d0:	74 07                	je     8034d9 <alloc_block_NF+0x1cb>
  8034d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d5:	8b 00                	mov    (%eax),%eax
  8034d7:	eb 05                	jmp    8034de <alloc_block_NF+0x1d0>
  8034d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034de:	a3 40 51 80 00       	mov    %eax,0x805140
  8034e3:	a1 40 51 80 00       	mov    0x805140,%eax
  8034e8:	85 c0                	test   %eax,%eax
  8034ea:	0f 85 3e fe ff ff    	jne    80332e <alloc_block_NF+0x20>
  8034f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034f4:	0f 85 34 fe ff ff    	jne    80332e <alloc_block_NF+0x20>
  8034fa:	e9 d5 03 00 00       	jmp    8038d4 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8034ff:	a1 38 51 80 00       	mov    0x805138,%eax
  803504:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803507:	e9 b1 01 00 00       	jmp    8036bd <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80350c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350f:	8b 50 08             	mov    0x8(%eax),%edx
  803512:	a1 28 50 80 00       	mov    0x805028,%eax
  803517:	39 c2                	cmp    %eax,%edx
  803519:	0f 82 96 01 00 00    	jb     8036b5 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80351f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803522:	8b 40 0c             	mov    0xc(%eax),%eax
  803525:	3b 45 08             	cmp    0x8(%ebp),%eax
  803528:	0f 82 87 01 00 00    	jb     8036b5 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803531:	8b 40 0c             	mov    0xc(%eax),%eax
  803534:	3b 45 08             	cmp    0x8(%ebp),%eax
  803537:	0f 85 95 00 00 00    	jne    8035d2 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80353d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803541:	75 17                	jne    80355a <alloc_block_NF+0x24c>
  803543:	83 ec 04             	sub    $0x4,%esp
  803546:	68 c4 4c 80 00       	push   $0x804cc4
  80354b:	68 fc 00 00 00       	push   $0xfc
  803550:	68 1b 4c 80 00       	push   $0x804c1b
  803555:	e8 68 d9 ff ff       	call   800ec2 <_panic>
  80355a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355d:	8b 00                	mov    (%eax),%eax
  80355f:	85 c0                	test   %eax,%eax
  803561:	74 10                	je     803573 <alloc_block_NF+0x265>
  803563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803566:	8b 00                	mov    (%eax),%eax
  803568:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80356b:	8b 52 04             	mov    0x4(%edx),%edx
  80356e:	89 50 04             	mov    %edx,0x4(%eax)
  803571:	eb 0b                	jmp    80357e <alloc_block_NF+0x270>
  803573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803576:	8b 40 04             	mov    0x4(%eax),%eax
  803579:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80357e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803581:	8b 40 04             	mov    0x4(%eax),%eax
  803584:	85 c0                	test   %eax,%eax
  803586:	74 0f                	je     803597 <alloc_block_NF+0x289>
  803588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358b:	8b 40 04             	mov    0x4(%eax),%eax
  80358e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803591:	8b 12                	mov    (%edx),%edx
  803593:	89 10                	mov    %edx,(%eax)
  803595:	eb 0a                	jmp    8035a1 <alloc_block_NF+0x293>
  803597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359a:	8b 00                	mov    (%eax),%eax
  80359c:	a3 38 51 80 00       	mov    %eax,0x805138
  8035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b4:	a1 44 51 80 00       	mov    0x805144,%eax
  8035b9:	48                   	dec    %eax
  8035ba:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8035bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c2:	8b 40 08             	mov    0x8(%eax),%eax
  8035c5:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8035ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cd:	e9 07 03 00 00       	jmp    8038d9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8035d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035db:	0f 86 d4 00 00 00    	jbe    8036b5 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8035e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8035e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ec:	8b 50 08             	mov    0x8(%eax),%edx
  8035ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8035f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8035fb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8035fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803602:	75 17                	jne    80361b <alloc_block_NF+0x30d>
  803604:	83 ec 04             	sub    $0x4,%esp
  803607:	68 c4 4c 80 00       	push   $0x804cc4
  80360c:	68 04 01 00 00       	push   $0x104
  803611:	68 1b 4c 80 00       	push   $0x804c1b
  803616:	e8 a7 d8 ff ff       	call   800ec2 <_panic>
  80361b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361e:	8b 00                	mov    (%eax),%eax
  803620:	85 c0                	test   %eax,%eax
  803622:	74 10                	je     803634 <alloc_block_NF+0x326>
  803624:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803627:	8b 00                	mov    (%eax),%eax
  803629:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80362c:	8b 52 04             	mov    0x4(%edx),%edx
  80362f:	89 50 04             	mov    %edx,0x4(%eax)
  803632:	eb 0b                	jmp    80363f <alloc_block_NF+0x331>
  803634:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803637:	8b 40 04             	mov    0x4(%eax),%eax
  80363a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80363f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803642:	8b 40 04             	mov    0x4(%eax),%eax
  803645:	85 c0                	test   %eax,%eax
  803647:	74 0f                	je     803658 <alloc_block_NF+0x34a>
  803649:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364c:	8b 40 04             	mov    0x4(%eax),%eax
  80364f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803652:	8b 12                	mov    (%edx),%edx
  803654:	89 10                	mov    %edx,(%eax)
  803656:	eb 0a                	jmp    803662 <alloc_block_NF+0x354>
  803658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365b:	8b 00                	mov    (%eax),%eax
  80365d:	a3 48 51 80 00       	mov    %eax,0x805148
  803662:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803665:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80366b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803675:	a1 54 51 80 00       	mov    0x805154,%eax
  80367a:	48                   	dec    %eax
  80367b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803683:	8b 40 08             	mov    0x8(%eax),%eax
  803686:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80368b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368e:	8b 50 08             	mov    0x8(%eax),%edx
  803691:	8b 45 08             	mov    0x8(%ebp),%eax
  803694:	01 c2                	add    %eax,%edx
  803696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803699:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80369c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369f:	8b 40 0c             	mov    0xc(%eax),%eax
  8036a2:	2b 45 08             	sub    0x8(%ebp),%eax
  8036a5:	89 c2                	mov    %eax,%edx
  8036a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036aa:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8036ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b0:	e9 24 02 00 00       	jmp    8038d9 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8036b5:	a1 40 51 80 00       	mov    0x805140,%eax
  8036ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036c1:	74 07                	je     8036ca <alloc_block_NF+0x3bc>
  8036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c6:	8b 00                	mov    (%eax),%eax
  8036c8:	eb 05                	jmp    8036cf <alloc_block_NF+0x3c1>
  8036ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8036cf:	a3 40 51 80 00       	mov    %eax,0x805140
  8036d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8036d9:	85 c0                	test   %eax,%eax
  8036db:	0f 85 2b fe ff ff    	jne    80350c <alloc_block_NF+0x1fe>
  8036e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e5:	0f 85 21 fe ff ff    	jne    80350c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8036eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8036f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036f3:	e9 ae 01 00 00       	jmp    8038a6 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8036f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fb:	8b 50 08             	mov    0x8(%eax),%edx
  8036fe:	a1 28 50 80 00       	mov    0x805028,%eax
  803703:	39 c2                	cmp    %eax,%edx
  803705:	0f 83 93 01 00 00    	jae    80389e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80370b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370e:	8b 40 0c             	mov    0xc(%eax),%eax
  803711:	3b 45 08             	cmp    0x8(%ebp),%eax
  803714:	0f 82 84 01 00 00    	jb     80389e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80371a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371d:	8b 40 0c             	mov    0xc(%eax),%eax
  803720:	3b 45 08             	cmp    0x8(%ebp),%eax
  803723:	0f 85 95 00 00 00    	jne    8037be <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80372d:	75 17                	jne    803746 <alloc_block_NF+0x438>
  80372f:	83 ec 04             	sub    $0x4,%esp
  803732:	68 c4 4c 80 00       	push   $0x804cc4
  803737:	68 14 01 00 00       	push   $0x114
  80373c:	68 1b 4c 80 00       	push   $0x804c1b
  803741:	e8 7c d7 ff ff       	call   800ec2 <_panic>
  803746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803749:	8b 00                	mov    (%eax),%eax
  80374b:	85 c0                	test   %eax,%eax
  80374d:	74 10                	je     80375f <alloc_block_NF+0x451>
  80374f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803752:	8b 00                	mov    (%eax),%eax
  803754:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803757:	8b 52 04             	mov    0x4(%edx),%edx
  80375a:	89 50 04             	mov    %edx,0x4(%eax)
  80375d:	eb 0b                	jmp    80376a <alloc_block_NF+0x45c>
  80375f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803762:	8b 40 04             	mov    0x4(%eax),%eax
  803765:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80376a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376d:	8b 40 04             	mov    0x4(%eax),%eax
  803770:	85 c0                	test   %eax,%eax
  803772:	74 0f                	je     803783 <alloc_block_NF+0x475>
  803774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803777:	8b 40 04             	mov    0x4(%eax),%eax
  80377a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80377d:	8b 12                	mov    (%edx),%edx
  80377f:	89 10                	mov    %edx,(%eax)
  803781:	eb 0a                	jmp    80378d <alloc_block_NF+0x47f>
  803783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803786:	8b 00                	mov    (%eax),%eax
  803788:	a3 38 51 80 00       	mov    %eax,0x805138
  80378d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803799:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8037a5:	48                   	dec    %eax
  8037a6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	8b 40 08             	mov    0x8(%eax),%eax
  8037b1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8037b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b9:	e9 1b 01 00 00       	jmp    8038d9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8037be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037c7:	0f 86 d1 00 00 00    	jbe    80389e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8037cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8037d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8037d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d8:	8b 50 08             	mov    0x8(%eax),%edx
  8037db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037de:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8037e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8037ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037ee:	75 17                	jne    803807 <alloc_block_NF+0x4f9>
  8037f0:	83 ec 04             	sub    $0x4,%esp
  8037f3:	68 c4 4c 80 00       	push   $0x804cc4
  8037f8:	68 1c 01 00 00       	push   $0x11c
  8037fd:	68 1b 4c 80 00       	push   $0x804c1b
  803802:	e8 bb d6 ff ff       	call   800ec2 <_panic>
  803807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	85 c0                	test   %eax,%eax
  80380e:	74 10                	je     803820 <alloc_block_NF+0x512>
  803810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803813:	8b 00                	mov    (%eax),%eax
  803815:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803818:	8b 52 04             	mov    0x4(%edx),%edx
  80381b:	89 50 04             	mov    %edx,0x4(%eax)
  80381e:	eb 0b                	jmp    80382b <alloc_block_NF+0x51d>
  803820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803823:	8b 40 04             	mov    0x4(%eax),%eax
  803826:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80382b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80382e:	8b 40 04             	mov    0x4(%eax),%eax
  803831:	85 c0                	test   %eax,%eax
  803833:	74 0f                	je     803844 <alloc_block_NF+0x536>
  803835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803838:	8b 40 04             	mov    0x4(%eax),%eax
  80383b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80383e:	8b 12                	mov    (%edx),%edx
  803840:	89 10                	mov    %edx,(%eax)
  803842:	eb 0a                	jmp    80384e <alloc_block_NF+0x540>
  803844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803847:	8b 00                	mov    (%eax),%eax
  803849:	a3 48 51 80 00       	mov    %eax,0x805148
  80384e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803851:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803857:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803861:	a1 54 51 80 00       	mov    0x805154,%eax
  803866:	48                   	dec    %eax
  803867:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80386c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80386f:	8b 40 08             	mov    0x8(%eax),%eax
  803872:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387a:	8b 50 08             	mov    0x8(%eax),%edx
  80387d:	8b 45 08             	mov    0x8(%ebp),%eax
  803880:	01 c2                	add    %eax,%edx
  803882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803885:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388b:	8b 40 0c             	mov    0xc(%eax),%eax
  80388e:	2b 45 08             	sub    0x8(%ebp),%eax
  803891:	89 c2                	mov    %eax,%edx
  803893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803896:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803899:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80389c:	eb 3b                	jmp    8038d9 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80389e:	a1 40 51 80 00       	mov    0x805140,%eax
  8038a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038aa:	74 07                	je     8038b3 <alloc_block_NF+0x5a5>
  8038ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038af:	8b 00                	mov    (%eax),%eax
  8038b1:	eb 05                	jmp    8038b8 <alloc_block_NF+0x5aa>
  8038b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b8:	a3 40 51 80 00       	mov    %eax,0x805140
  8038bd:	a1 40 51 80 00       	mov    0x805140,%eax
  8038c2:	85 c0                	test   %eax,%eax
  8038c4:	0f 85 2e fe ff ff    	jne    8036f8 <alloc_block_NF+0x3ea>
  8038ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ce:	0f 85 24 fe ff ff    	jne    8036f8 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8038d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038d9:	c9                   	leave  
  8038da:	c3                   	ret    

008038db <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8038db:	55                   	push   %ebp
  8038dc:	89 e5                	mov    %esp,%ebp
  8038de:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8038e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8038e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8038e9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8038ee:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8038f1:	a1 38 51 80 00       	mov    0x805138,%eax
  8038f6:	85 c0                	test   %eax,%eax
  8038f8:	74 14                	je     80390e <insert_sorted_with_merge_freeList+0x33>
  8038fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fd:	8b 50 08             	mov    0x8(%eax),%edx
  803900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803903:	8b 40 08             	mov    0x8(%eax),%eax
  803906:	39 c2                	cmp    %eax,%edx
  803908:	0f 87 9b 01 00 00    	ja     803aa9 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80390e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803912:	75 17                	jne    80392b <insert_sorted_with_merge_freeList+0x50>
  803914:	83 ec 04             	sub    $0x4,%esp
  803917:	68 f8 4b 80 00       	push   $0x804bf8
  80391c:	68 38 01 00 00       	push   $0x138
  803921:	68 1b 4c 80 00       	push   $0x804c1b
  803926:	e8 97 d5 ff ff       	call   800ec2 <_panic>
  80392b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803931:	8b 45 08             	mov    0x8(%ebp),%eax
  803934:	89 10                	mov    %edx,(%eax)
  803936:	8b 45 08             	mov    0x8(%ebp),%eax
  803939:	8b 00                	mov    (%eax),%eax
  80393b:	85 c0                	test   %eax,%eax
  80393d:	74 0d                	je     80394c <insert_sorted_with_merge_freeList+0x71>
  80393f:	a1 38 51 80 00       	mov    0x805138,%eax
  803944:	8b 55 08             	mov    0x8(%ebp),%edx
  803947:	89 50 04             	mov    %edx,0x4(%eax)
  80394a:	eb 08                	jmp    803954 <insert_sorted_with_merge_freeList+0x79>
  80394c:	8b 45 08             	mov    0x8(%ebp),%eax
  80394f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803954:	8b 45 08             	mov    0x8(%ebp),%eax
  803957:	a3 38 51 80 00       	mov    %eax,0x805138
  80395c:	8b 45 08             	mov    0x8(%ebp),%eax
  80395f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803966:	a1 44 51 80 00       	mov    0x805144,%eax
  80396b:	40                   	inc    %eax
  80396c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803971:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803975:	0f 84 a8 06 00 00    	je     804023 <insert_sorted_with_merge_freeList+0x748>
  80397b:	8b 45 08             	mov    0x8(%ebp),%eax
  80397e:	8b 50 08             	mov    0x8(%eax),%edx
  803981:	8b 45 08             	mov    0x8(%ebp),%eax
  803984:	8b 40 0c             	mov    0xc(%eax),%eax
  803987:	01 c2                	add    %eax,%edx
  803989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80398c:	8b 40 08             	mov    0x8(%eax),%eax
  80398f:	39 c2                	cmp    %eax,%edx
  803991:	0f 85 8c 06 00 00    	jne    804023 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803997:	8b 45 08             	mov    0x8(%ebp),%eax
  80399a:	8b 50 0c             	mov    0xc(%eax),%edx
  80399d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8039a3:	01 c2                	add    %eax,%edx
  8039a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a8:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8039ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039af:	75 17                	jne    8039c8 <insert_sorted_with_merge_freeList+0xed>
  8039b1:	83 ec 04             	sub    $0x4,%esp
  8039b4:	68 c4 4c 80 00       	push   $0x804cc4
  8039b9:	68 3c 01 00 00       	push   $0x13c
  8039be:	68 1b 4c 80 00       	push   $0x804c1b
  8039c3:	e8 fa d4 ff ff       	call   800ec2 <_panic>
  8039c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039cb:	8b 00                	mov    (%eax),%eax
  8039cd:	85 c0                	test   %eax,%eax
  8039cf:	74 10                	je     8039e1 <insert_sorted_with_merge_freeList+0x106>
  8039d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d4:	8b 00                	mov    (%eax),%eax
  8039d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039d9:	8b 52 04             	mov    0x4(%edx),%edx
  8039dc:	89 50 04             	mov    %edx,0x4(%eax)
  8039df:	eb 0b                	jmp    8039ec <insert_sorted_with_merge_freeList+0x111>
  8039e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e4:	8b 40 04             	mov    0x4(%eax),%eax
  8039e7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ef:	8b 40 04             	mov    0x4(%eax),%eax
  8039f2:	85 c0                	test   %eax,%eax
  8039f4:	74 0f                	je     803a05 <insert_sorted_with_merge_freeList+0x12a>
  8039f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f9:	8b 40 04             	mov    0x4(%eax),%eax
  8039fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039ff:	8b 12                	mov    (%edx),%edx
  803a01:	89 10                	mov    %edx,(%eax)
  803a03:	eb 0a                	jmp    803a0f <insert_sorted_with_merge_freeList+0x134>
  803a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a08:	8b 00                	mov    (%eax),%eax
  803a0a:	a3 38 51 80 00       	mov    %eax,0x805138
  803a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a22:	a1 44 51 80 00       	mov    0x805144,%eax
  803a27:	48                   	dec    %eax
  803a28:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a30:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803a41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a45:	75 17                	jne    803a5e <insert_sorted_with_merge_freeList+0x183>
  803a47:	83 ec 04             	sub    $0x4,%esp
  803a4a:	68 f8 4b 80 00       	push   $0x804bf8
  803a4f:	68 3f 01 00 00       	push   $0x13f
  803a54:	68 1b 4c 80 00       	push   $0x804c1b
  803a59:	e8 64 d4 ff ff       	call   800ec2 <_panic>
  803a5e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a67:	89 10                	mov    %edx,(%eax)
  803a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6c:	8b 00                	mov    (%eax),%eax
  803a6e:	85 c0                	test   %eax,%eax
  803a70:	74 0d                	je     803a7f <insert_sorted_with_merge_freeList+0x1a4>
  803a72:	a1 48 51 80 00       	mov    0x805148,%eax
  803a77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a7a:	89 50 04             	mov    %edx,0x4(%eax)
  803a7d:	eb 08                	jmp    803a87 <insert_sorted_with_merge_freeList+0x1ac>
  803a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a82:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a8a:	a3 48 51 80 00       	mov    %eax,0x805148
  803a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a99:	a1 54 51 80 00       	mov    0x805154,%eax
  803a9e:	40                   	inc    %eax
  803a9f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803aa4:	e9 7a 05 00 00       	jmp    804023 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aac:	8b 50 08             	mov    0x8(%eax),%edx
  803aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ab2:	8b 40 08             	mov    0x8(%eax),%eax
  803ab5:	39 c2                	cmp    %eax,%edx
  803ab7:	0f 82 14 01 00 00    	jb     803bd1 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac0:	8b 50 08             	mov    0x8(%eax),%edx
  803ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac6:	8b 40 0c             	mov    0xc(%eax),%eax
  803ac9:	01 c2                	add    %eax,%edx
  803acb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ace:	8b 40 08             	mov    0x8(%eax),%eax
  803ad1:	39 c2                	cmp    %eax,%edx
  803ad3:	0f 85 90 00 00 00    	jne    803b69 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803adc:	8b 50 0c             	mov    0xc(%eax),%edx
  803adf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae2:	8b 40 0c             	mov    0xc(%eax),%eax
  803ae5:	01 c2                	add    %eax,%edx
  803ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aea:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803aed:	8b 45 08             	mov    0x8(%ebp),%eax
  803af0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803af7:	8b 45 08             	mov    0x8(%ebp),%eax
  803afa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803b01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b05:	75 17                	jne    803b1e <insert_sorted_with_merge_freeList+0x243>
  803b07:	83 ec 04             	sub    $0x4,%esp
  803b0a:	68 f8 4b 80 00       	push   $0x804bf8
  803b0f:	68 49 01 00 00       	push   $0x149
  803b14:	68 1b 4c 80 00       	push   $0x804c1b
  803b19:	e8 a4 d3 ff ff       	call   800ec2 <_panic>
  803b1e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b24:	8b 45 08             	mov    0x8(%ebp),%eax
  803b27:	89 10                	mov    %edx,(%eax)
  803b29:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2c:	8b 00                	mov    (%eax),%eax
  803b2e:	85 c0                	test   %eax,%eax
  803b30:	74 0d                	je     803b3f <insert_sorted_with_merge_freeList+0x264>
  803b32:	a1 48 51 80 00       	mov    0x805148,%eax
  803b37:	8b 55 08             	mov    0x8(%ebp),%edx
  803b3a:	89 50 04             	mov    %edx,0x4(%eax)
  803b3d:	eb 08                	jmp    803b47 <insert_sorted_with_merge_freeList+0x26c>
  803b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b42:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b47:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4a:	a3 48 51 80 00       	mov    %eax,0x805148
  803b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b59:	a1 54 51 80 00       	mov    0x805154,%eax
  803b5e:	40                   	inc    %eax
  803b5f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b64:	e9 bb 04 00 00       	jmp    804024 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803b69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b6d:	75 17                	jne    803b86 <insert_sorted_with_merge_freeList+0x2ab>
  803b6f:	83 ec 04             	sub    $0x4,%esp
  803b72:	68 6c 4c 80 00       	push   $0x804c6c
  803b77:	68 4c 01 00 00       	push   $0x14c
  803b7c:	68 1b 4c 80 00       	push   $0x804c1b
  803b81:	e8 3c d3 ff ff       	call   800ec2 <_panic>
  803b86:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8f:	89 50 04             	mov    %edx,0x4(%eax)
  803b92:	8b 45 08             	mov    0x8(%ebp),%eax
  803b95:	8b 40 04             	mov    0x4(%eax),%eax
  803b98:	85 c0                	test   %eax,%eax
  803b9a:	74 0c                	je     803ba8 <insert_sorted_with_merge_freeList+0x2cd>
  803b9c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  803ba4:	89 10                	mov    %edx,(%eax)
  803ba6:	eb 08                	jmp    803bb0 <insert_sorted_with_merge_freeList+0x2d5>
  803ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bab:	a3 38 51 80 00       	mov    %eax,0x805138
  803bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bc1:	a1 44 51 80 00       	mov    0x805144,%eax
  803bc6:	40                   	inc    %eax
  803bc7:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803bcc:	e9 53 04 00 00       	jmp    804024 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803bd1:	a1 38 51 80 00       	mov    0x805138,%eax
  803bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bd9:	e9 15 04 00 00       	jmp    803ff3 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be1:	8b 00                	mov    (%eax),%eax
  803be3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803be6:	8b 45 08             	mov    0x8(%ebp),%eax
  803be9:	8b 50 08             	mov    0x8(%eax),%edx
  803bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bef:	8b 40 08             	mov    0x8(%eax),%eax
  803bf2:	39 c2                	cmp    %eax,%edx
  803bf4:	0f 86 f1 03 00 00    	jbe    803feb <insert_sorted_with_merge_freeList+0x710>
  803bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfd:	8b 50 08             	mov    0x8(%eax),%edx
  803c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c03:	8b 40 08             	mov    0x8(%eax),%eax
  803c06:	39 c2                	cmp    %eax,%edx
  803c08:	0f 83 dd 03 00 00    	jae    803feb <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c11:	8b 50 08             	mov    0x8(%eax),%edx
  803c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c17:	8b 40 0c             	mov    0xc(%eax),%eax
  803c1a:	01 c2                	add    %eax,%edx
  803c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1f:	8b 40 08             	mov    0x8(%eax),%eax
  803c22:	39 c2                	cmp    %eax,%edx
  803c24:	0f 85 b9 01 00 00    	jne    803de3 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2d:	8b 50 08             	mov    0x8(%eax),%edx
  803c30:	8b 45 08             	mov    0x8(%ebp),%eax
  803c33:	8b 40 0c             	mov    0xc(%eax),%eax
  803c36:	01 c2                	add    %eax,%edx
  803c38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c3b:	8b 40 08             	mov    0x8(%eax),%eax
  803c3e:	39 c2                	cmp    %eax,%edx
  803c40:	0f 85 0d 01 00 00    	jne    803d53 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c49:	8b 50 0c             	mov    0xc(%eax),%edx
  803c4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c4f:	8b 40 0c             	mov    0xc(%eax),%eax
  803c52:	01 c2                	add    %eax,%edx
  803c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c57:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803c5a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c5e:	75 17                	jne    803c77 <insert_sorted_with_merge_freeList+0x39c>
  803c60:	83 ec 04             	sub    $0x4,%esp
  803c63:	68 c4 4c 80 00       	push   $0x804cc4
  803c68:	68 5c 01 00 00       	push   $0x15c
  803c6d:	68 1b 4c 80 00       	push   $0x804c1b
  803c72:	e8 4b d2 ff ff       	call   800ec2 <_panic>
  803c77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c7a:	8b 00                	mov    (%eax),%eax
  803c7c:	85 c0                	test   %eax,%eax
  803c7e:	74 10                	je     803c90 <insert_sorted_with_merge_freeList+0x3b5>
  803c80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c83:	8b 00                	mov    (%eax),%eax
  803c85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c88:	8b 52 04             	mov    0x4(%edx),%edx
  803c8b:	89 50 04             	mov    %edx,0x4(%eax)
  803c8e:	eb 0b                	jmp    803c9b <insert_sorted_with_merge_freeList+0x3c0>
  803c90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c93:	8b 40 04             	mov    0x4(%eax),%eax
  803c96:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ca1:	85 c0                	test   %eax,%eax
  803ca3:	74 0f                	je     803cb4 <insert_sorted_with_merge_freeList+0x3d9>
  803ca5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca8:	8b 40 04             	mov    0x4(%eax),%eax
  803cab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cae:	8b 12                	mov    (%edx),%edx
  803cb0:	89 10                	mov    %edx,(%eax)
  803cb2:	eb 0a                	jmp    803cbe <insert_sorted_with_merge_freeList+0x3e3>
  803cb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cb7:	8b 00                	mov    (%eax),%eax
  803cb9:	a3 38 51 80 00       	mov    %eax,0x805138
  803cbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cd1:	a1 44 51 80 00       	mov    0x805144,%eax
  803cd6:	48                   	dec    %eax
  803cd7:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803cdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cdf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803ce6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ce9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803cf0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803cf4:	75 17                	jne    803d0d <insert_sorted_with_merge_freeList+0x432>
  803cf6:	83 ec 04             	sub    $0x4,%esp
  803cf9:	68 f8 4b 80 00       	push   $0x804bf8
  803cfe:	68 5f 01 00 00       	push   $0x15f
  803d03:	68 1b 4c 80 00       	push   $0x804c1b
  803d08:	e8 b5 d1 ff ff       	call   800ec2 <_panic>
  803d0d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d16:	89 10                	mov    %edx,(%eax)
  803d18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d1b:	8b 00                	mov    (%eax),%eax
  803d1d:	85 c0                	test   %eax,%eax
  803d1f:	74 0d                	je     803d2e <insert_sorted_with_merge_freeList+0x453>
  803d21:	a1 48 51 80 00       	mov    0x805148,%eax
  803d26:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d29:	89 50 04             	mov    %edx,0x4(%eax)
  803d2c:	eb 08                	jmp    803d36 <insert_sorted_with_merge_freeList+0x45b>
  803d2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d31:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d39:	a3 48 51 80 00       	mov    %eax,0x805148
  803d3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d48:	a1 54 51 80 00       	mov    0x805154,%eax
  803d4d:	40                   	inc    %eax
  803d4e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d56:	8b 50 0c             	mov    0xc(%eax),%edx
  803d59:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  803d5f:	01 c2                	add    %eax,%edx
  803d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d64:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803d67:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803d71:	8b 45 08             	mov    0x8(%ebp),%eax
  803d74:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803d7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d7f:	75 17                	jne    803d98 <insert_sorted_with_merge_freeList+0x4bd>
  803d81:	83 ec 04             	sub    $0x4,%esp
  803d84:	68 f8 4b 80 00       	push   $0x804bf8
  803d89:	68 64 01 00 00       	push   $0x164
  803d8e:	68 1b 4c 80 00       	push   $0x804c1b
  803d93:	e8 2a d1 ff ff       	call   800ec2 <_panic>
  803d98:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803da1:	89 10                	mov    %edx,(%eax)
  803da3:	8b 45 08             	mov    0x8(%ebp),%eax
  803da6:	8b 00                	mov    (%eax),%eax
  803da8:	85 c0                	test   %eax,%eax
  803daa:	74 0d                	je     803db9 <insert_sorted_with_merge_freeList+0x4de>
  803dac:	a1 48 51 80 00       	mov    0x805148,%eax
  803db1:	8b 55 08             	mov    0x8(%ebp),%edx
  803db4:	89 50 04             	mov    %edx,0x4(%eax)
  803db7:	eb 08                	jmp    803dc1 <insert_sorted_with_merge_freeList+0x4e6>
  803db9:	8b 45 08             	mov    0x8(%ebp),%eax
  803dbc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc4:	a3 48 51 80 00       	mov    %eax,0x805148
  803dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  803dcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dd3:	a1 54 51 80 00       	mov    0x805154,%eax
  803dd8:	40                   	inc    %eax
  803dd9:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803dde:	e9 41 02 00 00       	jmp    804024 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803de3:	8b 45 08             	mov    0x8(%ebp),%eax
  803de6:	8b 50 08             	mov    0x8(%eax),%edx
  803de9:	8b 45 08             	mov    0x8(%ebp),%eax
  803dec:	8b 40 0c             	mov    0xc(%eax),%eax
  803def:	01 c2                	add    %eax,%edx
  803df1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803df4:	8b 40 08             	mov    0x8(%eax),%eax
  803df7:	39 c2                	cmp    %eax,%edx
  803df9:	0f 85 7c 01 00 00    	jne    803f7b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803dff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803e03:	74 06                	je     803e0b <insert_sorted_with_merge_freeList+0x530>
  803e05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e09:	75 17                	jne    803e22 <insert_sorted_with_merge_freeList+0x547>
  803e0b:	83 ec 04             	sub    $0x4,%esp
  803e0e:	68 34 4c 80 00       	push   $0x804c34
  803e13:	68 69 01 00 00       	push   $0x169
  803e18:	68 1b 4c 80 00       	push   $0x804c1b
  803e1d:	e8 a0 d0 ff ff       	call   800ec2 <_panic>
  803e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e25:	8b 50 04             	mov    0x4(%eax),%edx
  803e28:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2b:	89 50 04             	mov    %edx,0x4(%eax)
  803e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e34:	89 10                	mov    %edx,(%eax)
  803e36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e39:	8b 40 04             	mov    0x4(%eax),%eax
  803e3c:	85 c0                	test   %eax,%eax
  803e3e:	74 0d                	je     803e4d <insert_sorted_with_merge_freeList+0x572>
  803e40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e43:	8b 40 04             	mov    0x4(%eax),%eax
  803e46:	8b 55 08             	mov    0x8(%ebp),%edx
  803e49:	89 10                	mov    %edx,(%eax)
  803e4b:	eb 08                	jmp    803e55 <insert_sorted_with_merge_freeList+0x57a>
  803e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e50:	a3 38 51 80 00       	mov    %eax,0x805138
  803e55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e58:	8b 55 08             	mov    0x8(%ebp),%edx
  803e5b:	89 50 04             	mov    %edx,0x4(%eax)
  803e5e:	a1 44 51 80 00       	mov    0x805144,%eax
  803e63:	40                   	inc    %eax
  803e64:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803e69:	8b 45 08             	mov    0x8(%ebp),%eax
  803e6c:	8b 50 0c             	mov    0xc(%eax),%edx
  803e6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e72:	8b 40 0c             	mov    0xc(%eax),%eax
  803e75:	01 c2                	add    %eax,%edx
  803e77:	8b 45 08             	mov    0x8(%ebp),%eax
  803e7a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803e7d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803e81:	75 17                	jne    803e9a <insert_sorted_with_merge_freeList+0x5bf>
  803e83:	83 ec 04             	sub    $0x4,%esp
  803e86:	68 c4 4c 80 00       	push   $0x804cc4
  803e8b:	68 6b 01 00 00       	push   $0x16b
  803e90:	68 1b 4c 80 00       	push   $0x804c1b
  803e95:	e8 28 d0 ff ff       	call   800ec2 <_panic>
  803e9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e9d:	8b 00                	mov    (%eax),%eax
  803e9f:	85 c0                	test   %eax,%eax
  803ea1:	74 10                	je     803eb3 <insert_sorted_with_merge_freeList+0x5d8>
  803ea3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ea6:	8b 00                	mov    (%eax),%eax
  803ea8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803eab:	8b 52 04             	mov    0x4(%edx),%edx
  803eae:	89 50 04             	mov    %edx,0x4(%eax)
  803eb1:	eb 0b                	jmp    803ebe <insert_sorted_with_merge_freeList+0x5e3>
  803eb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eb6:	8b 40 04             	mov    0x4(%eax),%eax
  803eb9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ebe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ec1:	8b 40 04             	mov    0x4(%eax),%eax
  803ec4:	85 c0                	test   %eax,%eax
  803ec6:	74 0f                	je     803ed7 <insert_sorted_with_merge_freeList+0x5fc>
  803ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ecb:	8b 40 04             	mov    0x4(%eax),%eax
  803ece:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ed1:	8b 12                	mov    (%edx),%edx
  803ed3:	89 10                	mov    %edx,(%eax)
  803ed5:	eb 0a                	jmp    803ee1 <insert_sorted_with_merge_freeList+0x606>
  803ed7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eda:	8b 00                	mov    (%eax),%eax
  803edc:	a3 38 51 80 00       	mov    %eax,0x805138
  803ee1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ee4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ef4:	a1 44 51 80 00       	mov    0x805144,%eax
  803ef9:	48                   	dec    %eax
  803efa:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803eff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803f09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f0c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803f13:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803f17:	75 17                	jne    803f30 <insert_sorted_with_merge_freeList+0x655>
  803f19:	83 ec 04             	sub    $0x4,%esp
  803f1c:	68 f8 4b 80 00       	push   $0x804bf8
  803f21:	68 6e 01 00 00       	push   $0x16e
  803f26:	68 1b 4c 80 00       	push   $0x804c1b
  803f2b:	e8 92 cf ff ff       	call   800ec2 <_panic>
  803f30:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803f36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f39:	89 10                	mov    %edx,(%eax)
  803f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f3e:	8b 00                	mov    (%eax),%eax
  803f40:	85 c0                	test   %eax,%eax
  803f42:	74 0d                	je     803f51 <insert_sorted_with_merge_freeList+0x676>
  803f44:	a1 48 51 80 00       	mov    0x805148,%eax
  803f49:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f4c:	89 50 04             	mov    %edx,0x4(%eax)
  803f4f:	eb 08                	jmp    803f59 <insert_sorted_with_merge_freeList+0x67e>
  803f51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f54:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803f59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f5c:	a3 48 51 80 00       	mov    %eax,0x805148
  803f61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f6b:	a1 54 51 80 00       	mov    0x805154,%eax
  803f70:	40                   	inc    %eax
  803f71:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803f76:	e9 a9 00 00 00       	jmp    804024 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803f7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f7f:	74 06                	je     803f87 <insert_sorted_with_merge_freeList+0x6ac>
  803f81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f85:	75 17                	jne    803f9e <insert_sorted_with_merge_freeList+0x6c3>
  803f87:	83 ec 04             	sub    $0x4,%esp
  803f8a:	68 90 4c 80 00       	push   $0x804c90
  803f8f:	68 73 01 00 00       	push   $0x173
  803f94:	68 1b 4c 80 00       	push   $0x804c1b
  803f99:	e8 24 cf ff ff       	call   800ec2 <_panic>
  803f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa1:	8b 10                	mov    (%eax),%edx
  803fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa6:	89 10                	mov    %edx,(%eax)
  803fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  803fab:	8b 00                	mov    (%eax),%eax
  803fad:	85 c0                	test   %eax,%eax
  803faf:	74 0b                	je     803fbc <insert_sorted_with_merge_freeList+0x6e1>
  803fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fb4:	8b 00                	mov    (%eax),%eax
  803fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  803fb9:	89 50 04             	mov    %edx,0x4(%eax)
  803fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  803fc2:	89 10                	mov    %edx,(%eax)
  803fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fca:	89 50 04             	mov    %edx,0x4(%eax)
  803fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  803fd0:	8b 00                	mov    (%eax),%eax
  803fd2:	85 c0                	test   %eax,%eax
  803fd4:	75 08                	jne    803fde <insert_sorted_with_merge_freeList+0x703>
  803fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803fd9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803fde:	a1 44 51 80 00       	mov    0x805144,%eax
  803fe3:	40                   	inc    %eax
  803fe4:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803fe9:	eb 39                	jmp    804024 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803feb:	a1 40 51 80 00       	mov    0x805140,%eax
  803ff0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ff3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ff7:	74 07                	je     804000 <insert_sorted_with_merge_freeList+0x725>
  803ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ffc:	8b 00                	mov    (%eax),%eax
  803ffe:	eb 05                	jmp    804005 <insert_sorted_with_merge_freeList+0x72a>
  804000:	b8 00 00 00 00       	mov    $0x0,%eax
  804005:	a3 40 51 80 00       	mov    %eax,0x805140
  80400a:	a1 40 51 80 00       	mov    0x805140,%eax
  80400f:	85 c0                	test   %eax,%eax
  804011:	0f 85 c7 fb ff ff    	jne    803bde <insert_sorted_with_merge_freeList+0x303>
  804017:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80401b:	0f 85 bd fb ff ff    	jne    803bde <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804021:	eb 01                	jmp    804024 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  804023:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804024:	90                   	nop
  804025:	c9                   	leave  
  804026:	c3                   	ret    
  804027:	90                   	nop

00804028 <__udivdi3>:
  804028:	55                   	push   %ebp
  804029:	57                   	push   %edi
  80402a:	56                   	push   %esi
  80402b:	53                   	push   %ebx
  80402c:	83 ec 1c             	sub    $0x1c,%esp
  80402f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804033:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804037:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80403b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80403f:	89 ca                	mov    %ecx,%edx
  804041:	89 f8                	mov    %edi,%eax
  804043:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804047:	85 f6                	test   %esi,%esi
  804049:	75 2d                	jne    804078 <__udivdi3+0x50>
  80404b:	39 cf                	cmp    %ecx,%edi
  80404d:	77 65                	ja     8040b4 <__udivdi3+0x8c>
  80404f:	89 fd                	mov    %edi,%ebp
  804051:	85 ff                	test   %edi,%edi
  804053:	75 0b                	jne    804060 <__udivdi3+0x38>
  804055:	b8 01 00 00 00       	mov    $0x1,%eax
  80405a:	31 d2                	xor    %edx,%edx
  80405c:	f7 f7                	div    %edi
  80405e:	89 c5                	mov    %eax,%ebp
  804060:	31 d2                	xor    %edx,%edx
  804062:	89 c8                	mov    %ecx,%eax
  804064:	f7 f5                	div    %ebp
  804066:	89 c1                	mov    %eax,%ecx
  804068:	89 d8                	mov    %ebx,%eax
  80406a:	f7 f5                	div    %ebp
  80406c:	89 cf                	mov    %ecx,%edi
  80406e:	89 fa                	mov    %edi,%edx
  804070:	83 c4 1c             	add    $0x1c,%esp
  804073:	5b                   	pop    %ebx
  804074:	5e                   	pop    %esi
  804075:	5f                   	pop    %edi
  804076:	5d                   	pop    %ebp
  804077:	c3                   	ret    
  804078:	39 ce                	cmp    %ecx,%esi
  80407a:	77 28                	ja     8040a4 <__udivdi3+0x7c>
  80407c:	0f bd fe             	bsr    %esi,%edi
  80407f:	83 f7 1f             	xor    $0x1f,%edi
  804082:	75 40                	jne    8040c4 <__udivdi3+0x9c>
  804084:	39 ce                	cmp    %ecx,%esi
  804086:	72 0a                	jb     804092 <__udivdi3+0x6a>
  804088:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80408c:	0f 87 9e 00 00 00    	ja     804130 <__udivdi3+0x108>
  804092:	b8 01 00 00 00       	mov    $0x1,%eax
  804097:	89 fa                	mov    %edi,%edx
  804099:	83 c4 1c             	add    $0x1c,%esp
  80409c:	5b                   	pop    %ebx
  80409d:	5e                   	pop    %esi
  80409e:	5f                   	pop    %edi
  80409f:	5d                   	pop    %ebp
  8040a0:	c3                   	ret    
  8040a1:	8d 76 00             	lea    0x0(%esi),%esi
  8040a4:	31 ff                	xor    %edi,%edi
  8040a6:	31 c0                	xor    %eax,%eax
  8040a8:	89 fa                	mov    %edi,%edx
  8040aa:	83 c4 1c             	add    $0x1c,%esp
  8040ad:	5b                   	pop    %ebx
  8040ae:	5e                   	pop    %esi
  8040af:	5f                   	pop    %edi
  8040b0:	5d                   	pop    %ebp
  8040b1:	c3                   	ret    
  8040b2:	66 90                	xchg   %ax,%ax
  8040b4:	89 d8                	mov    %ebx,%eax
  8040b6:	f7 f7                	div    %edi
  8040b8:	31 ff                	xor    %edi,%edi
  8040ba:	89 fa                	mov    %edi,%edx
  8040bc:	83 c4 1c             	add    $0x1c,%esp
  8040bf:	5b                   	pop    %ebx
  8040c0:	5e                   	pop    %esi
  8040c1:	5f                   	pop    %edi
  8040c2:	5d                   	pop    %ebp
  8040c3:	c3                   	ret    
  8040c4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040c9:	89 eb                	mov    %ebp,%ebx
  8040cb:	29 fb                	sub    %edi,%ebx
  8040cd:	89 f9                	mov    %edi,%ecx
  8040cf:	d3 e6                	shl    %cl,%esi
  8040d1:	89 c5                	mov    %eax,%ebp
  8040d3:	88 d9                	mov    %bl,%cl
  8040d5:	d3 ed                	shr    %cl,%ebp
  8040d7:	89 e9                	mov    %ebp,%ecx
  8040d9:	09 f1                	or     %esi,%ecx
  8040db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040df:	89 f9                	mov    %edi,%ecx
  8040e1:	d3 e0                	shl    %cl,%eax
  8040e3:	89 c5                	mov    %eax,%ebp
  8040e5:	89 d6                	mov    %edx,%esi
  8040e7:	88 d9                	mov    %bl,%cl
  8040e9:	d3 ee                	shr    %cl,%esi
  8040eb:	89 f9                	mov    %edi,%ecx
  8040ed:	d3 e2                	shl    %cl,%edx
  8040ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040f3:	88 d9                	mov    %bl,%cl
  8040f5:	d3 e8                	shr    %cl,%eax
  8040f7:	09 c2                	or     %eax,%edx
  8040f9:	89 d0                	mov    %edx,%eax
  8040fb:	89 f2                	mov    %esi,%edx
  8040fd:	f7 74 24 0c          	divl   0xc(%esp)
  804101:	89 d6                	mov    %edx,%esi
  804103:	89 c3                	mov    %eax,%ebx
  804105:	f7 e5                	mul    %ebp
  804107:	39 d6                	cmp    %edx,%esi
  804109:	72 19                	jb     804124 <__udivdi3+0xfc>
  80410b:	74 0b                	je     804118 <__udivdi3+0xf0>
  80410d:	89 d8                	mov    %ebx,%eax
  80410f:	31 ff                	xor    %edi,%edi
  804111:	e9 58 ff ff ff       	jmp    80406e <__udivdi3+0x46>
  804116:	66 90                	xchg   %ax,%ax
  804118:	8b 54 24 08          	mov    0x8(%esp),%edx
  80411c:	89 f9                	mov    %edi,%ecx
  80411e:	d3 e2                	shl    %cl,%edx
  804120:	39 c2                	cmp    %eax,%edx
  804122:	73 e9                	jae    80410d <__udivdi3+0xe5>
  804124:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804127:	31 ff                	xor    %edi,%edi
  804129:	e9 40 ff ff ff       	jmp    80406e <__udivdi3+0x46>
  80412e:	66 90                	xchg   %ax,%ax
  804130:	31 c0                	xor    %eax,%eax
  804132:	e9 37 ff ff ff       	jmp    80406e <__udivdi3+0x46>
  804137:	90                   	nop

00804138 <__umoddi3>:
  804138:	55                   	push   %ebp
  804139:	57                   	push   %edi
  80413a:	56                   	push   %esi
  80413b:	53                   	push   %ebx
  80413c:	83 ec 1c             	sub    $0x1c,%esp
  80413f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804143:	8b 74 24 34          	mov    0x34(%esp),%esi
  804147:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80414b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80414f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804153:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804157:	89 f3                	mov    %esi,%ebx
  804159:	89 fa                	mov    %edi,%edx
  80415b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80415f:	89 34 24             	mov    %esi,(%esp)
  804162:	85 c0                	test   %eax,%eax
  804164:	75 1a                	jne    804180 <__umoddi3+0x48>
  804166:	39 f7                	cmp    %esi,%edi
  804168:	0f 86 a2 00 00 00    	jbe    804210 <__umoddi3+0xd8>
  80416e:	89 c8                	mov    %ecx,%eax
  804170:	89 f2                	mov    %esi,%edx
  804172:	f7 f7                	div    %edi
  804174:	89 d0                	mov    %edx,%eax
  804176:	31 d2                	xor    %edx,%edx
  804178:	83 c4 1c             	add    $0x1c,%esp
  80417b:	5b                   	pop    %ebx
  80417c:	5e                   	pop    %esi
  80417d:	5f                   	pop    %edi
  80417e:	5d                   	pop    %ebp
  80417f:	c3                   	ret    
  804180:	39 f0                	cmp    %esi,%eax
  804182:	0f 87 ac 00 00 00    	ja     804234 <__umoddi3+0xfc>
  804188:	0f bd e8             	bsr    %eax,%ebp
  80418b:	83 f5 1f             	xor    $0x1f,%ebp
  80418e:	0f 84 ac 00 00 00    	je     804240 <__umoddi3+0x108>
  804194:	bf 20 00 00 00       	mov    $0x20,%edi
  804199:	29 ef                	sub    %ebp,%edi
  80419b:	89 fe                	mov    %edi,%esi
  80419d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041a1:	89 e9                	mov    %ebp,%ecx
  8041a3:	d3 e0                	shl    %cl,%eax
  8041a5:	89 d7                	mov    %edx,%edi
  8041a7:	89 f1                	mov    %esi,%ecx
  8041a9:	d3 ef                	shr    %cl,%edi
  8041ab:	09 c7                	or     %eax,%edi
  8041ad:	89 e9                	mov    %ebp,%ecx
  8041af:	d3 e2                	shl    %cl,%edx
  8041b1:	89 14 24             	mov    %edx,(%esp)
  8041b4:	89 d8                	mov    %ebx,%eax
  8041b6:	d3 e0                	shl    %cl,%eax
  8041b8:	89 c2                	mov    %eax,%edx
  8041ba:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041be:	d3 e0                	shl    %cl,%eax
  8041c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041c8:	89 f1                	mov    %esi,%ecx
  8041ca:	d3 e8                	shr    %cl,%eax
  8041cc:	09 d0                	or     %edx,%eax
  8041ce:	d3 eb                	shr    %cl,%ebx
  8041d0:	89 da                	mov    %ebx,%edx
  8041d2:	f7 f7                	div    %edi
  8041d4:	89 d3                	mov    %edx,%ebx
  8041d6:	f7 24 24             	mull   (%esp)
  8041d9:	89 c6                	mov    %eax,%esi
  8041db:	89 d1                	mov    %edx,%ecx
  8041dd:	39 d3                	cmp    %edx,%ebx
  8041df:	0f 82 87 00 00 00    	jb     80426c <__umoddi3+0x134>
  8041e5:	0f 84 91 00 00 00    	je     80427c <__umoddi3+0x144>
  8041eb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041ef:	29 f2                	sub    %esi,%edx
  8041f1:	19 cb                	sbb    %ecx,%ebx
  8041f3:	89 d8                	mov    %ebx,%eax
  8041f5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041f9:	d3 e0                	shl    %cl,%eax
  8041fb:	89 e9                	mov    %ebp,%ecx
  8041fd:	d3 ea                	shr    %cl,%edx
  8041ff:	09 d0                	or     %edx,%eax
  804201:	89 e9                	mov    %ebp,%ecx
  804203:	d3 eb                	shr    %cl,%ebx
  804205:	89 da                	mov    %ebx,%edx
  804207:	83 c4 1c             	add    $0x1c,%esp
  80420a:	5b                   	pop    %ebx
  80420b:	5e                   	pop    %esi
  80420c:	5f                   	pop    %edi
  80420d:	5d                   	pop    %ebp
  80420e:	c3                   	ret    
  80420f:	90                   	nop
  804210:	89 fd                	mov    %edi,%ebp
  804212:	85 ff                	test   %edi,%edi
  804214:	75 0b                	jne    804221 <__umoddi3+0xe9>
  804216:	b8 01 00 00 00       	mov    $0x1,%eax
  80421b:	31 d2                	xor    %edx,%edx
  80421d:	f7 f7                	div    %edi
  80421f:	89 c5                	mov    %eax,%ebp
  804221:	89 f0                	mov    %esi,%eax
  804223:	31 d2                	xor    %edx,%edx
  804225:	f7 f5                	div    %ebp
  804227:	89 c8                	mov    %ecx,%eax
  804229:	f7 f5                	div    %ebp
  80422b:	89 d0                	mov    %edx,%eax
  80422d:	e9 44 ff ff ff       	jmp    804176 <__umoddi3+0x3e>
  804232:	66 90                	xchg   %ax,%ax
  804234:	89 c8                	mov    %ecx,%eax
  804236:	89 f2                	mov    %esi,%edx
  804238:	83 c4 1c             	add    $0x1c,%esp
  80423b:	5b                   	pop    %ebx
  80423c:	5e                   	pop    %esi
  80423d:	5f                   	pop    %edi
  80423e:	5d                   	pop    %ebp
  80423f:	c3                   	ret    
  804240:	3b 04 24             	cmp    (%esp),%eax
  804243:	72 06                	jb     80424b <__umoddi3+0x113>
  804245:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804249:	77 0f                	ja     80425a <__umoddi3+0x122>
  80424b:	89 f2                	mov    %esi,%edx
  80424d:	29 f9                	sub    %edi,%ecx
  80424f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804253:	89 14 24             	mov    %edx,(%esp)
  804256:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80425a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80425e:	8b 14 24             	mov    (%esp),%edx
  804261:	83 c4 1c             	add    $0x1c,%esp
  804264:	5b                   	pop    %ebx
  804265:	5e                   	pop    %esi
  804266:	5f                   	pop    %edi
  804267:	5d                   	pop    %ebp
  804268:	c3                   	ret    
  804269:	8d 76 00             	lea    0x0(%esi),%esi
  80426c:	2b 04 24             	sub    (%esp),%eax
  80426f:	19 fa                	sbb    %edi,%edx
  804271:	89 d1                	mov    %edx,%ecx
  804273:	89 c6                	mov    %eax,%esi
  804275:	e9 71 ff ff ff       	jmp    8041eb <__umoddi3+0xb3>
  80427a:	66 90                	xchg   %ax,%ax
  80427c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804280:	72 ea                	jb     80426c <__umoddi3+0x134>
  804282:	89 d9                	mov    %ebx,%ecx
  804284:	e9 62 ff ff ff       	jmp    8041eb <__umoddi3+0xb3>
