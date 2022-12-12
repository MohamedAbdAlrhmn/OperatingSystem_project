
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
  800045:	e8 d3 25 00 00       	call   80261d <sys_set_uheap_strategy>
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
  80009b:	68 40 3f 80 00       	push   $0x803f40
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 5c 3f 80 00       	push   $0x803f5c
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
  8000d8:	e8 2b 20 00 00       	call   802108 <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 c3 20 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  800110:	68 74 3f 80 00       	push   $0x803f74
  800115:	6a 26                	push   $0x26
  800117:	68 5c 3f 80 00       	push   $0x803f5c
  80011c:	e8 23 0b 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  800121:	e8 82 20 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  800126:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800129:	3d 00 03 00 00       	cmp    $0x300,%eax
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 a4 3f 80 00       	push   $0x803fa4
  800138:	6a 28                	push   $0x28
  80013a:	68 5c 3f 80 00       	push   $0x803f5c
  80013f:	e8 00 0b 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800144:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800147:	e8 bc 1f 00 00       	call   802108 <sys_calculate_free_frames>
  80014c:	29 c3                	sub    %eax,%ebx
  80014e:	89 d8                	mov    %ebx,%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 c1 3f 80 00       	push   $0x803fc1
  80015d:	6a 29                	push   $0x29
  80015f:	68 5c 3f 80 00       	push   $0x803f5c
  800164:	e8 db 0a 00 00       	call   800c44 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 9a 1f 00 00       	call   802108 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 32 20 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  8001ae:	68 74 3f 80 00       	push   $0x803f74
  8001b3:	6a 2f                	push   $0x2f
  8001b5:	68 5c 3f 80 00       	push   $0x803f5c
  8001ba:	e8 85 0a 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001bf:	e8 e4 1f 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  8001c4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c7:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 a4 3f 80 00       	push   $0x803fa4
  8001d6:	6a 31                	push   $0x31
  8001d8:	68 5c 3f 80 00       	push   $0x803f5c
  8001dd:	e8 62 0a 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001e5:	e8 1e 1f 00 00       	call   802108 <sys_calculate_free_frames>
  8001ea:	29 c3                	sub    %eax,%ebx
  8001ec:	89 d8                	mov    %ebx,%eax
  8001ee:	83 f8 01             	cmp    $0x1,%eax
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 c1 3f 80 00       	push   $0x803fc1
  8001fb:	6a 32                	push   $0x32
  8001fd:	68 5c 3f 80 00       	push   $0x803f5c
  800202:	e8 3d 0a 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800207:	e8 fc 1e 00 00       	call   802108 <sys_calculate_free_frames>
  80020c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020f:	e8 94 1f 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  80024a:	68 74 3f 80 00       	push   $0x803f74
  80024f:	6a 38                	push   $0x38
  800251:	68 5c 3f 80 00       	push   $0x803f5c
  800256:	e8 e9 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  80025b:	e8 48 1f 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  800260:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800263:	3d 00 02 00 00       	cmp    $0x200,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 a4 3f 80 00       	push   $0x803fa4
  800272:	6a 3a                	push   $0x3a
  800274:	68 5c 3f 80 00       	push   $0x803f5c
  800279:	e8 c6 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80027e:	e8 85 1e 00 00       	call   802108 <sys_calculate_free_frames>
  800283:	89 c2                	mov    %eax,%edx
  800285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800288:	39 c2                	cmp    %eax,%edx
  80028a:	74 14                	je     8002a0 <_main+0x268>
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 c1 3f 80 00       	push   $0x803fc1
  800294:	6a 3b                	push   $0x3b
  800296:	68 5c 3f 80 00       	push   $0x803f5c
  80029b:	e8 a4 09 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002a0:	e8 63 1e 00 00       	call   802108 <sys_calculate_free_frames>
  8002a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002a8:	e8 fb 1e 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  8002de:	68 74 3f 80 00       	push   $0x803f74
  8002e3:	6a 41                	push   $0x41
  8002e5:	68 5c 3f 80 00       	push   $0x803f5c
  8002ea:	e8 55 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002ef:	e8 b4 1e 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  8002f4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 a4 3f 80 00       	push   $0x803fa4
  800306:	6a 43                	push   $0x43
  800308:	68 5c 3f 80 00       	push   $0x803f5c
  80030d:	e8 32 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800312:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800315:	e8 ee 1d 00 00       	call   802108 <sys_calculate_free_frames>
  80031a:	29 c3                	sub    %eax,%ebx
  80031c:	89 d8                	mov    %ebx,%eax
  80031e:	83 f8 01             	cmp    $0x1,%eax
  800321:	74 14                	je     800337 <_main+0x2ff>
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	68 c1 3f 80 00       	push   $0x803fc1
  80032b:	6a 44                	push   $0x44
  80032d:	68 5c 3f 80 00       	push   $0x803f5c
  800332:	e8 0d 09 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800337:	e8 cc 1d 00 00       	call   802108 <sys_calculate_free_frames>
  80033c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80033f:	e8 64 1e 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  800379:	68 74 3f 80 00       	push   $0x803f74
  80037e:	6a 4a                	push   $0x4a
  800380:	68 5c 3f 80 00       	push   $0x803f5c
  800385:	e8 ba 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80038a:	e8 19 1e 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  80038f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800392:	3d 00 01 00 00       	cmp    $0x100,%eax
  800397:	74 14                	je     8003ad <_main+0x375>
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 a4 3f 80 00       	push   $0x803fa4
  8003a1:	6a 4c                	push   $0x4c
  8003a3:	68 5c 3f 80 00       	push   $0x803f5c
  8003a8:	e8 97 08 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003ad:	e8 56 1d 00 00       	call   802108 <sys_calculate_free_frames>
  8003b2:	89 c2                	mov    %eax,%edx
  8003b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	74 14                	je     8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 c1 3f 80 00       	push   $0x803fc1
  8003c3:	6a 4d                	push   $0x4d
  8003c5:	68 5c 3f 80 00       	push   $0x803f5c
  8003ca:	e8 75 08 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cf:	e8 34 1d 00 00       	call   802108 <sys_calculate_free_frames>
  8003d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d7:	e8 cc 1d 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  800413:	68 74 3f 80 00       	push   $0x803f74
  800418:	6a 53                	push   $0x53
  80041a:	68 5c 3f 80 00       	push   $0x803f5c
  80041f:	e8 20 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800424:	e8 7f 1d 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  800429:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80042c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800431:	74 14                	je     800447 <_main+0x40f>
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	68 a4 3f 80 00       	push   $0x803fa4
  80043b:	6a 55                	push   $0x55
  80043d:	68 5c 3f 80 00       	push   $0x803f5c
  800442:	e8 fd 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800447:	e8 bc 1c 00 00       	call   802108 <sys_calculate_free_frames>
  80044c:	89 c2                	mov    %eax,%edx
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	74 14                	je     800469 <_main+0x431>
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 c1 3f 80 00       	push   $0x803fc1
  80045d:	6a 56                	push   $0x56
  80045f:	68 5c 3f 80 00       	push   $0x803f5c
  800464:	e8 db 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800469:	e8 9a 1c 00 00       	call   802108 <sys_calculate_free_frames>
  80046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800471:	e8 32 1d 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  8004ab:	68 74 3f 80 00       	push   $0x803f74
  8004b0:	6a 5c                	push   $0x5c
  8004b2:	68 5c 3f 80 00       	push   $0x803f5c
  8004b7:	e8 88 07 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004bc:	e8 e7 1c 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  8004c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 a4 3f 80 00       	push   $0x803fa4
  8004d3:	6a 5e                	push   $0x5e
  8004d5:	68 5c 3f 80 00       	push   $0x803f5c
  8004da:	e8 65 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004e2:	e8 21 1c 00 00       	call   802108 <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	83 f8 01             	cmp    $0x1,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 c1 3f 80 00       	push   $0x803fc1
  8004f8:	6a 5f                	push   $0x5f
  8004fa:	68 5c 3f 80 00       	push   $0x803f5c
  8004ff:	e8 40 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800504:	e8 ff 1b 00 00       	call   802108 <sys_calculate_free_frames>
  800509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80050c:	e8 97 1c 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  800548:	68 74 3f 80 00       	push   $0x803f74
  80054d:	6a 65                	push   $0x65
  80054f:	68 5c 3f 80 00       	push   $0x803f5c
  800554:	e8 eb 06 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800559:	e8 4a 1c 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  80055e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800561:	3d 00 01 00 00       	cmp    $0x100,%eax
  800566:	74 14                	je     80057c <_main+0x544>
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	68 a4 3f 80 00       	push   $0x803fa4
  800570:	6a 67                	push   $0x67
  800572:	68 5c 3f 80 00       	push   $0x803f5c
  800577:	e8 c8 06 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80057c:	e8 87 1b 00 00       	call   802108 <sys_calculate_free_frames>
  800581:	89 c2                	mov    %eax,%edx
  800583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	74 14                	je     80059e <_main+0x566>
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 c1 3f 80 00       	push   $0x803fc1
  800592:	6a 68                	push   $0x68
  800594:	68 5c 3f 80 00       	push   $0x803f5c
  800599:	e8 a6 06 00 00       	call   800c44 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80059e:	e8 65 1b 00 00       	call   802108 <sys_calculate_free_frames>
  8005a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005a6:	e8 fd 1b 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	50                   	push   %eax
  8005b5:	e8 f4 18 00 00       	call   801eae <free>
  8005ba:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005bd:	e8 e6 1b 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  8005c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c5:	29 c2                	sub    %eax,%edx
  8005c7:	89 d0                	mov    %edx,%eax
  8005c9:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 d4 3f 80 00       	push   $0x803fd4
  8005d8:	6a 72                	push   $0x72
  8005da:	68 5c 3f 80 00       	push   $0x803f5c
  8005df:	e8 60 06 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005e4:	e8 1f 1b 00 00       	call   802108 <sys_calculate_free_frames>
  8005e9:	89 c2                	mov    %eax,%edx
  8005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ee:	39 c2                	cmp    %eax,%edx
  8005f0:	74 14                	je     800606 <_main+0x5ce>
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 eb 3f 80 00       	push   $0x803feb
  8005fa:	6a 73                	push   $0x73
  8005fc:	68 5c 3f 80 00       	push   $0x803f5c
  800601:	e8 3e 06 00 00       	call   800c44 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800606:	e8 fd 1a 00 00       	call   802108 <sys_calculate_free_frames>
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060e:	e8 95 1b 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  800613:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800616:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	50                   	push   %eax
  80061d:	e8 8c 18 00 00       	call   801eae <free>
  800622:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800625:	e8 7e 1b 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  80062a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062d:	29 c2                	sub    %eax,%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	3d 00 02 00 00       	cmp    $0x200,%eax
  800636:	74 14                	je     80064c <_main+0x614>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 d4 3f 80 00       	push   $0x803fd4
  800640:	6a 7a                	push   $0x7a
  800642:	68 5c 3f 80 00       	push   $0x803f5c
  800647:	e8 f8 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064c:	e8 b7 1a 00 00       	call   802108 <sys_calculate_free_frames>
  800651:	89 c2                	mov    %eax,%edx
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	74 14                	je     80066e <_main+0x636>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 eb 3f 80 00       	push   $0x803feb
  800662:	6a 7b                	push   $0x7b
  800664:	68 5c 3f 80 00       	push   $0x803f5c
  800669:	e8 d6 05 00 00       	call   800c44 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80066e:	e8 95 1a 00 00       	call   802108 <sys_calculate_free_frames>
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800676:	e8 2d 1b 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80067e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800681:	83 ec 0c             	sub    $0xc,%esp
  800684:	50                   	push   %eax
  800685:	e8 24 18 00 00       	call   801eae <free>
  80068a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80068d:	e8 16 1b 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  800692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	3d 00 01 00 00       	cmp    $0x100,%eax
  80069e:	74 17                	je     8006b7 <_main+0x67f>
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	68 d4 3f 80 00       	push   $0x803fd4
  8006a8:	68 82 00 00 00       	push   $0x82
  8006ad:	68 5c 3f 80 00       	push   $0x803f5c
  8006b2:	e8 8d 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006b7:	e8 4c 1a 00 00       	call   802108 <sys_calculate_free_frames>
  8006bc:	89 c2                	mov    %eax,%edx
  8006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	74 17                	je     8006dc <_main+0x6a4>
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	68 eb 3f 80 00       	push   $0x803feb
  8006cd:	68 83 00 00 00       	push   $0x83
  8006d2:	68 5c 3f 80 00       	push   $0x803f5c
  8006d7:	e8 68 05 00 00       	call   800c44 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006dc:	e8 27 1a 00 00       	call   802108 <sys_calculate_free_frames>
  8006e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006e4:	e8 bf 1a 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  800720:	68 74 3f 80 00       	push   $0x803f74
  800725:	68 8c 00 00 00       	push   $0x8c
  80072a:	68 5c 3f 80 00       	push   $0x803f5c
  80072f:	e8 10 05 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800734:	e8 6f 1a 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  800739:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80073c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800741:	74 17                	je     80075a <_main+0x722>
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	68 a4 3f 80 00       	push   $0x803fa4
  80074b:	68 8e 00 00 00       	push   $0x8e
  800750:	68 5c 3f 80 00       	push   $0x803f5c
  800755:	e8 ea 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80075a:	e8 a9 19 00 00       	call   802108 <sys_calculate_free_frames>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 c1 3f 80 00       	push   $0x803fc1
  800770:	68 8f 00 00 00       	push   $0x8f
  800775:	68 5c 3f 80 00       	push   $0x803f5c
  80077a:	e8 c5 04 00 00       	call   800c44 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80077f:	e8 84 19 00 00       	call   802108 <sys_calculate_free_frames>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800787:	e8 1c 1a 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  8007bb:	68 74 3f 80 00       	push   $0x803f74
  8007c0:	68 95 00 00 00       	push   $0x95
  8007c5:	68 5c 3f 80 00       	push   $0x803f5c
  8007ca:	e8 75 04 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007cf:	e8 d4 19 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  8007d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007d7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007dc:	74 17                	je     8007f5 <_main+0x7bd>
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	68 a4 3f 80 00       	push   $0x803fa4
  8007e6:	68 97 00 00 00       	push   $0x97
  8007eb:	68 5c 3f 80 00       	push   $0x803f5c
  8007f0:	e8 4f 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007f5:	e8 0e 19 00 00       	call   802108 <sys_calculate_free_frames>
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 17                	je     80081a <_main+0x7e2>
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	68 c1 3f 80 00       	push   $0x803fc1
  80080b:	68 98 00 00 00       	push   $0x98
  800810:	68 5c 3f 80 00       	push   $0x803f5c
  800815:	e8 2a 04 00 00       	call   800c44 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80081a:	e8 e9 18 00 00       	call   802108 <sys_calculate_free_frames>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800822:	e8 81 19 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  80086c:	68 74 3f 80 00       	push   $0x803f74
  800871:	68 9e 00 00 00       	push   $0x9e
  800876:	68 5c 3f 80 00       	push   $0x803f5c
  80087b:	e8 c4 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800880:	e8 23 19 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  800885:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800888:	83 f8 40             	cmp    $0x40,%eax
  80088b:	74 17                	je     8008a4 <_main+0x86c>
  80088d:	83 ec 04             	sub    $0x4,%esp
  800890:	68 a4 3f 80 00       	push   $0x803fa4
  800895:	68 a0 00 00 00       	push   $0xa0
  80089a:	68 5c 3f 80 00       	push   $0x803f5c
  80089f:	e8 a0 03 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008a4:	e8 5f 18 00 00       	call   802108 <sys_calculate_free_frames>
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 c1 3f 80 00       	push   $0x803fc1
  8008ba:	68 a1 00 00 00       	push   $0xa1
  8008bf:	68 5c 3f 80 00       	push   $0x803f5c
  8008c4:	e8 7b 03 00 00       	call   800c44 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 3a 18 00 00       	call   802108 <sys_calculate_free_frames>
  8008ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008d1:	e8 d2 18 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  800911:	68 74 3f 80 00       	push   $0x803f74
  800916:	68 a7 00 00 00       	push   $0xa7
  80091b:	68 5c 3f 80 00       	push   $0x803f5c
  800920:	e8 1f 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800925:	e8 7e 18 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  80092a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80092d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 a4 3f 80 00       	push   $0x803fa4
  80093c:	68 a9 00 00 00       	push   $0xa9
  800941:	68 5c 3f 80 00       	push   $0x803f5c
  800946:	e8 f9 02 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80094b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80094e:	e8 b5 17 00 00       	call   802108 <sys_calculate_free_frames>
  800953:	29 c3                	sub    %eax,%ebx
  800955:	89 d8                	mov    %ebx,%eax
  800957:	83 f8 01             	cmp    $0x1,%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 c1 3f 80 00       	push   $0x803fc1
  800964:	68 aa 00 00 00       	push   $0xaa
  800969:	68 5c 3f 80 00       	push   $0x803f5c
  80096e:	e8 d1 02 00 00       	call   800c44 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  800973:	e8 90 17 00 00       	call   802108 <sys_calculate_free_frames>
  800978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80097b:	e8 28 18 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  800983:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800986:	83 ec 0c             	sub    $0xc,%esp
  800989:	50                   	push   %eax
  80098a:	e8 1f 15 00 00       	call   801eae <free>
  80098f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800992:	e8 11 18 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  800997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099a:	29 c2                	sub    %eax,%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009a3:	74 17                	je     8009bc <_main+0x984>
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 d4 3f 80 00       	push   $0x803fd4
  8009ad:	68 b4 00 00 00       	push   $0xb4
  8009b2:	68 5c 3f 80 00       	push   $0x803f5c
  8009b7:	e8 88 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009bc:	e8 47 17 00 00       	call   802108 <sys_calculate_free_frames>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 17                	je     8009e1 <_main+0x9a9>
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	68 eb 3f 80 00       	push   $0x803feb
  8009d2:	68 b5 00 00 00       	push   $0xb5
  8009d7:	68 5c 3f 80 00       	push   $0x803f5c
  8009dc:	e8 63 02 00 00       	call   800c44 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  8009e1:	e8 22 17 00 00       	call   802108 <sys_calculate_free_frames>
  8009e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e9:	e8 ba 17 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  8009f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8009f4:	83 ec 0c             	sub    $0xc,%esp
  8009f7:	50                   	push   %eax
  8009f8:	e8 b1 14 00 00       	call   801eae <free>
  8009fd:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800a00:	e8 a3 17 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  800a05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a08:	29 c2                	sub    %eax,%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800a11:	74 17                	je     800a2a <_main+0x9f2>
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	68 d4 3f 80 00       	push   $0x803fd4
  800a1b:	68 bc 00 00 00       	push   $0xbc
  800a20:	68 5c 3f 80 00       	push   $0x803f5c
  800a25:	e8 1a 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2a:	e8 d9 16 00 00       	call   802108 <sys_calculate_free_frames>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 eb 3f 80 00       	push   $0x803feb
  800a40:	68 bd 00 00 00       	push   $0xbd
  800a45:	68 5c 3f 80 00       	push   $0x803f5c
  800a4a:	e8 f5 01 00 00       	call   800c44 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a4f:	e8 b4 16 00 00       	call   802108 <sys_calculate_free_frames>
  800a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a57:	e8 4c 17 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
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
  800a91:	68 74 3f 80 00       	push   $0x803f74
  800a96:	68 c6 00 00 00       	push   $0xc6
  800a9b:	68 5c 3f 80 00       	push   $0x803f5c
  800aa0:	e8 9f 01 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800aa5:	e8 fe 16 00 00       	call   8021a8 <sys_pf_calculate_allocated_pages>
  800aaa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800aad:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 a4 3f 80 00       	push   $0x803fa4
  800abc:	68 c8 00 00 00       	push   $0xc8
  800ac1:	68 5c 3f 80 00       	push   $0x803f5c
  800ac6:	e8 79 01 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800acb:	e8 38 16 00 00       	call   802108 <sys_calculate_free_frames>
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad5:	39 c2                	cmp    %eax,%edx
  800ad7:	74 17                	je     800af0 <_main+0xab8>
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	68 c1 3f 80 00       	push   $0x803fc1
  800ae1:	68 c9 00 00 00       	push   $0xc9
  800ae6:	68 5c 3f 80 00       	push   $0x803f5c
  800aeb:	e8 54 01 00 00       	call   800c44 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800af0:	83 ec 0c             	sub    $0xc,%esp
  800af3:	68 f8 3f 80 00       	push   $0x803ff8
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
  800b0e:	e8 d5 18 00 00       	call   8023e8 <sys_getenvindex>
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
  800b79:	e8 77 16 00 00       	call   8021f5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	68 58 40 80 00       	push   $0x804058
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
  800ba9:	68 80 40 80 00       	push   $0x804080
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
  800bda:	68 a8 40 80 00       	push   $0x8040a8
  800bdf:	e8 14 03 00 00       	call   800ef8 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800be7:	a1 20 50 80 00       	mov    0x805020,%eax
  800bec:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	68 00 41 80 00       	push   $0x804100
  800bfb:	e8 f8 02 00 00       	call   800ef8 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	68 58 40 80 00       	push   $0x804058
  800c0b:	e8 e8 02 00 00       	call   800ef8 <cprintf>
  800c10:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c13:	e8 f7 15 00 00       	call   80220f <sys_enable_interrupt>

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
  800c2b:	e8 84 17 00 00       	call   8023b4 <sys_destroy_env>
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
  800c3c:	e8 d9 17 00 00       	call   80241a <sys_exit_env>
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
  800c65:	68 14 41 80 00       	push   $0x804114
  800c6a:	e8 89 02 00 00       	call   800ef8 <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c72:	a1 00 50 80 00       	mov    0x805000,%eax
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	ff 75 08             	pushl  0x8(%ebp)
  800c7d:	50                   	push   %eax
  800c7e:	68 19 41 80 00       	push   $0x804119
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
  800ca2:	68 35 41 80 00       	push   $0x804135
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
  800cce:	68 38 41 80 00       	push   $0x804138
  800cd3:	6a 26                	push   $0x26
  800cd5:	68 84 41 80 00       	push   $0x804184
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
  800da0:	68 90 41 80 00       	push   $0x804190
  800da5:	6a 3a                	push   $0x3a
  800da7:	68 84 41 80 00       	push   $0x804184
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
  800e10:	68 e4 41 80 00       	push   $0x8041e4
  800e15:	6a 44                	push   $0x44
  800e17:	68 84 41 80 00       	push   $0x804184
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
  800e6a:	e8 d8 11 00 00       	call   802047 <sys_cputs>
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
  800ee1:	e8 61 11 00 00       	call   802047 <sys_cputs>
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
  800f2b:	e8 c5 12 00 00       	call   8021f5 <sys_disable_interrupt>
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
  800f4b:	e8 bf 12 00 00       	call   80220f <sys_enable_interrupt>
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
  800f95:	e8 32 2d 00 00       	call   803ccc <__udivdi3>
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
  800fe5:	e8 f2 2d 00 00       	call   803ddc <__umoddi3>
  800fea:	83 c4 10             	add    $0x10,%esp
  800fed:	05 54 44 80 00       	add    $0x804454,%eax
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
  801140:	8b 04 85 78 44 80 00 	mov    0x804478(,%eax,4),%eax
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
  801221:	8b 34 9d c0 42 80 00 	mov    0x8042c0(,%ebx,4),%esi
  801228:	85 f6                	test   %esi,%esi
  80122a:	75 19                	jne    801245 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80122c:	53                   	push   %ebx
  80122d:	68 65 44 80 00       	push   $0x804465
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
  801246:	68 6e 44 80 00       	push   $0x80446e
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
  801273:	be 71 44 80 00       	mov    $0x804471,%esi
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
  801c99:	68 d0 45 80 00       	push   $0x8045d0
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801d4c:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801d53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d5b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	6a 06                	push   $0x6
  801d65:	ff 75 f4             	pushl  -0xc(%ebp)
  801d68:	50                   	push   %eax
  801d69:	e8 1d 04 00 00       	call   80218b <sys_allocate_chunk>
  801d6e:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801d71:	a1 20 51 80 00       	mov    0x805120,%eax
  801d76:	83 ec 0c             	sub    $0xc,%esp
  801d79:	50                   	push   %eax
  801d7a:	e8 92 0a 00 00       	call   802811 <initialize_MemBlocksList>
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
  801da7:	68 f5 45 80 00       	push   $0x8045f5
  801dac:	6a 33                	push   $0x33
  801dae:	68 13 46 80 00       	push   $0x804613
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
  801e26:	68 20 46 80 00       	push   $0x804620
  801e2b:	6a 34                	push   $0x34
  801e2d:	68 13 46 80 00       	push   $0x804613
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
  801e9b:	68 44 46 80 00       	push   $0x804644
  801ea0:	6a 46                	push   $0x46
  801ea2:	68 13 46 80 00       	push   $0x804613
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
  801eb7:	68 6c 46 80 00       	push   $0x80466c
  801ebc:	6a 61                	push   $0x61
  801ebe:	68 13 46 80 00       	push   $0x804613
  801ec3:	e8 7c ed ff ff       	call   800c44 <_panic>

00801ec8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 38             	sub    $0x38,%esp
  801ece:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed1:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ed4:	e8 a9 fd ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ed9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801edd:	75 07                	jne    801ee6 <smalloc+0x1e>
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee4:	eb 7c                	jmp    801f62 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801ee6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef3:	01 d0                	add    %edx,%eax
  801ef5:	48                   	dec    %eax
  801ef6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efc:	ba 00 00 00 00       	mov    $0x0,%edx
  801f01:	f7 75 f0             	divl   -0x10(%ebp)
  801f04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f07:	29 d0                	sub    %edx,%eax
  801f09:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801f0c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f13:	e8 41 06 00 00       	call   802559 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	74 11                	je     801f2d <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801f1c:	83 ec 0c             	sub    $0xc,%esp
  801f1f:	ff 75 e8             	pushl  -0x18(%ebp)
  801f22:	e8 ac 0c 00 00       	call   802bd3 <alloc_block_FF>
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f31:	74 2a                	je     801f5d <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f36:	8b 40 08             	mov    0x8(%eax),%eax
  801f39:	89 c2                	mov    %eax,%edx
  801f3b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f3f:	52                   	push   %edx
  801f40:	50                   	push   %eax
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	ff 75 08             	pushl  0x8(%ebp)
  801f47:	e8 92 03 00 00       	call   8022de <sys_createSharedObject>
  801f4c:	83 c4 10             	add    $0x10,%esp
  801f4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801f52:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801f56:	74 05                	je     801f5d <smalloc+0x95>
			return (void*)virtual_address;
  801f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f5b:	eb 05                	jmp    801f62 <smalloc+0x9a>
	}
	return NULL;
  801f5d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f6a:	e8 13 fd ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801f6f:	83 ec 04             	sub    $0x4,%esp
  801f72:	68 90 46 80 00       	push   $0x804690
  801f77:	68 a2 00 00 00       	push   $0xa2
  801f7c:	68 13 46 80 00       	push   $0x804613
  801f81:	e8 be ec ff ff       	call   800c44 <_panic>

00801f86 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f8c:	e8 f1 fc ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f91:	83 ec 04             	sub    $0x4,%esp
  801f94:	68 b4 46 80 00       	push   $0x8046b4
  801f99:	68 e6 00 00 00       	push   $0xe6
  801f9e:	68 13 46 80 00       	push   $0x804613
  801fa3:	e8 9c ec ff ff       	call   800c44 <_panic>

00801fa8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fae:	83 ec 04             	sub    $0x4,%esp
  801fb1:	68 dc 46 80 00       	push   $0x8046dc
  801fb6:	68 fa 00 00 00       	push   $0xfa
  801fbb:	68 13 46 80 00       	push   $0x804613
  801fc0:	e8 7f ec ff ff       	call   800c44 <_panic>

00801fc5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fcb:	83 ec 04             	sub    $0x4,%esp
  801fce:	68 00 47 80 00       	push   $0x804700
  801fd3:	68 05 01 00 00       	push   $0x105
  801fd8:	68 13 46 80 00       	push   $0x804613
  801fdd:	e8 62 ec ff ff       	call   800c44 <_panic>

00801fe2 <shrink>:

}
void shrink(uint32 newSize)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	68 00 47 80 00       	push   $0x804700
  801ff0:	68 0a 01 00 00       	push   $0x10a
  801ff5:	68 13 46 80 00       	push   $0x804613
  801ffa:	e8 45 ec ff ff       	call   800c44 <_panic>

00801fff <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802005:	83 ec 04             	sub    $0x4,%esp
  802008:	68 00 47 80 00       	push   $0x804700
  80200d:	68 0f 01 00 00       	push   $0x10f
  802012:	68 13 46 80 00       	push   $0x804613
  802017:	e8 28 ec ff ff       	call   800c44 <_panic>

0080201c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	57                   	push   %edi
  802020:	56                   	push   %esi
  802021:	53                   	push   %ebx
  802022:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802031:	8b 7d 18             	mov    0x18(%ebp),%edi
  802034:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802037:	cd 30                	int    $0x30
  802039:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80203c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80203f:	83 c4 10             	add    $0x10,%esp
  802042:	5b                   	pop    %ebx
  802043:	5e                   	pop    %esi
  802044:	5f                   	pop    %edi
  802045:	5d                   	pop    %ebp
  802046:	c3                   	ret    

00802047 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	83 ec 04             	sub    $0x4,%esp
  80204d:	8b 45 10             	mov    0x10(%ebp),%eax
  802050:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802053:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	52                   	push   %edx
  80205f:	ff 75 0c             	pushl  0xc(%ebp)
  802062:	50                   	push   %eax
  802063:	6a 00                	push   $0x0
  802065:	e8 b2 ff ff ff       	call   80201c <syscall>
  80206a:	83 c4 18             	add    $0x18,%esp
}
  80206d:	90                   	nop
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <sys_cgetc>:

int
sys_cgetc(void)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 01                	push   $0x1
  80207f:	e8 98 ff ff ff       	call   80201c <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80208c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	52                   	push   %edx
  802099:	50                   	push   %eax
  80209a:	6a 05                	push   $0x5
  80209c:	e8 7b ff ff ff       	call   80201c <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	56                   	push   %esi
  8020aa:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020ab:	8b 75 18             	mov    0x18(%ebp),%esi
  8020ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	56                   	push   %esi
  8020bb:	53                   	push   %ebx
  8020bc:	51                   	push   %ecx
  8020bd:	52                   	push   %edx
  8020be:	50                   	push   %eax
  8020bf:	6a 06                	push   $0x6
  8020c1:	e8 56 ff ff ff       	call   80201c <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020cc:	5b                   	pop    %ebx
  8020cd:	5e                   	pop    %esi
  8020ce:	5d                   	pop    %ebp
  8020cf:	c3                   	ret    

008020d0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	52                   	push   %edx
  8020e0:	50                   	push   %eax
  8020e1:	6a 07                	push   $0x7
  8020e3:	e8 34 ff ff ff       	call   80201c <syscall>
  8020e8:	83 c4 18             	add    $0x18,%esp
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	ff 75 0c             	pushl  0xc(%ebp)
  8020f9:	ff 75 08             	pushl  0x8(%ebp)
  8020fc:	6a 08                	push   $0x8
  8020fe:	e8 19 ff ff ff       	call   80201c <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 09                	push   $0x9
  802117:	e8 00 ff ff ff       	call   80201c <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 0a                	push   $0xa
  802130:	e8 e7 fe ff ff       	call   80201c <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 0b                	push   $0xb
  802149:	e8 ce fe ff ff       	call   80201c <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	ff 75 0c             	pushl  0xc(%ebp)
  80215f:	ff 75 08             	pushl  0x8(%ebp)
  802162:	6a 0f                	push   $0xf
  802164:	e8 b3 fe ff ff       	call   80201c <syscall>
  802169:	83 c4 18             	add    $0x18,%esp
	return;
  80216c:	90                   	nop
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	ff 75 0c             	pushl  0xc(%ebp)
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	6a 10                	push   $0x10
  802180:	e8 97 fe ff ff       	call   80201c <syscall>
  802185:	83 c4 18             	add    $0x18,%esp
	return ;
  802188:	90                   	nop
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	ff 75 10             	pushl  0x10(%ebp)
  802195:	ff 75 0c             	pushl  0xc(%ebp)
  802198:	ff 75 08             	pushl  0x8(%ebp)
  80219b:	6a 11                	push   $0x11
  80219d:	e8 7a fe ff ff       	call   80201c <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a5:	90                   	nop
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 0c                	push   $0xc
  8021b7:	e8 60 fe ff ff       	call   80201c <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	ff 75 08             	pushl  0x8(%ebp)
  8021cf:	6a 0d                	push   $0xd
  8021d1:	e8 46 fe ff ff       	call   80201c <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 0e                	push   $0xe
  8021ea:	e8 2d fe ff ff       	call   80201c <syscall>
  8021ef:	83 c4 18             	add    $0x18,%esp
}
  8021f2:	90                   	nop
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 13                	push   $0x13
  802204:	e8 13 fe ff ff       	call   80201c <syscall>
  802209:	83 c4 18             	add    $0x18,%esp
}
  80220c:	90                   	nop
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 14                	push   $0x14
  80221e:	e8 f9 fd ff ff       	call   80201c <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
}
  802226:	90                   	nop
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <sys_cputc>:


void
sys_cputc(const char c)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	83 ec 04             	sub    $0x4,%esp
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802235:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	50                   	push   %eax
  802242:	6a 15                	push   $0x15
  802244:	e8 d3 fd ff ff       	call   80201c <syscall>
  802249:	83 c4 18             	add    $0x18,%esp
}
  80224c:	90                   	nop
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 16                	push   $0x16
  80225e:	e8 b9 fd ff ff       	call   80201c <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
}
  802266:	90                   	nop
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	ff 75 0c             	pushl  0xc(%ebp)
  802278:	50                   	push   %eax
  802279:	6a 17                	push   $0x17
  80227b:	e8 9c fd ff ff       	call   80201c <syscall>
  802280:	83 c4 18             	add    $0x18,%esp
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802288:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	52                   	push   %edx
  802295:	50                   	push   %eax
  802296:	6a 1a                	push   $0x1a
  802298:	e8 7f fd ff ff       	call   80201c <syscall>
  80229d:	83 c4 18             	add    $0x18,%esp
}
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	52                   	push   %edx
  8022b2:	50                   	push   %eax
  8022b3:	6a 18                	push   $0x18
  8022b5:	e8 62 fd ff ff       	call   80201c <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	90                   	nop
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	52                   	push   %edx
  8022d0:	50                   	push   %eax
  8022d1:	6a 19                	push   $0x19
  8022d3:	e8 44 fd ff ff       	call   80201c <syscall>
  8022d8:	83 c4 18             	add    $0x18,%esp
}
  8022db:	90                   	nop
  8022dc:	c9                   	leave  
  8022dd:	c3                   	ret    

008022de <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	83 ec 04             	sub    $0x4,%esp
  8022e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022ea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022ed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	6a 00                	push   $0x0
  8022f6:	51                   	push   %ecx
  8022f7:	52                   	push   %edx
  8022f8:	ff 75 0c             	pushl  0xc(%ebp)
  8022fb:	50                   	push   %eax
  8022fc:	6a 1b                	push   $0x1b
  8022fe:	e8 19 fd ff ff       	call   80201c <syscall>
  802303:	83 c4 18             	add    $0x18,%esp
}
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80230b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230e:	8b 45 08             	mov    0x8(%ebp),%eax
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	52                   	push   %edx
  802318:	50                   	push   %eax
  802319:	6a 1c                	push   $0x1c
  80231b:	e8 fc fc ff ff       	call   80201c <syscall>
  802320:	83 c4 18             	add    $0x18,%esp
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802328:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80232b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	51                   	push   %ecx
  802336:	52                   	push   %edx
  802337:	50                   	push   %eax
  802338:	6a 1d                	push   $0x1d
  80233a:	e8 dd fc ff ff       	call   80201c <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802347:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	52                   	push   %edx
  802354:	50                   	push   %eax
  802355:	6a 1e                	push   $0x1e
  802357:	e8 c0 fc ff ff       	call   80201c <syscall>
  80235c:	83 c4 18             	add    $0x18,%esp
}
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 1f                	push   $0x1f
  802370:	e8 a7 fc ff ff       	call   80201c <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	6a 00                	push   $0x0
  802382:	ff 75 14             	pushl  0x14(%ebp)
  802385:	ff 75 10             	pushl  0x10(%ebp)
  802388:	ff 75 0c             	pushl  0xc(%ebp)
  80238b:	50                   	push   %eax
  80238c:	6a 20                	push   $0x20
  80238e:	e8 89 fc ff ff       	call   80201c <syscall>
  802393:	83 c4 18             	add    $0x18,%esp
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	50                   	push   %eax
  8023a7:	6a 21                	push   $0x21
  8023a9:	e8 6e fc ff ff       	call   80201c <syscall>
  8023ae:	83 c4 18             	add    $0x18,%esp
}
  8023b1:	90                   	nop
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	50                   	push   %eax
  8023c3:	6a 22                	push   $0x22
  8023c5:	e8 52 fc ff ff       	call   80201c <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 02                	push   $0x2
  8023de:	e8 39 fc ff ff       	call   80201c <syscall>
  8023e3:	83 c4 18             	add    $0x18,%esp
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 03                	push   $0x3
  8023f7:	e8 20 fc ff ff       	call   80201c <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
}
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 04                	push   $0x4
  802410:	e8 07 fc ff ff       	call   80201c <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <sys_exit_env>:


void sys_exit_env(void)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 23                	push   $0x23
  802429:	e8 ee fb ff ff       	call   80201c <syscall>
  80242e:	83 c4 18             	add    $0x18,%esp
}
  802431:	90                   	nop
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80243a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80243d:	8d 50 04             	lea    0x4(%eax),%edx
  802440:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	52                   	push   %edx
  80244a:	50                   	push   %eax
  80244b:	6a 24                	push   $0x24
  80244d:	e8 ca fb ff ff       	call   80201c <syscall>
  802452:	83 c4 18             	add    $0x18,%esp
	return result;
  802455:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802458:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80245b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80245e:	89 01                	mov    %eax,(%ecx)
  802460:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	c9                   	leave  
  802467:	c2 04 00             	ret    $0x4

0080246a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	ff 75 10             	pushl  0x10(%ebp)
  802474:	ff 75 0c             	pushl  0xc(%ebp)
  802477:	ff 75 08             	pushl  0x8(%ebp)
  80247a:	6a 12                	push   $0x12
  80247c:	e8 9b fb ff ff       	call   80201c <syscall>
  802481:	83 c4 18             	add    $0x18,%esp
	return ;
  802484:	90                   	nop
}
  802485:	c9                   	leave  
  802486:	c3                   	ret    

00802487 <sys_rcr2>:
uint32 sys_rcr2()
{
  802487:	55                   	push   %ebp
  802488:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 25                	push   $0x25
  802496:	e8 81 fb ff ff       	call   80201c <syscall>
  80249b:	83 c4 18             	add    $0x18,%esp
}
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    

008024a0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
  8024a3:	83 ec 04             	sub    $0x4,%esp
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024ac:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	50                   	push   %eax
  8024b9:	6a 26                	push   $0x26
  8024bb:	e8 5c fb ff ff       	call   80201c <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c3:	90                   	nop
}
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <rsttst>:
void rsttst()
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 28                	push   $0x28
  8024d5:	e8 42 fb ff ff       	call   80201c <syscall>
  8024da:	83 c4 18             	add    $0x18,%esp
	return ;
  8024dd:	90                   	nop
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	83 ec 04             	sub    $0x4,%esp
  8024e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8024e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024ec:	8b 55 18             	mov    0x18(%ebp),%edx
  8024ef:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024f3:	52                   	push   %edx
  8024f4:	50                   	push   %eax
  8024f5:	ff 75 10             	pushl  0x10(%ebp)
  8024f8:	ff 75 0c             	pushl  0xc(%ebp)
  8024fb:	ff 75 08             	pushl  0x8(%ebp)
  8024fe:	6a 27                	push   $0x27
  802500:	e8 17 fb ff ff       	call   80201c <syscall>
  802505:	83 c4 18             	add    $0x18,%esp
	return ;
  802508:	90                   	nop
}
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <chktst>:
void chktst(uint32 n)
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	ff 75 08             	pushl  0x8(%ebp)
  802519:	6a 29                	push   $0x29
  80251b:	e8 fc fa ff ff       	call   80201c <syscall>
  802520:	83 c4 18             	add    $0x18,%esp
	return ;
  802523:	90                   	nop
}
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <inctst>:

void inctst()
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 2a                	push   $0x2a
  802535:	e8 e2 fa ff ff       	call   80201c <syscall>
  80253a:	83 c4 18             	add    $0x18,%esp
	return ;
  80253d:	90                   	nop
}
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    

00802540 <gettst>:
uint32 gettst()
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 2b                	push   $0x2b
  80254f:	e8 c8 fa ff ff       	call   80201c <syscall>
  802554:	83 c4 18             	add    $0x18,%esp
}
  802557:	c9                   	leave  
  802558:	c3                   	ret    

00802559 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
  80255c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 2c                	push   $0x2c
  80256b:	e8 ac fa ff ff       	call   80201c <syscall>
  802570:	83 c4 18             	add    $0x18,%esp
  802573:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802576:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80257a:	75 07                	jne    802583 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80257c:	b8 01 00 00 00       	mov    $0x1,%eax
  802581:	eb 05                	jmp    802588 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802583:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
  80258d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 2c                	push   $0x2c
  80259c:	e8 7b fa ff ff       	call   80201c <syscall>
  8025a1:	83 c4 18             	add    $0x18,%esp
  8025a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025a7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025ab:	75 07                	jne    8025b4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b2:	eb 05                	jmp    8025b9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b9:	c9                   	leave  
  8025ba:	c3                   	ret    

008025bb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
  8025be:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 2c                	push   $0x2c
  8025cd:	e8 4a fa ff ff       	call   80201c <syscall>
  8025d2:	83 c4 18             	add    $0x18,%esp
  8025d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025d8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025dc:	75 07                	jne    8025e5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025de:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e3:	eb 05                	jmp    8025ea <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ea:	c9                   	leave  
  8025eb:	c3                   	ret    

008025ec <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 2c                	push   $0x2c
  8025fe:	e8 19 fa ff ff       	call   80201c <syscall>
  802603:	83 c4 18             	add    $0x18,%esp
  802606:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802609:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80260d:	75 07                	jne    802616 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80260f:	b8 01 00 00 00       	mov    $0x1,%eax
  802614:	eb 05                	jmp    80261b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802616:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261b:	c9                   	leave  
  80261c:	c3                   	ret    

0080261d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	ff 75 08             	pushl  0x8(%ebp)
  80262b:	6a 2d                	push   $0x2d
  80262d:	e8 ea f9 ff ff       	call   80201c <syscall>
  802632:	83 c4 18             	add    $0x18,%esp
	return ;
  802635:	90                   	nop
}
  802636:	c9                   	leave  
  802637:	c3                   	ret    

00802638 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802638:	55                   	push   %ebp
  802639:	89 e5                	mov    %esp,%ebp
  80263b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80263c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80263f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802642:	8b 55 0c             	mov    0xc(%ebp),%edx
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	6a 00                	push   $0x0
  80264a:	53                   	push   %ebx
  80264b:	51                   	push   %ecx
  80264c:	52                   	push   %edx
  80264d:	50                   	push   %eax
  80264e:	6a 2e                	push   $0x2e
  802650:	e8 c7 f9 ff ff       	call   80201c <syscall>
  802655:	83 c4 18             	add    $0x18,%esp
}
  802658:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    

0080265d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802660:	8b 55 0c             	mov    0xc(%ebp),%edx
  802663:	8b 45 08             	mov    0x8(%ebp),%eax
  802666:	6a 00                	push   $0x0
  802668:	6a 00                	push   $0x0
  80266a:	6a 00                	push   $0x0
  80266c:	52                   	push   %edx
  80266d:	50                   	push   %eax
  80266e:	6a 2f                	push   $0x2f
  802670:	e8 a7 f9 ff ff       	call   80201c <syscall>
  802675:	83 c4 18             	add    $0x18,%esp
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    

0080267a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80267a:	55                   	push   %ebp
  80267b:	89 e5                	mov    %esp,%ebp
  80267d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802680:	83 ec 0c             	sub    $0xc,%esp
  802683:	68 10 47 80 00       	push   $0x804710
  802688:	e8 6b e8 ff ff       	call   800ef8 <cprintf>
  80268d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802690:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802697:	83 ec 0c             	sub    $0xc,%esp
  80269a:	68 3c 47 80 00       	push   $0x80473c
  80269f:	e8 54 e8 ff ff       	call   800ef8 <cprintf>
  8026a4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026a7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026ab:	a1 38 51 80 00       	mov    0x805138,%eax
  8026b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b3:	eb 56                	jmp    80270b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026b9:	74 1c                	je     8026d7 <print_mem_block_lists+0x5d>
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	8b 50 08             	mov    0x8(%eax),%edx
  8026c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c4:	8b 48 08             	mov    0x8(%eax),%ecx
  8026c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cd:	01 c8                	add    %ecx,%eax
  8026cf:	39 c2                	cmp    %eax,%edx
  8026d1:	73 04                	jae    8026d7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026d3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 50 08             	mov    0x8(%eax),%edx
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e3:	01 c2                	add    %eax,%edx
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 40 08             	mov    0x8(%eax),%eax
  8026eb:	83 ec 04             	sub    $0x4,%esp
  8026ee:	52                   	push   %edx
  8026ef:	50                   	push   %eax
  8026f0:	68 51 47 80 00       	push   $0x804751
  8026f5:	e8 fe e7 ff ff       	call   800ef8 <cprintf>
  8026fa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802703:	a1 40 51 80 00       	mov    0x805140,%eax
  802708:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270f:	74 07                	je     802718 <print_mem_block_lists+0x9e>
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 00                	mov    (%eax),%eax
  802716:	eb 05                	jmp    80271d <print_mem_block_lists+0xa3>
  802718:	b8 00 00 00 00       	mov    $0x0,%eax
  80271d:	a3 40 51 80 00       	mov    %eax,0x805140
  802722:	a1 40 51 80 00       	mov    0x805140,%eax
  802727:	85 c0                	test   %eax,%eax
  802729:	75 8a                	jne    8026b5 <print_mem_block_lists+0x3b>
  80272b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272f:	75 84                	jne    8026b5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802731:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802735:	75 10                	jne    802747 <print_mem_block_lists+0xcd>
  802737:	83 ec 0c             	sub    $0xc,%esp
  80273a:	68 60 47 80 00       	push   $0x804760
  80273f:	e8 b4 e7 ff ff       	call   800ef8 <cprintf>
  802744:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802747:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80274e:	83 ec 0c             	sub    $0xc,%esp
  802751:	68 84 47 80 00       	push   $0x804784
  802756:	e8 9d e7 ff ff       	call   800ef8 <cprintf>
  80275b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80275e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802762:	a1 40 50 80 00       	mov    0x805040,%eax
  802767:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276a:	eb 56                	jmp    8027c2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80276c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802770:	74 1c                	je     80278e <print_mem_block_lists+0x114>
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 50 08             	mov    0x8(%eax),%edx
  802778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277b:	8b 48 08             	mov    0x8(%eax),%ecx
  80277e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802781:	8b 40 0c             	mov    0xc(%eax),%eax
  802784:	01 c8                	add    %ecx,%eax
  802786:	39 c2                	cmp    %eax,%edx
  802788:	73 04                	jae    80278e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80278a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 50 08             	mov    0x8(%eax),%edx
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 40 0c             	mov    0xc(%eax),%eax
  80279a:	01 c2                	add    %eax,%edx
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 40 08             	mov    0x8(%eax),%eax
  8027a2:	83 ec 04             	sub    $0x4,%esp
  8027a5:	52                   	push   %edx
  8027a6:	50                   	push   %eax
  8027a7:	68 51 47 80 00       	push   $0x804751
  8027ac:	e8 47 e7 ff ff       	call   800ef8 <cprintf>
  8027b1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027ba:	a1 48 50 80 00       	mov    0x805048,%eax
  8027bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c6:	74 07                	je     8027cf <print_mem_block_lists+0x155>
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 00                	mov    (%eax),%eax
  8027cd:	eb 05                	jmp    8027d4 <print_mem_block_lists+0x15a>
  8027cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d4:	a3 48 50 80 00       	mov    %eax,0x805048
  8027d9:	a1 48 50 80 00       	mov    0x805048,%eax
  8027de:	85 c0                	test   %eax,%eax
  8027e0:	75 8a                	jne    80276c <print_mem_block_lists+0xf2>
  8027e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e6:	75 84                	jne    80276c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027e8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027ec:	75 10                	jne    8027fe <print_mem_block_lists+0x184>
  8027ee:	83 ec 0c             	sub    $0xc,%esp
  8027f1:	68 9c 47 80 00       	push   $0x80479c
  8027f6:	e8 fd e6 ff ff       	call   800ef8 <cprintf>
  8027fb:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8027fe:	83 ec 0c             	sub    $0xc,%esp
  802801:	68 10 47 80 00       	push   $0x804710
  802806:	e8 ed e6 ff ff       	call   800ef8 <cprintf>
  80280b:	83 c4 10             	add    $0x10,%esp

}
  80280e:	90                   	nop
  80280f:	c9                   	leave  
  802810:	c3                   	ret    

00802811 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802811:	55                   	push   %ebp
  802812:	89 e5                	mov    %esp,%ebp
  802814:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802817:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80281e:	00 00 00 
  802821:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802828:	00 00 00 
  80282b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802832:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802835:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80283c:	e9 9e 00 00 00       	jmp    8028df <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802841:	a1 50 50 80 00       	mov    0x805050,%eax
  802846:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802849:	c1 e2 04             	shl    $0x4,%edx
  80284c:	01 d0                	add    %edx,%eax
  80284e:	85 c0                	test   %eax,%eax
  802850:	75 14                	jne    802866 <initialize_MemBlocksList+0x55>
  802852:	83 ec 04             	sub    $0x4,%esp
  802855:	68 c4 47 80 00       	push   $0x8047c4
  80285a:	6a 46                	push   $0x46
  80285c:	68 e7 47 80 00       	push   $0x8047e7
  802861:	e8 de e3 ff ff       	call   800c44 <_panic>
  802866:	a1 50 50 80 00       	mov    0x805050,%eax
  80286b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286e:	c1 e2 04             	shl    $0x4,%edx
  802871:	01 d0                	add    %edx,%eax
  802873:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802879:	89 10                	mov    %edx,(%eax)
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	85 c0                	test   %eax,%eax
  80287f:	74 18                	je     802899 <initialize_MemBlocksList+0x88>
  802881:	a1 48 51 80 00       	mov    0x805148,%eax
  802886:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80288c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80288f:	c1 e1 04             	shl    $0x4,%ecx
  802892:	01 ca                	add    %ecx,%edx
  802894:	89 50 04             	mov    %edx,0x4(%eax)
  802897:	eb 12                	jmp    8028ab <initialize_MemBlocksList+0x9a>
  802899:	a1 50 50 80 00       	mov    0x805050,%eax
  80289e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a1:	c1 e2 04             	shl    $0x4,%edx
  8028a4:	01 d0                	add    %edx,%eax
  8028a6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ab:	a1 50 50 80 00       	mov    0x805050,%eax
  8028b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b3:	c1 e2 04             	shl    $0x4,%edx
  8028b6:	01 d0                	add    %edx,%eax
  8028b8:	a3 48 51 80 00       	mov    %eax,0x805148
  8028bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8028c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c5:	c1 e2 04             	shl    $0x4,%edx
  8028c8:	01 d0                	add    %edx,%eax
  8028ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d1:	a1 54 51 80 00       	mov    0x805154,%eax
  8028d6:	40                   	inc    %eax
  8028d7:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8028dc:	ff 45 f4             	incl   -0xc(%ebp)
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e5:	0f 82 56 ff ff ff    	jb     802841 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8028eb:	90                   	nop
  8028ec:	c9                   	leave  
  8028ed:	c3                   	ret    

008028ee <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028ee:	55                   	push   %ebp
  8028ef:	89 e5                	mov    %esp,%ebp
  8028f1:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028fc:	eb 19                	jmp    802917 <find_block+0x29>
	{
		if(va==point->sva)
  8028fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802901:	8b 40 08             	mov    0x8(%eax),%eax
  802904:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802907:	75 05                	jne    80290e <find_block+0x20>
		   return point;
  802909:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80290c:	eb 36                	jmp    802944 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	8b 40 08             	mov    0x8(%eax),%eax
  802914:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802917:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80291b:	74 07                	je     802924 <find_block+0x36>
  80291d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802920:	8b 00                	mov    (%eax),%eax
  802922:	eb 05                	jmp    802929 <find_block+0x3b>
  802924:	b8 00 00 00 00       	mov    $0x0,%eax
  802929:	8b 55 08             	mov    0x8(%ebp),%edx
  80292c:	89 42 08             	mov    %eax,0x8(%edx)
  80292f:	8b 45 08             	mov    0x8(%ebp),%eax
  802932:	8b 40 08             	mov    0x8(%eax),%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	75 c5                	jne    8028fe <find_block+0x10>
  802939:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80293d:	75 bf                	jne    8028fe <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80293f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802944:	c9                   	leave  
  802945:	c3                   	ret    

00802946 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80294c:	a1 40 50 80 00       	mov    0x805040,%eax
  802951:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802954:	a1 44 50 80 00       	mov    0x805044,%eax
  802959:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802962:	74 24                	je     802988 <insert_sorted_allocList+0x42>
  802964:	8b 45 08             	mov    0x8(%ebp),%eax
  802967:	8b 50 08             	mov    0x8(%eax),%edx
  80296a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296d:	8b 40 08             	mov    0x8(%eax),%eax
  802970:	39 c2                	cmp    %eax,%edx
  802972:	76 14                	jbe    802988 <insert_sorted_allocList+0x42>
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	8b 50 08             	mov    0x8(%eax),%edx
  80297a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297d:	8b 40 08             	mov    0x8(%eax),%eax
  802980:	39 c2                	cmp    %eax,%edx
  802982:	0f 82 60 01 00 00    	jb     802ae8 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802988:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80298c:	75 65                	jne    8029f3 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80298e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802992:	75 14                	jne    8029a8 <insert_sorted_allocList+0x62>
  802994:	83 ec 04             	sub    $0x4,%esp
  802997:	68 c4 47 80 00       	push   $0x8047c4
  80299c:	6a 6b                	push   $0x6b
  80299e:	68 e7 47 80 00       	push   $0x8047e7
  8029a3:	e8 9c e2 ff ff       	call   800c44 <_panic>
  8029a8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	89 10                	mov    %edx,(%eax)
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	74 0d                	je     8029c9 <insert_sorted_allocList+0x83>
  8029bc:	a1 40 50 80 00       	mov    0x805040,%eax
  8029c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c4:	89 50 04             	mov    %edx,0x4(%eax)
  8029c7:	eb 08                	jmp    8029d1 <insert_sorted_allocList+0x8b>
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	a3 44 50 80 00       	mov    %eax,0x805044
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	a3 40 50 80 00       	mov    %eax,0x805040
  8029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029e8:	40                   	inc    %eax
  8029e9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029ee:	e9 dc 01 00 00       	jmp    802bcf <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	8b 50 08             	mov    0x8(%eax),%edx
  8029f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fc:	8b 40 08             	mov    0x8(%eax),%eax
  8029ff:	39 c2                	cmp    %eax,%edx
  802a01:	77 6c                	ja     802a6f <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a07:	74 06                	je     802a0f <insert_sorted_allocList+0xc9>
  802a09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a0d:	75 14                	jne    802a23 <insert_sorted_allocList+0xdd>
  802a0f:	83 ec 04             	sub    $0x4,%esp
  802a12:	68 00 48 80 00       	push   $0x804800
  802a17:	6a 6f                	push   $0x6f
  802a19:	68 e7 47 80 00       	push   $0x8047e7
  802a1e:	e8 21 e2 ff ff       	call   800c44 <_panic>
  802a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a26:	8b 50 04             	mov    0x4(%eax),%edx
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	89 50 04             	mov    %edx,0x4(%eax)
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a35:	89 10                	mov    %edx,(%eax)
  802a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3a:	8b 40 04             	mov    0x4(%eax),%eax
  802a3d:	85 c0                	test   %eax,%eax
  802a3f:	74 0d                	je     802a4e <insert_sorted_allocList+0x108>
  802a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a44:	8b 40 04             	mov    0x4(%eax),%eax
  802a47:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4a:	89 10                	mov    %edx,(%eax)
  802a4c:	eb 08                	jmp    802a56 <insert_sorted_allocList+0x110>
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	a3 40 50 80 00       	mov    %eax,0x805040
  802a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a59:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5c:	89 50 04             	mov    %edx,0x4(%eax)
  802a5f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a64:	40                   	inc    %eax
  802a65:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a6a:	e9 60 01 00 00       	jmp    802bcf <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	8b 50 08             	mov    0x8(%eax),%edx
  802a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a78:	8b 40 08             	mov    0x8(%eax),%eax
  802a7b:	39 c2                	cmp    %eax,%edx
  802a7d:	0f 82 4c 01 00 00    	jb     802bcf <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802a83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a87:	75 14                	jne    802a9d <insert_sorted_allocList+0x157>
  802a89:	83 ec 04             	sub    $0x4,%esp
  802a8c:	68 38 48 80 00       	push   $0x804838
  802a91:	6a 73                	push   $0x73
  802a93:	68 e7 47 80 00       	push   $0x8047e7
  802a98:	e8 a7 e1 ff ff       	call   800c44 <_panic>
  802a9d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	89 50 04             	mov    %edx,0x4(%eax)
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	74 0c                	je     802abf <insert_sorted_allocList+0x179>
  802ab3:	a1 44 50 80 00       	mov    0x805044,%eax
  802ab8:	8b 55 08             	mov    0x8(%ebp),%edx
  802abb:	89 10                	mov    %edx,(%eax)
  802abd:	eb 08                	jmp    802ac7 <insert_sorted_allocList+0x181>
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	a3 40 50 80 00       	mov    %eax,0x805040
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	a3 44 50 80 00       	mov    %eax,0x805044
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802add:	40                   	inc    %eax
  802ade:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ae3:	e9 e7 00 00 00       	jmp    802bcf <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802aee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802af5:	a1 40 50 80 00       	mov    0x805040,%eax
  802afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802afd:	e9 9d 00 00 00       	jmp    802b9f <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	8b 50 08             	mov    0x8(%eax),%edx
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 40 08             	mov    0x8(%eax),%eax
  802b16:	39 c2                	cmp    %eax,%edx
  802b18:	76 7d                	jbe    802b97 <insert_sorted_allocList+0x251>
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	8b 50 08             	mov    0x8(%eax),%edx
  802b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b23:	8b 40 08             	mov    0x8(%eax),%eax
  802b26:	39 c2                	cmp    %eax,%edx
  802b28:	73 6d                	jae    802b97 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802b2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2e:	74 06                	je     802b36 <insert_sorted_allocList+0x1f0>
  802b30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b34:	75 14                	jne    802b4a <insert_sorted_allocList+0x204>
  802b36:	83 ec 04             	sub    $0x4,%esp
  802b39:	68 5c 48 80 00       	push   $0x80485c
  802b3e:	6a 7f                	push   $0x7f
  802b40:	68 e7 47 80 00       	push   $0x8047e7
  802b45:	e8 fa e0 ff ff       	call   800c44 <_panic>
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 10                	mov    (%eax),%edx
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	89 10                	mov    %edx,(%eax)
  802b54:	8b 45 08             	mov    0x8(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	74 0b                	je     802b68 <insert_sorted_allocList+0x222>
  802b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b60:	8b 00                	mov    (%eax),%eax
  802b62:	8b 55 08             	mov    0x8(%ebp),%edx
  802b65:	89 50 04             	mov    %edx,0x4(%eax)
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6e:	89 10                	mov    %edx,(%eax)
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b76:	89 50 04             	mov    %edx,0x4(%eax)
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	75 08                	jne    802b8a <insert_sorted_allocList+0x244>
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	a3 44 50 80 00       	mov    %eax,0x805044
  802b8a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b8f:	40                   	inc    %eax
  802b90:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802b95:	eb 39                	jmp    802bd0 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b97:	a1 48 50 80 00       	mov    0x805048,%eax
  802b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba3:	74 07                	je     802bac <insert_sorted_allocList+0x266>
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	eb 05                	jmp    802bb1 <insert_sorted_allocList+0x26b>
  802bac:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb1:	a3 48 50 80 00       	mov    %eax,0x805048
  802bb6:	a1 48 50 80 00       	mov    0x805048,%eax
  802bbb:	85 c0                	test   %eax,%eax
  802bbd:	0f 85 3f ff ff ff    	jne    802b02 <insert_sorted_allocList+0x1bc>
  802bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc7:	0f 85 35 ff ff ff    	jne    802b02 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802bcd:	eb 01                	jmp    802bd0 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802bcf:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802bd0:	90                   	nop
  802bd1:	c9                   	leave  
  802bd2:	c3                   	ret    

00802bd3 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802bd3:	55                   	push   %ebp
  802bd4:	89 e5                	mov    %esp,%ebp
  802bd6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802bd9:	a1 38 51 80 00       	mov    0x805138,%eax
  802bde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be1:	e9 85 01 00 00       	jmp    802d6b <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bef:	0f 82 6e 01 00 00    	jb     802d63 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bfe:	0f 85 8a 00 00 00    	jne    802c8e <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c08:	75 17                	jne    802c21 <alloc_block_FF+0x4e>
  802c0a:	83 ec 04             	sub    $0x4,%esp
  802c0d:	68 90 48 80 00       	push   $0x804890
  802c12:	68 93 00 00 00       	push   $0x93
  802c17:	68 e7 47 80 00       	push   $0x8047e7
  802c1c:	e8 23 e0 ff ff       	call   800c44 <_panic>
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	85 c0                	test   %eax,%eax
  802c28:	74 10                	je     802c3a <alloc_block_FF+0x67>
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c32:	8b 52 04             	mov    0x4(%edx),%edx
  802c35:	89 50 04             	mov    %edx,0x4(%eax)
  802c38:	eb 0b                	jmp    802c45 <alloc_block_FF+0x72>
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 40 04             	mov    0x4(%eax),%eax
  802c40:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 40 04             	mov    0x4(%eax),%eax
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	74 0f                	je     802c5e <alloc_block_FF+0x8b>
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 40 04             	mov    0x4(%eax),%eax
  802c55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c58:	8b 12                	mov    (%edx),%edx
  802c5a:	89 10                	mov    %edx,(%eax)
  802c5c:	eb 0a                	jmp    802c68 <alloc_block_FF+0x95>
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	8b 00                	mov    (%eax),%eax
  802c63:	a3 38 51 80 00       	mov    %eax,0x805138
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c80:	48                   	dec    %eax
  802c81:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	e9 10 01 00 00       	jmp    802d9e <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 40 0c             	mov    0xc(%eax),%eax
  802c94:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c97:	0f 86 c6 00 00 00    	jbe    802d63 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c9d:	a1 48 51 80 00       	mov    0x805148,%eax
  802ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca8:	8b 50 08             	mov    0x8(%eax),%edx
  802cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cae:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb7:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cbe:	75 17                	jne    802cd7 <alloc_block_FF+0x104>
  802cc0:	83 ec 04             	sub    $0x4,%esp
  802cc3:	68 90 48 80 00       	push   $0x804890
  802cc8:	68 9b 00 00 00       	push   $0x9b
  802ccd:	68 e7 47 80 00       	push   $0x8047e7
  802cd2:	e8 6d df ff ff       	call   800c44 <_panic>
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	85 c0                	test   %eax,%eax
  802cde:	74 10                	je     802cf0 <alloc_block_FF+0x11d>
  802ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce3:	8b 00                	mov    (%eax),%eax
  802ce5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce8:	8b 52 04             	mov    0x4(%edx),%edx
  802ceb:	89 50 04             	mov    %edx,0x4(%eax)
  802cee:	eb 0b                	jmp    802cfb <alloc_block_FF+0x128>
  802cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf3:	8b 40 04             	mov    0x4(%eax),%eax
  802cf6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfe:	8b 40 04             	mov    0x4(%eax),%eax
  802d01:	85 c0                	test   %eax,%eax
  802d03:	74 0f                	je     802d14 <alloc_block_FF+0x141>
  802d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0e:	8b 12                	mov    (%edx),%edx
  802d10:	89 10                	mov    %edx,(%eax)
  802d12:	eb 0a                	jmp    802d1e <alloc_block_FF+0x14b>
  802d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d17:	8b 00                	mov    (%eax),%eax
  802d19:	a3 48 51 80 00       	mov    %eax,0x805148
  802d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d31:	a1 54 51 80 00       	mov    0x805154,%eax
  802d36:	48                   	dec    %eax
  802d37:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 50 08             	mov    0x8(%eax),%edx
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	01 c2                	add    %eax,%edx
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 40 0c             	mov    0xc(%eax),%eax
  802d53:	2b 45 08             	sub    0x8(%ebp),%eax
  802d56:	89 c2                	mov    %eax,%edx
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d61:	eb 3b                	jmp    802d9e <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802d63:	a1 40 51 80 00       	mov    0x805140,%eax
  802d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6f:	74 07                	je     802d78 <alloc_block_FF+0x1a5>
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 00                	mov    (%eax),%eax
  802d76:	eb 05                	jmp    802d7d <alloc_block_FF+0x1aa>
  802d78:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7d:	a3 40 51 80 00       	mov    %eax,0x805140
  802d82:	a1 40 51 80 00       	mov    0x805140,%eax
  802d87:	85 c0                	test   %eax,%eax
  802d89:	0f 85 57 fe ff ff    	jne    802be6 <alloc_block_FF+0x13>
  802d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d93:	0f 85 4d fe ff ff    	jne    802be6 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d9e:	c9                   	leave  
  802d9f:	c3                   	ret    

00802da0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802da0:	55                   	push   %ebp
  802da1:	89 e5                	mov    %esp,%ebp
  802da3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802da6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802dad:	a1 38 51 80 00       	mov    0x805138,%eax
  802db2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db5:	e9 df 00 00 00       	jmp    802e99 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dc3:	0f 82 c8 00 00 00    	jb     802e91 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dd2:	0f 85 8a 00 00 00    	jne    802e62 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802dd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddc:	75 17                	jne    802df5 <alloc_block_BF+0x55>
  802dde:	83 ec 04             	sub    $0x4,%esp
  802de1:	68 90 48 80 00       	push   $0x804890
  802de6:	68 b7 00 00 00       	push   $0xb7
  802deb:	68 e7 47 80 00       	push   $0x8047e7
  802df0:	e8 4f de ff ff       	call   800c44 <_panic>
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	8b 00                	mov    (%eax),%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	74 10                	je     802e0e <alloc_block_BF+0x6e>
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e06:	8b 52 04             	mov    0x4(%edx),%edx
  802e09:	89 50 04             	mov    %edx,0x4(%eax)
  802e0c:	eb 0b                	jmp    802e19 <alloc_block_BF+0x79>
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 40 04             	mov    0x4(%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 0f                	je     802e32 <alloc_block_BF+0x92>
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	8b 40 04             	mov    0x4(%eax),%eax
  802e29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2c:	8b 12                	mov    (%edx),%edx
  802e2e:	89 10                	mov    %edx,(%eax)
  802e30:	eb 0a                	jmp    802e3c <alloc_block_BF+0x9c>
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	8b 00                	mov    (%eax),%eax
  802e37:	a3 38 51 80 00       	mov    %eax,0x805138
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4f:	a1 44 51 80 00       	mov    0x805144,%eax
  802e54:	48                   	dec    %eax
  802e55:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	e9 4d 01 00 00       	jmp    802faf <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 40 0c             	mov    0xc(%eax),%eax
  802e68:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e6b:	76 24                	jbe    802e91 <alloc_block_BF+0xf1>
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	8b 40 0c             	mov    0xc(%eax),%eax
  802e73:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e76:	73 19                	jae    802e91 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802e78:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 40 0c             	mov    0xc(%eax),%eax
  802e85:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 40 08             	mov    0x8(%eax),%eax
  802e8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802e91:	a1 40 51 80 00       	mov    0x805140,%eax
  802e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9d:	74 07                	je     802ea6 <alloc_block_BF+0x106>
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	eb 05                	jmp    802eab <alloc_block_BF+0x10b>
  802ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  802eab:	a3 40 51 80 00       	mov    %eax,0x805140
  802eb0:	a1 40 51 80 00       	mov    0x805140,%eax
  802eb5:	85 c0                	test   %eax,%eax
  802eb7:	0f 85 fd fe ff ff    	jne    802dba <alloc_block_BF+0x1a>
  802ebd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec1:	0f 85 f3 fe ff ff    	jne    802dba <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802ec7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ecb:	0f 84 d9 00 00 00    	je     802faa <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ed1:	a1 48 51 80 00       	mov    0x805148,%eax
  802ed6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802ed9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802edc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802edf:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802ee2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee8:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802eeb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802eef:	75 17                	jne    802f08 <alloc_block_BF+0x168>
  802ef1:	83 ec 04             	sub    $0x4,%esp
  802ef4:	68 90 48 80 00       	push   $0x804890
  802ef9:	68 c7 00 00 00       	push   $0xc7
  802efe:	68 e7 47 80 00       	push   $0x8047e7
  802f03:	e8 3c dd ff ff       	call   800c44 <_panic>
  802f08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f0b:	8b 00                	mov    (%eax),%eax
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	74 10                	je     802f21 <alloc_block_BF+0x181>
  802f11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f14:	8b 00                	mov    (%eax),%eax
  802f16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f19:	8b 52 04             	mov    0x4(%edx),%edx
  802f1c:	89 50 04             	mov    %edx,0x4(%eax)
  802f1f:	eb 0b                	jmp    802f2c <alloc_block_BF+0x18c>
  802f21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f24:	8b 40 04             	mov    0x4(%eax),%eax
  802f27:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f2f:	8b 40 04             	mov    0x4(%eax),%eax
  802f32:	85 c0                	test   %eax,%eax
  802f34:	74 0f                	je     802f45 <alloc_block_BF+0x1a5>
  802f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f39:	8b 40 04             	mov    0x4(%eax),%eax
  802f3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f3f:	8b 12                	mov    (%edx),%edx
  802f41:	89 10                	mov    %edx,(%eax)
  802f43:	eb 0a                	jmp    802f4f <alloc_block_BF+0x1af>
  802f45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f62:	a1 54 51 80 00       	mov    0x805154,%eax
  802f67:	48                   	dec    %eax
  802f68:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802f6d:	83 ec 08             	sub    $0x8,%esp
  802f70:	ff 75 ec             	pushl  -0x14(%ebp)
  802f73:	68 38 51 80 00       	push   $0x805138
  802f78:	e8 71 f9 ff ff       	call   8028ee <find_block>
  802f7d:	83 c4 10             	add    $0x10,%esp
  802f80:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802f83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f86:	8b 50 08             	mov    0x8(%eax),%edx
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	01 c2                	add    %eax,%edx
  802f8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f91:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802f94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f97:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9a:	2b 45 08             	sub    0x8(%ebp),%eax
  802f9d:	89 c2                	mov    %eax,%edx
  802f9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa2:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802fa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa8:	eb 05                	jmp    802faf <alloc_block_BF+0x20f>
	}
	return NULL;
  802faa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802faf:	c9                   	leave  
  802fb0:	c3                   	ret    

00802fb1 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802fb1:	55                   	push   %ebp
  802fb2:	89 e5                	mov    %esp,%ebp
  802fb4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802fb7:	a1 28 50 80 00       	mov    0x805028,%eax
  802fbc:	85 c0                	test   %eax,%eax
  802fbe:	0f 85 de 01 00 00    	jne    8031a2 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802fc4:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fcc:	e9 9e 01 00 00       	jmp    80316f <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fda:	0f 82 87 01 00 00    	jb     803167 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fe9:	0f 85 95 00 00 00    	jne    803084 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802fef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff3:	75 17                	jne    80300c <alloc_block_NF+0x5b>
  802ff5:	83 ec 04             	sub    $0x4,%esp
  802ff8:	68 90 48 80 00       	push   $0x804890
  802ffd:	68 e0 00 00 00       	push   $0xe0
  803002:	68 e7 47 80 00       	push   $0x8047e7
  803007:	e8 38 dc ff ff       	call   800c44 <_panic>
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	8b 00                	mov    (%eax),%eax
  803011:	85 c0                	test   %eax,%eax
  803013:	74 10                	je     803025 <alloc_block_NF+0x74>
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 00                	mov    (%eax),%eax
  80301a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80301d:	8b 52 04             	mov    0x4(%edx),%edx
  803020:	89 50 04             	mov    %edx,0x4(%eax)
  803023:	eb 0b                	jmp    803030 <alloc_block_NF+0x7f>
  803025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803028:	8b 40 04             	mov    0x4(%eax),%eax
  80302b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	8b 40 04             	mov    0x4(%eax),%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	74 0f                	je     803049 <alloc_block_NF+0x98>
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	8b 40 04             	mov    0x4(%eax),%eax
  803040:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803043:	8b 12                	mov    (%edx),%edx
  803045:	89 10                	mov    %edx,(%eax)
  803047:	eb 0a                	jmp    803053 <alloc_block_NF+0xa2>
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	a3 38 51 80 00       	mov    %eax,0x805138
  803053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803056:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803066:	a1 44 51 80 00       	mov    0x805144,%eax
  80306b:	48                   	dec    %eax
  80306c:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 40 08             	mov    0x8(%eax),%eax
  803077:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	e9 f8 04 00 00       	jmp    80357c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 40 0c             	mov    0xc(%eax),%eax
  80308a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308d:	0f 86 d4 00 00 00    	jbe    803167 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803093:	a1 48 51 80 00       	mov    0x805148,%eax
  803098:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	8b 50 08             	mov    0x8(%eax),%edx
  8030a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a4:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8030a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ad:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030b4:	75 17                	jne    8030cd <alloc_block_NF+0x11c>
  8030b6:	83 ec 04             	sub    $0x4,%esp
  8030b9:	68 90 48 80 00       	push   $0x804890
  8030be:	68 e9 00 00 00       	push   $0xe9
  8030c3:	68 e7 47 80 00       	push   $0x8047e7
  8030c8:	e8 77 db ff ff       	call   800c44 <_panic>
  8030cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d0:	8b 00                	mov    (%eax),%eax
  8030d2:	85 c0                	test   %eax,%eax
  8030d4:	74 10                	je     8030e6 <alloc_block_NF+0x135>
  8030d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d9:	8b 00                	mov    (%eax),%eax
  8030db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030de:	8b 52 04             	mov    0x4(%edx),%edx
  8030e1:	89 50 04             	mov    %edx,0x4(%eax)
  8030e4:	eb 0b                	jmp    8030f1 <alloc_block_NF+0x140>
  8030e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e9:	8b 40 04             	mov    0x4(%eax),%eax
  8030ec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f4:	8b 40 04             	mov    0x4(%eax),%eax
  8030f7:	85 c0                	test   %eax,%eax
  8030f9:	74 0f                	je     80310a <alloc_block_NF+0x159>
  8030fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fe:	8b 40 04             	mov    0x4(%eax),%eax
  803101:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803104:	8b 12                	mov    (%edx),%edx
  803106:	89 10                	mov    %edx,(%eax)
  803108:	eb 0a                	jmp    803114 <alloc_block_NF+0x163>
  80310a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310d:	8b 00                	mov    (%eax),%eax
  80310f:	a3 48 51 80 00       	mov    %eax,0x805148
  803114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803117:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803120:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803127:	a1 54 51 80 00       	mov    0x805154,%eax
  80312c:	48                   	dec    %eax
  80312d:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803132:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803135:	8b 40 08             	mov    0x8(%eax),%eax
  803138:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 50 08             	mov    0x8(%eax),%edx
  803143:	8b 45 08             	mov    0x8(%ebp),%eax
  803146:	01 c2                	add    %eax,%edx
  803148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314b:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	8b 40 0c             	mov    0xc(%eax),%eax
  803154:	2b 45 08             	sub    0x8(%ebp),%eax
  803157:	89 c2                	mov    %eax,%edx
  803159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315c:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80315f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803162:	e9 15 04 00 00       	jmp    80357c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803167:	a1 40 51 80 00       	mov    0x805140,%eax
  80316c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80316f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803173:	74 07                	je     80317c <alloc_block_NF+0x1cb>
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	8b 00                	mov    (%eax),%eax
  80317a:	eb 05                	jmp    803181 <alloc_block_NF+0x1d0>
  80317c:	b8 00 00 00 00       	mov    $0x0,%eax
  803181:	a3 40 51 80 00       	mov    %eax,0x805140
  803186:	a1 40 51 80 00       	mov    0x805140,%eax
  80318b:	85 c0                	test   %eax,%eax
  80318d:	0f 85 3e fe ff ff    	jne    802fd1 <alloc_block_NF+0x20>
  803193:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803197:	0f 85 34 fe ff ff    	jne    802fd1 <alloc_block_NF+0x20>
  80319d:	e9 d5 03 00 00       	jmp    803577 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031a2:	a1 38 51 80 00       	mov    0x805138,%eax
  8031a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031aa:	e9 b1 01 00 00       	jmp    803360 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8031af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b2:	8b 50 08             	mov    0x8(%eax),%edx
  8031b5:	a1 28 50 80 00       	mov    0x805028,%eax
  8031ba:	39 c2                	cmp    %eax,%edx
  8031bc:	0f 82 96 01 00 00    	jb     803358 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8031c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031cb:	0f 82 87 01 00 00    	jb     803358 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8031d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031da:	0f 85 95 00 00 00    	jne    803275 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8031e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e4:	75 17                	jne    8031fd <alloc_block_NF+0x24c>
  8031e6:	83 ec 04             	sub    $0x4,%esp
  8031e9:	68 90 48 80 00       	push   $0x804890
  8031ee:	68 fc 00 00 00       	push   $0xfc
  8031f3:	68 e7 47 80 00       	push   $0x8047e7
  8031f8:	e8 47 da ff ff       	call   800c44 <_panic>
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 00                	mov    (%eax),%eax
  803202:	85 c0                	test   %eax,%eax
  803204:	74 10                	je     803216 <alloc_block_NF+0x265>
  803206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803209:	8b 00                	mov    (%eax),%eax
  80320b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80320e:	8b 52 04             	mov    0x4(%edx),%edx
  803211:	89 50 04             	mov    %edx,0x4(%eax)
  803214:	eb 0b                	jmp    803221 <alloc_block_NF+0x270>
  803216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803219:	8b 40 04             	mov    0x4(%eax),%eax
  80321c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803224:	8b 40 04             	mov    0x4(%eax),%eax
  803227:	85 c0                	test   %eax,%eax
  803229:	74 0f                	je     80323a <alloc_block_NF+0x289>
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	8b 40 04             	mov    0x4(%eax),%eax
  803231:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803234:	8b 12                	mov    (%edx),%edx
  803236:	89 10                	mov    %edx,(%eax)
  803238:	eb 0a                	jmp    803244 <alloc_block_NF+0x293>
  80323a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323d:	8b 00                	mov    (%eax),%eax
  80323f:	a3 38 51 80 00       	mov    %eax,0x805138
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803257:	a1 44 51 80 00       	mov    0x805144,%eax
  80325c:	48                   	dec    %eax
  80325d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803265:	8b 40 08             	mov    0x8(%eax),%eax
  803268:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	e9 07 03 00 00       	jmp    80357c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803278:	8b 40 0c             	mov    0xc(%eax),%eax
  80327b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80327e:	0f 86 d4 00 00 00    	jbe    803358 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803284:	a1 48 51 80 00       	mov    0x805148,%eax
  803289:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80328c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328f:	8b 50 08             	mov    0x8(%eax),%edx
  803292:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803295:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803298:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329b:	8b 55 08             	mov    0x8(%ebp),%edx
  80329e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a5:	75 17                	jne    8032be <alloc_block_NF+0x30d>
  8032a7:	83 ec 04             	sub    $0x4,%esp
  8032aa:	68 90 48 80 00       	push   $0x804890
  8032af:	68 04 01 00 00       	push   $0x104
  8032b4:	68 e7 47 80 00       	push   $0x8047e7
  8032b9:	e8 86 d9 ff ff       	call   800c44 <_panic>
  8032be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c1:	8b 00                	mov    (%eax),%eax
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	74 10                	je     8032d7 <alloc_block_NF+0x326>
  8032c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ca:	8b 00                	mov    (%eax),%eax
  8032cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032cf:	8b 52 04             	mov    0x4(%edx),%edx
  8032d2:	89 50 04             	mov    %edx,0x4(%eax)
  8032d5:	eb 0b                	jmp    8032e2 <alloc_block_NF+0x331>
  8032d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032da:	8b 40 04             	mov    0x4(%eax),%eax
  8032dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e5:	8b 40 04             	mov    0x4(%eax),%eax
  8032e8:	85 c0                	test   %eax,%eax
  8032ea:	74 0f                	je     8032fb <alloc_block_NF+0x34a>
  8032ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ef:	8b 40 04             	mov    0x4(%eax),%eax
  8032f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f5:	8b 12                	mov    (%edx),%edx
  8032f7:	89 10                	mov    %edx,(%eax)
  8032f9:	eb 0a                	jmp    803305 <alloc_block_NF+0x354>
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	8b 00                	mov    (%eax),%eax
  803300:	a3 48 51 80 00       	mov    %eax,0x805148
  803305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803308:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803311:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803318:	a1 54 51 80 00       	mov    0x805154,%eax
  80331d:	48                   	dec    %eax
  80331e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803326:	8b 40 08             	mov    0x8(%eax),%eax
  803329:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80332e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803331:	8b 50 08             	mov    0x8(%eax),%edx
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	01 c2                	add    %eax,%edx
  803339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80333f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803342:	8b 40 0c             	mov    0xc(%eax),%eax
  803345:	2b 45 08             	sub    0x8(%ebp),%eax
  803348:	89 c2                	mov    %eax,%edx
  80334a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803350:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803353:	e9 24 02 00 00       	jmp    80357c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803358:	a1 40 51 80 00       	mov    0x805140,%eax
  80335d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803360:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803364:	74 07                	je     80336d <alloc_block_NF+0x3bc>
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	8b 00                	mov    (%eax),%eax
  80336b:	eb 05                	jmp    803372 <alloc_block_NF+0x3c1>
  80336d:	b8 00 00 00 00       	mov    $0x0,%eax
  803372:	a3 40 51 80 00       	mov    %eax,0x805140
  803377:	a1 40 51 80 00       	mov    0x805140,%eax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	0f 85 2b fe ff ff    	jne    8031af <alloc_block_NF+0x1fe>
  803384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803388:	0f 85 21 fe ff ff    	jne    8031af <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80338e:	a1 38 51 80 00       	mov    0x805138,%eax
  803393:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803396:	e9 ae 01 00 00       	jmp    803549 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80339b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339e:	8b 50 08             	mov    0x8(%eax),%edx
  8033a1:	a1 28 50 80 00       	mov    0x805028,%eax
  8033a6:	39 c2                	cmp    %eax,%edx
  8033a8:	0f 83 93 01 00 00    	jae    803541 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033b7:	0f 82 84 01 00 00    	jb     803541 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8033bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033c6:	0f 85 95 00 00 00    	jne    803461 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8033cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d0:	75 17                	jne    8033e9 <alloc_block_NF+0x438>
  8033d2:	83 ec 04             	sub    $0x4,%esp
  8033d5:	68 90 48 80 00       	push   $0x804890
  8033da:	68 14 01 00 00       	push   $0x114
  8033df:	68 e7 47 80 00       	push   $0x8047e7
  8033e4:	e8 5b d8 ff ff       	call   800c44 <_panic>
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	85 c0                	test   %eax,%eax
  8033f0:	74 10                	je     803402 <alloc_block_NF+0x451>
  8033f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f5:	8b 00                	mov    (%eax),%eax
  8033f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033fa:	8b 52 04             	mov    0x4(%edx),%edx
  8033fd:	89 50 04             	mov    %edx,0x4(%eax)
  803400:	eb 0b                	jmp    80340d <alloc_block_NF+0x45c>
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	8b 40 04             	mov    0x4(%eax),%eax
  803408:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80340d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803410:	8b 40 04             	mov    0x4(%eax),%eax
  803413:	85 c0                	test   %eax,%eax
  803415:	74 0f                	je     803426 <alloc_block_NF+0x475>
  803417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341a:	8b 40 04             	mov    0x4(%eax),%eax
  80341d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803420:	8b 12                	mov    (%edx),%edx
  803422:	89 10                	mov    %edx,(%eax)
  803424:	eb 0a                	jmp    803430 <alloc_block_NF+0x47f>
  803426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803429:	8b 00                	mov    (%eax),%eax
  80342b:	a3 38 51 80 00       	mov    %eax,0x805138
  803430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803443:	a1 44 51 80 00       	mov    0x805144,%eax
  803448:	48                   	dec    %eax
  803449:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803451:	8b 40 08             	mov    0x8(%eax),%eax
  803454:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345c:	e9 1b 01 00 00       	jmp    80357c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803464:	8b 40 0c             	mov    0xc(%eax),%eax
  803467:	3b 45 08             	cmp    0x8(%ebp),%eax
  80346a:	0f 86 d1 00 00 00    	jbe    803541 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803470:	a1 48 51 80 00       	mov    0x805148,%eax
  803475:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347b:	8b 50 08             	mov    0x8(%eax),%edx
  80347e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803481:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803484:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803487:	8b 55 08             	mov    0x8(%ebp),%edx
  80348a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80348d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803491:	75 17                	jne    8034aa <alloc_block_NF+0x4f9>
  803493:	83 ec 04             	sub    $0x4,%esp
  803496:	68 90 48 80 00       	push   $0x804890
  80349b:	68 1c 01 00 00       	push   $0x11c
  8034a0:	68 e7 47 80 00       	push   $0x8047e7
  8034a5:	e8 9a d7 ff ff       	call   800c44 <_panic>
  8034aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ad:	8b 00                	mov    (%eax),%eax
  8034af:	85 c0                	test   %eax,%eax
  8034b1:	74 10                	je     8034c3 <alloc_block_NF+0x512>
  8034b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b6:	8b 00                	mov    (%eax),%eax
  8034b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034bb:	8b 52 04             	mov    0x4(%edx),%edx
  8034be:	89 50 04             	mov    %edx,0x4(%eax)
  8034c1:	eb 0b                	jmp    8034ce <alloc_block_NF+0x51d>
  8034c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c6:	8b 40 04             	mov    0x4(%eax),%eax
  8034c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d1:	8b 40 04             	mov    0x4(%eax),%eax
  8034d4:	85 c0                	test   %eax,%eax
  8034d6:	74 0f                	je     8034e7 <alloc_block_NF+0x536>
  8034d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034db:	8b 40 04             	mov    0x4(%eax),%eax
  8034de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034e1:	8b 12                	mov    (%edx),%edx
  8034e3:	89 10                	mov    %edx,(%eax)
  8034e5:	eb 0a                	jmp    8034f1 <alloc_block_NF+0x540>
  8034e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8034f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803504:	a1 54 51 80 00       	mov    0x805154,%eax
  803509:	48                   	dec    %eax
  80350a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80350f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803512:	8b 40 08             	mov    0x8(%eax),%eax
  803515:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80351a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351d:	8b 50 08             	mov    0x8(%eax),%edx
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	01 c2                	add    %eax,%edx
  803525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803528:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80352b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352e:	8b 40 0c             	mov    0xc(%eax),%eax
  803531:	2b 45 08             	sub    0x8(%ebp),%eax
  803534:	89 c2                	mov    %eax,%edx
  803536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803539:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80353c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353f:	eb 3b                	jmp    80357c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803541:	a1 40 51 80 00       	mov    0x805140,%eax
  803546:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354d:	74 07                	je     803556 <alloc_block_NF+0x5a5>
  80354f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803552:	8b 00                	mov    (%eax),%eax
  803554:	eb 05                	jmp    80355b <alloc_block_NF+0x5aa>
  803556:	b8 00 00 00 00       	mov    $0x0,%eax
  80355b:	a3 40 51 80 00       	mov    %eax,0x805140
  803560:	a1 40 51 80 00       	mov    0x805140,%eax
  803565:	85 c0                	test   %eax,%eax
  803567:	0f 85 2e fe ff ff    	jne    80339b <alloc_block_NF+0x3ea>
  80356d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803571:	0f 85 24 fe ff ff    	jne    80339b <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803577:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80357c:	c9                   	leave  
  80357d:	c3                   	ret    

0080357e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80357e:	55                   	push   %ebp
  80357f:	89 e5                	mov    %esp,%ebp
  803581:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803584:	a1 38 51 80 00       	mov    0x805138,%eax
  803589:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80358c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803591:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803594:	a1 38 51 80 00       	mov    0x805138,%eax
  803599:	85 c0                	test   %eax,%eax
  80359b:	74 14                	je     8035b1 <insert_sorted_with_merge_freeList+0x33>
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	8b 50 08             	mov    0x8(%eax),%edx
  8035a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a6:	8b 40 08             	mov    0x8(%eax),%eax
  8035a9:	39 c2                	cmp    %eax,%edx
  8035ab:	0f 87 9b 01 00 00    	ja     80374c <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8035b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035b5:	75 17                	jne    8035ce <insert_sorted_with_merge_freeList+0x50>
  8035b7:	83 ec 04             	sub    $0x4,%esp
  8035ba:	68 c4 47 80 00       	push   $0x8047c4
  8035bf:	68 38 01 00 00       	push   $0x138
  8035c4:	68 e7 47 80 00       	push   $0x8047e7
  8035c9:	e8 76 d6 ff ff       	call   800c44 <_panic>
  8035ce:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8035d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d7:	89 10                	mov    %edx,(%eax)
  8035d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dc:	8b 00                	mov    (%eax),%eax
  8035de:	85 c0                	test   %eax,%eax
  8035e0:	74 0d                	je     8035ef <insert_sorted_with_merge_freeList+0x71>
  8035e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8035e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ea:	89 50 04             	mov    %edx,0x4(%eax)
  8035ed:	eb 08                	jmp    8035f7 <insert_sorted_with_merge_freeList+0x79>
  8035ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8035ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803602:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803609:	a1 44 51 80 00       	mov    0x805144,%eax
  80360e:	40                   	inc    %eax
  80360f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803614:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803618:	0f 84 a8 06 00 00    	je     803cc6 <insert_sorted_with_merge_freeList+0x748>
  80361e:	8b 45 08             	mov    0x8(%ebp),%eax
  803621:	8b 50 08             	mov    0x8(%eax),%edx
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	8b 40 0c             	mov    0xc(%eax),%eax
  80362a:	01 c2                	add    %eax,%edx
  80362c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80362f:	8b 40 08             	mov    0x8(%eax),%eax
  803632:	39 c2                	cmp    %eax,%edx
  803634:	0f 85 8c 06 00 00    	jne    803cc6 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	8b 50 0c             	mov    0xc(%eax),%edx
  803640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803643:	8b 40 0c             	mov    0xc(%eax),%eax
  803646:	01 c2                	add    %eax,%edx
  803648:	8b 45 08             	mov    0x8(%ebp),%eax
  80364b:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80364e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803652:	75 17                	jne    80366b <insert_sorted_with_merge_freeList+0xed>
  803654:	83 ec 04             	sub    $0x4,%esp
  803657:	68 90 48 80 00       	push   $0x804890
  80365c:	68 3c 01 00 00       	push   $0x13c
  803661:	68 e7 47 80 00       	push   $0x8047e7
  803666:	e8 d9 d5 ff ff       	call   800c44 <_panic>
  80366b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366e:	8b 00                	mov    (%eax),%eax
  803670:	85 c0                	test   %eax,%eax
  803672:	74 10                	je     803684 <insert_sorted_with_merge_freeList+0x106>
  803674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803677:	8b 00                	mov    (%eax),%eax
  803679:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80367c:	8b 52 04             	mov    0x4(%edx),%edx
  80367f:	89 50 04             	mov    %edx,0x4(%eax)
  803682:	eb 0b                	jmp    80368f <insert_sorted_with_merge_freeList+0x111>
  803684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803687:	8b 40 04             	mov    0x4(%eax),%eax
  80368a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80368f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803692:	8b 40 04             	mov    0x4(%eax),%eax
  803695:	85 c0                	test   %eax,%eax
  803697:	74 0f                	je     8036a8 <insert_sorted_with_merge_freeList+0x12a>
  803699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369c:	8b 40 04             	mov    0x4(%eax),%eax
  80369f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036a2:	8b 12                	mov    (%edx),%edx
  8036a4:	89 10                	mov    %edx,(%eax)
  8036a6:	eb 0a                	jmp    8036b2 <insert_sorted_with_merge_freeList+0x134>
  8036a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ab:	8b 00                	mov    (%eax),%eax
  8036ad:	a3 38 51 80 00       	mov    %eax,0x805138
  8036b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c5:	a1 44 51 80 00       	mov    0x805144,%eax
  8036ca:	48                   	dec    %eax
  8036cb:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8036d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8036da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8036e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036e8:	75 17                	jne    803701 <insert_sorted_with_merge_freeList+0x183>
  8036ea:	83 ec 04             	sub    $0x4,%esp
  8036ed:	68 c4 47 80 00       	push   $0x8047c4
  8036f2:	68 3f 01 00 00       	push   $0x13f
  8036f7:	68 e7 47 80 00       	push   $0x8047e7
  8036fc:	e8 43 d5 ff ff       	call   800c44 <_panic>
  803701:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370a:	89 10                	mov    %edx,(%eax)
  80370c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370f:	8b 00                	mov    (%eax),%eax
  803711:	85 c0                	test   %eax,%eax
  803713:	74 0d                	je     803722 <insert_sorted_with_merge_freeList+0x1a4>
  803715:	a1 48 51 80 00       	mov    0x805148,%eax
  80371a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80371d:	89 50 04             	mov    %edx,0x4(%eax)
  803720:	eb 08                	jmp    80372a <insert_sorted_with_merge_freeList+0x1ac>
  803722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803725:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80372a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372d:	a3 48 51 80 00       	mov    %eax,0x805148
  803732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803735:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373c:	a1 54 51 80 00       	mov    0x805154,%eax
  803741:	40                   	inc    %eax
  803742:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803747:	e9 7a 05 00 00       	jmp    803cc6 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80374c:	8b 45 08             	mov    0x8(%ebp),%eax
  80374f:	8b 50 08             	mov    0x8(%eax),%edx
  803752:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803755:	8b 40 08             	mov    0x8(%eax),%eax
  803758:	39 c2                	cmp    %eax,%edx
  80375a:	0f 82 14 01 00 00    	jb     803874 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803763:	8b 50 08             	mov    0x8(%eax),%edx
  803766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803769:	8b 40 0c             	mov    0xc(%eax),%eax
  80376c:	01 c2                	add    %eax,%edx
  80376e:	8b 45 08             	mov    0x8(%ebp),%eax
  803771:	8b 40 08             	mov    0x8(%eax),%eax
  803774:	39 c2                	cmp    %eax,%edx
  803776:	0f 85 90 00 00 00    	jne    80380c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80377c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377f:	8b 50 0c             	mov    0xc(%eax),%edx
  803782:	8b 45 08             	mov    0x8(%ebp),%eax
  803785:	8b 40 0c             	mov    0xc(%eax),%eax
  803788:	01 c2                	add    %eax,%edx
  80378a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80378d:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803790:	8b 45 08             	mov    0x8(%ebp),%eax
  803793:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80379a:	8b 45 08             	mov    0x8(%ebp),%eax
  80379d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037a8:	75 17                	jne    8037c1 <insert_sorted_with_merge_freeList+0x243>
  8037aa:	83 ec 04             	sub    $0x4,%esp
  8037ad:	68 c4 47 80 00       	push   $0x8047c4
  8037b2:	68 49 01 00 00       	push   $0x149
  8037b7:	68 e7 47 80 00       	push   $0x8047e7
  8037bc:	e8 83 d4 ff ff       	call   800c44 <_panic>
  8037c1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ca:	89 10                	mov    %edx,(%eax)
  8037cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cf:	8b 00                	mov    (%eax),%eax
  8037d1:	85 c0                	test   %eax,%eax
  8037d3:	74 0d                	je     8037e2 <insert_sorted_with_merge_freeList+0x264>
  8037d5:	a1 48 51 80 00       	mov    0x805148,%eax
  8037da:	8b 55 08             	mov    0x8(%ebp),%edx
  8037dd:	89 50 04             	mov    %edx,0x4(%eax)
  8037e0:	eb 08                	jmp    8037ea <insert_sorted_with_merge_freeList+0x26c>
  8037e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ed:	a3 48 51 80 00       	mov    %eax,0x805148
  8037f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037fc:	a1 54 51 80 00       	mov    0x805154,%eax
  803801:	40                   	inc    %eax
  803802:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803807:	e9 bb 04 00 00       	jmp    803cc7 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80380c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803810:	75 17                	jne    803829 <insert_sorted_with_merge_freeList+0x2ab>
  803812:	83 ec 04             	sub    $0x4,%esp
  803815:	68 38 48 80 00       	push   $0x804838
  80381a:	68 4c 01 00 00       	push   $0x14c
  80381f:	68 e7 47 80 00       	push   $0x8047e7
  803824:	e8 1b d4 ff ff       	call   800c44 <_panic>
  803829:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80382f:	8b 45 08             	mov    0x8(%ebp),%eax
  803832:	89 50 04             	mov    %edx,0x4(%eax)
  803835:	8b 45 08             	mov    0x8(%ebp),%eax
  803838:	8b 40 04             	mov    0x4(%eax),%eax
  80383b:	85 c0                	test   %eax,%eax
  80383d:	74 0c                	je     80384b <insert_sorted_with_merge_freeList+0x2cd>
  80383f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803844:	8b 55 08             	mov    0x8(%ebp),%edx
  803847:	89 10                	mov    %edx,(%eax)
  803849:	eb 08                	jmp    803853 <insert_sorted_with_merge_freeList+0x2d5>
  80384b:	8b 45 08             	mov    0x8(%ebp),%eax
  80384e:	a3 38 51 80 00       	mov    %eax,0x805138
  803853:	8b 45 08             	mov    0x8(%ebp),%eax
  803856:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80385b:	8b 45 08             	mov    0x8(%ebp),%eax
  80385e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803864:	a1 44 51 80 00       	mov    0x805144,%eax
  803869:	40                   	inc    %eax
  80386a:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80386f:	e9 53 04 00 00       	jmp    803cc7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803874:	a1 38 51 80 00       	mov    0x805138,%eax
  803879:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80387c:	e9 15 04 00 00       	jmp    803c96 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803884:	8b 00                	mov    (%eax),%eax
  803886:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803889:	8b 45 08             	mov    0x8(%ebp),%eax
  80388c:	8b 50 08             	mov    0x8(%eax),%edx
  80388f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803892:	8b 40 08             	mov    0x8(%eax),%eax
  803895:	39 c2                	cmp    %eax,%edx
  803897:	0f 86 f1 03 00 00    	jbe    803c8e <insert_sorted_with_merge_freeList+0x710>
  80389d:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a0:	8b 50 08             	mov    0x8(%eax),%edx
  8038a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a6:	8b 40 08             	mov    0x8(%eax),%eax
  8038a9:	39 c2                	cmp    %eax,%edx
  8038ab:	0f 83 dd 03 00 00    	jae    803c8e <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8038b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b4:	8b 50 08             	mov    0x8(%eax),%edx
  8038b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8038bd:	01 c2                	add    %eax,%edx
  8038bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c2:	8b 40 08             	mov    0x8(%eax),%eax
  8038c5:	39 c2                	cmp    %eax,%edx
  8038c7:	0f 85 b9 01 00 00    	jne    803a86 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d0:	8b 50 08             	mov    0x8(%eax),%edx
  8038d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8038d9:	01 c2                	add    %eax,%edx
  8038db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038de:	8b 40 08             	mov    0x8(%eax),%eax
  8038e1:	39 c2                	cmp    %eax,%edx
  8038e3:	0f 85 0d 01 00 00    	jne    8039f6 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8038e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8038ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8038f5:	01 c2                	add    %eax,%edx
  8038f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fa:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8038fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803901:	75 17                	jne    80391a <insert_sorted_with_merge_freeList+0x39c>
  803903:	83 ec 04             	sub    $0x4,%esp
  803906:	68 90 48 80 00       	push   $0x804890
  80390b:	68 5c 01 00 00       	push   $0x15c
  803910:	68 e7 47 80 00       	push   $0x8047e7
  803915:	e8 2a d3 ff ff       	call   800c44 <_panic>
  80391a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391d:	8b 00                	mov    (%eax),%eax
  80391f:	85 c0                	test   %eax,%eax
  803921:	74 10                	je     803933 <insert_sorted_with_merge_freeList+0x3b5>
  803923:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803926:	8b 00                	mov    (%eax),%eax
  803928:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80392b:	8b 52 04             	mov    0x4(%edx),%edx
  80392e:	89 50 04             	mov    %edx,0x4(%eax)
  803931:	eb 0b                	jmp    80393e <insert_sorted_with_merge_freeList+0x3c0>
  803933:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803936:	8b 40 04             	mov    0x4(%eax),%eax
  803939:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80393e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803941:	8b 40 04             	mov    0x4(%eax),%eax
  803944:	85 c0                	test   %eax,%eax
  803946:	74 0f                	je     803957 <insert_sorted_with_merge_freeList+0x3d9>
  803948:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394b:	8b 40 04             	mov    0x4(%eax),%eax
  80394e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803951:	8b 12                	mov    (%edx),%edx
  803953:	89 10                	mov    %edx,(%eax)
  803955:	eb 0a                	jmp    803961 <insert_sorted_with_merge_freeList+0x3e3>
  803957:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395a:	8b 00                	mov    (%eax),%eax
  80395c:	a3 38 51 80 00       	mov    %eax,0x805138
  803961:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803964:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80396a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803974:	a1 44 51 80 00       	mov    0x805144,%eax
  803979:	48                   	dec    %eax
  80397a:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80397f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803982:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803989:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803993:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803997:	75 17                	jne    8039b0 <insert_sorted_with_merge_freeList+0x432>
  803999:	83 ec 04             	sub    $0x4,%esp
  80399c:	68 c4 47 80 00       	push   $0x8047c4
  8039a1:	68 5f 01 00 00       	push   $0x15f
  8039a6:	68 e7 47 80 00       	push   $0x8047e7
  8039ab:	e8 94 d2 ff ff       	call   800c44 <_panic>
  8039b0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b9:	89 10                	mov    %edx,(%eax)
  8039bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039be:	8b 00                	mov    (%eax),%eax
  8039c0:	85 c0                	test   %eax,%eax
  8039c2:	74 0d                	je     8039d1 <insert_sorted_with_merge_freeList+0x453>
  8039c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8039c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039cc:	89 50 04             	mov    %edx,0x4(%eax)
  8039cf:	eb 08                	jmp    8039d9 <insert_sorted_with_merge_freeList+0x45b>
  8039d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8039e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039eb:	a1 54 51 80 00       	mov    0x805154,%eax
  8039f0:	40                   	inc    %eax
  8039f1:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8039f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8039fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803a02:	01 c2                	add    %eax,%edx
  803a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a07:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a14:	8b 45 08             	mov    0x8(%ebp),%eax
  803a17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a22:	75 17                	jne    803a3b <insert_sorted_with_merge_freeList+0x4bd>
  803a24:	83 ec 04             	sub    $0x4,%esp
  803a27:	68 c4 47 80 00       	push   $0x8047c4
  803a2c:	68 64 01 00 00       	push   $0x164
  803a31:	68 e7 47 80 00       	push   $0x8047e7
  803a36:	e8 09 d2 ff ff       	call   800c44 <_panic>
  803a3b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a41:	8b 45 08             	mov    0x8(%ebp),%eax
  803a44:	89 10                	mov    %edx,(%eax)
  803a46:	8b 45 08             	mov    0x8(%ebp),%eax
  803a49:	8b 00                	mov    (%eax),%eax
  803a4b:	85 c0                	test   %eax,%eax
  803a4d:	74 0d                	je     803a5c <insert_sorted_with_merge_freeList+0x4de>
  803a4f:	a1 48 51 80 00       	mov    0x805148,%eax
  803a54:	8b 55 08             	mov    0x8(%ebp),%edx
  803a57:	89 50 04             	mov    %edx,0x4(%eax)
  803a5a:	eb 08                	jmp    803a64 <insert_sorted_with_merge_freeList+0x4e6>
  803a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a64:	8b 45 08             	mov    0x8(%ebp),%eax
  803a67:	a3 48 51 80 00       	mov    %eax,0x805148
  803a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a76:	a1 54 51 80 00       	mov    0x805154,%eax
  803a7b:	40                   	inc    %eax
  803a7c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a81:	e9 41 02 00 00       	jmp    803cc7 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803a86:	8b 45 08             	mov    0x8(%ebp),%eax
  803a89:	8b 50 08             	mov    0x8(%eax),%edx
  803a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8f:	8b 40 0c             	mov    0xc(%eax),%eax
  803a92:	01 c2                	add    %eax,%edx
  803a94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a97:	8b 40 08             	mov    0x8(%eax),%eax
  803a9a:	39 c2                	cmp    %eax,%edx
  803a9c:	0f 85 7c 01 00 00    	jne    803c1e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803aa2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803aa6:	74 06                	je     803aae <insert_sorted_with_merge_freeList+0x530>
  803aa8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aac:	75 17                	jne    803ac5 <insert_sorted_with_merge_freeList+0x547>
  803aae:	83 ec 04             	sub    $0x4,%esp
  803ab1:	68 00 48 80 00       	push   $0x804800
  803ab6:	68 69 01 00 00       	push   $0x169
  803abb:	68 e7 47 80 00       	push   $0x8047e7
  803ac0:	e8 7f d1 ff ff       	call   800c44 <_panic>
  803ac5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac8:	8b 50 04             	mov    0x4(%eax),%edx
  803acb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ace:	89 50 04             	mov    %edx,0x4(%eax)
  803ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ad7:	89 10                	mov    %edx,(%eax)
  803ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803adc:	8b 40 04             	mov    0x4(%eax),%eax
  803adf:	85 c0                	test   %eax,%eax
  803ae1:	74 0d                	je     803af0 <insert_sorted_with_merge_freeList+0x572>
  803ae3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae6:	8b 40 04             	mov    0x4(%eax),%eax
  803ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  803aec:	89 10                	mov    %edx,(%eax)
  803aee:	eb 08                	jmp    803af8 <insert_sorted_with_merge_freeList+0x57a>
  803af0:	8b 45 08             	mov    0x8(%ebp),%eax
  803af3:	a3 38 51 80 00       	mov    %eax,0x805138
  803af8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803afb:	8b 55 08             	mov    0x8(%ebp),%edx
  803afe:	89 50 04             	mov    %edx,0x4(%eax)
  803b01:	a1 44 51 80 00       	mov    0x805144,%eax
  803b06:	40                   	inc    %eax
  803b07:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0f:	8b 50 0c             	mov    0xc(%eax),%edx
  803b12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b15:	8b 40 0c             	mov    0xc(%eax),%eax
  803b18:	01 c2                	add    %eax,%edx
  803b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b20:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b24:	75 17                	jne    803b3d <insert_sorted_with_merge_freeList+0x5bf>
  803b26:	83 ec 04             	sub    $0x4,%esp
  803b29:	68 90 48 80 00       	push   $0x804890
  803b2e:	68 6b 01 00 00       	push   $0x16b
  803b33:	68 e7 47 80 00       	push   $0x8047e7
  803b38:	e8 07 d1 ff ff       	call   800c44 <_panic>
  803b3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b40:	8b 00                	mov    (%eax),%eax
  803b42:	85 c0                	test   %eax,%eax
  803b44:	74 10                	je     803b56 <insert_sorted_with_merge_freeList+0x5d8>
  803b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b49:	8b 00                	mov    (%eax),%eax
  803b4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b4e:	8b 52 04             	mov    0x4(%edx),%edx
  803b51:	89 50 04             	mov    %edx,0x4(%eax)
  803b54:	eb 0b                	jmp    803b61 <insert_sorted_with_merge_freeList+0x5e3>
  803b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b59:	8b 40 04             	mov    0x4(%eax),%eax
  803b5c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b64:	8b 40 04             	mov    0x4(%eax),%eax
  803b67:	85 c0                	test   %eax,%eax
  803b69:	74 0f                	je     803b7a <insert_sorted_with_merge_freeList+0x5fc>
  803b6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6e:	8b 40 04             	mov    0x4(%eax),%eax
  803b71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b74:	8b 12                	mov    (%edx),%edx
  803b76:	89 10                	mov    %edx,(%eax)
  803b78:	eb 0a                	jmp    803b84 <insert_sorted_with_merge_freeList+0x606>
  803b7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7d:	8b 00                	mov    (%eax),%eax
  803b7f:	a3 38 51 80 00       	mov    %eax,0x805138
  803b84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b97:	a1 44 51 80 00       	mov    0x805144,%eax
  803b9c:	48                   	dec    %eax
  803b9d:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803ba2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803bac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803baf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803bb6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bba:	75 17                	jne    803bd3 <insert_sorted_with_merge_freeList+0x655>
  803bbc:	83 ec 04             	sub    $0x4,%esp
  803bbf:	68 c4 47 80 00       	push   $0x8047c4
  803bc4:	68 6e 01 00 00       	push   $0x16e
  803bc9:	68 e7 47 80 00       	push   $0x8047e7
  803bce:	e8 71 d0 ff ff       	call   800c44 <_panic>
  803bd3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803bd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bdc:	89 10                	mov    %edx,(%eax)
  803bde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be1:	8b 00                	mov    (%eax),%eax
  803be3:	85 c0                	test   %eax,%eax
  803be5:	74 0d                	je     803bf4 <insert_sorted_with_merge_freeList+0x676>
  803be7:	a1 48 51 80 00       	mov    0x805148,%eax
  803bec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bef:	89 50 04             	mov    %edx,0x4(%eax)
  803bf2:	eb 08                	jmp    803bfc <insert_sorted_with_merge_freeList+0x67e>
  803bf4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803bfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bff:	a3 48 51 80 00       	mov    %eax,0x805148
  803c04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c0e:	a1 54 51 80 00       	mov    0x805154,%eax
  803c13:	40                   	inc    %eax
  803c14:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c19:	e9 a9 00 00 00       	jmp    803cc7 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803c1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c22:	74 06                	je     803c2a <insert_sorted_with_merge_freeList+0x6ac>
  803c24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c28:	75 17                	jne    803c41 <insert_sorted_with_merge_freeList+0x6c3>
  803c2a:	83 ec 04             	sub    $0x4,%esp
  803c2d:	68 5c 48 80 00       	push   $0x80485c
  803c32:	68 73 01 00 00       	push   $0x173
  803c37:	68 e7 47 80 00       	push   $0x8047e7
  803c3c:	e8 03 d0 ff ff       	call   800c44 <_panic>
  803c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c44:	8b 10                	mov    (%eax),%edx
  803c46:	8b 45 08             	mov    0x8(%ebp),%eax
  803c49:	89 10                	mov    %edx,(%eax)
  803c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4e:	8b 00                	mov    (%eax),%eax
  803c50:	85 c0                	test   %eax,%eax
  803c52:	74 0b                	je     803c5f <insert_sorted_with_merge_freeList+0x6e1>
  803c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c57:	8b 00                	mov    (%eax),%eax
  803c59:	8b 55 08             	mov    0x8(%ebp),%edx
  803c5c:	89 50 04             	mov    %edx,0x4(%eax)
  803c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c62:	8b 55 08             	mov    0x8(%ebp),%edx
  803c65:	89 10                	mov    %edx,(%eax)
  803c67:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c6d:	89 50 04             	mov    %edx,0x4(%eax)
  803c70:	8b 45 08             	mov    0x8(%ebp),%eax
  803c73:	8b 00                	mov    (%eax),%eax
  803c75:	85 c0                	test   %eax,%eax
  803c77:	75 08                	jne    803c81 <insert_sorted_with_merge_freeList+0x703>
  803c79:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c81:	a1 44 51 80 00       	mov    0x805144,%eax
  803c86:	40                   	inc    %eax
  803c87:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803c8c:	eb 39                	jmp    803cc7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803c8e:	a1 40 51 80 00       	mov    0x805140,%eax
  803c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c9a:	74 07                	je     803ca3 <insert_sorted_with_merge_freeList+0x725>
  803c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9f:	8b 00                	mov    (%eax),%eax
  803ca1:	eb 05                	jmp    803ca8 <insert_sorted_with_merge_freeList+0x72a>
  803ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca8:	a3 40 51 80 00       	mov    %eax,0x805140
  803cad:	a1 40 51 80 00       	mov    0x805140,%eax
  803cb2:	85 c0                	test   %eax,%eax
  803cb4:	0f 85 c7 fb ff ff    	jne    803881 <insert_sorted_with_merge_freeList+0x303>
  803cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cbe:	0f 85 bd fb ff ff    	jne    803881 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803cc4:	eb 01                	jmp    803cc7 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803cc6:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803cc7:	90                   	nop
  803cc8:	c9                   	leave  
  803cc9:	c3                   	ret    
  803cca:	66 90                	xchg   %ax,%ax

00803ccc <__udivdi3>:
  803ccc:	55                   	push   %ebp
  803ccd:	57                   	push   %edi
  803cce:	56                   	push   %esi
  803ccf:	53                   	push   %ebx
  803cd0:	83 ec 1c             	sub    $0x1c,%esp
  803cd3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cd7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cdf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ce3:	89 ca                	mov    %ecx,%edx
  803ce5:	89 f8                	mov    %edi,%eax
  803ce7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ceb:	85 f6                	test   %esi,%esi
  803ced:	75 2d                	jne    803d1c <__udivdi3+0x50>
  803cef:	39 cf                	cmp    %ecx,%edi
  803cf1:	77 65                	ja     803d58 <__udivdi3+0x8c>
  803cf3:	89 fd                	mov    %edi,%ebp
  803cf5:	85 ff                	test   %edi,%edi
  803cf7:	75 0b                	jne    803d04 <__udivdi3+0x38>
  803cf9:	b8 01 00 00 00       	mov    $0x1,%eax
  803cfe:	31 d2                	xor    %edx,%edx
  803d00:	f7 f7                	div    %edi
  803d02:	89 c5                	mov    %eax,%ebp
  803d04:	31 d2                	xor    %edx,%edx
  803d06:	89 c8                	mov    %ecx,%eax
  803d08:	f7 f5                	div    %ebp
  803d0a:	89 c1                	mov    %eax,%ecx
  803d0c:	89 d8                	mov    %ebx,%eax
  803d0e:	f7 f5                	div    %ebp
  803d10:	89 cf                	mov    %ecx,%edi
  803d12:	89 fa                	mov    %edi,%edx
  803d14:	83 c4 1c             	add    $0x1c,%esp
  803d17:	5b                   	pop    %ebx
  803d18:	5e                   	pop    %esi
  803d19:	5f                   	pop    %edi
  803d1a:	5d                   	pop    %ebp
  803d1b:	c3                   	ret    
  803d1c:	39 ce                	cmp    %ecx,%esi
  803d1e:	77 28                	ja     803d48 <__udivdi3+0x7c>
  803d20:	0f bd fe             	bsr    %esi,%edi
  803d23:	83 f7 1f             	xor    $0x1f,%edi
  803d26:	75 40                	jne    803d68 <__udivdi3+0x9c>
  803d28:	39 ce                	cmp    %ecx,%esi
  803d2a:	72 0a                	jb     803d36 <__udivdi3+0x6a>
  803d2c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d30:	0f 87 9e 00 00 00    	ja     803dd4 <__udivdi3+0x108>
  803d36:	b8 01 00 00 00       	mov    $0x1,%eax
  803d3b:	89 fa                	mov    %edi,%edx
  803d3d:	83 c4 1c             	add    $0x1c,%esp
  803d40:	5b                   	pop    %ebx
  803d41:	5e                   	pop    %esi
  803d42:	5f                   	pop    %edi
  803d43:	5d                   	pop    %ebp
  803d44:	c3                   	ret    
  803d45:	8d 76 00             	lea    0x0(%esi),%esi
  803d48:	31 ff                	xor    %edi,%edi
  803d4a:	31 c0                	xor    %eax,%eax
  803d4c:	89 fa                	mov    %edi,%edx
  803d4e:	83 c4 1c             	add    $0x1c,%esp
  803d51:	5b                   	pop    %ebx
  803d52:	5e                   	pop    %esi
  803d53:	5f                   	pop    %edi
  803d54:	5d                   	pop    %ebp
  803d55:	c3                   	ret    
  803d56:	66 90                	xchg   %ax,%ax
  803d58:	89 d8                	mov    %ebx,%eax
  803d5a:	f7 f7                	div    %edi
  803d5c:	31 ff                	xor    %edi,%edi
  803d5e:	89 fa                	mov    %edi,%edx
  803d60:	83 c4 1c             	add    $0x1c,%esp
  803d63:	5b                   	pop    %ebx
  803d64:	5e                   	pop    %esi
  803d65:	5f                   	pop    %edi
  803d66:	5d                   	pop    %ebp
  803d67:	c3                   	ret    
  803d68:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d6d:	89 eb                	mov    %ebp,%ebx
  803d6f:	29 fb                	sub    %edi,%ebx
  803d71:	89 f9                	mov    %edi,%ecx
  803d73:	d3 e6                	shl    %cl,%esi
  803d75:	89 c5                	mov    %eax,%ebp
  803d77:	88 d9                	mov    %bl,%cl
  803d79:	d3 ed                	shr    %cl,%ebp
  803d7b:	89 e9                	mov    %ebp,%ecx
  803d7d:	09 f1                	or     %esi,%ecx
  803d7f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d83:	89 f9                	mov    %edi,%ecx
  803d85:	d3 e0                	shl    %cl,%eax
  803d87:	89 c5                	mov    %eax,%ebp
  803d89:	89 d6                	mov    %edx,%esi
  803d8b:	88 d9                	mov    %bl,%cl
  803d8d:	d3 ee                	shr    %cl,%esi
  803d8f:	89 f9                	mov    %edi,%ecx
  803d91:	d3 e2                	shl    %cl,%edx
  803d93:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d97:	88 d9                	mov    %bl,%cl
  803d99:	d3 e8                	shr    %cl,%eax
  803d9b:	09 c2                	or     %eax,%edx
  803d9d:	89 d0                	mov    %edx,%eax
  803d9f:	89 f2                	mov    %esi,%edx
  803da1:	f7 74 24 0c          	divl   0xc(%esp)
  803da5:	89 d6                	mov    %edx,%esi
  803da7:	89 c3                	mov    %eax,%ebx
  803da9:	f7 e5                	mul    %ebp
  803dab:	39 d6                	cmp    %edx,%esi
  803dad:	72 19                	jb     803dc8 <__udivdi3+0xfc>
  803daf:	74 0b                	je     803dbc <__udivdi3+0xf0>
  803db1:	89 d8                	mov    %ebx,%eax
  803db3:	31 ff                	xor    %edi,%edi
  803db5:	e9 58 ff ff ff       	jmp    803d12 <__udivdi3+0x46>
  803dba:	66 90                	xchg   %ax,%ax
  803dbc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803dc0:	89 f9                	mov    %edi,%ecx
  803dc2:	d3 e2                	shl    %cl,%edx
  803dc4:	39 c2                	cmp    %eax,%edx
  803dc6:	73 e9                	jae    803db1 <__udivdi3+0xe5>
  803dc8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803dcb:	31 ff                	xor    %edi,%edi
  803dcd:	e9 40 ff ff ff       	jmp    803d12 <__udivdi3+0x46>
  803dd2:	66 90                	xchg   %ax,%ax
  803dd4:	31 c0                	xor    %eax,%eax
  803dd6:	e9 37 ff ff ff       	jmp    803d12 <__udivdi3+0x46>
  803ddb:	90                   	nop

00803ddc <__umoddi3>:
  803ddc:	55                   	push   %ebp
  803ddd:	57                   	push   %edi
  803dde:	56                   	push   %esi
  803ddf:	53                   	push   %ebx
  803de0:	83 ec 1c             	sub    $0x1c,%esp
  803de3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803de7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803deb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803def:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803df3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803df7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dfb:	89 f3                	mov    %esi,%ebx
  803dfd:	89 fa                	mov    %edi,%edx
  803dff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e03:	89 34 24             	mov    %esi,(%esp)
  803e06:	85 c0                	test   %eax,%eax
  803e08:	75 1a                	jne    803e24 <__umoddi3+0x48>
  803e0a:	39 f7                	cmp    %esi,%edi
  803e0c:	0f 86 a2 00 00 00    	jbe    803eb4 <__umoddi3+0xd8>
  803e12:	89 c8                	mov    %ecx,%eax
  803e14:	89 f2                	mov    %esi,%edx
  803e16:	f7 f7                	div    %edi
  803e18:	89 d0                	mov    %edx,%eax
  803e1a:	31 d2                	xor    %edx,%edx
  803e1c:	83 c4 1c             	add    $0x1c,%esp
  803e1f:	5b                   	pop    %ebx
  803e20:	5e                   	pop    %esi
  803e21:	5f                   	pop    %edi
  803e22:	5d                   	pop    %ebp
  803e23:	c3                   	ret    
  803e24:	39 f0                	cmp    %esi,%eax
  803e26:	0f 87 ac 00 00 00    	ja     803ed8 <__umoddi3+0xfc>
  803e2c:	0f bd e8             	bsr    %eax,%ebp
  803e2f:	83 f5 1f             	xor    $0x1f,%ebp
  803e32:	0f 84 ac 00 00 00    	je     803ee4 <__umoddi3+0x108>
  803e38:	bf 20 00 00 00       	mov    $0x20,%edi
  803e3d:	29 ef                	sub    %ebp,%edi
  803e3f:	89 fe                	mov    %edi,%esi
  803e41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e45:	89 e9                	mov    %ebp,%ecx
  803e47:	d3 e0                	shl    %cl,%eax
  803e49:	89 d7                	mov    %edx,%edi
  803e4b:	89 f1                	mov    %esi,%ecx
  803e4d:	d3 ef                	shr    %cl,%edi
  803e4f:	09 c7                	or     %eax,%edi
  803e51:	89 e9                	mov    %ebp,%ecx
  803e53:	d3 e2                	shl    %cl,%edx
  803e55:	89 14 24             	mov    %edx,(%esp)
  803e58:	89 d8                	mov    %ebx,%eax
  803e5a:	d3 e0                	shl    %cl,%eax
  803e5c:	89 c2                	mov    %eax,%edx
  803e5e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e62:	d3 e0                	shl    %cl,%eax
  803e64:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e68:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e6c:	89 f1                	mov    %esi,%ecx
  803e6e:	d3 e8                	shr    %cl,%eax
  803e70:	09 d0                	or     %edx,%eax
  803e72:	d3 eb                	shr    %cl,%ebx
  803e74:	89 da                	mov    %ebx,%edx
  803e76:	f7 f7                	div    %edi
  803e78:	89 d3                	mov    %edx,%ebx
  803e7a:	f7 24 24             	mull   (%esp)
  803e7d:	89 c6                	mov    %eax,%esi
  803e7f:	89 d1                	mov    %edx,%ecx
  803e81:	39 d3                	cmp    %edx,%ebx
  803e83:	0f 82 87 00 00 00    	jb     803f10 <__umoddi3+0x134>
  803e89:	0f 84 91 00 00 00    	je     803f20 <__umoddi3+0x144>
  803e8f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e93:	29 f2                	sub    %esi,%edx
  803e95:	19 cb                	sbb    %ecx,%ebx
  803e97:	89 d8                	mov    %ebx,%eax
  803e99:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e9d:	d3 e0                	shl    %cl,%eax
  803e9f:	89 e9                	mov    %ebp,%ecx
  803ea1:	d3 ea                	shr    %cl,%edx
  803ea3:	09 d0                	or     %edx,%eax
  803ea5:	89 e9                	mov    %ebp,%ecx
  803ea7:	d3 eb                	shr    %cl,%ebx
  803ea9:	89 da                	mov    %ebx,%edx
  803eab:	83 c4 1c             	add    $0x1c,%esp
  803eae:	5b                   	pop    %ebx
  803eaf:	5e                   	pop    %esi
  803eb0:	5f                   	pop    %edi
  803eb1:	5d                   	pop    %ebp
  803eb2:	c3                   	ret    
  803eb3:	90                   	nop
  803eb4:	89 fd                	mov    %edi,%ebp
  803eb6:	85 ff                	test   %edi,%edi
  803eb8:	75 0b                	jne    803ec5 <__umoddi3+0xe9>
  803eba:	b8 01 00 00 00       	mov    $0x1,%eax
  803ebf:	31 d2                	xor    %edx,%edx
  803ec1:	f7 f7                	div    %edi
  803ec3:	89 c5                	mov    %eax,%ebp
  803ec5:	89 f0                	mov    %esi,%eax
  803ec7:	31 d2                	xor    %edx,%edx
  803ec9:	f7 f5                	div    %ebp
  803ecb:	89 c8                	mov    %ecx,%eax
  803ecd:	f7 f5                	div    %ebp
  803ecf:	89 d0                	mov    %edx,%eax
  803ed1:	e9 44 ff ff ff       	jmp    803e1a <__umoddi3+0x3e>
  803ed6:	66 90                	xchg   %ax,%ax
  803ed8:	89 c8                	mov    %ecx,%eax
  803eda:	89 f2                	mov    %esi,%edx
  803edc:	83 c4 1c             	add    $0x1c,%esp
  803edf:	5b                   	pop    %ebx
  803ee0:	5e                   	pop    %esi
  803ee1:	5f                   	pop    %edi
  803ee2:	5d                   	pop    %ebp
  803ee3:	c3                   	ret    
  803ee4:	3b 04 24             	cmp    (%esp),%eax
  803ee7:	72 06                	jb     803eef <__umoddi3+0x113>
  803ee9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803eed:	77 0f                	ja     803efe <__umoddi3+0x122>
  803eef:	89 f2                	mov    %esi,%edx
  803ef1:	29 f9                	sub    %edi,%ecx
  803ef3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ef7:	89 14 24             	mov    %edx,(%esp)
  803efa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803efe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f02:	8b 14 24             	mov    (%esp),%edx
  803f05:	83 c4 1c             	add    $0x1c,%esp
  803f08:	5b                   	pop    %ebx
  803f09:	5e                   	pop    %esi
  803f0a:	5f                   	pop    %edi
  803f0b:	5d                   	pop    %ebp
  803f0c:	c3                   	ret    
  803f0d:	8d 76 00             	lea    0x0(%esi),%esi
  803f10:	2b 04 24             	sub    (%esp),%eax
  803f13:	19 fa                	sbb    %edi,%edx
  803f15:	89 d1                	mov    %edx,%ecx
  803f17:	89 c6                	mov    %eax,%esi
  803f19:	e9 71 ff ff ff       	jmp    803e8f <__umoddi3+0xb3>
  803f1e:	66 90                	xchg   %ax,%ax
  803f20:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f24:	72 ea                	jb     803f10 <__umoddi3+0x134>
  803f26:	89 d9                	mov    %ebx,%ecx
  803f28:	e9 62 ff ff ff       	jmp    803e8f <__umoddi3+0xb3>
