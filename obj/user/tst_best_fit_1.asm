
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
  800045:	e8 20 26 00 00       	call   80266a <sys_set_uheap_strategy>
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
  80009b:	68 80 3f 80 00       	push   $0x803f80
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 9c 3f 80 00       	push   $0x803f9c
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
  8000d8:	e8 78 20 00 00       	call   802155 <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 10 21 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  800110:	68 b4 3f 80 00       	push   $0x803fb4
  800115:	6a 26                	push   $0x26
  800117:	68 9c 3f 80 00       	push   $0x803f9c
  80011c:	e8 23 0b 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  800121:	e8 cf 20 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  800126:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800129:	3d 00 03 00 00       	cmp    $0x300,%eax
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 e4 3f 80 00       	push   $0x803fe4
  800138:	6a 28                	push   $0x28
  80013a:	68 9c 3f 80 00       	push   $0x803f9c
  80013f:	e8 00 0b 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800144:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800147:	e8 09 20 00 00       	call   802155 <sys_calculate_free_frames>
  80014c:	29 c3                	sub    %eax,%ebx
  80014e:	89 d8                	mov    %ebx,%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 01 40 80 00       	push   $0x804001
  80015d:	6a 29                	push   $0x29
  80015f:	68 9c 3f 80 00       	push   $0x803f9c
  800164:	e8 db 0a 00 00       	call   800c44 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 e7 1f 00 00       	call   802155 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 7f 20 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  8001ae:	68 b4 3f 80 00       	push   $0x803fb4
  8001b3:	6a 2f                	push   $0x2f
  8001b5:	68 9c 3f 80 00       	push   $0x803f9c
  8001ba:	e8 85 0a 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001bf:	e8 31 20 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  8001c4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c7:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 e4 3f 80 00       	push   $0x803fe4
  8001d6:	6a 31                	push   $0x31
  8001d8:	68 9c 3f 80 00       	push   $0x803f9c
  8001dd:	e8 62 0a 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001e5:	e8 6b 1f 00 00       	call   802155 <sys_calculate_free_frames>
  8001ea:	29 c3                	sub    %eax,%ebx
  8001ec:	89 d8                	mov    %ebx,%eax
  8001ee:	83 f8 01             	cmp    $0x1,%eax
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 01 40 80 00       	push   $0x804001
  8001fb:	6a 32                	push   $0x32
  8001fd:	68 9c 3f 80 00       	push   $0x803f9c
  800202:	e8 3d 0a 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800207:	e8 49 1f 00 00       	call   802155 <sys_calculate_free_frames>
  80020c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020f:	e8 e1 1f 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  80024a:	68 b4 3f 80 00       	push   $0x803fb4
  80024f:	6a 38                	push   $0x38
  800251:	68 9c 3f 80 00       	push   $0x803f9c
  800256:	e8 e9 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  80025b:	e8 95 1f 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  800260:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800263:	3d 00 02 00 00       	cmp    $0x200,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 e4 3f 80 00       	push   $0x803fe4
  800272:	6a 3a                	push   $0x3a
  800274:	68 9c 3f 80 00       	push   $0x803f9c
  800279:	e8 c6 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80027e:	e8 d2 1e 00 00       	call   802155 <sys_calculate_free_frames>
  800283:	89 c2                	mov    %eax,%edx
  800285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800288:	39 c2                	cmp    %eax,%edx
  80028a:	74 14                	je     8002a0 <_main+0x268>
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 01 40 80 00       	push   $0x804001
  800294:	6a 3b                	push   $0x3b
  800296:	68 9c 3f 80 00       	push   $0x803f9c
  80029b:	e8 a4 09 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002a0:	e8 b0 1e 00 00       	call   802155 <sys_calculate_free_frames>
  8002a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002a8:	e8 48 1f 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  8002de:	68 b4 3f 80 00       	push   $0x803fb4
  8002e3:	6a 41                	push   $0x41
  8002e5:	68 9c 3f 80 00       	push   $0x803f9c
  8002ea:	e8 55 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002ef:	e8 01 1f 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  8002f4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 e4 3f 80 00       	push   $0x803fe4
  800306:	6a 43                	push   $0x43
  800308:	68 9c 3f 80 00       	push   $0x803f9c
  80030d:	e8 32 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800312:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800315:	e8 3b 1e 00 00       	call   802155 <sys_calculate_free_frames>
  80031a:	29 c3                	sub    %eax,%ebx
  80031c:	89 d8                	mov    %ebx,%eax
  80031e:	83 f8 01             	cmp    $0x1,%eax
  800321:	74 14                	je     800337 <_main+0x2ff>
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	68 01 40 80 00       	push   $0x804001
  80032b:	6a 44                	push   $0x44
  80032d:	68 9c 3f 80 00       	push   $0x803f9c
  800332:	e8 0d 09 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800337:	e8 19 1e 00 00       	call   802155 <sys_calculate_free_frames>
  80033c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80033f:	e8 b1 1e 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  800379:	68 b4 3f 80 00       	push   $0x803fb4
  80037e:	6a 4a                	push   $0x4a
  800380:	68 9c 3f 80 00       	push   $0x803f9c
  800385:	e8 ba 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80038a:	e8 66 1e 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  80038f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800392:	3d 00 01 00 00       	cmp    $0x100,%eax
  800397:	74 14                	je     8003ad <_main+0x375>
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 e4 3f 80 00       	push   $0x803fe4
  8003a1:	6a 4c                	push   $0x4c
  8003a3:	68 9c 3f 80 00       	push   $0x803f9c
  8003a8:	e8 97 08 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003ad:	e8 a3 1d 00 00       	call   802155 <sys_calculate_free_frames>
  8003b2:	89 c2                	mov    %eax,%edx
  8003b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	74 14                	je     8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 01 40 80 00       	push   $0x804001
  8003c3:	6a 4d                	push   $0x4d
  8003c5:	68 9c 3f 80 00       	push   $0x803f9c
  8003ca:	e8 75 08 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cf:	e8 81 1d 00 00       	call   802155 <sys_calculate_free_frames>
  8003d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d7:	e8 19 1e 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  800413:	68 b4 3f 80 00       	push   $0x803fb4
  800418:	6a 53                	push   $0x53
  80041a:	68 9c 3f 80 00       	push   $0x803f9c
  80041f:	e8 20 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800424:	e8 cc 1d 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  800429:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80042c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800431:	74 14                	je     800447 <_main+0x40f>
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	68 e4 3f 80 00       	push   $0x803fe4
  80043b:	6a 55                	push   $0x55
  80043d:	68 9c 3f 80 00       	push   $0x803f9c
  800442:	e8 fd 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800447:	e8 09 1d 00 00       	call   802155 <sys_calculate_free_frames>
  80044c:	89 c2                	mov    %eax,%edx
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	74 14                	je     800469 <_main+0x431>
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 01 40 80 00       	push   $0x804001
  80045d:	6a 56                	push   $0x56
  80045f:	68 9c 3f 80 00       	push   $0x803f9c
  800464:	e8 db 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800469:	e8 e7 1c 00 00       	call   802155 <sys_calculate_free_frames>
  80046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800471:	e8 7f 1d 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  8004ab:	68 b4 3f 80 00       	push   $0x803fb4
  8004b0:	6a 5c                	push   $0x5c
  8004b2:	68 9c 3f 80 00       	push   $0x803f9c
  8004b7:	e8 88 07 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004bc:	e8 34 1d 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  8004c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 e4 3f 80 00       	push   $0x803fe4
  8004d3:	6a 5e                	push   $0x5e
  8004d5:	68 9c 3f 80 00       	push   $0x803f9c
  8004da:	e8 65 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004e2:	e8 6e 1c 00 00       	call   802155 <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	83 f8 01             	cmp    $0x1,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 01 40 80 00       	push   $0x804001
  8004f8:	6a 5f                	push   $0x5f
  8004fa:	68 9c 3f 80 00       	push   $0x803f9c
  8004ff:	e8 40 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800504:	e8 4c 1c 00 00       	call   802155 <sys_calculate_free_frames>
  800509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80050c:	e8 e4 1c 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  800548:	68 b4 3f 80 00       	push   $0x803fb4
  80054d:	6a 65                	push   $0x65
  80054f:	68 9c 3f 80 00       	push   $0x803f9c
  800554:	e8 eb 06 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800559:	e8 97 1c 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  80055e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800561:	3d 00 01 00 00       	cmp    $0x100,%eax
  800566:	74 14                	je     80057c <_main+0x544>
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	68 e4 3f 80 00       	push   $0x803fe4
  800570:	6a 67                	push   $0x67
  800572:	68 9c 3f 80 00       	push   $0x803f9c
  800577:	e8 c8 06 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80057c:	e8 d4 1b 00 00       	call   802155 <sys_calculate_free_frames>
  800581:	89 c2                	mov    %eax,%edx
  800583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	74 14                	je     80059e <_main+0x566>
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 01 40 80 00       	push   $0x804001
  800592:	6a 68                	push   $0x68
  800594:	68 9c 3f 80 00       	push   $0x803f9c
  800599:	e8 a6 06 00 00       	call   800c44 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80059e:	e8 b2 1b 00 00       	call   802155 <sys_calculate_free_frames>
  8005a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005a6:	e8 4a 1c 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	50                   	push   %eax
  8005b5:	e8 41 19 00 00       	call   801efb <free>
  8005ba:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005bd:	e8 33 1c 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  8005c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c5:	29 c2                	sub    %eax,%edx
  8005c7:	89 d0                	mov    %edx,%eax
  8005c9:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 14 40 80 00       	push   $0x804014
  8005d8:	6a 72                	push   $0x72
  8005da:	68 9c 3f 80 00       	push   $0x803f9c
  8005df:	e8 60 06 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005e4:	e8 6c 1b 00 00       	call   802155 <sys_calculate_free_frames>
  8005e9:	89 c2                	mov    %eax,%edx
  8005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ee:	39 c2                	cmp    %eax,%edx
  8005f0:	74 14                	je     800606 <_main+0x5ce>
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 2b 40 80 00       	push   $0x80402b
  8005fa:	6a 73                	push   $0x73
  8005fc:	68 9c 3f 80 00       	push   $0x803f9c
  800601:	e8 3e 06 00 00       	call   800c44 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800606:	e8 4a 1b 00 00       	call   802155 <sys_calculate_free_frames>
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060e:	e8 e2 1b 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  800613:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800616:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	50                   	push   %eax
  80061d:	e8 d9 18 00 00       	call   801efb <free>
  800622:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800625:	e8 cb 1b 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  80062a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062d:	29 c2                	sub    %eax,%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	3d 00 02 00 00       	cmp    $0x200,%eax
  800636:	74 14                	je     80064c <_main+0x614>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 14 40 80 00       	push   $0x804014
  800640:	6a 7a                	push   $0x7a
  800642:	68 9c 3f 80 00       	push   $0x803f9c
  800647:	e8 f8 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064c:	e8 04 1b 00 00       	call   802155 <sys_calculate_free_frames>
  800651:	89 c2                	mov    %eax,%edx
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	74 14                	je     80066e <_main+0x636>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 2b 40 80 00       	push   $0x80402b
  800662:	6a 7b                	push   $0x7b
  800664:	68 9c 3f 80 00       	push   $0x803f9c
  800669:	e8 d6 05 00 00       	call   800c44 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80066e:	e8 e2 1a 00 00       	call   802155 <sys_calculate_free_frames>
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800676:	e8 7a 1b 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80067e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800681:	83 ec 0c             	sub    $0xc,%esp
  800684:	50                   	push   %eax
  800685:	e8 71 18 00 00       	call   801efb <free>
  80068a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80068d:	e8 63 1b 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  800692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	3d 00 01 00 00       	cmp    $0x100,%eax
  80069e:	74 17                	je     8006b7 <_main+0x67f>
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	68 14 40 80 00       	push   $0x804014
  8006a8:	68 82 00 00 00       	push   $0x82
  8006ad:	68 9c 3f 80 00       	push   $0x803f9c
  8006b2:	e8 8d 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006b7:	e8 99 1a 00 00       	call   802155 <sys_calculate_free_frames>
  8006bc:	89 c2                	mov    %eax,%edx
  8006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	74 17                	je     8006dc <_main+0x6a4>
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	68 2b 40 80 00       	push   $0x80402b
  8006cd:	68 83 00 00 00       	push   $0x83
  8006d2:	68 9c 3f 80 00       	push   $0x803f9c
  8006d7:	e8 68 05 00 00       	call   800c44 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006dc:	e8 74 1a 00 00       	call   802155 <sys_calculate_free_frames>
  8006e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006e4:	e8 0c 1b 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  800720:	68 b4 3f 80 00       	push   $0x803fb4
  800725:	68 8c 00 00 00       	push   $0x8c
  80072a:	68 9c 3f 80 00       	push   $0x803f9c
  80072f:	e8 10 05 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800734:	e8 bc 1a 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  800739:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80073c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800741:	74 17                	je     80075a <_main+0x722>
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	68 e4 3f 80 00       	push   $0x803fe4
  80074b:	68 8e 00 00 00       	push   $0x8e
  800750:	68 9c 3f 80 00       	push   $0x803f9c
  800755:	e8 ea 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80075a:	e8 f6 19 00 00       	call   802155 <sys_calculate_free_frames>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 01 40 80 00       	push   $0x804001
  800770:	68 8f 00 00 00       	push   $0x8f
  800775:	68 9c 3f 80 00       	push   $0x803f9c
  80077a:	e8 c5 04 00 00       	call   800c44 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80077f:	e8 d1 19 00 00       	call   802155 <sys_calculate_free_frames>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800787:	e8 69 1a 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  8007bb:	68 b4 3f 80 00       	push   $0x803fb4
  8007c0:	68 95 00 00 00       	push   $0x95
  8007c5:	68 9c 3f 80 00       	push   $0x803f9c
  8007ca:	e8 75 04 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007cf:	e8 21 1a 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  8007d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007d7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007dc:	74 17                	je     8007f5 <_main+0x7bd>
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	68 e4 3f 80 00       	push   $0x803fe4
  8007e6:	68 97 00 00 00       	push   $0x97
  8007eb:	68 9c 3f 80 00       	push   $0x803f9c
  8007f0:	e8 4f 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007f5:	e8 5b 19 00 00       	call   802155 <sys_calculate_free_frames>
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 17                	je     80081a <_main+0x7e2>
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	68 01 40 80 00       	push   $0x804001
  80080b:	68 98 00 00 00       	push   $0x98
  800810:	68 9c 3f 80 00       	push   $0x803f9c
  800815:	e8 2a 04 00 00       	call   800c44 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80081a:	e8 36 19 00 00       	call   802155 <sys_calculate_free_frames>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800822:	e8 ce 19 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  80086c:	68 b4 3f 80 00       	push   $0x803fb4
  800871:	68 9e 00 00 00       	push   $0x9e
  800876:	68 9c 3f 80 00       	push   $0x803f9c
  80087b:	e8 c4 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800880:	e8 70 19 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  800885:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800888:	83 f8 40             	cmp    $0x40,%eax
  80088b:	74 17                	je     8008a4 <_main+0x86c>
  80088d:	83 ec 04             	sub    $0x4,%esp
  800890:	68 e4 3f 80 00       	push   $0x803fe4
  800895:	68 a0 00 00 00       	push   $0xa0
  80089a:	68 9c 3f 80 00       	push   $0x803f9c
  80089f:	e8 a0 03 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008a4:	e8 ac 18 00 00       	call   802155 <sys_calculate_free_frames>
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 01 40 80 00       	push   $0x804001
  8008ba:	68 a1 00 00 00       	push   $0xa1
  8008bf:	68 9c 3f 80 00       	push   $0x803f9c
  8008c4:	e8 7b 03 00 00       	call   800c44 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 87 18 00 00       	call   802155 <sys_calculate_free_frames>
  8008ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008d1:	e8 1f 19 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  800911:	68 b4 3f 80 00       	push   $0x803fb4
  800916:	68 a7 00 00 00       	push   $0xa7
  80091b:	68 9c 3f 80 00       	push   $0x803f9c
  800920:	e8 1f 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800925:	e8 cb 18 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  80092a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80092d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 e4 3f 80 00       	push   $0x803fe4
  80093c:	68 a9 00 00 00       	push   $0xa9
  800941:	68 9c 3f 80 00       	push   $0x803f9c
  800946:	e8 f9 02 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80094b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80094e:	e8 02 18 00 00       	call   802155 <sys_calculate_free_frames>
  800953:	29 c3                	sub    %eax,%ebx
  800955:	89 d8                	mov    %ebx,%eax
  800957:	83 f8 01             	cmp    $0x1,%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 01 40 80 00       	push   $0x804001
  800964:	68 aa 00 00 00       	push   $0xaa
  800969:	68 9c 3f 80 00       	push   $0x803f9c
  80096e:	e8 d1 02 00 00       	call   800c44 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  800973:	e8 dd 17 00 00       	call   802155 <sys_calculate_free_frames>
  800978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80097b:	e8 75 18 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  800983:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800986:	83 ec 0c             	sub    $0xc,%esp
  800989:	50                   	push   %eax
  80098a:	e8 6c 15 00 00       	call   801efb <free>
  80098f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800992:	e8 5e 18 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  800997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099a:	29 c2                	sub    %eax,%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009a3:	74 17                	je     8009bc <_main+0x984>
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 14 40 80 00       	push   $0x804014
  8009ad:	68 b4 00 00 00       	push   $0xb4
  8009b2:	68 9c 3f 80 00       	push   $0x803f9c
  8009b7:	e8 88 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009bc:	e8 94 17 00 00       	call   802155 <sys_calculate_free_frames>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 17                	je     8009e1 <_main+0x9a9>
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	68 2b 40 80 00       	push   $0x80402b
  8009d2:	68 b5 00 00 00       	push   $0xb5
  8009d7:	68 9c 3f 80 00       	push   $0x803f9c
  8009dc:	e8 63 02 00 00       	call   800c44 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  8009e1:	e8 6f 17 00 00       	call   802155 <sys_calculate_free_frames>
  8009e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e9:	e8 07 18 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  8009f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8009f4:	83 ec 0c             	sub    $0xc,%esp
  8009f7:	50                   	push   %eax
  8009f8:	e8 fe 14 00 00       	call   801efb <free>
  8009fd:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800a00:	e8 f0 17 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  800a05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a08:	29 c2                	sub    %eax,%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800a11:	74 17                	je     800a2a <_main+0x9f2>
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	68 14 40 80 00       	push   $0x804014
  800a1b:	68 bc 00 00 00       	push   $0xbc
  800a20:	68 9c 3f 80 00       	push   $0x803f9c
  800a25:	e8 1a 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2a:	e8 26 17 00 00       	call   802155 <sys_calculate_free_frames>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 2b 40 80 00       	push   $0x80402b
  800a40:	68 bd 00 00 00       	push   $0xbd
  800a45:	68 9c 3f 80 00       	push   $0x803f9c
  800a4a:	e8 f5 01 00 00       	call   800c44 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a4f:	e8 01 17 00 00       	call   802155 <sys_calculate_free_frames>
  800a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a57:	e8 99 17 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
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
  800a91:	68 b4 3f 80 00       	push   $0x803fb4
  800a96:	68 c6 00 00 00       	push   $0xc6
  800a9b:	68 9c 3f 80 00       	push   $0x803f9c
  800aa0:	e8 9f 01 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800aa5:	e8 4b 17 00 00       	call   8021f5 <sys_pf_calculate_allocated_pages>
  800aaa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800aad:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 e4 3f 80 00       	push   $0x803fe4
  800abc:	68 c8 00 00 00       	push   $0xc8
  800ac1:	68 9c 3f 80 00       	push   $0x803f9c
  800ac6:	e8 79 01 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800acb:	e8 85 16 00 00       	call   802155 <sys_calculate_free_frames>
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad5:	39 c2                	cmp    %eax,%edx
  800ad7:	74 17                	je     800af0 <_main+0xab8>
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	68 01 40 80 00       	push   $0x804001
  800ae1:	68 c9 00 00 00       	push   $0xc9
  800ae6:	68 9c 3f 80 00       	push   $0x803f9c
  800aeb:	e8 54 01 00 00       	call   800c44 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800af0:	83 ec 0c             	sub    $0xc,%esp
  800af3:	68 38 40 80 00       	push   $0x804038
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
  800b0e:	e8 22 19 00 00       	call   802435 <sys_getenvindex>
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
  800b79:	e8 c4 16 00 00       	call   802242 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	68 98 40 80 00       	push   $0x804098
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
  800ba9:	68 c0 40 80 00       	push   $0x8040c0
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
  800bda:	68 e8 40 80 00       	push   $0x8040e8
  800bdf:	e8 14 03 00 00       	call   800ef8 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800be7:	a1 20 50 80 00       	mov    0x805020,%eax
  800bec:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	68 40 41 80 00       	push   $0x804140
  800bfb:	e8 f8 02 00 00       	call   800ef8 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	68 98 40 80 00       	push   $0x804098
  800c0b:	e8 e8 02 00 00       	call   800ef8 <cprintf>
  800c10:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c13:	e8 44 16 00 00       	call   80225c <sys_enable_interrupt>

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
  800c2b:	e8 d1 17 00 00       	call   802401 <sys_destroy_env>
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
  800c3c:	e8 26 18 00 00       	call   802467 <sys_exit_env>
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
  800c65:	68 54 41 80 00       	push   $0x804154
  800c6a:	e8 89 02 00 00       	call   800ef8 <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c72:	a1 00 50 80 00       	mov    0x805000,%eax
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	ff 75 08             	pushl  0x8(%ebp)
  800c7d:	50                   	push   %eax
  800c7e:	68 59 41 80 00       	push   $0x804159
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
  800ca2:	68 75 41 80 00       	push   $0x804175
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
  800cce:	68 78 41 80 00       	push   $0x804178
  800cd3:	6a 26                	push   $0x26
  800cd5:	68 c4 41 80 00       	push   $0x8041c4
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
  800da0:	68 d0 41 80 00       	push   $0x8041d0
  800da5:	6a 3a                	push   $0x3a
  800da7:	68 c4 41 80 00       	push   $0x8041c4
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
  800e10:	68 24 42 80 00       	push   $0x804224
  800e15:	6a 44                	push   $0x44
  800e17:	68 c4 41 80 00       	push   $0x8041c4
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
  800e6a:	e8 25 12 00 00       	call   802094 <sys_cputs>
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
  800ee1:	e8 ae 11 00 00       	call   802094 <sys_cputs>
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
  800f2b:	e8 12 13 00 00       	call   802242 <sys_disable_interrupt>
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
  800f4b:	e8 0c 13 00 00       	call   80225c <sys_enable_interrupt>
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
  800f95:	e8 7e 2d 00 00       	call   803d18 <__udivdi3>
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
  800fe5:	e8 3e 2e 00 00       	call   803e28 <__umoddi3>
  800fea:	83 c4 10             	add    $0x10,%esp
  800fed:	05 94 44 80 00       	add    $0x804494,%eax
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
  801140:	8b 04 85 b8 44 80 00 	mov    0x8044b8(,%eax,4),%eax
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
  801221:	8b 34 9d 00 43 80 00 	mov    0x804300(,%ebx,4),%esi
  801228:	85 f6                	test   %esi,%esi
  80122a:	75 19                	jne    801245 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80122c:	53                   	push   %ebx
  80122d:	68 a5 44 80 00       	push   $0x8044a5
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
  801246:	68 ae 44 80 00       	push   $0x8044ae
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
  801273:	be b1 44 80 00       	mov    $0x8044b1,%esi
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
  801c99:	68 10 46 80 00       	push   $0x804610
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
  801d69:	e8 6a 04 00 00       	call   8021d8 <sys_allocate_chunk>
  801d6e:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801d71:	a1 20 51 80 00       	mov    0x805120,%eax
  801d76:	83 ec 0c             	sub    $0xc,%esp
  801d79:	50                   	push   %eax
  801d7a:	e8 df 0a 00 00       	call   80285e <initialize_MemBlocksList>
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
  801da7:	68 35 46 80 00       	push   $0x804635
  801dac:	6a 33                	push   $0x33
  801dae:	68 53 46 80 00       	push   $0x804653
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
  801e26:	68 60 46 80 00       	push   $0x804660
  801e2b:	6a 34                	push   $0x34
  801e2d:	68 53 46 80 00       	push   $0x804653
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
  801e83:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e86:	e8 f7 fd ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e8f:	75 07                	jne    801e98 <malloc+0x18>
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	eb 61                	jmp    801ef9 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801e98:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  801ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea5:	01 d0                	add    %edx,%eax
  801ea7:	48                   	dec    %eax
  801ea8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eae:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb3:	f7 75 f0             	divl   -0x10(%ebp)
  801eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb9:	29 d0                	sub    %edx,%eax
  801ebb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ebe:	e8 e3 06 00 00       	call   8025a6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	74 11                	je     801ed8 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801ec7:	83 ec 0c             	sub    $0xc,%esp
  801eca:	ff 75 e8             	pushl  -0x18(%ebp)
  801ecd:	e8 4e 0d 00 00       	call   802c20 <alloc_block_FF>
  801ed2:	83 c4 10             	add    $0x10,%esp
  801ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801edc:	74 16                	je     801ef4 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801ede:	83 ec 0c             	sub    $0xc,%esp
  801ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee4:	e8 aa 0a 00 00       	call   802993 <insert_sorted_allocList>
  801ee9:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eef:	8b 40 08             	mov    0x8(%eax),%eax
  801ef2:	eb 05                	jmp    801ef9 <malloc+0x79>
	}

    return NULL;
  801ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801f01:	83 ec 04             	sub    $0x4,%esp
  801f04:	68 84 46 80 00       	push   $0x804684
  801f09:	6a 6f                	push   $0x6f
  801f0b:	68 53 46 80 00       	push   $0x804653
  801f10:	e8 2f ed ff ff       	call   800c44 <_panic>

00801f15 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 38             	sub    $0x38,%esp
  801f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f21:	e8 5c fd ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f2a:	75 07                	jne    801f33 <smalloc+0x1e>
  801f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f31:	eb 7c                	jmp    801faf <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f33:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f40:	01 d0                	add    %edx,%eax
  801f42:	48                   	dec    %eax
  801f43:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f49:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4e:	f7 75 f0             	divl   -0x10(%ebp)
  801f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f54:	29 d0                	sub    %edx,%eax
  801f56:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801f59:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f60:	e8 41 06 00 00       	call   8025a6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f65:	85 c0                	test   %eax,%eax
  801f67:	74 11                	je     801f7a <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801f69:	83 ec 0c             	sub    $0xc,%esp
  801f6c:	ff 75 e8             	pushl  -0x18(%ebp)
  801f6f:	e8 ac 0c 00 00       	call   802c20 <alloc_block_FF>
  801f74:	83 c4 10             	add    $0x10,%esp
  801f77:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801f7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7e:	74 2a                	je     801faa <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f83:	8b 40 08             	mov    0x8(%eax),%eax
  801f86:	89 c2                	mov    %eax,%edx
  801f88:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f8c:	52                   	push   %edx
  801f8d:	50                   	push   %eax
  801f8e:	ff 75 0c             	pushl  0xc(%ebp)
  801f91:	ff 75 08             	pushl  0x8(%ebp)
  801f94:	e8 92 03 00 00       	call   80232b <sys_createSharedObject>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801f9f:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801fa3:	74 05                	je     801faa <smalloc+0x95>
			return (void*)virtual_address;
  801fa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fa8:	eb 05                	jmp    801faf <smalloc+0x9a>
	}
	return NULL;
  801faa:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fb7:	e8 c6 fc ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801fbc:	83 ec 04             	sub    $0x4,%esp
  801fbf:	68 a8 46 80 00       	push   $0x8046a8
  801fc4:	68 b0 00 00 00       	push   $0xb0
  801fc9:	68 53 46 80 00       	push   $0x804653
  801fce:	e8 71 ec ff ff       	call   800c44 <_panic>

00801fd3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fd9:	e8 a4 fc ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fde:	83 ec 04             	sub    $0x4,%esp
  801fe1:	68 cc 46 80 00       	push   $0x8046cc
  801fe6:	68 f4 00 00 00       	push   $0xf4
  801feb:	68 53 46 80 00       	push   $0x804653
  801ff0:	e8 4f ec ff ff       	call   800c44 <_panic>

00801ff5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ffb:	83 ec 04             	sub    $0x4,%esp
  801ffe:	68 f4 46 80 00       	push   $0x8046f4
  802003:	68 08 01 00 00       	push   $0x108
  802008:	68 53 46 80 00       	push   $0x804653
  80200d:	e8 32 ec ff ff       	call   800c44 <_panic>

00802012 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802018:	83 ec 04             	sub    $0x4,%esp
  80201b:	68 18 47 80 00       	push   $0x804718
  802020:	68 13 01 00 00       	push   $0x113
  802025:	68 53 46 80 00       	push   $0x804653
  80202a:	e8 15 ec ff ff       	call   800c44 <_panic>

0080202f <shrink>:

}
void shrink(uint32 newSize)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802035:	83 ec 04             	sub    $0x4,%esp
  802038:	68 18 47 80 00       	push   $0x804718
  80203d:	68 18 01 00 00       	push   $0x118
  802042:	68 53 46 80 00       	push   $0x804653
  802047:	e8 f8 eb ff ff       	call   800c44 <_panic>

0080204c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802052:	83 ec 04             	sub    $0x4,%esp
  802055:	68 18 47 80 00       	push   $0x804718
  80205a:	68 1d 01 00 00       	push   $0x11d
  80205f:	68 53 46 80 00       	push   $0x804653
  802064:	e8 db eb ff ff       	call   800c44 <_panic>

00802069 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	57                   	push   %edi
  80206d:	56                   	push   %esi
  80206e:	53                   	push   %ebx
  80206f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	8b 55 0c             	mov    0xc(%ebp),%edx
  802078:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80207b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80207e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802081:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802084:	cd 30                	int    $0x30
  802086:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802089:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80208c:	83 c4 10             	add    $0x10,%esp
  80208f:	5b                   	pop    %ebx
  802090:	5e                   	pop    %esi
  802091:	5f                   	pop    %edi
  802092:	5d                   	pop    %ebp
  802093:	c3                   	ret    

00802094 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 04             	sub    $0x4,%esp
  80209a:	8b 45 10             	mov    0x10(%ebp),%eax
  80209d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020a0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	52                   	push   %edx
  8020ac:	ff 75 0c             	pushl  0xc(%ebp)
  8020af:	50                   	push   %eax
  8020b0:	6a 00                	push   $0x0
  8020b2:	e8 b2 ff ff ff       	call   802069 <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
}
  8020ba:	90                   	nop
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 01                	push   $0x1
  8020cc:	e8 98 ff ff ff       	call   802069 <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	52                   	push   %edx
  8020e6:	50                   	push   %eax
  8020e7:	6a 05                	push   $0x5
  8020e9:	e8 7b ff ff ff       	call   802069 <syscall>
  8020ee:	83 c4 18             	add    $0x18,%esp
}
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	56                   	push   %esi
  8020f7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020f8:	8b 75 18             	mov    0x18(%ebp),%esi
  8020fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802101:	8b 55 0c             	mov    0xc(%ebp),%edx
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	56                   	push   %esi
  802108:	53                   	push   %ebx
  802109:	51                   	push   %ecx
  80210a:	52                   	push   %edx
  80210b:	50                   	push   %eax
  80210c:	6a 06                	push   $0x6
  80210e:	e8 56 ff ff ff       	call   802069 <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
}
  802116:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802119:	5b                   	pop    %ebx
  80211a:	5e                   	pop    %esi
  80211b:	5d                   	pop    %ebp
  80211c:	c3                   	ret    

0080211d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802120:	8b 55 0c             	mov    0xc(%ebp),%edx
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	52                   	push   %edx
  80212d:	50                   	push   %eax
  80212e:	6a 07                	push   $0x7
  802130:	e8 34 ff ff ff       	call   802069 <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	ff 75 0c             	pushl  0xc(%ebp)
  802146:	ff 75 08             	pushl  0x8(%ebp)
  802149:	6a 08                	push   $0x8
  80214b:	e8 19 ff ff ff       	call   802069 <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 09                	push   $0x9
  802164:	e8 00 ff ff ff       	call   802069 <syscall>
  802169:	83 c4 18             	add    $0x18,%esp
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 0a                	push   $0xa
  80217d:	e8 e7 fe ff ff       	call   802069 <syscall>
  802182:	83 c4 18             	add    $0x18,%esp
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 0b                	push   $0xb
  802196:	e8 ce fe ff ff       	call   802069 <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ac:	ff 75 08             	pushl  0x8(%ebp)
  8021af:	6a 0f                	push   $0xf
  8021b1:	e8 b3 fe ff ff       	call   802069 <syscall>
  8021b6:	83 c4 18             	add    $0x18,%esp
	return;
  8021b9:	90                   	nop
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	ff 75 0c             	pushl  0xc(%ebp)
  8021c8:	ff 75 08             	pushl  0x8(%ebp)
  8021cb:	6a 10                	push   $0x10
  8021cd:	e8 97 fe ff ff       	call   802069 <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d5:	90                   	nop
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	ff 75 10             	pushl  0x10(%ebp)
  8021e2:	ff 75 0c             	pushl  0xc(%ebp)
  8021e5:	ff 75 08             	pushl  0x8(%ebp)
  8021e8:	6a 11                	push   $0x11
  8021ea:	e8 7a fe ff ff       	call   802069 <syscall>
  8021ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f2:	90                   	nop
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 0c                	push   $0xc
  802204:	e8 60 fe ff ff       	call   802069 <syscall>
  802209:	83 c4 18             	add    $0x18,%esp
}
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	ff 75 08             	pushl  0x8(%ebp)
  80221c:	6a 0d                	push   $0xd
  80221e:	e8 46 fe ff ff       	call   802069 <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 0e                	push   $0xe
  802237:	e8 2d fe ff ff       	call   802069 <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
}
  80223f:	90                   	nop
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 13                	push   $0x13
  802251:	e8 13 fe ff ff       	call   802069 <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
}
  802259:	90                   	nop
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 14                	push   $0x14
  80226b:	e8 f9 fd ff ff       	call   802069 <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	90                   	nop
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <sys_cputc>:


void
sys_cputc(const char c)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	83 ec 04             	sub    $0x4,%esp
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802282:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	50                   	push   %eax
  80228f:	6a 15                	push   $0x15
  802291:	e8 d3 fd ff ff       	call   802069 <syscall>
  802296:	83 c4 18             	add    $0x18,%esp
}
  802299:	90                   	nop
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 16                	push   $0x16
  8022ab:	e8 b9 fd ff ff       	call   802069 <syscall>
  8022b0:	83 c4 18             	add    $0x18,%esp
}
  8022b3:	90                   	nop
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	ff 75 0c             	pushl  0xc(%ebp)
  8022c5:	50                   	push   %eax
  8022c6:	6a 17                	push   $0x17
  8022c8:	e8 9c fd ff ff       	call   802069 <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	52                   	push   %edx
  8022e2:	50                   	push   %eax
  8022e3:	6a 1a                	push   $0x1a
  8022e5:	e8 7f fd ff ff       	call   802069 <syscall>
  8022ea:	83 c4 18             	add    $0x18,%esp
}
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	52                   	push   %edx
  8022ff:	50                   	push   %eax
  802300:	6a 18                	push   $0x18
  802302:	e8 62 fd ff ff       	call   802069 <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
}
  80230a:	90                   	nop
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802310:	8b 55 0c             	mov    0xc(%ebp),%edx
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	52                   	push   %edx
  80231d:	50                   	push   %eax
  80231e:	6a 19                	push   $0x19
  802320:	e8 44 fd ff ff       	call   802069 <syscall>
  802325:	83 c4 18             	add    $0x18,%esp
}
  802328:	90                   	nop
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 04             	sub    $0x4,%esp
  802331:	8b 45 10             	mov    0x10(%ebp),%eax
  802334:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802337:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80233a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	6a 00                	push   $0x0
  802343:	51                   	push   %ecx
  802344:	52                   	push   %edx
  802345:	ff 75 0c             	pushl  0xc(%ebp)
  802348:	50                   	push   %eax
  802349:	6a 1b                	push   $0x1b
  80234b:	e8 19 fd ff ff       	call   802069 <syscall>
  802350:	83 c4 18             	add    $0x18,%esp
}
  802353:	c9                   	leave  
  802354:	c3                   	ret    

00802355 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802358:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	52                   	push   %edx
  802365:	50                   	push   %eax
  802366:	6a 1c                	push   $0x1c
  802368:	e8 fc fc ff ff       	call   802069 <syscall>
  80236d:	83 c4 18             	add    $0x18,%esp
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802375:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802378:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	51                   	push   %ecx
  802383:	52                   	push   %edx
  802384:	50                   	push   %eax
  802385:	6a 1d                	push   $0x1d
  802387:	e8 dd fc ff ff       	call   802069 <syscall>
  80238c:	83 c4 18             	add    $0x18,%esp
}
  80238f:	c9                   	leave  
  802390:	c3                   	ret    

00802391 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802394:	8b 55 0c             	mov    0xc(%ebp),%edx
  802397:	8b 45 08             	mov    0x8(%ebp),%eax
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	52                   	push   %edx
  8023a1:	50                   	push   %eax
  8023a2:	6a 1e                	push   $0x1e
  8023a4:	e8 c0 fc ff ff       	call   802069 <syscall>
  8023a9:	83 c4 18             	add    $0x18,%esp
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 1f                	push   $0x1f
  8023bd:	e8 a7 fc ff ff       	call   802069 <syscall>
  8023c2:	83 c4 18             	add    $0x18,%esp
}
  8023c5:	c9                   	leave  
  8023c6:	c3                   	ret    

008023c7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	6a 00                	push   $0x0
  8023cf:	ff 75 14             	pushl  0x14(%ebp)
  8023d2:	ff 75 10             	pushl  0x10(%ebp)
  8023d5:	ff 75 0c             	pushl  0xc(%ebp)
  8023d8:	50                   	push   %eax
  8023d9:	6a 20                	push   $0x20
  8023db:	e8 89 fc ff ff       	call   802069 <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	50                   	push   %eax
  8023f4:	6a 21                	push   $0x21
  8023f6:	e8 6e fc ff ff       	call   802069 <syscall>
  8023fb:	83 c4 18             	add    $0x18,%esp
}
  8023fe:	90                   	nop
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	50                   	push   %eax
  802410:	6a 22                	push   $0x22
  802412:	e8 52 fc ff ff       	call   802069 <syscall>
  802417:	83 c4 18             	add    $0x18,%esp
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 02                	push   $0x2
  80242b:	e8 39 fc ff ff       	call   802069 <syscall>
  802430:	83 c4 18             	add    $0x18,%esp
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 03                	push   $0x3
  802444:	e8 20 fc ff ff       	call   802069 <syscall>
  802449:	83 c4 18             	add    $0x18,%esp
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 04                	push   $0x4
  80245d:	e8 07 fc ff ff       	call   802069 <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <sys_exit_env>:


void sys_exit_env(void)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 23                	push   $0x23
  802476:	e8 ee fb ff ff       	call   802069 <syscall>
  80247b:	83 c4 18             	add    $0x18,%esp
}
  80247e:	90                   	nop
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802487:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80248a:	8d 50 04             	lea    0x4(%eax),%edx
  80248d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	52                   	push   %edx
  802497:	50                   	push   %eax
  802498:	6a 24                	push   $0x24
  80249a:	e8 ca fb ff ff       	call   802069 <syscall>
  80249f:	83 c4 18             	add    $0x18,%esp
	return result;
  8024a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ab:	89 01                	mov    %eax,(%ecx)
  8024ad:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b3:	c9                   	leave  
  8024b4:	c2 04 00             	ret    $0x4

008024b7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	ff 75 10             	pushl  0x10(%ebp)
  8024c1:	ff 75 0c             	pushl  0xc(%ebp)
  8024c4:	ff 75 08             	pushl  0x8(%ebp)
  8024c7:	6a 12                	push   $0x12
  8024c9:	e8 9b fb ff ff       	call   802069 <syscall>
  8024ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d1:	90                   	nop
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 25                	push   $0x25
  8024e3:	e8 81 fb ff ff       	call   802069 <syscall>
  8024e8:	83 c4 18             	add    $0x18,%esp
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	83 ec 04             	sub    $0x4,%esp
  8024f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024f9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	50                   	push   %eax
  802506:	6a 26                	push   $0x26
  802508:	e8 5c fb ff ff       	call   802069 <syscall>
  80250d:	83 c4 18             	add    $0x18,%esp
	return ;
  802510:	90                   	nop
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <rsttst>:
void rsttst()
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 28                	push   $0x28
  802522:	e8 42 fb ff ff       	call   802069 <syscall>
  802527:	83 c4 18             	add    $0x18,%esp
	return ;
  80252a:	90                   	nop
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
  802530:	83 ec 04             	sub    $0x4,%esp
  802533:	8b 45 14             	mov    0x14(%ebp),%eax
  802536:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802539:	8b 55 18             	mov    0x18(%ebp),%edx
  80253c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802540:	52                   	push   %edx
  802541:	50                   	push   %eax
  802542:	ff 75 10             	pushl  0x10(%ebp)
  802545:	ff 75 0c             	pushl  0xc(%ebp)
  802548:	ff 75 08             	pushl  0x8(%ebp)
  80254b:	6a 27                	push   $0x27
  80254d:	e8 17 fb ff ff       	call   802069 <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
	return ;
  802555:	90                   	nop
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <chktst>:
void chktst(uint32 n)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	ff 75 08             	pushl  0x8(%ebp)
  802566:	6a 29                	push   $0x29
  802568:	e8 fc fa ff ff       	call   802069 <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
	return ;
  802570:	90                   	nop
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <inctst>:

void inctst()
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 2a                	push   $0x2a
  802582:	e8 e2 fa ff ff       	call   802069 <syscall>
  802587:	83 c4 18             	add    $0x18,%esp
	return ;
  80258a:	90                   	nop
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <gettst>:
uint32 gettst()
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 2b                	push   $0x2b
  80259c:	e8 c8 fa ff ff       	call   802069 <syscall>
  8025a1:	83 c4 18             	add    $0x18,%esp
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 2c                	push   $0x2c
  8025b8:	e8 ac fa ff ff       	call   802069 <syscall>
  8025bd:	83 c4 18             	add    $0x18,%esp
  8025c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025c3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025c7:	75 07                	jne    8025d0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ce:	eb 05                	jmp    8025d5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
  8025da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 2c                	push   $0x2c
  8025e9:	e8 7b fa ff ff       	call   802069 <syscall>
  8025ee:	83 c4 18             	add    $0x18,%esp
  8025f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025f4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025f8:	75 07                	jne    802601 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ff:	eb 05                	jmp    802606 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802601:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
  80260b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 2c                	push   $0x2c
  80261a:	e8 4a fa ff ff       	call   802069 <syscall>
  80261f:	83 c4 18             	add    $0x18,%esp
  802622:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802625:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802629:	75 07                	jne    802632 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80262b:	b8 01 00 00 00       	mov    $0x1,%eax
  802630:	eb 05                	jmp    802637 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802632:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802637:	c9                   	leave  
  802638:	c3                   	ret    

00802639 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
  80263c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 2c                	push   $0x2c
  80264b:	e8 19 fa ff ff       	call   802069 <syscall>
  802650:	83 c4 18             	add    $0x18,%esp
  802653:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802656:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80265a:	75 07                	jne    802663 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80265c:	b8 01 00 00 00       	mov    $0x1,%eax
  802661:	eb 05                	jmp    802668 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802663:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802668:	c9                   	leave  
  802669:	c3                   	ret    

0080266a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80266d:	6a 00                	push   $0x0
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	ff 75 08             	pushl  0x8(%ebp)
  802678:	6a 2d                	push   $0x2d
  80267a:	e8 ea f9 ff ff       	call   802069 <syscall>
  80267f:	83 c4 18             	add    $0x18,%esp
	return ;
  802682:	90                   	nop
}
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
  802688:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802689:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80268c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80268f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	6a 00                	push   $0x0
  802697:	53                   	push   %ebx
  802698:	51                   	push   %ecx
  802699:	52                   	push   %edx
  80269a:	50                   	push   %eax
  80269b:	6a 2e                	push   $0x2e
  80269d:	e8 c7 f9 ff ff       	call   802069 <syscall>
  8026a2:	83 c4 18             	add    $0x18,%esp
}
  8026a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    

008026aa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	52                   	push   %edx
  8026ba:	50                   	push   %eax
  8026bb:	6a 2f                	push   $0x2f
  8026bd:	e8 a7 f9 ff ff       	call   802069 <syscall>
  8026c2:	83 c4 18             	add    $0x18,%esp
}
  8026c5:	c9                   	leave  
  8026c6:	c3                   	ret    

008026c7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
  8026ca:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026cd:	83 ec 0c             	sub    $0xc,%esp
  8026d0:	68 28 47 80 00       	push   $0x804728
  8026d5:	e8 1e e8 ff ff       	call   800ef8 <cprintf>
  8026da:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026e4:	83 ec 0c             	sub    $0xc,%esp
  8026e7:	68 54 47 80 00       	push   $0x804754
  8026ec:	e8 07 e8 ff ff       	call   800ef8 <cprintf>
  8026f1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026f4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026f8:	a1 38 51 80 00       	mov    0x805138,%eax
  8026fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802700:	eb 56                	jmp    802758 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802702:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802706:	74 1c                	je     802724 <print_mem_block_lists+0x5d>
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	8b 50 08             	mov    0x8(%eax),%edx
  80270e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802711:	8b 48 08             	mov    0x8(%eax),%ecx
  802714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802717:	8b 40 0c             	mov    0xc(%eax),%eax
  80271a:	01 c8                	add    %ecx,%eax
  80271c:	39 c2                	cmp    %eax,%edx
  80271e:	73 04                	jae    802724 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802720:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 50 08             	mov    0x8(%eax),%edx
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 40 0c             	mov    0xc(%eax),%eax
  802730:	01 c2                	add    %eax,%edx
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 40 08             	mov    0x8(%eax),%eax
  802738:	83 ec 04             	sub    $0x4,%esp
  80273b:	52                   	push   %edx
  80273c:	50                   	push   %eax
  80273d:	68 69 47 80 00       	push   $0x804769
  802742:	e8 b1 e7 ff ff       	call   800ef8 <cprintf>
  802747:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802750:	a1 40 51 80 00       	mov    0x805140,%eax
  802755:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275c:	74 07                	je     802765 <print_mem_block_lists+0x9e>
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 00                	mov    (%eax),%eax
  802763:	eb 05                	jmp    80276a <print_mem_block_lists+0xa3>
  802765:	b8 00 00 00 00       	mov    $0x0,%eax
  80276a:	a3 40 51 80 00       	mov    %eax,0x805140
  80276f:	a1 40 51 80 00       	mov    0x805140,%eax
  802774:	85 c0                	test   %eax,%eax
  802776:	75 8a                	jne    802702 <print_mem_block_lists+0x3b>
  802778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277c:	75 84                	jne    802702 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80277e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802782:	75 10                	jne    802794 <print_mem_block_lists+0xcd>
  802784:	83 ec 0c             	sub    $0xc,%esp
  802787:	68 78 47 80 00       	push   $0x804778
  80278c:	e8 67 e7 ff ff       	call   800ef8 <cprintf>
  802791:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802794:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80279b:	83 ec 0c             	sub    $0xc,%esp
  80279e:	68 9c 47 80 00       	push   $0x80479c
  8027a3:	e8 50 e7 ff ff       	call   800ef8 <cprintf>
  8027a8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027ab:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027af:	a1 40 50 80 00       	mov    0x805040,%eax
  8027b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b7:	eb 56                	jmp    80280f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027bd:	74 1c                	je     8027db <print_mem_block_lists+0x114>
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 50 08             	mov    0x8(%eax),%edx
  8027c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c8:	8b 48 08             	mov    0x8(%eax),%ecx
  8027cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d1:	01 c8                	add    %ecx,%eax
  8027d3:	39 c2                	cmp    %eax,%edx
  8027d5:	73 04                	jae    8027db <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027d7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 50 08             	mov    0x8(%eax),%edx
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e7:	01 c2                	add    %eax,%edx
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 08             	mov    0x8(%eax),%eax
  8027ef:	83 ec 04             	sub    $0x4,%esp
  8027f2:	52                   	push   %edx
  8027f3:	50                   	push   %eax
  8027f4:	68 69 47 80 00       	push   $0x804769
  8027f9:	e8 fa e6 ff ff       	call   800ef8 <cprintf>
  8027fe:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802807:	a1 48 50 80 00       	mov    0x805048,%eax
  80280c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802813:	74 07                	je     80281c <print_mem_block_lists+0x155>
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	eb 05                	jmp    802821 <print_mem_block_lists+0x15a>
  80281c:	b8 00 00 00 00       	mov    $0x0,%eax
  802821:	a3 48 50 80 00       	mov    %eax,0x805048
  802826:	a1 48 50 80 00       	mov    0x805048,%eax
  80282b:	85 c0                	test   %eax,%eax
  80282d:	75 8a                	jne    8027b9 <print_mem_block_lists+0xf2>
  80282f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802833:	75 84                	jne    8027b9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802835:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802839:	75 10                	jne    80284b <print_mem_block_lists+0x184>
  80283b:	83 ec 0c             	sub    $0xc,%esp
  80283e:	68 b4 47 80 00       	push   $0x8047b4
  802843:	e8 b0 e6 ff ff       	call   800ef8 <cprintf>
  802848:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80284b:	83 ec 0c             	sub    $0xc,%esp
  80284e:	68 28 47 80 00       	push   $0x804728
  802853:	e8 a0 e6 ff ff       	call   800ef8 <cprintf>
  802858:	83 c4 10             	add    $0x10,%esp

}
  80285b:	90                   	nop
  80285c:	c9                   	leave  
  80285d:	c3                   	ret    

0080285e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
  802861:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802864:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80286b:	00 00 00 
  80286e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802875:	00 00 00 
  802878:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80287f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802882:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802889:	e9 9e 00 00 00       	jmp    80292c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80288e:	a1 50 50 80 00       	mov    0x805050,%eax
  802893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802896:	c1 e2 04             	shl    $0x4,%edx
  802899:	01 d0                	add    %edx,%eax
  80289b:	85 c0                	test   %eax,%eax
  80289d:	75 14                	jne    8028b3 <initialize_MemBlocksList+0x55>
  80289f:	83 ec 04             	sub    $0x4,%esp
  8028a2:	68 dc 47 80 00       	push   $0x8047dc
  8028a7:	6a 46                	push   $0x46
  8028a9:	68 ff 47 80 00       	push   $0x8047ff
  8028ae:	e8 91 e3 ff ff       	call   800c44 <_panic>
  8028b3:	a1 50 50 80 00       	mov    0x805050,%eax
  8028b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bb:	c1 e2 04             	shl    $0x4,%edx
  8028be:	01 d0                	add    %edx,%eax
  8028c0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028c6:	89 10                	mov    %edx,(%eax)
  8028c8:	8b 00                	mov    (%eax),%eax
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	74 18                	je     8028e6 <initialize_MemBlocksList+0x88>
  8028ce:	a1 48 51 80 00       	mov    0x805148,%eax
  8028d3:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028d9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028dc:	c1 e1 04             	shl    $0x4,%ecx
  8028df:	01 ca                	add    %ecx,%edx
  8028e1:	89 50 04             	mov    %edx,0x4(%eax)
  8028e4:	eb 12                	jmp    8028f8 <initialize_MemBlocksList+0x9a>
  8028e6:	a1 50 50 80 00       	mov    0x805050,%eax
  8028eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ee:	c1 e2 04             	shl    $0x4,%edx
  8028f1:	01 d0                	add    %edx,%eax
  8028f3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028f8:	a1 50 50 80 00       	mov    0x805050,%eax
  8028fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802900:	c1 e2 04             	shl    $0x4,%edx
  802903:	01 d0                	add    %edx,%eax
  802905:	a3 48 51 80 00       	mov    %eax,0x805148
  80290a:	a1 50 50 80 00       	mov    0x805050,%eax
  80290f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802912:	c1 e2 04             	shl    $0x4,%edx
  802915:	01 d0                	add    %edx,%eax
  802917:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291e:	a1 54 51 80 00       	mov    0x805154,%eax
  802923:	40                   	inc    %eax
  802924:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802929:	ff 45 f4             	incl   -0xc(%ebp)
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802932:	0f 82 56 ff ff ff    	jb     80288e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802938:	90                   	nop
  802939:	c9                   	leave  
  80293a:	c3                   	ret    

0080293b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80293b:	55                   	push   %ebp
  80293c:	89 e5                	mov    %esp,%ebp
  80293e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802941:	8b 45 08             	mov    0x8(%ebp),%eax
  802944:	8b 00                	mov    (%eax),%eax
  802946:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802949:	eb 19                	jmp    802964 <find_block+0x29>
	{
		if(va==point->sva)
  80294b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80294e:	8b 40 08             	mov    0x8(%eax),%eax
  802951:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802954:	75 05                	jne    80295b <find_block+0x20>
		   return point;
  802956:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802959:	eb 36                	jmp    802991 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	8b 40 08             	mov    0x8(%eax),%eax
  802961:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802964:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802968:	74 07                	je     802971 <find_block+0x36>
  80296a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80296d:	8b 00                	mov    (%eax),%eax
  80296f:	eb 05                	jmp    802976 <find_block+0x3b>
  802971:	b8 00 00 00 00       	mov    $0x0,%eax
  802976:	8b 55 08             	mov    0x8(%ebp),%edx
  802979:	89 42 08             	mov    %eax,0x8(%edx)
  80297c:	8b 45 08             	mov    0x8(%ebp),%eax
  80297f:	8b 40 08             	mov    0x8(%eax),%eax
  802982:	85 c0                	test   %eax,%eax
  802984:	75 c5                	jne    80294b <find_block+0x10>
  802986:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80298a:	75 bf                	jne    80294b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80298c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802991:	c9                   	leave  
  802992:	c3                   	ret    

00802993 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802993:	55                   	push   %ebp
  802994:	89 e5                	mov    %esp,%ebp
  802996:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802999:	a1 40 50 80 00       	mov    0x805040,%eax
  80299e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8029a1:	a1 44 50 80 00       	mov    0x805044,%eax
  8029a6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029af:	74 24                	je     8029d5 <insert_sorted_allocList+0x42>
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	8b 50 08             	mov    0x8(%eax),%edx
  8029b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ba:	8b 40 08             	mov    0x8(%eax),%eax
  8029bd:	39 c2                	cmp    %eax,%edx
  8029bf:	76 14                	jbe    8029d5 <insert_sorted_allocList+0x42>
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	8b 50 08             	mov    0x8(%eax),%edx
  8029c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ca:	8b 40 08             	mov    0x8(%eax),%eax
  8029cd:	39 c2                	cmp    %eax,%edx
  8029cf:	0f 82 60 01 00 00    	jb     802b35 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8029d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029d9:	75 65                	jne    802a40 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8029db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029df:	75 14                	jne    8029f5 <insert_sorted_allocList+0x62>
  8029e1:	83 ec 04             	sub    $0x4,%esp
  8029e4:	68 dc 47 80 00       	push   $0x8047dc
  8029e9:	6a 6b                	push   $0x6b
  8029eb:	68 ff 47 80 00       	push   $0x8047ff
  8029f0:	e8 4f e2 ff ff       	call   800c44 <_panic>
  8029f5:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	89 10                	mov    %edx,(%eax)
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 0d                	je     802a16 <insert_sorted_allocList+0x83>
  802a09:	a1 40 50 80 00       	mov    0x805040,%eax
  802a0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a11:	89 50 04             	mov    %edx,0x4(%eax)
  802a14:	eb 08                	jmp    802a1e <insert_sorted_allocList+0x8b>
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	a3 44 50 80 00       	mov    %eax,0x805044
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	a3 40 50 80 00       	mov    %eax,0x805040
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a30:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a35:	40                   	inc    %eax
  802a36:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a3b:	e9 dc 01 00 00       	jmp    802c1c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	8b 50 08             	mov    0x8(%eax),%edx
  802a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a49:	8b 40 08             	mov    0x8(%eax),%eax
  802a4c:	39 c2                	cmp    %eax,%edx
  802a4e:	77 6c                	ja     802abc <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a54:	74 06                	je     802a5c <insert_sorted_allocList+0xc9>
  802a56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a5a:	75 14                	jne    802a70 <insert_sorted_allocList+0xdd>
  802a5c:	83 ec 04             	sub    $0x4,%esp
  802a5f:	68 18 48 80 00       	push   $0x804818
  802a64:	6a 6f                	push   $0x6f
  802a66:	68 ff 47 80 00       	push   $0x8047ff
  802a6b:	e8 d4 e1 ff ff       	call   800c44 <_panic>
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	8b 50 04             	mov    0x4(%eax),%edx
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	89 50 04             	mov    %edx,0x4(%eax)
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a82:	89 10                	mov    %edx,(%eax)
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 40 04             	mov    0x4(%eax),%eax
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	74 0d                	je     802a9b <insert_sorted_allocList+0x108>
  802a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a91:	8b 40 04             	mov    0x4(%eax),%eax
  802a94:	8b 55 08             	mov    0x8(%ebp),%edx
  802a97:	89 10                	mov    %edx,(%eax)
  802a99:	eb 08                	jmp    802aa3 <insert_sorted_allocList+0x110>
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	a3 40 50 80 00       	mov    %eax,0x805040
  802aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa6:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa9:	89 50 04             	mov    %edx,0x4(%eax)
  802aac:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ab1:	40                   	inc    %eax
  802ab2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ab7:	e9 60 01 00 00       	jmp    802c1c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	8b 50 08             	mov    0x8(%eax),%edx
  802ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac5:	8b 40 08             	mov    0x8(%eax),%eax
  802ac8:	39 c2                	cmp    %eax,%edx
  802aca:	0f 82 4c 01 00 00    	jb     802c1c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802ad0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad4:	75 14                	jne    802aea <insert_sorted_allocList+0x157>
  802ad6:	83 ec 04             	sub    $0x4,%esp
  802ad9:	68 50 48 80 00       	push   $0x804850
  802ade:	6a 73                	push   $0x73
  802ae0:	68 ff 47 80 00       	push   $0x8047ff
  802ae5:	e8 5a e1 ff ff       	call   800c44 <_panic>
  802aea:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802af0:	8b 45 08             	mov    0x8(%ebp),%eax
  802af3:	89 50 04             	mov    %edx,0x4(%eax)
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	8b 40 04             	mov    0x4(%eax),%eax
  802afc:	85 c0                	test   %eax,%eax
  802afe:	74 0c                	je     802b0c <insert_sorted_allocList+0x179>
  802b00:	a1 44 50 80 00       	mov    0x805044,%eax
  802b05:	8b 55 08             	mov    0x8(%ebp),%edx
  802b08:	89 10                	mov    %edx,(%eax)
  802b0a:	eb 08                	jmp    802b14 <insert_sorted_allocList+0x181>
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	a3 40 50 80 00       	mov    %eax,0x805040
  802b14:	8b 45 08             	mov    0x8(%ebp),%eax
  802b17:	a3 44 50 80 00       	mov    %eax,0x805044
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b25:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b2a:	40                   	inc    %eax
  802b2b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b30:	e9 e7 00 00 00       	jmp    802c1c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802b3b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b42:	a1 40 50 80 00       	mov    0x805040,%eax
  802b47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b4a:	e9 9d 00 00 00       	jmp    802bec <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	8b 00                	mov    (%eax),%eax
  802b54:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	8b 50 08             	mov    0x8(%eax),%edx
  802b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b60:	8b 40 08             	mov    0x8(%eax),%eax
  802b63:	39 c2                	cmp    %eax,%edx
  802b65:	76 7d                	jbe    802be4 <insert_sorted_allocList+0x251>
  802b67:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6a:	8b 50 08             	mov    0x8(%eax),%edx
  802b6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b70:	8b 40 08             	mov    0x8(%eax),%eax
  802b73:	39 c2                	cmp    %eax,%edx
  802b75:	73 6d                	jae    802be4 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802b77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7b:	74 06                	je     802b83 <insert_sorted_allocList+0x1f0>
  802b7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b81:	75 14                	jne    802b97 <insert_sorted_allocList+0x204>
  802b83:	83 ec 04             	sub    $0x4,%esp
  802b86:	68 74 48 80 00       	push   $0x804874
  802b8b:	6a 7f                	push   $0x7f
  802b8d:	68 ff 47 80 00       	push   $0x8047ff
  802b92:	e8 ad e0 ff ff       	call   800c44 <_panic>
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 10                	mov    (%eax),%edx
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	89 10                	mov    %edx,(%eax)
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	8b 00                	mov    (%eax),%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	74 0b                	je     802bb5 <insert_sorted_allocList+0x222>
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 00                	mov    (%eax),%eax
  802baf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb2:	89 50 04             	mov    %edx,0x4(%eax)
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbb:	89 10                	mov    %edx,(%eax)
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc3:	89 50 04             	mov    %edx,0x4(%eax)
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	75 08                	jne    802bd7 <insert_sorted_allocList+0x244>
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	a3 44 50 80 00       	mov    %eax,0x805044
  802bd7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bdc:	40                   	inc    %eax
  802bdd:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802be2:	eb 39                	jmp    802c1d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802be4:	a1 48 50 80 00       	mov    0x805048,%eax
  802be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf0:	74 07                	je     802bf9 <insert_sorted_allocList+0x266>
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	eb 05                	jmp    802bfe <insert_sorted_allocList+0x26b>
  802bf9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bfe:	a3 48 50 80 00       	mov    %eax,0x805048
  802c03:	a1 48 50 80 00       	mov    0x805048,%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	0f 85 3f ff ff ff    	jne    802b4f <insert_sorted_allocList+0x1bc>
  802c10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c14:	0f 85 35 ff ff ff    	jne    802b4f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c1a:	eb 01                	jmp    802c1d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c1c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c1d:	90                   	nop
  802c1e:	c9                   	leave  
  802c1f:	c3                   	ret    

00802c20 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c20:	55                   	push   %ebp
  802c21:	89 e5                	mov    %esp,%ebp
  802c23:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c26:	a1 38 51 80 00       	mov    0x805138,%eax
  802c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2e:	e9 85 01 00 00       	jmp    802db8 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	8b 40 0c             	mov    0xc(%eax),%eax
  802c39:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3c:	0f 82 6e 01 00 00    	jb     802db0 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 40 0c             	mov    0xc(%eax),%eax
  802c48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c4b:	0f 85 8a 00 00 00    	jne    802cdb <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c55:	75 17                	jne    802c6e <alloc_block_FF+0x4e>
  802c57:	83 ec 04             	sub    $0x4,%esp
  802c5a:	68 a8 48 80 00       	push   $0x8048a8
  802c5f:	68 93 00 00 00       	push   $0x93
  802c64:	68 ff 47 80 00       	push   $0x8047ff
  802c69:	e8 d6 df ff ff       	call   800c44 <_panic>
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	8b 00                	mov    (%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 10                	je     802c87 <alloc_block_FF+0x67>
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7f:	8b 52 04             	mov    0x4(%edx),%edx
  802c82:	89 50 04             	mov    %edx,0x4(%eax)
  802c85:	eb 0b                	jmp    802c92 <alloc_block_FF+0x72>
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	8b 40 04             	mov    0x4(%eax),%eax
  802c8d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 40 04             	mov    0x4(%eax),%eax
  802c98:	85 c0                	test   %eax,%eax
  802c9a:	74 0f                	je     802cab <alloc_block_FF+0x8b>
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ca2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca5:	8b 12                	mov    (%edx),%edx
  802ca7:	89 10                	mov    %edx,(%eax)
  802ca9:	eb 0a                	jmp    802cb5 <alloc_block_FF+0x95>
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 00                	mov    (%eax),%eax
  802cb0:	a3 38 51 80 00       	mov    %eax,0x805138
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc8:	a1 44 51 80 00       	mov    0x805144,%eax
  802ccd:	48                   	dec    %eax
  802cce:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	e9 10 01 00 00       	jmp    802deb <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce4:	0f 86 c6 00 00 00    	jbe    802db0 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cea:	a1 48 51 80 00       	mov    0x805148,%eax
  802cef:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf5:	8b 50 08             	mov    0x8(%eax),%edx
  802cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfb:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 55 08             	mov    0x8(%ebp),%edx
  802d04:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0b:	75 17                	jne    802d24 <alloc_block_FF+0x104>
  802d0d:	83 ec 04             	sub    $0x4,%esp
  802d10:	68 a8 48 80 00       	push   $0x8048a8
  802d15:	68 9b 00 00 00       	push   $0x9b
  802d1a:	68 ff 47 80 00       	push   $0x8047ff
  802d1f:	e8 20 df ff ff       	call   800c44 <_panic>
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	74 10                	je     802d3d <alloc_block_FF+0x11d>
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d35:	8b 52 04             	mov    0x4(%edx),%edx
  802d38:	89 50 04             	mov    %edx,0x4(%eax)
  802d3b:	eb 0b                	jmp    802d48 <alloc_block_FF+0x128>
  802d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d40:	8b 40 04             	mov    0x4(%eax),%eax
  802d43:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	85 c0                	test   %eax,%eax
  802d50:	74 0f                	je     802d61 <alloc_block_FF+0x141>
  802d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d55:	8b 40 04             	mov    0x4(%eax),%eax
  802d58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5b:	8b 12                	mov    (%edx),%edx
  802d5d:	89 10                	mov    %edx,(%eax)
  802d5f:	eb 0a                	jmp    802d6b <alloc_block_FF+0x14b>
  802d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	a3 48 51 80 00       	mov    %eax,0x805148
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7e:	a1 54 51 80 00       	mov    0x805154,%eax
  802d83:	48                   	dec    %eax
  802d84:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	8b 50 08             	mov    0x8(%eax),%edx
  802d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d92:	01 c2                	add    %eax,%edx
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802da0:	2b 45 08             	sub    0x8(%ebp),%eax
  802da3:	89 c2                	mov    %eax,%edx
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dae:	eb 3b                	jmp    802deb <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802db0:	a1 40 51 80 00       	mov    0x805140,%eax
  802db5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbc:	74 07                	je     802dc5 <alloc_block_FF+0x1a5>
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	eb 05                	jmp    802dca <alloc_block_FF+0x1aa>
  802dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802dca:	a3 40 51 80 00       	mov    %eax,0x805140
  802dcf:	a1 40 51 80 00       	mov    0x805140,%eax
  802dd4:	85 c0                	test   %eax,%eax
  802dd6:	0f 85 57 fe ff ff    	jne    802c33 <alloc_block_FF+0x13>
  802ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de0:	0f 85 4d fe ff ff    	jne    802c33 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802de6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802deb:	c9                   	leave  
  802dec:	c3                   	ret    

00802ded <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ded:	55                   	push   %ebp
  802dee:	89 e5                	mov    %esp,%ebp
  802df0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802df3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802dfa:	a1 38 51 80 00       	mov    0x805138,%eax
  802dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e02:	e9 df 00 00 00       	jmp    802ee6 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e10:	0f 82 c8 00 00 00    	jb     802ede <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e1f:	0f 85 8a 00 00 00    	jne    802eaf <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802e25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e29:	75 17                	jne    802e42 <alloc_block_BF+0x55>
  802e2b:	83 ec 04             	sub    $0x4,%esp
  802e2e:	68 a8 48 80 00       	push   $0x8048a8
  802e33:	68 b7 00 00 00       	push   $0xb7
  802e38:	68 ff 47 80 00       	push   $0x8047ff
  802e3d:	e8 02 de ff ff       	call   800c44 <_panic>
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 00                	mov    (%eax),%eax
  802e47:	85 c0                	test   %eax,%eax
  802e49:	74 10                	je     802e5b <alloc_block_BF+0x6e>
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e53:	8b 52 04             	mov    0x4(%edx),%edx
  802e56:	89 50 04             	mov    %edx,0x4(%eax)
  802e59:	eb 0b                	jmp    802e66 <alloc_block_BF+0x79>
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 40 04             	mov    0x4(%eax),%eax
  802e61:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 40 04             	mov    0x4(%eax),%eax
  802e6c:	85 c0                	test   %eax,%eax
  802e6e:	74 0f                	je     802e7f <alloc_block_BF+0x92>
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 40 04             	mov    0x4(%eax),%eax
  802e76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e79:	8b 12                	mov    (%edx),%edx
  802e7b:	89 10                	mov    %edx,(%eax)
  802e7d:	eb 0a                	jmp    802e89 <alloc_block_BF+0x9c>
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 00                	mov    (%eax),%eax
  802e84:	a3 38 51 80 00       	mov    %eax,0x805138
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9c:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea1:	48                   	dec    %eax
  802ea2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	e9 4d 01 00 00       	jmp    802ffc <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb8:	76 24                	jbe    802ede <alloc_block_BF+0xf1>
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ec3:	73 19                	jae    802ede <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ec5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 40 08             	mov    0x8(%eax),%eax
  802edb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ede:	a1 40 51 80 00       	mov    0x805140,%eax
  802ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eea:	74 07                	je     802ef3 <alloc_block_BF+0x106>
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	8b 00                	mov    (%eax),%eax
  802ef1:	eb 05                	jmp    802ef8 <alloc_block_BF+0x10b>
  802ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef8:	a3 40 51 80 00       	mov    %eax,0x805140
  802efd:	a1 40 51 80 00       	mov    0x805140,%eax
  802f02:	85 c0                	test   %eax,%eax
  802f04:	0f 85 fd fe ff ff    	jne    802e07 <alloc_block_BF+0x1a>
  802f0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0e:	0f 85 f3 fe ff ff    	jne    802e07 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802f14:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f18:	0f 84 d9 00 00 00    	je     802ff7 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f1e:	a1 48 51 80 00       	mov    0x805148,%eax
  802f23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f2c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f32:	8b 55 08             	mov    0x8(%ebp),%edx
  802f35:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802f38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f3c:	75 17                	jne    802f55 <alloc_block_BF+0x168>
  802f3e:	83 ec 04             	sub    $0x4,%esp
  802f41:	68 a8 48 80 00       	push   $0x8048a8
  802f46:	68 c7 00 00 00       	push   $0xc7
  802f4b:	68 ff 47 80 00       	push   $0x8047ff
  802f50:	e8 ef dc ff ff       	call   800c44 <_panic>
  802f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f58:	8b 00                	mov    (%eax),%eax
  802f5a:	85 c0                	test   %eax,%eax
  802f5c:	74 10                	je     802f6e <alloc_block_BF+0x181>
  802f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f61:	8b 00                	mov    (%eax),%eax
  802f63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f66:	8b 52 04             	mov    0x4(%edx),%edx
  802f69:	89 50 04             	mov    %edx,0x4(%eax)
  802f6c:	eb 0b                	jmp    802f79 <alloc_block_BF+0x18c>
  802f6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f71:	8b 40 04             	mov    0x4(%eax),%eax
  802f74:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7c:	8b 40 04             	mov    0x4(%eax),%eax
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	74 0f                	je     802f92 <alloc_block_BF+0x1a5>
  802f83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f86:	8b 40 04             	mov    0x4(%eax),%eax
  802f89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f8c:	8b 12                	mov    (%edx),%edx
  802f8e:	89 10                	mov    %edx,(%eax)
  802f90:	eb 0a                	jmp    802f9c <alloc_block_BF+0x1af>
  802f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f95:	8b 00                	mov    (%eax),%eax
  802f97:	a3 48 51 80 00       	mov    %eax,0x805148
  802f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802faf:	a1 54 51 80 00       	mov    0x805154,%eax
  802fb4:	48                   	dec    %eax
  802fb5:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802fba:	83 ec 08             	sub    $0x8,%esp
  802fbd:	ff 75 ec             	pushl  -0x14(%ebp)
  802fc0:	68 38 51 80 00       	push   $0x805138
  802fc5:	e8 71 f9 ff ff       	call   80293b <find_block>
  802fca:	83 c4 10             	add    $0x10,%esp
  802fcd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802fd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd3:	8b 50 08             	mov    0x8(%eax),%edx
  802fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd9:	01 c2                	add    %eax,%edx
  802fdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fde:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802fe1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe7:	2b 45 08             	sub    0x8(%ebp),%eax
  802fea:	89 c2                	mov    %eax,%edx
  802fec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fef:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff5:	eb 05                	jmp    802ffc <alloc_block_BF+0x20f>
	}
	return NULL;
  802ff7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ffc:	c9                   	leave  
  802ffd:	c3                   	ret    

00802ffe <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ffe:	55                   	push   %ebp
  802fff:	89 e5                	mov    %esp,%ebp
  803001:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803004:	a1 28 50 80 00       	mov    0x805028,%eax
  803009:	85 c0                	test   %eax,%eax
  80300b:	0f 85 de 01 00 00    	jne    8031ef <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803011:	a1 38 51 80 00       	mov    0x805138,%eax
  803016:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803019:	e9 9e 01 00 00       	jmp    8031bc <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80301e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803021:	8b 40 0c             	mov    0xc(%eax),%eax
  803024:	3b 45 08             	cmp    0x8(%ebp),%eax
  803027:	0f 82 87 01 00 00    	jb     8031b4 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 40 0c             	mov    0xc(%eax),%eax
  803033:	3b 45 08             	cmp    0x8(%ebp),%eax
  803036:	0f 85 95 00 00 00    	jne    8030d1 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80303c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803040:	75 17                	jne    803059 <alloc_block_NF+0x5b>
  803042:	83 ec 04             	sub    $0x4,%esp
  803045:	68 a8 48 80 00       	push   $0x8048a8
  80304a:	68 e0 00 00 00       	push   $0xe0
  80304f:	68 ff 47 80 00       	push   $0x8047ff
  803054:	e8 eb db ff ff       	call   800c44 <_panic>
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 10                	je     803072 <alloc_block_NF+0x74>
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	8b 00                	mov    (%eax),%eax
  803067:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306a:	8b 52 04             	mov    0x4(%edx),%edx
  80306d:	89 50 04             	mov    %edx,0x4(%eax)
  803070:	eb 0b                	jmp    80307d <alloc_block_NF+0x7f>
  803072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803075:	8b 40 04             	mov    0x4(%eax),%eax
  803078:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 40 04             	mov    0x4(%eax),%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	74 0f                	je     803096 <alloc_block_NF+0x98>
  803087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308a:	8b 40 04             	mov    0x4(%eax),%eax
  80308d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803090:	8b 12                	mov    (%edx),%edx
  803092:	89 10                	mov    %edx,(%eax)
  803094:	eb 0a                	jmp    8030a0 <alloc_block_NF+0xa2>
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	8b 00                	mov    (%eax),%eax
  80309b:	a3 38 51 80 00       	mov    %eax,0x805138
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b3:	a1 44 51 80 00       	mov    0x805144,%eax
  8030b8:	48                   	dec    %eax
  8030b9:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 40 08             	mov    0x8(%eax),%eax
  8030c4:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	e9 f8 04 00 00       	jmp    8035c9 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030da:	0f 86 d4 00 00 00    	jbe    8031b4 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8030e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030eb:	8b 50 08             	mov    0x8(%eax),%edx
  8030ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f1:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8030f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fa:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803101:	75 17                	jne    80311a <alloc_block_NF+0x11c>
  803103:	83 ec 04             	sub    $0x4,%esp
  803106:	68 a8 48 80 00       	push   $0x8048a8
  80310b:	68 e9 00 00 00       	push   $0xe9
  803110:	68 ff 47 80 00       	push   $0x8047ff
  803115:	e8 2a db ff ff       	call   800c44 <_panic>
  80311a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311d:	8b 00                	mov    (%eax),%eax
  80311f:	85 c0                	test   %eax,%eax
  803121:	74 10                	je     803133 <alloc_block_NF+0x135>
  803123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80312b:	8b 52 04             	mov    0x4(%edx),%edx
  80312e:	89 50 04             	mov    %edx,0x4(%eax)
  803131:	eb 0b                	jmp    80313e <alloc_block_NF+0x140>
  803133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803136:	8b 40 04             	mov    0x4(%eax),%eax
  803139:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803141:	8b 40 04             	mov    0x4(%eax),%eax
  803144:	85 c0                	test   %eax,%eax
  803146:	74 0f                	je     803157 <alloc_block_NF+0x159>
  803148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314b:	8b 40 04             	mov    0x4(%eax),%eax
  80314e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803151:	8b 12                	mov    (%edx),%edx
  803153:	89 10                	mov    %edx,(%eax)
  803155:	eb 0a                	jmp    803161 <alloc_block_NF+0x163>
  803157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315a:	8b 00                	mov    (%eax),%eax
  80315c:	a3 48 51 80 00       	mov    %eax,0x805148
  803161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803164:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803174:	a1 54 51 80 00       	mov    0x805154,%eax
  803179:	48                   	dec    %eax
  80317a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80317f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803182:	8b 40 08             	mov    0x8(%eax),%eax
  803185:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80318a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318d:	8b 50 08             	mov    0x8(%eax),%edx
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	01 c2                	add    %eax,%edx
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a1:	2b 45 08             	sub    0x8(%ebp),%eax
  8031a4:	89 c2                	mov    %eax,%edx
  8031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a9:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8031ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031af:	e9 15 04 00 00       	jmp    8035c9 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8031b4:	a1 40 51 80 00       	mov    0x805140,%eax
  8031b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c0:	74 07                	je     8031c9 <alloc_block_NF+0x1cb>
  8031c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	eb 05                	jmp    8031ce <alloc_block_NF+0x1d0>
  8031c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ce:	a3 40 51 80 00       	mov    %eax,0x805140
  8031d3:	a1 40 51 80 00       	mov    0x805140,%eax
  8031d8:	85 c0                	test   %eax,%eax
  8031da:	0f 85 3e fe ff ff    	jne    80301e <alloc_block_NF+0x20>
  8031e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e4:	0f 85 34 fe ff ff    	jne    80301e <alloc_block_NF+0x20>
  8031ea:	e9 d5 03 00 00       	jmp    8035c4 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8031f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f7:	e9 b1 01 00 00       	jmp    8033ad <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8031fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ff:	8b 50 08             	mov    0x8(%eax),%edx
  803202:	a1 28 50 80 00       	mov    0x805028,%eax
  803207:	39 c2                	cmp    %eax,%edx
  803209:	0f 82 96 01 00 00    	jb     8033a5 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80320f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803212:	8b 40 0c             	mov    0xc(%eax),%eax
  803215:	3b 45 08             	cmp    0x8(%ebp),%eax
  803218:	0f 82 87 01 00 00    	jb     8033a5 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80321e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803221:	8b 40 0c             	mov    0xc(%eax),%eax
  803224:	3b 45 08             	cmp    0x8(%ebp),%eax
  803227:	0f 85 95 00 00 00    	jne    8032c2 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80322d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803231:	75 17                	jne    80324a <alloc_block_NF+0x24c>
  803233:	83 ec 04             	sub    $0x4,%esp
  803236:	68 a8 48 80 00       	push   $0x8048a8
  80323b:	68 fc 00 00 00       	push   $0xfc
  803240:	68 ff 47 80 00       	push   $0x8047ff
  803245:	e8 fa d9 ff ff       	call   800c44 <_panic>
  80324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324d:	8b 00                	mov    (%eax),%eax
  80324f:	85 c0                	test   %eax,%eax
  803251:	74 10                	je     803263 <alloc_block_NF+0x265>
  803253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803256:	8b 00                	mov    (%eax),%eax
  803258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80325b:	8b 52 04             	mov    0x4(%edx),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%eax)
  803261:	eb 0b                	jmp    80326e <alloc_block_NF+0x270>
  803263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803266:	8b 40 04             	mov    0x4(%eax),%eax
  803269:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 40 04             	mov    0x4(%eax),%eax
  803274:	85 c0                	test   %eax,%eax
  803276:	74 0f                	je     803287 <alloc_block_NF+0x289>
  803278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327b:	8b 40 04             	mov    0x4(%eax),%eax
  80327e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803281:	8b 12                	mov    (%edx),%edx
  803283:	89 10                	mov    %edx,(%eax)
  803285:	eb 0a                	jmp    803291 <alloc_block_NF+0x293>
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	a3 38 51 80 00       	mov    %eax,0x805138
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8032a9:	48                   	dec    %eax
  8032aa:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b2:	8b 40 08             	mov    0x8(%eax),%eax
  8032b5:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	e9 07 03 00 00       	jmp    8035c9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032cb:	0f 86 d4 00 00 00    	jbe    8033a5 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dc:	8b 50 08             	mov    0x8(%eax),%edx
  8032df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032eb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032f2:	75 17                	jne    80330b <alloc_block_NF+0x30d>
  8032f4:	83 ec 04             	sub    $0x4,%esp
  8032f7:	68 a8 48 80 00       	push   $0x8048a8
  8032fc:	68 04 01 00 00       	push   $0x104
  803301:	68 ff 47 80 00       	push   $0x8047ff
  803306:	e8 39 d9 ff ff       	call   800c44 <_panic>
  80330b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330e:	8b 00                	mov    (%eax),%eax
  803310:	85 c0                	test   %eax,%eax
  803312:	74 10                	je     803324 <alloc_block_NF+0x326>
  803314:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803317:	8b 00                	mov    (%eax),%eax
  803319:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80331c:	8b 52 04             	mov    0x4(%edx),%edx
  80331f:	89 50 04             	mov    %edx,0x4(%eax)
  803322:	eb 0b                	jmp    80332f <alloc_block_NF+0x331>
  803324:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803327:	8b 40 04             	mov    0x4(%eax),%eax
  80332a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803332:	8b 40 04             	mov    0x4(%eax),%eax
  803335:	85 c0                	test   %eax,%eax
  803337:	74 0f                	je     803348 <alloc_block_NF+0x34a>
  803339:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333c:	8b 40 04             	mov    0x4(%eax),%eax
  80333f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803342:	8b 12                	mov    (%edx),%edx
  803344:	89 10                	mov    %edx,(%eax)
  803346:	eb 0a                	jmp    803352 <alloc_block_NF+0x354>
  803348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	a3 48 51 80 00       	mov    %eax,0x805148
  803352:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803355:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80335b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803365:	a1 54 51 80 00       	mov    0x805154,%eax
  80336a:	48                   	dec    %eax
  80336b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803370:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803373:	8b 40 08             	mov    0x8(%eax),%eax
  803376:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80337b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337e:	8b 50 08             	mov    0x8(%eax),%edx
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	01 c2                	add    %eax,%edx
  803386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803389:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338f:	8b 40 0c             	mov    0xc(%eax),%eax
  803392:	2b 45 08             	sub    0x8(%ebp),%eax
  803395:	89 c2                	mov    %eax,%edx
  803397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80339d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a0:	e9 24 02 00 00       	jmp    8035c9 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8033aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b1:	74 07                	je     8033ba <alloc_block_NF+0x3bc>
  8033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b6:	8b 00                	mov    (%eax),%eax
  8033b8:	eb 05                	jmp    8033bf <alloc_block_NF+0x3c1>
  8033ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bf:	a3 40 51 80 00       	mov    %eax,0x805140
  8033c4:	a1 40 51 80 00       	mov    0x805140,%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	0f 85 2b fe ff ff    	jne    8031fc <alloc_block_NF+0x1fe>
  8033d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d5:	0f 85 21 fe ff ff    	jne    8031fc <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033db:	a1 38 51 80 00       	mov    0x805138,%eax
  8033e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e3:	e9 ae 01 00 00       	jmp    803596 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	8b 50 08             	mov    0x8(%eax),%edx
  8033ee:	a1 28 50 80 00       	mov    0x805028,%eax
  8033f3:	39 c2                	cmp    %eax,%edx
  8033f5:	0f 83 93 01 00 00    	jae    80358e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8033fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803401:	3b 45 08             	cmp    0x8(%ebp),%eax
  803404:	0f 82 84 01 00 00    	jb     80358e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80340a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340d:	8b 40 0c             	mov    0xc(%eax),%eax
  803410:	3b 45 08             	cmp    0x8(%ebp),%eax
  803413:	0f 85 95 00 00 00    	jne    8034ae <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341d:	75 17                	jne    803436 <alloc_block_NF+0x438>
  80341f:	83 ec 04             	sub    $0x4,%esp
  803422:	68 a8 48 80 00       	push   $0x8048a8
  803427:	68 14 01 00 00       	push   $0x114
  80342c:	68 ff 47 80 00       	push   $0x8047ff
  803431:	e8 0e d8 ff ff       	call   800c44 <_panic>
  803436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	85 c0                	test   %eax,%eax
  80343d:	74 10                	je     80344f <alloc_block_NF+0x451>
  80343f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803442:	8b 00                	mov    (%eax),%eax
  803444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803447:	8b 52 04             	mov    0x4(%edx),%edx
  80344a:	89 50 04             	mov    %edx,0x4(%eax)
  80344d:	eb 0b                	jmp    80345a <alloc_block_NF+0x45c>
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	8b 40 04             	mov    0x4(%eax),%eax
  803455:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	8b 40 04             	mov    0x4(%eax),%eax
  803460:	85 c0                	test   %eax,%eax
  803462:	74 0f                	je     803473 <alloc_block_NF+0x475>
  803464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803467:	8b 40 04             	mov    0x4(%eax),%eax
  80346a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80346d:	8b 12                	mov    (%edx),%edx
  80346f:	89 10                	mov    %edx,(%eax)
  803471:	eb 0a                	jmp    80347d <alloc_block_NF+0x47f>
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	a3 38 51 80 00       	mov    %eax,0x805138
  80347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803490:	a1 44 51 80 00       	mov    0x805144,%eax
  803495:	48                   	dec    %eax
  803496:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349e:	8b 40 08             	mov    0x8(%eax),%eax
  8034a1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8034a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a9:	e9 1b 01 00 00       	jmp    8035c9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8034ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034b7:	0f 86 d1 00 00 00    	jbe    80358e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8034bd:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8034c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c8:	8b 50 08             	mov    0x8(%eax),%edx
  8034cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ce:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8034d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8034da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034de:	75 17                	jne    8034f7 <alloc_block_NF+0x4f9>
  8034e0:	83 ec 04             	sub    $0x4,%esp
  8034e3:	68 a8 48 80 00       	push   $0x8048a8
  8034e8:	68 1c 01 00 00       	push   $0x11c
  8034ed:	68 ff 47 80 00       	push   $0x8047ff
  8034f2:	e8 4d d7 ff ff       	call   800c44 <_panic>
  8034f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fa:	8b 00                	mov    (%eax),%eax
  8034fc:	85 c0                	test   %eax,%eax
  8034fe:	74 10                	je     803510 <alloc_block_NF+0x512>
  803500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803503:	8b 00                	mov    (%eax),%eax
  803505:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803508:	8b 52 04             	mov    0x4(%edx),%edx
  80350b:	89 50 04             	mov    %edx,0x4(%eax)
  80350e:	eb 0b                	jmp    80351b <alloc_block_NF+0x51d>
  803510:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803513:	8b 40 04             	mov    0x4(%eax),%eax
  803516:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80351b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351e:	8b 40 04             	mov    0x4(%eax),%eax
  803521:	85 c0                	test   %eax,%eax
  803523:	74 0f                	je     803534 <alloc_block_NF+0x536>
  803525:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803528:	8b 40 04             	mov    0x4(%eax),%eax
  80352b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80352e:	8b 12                	mov    (%edx),%edx
  803530:	89 10                	mov    %edx,(%eax)
  803532:	eb 0a                	jmp    80353e <alloc_block_NF+0x540>
  803534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803537:	8b 00                	mov    (%eax),%eax
  803539:	a3 48 51 80 00       	mov    %eax,0x805148
  80353e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803547:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80354a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803551:	a1 54 51 80 00       	mov    0x805154,%eax
  803556:	48                   	dec    %eax
  803557:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80355c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355f:	8b 40 08             	mov    0x8(%eax),%eax
  803562:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356a:	8b 50 08             	mov    0x8(%eax),%edx
  80356d:	8b 45 08             	mov    0x8(%ebp),%eax
  803570:	01 c2                	add    %eax,%edx
  803572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803575:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357b:	8b 40 0c             	mov    0xc(%eax),%eax
  80357e:	2b 45 08             	sub    0x8(%ebp),%eax
  803581:	89 c2                	mov    %eax,%edx
  803583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803586:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358c:	eb 3b                	jmp    8035c9 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80358e:	a1 40 51 80 00       	mov    0x805140,%eax
  803593:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80359a:	74 07                	je     8035a3 <alloc_block_NF+0x5a5>
  80359c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359f:	8b 00                	mov    (%eax),%eax
  8035a1:	eb 05                	jmp    8035a8 <alloc_block_NF+0x5aa>
  8035a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a8:	a3 40 51 80 00       	mov    %eax,0x805140
  8035ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8035b2:	85 c0                	test   %eax,%eax
  8035b4:	0f 85 2e fe ff ff    	jne    8033e8 <alloc_block_NF+0x3ea>
  8035ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035be:	0f 85 24 fe ff ff    	jne    8033e8 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8035c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035c9:	c9                   	leave  
  8035ca:	c3                   	ret    

008035cb <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8035cb:	55                   	push   %ebp
  8035cc:	89 e5                	mov    %esp,%ebp
  8035ce:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8035d1:	a1 38 51 80 00       	mov    0x805138,%eax
  8035d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8035d9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035de:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8035e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8035e6:	85 c0                	test   %eax,%eax
  8035e8:	74 14                	je     8035fe <insert_sorted_with_merge_freeList+0x33>
  8035ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ed:	8b 50 08             	mov    0x8(%eax),%edx
  8035f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f3:	8b 40 08             	mov    0x8(%eax),%eax
  8035f6:	39 c2                	cmp    %eax,%edx
  8035f8:	0f 87 9b 01 00 00    	ja     803799 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8035fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803602:	75 17                	jne    80361b <insert_sorted_with_merge_freeList+0x50>
  803604:	83 ec 04             	sub    $0x4,%esp
  803607:	68 dc 47 80 00       	push   $0x8047dc
  80360c:	68 38 01 00 00       	push   $0x138
  803611:	68 ff 47 80 00       	push   $0x8047ff
  803616:	e8 29 d6 ff ff       	call   800c44 <_panic>
  80361b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803621:	8b 45 08             	mov    0x8(%ebp),%eax
  803624:	89 10                	mov    %edx,(%eax)
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	8b 00                	mov    (%eax),%eax
  80362b:	85 c0                	test   %eax,%eax
  80362d:	74 0d                	je     80363c <insert_sorted_with_merge_freeList+0x71>
  80362f:	a1 38 51 80 00       	mov    0x805138,%eax
  803634:	8b 55 08             	mov    0x8(%ebp),%edx
  803637:	89 50 04             	mov    %edx,0x4(%eax)
  80363a:	eb 08                	jmp    803644 <insert_sorted_with_merge_freeList+0x79>
  80363c:	8b 45 08             	mov    0x8(%ebp),%eax
  80363f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803644:	8b 45 08             	mov    0x8(%ebp),%eax
  803647:	a3 38 51 80 00       	mov    %eax,0x805138
  80364c:	8b 45 08             	mov    0x8(%ebp),%eax
  80364f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803656:	a1 44 51 80 00       	mov    0x805144,%eax
  80365b:	40                   	inc    %eax
  80365c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803661:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803665:	0f 84 a8 06 00 00    	je     803d13 <insert_sorted_with_merge_freeList+0x748>
  80366b:	8b 45 08             	mov    0x8(%ebp),%eax
  80366e:	8b 50 08             	mov    0x8(%eax),%edx
  803671:	8b 45 08             	mov    0x8(%ebp),%eax
  803674:	8b 40 0c             	mov    0xc(%eax),%eax
  803677:	01 c2                	add    %eax,%edx
  803679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80367c:	8b 40 08             	mov    0x8(%eax),%eax
  80367f:	39 c2                	cmp    %eax,%edx
  803681:	0f 85 8c 06 00 00    	jne    803d13 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803687:	8b 45 08             	mov    0x8(%ebp),%eax
  80368a:	8b 50 0c             	mov    0xc(%eax),%edx
  80368d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803690:	8b 40 0c             	mov    0xc(%eax),%eax
  803693:	01 c2                	add    %eax,%edx
  803695:	8b 45 08             	mov    0x8(%ebp),%eax
  803698:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80369b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80369f:	75 17                	jne    8036b8 <insert_sorted_with_merge_freeList+0xed>
  8036a1:	83 ec 04             	sub    $0x4,%esp
  8036a4:	68 a8 48 80 00       	push   $0x8048a8
  8036a9:	68 3c 01 00 00       	push   $0x13c
  8036ae:	68 ff 47 80 00       	push   $0x8047ff
  8036b3:	e8 8c d5 ff ff       	call   800c44 <_panic>
  8036b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036bb:	8b 00                	mov    (%eax),%eax
  8036bd:	85 c0                	test   %eax,%eax
  8036bf:	74 10                	je     8036d1 <insert_sorted_with_merge_freeList+0x106>
  8036c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c4:	8b 00                	mov    (%eax),%eax
  8036c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036c9:	8b 52 04             	mov    0x4(%edx),%edx
  8036cc:	89 50 04             	mov    %edx,0x4(%eax)
  8036cf:	eb 0b                	jmp    8036dc <insert_sorted_with_merge_freeList+0x111>
  8036d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d4:	8b 40 04             	mov    0x4(%eax),%eax
  8036d7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036df:	8b 40 04             	mov    0x4(%eax),%eax
  8036e2:	85 c0                	test   %eax,%eax
  8036e4:	74 0f                	je     8036f5 <insert_sorted_with_merge_freeList+0x12a>
  8036e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e9:	8b 40 04             	mov    0x4(%eax),%eax
  8036ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ef:	8b 12                	mov    (%edx),%edx
  8036f1:	89 10                	mov    %edx,(%eax)
  8036f3:	eb 0a                	jmp    8036ff <insert_sorted_with_merge_freeList+0x134>
  8036f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f8:	8b 00                	mov    (%eax),%eax
  8036fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8036ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803702:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803712:	a1 44 51 80 00       	mov    0x805144,%eax
  803717:	48                   	dec    %eax
  803718:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80371d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803720:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803731:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803735:	75 17                	jne    80374e <insert_sorted_with_merge_freeList+0x183>
  803737:	83 ec 04             	sub    $0x4,%esp
  80373a:	68 dc 47 80 00       	push   $0x8047dc
  80373f:	68 3f 01 00 00       	push   $0x13f
  803744:	68 ff 47 80 00       	push   $0x8047ff
  803749:	e8 f6 d4 ff ff       	call   800c44 <_panic>
  80374e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803757:	89 10                	mov    %edx,(%eax)
  803759:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375c:	8b 00                	mov    (%eax),%eax
  80375e:	85 c0                	test   %eax,%eax
  803760:	74 0d                	je     80376f <insert_sorted_with_merge_freeList+0x1a4>
  803762:	a1 48 51 80 00       	mov    0x805148,%eax
  803767:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80376a:	89 50 04             	mov    %edx,0x4(%eax)
  80376d:	eb 08                	jmp    803777 <insert_sorted_with_merge_freeList+0x1ac>
  80376f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803772:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377a:	a3 48 51 80 00       	mov    %eax,0x805148
  80377f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803782:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803789:	a1 54 51 80 00       	mov    0x805154,%eax
  80378e:	40                   	inc    %eax
  80378f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803794:	e9 7a 05 00 00       	jmp    803d13 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803799:	8b 45 08             	mov    0x8(%ebp),%eax
  80379c:	8b 50 08             	mov    0x8(%eax),%edx
  80379f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a2:	8b 40 08             	mov    0x8(%eax),%eax
  8037a5:	39 c2                	cmp    %eax,%edx
  8037a7:	0f 82 14 01 00 00    	jb     8038c1 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8037ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b0:	8b 50 08             	mov    0x8(%eax),%edx
  8037b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b9:	01 c2                	add    %eax,%edx
  8037bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037be:	8b 40 08             	mov    0x8(%eax),%eax
  8037c1:	39 c2                	cmp    %eax,%edx
  8037c3:	0f 85 90 00 00 00    	jne    803859 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8037c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8037cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d5:	01 c2                	add    %eax,%edx
  8037d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037da:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8037dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8037e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037f5:	75 17                	jne    80380e <insert_sorted_with_merge_freeList+0x243>
  8037f7:	83 ec 04             	sub    $0x4,%esp
  8037fa:	68 dc 47 80 00       	push   $0x8047dc
  8037ff:	68 49 01 00 00       	push   $0x149
  803804:	68 ff 47 80 00       	push   $0x8047ff
  803809:	e8 36 d4 ff ff       	call   800c44 <_panic>
  80380e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803814:	8b 45 08             	mov    0x8(%ebp),%eax
  803817:	89 10                	mov    %edx,(%eax)
  803819:	8b 45 08             	mov    0x8(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	85 c0                	test   %eax,%eax
  803820:	74 0d                	je     80382f <insert_sorted_with_merge_freeList+0x264>
  803822:	a1 48 51 80 00       	mov    0x805148,%eax
  803827:	8b 55 08             	mov    0x8(%ebp),%edx
  80382a:	89 50 04             	mov    %edx,0x4(%eax)
  80382d:	eb 08                	jmp    803837 <insert_sorted_with_merge_freeList+0x26c>
  80382f:	8b 45 08             	mov    0x8(%ebp),%eax
  803832:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803837:	8b 45 08             	mov    0x8(%ebp),%eax
  80383a:	a3 48 51 80 00       	mov    %eax,0x805148
  80383f:	8b 45 08             	mov    0x8(%ebp),%eax
  803842:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803849:	a1 54 51 80 00       	mov    0x805154,%eax
  80384e:	40                   	inc    %eax
  80384f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803854:	e9 bb 04 00 00       	jmp    803d14 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803859:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80385d:	75 17                	jne    803876 <insert_sorted_with_merge_freeList+0x2ab>
  80385f:	83 ec 04             	sub    $0x4,%esp
  803862:	68 50 48 80 00       	push   $0x804850
  803867:	68 4c 01 00 00       	push   $0x14c
  80386c:	68 ff 47 80 00       	push   $0x8047ff
  803871:	e8 ce d3 ff ff       	call   800c44 <_panic>
  803876:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80387c:	8b 45 08             	mov    0x8(%ebp),%eax
  80387f:	89 50 04             	mov    %edx,0x4(%eax)
  803882:	8b 45 08             	mov    0x8(%ebp),%eax
  803885:	8b 40 04             	mov    0x4(%eax),%eax
  803888:	85 c0                	test   %eax,%eax
  80388a:	74 0c                	je     803898 <insert_sorted_with_merge_freeList+0x2cd>
  80388c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803891:	8b 55 08             	mov    0x8(%ebp),%edx
  803894:	89 10                	mov    %edx,(%eax)
  803896:	eb 08                	jmp    8038a0 <insert_sorted_with_merge_freeList+0x2d5>
  803898:	8b 45 08             	mov    0x8(%ebp),%eax
  80389b:	a3 38 51 80 00       	mov    %eax,0x805138
  8038a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038b1:	a1 44 51 80 00       	mov    0x805144,%eax
  8038b6:	40                   	inc    %eax
  8038b7:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038bc:	e9 53 04 00 00       	jmp    803d14 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038c1:	a1 38 51 80 00       	mov    0x805138,%eax
  8038c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038c9:	e9 15 04 00 00       	jmp    803ce3 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8038ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d1:	8b 00                	mov    (%eax),%eax
  8038d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d9:	8b 50 08             	mov    0x8(%eax),%edx
  8038dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038df:	8b 40 08             	mov    0x8(%eax),%eax
  8038e2:	39 c2                	cmp    %eax,%edx
  8038e4:	0f 86 f1 03 00 00    	jbe    803cdb <insert_sorted_with_merge_freeList+0x710>
  8038ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ed:	8b 50 08             	mov    0x8(%eax),%edx
  8038f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f3:	8b 40 08             	mov    0x8(%eax),%eax
  8038f6:	39 c2                	cmp    %eax,%edx
  8038f8:	0f 83 dd 03 00 00    	jae    803cdb <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8038fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803901:	8b 50 08             	mov    0x8(%eax),%edx
  803904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803907:	8b 40 0c             	mov    0xc(%eax),%eax
  80390a:	01 c2                	add    %eax,%edx
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
  80390f:	8b 40 08             	mov    0x8(%eax),%eax
  803912:	39 c2                	cmp    %eax,%edx
  803914:	0f 85 b9 01 00 00    	jne    803ad3 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80391a:	8b 45 08             	mov    0x8(%ebp),%eax
  80391d:	8b 50 08             	mov    0x8(%eax),%edx
  803920:	8b 45 08             	mov    0x8(%ebp),%eax
  803923:	8b 40 0c             	mov    0xc(%eax),%eax
  803926:	01 c2                	add    %eax,%edx
  803928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392b:	8b 40 08             	mov    0x8(%eax),%eax
  80392e:	39 c2                	cmp    %eax,%edx
  803930:	0f 85 0d 01 00 00    	jne    803a43 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803939:	8b 50 0c             	mov    0xc(%eax),%edx
  80393c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80393f:	8b 40 0c             	mov    0xc(%eax),%eax
  803942:	01 c2                	add    %eax,%edx
  803944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803947:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80394a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80394e:	75 17                	jne    803967 <insert_sorted_with_merge_freeList+0x39c>
  803950:	83 ec 04             	sub    $0x4,%esp
  803953:	68 a8 48 80 00       	push   $0x8048a8
  803958:	68 5c 01 00 00       	push   $0x15c
  80395d:	68 ff 47 80 00       	push   $0x8047ff
  803962:	e8 dd d2 ff ff       	call   800c44 <_panic>
  803967:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396a:	8b 00                	mov    (%eax),%eax
  80396c:	85 c0                	test   %eax,%eax
  80396e:	74 10                	je     803980 <insert_sorted_with_merge_freeList+0x3b5>
  803970:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803973:	8b 00                	mov    (%eax),%eax
  803975:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803978:	8b 52 04             	mov    0x4(%edx),%edx
  80397b:	89 50 04             	mov    %edx,0x4(%eax)
  80397e:	eb 0b                	jmp    80398b <insert_sorted_with_merge_freeList+0x3c0>
  803980:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803983:	8b 40 04             	mov    0x4(%eax),%eax
  803986:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80398b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398e:	8b 40 04             	mov    0x4(%eax),%eax
  803991:	85 c0                	test   %eax,%eax
  803993:	74 0f                	je     8039a4 <insert_sorted_with_merge_freeList+0x3d9>
  803995:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803998:	8b 40 04             	mov    0x4(%eax),%eax
  80399b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80399e:	8b 12                	mov    (%edx),%edx
  8039a0:	89 10                	mov    %edx,(%eax)
  8039a2:	eb 0a                	jmp    8039ae <insert_sorted_with_merge_freeList+0x3e3>
  8039a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a7:	8b 00                	mov    (%eax),%eax
  8039a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8039ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8039c6:	48                   	dec    %eax
  8039c7:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8039cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8039d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039e4:	75 17                	jne    8039fd <insert_sorted_with_merge_freeList+0x432>
  8039e6:	83 ec 04             	sub    $0x4,%esp
  8039e9:	68 dc 47 80 00       	push   $0x8047dc
  8039ee:	68 5f 01 00 00       	push   $0x15f
  8039f3:	68 ff 47 80 00       	push   $0x8047ff
  8039f8:	e8 47 d2 ff ff       	call   800c44 <_panic>
  8039fd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a06:	89 10                	mov    %edx,(%eax)
  803a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0b:	8b 00                	mov    (%eax),%eax
  803a0d:	85 c0                	test   %eax,%eax
  803a0f:	74 0d                	je     803a1e <insert_sorted_with_merge_freeList+0x453>
  803a11:	a1 48 51 80 00       	mov    0x805148,%eax
  803a16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a19:	89 50 04             	mov    %edx,0x4(%eax)
  803a1c:	eb 08                	jmp    803a26 <insert_sorted_with_merge_freeList+0x45b>
  803a1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a21:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a29:	a3 48 51 80 00       	mov    %eax,0x805148
  803a2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a38:	a1 54 51 80 00       	mov    0x805154,%eax
  803a3d:	40                   	inc    %eax
  803a3e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a46:	8b 50 0c             	mov    0xc(%eax),%edx
  803a49:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4c:	8b 40 0c             	mov    0xc(%eax),%eax
  803a4f:	01 c2                	add    %eax,%edx
  803a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a54:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a57:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a61:	8b 45 08             	mov    0x8(%ebp),%eax
  803a64:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a6f:	75 17                	jne    803a88 <insert_sorted_with_merge_freeList+0x4bd>
  803a71:	83 ec 04             	sub    $0x4,%esp
  803a74:	68 dc 47 80 00       	push   $0x8047dc
  803a79:	68 64 01 00 00       	push   $0x164
  803a7e:	68 ff 47 80 00       	push   $0x8047ff
  803a83:	e8 bc d1 ff ff       	call   800c44 <_panic>
  803a88:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a91:	89 10                	mov    %edx,(%eax)
  803a93:	8b 45 08             	mov    0x8(%ebp),%eax
  803a96:	8b 00                	mov    (%eax),%eax
  803a98:	85 c0                	test   %eax,%eax
  803a9a:	74 0d                	je     803aa9 <insert_sorted_with_merge_freeList+0x4de>
  803a9c:	a1 48 51 80 00       	mov    0x805148,%eax
  803aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  803aa4:	89 50 04             	mov    %edx,0x4(%eax)
  803aa7:	eb 08                	jmp    803ab1 <insert_sorted_with_merge_freeList+0x4e6>
  803aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab4:	a3 48 51 80 00       	mov    %eax,0x805148
  803ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  803abc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ac3:	a1 54 51 80 00       	mov    0x805154,%eax
  803ac8:	40                   	inc    %eax
  803ac9:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ace:	e9 41 02 00 00       	jmp    803d14 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad6:	8b 50 08             	mov    0x8(%eax),%edx
  803ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  803adc:	8b 40 0c             	mov    0xc(%eax),%eax
  803adf:	01 c2                	add    %eax,%edx
  803ae1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae4:	8b 40 08             	mov    0x8(%eax),%eax
  803ae7:	39 c2                	cmp    %eax,%edx
  803ae9:	0f 85 7c 01 00 00    	jne    803c6b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803aef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803af3:	74 06                	je     803afb <insert_sorted_with_merge_freeList+0x530>
  803af5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803af9:	75 17                	jne    803b12 <insert_sorted_with_merge_freeList+0x547>
  803afb:	83 ec 04             	sub    $0x4,%esp
  803afe:	68 18 48 80 00       	push   $0x804818
  803b03:	68 69 01 00 00       	push   $0x169
  803b08:	68 ff 47 80 00       	push   $0x8047ff
  803b0d:	e8 32 d1 ff ff       	call   800c44 <_panic>
  803b12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b15:	8b 50 04             	mov    0x4(%eax),%edx
  803b18:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1b:	89 50 04             	mov    %edx,0x4(%eax)
  803b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b24:	89 10                	mov    %edx,(%eax)
  803b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b29:	8b 40 04             	mov    0x4(%eax),%eax
  803b2c:	85 c0                	test   %eax,%eax
  803b2e:	74 0d                	je     803b3d <insert_sorted_with_merge_freeList+0x572>
  803b30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b33:	8b 40 04             	mov    0x4(%eax),%eax
  803b36:	8b 55 08             	mov    0x8(%ebp),%edx
  803b39:	89 10                	mov    %edx,(%eax)
  803b3b:	eb 08                	jmp    803b45 <insert_sorted_with_merge_freeList+0x57a>
  803b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b40:	a3 38 51 80 00       	mov    %eax,0x805138
  803b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b48:	8b 55 08             	mov    0x8(%ebp),%edx
  803b4b:	89 50 04             	mov    %edx,0x4(%eax)
  803b4e:	a1 44 51 80 00       	mov    0x805144,%eax
  803b53:	40                   	inc    %eax
  803b54:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b59:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5c:	8b 50 0c             	mov    0xc(%eax),%edx
  803b5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b62:	8b 40 0c             	mov    0xc(%eax),%eax
  803b65:	01 c2                	add    %eax,%edx
  803b67:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b6d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b71:	75 17                	jne    803b8a <insert_sorted_with_merge_freeList+0x5bf>
  803b73:	83 ec 04             	sub    $0x4,%esp
  803b76:	68 a8 48 80 00       	push   $0x8048a8
  803b7b:	68 6b 01 00 00       	push   $0x16b
  803b80:	68 ff 47 80 00       	push   $0x8047ff
  803b85:	e8 ba d0 ff ff       	call   800c44 <_panic>
  803b8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b8d:	8b 00                	mov    (%eax),%eax
  803b8f:	85 c0                	test   %eax,%eax
  803b91:	74 10                	je     803ba3 <insert_sorted_with_merge_freeList+0x5d8>
  803b93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b96:	8b 00                	mov    (%eax),%eax
  803b98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b9b:	8b 52 04             	mov    0x4(%edx),%edx
  803b9e:	89 50 04             	mov    %edx,0x4(%eax)
  803ba1:	eb 0b                	jmp    803bae <insert_sorted_with_merge_freeList+0x5e3>
  803ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba6:	8b 40 04             	mov    0x4(%eax),%eax
  803ba9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb1:	8b 40 04             	mov    0x4(%eax),%eax
  803bb4:	85 c0                	test   %eax,%eax
  803bb6:	74 0f                	je     803bc7 <insert_sorted_with_merge_freeList+0x5fc>
  803bb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bbb:	8b 40 04             	mov    0x4(%eax),%eax
  803bbe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bc1:	8b 12                	mov    (%edx),%edx
  803bc3:	89 10                	mov    %edx,(%eax)
  803bc5:	eb 0a                	jmp    803bd1 <insert_sorted_with_merge_freeList+0x606>
  803bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bca:	8b 00                	mov    (%eax),%eax
  803bcc:	a3 38 51 80 00       	mov    %eax,0x805138
  803bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bdd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803be4:	a1 44 51 80 00       	mov    0x805144,%eax
  803be9:	48                   	dec    %eax
  803bea:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803bef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803bf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bfc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803c03:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c07:	75 17                	jne    803c20 <insert_sorted_with_merge_freeList+0x655>
  803c09:	83 ec 04             	sub    $0x4,%esp
  803c0c:	68 dc 47 80 00       	push   $0x8047dc
  803c11:	68 6e 01 00 00       	push   $0x16e
  803c16:	68 ff 47 80 00       	push   $0x8047ff
  803c1b:	e8 24 d0 ff ff       	call   800c44 <_panic>
  803c20:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c29:	89 10                	mov    %edx,(%eax)
  803c2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c2e:	8b 00                	mov    (%eax),%eax
  803c30:	85 c0                	test   %eax,%eax
  803c32:	74 0d                	je     803c41 <insert_sorted_with_merge_freeList+0x676>
  803c34:	a1 48 51 80 00       	mov    0x805148,%eax
  803c39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c3c:	89 50 04             	mov    %edx,0x4(%eax)
  803c3f:	eb 08                	jmp    803c49 <insert_sorted_with_merge_freeList+0x67e>
  803c41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c44:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c4c:	a3 48 51 80 00       	mov    %eax,0x805148
  803c51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c5b:	a1 54 51 80 00       	mov    0x805154,%eax
  803c60:	40                   	inc    %eax
  803c61:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c66:	e9 a9 00 00 00       	jmp    803d14 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c6f:	74 06                	je     803c77 <insert_sorted_with_merge_freeList+0x6ac>
  803c71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c75:	75 17                	jne    803c8e <insert_sorted_with_merge_freeList+0x6c3>
  803c77:	83 ec 04             	sub    $0x4,%esp
  803c7a:	68 74 48 80 00       	push   $0x804874
  803c7f:	68 73 01 00 00       	push   $0x173
  803c84:	68 ff 47 80 00       	push   $0x8047ff
  803c89:	e8 b6 cf ff ff       	call   800c44 <_panic>
  803c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c91:	8b 10                	mov    (%eax),%edx
  803c93:	8b 45 08             	mov    0x8(%ebp),%eax
  803c96:	89 10                	mov    %edx,(%eax)
  803c98:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9b:	8b 00                	mov    (%eax),%eax
  803c9d:	85 c0                	test   %eax,%eax
  803c9f:	74 0b                	je     803cac <insert_sorted_with_merge_freeList+0x6e1>
  803ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca4:	8b 00                	mov    (%eax),%eax
  803ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  803ca9:	89 50 04             	mov    %edx,0x4(%eax)
  803cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803caf:	8b 55 08             	mov    0x8(%ebp),%edx
  803cb2:	89 10                	mov    %edx,(%eax)
  803cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cba:	89 50 04             	mov    %edx,0x4(%eax)
  803cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc0:	8b 00                	mov    (%eax),%eax
  803cc2:	85 c0                	test   %eax,%eax
  803cc4:	75 08                	jne    803cce <insert_sorted_with_merge_freeList+0x703>
  803cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803cce:	a1 44 51 80 00       	mov    0x805144,%eax
  803cd3:	40                   	inc    %eax
  803cd4:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803cd9:	eb 39                	jmp    803d14 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803cdb:	a1 40 51 80 00       	mov    0x805140,%eax
  803ce0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ce3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ce7:	74 07                	je     803cf0 <insert_sorted_with_merge_freeList+0x725>
  803ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cec:	8b 00                	mov    (%eax),%eax
  803cee:	eb 05                	jmp    803cf5 <insert_sorted_with_merge_freeList+0x72a>
  803cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf5:	a3 40 51 80 00       	mov    %eax,0x805140
  803cfa:	a1 40 51 80 00       	mov    0x805140,%eax
  803cff:	85 c0                	test   %eax,%eax
  803d01:	0f 85 c7 fb ff ff    	jne    8038ce <insert_sorted_with_merge_freeList+0x303>
  803d07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d0b:	0f 85 bd fb ff ff    	jne    8038ce <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d11:	eb 01                	jmp    803d14 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803d13:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d14:	90                   	nop
  803d15:	c9                   	leave  
  803d16:	c3                   	ret    
  803d17:	90                   	nop

00803d18 <__udivdi3>:
  803d18:	55                   	push   %ebp
  803d19:	57                   	push   %edi
  803d1a:	56                   	push   %esi
  803d1b:	53                   	push   %ebx
  803d1c:	83 ec 1c             	sub    $0x1c,%esp
  803d1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d2f:	89 ca                	mov    %ecx,%edx
  803d31:	89 f8                	mov    %edi,%eax
  803d33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d37:	85 f6                	test   %esi,%esi
  803d39:	75 2d                	jne    803d68 <__udivdi3+0x50>
  803d3b:	39 cf                	cmp    %ecx,%edi
  803d3d:	77 65                	ja     803da4 <__udivdi3+0x8c>
  803d3f:	89 fd                	mov    %edi,%ebp
  803d41:	85 ff                	test   %edi,%edi
  803d43:	75 0b                	jne    803d50 <__udivdi3+0x38>
  803d45:	b8 01 00 00 00       	mov    $0x1,%eax
  803d4a:	31 d2                	xor    %edx,%edx
  803d4c:	f7 f7                	div    %edi
  803d4e:	89 c5                	mov    %eax,%ebp
  803d50:	31 d2                	xor    %edx,%edx
  803d52:	89 c8                	mov    %ecx,%eax
  803d54:	f7 f5                	div    %ebp
  803d56:	89 c1                	mov    %eax,%ecx
  803d58:	89 d8                	mov    %ebx,%eax
  803d5a:	f7 f5                	div    %ebp
  803d5c:	89 cf                	mov    %ecx,%edi
  803d5e:	89 fa                	mov    %edi,%edx
  803d60:	83 c4 1c             	add    $0x1c,%esp
  803d63:	5b                   	pop    %ebx
  803d64:	5e                   	pop    %esi
  803d65:	5f                   	pop    %edi
  803d66:	5d                   	pop    %ebp
  803d67:	c3                   	ret    
  803d68:	39 ce                	cmp    %ecx,%esi
  803d6a:	77 28                	ja     803d94 <__udivdi3+0x7c>
  803d6c:	0f bd fe             	bsr    %esi,%edi
  803d6f:	83 f7 1f             	xor    $0x1f,%edi
  803d72:	75 40                	jne    803db4 <__udivdi3+0x9c>
  803d74:	39 ce                	cmp    %ecx,%esi
  803d76:	72 0a                	jb     803d82 <__udivdi3+0x6a>
  803d78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d7c:	0f 87 9e 00 00 00    	ja     803e20 <__udivdi3+0x108>
  803d82:	b8 01 00 00 00       	mov    $0x1,%eax
  803d87:	89 fa                	mov    %edi,%edx
  803d89:	83 c4 1c             	add    $0x1c,%esp
  803d8c:	5b                   	pop    %ebx
  803d8d:	5e                   	pop    %esi
  803d8e:	5f                   	pop    %edi
  803d8f:	5d                   	pop    %ebp
  803d90:	c3                   	ret    
  803d91:	8d 76 00             	lea    0x0(%esi),%esi
  803d94:	31 ff                	xor    %edi,%edi
  803d96:	31 c0                	xor    %eax,%eax
  803d98:	89 fa                	mov    %edi,%edx
  803d9a:	83 c4 1c             	add    $0x1c,%esp
  803d9d:	5b                   	pop    %ebx
  803d9e:	5e                   	pop    %esi
  803d9f:	5f                   	pop    %edi
  803da0:	5d                   	pop    %ebp
  803da1:	c3                   	ret    
  803da2:	66 90                	xchg   %ax,%ax
  803da4:	89 d8                	mov    %ebx,%eax
  803da6:	f7 f7                	div    %edi
  803da8:	31 ff                	xor    %edi,%edi
  803daa:	89 fa                	mov    %edi,%edx
  803dac:	83 c4 1c             	add    $0x1c,%esp
  803daf:	5b                   	pop    %ebx
  803db0:	5e                   	pop    %esi
  803db1:	5f                   	pop    %edi
  803db2:	5d                   	pop    %ebp
  803db3:	c3                   	ret    
  803db4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803db9:	89 eb                	mov    %ebp,%ebx
  803dbb:	29 fb                	sub    %edi,%ebx
  803dbd:	89 f9                	mov    %edi,%ecx
  803dbf:	d3 e6                	shl    %cl,%esi
  803dc1:	89 c5                	mov    %eax,%ebp
  803dc3:	88 d9                	mov    %bl,%cl
  803dc5:	d3 ed                	shr    %cl,%ebp
  803dc7:	89 e9                	mov    %ebp,%ecx
  803dc9:	09 f1                	or     %esi,%ecx
  803dcb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803dcf:	89 f9                	mov    %edi,%ecx
  803dd1:	d3 e0                	shl    %cl,%eax
  803dd3:	89 c5                	mov    %eax,%ebp
  803dd5:	89 d6                	mov    %edx,%esi
  803dd7:	88 d9                	mov    %bl,%cl
  803dd9:	d3 ee                	shr    %cl,%esi
  803ddb:	89 f9                	mov    %edi,%ecx
  803ddd:	d3 e2                	shl    %cl,%edx
  803ddf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803de3:	88 d9                	mov    %bl,%cl
  803de5:	d3 e8                	shr    %cl,%eax
  803de7:	09 c2                	or     %eax,%edx
  803de9:	89 d0                	mov    %edx,%eax
  803deb:	89 f2                	mov    %esi,%edx
  803ded:	f7 74 24 0c          	divl   0xc(%esp)
  803df1:	89 d6                	mov    %edx,%esi
  803df3:	89 c3                	mov    %eax,%ebx
  803df5:	f7 e5                	mul    %ebp
  803df7:	39 d6                	cmp    %edx,%esi
  803df9:	72 19                	jb     803e14 <__udivdi3+0xfc>
  803dfb:	74 0b                	je     803e08 <__udivdi3+0xf0>
  803dfd:	89 d8                	mov    %ebx,%eax
  803dff:	31 ff                	xor    %edi,%edi
  803e01:	e9 58 ff ff ff       	jmp    803d5e <__udivdi3+0x46>
  803e06:	66 90                	xchg   %ax,%ax
  803e08:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e0c:	89 f9                	mov    %edi,%ecx
  803e0e:	d3 e2                	shl    %cl,%edx
  803e10:	39 c2                	cmp    %eax,%edx
  803e12:	73 e9                	jae    803dfd <__udivdi3+0xe5>
  803e14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e17:	31 ff                	xor    %edi,%edi
  803e19:	e9 40 ff ff ff       	jmp    803d5e <__udivdi3+0x46>
  803e1e:	66 90                	xchg   %ax,%ax
  803e20:	31 c0                	xor    %eax,%eax
  803e22:	e9 37 ff ff ff       	jmp    803d5e <__udivdi3+0x46>
  803e27:	90                   	nop

00803e28 <__umoddi3>:
  803e28:	55                   	push   %ebp
  803e29:	57                   	push   %edi
  803e2a:	56                   	push   %esi
  803e2b:	53                   	push   %ebx
  803e2c:	83 ec 1c             	sub    $0x1c,%esp
  803e2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e33:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e47:	89 f3                	mov    %esi,%ebx
  803e49:	89 fa                	mov    %edi,%edx
  803e4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e4f:	89 34 24             	mov    %esi,(%esp)
  803e52:	85 c0                	test   %eax,%eax
  803e54:	75 1a                	jne    803e70 <__umoddi3+0x48>
  803e56:	39 f7                	cmp    %esi,%edi
  803e58:	0f 86 a2 00 00 00    	jbe    803f00 <__umoddi3+0xd8>
  803e5e:	89 c8                	mov    %ecx,%eax
  803e60:	89 f2                	mov    %esi,%edx
  803e62:	f7 f7                	div    %edi
  803e64:	89 d0                	mov    %edx,%eax
  803e66:	31 d2                	xor    %edx,%edx
  803e68:	83 c4 1c             	add    $0x1c,%esp
  803e6b:	5b                   	pop    %ebx
  803e6c:	5e                   	pop    %esi
  803e6d:	5f                   	pop    %edi
  803e6e:	5d                   	pop    %ebp
  803e6f:	c3                   	ret    
  803e70:	39 f0                	cmp    %esi,%eax
  803e72:	0f 87 ac 00 00 00    	ja     803f24 <__umoddi3+0xfc>
  803e78:	0f bd e8             	bsr    %eax,%ebp
  803e7b:	83 f5 1f             	xor    $0x1f,%ebp
  803e7e:	0f 84 ac 00 00 00    	je     803f30 <__umoddi3+0x108>
  803e84:	bf 20 00 00 00       	mov    $0x20,%edi
  803e89:	29 ef                	sub    %ebp,%edi
  803e8b:	89 fe                	mov    %edi,%esi
  803e8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e91:	89 e9                	mov    %ebp,%ecx
  803e93:	d3 e0                	shl    %cl,%eax
  803e95:	89 d7                	mov    %edx,%edi
  803e97:	89 f1                	mov    %esi,%ecx
  803e99:	d3 ef                	shr    %cl,%edi
  803e9b:	09 c7                	or     %eax,%edi
  803e9d:	89 e9                	mov    %ebp,%ecx
  803e9f:	d3 e2                	shl    %cl,%edx
  803ea1:	89 14 24             	mov    %edx,(%esp)
  803ea4:	89 d8                	mov    %ebx,%eax
  803ea6:	d3 e0                	shl    %cl,%eax
  803ea8:	89 c2                	mov    %eax,%edx
  803eaa:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eae:	d3 e0                	shl    %cl,%eax
  803eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803eb4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eb8:	89 f1                	mov    %esi,%ecx
  803eba:	d3 e8                	shr    %cl,%eax
  803ebc:	09 d0                	or     %edx,%eax
  803ebe:	d3 eb                	shr    %cl,%ebx
  803ec0:	89 da                	mov    %ebx,%edx
  803ec2:	f7 f7                	div    %edi
  803ec4:	89 d3                	mov    %edx,%ebx
  803ec6:	f7 24 24             	mull   (%esp)
  803ec9:	89 c6                	mov    %eax,%esi
  803ecb:	89 d1                	mov    %edx,%ecx
  803ecd:	39 d3                	cmp    %edx,%ebx
  803ecf:	0f 82 87 00 00 00    	jb     803f5c <__umoddi3+0x134>
  803ed5:	0f 84 91 00 00 00    	je     803f6c <__umoddi3+0x144>
  803edb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803edf:	29 f2                	sub    %esi,%edx
  803ee1:	19 cb                	sbb    %ecx,%ebx
  803ee3:	89 d8                	mov    %ebx,%eax
  803ee5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ee9:	d3 e0                	shl    %cl,%eax
  803eeb:	89 e9                	mov    %ebp,%ecx
  803eed:	d3 ea                	shr    %cl,%edx
  803eef:	09 d0                	or     %edx,%eax
  803ef1:	89 e9                	mov    %ebp,%ecx
  803ef3:	d3 eb                	shr    %cl,%ebx
  803ef5:	89 da                	mov    %ebx,%edx
  803ef7:	83 c4 1c             	add    $0x1c,%esp
  803efa:	5b                   	pop    %ebx
  803efb:	5e                   	pop    %esi
  803efc:	5f                   	pop    %edi
  803efd:	5d                   	pop    %ebp
  803efe:	c3                   	ret    
  803eff:	90                   	nop
  803f00:	89 fd                	mov    %edi,%ebp
  803f02:	85 ff                	test   %edi,%edi
  803f04:	75 0b                	jne    803f11 <__umoddi3+0xe9>
  803f06:	b8 01 00 00 00       	mov    $0x1,%eax
  803f0b:	31 d2                	xor    %edx,%edx
  803f0d:	f7 f7                	div    %edi
  803f0f:	89 c5                	mov    %eax,%ebp
  803f11:	89 f0                	mov    %esi,%eax
  803f13:	31 d2                	xor    %edx,%edx
  803f15:	f7 f5                	div    %ebp
  803f17:	89 c8                	mov    %ecx,%eax
  803f19:	f7 f5                	div    %ebp
  803f1b:	89 d0                	mov    %edx,%eax
  803f1d:	e9 44 ff ff ff       	jmp    803e66 <__umoddi3+0x3e>
  803f22:	66 90                	xchg   %ax,%ax
  803f24:	89 c8                	mov    %ecx,%eax
  803f26:	89 f2                	mov    %esi,%edx
  803f28:	83 c4 1c             	add    $0x1c,%esp
  803f2b:	5b                   	pop    %ebx
  803f2c:	5e                   	pop    %esi
  803f2d:	5f                   	pop    %edi
  803f2e:	5d                   	pop    %ebp
  803f2f:	c3                   	ret    
  803f30:	3b 04 24             	cmp    (%esp),%eax
  803f33:	72 06                	jb     803f3b <__umoddi3+0x113>
  803f35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f39:	77 0f                	ja     803f4a <__umoddi3+0x122>
  803f3b:	89 f2                	mov    %esi,%edx
  803f3d:	29 f9                	sub    %edi,%ecx
  803f3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f43:	89 14 24             	mov    %edx,(%esp)
  803f46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f4e:	8b 14 24             	mov    (%esp),%edx
  803f51:	83 c4 1c             	add    $0x1c,%esp
  803f54:	5b                   	pop    %ebx
  803f55:	5e                   	pop    %esi
  803f56:	5f                   	pop    %edi
  803f57:	5d                   	pop    %ebp
  803f58:	c3                   	ret    
  803f59:	8d 76 00             	lea    0x0(%esi),%esi
  803f5c:	2b 04 24             	sub    (%esp),%eax
  803f5f:	19 fa                	sbb    %edi,%edx
  803f61:	89 d1                	mov    %edx,%ecx
  803f63:	89 c6                	mov    %eax,%esi
  803f65:	e9 71 ff ff ff       	jmp    803edb <__umoddi3+0xb3>
  803f6a:	66 90                	xchg   %ax,%ax
  803f6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f70:	72 ea                	jb     803f5c <__umoddi3+0x134>
  803f72:	89 d9                	mov    %ebx,%ecx
  803f74:	e9 62 ff ff ff       	jmp    803edb <__umoddi3+0xb3>
