
obj/user/tst_best_fit_1:     file format elf32-i386


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
  800031:	e8 d2 0a 00 00       	call   800b08 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 6b 25 00 00       	call   8025b5 <sys_set_uheap_strategy>
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
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

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
  80009b:	68 e0 3e 80 00       	push   $0x803ee0
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 fc 3e 80 00       	push   $0x803efc
  8000a7:	e8 98 0b 00 00       	call   800c44 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 ca 1d 00 00       	call   801e80 <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
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
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 c3 1f 00 00       	call   8020a0 <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 5b 20 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(3*Mega-kilo);
  8000e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	01 d2                	add    %edx,%edx
  8000ef:	01 d0                	add    %edx,%eax
  8000f1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 83 1d 00 00       	call   801e80 <malloc>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800103:	8b 45 90             	mov    -0x70(%ebp),%eax
  800106:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80010b:	74 14                	je     800121 <_main+0xe9>
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	68 14 3f 80 00       	push   $0x803f14
  800115:	6a 26                	push   $0x26
  800117:	68 fc 3e 80 00       	push   $0x803efc
  80011c:	e8 23 0b 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  800121:	e8 1a 20 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800126:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800129:	3d 00 03 00 00       	cmp    $0x300,%eax
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 44 3f 80 00       	push   $0x803f44
  800138:	6a 28                	push   $0x28
  80013a:	68 fc 3e 80 00       	push   $0x803efc
  80013f:	e8 00 0b 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800144:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800147:	e8 54 1f 00 00       	call   8020a0 <sys_calculate_free_frames>
  80014c:	29 c3                	sub    %eax,%ebx
  80014e:	89 d8                	mov    %ebx,%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 61 3f 80 00       	push   $0x803f61
  80015d:	6a 29                	push   $0x29
  80015f:	68 fc 3e 80 00       	push   $0x803efc
  800164:	e8 db 0a 00 00       	call   800c44 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 32 1f 00 00       	call   8020a0 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 ca 1f 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	89 c2                	mov    %eax,%edx
  80017e:	01 d2                	add    %edx,%edx
  800180:	01 d0                	add    %edx,%eax
  800182:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 f2 1c 00 00       	call   801e80 <malloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  800194:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800197:	89 c1                	mov    %eax,%ecx
  800199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019c:	89 c2                	mov    %eax,%edx
  80019e:	01 d2                	add    %edx,%edx
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a7:	39 c1                	cmp    %eax,%ecx
  8001a9:	74 14                	je     8001bf <_main+0x187>
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	68 14 3f 80 00       	push   $0x803f14
  8001b3:	6a 2f                	push   $0x2f
  8001b5:	68 fc 3e 80 00       	push   $0x803efc
  8001ba:	e8 85 0a 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001bf:	e8 7c 1f 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  8001c4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c7:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 44 3f 80 00       	push   $0x803f44
  8001d6:	6a 31                	push   $0x31
  8001d8:	68 fc 3e 80 00       	push   $0x803efc
  8001dd:	e8 62 0a 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001e5:	e8 b6 1e 00 00       	call   8020a0 <sys_calculate_free_frames>
  8001ea:	29 c3                	sub    %eax,%ebx
  8001ec:	89 d8                	mov    %ebx,%eax
  8001ee:	83 f8 01             	cmp    $0x1,%eax
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 61 3f 80 00       	push   $0x803f61
  8001fb:	6a 32                	push   $0x32
  8001fd:	68 fc 3e 80 00       	push   $0x803efc
  800202:	e8 3d 0a 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800207:	e8 94 1e 00 00       	call   8020a0 <sys_calculate_free_frames>
  80020c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020f:	e8 2c 1f 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800214:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*Mega-kilo);
  800217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	50                   	push   %eax
  800223:	e8 58 1c 00 00       	call   801e80 <malloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80022e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800231:	89 c1                	mov    %eax,%ecx
  800233:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800236:	89 d0                	mov    %edx,%eax
  800238:	01 c0                	add    %eax,%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	01 c0                	add    %eax,%eax
  80023e:	05 00 00 00 80       	add    $0x80000000,%eax
  800243:	39 c1                	cmp    %eax,%ecx
  800245:	74 14                	je     80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 14 3f 80 00       	push   $0x803f14
  80024f:	6a 38                	push   $0x38
  800251:	68 fc 3e 80 00       	push   $0x803efc
  800256:	e8 e9 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  80025b:	e8 e0 1e 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800260:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800263:	3d 00 02 00 00       	cmp    $0x200,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 44 3f 80 00       	push   $0x803f44
  800272:	6a 3a                	push   $0x3a
  800274:	68 fc 3e 80 00       	push   $0x803efc
  800279:	e8 c6 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80027e:	e8 1d 1e 00 00       	call   8020a0 <sys_calculate_free_frames>
  800283:	89 c2                	mov    %eax,%edx
  800285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800288:	39 c2                	cmp    %eax,%edx
  80028a:	74 14                	je     8002a0 <_main+0x268>
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 61 3f 80 00       	push   $0x803f61
  800294:	6a 3b                	push   $0x3b
  800296:	68 fc 3e 80 00       	push   $0x803efc
  80029b:	e8 a4 09 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002a0:	e8 fb 1d 00 00       	call   8020a0 <sys_calculate_free_frames>
  8002a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002a8:	e8 93 1e 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  8002ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*Mega-kilo);
  8002b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b3:	01 c0                	add    %eax,%eax
  8002b5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	50                   	push   %eax
  8002bc:	e8 bf 1b 00 00       	call   801e80 <malloc>
  8002c1:	83 c4 10             	add    $0x10,%esp
  8002c4:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8002c7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002ca:	89 c2                	mov    %eax,%edx
  8002cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cf:	c1 e0 03             	shl    $0x3,%eax
  8002d2:	05 00 00 00 80       	add    $0x80000000,%eax
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	74 14                	je     8002ef <_main+0x2b7>
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	68 14 3f 80 00       	push   $0x803f14
  8002e3:	6a 41                	push   $0x41
  8002e5:	68 fc 3e 80 00       	push   $0x803efc
  8002ea:	e8 55 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002ef:	e8 4c 1e 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  8002f4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 44 3f 80 00       	push   $0x803f44
  800306:	6a 43                	push   $0x43
  800308:	68 fc 3e 80 00       	push   $0x803efc
  80030d:	e8 32 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800312:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800315:	e8 86 1d 00 00       	call   8020a0 <sys_calculate_free_frames>
  80031a:	29 c3                	sub    %eax,%ebx
  80031c:	89 d8                	mov    %ebx,%eax
  80031e:	83 f8 01             	cmp    $0x1,%eax
  800321:	74 14                	je     800337 <_main+0x2ff>
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	68 61 3f 80 00       	push   $0x803f61
  80032b:	6a 44                	push   $0x44
  80032d:	68 fc 3e 80 00       	push   $0x803efc
  800332:	e8 0d 09 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800337:	e8 64 1d 00 00       	call   8020a0 <sys_calculate_free_frames>
  80033c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80033f:	e8 fc 1d 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800344:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(1*Mega-kilo);
  800347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80034a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	50                   	push   %eax
  800351:	e8 2a 1b 00 00       	call   801e80 <malloc>
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 10*Mega) ) panic("Wrong start address for the allocated space... ");
  80035c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80035f:	89 c1                	mov    %eax,%ecx
  800361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	c1 e0 02             	shl    $0x2,%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	05 00 00 00 80       	add    $0x80000000,%eax
  800372:	39 c1                	cmp    %eax,%ecx
  800374:	74 14                	je     80038a <_main+0x352>
  800376:	83 ec 04             	sub    $0x4,%esp
  800379:	68 14 3f 80 00       	push   $0x803f14
  80037e:	6a 4a                	push   $0x4a
  800380:	68 fc 3e 80 00       	push   $0x803efc
  800385:	e8 ba 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80038a:	e8 b1 1d 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  80038f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800392:	3d 00 01 00 00       	cmp    $0x100,%eax
  800397:	74 14                	je     8003ad <_main+0x375>
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 44 3f 80 00       	push   $0x803f44
  8003a1:	6a 4c                	push   $0x4c
  8003a3:	68 fc 3e 80 00       	push   $0x803efc
  8003a8:	e8 97 08 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003ad:	e8 ee 1c 00 00       	call   8020a0 <sys_calculate_free_frames>
  8003b2:	89 c2                	mov    %eax,%edx
  8003b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	74 14                	je     8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 61 3f 80 00       	push   $0x803f61
  8003c3:	6a 4d                	push   $0x4d
  8003c5:	68 fc 3e 80 00       	push   $0x803efc
  8003ca:	e8 75 08 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cf:	e8 cc 1c 00 00       	call   8020a0 <sys_calculate_free_frames>
  8003d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d7:	e8 64 1d 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  8003dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(1*Mega-kilo);
  8003df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	50                   	push   %eax
  8003e9:	e8 92 1a 00 00       	call   801e80 <malloc>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 11*Mega) ) panic("Wrong start address for the allocated space... ");
  8003f4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003f7:	89 c1                	mov    %eax,%ecx
  8003f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003fc:	89 d0                	mov    %edx,%eax
  8003fe:	c1 e0 02             	shl    $0x2,%eax
  800401:	01 d0                	add    %edx,%eax
  800403:	01 c0                	add    %eax,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	05 00 00 00 80       	add    $0x80000000,%eax
  80040c:	39 c1                	cmp    %eax,%ecx
  80040e:	74 14                	je     800424 <_main+0x3ec>
  800410:	83 ec 04             	sub    $0x4,%esp
  800413:	68 14 3f 80 00       	push   $0x803f14
  800418:	6a 53                	push   $0x53
  80041a:	68 fc 3e 80 00       	push   $0x803efc
  80041f:	e8 20 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800424:	e8 17 1d 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800429:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80042c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800431:	74 14                	je     800447 <_main+0x40f>
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	68 44 3f 80 00       	push   $0x803f44
  80043b:	6a 55                	push   $0x55
  80043d:	68 fc 3e 80 00       	push   $0x803efc
  800442:	e8 fd 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800447:	e8 54 1c 00 00       	call   8020a0 <sys_calculate_free_frames>
  80044c:	89 c2                	mov    %eax,%edx
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	74 14                	je     800469 <_main+0x431>
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 61 3f 80 00       	push   $0x803f61
  80045d:	6a 56                	push   $0x56
  80045f:	68 fc 3e 80 00       	push   $0x803efc
  800464:	e8 db 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800469:	e8 32 1c 00 00       	call   8020a0 <sys_calculate_free_frames>
  80046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800471:	e8 ca 1c 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800476:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(1*Mega-kilo);
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	50                   	push   %eax
  800483:	e8 f8 19 00 00       	call   801e80 <malloc>
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 12*Mega) ) panic("Wrong start address for the allocated space... ");
  80048e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800491:	89 c1                	mov    %eax,%ecx
  800493:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800496:	89 d0                	mov    %edx,%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	c1 e0 02             	shl    $0x2,%eax
  80049f:	05 00 00 00 80       	add    $0x80000000,%eax
  8004a4:	39 c1                	cmp    %eax,%ecx
  8004a6:	74 14                	je     8004bc <_main+0x484>
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	68 14 3f 80 00       	push   $0x803f14
  8004b0:	6a 5c                	push   $0x5c
  8004b2:	68 fc 3e 80 00       	push   $0x803efc
  8004b7:	e8 88 07 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004bc:	e8 7f 1c 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  8004c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 44 3f 80 00       	push   $0x803f44
  8004d3:	6a 5e                	push   $0x5e
  8004d5:	68 fc 3e 80 00       	push   $0x803efc
  8004da:	e8 65 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004e2:	e8 b9 1b 00 00       	call   8020a0 <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	83 f8 01             	cmp    $0x1,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 61 3f 80 00       	push   $0x803f61
  8004f8:	6a 5f                	push   $0x5f
  8004fa:	68 fc 3e 80 00       	push   $0x803efc
  8004ff:	e8 40 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800504:	e8 97 1b 00 00       	call   8020a0 <sys_calculate_free_frames>
  800509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80050c:	e8 2f 1c 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(1*Mega-kilo);
  800514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800517:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 5d 19 00 00       	call   801e80 <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 13*Mega)) panic("Wrong start address for the allocated space... ");
  800529:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80052c:	89 c1                	mov    %eax,%ecx
  80052e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800531:	89 d0                	mov    %edx,%eax
  800533:	01 c0                	add    %eax,%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	c1 e0 02             	shl    $0x2,%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	05 00 00 00 80       	add    $0x80000000,%eax
  800541:	39 c1                	cmp    %eax,%ecx
  800543:	74 14                	je     800559 <_main+0x521>
  800545:	83 ec 04             	sub    $0x4,%esp
  800548:	68 14 3f 80 00       	push   $0x803f14
  80054d:	6a 65                	push   $0x65
  80054f:	68 fc 3e 80 00       	push   $0x803efc
  800554:	e8 eb 06 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800559:	e8 e2 1b 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  80055e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800561:	3d 00 01 00 00       	cmp    $0x100,%eax
  800566:	74 14                	je     80057c <_main+0x544>
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	68 44 3f 80 00       	push   $0x803f44
  800570:	6a 67                	push   $0x67
  800572:	68 fc 3e 80 00       	push   $0x803efc
  800577:	e8 c8 06 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80057c:	e8 1f 1b 00 00       	call   8020a0 <sys_calculate_free_frames>
  800581:	89 c2                	mov    %eax,%edx
  800583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	74 14                	je     80059e <_main+0x566>
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 61 3f 80 00       	push   $0x803f61
  800592:	6a 68                	push   $0x68
  800594:	68 fc 3e 80 00       	push   $0x803efc
  800599:	e8 a6 06 00 00       	call   800c44 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80059e:	e8 fd 1a 00 00       	call   8020a0 <sys_calculate_free_frames>
  8005a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005a6:	e8 95 1b 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	50                   	push   %eax
  8005b5:	e8 f4 18 00 00       	call   801eae <free>
  8005ba:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005bd:	e8 7e 1b 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  8005c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c5:	29 c2                	sub    %eax,%edx
  8005c7:	89 d0                	mov    %edx,%eax
  8005c9:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 74 3f 80 00       	push   $0x803f74
  8005d8:	6a 72                	push   $0x72
  8005da:	68 fc 3e 80 00       	push   $0x803efc
  8005df:	e8 60 06 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005e4:	e8 b7 1a 00 00       	call   8020a0 <sys_calculate_free_frames>
  8005e9:	89 c2                	mov    %eax,%edx
  8005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ee:	39 c2                	cmp    %eax,%edx
  8005f0:	74 14                	je     800606 <_main+0x5ce>
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 8b 3f 80 00       	push   $0x803f8b
  8005fa:	6a 73                	push   $0x73
  8005fc:	68 fc 3e 80 00       	push   $0x803efc
  800601:	e8 3e 06 00 00       	call   800c44 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800606:	e8 95 1a 00 00       	call   8020a0 <sys_calculate_free_frames>
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060e:	e8 2d 1b 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800613:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800616:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	50                   	push   %eax
  80061d:	e8 8c 18 00 00       	call   801eae <free>
  800622:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800625:	e8 16 1b 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  80062a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062d:	29 c2                	sub    %eax,%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	3d 00 02 00 00       	cmp    $0x200,%eax
  800636:	74 14                	je     80064c <_main+0x614>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 74 3f 80 00       	push   $0x803f74
  800640:	6a 7a                	push   $0x7a
  800642:	68 fc 3e 80 00       	push   $0x803efc
  800647:	e8 f8 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064c:	e8 4f 1a 00 00       	call   8020a0 <sys_calculate_free_frames>
  800651:	89 c2                	mov    %eax,%edx
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	74 14                	je     80066e <_main+0x636>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 8b 3f 80 00       	push   $0x803f8b
  800662:	6a 7b                	push   $0x7b
  800664:	68 fc 3e 80 00       	push   $0x803efc
  800669:	e8 d6 05 00 00       	call   800c44 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80066e:	e8 2d 1a 00 00       	call   8020a0 <sys_calculate_free_frames>
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800676:	e8 c5 1a 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80067e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800681:	83 ec 0c             	sub    $0xc,%esp
  800684:	50                   	push   %eax
  800685:	e8 24 18 00 00       	call   801eae <free>
  80068a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80068d:	e8 ae 1a 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	3d 00 01 00 00       	cmp    $0x100,%eax
  80069e:	74 17                	je     8006b7 <_main+0x67f>
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	68 74 3f 80 00       	push   $0x803f74
  8006a8:	68 82 00 00 00       	push   $0x82
  8006ad:	68 fc 3e 80 00       	push   $0x803efc
  8006b2:	e8 8d 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006b7:	e8 e4 19 00 00       	call   8020a0 <sys_calculate_free_frames>
  8006bc:	89 c2                	mov    %eax,%edx
  8006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	74 17                	je     8006dc <_main+0x6a4>
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	68 8b 3f 80 00       	push   $0x803f8b
  8006cd:	68 83 00 00 00       	push   $0x83
  8006d2:	68 fc 3e 80 00       	push   $0x803efc
  8006d7:	e8 68 05 00 00       	call   800c44 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006dc:	e8 bf 19 00 00       	call   8020a0 <sys_calculate_free_frames>
  8006e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006e4:	e8 57 1a 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  8006e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo);
  8006ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ef:	c1 e0 09             	shl    $0x9,%eax
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	50                   	push   %eax
  8006f6:	e8 85 17 00 00       	call   801e80 <malloc>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  800701:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800704:	89 c1                	mov    %eax,%ecx
  800706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800709:	89 d0                	mov    %edx,%eax
  80070b:	c1 e0 02             	shl    $0x2,%eax
  80070e:	01 d0                	add    %edx,%eax
  800710:	01 c0                	add    %eax,%eax
  800712:	01 d0                	add    %edx,%eax
  800714:	05 00 00 00 80       	add    $0x80000000,%eax
  800719:	39 c1                	cmp    %eax,%ecx
  80071b:	74 17                	je     800734 <_main+0x6fc>
  80071d:	83 ec 04             	sub    $0x4,%esp
  800720:	68 14 3f 80 00       	push   $0x803f14
  800725:	68 8c 00 00 00       	push   $0x8c
  80072a:	68 fc 3e 80 00       	push   $0x803efc
  80072f:	e8 10 05 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800734:	e8 07 1a 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800739:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80073c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800741:	74 17                	je     80075a <_main+0x722>
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	68 44 3f 80 00       	push   $0x803f44
  80074b:	68 8e 00 00 00       	push   $0x8e
  800750:	68 fc 3e 80 00       	push   $0x803efc
  800755:	e8 ea 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80075a:	e8 41 19 00 00       	call   8020a0 <sys_calculate_free_frames>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 61 3f 80 00       	push   $0x803f61
  800770:	68 8f 00 00 00       	push   $0x8f
  800775:	68 fc 3e 80 00       	push   $0x803efc
  80077a:	e8 c5 04 00 00       	call   800c44 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80077f:	e8 1c 19 00 00       	call   8020a0 <sys_calculate_free_frames>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800787:	e8 b4 19 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  80078c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80078f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800792:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	50                   	push   %eax
  800799:	e8 e2 16 00 00       	call   801e80 <malloc>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8007a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007a7:	89 c2                	mov    %eax,%edx
  8007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ac:	c1 e0 03             	shl    $0x3,%eax
  8007af:	05 00 00 00 80       	add    $0x80000000,%eax
  8007b4:	39 c2                	cmp    %eax,%edx
  8007b6:	74 17                	je     8007cf <_main+0x797>
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	68 14 3f 80 00       	push   $0x803f14
  8007c0:	68 95 00 00 00       	push   $0x95
  8007c5:	68 fc 3e 80 00       	push   $0x803efc
  8007ca:	e8 75 04 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007cf:	e8 6c 19 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  8007d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007d7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007dc:	74 17                	je     8007f5 <_main+0x7bd>
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	68 44 3f 80 00       	push   $0x803f44
  8007e6:	68 97 00 00 00       	push   $0x97
  8007eb:	68 fc 3e 80 00       	push   $0x803efc
  8007f0:	e8 4f 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007f5:	e8 a6 18 00 00       	call   8020a0 <sys_calculate_free_frames>
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 17                	je     80081a <_main+0x7e2>
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	68 61 3f 80 00       	push   $0x803f61
  80080b:	68 98 00 00 00       	push   $0x98
  800810:	68 fc 3e 80 00       	push   $0x803efc
  800815:	e8 2a 04 00 00       	call   800c44 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80081a:	e8 81 18 00 00       	call   8020a0 <sys_calculate_free_frames>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800822:	e8 19 19 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800827:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  80082a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082d:	89 d0                	mov    %edx,%eax
  80082f:	c1 e0 08             	shl    $0x8,%eax
  800832:	29 d0                	sub    %edx,%eax
  800834:	83 ec 0c             	sub    $0xc,%esp
  800837:	50                   	push   %eax
  800838:	e8 43 16 00 00       	call   801e80 <malloc>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 11*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800843:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800846:	89 c1                	mov    %eax,%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	c1 e0 02             	shl    $0x2,%eax
  800850:	01 d0                	add    %edx,%eax
  800852:	01 c0                	add    %eax,%eax
  800854:	01 d0                	add    %edx,%eax
  800856:	89 c2                	mov    %eax,%edx
  800858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085b:	c1 e0 09             	shl    $0x9,%eax
  80085e:	01 d0                	add    %edx,%eax
  800860:	05 00 00 00 80       	add    $0x80000000,%eax
  800865:	39 c1                	cmp    %eax,%ecx
  800867:	74 17                	je     800880 <_main+0x848>
  800869:	83 ec 04             	sub    $0x4,%esp
  80086c:	68 14 3f 80 00       	push   $0x803f14
  800871:	68 9e 00 00 00       	push   $0x9e
  800876:	68 fc 3e 80 00       	push   $0x803efc
  80087b:	e8 c4 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800880:	e8 bb 18 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800885:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800888:	83 f8 40             	cmp    $0x40,%eax
  80088b:	74 17                	je     8008a4 <_main+0x86c>
  80088d:	83 ec 04             	sub    $0x4,%esp
  800890:	68 44 3f 80 00       	push   $0x803f44
  800895:	68 a0 00 00 00       	push   $0xa0
  80089a:	68 fc 3e 80 00       	push   $0x803efc
  80089f:	e8 a0 03 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008a4:	e8 f7 17 00 00       	call   8020a0 <sys_calculate_free_frames>
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 61 3f 80 00       	push   $0x803f61
  8008ba:	68 a1 00 00 00       	push   $0xa1
  8008bf:	68 fc 3e 80 00       	push   $0x803efc
  8008c4:	e8 7b 03 00 00       	call   800c44 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 d2 17 00 00       	call   8020a0 <sys_calculate_free_frames>
  8008ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008d1:	e8 6a 18 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  8008d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dc:	c1 e0 02             	shl    $0x2,%eax
  8008df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008e2:	83 ec 0c             	sub    $0xc,%esp
  8008e5:	50                   	push   %eax
  8008e6:	e8 95 15 00 00       	call   801e80 <malloc>
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  8008f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008f4:	89 c1                	mov    %eax,%ecx
  8008f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	01 c0                	add    %eax,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	01 c0                	add    %eax,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	05 00 00 00 80       	add    $0x80000000,%eax
  80090a:	39 c1                	cmp    %eax,%ecx
  80090c:	74 17                	je     800925 <_main+0x8ed>
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	68 14 3f 80 00       	push   $0x803f14
  800916:	68 a7 00 00 00       	push   $0xa7
  80091b:	68 fc 3e 80 00       	push   $0x803efc
  800920:	e8 1f 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800925:	e8 16 18 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  80092a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80092d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 44 3f 80 00       	push   $0x803f44
  80093c:	68 a9 00 00 00       	push   $0xa9
  800941:	68 fc 3e 80 00       	push   $0x803efc
  800946:	e8 f9 02 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80094b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80094e:	e8 4d 17 00 00       	call   8020a0 <sys_calculate_free_frames>
  800953:	29 c3                	sub    %eax,%ebx
  800955:	89 d8                	mov    %ebx,%eax
  800957:	83 f8 01             	cmp    $0x1,%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 61 3f 80 00       	push   $0x803f61
  800964:	68 aa 00 00 00       	push   $0xaa
  800969:	68 fc 3e 80 00       	push   $0x803efc
  80096e:	e8 d1 02 00 00       	call   800c44 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  800973:	e8 28 17 00 00       	call   8020a0 <sys_calculate_free_frames>
  800978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80097b:	e8 c0 17 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  800983:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800986:	83 ec 0c             	sub    $0xc,%esp
  800989:	50                   	push   %eax
  80098a:	e8 1f 15 00 00       	call   801eae <free>
  80098f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800992:	e8 a9 17 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099a:	29 c2                	sub    %eax,%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009a3:	74 17                	je     8009bc <_main+0x984>
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 74 3f 80 00       	push   $0x803f74
  8009ad:	68 b4 00 00 00       	push   $0xb4
  8009b2:	68 fc 3e 80 00       	push   $0x803efc
  8009b7:	e8 88 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009bc:	e8 df 16 00 00       	call   8020a0 <sys_calculate_free_frames>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 17                	je     8009e1 <_main+0x9a9>
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	68 8b 3f 80 00       	push   $0x803f8b
  8009d2:	68 b5 00 00 00       	push   $0xb5
  8009d7:	68 fc 3e 80 00       	push   $0x803efc
  8009dc:	e8 63 02 00 00       	call   800c44 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  8009e1:	e8 ba 16 00 00       	call   8020a0 <sys_calculate_free_frames>
  8009e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e9:	e8 52 17 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  8009f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8009f4:	83 ec 0c             	sub    $0xc,%esp
  8009f7:	50                   	push   %eax
  8009f8:	e8 b1 14 00 00       	call   801eae <free>
  8009fd:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800a00:	e8 3b 17 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800a05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a08:	29 c2                	sub    %eax,%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800a11:	74 17                	je     800a2a <_main+0x9f2>
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	68 74 3f 80 00       	push   $0x803f74
  800a1b:	68 bc 00 00 00       	push   $0xbc
  800a20:	68 fc 3e 80 00       	push   $0x803efc
  800a25:	e8 1a 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2a:	e8 71 16 00 00       	call   8020a0 <sys_calculate_free_frames>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 8b 3f 80 00       	push   $0x803f8b
  800a40:	68 bd 00 00 00       	push   $0xbd
  800a45:	68 fc 3e 80 00       	push   $0x803efc
  800a4a:	e8 f5 01 00 00       	call   800c44 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a4f:	e8 4c 16 00 00       	call   8020a0 <sys_calculate_free_frames>
  800a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a57:	e8 e4 16 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800a5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega - kilo);
  800a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a62:	01 c0                	add    %eax,%eax
  800a64:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	50                   	push   %eax
  800a6b:	e8 10 14 00 00       	call   801e80 <malloc>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 9*Mega)) panic("Wrong start address for the allocated space... ");
  800a76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a79:	89 c1                	mov    %eax,%ecx
  800a7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	c1 e0 03             	shl    $0x3,%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	05 00 00 00 80       	add    $0x80000000,%eax
  800a8a:	39 c1                	cmp    %eax,%ecx
  800a8c:	74 17                	je     800aa5 <_main+0xa6d>
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	68 14 3f 80 00       	push   $0x803f14
  800a96:	68 c6 00 00 00       	push   $0xc6
  800a9b:	68 fc 3e 80 00       	push   $0x803efc
  800aa0:	e8 9f 01 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800aa5:	e8 96 16 00 00       	call   802140 <sys_pf_calculate_allocated_pages>
  800aaa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800aad:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 44 3f 80 00       	push   $0x803f44
  800abc:	68 c8 00 00 00       	push   $0xc8
  800ac1:	68 fc 3e 80 00       	push   $0x803efc
  800ac6:	e8 79 01 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800acb:	e8 d0 15 00 00       	call   8020a0 <sys_calculate_free_frames>
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad5:	39 c2                	cmp    %eax,%edx
  800ad7:	74 17                	je     800af0 <_main+0xab8>
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	68 61 3f 80 00       	push   $0x803f61
  800ae1:	68 c9 00 00 00       	push   $0xc9
  800ae6:	68 fc 3e 80 00       	push   $0x803efc
  800aeb:	e8 54 01 00 00       	call   800c44 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800af0:	83 ec 0c             	sub    $0xc,%esp
  800af3:	68 98 3f 80 00       	push   $0x803f98
  800af8:	e8 fb 03 00 00       	call   800ef8 <cprintf>
  800afd:	83 c4 10             	add    $0x10,%esp

	return;
  800b00:	90                   	nop
}
  800b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b04:	5b                   	pop    %ebx
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b0e:	e8 6d 18 00 00       	call   802380 <sys_getenvindex>
  800b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b19:	89 d0                	mov    %edx,%eax
  800b1b:	c1 e0 03             	shl    $0x3,%eax
  800b1e:	01 d0                	add    %edx,%eax
  800b20:	01 c0                	add    %eax,%eax
  800b22:	01 d0                	add    %edx,%eax
  800b24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2b:	01 d0                	add    %edx,%eax
  800b2d:	c1 e0 04             	shl    $0x4,%eax
  800b30:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b35:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800b3f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	74 0f                	je     800b58 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b49:	a1 20 50 80 00       	mov    0x805020,%eax
  800b4e:	05 5c 05 00 00       	add    $0x55c,%eax
  800b53:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5c:	7e 0a                	jle    800b68 <libmain+0x60>
		binaryname = argv[0];
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 c2 f4 ff ff       	call   800038 <_main>
  800b76:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800b79:	e8 0f 16 00 00       	call   80218d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	68 f8 3f 80 00       	push   $0x803ff8
  800b86:	e8 6d 03 00 00       	call   800ef8 <cprintf>
  800b8b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b8e:	a1 20 50 80 00       	mov    0x805020,%eax
  800b93:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800b99:	a1 20 50 80 00       	mov    0x805020,%eax
  800b9e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ba4:	83 ec 04             	sub    $0x4,%esp
  800ba7:	52                   	push   %edx
  800ba8:	50                   	push   %eax
  800ba9:	68 20 40 80 00       	push   $0x804020
  800bae:	e8 45 03 00 00       	call   800ef8 <cprintf>
  800bb3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bb6:	a1 20 50 80 00       	mov    0x805020,%eax
  800bbb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800bc1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bc6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800bcc:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd1:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800bd7:	51                   	push   %ecx
  800bd8:	52                   	push   %edx
  800bd9:	50                   	push   %eax
  800bda:	68 48 40 80 00       	push   $0x804048
  800bdf:	e8 14 03 00 00       	call   800ef8 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800be7:	a1 20 50 80 00       	mov    0x805020,%eax
  800bec:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	68 a0 40 80 00       	push   $0x8040a0
  800bfb:	e8 f8 02 00 00       	call   800ef8 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	68 f8 3f 80 00       	push   $0x803ff8
  800c0b:	e8 e8 02 00 00       	call   800ef8 <cprintf>
  800c10:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c13:	e8 8f 15 00 00       	call   8021a7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c18:	e8 19 00 00 00       	call   800c36 <exit>
}
  800c1d:	90                   	nop
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	6a 00                	push   $0x0
  800c2b:	e8 1c 17 00 00       	call   80234c <sys_destroy_env>
  800c30:	83 c4 10             	add    $0x10,%esp
}
  800c33:	90                   	nop
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <exit>:

void
exit(void)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c3c:	e8 71 17 00 00       	call   8023b2 <sys_exit_env>
}
  800c41:	90                   	nop
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c4a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4d:	83 c0 04             	add    $0x4,%eax
  800c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c53:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	74 16                	je     800c72 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c5c:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	50                   	push   %eax
  800c65:	68 b4 40 80 00       	push   $0x8040b4
  800c6a:	e8 89 02 00 00       	call   800ef8 <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c72:	a1 00 50 80 00       	mov    0x805000,%eax
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	ff 75 08             	pushl  0x8(%ebp)
  800c7d:	50                   	push   %eax
  800c7e:	68 b9 40 80 00       	push   $0x8040b9
  800c83:	e8 70 02 00 00       	call   800ef8 <cprintf>
  800c88:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 f4             	pushl  -0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	e8 f3 01 00 00       	call   800e8d <vcprintf>
  800c9a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	6a 00                	push   $0x0
  800ca2:	68 d5 40 80 00       	push   $0x8040d5
  800ca7:	e8 e1 01 00 00       	call   800e8d <vcprintf>
  800cac:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800caf:	e8 82 ff ff ff       	call   800c36 <exit>

	// should not return here
	while (1) ;
  800cb4:	eb fe                	jmp    800cb4 <_panic+0x70>

00800cb6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cbc:	a1 20 50 80 00       	mov    0x805020,%eax
  800cc1:	8b 50 74             	mov    0x74(%eax),%edx
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	39 c2                	cmp    %eax,%edx
  800cc9:	74 14                	je     800cdf <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800ccb:	83 ec 04             	sub    $0x4,%esp
  800cce:	68 d8 40 80 00       	push   $0x8040d8
  800cd3:	6a 26                	push   $0x26
  800cd5:	68 24 41 80 00       	push   $0x804124
  800cda:	e8 65 ff ff ff       	call   800c44 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800cdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ce6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ced:	e9 c2 00 00 00       	jmp    800db4 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	01 d0                	add    %edx,%eax
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	85 c0                	test   %eax,%eax
  800d05:	75 08                	jne    800d0f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d07:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d0a:	e9 a2 00 00 00       	jmp    800db1 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d1d:	eb 69                	jmp    800d88 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d1f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d24:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d2d:	89 d0                	mov    %edx,%eax
  800d2f:	01 c0                	add    %eax,%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	c1 e0 03             	shl    $0x3,%eax
  800d36:	01 c8                	add    %ecx,%eax
  800d38:	8a 40 04             	mov    0x4(%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	75 46                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d44:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d4d:	89 d0                	mov    %edx,%eax
  800d4f:	01 c0                	add    %eax,%eax
  800d51:	01 d0                	add    %edx,%eax
  800d53:	c1 e0 03             	shl    $0x3,%eax
  800d56:	01 c8                	add    %ecx,%eax
  800d58:	8b 00                	mov    (%eax),%eax
  800d5a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d65:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d6a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	01 c8                	add    %ecx,%eax
  800d76:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d78:	39 c2                	cmp    %eax,%edx
  800d7a:	75 09                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800d7c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d83:	eb 12                	jmp    800d97 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d85:	ff 45 e8             	incl   -0x18(%ebp)
  800d88:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8d:	8b 50 74             	mov    0x74(%eax),%edx
  800d90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d93:	39 c2                	cmp    %eax,%edx
  800d95:	77 88                	ja     800d1f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800d97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d9b:	75 14                	jne    800db1 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800d9d:	83 ec 04             	sub    $0x4,%esp
  800da0:	68 30 41 80 00       	push   $0x804130
  800da5:	6a 3a                	push   $0x3a
  800da7:	68 24 41 80 00       	push   $0x804124
  800dac:	e8 93 fe ff ff       	call   800c44 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800db1:	ff 45 f0             	incl   -0x10(%ebp)
  800db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dba:	0f 8c 32 ff ff ff    	jl     800cf2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800dc0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800dce:	eb 26                	jmp    800df6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800dd0:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ddb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	01 c0                	add    %eax,%eax
  800de2:	01 d0                	add    %edx,%eax
  800de4:	c1 e0 03             	shl    $0x3,%eax
  800de7:	01 c8                	add    %ecx,%eax
  800de9:	8a 40 04             	mov    0x4(%eax),%al
  800dec:	3c 01                	cmp    $0x1,%al
  800dee:	75 03                	jne    800df3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800df0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800df3:	ff 45 e0             	incl   -0x20(%ebp)
  800df6:	a1 20 50 80 00       	mov    0x805020,%eax
  800dfb:	8b 50 74             	mov    0x74(%eax),%edx
  800dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e01:	39 c2                	cmp    %eax,%edx
  800e03:	77 cb                	ja     800dd0 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e0b:	74 14                	je     800e21 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e0d:	83 ec 04             	sub    $0x4,%esp
  800e10:	68 84 41 80 00       	push   $0x804184
  800e15:	6a 44                	push   $0x44
  800e17:	68 24 41 80 00       	push   $0x804124
  800e1c:	e8 23 fe ff ff       	call   800c44 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e21:	90                   	nop
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8b 00                	mov    (%eax),%eax
  800e2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e35:	89 0a                	mov    %ecx,(%edx)
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	88 d1                	mov    %dl,%cl
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	8b 00                	mov    (%eax),%eax
  800e48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e4d:	75 2c                	jne    800e7b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e4f:	a0 24 50 80 00       	mov    0x805024,%al
  800e54:	0f b6 c0             	movzbl %al,%eax
  800e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5a:	8b 12                	mov    (%edx),%edx
  800e5c:	89 d1                	mov    %edx,%ecx
  800e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e61:	83 c2 08             	add    $0x8,%edx
  800e64:	83 ec 04             	sub    $0x4,%esp
  800e67:	50                   	push   %eax
  800e68:	51                   	push   %ecx
  800e69:	52                   	push   %edx
  800e6a:	e8 70 11 00 00       	call   801fdf <sys_cputs>
  800e6f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	8b 40 04             	mov    0x4(%eax),%eax
  800e81:	8d 50 01             	lea    0x1(%eax),%edx
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e8a:	90                   	nop
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800e96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800e9d:	00 00 00 
	b.cnt = 0;
  800ea0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ea7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	ff 75 08             	pushl  0x8(%ebp)
  800eb0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800eb6:	50                   	push   %eax
  800eb7:	68 24 0e 80 00       	push   $0x800e24
  800ebc:	e8 11 02 00 00       	call   8010d2 <vprintfmt>
  800ec1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ec4:	a0 24 50 80 00       	mov    0x805024,%al
  800ec9:	0f b6 c0             	movzbl %al,%eax
  800ecc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	50                   	push   %eax
  800ed6:	52                   	push   %edx
  800ed7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800edd:	83 c0 08             	add    $0x8,%eax
  800ee0:	50                   	push   %eax
  800ee1:	e8 f9 10 00 00       	call   801fdf <sys_cputs>
  800ee6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ee9:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800ef0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800efe:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f05:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 f4             	pushl  -0xc(%ebp)
  800f14:	50                   	push   %eax
  800f15:	e8 73 ff ff ff       	call   800e8d <vcprintf>
  800f1a:	83 c4 10             	add    $0x10,%esp
  800f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f2b:	e8 5d 12 00 00       	call   80218d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f30:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3f:	50                   	push   %eax
  800f40:	e8 48 ff ff ff       	call   800e8d <vcprintf>
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f4b:	e8 57 12 00 00       	call   8021a7 <sys_enable_interrupt>
	return cnt;
  800f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	53                   	push   %ebx
  800f59:	83 ec 14             	sub    $0x14,%esp
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f62:	8b 45 14             	mov    0x14(%ebp),%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f68:	8b 45 18             	mov    0x18(%ebp),%eax
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f73:	77 55                	ja     800fca <printnum+0x75>
  800f75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f78:	72 05                	jb     800f7f <printnum+0x2a>
  800f7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f7d:	77 4b                	ja     800fca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f7f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f82:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f85:	8b 45 18             	mov    0x18(%ebp),%eax
  800f88:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8d:	52                   	push   %edx
  800f8e:	50                   	push   %eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	ff 75 f0             	pushl  -0x10(%ebp)
  800f95:	e8 ca 2c 00 00       	call   803c64 <__udivdi3>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	ff 75 20             	pushl  0x20(%ebp)
  800fa3:	53                   	push   %ebx
  800fa4:	ff 75 18             	pushl  0x18(%ebp)
  800fa7:	52                   	push   %edx
  800fa8:	50                   	push   %eax
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 a1 ff ff ff       	call   800f55 <printnum>
  800fb4:	83 c4 20             	add    $0x20,%esp
  800fb7:	eb 1a                	jmp    800fd3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	ff 75 20             	pushl  0x20(%ebp)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	ff d0                	call   *%eax
  800fc7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fca:	ff 4d 1c             	decl   0x1c(%ebp)
  800fcd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fd1:	7f e6                	jg     800fb9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fd3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe1:	53                   	push   %ebx
  800fe2:	51                   	push   %ecx
  800fe3:	52                   	push   %edx
  800fe4:	50                   	push   %eax
  800fe5:	e8 8a 2d 00 00       	call   803d74 <__umoddi3>
  800fea:	83 c4 10             	add    $0x10,%esp
  800fed:	05 f4 43 80 00       	add    $0x8043f4,%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f be c0             	movsbl %al,%eax
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
}
  801006:	90                   	nop
  801007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80100f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801013:	7e 1c                	jle    801031 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8b 00                	mov    (%eax),%eax
  80101a:	8d 50 08             	lea    0x8(%eax),%edx
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	89 10                	mov    %edx,(%eax)
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	83 e8 08             	sub    $0x8,%eax
  80102a:	8b 50 04             	mov    0x4(%eax),%edx
  80102d:	8b 00                	mov    (%eax),%eax
  80102f:	eb 40                	jmp    801071 <getuint+0x65>
	else if (lflag)
  801031:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801035:	74 1e                	je     801055 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8b 00                	mov    (%eax),%eax
  80103c:	8d 50 04             	lea    0x4(%eax),%edx
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	89 10                	mov    %edx,(%eax)
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8b 00                	mov    (%eax),%eax
  801049:	83 e8 04             	sub    $0x4,%eax
  80104c:	8b 00                	mov    (%eax),%eax
  80104e:	ba 00 00 00 00       	mov    $0x0,%edx
  801053:	eb 1c                	jmp    801071 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8b 00                	mov    (%eax),%eax
  80105a:	8d 50 04             	lea    0x4(%eax),%edx
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 10                	mov    %edx,(%eax)
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8b 00                	mov    (%eax),%eax
  801067:	83 e8 04             	sub    $0x4,%eax
  80106a:	8b 00                	mov    (%eax),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801076:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80107a:	7e 1c                	jle    801098 <getint+0x25>
		return va_arg(*ap, long long);
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8b 00                	mov    (%eax),%eax
  801081:	8d 50 08             	lea    0x8(%eax),%edx
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	89 10                	mov    %edx,(%eax)
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	83 e8 08             	sub    $0x8,%eax
  801091:	8b 50 04             	mov    0x4(%eax),%edx
  801094:	8b 00                	mov    (%eax),%eax
  801096:	eb 38                	jmp    8010d0 <getint+0x5d>
	else if (lflag)
  801098:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109c:	74 1a                	je     8010b8 <getint+0x45>
		return va_arg(*ap, long);
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 50 04             	lea    0x4(%eax),%edx
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	89 10                	mov    %edx,(%eax)
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	83 e8 04             	sub    $0x4,%eax
  8010b3:	8b 00                	mov    (%eax),%eax
  8010b5:	99                   	cltd   
  8010b6:	eb 18                	jmp    8010d0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	8d 50 04             	lea    0x4(%eax),%edx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	89 10                	mov    %edx,(%eax)
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8b 00                	mov    (%eax),%eax
  8010ca:	83 e8 04             	sub    $0x4,%eax
  8010cd:	8b 00                	mov    (%eax),%eax
  8010cf:	99                   	cltd   
}
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
  8010d7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010da:	eb 17                	jmp    8010f3 <vprintfmt+0x21>
			if (ch == '\0')
  8010dc:	85 db                	test   %ebx,%ebx
  8010de:	0f 84 af 03 00 00    	je     801493 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	53                   	push   %ebx
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	ff d0                	call   *%eax
  8010f0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	8d 50 01             	lea    0x1(%eax),%edx
  8010f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	0f b6 d8             	movzbl %al,%ebx
  801101:	83 fb 25             	cmp    $0x25,%ebx
  801104:	75 d6                	jne    8010dc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801106:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80110a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801111:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801118:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80111f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801126:	8b 45 10             	mov    0x10(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 10             	mov    %edx,0x10(%ebp)
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d8             	movzbl %al,%ebx
  801134:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801137:	83 f8 55             	cmp    $0x55,%eax
  80113a:	0f 87 2b 03 00 00    	ja     80146b <vprintfmt+0x399>
  801140:	8b 04 85 18 44 80 00 	mov    0x804418(,%eax,4),%eax
  801147:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801149:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80114d:	eb d7                	jmp    801126 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80114f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801153:	eb d1                	jmp    801126 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801155:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80115c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80115f:	89 d0                	mov    %edx,%eax
  801161:	c1 e0 02             	shl    $0x2,%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	01 c0                	add    %eax,%eax
  801168:	01 d8                	add    %ebx,%eax
  80116a:	83 e8 30             	sub    $0x30,%eax
  80116d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801178:	83 fb 2f             	cmp    $0x2f,%ebx
  80117b:	7e 3e                	jle    8011bb <vprintfmt+0xe9>
  80117d:	83 fb 39             	cmp    $0x39,%ebx
  801180:	7f 39                	jg     8011bb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801182:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801185:	eb d5                	jmp    80115c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801187:	8b 45 14             	mov    0x14(%ebp),%eax
  80118a:	83 c0 04             	add    $0x4,%eax
  80118d:	89 45 14             	mov    %eax,0x14(%ebp)
  801190:	8b 45 14             	mov    0x14(%ebp),%eax
  801193:	83 e8 04             	sub    $0x4,%eax
  801196:	8b 00                	mov    (%eax),%eax
  801198:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80119b:	eb 1f                	jmp    8011bc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80119d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a1:	79 83                	jns    801126 <vprintfmt+0x54>
				width = 0;
  8011a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011aa:	e9 77 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011af:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011b6:	e9 6b ff ff ff       	jmp    801126 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011bb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011c0:	0f 89 60 ff ff ff    	jns    801126 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011d3:	e9 4e ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011d8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011db:	e9 46 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	83 c0 04             	add    $0x4,%eax
  8011e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8011e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ec:	83 e8 04             	sub    $0x4,%eax
  8011ef:	8b 00                	mov    (%eax),%eax
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	50                   	push   %eax
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	ff d0                	call   *%eax
  8011fd:	83 c4 10             	add    $0x10,%esp
			break;
  801200:	e9 89 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801205:	8b 45 14             	mov    0x14(%ebp),%eax
  801208:	83 c0 04             	add    $0x4,%eax
  80120b:	89 45 14             	mov    %eax,0x14(%ebp)
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	83 e8 04             	sub    $0x4,%eax
  801214:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801216:	85 db                	test   %ebx,%ebx
  801218:	79 02                	jns    80121c <vprintfmt+0x14a>
				err = -err;
  80121a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80121c:	83 fb 64             	cmp    $0x64,%ebx
  80121f:	7f 0b                	jg     80122c <vprintfmt+0x15a>
  801221:	8b 34 9d 60 42 80 00 	mov    0x804260(,%ebx,4),%esi
  801228:	85 f6                	test   %esi,%esi
  80122a:	75 19                	jne    801245 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80122c:	53                   	push   %ebx
  80122d:	68 05 44 80 00       	push   $0x804405
  801232:	ff 75 0c             	pushl  0xc(%ebp)
  801235:	ff 75 08             	pushl  0x8(%ebp)
  801238:	e8 5e 02 00 00       	call   80149b <printfmt>
  80123d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801240:	e9 49 02 00 00       	jmp    80148e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801245:	56                   	push   %esi
  801246:	68 0e 44 80 00       	push   $0x80440e
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	ff 75 08             	pushl  0x8(%ebp)
  801251:	e8 45 02 00 00       	call   80149b <printfmt>
  801256:	83 c4 10             	add    $0x10,%esp
			break;
  801259:	e9 30 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80125e:	8b 45 14             	mov    0x14(%ebp),%eax
  801261:	83 c0 04             	add    $0x4,%eax
  801264:	89 45 14             	mov    %eax,0x14(%ebp)
  801267:	8b 45 14             	mov    0x14(%ebp),%eax
  80126a:	83 e8 04             	sub    $0x4,%eax
  80126d:	8b 30                	mov    (%eax),%esi
  80126f:	85 f6                	test   %esi,%esi
  801271:	75 05                	jne    801278 <vprintfmt+0x1a6>
				p = "(null)";
  801273:	be 11 44 80 00       	mov    $0x804411,%esi
			if (width > 0 && padc != '-')
  801278:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80127c:	7e 6d                	jle    8012eb <vprintfmt+0x219>
  80127e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801282:	74 67                	je     8012eb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	50                   	push   %eax
  80128b:	56                   	push   %esi
  80128c:	e8 0c 03 00 00       	call   80159d <strnlen>
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801297:	eb 16                	jmp    8012af <vprintfmt+0x1dd>
					putch(padc, putdat);
  801299:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	ff 75 0c             	pushl  0xc(%ebp)
  8012a3:	50                   	push   %eax
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	ff d0                	call   *%eax
  8012a9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8012af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b3:	7f e4                	jg     801299 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012b5:	eb 34                	jmp    8012eb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012bb:	74 1c                	je     8012d9 <vprintfmt+0x207>
  8012bd:	83 fb 1f             	cmp    $0x1f,%ebx
  8012c0:	7e 05                	jle    8012c7 <vprintfmt+0x1f5>
  8012c2:	83 fb 7e             	cmp    $0x7e,%ebx
  8012c5:	7e 12                	jle    8012d9 <vprintfmt+0x207>
					putch('?', putdat);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	6a 3f                	push   $0x3f
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	ff d0                	call   *%eax
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	eb 0f                	jmp    8012e8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	53                   	push   %ebx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	ff d0                	call   *%eax
  8012e5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8012eb:	89 f0                	mov    %esi,%eax
  8012ed:	8d 70 01             	lea    0x1(%eax),%esi
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	0f be d8             	movsbl %al,%ebx
  8012f5:	85 db                	test   %ebx,%ebx
  8012f7:	74 24                	je     80131d <vprintfmt+0x24b>
  8012f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012fd:	78 b8                	js     8012b7 <vprintfmt+0x1e5>
  8012ff:	ff 4d e0             	decl   -0x20(%ebp)
  801302:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801306:	79 af                	jns    8012b7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801308:	eb 13                	jmp    80131d <vprintfmt+0x24b>
				putch(' ', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 20                	push   $0x20
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80131a:	ff 4d e4             	decl   -0x1c(%ebp)
  80131d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801321:	7f e7                	jg     80130a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801323:	e9 66 01 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	ff 75 e8             	pushl  -0x18(%ebp)
  80132e:	8d 45 14             	lea    0x14(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	e8 3c fd ff ff       	call   801073 <getint>
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80133d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801346:	85 d2                	test   %edx,%edx
  801348:	79 23                	jns    80136d <vprintfmt+0x29b>
				putch('-', putdat);
  80134a:	83 ec 08             	sub    $0x8,%esp
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	6a 2d                	push   $0x2d
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	ff d0                	call   *%eax
  801357:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801360:	f7 d8                	neg    %eax
  801362:	83 d2 00             	adc    $0x0,%edx
  801365:	f7 da                	neg    %edx
  801367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80136a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80136d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801374:	e9 bc 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801379:	83 ec 08             	sub    $0x8,%esp
  80137c:	ff 75 e8             	pushl  -0x18(%ebp)
  80137f:	8d 45 14             	lea    0x14(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	e8 84 fc ff ff       	call   80100c <getuint>
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80138e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801391:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801398:	e9 98 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	6a 58                	push   $0x58
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	ff d0                	call   *%eax
  8013aa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	6a 58                	push   $0x58
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	ff d0                	call   *%eax
  8013ba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	6a 58                	push   $0x58
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	ff d0                	call   *%eax
  8013ca:	83 c4 10             	add    $0x10,%esp
			break;
  8013cd:	e9 bc 00 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	6a 30                	push   $0x30
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	ff d0                	call   *%eax
  8013df:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	ff 75 0c             	pushl  0xc(%ebp)
  8013e8:	6a 78                	push   $0x78
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	ff d0                	call   *%eax
  8013ef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8013f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f5:	83 c0 04             	add    $0x4,%eax
  8013f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8013fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fe:	83 e8 04             	sub    $0x4,%eax
  801401:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80140d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801414:	eb 1f                	jmp    801435 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	ff 75 e8             	pushl  -0x18(%ebp)
  80141c:	8d 45 14             	lea    0x14(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	e8 e7 fb ff ff       	call   80100c <getuint>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80142e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801435:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	52                   	push   %edx
  801440:	ff 75 e4             	pushl  -0x1c(%ebp)
  801443:	50                   	push   %eax
  801444:	ff 75 f4             	pushl  -0xc(%ebp)
  801447:	ff 75 f0             	pushl  -0x10(%ebp)
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	ff 75 08             	pushl  0x8(%ebp)
  801450:	e8 00 fb ff ff       	call   800f55 <printnum>
  801455:	83 c4 20             	add    $0x20,%esp
			break;
  801458:	eb 34                	jmp    80148e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	53                   	push   %ebx
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	ff d0                	call   *%eax
  801466:	83 c4 10             	add    $0x10,%esp
			break;
  801469:	eb 23                	jmp    80148e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	6a 25                	push   $0x25
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	ff d0                	call   *%eax
  801478:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80147b:	ff 4d 10             	decl   0x10(%ebp)
  80147e:	eb 03                	jmp    801483 <vprintfmt+0x3b1>
  801480:	ff 4d 10             	decl   0x10(%ebp)
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	48                   	dec    %eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	3c 25                	cmp    $0x25,%al
  80148b:	75 f3                	jne    801480 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80148d:	90                   	nop
		}
	}
  80148e:	e9 47 fc ff ff       	jmp    8010da <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801493:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801494:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8014a4:	83 c0 04             	add    $0x4,%eax
  8014a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b0:	50                   	push   %eax
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	ff 75 08             	pushl  0x8(%ebp)
  8014b7:	e8 16 fc ff ff       	call   8010d2 <vprintfmt>
  8014bc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014bf:	90                   	nop
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	8b 40 08             	mov    0x8(%eax),%eax
  8014cb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d7:	8b 10                	mov    (%eax),%edx
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	8b 40 04             	mov    0x4(%eax),%eax
  8014df:	39 c2                	cmp    %eax,%edx
  8014e1:	73 12                	jae    8014f5 <sprintputch+0x33>
		*b->buf++ = ch;
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	89 0a                	mov    %ecx,(%edx)
  8014f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f3:	88 10                	mov    %dl,(%eax)
}
  8014f5:	90                   	nop
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801512:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801519:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151d:	74 06                	je     801525 <vsnprintf+0x2d>
  80151f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801523:	7f 07                	jg     80152c <vsnprintf+0x34>
		return -E_INVAL;
  801525:	b8 03 00 00 00       	mov    $0x3,%eax
  80152a:	eb 20                	jmp    80154c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80152c:	ff 75 14             	pushl  0x14(%ebp)
  80152f:	ff 75 10             	pushl  0x10(%ebp)
  801532:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	68 c2 14 80 00       	push   $0x8014c2
  80153b:	e8 92 fb ff ff       	call   8010d2 <vprintfmt>
  801540:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801546:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801554:	8d 45 10             	lea    0x10(%ebp),%eax
  801557:	83 c0 04             	add    $0x4,%eax
  80155a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	ff 75 f4             	pushl  -0xc(%ebp)
  801563:	50                   	push   %eax
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	ff 75 08             	pushl  0x8(%ebp)
  80156a:	e8 89 ff ff ff       	call   8014f8 <vsnprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801587:	eb 06                	jmp    80158f <strlen+0x15>
		n++;
  801589:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80158c:	ff 45 08             	incl   0x8(%ebp)
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	84 c0                	test   %al,%al
  801596:	75 f1                	jne    801589 <strlen+0xf>
		n++;
	return n;
  801598:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015aa:	eb 09                	jmp    8015b5 <strnlen+0x18>
		n++;
  8015ac:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	ff 4d 0c             	decl   0xc(%ebp)
  8015b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b9:	74 09                	je     8015c4 <strnlen+0x27>
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	84 c0                	test   %al,%al
  8015c2:	75 e8                	jne    8015ac <strnlen+0xf>
		n++;
	return n;
  8015c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015d5:	90                   	nop
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8d 50 01             	lea    0x1(%eax),%edx
  8015dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8015df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015e8:	8a 12                	mov    (%edx),%dl
  8015ea:	88 10                	mov    %dl,(%eax)
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	84 c0                	test   %al,%al
  8015f0:	75 e4                	jne    8015d6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80160a:	eb 1f                	jmp    80162b <strncpy+0x34>
		*dst++ = *src;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8d 50 01             	lea    0x1(%eax),%edx
  801612:	89 55 08             	mov    %edx,0x8(%ebp)
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8a 12                	mov    (%edx),%dl
  80161a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	84 c0                	test   %al,%al
  801623:	74 03                	je     801628 <strncpy+0x31>
			src++;
  801625:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801628:	ff 45 fc             	incl   -0x4(%ebp)
  80162b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801631:	72 d9                	jb     80160c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801633:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801644:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801648:	74 30                	je     80167a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80164a:	eb 16                	jmp    801662 <strlcpy+0x2a>
			*dst++ = *src++;
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8d 50 01             	lea    0x1(%eax),%edx
  801652:	89 55 08             	mov    %edx,0x8(%ebp)
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80165e:	8a 12                	mov    (%edx),%dl
  801660:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801662:	ff 4d 10             	decl   0x10(%ebp)
  801665:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801669:	74 09                	je     801674 <strlcpy+0x3c>
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	84 c0                	test   %al,%al
  801672:	75 d8                	jne    80164c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80167a:	8b 55 08             	mov    0x8(%ebp),%edx
  80167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801680:	29 c2                	sub    %eax,%edx
  801682:	89 d0                	mov    %edx,%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801689:	eb 06                	jmp    801691 <strcmp+0xb>
		p++, q++;
  80168b:	ff 45 08             	incl   0x8(%ebp)
  80168e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	84 c0                	test   %al,%al
  801698:	74 0e                	je     8016a8 <strcmp+0x22>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 10                	mov    (%eax),%dl
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	38 c2                	cmp    %al,%dl
  8016a6:	74 e3                	je     80168b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	0f b6 d0             	movzbl %al,%edx
  8016b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	0f b6 c0             	movzbl %al,%eax
  8016b8:	29 c2                	sub    %eax,%edx
  8016ba:	89 d0                	mov    %edx,%eax
}
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016c1:	eb 09                	jmp    8016cc <strncmp+0xe>
		n--, p++, q++;
  8016c3:	ff 4d 10             	decl   0x10(%ebp)
  8016c6:	ff 45 08             	incl   0x8(%ebp)
  8016c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d0:	74 17                	je     8016e9 <strncmp+0x2b>
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	84 c0                	test   %al,%al
  8016d9:	74 0e                	je     8016e9 <strncmp+0x2b>
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 10                	mov    (%eax),%dl
  8016e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	38 c2                	cmp    %al,%dl
  8016e7:	74 da                	je     8016c3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ed:	75 07                	jne    8016f6 <strncmp+0x38>
		return 0;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	eb 14                	jmp    80170a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	0f b6 d0             	movzbl %al,%edx
  8016fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801701:	8a 00                	mov    (%eax),%al
  801703:	0f b6 c0             	movzbl %al,%eax
  801706:	29 c2                	sub    %eax,%edx
  801708:	89 d0                	mov    %edx,%eax
}
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	8b 45 0c             	mov    0xc(%ebp),%eax
  801715:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801718:	eb 12                	jmp    80172c <strchr+0x20>
		if (*s == c)
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801722:	75 05                	jne    801729 <strchr+0x1d>
			return (char *) s;
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	eb 11                	jmp    80173a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801729:	ff 45 08             	incl   0x8(%ebp)
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	84 c0                	test   %al,%al
  801733:	75 e5                	jne    80171a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	8b 45 0c             	mov    0xc(%ebp),%eax
  801745:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801748:	eb 0d                	jmp    801757 <strfind+0x1b>
		if (*s == c)
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801752:	74 0e                	je     801762 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801754:	ff 45 08             	incl   0x8(%ebp)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	75 ea                	jne    80174a <strfind+0xe>
  801760:	eb 01                	jmp    801763 <strfind+0x27>
		if (*s == c)
			break;
  801762:	90                   	nop
	return (char *) s;
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801774:	8b 45 10             	mov    0x10(%ebp),%eax
  801777:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80177a:	eb 0e                	jmp    80178a <memset+0x22>
		*p++ = c;
  80177c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177f:	8d 50 01             	lea    0x1(%eax),%edx
  801782:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801785:	8b 55 0c             	mov    0xc(%ebp),%edx
  801788:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80178a:	ff 4d f8             	decl   -0x8(%ebp)
  80178d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801791:	79 e9                	jns    80177c <memset+0x14>
		*p++ = c;

	return v;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80179e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017aa:	eb 16                	jmp    8017c2 <memcpy+0x2a>
		*d++ = *s++;
  8017ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017af:	8d 50 01             	lea    0x1(%eax),%edx
  8017b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017bb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017be:	8a 12                	mov    (%edx),%dl
  8017c0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	75 dd                	jne    8017ac <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017ec:	73 50                	jae    80183e <memmove+0x6a>
  8017ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	01 d0                	add    %edx,%eax
  8017f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f9:	76 43                	jbe    80183e <memmove+0x6a>
		s += n;
  8017fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801807:	eb 10                	jmp    801819 <memmove+0x45>
			*--d = *--s;
  801809:	ff 4d f8             	decl   -0x8(%ebp)
  80180c:	ff 4d fc             	decl   -0x4(%ebp)
  80180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801812:	8a 10                	mov    (%eax),%dl
  801814:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801817:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80181f:	89 55 10             	mov    %edx,0x10(%ebp)
  801822:	85 c0                	test   %eax,%eax
  801824:	75 e3                	jne    801809 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801826:	eb 23                	jmp    80184b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801828:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8d 4a 01             	lea    0x1(%edx),%ecx
  801837:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80183a:	8a 12                	mov    (%edx),%dl
  80183c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	8d 50 ff             	lea    -0x1(%eax),%edx
  801844:	89 55 10             	mov    %edx,0x10(%ebp)
  801847:	85 c0                	test   %eax,%eax
  801849:	75 dd                	jne    801828 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801862:	eb 2a                	jmp    80188e <memcmp+0x3e>
		if (*s1 != *s2)
  801864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801867:	8a 10                	mov    (%eax),%dl
  801869:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	38 c2                	cmp    %al,%dl
  801870:	74 16                	je     801888 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	0f b6 d0             	movzbl %al,%edx
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	8a 00                	mov    (%eax),%al
  80187f:	0f b6 c0             	movzbl %al,%eax
  801882:	29 c2                	sub    %eax,%edx
  801884:	89 d0                	mov    %edx,%eax
  801886:	eb 18                	jmp    8018a0 <memcmp+0x50>
		s1++, s2++;
  801888:	ff 45 fc             	incl   -0x4(%ebp)
  80188b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	8d 50 ff             	lea    -0x1(%eax),%edx
  801894:	89 55 10             	mov    %edx,0x10(%ebp)
  801897:	85 c0                	test   %eax,%eax
  801899:	75 c9                	jne    801864 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018b3:	eb 15                	jmp    8018ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	0f b6 c0             	movzbl %al,%eax
  8018c3:	39 c2                	cmp    %eax,%edx
  8018c5:	74 0d                	je     8018d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018c7:	ff 45 08             	incl   0x8(%ebp)
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018d0:	72 e3                	jb     8018b5 <memfind+0x13>
  8018d2:	eb 01                	jmp    8018d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018d4:	90                   	nop
	return (void *) s;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ee:	eb 03                	jmp    8018f3 <strtol+0x19>
		s++;
  8018f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	3c 20                	cmp    $0x20,%al
  8018fa:	74 f4                	je     8018f0 <strtol+0x16>
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	8a 00                	mov    (%eax),%al
  801901:	3c 09                	cmp    $0x9,%al
  801903:	74 eb                	je     8018f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	3c 2b                	cmp    $0x2b,%al
  80190c:	75 05                	jne    801913 <strtol+0x39>
		s++;
  80190e:	ff 45 08             	incl   0x8(%ebp)
  801911:	eb 13                	jmp    801926 <strtol+0x4c>
	else if (*s == '-')
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	3c 2d                	cmp    $0x2d,%al
  80191a:	75 0a                	jne    801926 <strtol+0x4c>
		s++, neg = 1;
  80191c:	ff 45 08             	incl   0x8(%ebp)
  80191f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801926:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192a:	74 06                	je     801932 <strtol+0x58>
  80192c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801930:	75 20                	jne    801952 <strtol+0x78>
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	3c 30                	cmp    $0x30,%al
  801939:	75 17                	jne    801952 <strtol+0x78>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	40                   	inc    %eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	3c 78                	cmp    $0x78,%al
  801943:	75 0d                	jne    801952 <strtol+0x78>
		s += 2, base = 16;
  801945:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801949:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801950:	eb 28                	jmp    80197a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801952:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801956:	75 15                	jne    80196d <strtol+0x93>
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8a 00                	mov    (%eax),%al
  80195d:	3c 30                	cmp    $0x30,%al
  80195f:	75 0c                	jne    80196d <strtol+0x93>
		s++, base = 8;
  801961:	ff 45 08             	incl   0x8(%ebp)
  801964:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80196b:	eb 0d                	jmp    80197a <strtol+0xa0>
	else if (base == 0)
  80196d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801971:	75 07                	jne    80197a <strtol+0xa0>
		base = 10;
  801973:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8a 00                	mov    (%eax),%al
  80197f:	3c 2f                	cmp    $0x2f,%al
  801981:	7e 19                	jle    80199c <strtol+0xc2>
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	3c 39                	cmp    $0x39,%al
  80198a:	7f 10                	jg     80199c <strtol+0xc2>
			dig = *s - '0';
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	0f be c0             	movsbl %al,%eax
  801994:	83 e8 30             	sub    $0x30,%eax
  801997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199a:	eb 42                	jmp    8019de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	3c 60                	cmp    $0x60,%al
  8019a3:	7e 19                	jle    8019be <strtol+0xe4>
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8a 00                	mov    (%eax),%al
  8019aa:	3c 7a                	cmp    $0x7a,%al
  8019ac:	7f 10                	jg     8019be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8a 00                	mov    (%eax),%al
  8019b3:	0f be c0             	movsbl %al,%eax
  8019b6:	83 e8 57             	sub    $0x57,%eax
  8019b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019bc:	eb 20                	jmp    8019de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 40                	cmp    $0x40,%al
  8019c5:	7e 39                	jle    801a00 <strtol+0x126>
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8a 00                	mov    (%eax),%al
  8019cc:	3c 5a                	cmp    $0x5a,%al
  8019ce:	7f 30                	jg     801a00 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8a 00                	mov    (%eax),%al
  8019d5:	0f be c0             	movsbl %al,%eax
  8019d8:	83 e8 37             	sub    $0x37,%eax
  8019db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019e4:	7d 19                	jge    8019ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019e6:	ff 45 08             	incl   0x8(%ebp)
  8019e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019f0:	89 c2                	mov    %eax,%edx
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019fa:	e9 7b ff ff ff       	jmp    80197a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a04:	74 08                	je     801a0e <strtol+0x134>
		*endptr = (char *) s;
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a12:	74 07                	je     801a1b <strtol+0x141>
  801a14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a17:	f7 d8                	neg    %eax
  801a19:	eb 03                	jmp    801a1e <strtol+0x144>
  801a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <ltostr>:

void
ltostr(long value, char *str)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a38:	79 13                	jns    801a4d <ltostr+0x2d>
	{
		neg = 1;
  801a3a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a47:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a4a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a55:	99                   	cltd   
  801a56:	f7 f9                	idiv   %ecx
  801a58:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	8d 50 01             	lea    0x1(%eax),%edx
  801a61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a64:	89 c2                	mov    %eax,%edx
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a6e:	83 c2 30             	add    $0x30,%edx
  801a71:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a76:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a7b:	f7 e9                	imul   %ecx
  801a7d:	c1 fa 02             	sar    $0x2,%edx
  801a80:	89 c8                	mov    %ecx,%eax
  801a82:	c1 f8 1f             	sar    $0x1f,%eax
  801a85:	29 c2                	sub    %eax,%edx
  801a87:	89 d0                	mov    %edx,%eax
  801a89:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801a8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a8f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a94:	f7 e9                	imul   %ecx
  801a96:	c1 fa 02             	sar    $0x2,%edx
  801a99:	89 c8                	mov    %ecx,%eax
  801a9b:	c1 f8 1f             	sar    $0x1f,%eax
  801a9e:	29 c2                	sub    %eax,%edx
  801aa0:	89 d0                	mov    %edx,%eax
  801aa2:	c1 e0 02             	shl    $0x2,%eax
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	01 c0                	add    %eax,%eax
  801aa9:	29 c1                	sub    %eax,%ecx
  801aab:	89 ca                	mov    %ecx,%edx
  801aad:	85 d2                	test   %edx,%edx
  801aaf:	75 9c                	jne    801a4d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ab1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abb:	48                   	dec    %eax
  801abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ac3:	74 3d                	je     801b02 <ltostr+0xe2>
		start = 1 ;
  801ac5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801acc:	eb 34                	jmp    801b02 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad4:	01 d0                	add    %edx,%eax
  801ad6:	8a 00                	mov    (%eax),%al
  801ad8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae1:	01 c2                	add    %eax,%edx
  801ae3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae9:	01 c8                	add    %ecx,%eax
  801aeb:	8a 00                	mov    (%eax),%al
  801aed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801aef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	01 c2                	add    %eax,%edx
  801af7:	8a 45 eb             	mov    -0x15(%ebp),%al
  801afa:	88 02                	mov    %al,(%edx)
		start++ ;
  801afc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801aff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b08:	7c c4                	jl     801ace <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b10:	01 d0                	add    %edx,%eax
  801b12:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	e8 54 fa ff ff       	call   80157a <strlen>
  801b26:	83 c4 04             	add    $0x4,%esp
  801b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	e8 46 fa ff ff       	call   80157a <strlen>
  801b34:	83 c4 04             	add    $0x4,%esp
  801b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b48:	eb 17                	jmp    801b61 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b50:	01 c2                	add    %eax,%edx
  801b52:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	01 c8                	add    %ecx,%eax
  801b5a:	8a 00                	mov    (%eax),%al
  801b5c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b5e:	ff 45 fc             	incl   -0x4(%ebp)
  801b61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b67:	7c e1                	jl     801b4a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b69:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b77:	eb 1f                	jmp    801b98 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b7c:	8d 50 01             	lea    0x1(%eax),%edx
  801b7f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b82:	89 c2                	mov    %eax,%edx
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	01 c2                	add    %eax,%edx
  801b89:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8f:	01 c8                	add    %ecx,%eax
  801b91:	8a 00                	mov    (%eax),%al
  801b93:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b95:	ff 45 f8             	incl   -0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b9e:	7c d9                	jl     801b79 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ba0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba6:	01 d0                	add    %edx,%eax
  801ba8:	c6 00 00             	movb   $0x0,(%eax)
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bba:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbd:	8b 00                	mov    (%eax),%eax
  801bbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc9:	01 d0                	add    %edx,%eax
  801bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bd1:	eb 0c                	jmp    801bdf <strsplit+0x31>
			*string++ = 0;
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	8d 50 01             	lea    0x1(%eax),%edx
  801bd9:	89 55 08             	mov    %edx,0x8(%ebp)
  801bdc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	8a 00                	mov    (%eax),%al
  801be4:	84 c0                	test   %al,%al
  801be6:	74 18                	je     801c00 <strsplit+0x52>
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	8a 00                	mov    (%eax),%al
  801bed:	0f be c0             	movsbl %al,%eax
  801bf0:	50                   	push   %eax
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	e8 13 fb ff ff       	call   80170c <strchr>
  801bf9:	83 c4 08             	add    $0x8,%esp
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	75 d3                	jne    801bd3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	8a 00                	mov    (%eax),%al
  801c05:	84 c0                	test   %al,%al
  801c07:	74 5a                	je     801c63 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c09:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0c:	8b 00                	mov    (%eax),%eax
  801c0e:	83 f8 0f             	cmp    $0xf,%eax
  801c11:	75 07                	jne    801c1a <strsplit+0x6c>
		{
			return 0;
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
  801c18:	eb 66                	jmp    801c80 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1d:	8b 00                	mov    (%eax),%eax
  801c1f:	8d 48 01             	lea    0x1(%eax),%ecx
  801c22:	8b 55 14             	mov    0x14(%ebp),%edx
  801c25:	89 0a                	mov    %ecx,(%edx)
  801c27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c31:	01 c2                	add    %eax,%edx
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c38:	eb 03                	jmp    801c3d <strsplit+0x8f>
			string++;
  801c3a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	8a 00                	mov    (%eax),%al
  801c42:	84 c0                	test   %al,%al
  801c44:	74 8b                	je     801bd1 <strsplit+0x23>
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8a 00                	mov    (%eax),%al
  801c4b:	0f be c0             	movsbl %al,%eax
  801c4e:	50                   	push   %eax
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	e8 b5 fa ff ff       	call   80170c <strchr>
  801c57:	83 c4 08             	add    $0x8,%esp
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	74 dc                	je     801c3a <strsplit+0x8c>
			string++;
	}
  801c5e:	e9 6e ff ff ff       	jmp    801bd1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c63:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	8b 00                	mov    (%eax),%eax
  801c69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c70:	8b 45 10             	mov    0x10(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c7b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801c88:	a1 04 50 80 00       	mov    0x805004,%eax
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	74 1f                	je     801cb0 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801c91:	e8 1d 00 00 00       	call   801cb3 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801c96:	83 ec 0c             	sub    $0xc,%esp
  801c99:	68 70 45 80 00       	push   $0x804570
  801c9e:	e8 55 f2 ff ff       	call   800ef8 <cprintf>
  801ca3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ca6:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cad:	00 00 00 
	}
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801cb9:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801cc0:	00 00 00 
  801cc3:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801cca:	00 00 00 
  801ccd:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801cd4:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801cd7:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801cde:	00 00 00 
  801ce1:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801ce8:	00 00 00 
  801ceb:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801cf2:	00 00 00 
	uint32 arr_size = 0;
  801cf5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801cfc:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d0b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d10:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801d15:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d1c:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801d1f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d26:	a1 20 51 80 00       	mov    0x805120,%eax
  801d2b:	c1 e0 04             	shl    $0x4,%eax
  801d2e:	89 c2                	mov    %eax,%edx
  801d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d33:	01 d0                	add    %edx,%eax
  801d35:	48                   	dec    %eax
  801d36:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d41:	f7 75 ec             	divl   -0x14(%ebp)
  801d44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d47:	29 d0                	sub    %edx,%eax
  801d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801d4c:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801d53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d5b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	6a 03                	push   $0x3
  801d65:	ff 75 f4             	pushl  -0xc(%ebp)
  801d68:	50                   	push   %eax
  801d69:	e8 b5 03 00 00       	call   802123 <sys_allocate_chunk>
  801d6e:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801d71:	a1 20 51 80 00       	mov    0x805120,%eax
  801d76:	83 ec 0c             	sub    $0xc,%esp
  801d79:	50                   	push   %eax
  801d7a:	e8 2a 0a 00 00       	call   8027a9 <initialize_MemBlocksList>
  801d7f:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801d82:	a1 48 51 80 00       	mov    0x805148,%eax
  801d87:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801d8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d8d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d97:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801d9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801da2:	75 14                	jne    801db8 <initialize_dyn_block_system+0x105>
  801da4:	83 ec 04             	sub    $0x4,%esp
  801da7:	68 95 45 80 00       	push   $0x804595
  801dac:	6a 33                	push   $0x33
  801dae:	68 b3 45 80 00       	push   $0x8045b3
  801db3:	e8 8c ee ff ff       	call   800c44 <_panic>
  801db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dbb:	8b 00                	mov    (%eax),%eax
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	74 10                	je     801dd1 <initialize_dyn_block_system+0x11e>
  801dc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc4:	8b 00                	mov    (%eax),%eax
  801dc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dc9:	8b 52 04             	mov    0x4(%edx),%edx
  801dcc:	89 50 04             	mov    %edx,0x4(%eax)
  801dcf:	eb 0b                	jmp    801ddc <initialize_dyn_block_system+0x129>
  801dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dd4:	8b 40 04             	mov    0x4(%eax),%eax
  801dd7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ddc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ddf:	8b 40 04             	mov    0x4(%eax),%eax
  801de2:	85 c0                	test   %eax,%eax
  801de4:	74 0f                	je     801df5 <initialize_dyn_block_system+0x142>
  801de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de9:	8b 40 04             	mov    0x4(%eax),%eax
  801dec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801def:	8b 12                	mov    (%edx),%edx
  801df1:	89 10                	mov    %edx,(%eax)
  801df3:	eb 0a                	jmp    801dff <initialize_dyn_block_system+0x14c>
  801df5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df8:	8b 00                	mov    (%eax),%eax
  801dfa:	a3 48 51 80 00       	mov    %eax,0x805148
  801dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e12:	a1 54 51 80 00       	mov    0x805154,%eax
  801e17:	48                   	dec    %eax
  801e18:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801e1d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e21:	75 14                	jne    801e37 <initialize_dyn_block_system+0x184>
  801e23:	83 ec 04             	sub    $0x4,%esp
  801e26:	68 c0 45 80 00       	push   $0x8045c0
  801e2b:	6a 34                	push   $0x34
  801e2d:	68 b3 45 80 00       	push   $0x8045b3
  801e32:	e8 0d ee ff ff       	call   800c44 <_panic>
  801e37:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e40:	89 10                	mov    %edx,(%eax)
  801e42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e45:	8b 00                	mov    (%eax),%eax
  801e47:	85 c0                	test   %eax,%eax
  801e49:	74 0d                	je     801e58 <initialize_dyn_block_system+0x1a5>
  801e4b:	a1 38 51 80 00       	mov    0x805138,%eax
  801e50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e53:	89 50 04             	mov    %edx,0x4(%eax)
  801e56:	eb 08                	jmp    801e60 <initialize_dyn_block_system+0x1ad>
  801e58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801e60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e63:	a3 38 51 80 00       	mov    %eax,0x805138
  801e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e72:	a1 44 51 80 00       	mov    0x805144,%eax
  801e77:	40                   	inc    %eax
  801e78:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801e7d:	90                   	nop
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e86:	e8 f7 fd ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e8f:	75 07                	jne    801e98 <malloc+0x18>
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	eb 14                	jmp    801eac <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801e98:	83 ec 04             	sub    $0x4,%esp
  801e9b:	68 e4 45 80 00       	push   $0x8045e4
  801ea0:	6a 46                	push   $0x46
  801ea2:	68 b3 45 80 00       	push   $0x8045b3
  801ea7:	e8 98 ed ff ff       	call   800c44 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801eb4:	83 ec 04             	sub    $0x4,%esp
  801eb7:	68 0c 46 80 00       	push   $0x80460c
  801ebc:	6a 61                	push   $0x61
  801ebe:	68 b3 45 80 00       	push   $0x8045b3
  801ec3:	e8 7c ed ff ff       	call   800c44 <_panic>

00801ec8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 18             	sub    $0x18,%esp
  801ece:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed1:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ed4:	e8 a9 fd ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ed9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801edd:	75 07                	jne    801ee6 <smalloc+0x1e>
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee4:	eb 14                	jmp    801efa <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801ee6:	83 ec 04             	sub    $0x4,%esp
  801ee9:	68 30 46 80 00       	push   $0x804630
  801eee:	6a 76                	push   $0x76
  801ef0:	68 b3 45 80 00       	push   $0x8045b3
  801ef5:	e8 4a ed ff ff       	call   800c44 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f02:	e8 7b fd ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801f07:	83 ec 04             	sub    $0x4,%esp
  801f0a:	68 58 46 80 00       	push   $0x804658
  801f0f:	68 93 00 00 00       	push   $0x93
  801f14:	68 b3 45 80 00       	push   $0x8045b3
  801f19:	e8 26 ed ff ff       	call   800c44 <_panic>

00801f1e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f24:	e8 59 fd ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f29:	83 ec 04             	sub    $0x4,%esp
  801f2c:	68 7c 46 80 00       	push   $0x80467c
  801f31:	68 c5 00 00 00       	push   $0xc5
  801f36:	68 b3 45 80 00       	push   $0x8045b3
  801f3b:	e8 04 ed ff ff       	call   800c44 <_panic>

00801f40 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f46:	83 ec 04             	sub    $0x4,%esp
  801f49:	68 a4 46 80 00       	push   $0x8046a4
  801f4e:	68 d9 00 00 00       	push   $0xd9
  801f53:	68 b3 45 80 00       	push   $0x8045b3
  801f58:	e8 e7 ec ff ff       	call   800c44 <_panic>

00801f5d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f63:	83 ec 04             	sub    $0x4,%esp
  801f66:	68 c8 46 80 00       	push   $0x8046c8
  801f6b:	68 e4 00 00 00       	push   $0xe4
  801f70:	68 b3 45 80 00       	push   $0x8045b3
  801f75:	e8 ca ec ff ff       	call   800c44 <_panic>

00801f7a <shrink>:

}
void shrink(uint32 newSize)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f80:	83 ec 04             	sub    $0x4,%esp
  801f83:	68 c8 46 80 00       	push   $0x8046c8
  801f88:	68 e9 00 00 00       	push   $0xe9
  801f8d:	68 b3 45 80 00       	push   $0x8045b3
  801f92:	e8 ad ec ff ff       	call   800c44 <_panic>

00801f97 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	68 c8 46 80 00       	push   $0x8046c8
  801fa5:	68 ee 00 00 00       	push   $0xee
  801faa:	68 b3 45 80 00       	push   $0x8045b3
  801faf:	e8 90 ec ff ff       	call   800c44 <_panic>

00801fb4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	57                   	push   %edi
  801fb8:	56                   	push   %esi
  801fb9:	53                   	push   %ebx
  801fba:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fc6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fc9:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fcc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fcf:	cd 30                	int    $0x30
  801fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	5b                   	pop    %ebx
  801fdb:	5e                   	pop    %esi
  801fdc:	5f                   	pop    %edi
  801fdd:	5d                   	pop    %ebp
  801fde:	c3                   	ret    

00801fdf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 04             	sub    $0x4,%esp
  801fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801feb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	52                   	push   %edx
  801ff7:	ff 75 0c             	pushl  0xc(%ebp)
  801ffa:	50                   	push   %eax
  801ffb:	6a 00                	push   $0x0
  801ffd:	e8 b2 ff ff ff       	call   801fb4 <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
}
  802005:	90                   	nop
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_cgetc>:

int
sys_cgetc(void)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 01                	push   $0x1
  802017:	e8 98 ff ff ff       	call   801fb4 <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802024:	8b 55 0c             	mov    0xc(%ebp),%edx
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	52                   	push   %edx
  802031:	50                   	push   %eax
  802032:	6a 05                	push   $0x5
  802034:	e8 7b ff ff ff       	call   801fb4 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	56                   	push   %esi
  802042:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802043:	8b 75 18             	mov    0x18(%ebp),%esi
  802046:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802049:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204f:	8b 45 08             	mov    0x8(%ebp),%eax
  802052:	56                   	push   %esi
  802053:	53                   	push   %ebx
  802054:	51                   	push   %ecx
  802055:	52                   	push   %edx
  802056:	50                   	push   %eax
  802057:	6a 06                	push   $0x6
  802059:	e8 56 ff ff ff       	call   801fb4 <syscall>
  80205e:	83 c4 18             	add    $0x18,%esp
}
  802061:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802064:	5b                   	pop    %ebx
  802065:	5e                   	pop    %esi
  802066:	5d                   	pop    %ebp
  802067:	c3                   	ret    

00802068 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80206b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	52                   	push   %edx
  802078:	50                   	push   %eax
  802079:	6a 07                	push   $0x7
  80207b:	e8 34 ff ff ff       	call   801fb4 <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
}
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	ff 75 0c             	pushl  0xc(%ebp)
  802091:	ff 75 08             	pushl  0x8(%ebp)
  802094:	6a 08                	push   $0x8
  802096:	e8 19 ff ff ff       	call   801fb4 <syscall>
  80209b:	83 c4 18             	add    $0x18,%esp
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 09                	push   $0x9
  8020af:	e8 00 ff ff ff       	call   801fb4 <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 0a                	push   $0xa
  8020c8:	e8 e7 fe ff ff       	call   801fb4 <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 0b                	push   $0xb
  8020e1:	e8 ce fe ff ff       	call   801fb4 <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	ff 75 0c             	pushl  0xc(%ebp)
  8020f7:	ff 75 08             	pushl  0x8(%ebp)
  8020fa:	6a 0f                	push   $0xf
  8020fc:	e8 b3 fe ff ff       	call   801fb4 <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
	return;
  802104:	90                   	nop
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	ff 75 0c             	pushl  0xc(%ebp)
  802113:	ff 75 08             	pushl  0x8(%ebp)
  802116:	6a 10                	push   $0x10
  802118:	e8 97 fe ff ff       	call   801fb4 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
	return ;
  802120:	90                   	nop
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	ff 75 10             	pushl  0x10(%ebp)
  80212d:	ff 75 0c             	pushl  0xc(%ebp)
  802130:	ff 75 08             	pushl  0x8(%ebp)
  802133:	6a 11                	push   $0x11
  802135:	e8 7a fe ff ff       	call   801fb4 <syscall>
  80213a:	83 c4 18             	add    $0x18,%esp
	return ;
  80213d:	90                   	nop
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 0c                	push   $0xc
  80214f:	e8 60 fe ff ff       	call   801fb4 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	ff 75 08             	pushl  0x8(%ebp)
  802167:	6a 0d                	push   $0xd
  802169:	e8 46 fe ff ff       	call   801fb4 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 0e                	push   $0xe
  802182:	e8 2d fe ff ff       	call   801fb4 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	90                   	nop
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 13                	push   $0x13
  80219c:	e8 13 fe ff ff       	call   801fb4 <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
}
  8021a4:	90                   	nop
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 14                	push   $0x14
  8021b6:	e8 f9 fd ff ff       	call   801fb4 <syscall>
  8021bb:	83 c4 18             	add    $0x18,%esp
}
  8021be:	90                   	nop
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	83 ec 04             	sub    $0x4,%esp
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021cd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	50                   	push   %eax
  8021da:	6a 15                	push   $0x15
  8021dc:	e8 d3 fd ff ff       	call   801fb4 <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
}
  8021e4:	90                   	nop
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 16                	push   $0x16
  8021f6:	e8 b9 fd ff ff       	call   801fb4 <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
}
  8021fe:	90                   	nop
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	ff 75 0c             	pushl  0xc(%ebp)
  802210:	50                   	push   %eax
  802211:	6a 17                	push   $0x17
  802213:	e8 9c fd ff ff       	call   801fb4 <syscall>
  802218:	83 c4 18             	add    $0x18,%esp
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802220:	8b 55 0c             	mov    0xc(%ebp),%edx
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	52                   	push   %edx
  80222d:	50                   	push   %eax
  80222e:	6a 1a                	push   $0x1a
  802230:	e8 7f fd ff ff       	call   801fb4 <syscall>
  802235:	83 c4 18             	add    $0x18,%esp
}
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80223d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	52                   	push   %edx
  80224a:	50                   	push   %eax
  80224b:	6a 18                	push   $0x18
  80224d:	e8 62 fd ff ff       	call   801fb4 <syscall>
  802252:	83 c4 18             	add    $0x18,%esp
}
  802255:	90                   	nop
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80225b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	52                   	push   %edx
  802268:	50                   	push   %eax
  802269:	6a 19                	push   $0x19
  80226b:	e8 44 fd ff ff       	call   801fb4 <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	90                   	nop
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	83 ec 04             	sub    $0x4,%esp
  80227c:	8b 45 10             	mov    0x10(%ebp),%eax
  80227f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802282:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802285:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	6a 00                	push   $0x0
  80228e:	51                   	push   %ecx
  80228f:	52                   	push   %edx
  802290:	ff 75 0c             	pushl  0xc(%ebp)
  802293:	50                   	push   %eax
  802294:	6a 1b                	push   $0x1b
  802296:	e8 19 fd ff ff       	call   801fb4 <syscall>
  80229b:	83 c4 18             	add    $0x18,%esp
}
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8022a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	52                   	push   %edx
  8022b0:	50                   	push   %eax
  8022b1:	6a 1c                	push   $0x1c
  8022b3:	e8 fc fc ff ff       	call   801fb4 <syscall>
  8022b8:	83 c4 18             	add    $0x18,%esp
}
  8022bb:	c9                   	leave  
  8022bc:	c3                   	ret    

008022bd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8022c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	51                   	push   %ecx
  8022ce:	52                   	push   %edx
  8022cf:	50                   	push   %eax
  8022d0:	6a 1d                	push   $0x1d
  8022d2:	e8 dd fc ff ff       	call   801fb4 <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	52                   	push   %edx
  8022ec:	50                   	push   %eax
  8022ed:	6a 1e                	push   $0x1e
  8022ef:	e8 c0 fc ff ff       	call   801fb4 <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 1f                	push   $0x1f
  802308:	e8 a7 fc ff ff       	call   801fb4 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	6a 00                	push   $0x0
  80231a:	ff 75 14             	pushl  0x14(%ebp)
  80231d:	ff 75 10             	pushl  0x10(%ebp)
  802320:	ff 75 0c             	pushl  0xc(%ebp)
  802323:	50                   	push   %eax
  802324:	6a 20                	push   $0x20
  802326:	e8 89 fc ff ff       	call   801fb4 <syscall>
  80232b:	83 c4 18             	add    $0x18,%esp
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	50                   	push   %eax
  80233f:	6a 21                	push   $0x21
  802341:	e8 6e fc ff ff       	call   801fb4 <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
}
  802349:	90                   	nop
  80234a:	c9                   	leave  
  80234b:	c3                   	ret    

0080234c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	50                   	push   %eax
  80235b:	6a 22                	push   $0x22
  80235d:	e8 52 fc ff ff       	call   801fb4 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 02                	push   $0x2
  802376:	e8 39 fc ff ff       	call   801fb4 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 03                	push   $0x3
  80238f:	e8 20 fc ff ff       	call   801fb4 <syscall>
  802394:	83 c4 18             	add    $0x18,%esp
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 04                	push   $0x4
  8023a8:	e8 07 fc ff ff       	call   801fb4 <syscall>
  8023ad:	83 c4 18             	add    $0x18,%esp
}
  8023b0:	c9                   	leave  
  8023b1:	c3                   	ret    

008023b2 <sys_exit_env>:


void sys_exit_env(void)
{
  8023b2:	55                   	push   %ebp
  8023b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 23                	push   $0x23
  8023c1:	e8 ee fb ff ff       	call   801fb4 <syscall>
  8023c6:	83 c4 18             	add    $0x18,%esp
}
  8023c9:	90                   	nop
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023d2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023d5:	8d 50 04             	lea    0x4(%eax),%edx
  8023d8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	52                   	push   %edx
  8023e2:	50                   	push   %eax
  8023e3:	6a 24                	push   $0x24
  8023e5:	e8 ca fb ff ff       	call   801fb4 <syscall>
  8023ea:	83 c4 18             	add    $0x18,%esp
	return result;
  8023ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023f6:	89 01                	mov    %eax,(%ecx)
  8023f8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	c9                   	leave  
  8023ff:	c2 04 00             	ret    $0x4

00802402 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	ff 75 10             	pushl  0x10(%ebp)
  80240c:	ff 75 0c             	pushl  0xc(%ebp)
  80240f:	ff 75 08             	pushl  0x8(%ebp)
  802412:	6a 12                	push   $0x12
  802414:	e8 9b fb ff ff       	call   801fb4 <syscall>
  802419:	83 c4 18             	add    $0x18,%esp
	return ;
  80241c:	90                   	nop
}
  80241d:	c9                   	leave  
  80241e:	c3                   	ret    

0080241f <sys_rcr2>:
uint32 sys_rcr2()
{
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 25                	push   $0x25
  80242e:	e8 81 fb ff ff       	call   801fb4 <syscall>
  802433:	83 c4 18             	add    $0x18,%esp
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	83 ec 04             	sub    $0x4,%esp
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802444:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	50                   	push   %eax
  802451:	6a 26                	push   $0x26
  802453:	e8 5c fb ff ff       	call   801fb4 <syscall>
  802458:	83 c4 18             	add    $0x18,%esp
	return ;
  80245b:	90                   	nop
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <rsttst>:
void rsttst()
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 28                	push   $0x28
  80246d:	e8 42 fb ff ff       	call   801fb4 <syscall>
  802472:	83 c4 18             	add    $0x18,%esp
	return ;
  802475:	90                   	nop
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
  80247b:	83 ec 04             	sub    $0x4,%esp
  80247e:	8b 45 14             	mov    0x14(%ebp),%eax
  802481:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802484:	8b 55 18             	mov    0x18(%ebp),%edx
  802487:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80248b:	52                   	push   %edx
  80248c:	50                   	push   %eax
  80248d:	ff 75 10             	pushl  0x10(%ebp)
  802490:	ff 75 0c             	pushl  0xc(%ebp)
  802493:	ff 75 08             	pushl  0x8(%ebp)
  802496:	6a 27                	push   $0x27
  802498:	e8 17 fb ff ff       	call   801fb4 <syscall>
  80249d:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a0:	90                   	nop
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    

008024a3 <chktst>:
void chktst(uint32 n)
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	ff 75 08             	pushl  0x8(%ebp)
  8024b1:	6a 29                	push   $0x29
  8024b3:	e8 fc fa ff ff       	call   801fb4 <syscall>
  8024b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8024bb:	90                   	nop
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <inctst>:

void inctst()
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 2a                	push   $0x2a
  8024cd:	e8 e2 fa ff ff       	call   801fb4 <syscall>
  8024d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d5:	90                   	nop
}
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <gettst>:
uint32 gettst()
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 2b                	push   $0x2b
  8024e7:	e8 c8 fa ff ff       	call   801fb4 <syscall>
  8024ec:	83 c4 18             	add    $0x18,%esp
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
  8024f4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 2c                	push   $0x2c
  802503:	e8 ac fa ff ff       	call   801fb4 <syscall>
  802508:	83 c4 18             	add    $0x18,%esp
  80250b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80250e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802512:	75 07                	jne    80251b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802514:	b8 01 00 00 00       	mov    $0x1,%eax
  802519:	eb 05                	jmp    802520 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80251b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
  802525:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 2c                	push   $0x2c
  802534:	e8 7b fa ff ff       	call   801fb4 <syscall>
  802539:	83 c4 18             	add    $0x18,%esp
  80253c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80253f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802543:	75 07                	jne    80254c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802545:	b8 01 00 00 00       	mov    $0x1,%eax
  80254a:	eb 05                	jmp    802551 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80254c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
  802556:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 2c                	push   $0x2c
  802565:	e8 4a fa ff ff       	call   801fb4 <syscall>
  80256a:	83 c4 18             	add    $0x18,%esp
  80256d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802570:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802574:	75 07                	jne    80257d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802576:	b8 01 00 00 00       	mov    $0x1,%eax
  80257b:	eb 05                	jmp    802582 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80257d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802582:	c9                   	leave  
  802583:	c3                   	ret    

00802584 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 2c                	push   $0x2c
  802596:	e8 19 fa ff ff       	call   801fb4 <syscall>
  80259b:	83 c4 18             	add    $0x18,%esp
  80259e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025a1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025a5:	75 07                	jne    8025ae <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ac:	eb 05                	jmp    8025b3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	ff 75 08             	pushl  0x8(%ebp)
  8025c3:	6a 2d                	push   $0x2d
  8025c5:	e8 ea f9 ff ff       	call   801fb4 <syscall>
  8025ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8025cd:	90                   	nop
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025d4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e0:	6a 00                	push   $0x0
  8025e2:	53                   	push   %ebx
  8025e3:	51                   	push   %ecx
  8025e4:	52                   	push   %edx
  8025e5:	50                   	push   %eax
  8025e6:	6a 2e                	push   $0x2e
  8025e8:	e8 c7 f9 ff ff       	call   801fb4 <syscall>
  8025ed:	83 c4 18             	add    $0x18,%esp
}
  8025f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	52                   	push   %edx
  802605:	50                   	push   %eax
  802606:	6a 2f                	push   $0x2f
  802608:	e8 a7 f9 ff ff       	call   801fb4 <syscall>
  80260d:	83 c4 18             	add    $0x18,%esp
}
  802610:	c9                   	leave  
  802611:	c3                   	ret    

00802612 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
  802615:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802618:	83 ec 0c             	sub    $0xc,%esp
  80261b:	68 d8 46 80 00       	push   $0x8046d8
  802620:	e8 d3 e8 ff ff       	call   800ef8 <cprintf>
  802625:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802628:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80262f:	83 ec 0c             	sub    $0xc,%esp
  802632:	68 04 47 80 00       	push   $0x804704
  802637:	e8 bc e8 ff ff       	call   800ef8 <cprintf>
  80263c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80263f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802643:	a1 38 51 80 00       	mov    0x805138,%eax
  802648:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264b:	eb 56                	jmp    8026a3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80264d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802651:	74 1c                	je     80266f <print_mem_block_lists+0x5d>
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	8b 50 08             	mov    0x8(%eax),%edx
  802659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265c:	8b 48 08             	mov    0x8(%eax),%ecx
  80265f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802662:	8b 40 0c             	mov    0xc(%eax),%eax
  802665:	01 c8                	add    %ecx,%eax
  802667:	39 c2                	cmp    %eax,%edx
  802669:	73 04                	jae    80266f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80266b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 50 08             	mov    0x8(%eax),%edx
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 40 0c             	mov    0xc(%eax),%eax
  80267b:	01 c2                	add    %eax,%edx
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 40 08             	mov    0x8(%eax),%eax
  802683:	83 ec 04             	sub    $0x4,%esp
  802686:	52                   	push   %edx
  802687:	50                   	push   %eax
  802688:	68 19 47 80 00       	push   $0x804719
  80268d:	e8 66 e8 ff ff       	call   800ef8 <cprintf>
  802692:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80269b:	a1 40 51 80 00       	mov    0x805140,%eax
  8026a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a7:	74 07                	je     8026b0 <print_mem_block_lists+0x9e>
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	eb 05                	jmp    8026b5 <print_mem_block_lists+0xa3>
  8026b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b5:	a3 40 51 80 00       	mov    %eax,0x805140
  8026ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	75 8a                	jne    80264d <print_mem_block_lists+0x3b>
  8026c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c7:	75 84                	jne    80264d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8026c9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026cd:	75 10                	jne    8026df <print_mem_block_lists+0xcd>
  8026cf:	83 ec 0c             	sub    $0xc,%esp
  8026d2:	68 28 47 80 00       	push   $0x804728
  8026d7:	e8 1c e8 ff ff       	call   800ef8 <cprintf>
  8026dc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8026df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8026e6:	83 ec 0c             	sub    $0xc,%esp
  8026e9:	68 4c 47 80 00       	push   $0x80474c
  8026ee:	e8 05 e8 ff ff       	call   800ef8 <cprintf>
  8026f3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8026f6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8026ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802702:	eb 56                	jmp    80275a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802704:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802708:	74 1c                	je     802726 <print_mem_block_lists+0x114>
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 50 08             	mov    0x8(%eax),%edx
  802710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802713:	8b 48 08             	mov    0x8(%eax),%ecx
  802716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802719:	8b 40 0c             	mov    0xc(%eax),%eax
  80271c:	01 c8                	add    %ecx,%eax
  80271e:	39 c2                	cmp    %eax,%edx
  802720:	73 04                	jae    802726 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802722:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 50 08             	mov    0x8(%eax),%edx
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 40 0c             	mov    0xc(%eax),%eax
  802732:	01 c2                	add    %eax,%edx
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 40 08             	mov    0x8(%eax),%eax
  80273a:	83 ec 04             	sub    $0x4,%esp
  80273d:	52                   	push   %edx
  80273e:	50                   	push   %eax
  80273f:	68 19 47 80 00       	push   $0x804719
  802744:	e8 af e7 ff ff       	call   800ef8 <cprintf>
  802749:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802752:	a1 48 50 80 00       	mov    0x805048,%eax
  802757:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275e:	74 07                	je     802767 <print_mem_block_lists+0x155>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	eb 05                	jmp    80276c <print_mem_block_lists+0x15a>
  802767:	b8 00 00 00 00       	mov    $0x0,%eax
  80276c:	a3 48 50 80 00       	mov    %eax,0x805048
  802771:	a1 48 50 80 00       	mov    0x805048,%eax
  802776:	85 c0                	test   %eax,%eax
  802778:	75 8a                	jne    802704 <print_mem_block_lists+0xf2>
  80277a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277e:	75 84                	jne    802704 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802780:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802784:	75 10                	jne    802796 <print_mem_block_lists+0x184>
  802786:	83 ec 0c             	sub    $0xc,%esp
  802789:	68 64 47 80 00       	push   $0x804764
  80278e:	e8 65 e7 ff ff       	call   800ef8 <cprintf>
  802793:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802796:	83 ec 0c             	sub    $0xc,%esp
  802799:	68 d8 46 80 00       	push   $0x8046d8
  80279e:	e8 55 e7 ff ff       	call   800ef8 <cprintf>
  8027a3:	83 c4 10             	add    $0x10,%esp

}
  8027a6:	90                   	nop
  8027a7:	c9                   	leave  
  8027a8:	c3                   	ret    

008027a9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8027a9:	55                   	push   %ebp
  8027aa:	89 e5                	mov    %esp,%ebp
  8027ac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8027af:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8027b6:	00 00 00 
  8027b9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8027c0:	00 00 00 
  8027c3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8027ca:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8027cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8027d4:	e9 9e 00 00 00       	jmp    802877 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8027d9:	a1 50 50 80 00       	mov    0x805050,%eax
  8027de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e1:	c1 e2 04             	shl    $0x4,%edx
  8027e4:	01 d0                	add    %edx,%eax
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	75 14                	jne    8027fe <initialize_MemBlocksList+0x55>
  8027ea:	83 ec 04             	sub    $0x4,%esp
  8027ed:	68 8c 47 80 00       	push   $0x80478c
  8027f2:	6a 46                	push   $0x46
  8027f4:	68 af 47 80 00       	push   $0x8047af
  8027f9:	e8 46 e4 ff ff       	call   800c44 <_panic>
  8027fe:	a1 50 50 80 00       	mov    0x805050,%eax
  802803:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802806:	c1 e2 04             	shl    $0x4,%edx
  802809:	01 d0                	add    %edx,%eax
  80280b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802811:	89 10                	mov    %edx,(%eax)
  802813:	8b 00                	mov    (%eax),%eax
  802815:	85 c0                	test   %eax,%eax
  802817:	74 18                	je     802831 <initialize_MemBlocksList+0x88>
  802819:	a1 48 51 80 00       	mov    0x805148,%eax
  80281e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802824:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802827:	c1 e1 04             	shl    $0x4,%ecx
  80282a:	01 ca                	add    %ecx,%edx
  80282c:	89 50 04             	mov    %edx,0x4(%eax)
  80282f:	eb 12                	jmp    802843 <initialize_MemBlocksList+0x9a>
  802831:	a1 50 50 80 00       	mov    0x805050,%eax
  802836:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802839:	c1 e2 04             	shl    $0x4,%edx
  80283c:	01 d0                	add    %edx,%eax
  80283e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802843:	a1 50 50 80 00       	mov    0x805050,%eax
  802848:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284b:	c1 e2 04             	shl    $0x4,%edx
  80284e:	01 d0                	add    %edx,%eax
  802850:	a3 48 51 80 00       	mov    %eax,0x805148
  802855:	a1 50 50 80 00       	mov    0x805050,%eax
  80285a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285d:	c1 e2 04             	shl    $0x4,%edx
  802860:	01 d0                	add    %edx,%eax
  802862:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802869:	a1 54 51 80 00       	mov    0x805154,%eax
  80286e:	40                   	inc    %eax
  80286f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802874:	ff 45 f4             	incl   -0xc(%ebp)
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287d:	0f 82 56 ff ff ff    	jb     8027d9 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802883:	90                   	nop
  802884:	c9                   	leave  
  802885:	c3                   	ret    

00802886 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
  802889:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802894:	eb 19                	jmp    8028af <find_block+0x29>
	{
		if(va==point->sva)
  802896:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802899:	8b 40 08             	mov    0x8(%eax),%eax
  80289c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80289f:	75 05                	jne    8028a6 <find_block+0x20>
		   return point;
  8028a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028a4:	eb 36                	jmp    8028dc <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	8b 40 08             	mov    0x8(%eax),%eax
  8028ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028af:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028b3:	74 07                	je     8028bc <find_block+0x36>
  8028b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028b8:	8b 00                	mov    (%eax),%eax
  8028ba:	eb 05                	jmp    8028c1 <find_block+0x3b>
  8028bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c4:	89 42 08             	mov    %eax,0x8(%edx)
  8028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ca:	8b 40 08             	mov    0x8(%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	75 c5                	jne    802896 <find_block+0x10>
  8028d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028d5:	75 bf                	jne    802896 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8028d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028dc:	c9                   	leave  
  8028dd:	c3                   	ret    

008028de <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8028de:	55                   	push   %ebp
  8028df:	89 e5                	mov    %esp,%ebp
  8028e1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8028e4:	a1 40 50 80 00       	mov    0x805040,%eax
  8028e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8028ec:	a1 44 50 80 00       	mov    0x805044,%eax
  8028f1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8028fa:	74 24                	je     802920 <insert_sorted_allocList+0x42>
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	8b 50 08             	mov    0x8(%eax),%edx
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	8b 40 08             	mov    0x8(%eax),%eax
  802908:	39 c2                	cmp    %eax,%edx
  80290a:	76 14                	jbe    802920 <insert_sorted_allocList+0x42>
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	8b 50 08             	mov    0x8(%eax),%edx
  802912:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802915:	8b 40 08             	mov    0x8(%eax),%eax
  802918:	39 c2                	cmp    %eax,%edx
  80291a:	0f 82 60 01 00 00    	jb     802a80 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802920:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802924:	75 65                	jne    80298b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802926:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80292a:	75 14                	jne    802940 <insert_sorted_allocList+0x62>
  80292c:	83 ec 04             	sub    $0x4,%esp
  80292f:	68 8c 47 80 00       	push   $0x80478c
  802934:	6a 6b                	push   $0x6b
  802936:	68 af 47 80 00       	push   $0x8047af
  80293b:	e8 04 e3 ff ff       	call   800c44 <_panic>
  802940:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	89 10                	mov    %edx,(%eax)
  80294b:	8b 45 08             	mov    0x8(%ebp),%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	74 0d                	je     802961 <insert_sorted_allocList+0x83>
  802954:	a1 40 50 80 00       	mov    0x805040,%eax
  802959:	8b 55 08             	mov    0x8(%ebp),%edx
  80295c:	89 50 04             	mov    %edx,0x4(%eax)
  80295f:	eb 08                	jmp    802969 <insert_sorted_allocList+0x8b>
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	a3 44 50 80 00       	mov    %eax,0x805044
  802969:	8b 45 08             	mov    0x8(%ebp),%eax
  80296c:	a3 40 50 80 00       	mov    %eax,0x805040
  802971:	8b 45 08             	mov    0x8(%ebp),%eax
  802974:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802980:	40                   	inc    %eax
  802981:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802986:	e9 dc 01 00 00       	jmp    802b67 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	8b 50 08             	mov    0x8(%eax),%edx
  802991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802994:	8b 40 08             	mov    0x8(%eax),%eax
  802997:	39 c2                	cmp    %eax,%edx
  802999:	77 6c                	ja     802a07 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80299b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80299f:	74 06                	je     8029a7 <insert_sorted_allocList+0xc9>
  8029a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029a5:	75 14                	jne    8029bb <insert_sorted_allocList+0xdd>
  8029a7:	83 ec 04             	sub    $0x4,%esp
  8029aa:	68 c8 47 80 00       	push   $0x8047c8
  8029af:	6a 6f                	push   $0x6f
  8029b1:	68 af 47 80 00       	push   $0x8047af
  8029b6:	e8 89 e2 ff ff       	call   800c44 <_panic>
  8029bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029be:	8b 50 04             	mov    0x4(%eax),%edx
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	89 50 04             	mov    %edx,0x4(%eax)
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029cd:	89 10                	mov    %edx,(%eax)
  8029cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d2:	8b 40 04             	mov    0x4(%eax),%eax
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	74 0d                	je     8029e6 <insert_sorted_allocList+0x108>
  8029d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dc:	8b 40 04             	mov    0x4(%eax),%eax
  8029df:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e2:	89 10                	mov    %edx,(%eax)
  8029e4:	eb 08                	jmp    8029ee <insert_sorted_allocList+0x110>
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	a3 40 50 80 00       	mov    %eax,0x805040
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f4:	89 50 04             	mov    %edx,0x4(%eax)
  8029f7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029fc:	40                   	inc    %eax
  8029fd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a02:	e9 60 01 00 00       	jmp    802b67 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	8b 50 08             	mov    0x8(%eax),%edx
  802a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a10:	8b 40 08             	mov    0x8(%eax),%eax
  802a13:	39 c2                	cmp    %eax,%edx
  802a15:	0f 82 4c 01 00 00    	jb     802b67 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802a1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a1f:	75 14                	jne    802a35 <insert_sorted_allocList+0x157>
  802a21:	83 ec 04             	sub    $0x4,%esp
  802a24:	68 00 48 80 00       	push   $0x804800
  802a29:	6a 73                	push   $0x73
  802a2b:	68 af 47 80 00       	push   $0x8047af
  802a30:	e8 0f e2 ff ff       	call   800c44 <_panic>
  802a35:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	89 50 04             	mov    %edx,0x4(%eax)
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	8b 40 04             	mov    0x4(%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 0c                	je     802a57 <insert_sorted_allocList+0x179>
  802a4b:	a1 44 50 80 00       	mov    0x805044,%eax
  802a50:	8b 55 08             	mov    0x8(%ebp),%edx
  802a53:	89 10                	mov    %edx,(%eax)
  802a55:	eb 08                	jmp    802a5f <insert_sorted_allocList+0x181>
  802a57:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5a:	a3 40 50 80 00       	mov    %eax,0x805040
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	a3 44 50 80 00       	mov    %eax,0x805044
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a70:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a75:	40                   	inc    %eax
  802a76:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a7b:	e9 e7 00 00 00       	jmp    802b67 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802a86:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a8d:	a1 40 50 80 00       	mov    0x805040,%eax
  802a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a95:	e9 9d 00 00 00       	jmp    802b37 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 00                	mov    (%eax),%eax
  802a9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	8b 50 08             	mov    0x8(%eax),%edx
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 40 08             	mov    0x8(%eax),%eax
  802aae:	39 c2                	cmp    %eax,%edx
  802ab0:	76 7d                	jbe    802b2f <insert_sorted_allocList+0x251>
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	8b 50 08             	mov    0x8(%eax),%edx
  802ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abb:	8b 40 08             	mov    0x8(%eax),%eax
  802abe:	39 c2                	cmp    %eax,%edx
  802ac0:	73 6d                	jae    802b2f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac6:	74 06                	je     802ace <insert_sorted_allocList+0x1f0>
  802ac8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802acc:	75 14                	jne    802ae2 <insert_sorted_allocList+0x204>
  802ace:	83 ec 04             	sub    $0x4,%esp
  802ad1:	68 24 48 80 00       	push   $0x804824
  802ad6:	6a 7f                	push   $0x7f
  802ad8:	68 af 47 80 00       	push   $0x8047af
  802add:	e8 62 e1 ff ff       	call   800c44 <_panic>
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	8b 10                	mov    (%eax),%edx
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	89 10                	mov    %edx,(%eax)
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	74 0b                	je     802b00 <insert_sorted_allocList+0x222>
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	8b 00                	mov    (%eax),%eax
  802afa:	8b 55 08             	mov    0x8(%ebp),%edx
  802afd:	89 50 04             	mov    %edx,0x4(%eax)
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 55 08             	mov    0x8(%ebp),%edx
  802b06:	89 10                	mov    %edx,(%eax)
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b0e:	89 50 04             	mov    %edx,0x4(%eax)
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	75 08                	jne    802b22 <insert_sorted_allocList+0x244>
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	a3 44 50 80 00       	mov    %eax,0x805044
  802b22:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b27:	40                   	inc    %eax
  802b28:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802b2d:	eb 39                	jmp    802b68 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b2f:	a1 48 50 80 00       	mov    0x805048,%eax
  802b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3b:	74 07                	je     802b44 <insert_sorted_allocList+0x266>
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	eb 05                	jmp    802b49 <insert_sorted_allocList+0x26b>
  802b44:	b8 00 00 00 00       	mov    $0x0,%eax
  802b49:	a3 48 50 80 00       	mov    %eax,0x805048
  802b4e:	a1 48 50 80 00       	mov    0x805048,%eax
  802b53:	85 c0                	test   %eax,%eax
  802b55:	0f 85 3f ff ff ff    	jne    802a9a <insert_sorted_allocList+0x1bc>
  802b5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5f:	0f 85 35 ff ff ff    	jne    802a9a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802b65:	eb 01                	jmp    802b68 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b67:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802b68:	90                   	nop
  802b69:	c9                   	leave  
  802b6a:	c3                   	ret    

00802b6b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b6b:	55                   	push   %ebp
  802b6c:	89 e5                	mov    %esp,%ebp
  802b6e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b71:	a1 38 51 80 00       	mov    0x805138,%eax
  802b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b79:	e9 85 01 00 00       	jmp    802d03 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 40 0c             	mov    0xc(%eax),%eax
  802b84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b87:	0f 82 6e 01 00 00    	jb     802cfb <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 40 0c             	mov    0xc(%eax),%eax
  802b93:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b96:	0f 85 8a 00 00 00    	jne    802c26 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802b9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba0:	75 17                	jne    802bb9 <alloc_block_FF+0x4e>
  802ba2:	83 ec 04             	sub    $0x4,%esp
  802ba5:	68 58 48 80 00       	push   $0x804858
  802baa:	68 93 00 00 00       	push   $0x93
  802baf:	68 af 47 80 00       	push   $0x8047af
  802bb4:	e8 8b e0 ff ff       	call   800c44 <_panic>
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 00                	mov    (%eax),%eax
  802bbe:	85 c0                	test   %eax,%eax
  802bc0:	74 10                	je     802bd2 <alloc_block_FF+0x67>
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 00                	mov    (%eax),%eax
  802bc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bca:	8b 52 04             	mov    0x4(%edx),%edx
  802bcd:	89 50 04             	mov    %edx,0x4(%eax)
  802bd0:	eb 0b                	jmp    802bdd <alloc_block_FF+0x72>
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 40 04             	mov    0x4(%eax),%eax
  802bd8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 40 04             	mov    0x4(%eax),%eax
  802be3:	85 c0                	test   %eax,%eax
  802be5:	74 0f                	je     802bf6 <alloc_block_FF+0x8b>
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 40 04             	mov    0x4(%eax),%eax
  802bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf0:	8b 12                	mov    (%edx),%edx
  802bf2:	89 10                	mov    %edx,(%eax)
  802bf4:	eb 0a                	jmp    802c00 <alloc_block_FF+0x95>
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	a3 38 51 80 00       	mov    %eax,0x805138
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c13:	a1 44 51 80 00       	mov    0x805144,%eax
  802c18:	48                   	dec    %eax
  802c19:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	e9 10 01 00 00       	jmp    802d36 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2f:	0f 86 c6 00 00 00    	jbe    802cfb <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c35:	a1 48 51 80 00       	mov    0x805148,%eax
  802c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 50 08             	mov    0x8(%eax),%edx
  802c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c46:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c56:	75 17                	jne    802c6f <alloc_block_FF+0x104>
  802c58:	83 ec 04             	sub    $0x4,%esp
  802c5b:	68 58 48 80 00       	push   $0x804858
  802c60:	68 9b 00 00 00       	push   $0x9b
  802c65:	68 af 47 80 00       	push   $0x8047af
  802c6a:	e8 d5 df ff ff       	call   800c44 <_panic>
  802c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c72:	8b 00                	mov    (%eax),%eax
  802c74:	85 c0                	test   %eax,%eax
  802c76:	74 10                	je     802c88 <alloc_block_FF+0x11d>
  802c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c80:	8b 52 04             	mov    0x4(%edx),%edx
  802c83:	89 50 04             	mov    %edx,0x4(%eax)
  802c86:	eb 0b                	jmp    802c93 <alloc_block_FF+0x128>
  802c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8b:	8b 40 04             	mov    0x4(%eax),%eax
  802c8e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c96:	8b 40 04             	mov    0x4(%eax),%eax
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	74 0f                	je     802cac <alloc_block_FF+0x141>
  802c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca0:	8b 40 04             	mov    0x4(%eax),%eax
  802ca3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca6:	8b 12                	mov    (%edx),%edx
  802ca8:	89 10                	mov    %edx,(%eax)
  802caa:	eb 0a                	jmp    802cb6 <alloc_block_FF+0x14b>
  802cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	a3 48 51 80 00       	mov    %eax,0x805148
  802cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc9:	a1 54 51 80 00       	mov    0x805154,%eax
  802cce:	48                   	dec    %eax
  802ccf:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 50 08             	mov    0x8(%eax),%edx
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	01 c2                	add    %eax,%edx
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ceb:	2b 45 08             	sub    0x8(%ebp),%eax
  802cee:	89 c2                	mov    %eax,%edx
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf9:	eb 3b                	jmp    802d36 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802cfb:	a1 40 51 80 00       	mov    0x805140,%eax
  802d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d07:	74 07                	je     802d10 <alloc_block_FF+0x1a5>
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	eb 05                	jmp    802d15 <alloc_block_FF+0x1aa>
  802d10:	b8 00 00 00 00       	mov    $0x0,%eax
  802d15:	a3 40 51 80 00       	mov    %eax,0x805140
  802d1a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	0f 85 57 fe ff ff    	jne    802b7e <alloc_block_FF+0x13>
  802d27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2b:	0f 85 4d fe ff ff    	jne    802b7e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802d31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d36:	c9                   	leave  
  802d37:	c3                   	ret    

00802d38 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d38:	55                   	push   %ebp
  802d39:	89 e5                	mov    %esp,%ebp
  802d3b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802d3e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d45:	a1 38 51 80 00       	mov    0x805138,%eax
  802d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4d:	e9 df 00 00 00       	jmp    802e31 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 40 0c             	mov    0xc(%eax),%eax
  802d58:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d5b:	0f 82 c8 00 00 00    	jb     802e29 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 40 0c             	mov    0xc(%eax),%eax
  802d67:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d6a:	0f 85 8a 00 00 00    	jne    802dfa <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802d70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d74:	75 17                	jne    802d8d <alloc_block_BF+0x55>
  802d76:	83 ec 04             	sub    $0x4,%esp
  802d79:	68 58 48 80 00       	push   $0x804858
  802d7e:	68 b7 00 00 00       	push   $0xb7
  802d83:	68 af 47 80 00       	push   $0x8047af
  802d88:	e8 b7 de ff ff       	call   800c44 <_panic>
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	8b 00                	mov    (%eax),%eax
  802d92:	85 c0                	test   %eax,%eax
  802d94:	74 10                	je     802da6 <alloc_block_BF+0x6e>
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 00                	mov    (%eax),%eax
  802d9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d9e:	8b 52 04             	mov    0x4(%edx),%edx
  802da1:	89 50 04             	mov    %edx,0x4(%eax)
  802da4:	eb 0b                	jmp    802db1 <alloc_block_BF+0x79>
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	8b 40 04             	mov    0x4(%eax),%eax
  802dac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 40 04             	mov    0x4(%eax),%eax
  802db7:	85 c0                	test   %eax,%eax
  802db9:	74 0f                	je     802dca <alloc_block_BF+0x92>
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 40 04             	mov    0x4(%eax),%eax
  802dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc4:	8b 12                	mov    (%edx),%edx
  802dc6:	89 10                	mov    %edx,(%eax)
  802dc8:	eb 0a                	jmp    802dd4 <alloc_block_BF+0x9c>
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	a3 38 51 80 00       	mov    %eax,0x805138
  802dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de7:	a1 44 51 80 00       	mov    0x805144,%eax
  802dec:	48                   	dec    %eax
  802ded:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	e9 4d 01 00 00       	jmp    802f47 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802e00:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e03:	76 24                	jbe    802e29 <alloc_block_BF+0xf1>
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e0e:	73 19                	jae    802e29 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802e10:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 40 08             	mov    0x8(%eax),%eax
  802e26:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802e29:	a1 40 51 80 00       	mov    0x805140,%eax
  802e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e35:	74 07                	je     802e3e <alloc_block_BF+0x106>
  802e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	eb 05                	jmp    802e43 <alloc_block_BF+0x10b>
  802e3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e43:	a3 40 51 80 00       	mov    %eax,0x805140
  802e48:	a1 40 51 80 00       	mov    0x805140,%eax
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	0f 85 fd fe ff ff    	jne    802d52 <alloc_block_BF+0x1a>
  802e55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e59:	0f 85 f3 fe ff ff    	jne    802d52 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802e5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e63:	0f 84 d9 00 00 00    	je     802f42 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e69:	a1 48 51 80 00       	mov    0x805148,%eax
  802e6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e77:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e80:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802e83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e87:	75 17                	jne    802ea0 <alloc_block_BF+0x168>
  802e89:	83 ec 04             	sub    $0x4,%esp
  802e8c:	68 58 48 80 00       	push   $0x804858
  802e91:	68 c7 00 00 00       	push   $0xc7
  802e96:	68 af 47 80 00       	push   $0x8047af
  802e9b:	e8 a4 dd ff ff       	call   800c44 <_panic>
  802ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea3:	8b 00                	mov    (%eax),%eax
  802ea5:	85 c0                	test   %eax,%eax
  802ea7:	74 10                	je     802eb9 <alloc_block_BF+0x181>
  802ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eac:	8b 00                	mov    (%eax),%eax
  802eae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802eb1:	8b 52 04             	mov    0x4(%edx),%edx
  802eb4:	89 50 04             	mov    %edx,0x4(%eax)
  802eb7:	eb 0b                	jmp    802ec4 <alloc_block_BF+0x18c>
  802eb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ebc:	8b 40 04             	mov    0x4(%eax),%eax
  802ebf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec7:	8b 40 04             	mov    0x4(%eax),%eax
  802eca:	85 c0                	test   %eax,%eax
  802ecc:	74 0f                	je     802edd <alloc_block_BF+0x1a5>
  802ece:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed1:	8b 40 04             	mov    0x4(%eax),%eax
  802ed4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ed7:	8b 12                	mov    (%edx),%edx
  802ed9:	89 10                	mov    %edx,(%eax)
  802edb:	eb 0a                	jmp    802ee7 <alloc_block_BF+0x1af>
  802edd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee0:	8b 00                	mov    (%eax),%eax
  802ee2:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efa:	a1 54 51 80 00       	mov    0x805154,%eax
  802eff:	48                   	dec    %eax
  802f00:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802f05:	83 ec 08             	sub    $0x8,%esp
  802f08:	ff 75 ec             	pushl  -0x14(%ebp)
  802f0b:	68 38 51 80 00       	push   $0x805138
  802f10:	e8 71 f9 ff ff       	call   802886 <find_block>
  802f15:	83 c4 10             	add    $0x10,%esp
  802f18:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802f1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1e:	8b 50 08             	mov    0x8(%eax),%edx
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	01 c2                	add    %eax,%edx
  802f26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f29:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802f2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f32:	2b 45 08             	sub    0x8(%ebp),%eax
  802f35:	89 c2                	mov    %eax,%edx
  802f37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802f3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f40:	eb 05                	jmp    802f47 <alloc_block_BF+0x20f>
	}
	return NULL;
  802f42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f47:	c9                   	leave  
  802f48:	c3                   	ret    

00802f49 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802f49:	55                   	push   %ebp
  802f4a:	89 e5                	mov    %esp,%ebp
  802f4c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802f4f:	a1 28 50 80 00       	mov    0x805028,%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	0f 85 de 01 00 00    	jne    80313a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f5c:	a1 38 51 80 00       	mov    0x805138,%eax
  802f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f64:	e9 9e 01 00 00       	jmp    803107 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f72:	0f 82 87 01 00 00    	jb     8030ff <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f81:	0f 85 95 00 00 00    	jne    80301c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802f87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8b:	75 17                	jne    802fa4 <alloc_block_NF+0x5b>
  802f8d:	83 ec 04             	sub    $0x4,%esp
  802f90:	68 58 48 80 00       	push   $0x804858
  802f95:	68 e0 00 00 00       	push   $0xe0
  802f9a:	68 af 47 80 00       	push   $0x8047af
  802f9f:	e8 a0 dc ff ff       	call   800c44 <_panic>
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 00                	mov    (%eax),%eax
  802fa9:	85 c0                	test   %eax,%eax
  802fab:	74 10                	je     802fbd <alloc_block_NF+0x74>
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb5:	8b 52 04             	mov    0x4(%edx),%edx
  802fb8:	89 50 04             	mov    %edx,0x4(%eax)
  802fbb:	eb 0b                	jmp    802fc8 <alloc_block_NF+0x7f>
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	8b 40 04             	mov    0x4(%eax),%eax
  802fc3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 40 04             	mov    0x4(%eax),%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	74 0f                	je     802fe1 <alloc_block_NF+0x98>
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 40 04             	mov    0x4(%eax),%eax
  802fd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fdb:	8b 12                	mov    (%edx),%edx
  802fdd:	89 10                	mov    %edx,(%eax)
  802fdf:	eb 0a                	jmp    802feb <alloc_block_NF+0xa2>
  802fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe4:	8b 00                	mov    (%eax),%eax
  802fe6:	a3 38 51 80 00       	mov    %eax,0x805138
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffe:	a1 44 51 80 00       	mov    0x805144,%eax
  803003:	48                   	dec    %eax
  803004:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 40 08             	mov    0x8(%eax),%eax
  80300f:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	e9 f8 04 00 00       	jmp    803514 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	8b 40 0c             	mov    0xc(%eax),%eax
  803022:	3b 45 08             	cmp    0x8(%ebp),%eax
  803025:	0f 86 d4 00 00 00    	jbe    8030ff <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80302b:	a1 48 51 80 00       	mov    0x805148,%eax
  803030:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803036:	8b 50 08             	mov    0x8(%eax),%edx
  803039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80303f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803042:	8b 55 08             	mov    0x8(%ebp),%edx
  803045:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803048:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80304c:	75 17                	jne    803065 <alloc_block_NF+0x11c>
  80304e:	83 ec 04             	sub    $0x4,%esp
  803051:	68 58 48 80 00       	push   $0x804858
  803056:	68 e9 00 00 00       	push   $0xe9
  80305b:	68 af 47 80 00       	push   $0x8047af
  803060:	e8 df db ff ff       	call   800c44 <_panic>
  803065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803068:	8b 00                	mov    (%eax),%eax
  80306a:	85 c0                	test   %eax,%eax
  80306c:	74 10                	je     80307e <alloc_block_NF+0x135>
  80306e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803076:	8b 52 04             	mov    0x4(%edx),%edx
  803079:	89 50 04             	mov    %edx,0x4(%eax)
  80307c:	eb 0b                	jmp    803089 <alloc_block_NF+0x140>
  80307e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803081:	8b 40 04             	mov    0x4(%eax),%eax
  803084:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308c:	8b 40 04             	mov    0x4(%eax),%eax
  80308f:	85 c0                	test   %eax,%eax
  803091:	74 0f                	je     8030a2 <alloc_block_NF+0x159>
  803093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803096:	8b 40 04             	mov    0x4(%eax),%eax
  803099:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80309c:	8b 12                	mov    (%edx),%edx
  80309e:	89 10                	mov    %edx,(%eax)
  8030a0:	eb 0a                	jmp    8030ac <alloc_block_NF+0x163>
  8030a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a5:	8b 00                	mov    (%eax),%eax
  8030a7:	a3 48 51 80 00       	mov    %eax,0x805148
  8030ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bf:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c4:	48                   	dec    %eax
  8030c5:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8030ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cd:	8b 40 08             	mov    0x8(%eax),%eax
  8030d0:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	8b 50 08             	mov    0x8(%eax),%edx
  8030db:	8b 45 08             	mov    0x8(%ebp),%eax
  8030de:	01 c2                	add    %eax,%edx
  8030e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e3:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ec:	2b 45 08             	sub    0x8(%ebp),%eax
  8030ef:	89 c2                	mov    %eax,%edx
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8030f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fa:	e9 15 04 00 00       	jmp    803514 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8030ff:	a1 40 51 80 00       	mov    0x805140,%eax
  803104:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310b:	74 07                	je     803114 <alloc_block_NF+0x1cb>
  80310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803110:	8b 00                	mov    (%eax),%eax
  803112:	eb 05                	jmp    803119 <alloc_block_NF+0x1d0>
  803114:	b8 00 00 00 00       	mov    $0x0,%eax
  803119:	a3 40 51 80 00       	mov    %eax,0x805140
  80311e:	a1 40 51 80 00       	mov    0x805140,%eax
  803123:	85 c0                	test   %eax,%eax
  803125:	0f 85 3e fe ff ff    	jne    802f69 <alloc_block_NF+0x20>
  80312b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312f:	0f 85 34 fe ff ff    	jne    802f69 <alloc_block_NF+0x20>
  803135:	e9 d5 03 00 00       	jmp    80350f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80313a:	a1 38 51 80 00       	mov    0x805138,%eax
  80313f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803142:	e9 b1 01 00 00       	jmp    8032f8 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	8b 50 08             	mov    0x8(%eax),%edx
  80314d:	a1 28 50 80 00       	mov    0x805028,%eax
  803152:	39 c2                	cmp    %eax,%edx
  803154:	0f 82 96 01 00 00    	jb     8032f0 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	8b 40 0c             	mov    0xc(%eax),%eax
  803160:	3b 45 08             	cmp    0x8(%ebp),%eax
  803163:	0f 82 87 01 00 00    	jb     8032f0 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 40 0c             	mov    0xc(%eax),%eax
  80316f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803172:	0f 85 95 00 00 00    	jne    80320d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803178:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317c:	75 17                	jne    803195 <alloc_block_NF+0x24c>
  80317e:	83 ec 04             	sub    $0x4,%esp
  803181:	68 58 48 80 00       	push   $0x804858
  803186:	68 fc 00 00 00       	push   $0xfc
  80318b:	68 af 47 80 00       	push   $0x8047af
  803190:	e8 af da ff ff       	call   800c44 <_panic>
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	8b 00                	mov    (%eax),%eax
  80319a:	85 c0                	test   %eax,%eax
  80319c:	74 10                	je     8031ae <alloc_block_NF+0x265>
  80319e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a6:	8b 52 04             	mov    0x4(%edx),%edx
  8031a9:	89 50 04             	mov    %edx,0x4(%eax)
  8031ac:	eb 0b                	jmp    8031b9 <alloc_block_NF+0x270>
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	8b 40 04             	mov    0x4(%eax),%eax
  8031b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bc:	8b 40 04             	mov    0x4(%eax),%eax
  8031bf:	85 c0                	test   %eax,%eax
  8031c1:	74 0f                	je     8031d2 <alloc_block_NF+0x289>
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 40 04             	mov    0x4(%eax),%eax
  8031c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031cc:	8b 12                	mov    (%edx),%edx
  8031ce:	89 10                	mov    %edx,(%eax)
  8031d0:	eb 0a                	jmp    8031dc <alloc_block_NF+0x293>
  8031d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d5:	8b 00                	mov    (%eax),%eax
  8031d7:	a3 38 51 80 00       	mov    %eax,0x805138
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f4:	48                   	dec    %eax
  8031f5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	8b 40 08             	mov    0x8(%eax),%eax
  803200:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803208:	e9 07 03 00 00       	jmp    803514 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	8b 40 0c             	mov    0xc(%eax),%eax
  803213:	3b 45 08             	cmp    0x8(%ebp),%eax
  803216:	0f 86 d4 00 00 00    	jbe    8032f0 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80321c:	a1 48 51 80 00       	mov    0x805148,%eax
  803221:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	8b 50 08             	mov    0x8(%eax),%edx
  80322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803230:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803233:	8b 55 08             	mov    0x8(%ebp),%edx
  803236:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803239:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80323d:	75 17                	jne    803256 <alloc_block_NF+0x30d>
  80323f:	83 ec 04             	sub    $0x4,%esp
  803242:	68 58 48 80 00       	push   $0x804858
  803247:	68 04 01 00 00       	push   $0x104
  80324c:	68 af 47 80 00       	push   $0x8047af
  803251:	e8 ee d9 ff ff       	call   800c44 <_panic>
  803256:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	85 c0                	test   %eax,%eax
  80325d:	74 10                	je     80326f <alloc_block_NF+0x326>
  80325f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803262:	8b 00                	mov    (%eax),%eax
  803264:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803267:	8b 52 04             	mov    0x4(%edx),%edx
  80326a:	89 50 04             	mov    %edx,0x4(%eax)
  80326d:	eb 0b                	jmp    80327a <alloc_block_NF+0x331>
  80326f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803272:	8b 40 04             	mov    0x4(%eax),%eax
  803275:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80327a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327d:	8b 40 04             	mov    0x4(%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	74 0f                	je     803293 <alloc_block_NF+0x34a>
  803284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803287:	8b 40 04             	mov    0x4(%eax),%eax
  80328a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80328d:	8b 12                	mov    (%edx),%edx
  80328f:	89 10                	mov    %edx,(%eax)
  803291:	eb 0a                	jmp    80329d <alloc_block_NF+0x354>
  803293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803296:	8b 00                	mov    (%eax),%eax
  803298:	a3 48 51 80 00       	mov    %eax,0x805148
  80329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8032b5:	48                   	dec    %eax
  8032b6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8032bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032be:	8b 40 08             	mov    0x8(%eax),%eax
  8032c1:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8032c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c9:	8b 50 08             	mov    0x8(%eax),%edx
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	01 c2                	add    %eax,%edx
  8032d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	8b 40 0c             	mov    0xc(%eax),%eax
  8032dd:	2b 45 08             	sub    0x8(%ebp),%eax
  8032e0:	89 c2                	mov    %eax,%edx
  8032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8032e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032eb:	e9 24 02 00 00       	jmp    803514 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8032f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fc:	74 07                	je     803305 <alloc_block_NF+0x3bc>
  8032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803301:	8b 00                	mov    (%eax),%eax
  803303:	eb 05                	jmp    80330a <alloc_block_NF+0x3c1>
  803305:	b8 00 00 00 00       	mov    $0x0,%eax
  80330a:	a3 40 51 80 00       	mov    %eax,0x805140
  80330f:	a1 40 51 80 00       	mov    0x805140,%eax
  803314:	85 c0                	test   %eax,%eax
  803316:	0f 85 2b fe ff ff    	jne    803147 <alloc_block_NF+0x1fe>
  80331c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803320:	0f 85 21 fe ff ff    	jne    803147 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803326:	a1 38 51 80 00       	mov    0x805138,%eax
  80332b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80332e:	e9 ae 01 00 00       	jmp    8034e1 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803336:	8b 50 08             	mov    0x8(%eax),%edx
  803339:	a1 28 50 80 00       	mov    0x805028,%eax
  80333e:	39 c2                	cmp    %eax,%edx
  803340:	0f 83 93 01 00 00    	jae    8034d9 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803349:	8b 40 0c             	mov    0xc(%eax),%eax
  80334c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80334f:	0f 82 84 01 00 00    	jb     8034d9 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	8b 40 0c             	mov    0xc(%eax),%eax
  80335b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80335e:	0f 85 95 00 00 00    	jne    8033f9 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803368:	75 17                	jne    803381 <alloc_block_NF+0x438>
  80336a:	83 ec 04             	sub    $0x4,%esp
  80336d:	68 58 48 80 00       	push   $0x804858
  803372:	68 14 01 00 00       	push   $0x114
  803377:	68 af 47 80 00       	push   $0x8047af
  80337c:	e8 c3 d8 ff ff       	call   800c44 <_panic>
  803381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803384:	8b 00                	mov    (%eax),%eax
  803386:	85 c0                	test   %eax,%eax
  803388:	74 10                	je     80339a <alloc_block_NF+0x451>
  80338a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338d:	8b 00                	mov    (%eax),%eax
  80338f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803392:	8b 52 04             	mov    0x4(%edx),%edx
  803395:	89 50 04             	mov    %edx,0x4(%eax)
  803398:	eb 0b                	jmp    8033a5 <alloc_block_NF+0x45c>
  80339a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339d:	8b 40 04             	mov    0x4(%eax),%eax
  8033a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a8:	8b 40 04             	mov    0x4(%eax),%eax
  8033ab:	85 c0                	test   %eax,%eax
  8033ad:	74 0f                	je     8033be <alloc_block_NF+0x475>
  8033af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b2:	8b 40 04             	mov    0x4(%eax),%eax
  8033b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033b8:	8b 12                	mov    (%edx),%edx
  8033ba:	89 10                	mov    %edx,(%eax)
  8033bc:	eb 0a                	jmp    8033c8 <alloc_block_NF+0x47f>
  8033be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c1:	8b 00                	mov    (%eax),%eax
  8033c3:	a3 38 51 80 00       	mov    %eax,0x805138
  8033c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033db:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e0:	48                   	dec    %eax
  8033e1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8033e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e9:	8b 40 08             	mov    0x8(%eax),%eax
  8033ec:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	e9 1b 01 00 00       	jmp    803514 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  803402:	0f 86 d1 00 00 00    	jbe    8034d9 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803408:	a1 48 51 80 00       	mov    0x805148,%eax
  80340d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803413:	8b 50 08             	mov    0x8(%eax),%edx
  803416:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803419:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80341c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80341f:	8b 55 08             	mov    0x8(%ebp),%edx
  803422:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803425:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803429:	75 17                	jne    803442 <alloc_block_NF+0x4f9>
  80342b:	83 ec 04             	sub    $0x4,%esp
  80342e:	68 58 48 80 00       	push   $0x804858
  803433:	68 1c 01 00 00       	push   $0x11c
  803438:	68 af 47 80 00       	push   $0x8047af
  80343d:	e8 02 d8 ff ff       	call   800c44 <_panic>
  803442:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803445:	8b 00                	mov    (%eax),%eax
  803447:	85 c0                	test   %eax,%eax
  803449:	74 10                	je     80345b <alloc_block_NF+0x512>
  80344b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80344e:	8b 00                	mov    (%eax),%eax
  803450:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803453:	8b 52 04             	mov    0x4(%edx),%edx
  803456:	89 50 04             	mov    %edx,0x4(%eax)
  803459:	eb 0b                	jmp    803466 <alloc_block_NF+0x51d>
  80345b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80345e:	8b 40 04             	mov    0x4(%eax),%eax
  803461:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803469:	8b 40 04             	mov    0x4(%eax),%eax
  80346c:	85 c0                	test   %eax,%eax
  80346e:	74 0f                	je     80347f <alloc_block_NF+0x536>
  803470:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803473:	8b 40 04             	mov    0x4(%eax),%eax
  803476:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803479:	8b 12                	mov    (%edx),%edx
  80347b:	89 10                	mov    %edx,(%eax)
  80347d:	eb 0a                	jmp    803489 <alloc_block_NF+0x540>
  80347f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803482:	8b 00                	mov    (%eax),%eax
  803484:	a3 48 51 80 00       	mov    %eax,0x805148
  803489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80348c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803492:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803495:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349c:	a1 54 51 80 00       	mov    0x805154,%eax
  8034a1:	48                   	dec    %eax
  8034a2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8034a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034aa:	8b 40 08             	mov    0x8(%eax),%eax
  8034ad:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8034b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b5:	8b 50 08             	mov    0x8(%eax),%edx
  8034b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bb:	01 c2                	add    %eax,%edx
  8034bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8034c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c9:	2b 45 08             	sub    0x8(%ebp),%eax
  8034cc:	89 c2                	mov    %eax,%edx
  8034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8034d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d7:	eb 3b                	jmp    803514 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8034d9:	a1 40 51 80 00       	mov    0x805140,%eax
  8034de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e5:	74 07                	je     8034ee <alloc_block_NF+0x5a5>
  8034e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	eb 05                	jmp    8034f3 <alloc_block_NF+0x5aa>
  8034ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f3:	a3 40 51 80 00       	mov    %eax,0x805140
  8034f8:	a1 40 51 80 00       	mov    0x805140,%eax
  8034fd:	85 c0                	test   %eax,%eax
  8034ff:	0f 85 2e fe ff ff    	jne    803333 <alloc_block_NF+0x3ea>
  803505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803509:	0f 85 24 fe ff ff    	jne    803333 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80350f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803514:	c9                   	leave  
  803515:	c3                   	ret    

00803516 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803516:	55                   	push   %ebp
  803517:	89 e5                	mov    %esp,%ebp
  803519:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80351c:	a1 38 51 80 00       	mov    0x805138,%eax
  803521:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803524:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803529:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80352c:	a1 38 51 80 00       	mov    0x805138,%eax
  803531:	85 c0                	test   %eax,%eax
  803533:	74 14                	je     803549 <insert_sorted_with_merge_freeList+0x33>
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	8b 50 08             	mov    0x8(%eax),%edx
  80353b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353e:	8b 40 08             	mov    0x8(%eax),%eax
  803541:	39 c2                	cmp    %eax,%edx
  803543:	0f 87 9b 01 00 00    	ja     8036e4 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803549:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80354d:	75 17                	jne    803566 <insert_sorted_with_merge_freeList+0x50>
  80354f:	83 ec 04             	sub    $0x4,%esp
  803552:	68 8c 47 80 00       	push   $0x80478c
  803557:	68 38 01 00 00       	push   $0x138
  80355c:	68 af 47 80 00       	push   $0x8047af
  803561:	e8 de d6 ff ff       	call   800c44 <_panic>
  803566:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	89 10                	mov    %edx,(%eax)
  803571:	8b 45 08             	mov    0x8(%ebp),%eax
  803574:	8b 00                	mov    (%eax),%eax
  803576:	85 c0                	test   %eax,%eax
  803578:	74 0d                	je     803587 <insert_sorted_with_merge_freeList+0x71>
  80357a:	a1 38 51 80 00       	mov    0x805138,%eax
  80357f:	8b 55 08             	mov    0x8(%ebp),%edx
  803582:	89 50 04             	mov    %edx,0x4(%eax)
  803585:	eb 08                	jmp    80358f <insert_sorted_with_merge_freeList+0x79>
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	a3 38 51 80 00       	mov    %eax,0x805138
  803597:	8b 45 08             	mov    0x8(%ebp),%eax
  80359a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a1:	a1 44 51 80 00       	mov    0x805144,%eax
  8035a6:	40                   	inc    %eax
  8035a7:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035b0:	0f 84 a8 06 00 00    	je     803c5e <insert_sorted_with_merge_freeList+0x748>
  8035b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b9:	8b 50 08             	mov    0x8(%eax),%edx
  8035bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c2:	01 c2                	add    %eax,%edx
  8035c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c7:	8b 40 08             	mov    0x8(%eax),%eax
  8035ca:	39 c2                	cmp    %eax,%edx
  8035cc:	0f 85 8c 06 00 00    	jne    803c5e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8035d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035db:	8b 40 0c             	mov    0xc(%eax),%eax
  8035de:	01 c2                	add    %eax,%edx
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8035e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035ea:	75 17                	jne    803603 <insert_sorted_with_merge_freeList+0xed>
  8035ec:	83 ec 04             	sub    $0x4,%esp
  8035ef:	68 58 48 80 00       	push   $0x804858
  8035f4:	68 3c 01 00 00       	push   $0x13c
  8035f9:	68 af 47 80 00       	push   $0x8047af
  8035fe:	e8 41 d6 ff ff       	call   800c44 <_panic>
  803603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803606:	8b 00                	mov    (%eax),%eax
  803608:	85 c0                	test   %eax,%eax
  80360a:	74 10                	je     80361c <insert_sorted_with_merge_freeList+0x106>
  80360c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360f:	8b 00                	mov    (%eax),%eax
  803611:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803614:	8b 52 04             	mov    0x4(%edx),%edx
  803617:	89 50 04             	mov    %edx,0x4(%eax)
  80361a:	eb 0b                	jmp    803627 <insert_sorted_with_merge_freeList+0x111>
  80361c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361f:	8b 40 04             	mov    0x4(%eax),%eax
  803622:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80362a:	8b 40 04             	mov    0x4(%eax),%eax
  80362d:	85 c0                	test   %eax,%eax
  80362f:	74 0f                	je     803640 <insert_sorted_with_merge_freeList+0x12a>
  803631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803634:	8b 40 04             	mov    0x4(%eax),%eax
  803637:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80363a:	8b 12                	mov    (%edx),%edx
  80363c:	89 10                	mov    %edx,(%eax)
  80363e:	eb 0a                	jmp    80364a <insert_sorted_with_merge_freeList+0x134>
  803640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803643:	8b 00                	mov    (%eax),%eax
  803645:	a3 38 51 80 00       	mov    %eax,0x805138
  80364a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80364d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803656:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365d:	a1 44 51 80 00       	mov    0x805144,%eax
  803662:	48                   	dec    %eax
  803663:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803675:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80367c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803680:	75 17                	jne    803699 <insert_sorted_with_merge_freeList+0x183>
  803682:	83 ec 04             	sub    $0x4,%esp
  803685:	68 8c 47 80 00       	push   $0x80478c
  80368a:	68 3f 01 00 00       	push   $0x13f
  80368f:	68 af 47 80 00       	push   $0x8047af
  803694:	e8 ab d5 ff ff       	call   800c44 <_panic>
  803699:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80369f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a2:	89 10                	mov    %edx,(%eax)
  8036a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a7:	8b 00                	mov    (%eax),%eax
  8036a9:	85 c0                	test   %eax,%eax
  8036ab:	74 0d                	je     8036ba <insert_sorted_with_merge_freeList+0x1a4>
  8036ad:	a1 48 51 80 00       	mov    0x805148,%eax
  8036b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036b5:	89 50 04             	mov    %edx,0x4(%eax)
  8036b8:	eb 08                	jmp    8036c2 <insert_sorted_with_merge_freeList+0x1ac>
  8036ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036bd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c5:	a3 48 51 80 00       	mov    %eax,0x805148
  8036ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d4:	a1 54 51 80 00       	mov    0x805154,%eax
  8036d9:	40                   	inc    %eax
  8036da:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036df:	e9 7a 05 00 00       	jmp    803c5e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	8b 50 08             	mov    0x8(%eax),%edx
  8036ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ed:	8b 40 08             	mov    0x8(%eax),%eax
  8036f0:	39 c2                	cmp    %eax,%edx
  8036f2:	0f 82 14 01 00 00    	jb     80380c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8036f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036fb:	8b 50 08             	mov    0x8(%eax),%edx
  8036fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803701:	8b 40 0c             	mov    0xc(%eax),%eax
  803704:	01 c2                	add    %eax,%edx
  803706:	8b 45 08             	mov    0x8(%ebp),%eax
  803709:	8b 40 08             	mov    0x8(%eax),%eax
  80370c:	39 c2                	cmp    %eax,%edx
  80370e:	0f 85 90 00 00 00    	jne    8037a4 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803714:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803717:	8b 50 0c             	mov    0xc(%eax),%edx
  80371a:	8b 45 08             	mov    0x8(%ebp),%eax
  80371d:	8b 40 0c             	mov    0xc(%eax),%eax
  803720:	01 c2                	add    %eax,%edx
  803722:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803725:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803728:	8b 45 08             	mov    0x8(%ebp),%eax
  80372b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80373c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803740:	75 17                	jne    803759 <insert_sorted_with_merge_freeList+0x243>
  803742:	83 ec 04             	sub    $0x4,%esp
  803745:	68 8c 47 80 00       	push   $0x80478c
  80374a:	68 49 01 00 00       	push   $0x149
  80374f:	68 af 47 80 00       	push   $0x8047af
  803754:	e8 eb d4 ff ff       	call   800c44 <_panic>
  803759:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80375f:	8b 45 08             	mov    0x8(%ebp),%eax
  803762:	89 10                	mov    %edx,(%eax)
  803764:	8b 45 08             	mov    0x8(%ebp),%eax
  803767:	8b 00                	mov    (%eax),%eax
  803769:	85 c0                	test   %eax,%eax
  80376b:	74 0d                	je     80377a <insert_sorted_with_merge_freeList+0x264>
  80376d:	a1 48 51 80 00       	mov    0x805148,%eax
  803772:	8b 55 08             	mov    0x8(%ebp),%edx
  803775:	89 50 04             	mov    %edx,0x4(%eax)
  803778:	eb 08                	jmp    803782 <insert_sorted_with_merge_freeList+0x26c>
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803782:	8b 45 08             	mov    0x8(%ebp),%eax
  803785:	a3 48 51 80 00       	mov    %eax,0x805148
  80378a:	8b 45 08             	mov    0x8(%ebp),%eax
  80378d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803794:	a1 54 51 80 00       	mov    0x805154,%eax
  803799:	40                   	inc    %eax
  80379a:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80379f:	e9 bb 04 00 00       	jmp    803c5f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8037a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037a8:	75 17                	jne    8037c1 <insert_sorted_with_merge_freeList+0x2ab>
  8037aa:	83 ec 04             	sub    $0x4,%esp
  8037ad:	68 00 48 80 00       	push   $0x804800
  8037b2:	68 4c 01 00 00       	push   $0x14c
  8037b7:	68 af 47 80 00       	push   $0x8047af
  8037bc:	e8 83 d4 ff ff       	call   800c44 <_panic>
  8037c1:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ca:	89 50 04             	mov    %edx,0x4(%eax)
  8037cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d0:	8b 40 04             	mov    0x4(%eax),%eax
  8037d3:	85 c0                	test   %eax,%eax
  8037d5:	74 0c                	je     8037e3 <insert_sorted_with_merge_freeList+0x2cd>
  8037d7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8037dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8037df:	89 10                	mov    %edx,(%eax)
  8037e1:	eb 08                	jmp    8037eb <insert_sorted_with_merge_freeList+0x2d5>
  8037e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e6:	a3 38 51 80 00       	mov    %eax,0x805138
  8037eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037fc:	a1 44 51 80 00       	mov    0x805144,%eax
  803801:	40                   	inc    %eax
  803802:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803807:	e9 53 04 00 00       	jmp    803c5f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80380c:	a1 38 51 80 00       	mov    0x805138,%eax
  803811:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803814:	e9 15 04 00 00       	jmp    803c2e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803821:	8b 45 08             	mov    0x8(%ebp),%eax
  803824:	8b 50 08             	mov    0x8(%eax),%edx
  803827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382a:	8b 40 08             	mov    0x8(%eax),%eax
  80382d:	39 c2                	cmp    %eax,%edx
  80382f:	0f 86 f1 03 00 00    	jbe    803c26 <insert_sorted_with_merge_freeList+0x710>
  803835:	8b 45 08             	mov    0x8(%ebp),%eax
  803838:	8b 50 08             	mov    0x8(%eax),%edx
  80383b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383e:	8b 40 08             	mov    0x8(%eax),%eax
  803841:	39 c2                	cmp    %eax,%edx
  803843:	0f 83 dd 03 00 00    	jae    803c26 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384c:	8b 50 08             	mov    0x8(%eax),%edx
  80384f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803852:	8b 40 0c             	mov    0xc(%eax),%eax
  803855:	01 c2                	add    %eax,%edx
  803857:	8b 45 08             	mov    0x8(%ebp),%eax
  80385a:	8b 40 08             	mov    0x8(%eax),%eax
  80385d:	39 c2                	cmp    %eax,%edx
  80385f:	0f 85 b9 01 00 00    	jne    803a1e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803865:	8b 45 08             	mov    0x8(%ebp),%eax
  803868:	8b 50 08             	mov    0x8(%eax),%edx
  80386b:	8b 45 08             	mov    0x8(%ebp),%eax
  80386e:	8b 40 0c             	mov    0xc(%eax),%eax
  803871:	01 c2                	add    %eax,%edx
  803873:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803876:	8b 40 08             	mov    0x8(%eax),%eax
  803879:	39 c2                	cmp    %eax,%edx
  80387b:	0f 85 0d 01 00 00    	jne    80398e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803884:	8b 50 0c             	mov    0xc(%eax),%edx
  803887:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388a:	8b 40 0c             	mov    0xc(%eax),%eax
  80388d:	01 c2                	add    %eax,%edx
  80388f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803892:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803895:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803899:	75 17                	jne    8038b2 <insert_sorted_with_merge_freeList+0x39c>
  80389b:	83 ec 04             	sub    $0x4,%esp
  80389e:	68 58 48 80 00       	push   $0x804858
  8038a3:	68 5c 01 00 00       	push   $0x15c
  8038a8:	68 af 47 80 00       	push   $0x8047af
  8038ad:	e8 92 d3 ff ff       	call   800c44 <_panic>
  8038b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b5:	8b 00                	mov    (%eax),%eax
  8038b7:	85 c0                	test   %eax,%eax
  8038b9:	74 10                	je     8038cb <insert_sorted_with_merge_freeList+0x3b5>
  8038bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038be:	8b 00                	mov    (%eax),%eax
  8038c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038c3:	8b 52 04             	mov    0x4(%edx),%edx
  8038c6:	89 50 04             	mov    %edx,0x4(%eax)
  8038c9:	eb 0b                	jmp    8038d6 <insert_sorted_with_merge_freeList+0x3c0>
  8038cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ce:	8b 40 04             	mov    0x4(%eax),%eax
  8038d1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d9:	8b 40 04             	mov    0x4(%eax),%eax
  8038dc:	85 c0                	test   %eax,%eax
  8038de:	74 0f                	je     8038ef <insert_sorted_with_merge_freeList+0x3d9>
  8038e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e3:	8b 40 04             	mov    0x4(%eax),%eax
  8038e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038e9:	8b 12                	mov    (%edx),%edx
  8038eb:	89 10                	mov    %edx,(%eax)
  8038ed:	eb 0a                	jmp    8038f9 <insert_sorted_with_merge_freeList+0x3e3>
  8038ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f2:	8b 00                	mov    (%eax),%eax
  8038f4:	a3 38 51 80 00       	mov    %eax,0x805138
  8038f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803902:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803905:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80390c:	a1 44 51 80 00       	mov    0x805144,%eax
  803911:	48                   	dec    %eax
  803912:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803917:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803921:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803924:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80392b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80392f:	75 17                	jne    803948 <insert_sorted_with_merge_freeList+0x432>
  803931:	83 ec 04             	sub    $0x4,%esp
  803934:	68 8c 47 80 00       	push   $0x80478c
  803939:	68 5f 01 00 00       	push   $0x15f
  80393e:	68 af 47 80 00       	push   $0x8047af
  803943:	e8 fc d2 ff ff       	call   800c44 <_panic>
  803948:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80394e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803951:	89 10                	mov    %edx,(%eax)
  803953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803956:	8b 00                	mov    (%eax),%eax
  803958:	85 c0                	test   %eax,%eax
  80395a:	74 0d                	je     803969 <insert_sorted_with_merge_freeList+0x453>
  80395c:	a1 48 51 80 00       	mov    0x805148,%eax
  803961:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803964:	89 50 04             	mov    %edx,0x4(%eax)
  803967:	eb 08                	jmp    803971 <insert_sorted_with_merge_freeList+0x45b>
  803969:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803971:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803974:	a3 48 51 80 00       	mov    %eax,0x805148
  803979:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803983:	a1 54 51 80 00       	mov    0x805154,%eax
  803988:	40                   	inc    %eax
  803989:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80398e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803991:	8b 50 0c             	mov    0xc(%eax),%edx
  803994:	8b 45 08             	mov    0x8(%ebp),%eax
  803997:	8b 40 0c             	mov    0xc(%eax),%eax
  80399a:	01 c2                	add    %eax,%edx
  80399c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8039a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8039ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8039af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8039b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039ba:	75 17                	jne    8039d3 <insert_sorted_with_merge_freeList+0x4bd>
  8039bc:	83 ec 04             	sub    $0x4,%esp
  8039bf:	68 8c 47 80 00       	push   $0x80478c
  8039c4:	68 64 01 00 00       	push   $0x164
  8039c9:	68 af 47 80 00       	push   $0x8047af
  8039ce:	e8 71 d2 ff ff       	call   800c44 <_panic>
  8039d3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039dc:	89 10                	mov    %edx,(%eax)
  8039de:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e1:	8b 00                	mov    (%eax),%eax
  8039e3:	85 c0                	test   %eax,%eax
  8039e5:	74 0d                	je     8039f4 <insert_sorted_with_merge_freeList+0x4de>
  8039e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8039ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8039ef:	89 50 04             	mov    %edx,0x4(%eax)
  8039f2:	eb 08                	jmp    8039fc <insert_sorted_with_merge_freeList+0x4e6>
  8039f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ff:	a3 48 51 80 00       	mov    %eax,0x805148
  803a04:	8b 45 08             	mov    0x8(%ebp),%eax
  803a07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a0e:	a1 54 51 80 00       	mov    0x805154,%eax
  803a13:	40                   	inc    %eax
  803a14:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a19:	e9 41 02 00 00       	jmp    803c5f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a21:	8b 50 08             	mov    0x8(%eax),%edx
  803a24:	8b 45 08             	mov    0x8(%ebp),%eax
  803a27:	8b 40 0c             	mov    0xc(%eax),%eax
  803a2a:	01 c2                	add    %eax,%edx
  803a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2f:	8b 40 08             	mov    0x8(%eax),%eax
  803a32:	39 c2                	cmp    %eax,%edx
  803a34:	0f 85 7c 01 00 00    	jne    803bb6 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803a3a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a3e:	74 06                	je     803a46 <insert_sorted_with_merge_freeList+0x530>
  803a40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a44:	75 17                	jne    803a5d <insert_sorted_with_merge_freeList+0x547>
  803a46:	83 ec 04             	sub    $0x4,%esp
  803a49:	68 c8 47 80 00       	push   $0x8047c8
  803a4e:	68 69 01 00 00       	push   $0x169
  803a53:	68 af 47 80 00       	push   $0x8047af
  803a58:	e8 e7 d1 ff ff       	call   800c44 <_panic>
  803a5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a60:	8b 50 04             	mov    0x4(%eax),%edx
  803a63:	8b 45 08             	mov    0x8(%ebp),%eax
  803a66:	89 50 04             	mov    %edx,0x4(%eax)
  803a69:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a6f:	89 10                	mov    %edx,(%eax)
  803a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a74:	8b 40 04             	mov    0x4(%eax),%eax
  803a77:	85 c0                	test   %eax,%eax
  803a79:	74 0d                	je     803a88 <insert_sorted_with_merge_freeList+0x572>
  803a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7e:	8b 40 04             	mov    0x4(%eax),%eax
  803a81:	8b 55 08             	mov    0x8(%ebp),%edx
  803a84:	89 10                	mov    %edx,(%eax)
  803a86:	eb 08                	jmp    803a90 <insert_sorted_with_merge_freeList+0x57a>
  803a88:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8b:	a3 38 51 80 00       	mov    %eax,0x805138
  803a90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a93:	8b 55 08             	mov    0x8(%ebp),%edx
  803a96:	89 50 04             	mov    %edx,0x4(%eax)
  803a99:	a1 44 51 80 00       	mov    0x805144,%eax
  803a9e:	40                   	inc    %eax
  803a9f:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa7:	8b 50 0c             	mov    0xc(%eax),%edx
  803aaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aad:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab0:	01 c2                	add    %eax,%edx
  803ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab5:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803ab8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803abc:	75 17                	jne    803ad5 <insert_sorted_with_merge_freeList+0x5bf>
  803abe:	83 ec 04             	sub    $0x4,%esp
  803ac1:	68 58 48 80 00       	push   $0x804858
  803ac6:	68 6b 01 00 00       	push   $0x16b
  803acb:	68 af 47 80 00       	push   $0x8047af
  803ad0:	e8 6f d1 ff ff       	call   800c44 <_panic>
  803ad5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ad8:	8b 00                	mov    (%eax),%eax
  803ada:	85 c0                	test   %eax,%eax
  803adc:	74 10                	je     803aee <insert_sorted_with_merge_freeList+0x5d8>
  803ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae1:	8b 00                	mov    (%eax),%eax
  803ae3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ae6:	8b 52 04             	mov    0x4(%edx),%edx
  803ae9:	89 50 04             	mov    %edx,0x4(%eax)
  803aec:	eb 0b                	jmp    803af9 <insert_sorted_with_merge_freeList+0x5e3>
  803aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af1:	8b 40 04             	mov    0x4(%eax),%eax
  803af4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803af9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803afc:	8b 40 04             	mov    0x4(%eax),%eax
  803aff:	85 c0                	test   %eax,%eax
  803b01:	74 0f                	je     803b12 <insert_sorted_with_merge_freeList+0x5fc>
  803b03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b06:	8b 40 04             	mov    0x4(%eax),%eax
  803b09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b0c:	8b 12                	mov    (%edx),%edx
  803b0e:	89 10                	mov    %edx,(%eax)
  803b10:	eb 0a                	jmp    803b1c <insert_sorted_with_merge_freeList+0x606>
  803b12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b15:	8b 00                	mov    (%eax),%eax
  803b17:	a3 38 51 80 00       	mov    %eax,0x805138
  803b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b2f:	a1 44 51 80 00       	mov    0x805144,%eax
  803b34:	48                   	dec    %eax
  803b35:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803b3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803b44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b47:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803b4e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b52:	75 17                	jne    803b6b <insert_sorted_with_merge_freeList+0x655>
  803b54:	83 ec 04             	sub    $0x4,%esp
  803b57:	68 8c 47 80 00       	push   $0x80478c
  803b5c:	68 6e 01 00 00       	push   $0x16e
  803b61:	68 af 47 80 00       	push   $0x8047af
  803b66:	e8 d9 d0 ff ff       	call   800c44 <_panic>
  803b6b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b74:	89 10                	mov    %edx,(%eax)
  803b76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b79:	8b 00                	mov    (%eax),%eax
  803b7b:	85 c0                	test   %eax,%eax
  803b7d:	74 0d                	je     803b8c <insert_sorted_with_merge_freeList+0x676>
  803b7f:	a1 48 51 80 00       	mov    0x805148,%eax
  803b84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b87:	89 50 04             	mov    %edx,0x4(%eax)
  803b8a:	eb 08                	jmp    803b94 <insert_sorted_with_merge_freeList+0x67e>
  803b8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b8f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b97:	a3 48 51 80 00       	mov    %eax,0x805148
  803b9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ba6:	a1 54 51 80 00       	mov    0x805154,%eax
  803bab:	40                   	inc    %eax
  803bac:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803bb1:	e9 a9 00 00 00       	jmp    803c5f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bba:	74 06                	je     803bc2 <insert_sorted_with_merge_freeList+0x6ac>
  803bbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bc0:	75 17                	jne    803bd9 <insert_sorted_with_merge_freeList+0x6c3>
  803bc2:	83 ec 04             	sub    $0x4,%esp
  803bc5:	68 24 48 80 00       	push   $0x804824
  803bca:	68 73 01 00 00       	push   $0x173
  803bcf:	68 af 47 80 00       	push   $0x8047af
  803bd4:	e8 6b d0 ff ff       	call   800c44 <_panic>
  803bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdc:	8b 10                	mov    (%eax),%edx
  803bde:	8b 45 08             	mov    0x8(%ebp),%eax
  803be1:	89 10                	mov    %edx,(%eax)
  803be3:	8b 45 08             	mov    0x8(%ebp),%eax
  803be6:	8b 00                	mov    (%eax),%eax
  803be8:	85 c0                	test   %eax,%eax
  803bea:	74 0b                	je     803bf7 <insert_sorted_with_merge_freeList+0x6e1>
  803bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bef:	8b 00                	mov    (%eax),%eax
  803bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  803bf4:	89 50 04             	mov    %edx,0x4(%eax)
  803bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfa:	8b 55 08             	mov    0x8(%ebp),%edx
  803bfd:	89 10                	mov    %edx,(%eax)
  803bff:	8b 45 08             	mov    0x8(%ebp),%eax
  803c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c05:	89 50 04             	mov    %edx,0x4(%eax)
  803c08:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0b:	8b 00                	mov    (%eax),%eax
  803c0d:	85 c0                	test   %eax,%eax
  803c0f:	75 08                	jne    803c19 <insert_sorted_with_merge_freeList+0x703>
  803c11:	8b 45 08             	mov    0x8(%ebp),%eax
  803c14:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c19:	a1 44 51 80 00       	mov    0x805144,%eax
  803c1e:	40                   	inc    %eax
  803c1f:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803c24:	eb 39                	jmp    803c5f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803c26:	a1 40 51 80 00       	mov    0x805140,%eax
  803c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c32:	74 07                	je     803c3b <insert_sorted_with_merge_freeList+0x725>
  803c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c37:	8b 00                	mov    (%eax),%eax
  803c39:	eb 05                	jmp    803c40 <insert_sorted_with_merge_freeList+0x72a>
  803c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c40:	a3 40 51 80 00       	mov    %eax,0x805140
  803c45:	a1 40 51 80 00       	mov    0x805140,%eax
  803c4a:	85 c0                	test   %eax,%eax
  803c4c:	0f 85 c7 fb ff ff    	jne    803819 <insert_sorted_with_merge_freeList+0x303>
  803c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c56:	0f 85 bd fb ff ff    	jne    803819 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803c5c:	eb 01                	jmp    803c5f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803c5e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803c5f:	90                   	nop
  803c60:	c9                   	leave  
  803c61:	c3                   	ret    
  803c62:	66 90                	xchg   %ax,%ax

00803c64 <__udivdi3>:
  803c64:	55                   	push   %ebp
  803c65:	57                   	push   %edi
  803c66:	56                   	push   %esi
  803c67:	53                   	push   %ebx
  803c68:	83 ec 1c             	sub    $0x1c,%esp
  803c6b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c6f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c7b:	89 ca                	mov    %ecx,%edx
  803c7d:	89 f8                	mov    %edi,%eax
  803c7f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c83:	85 f6                	test   %esi,%esi
  803c85:	75 2d                	jne    803cb4 <__udivdi3+0x50>
  803c87:	39 cf                	cmp    %ecx,%edi
  803c89:	77 65                	ja     803cf0 <__udivdi3+0x8c>
  803c8b:	89 fd                	mov    %edi,%ebp
  803c8d:	85 ff                	test   %edi,%edi
  803c8f:	75 0b                	jne    803c9c <__udivdi3+0x38>
  803c91:	b8 01 00 00 00       	mov    $0x1,%eax
  803c96:	31 d2                	xor    %edx,%edx
  803c98:	f7 f7                	div    %edi
  803c9a:	89 c5                	mov    %eax,%ebp
  803c9c:	31 d2                	xor    %edx,%edx
  803c9e:	89 c8                	mov    %ecx,%eax
  803ca0:	f7 f5                	div    %ebp
  803ca2:	89 c1                	mov    %eax,%ecx
  803ca4:	89 d8                	mov    %ebx,%eax
  803ca6:	f7 f5                	div    %ebp
  803ca8:	89 cf                	mov    %ecx,%edi
  803caa:	89 fa                	mov    %edi,%edx
  803cac:	83 c4 1c             	add    $0x1c,%esp
  803caf:	5b                   	pop    %ebx
  803cb0:	5e                   	pop    %esi
  803cb1:	5f                   	pop    %edi
  803cb2:	5d                   	pop    %ebp
  803cb3:	c3                   	ret    
  803cb4:	39 ce                	cmp    %ecx,%esi
  803cb6:	77 28                	ja     803ce0 <__udivdi3+0x7c>
  803cb8:	0f bd fe             	bsr    %esi,%edi
  803cbb:	83 f7 1f             	xor    $0x1f,%edi
  803cbe:	75 40                	jne    803d00 <__udivdi3+0x9c>
  803cc0:	39 ce                	cmp    %ecx,%esi
  803cc2:	72 0a                	jb     803cce <__udivdi3+0x6a>
  803cc4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cc8:	0f 87 9e 00 00 00    	ja     803d6c <__udivdi3+0x108>
  803cce:	b8 01 00 00 00       	mov    $0x1,%eax
  803cd3:	89 fa                	mov    %edi,%edx
  803cd5:	83 c4 1c             	add    $0x1c,%esp
  803cd8:	5b                   	pop    %ebx
  803cd9:	5e                   	pop    %esi
  803cda:	5f                   	pop    %edi
  803cdb:	5d                   	pop    %ebp
  803cdc:	c3                   	ret    
  803cdd:	8d 76 00             	lea    0x0(%esi),%esi
  803ce0:	31 ff                	xor    %edi,%edi
  803ce2:	31 c0                	xor    %eax,%eax
  803ce4:	89 fa                	mov    %edi,%edx
  803ce6:	83 c4 1c             	add    $0x1c,%esp
  803ce9:	5b                   	pop    %ebx
  803cea:	5e                   	pop    %esi
  803ceb:	5f                   	pop    %edi
  803cec:	5d                   	pop    %ebp
  803ced:	c3                   	ret    
  803cee:	66 90                	xchg   %ax,%ax
  803cf0:	89 d8                	mov    %ebx,%eax
  803cf2:	f7 f7                	div    %edi
  803cf4:	31 ff                	xor    %edi,%edi
  803cf6:	89 fa                	mov    %edi,%edx
  803cf8:	83 c4 1c             	add    $0x1c,%esp
  803cfb:	5b                   	pop    %ebx
  803cfc:	5e                   	pop    %esi
  803cfd:	5f                   	pop    %edi
  803cfe:	5d                   	pop    %ebp
  803cff:	c3                   	ret    
  803d00:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d05:	89 eb                	mov    %ebp,%ebx
  803d07:	29 fb                	sub    %edi,%ebx
  803d09:	89 f9                	mov    %edi,%ecx
  803d0b:	d3 e6                	shl    %cl,%esi
  803d0d:	89 c5                	mov    %eax,%ebp
  803d0f:	88 d9                	mov    %bl,%cl
  803d11:	d3 ed                	shr    %cl,%ebp
  803d13:	89 e9                	mov    %ebp,%ecx
  803d15:	09 f1                	or     %esi,%ecx
  803d17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d1b:	89 f9                	mov    %edi,%ecx
  803d1d:	d3 e0                	shl    %cl,%eax
  803d1f:	89 c5                	mov    %eax,%ebp
  803d21:	89 d6                	mov    %edx,%esi
  803d23:	88 d9                	mov    %bl,%cl
  803d25:	d3 ee                	shr    %cl,%esi
  803d27:	89 f9                	mov    %edi,%ecx
  803d29:	d3 e2                	shl    %cl,%edx
  803d2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d2f:	88 d9                	mov    %bl,%cl
  803d31:	d3 e8                	shr    %cl,%eax
  803d33:	09 c2                	or     %eax,%edx
  803d35:	89 d0                	mov    %edx,%eax
  803d37:	89 f2                	mov    %esi,%edx
  803d39:	f7 74 24 0c          	divl   0xc(%esp)
  803d3d:	89 d6                	mov    %edx,%esi
  803d3f:	89 c3                	mov    %eax,%ebx
  803d41:	f7 e5                	mul    %ebp
  803d43:	39 d6                	cmp    %edx,%esi
  803d45:	72 19                	jb     803d60 <__udivdi3+0xfc>
  803d47:	74 0b                	je     803d54 <__udivdi3+0xf0>
  803d49:	89 d8                	mov    %ebx,%eax
  803d4b:	31 ff                	xor    %edi,%edi
  803d4d:	e9 58 ff ff ff       	jmp    803caa <__udivdi3+0x46>
  803d52:	66 90                	xchg   %ax,%ax
  803d54:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d58:	89 f9                	mov    %edi,%ecx
  803d5a:	d3 e2                	shl    %cl,%edx
  803d5c:	39 c2                	cmp    %eax,%edx
  803d5e:	73 e9                	jae    803d49 <__udivdi3+0xe5>
  803d60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d63:	31 ff                	xor    %edi,%edi
  803d65:	e9 40 ff ff ff       	jmp    803caa <__udivdi3+0x46>
  803d6a:	66 90                	xchg   %ax,%ax
  803d6c:	31 c0                	xor    %eax,%eax
  803d6e:	e9 37 ff ff ff       	jmp    803caa <__udivdi3+0x46>
  803d73:	90                   	nop

00803d74 <__umoddi3>:
  803d74:	55                   	push   %ebp
  803d75:	57                   	push   %edi
  803d76:	56                   	push   %esi
  803d77:	53                   	push   %ebx
  803d78:	83 ec 1c             	sub    $0x1c,%esp
  803d7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d93:	89 f3                	mov    %esi,%ebx
  803d95:	89 fa                	mov    %edi,%edx
  803d97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d9b:	89 34 24             	mov    %esi,(%esp)
  803d9e:	85 c0                	test   %eax,%eax
  803da0:	75 1a                	jne    803dbc <__umoddi3+0x48>
  803da2:	39 f7                	cmp    %esi,%edi
  803da4:	0f 86 a2 00 00 00    	jbe    803e4c <__umoddi3+0xd8>
  803daa:	89 c8                	mov    %ecx,%eax
  803dac:	89 f2                	mov    %esi,%edx
  803dae:	f7 f7                	div    %edi
  803db0:	89 d0                	mov    %edx,%eax
  803db2:	31 d2                	xor    %edx,%edx
  803db4:	83 c4 1c             	add    $0x1c,%esp
  803db7:	5b                   	pop    %ebx
  803db8:	5e                   	pop    %esi
  803db9:	5f                   	pop    %edi
  803dba:	5d                   	pop    %ebp
  803dbb:	c3                   	ret    
  803dbc:	39 f0                	cmp    %esi,%eax
  803dbe:	0f 87 ac 00 00 00    	ja     803e70 <__umoddi3+0xfc>
  803dc4:	0f bd e8             	bsr    %eax,%ebp
  803dc7:	83 f5 1f             	xor    $0x1f,%ebp
  803dca:	0f 84 ac 00 00 00    	je     803e7c <__umoddi3+0x108>
  803dd0:	bf 20 00 00 00       	mov    $0x20,%edi
  803dd5:	29 ef                	sub    %ebp,%edi
  803dd7:	89 fe                	mov    %edi,%esi
  803dd9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ddd:	89 e9                	mov    %ebp,%ecx
  803ddf:	d3 e0                	shl    %cl,%eax
  803de1:	89 d7                	mov    %edx,%edi
  803de3:	89 f1                	mov    %esi,%ecx
  803de5:	d3 ef                	shr    %cl,%edi
  803de7:	09 c7                	or     %eax,%edi
  803de9:	89 e9                	mov    %ebp,%ecx
  803deb:	d3 e2                	shl    %cl,%edx
  803ded:	89 14 24             	mov    %edx,(%esp)
  803df0:	89 d8                	mov    %ebx,%eax
  803df2:	d3 e0                	shl    %cl,%eax
  803df4:	89 c2                	mov    %eax,%edx
  803df6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dfa:	d3 e0                	shl    %cl,%eax
  803dfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e00:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e04:	89 f1                	mov    %esi,%ecx
  803e06:	d3 e8                	shr    %cl,%eax
  803e08:	09 d0                	or     %edx,%eax
  803e0a:	d3 eb                	shr    %cl,%ebx
  803e0c:	89 da                	mov    %ebx,%edx
  803e0e:	f7 f7                	div    %edi
  803e10:	89 d3                	mov    %edx,%ebx
  803e12:	f7 24 24             	mull   (%esp)
  803e15:	89 c6                	mov    %eax,%esi
  803e17:	89 d1                	mov    %edx,%ecx
  803e19:	39 d3                	cmp    %edx,%ebx
  803e1b:	0f 82 87 00 00 00    	jb     803ea8 <__umoddi3+0x134>
  803e21:	0f 84 91 00 00 00    	je     803eb8 <__umoddi3+0x144>
  803e27:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e2b:	29 f2                	sub    %esi,%edx
  803e2d:	19 cb                	sbb    %ecx,%ebx
  803e2f:	89 d8                	mov    %ebx,%eax
  803e31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e35:	d3 e0                	shl    %cl,%eax
  803e37:	89 e9                	mov    %ebp,%ecx
  803e39:	d3 ea                	shr    %cl,%edx
  803e3b:	09 d0                	or     %edx,%eax
  803e3d:	89 e9                	mov    %ebp,%ecx
  803e3f:	d3 eb                	shr    %cl,%ebx
  803e41:	89 da                	mov    %ebx,%edx
  803e43:	83 c4 1c             	add    $0x1c,%esp
  803e46:	5b                   	pop    %ebx
  803e47:	5e                   	pop    %esi
  803e48:	5f                   	pop    %edi
  803e49:	5d                   	pop    %ebp
  803e4a:	c3                   	ret    
  803e4b:	90                   	nop
  803e4c:	89 fd                	mov    %edi,%ebp
  803e4e:	85 ff                	test   %edi,%edi
  803e50:	75 0b                	jne    803e5d <__umoddi3+0xe9>
  803e52:	b8 01 00 00 00       	mov    $0x1,%eax
  803e57:	31 d2                	xor    %edx,%edx
  803e59:	f7 f7                	div    %edi
  803e5b:	89 c5                	mov    %eax,%ebp
  803e5d:	89 f0                	mov    %esi,%eax
  803e5f:	31 d2                	xor    %edx,%edx
  803e61:	f7 f5                	div    %ebp
  803e63:	89 c8                	mov    %ecx,%eax
  803e65:	f7 f5                	div    %ebp
  803e67:	89 d0                	mov    %edx,%eax
  803e69:	e9 44 ff ff ff       	jmp    803db2 <__umoddi3+0x3e>
  803e6e:	66 90                	xchg   %ax,%ax
  803e70:	89 c8                	mov    %ecx,%eax
  803e72:	89 f2                	mov    %esi,%edx
  803e74:	83 c4 1c             	add    $0x1c,%esp
  803e77:	5b                   	pop    %ebx
  803e78:	5e                   	pop    %esi
  803e79:	5f                   	pop    %edi
  803e7a:	5d                   	pop    %ebp
  803e7b:	c3                   	ret    
  803e7c:	3b 04 24             	cmp    (%esp),%eax
  803e7f:	72 06                	jb     803e87 <__umoddi3+0x113>
  803e81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e85:	77 0f                	ja     803e96 <__umoddi3+0x122>
  803e87:	89 f2                	mov    %esi,%edx
  803e89:	29 f9                	sub    %edi,%ecx
  803e8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e8f:	89 14 24             	mov    %edx,(%esp)
  803e92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e96:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e9a:	8b 14 24             	mov    (%esp),%edx
  803e9d:	83 c4 1c             	add    $0x1c,%esp
  803ea0:	5b                   	pop    %ebx
  803ea1:	5e                   	pop    %esi
  803ea2:	5f                   	pop    %edi
  803ea3:	5d                   	pop    %ebp
  803ea4:	c3                   	ret    
  803ea5:	8d 76 00             	lea    0x0(%esi),%esi
  803ea8:	2b 04 24             	sub    (%esp),%eax
  803eab:	19 fa                	sbb    %edi,%edx
  803ead:	89 d1                	mov    %edx,%ecx
  803eaf:	89 c6                	mov    %eax,%esi
  803eb1:	e9 71 ff ff ff       	jmp    803e27 <__umoddi3+0xb3>
  803eb6:	66 90                	xchg   %ax,%ax
  803eb8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ebc:	72 ea                	jb     803ea8 <__umoddi3+0x134>
  803ebe:	89 d9                	mov    %ebx,%ecx
  803ec0:	e9 62 ff ff ff       	jmp    803e27 <__umoddi3+0xb3>
