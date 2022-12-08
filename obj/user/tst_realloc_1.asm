
obj/user/tst_realloc_1:     file format elf32-i386


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
  800031:	e8 38 11 00 00       	call   80116e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 c4 80             	add    $0xffffff80,%esp
	int Mega = 1024*1024;
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 55 80             	lea    -0x80(%ebp),%edx
  800051:	b9 14 00 00 00       	mov    $0x14,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 40 45 80 00       	push   $0x804540
  800067:	e8 f2 14 00 00       	call   80155e <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 92 26 00 00       	call   802706 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 2a 27 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  80007f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800082:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800085:	83 ec 0c             	sub    $0xc,%esp
  800088:	50                   	push   %eax
  800089:	e8 58 24 00 00       	call   8024e6 <malloc>
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800094:	8b 45 80             	mov    -0x80(%ebp),%eax
  800097:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80009c:	74 14                	je     8000b2 <_main+0x7a>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	68 64 45 80 00       	push   $0x804564
  8000a6:	6a 11                	push   $0x11
  8000a8:	68 94 45 80 00       	push   $0x804594
  8000ad:	e8 f8 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000b5:	e8 4c 26 00 00       	call   802706 <sys_calculate_free_frames>
  8000ba:	29 c3                	sub    %eax,%ebx
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 ac 45 80 00       	push   $0x8045ac
  8000cb:	6a 13                	push   $0x13
  8000cd:	68 94 45 80 00       	push   $0x804594
  8000d2:	e8 d3 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256)panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 ca 26 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  8000dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 18 46 80 00       	push   $0x804618
  8000ee:	6a 14                	push   $0x14
  8000f0:	68 94 45 80 00       	push   $0x804594
  8000f5:	e8 b0 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000fa:	e8 07 26 00 00       	call   802706 <sys_calculate_free_frames>
  8000ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800102:	e8 9f 26 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80010a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 cd 23 00 00       	call   8024e6 <malloc>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80011f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800122:	89 c2                	mov    %eax,%edx
  800124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800127:	05 00 00 00 80       	add    $0x80000000,%eax
  80012c:	39 c2                	cmp    %eax,%edx
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 64 45 80 00       	push   $0x804564
  800138:	6a 19                	push   $0x19
  80013a:	68 94 45 80 00       	push   $0x804594
  80013f:	e8 66 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800144:	e8 bd 25 00 00       	call   802706 <sys_calculate_free_frames>
  800149:	89 c2                	mov    %eax,%edx
  80014b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014e:	39 c2                	cmp    %eax,%edx
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 ac 45 80 00       	push   $0x8045ac
  80015a:	6a 1b                	push   $0x1b
  80015c:	68 94 45 80 00       	push   $0x804594
  800161:	e8 44 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800166:	e8 3b 26 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  80016b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80016e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 18 46 80 00       	push   $0x804618
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 94 45 80 00       	push   $0x804594
  800184:	e8 21 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800189:	e8 78 25 00 00       	call   802706 <sys_calculate_free_frames>
  80018e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800191:	e8 10 26 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80019c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	50                   	push   %eax
  8001a3:	e8 3e 23 00 00       	call   8024e6 <malloc>
  8001a8:	83 c4 10             	add    $0x10,%esp
  8001ab:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001ae:	8b 45 88             	mov    -0x78(%ebp),%eax
  8001b1:	89 c2                	mov    %eax,%edx
  8001b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b6:	01 c0                	add    %eax,%eax
  8001b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 64 45 80 00       	push   $0x804564
  8001c9:	6a 21                	push   $0x21
  8001cb:	68 94 45 80 00       	push   $0x804594
  8001d0:	e8 d5 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001d5:	e8 2c 25 00 00       	call   802706 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 ac 45 80 00       	push   $0x8045ac
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 94 45 80 00       	push   $0x804594
  8001f2:	e8 b3 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8001f7:	e8 aa 25 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  8001fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 18 46 80 00       	push   $0x804618
  80020e:	6a 24                	push   $0x24
  800210:	68 94 45 80 00       	push   $0x804594
  800215:	e8 90 10 00 00       	call   8012aa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80021a:	e8 e7 24 00 00       	call   802706 <sys_calculate_free_frames>
  80021f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800222:	e8 7f 25 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  80022a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80022d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	50                   	push   %eax
  800234:	e8 ad 22 00 00       	call   8024e6 <malloc>
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80023f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800242:	89 c1                	mov    %eax,%ecx
  800244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800247:	89 c2                	mov    %eax,%edx
  800249:	01 d2                	add    %edx,%edx
  80024b:	01 d0                	add    %edx,%eax
  80024d:	05 00 00 00 80       	add    $0x80000000,%eax
  800252:	39 c1                	cmp    %eax,%ecx
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 64 45 80 00       	push   $0x804564
  80025e:	6a 2a                	push   $0x2a
  800260:	68 94 45 80 00       	push   $0x804594
  800265:	e8 40 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026a:	e8 97 24 00 00       	call   802706 <sys_calculate_free_frames>
  80026f:	89 c2                	mov    %eax,%edx
  800271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 ac 45 80 00       	push   $0x8045ac
  800280:	6a 2c                	push   $0x2c
  800282:	68 94 45 80 00       	push   $0x804594
  800287:	e8 1e 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80028c:	e8 15 25 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	3d 00 01 00 00       	cmp    $0x100,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 18 46 80 00       	push   $0x804618
  8002a3:	6a 2d                	push   $0x2d
  8002a5:	68 94 45 80 00       	push   $0x804594
  8002aa:	e8 fb 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 52 24 00 00       	call   802706 <sys_calculate_free_frames>
  8002b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 ea 24 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  8002bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	50                   	push   %eax
  8002cb:	e8 16 22 00 00       	call   8024e6 <malloc>
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002d6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002d9:	89 c2                	mov    %eax,%edx
  8002db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002de:	c1 e0 02             	shl    $0x2,%eax
  8002e1:	05 00 00 00 80       	add    $0x80000000,%eax
  8002e6:	39 c2                	cmp    %eax,%edx
  8002e8:	74 14                	je     8002fe <_main+0x2c6>
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	68 64 45 80 00       	push   $0x804564
  8002f2:	6a 33                	push   $0x33
  8002f4:	68 94 45 80 00       	push   $0x804594
  8002f9:	e8 ac 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800301:	e8 00 24 00 00       	call   802706 <sys_calculate_free_frames>
  800306:	29 c3                	sub    %eax,%ebx
  800308:	89 d8                	mov    %ebx,%eax
  80030a:	83 f8 01             	cmp    $0x1,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 ac 45 80 00       	push   $0x8045ac
  800317:	6a 35                	push   $0x35
  800319:	68 94 45 80 00       	push   $0x804594
  80031e:	e8 87 0f 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800323:	e8 7e 24 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800328:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 18 46 80 00       	push   $0x804618
  80033a:	6a 36                	push   $0x36
  80033c:	68 94 45 80 00       	push   $0x804594
  800341:	e8 64 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800346:	e8 bb 23 00 00       	call   802706 <sys_calculate_free_frames>
  80034b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80034e:	e8 53 24 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800359:	01 c0                	add    %eax,%eax
  80035b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80035e:	83 ec 0c             	sub    $0xc,%esp
  800361:	50                   	push   %eax
  800362:	e8 7f 21 00 00       	call   8024e6 <malloc>
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80036d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800370:	89 c1                	mov    %eax,%ecx
  800372:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800375:	89 d0                	mov    %edx,%eax
  800377:	01 c0                	add    %eax,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	05 00 00 00 80       	add    $0x80000000,%eax
  800382:	39 c1                	cmp    %eax,%ecx
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 64 45 80 00       	push   $0x804564
  80038e:	6a 3c                	push   $0x3c
  800390:	68 94 45 80 00       	push   $0x804594
  800395:	e8 10 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039a:	e8 67 23 00 00       	call   802706 <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 ac 45 80 00       	push   $0x8045ac
  8003b0:	6a 3e                	push   $0x3e
  8003b2:	68 94 45 80 00       	push   $0x804594
  8003b7:	e8 ee 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003bc:	e8 e5 23 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  8003c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 18 46 80 00       	push   $0x804618
  8003d3:	6a 3f                	push   $0x3f
  8003d5:	68 94 45 80 00       	push   $0x804594
  8003da:	e8 cb 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 22 23 00 00       	call   802706 <sys_calculate_free_frames>
  8003e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 ba 23 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	01 d2                	add    %edx,%edx
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003fb:	83 ec 0c             	sub    $0xc,%esp
  8003fe:	50                   	push   %eax
  8003ff:	e8 e2 20 00 00       	call   8024e6 <malloc>
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80040a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800412:	c1 e0 03             	shl    $0x3,%eax
  800415:	05 00 00 00 80       	add    $0x80000000,%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	74 14                	je     800432 <_main+0x3fa>
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	68 64 45 80 00       	push   $0x804564
  800426:	6a 45                	push   $0x45
  800428:	68 94 45 80 00       	push   $0x804594
  80042d:	e8 78 0e 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800432:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800435:	e8 cc 22 00 00       	call   802706 <sys_calculate_free_frames>
  80043a:	29 c3                	sub    %eax,%ebx
  80043c:	89 d8                	mov    %ebx,%eax
  80043e:	83 f8 01             	cmp    $0x1,%eax
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 ac 45 80 00       	push   $0x8045ac
  80044b:	6a 47                	push   $0x47
  80044d:	68 94 45 80 00       	push   $0x804594
  800452:	e8 53 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800457:	e8 4a 23 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  80045c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80045f:	3d 00 03 00 00       	cmp    $0x300,%eax
  800464:	74 14                	je     80047a <_main+0x442>
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 18 46 80 00       	push   $0x804618
  80046e:	6a 48                	push   $0x48
  800470:	68 94 45 80 00       	push   $0x804594
  800475:	e8 30 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80047a:	e8 87 22 00 00       	call   802706 <sys_calculate_free_frames>
  80047f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800482:	e8 1f 23 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048d:	89 c2                	mov    %eax,%edx
  80048f:	01 d2                	add    %edx,%edx
  800491:	01 d0                	add    %edx,%eax
  800493:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 47 20 00 00       	call   8024e6 <malloc>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004a5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004a8:	89 c1                	mov    %eax,%ecx
  8004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8004ad:	89 d0                	mov    %edx,%eax
  8004af:	c1 e0 02             	shl    $0x2,%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	01 c0                	add    %eax,%eax
  8004b6:	01 d0                	add    %edx,%eax
  8004b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8004bd:	39 c1                	cmp    %eax,%ecx
  8004bf:	74 14                	je     8004d5 <_main+0x49d>
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	68 64 45 80 00       	push   $0x804564
  8004c9:	6a 4e                	push   $0x4e
  8004cb:	68 94 45 80 00       	push   $0x804594
  8004d0:	e8 d5 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8004d8:	e8 29 22 00 00       	call   802706 <sys_calculate_free_frames>
  8004dd:	29 c3                	sub    %eax,%ebx
  8004df:	89 d8                	mov    %ebx,%eax
  8004e1:	83 f8 01             	cmp    $0x1,%eax
  8004e4:	74 14                	je     8004fa <_main+0x4c2>
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 ac 45 80 00       	push   $0x8045ac
  8004ee:	6a 50                	push   $0x50
  8004f0:	68 94 45 80 00       	push   $0x804594
  8004f5:	e8 b0 0d 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8004fa:	e8 a7 22 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  8004ff:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800502:	3d 00 03 00 00       	cmp    $0x300,%eax
  800507:	74 14                	je     80051d <_main+0x4e5>
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 18 46 80 00       	push   $0x804618
  800511:	6a 51                	push   $0x51
  800513:	68 94 45 80 00       	push   $0x804594
  800518:	e8 8d 0d 00 00       	call   8012aa <_panic>


		//NEW
		//Filling the remaining size of user heap
		freeFrames = sys_calculate_free_frames() ;
  80051d:	e8 e4 21 00 00       	call   802706 <sys_calculate_free_frames>
  800522:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800525:	e8 7c 22 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  80052a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		uint32 remainingSpaceInUHeap = (USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega;
  80052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d0                	add    %edx,%eax
  80053a:	01 c0                	add    %eax,%eax
  80053c:	f7 d8                	neg    %eax
  80053e:	05 00 00 00 20       	add    $0x20000000,%eax
  800543:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(remainingSpaceInUHeap - kilo);
  800546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800549:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054c:	29 c2                	sub    %eax,%edx
  80054e:	89 d0                	mov    %edx,%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 8d 1f 00 00       	call   8024e6 <malloc>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80055f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800562:	89 c1                	mov    %eax,%ecx
  800564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800567:	89 d0                	mov    %edx,%eax
  800569:	01 c0                	add    %eax,%eax
  80056b:	01 d0                	add    %edx,%eax
  80056d:	01 c0                	add    %eax,%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	01 c0                	add    %eax,%eax
  800573:	05 00 00 00 80       	add    $0x80000000,%eax
  800578:	39 c1                	cmp    %eax,%ecx
  80057a:	74 14                	je     800590 <_main+0x558>
  80057c:	83 ec 04             	sub    $0x4,%esp
  80057f:	68 64 45 80 00       	push   $0x804564
  800584:	6a 5a                	push   $0x5a
  800586:	68 94 45 80 00       	push   $0x804594
  80058b:	e8 1a 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800590:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800593:	e8 6e 21 00 00       	call   802706 <sys_calculate_free_frames>
  800598:	29 c3                	sub    %eax,%ebx
  80059a:	89 d8                	mov    %ebx,%eax
  80059c:	83 f8 7c             	cmp    $0x7c,%eax
  80059f:	74 14                	je     8005b5 <_main+0x57d>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 ac 45 80 00       	push   $0x8045ac
  8005a9:	6a 5c                	push   $0x5c
  8005ab:	68 94 45 80 00       	push   $0x804594
  8005b0:	e8 f5 0c 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005b5:	e8 ec 21 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  8005ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8005bd:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 18 46 80 00       	push   $0x804618
  8005cc:	6a 5d                	push   $0x5d
  8005ce:	68 94 45 80 00       	push   $0x804594
  8005d3:	e8 d2 0c 00 00       	call   8012aa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 29 21 00 00       	call   802706 <sys_calculate_free_frames>
  8005dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e0:	e8 c1 21 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8005e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	50                   	push   %eax
  8005ef:	e8 20 1f 00 00       	call   802514 <free>
  8005f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005f7:	e8 aa 21 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  8005fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
  800601:	89 d0                	mov    %edx,%eax
  800603:	3d 00 01 00 00       	cmp    $0x100,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 48 46 80 00       	push   $0x804648
  800612:	6a 68                	push   $0x68
  800614:	68 94 45 80 00       	push   $0x804594
  800619:	e8 8c 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80061e:	e8 e3 20 00 00       	call   802706 <sys_calculate_free_frames>
  800623:	89 c2                	mov    %eax,%edx
  800625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	74 14                	je     800640 <_main+0x608>
  80062c:	83 ec 04             	sub    $0x4,%esp
  80062f:	68 84 46 80 00       	push   $0x804684
  800634:	6a 69                	push   $0x69
  800636:	68 94 45 80 00       	push   $0x804594
  80063b:	e8 6a 0c 00 00       	call   8012aa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800640:	e8 c1 20 00 00       	call   802706 <sys_calculate_free_frames>
  800645:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800648:	e8 59 21 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800650:	8b 45 90             	mov    -0x70(%ebp),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	50                   	push   %eax
  800657:	e8 b8 1e 00 00       	call   802514 <free>
  80065c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80065f:	e8 42 21 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800667:	29 c2                	sub    %eax,%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800670:	74 14                	je     800686 <_main+0x64e>
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	68 48 46 80 00       	push   $0x804648
  80067a:	6a 70                	push   $0x70
  80067c:	68 94 45 80 00       	push   $0x804594
  800681:	e8 24 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800686:	e8 7b 20 00 00       	call   802706 <sys_calculate_free_frames>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 84 46 80 00       	push   $0x804684
  80069c:	6a 71                	push   $0x71
  80069e:	68 94 45 80 00       	push   $0x804594
  8006a3:	e8 02 0c 00 00       	call   8012aa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006a8:	e8 59 20 00 00       	call   802706 <sys_calculate_free_frames>
  8006ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006b0:	e8 f1 20 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8006b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	50                   	push   %eax
  8006bf:	e8 50 1e 00 00       	call   802514 <free>
  8006c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006c7:	e8 da 20 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  8006cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cf:	29 c2                	sub    %eax,%edx
  8006d1:	89 d0                	mov    %edx,%eax
  8006d3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006d8:	74 14                	je     8006ee <_main+0x6b6>
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	68 48 46 80 00       	push   $0x804648
  8006e2:	6a 78                	push   $0x78
  8006e4:	68 94 45 80 00       	push   $0x804594
  8006e9:	e8 bc 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006ee:	e8 13 20 00 00       	call   802706 <sys_calculate_free_frames>
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f8:	39 c2                	cmp    %eax,%edx
  8006fa:	74 14                	je     800710 <_main+0x6d8>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 84 46 80 00       	push   $0x804684
  800704:	6a 79                	push   $0x79
  800706:	68 94 45 80 00       	push   $0x804594
  80070b:	e8 9a 0b 00 00       	call   8012aa <_panic>

		//NEW
		//free the latest Hole (the big one)
		freeFrames = sys_calculate_free_frames() ;
  800710:	e8 f1 1f 00 00       	call   802706 <sys_calculate_free_frames>
  800715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800718:	e8 89 20 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  800720:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	50                   	push   %eax
  800727:	e8 e8 1d 00 00       	call   802514 <free>
  80072c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
  80072f:	e8 72 20 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
  800739:	89 d0                	mov    %edx,%eax
  80073b:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  800740:	74 17                	je     800759 <_main+0x721>
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	68 48 46 80 00       	push   $0x804648
  80074a:	68 81 00 00 00       	push   $0x81
  80074f:	68 94 45 80 00       	push   $0x804594
  800754:	e8 51 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800759:	e8 a8 1f 00 00       	call   802706 <sys_calculate_free_frames>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800763:	39 c2                	cmp    %eax,%edx
  800765:	74 17                	je     80077e <_main+0x746>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 84 46 80 00       	push   $0x804684
  80076f:	68 82 00 00 00       	push   $0x82
  800774:	68 94 45 80 00       	push   $0x804594
  800779:	e8 2c 0b 00 00       	call   8012aa <_panic>
	}
	int cnt = 0;
  80077e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800785:	e8 7c 1f 00 00       	call   802706 <sys_calculate_free_frames>
  80078a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80078d:	e8 14 20 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(512*kilo - kilo);
  800795:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800798:	89 d0                	mov    %edx,%eax
  80079a:	c1 e0 09             	shl    $0x9,%eax
  80079d:	29 d0                	sub    %edx,%eax
  80079f:	83 ec 0c             	sub    $0xc,%esp
  8007a2:	50                   	push   %eax
  8007a3:	e8 3e 1d 00 00       	call   8024e6 <malloc>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8007ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8007b1:	89 c2                	mov    %eax,%edx
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 64 45 80 00       	push   $0x804564
  8007c7:	68 8e 00 00 00       	push   $0x8e
  8007cc:	68 94 45 80 00       	push   $0x804594
  8007d1:	e8 d4 0a 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8007d6:	e8 2b 1f 00 00       	call   802706 <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 ac 45 80 00       	push   $0x8045ac
  8007ec:	68 90 00 00 00       	push   $0x90
  8007f1:	68 94 45 80 00       	push   $0x804594
  8007f6:	e8 af 0a 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  8007fb:	e8 a6 1f 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800800:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800803:	3d 80 00 00 00       	cmp    $0x80,%eax
  800808:	74 17                	je     800821 <_main+0x7e9>
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 18 46 80 00       	push   $0x804618
  800812:	68 91 00 00 00       	push   $0x91
  800817:	68 94 45 80 00       	push   $0x804594
  80081c:	e8 89 0a 00 00       	call   8012aa <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[9];
  800821:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800824:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int lastIndexOfInt1 = ((512)*kilo)/sizeof(int) - 1;
  800827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082a:	c1 e0 09             	shl    $0x9,%eax
  80082d:	c1 e8 02             	shr    $0x2,%eax
  800830:	48                   	dec    %eax
  800831:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		int i = 0;
  800834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800842:	eb 17                	jmp    80085b <_main+0x823>
		{
			intArr[i] = i ;
  800844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800847:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80084e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800851:	01 c2                	add    %eax,%edx
  800853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800856:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800858:	ff 45 f4             	incl   -0xc(%ebp)
  80085b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80085f:	7e e3                	jle    800844 <_main+0x80c>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800861:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800867:	eb 17                	jmp    800880 <_main+0x848>
		{
			intArr[i] = i ;
  800869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800873:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800876:	01 c2                	add    %eax,%edx
  800878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  80087d:	ff 4d f4             	decl   -0xc(%ebp)
  800880:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800883:	83 e8 64             	sub    $0x64,%eax
  800886:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800889:	7c de                	jl     800869 <_main+0x831>
		{
			intArr[i] = i ;
		}

		//Reallocate it [expanded in the same place]
		freeFrames = sys_calculate_free_frames() ;
  80088b:	e8 76 1e 00 00       	call   802706 <sys_calculate_free_frames>
  800890:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800893:	e8 0e 1f 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 512*kilo + 256*kilo - kilo);
  80089b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80089e:	89 d0                	mov    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d0                	add    %edx,%eax
  8008a4:	c1 e0 08             	shl    $0x8,%eax
  8008a7:	29 d0                	sub    %edx,%eax
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	52                   	push   %edx
  8008b2:	50                   	push   %eax
  8008b3:	e8 cc 1c 00 00       	call   802584 <realloc>
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the re-allocated space... ");
  8008be:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008c1:	89 c2                	mov    %eax,%edx
  8008c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 d0 46 80 00       	push   $0x8046d0
  8008d7:	68 ae 00 00 00       	push   $0xae
  8008dc:	68 94 45 80 00       	push   $0x804594
  8008e1:	e8 c4 09 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008e6:	e8 1b 1e 00 00       	call   802706 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 04 47 80 00       	push   $0x804704
  8008fc:	68 b0 00 00 00       	push   $0xb0
  800901:	68 94 45 80 00       	push   $0x804594
  800906:	e8 9f 09 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are re-allocated in PageFile");
  80090b:	e8 96 1e 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800910:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800913:	83 f8 40             	cmp    $0x40,%eax
  800916:	74 17                	je     80092f <_main+0x8f7>
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 74 47 80 00       	push   $0x804774
  800920:	68 b1 00 00 00       	push   $0xb1
  800925:	68 94 45 80 00       	push   $0x804594
  80092a:	e8 7b 09 00 00       	call   8012aa <_panic>


		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;
  80092f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800932:	89 d0                	mov    %edx,%eax
  800934:	01 c0                	add    %eax,%eax
  800936:	01 d0                	add    %edx,%eax
  800938:	c1 e0 08             	shl    $0x8,%eax
  80093b:	c1 e8 02             	shr    $0x2,%eax
  80093e:	48                   	dec    %eax
  80093f:	89 45 d0             	mov    %eax,-0x30(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800945:	40                   	inc    %eax
  800946:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800949:	eb 17                	jmp    800962 <_main+0x92a>
		{
			intArr[i] = i;
  80094b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800958:	01 c2                	add    %eax,%edx
  80095a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095d:	89 02                	mov    %eax,(%edx)
		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  80095f:	ff 45 f4             	incl   -0xc(%ebp)
  800962:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800965:	83 c0 65             	add    $0x65,%eax
  800968:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80096b:	7f de                	jg     80094b <_main+0x913>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80096d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800970:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800973:	eb 17                	jmp    80098c <_main+0x954>
		{
			intArr[i] = i;
  800975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800978:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800982:	01 c2                	add    %eax,%edx
  800984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800987:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800989:	ff 4d f4             	decl   -0xc(%ebp)
  80098c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80098f:	83 e8 64             	sub    $0x64,%eax
  800992:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800995:	7c de                	jl     800975 <_main+0x93d>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80099e:	eb 30                	jmp    8009d0 <_main+0x998>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ad:	01 d0                	add    %edx,%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009b4:	74 17                	je     8009cd <_main+0x995>
  8009b6:	83 ec 04             	sub    $0x4,%esp
  8009b9:	68 a8 47 80 00       	push   $0x8047a8
  8009be:	68 c6 00 00 00       	push   $0xc6
  8009c3:	68 94 45 80 00       	push   $0x804594
  8009c8:	e8 dd 08 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  8009cd:	ff 45 f4             	incl   -0xc(%ebp)
  8009d0:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  8009d4:	7e ca                	jle    8009a0 <_main+0x968>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  8009d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8009dc:	eb 30                	jmp    800a0e <_main+0x9d6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009eb:	01 d0                	add    %edx,%eax
  8009ed:	8b 00                	mov    (%eax),%eax
  8009ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009f2:	74 17                	je     800a0b <_main+0x9d3>
  8009f4:	83 ec 04             	sub    $0x4,%esp
  8009f7:	68 a8 47 80 00       	push   $0x8047a8
  8009fc:	68 cc 00 00 00       	push   $0xcc
  800a01:	68 94 45 80 00       	push   $0x804594
  800a06:	e8 9f 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800a0b:	ff 4d f4             	decl   -0xc(%ebp)
  800a0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a11:	83 e8 64             	sub    $0x64,%eax
  800a14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a17:	7c c5                	jl     8009de <_main+0x9a6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1c:	40                   	inc    %eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a20:	eb 30                	jmp    800a52 <_main+0xa1a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a2f:	01 d0                	add    %edx,%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 a8 47 80 00       	push   $0x8047a8
  800a40:	68 d2 00 00 00       	push   $0xd2
  800a45:	68 94 45 80 00       	push   $0x804594
  800a4a:	e8 5b 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a4f:	ff 45 f4             	incl   -0xc(%ebp)
  800a52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a55:	83 c0 65             	add    $0x65,%eax
  800a58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a5b:	7f c5                	jg     800a22 <_main+0x9ea>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a63:	eb 30                	jmp    800a95 <_main+0xa5d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a72:	01 d0                	add    %edx,%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a79:	74 17                	je     800a92 <_main+0xa5a>
  800a7b:	83 ec 04             	sub    $0x4,%esp
  800a7e:	68 a8 47 80 00       	push   $0x8047a8
  800a83:	68 d8 00 00 00       	push   $0xd8
  800a88:	68 94 45 80 00       	push   $0x804594
  800a8d:	e8 18 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a92:	ff 4d f4             	decl   -0xc(%ebp)
  800a95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a98:	83 e8 64             	sub    $0x64,%eax
  800a9b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a9e:	7c c5                	jl     800a65 <_main+0xa2d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800aa0:	e8 61 1c 00 00       	call   802706 <sys_calculate_free_frames>
  800aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800aa8:	e8 f9 1c 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800ab0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	50                   	push   %eax
  800ab7:	e8 58 1a 00 00       	call   802514 <free>
  800abc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800abf:	e8 e2 1c 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800ad0:	74 17                	je     800ae9 <_main+0xab1>
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	68 e0 47 80 00       	push   $0x8047e0
  800ada:	68 e0 00 00 00       	push   $0xe0
  800adf:	68 94 45 80 00       	push   $0x804594
  800ae4:	e8 c1 07 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ae9:	e8 18 1c 00 00       	call   802706 <sys_calculate_free_frames>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	83 f8 05             	cmp    $0x5,%eax
  800afa:	74 17                	je     800b13 <_main+0xadb>
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	68 84 46 80 00       	push   $0x804684
  800b04:	68 e1 00 00 00       	push   $0xe1
  800b09:	68 94 45 80 00       	push   $0x804594
  800b0e:	e8 97 07 00 00       	call   8012aa <_panic>

		vcprintf("\b\b\b40%", NULL);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	6a 00                	push   $0x0
  800b18:	68 34 48 80 00       	push   $0x804834
  800b1d:	e8 d1 09 00 00       	call   8014f3 <vcprintf>
  800b22:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800b25:	e8 dc 1b 00 00       	call   802706 <sys_calculate_free_frames>
  800b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b2d:	e8 74 1c 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(1*Mega + 512*kilo - kilo);
  800b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b38:	c1 e0 09             	shl    $0x9,%eax
  800b3b:	89 c2                	mov    %eax,%edx
  800b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800b45:	83 ec 0c             	sub    $0xc,%esp
  800b48:	50                   	push   %eax
  800b49:	e8 98 19 00 00       	call   8024e6 <malloc>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800b54:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5c:	c1 e0 02             	shl    $0x2,%eax
  800b5f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b64:	39 c2                	cmp    %eax,%edx
  800b66:	74 17                	je     800b7f <_main+0xb47>
  800b68:	83 ec 04             	sub    $0x4,%esp
  800b6b:	68 64 45 80 00       	push   $0x804564
  800b70:	68 eb 00 00 00       	push   $0xeb
  800b75:	68 94 45 80 00       	push   $0x804594
  800b7a:	e8 2b 07 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b7f:	e8 82 1b 00 00       	call   802706 <sys_calculate_free_frames>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	74 17                	je     800ba4 <_main+0xb6c>
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	68 ac 45 80 00       	push   $0x8045ac
  800b95:	68 ed 00 00 00       	push   $0xed
  800b9a:	68 94 45 80 00       	push   $0x804594
  800b9f:	e8 06 07 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800ba4:	e8 fd 1b 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800ba9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800bac:	3d 80 01 00 00       	cmp    $0x180,%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 18 46 80 00       	push   $0x804618
  800bbb:	68 ee 00 00 00       	push   $0xee
  800bc0:	68 94 45 80 00       	push   $0x804594
  800bc5:	e8 e0 06 00 00       	call   8012aa <_panic>

		//Fill it with data
		intArr = (int*) ptr_allocations[9];
  800bca:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800bcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c1 e0 09             	shl    $0x9,%eax
  800bd6:	89 c2                	mov    %eax,%edx
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	01 d0                	add    %edx,%eax
  800bdd:	c1 e8 02             	shr    $0x2,%eax
  800be0:	48                   	dec    %eax
  800be1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		i = 0;
  800be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800bf2:	eb 17                	jmp    800c0b <_main+0xbd3>
		{
			intArr[i] = i ;
  800bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c01:	01 c2                	add    %eax,%edx
  800c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c06:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800c08:	ff 45 f4             	incl   -0xc(%ebp)
  800c0b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800c0f:	7e e3                	jle    800bf4 <_main+0xbbc>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c17:	eb 17                	jmp    800c30 <_main+0xbf8>
		{
			intArr[i] = i ;
  800c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c26:	01 c2                	add    %eax,%edx
  800c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c2d:	ff 4d f4             	decl   -0xc(%ebp)
  800c30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c33:	83 e8 64             	sub    $0x64,%eax
  800c36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800c39:	7c de                	jl     800c19 <_main+0xbe1>
		{
			intArr[i] = i ;
		}

		//Reallocate it to 2.5 MB [should be moved to next hole]
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 c6 1a 00 00       	call   802706 <sys_calculate_free_frames>
  800c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 5e 1b 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 1*Mega + 512*kilo + 1*Mega - kilo);
  800c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4e:	c1 e0 09             	shl    $0x9,%eax
  800c51:	89 c2                	mov    %eax,%edx
  800c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c56:	01 c2                	add    %eax,%edx
  800c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5b:	01 d0                	add    %edx,%eax
  800c5d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800c60:	89 c2                	mov    %eax,%edx
  800c62:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	52                   	push   %edx
  800c69:	50                   	push   %eax
  800c6a:	e8 15 19 00 00       	call   802584 <realloc>
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800c75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7d:	c1 e0 03             	shl    $0x3,%eax
  800c80:	05 00 00 00 80       	add    $0x80000000,%eax
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 d0 46 80 00       	push   $0x8046d0
  800c91:	68 07 01 00 00       	push   $0x107
  800c96:	68 94 45 80 00       	push   $0x804594
  800c9b:	e8 0a 06 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");

		//if((sys_calculate_free_frames() - freeFrames) != 3) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  800ca0:	e8 01 1b 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800ca5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cad:	74 17                	je     800cc6 <_main+0xc8e>
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	68 74 47 80 00       	push   $0x804774
  800cb7:	68 0b 01 00 00       	push   $0x10b
  800cbc:	68 94 45 80 00       	push   $0x804594
  800cc1:	e8 e4 05 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (2*Mega + 512*kilo)/sizeof(int) - 1;
  800cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc9:	c1 e0 08             	shl    $0x8,%eax
  800ccc:	89 c2                	mov    %eax,%edx
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	c1 e8 02             	shr    $0x2,%eax
  800cd8:	48                   	dec    %eax
  800cd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[9];
  800cdc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800cdf:	89 45 d8             	mov    %eax,-0x28(%ebp)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ce5:	40                   	inc    %eax
  800ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ce9:	eb 17                	jmp    800d02 <_main+0xcca>
		{
			intArr[i] = i;
  800ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cf5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cf8:	01 c2                	add    %eax,%edx
  800cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfd:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800cff:	ff 45 f4             	incl   -0xc(%ebp)
  800d02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d05:	83 c0 65             	add    $0x65,%eax
  800d08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d0b:	7f de                	jg     800ceb <_main+0xcb3>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d13:	eb 17                	jmp    800d2c <_main+0xcf4>
		{
			intArr[i] = i;
  800d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d22:	01 c2                	add    %eax,%edx
  800d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d27:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d29:	ff 4d f4             	decl   -0xc(%ebp)
  800d2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d2f:	83 e8 64             	sub    $0x64,%eax
  800d32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d35:	7c de                	jl     800d15 <_main+0xcdd>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800d3e:	eb 30                	jmp    800d70 <_main+0xd38>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d54:	74 17                	je     800d6d <_main+0xd35>
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	68 a8 47 80 00       	push   $0x8047a8
  800d5e:	68 22 01 00 00       	push   $0x122
  800d63:	68 94 45 80 00       	push   $0x804594
  800d68:	e8 3d 05 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
  800d70:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800d74:	7e ca                	jle    800d40 <_main+0xd08>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7c:	eb 30                	jmp    800dae <_main+0xd76>
		{
			if (intArr[i] != i)
  800d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d8b:	01 d0                	add    %edx,%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d92:	74 17                	je     800dab <_main+0xd73>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800d94:	83 ec 04             	sub    $0x4,%esp
  800d97:	68 a8 47 80 00       	push   $0x8047a8
  800d9c:	68 2a 01 00 00       	push   $0x12a
  800da1:	68 94 45 80 00       	push   $0x804594
  800da6:	e8 ff 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800dab:	ff 4d f4             	decl   -0xc(%ebp)
  800dae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db1:	83 e8 64             	sub    $0x64,%eax
  800db4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800db7:	7c c5                	jl     800d7e <_main+0xd46>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dbc:	40                   	inc    %eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dc0:	eb 30                	jmp    800df2 <_main+0xdba>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dcc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dcf:	01 d0                	add    %edx,%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dd6:	74 17                	je     800def <_main+0xdb7>
  800dd8:	83 ec 04             	sub    $0x4,%esp
  800ddb:	68 a8 47 80 00       	push   $0x8047a8
  800de0:	68 31 01 00 00       	push   $0x131
  800de5:	68 94 45 80 00       	push   $0x804594
  800dea:	e8 bb 04 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800def:	ff 45 f4             	incl   -0xc(%ebp)
  800df2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800df5:	83 c0 65             	add    $0x65,%eax
  800df8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dfb:	7f c5                	jg     800dc2 <_main+0xd8a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800dfd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e03:	eb 30                	jmp    800e35 <_main+0xdfd>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e12:	01 d0                	add    %edx,%eax
  800e14:	8b 00                	mov    (%eax),%eax
  800e16:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e19:	74 17                	je     800e32 <_main+0xdfa>
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	68 a8 47 80 00       	push   $0x8047a8
  800e23:	68 37 01 00 00       	push   $0x137
  800e28:	68 94 45 80 00       	push   $0x804594
  800e2d:	e8 78 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800e32:	ff 4d f4             	decl   -0xc(%ebp)
  800e35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e38:	83 e8 64             	sub    $0x64,%eax
  800e3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e3e:	7c c5                	jl     800e05 <_main+0xdcd>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800e40:	e8 c1 18 00 00       	call   802706 <sys_calculate_free_frames>
  800e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e48:	e8 59 19 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800e50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	e8 b8 16 00 00       	call   802514 <free>
  800e5c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e5f:	e8 42 19 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	3d 80 02 00 00       	cmp    $0x280,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 e0 47 80 00       	push   $0x8047e0
  800e7a:	68 40 01 00 00       	push   $0x140
  800e7f:	68 94 45 80 00       	push   $0x804594
  800e84:	e8 21 04 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b70%", NULL);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	6a 00                	push   $0x0
  800e8e:	68 3b 48 80 00       	push   $0x80483b
  800e93:	e8 5b 06 00 00       	call   8014f3 <vcprintf>
  800e98:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate that's not fit in the same location*/

		//Fill it with data
		intArr = (int*) ptr_allocations[0];
  800e9b:	8b 45 80             	mov    -0x80(%ebp),%eax
  800e9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	c1 e8 02             	shr    $0x2,%eax
  800ea7:	48                   	dec    %eax
  800ea8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		i = 0;
  800eab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800eb9:	eb 17                	jmp    800ed2 <_main+0xe9a>
		{
			intArr[i] = i ;
  800ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ec5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ec8:	01 c2                	add    %eax,%edx
  800eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecd:	89 02                	mov    %eax,(%edx)

		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800ecf:	ff 45 f4             	incl   -0xc(%ebp)
  800ed2:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800ed6:	7e e3                	jle    800ebb <_main+0xe83>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ed8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ede:	eb 17                	jmp    800ef7 <_main+0xebf>
		{
			intArr[i] = i ;
  800ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800eed:	01 c2                	add    %eax,%edx
  800eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ef4:	ff 4d f4             	decl   -0xc(%ebp)
  800ef7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800efa:	83 e8 64             	sub    $0x64,%eax
  800efd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f00:	7c de                	jl     800ee0 <_main+0xea8>
			intArr[i] = i ;
		}


		//Reallocate it to 4 MB [should be moved to last hole]
		freeFrames = sys_calculate_free_frames() ;
  800f02:	e8 ff 17 00 00       	call   802706 <sys_calculate_free_frames>
  800f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f0a:	e8 97 18 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 1*Mega + 3*Mega - kilo);
  800f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f15:	c1 e0 02             	shl    $0x2,%eax
  800f18:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800f1b:	89 c2                	mov    %eax,%edx
  800f1d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	52                   	push   %edx
  800f24:	50                   	push   %eax
  800f25:	e8 5a 16 00 00       	call   802584 <realloc>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	89 45 80             	mov    %eax,-0x80(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the re-allocated space... ");
  800f30:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f33:	89 c1                	mov    %eax,%ecx
  800f35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f38:	89 d0                	mov    %edx,%eax
  800f3a:	01 c0                	add    %eax,%eax
  800f3c:	01 d0                	add    %edx,%eax
  800f3e:	01 c0                	add    %eax,%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	01 c0                	add    %eax,%eax
  800f44:	05 00 00 00 80       	add    $0x80000000,%eax
  800f49:	39 c1                	cmp    %eax,%ecx
  800f4b:	74 17                	je     800f64 <_main+0xf2c>
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	68 d0 46 80 00       	push   $0x8046d0
  800f55:	68 60 01 00 00       	push   $0x160
  800f5a:	68 94 45 80 00       	push   $0x804594
  800f5f:	e8 46 03 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are re-allocated in PageFile");
  800f64:	e8 3d 18 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  800f69:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f6c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800f71:	74 17                	je     800f8a <_main+0xf52>
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 74 47 80 00       	push   $0x804774
  800f7b:	68 63 01 00 00       	push   $0x163
  800f80:	68 94 45 80 00       	push   $0x804594
  800f85:	e8 20 03 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
  800f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8d:	c1 e0 02             	shl    $0x2,%eax
  800f90:	c1 e8 02             	shr    $0x2,%eax
  800f93:	48                   	dec    %eax
  800f94:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[0];
  800f97:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f9a:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fa0:	40                   	inc    %eax
  800fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa4:	eb 17                	jmp    800fbd <_main+0xf85>
		{
			intArr[i] = i;
  800fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fb3:	01 c2                	add    %eax,%edx
  800fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb8:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[0];

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800fba:	ff 45 f4             	incl   -0xc(%ebp)
  800fbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fc0:	83 c0 65             	add    $0x65,%eax
  800fc3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fc6:	7f de                	jg     800fa6 <_main+0xf6e>
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fce:	eb 17                	jmp    800fe7 <_main+0xfaf>
		{
			intArr[i] = i;
  800fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fdd:	01 c2                	add    %eax,%edx
  800fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fe4:	ff 4d f4             	decl   -0xc(%ebp)
  800fe7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fea:	83 e8 64             	sub    $0x64,%eax
  800fed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff0:	7c de                	jl     800fd0 <_main+0xf98>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800ff9:	eb 30                	jmp    80102b <_main+0xff3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801005:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80100f:	74 17                	je     801028 <_main+0xff0>
  801011:	83 ec 04             	sub    $0x4,%esp
  801014:	68 a8 47 80 00       	push   $0x8047a8
  801019:	68 79 01 00 00       	push   $0x179
  80101e:	68 94 45 80 00       	push   $0x804594
  801023:	e8 82 02 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  801028:	ff 45 f4             	incl   -0xc(%ebp)
  80102b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80102f:	7e ca                	jle    800ffb <_main+0xfc3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801031:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801037:	eb 30                	jmp    801069 <_main+0x1031>
		{
			if (intArr[i] != i)
  801039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801043:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	8b 00                	mov    (%eax),%eax
  80104a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80104d:	74 17                	je     801066 <_main+0x102e>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  80104f:	83 ec 04             	sub    $0x4,%esp
  801052:	68 a8 47 80 00       	push   $0x8047a8
  801057:	68 81 01 00 00       	push   $0x181
  80105c:	68 94 45 80 00       	push   $0x804594
  801061:	e8 44 02 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801066:	ff 4d f4             	decl   -0xc(%ebp)
  801069:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80106c:	83 e8 64             	sub    $0x64,%eax
  80106f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801072:	7c c5                	jl     801039 <_main+0x1001>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  801074:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801077:	40                   	inc    %eax
  801078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107b:	eb 30                	jmp    8010ad <_main+0x1075>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80107d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801080:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801087:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80108a:	01 d0                	add    %edx,%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801091:	74 17                	je     8010aa <_main+0x1072>
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	68 a8 47 80 00       	push   $0x8047a8
  80109b:	68 88 01 00 00       	push   $0x188
  8010a0:	68 94 45 80 00       	push   $0x804594
  8010a5:	e8 00 02 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  8010aa:	ff 45 f4             	incl   -0xc(%ebp)
  8010ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010b0:	83 c0 65             	add    $0x65,%eax
  8010b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010b6:	7f c5                	jg     80107d <_main+0x1045>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010be:	eb 30                	jmp    8010f0 <_main+0x10b8>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d4:	74 17                	je     8010ed <_main+0x10b5>
  8010d6:	83 ec 04             	sub    $0x4,%esp
  8010d9:	68 a8 47 80 00       	push   $0x8047a8
  8010de:	68 8e 01 00 00       	push   $0x18e
  8010e3:	68 94 45 80 00       	push   $0x804594
  8010e8:	e8 bd 01 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010ed:	ff 4d f4             	decl   -0xc(%ebp)
  8010f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010f3:	83 e8 64             	sub    $0x64,%eax
  8010f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010f9:	7c c5                	jl     8010c0 <_main+0x1088>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  8010fb:	e8 06 16 00 00       	call   802706 <sys_calculate_free_frames>
  801100:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801103:	e8 9e 16 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  801108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[0]);
  80110b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	e8 fd 13 00 00       	call   802514 <free>
  801117:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  80111a:	e8 87 16 00 00       	call   8027a6 <sys_pf_calculate_allocated_pages>
  80111f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112b:	74 17                	je     801144 <_main+0x110c>
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 e0 47 80 00       	push   $0x8047e0
  801135:	68 96 01 00 00       	push   $0x196
  80113a:	68 94 45 80 00       	push   $0x804594
  80113f:	e8 66 01 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 2) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 00                	push   $0x0
  801149:	68 42 48 80 00       	push   $0x804842
  80114e:	e8 a0 03 00 00       	call   8014f3 <vcprintf>
  801153:	83 c4 10             	add    $0x10,%esp
	}

	cprintf("Congratulations!! test realloc [1] completed successfully.\n");
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 4c 48 80 00       	push   $0x80484c
  80115e:	e8 fb 03 00 00       	call   80155e <cprintf>
  801163:	83 c4 10             	add    $0x10,%esp

	return;
  801166:	90                   	nop
}
  801167:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116a:	5b                   	pop    %ebx
  80116b:	5f                   	pop    %edi
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801174:	e8 6d 18 00 00       	call   8029e6 <sys_getenvindex>
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80117c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	c1 e0 03             	shl    $0x3,%eax
  801184:	01 d0                	add    %edx,%eax
  801186:	01 c0                	add    %eax,%eax
  801188:	01 d0                	add    %edx,%eax
  80118a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801191:	01 d0                	add    %edx,%eax
  801193:	c1 e0 04             	shl    $0x4,%eax
  801196:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80119b:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8011a0:	a1 20 60 80 00       	mov    0x806020,%eax
  8011a5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0f                	je     8011be <libmain+0x50>
		binaryname = myEnv->prog_name;
  8011af:	a1 20 60 80 00       	mov    0x806020,%eax
  8011b4:	05 5c 05 00 00       	add    $0x55c,%eax
  8011b9:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c2:	7e 0a                	jle    8011ce <libmain+0x60>
		binaryname = argv[0];
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  8011ce:	83 ec 08             	sub    $0x8,%esp
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	ff 75 08             	pushl  0x8(%ebp)
  8011d7:	e8 5c ee ff ff       	call   800038 <_main>
  8011dc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8011df:	e8 0f 16 00 00       	call   8027f3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	68 a0 48 80 00       	push   $0x8048a0
  8011ec:	e8 6d 03 00 00       	call   80155e <cprintf>
  8011f1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8011f4:	a1 20 60 80 00       	mov    0x806020,%eax
  8011f9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8011ff:	a1 20 60 80 00       	mov    0x806020,%eax
  801204:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	52                   	push   %edx
  80120e:	50                   	push   %eax
  80120f:	68 c8 48 80 00       	push   $0x8048c8
  801214:	e8 45 03 00 00       	call   80155e <cprintf>
  801219:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80121c:	a1 20 60 80 00       	mov    0x806020,%eax
  801221:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  801227:	a1 20 60 80 00       	mov    0x806020,%eax
  80122c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  801232:	a1 20 60 80 00       	mov    0x806020,%eax
  801237:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80123d:	51                   	push   %ecx
  80123e:	52                   	push   %edx
  80123f:	50                   	push   %eax
  801240:	68 f0 48 80 00       	push   $0x8048f0
  801245:	e8 14 03 00 00       	call   80155e <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80124d:	a1 20 60 80 00       	mov    0x806020,%eax
  801252:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	50                   	push   %eax
  80125c:	68 48 49 80 00       	push   $0x804948
  801261:	e8 f8 02 00 00       	call   80155e <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	68 a0 48 80 00       	push   $0x8048a0
  801271:	e8 e8 02 00 00       	call   80155e <cprintf>
  801276:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801279:	e8 8f 15 00 00       	call   80280d <sys_enable_interrupt>

	// exit gracefully
	exit();
  80127e:	e8 19 00 00 00       	call   80129c <exit>
}
  801283:	90                   	nop
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	6a 00                	push   $0x0
  801291:	e8 1c 17 00 00       	call   8029b2 <sys_destroy_env>
  801296:	83 c4 10             	add    $0x10,%esp
}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <exit>:

void
exit(void)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012a2:	e8 71 17 00 00       	call   802a18 <sys_exit_env>
}
  8012a7:	90                   	nop
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012b0:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b3:	83 c0 04             	add    $0x4,%eax
  8012b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012b9:	a1 5c 61 80 00       	mov    0x80615c,%eax
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	74 16                	je     8012d8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8012c2:	a1 5c 61 80 00       	mov    0x80615c,%eax
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	50                   	push   %eax
  8012cb:	68 5c 49 80 00       	push   $0x80495c
  8012d0:	e8 89 02 00 00       	call   80155e <cprintf>
  8012d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8012d8:	a1 00 60 80 00       	mov    0x806000,%eax
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	50                   	push   %eax
  8012e4:	68 61 49 80 00       	push   $0x804961
  8012e9:	e8 70 02 00 00       	call   80155e <cprintf>
  8012ee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8012f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012fa:	50                   	push   %eax
  8012fb:	e8 f3 01 00 00       	call   8014f3 <vcprintf>
  801300:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	6a 00                	push   $0x0
  801308:	68 7d 49 80 00       	push   $0x80497d
  80130d:	e8 e1 01 00 00       	call   8014f3 <vcprintf>
  801312:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801315:	e8 82 ff ff ff       	call   80129c <exit>

	// should not return here
	while (1) ;
  80131a:	eb fe                	jmp    80131a <_panic+0x70>

0080131c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801322:	a1 20 60 80 00       	mov    0x806020,%eax
  801327:	8b 50 74             	mov    0x74(%eax),%edx
  80132a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132d:	39 c2                	cmp    %eax,%edx
  80132f:	74 14                	je     801345 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	68 80 49 80 00       	push   $0x804980
  801339:	6a 26                	push   $0x26
  80133b:	68 cc 49 80 00       	push   $0x8049cc
  801340:	e8 65 ff ff ff       	call   8012aa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80134c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801353:	e9 c2 00 00 00       	jmp    80141a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	8b 00                	mov    (%eax),%eax
  801369:	85 c0                	test   %eax,%eax
  80136b:	75 08                	jne    801375 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80136d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801370:	e9 a2 00 00 00       	jmp    801417 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801375:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80137c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801383:	eb 69                	jmp    8013ee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801385:	a1 20 60 80 00       	mov    0x806020,%eax
  80138a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	01 c0                	add    %eax,%eax
  801397:	01 d0                	add    %edx,%eax
  801399:	c1 e0 03             	shl    $0x3,%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8a 40 04             	mov    0x4(%eax),%al
  8013a1:	84 c0                	test   %al,%al
  8013a3:	75 46                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013a5:	a1 20 60 80 00       	mov    0x806020,%eax
  8013aa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013b3:	89 d0                	mov    %edx,%eax
  8013b5:	01 c0                	add    %eax,%eax
  8013b7:	01 d0                	add    %edx,%eax
  8013b9:	c1 e0 03             	shl    $0x3,%eax
  8013bc:	01 c8                	add    %ecx,%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8013cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	01 c8                	add    %ecx,%eax
  8013dc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013de:	39 c2                	cmp    %eax,%edx
  8013e0:	75 09                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8013e2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8013e9:	eb 12                	jmp    8013fd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013eb:	ff 45 e8             	incl   -0x18(%ebp)
  8013ee:	a1 20 60 80 00       	mov    0x806020,%eax
  8013f3:	8b 50 74             	mov    0x74(%eax),%edx
  8013f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f9:	39 c2                	cmp    %eax,%edx
  8013fb:	77 88                	ja     801385 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8013fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801401:	75 14                	jne    801417 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	68 d8 49 80 00       	push   $0x8049d8
  80140b:	6a 3a                	push   $0x3a
  80140d:	68 cc 49 80 00       	push   $0x8049cc
  801412:	e8 93 fe ff ff       	call   8012aa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801417:	ff 45 f0             	incl   -0x10(%ebp)
  80141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801420:	0f 8c 32 ff ff ff    	jl     801358 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801426:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80142d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801434:	eb 26                	jmp    80145c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801436:	a1 20 60 80 00       	mov    0x806020,%eax
  80143b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801441:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801444:	89 d0                	mov    %edx,%eax
  801446:	01 c0                	add    %eax,%eax
  801448:	01 d0                	add    %edx,%eax
  80144a:	c1 e0 03             	shl    $0x3,%eax
  80144d:	01 c8                	add    %ecx,%eax
  80144f:	8a 40 04             	mov    0x4(%eax),%al
  801452:	3c 01                	cmp    $0x1,%al
  801454:	75 03                	jne    801459 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801456:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801459:	ff 45 e0             	incl   -0x20(%ebp)
  80145c:	a1 20 60 80 00       	mov    0x806020,%eax
  801461:	8b 50 74             	mov    0x74(%eax),%edx
  801464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801467:	39 c2                	cmp    %eax,%edx
  801469:	77 cb                	ja     801436 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801471:	74 14                	je     801487 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	68 2c 4a 80 00       	push   $0x804a2c
  80147b:	6a 44                	push   $0x44
  80147d:	68 cc 49 80 00       	push   $0x8049cc
  801482:	e8 23 fe ff ff       	call   8012aa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801487:	90                   	nop
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801490:	8b 45 0c             	mov    0xc(%ebp),%eax
  801493:	8b 00                	mov    (%eax),%eax
  801495:	8d 48 01             	lea    0x1(%eax),%ecx
  801498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149b:	89 0a                	mov    %ecx,(%edx)
  80149d:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a0:	88 d1                	mov    %dl,%cl
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014b3:	75 2c                	jne    8014e1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8014b5:	a0 24 60 80 00       	mov    0x806024,%al
  8014ba:	0f b6 c0             	movzbl %al,%eax
  8014bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c0:	8b 12                	mov    (%edx),%edx
  8014c2:	89 d1                	mov    %edx,%ecx
  8014c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c7:	83 c2 08             	add    $0x8,%edx
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	50                   	push   %eax
  8014ce:	51                   	push   %ecx
  8014cf:	52                   	push   %edx
  8014d0:	e8 70 11 00 00       	call   802645 <sys_cputs>
  8014d5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8b 40 04             	mov    0x4(%eax),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	89 50 04             	mov    %edx,0x4(%eax)
}
  8014f0:	90                   	nop
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8014fc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801503:	00 00 00 
	b.cnt = 0;
  801506:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80150d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	ff 75 08             	pushl  0x8(%ebp)
  801516:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	68 8a 14 80 00       	push   $0x80148a
  801522:	e8 11 02 00 00       	call   801738 <vprintfmt>
  801527:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80152a:	a0 24 60 80 00       	mov    0x806024,%al
  80152f:	0f b6 c0             	movzbl %al,%eax
  801532:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801538:	83 ec 04             	sub    $0x4,%esp
  80153b:	50                   	push   %eax
  80153c:	52                   	push   %edx
  80153d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801543:	83 c0 08             	add    $0x8,%eax
  801546:	50                   	push   %eax
  801547:	e8 f9 10 00 00       	call   802645 <sys_cputs>
  80154c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80154f:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  801556:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <cprintf>:

int cprintf(const char *fmt, ...) {
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801564:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  80156b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	ff 75 f4             	pushl  -0xc(%ebp)
  80157a:	50                   	push   %eax
  80157b:	e8 73 ff ff ff       	call   8014f3 <vcprintf>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801591:	e8 5d 12 00 00       	call   8027f3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801596:	8d 45 0c             	lea    0xc(%ebp),%eax
  801599:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a5:	50                   	push   %eax
  8015a6:	e8 48 ff ff ff       	call   8014f3 <vcprintf>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8015b1:	e8 57 12 00 00       	call   80280d <sys_enable_interrupt>
	return cnt;
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	53                   	push   %ebx
  8015bf:	83 ec 14             	sub    $0x14,%esp
  8015c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015ce:	8b 45 18             	mov    0x18(%ebp),%eax
  8015d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015d9:	77 55                	ja     801630 <printnum+0x75>
  8015db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015de:	72 05                	jb     8015e5 <printnum+0x2a>
  8015e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e3:	77 4b                	ja     801630 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015e5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8015e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8015ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f3:	52                   	push   %edx
  8015f4:	50                   	push   %eax
  8015f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8015fb:	e8 c8 2c 00 00       	call   8042c8 <__udivdi3>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	ff 75 20             	pushl  0x20(%ebp)
  801609:	53                   	push   %ebx
  80160a:	ff 75 18             	pushl  0x18(%ebp)
  80160d:	52                   	push   %edx
  80160e:	50                   	push   %eax
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	ff 75 08             	pushl  0x8(%ebp)
  801615:	e8 a1 ff ff ff       	call   8015bb <printnum>
  80161a:	83 c4 20             	add    $0x20,%esp
  80161d:	eb 1a                	jmp    801639 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	ff 75 0c             	pushl  0xc(%ebp)
  801625:	ff 75 20             	pushl  0x20(%ebp)
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	ff d0                	call   *%eax
  80162d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801630:	ff 4d 1c             	decl   0x1c(%ebp)
  801633:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801637:	7f e6                	jg     80161f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801639:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80163c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801647:	53                   	push   %ebx
  801648:	51                   	push   %ecx
  801649:	52                   	push   %edx
  80164a:	50                   	push   %eax
  80164b:	e8 88 2d 00 00       	call   8043d8 <__umoddi3>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	05 94 4c 80 00       	add    $0x804c94,%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f be c0             	movsbl %al,%eax
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	50                   	push   %eax
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	ff d0                	call   *%eax
  801669:	83 c4 10             	add    $0x10,%esp
}
  80166c:	90                   	nop
  80166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801675:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801679:	7e 1c                	jle    801697 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	8b 00                	mov    (%eax),%eax
  801680:	8d 50 08             	lea    0x8(%eax),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	89 10                	mov    %edx,(%eax)
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	83 e8 08             	sub    $0x8,%eax
  801690:	8b 50 04             	mov    0x4(%eax),%edx
  801693:	8b 00                	mov    (%eax),%eax
  801695:	eb 40                	jmp    8016d7 <getuint+0x65>
	else if (lflag)
  801697:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169b:	74 1e                	je     8016bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8b 00                	mov    (%eax),%eax
  8016a2:	8d 50 04             	lea    0x4(%eax),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	89 10                	mov    %edx,(%eax)
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	83 e8 04             	sub    $0x4,%eax
  8016b2:	8b 00                	mov    (%eax),%eax
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	eb 1c                	jmp    8016d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8b 00                	mov    (%eax),%eax
  8016c0:	8d 50 04             	lea    0x4(%eax),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	89 10                	mov    %edx,(%eax)
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8b 00                	mov    (%eax),%eax
  8016cd:	83 e8 04             	sub    $0x4,%eax
  8016d0:	8b 00                	mov    (%eax),%eax
  8016d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8016d7:	5d                   	pop    %ebp
  8016d8:	c3                   	ret    

008016d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8016dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016e0:	7e 1c                	jle    8016fe <getint+0x25>
		return va_arg(*ap, long long);
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8b 00                	mov    (%eax),%eax
  8016e7:	8d 50 08             	lea    0x8(%eax),%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	89 10                	mov    %edx,(%eax)
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	83 e8 08             	sub    $0x8,%eax
  8016f7:	8b 50 04             	mov    0x4(%eax),%edx
  8016fa:	8b 00                	mov    (%eax),%eax
  8016fc:	eb 38                	jmp    801736 <getint+0x5d>
	else if (lflag)
  8016fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801702:	74 1a                	je     80171e <getint+0x45>
		return va_arg(*ap, long);
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8b 00                	mov    (%eax),%eax
  801709:	8d 50 04             	lea    0x4(%eax),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	89 10                	mov    %edx,(%eax)
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	83 e8 04             	sub    $0x4,%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	99                   	cltd   
  80171c:	eb 18                	jmp    801736 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	8d 50 04             	lea    0x4(%eax),%edx
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	89 10                	mov    %edx,(%eax)
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8b 00                	mov    (%eax),%eax
  801730:	83 e8 04             	sub    $0x4,%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	99                   	cltd   
}
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801740:	eb 17                	jmp    801759 <vprintfmt+0x21>
			if (ch == '\0')
  801742:	85 db                	test   %ebx,%ebx
  801744:	0f 84 af 03 00 00    	je     801af9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	53                   	push   %ebx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	ff d0                	call   *%eax
  801756:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	8d 50 01             	lea    0x1(%eax),%edx
  80175f:	89 55 10             	mov    %edx,0x10(%ebp)
  801762:	8a 00                	mov    (%eax),%al
  801764:	0f b6 d8             	movzbl %al,%ebx
  801767:	83 fb 25             	cmp    $0x25,%ebx
  80176a:	75 d6                	jne    801742 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80176c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801770:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801777:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80177e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801785:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80178c:	8b 45 10             	mov    0x10(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 10             	mov    %edx,0x10(%ebp)
  801795:	8a 00                	mov    (%eax),%al
  801797:	0f b6 d8             	movzbl %al,%ebx
  80179a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80179d:	83 f8 55             	cmp    $0x55,%eax
  8017a0:	0f 87 2b 03 00 00    	ja     801ad1 <vprintfmt+0x399>
  8017a6:	8b 04 85 b8 4c 80 00 	mov    0x804cb8(,%eax,4),%eax
  8017ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8017af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8017b3:	eb d7                	jmp    80178c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8017b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8017b9:	eb d1                	jmp    80178c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8017c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017c5:	89 d0                	mov    %edx,%eax
  8017c7:	c1 e0 02             	shl    $0x2,%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	01 c0                	add    %eax,%eax
  8017ce:	01 d8                	add    %ebx,%eax
  8017d0:	83 e8 30             	sub    $0x30,%eax
  8017d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8017d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8017de:	83 fb 2f             	cmp    $0x2f,%ebx
  8017e1:	7e 3e                	jle    801821 <vprintfmt+0xe9>
  8017e3:	83 fb 39             	cmp    $0x39,%ebx
  8017e6:	7f 39                	jg     801821 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8017eb:	eb d5                	jmp    8017c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8017ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f0:	83 c0 04             	add    $0x4,%eax
  8017f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8017f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f9:	83 e8 04             	sub    $0x4,%eax
  8017fc:	8b 00                	mov    (%eax),%eax
  8017fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801801:	eb 1f                	jmp    801822 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801807:	79 83                	jns    80178c <vprintfmt+0x54>
				width = 0;
  801809:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801810:	e9 77 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801815:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80181c:	e9 6b ff ff ff       	jmp    80178c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801821:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801826:	0f 89 60 ff ff ff    	jns    80178c <vprintfmt+0x54>
				width = precision, precision = -1;
  80182c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801832:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801839:	e9 4e ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80183e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801841:	e9 46 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	83 c0 04             	add    $0x4,%eax
  80184c:	89 45 14             	mov    %eax,0x14(%ebp)
  80184f:	8b 45 14             	mov    0x14(%ebp),%eax
  801852:	83 e8 04             	sub    $0x4,%eax
  801855:	8b 00                	mov    (%eax),%eax
  801857:	83 ec 08             	sub    $0x8,%esp
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	50                   	push   %eax
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	ff d0                	call   *%eax
  801863:	83 c4 10             	add    $0x10,%esp
			break;
  801866:	e9 89 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80186b:	8b 45 14             	mov    0x14(%ebp),%eax
  80186e:	83 c0 04             	add    $0x4,%eax
  801871:	89 45 14             	mov    %eax,0x14(%ebp)
  801874:	8b 45 14             	mov    0x14(%ebp),%eax
  801877:	83 e8 04             	sub    $0x4,%eax
  80187a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80187c:	85 db                	test   %ebx,%ebx
  80187e:	79 02                	jns    801882 <vprintfmt+0x14a>
				err = -err;
  801880:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801882:	83 fb 64             	cmp    $0x64,%ebx
  801885:	7f 0b                	jg     801892 <vprintfmt+0x15a>
  801887:	8b 34 9d 00 4b 80 00 	mov    0x804b00(,%ebx,4),%esi
  80188e:	85 f6                	test   %esi,%esi
  801890:	75 19                	jne    8018ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801892:	53                   	push   %ebx
  801893:	68 a5 4c 80 00       	push   $0x804ca5
  801898:	ff 75 0c             	pushl  0xc(%ebp)
  80189b:	ff 75 08             	pushl  0x8(%ebp)
  80189e:	e8 5e 02 00 00       	call   801b01 <printfmt>
  8018a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8018a6:	e9 49 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8018ab:	56                   	push   %esi
  8018ac:	68 ae 4c 80 00       	push   $0x804cae
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	e8 45 02 00 00       	call   801b01 <printfmt>
  8018bc:	83 c4 10             	add    $0x10,%esp
			break;
  8018bf:	e9 30 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8018c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c7:	83 c0 04             	add    $0x4,%eax
  8018ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8018cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d0:	83 e8 04             	sub    $0x4,%eax
  8018d3:	8b 30                	mov    (%eax),%esi
  8018d5:	85 f6                	test   %esi,%esi
  8018d7:	75 05                	jne    8018de <vprintfmt+0x1a6>
				p = "(null)";
  8018d9:	be b1 4c 80 00       	mov    $0x804cb1,%esi
			if (width > 0 && padc != '-')
  8018de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018e2:	7e 6d                	jle    801951 <vprintfmt+0x219>
  8018e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8018e8:	74 67                	je     801951 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8018ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ed:	83 ec 08             	sub    $0x8,%esp
  8018f0:	50                   	push   %eax
  8018f1:	56                   	push   %esi
  8018f2:	e8 0c 03 00 00       	call   801c03 <strnlen>
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8018fd:	eb 16                	jmp    801915 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8018ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	50                   	push   %eax
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	ff d0                	call   *%eax
  80190f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801912:	ff 4d e4             	decl   -0x1c(%ebp)
  801915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801919:	7f e4                	jg     8018ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80191b:	eb 34                	jmp    801951 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80191d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801921:	74 1c                	je     80193f <vprintfmt+0x207>
  801923:	83 fb 1f             	cmp    $0x1f,%ebx
  801926:	7e 05                	jle    80192d <vprintfmt+0x1f5>
  801928:	83 fb 7e             	cmp    $0x7e,%ebx
  80192b:	7e 12                	jle    80193f <vprintfmt+0x207>
					putch('?', putdat);
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	6a 3f                	push   $0x3f
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	ff d0                	call   *%eax
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	eb 0f                	jmp    80194e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	53                   	push   %ebx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	ff d0                	call   *%eax
  80194b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80194e:	ff 4d e4             	decl   -0x1c(%ebp)
  801951:	89 f0                	mov    %esi,%eax
  801953:	8d 70 01             	lea    0x1(%eax),%esi
  801956:	8a 00                	mov    (%eax),%al
  801958:	0f be d8             	movsbl %al,%ebx
  80195b:	85 db                	test   %ebx,%ebx
  80195d:	74 24                	je     801983 <vprintfmt+0x24b>
  80195f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801963:	78 b8                	js     80191d <vprintfmt+0x1e5>
  801965:	ff 4d e0             	decl   -0x20(%ebp)
  801968:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80196c:	79 af                	jns    80191d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80196e:	eb 13                	jmp    801983 <vprintfmt+0x24b>
				putch(' ', putdat);
  801970:	83 ec 08             	sub    $0x8,%esp
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	6a 20                	push   $0x20
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	ff d0                	call   *%eax
  80197d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801980:	ff 4d e4             	decl   -0x1c(%ebp)
  801983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801987:	7f e7                	jg     801970 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801989:	e9 66 01 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80198e:	83 ec 08             	sub    $0x8,%esp
  801991:	ff 75 e8             	pushl  -0x18(%ebp)
  801994:	8d 45 14             	lea    0x14(%ebp),%eax
  801997:	50                   	push   %eax
  801998:	e8 3c fd ff ff       	call   8016d9 <getint>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ac:	85 d2                	test   %edx,%edx
  8019ae:	79 23                	jns    8019d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	6a 2d                	push   $0x2d
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	ff d0                	call   *%eax
  8019bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c6:	f7 d8                	neg    %eax
  8019c8:	83 d2 00             	adc    $0x0,%edx
  8019cb:	f7 da                	neg    %edx
  8019cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8019d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019da:	e9 bc 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8019e8:	50                   	push   %eax
  8019e9:	e8 84 fc ff ff       	call   801672 <getuint>
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8019f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019fe:	e9 98 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801a03:	83 ec 08             	sub    $0x8,%esp
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	6a 58                	push   $0x58
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	ff d0                	call   *%eax
  801a10:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a13:	83 ec 08             	sub    $0x8,%esp
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	6a 58                	push   $0x58
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	ff d0                	call   *%eax
  801a20:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	6a 58                	push   $0x58
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	ff d0                	call   *%eax
  801a30:	83 c4 10             	add    $0x10,%esp
			break;
  801a33:	e9 bc 00 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801a38:	83 ec 08             	sub    $0x8,%esp
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	6a 30                	push   $0x30
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	ff d0                	call   *%eax
  801a45:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801a48:	83 ec 08             	sub    $0x8,%esp
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	6a 78                	push   $0x78
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	ff d0                	call   *%eax
  801a55:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801a58:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5b:	83 c0 04             	add    $0x4,%eax
  801a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  801a61:	8b 45 14             	mov    0x14(%ebp),%eax
  801a64:	83 e8 04             	sub    $0x4,%eax
  801a67:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801a73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801a7a:	eb 1f                	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  801a82:	8d 45 14             	lea    0x14(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	e8 e7 fb ff ff       	call   801672 <getuint>
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801a94:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801a9b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	52                   	push   %edx
  801aa6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	ff 75 f4             	pushl  -0xc(%ebp)
  801aad:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	e8 00 fb ff ff       	call   8015bb <printnum>
  801abb:	83 c4 20             	add    $0x20,%esp
			break;
  801abe:	eb 34                	jmp    801af4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ac0:	83 ec 08             	sub    $0x8,%esp
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	53                   	push   %ebx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	ff d0                	call   *%eax
  801acc:	83 c4 10             	add    $0x10,%esp
			break;
  801acf:	eb 23                	jmp    801af4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ad1:	83 ec 08             	sub    $0x8,%esp
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	6a 25                	push   $0x25
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	ff d0                	call   *%eax
  801ade:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ae1:	ff 4d 10             	decl   0x10(%ebp)
  801ae4:	eb 03                	jmp    801ae9 <vprintfmt+0x3b1>
  801ae6:	ff 4d 10             	decl   0x10(%ebp)
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	48                   	dec    %eax
  801aed:	8a 00                	mov    (%eax),%al
  801aef:	3c 25                	cmp    $0x25,%al
  801af1:	75 f3                	jne    801ae6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801af3:	90                   	nop
		}
	}
  801af4:	e9 47 fc ff ff       	jmp    801740 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801af9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801afa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afd:	5b                   	pop    %ebx
  801afe:	5e                   	pop    %esi
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801b07:	8d 45 10             	lea    0x10(%ebp),%eax
  801b0a:	83 c0 04             	add    $0x4,%eax
  801b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801b10:	8b 45 10             	mov    0x10(%ebp),%eax
  801b13:	ff 75 f4             	pushl  -0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	e8 16 fc ff ff       	call   801738 <vprintfmt>
  801b22:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2e:	8b 40 08             	mov    0x8(%eax),%eax
  801b31:	8d 50 01             	lea    0x1(%eax),%edx
  801b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b37:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3d:	8b 10                	mov    (%eax),%edx
  801b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b42:	8b 40 04             	mov    0x4(%eax),%eax
  801b45:	39 c2                	cmp    %eax,%edx
  801b47:	73 12                	jae    801b5b <sprintputch+0x33>
		*b->buf++ = ch;
  801b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4c:	8b 00                	mov    (%eax),%eax
  801b4e:	8d 48 01             	lea    0x1(%eax),%ecx
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	89 0a                	mov    %ecx,(%edx)
  801b56:	8b 55 08             	mov    0x8(%ebp),%edx
  801b59:	88 10                	mov    %dl,(%eax)
}
  801b5b:	90                   	nop
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    

00801b5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	01 d0                	add    %edx,%eax
  801b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b83:	74 06                	je     801b8b <vsnprintf+0x2d>
  801b85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b89:	7f 07                	jg     801b92 <vsnprintf+0x34>
		return -E_INVAL;
  801b8b:	b8 03 00 00 00       	mov    $0x3,%eax
  801b90:	eb 20                	jmp    801bb2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b92:	ff 75 14             	pushl  0x14(%ebp)
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b9b:	50                   	push   %eax
  801b9c:	68 28 1b 80 00       	push   $0x801b28
  801ba1:	e8 92 fb ff ff       	call   801738 <vprintfmt>
  801ba6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bba:	8d 45 10             	lea    0x10(%ebp),%eax
  801bbd:	83 c0 04             	add    $0x4,%eax
  801bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc9:	50                   	push   %eax
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	e8 89 ff ff ff       	call   801b5e <vsnprintf>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801be6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bed:	eb 06                	jmp    801bf5 <strlen+0x15>
		n++;
  801bef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801bf2:	ff 45 08             	incl   0x8(%ebp)
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	8a 00                	mov    (%eax),%al
  801bfa:	84 c0                	test   %al,%al
  801bfc:	75 f1                	jne    801bef <strlen+0xf>
		n++;
	return n;
  801bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c10:	eb 09                	jmp    801c1b <strnlen+0x18>
		n++;
  801c12:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c15:	ff 45 08             	incl   0x8(%ebp)
  801c18:	ff 4d 0c             	decl   0xc(%ebp)
  801c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c1f:	74 09                	je     801c2a <strnlen+0x27>
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	8a 00                	mov    (%eax),%al
  801c26:	84 c0                	test   %al,%al
  801c28:	75 e8                	jne    801c12 <strnlen+0xf>
		n++;
	return n;
  801c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801c3b:	90                   	nop
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8d 50 01             	lea    0x1(%eax),%edx
  801c42:	89 55 08             	mov    %edx,0x8(%ebp)
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c48:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c4b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c4e:	8a 12                	mov    (%edx),%dl
  801c50:	88 10                	mov    %dl,(%eax)
  801c52:	8a 00                	mov    (%eax),%al
  801c54:	84 c0                	test   %al,%al
  801c56:	75 e4                	jne    801c3c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801c69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c70:	eb 1f                	jmp    801c91 <strncpy+0x34>
		*dst++ = *src;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	8d 50 01             	lea    0x1(%eax),%edx
  801c78:	89 55 08             	mov    %edx,0x8(%ebp)
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7e:	8a 12                	mov    (%edx),%dl
  801c80:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	84 c0                	test   %al,%al
  801c89:	74 03                	je     801c8e <strncpy+0x31>
			src++;
  801c8b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c8e:	ff 45 fc             	incl   -0x4(%ebp)
  801c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c94:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c97:	72 d9                	jb     801c72 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801caa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cae:	74 30                	je     801ce0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801cb0:	eb 16                	jmp    801cc8 <strlcpy+0x2a>
			*dst++ = *src++;
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	8d 50 01             	lea    0x1(%eax),%edx
  801cb8:	89 55 08             	mov    %edx,0x8(%ebp)
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cc1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801cc4:	8a 12                	mov    (%edx),%dl
  801cc6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801cc8:	ff 4d 10             	decl   0x10(%ebp)
  801ccb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ccf:	74 09                	je     801cda <strlcpy+0x3c>
  801cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd4:	8a 00                	mov    (%eax),%al
  801cd6:	84 c0                	test   %al,%al
  801cd8:	75 d8                	jne    801cb2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ce6:	29 c2                	sub    %eax,%edx
  801ce8:	89 d0                	mov    %edx,%eax
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801cef:	eb 06                	jmp    801cf7 <strcmp+0xb>
		p++, q++;
  801cf1:	ff 45 08             	incl   0x8(%ebp)
  801cf4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	8a 00                	mov    (%eax),%al
  801cfc:	84 c0                	test   %al,%al
  801cfe:	74 0e                	je     801d0e <strcmp+0x22>
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	8a 10                	mov    (%eax),%dl
  801d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d08:	8a 00                	mov    (%eax),%al
  801d0a:	38 c2                	cmp    %al,%dl
  801d0c:	74 e3                	je     801cf1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	8a 00                	mov    (%eax),%al
  801d13:	0f b6 d0             	movzbl %al,%edx
  801d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d19:	8a 00                	mov    (%eax),%al
  801d1b:	0f b6 c0             	movzbl %al,%eax
  801d1e:	29 c2                	sub    %eax,%edx
  801d20:	89 d0                	mov    %edx,%eax
}
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    

00801d24 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801d27:	eb 09                	jmp    801d32 <strncmp+0xe>
		n--, p++, q++;
  801d29:	ff 4d 10             	decl   0x10(%ebp)
  801d2c:	ff 45 08             	incl   0x8(%ebp)
  801d2f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801d32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d36:	74 17                	je     801d4f <strncmp+0x2b>
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	8a 00                	mov    (%eax),%al
  801d3d:	84 c0                	test   %al,%al
  801d3f:	74 0e                	je     801d4f <strncmp+0x2b>
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	8a 10                	mov    (%eax),%dl
  801d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d49:	8a 00                	mov    (%eax),%al
  801d4b:	38 c2                	cmp    %al,%dl
  801d4d:	74 da                	je     801d29 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d53:	75 07                	jne    801d5c <strncmp+0x38>
		return 0;
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	eb 14                	jmp    801d70 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	8a 00                	mov    (%eax),%al
  801d61:	0f b6 d0             	movzbl %al,%edx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	8a 00                	mov    (%eax),%al
  801d69:	0f b6 c0             	movzbl %al,%eax
  801d6c:	29 c2                	sub    %eax,%edx
  801d6e:	89 d0                	mov    %edx,%eax
}
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    

00801d72 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d7e:	eb 12                	jmp    801d92 <strchr+0x20>
		if (*s == c)
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	8a 00                	mov    (%eax),%al
  801d85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d88:	75 05                	jne    801d8f <strchr+0x1d>
			return (char *) s;
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	eb 11                	jmp    801da0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d8f:	ff 45 08             	incl   0x8(%ebp)
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	8a 00                	mov    (%eax),%al
  801d97:	84 c0                	test   %al,%al
  801d99:	75 e5                	jne    801d80 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801dae:	eb 0d                	jmp    801dbd <strfind+0x1b>
		if (*s == c)
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	8a 00                	mov    (%eax),%al
  801db5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801db8:	74 0e                	je     801dc8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801dba:	ff 45 08             	incl   0x8(%ebp)
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8a 00                	mov    (%eax),%al
  801dc2:	84 c0                	test   %al,%al
  801dc4:	75 ea                	jne    801db0 <strfind+0xe>
  801dc6:	eb 01                	jmp    801dc9 <strfind+0x27>
		if (*s == c)
			break;
  801dc8:	90                   	nop
	return (char *) s;
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801dda:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801de0:	eb 0e                	jmp    801df0 <memset+0x22>
		*p++ = c;
  801de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de5:	8d 50 01             	lea    0x1(%eax),%edx
  801de8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801df0:	ff 4d f8             	decl   -0x8(%ebp)
  801df3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801df7:	79 e9                	jns    801de2 <memset+0x14>
		*p++ = c;

	return v;
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801e10:	eb 16                	jmp    801e28 <memcpy+0x2a>
		*d++ = *s++;
  801e12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e15:	8d 50 01             	lea    0x1(%eax),%edx
  801e18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e21:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801e24:	8a 12                	mov    (%edx),%dl
  801e26:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801e28:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e2e:	89 55 10             	mov    %edx,0x10(%ebp)
  801e31:	85 c0                	test   %eax,%eax
  801e33:	75 dd                	jne    801e12 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e52:	73 50                	jae    801ea4 <memmove+0x6a>
  801e54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e57:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5a:	01 d0                	add    %edx,%eax
  801e5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e5f:	76 43                	jbe    801ea4 <memmove+0x6a>
		s += n;
  801e61:	8b 45 10             	mov    0x10(%ebp),%eax
  801e64:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801e67:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801e6d:	eb 10                	jmp    801e7f <memmove+0x45>
			*--d = *--s;
  801e6f:	ff 4d f8             	decl   -0x8(%ebp)
  801e72:	ff 4d fc             	decl   -0x4(%ebp)
  801e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e78:	8a 10                	mov    (%eax),%dl
  801e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e7d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e82:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e85:	89 55 10             	mov    %edx,0x10(%ebp)
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	75 e3                	jne    801e6f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e8c:	eb 23                	jmp    801eb1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e91:	8d 50 01             	lea    0x1(%eax),%edx
  801e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ea0:	8a 12                	mov    (%edx),%dl
  801ea2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	75 dd                	jne    801e8e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ec8:	eb 2a                	jmp    801ef4 <memcmp+0x3e>
		if (*s1 != *s2)
  801eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecd:	8a 10                	mov    (%eax),%dl
  801ecf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed2:	8a 00                	mov    (%eax),%al
  801ed4:	38 c2                	cmp    %al,%dl
  801ed6:	74 16                	je     801eee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	0f b6 d0             	movzbl %al,%edx
  801ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ee3:	8a 00                	mov    (%eax),%al
  801ee5:	0f b6 c0             	movzbl %al,%eax
  801ee8:	29 c2                	sub    %eax,%edx
  801eea:	89 d0                	mov    %edx,%eax
  801eec:	eb 18                	jmp    801f06 <memcmp+0x50>
		s1++, s2++;
  801eee:	ff 45 fc             	incl   -0x4(%ebp)
  801ef1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801efa:	89 55 10             	mov    %edx,0x10(%ebp)
  801efd:	85 c0                	test   %eax,%eax
  801eff:	75 c9                	jne    801eca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f11:	8b 45 10             	mov    0x10(%ebp),%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801f19:	eb 15                	jmp    801f30 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	8a 00                	mov    (%eax),%al
  801f20:	0f b6 d0             	movzbl %al,%edx
  801f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f26:	0f b6 c0             	movzbl %al,%eax
  801f29:	39 c2                	cmp    %eax,%edx
  801f2b:	74 0d                	je     801f3a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801f2d:	ff 45 08             	incl   0x8(%ebp)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801f36:	72 e3                	jb     801f1b <memfind+0x13>
  801f38:	eb 01                	jmp    801f3b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801f3a:	90                   	nop
	return (void *) s;
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801f4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f54:	eb 03                	jmp    801f59 <strtol+0x19>
		s++;
  801f56:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	8a 00                	mov    (%eax),%al
  801f5e:	3c 20                	cmp    $0x20,%al
  801f60:	74 f4                	je     801f56 <strtol+0x16>
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	8a 00                	mov    (%eax),%al
  801f67:	3c 09                	cmp    $0x9,%al
  801f69:	74 eb                	je     801f56 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	8a 00                	mov    (%eax),%al
  801f70:	3c 2b                	cmp    $0x2b,%al
  801f72:	75 05                	jne    801f79 <strtol+0x39>
		s++;
  801f74:	ff 45 08             	incl   0x8(%ebp)
  801f77:	eb 13                	jmp    801f8c <strtol+0x4c>
	else if (*s == '-')
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	8a 00                	mov    (%eax),%al
  801f7e:	3c 2d                	cmp    $0x2d,%al
  801f80:	75 0a                	jne    801f8c <strtol+0x4c>
		s++, neg = 1;
  801f82:	ff 45 08             	incl   0x8(%ebp)
  801f85:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f90:	74 06                	je     801f98 <strtol+0x58>
  801f92:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801f96:	75 20                	jne    801fb8 <strtol+0x78>
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	8a 00                	mov    (%eax),%al
  801f9d:	3c 30                	cmp    $0x30,%al
  801f9f:	75 17                	jne    801fb8 <strtol+0x78>
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	40                   	inc    %eax
  801fa5:	8a 00                	mov    (%eax),%al
  801fa7:	3c 78                	cmp    $0x78,%al
  801fa9:	75 0d                	jne    801fb8 <strtol+0x78>
		s += 2, base = 16;
  801fab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801faf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801fb6:	eb 28                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801fb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fbc:	75 15                	jne    801fd3 <strtol+0x93>
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8a 00                	mov    (%eax),%al
  801fc3:	3c 30                	cmp    $0x30,%al
  801fc5:	75 0c                	jne    801fd3 <strtol+0x93>
		s++, base = 8;
  801fc7:	ff 45 08             	incl   0x8(%ebp)
  801fca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801fd1:	eb 0d                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0)
  801fd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fd7:	75 07                	jne    801fe0 <strtol+0xa0>
		base = 10;
  801fd9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	8a 00                	mov    (%eax),%al
  801fe5:	3c 2f                	cmp    $0x2f,%al
  801fe7:	7e 19                	jle    802002 <strtol+0xc2>
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	8a 00                	mov    (%eax),%al
  801fee:	3c 39                	cmp    $0x39,%al
  801ff0:	7f 10                	jg     802002 <strtol+0xc2>
			dig = *s - '0';
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	8a 00                	mov    (%eax),%al
  801ff7:	0f be c0             	movsbl %al,%eax
  801ffa:	83 e8 30             	sub    $0x30,%eax
  801ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802000:	eb 42                	jmp    802044 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8a 00                	mov    (%eax),%al
  802007:	3c 60                	cmp    $0x60,%al
  802009:	7e 19                	jle    802024 <strtol+0xe4>
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	8a 00                	mov    (%eax),%al
  802010:	3c 7a                	cmp    $0x7a,%al
  802012:	7f 10                	jg     802024 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	8a 00                	mov    (%eax),%al
  802019:	0f be c0             	movsbl %al,%eax
  80201c:	83 e8 57             	sub    $0x57,%eax
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802022:	eb 20                	jmp    802044 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8a 00                	mov    (%eax),%al
  802029:	3c 40                	cmp    $0x40,%al
  80202b:	7e 39                	jle    802066 <strtol+0x126>
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8a 00                	mov    (%eax),%al
  802032:	3c 5a                	cmp    $0x5a,%al
  802034:	7f 30                	jg     802066 <strtol+0x126>
			dig = *s - 'A' + 10;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8a 00                	mov    (%eax),%al
  80203b:	0f be c0             	movsbl %al,%eax
  80203e:	83 e8 37             	sub    $0x37,%eax
  802041:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	3b 45 10             	cmp    0x10(%ebp),%eax
  80204a:	7d 19                	jge    802065 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80204c:	ff 45 08             	incl   0x8(%ebp)
  80204f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802052:	0f af 45 10          	imul   0x10(%ebp),%eax
  802056:	89 c2                	mov    %eax,%edx
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	01 d0                	add    %edx,%eax
  80205d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802060:	e9 7b ff ff ff       	jmp    801fe0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802065:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802066:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80206a:	74 08                	je     802074 <strtol+0x134>
		*endptr = (char *) s;
  80206c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206f:	8b 55 08             	mov    0x8(%ebp),%edx
  802072:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802074:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802078:	74 07                	je     802081 <strtol+0x141>
  80207a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207d:	f7 d8                	neg    %eax
  80207f:	eb 03                	jmp    802084 <strtol+0x144>
  802081:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <ltostr>:

void
ltostr(long value, char *str)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80208c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802093:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80209a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80209e:	79 13                	jns    8020b3 <ltostr+0x2d>
	{
		neg = 1;
  8020a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8020ad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8020b0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8020bb:	99                   	cltd   
  8020bc:	f7 f9                	idiv   %ecx
  8020be:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8020c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c4:	8d 50 01             	lea    0x1(%eax),%edx
  8020c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8020ca:	89 c2                	mov    %eax,%edx
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020d4:	83 c2 30             	add    $0x30,%edx
  8020d7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8020d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020dc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020e1:	f7 e9                	imul   %ecx
  8020e3:	c1 fa 02             	sar    $0x2,%edx
  8020e6:	89 c8                	mov    %ecx,%eax
  8020e8:	c1 f8 1f             	sar    $0x1f,%eax
  8020eb:	29 c2                	sub    %eax,%edx
  8020ed:	89 d0                	mov    %edx,%eax
  8020ef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8020f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020fa:	f7 e9                	imul   %ecx
  8020fc:	c1 fa 02             	sar    $0x2,%edx
  8020ff:	89 c8                	mov    %ecx,%eax
  802101:	c1 f8 1f             	sar    $0x1f,%eax
  802104:	29 c2                	sub    %eax,%edx
  802106:	89 d0                	mov    %edx,%eax
  802108:	c1 e0 02             	shl    $0x2,%eax
  80210b:	01 d0                	add    %edx,%eax
  80210d:	01 c0                	add    %eax,%eax
  80210f:	29 c1                	sub    %eax,%ecx
  802111:	89 ca                	mov    %ecx,%edx
  802113:	85 d2                	test   %edx,%edx
  802115:	75 9c                	jne    8020b3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80211e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802121:	48                   	dec    %eax
  802122:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802125:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802129:	74 3d                	je     802168 <ltostr+0xe2>
		start = 1 ;
  80212b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802132:	eb 34                	jmp    802168 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	01 d0                	add    %edx,%eax
  80213c:	8a 00                	mov    (%eax),%al
  80213e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	8b 45 0c             	mov    0xc(%ebp),%eax
  802147:	01 c2                	add    %eax,%edx
  802149:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80214c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214f:	01 c8                	add    %ecx,%eax
  802151:	8a 00                	mov    (%eax),%al
  802153:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802155:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215b:	01 c2                	add    %eax,%edx
  80215d:	8a 45 eb             	mov    -0x15(%ebp),%al
  802160:	88 02                	mov    %al,(%edx)
		start++ ;
  802162:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802165:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80216e:	7c c4                	jl     802134 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802170:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802173:	8b 45 0c             	mov    0xc(%ebp),%eax
  802176:	01 d0                	add    %edx,%eax
  802178:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	e8 54 fa ff ff       	call   801be0 <strlen>
  80218c:	83 c4 04             	add    $0x4,%esp
  80218f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802192:	ff 75 0c             	pushl  0xc(%ebp)
  802195:	e8 46 fa ff ff       	call   801be0 <strlen>
  80219a:	83 c4 04             	add    $0x4,%esp
  80219d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8021a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8021a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021ae:	eb 17                	jmp    8021c7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8021b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b6:	01 c2                	add    %eax,%edx
  8021b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	01 c8                	add    %ecx,%eax
  8021c0:	8a 00                	mov    (%eax),%al
  8021c2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8021c4:	ff 45 fc             	incl   -0x4(%ebp)
  8021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021cd:	7c e1                	jl     8021b0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8021cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8021d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8021dd:	eb 1f                	jmp    8021fe <strcconcat+0x80>
		final[s++] = str2[i] ;
  8021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e2:	8d 50 01             	lea    0x1(%eax),%edx
  8021e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8021e8:	89 c2                	mov    %eax,%edx
  8021ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ed:	01 c2                	add    %eax,%edx
  8021ef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8021f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f5:	01 c8                	add    %ecx,%eax
  8021f7:	8a 00                	mov    (%eax),%al
  8021f9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8021fb:	ff 45 f8             	incl   -0x8(%ebp)
  8021fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802201:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802204:	7c d9                	jl     8021df <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802206:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	c6 00 00             	movb   $0x0,(%eax)
}
  802211:	90                   	nop
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802217:	8b 45 14             	mov    0x14(%ebp),%eax
  80221a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802220:	8b 45 14             	mov    0x14(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80222c:	8b 45 10             	mov    0x10(%ebp),%eax
  80222f:	01 d0                	add    %edx,%eax
  802231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802237:	eb 0c                	jmp    802245 <strsplit+0x31>
			*string++ = 0;
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8d 50 01             	lea    0x1(%eax),%edx
  80223f:	89 55 08             	mov    %edx,0x8(%ebp)
  802242:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8a 00                	mov    (%eax),%al
  80224a:	84 c0                	test   %al,%al
  80224c:	74 18                	je     802266 <strsplit+0x52>
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	8a 00                	mov    (%eax),%al
  802253:	0f be c0             	movsbl %al,%eax
  802256:	50                   	push   %eax
  802257:	ff 75 0c             	pushl  0xc(%ebp)
  80225a:	e8 13 fb ff ff       	call   801d72 <strchr>
  80225f:	83 c4 08             	add    $0x8,%esp
  802262:	85 c0                	test   %eax,%eax
  802264:	75 d3                	jne    802239 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8a 00                	mov    (%eax),%al
  80226b:	84 c0                	test   %al,%al
  80226d:	74 5a                	je     8022c9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80226f:	8b 45 14             	mov    0x14(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	83 f8 0f             	cmp    $0xf,%eax
  802277:	75 07                	jne    802280 <strsplit+0x6c>
		{
			return 0;
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	eb 66                	jmp    8022e6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802280:	8b 45 14             	mov    0x14(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	8d 48 01             	lea    0x1(%eax),%ecx
  802288:	8b 55 14             	mov    0x14(%ebp),%edx
  80228b:	89 0a                	mov    %ecx,(%edx)
  80228d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802294:	8b 45 10             	mov    0x10(%ebp),%eax
  802297:	01 c2                	add    %eax,%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80229e:	eb 03                	jmp    8022a3 <strsplit+0x8f>
			string++;
  8022a0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8a 00                	mov    (%eax),%al
  8022a8:	84 c0                	test   %al,%al
  8022aa:	74 8b                	je     802237 <strsplit+0x23>
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8a 00                	mov    (%eax),%al
  8022b1:	0f be c0             	movsbl %al,%eax
  8022b4:	50                   	push   %eax
  8022b5:	ff 75 0c             	pushl  0xc(%ebp)
  8022b8:	e8 b5 fa ff ff       	call   801d72 <strchr>
  8022bd:	83 c4 08             	add    $0x8,%esp
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	74 dc                	je     8022a0 <strsplit+0x8c>
			string++;
	}
  8022c4:	e9 6e ff ff ff       	jmp    802237 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8022c9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8022ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8022e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8022ee:	a1 04 60 80 00       	mov    0x806004,%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	74 1f                	je     802316 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8022f7:	e8 1d 00 00 00       	call   802319 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	68 10 4e 80 00       	push   $0x804e10
  802304:	e8 55 f2 ff ff       	call   80155e <cprintf>
  802309:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80230c:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  802313:	00 00 00 
	}
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80231f:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  802326:	00 00 00 
  802329:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  802330:	00 00 00 
  802333:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  80233a:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80233d:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  802344:	00 00 00 
  802347:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  80234e:	00 00 00 
  802351:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  802358:	00 00 00 
	uint32 arr_size = 0;
  80235b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  802362:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  802369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802371:	2d 00 10 00 00       	sub    $0x1000,%eax
  802376:	a3 50 60 80 00       	mov    %eax,0x806050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80237b:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  802382:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  802385:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80238c:	a1 20 61 80 00       	mov    0x806120,%eax
  802391:	c1 e0 04             	shl    $0x4,%eax
  802394:	89 c2                	mov    %eax,%edx
  802396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802399:	01 d0                	add    %edx,%eax
  80239b:	48                   	dec    %eax
  80239c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80239f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a7:	f7 75 ec             	divl   -0x14(%ebp)
  8023aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023ad:	29 d0                	sub    %edx,%eax
  8023af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8023b2:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8023b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8023c1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023c6:	83 ec 04             	sub    $0x4,%esp
  8023c9:	6a 06                	push   $0x6
  8023cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8023ce:	50                   	push   %eax
  8023cf:	e8 b5 03 00 00       	call   802789 <sys_allocate_chunk>
  8023d4:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8023d7:	a1 20 61 80 00       	mov    0x806120,%eax
  8023dc:	83 ec 0c             	sub    $0xc,%esp
  8023df:	50                   	push   %eax
  8023e0:	e8 2a 0a 00 00       	call   802e0f <initialize_MemBlocksList>
  8023e5:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023e8:	a1 48 61 80 00       	mov    0x806148,%eax
  8023ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8023f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f3:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8023fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023fd:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  802404:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802408:	75 14                	jne    80241e <initialize_dyn_block_system+0x105>
  80240a:	83 ec 04             	sub    $0x4,%esp
  80240d:	68 35 4e 80 00       	push   $0x804e35
  802412:	6a 33                	push   $0x33
  802414:	68 53 4e 80 00       	push   $0x804e53
  802419:	e8 8c ee ff ff       	call   8012aa <_panic>
  80241e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802421:	8b 00                	mov    (%eax),%eax
  802423:	85 c0                	test   %eax,%eax
  802425:	74 10                	je     802437 <initialize_dyn_block_system+0x11e>
  802427:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80242a:	8b 00                	mov    (%eax),%eax
  80242c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80242f:	8b 52 04             	mov    0x4(%edx),%edx
  802432:	89 50 04             	mov    %edx,0x4(%eax)
  802435:	eb 0b                	jmp    802442 <initialize_dyn_block_system+0x129>
  802437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80243a:	8b 40 04             	mov    0x4(%eax),%eax
  80243d:	a3 4c 61 80 00       	mov    %eax,0x80614c
  802442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802445:	8b 40 04             	mov    0x4(%eax),%eax
  802448:	85 c0                	test   %eax,%eax
  80244a:	74 0f                	je     80245b <initialize_dyn_block_system+0x142>
  80244c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80244f:	8b 40 04             	mov    0x4(%eax),%eax
  802452:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802455:	8b 12                	mov    (%edx),%edx
  802457:	89 10                	mov    %edx,(%eax)
  802459:	eb 0a                	jmp    802465 <initialize_dyn_block_system+0x14c>
  80245b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80245e:	8b 00                	mov    (%eax),%eax
  802460:	a3 48 61 80 00       	mov    %eax,0x806148
  802465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802468:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802471:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802478:	a1 54 61 80 00       	mov    0x806154,%eax
  80247d:	48                   	dec    %eax
  80247e:	a3 54 61 80 00       	mov    %eax,0x806154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  802483:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802487:	75 14                	jne    80249d <initialize_dyn_block_system+0x184>
  802489:	83 ec 04             	sub    $0x4,%esp
  80248c:	68 60 4e 80 00       	push   $0x804e60
  802491:	6a 34                	push   $0x34
  802493:	68 53 4e 80 00       	push   $0x804e53
  802498:	e8 0d ee ff ff       	call   8012aa <_panic>
  80249d:	8b 15 38 61 80 00    	mov    0x806138,%edx
  8024a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a6:	89 10                	mov    %edx,(%eax)
  8024a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ab:	8b 00                	mov    (%eax),%eax
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	74 0d                	je     8024be <initialize_dyn_block_system+0x1a5>
  8024b1:	a1 38 61 80 00       	mov    0x806138,%eax
  8024b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024b9:	89 50 04             	mov    %edx,0x4(%eax)
  8024bc:	eb 08                	jmp    8024c6 <initialize_dyn_block_system+0x1ad>
  8024be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c1:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8024c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c9:	a3 38 61 80 00       	mov    %eax,0x806138
  8024ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d8:	a1 44 61 80 00       	mov    0x806144,%eax
  8024dd:	40                   	inc    %eax
  8024de:	a3 44 61 80 00       	mov    %eax,0x806144
}
  8024e3:	90                   	nop
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8024ec:	e8 f7 fd ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8024f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024f5:	75 07                	jne    8024fe <malloc+0x18>
  8024f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fc:	eb 14                	jmp    802512 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	68 84 4e 80 00       	push   $0x804e84
  802506:	6a 46                	push   $0x46
  802508:	68 53 4e 80 00       	push   $0x804e53
  80250d:	e8 98 ed ff ff       	call   8012aa <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80251a:	83 ec 04             	sub    $0x4,%esp
  80251d:	68 ac 4e 80 00       	push   $0x804eac
  802522:	6a 61                	push   $0x61
  802524:	68 53 4e 80 00       	push   $0x804e53
  802529:	e8 7c ed ff ff       	call   8012aa <_panic>

0080252e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
  802531:	83 ec 18             	sub    $0x18,%esp
  802534:	8b 45 10             	mov    0x10(%ebp),%eax
  802537:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80253a:	e8 a9 fd ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  80253f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802543:	75 07                	jne    80254c <smalloc+0x1e>
  802545:	b8 00 00 00 00       	mov    $0x0,%eax
  80254a:	eb 14                	jmp    802560 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80254c:	83 ec 04             	sub    $0x4,%esp
  80254f:	68 d0 4e 80 00       	push   $0x804ed0
  802554:	6a 76                	push   $0x76
  802556:	68 53 4e 80 00       	push   $0x804e53
  80255b:	e8 4a ed ff ff       	call   8012aa <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802568:	e8 7b fd ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80256d:	83 ec 04             	sub    $0x4,%esp
  802570:	68 f8 4e 80 00       	push   $0x804ef8
  802575:	68 93 00 00 00       	push   $0x93
  80257a:	68 53 4e 80 00       	push   $0x804e53
  80257f:	e8 26 ed ff ff       	call   8012aa <_panic>

00802584 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80258a:	e8 59 fd ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80258f:	83 ec 04             	sub    $0x4,%esp
  802592:	68 1c 4f 80 00       	push   $0x804f1c
  802597:	68 c5 00 00 00       	push   $0xc5
  80259c:	68 53 4e 80 00       	push   $0x804e53
  8025a1:	e8 04 ed ff ff       	call   8012aa <_panic>

008025a6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8025ac:	83 ec 04             	sub    $0x4,%esp
  8025af:	68 44 4f 80 00       	push   $0x804f44
  8025b4:	68 d9 00 00 00       	push   $0xd9
  8025b9:	68 53 4e 80 00       	push   $0x804e53
  8025be:	e8 e7 ec ff ff       	call   8012aa <_panic>

008025c3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
  8025c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025c9:	83 ec 04             	sub    $0x4,%esp
  8025cc:	68 68 4f 80 00       	push   $0x804f68
  8025d1:	68 e4 00 00 00       	push   $0xe4
  8025d6:	68 53 4e 80 00       	push   $0x804e53
  8025db:	e8 ca ec ff ff       	call   8012aa <_panic>

008025e0 <shrink>:

}
void shrink(uint32 newSize)
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
  8025e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025e6:	83 ec 04             	sub    $0x4,%esp
  8025e9:	68 68 4f 80 00       	push   $0x804f68
  8025ee:	68 e9 00 00 00       	push   $0xe9
  8025f3:	68 53 4e 80 00       	push   $0x804e53
  8025f8:	e8 ad ec ff ff       	call   8012aa <_panic>

008025fd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
  802600:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802603:	83 ec 04             	sub    $0x4,%esp
  802606:	68 68 4f 80 00       	push   $0x804f68
  80260b:	68 ee 00 00 00       	push   $0xee
  802610:	68 53 4e 80 00       	push   $0x804e53
  802615:	e8 90 ec ff ff       	call   8012aa <_panic>

0080261a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	57                   	push   %edi
  80261e:	56                   	push   %esi
  80261f:	53                   	push   %ebx
  802620:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	8b 55 0c             	mov    0xc(%ebp),%edx
  802629:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80262c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80262f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802632:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802635:	cd 30                	int    $0x30
  802637:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80263a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80263d:	83 c4 10             	add    $0x10,%esp
  802640:	5b                   	pop    %ebx
  802641:	5e                   	pop    %esi
  802642:	5f                   	pop    %edi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    

00802645 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 04             	sub    $0x4,%esp
  80264b:	8b 45 10             	mov    0x10(%ebp),%eax
  80264e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802651:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	52                   	push   %edx
  80265d:	ff 75 0c             	pushl  0xc(%ebp)
  802660:	50                   	push   %eax
  802661:	6a 00                	push   $0x0
  802663:	e8 b2 ff ff ff       	call   80261a <syscall>
  802668:	83 c4 18             	add    $0x18,%esp
}
  80266b:	90                   	nop
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <sys_cgetc>:

int
sys_cgetc(void)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 01                	push   $0x1
  80267d:	e8 98 ff ff ff       	call   80261a <syscall>
  802682:	83 c4 18             	add    $0x18,%esp
}
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80268a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268d:	8b 45 08             	mov    0x8(%ebp),%eax
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	52                   	push   %edx
  802697:	50                   	push   %eax
  802698:	6a 05                	push   $0x5
  80269a:	e8 7b ff ff ff       	call   80261a <syscall>
  80269f:	83 c4 18             	add    $0x18,%esp
}
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	56                   	push   %esi
  8026a8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8026a9:	8b 75 18             	mov    0x18(%ebp),%esi
  8026ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b8:	56                   	push   %esi
  8026b9:	53                   	push   %ebx
  8026ba:	51                   	push   %ecx
  8026bb:	52                   	push   %edx
  8026bc:	50                   	push   %eax
  8026bd:	6a 06                	push   $0x6
  8026bf:	e8 56 ff ff ff       	call   80261a <syscall>
  8026c4:	83 c4 18             	add    $0x18,%esp
}
  8026c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026ca:	5b                   	pop    %ebx
  8026cb:	5e                   	pop    %esi
  8026cc:	5d                   	pop    %ebp
  8026cd:	c3                   	ret    

008026ce <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8026d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	52                   	push   %edx
  8026de:	50                   	push   %eax
  8026df:	6a 07                	push   $0x7
  8026e1:	e8 34 ff ff ff       	call   80261a <syscall>
  8026e6:	83 c4 18             	add    $0x18,%esp
}
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8026ee:	6a 00                	push   $0x0
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	ff 75 0c             	pushl  0xc(%ebp)
  8026f7:	ff 75 08             	pushl  0x8(%ebp)
  8026fa:	6a 08                	push   $0x8
  8026fc:	e8 19 ff ff ff       	call   80261a <syscall>
  802701:	83 c4 18             	add    $0x18,%esp
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 09                	push   $0x9
  802715:	e8 00 ff ff ff       	call   80261a <syscall>
  80271a:	83 c4 18             	add    $0x18,%esp
}
  80271d:	c9                   	leave  
  80271e:	c3                   	ret    

0080271f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80271f:	55                   	push   %ebp
  802720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 0a                	push   $0xa
  80272e:	e8 e7 fe ff ff       	call   80261a <syscall>
  802733:	83 c4 18             	add    $0x18,%esp
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 0b                	push   $0xb
  802747:	e8 ce fe ff ff       	call   80261a <syscall>
  80274c:	83 c4 18             	add    $0x18,%esp
}
  80274f:	c9                   	leave  
  802750:	c3                   	ret    

00802751 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	ff 75 0c             	pushl  0xc(%ebp)
  80275d:	ff 75 08             	pushl  0x8(%ebp)
  802760:	6a 0f                	push   $0xf
  802762:	e8 b3 fe ff ff       	call   80261a <syscall>
  802767:	83 c4 18             	add    $0x18,%esp
	return;
  80276a:	90                   	nop
}
  80276b:	c9                   	leave  
  80276c:	c3                   	ret    

0080276d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80276d:	55                   	push   %ebp
  80276e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	ff 75 0c             	pushl  0xc(%ebp)
  802779:	ff 75 08             	pushl  0x8(%ebp)
  80277c:	6a 10                	push   $0x10
  80277e:	e8 97 fe ff ff       	call   80261a <syscall>
  802783:	83 c4 18             	add    $0x18,%esp
	return ;
  802786:	90                   	nop
}
  802787:	c9                   	leave  
  802788:	c3                   	ret    

00802789 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802789:	55                   	push   %ebp
  80278a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	ff 75 10             	pushl  0x10(%ebp)
  802793:	ff 75 0c             	pushl  0xc(%ebp)
  802796:	ff 75 08             	pushl  0x8(%ebp)
  802799:	6a 11                	push   $0x11
  80279b:	e8 7a fe ff ff       	call   80261a <syscall>
  8027a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8027a3:	90                   	nop
}
  8027a4:	c9                   	leave  
  8027a5:	c3                   	ret    

008027a6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 0c                	push   $0xc
  8027b5:	e8 60 fe ff ff       	call   80261a <syscall>
  8027ba:	83 c4 18             	add    $0x18,%esp
}
  8027bd:	c9                   	leave  
  8027be:	c3                   	ret    

008027bf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8027bf:	55                   	push   %ebp
  8027c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	ff 75 08             	pushl  0x8(%ebp)
  8027cd:	6a 0d                	push   $0xd
  8027cf:	e8 46 fe ff ff       	call   80261a <syscall>
  8027d4:	83 c4 18             	add    $0x18,%esp
}
  8027d7:	c9                   	leave  
  8027d8:	c3                   	ret    

008027d9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8027d9:	55                   	push   %ebp
  8027da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8027dc:	6a 00                	push   $0x0
  8027de:	6a 00                	push   $0x0
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 00                	push   $0x0
  8027e4:	6a 00                	push   $0x0
  8027e6:	6a 0e                	push   $0xe
  8027e8:	e8 2d fe ff ff       	call   80261a <syscall>
  8027ed:	83 c4 18             	add    $0x18,%esp
}
  8027f0:	90                   	nop
  8027f1:	c9                   	leave  
  8027f2:	c3                   	ret    

008027f3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 00                	push   $0x0
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	6a 13                	push   $0x13
  802802:	e8 13 fe ff ff       	call   80261a <syscall>
  802807:	83 c4 18             	add    $0x18,%esp
}
  80280a:	90                   	nop
  80280b:	c9                   	leave  
  80280c:	c3                   	ret    

0080280d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	6a 14                	push   $0x14
  80281c:	e8 f9 fd ff ff       	call   80261a <syscall>
  802821:	83 c4 18             	add    $0x18,%esp
}
  802824:	90                   	nop
  802825:	c9                   	leave  
  802826:	c3                   	ret    

00802827 <sys_cputc>:


void
sys_cputc(const char c)
{
  802827:	55                   	push   %ebp
  802828:	89 e5                	mov    %esp,%ebp
  80282a:	83 ec 04             	sub    $0x4,%esp
  80282d:	8b 45 08             	mov    0x8(%ebp),%eax
  802830:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802833:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802837:	6a 00                	push   $0x0
  802839:	6a 00                	push   $0x0
  80283b:	6a 00                	push   $0x0
  80283d:	6a 00                	push   $0x0
  80283f:	50                   	push   %eax
  802840:	6a 15                	push   $0x15
  802842:	e8 d3 fd ff ff       	call   80261a <syscall>
  802847:	83 c4 18             	add    $0x18,%esp
}
  80284a:	90                   	nop
  80284b:	c9                   	leave  
  80284c:	c3                   	ret    

0080284d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80284d:	55                   	push   %ebp
  80284e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802850:	6a 00                	push   $0x0
  802852:	6a 00                	push   $0x0
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 16                	push   $0x16
  80285c:	e8 b9 fd ff ff       	call   80261a <syscall>
  802861:	83 c4 18             	add    $0x18,%esp
}
  802864:	90                   	nop
  802865:	c9                   	leave  
  802866:	c3                   	ret    

00802867 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802867:	55                   	push   %ebp
  802868:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80286a:	8b 45 08             	mov    0x8(%ebp),%eax
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	ff 75 0c             	pushl  0xc(%ebp)
  802876:	50                   	push   %eax
  802877:	6a 17                	push   $0x17
  802879:	e8 9c fd ff ff       	call   80261a <syscall>
  80287e:	83 c4 18             	add    $0x18,%esp
}
  802881:	c9                   	leave  
  802882:	c3                   	ret    

00802883 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802883:	55                   	push   %ebp
  802884:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802886:	8b 55 0c             	mov    0xc(%ebp),%edx
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	6a 00                	push   $0x0
  80288e:	6a 00                	push   $0x0
  802890:	6a 00                	push   $0x0
  802892:	52                   	push   %edx
  802893:	50                   	push   %eax
  802894:	6a 1a                	push   $0x1a
  802896:	e8 7f fd ff ff       	call   80261a <syscall>
  80289b:	83 c4 18             	add    $0x18,%esp
}
  80289e:	c9                   	leave  
  80289f:	c3                   	ret    

008028a0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8028a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 00                	push   $0x0
  8028af:	52                   	push   %edx
  8028b0:	50                   	push   %eax
  8028b1:	6a 18                	push   $0x18
  8028b3:	e8 62 fd ff ff       	call   80261a <syscall>
  8028b8:	83 c4 18             	add    $0x18,%esp
}
  8028bb:	90                   	nop
  8028bc:	c9                   	leave  
  8028bd:	c3                   	ret    

008028be <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8028be:	55                   	push   %ebp
  8028bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8028c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	52                   	push   %edx
  8028ce:	50                   	push   %eax
  8028cf:	6a 19                	push   $0x19
  8028d1:	e8 44 fd ff ff       	call   80261a <syscall>
  8028d6:	83 c4 18             	add    $0x18,%esp
}
  8028d9:	90                   	nop
  8028da:	c9                   	leave  
  8028db:	c3                   	ret    

008028dc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8028dc:	55                   	push   %ebp
  8028dd:	89 e5                	mov    %esp,%ebp
  8028df:	83 ec 04             	sub    $0x4,%esp
  8028e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8028e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8028e8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8028eb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	6a 00                	push   $0x0
  8028f4:	51                   	push   %ecx
  8028f5:	52                   	push   %edx
  8028f6:	ff 75 0c             	pushl  0xc(%ebp)
  8028f9:	50                   	push   %eax
  8028fa:	6a 1b                	push   $0x1b
  8028fc:	e8 19 fd ff ff       	call   80261a <syscall>
  802901:	83 c4 18             	add    $0x18,%esp
}
  802904:	c9                   	leave  
  802905:	c3                   	ret    

00802906 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	52                   	push   %edx
  802916:	50                   	push   %eax
  802917:	6a 1c                	push   $0x1c
  802919:	e8 fc fc ff ff       	call   80261a <syscall>
  80291e:	83 c4 18             	add    $0x18,%esp
}
  802921:	c9                   	leave  
  802922:	c3                   	ret    

00802923 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802923:	55                   	push   %ebp
  802924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802926:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802929:	8b 55 0c             	mov    0xc(%ebp),%edx
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	6a 00                	push   $0x0
  802931:	6a 00                	push   $0x0
  802933:	51                   	push   %ecx
  802934:	52                   	push   %edx
  802935:	50                   	push   %eax
  802936:	6a 1d                	push   $0x1d
  802938:	e8 dd fc ff ff       	call   80261a <syscall>
  80293d:	83 c4 18             	add    $0x18,%esp
}
  802940:	c9                   	leave  
  802941:	c3                   	ret    

00802942 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802942:	55                   	push   %ebp
  802943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802945:	8b 55 0c             	mov    0xc(%ebp),%edx
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 00                	push   $0x0
  802951:	52                   	push   %edx
  802952:	50                   	push   %eax
  802953:	6a 1e                	push   $0x1e
  802955:	e8 c0 fc ff ff       	call   80261a <syscall>
  80295a:	83 c4 18             	add    $0x18,%esp
}
  80295d:	c9                   	leave  
  80295e:	c3                   	ret    

0080295f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80295f:	55                   	push   %ebp
  802960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802962:	6a 00                	push   $0x0
  802964:	6a 00                	push   $0x0
  802966:	6a 00                	push   $0x0
  802968:	6a 00                	push   $0x0
  80296a:	6a 00                	push   $0x0
  80296c:	6a 1f                	push   $0x1f
  80296e:	e8 a7 fc ff ff       	call   80261a <syscall>
  802973:	83 c4 18             	add    $0x18,%esp
}
  802976:	c9                   	leave  
  802977:	c3                   	ret    

00802978 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802978:	55                   	push   %ebp
  802979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	6a 00                	push   $0x0
  802980:	ff 75 14             	pushl  0x14(%ebp)
  802983:	ff 75 10             	pushl  0x10(%ebp)
  802986:	ff 75 0c             	pushl  0xc(%ebp)
  802989:	50                   	push   %eax
  80298a:	6a 20                	push   $0x20
  80298c:	e8 89 fc ff ff       	call   80261a <syscall>
  802991:	83 c4 18             	add    $0x18,%esp
}
  802994:	c9                   	leave  
  802995:	c3                   	ret    

00802996 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802996:	55                   	push   %ebp
  802997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	6a 00                	push   $0x0
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 00                	push   $0x0
  8029a4:	50                   	push   %eax
  8029a5:	6a 21                	push   $0x21
  8029a7:	e8 6e fc ff ff       	call   80261a <syscall>
  8029ac:	83 c4 18             	add    $0x18,%esp
}
  8029af:	90                   	nop
  8029b0:	c9                   	leave  
  8029b1:	c3                   	ret    

008029b2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8029b2:	55                   	push   %ebp
  8029b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b8:	6a 00                	push   $0x0
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	50                   	push   %eax
  8029c1:	6a 22                	push   $0x22
  8029c3:	e8 52 fc ff ff       	call   80261a <syscall>
  8029c8:	83 c4 18             	add    $0x18,%esp
}
  8029cb:	c9                   	leave  
  8029cc:	c3                   	ret    

008029cd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 02                	push   $0x2
  8029dc:	e8 39 fc ff ff       	call   80261a <syscall>
  8029e1:	83 c4 18             	add    $0x18,%esp
}
  8029e4:	c9                   	leave  
  8029e5:	c3                   	ret    

008029e6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8029e6:	55                   	push   %ebp
  8029e7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8029e9:	6a 00                	push   $0x0
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 00                	push   $0x0
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 03                	push   $0x3
  8029f5:	e8 20 fc ff ff       	call   80261a <syscall>
  8029fa:	83 c4 18             	add    $0x18,%esp
}
  8029fd:	c9                   	leave  
  8029fe:	c3                   	ret    

008029ff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8029ff:	55                   	push   %ebp
  802a00:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 04                	push   $0x4
  802a0e:	e8 07 fc ff ff       	call   80261a <syscall>
  802a13:	83 c4 18             	add    $0x18,%esp
}
  802a16:	c9                   	leave  
  802a17:	c3                   	ret    

00802a18 <sys_exit_env>:


void sys_exit_env(void)
{
  802a18:	55                   	push   %ebp
  802a19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	6a 00                	push   $0x0
  802a21:	6a 00                	push   $0x0
  802a23:	6a 00                	push   $0x0
  802a25:	6a 23                	push   $0x23
  802a27:	e8 ee fb ff ff       	call   80261a <syscall>
  802a2c:	83 c4 18             	add    $0x18,%esp
}
  802a2f:	90                   	nop
  802a30:	c9                   	leave  
  802a31:	c3                   	ret    

00802a32 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802a32:	55                   	push   %ebp
  802a33:	89 e5                	mov    %esp,%ebp
  802a35:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802a38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a3b:	8d 50 04             	lea    0x4(%eax),%edx
  802a3e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a41:	6a 00                	push   $0x0
  802a43:	6a 00                	push   $0x0
  802a45:	6a 00                	push   $0x0
  802a47:	52                   	push   %edx
  802a48:	50                   	push   %eax
  802a49:	6a 24                	push   $0x24
  802a4b:	e8 ca fb ff ff       	call   80261a <syscall>
  802a50:	83 c4 18             	add    $0x18,%esp
	return result;
  802a53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a5c:	89 01                	mov    %eax,(%ecx)
  802a5e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	c9                   	leave  
  802a65:	c2 04 00             	ret    $0x4

00802a68 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a68:	55                   	push   %ebp
  802a69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a6b:	6a 00                	push   $0x0
  802a6d:	6a 00                	push   $0x0
  802a6f:	ff 75 10             	pushl  0x10(%ebp)
  802a72:	ff 75 0c             	pushl  0xc(%ebp)
  802a75:	ff 75 08             	pushl  0x8(%ebp)
  802a78:	6a 12                	push   $0x12
  802a7a:	e8 9b fb ff ff       	call   80261a <syscall>
  802a7f:	83 c4 18             	add    $0x18,%esp
	return ;
  802a82:	90                   	nop
}
  802a83:	c9                   	leave  
  802a84:	c3                   	ret    

00802a85 <sys_rcr2>:
uint32 sys_rcr2()
{
  802a85:	55                   	push   %ebp
  802a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802a88:	6a 00                	push   $0x0
  802a8a:	6a 00                	push   $0x0
  802a8c:	6a 00                	push   $0x0
  802a8e:	6a 00                	push   $0x0
  802a90:	6a 00                	push   $0x0
  802a92:	6a 25                	push   $0x25
  802a94:	e8 81 fb ff ff       	call   80261a <syscall>
  802a99:	83 c4 18             	add    $0x18,%esp
}
  802a9c:	c9                   	leave  
  802a9d:	c3                   	ret    

00802a9e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802a9e:	55                   	push   %ebp
  802a9f:	89 e5                	mov    %esp,%ebp
  802aa1:	83 ec 04             	sub    $0x4,%esp
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802aaa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 00                	push   $0x0
  802ab6:	50                   	push   %eax
  802ab7:	6a 26                	push   $0x26
  802ab9:	e8 5c fb ff ff       	call   80261a <syscall>
  802abe:	83 c4 18             	add    $0x18,%esp
	return ;
  802ac1:	90                   	nop
}
  802ac2:	c9                   	leave  
  802ac3:	c3                   	ret    

00802ac4 <rsttst>:
void rsttst()
{
  802ac4:	55                   	push   %ebp
  802ac5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	6a 00                	push   $0x0
  802ad1:	6a 28                	push   $0x28
  802ad3:	e8 42 fb ff ff       	call   80261a <syscall>
  802ad8:	83 c4 18             	add    $0x18,%esp
	return ;
  802adb:	90                   	nop
}
  802adc:	c9                   	leave  
  802add:	c3                   	ret    

00802ade <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802ade:	55                   	push   %ebp
  802adf:	89 e5                	mov    %esp,%ebp
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  802ae7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802aea:	8b 55 18             	mov    0x18(%ebp),%edx
  802aed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802af1:	52                   	push   %edx
  802af2:	50                   	push   %eax
  802af3:	ff 75 10             	pushl  0x10(%ebp)
  802af6:	ff 75 0c             	pushl  0xc(%ebp)
  802af9:	ff 75 08             	pushl  0x8(%ebp)
  802afc:	6a 27                	push   $0x27
  802afe:	e8 17 fb ff ff       	call   80261a <syscall>
  802b03:	83 c4 18             	add    $0x18,%esp
	return ;
  802b06:	90                   	nop
}
  802b07:	c9                   	leave  
  802b08:	c3                   	ret    

00802b09 <chktst>:
void chktst(uint32 n)
{
  802b09:	55                   	push   %ebp
  802b0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b0c:	6a 00                	push   $0x0
  802b0e:	6a 00                	push   $0x0
  802b10:	6a 00                	push   $0x0
  802b12:	6a 00                	push   $0x0
  802b14:	ff 75 08             	pushl  0x8(%ebp)
  802b17:	6a 29                	push   $0x29
  802b19:	e8 fc fa ff ff       	call   80261a <syscall>
  802b1e:	83 c4 18             	add    $0x18,%esp
	return ;
  802b21:	90                   	nop
}
  802b22:	c9                   	leave  
  802b23:	c3                   	ret    

00802b24 <inctst>:

void inctst()
{
  802b24:	55                   	push   %ebp
  802b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 00                	push   $0x0
  802b2d:	6a 00                	push   $0x0
  802b2f:	6a 00                	push   $0x0
  802b31:	6a 2a                	push   $0x2a
  802b33:	e8 e2 fa ff ff       	call   80261a <syscall>
  802b38:	83 c4 18             	add    $0x18,%esp
	return ;
  802b3b:	90                   	nop
}
  802b3c:	c9                   	leave  
  802b3d:	c3                   	ret    

00802b3e <gettst>:
uint32 gettst()
{
  802b3e:	55                   	push   %ebp
  802b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	6a 00                	push   $0x0
  802b4b:	6a 2b                	push   $0x2b
  802b4d:	e8 c8 fa ff ff       	call   80261a <syscall>
  802b52:	83 c4 18             	add    $0x18,%esp
}
  802b55:	c9                   	leave  
  802b56:	c3                   	ret    

00802b57 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802b57:	55                   	push   %ebp
  802b58:	89 e5                	mov    %esp,%ebp
  802b5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	6a 00                	push   $0x0
  802b63:	6a 00                	push   $0x0
  802b65:	6a 00                	push   $0x0
  802b67:	6a 2c                	push   $0x2c
  802b69:	e8 ac fa ff ff       	call   80261a <syscall>
  802b6e:	83 c4 18             	add    $0x18,%esp
  802b71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802b74:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802b78:	75 07                	jne    802b81 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b7f:	eb 05                	jmp    802b86 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b86:	c9                   	leave  
  802b87:	c3                   	ret    

00802b88 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802b88:	55                   	push   %ebp
  802b89:	89 e5                	mov    %esp,%ebp
  802b8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 00                	push   $0x0
  802b92:	6a 00                	push   $0x0
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	6a 2c                	push   $0x2c
  802b9a:	e8 7b fa ff ff       	call   80261a <syscall>
  802b9f:	83 c4 18             	add    $0x18,%esp
  802ba2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802ba5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802ba9:	75 07                	jne    802bb2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802bab:	b8 01 00 00 00       	mov    $0x1,%eax
  802bb0:	eb 05                	jmp    802bb7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802bb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb7:	c9                   	leave  
  802bb8:	c3                   	ret    

00802bb9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802bb9:	55                   	push   %ebp
  802bba:	89 e5                	mov    %esp,%ebp
  802bbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 00                	push   $0x0
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	6a 2c                	push   $0x2c
  802bcb:	e8 4a fa ff ff       	call   80261a <syscall>
  802bd0:	83 c4 18             	add    $0x18,%esp
  802bd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802bd6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802bda:	75 07                	jne    802be3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802bdc:	b8 01 00 00 00       	mov    $0x1,%eax
  802be1:	eb 05                	jmp    802be8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be8:	c9                   	leave  
  802be9:	c3                   	ret    

00802bea <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802bea:	55                   	push   %ebp
  802beb:	89 e5                	mov    %esp,%ebp
  802bed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bf0:	6a 00                	push   $0x0
  802bf2:	6a 00                	push   $0x0
  802bf4:	6a 00                	push   $0x0
  802bf6:	6a 00                	push   $0x0
  802bf8:	6a 00                	push   $0x0
  802bfa:	6a 2c                	push   $0x2c
  802bfc:	e8 19 fa ff ff       	call   80261a <syscall>
  802c01:	83 c4 18             	add    $0x18,%esp
  802c04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802c07:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802c0b:	75 07                	jne    802c14 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802c0d:	b8 01 00 00 00       	mov    $0x1,%eax
  802c12:	eb 05                	jmp    802c19 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802c14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c19:	c9                   	leave  
  802c1a:	c3                   	ret    

00802c1b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c1b:	55                   	push   %ebp
  802c1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802c1e:	6a 00                	push   $0x0
  802c20:	6a 00                	push   $0x0
  802c22:	6a 00                	push   $0x0
  802c24:	6a 00                	push   $0x0
  802c26:	ff 75 08             	pushl  0x8(%ebp)
  802c29:	6a 2d                	push   $0x2d
  802c2b:	e8 ea f9 ff ff       	call   80261a <syscall>
  802c30:	83 c4 18             	add    $0x18,%esp
	return ;
  802c33:	90                   	nop
}
  802c34:	c9                   	leave  
  802c35:	c3                   	ret    

00802c36 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802c36:	55                   	push   %ebp
  802c37:	89 e5                	mov    %esp,%ebp
  802c39:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802c3a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	6a 00                	push   $0x0
  802c48:	53                   	push   %ebx
  802c49:	51                   	push   %ecx
  802c4a:	52                   	push   %edx
  802c4b:	50                   	push   %eax
  802c4c:	6a 2e                	push   $0x2e
  802c4e:	e8 c7 f9 ff ff       	call   80261a <syscall>
  802c53:	83 c4 18             	add    $0x18,%esp
}
  802c56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c59:	c9                   	leave  
  802c5a:	c3                   	ret    

00802c5b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802c5b:	55                   	push   %ebp
  802c5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	6a 00                	push   $0x0
  802c66:	6a 00                	push   $0x0
  802c68:	6a 00                	push   $0x0
  802c6a:	52                   	push   %edx
  802c6b:	50                   	push   %eax
  802c6c:	6a 2f                	push   $0x2f
  802c6e:	e8 a7 f9 ff ff       	call   80261a <syscall>
  802c73:	83 c4 18             	add    $0x18,%esp
}
  802c76:	c9                   	leave  
  802c77:	c3                   	ret    

00802c78 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802c78:	55                   	push   %ebp
  802c79:	89 e5                	mov    %esp,%ebp
  802c7b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802c7e:	83 ec 0c             	sub    $0xc,%esp
  802c81:	68 78 4f 80 00       	push   $0x804f78
  802c86:	e8 d3 e8 ff ff       	call   80155e <cprintf>
  802c8b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802c8e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802c95:	83 ec 0c             	sub    $0xc,%esp
  802c98:	68 a4 4f 80 00       	push   $0x804fa4
  802c9d:	e8 bc e8 ff ff       	call   80155e <cprintf>
  802ca2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802ca5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ca9:	a1 38 61 80 00       	mov    0x806138,%eax
  802cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb1:	eb 56                	jmp    802d09 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802cb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cb7:	74 1c                	je     802cd5 <print_mem_block_lists+0x5d>
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 50 08             	mov    0x8(%eax),%edx
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	8b 48 08             	mov    0x8(%eax),%ecx
  802cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccb:	01 c8                	add    %ecx,%eax
  802ccd:	39 c2                	cmp    %eax,%edx
  802ccf:	73 04                	jae    802cd5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802cd1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 50 08             	mov    0x8(%eax),%edx
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce1:	01 c2                	add    %eax,%edx
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 08             	mov    0x8(%eax),%eax
  802ce9:	83 ec 04             	sub    $0x4,%esp
  802cec:	52                   	push   %edx
  802ced:	50                   	push   %eax
  802cee:	68 b9 4f 80 00       	push   $0x804fb9
  802cf3:	e8 66 e8 ff ff       	call   80155e <cprintf>
  802cf8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d01:	a1 40 61 80 00       	mov    0x806140,%eax
  802d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0d:	74 07                	je     802d16 <print_mem_block_lists+0x9e>
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	8b 00                	mov    (%eax),%eax
  802d14:	eb 05                	jmp    802d1b <print_mem_block_lists+0xa3>
  802d16:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1b:	a3 40 61 80 00       	mov    %eax,0x806140
  802d20:	a1 40 61 80 00       	mov    0x806140,%eax
  802d25:	85 c0                	test   %eax,%eax
  802d27:	75 8a                	jne    802cb3 <print_mem_block_lists+0x3b>
  802d29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2d:	75 84                	jne    802cb3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802d2f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802d33:	75 10                	jne    802d45 <print_mem_block_lists+0xcd>
  802d35:	83 ec 0c             	sub    $0xc,%esp
  802d38:	68 c8 4f 80 00       	push   $0x804fc8
  802d3d:	e8 1c e8 ff ff       	call   80155e <cprintf>
  802d42:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802d45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802d4c:	83 ec 0c             	sub    $0xc,%esp
  802d4f:	68 ec 4f 80 00       	push   $0x804fec
  802d54:	e8 05 e8 ff ff       	call   80155e <cprintf>
  802d59:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802d5c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802d60:	a1 40 60 80 00       	mov    0x806040,%eax
  802d65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d68:	eb 56                	jmp    802dc0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802d6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d6e:	74 1c                	je     802d8c <print_mem_block_lists+0x114>
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 50 08             	mov    0x8(%eax),%edx
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	8b 48 08             	mov    0x8(%eax),%ecx
  802d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d82:	01 c8                	add    %ecx,%eax
  802d84:	39 c2                	cmp    %eax,%edx
  802d86:	73 04                	jae    802d8c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802d88:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 50 08             	mov    0x8(%eax),%edx
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	8b 40 0c             	mov    0xc(%eax),%eax
  802d98:	01 c2                	add    %eax,%edx
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 40 08             	mov    0x8(%eax),%eax
  802da0:	83 ec 04             	sub    $0x4,%esp
  802da3:	52                   	push   %edx
  802da4:	50                   	push   %eax
  802da5:	68 b9 4f 80 00       	push   $0x804fb9
  802daa:	e8 af e7 ff ff       	call   80155e <cprintf>
  802daf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802db8:	a1 48 60 80 00       	mov    0x806048,%eax
  802dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc4:	74 07                	je     802dcd <print_mem_block_lists+0x155>
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	eb 05                	jmp    802dd2 <print_mem_block_lists+0x15a>
  802dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd2:	a3 48 60 80 00       	mov    %eax,0x806048
  802dd7:	a1 48 60 80 00       	mov    0x806048,%eax
  802ddc:	85 c0                	test   %eax,%eax
  802dde:	75 8a                	jne    802d6a <print_mem_block_lists+0xf2>
  802de0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de4:	75 84                	jne    802d6a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802de6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802dea:	75 10                	jne    802dfc <print_mem_block_lists+0x184>
  802dec:	83 ec 0c             	sub    $0xc,%esp
  802def:	68 04 50 80 00       	push   $0x805004
  802df4:	e8 65 e7 ff ff       	call   80155e <cprintf>
  802df9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802dfc:	83 ec 0c             	sub    $0xc,%esp
  802dff:	68 78 4f 80 00       	push   $0x804f78
  802e04:	e8 55 e7 ff ff       	call   80155e <cprintf>
  802e09:	83 c4 10             	add    $0x10,%esp

}
  802e0c:	90                   	nop
  802e0d:	c9                   	leave  
  802e0e:	c3                   	ret    

00802e0f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802e0f:	55                   	push   %ebp
  802e10:	89 e5                	mov    %esp,%ebp
  802e12:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802e15:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  802e1c:	00 00 00 
  802e1f:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  802e26:	00 00 00 
  802e29:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  802e30:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802e33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e3a:	e9 9e 00 00 00       	jmp    802edd <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802e3f:	a1 50 60 80 00       	mov    0x806050,%eax
  802e44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e47:	c1 e2 04             	shl    $0x4,%edx
  802e4a:	01 d0                	add    %edx,%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	75 14                	jne    802e64 <initialize_MemBlocksList+0x55>
  802e50:	83 ec 04             	sub    $0x4,%esp
  802e53:	68 2c 50 80 00       	push   $0x80502c
  802e58:	6a 46                	push   $0x46
  802e5a:	68 4f 50 80 00       	push   $0x80504f
  802e5f:	e8 46 e4 ff ff       	call   8012aa <_panic>
  802e64:	a1 50 60 80 00       	mov    0x806050,%eax
  802e69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6c:	c1 e2 04             	shl    $0x4,%edx
  802e6f:	01 d0                	add    %edx,%eax
  802e71:	8b 15 48 61 80 00    	mov    0x806148,%edx
  802e77:	89 10                	mov    %edx,(%eax)
  802e79:	8b 00                	mov    (%eax),%eax
  802e7b:	85 c0                	test   %eax,%eax
  802e7d:	74 18                	je     802e97 <initialize_MemBlocksList+0x88>
  802e7f:	a1 48 61 80 00       	mov    0x806148,%eax
  802e84:	8b 15 50 60 80 00    	mov    0x806050,%edx
  802e8a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802e8d:	c1 e1 04             	shl    $0x4,%ecx
  802e90:	01 ca                	add    %ecx,%edx
  802e92:	89 50 04             	mov    %edx,0x4(%eax)
  802e95:	eb 12                	jmp    802ea9 <initialize_MemBlocksList+0x9a>
  802e97:	a1 50 60 80 00       	mov    0x806050,%eax
  802e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9f:	c1 e2 04             	shl    $0x4,%edx
  802ea2:	01 d0                	add    %edx,%eax
  802ea4:	a3 4c 61 80 00       	mov    %eax,0x80614c
  802ea9:	a1 50 60 80 00       	mov    0x806050,%eax
  802eae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb1:	c1 e2 04             	shl    $0x4,%edx
  802eb4:	01 d0                	add    %edx,%eax
  802eb6:	a3 48 61 80 00       	mov    %eax,0x806148
  802ebb:	a1 50 60 80 00       	mov    0x806050,%eax
  802ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec3:	c1 e2 04             	shl    $0x4,%edx
  802ec6:	01 d0                	add    %edx,%eax
  802ec8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecf:	a1 54 61 80 00       	mov    0x806154,%eax
  802ed4:	40                   	inc    %eax
  802ed5:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802eda:	ff 45 f4             	incl   -0xc(%ebp)
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee3:	0f 82 56 ff ff ff    	jb     802e3f <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802ee9:	90                   	nop
  802eea:	c9                   	leave  
  802eeb:	c3                   	ret    

00802eec <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802eec:	55                   	push   %ebp
  802eed:	89 e5                	mov    %esp,%ebp
  802eef:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	8b 00                	mov    (%eax),%eax
  802ef7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802efa:	eb 19                	jmp    802f15 <find_block+0x29>
	{
		if(va==point->sva)
  802efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802eff:	8b 40 08             	mov    0x8(%eax),%eax
  802f02:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f05:	75 05                	jne    802f0c <find_block+0x20>
		   return point;
  802f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f0a:	eb 36                	jmp    802f42 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	8b 40 08             	mov    0x8(%eax),%eax
  802f12:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802f15:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802f19:	74 07                	je     802f22 <find_block+0x36>
  802f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	eb 05                	jmp    802f27 <find_block+0x3b>
  802f22:	b8 00 00 00 00       	mov    $0x0,%eax
  802f27:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2a:	89 42 08             	mov    %eax,0x8(%edx)
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	8b 40 08             	mov    0x8(%eax),%eax
  802f33:	85 c0                	test   %eax,%eax
  802f35:	75 c5                	jne    802efc <find_block+0x10>
  802f37:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802f3b:	75 bf                	jne    802efc <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802f3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f42:	c9                   	leave  
  802f43:	c3                   	ret    

00802f44 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802f44:	55                   	push   %ebp
  802f45:	89 e5                	mov    %esp,%ebp
  802f47:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802f4a:	a1 40 60 80 00       	mov    0x806040,%eax
  802f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802f52:	a1 44 60 80 00       	mov    0x806044,%eax
  802f57:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802f60:	74 24                	je     802f86 <insert_sorted_allocList+0x42>
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	8b 50 08             	mov    0x8(%eax),%edx
  802f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6b:	8b 40 08             	mov    0x8(%eax),%eax
  802f6e:	39 c2                	cmp    %eax,%edx
  802f70:	76 14                	jbe    802f86 <insert_sorted_allocList+0x42>
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	8b 50 08             	mov    0x8(%eax),%edx
  802f78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7b:	8b 40 08             	mov    0x8(%eax),%eax
  802f7e:	39 c2                	cmp    %eax,%edx
  802f80:	0f 82 60 01 00 00    	jb     8030e6 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802f86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f8a:	75 65                	jne    802ff1 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802f8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f90:	75 14                	jne    802fa6 <insert_sorted_allocList+0x62>
  802f92:	83 ec 04             	sub    $0x4,%esp
  802f95:	68 2c 50 80 00       	push   $0x80502c
  802f9a:	6a 6b                	push   $0x6b
  802f9c:	68 4f 50 80 00       	push   $0x80504f
  802fa1:	e8 04 e3 ff ff       	call   8012aa <_panic>
  802fa6:	8b 15 40 60 80 00    	mov    0x806040,%edx
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	89 10                	mov    %edx,(%eax)
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	8b 00                	mov    (%eax),%eax
  802fb6:	85 c0                	test   %eax,%eax
  802fb8:	74 0d                	je     802fc7 <insert_sorted_allocList+0x83>
  802fba:	a1 40 60 80 00       	mov    0x806040,%eax
  802fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc2:	89 50 04             	mov    %edx,0x4(%eax)
  802fc5:	eb 08                	jmp    802fcf <insert_sorted_allocList+0x8b>
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	a3 44 60 80 00       	mov    %eax,0x806044
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	a3 40 60 80 00       	mov    %eax,0x806040
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe1:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802fe6:	40                   	inc    %eax
  802fe7:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802fec:	e9 dc 01 00 00       	jmp    8031cd <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	8b 50 08             	mov    0x8(%eax),%edx
  802ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffa:	8b 40 08             	mov    0x8(%eax),%eax
  802ffd:	39 c2                	cmp    %eax,%edx
  802fff:	77 6c                	ja     80306d <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  803001:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803005:	74 06                	je     80300d <insert_sorted_allocList+0xc9>
  803007:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300b:	75 14                	jne    803021 <insert_sorted_allocList+0xdd>
  80300d:	83 ec 04             	sub    $0x4,%esp
  803010:	68 68 50 80 00       	push   $0x805068
  803015:	6a 6f                	push   $0x6f
  803017:	68 4f 50 80 00       	push   $0x80504f
  80301c:	e8 89 e2 ff ff       	call   8012aa <_panic>
  803021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803024:	8b 50 04             	mov    0x4(%eax),%edx
  803027:	8b 45 08             	mov    0x8(%ebp),%eax
  80302a:	89 50 04             	mov    %edx,0x4(%eax)
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803033:	89 10                	mov    %edx,(%eax)
  803035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803038:	8b 40 04             	mov    0x4(%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 0d                	je     80304c <insert_sorted_allocList+0x108>
  80303f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	8b 55 08             	mov    0x8(%ebp),%edx
  803048:	89 10                	mov    %edx,(%eax)
  80304a:	eb 08                	jmp    803054 <insert_sorted_allocList+0x110>
  80304c:	8b 45 08             	mov    0x8(%ebp),%eax
  80304f:	a3 40 60 80 00       	mov    %eax,0x806040
  803054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803057:	8b 55 08             	mov    0x8(%ebp),%edx
  80305a:	89 50 04             	mov    %edx,0x4(%eax)
  80305d:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803062:	40                   	inc    %eax
  803063:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803068:	e9 60 01 00 00       	jmp    8031cd <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	8b 50 08             	mov    0x8(%eax),%edx
  803073:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803076:	8b 40 08             	mov    0x8(%eax),%eax
  803079:	39 c2                	cmp    %eax,%edx
  80307b:	0f 82 4c 01 00 00    	jb     8031cd <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  803081:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803085:	75 14                	jne    80309b <insert_sorted_allocList+0x157>
  803087:	83 ec 04             	sub    $0x4,%esp
  80308a:	68 a0 50 80 00       	push   $0x8050a0
  80308f:	6a 73                	push   $0x73
  803091:	68 4f 50 80 00       	push   $0x80504f
  803096:	e8 0f e2 ff ff       	call   8012aa <_panic>
  80309b:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	89 50 04             	mov    %edx,0x4(%eax)
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	8b 40 04             	mov    0x4(%eax),%eax
  8030ad:	85 c0                	test   %eax,%eax
  8030af:	74 0c                	je     8030bd <insert_sorted_allocList+0x179>
  8030b1:	a1 44 60 80 00       	mov    0x806044,%eax
  8030b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b9:	89 10                	mov    %edx,(%eax)
  8030bb:	eb 08                	jmp    8030c5 <insert_sorted_allocList+0x181>
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	a3 40 60 80 00       	mov    %eax,0x806040
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	a3 44 60 80 00       	mov    %eax,0x806044
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d6:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8030db:	40                   	inc    %eax
  8030dc:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8030e1:	e9 e7 00 00 00       	jmp    8031cd <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8030e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8030ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8030f3:	a1 40 60 80 00       	mov    0x806040,%eax
  8030f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030fb:	e9 9d 00 00 00       	jmp    80319d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  803100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  803108:	8b 45 08             	mov    0x8(%ebp),%eax
  80310b:	8b 50 08             	mov    0x8(%eax),%edx
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 40 08             	mov    0x8(%eax),%eax
  803114:	39 c2                	cmp    %eax,%edx
  803116:	76 7d                	jbe    803195 <insert_sorted_allocList+0x251>
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	8b 50 08             	mov    0x8(%eax),%edx
  80311e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803121:	8b 40 08             	mov    0x8(%eax),%eax
  803124:	39 c2                	cmp    %eax,%edx
  803126:	73 6d                	jae    803195 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  803128:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312c:	74 06                	je     803134 <insert_sorted_allocList+0x1f0>
  80312e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803132:	75 14                	jne    803148 <insert_sorted_allocList+0x204>
  803134:	83 ec 04             	sub    $0x4,%esp
  803137:	68 c4 50 80 00       	push   $0x8050c4
  80313c:	6a 7f                	push   $0x7f
  80313e:	68 4f 50 80 00       	push   $0x80504f
  803143:	e8 62 e1 ff ff       	call   8012aa <_panic>
  803148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314b:	8b 10                	mov    (%eax),%edx
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	89 10                	mov    %edx,(%eax)
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	85 c0                	test   %eax,%eax
  803159:	74 0b                	je     803166 <insert_sorted_allocList+0x222>
  80315b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315e:	8b 00                	mov    (%eax),%eax
  803160:	8b 55 08             	mov    0x8(%ebp),%edx
  803163:	89 50 04             	mov    %edx,0x4(%eax)
  803166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803169:	8b 55 08             	mov    0x8(%ebp),%edx
  80316c:	89 10                	mov    %edx,(%eax)
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803174:	89 50 04             	mov    %edx,0x4(%eax)
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	85 c0                	test   %eax,%eax
  80317e:	75 08                	jne    803188 <insert_sorted_allocList+0x244>
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	a3 44 60 80 00       	mov    %eax,0x806044
  803188:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80318d:	40                   	inc    %eax
  80318e:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  803193:	eb 39                	jmp    8031ce <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  803195:	a1 48 60 80 00       	mov    0x806048,%eax
  80319a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80319d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a1:	74 07                	je     8031aa <insert_sorted_allocList+0x266>
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 00                	mov    (%eax),%eax
  8031a8:	eb 05                	jmp    8031af <insert_sorted_allocList+0x26b>
  8031aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8031af:	a3 48 60 80 00       	mov    %eax,0x806048
  8031b4:	a1 48 60 80 00       	mov    0x806048,%eax
  8031b9:	85 c0                	test   %eax,%eax
  8031bb:	0f 85 3f ff ff ff    	jne    803100 <insert_sorted_allocList+0x1bc>
  8031c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c5:	0f 85 35 ff ff ff    	jne    803100 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8031cb:	eb 01                	jmp    8031ce <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8031cd:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8031ce:	90                   	nop
  8031cf:	c9                   	leave  
  8031d0:	c3                   	ret    

008031d1 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8031d1:	55                   	push   %ebp
  8031d2:	89 e5                	mov    %esp,%ebp
  8031d4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8031d7:	a1 38 61 80 00       	mov    0x806138,%eax
  8031dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031df:	e9 85 01 00 00       	jmp    803369 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ed:	0f 82 6e 01 00 00    	jb     803361 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031fc:	0f 85 8a 00 00 00    	jne    80328c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  803202:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803206:	75 17                	jne    80321f <alloc_block_FF+0x4e>
  803208:	83 ec 04             	sub    $0x4,%esp
  80320b:	68 f8 50 80 00       	push   $0x8050f8
  803210:	68 93 00 00 00       	push   $0x93
  803215:	68 4f 50 80 00       	push   $0x80504f
  80321a:	e8 8b e0 ff ff       	call   8012aa <_panic>
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	85 c0                	test   %eax,%eax
  803226:	74 10                	je     803238 <alloc_block_FF+0x67>
  803228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322b:	8b 00                	mov    (%eax),%eax
  80322d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803230:	8b 52 04             	mov    0x4(%edx),%edx
  803233:	89 50 04             	mov    %edx,0x4(%eax)
  803236:	eb 0b                	jmp    803243 <alloc_block_FF+0x72>
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	8b 40 04             	mov    0x4(%eax),%eax
  80323e:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803246:	8b 40 04             	mov    0x4(%eax),%eax
  803249:	85 c0                	test   %eax,%eax
  80324b:	74 0f                	je     80325c <alloc_block_FF+0x8b>
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 40 04             	mov    0x4(%eax),%eax
  803253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803256:	8b 12                	mov    (%edx),%edx
  803258:	89 10                	mov    %edx,(%eax)
  80325a:	eb 0a                	jmp    803266 <alloc_block_FF+0x95>
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	a3 38 61 80 00       	mov    %eax,0x806138
  803266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803269:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803279:	a1 44 61 80 00       	mov    0x806144,%eax
  80327e:	48                   	dec    %eax
  80327f:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  803284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803287:	e9 10 01 00 00       	jmp    80339c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80328c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328f:	8b 40 0c             	mov    0xc(%eax),%eax
  803292:	3b 45 08             	cmp    0x8(%ebp),%eax
  803295:	0f 86 c6 00 00 00    	jbe    803361 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80329b:	a1 48 61 80 00       	mov    0x806148,%eax
  8032a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8032a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a6:	8b 50 08             	mov    0x8(%eax),%edx
  8032a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ac:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8032af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b5:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032bc:	75 17                	jne    8032d5 <alloc_block_FF+0x104>
  8032be:	83 ec 04             	sub    $0x4,%esp
  8032c1:	68 f8 50 80 00       	push   $0x8050f8
  8032c6:	68 9b 00 00 00       	push   $0x9b
  8032cb:	68 4f 50 80 00       	push   $0x80504f
  8032d0:	e8 d5 df ff ff       	call   8012aa <_panic>
  8032d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d8:	8b 00                	mov    (%eax),%eax
  8032da:	85 c0                	test   %eax,%eax
  8032dc:	74 10                	je     8032ee <alloc_block_FF+0x11d>
  8032de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e6:	8b 52 04             	mov    0x4(%edx),%edx
  8032e9:	89 50 04             	mov    %edx,0x4(%eax)
  8032ec:	eb 0b                	jmp    8032f9 <alloc_block_FF+0x128>
  8032ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f1:	8b 40 04             	mov    0x4(%eax),%eax
  8032f4:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8032f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fc:	8b 40 04             	mov    0x4(%eax),%eax
  8032ff:	85 c0                	test   %eax,%eax
  803301:	74 0f                	je     803312 <alloc_block_FF+0x141>
  803303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803306:	8b 40 04             	mov    0x4(%eax),%eax
  803309:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80330c:	8b 12                	mov    (%edx),%edx
  80330e:	89 10                	mov    %edx,(%eax)
  803310:	eb 0a                	jmp    80331c <alloc_block_FF+0x14b>
  803312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	a3 48 61 80 00       	mov    %eax,0x806148
  80331c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803328:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332f:	a1 54 61 80 00       	mov    0x806154,%eax
  803334:	48                   	dec    %eax
  803335:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	8b 50 08             	mov    0x8(%eax),%edx
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	01 c2                	add    %eax,%edx
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 40 0c             	mov    0xc(%eax),%eax
  803351:	2b 45 08             	sub    0x8(%ebp),%eax
  803354:	89 c2                	mov    %eax,%edx
  803356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803359:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80335c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335f:	eb 3b                	jmp    80339c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803361:	a1 40 61 80 00       	mov    0x806140,%eax
  803366:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336d:	74 07                	je     803376 <alloc_block_FF+0x1a5>
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	8b 00                	mov    (%eax),%eax
  803374:	eb 05                	jmp    80337b <alloc_block_FF+0x1aa>
  803376:	b8 00 00 00 00       	mov    $0x0,%eax
  80337b:	a3 40 61 80 00       	mov    %eax,0x806140
  803380:	a1 40 61 80 00       	mov    0x806140,%eax
  803385:	85 c0                	test   %eax,%eax
  803387:	0f 85 57 fe ff ff    	jne    8031e4 <alloc_block_FF+0x13>
  80338d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803391:	0f 85 4d fe ff ff    	jne    8031e4 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  803397:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80339c:	c9                   	leave  
  80339d:	c3                   	ret    

0080339e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80339e:	55                   	push   %ebp
  80339f:	89 e5                	mov    %esp,%ebp
  8033a1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8033a4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8033ab:	a1 38 61 80 00       	mov    0x806138,%eax
  8033b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b3:	e9 df 00 00 00       	jmp    803497 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8033b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033c1:	0f 82 c8 00 00 00    	jb     80348f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8033cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033d0:	0f 85 8a 00 00 00    	jne    803460 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8033d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033da:	75 17                	jne    8033f3 <alloc_block_BF+0x55>
  8033dc:	83 ec 04             	sub    $0x4,%esp
  8033df:	68 f8 50 80 00       	push   $0x8050f8
  8033e4:	68 b7 00 00 00       	push   $0xb7
  8033e9:	68 4f 50 80 00       	push   $0x80504f
  8033ee:	e8 b7 de ff ff       	call   8012aa <_panic>
  8033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f6:	8b 00                	mov    (%eax),%eax
  8033f8:	85 c0                	test   %eax,%eax
  8033fa:	74 10                	je     80340c <alloc_block_BF+0x6e>
  8033fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ff:	8b 00                	mov    (%eax),%eax
  803401:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803404:	8b 52 04             	mov    0x4(%edx),%edx
  803407:	89 50 04             	mov    %edx,0x4(%eax)
  80340a:	eb 0b                	jmp    803417 <alloc_block_BF+0x79>
  80340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340f:	8b 40 04             	mov    0x4(%eax),%eax
  803412:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341a:	8b 40 04             	mov    0x4(%eax),%eax
  80341d:	85 c0                	test   %eax,%eax
  80341f:	74 0f                	je     803430 <alloc_block_BF+0x92>
  803421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803424:	8b 40 04             	mov    0x4(%eax),%eax
  803427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80342a:	8b 12                	mov    (%edx),%edx
  80342c:	89 10                	mov    %edx,(%eax)
  80342e:	eb 0a                	jmp    80343a <alloc_block_BF+0x9c>
  803430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803433:	8b 00                	mov    (%eax),%eax
  803435:	a3 38 61 80 00       	mov    %eax,0x806138
  80343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344d:	a1 44 61 80 00       	mov    0x806144,%eax
  803452:	48                   	dec    %eax
  803453:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  803458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345b:	e9 4d 01 00 00       	jmp    8035ad <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803463:	8b 40 0c             	mov    0xc(%eax),%eax
  803466:	3b 45 08             	cmp    0x8(%ebp),%eax
  803469:	76 24                	jbe    80348f <alloc_block_BF+0xf1>
  80346b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346e:	8b 40 0c             	mov    0xc(%eax),%eax
  803471:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803474:	73 19                	jae    80348f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803476:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803480:	8b 40 0c             	mov    0xc(%eax),%eax
  803483:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	8b 40 08             	mov    0x8(%eax),%eax
  80348c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80348f:	a1 40 61 80 00       	mov    0x806140,%eax
  803494:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803497:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349b:	74 07                	je     8034a4 <alloc_block_BF+0x106>
  80349d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a0:	8b 00                	mov    (%eax),%eax
  8034a2:	eb 05                	jmp    8034a9 <alloc_block_BF+0x10b>
  8034a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a9:	a3 40 61 80 00       	mov    %eax,0x806140
  8034ae:	a1 40 61 80 00       	mov    0x806140,%eax
  8034b3:	85 c0                	test   %eax,%eax
  8034b5:	0f 85 fd fe ff ff    	jne    8033b8 <alloc_block_BF+0x1a>
  8034bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034bf:	0f 85 f3 fe ff ff    	jne    8033b8 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8034c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034c9:	0f 84 d9 00 00 00    	je     8035a8 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8034cf:	a1 48 61 80 00       	mov    0x806148,%eax
  8034d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8034d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034dd:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8034e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e6:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8034e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034ed:	75 17                	jne    803506 <alloc_block_BF+0x168>
  8034ef:	83 ec 04             	sub    $0x4,%esp
  8034f2:	68 f8 50 80 00       	push   $0x8050f8
  8034f7:	68 c7 00 00 00       	push   $0xc7
  8034fc:	68 4f 50 80 00       	push   $0x80504f
  803501:	e8 a4 dd ff ff       	call   8012aa <_panic>
  803506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803509:	8b 00                	mov    (%eax),%eax
  80350b:	85 c0                	test   %eax,%eax
  80350d:	74 10                	je     80351f <alloc_block_BF+0x181>
  80350f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803517:	8b 52 04             	mov    0x4(%edx),%edx
  80351a:	89 50 04             	mov    %edx,0x4(%eax)
  80351d:	eb 0b                	jmp    80352a <alloc_block_BF+0x18c>
  80351f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803522:	8b 40 04             	mov    0x4(%eax),%eax
  803525:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80352a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352d:	8b 40 04             	mov    0x4(%eax),%eax
  803530:	85 c0                	test   %eax,%eax
  803532:	74 0f                	je     803543 <alloc_block_BF+0x1a5>
  803534:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803537:	8b 40 04             	mov    0x4(%eax),%eax
  80353a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80353d:	8b 12                	mov    (%edx),%edx
  80353f:	89 10                	mov    %edx,(%eax)
  803541:	eb 0a                	jmp    80354d <alloc_block_BF+0x1af>
  803543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803546:	8b 00                	mov    (%eax),%eax
  803548:	a3 48 61 80 00       	mov    %eax,0x806148
  80354d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803550:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803559:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803560:	a1 54 61 80 00       	mov    0x806154,%eax
  803565:	48                   	dec    %eax
  803566:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80356b:	83 ec 08             	sub    $0x8,%esp
  80356e:	ff 75 ec             	pushl  -0x14(%ebp)
  803571:	68 38 61 80 00       	push   $0x806138
  803576:	e8 71 f9 ff ff       	call   802eec <find_block>
  80357b:	83 c4 10             	add    $0x10,%esp
  80357e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803581:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803584:	8b 50 08             	mov    0x8(%eax),%edx
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	01 c2                	add    %eax,%edx
  80358c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80358f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803592:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803595:	8b 40 0c             	mov    0xc(%eax),%eax
  803598:	2b 45 08             	sub    0x8(%ebp),%eax
  80359b:	89 c2                	mov    %eax,%edx
  80359d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a0:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8035a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a6:	eb 05                	jmp    8035ad <alloc_block_BF+0x20f>
	}
	return NULL;
  8035a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035ad:	c9                   	leave  
  8035ae:	c3                   	ret    

008035af <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8035af:	55                   	push   %ebp
  8035b0:	89 e5                	mov    %esp,%ebp
  8035b2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8035b5:	a1 28 60 80 00       	mov    0x806028,%eax
  8035ba:	85 c0                	test   %eax,%eax
  8035bc:	0f 85 de 01 00 00    	jne    8037a0 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8035c2:	a1 38 61 80 00       	mov    0x806138,%eax
  8035c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ca:	e9 9e 01 00 00       	jmp    80376d <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8035cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035d8:	0f 82 87 01 00 00    	jb     803765 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8035de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035e7:	0f 85 95 00 00 00    	jne    803682 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8035ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f1:	75 17                	jne    80360a <alloc_block_NF+0x5b>
  8035f3:	83 ec 04             	sub    $0x4,%esp
  8035f6:	68 f8 50 80 00       	push   $0x8050f8
  8035fb:	68 e0 00 00 00       	push   $0xe0
  803600:	68 4f 50 80 00       	push   $0x80504f
  803605:	e8 a0 dc ff ff       	call   8012aa <_panic>
  80360a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360d:	8b 00                	mov    (%eax),%eax
  80360f:	85 c0                	test   %eax,%eax
  803611:	74 10                	je     803623 <alloc_block_NF+0x74>
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	8b 00                	mov    (%eax),%eax
  803618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80361b:	8b 52 04             	mov    0x4(%edx),%edx
  80361e:	89 50 04             	mov    %edx,0x4(%eax)
  803621:	eb 0b                	jmp    80362e <alloc_block_NF+0x7f>
  803623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803626:	8b 40 04             	mov    0x4(%eax),%eax
  803629:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80362e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803631:	8b 40 04             	mov    0x4(%eax),%eax
  803634:	85 c0                	test   %eax,%eax
  803636:	74 0f                	je     803647 <alloc_block_NF+0x98>
  803638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363b:	8b 40 04             	mov    0x4(%eax),%eax
  80363e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803641:	8b 12                	mov    (%edx),%edx
  803643:	89 10                	mov    %edx,(%eax)
  803645:	eb 0a                	jmp    803651 <alloc_block_NF+0xa2>
  803647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364a:	8b 00                	mov    (%eax),%eax
  80364c:	a3 38 61 80 00       	mov    %eax,0x806138
  803651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803654:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80365a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803664:	a1 44 61 80 00       	mov    0x806144,%eax
  803669:	48                   	dec    %eax
  80366a:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  80366f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803672:	8b 40 08             	mov    0x8(%eax),%eax
  803675:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  80367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367d:	e9 f8 04 00 00       	jmp    803b7a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803685:	8b 40 0c             	mov    0xc(%eax),%eax
  803688:	3b 45 08             	cmp    0x8(%ebp),%eax
  80368b:	0f 86 d4 00 00 00    	jbe    803765 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803691:	a1 48 61 80 00       	mov    0x806148,%eax
  803696:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369c:	8b 50 08             	mov    0x8(%eax),%edx
  80369f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a2:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8036a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ab:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8036ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036b2:	75 17                	jne    8036cb <alloc_block_NF+0x11c>
  8036b4:	83 ec 04             	sub    $0x4,%esp
  8036b7:	68 f8 50 80 00       	push   $0x8050f8
  8036bc:	68 e9 00 00 00       	push   $0xe9
  8036c1:	68 4f 50 80 00       	push   $0x80504f
  8036c6:	e8 df db ff ff       	call   8012aa <_panic>
  8036cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ce:	8b 00                	mov    (%eax),%eax
  8036d0:	85 c0                	test   %eax,%eax
  8036d2:	74 10                	je     8036e4 <alloc_block_NF+0x135>
  8036d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d7:	8b 00                	mov    (%eax),%eax
  8036d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036dc:	8b 52 04             	mov    0x4(%edx),%edx
  8036df:	89 50 04             	mov    %edx,0x4(%eax)
  8036e2:	eb 0b                	jmp    8036ef <alloc_block_NF+0x140>
  8036e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e7:	8b 40 04             	mov    0x4(%eax),%eax
  8036ea:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8036ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f2:	8b 40 04             	mov    0x4(%eax),%eax
  8036f5:	85 c0                	test   %eax,%eax
  8036f7:	74 0f                	je     803708 <alloc_block_NF+0x159>
  8036f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036fc:	8b 40 04             	mov    0x4(%eax),%eax
  8036ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803702:	8b 12                	mov    (%edx),%edx
  803704:	89 10                	mov    %edx,(%eax)
  803706:	eb 0a                	jmp    803712 <alloc_block_NF+0x163>
  803708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370b:	8b 00                	mov    (%eax),%eax
  80370d:	a3 48 61 80 00       	mov    %eax,0x806148
  803712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803715:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80371b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80371e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803725:	a1 54 61 80 00       	mov    0x806154,%eax
  80372a:	48                   	dec    %eax
  80372b:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  803730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803733:	8b 40 08             	mov    0x8(%eax),%eax
  803736:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  80373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373e:	8b 50 08             	mov    0x8(%eax),%edx
  803741:	8b 45 08             	mov    0x8(%ebp),%eax
  803744:	01 c2                	add    %eax,%edx
  803746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803749:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80374c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374f:	8b 40 0c             	mov    0xc(%eax),%eax
  803752:	2b 45 08             	sub    0x8(%ebp),%eax
  803755:	89 c2                	mov    %eax,%edx
  803757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80375d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803760:	e9 15 04 00 00       	jmp    803b7a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803765:	a1 40 61 80 00       	mov    0x806140,%eax
  80376a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80376d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803771:	74 07                	je     80377a <alloc_block_NF+0x1cb>
  803773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803776:	8b 00                	mov    (%eax),%eax
  803778:	eb 05                	jmp    80377f <alloc_block_NF+0x1d0>
  80377a:	b8 00 00 00 00       	mov    $0x0,%eax
  80377f:	a3 40 61 80 00       	mov    %eax,0x806140
  803784:	a1 40 61 80 00       	mov    0x806140,%eax
  803789:	85 c0                	test   %eax,%eax
  80378b:	0f 85 3e fe ff ff    	jne    8035cf <alloc_block_NF+0x20>
  803791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803795:	0f 85 34 fe ff ff    	jne    8035cf <alloc_block_NF+0x20>
  80379b:	e9 d5 03 00 00       	jmp    803b75 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8037a0:	a1 38 61 80 00       	mov    0x806138,%eax
  8037a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037a8:	e9 b1 01 00 00       	jmp    80395e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8037ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b0:	8b 50 08             	mov    0x8(%eax),%edx
  8037b3:	a1 28 60 80 00       	mov    0x806028,%eax
  8037b8:	39 c2                	cmp    %eax,%edx
  8037ba:	0f 82 96 01 00 00    	jb     803956 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037c9:	0f 82 87 01 00 00    	jb     803956 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8037cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037d8:	0f 85 95 00 00 00    	jne    803873 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8037de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e2:	75 17                	jne    8037fb <alloc_block_NF+0x24c>
  8037e4:	83 ec 04             	sub    $0x4,%esp
  8037e7:	68 f8 50 80 00       	push   $0x8050f8
  8037ec:	68 fc 00 00 00       	push   $0xfc
  8037f1:	68 4f 50 80 00       	push   $0x80504f
  8037f6:	e8 af da ff ff       	call   8012aa <_panic>
  8037fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fe:	8b 00                	mov    (%eax),%eax
  803800:	85 c0                	test   %eax,%eax
  803802:	74 10                	je     803814 <alloc_block_NF+0x265>
  803804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803807:	8b 00                	mov    (%eax),%eax
  803809:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80380c:	8b 52 04             	mov    0x4(%edx),%edx
  80380f:	89 50 04             	mov    %edx,0x4(%eax)
  803812:	eb 0b                	jmp    80381f <alloc_block_NF+0x270>
  803814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803817:	8b 40 04             	mov    0x4(%eax),%eax
  80381a:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80381f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803822:	8b 40 04             	mov    0x4(%eax),%eax
  803825:	85 c0                	test   %eax,%eax
  803827:	74 0f                	je     803838 <alloc_block_NF+0x289>
  803829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382c:	8b 40 04             	mov    0x4(%eax),%eax
  80382f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803832:	8b 12                	mov    (%edx),%edx
  803834:	89 10                	mov    %edx,(%eax)
  803836:	eb 0a                	jmp    803842 <alloc_block_NF+0x293>
  803838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383b:	8b 00                	mov    (%eax),%eax
  80383d:	a3 38 61 80 00       	mov    %eax,0x806138
  803842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803845:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80384b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803855:	a1 44 61 80 00       	mov    0x806144,%eax
  80385a:	48                   	dec    %eax
  80385b:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803863:	8b 40 08             	mov    0x8(%eax),%eax
  803866:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  80386b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386e:	e9 07 03 00 00       	jmp    803b7a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803876:	8b 40 0c             	mov    0xc(%eax),%eax
  803879:	3b 45 08             	cmp    0x8(%ebp),%eax
  80387c:	0f 86 d4 00 00 00    	jbe    803956 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803882:	a1 48 61 80 00       	mov    0x806148,%eax
  803887:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80388a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388d:	8b 50 08             	mov    0x8(%eax),%edx
  803890:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803893:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803896:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803899:	8b 55 08             	mov    0x8(%ebp),%edx
  80389c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80389f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038a3:	75 17                	jne    8038bc <alloc_block_NF+0x30d>
  8038a5:	83 ec 04             	sub    $0x4,%esp
  8038a8:	68 f8 50 80 00       	push   $0x8050f8
  8038ad:	68 04 01 00 00       	push   $0x104
  8038b2:	68 4f 50 80 00       	push   $0x80504f
  8038b7:	e8 ee d9 ff ff       	call   8012aa <_panic>
  8038bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bf:	8b 00                	mov    (%eax),%eax
  8038c1:	85 c0                	test   %eax,%eax
  8038c3:	74 10                	je     8038d5 <alloc_block_NF+0x326>
  8038c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c8:	8b 00                	mov    (%eax),%eax
  8038ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038cd:	8b 52 04             	mov    0x4(%edx),%edx
  8038d0:	89 50 04             	mov    %edx,0x4(%eax)
  8038d3:	eb 0b                	jmp    8038e0 <alloc_block_NF+0x331>
  8038d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d8:	8b 40 04             	mov    0x4(%eax),%eax
  8038db:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8038e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e3:	8b 40 04             	mov    0x4(%eax),%eax
  8038e6:	85 c0                	test   %eax,%eax
  8038e8:	74 0f                	je     8038f9 <alloc_block_NF+0x34a>
  8038ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ed:	8b 40 04             	mov    0x4(%eax),%eax
  8038f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038f3:	8b 12                	mov    (%edx),%edx
  8038f5:	89 10                	mov    %edx,(%eax)
  8038f7:	eb 0a                	jmp    803903 <alloc_block_NF+0x354>
  8038f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038fc:	8b 00                	mov    (%eax),%eax
  8038fe:	a3 48 61 80 00       	mov    %eax,0x806148
  803903:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803906:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80390c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803916:	a1 54 61 80 00       	mov    0x806154,%eax
  80391b:	48                   	dec    %eax
  80391c:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803921:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803924:	8b 40 08             	mov    0x8(%eax),%eax
  803927:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  80392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392f:	8b 50 08             	mov    0x8(%eax),%edx
  803932:	8b 45 08             	mov    0x8(%ebp),%eax
  803935:	01 c2                	add    %eax,%edx
  803937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80393d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803940:	8b 40 0c             	mov    0xc(%eax),%eax
  803943:	2b 45 08             	sub    0x8(%ebp),%eax
  803946:	89 c2                	mov    %eax,%edx
  803948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80394e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803951:	e9 24 02 00 00       	jmp    803b7a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803956:	a1 40 61 80 00       	mov    0x806140,%eax
  80395b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80395e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803962:	74 07                	je     80396b <alloc_block_NF+0x3bc>
  803964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803967:	8b 00                	mov    (%eax),%eax
  803969:	eb 05                	jmp    803970 <alloc_block_NF+0x3c1>
  80396b:	b8 00 00 00 00       	mov    $0x0,%eax
  803970:	a3 40 61 80 00       	mov    %eax,0x806140
  803975:	a1 40 61 80 00       	mov    0x806140,%eax
  80397a:	85 c0                	test   %eax,%eax
  80397c:	0f 85 2b fe ff ff    	jne    8037ad <alloc_block_NF+0x1fe>
  803982:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803986:	0f 85 21 fe ff ff    	jne    8037ad <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80398c:	a1 38 61 80 00       	mov    0x806138,%eax
  803991:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803994:	e9 ae 01 00 00       	jmp    803b47 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399c:	8b 50 08             	mov    0x8(%eax),%edx
  80399f:	a1 28 60 80 00       	mov    0x806028,%eax
  8039a4:	39 c2                	cmp    %eax,%edx
  8039a6:	0f 83 93 01 00 00    	jae    803b3f <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8039ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039af:	8b 40 0c             	mov    0xc(%eax),%eax
  8039b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039b5:	0f 82 84 01 00 00    	jb     803b3f <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8039bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039be:	8b 40 0c             	mov    0xc(%eax),%eax
  8039c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039c4:	0f 85 95 00 00 00    	jne    803a5f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8039ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ce:	75 17                	jne    8039e7 <alloc_block_NF+0x438>
  8039d0:	83 ec 04             	sub    $0x4,%esp
  8039d3:	68 f8 50 80 00       	push   $0x8050f8
  8039d8:	68 14 01 00 00       	push   $0x114
  8039dd:	68 4f 50 80 00       	push   $0x80504f
  8039e2:	e8 c3 d8 ff ff       	call   8012aa <_panic>
  8039e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ea:	8b 00                	mov    (%eax),%eax
  8039ec:	85 c0                	test   %eax,%eax
  8039ee:	74 10                	je     803a00 <alloc_block_NF+0x451>
  8039f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f3:	8b 00                	mov    (%eax),%eax
  8039f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039f8:	8b 52 04             	mov    0x4(%edx),%edx
  8039fb:	89 50 04             	mov    %edx,0x4(%eax)
  8039fe:	eb 0b                	jmp    803a0b <alloc_block_NF+0x45c>
  803a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a03:	8b 40 04             	mov    0x4(%eax),%eax
  803a06:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0e:	8b 40 04             	mov    0x4(%eax),%eax
  803a11:	85 c0                	test   %eax,%eax
  803a13:	74 0f                	je     803a24 <alloc_block_NF+0x475>
  803a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a18:	8b 40 04             	mov    0x4(%eax),%eax
  803a1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a1e:	8b 12                	mov    (%edx),%edx
  803a20:	89 10                	mov    %edx,(%eax)
  803a22:	eb 0a                	jmp    803a2e <alloc_block_NF+0x47f>
  803a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a27:	8b 00                	mov    (%eax),%eax
  803a29:	a3 38 61 80 00       	mov    %eax,0x806138
  803a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a41:	a1 44 61 80 00       	mov    0x806144,%eax
  803a46:	48                   	dec    %eax
  803a47:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4f:	8b 40 08             	mov    0x8(%eax),%eax
  803a52:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5a:	e9 1b 01 00 00       	jmp    803b7a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a62:	8b 40 0c             	mov    0xc(%eax),%eax
  803a65:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a68:	0f 86 d1 00 00 00    	jbe    803b3f <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803a6e:	a1 48 61 80 00       	mov    0x806148,%eax
  803a73:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a79:	8b 50 08             	mov    0x8(%eax),%edx
  803a7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a7f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803a82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a85:	8b 55 08             	mov    0x8(%ebp),%edx
  803a88:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803a8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a8f:	75 17                	jne    803aa8 <alloc_block_NF+0x4f9>
  803a91:	83 ec 04             	sub    $0x4,%esp
  803a94:	68 f8 50 80 00       	push   $0x8050f8
  803a99:	68 1c 01 00 00       	push   $0x11c
  803a9e:	68 4f 50 80 00       	push   $0x80504f
  803aa3:	e8 02 d8 ff ff       	call   8012aa <_panic>
  803aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aab:	8b 00                	mov    (%eax),%eax
  803aad:	85 c0                	test   %eax,%eax
  803aaf:	74 10                	je     803ac1 <alloc_block_NF+0x512>
  803ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ab4:	8b 00                	mov    (%eax),%eax
  803ab6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ab9:	8b 52 04             	mov    0x4(%edx),%edx
  803abc:	89 50 04             	mov    %edx,0x4(%eax)
  803abf:	eb 0b                	jmp    803acc <alloc_block_NF+0x51d>
  803ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac4:	8b 40 04             	mov    0x4(%eax),%eax
  803ac7:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803acf:	8b 40 04             	mov    0x4(%eax),%eax
  803ad2:	85 c0                	test   %eax,%eax
  803ad4:	74 0f                	je     803ae5 <alloc_block_NF+0x536>
  803ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ad9:	8b 40 04             	mov    0x4(%eax),%eax
  803adc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803adf:	8b 12                	mov    (%edx),%edx
  803ae1:	89 10                	mov    %edx,(%eax)
  803ae3:	eb 0a                	jmp    803aef <alloc_block_NF+0x540>
  803ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ae8:	8b 00                	mov    (%eax),%eax
  803aea:	a3 48 61 80 00       	mov    %eax,0x806148
  803aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803afb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b02:	a1 54 61 80 00       	mov    0x806154,%eax
  803b07:	48                   	dec    %eax
  803b08:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803b0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b10:	8b 40 08             	mov    0x8(%eax),%eax
  803b13:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1b:	8b 50 08             	mov    0x8(%eax),%edx
  803b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b21:	01 c2                	add    %eax,%edx
  803b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b26:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2c:	8b 40 0c             	mov    0xc(%eax),%eax
  803b2f:	2b 45 08             	sub    0x8(%ebp),%eax
  803b32:	89 c2                	mov    %eax,%edx
  803b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b37:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803b3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b3d:	eb 3b                	jmp    803b7a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803b3f:	a1 40 61 80 00       	mov    0x806140,%eax
  803b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b4b:	74 07                	je     803b54 <alloc_block_NF+0x5a5>
  803b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b50:	8b 00                	mov    (%eax),%eax
  803b52:	eb 05                	jmp    803b59 <alloc_block_NF+0x5aa>
  803b54:	b8 00 00 00 00       	mov    $0x0,%eax
  803b59:	a3 40 61 80 00       	mov    %eax,0x806140
  803b5e:	a1 40 61 80 00       	mov    0x806140,%eax
  803b63:	85 c0                	test   %eax,%eax
  803b65:	0f 85 2e fe ff ff    	jne    803999 <alloc_block_NF+0x3ea>
  803b6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b6f:	0f 85 24 fe ff ff    	jne    803999 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803b75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b7a:	c9                   	leave  
  803b7b:	c3                   	ret    

00803b7c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803b7c:	55                   	push   %ebp
  803b7d:	89 e5                	mov    %esp,%ebp
  803b7f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803b82:	a1 38 61 80 00       	mov    0x806138,%eax
  803b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803b8a:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803b8f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803b92:	a1 38 61 80 00       	mov    0x806138,%eax
  803b97:	85 c0                	test   %eax,%eax
  803b99:	74 14                	je     803baf <insert_sorted_with_merge_freeList+0x33>
  803b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9e:	8b 50 08             	mov    0x8(%eax),%edx
  803ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ba4:	8b 40 08             	mov    0x8(%eax),%eax
  803ba7:	39 c2                	cmp    %eax,%edx
  803ba9:	0f 87 9b 01 00 00    	ja     803d4a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803baf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bb3:	75 17                	jne    803bcc <insert_sorted_with_merge_freeList+0x50>
  803bb5:	83 ec 04             	sub    $0x4,%esp
  803bb8:	68 2c 50 80 00       	push   $0x80502c
  803bbd:	68 38 01 00 00       	push   $0x138
  803bc2:	68 4f 50 80 00       	push   $0x80504f
  803bc7:	e8 de d6 ff ff       	call   8012aa <_panic>
  803bcc:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd5:	89 10                	mov    %edx,(%eax)
  803bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bda:	8b 00                	mov    (%eax),%eax
  803bdc:	85 c0                	test   %eax,%eax
  803bde:	74 0d                	je     803bed <insert_sorted_with_merge_freeList+0x71>
  803be0:	a1 38 61 80 00       	mov    0x806138,%eax
  803be5:	8b 55 08             	mov    0x8(%ebp),%edx
  803be8:	89 50 04             	mov    %edx,0x4(%eax)
  803beb:	eb 08                	jmp    803bf5 <insert_sorted_with_merge_freeList+0x79>
  803bed:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf0:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf8:	a3 38 61 80 00       	mov    %eax,0x806138
  803bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  803c00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c07:	a1 44 61 80 00       	mov    0x806144,%eax
  803c0c:	40                   	inc    %eax
  803c0d:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803c12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c16:	0f 84 a8 06 00 00    	je     8042c4 <insert_sorted_with_merge_freeList+0x748>
  803c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1f:	8b 50 08             	mov    0x8(%eax),%edx
  803c22:	8b 45 08             	mov    0x8(%ebp),%eax
  803c25:	8b 40 0c             	mov    0xc(%eax),%eax
  803c28:	01 c2                	add    %eax,%edx
  803c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c2d:	8b 40 08             	mov    0x8(%eax),%eax
  803c30:	39 c2                	cmp    %eax,%edx
  803c32:	0f 85 8c 06 00 00    	jne    8042c4 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803c38:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3b:	8b 50 0c             	mov    0xc(%eax),%edx
  803c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c41:	8b 40 0c             	mov    0xc(%eax),%eax
  803c44:	01 c2                	add    %eax,%edx
  803c46:	8b 45 08             	mov    0x8(%ebp),%eax
  803c49:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803c4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c50:	75 17                	jne    803c69 <insert_sorted_with_merge_freeList+0xed>
  803c52:	83 ec 04             	sub    $0x4,%esp
  803c55:	68 f8 50 80 00       	push   $0x8050f8
  803c5a:	68 3c 01 00 00       	push   $0x13c
  803c5f:	68 4f 50 80 00       	push   $0x80504f
  803c64:	e8 41 d6 ff ff       	call   8012aa <_panic>
  803c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c6c:	8b 00                	mov    (%eax),%eax
  803c6e:	85 c0                	test   %eax,%eax
  803c70:	74 10                	je     803c82 <insert_sorted_with_merge_freeList+0x106>
  803c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c75:	8b 00                	mov    (%eax),%eax
  803c77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c7a:	8b 52 04             	mov    0x4(%edx),%edx
  803c7d:	89 50 04             	mov    %edx,0x4(%eax)
  803c80:	eb 0b                	jmp    803c8d <insert_sorted_with_merge_freeList+0x111>
  803c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c85:	8b 40 04             	mov    0x4(%eax),%eax
  803c88:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c90:	8b 40 04             	mov    0x4(%eax),%eax
  803c93:	85 c0                	test   %eax,%eax
  803c95:	74 0f                	je     803ca6 <insert_sorted_with_merge_freeList+0x12a>
  803c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c9a:	8b 40 04             	mov    0x4(%eax),%eax
  803c9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ca0:	8b 12                	mov    (%edx),%edx
  803ca2:	89 10                	mov    %edx,(%eax)
  803ca4:	eb 0a                	jmp    803cb0 <insert_sorted_with_merge_freeList+0x134>
  803ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ca9:	8b 00                	mov    (%eax),%eax
  803cab:	a3 38 61 80 00       	mov    %eax,0x806138
  803cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cc3:	a1 44 61 80 00       	mov    0x806144,%eax
  803cc8:	48                   	dec    %eax
  803cc9:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  803cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cdb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803ce2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ce6:	75 17                	jne    803cff <insert_sorted_with_merge_freeList+0x183>
  803ce8:	83 ec 04             	sub    $0x4,%esp
  803ceb:	68 2c 50 80 00       	push   $0x80502c
  803cf0:	68 3f 01 00 00       	push   $0x13f
  803cf5:	68 4f 50 80 00       	push   $0x80504f
  803cfa:	e8 ab d5 ff ff       	call   8012aa <_panic>
  803cff:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d08:	89 10                	mov    %edx,(%eax)
  803d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d0d:	8b 00                	mov    (%eax),%eax
  803d0f:	85 c0                	test   %eax,%eax
  803d11:	74 0d                	je     803d20 <insert_sorted_with_merge_freeList+0x1a4>
  803d13:	a1 48 61 80 00       	mov    0x806148,%eax
  803d18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d1b:	89 50 04             	mov    %edx,0x4(%eax)
  803d1e:	eb 08                	jmp    803d28 <insert_sorted_with_merge_freeList+0x1ac>
  803d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d23:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d2b:	a3 48 61 80 00       	mov    %eax,0x806148
  803d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d3a:	a1 54 61 80 00       	mov    0x806154,%eax
  803d3f:	40                   	inc    %eax
  803d40:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803d45:	e9 7a 05 00 00       	jmp    8042c4 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4d:	8b 50 08             	mov    0x8(%eax),%edx
  803d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d53:	8b 40 08             	mov    0x8(%eax),%eax
  803d56:	39 c2                	cmp    %eax,%edx
  803d58:	0f 82 14 01 00 00    	jb     803e72 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d61:	8b 50 08             	mov    0x8(%eax),%edx
  803d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d67:	8b 40 0c             	mov    0xc(%eax),%eax
  803d6a:	01 c2                	add    %eax,%edx
  803d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6f:	8b 40 08             	mov    0x8(%eax),%eax
  803d72:	39 c2                	cmp    %eax,%edx
  803d74:	0f 85 90 00 00 00    	jne    803e0a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d7d:	8b 50 0c             	mov    0xc(%eax),%edx
  803d80:	8b 45 08             	mov    0x8(%ebp),%eax
  803d83:	8b 40 0c             	mov    0xc(%eax),%eax
  803d86:	01 c2                	add    %eax,%edx
  803d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d8b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d91:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803d98:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803da2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803da6:	75 17                	jne    803dbf <insert_sorted_with_merge_freeList+0x243>
  803da8:	83 ec 04             	sub    $0x4,%esp
  803dab:	68 2c 50 80 00       	push   $0x80502c
  803db0:	68 49 01 00 00       	push   $0x149
  803db5:	68 4f 50 80 00       	push   $0x80504f
  803dba:	e8 eb d4 ff ff       	call   8012aa <_panic>
  803dbf:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc8:	89 10                	mov    %edx,(%eax)
  803dca:	8b 45 08             	mov    0x8(%ebp),%eax
  803dcd:	8b 00                	mov    (%eax),%eax
  803dcf:	85 c0                	test   %eax,%eax
  803dd1:	74 0d                	je     803de0 <insert_sorted_with_merge_freeList+0x264>
  803dd3:	a1 48 61 80 00       	mov    0x806148,%eax
  803dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  803ddb:	89 50 04             	mov    %edx,0x4(%eax)
  803dde:	eb 08                	jmp    803de8 <insert_sorted_with_merge_freeList+0x26c>
  803de0:	8b 45 08             	mov    0x8(%ebp),%eax
  803de3:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803de8:	8b 45 08             	mov    0x8(%ebp),%eax
  803deb:	a3 48 61 80 00       	mov    %eax,0x806148
  803df0:	8b 45 08             	mov    0x8(%ebp),%eax
  803df3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dfa:	a1 54 61 80 00       	mov    0x806154,%eax
  803dff:	40                   	inc    %eax
  803e00:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e05:	e9 bb 04 00 00       	jmp    8042c5 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803e0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e0e:	75 17                	jne    803e27 <insert_sorted_with_merge_freeList+0x2ab>
  803e10:	83 ec 04             	sub    $0x4,%esp
  803e13:	68 a0 50 80 00       	push   $0x8050a0
  803e18:	68 4c 01 00 00       	push   $0x14c
  803e1d:	68 4f 50 80 00       	push   $0x80504f
  803e22:	e8 83 d4 ff ff       	call   8012aa <_panic>
  803e27:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e30:	89 50 04             	mov    %edx,0x4(%eax)
  803e33:	8b 45 08             	mov    0x8(%ebp),%eax
  803e36:	8b 40 04             	mov    0x4(%eax),%eax
  803e39:	85 c0                	test   %eax,%eax
  803e3b:	74 0c                	je     803e49 <insert_sorted_with_merge_freeList+0x2cd>
  803e3d:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803e42:	8b 55 08             	mov    0x8(%ebp),%edx
  803e45:	89 10                	mov    %edx,(%eax)
  803e47:	eb 08                	jmp    803e51 <insert_sorted_with_merge_freeList+0x2d5>
  803e49:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4c:	a3 38 61 80 00       	mov    %eax,0x806138
  803e51:	8b 45 08             	mov    0x8(%ebp),%eax
  803e54:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803e59:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e62:	a1 44 61 80 00       	mov    0x806144,%eax
  803e67:	40                   	inc    %eax
  803e68:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e6d:	e9 53 04 00 00       	jmp    8042c5 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803e72:	a1 38 61 80 00       	mov    0x806138,%eax
  803e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e7a:	e9 15 04 00 00       	jmp    804294 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e82:	8b 00                	mov    (%eax),%eax
  803e84:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803e87:	8b 45 08             	mov    0x8(%ebp),%eax
  803e8a:	8b 50 08             	mov    0x8(%eax),%edx
  803e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e90:	8b 40 08             	mov    0x8(%eax),%eax
  803e93:	39 c2                	cmp    %eax,%edx
  803e95:	0f 86 f1 03 00 00    	jbe    80428c <insert_sorted_with_merge_freeList+0x710>
  803e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9e:	8b 50 08             	mov    0x8(%eax),%edx
  803ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ea4:	8b 40 08             	mov    0x8(%eax),%eax
  803ea7:	39 c2                	cmp    %eax,%edx
  803ea9:	0f 83 dd 03 00 00    	jae    80428c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb2:	8b 50 08             	mov    0x8(%eax),%edx
  803eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb8:	8b 40 0c             	mov    0xc(%eax),%eax
  803ebb:	01 c2                	add    %eax,%edx
  803ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec0:	8b 40 08             	mov    0x8(%eax),%eax
  803ec3:	39 c2                	cmp    %eax,%edx
  803ec5:	0f 85 b9 01 00 00    	jne    804084 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ece:	8b 50 08             	mov    0x8(%eax),%edx
  803ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed4:	8b 40 0c             	mov    0xc(%eax),%eax
  803ed7:	01 c2                	add    %eax,%edx
  803ed9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803edc:	8b 40 08             	mov    0x8(%eax),%eax
  803edf:	39 c2                	cmp    %eax,%edx
  803ee1:	0f 85 0d 01 00 00    	jne    803ff4 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eea:	8b 50 0c             	mov    0xc(%eax),%edx
  803eed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ef0:	8b 40 0c             	mov    0xc(%eax),%eax
  803ef3:	01 c2                	add    %eax,%edx
  803ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef8:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803efb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803eff:	75 17                	jne    803f18 <insert_sorted_with_merge_freeList+0x39c>
  803f01:	83 ec 04             	sub    $0x4,%esp
  803f04:	68 f8 50 80 00       	push   $0x8050f8
  803f09:	68 5c 01 00 00       	push   $0x15c
  803f0e:	68 4f 50 80 00       	push   $0x80504f
  803f13:	e8 92 d3 ff ff       	call   8012aa <_panic>
  803f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f1b:	8b 00                	mov    (%eax),%eax
  803f1d:	85 c0                	test   %eax,%eax
  803f1f:	74 10                	je     803f31 <insert_sorted_with_merge_freeList+0x3b5>
  803f21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f24:	8b 00                	mov    (%eax),%eax
  803f26:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f29:	8b 52 04             	mov    0x4(%edx),%edx
  803f2c:	89 50 04             	mov    %edx,0x4(%eax)
  803f2f:	eb 0b                	jmp    803f3c <insert_sorted_with_merge_freeList+0x3c0>
  803f31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f34:	8b 40 04             	mov    0x4(%eax),%eax
  803f37:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f3f:	8b 40 04             	mov    0x4(%eax),%eax
  803f42:	85 c0                	test   %eax,%eax
  803f44:	74 0f                	je     803f55 <insert_sorted_with_merge_freeList+0x3d9>
  803f46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f49:	8b 40 04             	mov    0x4(%eax),%eax
  803f4c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f4f:	8b 12                	mov    (%edx),%edx
  803f51:	89 10                	mov    %edx,(%eax)
  803f53:	eb 0a                	jmp    803f5f <insert_sorted_with_merge_freeList+0x3e3>
  803f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f58:	8b 00                	mov    (%eax),%eax
  803f5a:	a3 38 61 80 00       	mov    %eax,0x806138
  803f5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f72:	a1 44 61 80 00       	mov    0x806144,%eax
  803f77:	48                   	dec    %eax
  803f78:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  803f7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f80:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803f87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803f91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803f95:	75 17                	jne    803fae <insert_sorted_with_merge_freeList+0x432>
  803f97:	83 ec 04             	sub    $0x4,%esp
  803f9a:	68 2c 50 80 00       	push   $0x80502c
  803f9f:	68 5f 01 00 00       	push   $0x15f
  803fa4:	68 4f 50 80 00       	push   $0x80504f
  803fa9:	e8 fc d2 ff ff       	call   8012aa <_panic>
  803fae:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803fb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fb7:	89 10                	mov    %edx,(%eax)
  803fb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fbc:	8b 00                	mov    (%eax),%eax
  803fbe:	85 c0                	test   %eax,%eax
  803fc0:	74 0d                	je     803fcf <insert_sorted_with_merge_freeList+0x453>
  803fc2:	a1 48 61 80 00       	mov    0x806148,%eax
  803fc7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fca:	89 50 04             	mov    %edx,0x4(%eax)
  803fcd:	eb 08                	jmp    803fd7 <insert_sorted_with_merge_freeList+0x45b>
  803fcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fd2:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803fd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fda:	a3 48 61 80 00       	mov    %eax,0x806148
  803fdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fe2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fe9:	a1 54 61 80 00       	mov    0x806154,%eax
  803fee:	40                   	inc    %eax
  803fef:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  803ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ff7:	8b 50 0c             	mov    0xc(%eax),%edx
  803ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffd:	8b 40 0c             	mov    0xc(%eax),%eax
  804000:	01 c2                	add    %eax,%edx
  804002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804005:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  804008:	8b 45 08             	mov    0x8(%ebp),%eax
  80400b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  804012:	8b 45 08             	mov    0x8(%ebp),%eax
  804015:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80401c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804020:	75 17                	jne    804039 <insert_sorted_with_merge_freeList+0x4bd>
  804022:	83 ec 04             	sub    $0x4,%esp
  804025:	68 2c 50 80 00       	push   $0x80502c
  80402a:	68 64 01 00 00       	push   $0x164
  80402f:	68 4f 50 80 00       	push   $0x80504f
  804034:	e8 71 d2 ff ff       	call   8012aa <_panic>
  804039:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80403f:	8b 45 08             	mov    0x8(%ebp),%eax
  804042:	89 10                	mov    %edx,(%eax)
  804044:	8b 45 08             	mov    0x8(%ebp),%eax
  804047:	8b 00                	mov    (%eax),%eax
  804049:	85 c0                	test   %eax,%eax
  80404b:	74 0d                	je     80405a <insert_sorted_with_merge_freeList+0x4de>
  80404d:	a1 48 61 80 00       	mov    0x806148,%eax
  804052:	8b 55 08             	mov    0x8(%ebp),%edx
  804055:	89 50 04             	mov    %edx,0x4(%eax)
  804058:	eb 08                	jmp    804062 <insert_sorted_with_merge_freeList+0x4e6>
  80405a:	8b 45 08             	mov    0x8(%ebp),%eax
  80405d:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804062:	8b 45 08             	mov    0x8(%ebp),%eax
  804065:	a3 48 61 80 00       	mov    %eax,0x806148
  80406a:	8b 45 08             	mov    0x8(%ebp),%eax
  80406d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804074:	a1 54 61 80 00       	mov    0x806154,%eax
  804079:	40                   	inc    %eax
  80407a:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  80407f:	e9 41 02 00 00       	jmp    8042c5 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804084:	8b 45 08             	mov    0x8(%ebp),%eax
  804087:	8b 50 08             	mov    0x8(%eax),%edx
  80408a:	8b 45 08             	mov    0x8(%ebp),%eax
  80408d:	8b 40 0c             	mov    0xc(%eax),%eax
  804090:	01 c2                	add    %eax,%edx
  804092:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804095:	8b 40 08             	mov    0x8(%eax),%eax
  804098:	39 c2                	cmp    %eax,%edx
  80409a:	0f 85 7c 01 00 00    	jne    80421c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8040a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8040a4:	74 06                	je     8040ac <insert_sorted_with_merge_freeList+0x530>
  8040a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040aa:	75 17                	jne    8040c3 <insert_sorted_with_merge_freeList+0x547>
  8040ac:	83 ec 04             	sub    $0x4,%esp
  8040af:	68 68 50 80 00       	push   $0x805068
  8040b4:	68 69 01 00 00       	push   $0x169
  8040b9:	68 4f 50 80 00       	push   $0x80504f
  8040be:	e8 e7 d1 ff ff       	call   8012aa <_panic>
  8040c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040c6:	8b 50 04             	mov    0x4(%eax),%edx
  8040c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040cc:	89 50 04             	mov    %edx,0x4(%eax)
  8040cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8040d5:	89 10                	mov    %edx,(%eax)
  8040d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040da:	8b 40 04             	mov    0x4(%eax),%eax
  8040dd:	85 c0                	test   %eax,%eax
  8040df:	74 0d                	je     8040ee <insert_sorted_with_merge_freeList+0x572>
  8040e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040e4:	8b 40 04             	mov    0x4(%eax),%eax
  8040e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8040ea:	89 10                	mov    %edx,(%eax)
  8040ec:	eb 08                	jmp    8040f6 <insert_sorted_with_merge_freeList+0x57a>
  8040ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f1:	a3 38 61 80 00       	mov    %eax,0x806138
  8040f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8040fc:	89 50 04             	mov    %edx,0x4(%eax)
  8040ff:	a1 44 61 80 00       	mov    0x806144,%eax
  804104:	40                   	inc    %eax
  804105:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  80410a:	8b 45 08             	mov    0x8(%ebp),%eax
  80410d:	8b 50 0c             	mov    0xc(%eax),%edx
  804110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804113:	8b 40 0c             	mov    0xc(%eax),%eax
  804116:	01 c2                	add    %eax,%edx
  804118:	8b 45 08             	mov    0x8(%ebp),%eax
  80411b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80411e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804122:	75 17                	jne    80413b <insert_sorted_with_merge_freeList+0x5bf>
  804124:	83 ec 04             	sub    $0x4,%esp
  804127:	68 f8 50 80 00       	push   $0x8050f8
  80412c:	68 6b 01 00 00       	push   $0x16b
  804131:	68 4f 50 80 00       	push   $0x80504f
  804136:	e8 6f d1 ff ff       	call   8012aa <_panic>
  80413b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80413e:	8b 00                	mov    (%eax),%eax
  804140:	85 c0                	test   %eax,%eax
  804142:	74 10                	je     804154 <insert_sorted_with_merge_freeList+0x5d8>
  804144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804147:	8b 00                	mov    (%eax),%eax
  804149:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80414c:	8b 52 04             	mov    0x4(%edx),%edx
  80414f:	89 50 04             	mov    %edx,0x4(%eax)
  804152:	eb 0b                	jmp    80415f <insert_sorted_with_merge_freeList+0x5e3>
  804154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804157:	8b 40 04             	mov    0x4(%eax),%eax
  80415a:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80415f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804162:	8b 40 04             	mov    0x4(%eax),%eax
  804165:	85 c0                	test   %eax,%eax
  804167:	74 0f                	je     804178 <insert_sorted_with_merge_freeList+0x5fc>
  804169:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80416c:	8b 40 04             	mov    0x4(%eax),%eax
  80416f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804172:	8b 12                	mov    (%edx),%edx
  804174:	89 10                	mov    %edx,(%eax)
  804176:	eb 0a                	jmp    804182 <insert_sorted_with_merge_freeList+0x606>
  804178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80417b:	8b 00                	mov    (%eax),%eax
  80417d:	a3 38 61 80 00       	mov    %eax,0x806138
  804182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804185:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80418b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80418e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804195:	a1 44 61 80 00       	mov    0x806144,%eax
  80419a:	48                   	dec    %eax
  80419b:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  8041a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8041aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041ad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8041b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8041b8:	75 17                	jne    8041d1 <insert_sorted_with_merge_freeList+0x655>
  8041ba:	83 ec 04             	sub    $0x4,%esp
  8041bd:	68 2c 50 80 00       	push   $0x80502c
  8041c2:	68 6e 01 00 00       	push   $0x16e
  8041c7:	68 4f 50 80 00       	push   $0x80504f
  8041cc:	e8 d9 d0 ff ff       	call   8012aa <_panic>
  8041d1:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8041d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041da:	89 10                	mov    %edx,(%eax)
  8041dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041df:	8b 00                	mov    (%eax),%eax
  8041e1:	85 c0                	test   %eax,%eax
  8041e3:	74 0d                	je     8041f2 <insert_sorted_with_merge_freeList+0x676>
  8041e5:	a1 48 61 80 00       	mov    0x806148,%eax
  8041ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041ed:	89 50 04             	mov    %edx,0x4(%eax)
  8041f0:	eb 08                	jmp    8041fa <insert_sorted_with_merge_freeList+0x67e>
  8041f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041f5:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8041fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041fd:	a3 48 61 80 00       	mov    %eax,0x806148
  804202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804205:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80420c:	a1 54 61 80 00       	mov    0x806154,%eax
  804211:	40                   	inc    %eax
  804212:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  804217:	e9 a9 00 00 00       	jmp    8042c5 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80421c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804220:	74 06                	je     804228 <insert_sorted_with_merge_freeList+0x6ac>
  804222:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804226:	75 17                	jne    80423f <insert_sorted_with_merge_freeList+0x6c3>
  804228:	83 ec 04             	sub    $0x4,%esp
  80422b:	68 c4 50 80 00       	push   $0x8050c4
  804230:	68 73 01 00 00       	push   $0x173
  804235:	68 4f 50 80 00       	push   $0x80504f
  80423a:	e8 6b d0 ff ff       	call   8012aa <_panic>
  80423f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804242:	8b 10                	mov    (%eax),%edx
  804244:	8b 45 08             	mov    0x8(%ebp),%eax
  804247:	89 10                	mov    %edx,(%eax)
  804249:	8b 45 08             	mov    0x8(%ebp),%eax
  80424c:	8b 00                	mov    (%eax),%eax
  80424e:	85 c0                	test   %eax,%eax
  804250:	74 0b                	je     80425d <insert_sorted_with_merge_freeList+0x6e1>
  804252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804255:	8b 00                	mov    (%eax),%eax
  804257:	8b 55 08             	mov    0x8(%ebp),%edx
  80425a:	89 50 04             	mov    %edx,0x4(%eax)
  80425d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804260:	8b 55 08             	mov    0x8(%ebp),%edx
  804263:	89 10                	mov    %edx,(%eax)
  804265:	8b 45 08             	mov    0x8(%ebp),%eax
  804268:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80426b:	89 50 04             	mov    %edx,0x4(%eax)
  80426e:	8b 45 08             	mov    0x8(%ebp),%eax
  804271:	8b 00                	mov    (%eax),%eax
  804273:	85 c0                	test   %eax,%eax
  804275:	75 08                	jne    80427f <insert_sorted_with_merge_freeList+0x703>
  804277:	8b 45 08             	mov    0x8(%ebp),%eax
  80427a:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80427f:	a1 44 61 80 00       	mov    0x806144,%eax
  804284:	40                   	inc    %eax
  804285:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  80428a:	eb 39                	jmp    8042c5 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80428c:	a1 40 61 80 00       	mov    0x806140,%eax
  804291:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804294:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804298:	74 07                	je     8042a1 <insert_sorted_with_merge_freeList+0x725>
  80429a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80429d:	8b 00                	mov    (%eax),%eax
  80429f:	eb 05                	jmp    8042a6 <insert_sorted_with_merge_freeList+0x72a>
  8042a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8042a6:	a3 40 61 80 00       	mov    %eax,0x806140
  8042ab:	a1 40 61 80 00       	mov    0x806140,%eax
  8042b0:	85 c0                	test   %eax,%eax
  8042b2:	0f 85 c7 fb ff ff    	jne    803e7f <insert_sorted_with_merge_freeList+0x303>
  8042b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042bc:	0f 85 bd fb ff ff    	jne    803e7f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8042c2:	eb 01                	jmp    8042c5 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8042c4:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8042c5:	90                   	nop
  8042c6:	c9                   	leave  
  8042c7:	c3                   	ret    

008042c8 <__udivdi3>:
  8042c8:	55                   	push   %ebp
  8042c9:	57                   	push   %edi
  8042ca:	56                   	push   %esi
  8042cb:	53                   	push   %ebx
  8042cc:	83 ec 1c             	sub    $0x1c,%esp
  8042cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8042d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8042d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8042df:	89 ca                	mov    %ecx,%edx
  8042e1:	89 f8                	mov    %edi,%eax
  8042e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8042e7:	85 f6                	test   %esi,%esi
  8042e9:	75 2d                	jne    804318 <__udivdi3+0x50>
  8042eb:	39 cf                	cmp    %ecx,%edi
  8042ed:	77 65                	ja     804354 <__udivdi3+0x8c>
  8042ef:	89 fd                	mov    %edi,%ebp
  8042f1:	85 ff                	test   %edi,%edi
  8042f3:	75 0b                	jne    804300 <__udivdi3+0x38>
  8042f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8042fa:	31 d2                	xor    %edx,%edx
  8042fc:	f7 f7                	div    %edi
  8042fe:	89 c5                	mov    %eax,%ebp
  804300:	31 d2                	xor    %edx,%edx
  804302:	89 c8                	mov    %ecx,%eax
  804304:	f7 f5                	div    %ebp
  804306:	89 c1                	mov    %eax,%ecx
  804308:	89 d8                	mov    %ebx,%eax
  80430a:	f7 f5                	div    %ebp
  80430c:	89 cf                	mov    %ecx,%edi
  80430e:	89 fa                	mov    %edi,%edx
  804310:	83 c4 1c             	add    $0x1c,%esp
  804313:	5b                   	pop    %ebx
  804314:	5e                   	pop    %esi
  804315:	5f                   	pop    %edi
  804316:	5d                   	pop    %ebp
  804317:	c3                   	ret    
  804318:	39 ce                	cmp    %ecx,%esi
  80431a:	77 28                	ja     804344 <__udivdi3+0x7c>
  80431c:	0f bd fe             	bsr    %esi,%edi
  80431f:	83 f7 1f             	xor    $0x1f,%edi
  804322:	75 40                	jne    804364 <__udivdi3+0x9c>
  804324:	39 ce                	cmp    %ecx,%esi
  804326:	72 0a                	jb     804332 <__udivdi3+0x6a>
  804328:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80432c:	0f 87 9e 00 00 00    	ja     8043d0 <__udivdi3+0x108>
  804332:	b8 01 00 00 00       	mov    $0x1,%eax
  804337:	89 fa                	mov    %edi,%edx
  804339:	83 c4 1c             	add    $0x1c,%esp
  80433c:	5b                   	pop    %ebx
  80433d:	5e                   	pop    %esi
  80433e:	5f                   	pop    %edi
  80433f:	5d                   	pop    %ebp
  804340:	c3                   	ret    
  804341:	8d 76 00             	lea    0x0(%esi),%esi
  804344:	31 ff                	xor    %edi,%edi
  804346:	31 c0                	xor    %eax,%eax
  804348:	89 fa                	mov    %edi,%edx
  80434a:	83 c4 1c             	add    $0x1c,%esp
  80434d:	5b                   	pop    %ebx
  80434e:	5e                   	pop    %esi
  80434f:	5f                   	pop    %edi
  804350:	5d                   	pop    %ebp
  804351:	c3                   	ret    
  804352:	66 90                	xchg   %ax,%ax
  804354:	89 d8                	mov    %ebx,%eax
  804356:	f7 f7                	div    %edi
  804358:	31 ff                	xor    %edi,%edi
  80435a:	89 fa                	mov    %edi,%edx
  80435c:	83 c4 1c             	add    $0x1c,%esp
  80435f:	5b                   	pop    %ebx
  804360:	5e                   	pop    %esi
  804361:	5f                   	pop    %edi
  804362:	5d                   	pop    %ebp
  804363:	c3                   	ret    
  804364:	bd 20 00 00 00       	mov    $0x20,%ebp
  804369:	89 eb                	mov    %ebp,%ebx
  80436b:	29 fb                	sub    %edi,%ebx
  80436d:	89 f9                	mov    %edi,%ecx
  80436f:	d3 e6                	shl    %cl,%esi
  804371:	89 c5                	mov    %eax,%ebp
  804373:	88 d9                	mov    %bl,%cl
  804375:	d3 ed                	shr    %cl,%ebp
  804377:	89 e9                	mov    %ebp,%ecx
  804379:	09 f1                	or     %esi,%ecx
  80437b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80437f:	89 f9                	mov    %edi,%ecx
  804381:	d3 e0                	shl    %cl,%eax
  804383:	89 c5                	mov    %eax,%ebp
  804385:	89 d6                	mov    %edx,%esi
  804387:	88 d9                	mov    %bl,%cl
  804389:	d3 ee                	shr    %cl,%esi
  80438b:	89 f9                	mov    %edi,%ecx
  80438d:	d3 e2                	shl    %cl,%edx
  80438f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804393:	88 d9                	mov    %bl,%cl
  804395:	d3 e8                	shr    %cl,%eax
  804397:	09 c2                	or     %eax,%edx
  804399:	89 d0                	mov    %edx,%eax
  80439b:	89 f2                	mov    %esi,%edx
  80439d:	f7 74 24 0c          	divl   0xc(%esp)
  8043a1:	89 d6                	mov    %edx,%esi
  8043a3:	89 c3                	mov    %eax,%ebx
  8043a5:	f7 e5                	mul    %ebp
  8043a7:	39 d6                	cmp    %edx,%esi
  8043a9:	72 19                	jb     8043c4 <__udivdi3+0xfc>
  8043ab:	74 0b                	je     8043b8 <__udivdi3+0xf0>
  8043ad:	89 d8                	mov    %ebx,%eax
  8043af:	31 ff                	xor    %edi,%edi
  8043b1:	e9 58 ff ff ff       	jmp    80430e <__udivdi3+0x46>
  8043b6:	66 90                	xchg   %ax,%ax
  8043b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8043bc:	89 f9                	mov    %edi,%ecx
  8043be:	d3 e2                	shl    %cl,%edx
  8043c0:	39 c2                	cmp    %eax,%edx
  8043c2:	73 e9                	jae    8043ad <__udivdi3+0xe5>
  8043c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8043c7:	31 ff                	xor    %edi,%edi
  8043c9:	e9 40 ff ff ff       	jmp    80430e <__udivdi3+0x46>
  8043ce:	66 90                	xchg   %ax,%ax
  8043d0:	31 c0                	xor    %eax,%eax
  8043d2:	e9 37 ff ff ff       	jmp    80430e <__udivdi3+0x46>
  8043d7:	90                   	nop

008043d8 <__umoddi3>:
  8043d8:	55                   	push   %ebp
  8043d9:	57                   	push   %edi
  8043da:	56                   	push   %esi
  8043db:	53                   	push   %ebx
  8043dc:	83 ec 1c             	sub    $0x1c,%esp
  8043df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8043e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8043e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8043ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8043f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8043f7:	89 f3                	mov    %esi,%ebx
  8043f9:	89 fa                	mov    %edi,%edx
  8043fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043ff:	89 34 24             	mov    %esi,(%esp)
  804402:	85 c0                	test   %eax,%eax
  804404:	75 1a                	jne    804420 <__umoddi3+0x48>
  804406:	39 f7                	cmp    %esi,%edi
  804408:	0f 86 a2 00 00 00    	jbe    8044b0 <__umoddi3+0xd8>
  80440e:	89 c8                	mov    %ecx,%eax
  804410:	89 f2                	mov    %esi,%edx
  804412:	f7 f7                	div    %edi
  804414:	89 d0                	mov    %edx,%eax
  804416:	31 d2                	xor    %edx,%edx
  804418:	83 c4 1c             	add    $0x1c,%esp
  80441b:	5b                   	pop    %ebx
  80441c:	5e                   	pop    %esi
  80441d:	5f                   	pop    %edi
  80441e:	5d                   	pop    %ebp
  80441f:	c3                   	ret    
  804420:	39 f0                	cmp    %esi,%eax
  804422:	0f 87 ac 00 00 00    	ja     8044d4 <__umoddi3+0xfc>
  804428:	0f bd e8             	bsr    %eax,%ebp
  80442b:	83 f5 1f             	xor    $0x1f,%ebp
  80442e:	0f 84 ac 00 00 00    	je     8044e0 <__umoddi3+0x108>
  804434:	bf 20 00 00 00       	mov    $0x20,%edi
  804439:	29 ef                	sub    %ebp,%edi
  80443b:	89 fe                	mov    %edi,%esi
  80443d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804441:	89 e9                	mov    %ebp,%ecx
  804443:	d3 e0                	shl    %cl,%eax
  804445:	89 d7                	mov    %edx,%edi
  804447:	89 f1                	mov    %esi,%ecx
  804449:	d3 ef                	shr    %cl,%edi
  80444b:	09 c7                	or     %eax,%edi
  80444d:	89 e9                	mov    %ebp,%ecx
  80444f:	d3 e2                	shl    %cl,%edx
  804451:	89 14 24             	mov    %edx,(%esp)
  804454:	89 d8                	mov    %ebx,%eax
  804456:	d3 e0                	shl    %cl,%eax
  804458:	89 c2                	mov    %eax,%edx
  80445a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80445e:	d3 e0                	shl    %cl,%eax
  804460:	89 44 24 04          	mov    %eax,0x4(%esp)
  804464:	8b 44 24 08          	mov    0x8(%esp),%eax
  804468:	89 f1                	mov    %esi,%ecx
  80446a:	d3 e8                	shr    %cl,%eax
  80446c:	09 d0                	or     %edx,%eax
  80446e:	d3 eb                	shr    %cl,%ebx
  804470:	89 da                	mov    %ebx,%edx
  804472:	f7 f7                	div    %edi
  804474:	89 d3                	mov    %edx,%ebx
  804476:	f7 24 24             	mull   (%esp)
  804479:	89 c6                	mov    %eax,%esi
  80447b:	89 d1                	mov    %edx,%ecx
  80447d:	39 d3                	cmp    %edx,%ebx
  80447f:	0f 82 87 00 00 00    	jb     80450c <__umoddi3+0x134>
  804485:	0f 84 91 00 00 00    	je     80451c <__umoddi3+0x144>
  80448b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80448f:	29 f2                	sub    %esi,%edx
  804491:	19 cb                	sbb    %ecx,%ebx
  804493:	89 d8                	mov    %ebx,%eax
  804495:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804499:	d3 e0                	shl    %cl,%eax
  80449b:	89 e9                	mov    %ebp,%ecx
  80449d:	d3 ea                	shr    %cl,%edx
  80449f:	09 d0                	or     %edx,%eax
  8044a1:	89 e9                	mov    %ebp,%ecx
  8044a3:	d3 eb                	shr    %cl,%ebx
  8044a5:	89 da                	mov    %ebx,%edx
  8044a7:	83 c4 1c             	add    $0x1c,%esp
  8044aa:	5b                   	pop    %ebx
  8044ab:	5e                   	pop    %esi
  8044ac:	5f                   	pop    %edi
  8044ad:	5d                   	pop    %ebp
  8044ae:	c3                   	ret    
  8044af:	90                   	nop
  8044b0:	89 fd                	mov    %edi,%ebp
  8044b2:	85 ff                	test   %edi,%edi
  8044b4:	75 0b                	jne    8044c1 <__umoddi3+0xe9>
  8044b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8044bb:	31 d2                	xor    %edx,%edx
  8044bd:	f7 f7                	div    %edi
  8044bf:	89 c5                	mov    %eax,%ebp
  8044c1:	89 f0                	mov    %esi,%eax
  8044c3:	31 d2                	xor    %edx,%edx
  8044c5:	f7 f5                	div    %ebp
  8044c7:	89 c8                	mov    %ecx,%eax
  8044c9:	f7 f5                	div    %ebp
  8044cb:	89 d0                	mov    %edx,%eax
  8044cd:	e9 44 ff ff ff       	jmp    804416 <__umoddi3+0x3e>
  8044d2:	66 90                	xchg   %ax,%ax
  8044d4:	89 c8                	mov    %ecx,%eax
  8044d6:	89 f2                	mov    %esi,%edx
  8044d8:	83 c4 1c             	add    $0x1c,%esp
  8044db:	5b                   	pop    %ebx
  8044dc:	5e                   	pop    %esi
  8044dd:	5f                   	pop    %edi
  8044de:	5d                   	pop    %ebp
  8044df:	c3                   	ret    
  8044e0:	3b 04 24             	cmp    (%esp),%eax
  8044e3:	72 06                	jb     8044eb <__umoddi3+0x113>
  8044e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8044e9:	77 0f                	ja     8044fa <__umoddi3+0x122>
  8044eb:	89 f2                	mov    %esi,%edx
  8044ed:	29 f9                	sub    %edi,%ecx
  8044ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8044f3:	89 14 24             	mov    %edx,(%esp)
  8044f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8044fe:	8b 14 24             	mov    (%esp),%edx
  804501:	83 c4 1c             	add    $0x1c,%esp
  804504:	5b                   	pop    %ebx
  804505:	5e                   	pop    %esi
  804506:	5f                   	pop    %edi
  804507:	5d                   	pop    %ebp
  804508:	c3                   	ret    
  804509:	8d 76 00             	lea    0x0(%esi),%esi
  80450c:	2b 04 24             	sub    (%esp),%eax
  80450f:	19 fa                	sbb    %edi,%edx
  804511:	89 d1                	mov    %edx,%ecx
  804513:	89 c6                	mov    %eax,%esi
  804515:	e9 71 ff ff ff       	jmp    80448b <__umoddi3+0xb3>
  80451a:	66 90                	xchg   %ax,%ax
  80451c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804520:	72 ea                	jb     80450c <__umoddi3+0x134>
  804522:	89 d9                	mov    %ebx,%ecx
  804524:	e9 62 ff ff ff       	jmp    80448b <__umoddi3+0xb3>
