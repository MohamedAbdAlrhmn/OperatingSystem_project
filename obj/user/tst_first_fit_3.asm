
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
  800045:	e8 e6 29 00 00       	call   802a30 <sys_set_uheap_strategy>
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
  80009b:	68 60 43 80 00       	push   $0x804360
  8000a0:	6a 16                	push   $0x16
  8000a2:	68 7c 43 80 00       	push   $0x80437c
  8000a7:	e8 16 0e 00 00       	call   800ec2 <_panic>
	}

	int envID = sys_getenvid();
  8000ac:	e8 31 27 00 00       	call   8027e2 <sys_getenvid>
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
  8000e0:	e8 36 24 00 00       	call   80251b <sys_calculate_free_frames>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e8:	e8 ce 24 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	6a 01                	push   $0x1
  8000f8:	50                   	push   %eax
  8000f9:	68 93 43 80 00       	push   $0x804393
  8000fe:	e8 46 21 00 00       	call   802249 <smalloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if (ptr_allocations[0] != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800109:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80010c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800111:	74 14                	je     800127 <_main+0xef>
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 98 43 80 00       	push   $0x804398
  80011b:	6a 2a                	push   $0x2a
  80011d:	68 7c 43 80 00       	push   $0x80437c
  800122:	e8 9b 0d 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  256+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800127:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80012a:	e8 ec 23 00 00       	call   80251b <sys_calculate_free_frames>
  80012f:	29 c3                	sub    %eax,%ebx
  800131:	89 d8                	mov    %ebx,%eax
  800133:	3d 03 01 00 00       	cmp    $0x103,%eax
  800138:	74 14                	je     80014e <_main+0x116>
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	68 04 44 80 00       	push   $0x804404
  800142:	6a 2b                	push   $0x2b
  800144:	68 7c 43 80 00       	push   $0x80437c
  800149:	e8 74 0d 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014e:	e8 68 24 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800153:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 82 44 80 00       	push   $0x804482
  800160:	6a 2c                	push   $0x2c
  800162:	68 7c 43 80 00       	push   $0x80437c
  800167:	e8 56 0d 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80016c:	e8 aa 23 00 00       	call   80251b <sys_calculate_free_frames>
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800174:	e8 42 24 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
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
  8001a5:	68 a0 44 80 00       	push   $0x8044a0
  8001aa:	6a 32                	push   $0x32
  8001ac:	68 7c 43 80 00       	push   $0x80437c
  8001b1:	e8 0c 0d 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b6:	e8 00 24 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  8001bb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 82 44 80 00       	push   $0x804482
  8001c8:	6a 34                	push   $0x34
  8001ca:	68 7c 43 80 00       	push   $0x80437c
  8001cf:	e8 ee 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001d4:	e8 42 23 00 00       	call   80251b <sys_calculate_free_frames>
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001de:	39 c2                	cmp    %eax,%edx
  8001e0:	74 14                	je     8001f6 <_main+0x1be>
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	68 d0 44 80 00       	push   $0x8044d0
  8001ea:	6a 35                	push   $0x35
  8001ec:	68 7c 43 80 00       	push   $0x80437c
  8001f1:	e8 cc 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f6:	e8 20 23 00 00       	call   80251b <sys_calculate_free_frames>
  8001fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fe:	e8 b8 23 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
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
  800231:	68 a0 44 80 00       	push   $0x8044a0
  800236:	6a 3b                	push   $0x3b
  800238:	68 7c 43 80 00       	push   $0x80437c
  80023d:	e8 80 0c 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800242:	e8 74 23 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800247:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80024a:	74 14                	je     800260 <_main+0x228>
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	68 82 44 80 00       	push   $0x804482
  800254:	6a 3d                	push   $0x3d
  800256:	68 7c 43 80 00       	push   $0x80437c
  80025b:	e8 62 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800260:	e8 b6 22 00 00       	call   80251b <sys_calculate_free_frames>
  800265:	89 c2                	mov    %eax,%edx
  800267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026a:	39 c2                	cmp    %eax,%edx
  80026c:	74 14                	je     800282 <_main+0x24a>
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	68 d0 44 80 00       	push   $0x8044d0
  800276:	6a 3e                	push   $0x3e
  800278:	68 7c 43 80 00       	push   $0x80437c
  80027d:	e8 40 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800282:	e8 94 22 00 00       	call   80251b <sys_calculate_free_frames>
  800287:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80028a:	e8 2c 23 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
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
  8002c1:	68 a0 44 80 00       	push   $0x8044a0
  8002c6:	6a 44                	push   $0x44
  8002c8:	68 7c 43 80 00       	push   $0x80437c
  8002cd:	e8 f0 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002d2:	e8 e4 22 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  8002d7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 82 44 80 00       	push   $0x804482
  8002e4:	6a 46                	push   $0x46
  8002e6:	68 7c 43 80 00       	push   $0x80437c
  8002eb:	e8 d2 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002f0:	e8 26 22 00 00       	call   80251b <sys_calculate_free_frames>
  8002f5:	89 c2                	mov    %eax,%edx
  8002f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 d0 44 80 00       	push   $0x8044d0
  800306:	6a 47                	push   $0x47
  800308:	68 7c 43 80 00       	push   $0x80437c
  80030d:	e8 b0 0b 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800312:	e8 04 22 00 00       	call   80251b <sys_calculate_free_frames>
  800317:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80031a:	e8 9c 22 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
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
  800350:	68 a0 44 80 00       	push   $0x8044a0
  800355:	6a 4d                	push   $0x4d
  800357:	68 7c 43 80 00       	push   $0x80437c
  80035c:	e8 61 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800361:	e8 55 22 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800366:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800369:	74 14                	je     80037f <_main+0x347>
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	68 82 44 80 00       	push   $0x804482
  800373:	6a 4f                	push   $0x4f
  800375:	68 7c 43 80 00       	push   $0x80437c
  80037a:	e8 43 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80037f:	e8 97 21 00 00       	call   80251b <sys_calculate_free_frames>
  800384:	89 c2                	mov    %eax,%edx
  800386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	74 14                	je     8003a1 <_main+0x369>
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	68 d0 44 80 00       	push   $0x8044d0
  800395:	6a 50                	push   $0x50
  800397:	68 7c 43 80 00       	push   $0x80437c
  80039c:	e8 21 0b 00 00       	call   800ec2 <_panic>

		//Allocate Shared 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003a1:	e8 75 21 00 00       	call   80251b <sys_calculate_free_frames>
  8003a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a9:	e8 0d 22 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  8003ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  8003b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b4:	01 c0                	add    %eax,%eax
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	50                   	push   %eax
  8003bc:	68 e3 44 80 00       	push   $0x8044e3
  8003c1:	e8 83 1e 00 00       	call   802249 <smalloc>
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
  8003e6:	68 98 43 80 00       	push   $0x804398
  8003eb:	6a 56                	push   $0x56
  8003ed:	68 7c 43 80 00       	push   $0x80437c
  8003f2:	e8 cb 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  512+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8003f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003fa:	e8 1c 21 00 00       	call   80251b <sys_calculate_free_frames>
  8003ff:	29 c3                	sub    %eax,%ebx
  800401:	89 d8                	mov    %ebx,%eax
  800403:	3d 03 02 00 00       	cmp    $0x203,%eax
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 04 44 80 00       	push   $0x804404
  800412:	6a 57                	push   $0x57
  800414:	68 7c 43 80 00       	push   $0x80437c
  800419:	e8 a4 0a 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80041e:	e8 98 21 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800423:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800426:	74 14                	je     80043c <_main+0x404>
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	68 82 44 80 00       	push   $0x804482
  800430:	6a 58                	push   $0x58
  800432:	68 7c 43 80 00       	push   $0x80437c
  800437:	e8 86 0a 00 00       	call   800ec2 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80043c:	e8 da 20 00 00       	call   80251b <sys_calculate_free_frames>
  800441:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800444:	e8 72 21 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
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
  80047e:	68 a0 44 80 00       	push   $0x8044a0
  800483:	6a 5e                	push   $0x5e
  800485:	68 7c 43 80 00       	push   $0x80437c
  80048a:	e8 33 0a 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80048f:	e8 27 21 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800494:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800497:	74 14                	je     8004ad <_main+0x475>
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 82 44 80 00       	push   $0x804482
  8004a1:	6a 60                	push   $0x60
  8004a3:	68 7c 43 80 00       	push   $0x80437c
  8004a8:	e8 15 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8004ad:	e8 69 20 00 00       	call   80251b <sys_calculate_free_frames>
  8004b2:	89 c2                	mov    %eax,%edx
  8004b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b7:	39 c2                	cmp    %eax,%edx
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 d0 44 80 00       	push   $0x8044d0
  8004c3:	6a 61                	push   $0x61
  8004c5:	68 7c 43 80 00       	push   $0x80437c
  8004ca:	e8 f3 09 00 00       	call   800ec2 <_panic>

		//Allocate Shared 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004cf:	e8 47 20 00 00       	call   80251b <sys_calculate_free_frames>
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004d7:	e8 df 20 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  8004dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8004df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	01 d2                	add    %edx,%edx
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	6a 00                	push   $0x0
  8004ed:	50                   	push   %eax
  8004ee:	68 e5 44 80 00       	push   $0x8044e5
  8004f3:	e8 51 1d 00 00       	call   802249 <smalloc>
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
  80051b:	68 98 43 80 00       	push   $0x804398
  800520:	6a 67                	push   $0x67
  800522:	68 7c 43 80 00       	push   $0x80437c
  800527:	e8 96 09 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80052c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052f:	e8 e7 1f 00 00       	call   80251b <sys_calculate_free_frames>
  800534:	29 c3                	sub    %eax,%ebx
  800536:	89 d8                	mov    %ebx,%eax
  800538:	3d 04 03 00 00       	cmp    $0x304,%eax
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 04 44 80 00       	push   $0x804404
  800547:	6a 68                	push   $0x68
  800549:	68 7c 43 80 00       	push   $0x80437c
  80054e:	e8 6f 09 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800553:	e8 63 20 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800558:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 82 44 80 00       	push   $0x804482
  800565:	6a 69                	push   $0x69
  800567:	68 7c 43 80 00       	push   $0x80437c
  80056c:	e8 51 09 00 00       	call   800ec2 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800571:	e8 a5 1f 00 00       	call   80251b <sys_calculate_free_frames>
  800576:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800579:	e8 3d 20 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  80057e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800581:	8b 45 90             	mov    -0x70(%ebp),%eax
  800584:	83 ec 0c             	sub    $0xc,%esp
  800587:	50                   	push   %eax
  800588:	e8 ec 1b 00 00       	call   802179 <free>
  80058d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800590:	e8 26 20 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800595:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800598:	74 14                	je     8005ae <_main+0x576>
  80059a:	83 ec 04             	sub    $0x4,%esp
  80059d:	68 e7 44 80 00       	push   $0x8044e7
  8005a2:	6a 73                	push   $0x73
  8005a4:	68 7c 43 80 00       	push   $0x80437c
  8005a9:	e8 14 09 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ae:	e8 68 1f 00 00       	call   80251b <sys_calculate_free_frames>
  8005b3:	89 c2                	mov    %eax,%edx
  8005b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b8:	39 c2                	cmp    %eax,%edx
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 fe 44 80 00       	push   $0x8044fe
  8005c4:	6a 74                	push   $0x74
  8005c6:	68 7c 43 80 00       	push   $0x80437c
  8005cb:	e8 f2 08 00 00       	call   800ec2 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d0:	e8 46 1f 00 00       	call   80251b <sys_calculate_free_frames>
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005d8:	e8 de 1f 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8005e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	50                   	push   %eax
  8005e7:	e8 8d 1b 00 00       	call   802179 <free>
  8005ec:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005ef:	e8 c7 1f 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 14                	je     80060d <_main+0x5d5>
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 e7 44 80 00       	push   $0x8044e7
  800601:	6a 7b                	push   $0x7b
  800603:	68 7c 43 80 00       	push   $0x80437c
  800608:	e8 b5 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80060d:	e8 09 1f 00 00       	call   80251b <sys_calculate_free_frames>
  800612:	89 c2                	mov    %eax,%edx
  800614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800617:	39 c2                	cmp    %eax,%edx
  800619:	74 14                	je     80062f <_main+0x5f7>
  80061b:	83 ec 04             	sub    $0x4,%esp
  80061e:	68 fe 44 80 00       	push   $0x8044fe
  800623:	6a 7c                	push   $0x7c
  800625:	68 7c 43 80 00       	push   $0x80437c
  80062a:	e8 93 08 00 00       	call   800ec2 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80062f:	e8 e7 1e 00 00       	call   80251b <sys_calculate_free_frames>
  800634:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800637:	e8 7f 1f 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  80063c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80063f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	50                   	push   %eax
  800646:	e8 2e 1b 00 00       	call   802179 <free>
  80064b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80064e:	e8 68 1f 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800653:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800656:	74 17                	je     80066f <_main+0x637>
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	68 e7 44 80 00       	push   $0x8044e7
  800660:	68 83 00 00 00       	push   $0x83
  800665:	68 7c 43 80 00       	push   $0x80437c
  80066a:	e8 53 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80066f:	e8 a7 1e 00 00       	call   80251b <sys_calculate_free_frames>
  800674:	89 c2                	mov    %eax,%edx
  800676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800679:	39 c2                	cmp    %eax,%edx
  80067b:	74 17                	je     800694 <_main+0x65c>
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	68 fe 44 80 00       	push   $0x8044fe
  800685:	68 84 00 00 00       	push   $0x84
  80068a:	68 7c 43 80 00       	push   $0x80437c
  80068f:	e8 2e 08 00 00       	call   800ec2 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800694:	e8 82 1e 00 00       	call   80251b <sys_calculate_free_frames>
  800699:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069c:	e8 1a 1f 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
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
  8006d1:	68 a0 44 80 00       	push   $0x8044a0
  8006d6:	68 8d 00 00 00       	push   $0x8d
  8006db:	68 7c 43 80 00       	push   $0x80437c
  8006e0:	e8 dd 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006e5:	e8 d1 1e 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  8006ea:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006ed:	74 17                	je     800706 <_main+0x6ce>
  8006ef:	83 ec 04             	sub    $0x4,%esp
  8006f2:	68 82 44 80 00       	push   $0x804482
  8006f7:	68 8f 00 00 00       	push   $0x8f
  8006fc:	68 7c 43 80 00       	push   $0x80437c
  800701:	e8 bc 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800706:	e8 10 1e 00 00       	call   80251b <sys_calculate_free_frames>
  80070b:	89 c2                	mov    %eax,%edx
  80070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800710:	39 c2                	cmp    %eax,%edx
  800712:	74 17                	je     80072b <_main+0x6f3>
  800714:	83 ec 04             	sub    $0x4,%esp
  800717:	68 d0 44 80 00       	push   $0x8044d0
  80071c:	68 90 00 00 00       	push   $0x90
  800721:	68 7c 43 80 00       	push   $0x80437c
  800726:	e8 97 07 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80072b:	e8 eb 1d 00 00       	call   80251b <sys_calculate_free_frames>
  800730:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800733:	e8 83 1e 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
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
  800767:	68 a0 44 80 00       	push   $0x8044a0
  80076c:	68 96 00 00 00       	push   $0x96
  800771:	68 7c 43 80 00       	push   $0x80437c
  800776:	e8 47 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80077b:	e8 3b 1e 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800780:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800783:	74 17                	je     80079c <_main+0x764>
  800785:	83 ec 04             	sub    $0x4,%esp
  800788:	68 82 44 80 00       	push   $0x804482
  80078d:	68 98 00 00 00       	push   $0x98
  800792:	68 7c 43 80 00       	push   $0x80437c
  800797:	e8 26 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80079c:	e8 7a 1d 00 00       	call   80251b <sys_calculate_free_frames>
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a6:	39 c2                	cmp    %eax,%edx
  8007a8:	74 17                	je     8007c1 <_main+0x789>
  8007aa:	83 ec 04             	sub    $0x4,%esp
  8007ad:	68 d0 44 80 00       	push   $0x8044d0
  8007b2:	68 99 00 00 00       	push   $0x99
  8007b7:	68 7c 43 80 00       	push   $0x80437c
  8007bc:	e8 01 07 00 00       	call   800ec2 <_panic>

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007c1:	e8 55 1d 00 00       	call   80251b <sys_calculate_free_frames>
  8007c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007c9:	e8 ed 1d 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
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
  8007e1:	68 0b 45 80 00       	push   $0x80450b
  8007e6:	e8 5e 1a 00 00       	call   802249 <smalloc>
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
  80080f:	68 a0 44 80 00       	push   $0x8044a0
  800814:	68 a0 00 00 00       	push   $0xa0
  800819:	68 7c 43 80 00       	push   $0x80437c
  80081e:	e8 9f 06 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800823:	e8 93 1d 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800828:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80082b:	74 17                	je     800844 <_main+0x80c>
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	68 82 44 80 00       	push   $0x804482
  800835:	68 a1 00 00 00       	push   $0xa1
  80083a:	68 7c 43 80 00       	push   $0x80437c
  80083f:	e8 7e 06 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 64+0+2) panic("Wrong allocation: %d", (freeFrames - sys_calculate_free_frames()));
  800844:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800847:	e8 cf 1c 00 00       	call   80251b <sys_calculate_free_frames>
  80084c:	29 c3                	sub    %eax,%ebx
  80084e:	89 d8                	mov    %ebx,%eax
  800850:	83 f8 42             	cmp    $0x42,%eax
  800853:	74 21                	je     800876 <_main+0x83e>
  800855:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800858:	e8 be 1c 00 00       	call   80251b <sys_calculate_free_frames>
  80085d:	29 c3                	sub    %eax,%ebx
  80085f:	89 d8                	mov    %ebx,%eax
  800861:	50                   	push   %eax
  800862:	68 0d 45 80 00       	push   $0x80450d
  800867:	68 a2 00 00 00       	push   $0xa2
  80086c:	68 7c 43 80 00       	push   $0x80437c
  800871:	e8 4c 06 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800876:	e8 a0 1c 00 00       	call   80251b <sys_calculate_free_frames>
  80087b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80087e:	e8 38 1d 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
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
  8008b1:	68 a0 44 80 00       	push   $0x8044a0
  8008b6:	68 a8 00 00 00       	push   $0xa8
  8008bb:	68 7c 43 80 00       	push   $0x80437c
  8008c0:	e8 fd 05 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8008c5:	e8 f1 1c 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  8008ca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 82 44 80 00       	push   $0x804482
  8008d7:	68 aa 00 00 00       	push   $0xaa
  8008dc:	68 7c 43 80 00       	push   $0x80437c
  8008e1:	e8 dc 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008e6:	e8 30 1c 00 00       	call   80251b <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 d0 44 80 00       	push   $0x8044d0
  8008fc:	68 ab 00 00 00       	push   $0xab
  800901:	68 7c 43 80 00       	push   $0x80437c
  800906:	e8 b7 05 00 00       	call   800ec2 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  80090b:	e8 0b 1c 00 00       	call   80251b <sys_calculate_free_frames>
  800910:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800913:	e8 a3 1c 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800918:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  80091b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091e:	c1 e0 02             	shl    $0x2,%eax
  800921:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	6a 00                	push   $0x0
  800929:	50                   	push   %eax
  80092a:	68 22 45 80 00       	push   $0x804522
  80092f:	e8 15 19 00 00       	call   802249 <smalloc>
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
  80095a:	68 a0 44 80 00       	push   $0x8044a0
  80095f:	68 b2 00 00 00       	push   $0xb2
  800964:	68 7c 43 80 00       	push   $0x80437c
  800969:	e8 54 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1024+1+2) panic("Wrong allocation: ");
  80096e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800971:	e8 a5 1b 00 00       	call   80251b <sys_calculate_free_frames>
  800976:	29 c3                	sub    %eax,%ebx
  800978:	89 d8                	mov    %ebx,%eax
  80097a:	3d 03 04 00 00       	cmp    $0x403,%eax
  80097f:	74 17                	je     800998 <_main+0x960>
  800981:	83 ec 04             	sub    $0x4,%esp
  800984:	68 d0 44 80 00       	push   $0x8044d0
  800989:	68 b3 00 00 00       	push   $0xb3
  80098e:	68 7c 43 80 00       	push   $0x80437c
  800993:	e8 2a 05 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800998:	e8 1e 1c 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 82 44 80 00       	push   $0x804482
  8009aa:	68 b4 00 00 00       	push   $0xb4
  8009af:	68 7c 43 80 00       	push   $0x80437c
  8009b4:	e8 09 05 00 00       	call   800ec2 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009b9:	e8 5d 1b 00 00       	call   80251b <sys_calculate_free_frames>
  8009be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009c1:	e8 f5 1b 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  8009c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  8009c9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8009cc:	83 ec 0c             	sub    $0xc,%esp
  8009cf:	50                   	push   %eax
  8009d0:	e8 a4 17 00 00       	call   802179 <free>
  8009d5:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009d8:	e8 de 1b 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  8009dd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009e0:	74 17                	je     8009f9 <_main+0x9c1>
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	68 e7 44 80 00       	push   $0x8044e7
  8009ea:	68 bf 00 00 00       	push   $0xbf
  8009ef:	68 7c 43 80 00       	push   $0x80437c
  8009f4:	e8 c9 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009f9:	e8 1d 1b 00 00       	call   80251b <sys_calculate_free_frames>
  8009fe:	89 c2                	mov    %eax,%edx
  800a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a03:	39 c2                	cmp    %eax,%edx
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 fe 44 80 00       	push   $0x8044fe
  800a0f:	68 c0 00 00 00       	push   $0xc0
  800a14:	68 7c 43 80 00       	push   $0x80437c
  800a19:	e8 a4 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a1e:	e8 f8 1a 00 00       	call   80251b <sys_calculate_free_frames>
  800a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a26:	e8 90 1b 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  800a2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a31:	83 ec 0c             	sub    $0xc,%esp
  800a34:	50                   	push   %eax
  800a35:	e8 3f 17 00 00       	call   802179 <free>
  800a3a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a3d:	e8 79 1b 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800a42:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a45:	74 17                	je     800a5e <_main+0xa26>
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	68 e7 44 80 00       	push   $0x8044e7
  800a4f:	68 c7 00 00 00       	push   $0xc7
  800a54:	68 7c 43 80 00       	push   $0x80437c
  800a59:	e8 64 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a5e:	e8 b8 1a 00 00       	call   80251b <sys_calculate_free_frames>
  800a63:	89 c2                	mov    %eax,%edx
  800a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a68:	39 c2                	cmp    %eax,%edx
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 fe 44 80 00       	push   $0x8044fe
  800a74:	68 c8 00 00 00       	push   $0xc8
  800a79:	68 7c 43 80 00       	push   $0x80437c
  800a7e:	e8 3f 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 93 1a 00 00       	call   80251b <sys_calculate_free_frames>
  800a88:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 2b 1b 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800a90:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800a93:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 da 16 00 00       	call   802179 <free>
  800a9f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800aa2:	e8 14 1b 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800aa7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800aaa:	74 17                	je     800ac3 <_main+0xa8b>
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	68 e7 44 80 00       	push   $0x8044e7
  800ab4:	68 cf 00 00 00       	push   $0xcf
  800ab9:	68 7c 43 80 00       	push   $0x80437c
  800abe:	e8 ff 03 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800ac3:	e8 53 1a 00 00       	call   80251b <sys_calculate_free_frames>
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	39 c2                	cmp    %eax,%edx
  800acf:	74 17                	je     800ae8 <_main+0xab0>
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	68 fe 44 80 00       	push   $0x8044fe
  800ad9:	68 d0 00 00 00       	push   $0xd0
  800ade:	68 7c 43 80 00       	push   $0x80437c
  800ae3:	e8 da 03 00 00       	call   800ec2 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800ae8:	e8 2e 1a 00 00       	call   80251b <sys_calculate_free_frames>
  800aed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800af0:	e8 c6 1a 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
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
  800b3b:	68 a0 44 80 00       	push   $0x8044a0
  800b40:	68 da 00 00 00       	push   $0xda
  800b45:	68 7c 43 80 00       	push   $0x80437c
  800b4a:	e8 73 03 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b4f:	e8 67 1a 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800b54:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800b57:	74 17                	je     800b70 <_main+0xb38>
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	68 82 44 80 00       	push   $0x804482
  800b61:	68 dc 00 00 00       	push   $0xdc
  800b66:	68 7c 43 80 00       	push   $0x80437c
  800b6b:	e8 52 03 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b70:	e8 a6 19 00 00       	call   80251b <sys_calculate_free_frames>
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b7a:	39 c2                	cmp    %eax,%edx
  800b7c:	74 17                	je     800b95 <_main+0xb5d>
  800b7e:	83 ec 04             	sub    $0x4,%esp
  800b81:	68 d0 44 80 00       	push   $0x8044d0
  800b86:	68 dd 00 00 00       	push   $0xdd
  800b8b:	68 7c 43 80 00       	push   $0x80437c
  800b90:	e8 2d 03 00 00       	call   800ec2 <_panic>

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800b95:	e8 81 19 00 00       	call   80251b <sys_calculate_free_frames>
  800b9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b9d:	e8 19 1a 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ba8:	c1 e0 02             	shl    $0x2,%eax
  800bab:	83 ec 04             	sub    $0x4,%esp
  800bae:	6a 00                	push   $0x0
  800bb0:	50                   	push   %eax
  800bb1:	68 24 45 80 00       	push   $0x804524
  800bb6:	e8 8e 16 00 00       	call   802249 <smalloc>
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
  800bdc:	68 98 43 80 00       	push   $0x804398
  800be1:	68 e3 00 00 00       	push   $0xe3
  800be6:	68 7c 43 80 00       	push   $0x80437c
  800beb:	e8 d2 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1024+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800bf0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800bf3:	e8 23 19 00 00       	call   80251b <sys_calculate_free_frames>
  800bf8:	29 c3                	sub    %eax,%ebx
  800bfa:	89 d8                	mov    %ebx,%eax
  800bfc:	3d 03 04 00 00       	cmp    $0x403,%eax
  800c01:	74 17                	je     800c1a <_main+0xbe2>
  800c03:	83 ec 04             	sub    $0x4,%esp
  800c06:	68 04 44 80 00       	push   $0x804404
  800c0b:	68 e4 00 00 00       	push   $0xe4
  800c10:	68 7c 43 80 00       	push   $0x80437c
  800c15:	e8 a8 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c1a:	e8 9c 19 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800c1f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800c22:	74 17                	je     800c3b <_main+0xc03>
  800c24:	83 ec 04             	sub    $0x4,%esp
  800c27:	68 82 44 80 00       	push   $0x804482
  800c2c:	68 e5 00 00 00       	push   $0xe5
  800c31:	68 7c 43 80 00       	push   $0x80437c
  800c36:	e8 87 02 00 00       	call   800ec2 <_panic>

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 db 18 00 00       	call   80251b <sys_calculate_free_frames>
  800c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c43:	e8 73 19 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	68 e5 44 80 00       	push   $0x8044e5
  800c53:	ff 75 ec             	pushl  -0x14(%ebp)
  800c56:	e8 9c 16 00 00       	call   8022f7 <sget>
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
  800c79:	68 98 43 80 00       	push   $0x804398
  800c7e:	68 eb 00 00 00       	push   $0xeb
  800c83:	68 7c 43 80 00       	push   $0x80437c
  800c88:	e8 35 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800c8d:	e8 89 18 00 00       	call   80251b <sys_calculate_free_frames>
  800c92:	89 c2                	mov    %eax,%edx
  800c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	74 17                	je     800cb2 <_main+0xc7a>
  800c9b:	83 ec 04             	sub    $0x4,%esp
  800c9e:	68 04 44 80 00       	push   $0x804404
  800ca3:	68 ec 00 00 00       	push   $0xec
  800ca8:	68 7c 43 80 00       	push   $0x80437c
  800cad:	e8 10 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800cb2:	e8 04 19 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800cb7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800cba:	74 17                	je     800cd3 <_main+0xc9b>
  800cbc:	83 ec 04             	sub    $0x4,%esp
  800cbf:	68 82 44 80 00       	push   $0x804482
  800cc4:	68 ed 00 00 00       	push   $0xed
  800cc9:	68 7c 43 80 00       	push   $0x80437c
  800cce:	e8 ef 01 00 00       	call   800ec2 <_panic>

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800cd3:	e8 43 18 00 00       	call   80251b <sys_calculate_free_frames>
  800cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800cdb:	e8 db 18 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800ce0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	68 93 43 80 00       	push   $0x804393
  800ceb:	ff 75 ec             	pushl  -0x14(%ebp)
  800cee:	e8 04 16 00 00       	call   8022f7 <sget>
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
  800d14:	68 98 43 80 00       	push   $0x804398
  800d19:	68 f3 00 00 00       	push   $0xf3
  800d1e:	68 7c 43 80 00       	push   $0x80437c
  800d23:	e8 9a 01 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800d28:	e8 ee 17 00 00       	call   80251b <sys_calculate_free_frames>
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d32:	39 c2                	cmp    %eax,%edx
  800d34:	74 17                	je     800d4d <_main+0xd15>
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	68 04 44 80 00       	push   $0x804404
  800d3e:	68 f4 00 00 00       	push   $0xf4
  800d43:	68 7c 43 80 00       	push   $0x80437c
  800d48:	e8 75 01 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800d4d:	e8 69 18 00 00       	call   8025bb <sys_pf_calculate_allocated_pages>
  800d52:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d55:	74 17                	je     800d6e <_main+0xd36>
  800d57:	83 ec 04             	sub    $0x4,%esp
  800d5a:	68 82 44 80 00       	push   $0x804482
  800d5f:	68 f5 00 00 00       	push   $0xf5
  800d64:	68 7c 43 80 00       	push   $0x80437c
  800d69:	e8 54 01 00 00       	call   800ec2 <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT allocation (3) completed successfully.\n");
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	68 28 45 80 00       	push   $0x804528
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
  800d8c:	e8 6a 1a 00 00       	call   8027fb <sys_getenvindex>
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
  800df7:	e8 0c 18 00 00       	call   802608 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	68 8c 45 80 00       	push   $0x80458c
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
  800e27:	68 b4 45 80 00       	push   $0x8045b4
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
  800e58:	68 dc 45 80 00       	push   $0x8045dc
  800e5d:	e8 14 03 00 00       	call   801176 <cprintf>
  800e62:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800e65:	a1 20 50 80 00       	mov    0x805020,%eax
  800e6a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	50                   	push   %eax
  800e74:	68 34 46 80 00       	push   $0x804634
  800e79:	e8 f8 02 00 00       	call   801176 <cprintf>
  800e7e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	68 8c 45 80 00       	push   $0x80458c
  800e89:	e8 e8 02 00 00       	call   801176 <cprintf>
  800e8e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e91:	e8 8c 17 00 00       	call   802622 <sys_enable_interrupt>

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
  800ea9:	e8 19 19 00 00       	call   8027c7 <sys_destroy_env>
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
  800eba:	e8 6e 19 00 00       	call   80282d <sys_exit_env>
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
  800ee3:	68 48 46 80 00       	push   $0x804648
  800ee8:	e8 89 02 00 00       	call   801176 <cprintf>
  800eed:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ef0:	a1 00 50 80 00       	mov    0x805000,%eax
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	ff 75 08             	pushl  0x8(%ebp)
  800efb:	50                   	push   %eax
  800efc:	68 4d 46 80 00       	push   $0x80464d
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
  800f20:	68 69 46 80 00       	push   $0x804669
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
  800f4c:	68 6c 46 80 00       	push   $0x80466c
  800f51:	6a 26                	push   $0x26
  800f53:	68 b8 46 80 00       	push   $0x8046b8
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
  80101e:	68 c4 46 80 00       	push   $0x8046c4
  801023:	6a 3a                	push   $0x3a
  801025:	68 b8 46 80 00       	push   $0x8046b8
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
  80108e:	68 18 47 80 00       	push   $0x804718
  801093:	6a 44                	push   $0x44
  801095:	68 b8 46 80 00       	push   $0x8046b8
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
  8010e8:	e8 6d 13 00 00       	call   80245a <sys_cputs>
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
  80115f:	e8 f6 12 00 00       	call   80245a <sys_cputs>
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
  8011a9:	e8 5a 14 00 00       	call   802608 <sys_disable_interrupt>
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
  8011c9:	e8 54 14 00 00       	call   802622 <sys_enable_interrupt>
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
  801213:	e8 c8 2e 00 00       	call   8040e0 <__udivdi3>
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
  801263:	e8 88 2f 00 00       	call   8041f0 <__umoddi3>
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	05 94 49 80 00       	add    $0x804994,%eax
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
  8013be:	8b 04 85 b8 49 80 00 	mov    0x8049b8(,%eax,4),%eax
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
  80149f:	8b 34 9d 00 48 80 00 	mov    0x804800(,%ebx,4),%esi
  8014a6:	85 f6                	test   %esi,%esi
  8014a8:	75 19                	jne    8014c3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8014aa:	53                   	push   %ebx
  8014ab:	68 a5 49 80 00       	push   $0x8049a5
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
  8014c4:	68 ae 49 80 00       	push   $0x8049ae
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
  8014f1:	be b1 49 80 00       	mov    $0x8049b1,%esi
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
  801f17:	68 10 4b 80 00       	push   $0x804b10
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
  801fe7:	e8 b2 05 00 00       	call   80259e <sys_allocate_chunk>
  801fec:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801fef:	a1 20 51 80 00       	mov    0x805120,%eax
  801ff4:	83 ec 0c             	sub    $0xc,%esp
  801ff7:	50                   	push   %eax
  801ff8:	e8 27 0c 00 00       	call   802c24 <initialize_MemBlocksList>
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
  802025:	68 35 4b 80 00       	push   $0x804b35
  80202a:	6a 33                	push   $0x33
  80202c:	68 53 4b 80 00       	push   $0x804b53
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
  8020a4:	68 60 4b 80 00       	push   $0x804b60
  8020a9:	6a 34                	push   $0x34
  8020ab:	68 53 4b 80 00       	push   $0x804b53
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
  80213c:	e8 2b 08 00 00       	call   80296c <sys_isUHeapPlacementStrategyFIRSTFIT>
  802141:	85 c0                	test   %eax,%eax
  802143:	74 11                	je     802156 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  802145:	83 ec 0c             	sub    $0xc,%esp
  802148:	ff 75 e8             	pushl  -0x18(%ebp)
  80214b:	e8 96 0e 00 00       	call   802fe6 <alloc_block_FF>
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
  802162:	e8 f2 0b 00 00       	call   802d59 <insert_sorted_allocList>
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
  80217c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	83 ec 08             	sub    $0x8,%esp
  802185:	50                   	push   %eax
  802186:	68 40 50 80 00       	push   $0x805040
  80218b:	e8 71 0b 00 00       	call   802d01 <find_block>
  802190:	83 c4 10             	add    $0x10,%esp
  802193:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  802196:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219a:	0f 84 a6 00 00 00    	je     802246 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8021a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8021a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a9:	8b 40 08             	mov    0x8(%eax),%eax
  8021ac:	83 ec 08             	sub    $0x8,%esp
  8021af:	52                   	push   %edx
  8021b0:	50                   	push   %eax
  8021b1:	e8 b0 03 00 00       	call   802566 <sys_free_user_mem>
  8021b6:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8021b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bd:	75 14                	jne    8021d3 <free+0x5a>
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 35 4b 80 00       	push   $0x804b35
  8021c7:	6a 74                	push   $0x74
  8021c9:	68 53 4b 80 00       	push   $0x804b53
  8021ce:	e8 ef ec ff ff       	call   800ec2 <_panic>
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	8b 00                	mov    (%eax),%eax
  8021d8:	85 c0                	test   %eax,%eax
  8021da:	74 10                	je     8021ec <free+0x73>
  8021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021df:	8b 00                	mov    (%eax),%eax
  8021e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e4:	8b 52 04             	mov    0x4(%edx),%edx
  8021e7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ea:	eb 0b                	jmp    8021f7 <free+0x7e>
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	8b 40 04             	mov    0x4(%eax),%eax
  8021f2:	a3 44 50 80 00       	mov    %eax,0x805044
  8021f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fa:	8b 40 04             	mov    0x4(%eax),%eax
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	74 0f                	je     802210 <free+0x97>
  802201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802204:	8b 40 04             	mov    0x4(%eax),%eax
  802207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220a:	8b 12                	mov    (%edx),%edx
  80220c:	89 10                	mov    %edx,(%eax)
  80220e:	eb 0a                	jmp    80221a <free+0xa1>
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	8b 00                	mov    (%eax),%eax
  802215:	a3 40 50 80 00       	mov    %eax,0x805040
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802232:	48                   	dec    %eax
  802233:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	ff 75 f4             	pushl  -0xc(%ebp)
  80223e:	e8 4e 17 00 00       	call   803991 <insert_sorted_with_merge_freeList>
  802243:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802246:	90                   	nop
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	83 ec 38             	sub    $0x38,%esp
  80224f:	8b 45 10             	mov    0x10(%ebp),%eax
  802252:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802255:	e8 a6 fc ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  80225a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80225e:	75 0a                	jne    80226a <smalloc+0x21>
  802260:	b8 00 00 00 00       	mov    $0x0,%eax
  802265:	e9 8b 00 00 00       	jmp    8022f5 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80226a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802271:	8b 55 0c             	mov    0xc(%ebp),%edx
  802274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802277:	01 d0                	add    %edx,%eax
  802279:	48                   	dec    %eax
  80227a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80227d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802280:	ba 00 00 00 00       	mov    $0x0,%edx
  802285:	f7 75 f0             	divl   -0x10(%ebp)
  802288:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228b:	29 d0                	sub    %edx,%eax
  80228d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802290:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802297:	e8 d0 06 00 00       	call   80296c <sys_isUHeapPlacementStrategyFIRSTFIT>
  80229c:	85 c0                	test   %eax,%eax
  80229e:	74 11                	je     8022b1 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8022a0:	83 ec 0c             	sub    $0xc,%esp
  8022a3:	ff 75 e8             	pushl  -0x18(%ebp)
  8022a6:	e8 3b 0d 00 00       	call   802fe6 <alloc_block_FF>
  8022ab:	83 c4 10             	add    $0x10,%esp
  8022ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8022b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b5:	74 39                	je     8022f0 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 40 08             	mov    0x8(%eax),%eax
  8022bd:	89 c2                	mov    %eax,%edx
  8022bf:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8022c3:	52                   	push   %edx
  8022c4:	50                   	push   %eax
  8022c5:	ff 75 0c             	pushl  0xc(%ebp)
  8022c8:	ff 75 08             	pushl  0x8(%ebp)
  8022cb:	e8 21 04 00 00       	call   8026f1 <sys_createSharedObject>
  8022d0:	83 c4 10             	add    $0x10,%esp
  8022d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8022d6:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8022da:	74 14                	je     8022f0 <smalloc+0xa7>
  8022dc:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8022e0:	74 0e                	je     8022f0 <smalloc+0xa7>
  8022e2:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8022e6:	74 08                	je     8022f0 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 40 08             	mov    0x8(%eax),%eax
  8022ee:	eb 05                	jmp    8022f5 <smalloc+0xac>
	}
	return NULL;
  8022f0:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022fd:	e8 fe fb ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802302:	83 ec 08             	sub    $0x8,%esp
  802305:	ff 75 0c             	pushl  0xc(%ebp)
  802308:	ff 75 08             	pushl  0x8(%ebp)
  80230b:	e8 0b 04 00 00       	call   80271b <sys_getSizeOfSharedObject>
  802310:	83 c4 10             	add    $0x10,%esp
  802313:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  802316:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80231a:	74 76                	je     802392 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80231c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802323:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802329:	01 d0                	add    %edx,%eax
  80232b:	48                   	dec    %eax
  80232c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80232f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802332:	ba 00 00 00 00       	mov    $0x0,%edx
  802337:	f7 75 ec             	divl   -0x14(%ebp)
  80233a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80233d:	29 d0                	sub    %edx,%eax
  80233f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  802342:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802349:	e8 1e 06 00 00       	call   80296c <sys_isUHeapPlacementStrategyFIRSTFIT>
  80234e:	85 c0                	test   %eax,%eax
  802350:	74 11                	je     802363 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  802352:	83 ec 0c             	sub    $0xc,%esp
  802355:	ff 75 e4             	pushl  -0x1c(%ebp)
  802358:	e8 89 0c 00 00       	call   802fe6 <alloc_block_FF>
  80235d:	83 c4 10             	add    $0x10,%esp
  802360:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  802363:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802367:	74 29                	je     802392 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 40 08             	mov    0x8(%eax),%eax
  80236f:	83 ec 04             	sub    $0x4,%esp
  802372:	50                   	push   %eax
  802373:	ff 75 0c             	pushl  0xc(%ebp)
  802376:	ff 75 08             	pushl  0x8(%ebp)
  802379:	e8 ba 03 00 00       	call   802738 <sys_getSharedObject>
  80237e:	83 c4 10             	add    $0x10,%esp
  802381:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  802384:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  802388:	74 08                	je     802392 <sget+0x9b>
				return (void *)mem_block->sva;
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 40 08             	mov    0x8(%eax),%eax
  802390:	eb 05                	jmp    802397 <sget+0xa0>
		}
	}
	return NULL;
  802392:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80239f:	e8 5c fb ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8023a4:	83 ec 04             	sub    $0x4,%esp
  8023a7:	68 84 4b 80 00       	push   $0x804b84
  8023ac:	68 f7 00 00 00       	push   $0xf7
  8023b1:	68 53 4b 80 00       	push   $0x804b53
  8023b6:	e8 07 eb ff ff       	call   800ec2 <_panic>

008023bb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8023c1:	83 ec 04             	sub    $0x4,%esp
  8023c4:	68 ac 4b 80 00       	push   $0x804bac
  8023c9:	68 0b 01 00 00       	push   $0x10b
  8023ce:	68 53 4b 80 00       	push   $0x804b53
  8023d3:	e8 ea ea ff ff       	call   800ec2 <_panic>

008023d8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023de:	83 ec 04             	sub    $0x4,%esp
  8023e1:	68 d0 4b 80 00       	push   $0x804bd0
  8023e6:	68 16 01 00 00       	push   $0x116
  8023eb:	68 53 4b 80 00       	push   $0x804b53
  8023f0:	e8 cd ea ff ff       	call   800ec2 <_panic>

008023f5 <shrink>:

}
void shrink(uint32 newSize)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
  8023f8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023fb:	83 ec 04             	sub    $0x4,%esp
  8023fe:	68 d0 4b 80 00       	push   $0x804bd0
  802403:	68 1b 01 00 00       	push   $0x11b
  802408:	68 53 4b 80 00       	push   $0x804b53
  80240d:	e8 b0 ea ff ff       	call   800ec2 <_panic>

00802412 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802418:	83 ec 04             	sub    $0x4,%esp
  80241b:	68 d0 4b 80 00       	push   $0x804bd0
  802420:	68 20 01 00 00       	push   $0x120
  802425:	68 53 4b 80 00       	push   $0x804b53
  80242a:	e8 93 ea ff ff       	call   800ec2 <_panic>

0080242f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	57                   	push   %edi
  802433:	56                   	push   %esi
  802434:	53                   	push   %ebx
  802435:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802441:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802444:	8b 7d 18             	mov    0x18(%ebp),%edi
  802447:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80244a:	cd 30                	int    $0x30
  80244c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80244f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802452:	83 c4 10             	add    $0x10,%esp
  802455:	5b                   	pop    %ebx
  802456:	5e                   	pop    %esi
  802457:	5f                   	pop    %edi
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    

0080245a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	83 ec 04             	sub    $0x4,%esp
  802460:	8b 45 10             	mov    0x10(%ebp),%eax
  802463:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802466:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	52                   	push   %edx
  802472:	ff 75 0c             	pushl  0xc(%ebp)
  802475:	50                   	push   %eax
  802476:	6a 00                	push   $0x0
  802478:	e8 b2 ff ff ff       	call   80242f <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
}
  802480:	90                   	nop
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <sys_cgetc>:

int
sys_cgetc(void)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 01                	push   $0x1
  802492:	e8 98 ff ff ff       	call   80242f <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80249f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	52                   	push   %edx
  8024ac:	50                   	push   %eax
  8024ad:	6a 05                	push   $0x5
  8024af:	e8 7b ff ff ff       	call   80242f <syscall>
  8024b4:	83 c4 18             	add    $0x18,%esp
}
  8024b7:	c9                   	leave  
  8024b8:	c3                   	ret    

008024b9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	56                   	push   %esi
  8024bd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8024be:	8b 75 18             	mov    0x18(%ebp),%esi
  8024c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	56                   	push   %esi
  8024ce:	53                   	push   %ebx
  8024cf:	51                   	push   %ecx
  8024d0:	52                   	push   %edx
  8024d1:	50                   	push   %eax
  8024d2:	6a 06                	push   $0x6
  8024d4:	e8 56 ff ff ff       	call   80242f <syscall>
  8024d9:	83 c4 18             	add    $0x18,%esp
}
  8024dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024df:	5b                   	pop    %ebx
  8024e0:	5e                   	pop    %esi
  8024e1:	5d                   	pop    %ebp
  8024e2:	c3                   	ret    

008024e3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	52                   	push   %edx
  8024f3:	50                   	push   %eax
  8024f4:	6a 07                	push   $0x7
  8024f6:	e8 34 ff ff ff       	call   80242f <syscall>
  8024fb:	83 c4 18             	add    $0x18,%esp
}
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	ff 75 0c             	pushl  0xc(%ebp)
  80250c:	ff 75 08             	pushl  0x8(%ebp)
  80250f:	6a 08                	push   $0x8
  802511:	e8 19 ff ff ff       	call   80242f <syscall>
  802516:	83 c4 18             	add    $0x18,%esp
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 09                	push   $0x9
  80252a:	e8 00 ff ff ff       	call   80242f <syscall>
  80252f:	83 c4 18             	add    $0x18,%esp
}
  802532:	c9                   	leave  
  802533:	c3                   	ret    

00802534 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 0a                	push   $0xa
  802543:	e8 e7 fe ff ff       	call   80242f <syscall>
  802548:	83 c4 18             	add    $0x18,%esp
}
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 0b                	push   $0xb
  80255c:	e8 ce fe ff ff       	call   80242f <syscall>
  802561:	83 c4 18             	add    $0x18,%esp
}
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	ff 75 0c             	pushl  0xc(%ebp)
  802572:	ff 75 08             	pushl  0x8(%ebp)
  802575:	6a 0f                	push   $0xf
  802577:	e8 b3 fe ff ff       	call   80242f <syscall>
  80257c:	83 c4 18             	add    $0x18,%esp
	return;
  80257f:	90                   	nop
}
  802580:	c9                   	leave  
  802581:	c3                   	ret    

00802582 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802582:	55                   	push   %ebp
  802583:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	ff 75 0c             	pushl  0xc(%ebp)
  80258e:	ff 75 08             	pushl  0x8(%ebp)
  802591:	6a 10                	push   $0x10
  802593:	e8 97 fe ff ff       	call   80242f <syscall>
  802598:	83 c4 18             	add    $0x18,%esp
	return ;
  80259b:	90                   	nop
}
  80259c:	c9                   	leave  
  80259d:	c3                   	ret    

0080259e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80259e:	55                   	push   %ebp
  80259f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	ff 75 10             	pushl  0x10(%ebp)
  8025a8:	ff 75 0c             	pushl  0xc(%ebp)
  8025ab:	ff 75 08             	pushl  0x8(%ebp)
  8025ae:	6a 11                	push   $0x11
  8025b0:	e8 7a fe ff ff       	call   80242f <syscall>
  8025b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b8:	90                   	nop
}
  8025b9:	c9                   	leave  
  8025ba:	c3                   	ret    

008025bb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 0c                	push   $0xc
  8025ca:	e8 60 fe ff ff       	call   80242f <syscall>
  8025cf:	83 c4 18             	add    $0x18,%esp
}
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

008025d4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	ff 75 08             	pushl  0x8(%ebp)
  8025e2:	6a 0d                	push   $0xd
  8025e4:	e8 46 fe ff ff       	call   80242f <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
}
  8025ec:	c9                   	leave  
  8025ed:	c3                   	ret    

008025ee <sys_scarce_memory>:

void sys_scarce_memory()
{
  8025ee:	55                   	push   %ebp
  8025ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 0e                	push   $0xe
  8025fd:	e8 2d fe ff ff       	call   80242f <syscall>
  802602:	83 c4 18             	add    $0x18,%esp
}
  802605:	90                   	nop
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 13                	push   $0x13
  802617:	e8 13 fe ff ff       	call   80242f <syscall>
  80261c:	83 c4 18             	add    $0x18,%esp
}
  80261f:	90                   	nop
  802620:	c9                   	leave  
  802621:	c3                   	ret    

00802622 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802622:	55                   	push   %ebp
  802623:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 14                	push   $0x14
  802631:	e8 f9 fd ff ff       	call   80242f <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
}
  802639:	90                   	nop
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <sys_cputc>:


void
sys_cputc(const char c)
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
  80263f:	83 ec 04             	sub    $0x4,%esp
  802642:	8b 45 08             	mov    0x8(%ebp),%eax
  802645:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802648:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	50                   	push   %eax
  802655:	6a 15                	push   $0x15
  802657:	e8 d3 fd ff ff       	call   80242f <syscall>
  80265c:	83 c4 18             	add    $0x18,%esp
}
  80265f:	90                   	nop
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 16                	push   $0x16
  802671:	e8 b9 fd ff ff       	call   80242f <syscall>
  802676:	83 c4 18             	add    $0x18,%esp
}
  802679:	90                   	nop
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80267f:	8b 45 08             	mov    0x8(%ebp),%eax
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	ff 75 0c             	pushl  0xc(%ebp)
  80268b:	50                   	push   %eax
  80268c:	6a 17                	push   $0x17
  80268e:	e8 9c fd ff ff       	call   80242f <syscall>
  802693:	83 c4 18             	add    $0x18,%esp
}
  802696:	c9                   	leave  
  802697:	c3                   	ret    

00802698 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80269b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	52                   	push   %edx
  8026a8:	50                   	push   %eax
  8026a9:	6a 1a                	push   $0x1a
  8026ab:	e8 7f fd ff ff       	call   80242f <syscall>
  8026b0:	83 c4 18             	add    $0x18,%esp
}
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	52                   	push   %edx
  8026c5:	50                   	push   %eax
  8026c6:	6a 18                	push   $0x18
  8026c8:	e8 62 fd ff ff       	call   80242f <syscall>
  8026cd:	83 c4 18             	add    $0x18,%esp
}
  8026d0:	90                   	nop
  8026d1:	c9                   	leave  
  8026d2:	c3                   	ret    

008026d3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	52                   	push   %edx
  8026e3:	50                   	push   %eax
  8026e4:	6a 19                	push   $0x19
  8026e6:	e8 44 fd ff ff       	call   80242f <syscall>
  8026eb:	83 c4 18             	add    $0x18,%esp
}
  8026ee:	90                   	nop
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
  8026f4:	83 ec 04             	sub    $0x4,%esp
  8026f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8026fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8026fd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802700:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	6a 00                	push   $0x0
  802709:	51                   	push   %ecx
  80270a:	52                   	push   %edx
  80270b:	ff 75 0c             	pushl  0xc(%ebp)
  80270e:	50                   	push   %eax
  80270f:	6a 1b                	push   $0x1b
  802711:	e8 19 fd ff ff       	call   80242f <syscall>
  802716:	83 c4 18             	add    $0x18,%esp
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80271e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802721:	8b 45 08             	mov    0x8(%ebp),%eax
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 00                	push   $0x0
  80272a:	52                   	push   %edx
  80272b:	50                   	push   %eax
  80272c:	6a 1c                	push   $0x1c
  80272e:	e8 fc fc ff ff       	call   80242f <syscall>
  802733:	83 c4 18             	add    $0x18,%esp
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80273b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80273e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	51                   	push   %ecx
  802749:	52                   	push   %edx
  80274a:	50                   	push   %eax
  80274b:	6a 1d                	push   $0x1d
  80274d:	e8 dd fc ff ff       	call   80242f <syscall>
  802752:	83 c4 18             	add    $0x18,%esp
}
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80275a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80275d:	8b 45 08             	mov    0x8(%ebp),%eax
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	6a 00                	push   $0x0
  802766:	52                   	push   %edx
  802767:	50                   	push   %eax
  802768:	6a 1e                	push   $0x1e
  80276a:	e8 c0 fc ff ff       	call   80242f <syscall>
  80276f:	83 c4 18             	add    $0x18,%esp
}
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	6a 1f                	push   $0x1f
  802783:	e8 a7 fc ff ff       	call   80242f <syscall>
  802788:	83 c4 18             	add    $0x18,%esp
}
  80278b:	c9                   	leave  
  80278c:	c3                   	ret    

0080278d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80278d:	55                   	push   %ebp
  80278e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802790:	8b 45 08             	mov    0x8(%ebp),%eax
  802793:	6a 00                	push   $0x0
  802795:	ff 75 14             	pushl  0x14(%ebp)
  802798:	ff 75 10             	pushl  0x10(%ebp)
  80279b:	ff 75 0c             	pushl  0xc(%ebp)
  80279e:	50                   	push   %eax
  80279f:	6a 20                	push   $0x20
  8027a1:	e8 89 fc ff ff       	call   80242f <syscall>
  8027a6:	83 c4 18             	add    $0x18,%esp
}
  8027a9:	c9                   	leave  
  8027aa:	c3                   	ret    

008027ab <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8027ab:	55                   	push   %ebp
  8027ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8027ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	50                   	push   %eax
  8027ba:	6a 21                	push   $0x21
  8027bc:	e8 6e fc ff ff       	call   80242f <syscall>
  8027c1:	83 c4 18             	add    $0x18,%esp
}
  8027c4:	90                   	nop
  8027c5:	c9                   	leave  
  8027c6:	c3                   	ret    

008027c7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8027c7:	55                   	push   %ebp
  8027c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	6a 00                	push   $0x0
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	50                   	push   %eax
  8027d6:	6a 22                	push   $0x22
  8027d8:	e8 52 fc ff ff       	call   80242f <syscall>
  8027dd:	83 c4 18             	add    $0x18,%esp
}
  8027e0:	c9                   	leave  
  8027e1:	c3                   	ret    

008027e2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 02                	push   $0x2
  8027f1:	e8 39 fc ff ff       	call   80242f <syscall>
  8027f6:	83 c4 18             	add    $0x18,%esp
}
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    

008027fb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	6a 00                	push   $0x0
  802804:	6a 00                	push   $0x0
  802806:	6a 00                	push   $0x0
  802808:	6a 03                	push   $0x3
  80280a:	e8 20 fc ff ff       	call   80242f <syscall>
  80280f:	83 c4 18             	add    $0x18,%esp
}
  802812:	c9                   	leave  
  802813:	c3                   	ret    

00802814 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	6a 00                	push   $0x0
  80281d:	6a 00                	push   $0x0
  80281f:	6a 00                	push   $0x0
  802821:	6a 04                	push   $0x4
  802823:	e8 07 fc ff ff       	call   80242f <syscall>
  802828:	83 c4 18             	add    $0x18,%esp
}
  80282b:	c9                   	leave  
  80282c:	c3                   	ret    

0080282d <sys_exit_env>:


void sys_exit_env(void)
{
  80282d:	55                   	push   %ebp
  80282e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802830:	6a 00                	push   $0x0
  802832:	6a 00                	push   $0x0
  802834:	6a 00                	push   $0x0
  802836:	6a 00                	push   $0x0
  802838:	6a 00                	push   $0x0
  80283a:	6a 23                	push   $0x23
  80283c:	e8 ee fb ff ff       	call   80242f <syscall>
  802841:	83 c4 18             	add    $0x18,%esp
}
  802844:	90                   	nop
  802845:	c9                   	leave  
  802846:	c3                   	ret    

00802847 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802847:	55                   	push   %ebp
  802848:	89 e5                	mov    %esp,%ebp
  80284a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80284d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802850:	8d 50 04             	lea    0x4(%eax),%edx
  802853:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	52                   	push   %edx
  80285d:	50                   	push   %eax
  80285e:	6a 24                	push   $0x24
  802860:	e8 ca fb ff ff       	call   80242f <syscall>
  802865:	83 c4 18             	add    $0x18,%esp
	return result;
  802868:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80286b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80286e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802871:	89 01                	mov    %eax,(%ecx)
  802873:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	c9                   	leave  
  80287a:	c2 04 00             	ret    $0x4

0080287d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80287d:	55                   	push   %ebp
  80287e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	ff 75 10             	pushl  0x10(%ebp)
  802887:	ff 75 0c             	pushl  0xc(%ebp)
  80288a:	ff 75 08             	pushl  0x8(%ebp)
  80288d:	6a 12                	push   $0x12
  80288f:	e8 9b fb ff ff       	call   80242f <syscall>
  802894:	83 c4 18             	add    $0x18,%esp
	return ;
  802897:	90                   	nop
}
  802898:	c9                   	leave  
  802899:	c3                   	ret    

0080289a <sys_rcr2>:
uint32 sys_rcr2()
{
  80289a:	55                   	push   %ebp
  80289b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80289d:	6a 00                	push   $0x0
  80289f:	6a 00                	push   $0x0
  8028a1:	6a 00                	push   $0x0
  8028a3:	6a 00                	push   $0x0
  8028a5:	6a 00                	push   $0x0
  8028a7:	6a 25                	push   $0x25
  8028a9:	e8 81 fb ff ff       	call   80242f <syscall>
  8028ae:	83 c4 18             	add    $0x18,%esp
}
  8028b1:	c9                   	leave  
  8028b2:	c3                   	ret    

008028b3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8028b3:	55                   	push   %ebp
  8028b4:	89 e5                	mov    %esp,%ebp
  8028b6:	83 ec 04             	sub    $0x4,%esp
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8028bf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8028c3:	6a 00                	push   $0x0
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 00                	push   $0x0
  8028cb:	50                   	push   %eax
  8028cc:	6a 26                	push   $0x26
  8028ce:	e8 5c fb ff ff       	call   80242f <syscall>
  8028d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8028d6:	90                   	nop
}
  8028d7:	c9                   	leave  
  8028d8:	c3                   	ret    

008028d9 <rsttst>:
void rsttst()
{
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8028dc:	6a 00                	push   $0x0
  8028de:	6a 00                	push   $0x0
  8028e0:	6a 00                	push   $0x0
  8028e2:	6a 00                	push   $0x0
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 28                	push   $0x28
  8028e8:	e8 42 fb ff ff       	call   80242f <syscall>
  8028ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8028f0:	90                   	nop
}
  8028f1:	c9                   	leave  
  8028f2:	c3                   	ret    

008028f3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8028f3:	55                   	push   %ebp
  8028f4:	89 e5                	mov    %esp,%ebp
  8028f6:	83 ec 04             	sub    $0x4,%esp
  8028f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8028fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8028ff:	8b 55 18             	mov    0x18(%ebp),%edx
  802902:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802906:	52                   	push   %edx
  802907:	50                   	push   %eax
  802908:	ff 75 10             	pushl  0x10(%ebp)
  80290b:	ff 75 0c             	pushl  0xc(%ebp)
  80290e:	ff 75 08             	pushl  0x8(%ebp)
  802911:	6a 27                	push   $0x27
  802913:	e8 17 fb ff ff       	call   80242f <syscall>
  802918:	83 c4 18             	add    $0x18,%esp
	return ;
  80291b:	90                   	nop
}
  80291c:	c9                   	leave  
  80291d:	c3                   	ret    

0080291e <chktst>:
void chktst(uint32 n)
{
  80291e:	55                   	push   %ebp
  80291f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802921:	6a 00                	push   $0x0
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	ff 75 08             	pushl  0x8(%ebp)
  80292c:	6a 29                	push   $0x29
  80292e:	e8 fc fa ff ff       	call   80242f <syscall>
  802933:	83 c4 18             	add    $0x18,%esp
	return ;
  802936:	90                   	nop
}
  802937:	c9                   	leave  
  802938:	c3                   	ret    

00802939 <inctst>:

void inctst()
{
  802939:	55                   	push   %ebp
  80293a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 2a                	push   $0x2a
  802948:	e8 e2 fa ff ff       	call   80242f <syscall>
  80294d:	83 c4 18             	add    $0x18,%esp
	return ;
  802950:	90                   	nop
}
  802951:	c9                   	leave  
  802952:	c3                   	ret    

00802953 <gettst>:
uint32 gettst()
{
  802953:	55                   	push   %ebp
  802954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802956:	6a 00                	push   $0x0
  802958:	6a 00                	push   $0x0
  80295a:	6a 00                	push   $0x0
  80295c:	6a 00                	push   $0x0
  80295e:	6a 00                	push   $0x0
  802960:	6a 2b                	push   $0x2b
  802962:	e8 c8 fa ff ff       	call   80242f <syscall>
  802967:	83 c4 18             	add    $0x18,%esp
}
  80296a:	c9                   	leave  
  80296b:	c3                   	ret    

0080296c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80296c:	55                   	push   %ebp
  80296d:	89 e5                	mov    %esp,%ebp
  80296f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802972:	6a 00                	push   $0x0
  802974:	6a 00                	push   $0x0
  802976:	6a 00                	push   $0x0
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	6a 2c                	push   $0x2c
  80297e:	e8 ac fa ff ff       	call   80242f <syscall>
  802983:	83 c4 18             	add    $0x18,%esp
  802986:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802989:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80298d:	75 07                	jne    802996 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80298f:	b8 01 00 00 00       	mov    $0x1,%eax
  802994:	eb 05                	jmp    80299b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802996:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80299b:	c9                   	leave  
  80299c:	c3                   	ret    

0080299d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80299d:	55                   	push   %ebp
  80299e:	89 e5                	mov    %esp,%ebp
  8029a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 00                	push   $0x0
  8029a9:	6a 00                	push   $0x0
  8029ab:	6a 00                	push   $0x0
  8029ad:	6a 2c                	push   $0x2c
  8029af:	e8 7b fa ff ff       	call   80242f <syscall>
  8029b4:	83 c4 18             	add    $0x18,%esp
  8029b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8029ba:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8029be:	75 07                	jne    8029c7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8029c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8029c5:	eb 05                	jmp    8029cc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8029c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029cc:	c9                   	leave  
  8029cd:	c3                   	ret    

008029ce <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8029ce:	55                   	push   %ebp
  8029cf:	89 e5                	mov    %esp,%ebp
  8029d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 2c                	push   $0x2c
  8029e0:	e8 4a fa ff ff       	call   80242f <syscall>
  8029e5:	83 c4 18             	add    $0x18,%esp
  8029e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8029eb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8029ef:	75 07                	jne    8029f8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8029f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8029f6:	eb 05                	jmp    8029fd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8029f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029fd:	c9                   	leave  
  8029fe:	c3                   	ret    

008029ff <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8029ff:	55                   	push   %ebp
  802a00:	89 e5                	mov    %esp,%ebp
  802a02:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a05:	6a 00                	push   $0x0
  802a07:	6a 00                	push   $0x0
  802a09:	6a 00                	push   $0x0
  802a0b:	6a 00                	push   $0x0
  802a0d:	6a 00                	push   $0x0
  802a0f:	6a 2c                	push   $0x2c
  802a11:	e8 19 fa ff ff       	call   80242f <syscall>
  802a16:	83 c4 18             	add    $0x18,%esp
  802a19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802a1c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802a20:	75 07                	jne    802a29 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802a22:	b8 01 00 00 00       	mov    $0x1,%eax
  802a27:	eb 05                	jmp    802a2e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802a29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a2e:	c9                   	leave  
  802a2f:	c3                   	ret    

00802a30 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802a30:	55                   	push   %ebp
  802a31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	6a 00                	push   $0x0
  802a39:	6a 00                	push   $0x0
  802a3b:	ff 75 08             	pushl  0x8(%ebp)
  802a3e:	6a 2d                	push   $0x2d
  802a40:	e8 ea f9 ff ff       	call   80242f <syscall>
  802a45:	83 c4 18             	add    $0x18,%esp
	return ;
  802a48:	90                   	nop
}
  802a49:	c9                   	leave  
  802a4a:	c3                   	ret    

00802a4b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a4b:	55                   	push   %ebp
  802a4c:	89 e5                	mov    %esp,%ebp
  802a4e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a4f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a58:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5b:	6a 00                	push   $0x0
  802a5d:	53                   	push   %ebx
  802a5e:	51                   	push   %ecx
  802a5f:	52                   	push   %edx
  802a60:	50                   	push   %eax
  802a61:	6a 2e                	push   $0x2e
  802a63:	e8 c7 f9 ff ff       	call   80242f <syscall>
  802a68:	83 c4 18             	add    $0x18,%esp
}
  802a6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a6e:	c9                   	leave  
  802a6f:	c3                   	ret    

00802a70 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a70:	55                   	push   %ebp
  802a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 00                	push   $0x0
  802a7d:	6a 00                	push   $0x0
  802a7f:	52                   	push   %edx
  802a80:	50                   	push   %eax
  802a81:	6a 2f                	push   $0x2f
  802a83:	e8 a7 f9 ff ff       	call   80242f <syscall>
  802a88:	83 c4 18             	add    $0x18,%esp
}
  802a8b:	c9                   	leave  
  802a8c:	c3                   	ret    

00802a8d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802a8d:	55                   	push   %ebp
  802a8e:	89 e5                	mov    %esp,%ebp
  802a90:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802a93:	83 ec 0c             	sub    $0xc,%esp
  802a96:	68 e0 4b 80 00       	push   $0x804be0
  802a9b:	e8 d6 e6 ff ff       	call   801176 <cprintf>
  802aa0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802aa3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802aaa:	83 ec 0c             	sub    $0xc,%esp
  802aad:	68 0c 4c 80 00       	push   $0x804c0c
  802ab2:	e8 bf e6 ff ff       	call   801176 <cprintf>
  802ab7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802aba:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802abe:	a1 38 51 80 00       	mov    0x805138,%eax
  802ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac6:	eb 56                	jmp    802b1e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802ac8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802acc:	74 1c                	je     802aea <print_mem_block_lists+0x5d>
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	8b 50 08             	mov    0x8(%eax),%edx
  802ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad7:	8b 48 08             	mov    0x8(%eax),%ecx
  802ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802add:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae0:	01 c8                	add    %ecx,%eax
  802ae2:	39 c2                	cmp    %eax,%edx
  802ae4:	73 04                	jae    802aea <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802ae6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 50 08             	mov    0x8(%eax),%edx
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 40 0c             	mov    0xc(%eax),%eax
  802af6:	01 c2                	add    %eax,%edx
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 40 08             	mov    0x8(%eax),%eax
  802afe:	83 ec 04             	sub    $0x4,%esp
  802b01:	52                   	push   %edx
  802b02:	50                   	push   %eax
  802b03:	68 21 4c 80 00       	push   $0x804c21
  802b08:	e8 69 e6 ff ff       	call   801176 <cprintf>
  802b0d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b16:	a1 40 51 80 00       	mov    0x805140,%eax
  802b1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b22:	74 07                	je     802b2b <print_mem_block_lists+0x9e>
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 00                	mov    (%eax),%eax
  802b29:	eb 05                	jmp    802b30 <print_mem_block_lists+0xa3>
  802b2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b30:	a3 40 51 80 00       	mov    %eax,0x805140
  802b35:	a1 40 51 80 00       	mov    0x805140,%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	75 8a                	jne    802ac8 <print_mem_block_lists+0x3b>
  802b3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b42:	75 84                	jne    802ac8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802b44:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b48:	75 10                	jne    802b5a <print_mem_block_lists+0xcd>
  802b4a:	83 ec 0c             	sub    $0xc,%esp
  802b4d:	68 30 4c 80 00       	push   $0x804c30
  802b52:	e8 1f e6 ff ff       	call   801176 <cprintf>
  802b57:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802b5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802b61:	83 ec 0c             	sub    $0xc,%esp
  802b64:	68 54 4c 80 00       	push   $0x804c54
  802b69:	e8 08 e6 ff ff       	call   801176 <cprintf>
  802b6e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802b71:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802b75:	a1 40 50 80 00       	mov    0x805040,%eax
  802b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b7d:	eb 56                	jmp    802bd5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802b7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b83:	74 1c                	je     802ba1 <print_mem_block_lists+0x114>
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	8b 50 08             	mov    0x8(%eax),%edx
  802b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8e:	8b 48 08             	mov    0x8(%eax),%ecx
  802b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b94:	8b 40 0c             	mov    0xc(%eax),%eax
  802b97:	01 c8                	add    %ecx,%eax
  802b99:	39 c2                	cmp    %eax,%edx
  802b9b:	73 04                	jae    802ba1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802b9d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 50 08             	mov    0x8(%eax),%edx
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bad:	01 c2                	add    %eax,%edx
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 40 08             	mov    0x8(%eax),%eax
  802bb5:	83 ec 04             	sub    $0x4,%esp
  802bb8:	52                   	push   %edx
  802bb9:	50                   	push   %eax
  802bba:	68 21 4c 80 00       	push   $0x804c21
  802bbf:	e8 b2 e5 ff ff       	call   801176 <cprintf>
  802bc4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802bcd:	a1 48 50 80 00       	mov    0x805048,%eax
  802bd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd9:	74 07                	je     802be2 <print_mem_block_lists+0x155>
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 00                	mov    (%eax),%eax
  802be0:	eb 05                	jmp    802be7 <print_mem_block_lists+0x15a>
  802be2:	b8 00 00 00 00       	mov    $0x0,%eax
  802be7:	a3 48 50 80 00       	mov    %eax,0x805048
  802bec:	a1 48 50 80 00       	mov    0x805048,%eax
  802bf1:	85 c0                	test   %eax,%eax
  802bf3:	75 8a                	jne    802b7f <print_mem_block_lists+0xf2>
  802bf5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf9:	75 84                	jne    802b7f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802bfb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802bff:	75 10                	jne    802c11 <print_mem_block_lists+0x184>
  802c01:	83 ec 0c             	sub    $0xc,%esp
  802c04:	68 6c 4c 80 00       	push   $0x804c6c
  802c09:	e8 68 e5 ff ff       	call   801176 <cprintf>
  802c0e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802c11:	83 ec 0c             	sub    $0xc,%esp
  802c14:	68 e0 4b 80 00       	push   $0x804be0
  802c19:	e8 58 e5 ff ff       	call   801176 <cprintf>
  802c1e:	83 c4 10             	add    $0x10,%esp

}
  802c21:	90                   	nop
  802c22:	c9                   	leave  
  802c23:	c3                   	ret    

00802c24 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802c24:	55                   	push   %ebp
  802c25:	89 e5                	mov    %esp,%ebp
  802c27:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802c2a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802c31:	00 00 00 
  802c34:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802c3b:	00 00 00 
  802c3e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802c45:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802c48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c4f:	e9 9e 00 00 00       	jmp    802cf2 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802c54:	a1 50 50 80 00       	mov    0x805050,%eax
  802c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5c:	c1 e2 04             	shl    $0x4,%edx
  802c5f:	01 d0                	add    %edx,%eax
  802c61:	85 c0                	test   %eax,%eax
  802c63:	75 14                	jne    802c79 <initialize_MemBlocksList+0x55>
  802c65:	83 ec 04             	sub    $0x4,%esp
  802c68:	68 94 4c 80 00       	push   $0x804c94
  802c6d:	6a 46                	push   $0x46
  802c6f:	68 b7 4c 80 00       	push   $0x804cb7
  802c74:	e8 49 e2 ff ff       	call   800ec2 <_panic>
  802c79:	a1 50 50 80 00       	mov    0x805050,%eax
  802c7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c81:	c1 e2 04             	shl    $0x4,%edx
  802c84:	01 d0                	add    %edx,%eax
  802c86:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802c8c:	89 10                	mov    %edx,(%eax)
  802c8e:	8b 00                	mov    (%eax),%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	74 18                	je     802cac <initialize_MemBlocksList+0x88>
  802c94:	a1 48 51 80 00       	mov    0x805148,%eax
  802c99:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802c9f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802ca2:	c1 e1 04             	shl    $0x4,%ecx
  802ca5:	01 ca                	add    %ecx,%edx
  802ca7:	89 50 04             	mov    %edx,0x4(%eax)
  802caa:	eb 12                	jmp    802cbe <initialize_MemBlocksList+0x9a>
  802cac:	a1 50 50 80 00       	mov    0x805050,%eax
  802cb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb4:	c1 e2 04             	shl    $0x4,%edx
  802cb7:	01 d0                	add    %edx,%eax
  802cb9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cbe:	a1 50 50 80 00       	mov    0x805050,%eax
  802cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc6:	c1 e2 04             	shl    $0x4,%edx
  802cc9:	01 d0                	add    %edx,%eax
  802ccb:	a3 48 51 80 00       	mov    %eax,0x805148
  802cd0:	a1 50 50 80 00       	mov    0x805050,%eax
  802cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd8:	c1 e2 04             	shl    $0x4,%edx
  802cdb:	01 d0                	add    %edx,%eax
  802cdd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce4:	a1 54 51 80 00       	mov    0x805154,%eax
  802ce9:	40                   	inc    %eax
  802cea:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802cef:	ff 45 f4             	incl   -0xc(%ebp)
  802cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf8:	0f 82 56 ff ff ff    	jb     802c54 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802cfe:	90                   	nop
  802cff:	c9                   	leave  
  802d00:	c3                   	ret    

00802d01 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802d01:	55                   	push   %ebp
  802d02:	89 e5                	mov    %esp,%ebp
  802d04:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	8b 00                	mov    (%eax),%eax
  802d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d0f:	eb 19                	jmp    802d2a <find_block+0x29>
	{
		if(va==point->sva)
  802d11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d14:	8b 40 08             	mov    0x8(%eax),%eax
  802d17:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d1a:	75 05                	jne    802d21 <find_block+0x20>
		   return point;
  802d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d1f:	eb 36                	jmp    802d57 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	8b 40 08             	mov    0x8(%eax),%eax
  802d27:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d2e:	74 07                	je     802d37 <find_block+0x36>
  802d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	eb 05                	jmp    802d3c <find_block+0x3b>
  802d37:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3f:	89 42 08             	mov    %eax,0x8(%edx)
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	8b 40 08             	mov    0x8(%eax),%eax
  802d48:	85 c0                	test   %eax,%eax
  802d4a:	75 c5                	jne    802d11 <find_block+0x10>
  802d4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d50:	75 bf                	jne    802d11 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802d52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d57:	c9                   	leave  
  802d58:	c3                   	ret    

00802d59 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802d59:	55                   	push   %ebp
  802d5a:	89 e5                	mov    %esp,%ebp
  802d5c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802d5f:	a1 40 50 80 00       	mov    0x805040,%eax
  802d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802d67:	a1 44 50 80 00       	mov    0x805044,%eax
  802d6c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d72:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d75:	74 24                	je     802d9b <insert_sorted_allocList+0x42>
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	8b 50 08             	mov    0x8(%eax),%edx
  802d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d80:	8b 40 08             	mov    0x8(%eax),%eax
  802d83:	39 c2                	cmp    %eax,%edx
  802d85:	76 14                	jbe    802d9b <insert_sorted_allocList+0x42>
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	8b 50 08             	mov    0x8(%eax),%edx
  802d8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d90:	8b 40 08             	mov    0x8(%eax),%eax
  802d93:	39 c2                	cmp    %eax,%edx
  802d95:	0f 82 60 01 00 00    	jb     802efb <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802d9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9f:	75 65                	jne    802e06 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802da1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da5:	75 14                	jne    802dbb <insert_sorted_allocList+0x62>
  802da7:	83 ec 04             	sub    $0x4,%esp
  802daa:	68 94 4c 80 00       	push   $0x804c94
  802daf:	6a 6b                	push   $0x6b
  802db1:	68 b7 4c 80 00       	push   $0x804cb7
  802db6:	e8 07 e1 ff ff       	call   800ec2 <_panic>
  802dbb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	89 10                	mov    %edx,(%eax)
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 0d                	je     802ddc <insert_sorted_allocList+0x83>
  802dcf:	a1 40 50 80 00       	mov    0x805040,%eax
  802dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd7:	89 50 04             	mov    %edx,0x4(%eax)
  802dda:	eb 08                	jmp    802de4 <insert_sorted_allocList+0x8b>
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	a3 44 50 80 00       	mov    %eax,0x805044
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	a3 40 50 80 00       	mov    %eax,0x805040
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802dfb:	40                   	inc    %eax
  802dfc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802e01:	e9 dc 01 00 00       	jmp    802fe2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	8b 50 08             	mov    0x8(%eax),%edx
  802e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0f:	8b 40 08             	mov    0x8(%eax),%eax
  802e12:	39 c2                	cmp    %eax,%edx
  802e14:	77 6c                	ja     802e82 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802e16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e1a:	74 06                	je     802e22 <insert_sorted_allocList+0xc9>
  802e1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e20:	75 14                	jne    802e36 <insert_sorted_allocList+0xdd>
  802e22:	83 ec 04             	sub    $0x4,%esp
  802e25:	68 d0 4c 80 00       	push   $0x804cd0
  802e2a:	6a 6f                	push   $0x6f
  802e2c:	68 b7 4c 80 00       	push   $0x804cb7
  802e31:	e8 8c e0 ff ff       	call   800ec2 <_panic>
  802e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e39:	8b 50 04             	mov    0x4(%eax),%edx
  802e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3f:	89 50 04             	mov    %edx,0x4(%eax)
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e48:	89 10                	mov    %edx,(%eax)
  802e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4d:	8b 40 04             	mov    0x4(%eax),%eax
  802e50:	85 c0                	test   %eax,%eax
  802e52:	74 0d                	je     802e61 <insert_sorted_allocList+0x108>
  802e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e57:	8b 40 04             	mov    0x4(%eax),%eax
  802e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5d:	89 10                	mov    %edx,(%eax)
  802e5f:	eb 08                	jmp    802e69 <insert_sorted_allocList+0x110>
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	a3 40 50 80 00       	mov    %eax,0x805040
  802e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6f:	89 50 04             	mov    %edx,0x4(%eax)
  802e72:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e77:	40                   	inc    %eax
  802e78:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802e7d:	e9 60 01 00 00       	jmp    802fe2 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	8b 50 08             	mov    0x8(%eax),%edx
  802e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8b:	8b 40 08             	mov    0x8(%eax),%eax
  802e8e:	39 c2                	cmp    %eax,%edx
  802e90:	0f 82 4c 01 00 00    	jb     802fe2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802e96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9a:	75 14                	jne    802eb0 <insert_sorted_allocList+0x157>
  802e9c:	83 ec 04             	sub    $0x4,%esp
  802e9f:	68 08 4d 80 00       	push   $0x804d08
  802ea4:	6a 73                	push   $0x73
  802ea6:	68 b7 4c 80 00       	push   $0x804cb7
  802eab:	e8 12 e0 ff ff       	call   800ec2 <_panic>
  802eb0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	89 50 04             	mov    %edx,0x4(%eax)
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	8b 40 04             	mov    0x4(%eax),%eax
  802ec2:	85 c0                	test   %eax,%eax
  802ec4:	74 0c                	je     802ed2 <insert_sorted_allocList+0x179>
  802ec6:	a1 44 50 80 00       	mov    0x805044,%eax
  802ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ece:	89 10                	mov    %edx,(%eax)
  802ed0:	eb 08                	jmp    802eda <insert_sorted_allocList+0x181>
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	a3 40 50 80 00       	mov    %eax,0x805040
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	a3 44 50 80 00       	mov    %eax,0x805044
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eeb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ef0:	40                   	inc    %eax
  802ef1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ef6:	e9 e7 00 00 00       	jmp    802fe2 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802f01:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802f08:	a1 40 50 80 00       	mov    0x805040,%eax
  802f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f10:	e9 9d 00 00 00       	jmp    802fb2 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 00                	mov    (%eax),%eax
  802f1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	8b 50 08             	mov    0x8(%eax),%edx
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 40 08             	mov    0x8(%eax),%eax
  802f29:	39 c2                	cmp    %eax,%edx
  802f2b:	76 7d                	jbe    802faa <insert_sorted_allocList+0x251>
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	8b 50 08             	mov    0x8(%eax),%edx
  802f33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f36:	8b 40 08             	mov    0x8(%eax),%eax
  802f39:	39 c2                	cmp    %eax,%edx
  802f3b:	73 6d                	jae    802faa <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802f3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f41:	74 06                	je     802f49 <insert_sorted_allocList+0x1f0>
  802f43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f47:	75 14                	jne    802f5d <insert_sorted_allocList+0x204>
  802f49:	83 ec 04             	sub    $0x4,%esp
  802f4c:	68 2c 4d 80 00       	push   $0x804d2c
  802f51:	6a 7f                	push   $0x7f
  802f53:	68 b7 4c 80 00       	push   $0x804cb7
  802f58:	e8 65 df ff ff       	call   800ec2 <_panic>
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	8b 10                	mov    (%eax),%edx
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	89 10                	mov    %edx,(%eax)
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	8b 00                	mov    (%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 0b                	je     802f7b <insert_sorted_allocList+0x222>
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	8b 55 08             	mov    0x8(%ebp),%edx
  802f78:	89 50 04             	mov    %edx,0x4(%eax)
  802f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f81:	89 10                	mov    %edx,(%eax)
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f89:	89 50 04             	mov    %edx,0x4(%eax)
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	8b 00                	mov    (%eax),%eax
  802f91:	85 c0                	test   %eax,%eax
  802f93:	75 08                	jne    802f9d <insert_sorted_allocList+0x244>
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	a3 44 50 80 00       	mov    %eax,0x805044
  802f9d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802fa2:	40                   	inc    %eax
  802fa3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802fa8:	eb 39                	jmp    802fe3 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802faa:	a1 48 50 80 00       	mov    0x805048,%eax
  802faf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb6:	74 07                	je     802fbf <insert_sorted_allocList+0x266>
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	eb 05                	jmp    802fc4 <insert_sorted_allocList+0x26b>
  802fbf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc4:	a3 48 50 80 00       	mov    %eax,0x805048
  802fc9:	a1 48 50 80 00       	mov    0x805048,%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	0f 85 3f ff ff ff    	jne    802f15 <insert_sorted_allocList+0x1bc>
  802fd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fda:	0f 85 35 ff ff ff    	jne    802f15 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802fe0:	eb 01                	jmp    802fe3 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802fe2:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802fe3:	90                   	nop
  802fe4:	c9                   	leave  
  802fe5:	c3                   	ret    

00802fe6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802fe6:	55                   	push   %ebp
  802fe7:	89 e5                	mov    %esp,%ebp
  802fe9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802fec:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff4:	e9 85 01 00 00       	jmp    80317e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fff:	3b 45 08             	cmp    0x8(%ebp),%eax
  803002:	0f 82 6e 01 00 00    	jb     803176 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  803008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300b:	8b 40 0c             	mov    0xc(%eax),%eax
  80300e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803011:	0f 85 8a 00 00 00    	jne    8030a1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  803017:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301b:	75 17                	jne    803034 <alloc_block_FF+0x4e>
  80301d:	83 ec 04             	sub    $0x4,%esp
  803020:	68 60 4d 80 00       	push   $0x804d60
  803025:	68 93 00 00 00       	push   $0x93
  80302a:	68 b7 4c 80 00       	push   $0x804cb7
  80302f:	e8 8e de ff ff       	call   800ec2 <_panic>
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	8b 00                	mov    (%eax),%eax
  803039:	85 c0                	test   %eax,%eax
  80303b:	74 10                	je     80304d <alloc_block_FF+0x67>
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803045:	8b 52 04             	mov    0x4(%edx),%edx
  803048:	89 50 04             	mov    %edx,0x4(%eax)
  80304b:	eb 0b                	jmp    803058 <alloc_block_FF+0x72>
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	8b 40 04             	mov    0x4(%eax),%eax
  803053:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 40 04             	mov    0x4(%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 0f                	je     803071 <alloc_block_FF+0x8b>
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	8b 40 04             	mov    0x4(%eax),%eax
  803068:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306b:	8b 12                	mov    (%edx),%edx
  80306d:	89 10                	mov    %edx,(%eax)
  80306f:	eb 0a                	jmp    80307b <alloc_block_FF+0x95>
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 00                	mov    (%eax),%eax
  803076:	a3 38 51 80 00       	mov    %eax,0x805138
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308e:	a1 44 51 80 00       	mov    0x805144,%eax
  803093:	48                   	dec    %eax
  803094:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	e9 10 01 00 00       	jmp    8031b1 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030aa:	0f 86 c6 00 00 00    	jbe    803176 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030b0:	a1 48 51 80 00       	mov    0x805148,%eax
  8030b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	8b 50 08             	mov    0x8(%eax),%edx
  8030be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c1:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8030c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ca:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030d1:	75 17                	jne    8030ea <alloc_block_FF+0x104>
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	68 60 4d 80 00       	push   $0x804d60
  8030db:	68 9b 00 00 00       	push   $0x9b
  8030e0:	68 b7 4c 80 00       	push   $0x804cb7
  8030e5:	e8 d8 dd ff ff       	call   800ec2 <_panic>
  8030ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ed:	8b 00                	mov    (%eax),%eax
  8030ef:	85 c0                	test   %eax,%eax
  8030f1:	74 10                	je     803103 <alloc_block_FF+0x11d>
  8030f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f6:	8b 00                	mov    (%eax),%eax
  8030f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030fb:	8b 52 04             	mov    0x4(%edx),%edx
  8030fe:	89 50 04             	mov    %edx,0x4(%eax)
  803101:	eb 0b                	jmp    80310e <alloc_block_FF+0x128>
  803103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803106:	8b 40 04             	mov    0x4(%eax),%eax
  803109:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80310e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803111:	8b 40 04             	mov    0x4(%eax),%eax
  803114:	85 c0                	test   %eax,%eax
  803116:	74 0f                	je     803127 <alloc_block_FF+0x141>
  803118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311b:	8b 40 04             	mov    0x4(%eax),%eax
  80311e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803121:	8b 12                	mov    (%edx),%edx
  803123:	89 10                	mov    %edx,(%eax)
  803125:	eb 0a                	jmp    803131 <alloc_block_FF+0x14b>
  803127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	a3 48 51 80 00       	mov    %eax,0x805148
  803131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803134:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803144:	a1 54 51 80 00       	mov    0x805154,%eax
  803149:	48                   	dec    %eax
  80314a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 50 08             	mov    0x8(%eax),%edx
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	01 c2                	add    %eax,%edx
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 40 0c             	mov    0xc(%eax),%eax
  803166:	2b 45 08             	sub    0x8(%ebp),%eax
  803169:	89 c2                	mov    %eax,%edx
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  803171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803174:	eb 3b                	jmp    8031b1 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803176:	a1 40 51 80 00       	mov    0x805140,%eax
  80317b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80317e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803182:	74 07                	je     80318b <alloc_block_FF+0x1a5>
  803184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	eb 05                	jmp    803190 <alloc_block_FF+0x1aa>
  80318b:	b8 00 00 00 00       	mov    $0x0,%eax
  803190:	a3 40 51 80 00       	mov    %eax,0x805140
  803195:	a1 40 51 80 00       	mov    0x805140,%eax
  80319a:	85 c0                	test   %eax,%eax
  80319c:	0f 85 57 fe ff ff    	jne    802ff9 <alloc_block_FF+0x13>
  8031a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a6:	0f 85 4d fe ff ff    	jne    802ff9 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8031ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031b1:	c9                   	leave  
  8031b2:	c3                   	ret    

008031b3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8031b3:	55                   	push   %ebp
  8031b4:	89 e5                	mov    %esp,%ebp
  8031b6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8031b9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8031c0:	a1 38 51 80 00       	mov    0x805138,%eax
  8031c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c8:	e9 df 00 00 00       	jmp    8032ac <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8031cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d6:	0f 82 c8 00 00 00    	jb     8032a4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e5:	0f 85 8a 00 00 00    	jne    803275 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8031eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ef:	75 17                	jne    803208 <alloc_block_BF+0x55>
  8031f1:	83 ec 04             	sub    $0x4,%esp
  8031f4:	68 60 4d 80 00       	push   $0x804d60
  8031f9:	68 b7 00 00 00       	push   $0xb7
  8031fe:	68 b7 4c 80 00       	push   $0x804cb7
  803203:	e8 ba dc ff ff       	call   800ec2 <_panic>
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	8b 00                	mov    (%eax),%eax
  80320d:	85 c0                	test   %eax,%eax
  80320f:	74 10                	je     803221 <alloc_block_BF+0x6e>
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803219:	8b 52 04             	mov    0x4(%edx),%edx
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	eb 0b                	jmp    80322c <alloc_block_BF+0x79>
  803221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803224:	8b 40 04             	mov    0x4(%eax),%eax
  803227:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80322c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322f:	8b 40 04             	mov    0x4(%eax),%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	74 0f                	je     803245 <alloc_block_BF+0x92>
  803236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803239:	8b 40 04             	mov    0x4(%eax),%eax
  80323c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323f:	8b 12                	mov    (%edx),%edx
  803241:	89 10                	mov    %edx,(%eax)
  803243:	eb 0a                	jmp    80324f <alloc_block_BF+0x9c>
  803245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803248:	8b 00                	mov    (%eax),%eax
  80324a:	a3 38 51 80 00       	mov    %eax,0x805138
  80324f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803252:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803262:	a1 44 51 80 00       	mov    0x805144,%eax
  803267:	48                   	dec    %eax
  803268:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	e9 4d 01 00 00       	jmp    8033c2 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803278:	8b 40 0c             	mov    0xc(%eax),%eax
  80327b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80327e:	76 24                	jbe    8032a4 <alloc_block_BF+0xf1>
  803280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803283:	8b 40 0c             	mov    0xc(%eax),%eax
  803286:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803289:	73 19                	jae    8032a4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80328b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	8b 40 0c             	mov    0xc(%eax),%eax
  803298:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329e:	8b 40 08             	mov    0x8(%eax),%eax
  8032a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8032a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8032a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b0:	74 07                	je     8032b9 <alloc_block_BF+0x106>
  8032b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b5:	8b 00                	mov    (%eax),%eax
  8032b7:	eb 05                	jmp    8032be <alloc_block_BF+0x10b>
  8032b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8032be:	a3 40 51 80 00       	mov    %eax,0x805140
  8032c3:	a1 40 51 80 00       	mov    0x805140,%eax
  8032c8:	85 c0                	test   %eax,%eax
  8032ca:	0f 85 fd fe ff ff    	jne    8031cd <alloc_block_BF+0x1a>
  8032d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d4:	0f 85 f3 fe ff ff    	jne    8031cd <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8032da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032de:	0f 84 d9 00 00 00    	je     8033bd <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032e4:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8032ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032f2:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8032f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032fb:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8032fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803302:	75 17                	jne    80331b <alloc_block_BF+0x168>
  803304:	83 ec 04             	sub    $0x4,%esp
  803307:	68 60 4d 80 00       	push   $0x804d60
  80330c:	68 c7 00 00 00       	push   $0xc7
  803311:	68 b7 4c 80 00       	push   $0x804cb7
  803316:	e8 a7 db ff ff       	call   800ec2 <_panic>
  80331b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	85 c0                	test   %eax,%eax
  803322:	74 10                	je     803334 <alloc_block_BF+0x181>
  803324:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803327:	8b 00                	mov    (%eax),%eax
  803329:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80332c:	8b 52 04             	mov    0x4(%edx),%edx
  80332f:	89 50 04             	mov    %edx,0x4(%eax)
  803332:	eb 0b                	jmp    80333f <alloc_block_BF+0x18c>
  803334:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803337:	8b 40 04             	mov    0x4(%eax),%eax
  80333a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80333f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803342:	8b 40 04             	mov    0x4(%eax),%eax
  803345:	85 c0                	test   %eax,%eax
  803347:	74 0f                	je     803358 <alloc_block_BF+0x1a5>
  803349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334c:	8b 40 04             	mov    0x4(%eax),%eax
  80334f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803352:	8b 12                	mov    (%edx),%edx
  803354:	89 10                	mov    %edx,(%eax)
  803356:	eb 0a                	jmp    803362 <alloc_block_BF+0x1af>
  803358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	a3 48 51 80 00       	mov    %eax,0x805148
  803362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803365:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803375:	a1 54 51 80 00       	mov    0x805154,%eax
  80337a:	48                   	dec    %eax
  80337b:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803380:	83 ec 08             	sub    $0x8,%esp
  803383:	ff 75 ec             	pushl  -0x14(%ebp)
  803386:	68 38 51 80 00       	push   $0x805138
  80338b:	e8 71 f9 ff ff       	call   802d01 <find_block>
  803390:	83 c4 10             	add    $0x10,%esp
  803393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803396:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803399:	8b 50 08             	mov    0x8(%eax),%edx
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	01 c2                	add    %eax,%edx
  8033a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033a4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8033a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ad:	2b 45 08             	sub    0x8(%ebp),%eax
  8033b0:	89 c2                	mov    %eax,%edx
  8033b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b5:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8033b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bb:	eb 05                	jmp    8033c2 <alloc_block_BF+0x20f>
	}
	return NULL;
  8033bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033c2:	c9                   	leave  
  8033c3:	c3                   	ret    

008033c4 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8033c4:	55                   	push   %ebp
  8033c5:	89 e5                	mov    %esp,%ebp
  8033c7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8033ca:	a1 28 50 80 00       	mov    0x805028,%eax
  8033cf:	85 c0                	test   %eax,%eax
  8033d1:	0f 85 de 01 00 00    	jne    8035b5 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8033d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8033dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033df:	e9 9e 01 00 00       	jmp    803582 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8033e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033ed:	0f 82 87 01 00 00    	jb     80357a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033fc:	0f 85 95 00 00 00    	jne    803497 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803406:	75 17                	jne    80341f <alloc_block_NF+0x5b>
  803408:	83 ec 04             	sub    $0x4,%esp
  80340b:	68 60 4d 80 00       	push   $0x804d60
  803410:	68 e0 00 00 00       	push   $0xe0
  803415:	68 b7 4c 80 00       	push   $0x804cb7
  80341a:	e8 a3 da ff ff       	call   800ec2 <_panic>
  80341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803422:	8b 00                	mov    (%eax),%eax
  803424:	85 c0                	test   %eax,%eax
  803426:	74 10                	je     803438 <alloc_block_NF+0x74>
  803428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803430:	8b 52 04             	mov    0x4(%edx),%edx
  803433:	89 50 04             	mov    %edx,0x4(%eax)
  803436:	eb 0b                	jmp    803443 <alloc_block_NF+0x7f>
  803438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343b:	8b 40 04             	mov    0x4(%eax),%eax
  80343e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	8b 40 04             	mov    0x4(%eax),%eax
  803449:	85 c0                	test   %eax,%eax
  80344b:	74 0f                	je     80345c <alloc_block_NF+0x98>
  80344d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803450:	8b 40 04             	mov    0x4(%eax),%eax
  803453:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803456:	8b 12                	mov    (%edx),%edx
  803458:	89 10                	mov    %edx,(%eax)
  80345a:	eb 0a                	jmp    803466 <alloc_block_NF+0xa2>
  80345c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345f:	8b 00                	mov    (%eax),%eax
  803461:	a3 38 51 80 00       	mov    %eax,0x805138
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803472:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803479:	a1 44 51 80 00       	mov    0x805144,%eax
  80347e:	48                   	dec    %eax
  80347f:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803487:	8b 40 08             	mov    0x8(%eax),%eax
  80348a:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80348f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803492:	e9 f8 04 00 00       	jmp    80398f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349a:	8b 40 0c             	mov    0xc(%eax),%eax
  80349d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034a0:	0f 86 d4 00 00 00    	jbe    80357a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8034a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8034ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8034ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b1:	8b 50 08             	mov    0x8(%eax),%edx
  8034b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b7:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8034ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c0:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8034c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034c7:	75 17                	jne    8034e0 <alloc_block_NF+0x11c>
  8034c9:	83 ec 04             	sub    $0x4,%esp
  8034cc:	68 60 4d 80 00       	push   $0x804d60
  8034d1:	68 e9 00 00 00       	push   $0xe9
  8034d6:	68 b7 4c 80 00       	push   $0x804cb7
  8034db:	e8 e2 d9 ff ff       	call   800ec2 <_panic>
  8034e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e3:	8b 00                	mov    (%eax),%eax
  8034e5:	85 c0                	test   %eax,%eax
  8034e7:	74 10                	je     8034f9 <alloc_block_NF+0x135>
  8034e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f1:	8b 52 04             	mov    0x4(%edx),%edx
  8034f4:	89 50 04             	mov    %edx,0x4(%eax)
  8034f7:	eb 0b                	jmp    803504 <alloc_block_NF+0x140>
  8034f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034fc:	8b 40 04             	mov    0x4(%eax),%eax
  8034ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803507:	8b 40 04             	mov    0x4(%eax),%eax
  80350a:	85 c0                	test   %eax,%eax
  80350c:	74 0f                	je     80351d <alloc_block_NF+0x159>
  80350e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803511:	8b 40 04             	mov    0x4(%eax),%eax
  803514:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803517:	8b 12                	mov    (%edx),%edx
  803519:	89 10                	mov    %edx,(%eax)
  80351b:	eb 0a                	jmp    803527 <alloc_block_NF+0x163>
  80351d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803520:	8b 00                	mov    (%eax),%eax
  803522:	a3 48 51 80 00       	mov    %eax,0x805148
  803527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803533:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353a:	a1 54 51 80 00       	mov    0x805154,%eax
  80353f:	48                   	dec    %eax
  803540:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803548:	8b 40 08             	mov    0x8(%eax),%eax
  80354b:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803553:	8b 50 08             	mov    0x8(%eax),%edx
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	01 c2                	add    %eax,%edx
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803564:	8b 40 0c             	mov    0xc(%eax),%eax
  803567:	2b 45 08             	sub    0x8(%ebp),%eax
  80356a:	89 c2                	mov    %eax,%edx
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803575:	e9 15 04 00 00       	jmp    80398f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80357a:	a1 40 51 80 00       	mov    0x805140,%eax
  80357f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803582:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803586:	74 07                	je     80358f <alloc_block_NF+0x1cb>
  803588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358b:	8b 00                	mov    (%eax),%eax
  80358d:	eb 05                	jmp    803594 <alloc_block_NF+0x1d0>
  80358f:	b8 00 00 00 00       	mov    $0x0,%eax
  803594:	a3 40 51 80 00       	mov    %eax,0x805140
  803599:	a1 40 51 80 00       	mov    0x805140,%eax
  80359e:	85 c0                	test   %eax,%eax
  8035a0:	0f 85 3e fe ff ff    	jne    8033e4 <alloc_block_NF+0x20>
  8035a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035aa:	0f 85 34 fe ff ff    	jne    8033e4 <alloc_block_NF+0x20>
  8035b0:	e9 d5 03 00 00       	jmp    80398a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8035b5:	a1 38 51 80 00       	mov    0x805138,%eax
  8035ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035bd:	e9 b1 01 00 00       	jmp    803773 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8035c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c5:	8b 50 08             	mov    0x8(%eax),%edx
  8035c8:	a1 28 50 80 00       	mov    0x805028,%eax
  8035cd:	39 c2                	cmp    %eax,%edx
  8035cf:	0f 82 96 01 00 00    	jb     80376b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8035d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8035db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035de:	0f 82 87 01 00 00    	jb     80376b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035ed:	0f 85 95 00 00 00    	jne    803688 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8035f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f7:	75 17                	jne    803610 <alloc_block_NF+0x24c>
  8035f9:	83 ec 04             	sub    $0x4,%esp
  8035fc:	68 60 4d 80 00       	push   $0x804d60
  803601:	68 fc 00 00 00       	push   $0xfc
  803606:	68 b7 4c 80 00       	push   $0x804cb7
  80360b:	e8 b2 d8 ff ff       	call   800ec2 <_panic>
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	8b 00                	mov    (%eax),%eax
  803615:	85 c0                	test   %eax,%eax
  803617:	74 10                	je     803629 <alloc_block_NF+0x265>
  803619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361c:	8b 00                	mov    (%eax),%eax
  80361e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803621:	8b 52 04             	mov    0x4(%edx),%edx
  803624:	89 50 04             	mov    %edx,0x4(%eax)
  803627:	eb 0b                	jmp    803634 <alloc_block_NF+0x270>
  803629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362c:	8b 40 04             	mov    0x4(%eax),%eax
  80362f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803637:	8b 40 04             	mov    0x4(%eax),%eax
  80363a:	85 c0                	test   %eax,%eax
  80363c:	74 0f                	je     80364d <alloc_block_NF+0x289>
  80363e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803641:	8b 40 04             	mov    0x4(%eax),%eax
  803644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803647:	8b 12                	mov    (%edx),%edx
  803649:	89 10                	mov    %edx,(%eax)
  80364b:	eb 0a                	jmp    803657 <alloc_block_NF+0x293>
  80364d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803650:	8b 00                	mov    (%eax),%eax
  803652:	a3 38 51 80 00       	mov    %eax,0x805138
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803663:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80366a:	a1 44 51 80 00       	mov    0x805144,%eax
  80366f:	48                   	dec    %eax
  803670:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803678:	8b 40 08             	mov    0x8(%eax),%eax
  80367b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803683:	e9 07 03 00 00       	jmp    80398f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368b:	8b 40 0c             	mov    0xc(%eax),%eax
  80368e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803691:	0f 86 d4 00 00 00    	jbe    80376b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803697:	a1 48 51 80 00       	mov    0x805148,%eax
  80369c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80369f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a2:	8b 50 08             	mov    0x8(%eax),%edx
  8036a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8036ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8036b1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8036b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036b8:	75 17                	jne    8036d1 <alloc_block_NF+0x30d>
  8036ba:	83 ec 04             	sub    $0x4,%esp
  8036bd:	68 60 4d 80 00       	push   $0x804d60
  8036c2:	68 04 01 00 00       	push   $0x104
  8036c7:	68 b7 4c 80 00       	push   $0x804cb7
  8036cc:	e8 f1 d7 ff ff       	call   800ec2 <_panic>
  8036d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d4:	8b 00                	mov    (%eax),%eax
  8036d6:	85 c0                	test   %eax,%eax
  8036d8:	74 10                	je     8036ea <alloc_block_NF+0x326>
  8036da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036dd:	8b 00                	mov    (%eax),%eax
  8036df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036e2:	8b 52 04             	mov    0x4(%edx),%edx
  8036e5:	89 50 04             	mov    %edx,0x4(%eax)
  8036e8:	eb 0b                	jmp    8036f5 <alloc_block_NF+0x331>
  8036ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ed:	8b 40 04             	mov    0x4(%eax),%eax
  8036f0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f8:	8b 40 04             	mov    0x4(%eax),%eax
  8036fb:	85 c0                	test   %eax,%eax
  8036fd:	74 0f                	je     80370e <alloc_block_NF+0x34a>
  8036ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803702:	8b 40 04             	mov    0x4(%eax),%eax
  803705:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803708:	8b 12                	mov    (%edx),%edx
  80370a:	89 10                	mov    %edx,(%eax)
  80370c:	eb 0a                	jmp    803718 <alloc_block_NF+0x354>
  80370e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803711:	8b 00                	mov    (%eax),%eax
  803713:	a3 48 51 80 00       	mov    %eax,0x805148
  803718:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803721:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803724:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80372b:	a1 54 51 80 00       	mov    0x805154,%eax
  803730:	48                   	dec    %eax
  803731:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803736:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803739:	8b 40 08             	mov    0x8(%eax),%eax
  80373c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803744:	8b 50 08             	mov    0x8(%eax),%edx
  803747:	8b 45 08             	mov    0x8(%ebp),%eax
  80374a:	01 c2                	add    %eax,%edx
  80374c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803755:	8b 40 0c             	mov    0xc(%eax),%eax
  803758:	2b 45 08             	sub    0x8(%ebp),%eax
  80375b:	89 c2                	mov    %eax,%edx
  80375d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803760:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803763:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803766:	e9 24 02 00 00       	jmp    80398f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80376b:	a1 40 51 80 00       	mov    0x805140,%eax
  803770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803773:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803777:	74 07                	je     803780 <alloc_block_NF+0x3bc>
  803779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377c:	8b 00                	mov    (%eax),%eax
  80377e:	eb 05                	jmp    803785 <alloc_block_NF+0x3c1>
  803780:	b8 00 00 00 00       	mov    $0x0,%eax
  803785:	a3 40 51 80 00       	mov    %eax,0x805140
  80378a:	a1 40 51 80 00       	mov    0x805140,%eax
  80378f:	85 c0                	test   %eax,%eax
  803791:	0f 85 2b fe ff ff    	jne    8035c2 <alloc_block_NF+0x1fe>
  803797:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80379b:	0f 85 21 fe ff ff    	jne    8035c2 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8037a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8037a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037a9:	e9 ae 01 00 00       	jmp    80395c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8037ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b1:	8b 50 08             	mov    0x8(%eax),%edx
  8037b4:	a1 28 50 80 00       	mov    0x805028,%eax
  8037b9:	39 c2                	cmp    %eax,%edx
  8037bb:	0f 83 93 01 00 00    	jae    803954 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8037c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037ca:	0f 82 84 01 00 00    	jb     803954 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8037d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037d9:	0f 85 95 00 00 00    	jne    803874 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8037df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e3:	75 17                	jne    8037fc <alloc_block_NF+0x438>
  8037e5:	83 ec 04             	sub    $0x4,%esp
  8037e8:	68 60 4d 80 00       	push   $0x804d60
  8037ed:	68 14 01 00 00       	push   $0x114
  8037f2:	68 b7 4c 80 00       	push   $0x804cb7
  8037f7:	e8 c6 d6 ff ff       	call   800ec2 <_panic>
  8037fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ff:	8b 00                	mov    (%eax),%eax
  803801:	85 c0                	test   %eax,%eax
  803803:	74 10                	je     803815 <alloc_block_NF+0x451>
  803805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803808:	8b 00                	mov    (%eax),%eax
  80380a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80380d:	8b 52 04             	mov    0x4(%edx),%edx
  803810:	89 50 04             	mov    %edx,0x4(%eax)
  803813:	eb 0b                	jmp    803820 <alloc_block_NF+0x45c>
  803815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803818:	8b 40 04             	mov    0x4(%eax),%eax
  80381b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803823:	8b 40 04             	mov    0x4(%eax),%eax
  803826:	85 c0                	test   %eax,%eax
  803828:	74 0f                	je     803839 <alloc_block_NF+0x475>
  80382a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382d:	8b 40 04             	mov    0x4(%eax),%eax
  803830:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803833:	8b 12                	mov    (%edx),%edx
  803835:	89 10                	mov    %edx,(%eax)
  803837:	eb 0a                	jmp    803843 <alloc_block_NF+0x47f>
  803839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383c:	8b 00                	mov    (%eax),%eax
  80383e:	a3 38 51 80 00       	mov    %eax,0x805138
  803843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803846:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80384c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803856:	a1 44 51 80 00       	mov    0x805144,%eax
  80385b:	48                   	dec    %eax
  80385c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803864:	8b 40 08             	mov    0x8(%eax),%eax
  803867:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80386c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386f:	e9 1b 01 00 00       	jmp    80398f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803877:	8b 40 0c             	mov    0xc(%eax),%eax
  80387a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80387d:	0f 86 d1 00 00 00    	jbe    803954 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803883:	a1 48 51 80 00       	mov    0x805148,%eax
  803888:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80388b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388e:	8b 50 08             	mov    0x8(%eax),%edx
  803891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803894:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803897:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80389a:	8b 55 08             	mov    0x8(%ebp),%edx
  80389d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8038a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038a4:	75 17                	jne    8038bd <alloc_block_NF+0x4f9>
  8038a6:	83 ec 04             	sub    $0x4,%esp
  8038a9:	68 60 4d 80 00       	push   $0x804d60
  8038ae:	68 1c 01 00 00       	push   $0x11c
  8038b3:	68 b7 4c 80 00       	push   $0x804cb7
  8038b8:	e8 05 d6 ff ff       	call   800ec2 <_panic>
  8038bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c0:	8b 00                	mov    (%eax),%eax
  8038c2:	85 c0                	test   %eax,%eax
  8038c4:	74 10                	je     8038d6 <alloc_block_NF+0x512>
  8038c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c9:	8b 00                	mov    (%eax),%eax
  8038cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038ce:	8b 52 04             	mov    0x4(%edx),%edx
  8038d1:	89 50 04             	mov    %edx,0x4(%eax)
  8038d4:	eb 0b                	jmp    8038e1 <alloc_block_NF+0x51d>
  8038d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038d9:	8b 40 04             	mov    0x4(%eax),%eax
  8038dc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038e4:	8b 40 04             	mov    0x4(%eax),%eax
  8038e7:	85 c0                	test   %eax,%eax
  8038e9:	74 0f                	je     8038fa <alloc_block_NF+0x536>
  8038eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ee:	8b 40 04             	mov    0x4(%eax),%eax
  8038f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038f4:	8b 12                	mov    (%edx),%edx
  8038f6:	89 10                	mov    %edx,(%eax)
  8038f8:	eb 0a                	jmp    803904 <alloc_block_NF+0x540>
  8038fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038fd:	8b 00                	mov    (%eax),%eax
  8038ff:	a3 48 51 80 00       	mov    %eax,0x805148
  803904:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803907:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80390d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803910:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803917:	a1 54 51 80 00       	mov    0x805154,%eax
  80391c:	48                   	dec    %eax
  80391d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803922:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803925:	8b 40 08             	mov    0x8(%eax),%eax
  803928:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80392d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803930:	8b 50 08             	mov    0x8(%eax),%edx
  803933:	8b 45 08             	mov    0x8(%ebp),%eax
  803936:	01 c2                	add    %eax,%edx
  803938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80393e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803941:	8b 40 0c             	mov    0xc(%eax),%eax
  803944:	2b 45 08             	sub    0x8(%ebp),%eax
  803947:	89 c2                	mov    %eax,%edx
  803949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80394f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803952:	eb 3b                	jmp    80398f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803954:	a1 40 51 80 00       	mov    0x805140,%eax
  803959:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80395c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803960:	74 07                	je     803969 <alloc_block_NF+0x5a5>
  803962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803965:	8b 00                	mov    (%eax),%eax
  803967:	eb 05                	jmp    80396e <alloc_block_NF+0x5aa>
  803969:	b8 00 00 00 00       	mov    $0x0,%eax
  80396e:	a3 40 51 80 00       	mov    %eax,0x805140
  803973:	a1 40 51 80 00       	mov    0x805140,%eax
  803978:	85 c0                	test   %eax,%eax
  80397a:	0f 85 2e fe ff ff    	jne    8037ae <alloc_block_NF+0x3ea>
  803980:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803984:	0f 85 24 fe ff ff    	jne    8037ae <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80398a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80398f:	c9                   	leave  
  803990:	c3                   	ret    

00803991 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803991:	55                   	push   %ebp
  803992:	89 e5                	mov    %esp,%ebp
  803994:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803997:	a1 38 51 80 00       	mov    0x805138,%eax
  80399c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80399f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8039a4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8039a7:	a1 38 51 80 00       	mov    0x805138,%eax
  8039ac:	85 c0                	test   %eax,%eax
  8039ae:	74 14                	je     8039c4 <insert_sorted_with_merge_freeList+0x33>
  8039b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b3:	8b 50 08             	mov    0x8(%eax),%edx
  8039b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b9:	8b 40 08             	mov    0x8(%eax),%eax
  8039bc:	39 c2                	cmp    %eax,%edx
  8039be:	0f 87 9b 01 00 00    	ja     803b5f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8039c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039c8:	75 17                	jne    8039e1 <insert_sorted_with_merge_freeList+0x50>
  8039ca:	83 ec 04             	sub    $0x4,%esp
  8039cd:	68 94 4c 80 00       	push   $0x804c94
  8039d2:	68 38 01 00 00       	push   $0x138
  8039d7:	68 b7 4c 80 00       	push   $0x804cb7
  8039dc:	e8 e1 d4 ff ff       	call   800ec2 <_panic>
  8039e1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8039e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ea:	89 10                	mov    %edx,(%eax)
  8039ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ef:	8b 00                	mov    (%eax),%eax
  8039f1:	85 c0                	test   %eax,%eax
  8039f3:	74 0d                	je     803a02 <insert_sorted_with_merge_freeList+0x71>
  8039f5:	a1 38 51 80 00       	mov    0x805138,%eax
  8039fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8039fd:	89 50 04             	mov    %edx,0x4(%eax)
  803a00:	eb 08                	jmp    803a0a <insert_sorted_with_merge_freeList+0x79>
  803a02:	8b 45 08             	mov    0x8(%ebp),%eax
  803a05:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0d:	a3 38 51 80 00       	mov    %eax,0x805138
  803a12:	8b 45 08             	mov    0x8(%ebp),%eax
  803a15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a1c:	a1 44 51 80 00       	mov    0x805144,%eax
  803a21:	40                   	inc    %eax
  803a22:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803a27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a2b:	0f 84 a8 06 00 00    	je     8040d9 <insert_sorted_with_merge_freeList+0x748>
  803a31:	8b 45 08             	mov    0x8(%ebp),%eax
  803a34:	8b 50 08             	mov    0x8(%eax),%edx
  803a37:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3a:	8b 40 0c             	mov    0xc(%eax),%eax
  803a3d:	01 c2                	add    %eax,%edx
  803a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a42:	8b 40 08             	mov    0x8(%eax),%eax
  803a45:	39 c2                	cmp    %eax,%edx
  803a47:	0f 85 8c 06 00 00    	jne    8040d9 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a50:	8b 50 0c             	mov    0xc(%eax),%edx
  803a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a56:	8b 40 0c             	mov    0xc(%eax),%eax
  803a59:	01 c2                	add    %eax,%edx
  803a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803a61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a65:	75 17                	jne    803a7e <insert_sorted_with_merge_freeList+0xed>
  803a67:	83 ec 04             	sub    $0x4,%esp
  803a6a:	68 60 4d 80 00       	push   $0x804d60
  803a6f:	68 3c 01 00 00       	push   $0x13c
  803a74:	68 b7 4c 80 00       	push   $0x804cb7
  803a79:	e8 44 d4 ff ff       	call   800ec2 <_panic>
  803a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a81:	8b 00                	mov    (%eax),%eax
  803a83:	85 c0                	test   %eax,%eax
  803a85:	74 10                	je     803a97 <insert_sorted_with_merge_freeList+0x106>
  803a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a8a:	8b 00                	mov    (%eax),%eax
  803a8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a8f:	8b 52 04             	mov    0x4(%edx),%edx
  803a92:	89 50 04             	mov    %edx,0x4(%eax)
  803a95:	eb 0b                	jmp    803aa2 <insert_sorted_with_merge_freeList+0x111>
  803a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a9a:	8b 40 04             	mov    0x4(%eax),%eax
  803a9d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa5:	8b 40 04             	mov    0x4(%eax),%eax
  803aa8:	85 c0                	test   %eax,%eax
  803aaa:	74 0f                	je     803abb <insert_sorted_with_merge_freeList+0x12a>
  803aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aaf:	8b 40 04             	mov    0x4(%eax),%eax
  803ab2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ab5:	8b 12                	mov    (%edx),%edx
  803ab7:	89 10                	mov    %edx,(%eax)
  803ab9:	eb 0a                	jmp    803ac5 <insert_sorted_with_merge_freeList+0x134>
  803abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803abe:	8b 00                	mov    (%eax),%eax
  803ac0:	a3 38 51 80 00       	mov    %eax,0x805138
  803ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ad8:	a1 44 51 80 00       	mov    0x805144,%eax
  803add:	48                   	dec    %eax
  803ade:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803af7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803afb:	75 17                	jne    803b14 <insert_sorted_with_merge_freeList+0x183>
  803afd:	83 ec 04             	sub    $0x4,%esp
  803b00:	68 94 4c 80 00       	push   $0x804c94
  803b05:	68 3f 01 00 00       	push   $0x13f
  803b0a:	68 b7 4c 80 00       	push   $0x804cb7
  803b0f:	e8 ae d3 ff ff       	call   800ec2 <_panic>
  803b14:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b1d:	89 10                	mov    %edx,(%eax)
  803b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b22:	8b 00                	mov    (%eax),%eax
  803b24:	85 c0                	test   %eax,%eax
  803b26:	74 0d                	je     803b35 <insert_sorted_with_merge_freeList+0x1a4>
  803b28:	a1 48 51 80 00       	mov    0x805148,%eax
  803b2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b30:	89 50 04             	mov    %edx,0x4(%eax)
  803b33:	eb 08                	jmp    803b3d <insert_sorted_with_merge_freeList+0x1ac>
  803b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b38:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b40:	a3 48 51 80 00       	mov    %eax,0x805148
  803b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b4f:	a1 54 51 80 00       	mov    0x805154,%eax
  803b54:	40                   	inc    %eax
  803b55:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b5a:	e9 7a 05 00 00       	jmp    8040d9 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b62:	8b 50 08             	mov    0x8(%eax),%edx
  803b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b68:	8b 40 08             	mov    0x8(%eax),%eax
  803b6b:	39 c2                	cmp    %eax,%edx
  803b6d:	0f 82 14 01 00 00    	jb     803c87 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b76:	8b 50 08             	mov    0x8(%eax),%edx
  803b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b7c:	8b 40 0c             	mov    0xc(%eax),%eax
  803b7f:	01 c2                	add    %eax,%edx
  803b81:	8b 45 08             	mov    0x8(%ebp),%eax
  803b84:	8b 40 08             	mov    0x8(%eax),%eax
  803b87:	39 c2                	cmp    %eax,%edx
  803b89:	0f 85 90 00 00 00    	jne    803c1f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b92:	8b 50 0c             	mov    0xc(%eax),%edx
  803b95:	8b 45 08             	mov    0x8(%ebp),%eax
  803b98:	8b 40 0c             	mov    0xc(%eax),%eax
  803b9b:	01 c2                	add    %eax,%edx
  803b9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ba0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803bad:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803bb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bbb:	75 17                	jne    803bd4 <insert_sorted_with_merge_freeList+0x243>
  803bbd:	83 ec 04             	sub    $0x4,%esp
  803bc0:	68 94 4c 80 00       	push   $0x804c94
  803bc5:	68 49 01 00 00       	push   $0x149
  803bca:	68 b7 4c 80 00       	push   $0x804cb7
  803bcf:	e8 ee d2 ff ff       	call   800ec2 <_panic>
  803bd4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803bda:	8b 45 08             	mov    0x8(%ebp),%eax
  803bdd:	89 10                	mov    %edx,(%eax)
  803bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  803be2:	8b 00                	mov    (%eax),%eax
  803be4:	85 c0                	test   %eax,%eax
  803be6:	74 0d                	je     803bf5 <insert_sorted_with_merge_freeList+0x264>
  803be8:	a1 48 51 80 00       	mov    0x805148,%eax
  803bed:	8b 55 08             	mov    0x8(%ebp),%edx
  803bf0:	89 50 04             	mov    %edx,0x4(%eax)
  803bf3:	eb 08                	jmp    803bfd <insert_sorted_with_merge_freeList+0x26c>
  803bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  803c00:	a3 48 51 80 00       	mov    %eax,0x805148
  803c05:	8b 45 08             	mov    0x8(%ebp),%eax
  803c08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c0f:	a1 54 51 80 00       	mov    0x805154,%eax
  803c14:	40                   	inc    %eax
  803c15:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803c1a:	e9 bb 04 00 00       	jmp    8040da <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803c1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c23:	75 17                	jne    803c3c <insert_sorted_with_merge_freeList+0x2ab>
  803c25:	83 ec 04             	sub    $0x4,%esp
  803c28:	68 08 4d 80 00       	push   $0x804d08
  803c2d:	68 4c 01 00 00       	push   $0x14c
  803c32:	68 b7 4c 80 00       	push   $0x804cb7
  803c37:	e8 86 d2 ff ff       	call   800ec2 <_panic>
  803c3c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803c42:	8b 45 08             	mov    0x8(%ebp),%eax
  803c45:	89 50 04             	mov    %edx,0x4(%eax)
  803c48:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4b:	8b 40 04             	mov    0x4(%eax),%eax
  803c4e:	85 c0                	test   %eax,%eax
  803c50:	74 0c                	je     803c5e <insert_sorted_with_merge_freeList+0x2cd>
  803c52:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803c57:	8b 55 08             	mov    0x8(%ebp),%edx
  803c5a:	89 10                	mov    %edx,(%eax)
  803c5c:	eb 08                	jmp    803c66 <insert_sorted_with_merge_freeList+0x2d5>
  803c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c61:	a3 38 51 80 00       	mov    %eax,0x805138
  803c66:	8b 45 08             	mov    0x8(%ebp),%eax
  803c69:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c77:	a1 44 51 80 00       	mov    0x805144,%eax
  803c7c:	40                   	inc    %eax
  803c7d:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803c82:	e9 53 04 00 00       	jmp    8040da <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803c87:	a1 38 51 80 00       	mov    0x805138,%eax
  803c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c8f:	e9 15 04 00 00       	jmp    8040a9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c97:	8b 00                	mov    (%eax),%eax
  803c99:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9f:	8b 50 08             	mov    0x8(%eax),%edx
  803ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca5:	8b 40 08             	mov    0x8(%eax),%eax
  803ca8:	39 c2                	cmp    %eax,%edx
  803caa:	0f 86 f1 03 00 00    	jbe    8040a1 <insert_sorted_with_merge_freeList+0x710>
  803cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb3:	8b 50 08             	mov    0x8(%eax),%edx
  803cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cb9:	8b 40 08             	mov    0x8(%eax),%eax
  803cbc:	39 c2                	cmp    %eax,%edx
  803cbe:	0f 83 dd 03 00 00    	jae    8040a1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc7:	8b 50 08             	mov    0x8(%eax),%edx
  803cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccd:	8b 40 0c             	mov    0xc(%eax),%eax
  803cd0:	01 c2                	add    %eax,%edx
  803cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd5:	8b 40 08             	mov    0x8(%eax),%eax
  803cd8:	39 c2                	cmp    %eax,%edx
  803cda:	0f 85 b9 01 00 00    	jne    803e99 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce3:	8b 50 08             	mov    0x8(%eax),%edx
  803ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce9:	8b 40 0c             	mov    0xc(%eax),%eax
  803cec:	01 c2                	add    %eax,%edx
  803cee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf1:	8b 40 08             	mov    0x8(%eax),%eax
  803cf4:	39 c2                	cmp    %eax,%edx
  803cf6:	0f 85 0d 01 00 00    	jne    803e09 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cff:	8b 50 0c             	mov    0xc(%eax),%edx
  803d02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d05:	8b 40 0c             	mov    0xc(%eax),%eax
  803d08:	01 c2                	add    %eax,%edx
  803d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803d10:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d14:	75 17                	jne    803d2d <insert_sorted_with_merge_freeList+0x39c>
  803d16:	83 ec 04             	sub    $0x4,%esp
  803d19:	68 60 4d 80 00       	push   $0x804d60
  803d1e:	68 5c 01 00 00       	push   $0x15c
  803d23:	68 b7 4c 80 00       	push   $0x804cb7
  803d28:	e8 95 d1 ff ff       	call   800ec2 <_panic>
  803d2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d30:	8b 00                	mov    (%eax),%eax
  803d32:	85 c0                	test   %eax,%eax
  803d34:	74 10                	je     803d46 <insert_sorted_with_merge_freeList+0x3b5>
  803d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d39:	8b 00                	mov    (%eax),%eax
  803d3b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d3e:	8b 52 04             	mov    0x4(%edx),%edx
  803d41:	89 50 04             	mov    %edx,0x4(%eax)
  803d44:	eb 0b                	jmp    803d51 <insert_sorted_with_merge_freeList+0x3c0>
  803d46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d49:	8b 40 04             	mov    0x4(%eax),%eax
  803d4c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803d51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d54:	8b 40 04             	mov    0x4(%eax),%eax
  803d57:	85 c0                	test   %eax,%eax
  803d59:	74 0f                	je     803d6a <insert_sorted_with_merge_freeList+0x3d9>
  803d5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d5e:	8b 40 04             	mov    0x4(%eax),%eax
  803d61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d64:	8b 12                	mov    (%edx),%edx
  803d66:	89 10                	mov    %edx,(%eax)
  803d68:	eb 0a                	jmp    803d74 <insert_sorted_with_merge_freeList+0x3e3>
  803d6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d6d:	8b 00                	mov    (%eax),%eax
  803d6f:	a3 38 51 80 00       	mov    %eax,0x805138
  803d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d87:	a1 44 51 80 00       	mov    0x805144,%eax
  803d8c:	48                   	dec    %eax
  803d8d:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803d92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d95:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803d9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d9f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803da6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803daa:	75 17                	jne    803dc3 <insert_sorted_with_merge_freeList+0x432>
  803dac:	83 ec 04             	sub    $0x4,%esp
  803daf:	68 94 4c 80 00       	push   $0x804c94
  803db4:	68 5f 01 00 00       	push   $0x15f
  803db9:	68 b7 4c 80 00       	push   $0x804cb7
  803dbe:	e8 ff d0 ff ff       	call   800ec2 <_panic>
  803dc3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803dc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dcc:	89 10                	mov    %edx,(%eax)
  803dce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dd1:	8b 00                	mov    (%eax),%eax
  803dd3:	85 c0                	test   %eax,%eax
  803dd5:	74 0d                	je     803de4 <insert_sorted_with_merge_freeList+0x453>
  803dd7:	a1 48 51 80 00       	mov    0x805148,%eax
  803ddc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ddf:	89 50 04             	mov    %edx,0x4(%eax)
  803de2:	eb 08                	jmp    803dec <insert_sorted_with_merge_freeList+0x45b>
  803de4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803de7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803dec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803def:	a3 48 51 80 00       	mov    %eax,0x805148
  803df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803df7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dfe:	a1 54 51 80 00       	mov    0x805154,%eax
  803e03:	40                   	inc    %eax
  803e04:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0c:	8b 50 0c             	mov    0xc(%eax),%edx
  803e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e12:	8b 40 0c             	mov    0xc(%eax),%eax
  803e15:	01 c2                	add    %eax,%edx
  803e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e20:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803e27:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803e31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e35:	75 17                	jne    803e4e <insert_sorted_with_merge_freeList+0x4bd>
  803e37:	83 ec 04             	sub    $0x4,%esp
  803e3a:	68 94 4c 80 00       	push   $0x804c94
  803e3f:	68 64 01 00 00       	push   $0x164
  803e44:	68 b7 4c 80 00       	push   $0x804cb7
  803e49:	e8 74 d0 ff ff       	call   800ec2 <_panic>
  803e4e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803e54:	8b 45 08             	mov    0x8(%ebp),%eax
  803e57:	89 10                	mov    %edx,(%eax)
  803e59:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5c:	8b 00                	mov    (%eax),%eax
  803e5e:	85 c0                	test   %eax,%eax
  803e60:	74 0d                	je     803e6f <insert_sorted_with_merge_freeList+0x4de>
  803e62:	a1 48 51 80 00       	mov    0x805148,%eax
  803e67:	8b 55 08             	mov    0x8(%ebp),%edx
  803e6a:	89 50 04             	mov    %edx,0x4(%eax)
  803e6d:	eb 08                	jmp    803e77 <insert_sorted_with_merge_freeList+0x4e6>
  803e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e72:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803e77:	8b 45 08             	mov    0x8(%ebp),%eax
  803e7a:	a3 48 51 80 00       	mov    %eax,0x805148
  803e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e89:	a1 54 51 80 00       	mov    0x805154,%eax
  803e8e:	40                   	inc    %eax
  803e8f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803e94:	e9 41 02 00 00       	jmp    8040da <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803e99:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9c:	8b 50 08             	mov    0x8(%eax),%edx
  803e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea2:	8b 40 0c             	mov    0xc(%eax),%eax
  803ea5:	01 c2                	add    %eax,%edx
  803ea7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eaa:	8b 40 08             	mov    0x8(%eax),%eax
  803ead:	39 c2                	cmp    %eax,%edx
  803eaf:	0f 85 7c 01 00 00    	jne    804031 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803eb5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803eb9:	74 06                	je     803ec1 <insert_sorted_with_merge_freeList+0x530>
  803ebb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ebf:	75 17                	jne    803ed8 <insert_sorted_with_merge_freeList+0x547>
  803ec1:	83 ec 04             	sub    $0x4,%esp
  803ec4:	68 d0 4c 80 00       	push   $0x804cd0
  803ec9:	68 69 01 00 00       	push   $0x169
  803ece:	68 b7 4c 80 00       	push   $0x804cb7
  803ed3:	e8 ea cf ff ff       	call   800ec2 <_panic>
  803ed8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803edb:	8b 50 04             	mov    0x4(%eax),%edx
  803ede:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee1:	89 50 04             	mov    %edx,0x4(%eax)
  803ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803eea:	89 10                	mov    %edx,(%eax)
  803eec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eef:	8b 40 04             	mov    0x4(%eax),%eax
  803ef2:	85 c0                	test   %eax,%eax
  803ef4:	74 0d                	je     803f03 <insert_sorted_with_merge_freeList+0x572>
  803ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ef9:	8b 40 04             	mov    0x4(%eax),%eax
  803efc:	8b 55 08             	mov    0x8(%ebp),%edx
  803eff:	89 10                	mov    %edx,(%eax)
  803f01:	eb 08                	jmp    803f0b <insert_sorted_with_merge_freeList+0x57a>
  803f03:	8b 45 08             	mov    0x8(%ebp),%eax
  803f06:	a3 38 51 80 00       	mov    %eax,0x805138
  803f0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  803f11:	89 50 04             	mov    %edx,0x4(%eax)
  803f14:	a1 44 51 80 00       	mov    0x805144,%eax
  803f19:	40                   	inc    %eax
  803f1a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f22:	8b 50 0c             	mov    0xc(%eax),%edx
  803f25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f28:	8b 40 0c             	mov    0xc(%eax),%eax
  803f2b:	01 c2                	add    %eax,%edx
  803f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f30:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803f33:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803f37:	75 17                	jne    803f50 <insert_sorted_with_merge_freeList+0x5bf>
  803f39:	83 ec 04             	sub    $0x4,%esp
  803f3c:	68 60 4d 80 00       	push   $0x804d60
  803f41:	68 6b 01 00 00       	push   $0x16b
  803f46:	68 b7 4c 80 00       	push   $0x804cb7
  803f4b:	e8 72 cf ff ff       	call   800ec2 <_panic>
  803f50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f53:	8b 00                	mov    (%eax),%eax
  803f55:	85 c0                	test   %eax,%eax
  803f57:	74 10                	je     803f69 <insert_sorted_with_merge_freeList+0x5d8>
  803f59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f5c:	8b 00                	mov    (%eax),%eax
  803f5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f61:	8b 52 04             	mov    0x4(%edx),%edx
  803f64:	89 50 04             	mov    %edx,0x4(%eax)
  803f67:	eb 0b                	jmp    803f74 <insert_sorted_with_merge_freeList+0x5e3>
  803f69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f6c:	8b 40 04             	mov    0x4(%eax),%eax
  803f6f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803f74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f77:	8b 40 04             	mov    0x4(%eax),%eax
  803f7a:	85 c0                	test   %eax,%eax
  803f7c:	74 0f                	je     803f8d <insert_sorted_with_merge_freeList+0x5fc>
  803f7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f81:	8b 40 04             	mov    0x4(%eax),%eax
  803f84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f87:	8b 12                	mov    (%edx),%edx
  803f89:	89 10                	mov    %edx,(%eax)
  803f8b:	eb 0a                	jmp    803f97 <insert_sorted_with_merge_freeList+0x606>
  803f8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f90:	8b 00                	mov    (%eax),%eax
  803f92:	a3 38 51 80 00       	mov    %eax,0x805138
  803f97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fa3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803faa:	a1 44 51 80 00       	mov    0x805144,%eax
  803faf:	48                   	dec    %eax
  803fb0:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fb8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fc2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803fc9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803fcd:	75 17                	jne    803fe6 <insert_sorted_with_merge_freeList+0x655>
  803fcf:	83 ec 04             	sub    $0x4,%esp
  803fd2:	68 94 4c 80 00       	push   $0x804c94
  803fd7:	68 6e 01 00 00       	push   $0x16e
  803fdc:	68 b7 4c 80 00       	push   $0x804cb7
  803fe1:	e8 dc ce ff ff       	call   800ec2 <_panic>
  803fe6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803fec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fef:	89 10                	mov    %edx,(%eax)
  803ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ff4:	8b 00                	mov    (%eax),%eax
  803ff6:	85 c0                	test   %eax,%eax
  803ff8:	74 0d                	je     804007 <insert_sorted_with_merge_freeList+0x676>
  803ffa:	a1 48 51 80 00       	mov    0x805148,%eax
  803fff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804002:	89 50 04             	mov    %edx,0x4(%eax)
  804005:	eb 08                	jmp    80400f <insert_sorted_with_merge_freeList+0x67e>
  804007:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80400a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80400f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804012:	a3 48 51 80 00       	mov    %eax,0x805148
  804017:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80401a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804021:	a1 54 51 80 00       	mov    0x805154,%eax
  804026:	40                   	inc    %eax
  804027:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80402c:	e9 a9 00 00 00       	jmp    8040da <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  804031:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804035:	74 06                	je     80403d <insert_sorted_with_merge_freeList+0x6ac>
  804037:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80403b:	75 17                	jne    804054 <insert_sorted_with_merge_freeList+0x6c3>
  80403d:	83 ec 04             	sub    $0x4,%esp
  804040:	68 2c 4d 80 00       	push   $0x804d2c
  804045:	68 73 01 00 00       	push   $0x173
  80404a:	68 b7 4c 80 00       	push   $0x804cb7
  80404f:	e8 6e ce ff ff       	call   800ec2 <_panic>
  804054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804057:	8b 10                	mov    (%eax),%edx
  804059:	8b 45 08             	mov    0x8(%ebp),%eax
  80405c:	89 10                	mov    %edx,(%eax)
  80405e:	8b 45 08             	mov    0x8(%ebp),%eax
  804061:	8b 00                	mov    (%eax),%eax
  804063:	85 c0                	test   %eax,%eax
  804065:	74 0b                	je     804072 <insert_sorted_with_merge_freeList+0x6e1>
  804067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80406a:	8b 00                	mov    (%eax),%eax
  80406c:	8b 55 08             	mov    0x8(%ebp),%edx
  80406f:	89 50 04             	mov    %edx,0x4(%eax)
  804072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804075:	8b 55 08             	mov    0x8(%ebp),%edx
  804078:	89 10                	mov    %edx,(%eax)
  80407a:	8b 45 08             	mov    0x8(%ebp),%eax
  80407d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804080:	89 50 04             	mov    %edx,0x4(%eax)
  804083:	8b 45 08             	mov    0x8(%ebp),%eax
  804086:	8b 00                	mov    (%eax),%eax
  804088:	85 c0                	test   %eax,%eax
  80408a:	75 08                	jne    804094 <insert_sorted_with_merge_freeList+0x703>
  80408c:	8b 45 08             	mov    0x8(%ebp),%eax
  80408f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  804094:	a1 44 51 80 00       	mov    0x805144,%eax
  804099:	40                   	inc    %eax
  80409a:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80409f:	eb 39                	jmp    8040da <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8040a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8040a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040ad:	74 07                	je     8040b6 <insert_sorted_with_merge_freeList+0x725>
  8040af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b2:	8b 00                	mov    (%eax),%eax
  8040b4:	eb 05                	jmp    8040bb <insert_sorted_with_merge_freeList+0x72a>
  8040b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8040bb:	a3 40 51 80 00       	mov    %eax,0x805140
  8040c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8040c5:	85 c0                	test   %eax,%eax
  8040c7:	0f 85 c7 fb ff ff    	jne    803c94 <insert_sorted_with_merge_freeList+0x303>
  8040cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040d1:	0f 85 bd fb ff ff    	jne    803c94 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8040d7:	eb 01                	jmp    8040da <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8040d9:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8040da:	90                   	nop
  8040db:	c9                   	leave  
  8040dc:	c3                   	ret    
  8040dd:	66 90                	xchg   %ax,%ax
  8040df:	90                   	nop

008040e0 <__udivdi3>:
  8040e0:	55                   	push   %ebp
  8040e1:	57                   	push   %edi
  8040e2:	56                   	push   %esi
  8040e3:	53                   	push   %ebx
  8040e4:	83 ec 1c             	sub    $0x1c,%esp
  8040e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040f7:	89 ca                	mov    %ecx,%edx
  8040f9:	89 f8                	mov    %edi,%eax
  8040fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040ff:	85 f6                	test   %esi,%esi
  804101:	75 2d                	jne    804130 <__udivdi3+0x50>
  804103:	39 cf                	cmp    %ecx,%edi
  804105:	77 65                	ja     80416c <__udivdi3+0x8c>
  804107:	89 fd                	mov    %edi,%ebp
  804109:	85 ff                	test   %edi,%edi
  80410b:	75 0b                	jne    804118 <__udivdi3+0x38>
  80410d:	b8 01 00 00 00       	mov    $0x1,%eax
  804112:	31 d2                	xor    %edx,%edx
  804114:	f7 f7                	div    %edi
  804116:	89 c5                	mov    %eax,%ebp
  804118:	31 d2                	xor    %edx,%edx
  80411a:	89 c8                	mov    %ecx,%eax
  80411c:	f7 f5                	div    %ebp
  80411e:	89 c1                	mov    %eax,%ecx
  804120:	89 d8                	mov    %ebx,%eax
  804122:	f7 f5                	div    %ebp
  804124:	89 cf                	mov    %ecx,%edi
  804126:	89 fa                	mov    %edi,%edx
  804128:	83 c4 1c             	add    $0x1c,%esp
  80412b:	5b                   	pop    %ebx
  80412c:	5e                   	pop    %esi
  80412d:	5f                   	pop    %edi
  80412e:	5d                   	pop    %ebp
  80412f:	c3                   	ret    
  804130:	39 ce                	cmp    %ecx,%esi
  804132:	77 28                	ja     80415c <__udivdi3+0x7c>
  804134:	0f bd fe             	bsr    %esi,%edi
  804137:	83 f7 1f             	xor    $0x1f,%edi
  80413a:	75 40                	jne    80417c <__udivdi3+0x9c>
  80413c:	39 ce                	cmp    %ecx,%esi
  80413e:	72 0a                	jb     80414a <__udivdi3+0x6a>
  804140:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804144:	0f 87 9e 00 00 00    	ja     8041e8 <__udivdi3+0x108>
  80414a:	b8 01 00 00 00       	mov    $0x1,%eax
  80414f:	89 fa                	mov    %edi,%edx
  804151:	83 c4 1c             	add    $0x1c,%esp
  804154:	5b                   	pop    %ebx
  804155:	5e                   	pop    %esi
  804156:	5f                   	pop    %edi
  804157:	5d                   	pop    %ebp
  804158:	c3                   	ret    
  804159:	8d 76 00             	lea    0x0(%esi),%esi
  80415c:	31 ff                	xor    %edi,%edi
  80415e:	31 c0                	xor    %eax,%eax
  804160:	89 fa                	mov    %edi,%edx
  804162:	83 c4 1c             	add    $0x1c,%esp
  804165:	5b                   	pop    %ebx
  804166:	5e                   	pop    %esi
  804167:	5f                   	pop    %edi
  804168:	5d                   	pop    %ebp
  804169:	c3                   	ret    
  80416a:	66 90                	xchg   %ax,%ax
  80416c:	89 d8                	mov    %ebx,%eax
  80416e:	f7 f7                	div    %edi
  804170:	31 ff                	xor    %edi,%edi
  804172:	89 fa                	mov    %edi,%edx
  804174:	83 c4 1c             	add    $0x1c,%esp
  804177:	5b                   	pop    %ebx
  804178:	5e                   	pop    %esi
  804179:	5f                   	pop    %edi
  80417a:	5d                   	pop    %ebp
  80417b:	c3                   	ret    
  80417c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804181:	89 eb                	mov    %ebp,%ebx
  804183:	29 fb                	sub    %edi,%ebx
  804185:	89 f9                	mov    %edi,%ecx
  804187:	d3 e6                	shl    %cl,%esi
  804189:	89 c5                	mov    %eax,%ebp
  80418b:	88 d9                	mov    %bl,%cl
  80418d:	d3 ed                	shr    %cl,%ebp
  80418f:	89 e9                	mov    %ebp,%ecx
  804191:	09 f1                	or     %esi,%ecx
  804193:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804197:	89 f9                	mov    %edi,%ecx
  804199:	d3 e0                	shl    %cl,%eax
  80419b:	89 c5                	mov    %eax,%ebp
  80419d:	89 d6                	mov    %edx,%esi
  80419f:	88 d9                	mov    %bl,%cl
  8041a1:	d3 ee                	shr    %cl,%esi
  8041a3:	89 f9                	mov    %edi,%ecx
  8041a5:	d3 e2                	shl    %cl,%edx
  8041a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041ab:	88 d9                	mov    %bl,%cl
  8041ad:	d3 e8                	shr    %cl,%eax
  8041af:	09 c2                	or     %eax,%edx
  8041b1:	89 d0                	mov    %edx,%eax
  8041b3:	89 f2                	mov    %esi,%edx
  8041b5:	f7 74 24 0c          	divl   0xc(%esp)
  8041b9:	89 d6                	mov    %edx,%esi
  8041bb:	89 c3                	mov    %eax,%ebx
  8041bd:	f7 e5                	mul    %ebp
  8041bf:	39 d6                	cmp    %edx,%esi
  8041c1:	72 19                	jb     8041dc <__udivdi3+0xfc>
  8041c3:	74 0b                	je     8041d0 <__udivdi3+0xf0>
  8041c5:	89 d8                	mov    %ebx,%eax
  8041c7:	31 ff                	xor    %edi,%edi
  8041c9:	e9 58 ff ff ff       	jmp    804126 <__udivdi3+0x46>
  8041ce:	66 90                	xchg   %ax,%ax
  8041d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041d4:	89 f9                	mov    %edi,%ecx
  8041d6:	d3 e2                	shl    %cl,%edx
  8041d8:	39 c2                	cmp    %eax,%edx
  8041da:	73 e9                	jae    8041c5 <__udivdi3+0xe5>
  8041dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041df:	31 ff                	xor    %edi,%edi
  8041e1:	e9 40 ff ff ff       	jmp    804126 <__udivdi3+0x46>
  8041e6:	66 90                	xchg   %ax,%ax
  8041e8:	31 c0                	xor    %eax,%eax
  8041ea:	e9 37 ff ff ff       	jmp    804126 <__udivdi3+0x46>
  8041ef:	90                   	nop

008041f0 <__umoddi3>:
  8041f0:	55                   	push   %ebp
  8041f1:	57                   	push   %edi
  8041f2:	56                   	push   %esi
  8041f3:	53                   	push   %ebx
  8041f4:	83 ec 1c             	sub    $0x1c,%esp
  8041f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804203:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804207:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80420b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80420f:	89 f3                	mov    %esi,%ebx
  804211:	89 fa                	mov    %edi,%edx
  804213:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804217:	89 34 24             	mov    %esi,(%esp)
  80421a:	85 c0                	test   %eax,%eax
  80421c:	75 1a                	jne    804238 <__umoddi3+0x48>
  80421e:	39 f7                	cmp    %esi,%edi
  804220:	0f 86 a2 00 00 00    	jbe    8042c8 <__umoddi3+0xd8>
  804226:	89 c8                	mov    %ecx,%eax
  804228:	89 f2                	mov    %esi,%edx
  80422a:	f7 f7                	div    %edi
  80422c:	89 d0                	mov    %edx,%eax
  80422e:	31 d2                	xor    %edx,%edx
  804230:	83 c4 1c             	add    $0x1c,%esp
  804233:	5b                   	pop    %ebx
  804234:	5e                   	pop    %esi
  804235:	5f                   	pop    %edi
  804236:	5d                   	pop    %ebp
  804237:	c3                   	ret    
  804238:	39 f0                	cmp    %esi,%eax
  80423a:	0f 87 ac 00 00 00    	ja     8042ec <__umoddi3+0xfc>
  804240:	0f bd e8             	bsr    %eax,%ebp
  804243:	83 f5 1f             	xor    $0x1f,%ebp
  804246:	0f 84 ac 00 00 00    	je     8042f8 <__umoddi3+0x108>
  80424c:	bf 20 00 00 00       	mov    $0x20,%edi
  804251:	29 ef                	sub    %ebp,%edi
  804253:	89 fe                	mov    %edi,%esi
  804255:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804259:	89 e9                	mov    %ebp,%ecx
  80425b:	d3 e0                	shl    %cl,%eax
  80425d:	89 d7                	mov    %edx,%edi
  80425f:	89 f1                	mov    %esi,%ecx
  804261:	d3 ef                	shr    %cl,%edi
  804263:	09 c7                	or     %eax,%edi
  804265:	89 e9                	mov    %ebp,%ecx
  804267:	d3 e2                	shl    %cl,%edx
  804269:	89 14 24             	mov    %edx,(%esp)
  80426c:	89 d8                	mov    %ebx,%eax
  80426e:	d3 e0                	shl    %cl,%eax
  804270:	89 c2                	mov    %eax,%edx
  804272:	8b 44 24 08          	mov    0x8(%esp),%eax
  804276:	d3 e0                	shl    %cl,%eax
  804278:	89 44 24 04          	mov    %eax,0x4(%esp)
  80427c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804280:	89 f1                	mov    %esi,%ecx
  804282:	d3 e8                	shr    %cl,%eax
  804284:	09 d0                	or     %edx,%eax
  804286:	d3 eb                	shr    %cl,%ebx
  804288:	89 da                	mov    %ebx,%edx
  80428a:	f7 f7                	div    %edi
  80428c:	89 d3                	mov    %edx,%ebx
  80428e:	f7 24 24             	mull   (%esp)
  804291:	89 c6                	mov    %eax,%esi
  804293:	89 d1                	mov    %edx,%ecx
  804295:	39 d3                	cmp    %edx,%ebx
  804297:	0f 82 87 00 00 00    	jb     804324 <__umoddi3+0x134>
  80429d:	0f 84 91 00 00 00    	je     804334 <__umoddi3+0x144>
  8042a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8042a7:	29 f2                	sub    %esi,%edx
  8042a9:	19 cb                	sbb    %ecx,%ebx
  8042ab:	89 d8                	mov    %ebx,%eax
  8042ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8042b1:	d3 e0                	shl    %cl,%eax
  8042b3:	89 e9                	mov    %ebp,%ecx
  8042b5:	d3 ea                	shr    %cl,%edx
  8042b7:	09 d0                	or     %edx,%eax
  8042b9:	89 e9                	mov    %ebp,%ecx
  8042bb:	d3 eb                	shr    %cl,%ebx
  8042bd:	89 da                	mov    %ebx,%edx
  8042bf:	83 c4 1c             	add    $0x1c,%esp
  8042c2:	5b                   	pop    %ebx
  8042c3:	5e                   	pop    %esi
  8042c4:	5f                   	pop    %edi
  8042c5:	5d                   	pop    %ebp
  8042c6:	c3                   	ret    
  8042c7:	90                   	nop
  8042c8:	89 fd                	mov    %edi,%ebp
  8042ca:	85 ff                	test   %edi,%edi
  8042cc:	75 0b                	jne    8042d9 <__umoddi3+0xe9>
  8042ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8042d3:	31 d2                	xor    %edx,%edx
  8042d5:	f7 f7                	div    %edi
  8042d7:	89 c5                	mov    %eax,%ebp
  8042d9:	89 f0                	mov    %esi,%eax
  8042db:	31 d2                	xor    %edx,%edx
  8042dd:	f7 f5                	div    %ebp
  8042df:	89 c8                	mov    %ecx,%eax
  8042e1:	f7 f5                	div    %ebp
  8042e3:	89 d0                	mov    %edx,%eax
  8042e5:	e9 44 ff ff ff       	jmp    80422e <__umoddi3+0x3e>
  8042ea:	66 90                	xchg   %ax,%ax
  8042ec:	89 c8                	mov    %ecx,%eax
  8042ee:	89 f2                	mov    %esi,%edx
  8042f0:	83 c4 1c             	add    $0x1c,%esp
  8042f3:	5b                   	pop    %ebx
  8042f4:	5e                   	pop    %esi
  8042f5:	5f                   	pop    %edi
  8042f6:	5d                   	pop    %ebp
  8042f7:	c3                   	ret    
  8042f8:	3b 04 24             	cmp    (%esp),%eax
  8042fb:	72 06                	jb     804303 <__umoddi3+0x113>
  8042fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804301:	77 0f                	ja     804312 <__umoddi3+0x122>
  804303:	89 f2                	mov    %esi,%edx
  804305:	29 f9                	sub    %edi,%ecx
  804307:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80430b:	89 14 24             	mov    %edx,(%esp)
  80430e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804312:	8b 44 24 04          	mov    0x4(%esp),%eax
  804316:	8b 14 24             	mov    (%esp),%edx
  804319:	83 c4 1c             	add    $0x1c,%esp
  80431c:	5b                   	pop    %ebx
  80431d:	5e                   	pop    %esi
  80431e:	5f                   	pop    %edi
  80431f:	5d                   	pop    %ebp
  804320:	c3                   	ret    
  804321:	8d 76 00             	lea    0x0(%esi),%esi
  804324:	2b 04 24             	sub    (%esp),%eax
  804327:	19 fa                	sbb    %edi,%edx
  804329:	89 d1                	mov    %edx,%ecx
  80432b:	89 c6                	mov    %eax,%esi
  80432d:	e9 71 ff ff ff       	jmp    8042a3 <__umoddi3+0xb3>
  804332:	66 90                	xchg   %ax,%ax
  804334:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804338:	72 ea                	jb     804324 <__umoddi3+0x134>
  80433a:	89 d9                	mov    %ebx,%ecx
  80433c:	e9 62 ff ff ff       	jmp    8042a3 <__umoddi3+0xb3>
