
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
  800062:	68 c0 45 80 00       	push   $0x8045c0
  800067:	e8 f2 14 00 00       	call   80155e <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 1f 27 00 00       	call   802793 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 b7 27 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  8000a1:	68 e4 45 80 00       	push   $0x8045e4
  8000a6:	6a 11                	push   $0x11
  8000a8:	68 14 46 80 00       	push   $0x804614
  8000ad:	e8 f8 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000b5:	e8 d9 26 00 00       	call   802793 <sys_calculate_free_frames>
  8000ba:	29 c3                	sub    %eax,%ebx
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 2c 46 80 00       	push   $0x80462c
  8000cb:	6a 13                	push   $0x13
  8000cd:	68 14 46 80 00       	push   $0x804614
  8000d2:	e8 d3 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256)panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 57 27 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  8000dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 98 46 80 00       	push   $0x804698
  8000ee:	6a 14                	push   $0x14
  8000f0:	68 14 46 80 00       	push   $0x804614
  8000f5:	e8 b0 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000fa:	e8 94 26 00 00       	call   802793 <sys_calculate_free_frames>
  8000ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800102:	e8 2c 27 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  800133:	68 e4 45 80 00       	push   $0x8045e4
  800138:	6a 19                	push   $0x19
  80013a:	68 14 46 80 00       	push   $0x804614
  80013f:	e8 66 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800144:	e8 4a 26 00 00       	call   802793 <sys_calculate_free_frames>
  800149:	89 c2                	mov    %eax,%edx
  80014b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014e:	39 c2                	cmp    %eax,%edx
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 2c 46 80 00       	push   $0x80462c
  80015a:	6a 1b                	push   $0x1b
  80015c:	68 14 46 80 00       	push   $0x804614
  800161:	e8 44 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800166:	e8 c8 26 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  80016b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80016e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 98 46 80 00       	push   $0x804698
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 14 46 80 00       	push   $0x804614
  800184:	e8 21 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800189:	e8 05 26 00 00       	call   802793 <sys_calculate_free_frames>
  80018e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800191:	e8 9d 26 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  8001c4:	68 e4 45 80 00       	push   $0x8045e4
  8001c9:	6a 21                	push   $0x21
  8001cb:	68 14 46 80 00       	push   $0x804614
  8001d0:	e8 d5 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001d5:	e8 b9 25 00 00       	call   802793 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 2c 46 80 00       	push   $0x80462c
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 14 46 80 00       	push   $0x804614
  8001f2:	e8 b3 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8001f7:	e8 37 26 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  8001fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 98 46 80 00       	push   $0x804698
  80020e:	6a 24                	push   $0x24
  800210:	68 14 46 80 00       	push   $0x804614
  800215:	e8 90 10 00 00       	call   8012aa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80021a:	e8 74 25 00 00       	call   802793 <sys_calculate_free_frames>
  80021f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800222:	e8 0c 26 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  800259:	68 e4 45 80 00       	push   $0x8045e4
  80025e:	6a 2a                	push   $0x2a
  800260:	68 14 46 80 00       	push   $0x804614
  800265:	e8 40 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026a:	e8 24 25 00 00       	call   802793 <sys_calculate_free_frames>
  80026f:	89 c2                	mov    %eax,%edx
  800271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 2c 46 80 00       	push   $0x80462c
  800280:	6a 2c                	push   $0x2c
  800282:	68 14 46 80 00       	push   $0x804614
  800287:	e8 1e 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80028c:	e8 a2 25 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	3d 00 01 00 00       	cmp    $0x100,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 98 46 80 00       	push   $0x804698
  8002a3:	6a 2d                	push   $0x2d
  8002a5:	68 14 46 80 00       	push   $0x804614
  8002aa:	e8 fb 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 df 24 00 00       	call   802793 <sys_calculate_free_frames>
  8002b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 77 25 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  8002ed:	68 e4 45 80 00       	push   $0x8045e4
  8002f2:	6a 33                	push   $0x33
  8002f4:	68 14 46 80 00       	push   $0x804614
  8002f9:	e8 ac 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800301:	e8 8d 24 00 00       	call   802793 <sys_calculate_free_frames>
  800306:	29 c3                	sub    %eax,%ebx
  800308:	89 d8                	mov    %ebx,%eax
  80030a:	83 f8 01             	cmp    $0x1,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 2c 46 80 00       	push   $0x80462c
  800317:	6a 35                	push   $0x35
  800319:	68 14 46 80 00       	push   $0x804614
  80031e:	e8 87 0f 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800323:	e8 0b 25 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800328:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 98 46 80 00       	push   $0x804698
  80033a:	6a 36                	push   $0x36
  80033c:	68 14 46 80 00       	push   $0x804614
  800341:	e8 64 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800346:	e8 48 24 00 00       	call   802793 <sys_calculate_free_frames>
  80034b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80034e:	e8 e0 24 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  800389:	68 e4 45 80 00       	push   $0x8045e4
  80038e:	6a 3c                	push   $0x3c
  800390:	68 14 46 80 00       	push   $0x804614
  800395:	e8 10 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039a:	e8 f4 23 00 00       	call   802793 <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 2c 46 80 00       	push   $0x80462c
  8003b0:	6a 3e                	push   $0x3e
  8003b2:	68 14 46 80 00       	push   $0x804614
  8003b7:	e8 ee 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003bc:	e8 72 24 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  8003c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 98 46 80 00       	push   $0x804698
  8003d3:	6a 3f                	push   $0x3f
  8003d5:	68 14 46 80 00       	push   $0x804614
  8003da:	e8 cb 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 af 23 00 00       	call   802793 <sys_calculate_free_frames>
  8003e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 47 24 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  800421:	68 e4 45 80 00       	push   $0x8045e4
  800426:	6a 45                	push   $0x45
  800428:	68 14 46 80 00       	push   $0x804614
  80042d:	e8 78 0e 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800432:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800435:	e8 59 23 00 00       	call   802793 <sys_calculate_free_frames>
  80043a:	29 c3                	sub    %eax,%ebx
  80043c:	89 d8                	mov    %ebx,%eax
  80043e:	83 f8 01             	cmp    $0x1,%eax
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 2c 46 80 00       	push   $0x80462c
  80044b:	6a 47                	push   $0x47
  80044d:	68 14 46 80 00       	push   $0x804614
  800452:	e8 53 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800457:	e8 d7 23 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  80045c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80045f:	3d 00 03 00 00       	cmp    $0x300,%eax
  800464:	74 14                	je     80047a <_main+0x442>
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 98 46 80 00       	push   $0x804698
  80046e:	6a 48                	push   $0x48
  800470:	68 14 46 80 00       	push   $0x804614
  800475:	e8 30 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80047a:	e8 14 23 00 00       	call   802793 <sys_calculate_free_frames>
  80047f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800482:	e8 ac 23 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  8004c4:	68 e4 45 80 00       	push   $0x8045e4
  8004c9:	6a 4e                	push   $0x4e
  8004cb:	68 14 46 80 00       	push   $0x804614
  8004d0:	e8 d5 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8004d8:	e8 b6 22 00 00       	call   802793 <sys_calculate_free_frames>
  8004dd:	29 c3                	sub    %eax,%ebx
  8004df:	89 d8                	mov    %ebx,%eax
  8004e1:	83 f8 01             	cmp    $0x1,%eax
  8004e4:	74 14                	je     8004fa <_main+0x4c2>
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 2c 46 80 00       	push   $0x80462c
  8004ee:	6a 50                	push   $0x50
  8004f0:	68 14 46 80 00       	push   $0x804614
  8004f5:	e8 b0 0d 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8004fa:	e8 34 23 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  8004ff:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800502:	3d 00 03 00 00       	cmp    $0x300,%eax
  800507:	74 14                	je     80051d <_main+0x4e5>
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 98 46 80 00       	push   $0x804698
  800511:	6a 51                	push   $0x51
  800513:	68 14 46 80 00       	push   $0x804614
  800518:	e8 8d 0d 00 00       	call   8012aa <_panic>


		//NEW
		//Filling the remaining size of user heap
		freeFrames = sys_calculate_free_frames() ;
  80051d:	e8 71 22 00 00       	call   802793 <sys_calculate_free_frames>
  800522:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800525:	e8 09 23 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  80057f:	68 e4 45 80 00       	push   $0x8045e4
  800584:	6a 5a                	push   $0x5a
  800586:	68 14 46 80 00       	push   $0x804614
  80058b:	e8 1a 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800590:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800593:	e8 fb 21 00 00       	call   802793 <sys_calculate_free_frames>
  800598:	29 c3                	sub    %eax,%ebx
  80059a:	89 d8                	mov    %ebx,%eax
  80059c:	83 f8 7c             	cmp    $0x7c,%eax
  80059f:	74 14                	je     8005b5 <_main+0x57d>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 2c 46 80 00       	push   $0x80462c
  8005a9:	6a 5c                	push   $0x5c
  8005ab:	68 14 46 80 00       	push   $0x804614
  8005b0:	e8 f5 0c 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005b5:	e8 79 22 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  8005ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8005bd:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 98 46 80 00       	push   $0x804698
  8005cc:	6a 5d                	push   $0x5d
  8005ce:	68 14 46 80 00       	push   $0x804614
  8005d3:	e8 d2 0c 00 00       	call   8012aa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 b6 21 00 00       	call   802793 <sys_calculate_free_frames>
  8005dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e0:	e8 4e 22 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8005e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	50                   	push   %eax
  8005ef:	e8 20 1f 00 00       	call   802514 <free>
  8005f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005f7:	e8 37 22 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  8005fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
  800601:	89 d0                	mov    %edx,%eax
  800603:	3d 00 01 00 00       	cmp    $0x100,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 c8 46 80 00       	push   $0x8046c8
  800612:	6a 68                	push   $0x68
  800614:	68 14 46 80 00       	push   $0x804614
  800619:	e8 8c 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80061e:	e8 70 21 00 00       	call   802793 <sys_calculate_free_frames>
  800623:	89 c2                	mov    %eax,%edx
  800625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	74 14                	je     800640 <_main+0x608>
  80062c:	83 ec 04             	sub    $0x4,%esp
  80062f:	68 04 47 80 00       	push   $0x804704
  800634:	6a 69                	push   $0x69
  800636:	68 14 46 80 00       	push   $0x804614
  80063b:	e8 6a 0c 00 00       	call   8012aa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800640:	e8 4e 21 00 00       	call   802793 <sys_calculate_free_frames>
  800645:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800648:	e8 e6 21 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800650:	8b 45 90             	mov    -0x70(%ebp),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	50                   	push   %eax
  800657:	e8 b8 1e 00 00       	call   802514 <free>
  80065c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80065f:	e8 cf 21 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800667:	29 c2                	sub    %eax,%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800670:	74 14                	je     800686 <_main+0x64e>
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	68 c8 46 80 00       	push   $0x8046c8
  80067a:	6a 70                	push   $0x70
  80067c:	68 14 46 80 00       	push   $0x804614
  800681:	e8 24 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800686:	e8 08 21 00 00       	call   802793 <sys_calculate_free_frames>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 04 47 80 00       	push   $0x804704
  80069c:	6a 71                	push   $0x71
  80069e:	68 14 46 80 00       	push   $0x804614
  8006a3:	e8 02 0c 00 00       	call   8012aa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006a8:	e8 e6 20 00 00       	call   802793 <sys_calculate_free_frames>
  8006ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006b0:	e8 7e 21 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8006b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	50                   	push   %eax
  8006bf:	e8 50 1e 00 00       	call   802514 <free>
  8006c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006c7:	e8 67 21 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  8006cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cf:	29 c2                	sub    %eax,%edx
  8006d1:	89 d0                	mov    %edx,%eax
  8006d3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006d8:	74 14                	je     8006ee <_main+0x6b6>
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	68 c8 46 80 00       	push   $0x8046c8
  8006e2:	6a 78                	push   $0x78
  8006e4:	68 14 46 80 00       	push   $0x804614
  8006e9:	e8 bc 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006ee:	e8 a0 20 00 00       	call   802793 <sys_calculate_free_frames>
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f8:	39 c2                	cmp    %eax,%edx
  8006fa:	74 14                	je     800710 <_main+0x6d8>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 04 47 80 00       	push   $0x804704
  800704:	6a 79                	push   $0x79
  800706:	68 14 46 80 00       	push   $0x804614
  80070b:	e8 9a 0b 00 00       	call   8012aa <_panic>

		//NEW
		//free the latest Hole (the big one)
		freeFrames = sys_calculate_free_frames() ;
  800710:	e8 7e 20 00 00       	call   802793 <sys_calculate_free_frames>
  800715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800718:	e8 16 21 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  800720:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	50                   	push   %eax
  800727:	e8 e8 1d 00 00       	call   802514 <free>
  80072c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
  80072f:	e8 ff 20 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
  800739:	89 d0                	mov    %edx,%eax
  80073b:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  800740:	74 17                	je     800759 <_main+0x721>
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	68 c8 46 80 00       	push   $0x8046c8
  80074a:	68 81 00 00 00       	push   $0x81
  80074f:	68 14 46 80 00       	push   $0x804614
  800754:	e8 51 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800759:	e8 35 20 00 00       	call   802793 <sys_calculate_free_frames>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800763:	39 c2                	cmp    %eax,%edx
  800765:	74 17                	je     80077e <_main+0x746>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 04 47 80 00       	push   $0x804704
  80076f:	68 82 00 00 00       	push   $0x82
  800774:	68 14 46 80 00       	push   $0x804614
  800779:	e8 2c 0b 00 00       	call   8012aa <_panic>
	}
	int cnt = 0;
  80077e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800785:	e8 09 20 00 00       	call   802793 <sys_calculate_free_frames>
  80078a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80078d:	e8 a1 20 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  8007c2:	68 e4 45 80 00       	push   $0x8045e4
  8007c7:	68 8e 00 00 00       	push   $0x8e
  8007cc:	68 14 46 80 00       	push   $0x804614
  8007d1:	e8 d4 0a 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8007d6:	e8 b8 1f 00 00       	call   802793 <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 2c 46 80 00       	push   $0x80462c
  8007ec:	68 90 00 00 00       	push   $0x90
  8007f1:	68 14 46 80 00       	push   $0x804614
  8007f6:	e8 af 0a 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  8007fb:	e8 33 20 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800800:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800803:	3d 80 00 00 00       	cmp    $0x80,%eax
  800808:	74 17                	je     800821 <_main+0x7e9>
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 98 46 80 00       	push   $0x804698
  800812:	68 91 00 00 00       	push   $0x91
  800817:	68 14 46 80 00       	push   $0x804614
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
  80088b:	e8 03 1f 00 00       	call   802793 <sys_calculate_free_frames>
  800890:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800893:	e8 9b 1f 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  8008b3:	e8 59 1d 00 00       	call   802611 <realloc>
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
  8008d2:	68 50 47 80 00       	push   $0x804750
  8008d7:	68 ae 00 00 00       	push   $0xae
  8008dc:	68 14 46 80 00       	push   $0x804614
  8008e1:	e8 c4 09 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008e6:	e8 a8 1e 00 00       	call   802793 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 84 47 80 00       	push   $0x804784
  8008fc:	68 b0 00 00 00       	push   $0xb0
  800901:	68 14 46 80 00       	push   $0x804614
  800906:	e8 9f 09 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are re-allocated in PageFile");
  80090b:	e8 23 1f 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800910:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800913:	83 f8 40             	cmp    $0x40,%eax
  800916:	74 17                	je     80092f <_main+0x8f7>
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 f4 47 80 00       	push   $0x8047f4
  800920:	68 b1 00 00 00       	push   $0xb1
  800925:	68 14 46 80 00       	push   $0x804614
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
  8009b9:	68 28 48 80 00       	push   $0x804828
  8009be:	68 c6 00 00 00       	push   $0xc6
  8009c3:	68 14 46 80 00       	push   $0x804614
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
  8009f7:	68 28 48 80 00       	push   $0x804828
  8009fc:	68 cc 00 00 00       	push   $0xcc
  800a01:	68 14 46 80 00       	push   $0x804614
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
  800a3b:	68 28 48 80 00       	push   $0x804828
  800a40:	68 d2 00 00 00       	push   $0xd2
  800a45:	68 14 46 80 00       	push   $0x804614
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
  800a7e:	68 28 48 80 00       	push   $0x804828
  800a83:	68 d8 00 00 00       	push   $0xd8
  800a88:	68 14 46 80 00       	push   $0x804614
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
  800aa0:	e8 ee 1c 00 00       	call   802793 <sys_calculate_free_frames>
  800aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800aa8:	e8 86 1d 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800ab0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	50                   	push   %eax
  800ab7:	e8 58 1a 00 00       	call   802514 <free>
  800abc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800abf:	e8 6f 1d 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800ad0:	74 17                	je     800ae9 <_main+0xab1>
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	68 60 48 80 00       	push   $0x804860
  800ada:	68 e0 00 00 00       	push   $0xe0
  800adf:	68 14 46 80 00       	push   $0x804614
  800ae4:	e8 c1 07 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ae9:	e8 a5 1c 00 00       	call   802793 <sys_calculate_free_frames>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	83 f8 05             	cmp    $0x5,%eax
  800afa:	74 17                	je     800b13 <_main+0xadb>
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	68 04 47 80 00       	push   $0x804704
  800b04:	68 e1 00 00 00       	push   $0xe1
  800b09:	68 14 46 80 00       	push   $0x804614
  800b0e:	e8 97 07 00 00       	call   8012aa <_panic>

		vcprintf("\b\b\b40%", NULL);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	6a 00                	push   $0x0
  800b18:	68 b4 48 80 00       	push   $0x8048b4
  800b1d:	e8 d1 09 00 00       	call   8014f3 <vcprintf>
  800b22:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800b25:	e8 69 1c 00 00       	call   802793 <sys_calculate_free_frames>
  800b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b2d:	e8 01 1d 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  800b6b:	68 e4 45 80 00       	push   $0x8045e4
  800b70:	68 eb 00 00 00       	push   $0xeb
  800b75:	68 14 46 80 00       	push   $0x804614
  800b7a:	e8 2b 07 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b7f:	e8 0f 1c 00 00       	call   802793 <sys_calculate_free_frames>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	74 17                	je     800ba4 <_main+0xb6c>
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	68 2c 46 80 00       	push   $0x80462c
  800b95:	68 ed 00 00 00       	push   $0xed
  800b9a:	68 14 46 80 00       	push   $0x804614
  800b9f:	e8 06 07 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800ba4:	e8 8a 1c 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800ba9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800bac:	3d 80 01 00 00       	cmp    $0x180,%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 98 46 80 00       	push   $0x804698
  800bbb:	68 ee 00 00 00       	push   $0xee
  800bc0:	68 14 46 80 00       	push   $0x804614
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
  800c3b:	e8 53 1b 00 00       	call   802793 <sys_calculate_free_frames>
  800c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 eb 1b 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  800c6a:	e8 a2 19 00 00       	call   802611 <realloc>
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
  800c8c:	68 50 47 80 00       	push   $0x804750
  800c91:	68 07 01 00 00       	push   $0x107
  800c96:	68 14 46 80 00       	push   $0x804614
  800c9b:	e8 0a 06 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");

		//if((sys_calculate_free_frames() - freeFrames) != 3) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  800ca0:	e8 8e 1b 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800ca5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cad:	74 17                	je     800cc6 <_main+0xc8e>
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	68 f4 47 80 00       	push   $0x8047f4
  800cb7:	68 0b 01 00 00       	push   $0x10b
  800cbc:	68 14 46 80 00       	push   $0x804614
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
  800d59:	68 28 48 80 00       	push   $0x804828
  800d5e:	68 22 01 00 00       	push   $0x122
  800d63:	68 14 46 80 00       	push   $0x804614
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
  800d97:	68 28 48 80 00       	push   $0x804828
  800d9c:	68 2a 01 00 00       	push   $0x12a
  800da1:	68 14 46 80 00       	push   $0x804614
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
  800ddb:	68 28 48 80 00       	push   $0x804828
  800de0:	68 31 01 00 00       	push   $0x131
  800de5:	68 14 46 80 00       	push   $0x804614
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
  800e1e:	68 28 48 80 00       	push   $0x804828
  800e23:	68 37 01 00 00       	push   $0x137
  800e28:	68 14 46 80 00       	push   $0x804614
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
  800e40:	e8 4e 19 00 00       	call   802793 <sys_calculate_free_frames>
  800e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e48:	e8 e6 19 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800e50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	e8 b8 16 00 00       	call   802514 <free>
  800e5c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e5f:	e8 cf 19 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	3d 80 02 00 00       	cmp    $0x280,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 60 48 80 00       	push   $0x804860
  800e7a:	68 40 01 00 00       	push   $0x140
  800e7f:	68 14 46 80 00       	push   $0x804614
  800e84:	e8 21 04 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b70%", NULL);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	6a 00                	push   $0x0
  800e8e:	68 bb 48 80 00       	push   $0x8048bb
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
  800f02:	e8 8c 18 00 00       	call   802793 <sys_calculate_free_frames>
  800f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f0a:	e8 24 19 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
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
  800f25:	e8 e7 16 00 00       	call   802611 <realloc>
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
  800f50:	68 50 47 80 00       	push   $0x804750
  800f55:	68 60 01 00 00       	push   $0x160
  800f5a:	68 14 46 80 00       	push   $0x804614
  800f5f:	e8 46 03 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are re-allocated in PageFile");
  800f64:	e8 ca 18 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  800f69:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f6c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800f71:	74 17                	je     800f8a <_main+0xf52>
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 f4 47 80 00       	push   $0x8047f4
  800f7b:	68 63 01 00 00       	push   $0x163
  800f80:	68 14 46 80 00       	push   $0x804614
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
  801014:	68 28 48 80 00       	push   $0x804828
  801019:	68 79 01 00 00       	push   $0x179
  80101e:	68 14 46 80 00       	push   $0x804614
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
  801052:	68 28 48 80 00       	push   $0x804828
  801057:	68 81 01 00 00       	push   $0x181
  80105c:	68 14 46 80 00       	push   $0x804614
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
  801096:	68 28 48 80 00       	push   $0x804828
  80109b:	68 88 01 00 00       	push   $0x188
  8010a0:	68 14 46 80 00       	push   $0x804614
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
  8010d9:	68 28 48 80 00       	push   $0x804828
  8010de:	68 8e 01 00 00       	push   $0x18e
  8010e3:	68 14 46 80 00       	push   $0x804614
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
  8010fb:	e8 93 16 00 00       	call   802793 <sys_calculate_free_frames>
  801100:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801103:	e8 2b 17 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  801108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[0]);
  80110b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	e8 fd 13 00 00       	call   802514 <free>
  801117:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  80111a:	e8 14 17 00 00       	call   802833 <sys_pf_calculate_allocated_pages>
  80111f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112b:	74 17                	je     801144 <_main+0x110c>
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 60 48 80 00       	push   $0x804860
  801135:	68 96 01 00 00       	push   $0x196
  80113a:	68 14 46 80 00       	push   $0x804614
  80113f:	e8 66 01 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 2) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 00                	push   $0x0
  801149:	68 c2 48 80 00       	push   $0x8048c2
  80114e:	e8 a0 03 00 00       	call   8014f3 <vcprintf>
  801153:	83 c4 10             	add    $0x10,%esp
	}

	cprintf("Congratulations!! test realloc [1] completed successfully.\n");
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 cc 48 80 00       	push   $0x8048cc
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
  801174:	e8 fa 18 00 00       	call   802a73 <sys_getenvindex>
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
  8011df:	e8 9c 16 00 00       	call   802880 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	68 20 49 80 00       	push   $0x804920
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
  80120f:	68 48 49 80 00       	push   $0x804948
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
  801240:	68 70 49 80 00       	push   $0x804970
  801245:	e8 14 03 00 00       	call   80155e <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80124d:	a1 20 60 80 00       	mov    0x806020,%eax
  801252:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	50                   	push   %eax
  80125c:	68 c8 49 80 00       	push   $0x8049c8
  801261:	e8 f8 02 00 00       	call   80155e <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	68 20 49 80 00       	push   $0x804920
  801271:	e8 e8 02 00 00       	call   80155e <cprintf>
  801276:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801279:	e8 1c 16 00 00       	call   80289a <sys_enable_interrupt>

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
  801291:	e8 a9 17 00 00       	call   802a3f <sys_destroy_env>
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
  8012a2:	e8 fe 17 00 00       	call   802aa5 <sys_exit_env>
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
  8012cb:	68 dc 49 80 00       	push   $0x8049dc
  8012d0:	e8 89 02 00 00       	call   80155e <cprintf>
  8012d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8012d8:	a1 00 60 80 00       	mov    0x806000,%eax
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	50                   	push   %eax
  8012e4:	68 e1 49 80 00       	push   $0x8049e1
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
  801308:	68 fd 49 80 00       	push   $0x8049fd
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
  801334:	68 00 4a 80 00       	push   $0x804a00
  801339:	6a 26                	push   $0x26
  80133b:	68 4c 4a 80 00       	push   $0x804a4c
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
  801406:	68 58 4a 80 00       	push   $0x804a58
  80140b:	6a 3a                	push   $0x3a
  80140d:	68 4c 4a 80 00       	push   $0x804a4c
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
  801476:	68 ac 4a 80 00       	push   $0x804aac
  80147b:	6a 44                	push   $0x44
  80147d:	68 4c 4a 80 00       	push   $0x804a4c
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
  8014d0:	e8 fd 11 00 00       	call   8026d2 <sys_cputs>
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
  801547:	e8 86 11 00 00       	call   8026d2 <sys_cputs>
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
  801591:	e8 ea 12 00 00       	call   802880 <sys_disable_interrupt>
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
  8015b1:	e8 e4 12 00 00       	call   80289a <sys_enable_interrupt>
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
  8015fb:	e8 58 2d 00 00       	call   804358 <__udivdi3>
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
  80164b:	e8 18 2e 00 00       	call   804468 <__umoddi3>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	05 14 4d 80 00       	add    $0x804d14,%eax
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
  8017a6:	8b 04 85 38 4d 80 00 	mov    0x804d38(,%eax,4),%eax
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
  801887:	8b 34 9d 80 4b 80 00 	mov    0x804b80(,%ebx,4),%esi
  80188e:	85 f6                	test   %esi,%esi
  801890:	75 19                	jne    8018ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801892:	53                   	push   %ebx
  801893:	68 25 4d 80 00       	push   $0x804d25
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
  8018ac:	68 2e 4d 80 00       	push   $0x804d2e
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
  8018d9:	be 31 4d 80 00       	mov    $0x804d31,%esi
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
  8022ff:	68 90 4e 80 00       	push   $0x804e90
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
  8023cf:	e8 42 04 00 00       	call   802816 <sys_allocate_chunk>
  8023d4:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8023d7:	a1 20 61 80 00       	mov    0x806120,%eax
  8023dc:	83 ec 0c             	sub    $0xc,%esp
  8023df:	50                   	push   %eax
  8023e0:	e8 b7 0a 00 00       	call   802e9c <initialize_MemBlocksList>
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
  80240d:	68 b5 4e 80 00       	push   $0x804eb5
  802412:	6a 33                	push   $0x33
  802414:	68 d3 4e 80 00       	push   $0x804ed3
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
  80248c:	68 e0 4e 80 00       	push   $0x804ee0
  802491:	6a 34                	push   $0x34
  802493:	68 d3 4e 80 00       	push   $0x804ed3
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
  802501:	68 04 4f 80 00       	push   $0x804f04
  802506:	6a 46                	push   $0x46
  802508:	68 d3 4e 80 00       	push   $0x804ed3
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
  80251d:	68 2c 4f 80 00       	push   $0x804f2c
  802522:	6a 61                	push   $0x61
  802524:	68 d3 4e 80 00       	push   $0x804ed3
  802529:	e8 7c ed ff ff       	call   8012aa <_panic>

0080252e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
  802531:	83 ec 38             	sub    $0x38,%esp
  802534:	8b 45 10             	mov    0x10(%ebp),%eax
  802537:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80253a:	e8 a9 fd ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  80253f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802543:	75 0a                	jne    80254f <smalloc+0x21>
  802545:	b8 00 00 00 00       	mov    $0x0,%eax
  80254a:	e9 9e 00 00 00       	jmp    8025ed <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80254f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802556:	8b 55 0c             	mov    0xc(%ebp),%edx
  802559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255c:	01 d0                	add    %edx,%eax
  80255e:	48                   	dec    %eax
  80255f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802562:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802565:	ba 00 00 00 00       	mov    $0x0,%edx
  80256a:	f7 75 f0             	divl   -0x10(%ebp)
  80256d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802570:	29 d0                	sub    %edx,%eax
  802572:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802575:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80257c:	e8 63 06 00 00       	call   802be4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802581:	85 c0                	test   %eax,%eax
  802583:	74 11                	je     802596 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  802585:	83 ec 0c             	sub    $0xc,%esp
  802588:	ff 75 e8             	pushl  -0x18(%ebp)
  80258b:	e8 ce 0c 00 00       	call   80325e <alloc_block_FF>
  802590:	83 c4 10             	add    $0x10,%esp
  802593:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  802596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259a:	74 4c                	je     8025e8 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 08             	mov    0x8(%eax),%eax
  8025a2:	89 c2                	mov    %eax,%edx
  8025a4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8025a8:	52                   	push   %edx
  8025a9:	50                   	push   %eax
  8025aa:	ff 75 0c             	pushl  0xc(%ebp)
  8025ad:	ff 75 08             	pushl  0x8(%ebp)
  8025b0:	e8 b4 03 00 00       	call   802969 <sys_createSharedObject>
  8025b5:	83 c4 10             	add    $0x10,%esp
  8025b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8025bb:	83 ec 08             	sub    $0x8,%esp
  8025be:	ff 75 e0             	pushl  -0x20(%ebp)
  8025c1:	68 4f 4f 80 00       	push   $0x804f4f
  8025c6:	e8 93 ef ff ff       	call   80155e <cprintf>
  8025cb:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8025ce:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8025d2:	74 14                	je     8025e8 <smalloc+0xba>
  8025d4:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8025d8:	74 0e                	je     8025e8 <smalloc+0xba>
  8025da:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8025de:	74 08                	je     8025e8 <smalloc+0xba>
			return (void*) mem_block->sva;
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	8b 40 08             	mov    0x8(%eax),%eax
  8025e6:	eb 05                	jmp    8025ed <smalloc+0xbf>
	}
	return NULL;
  8025e8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8025f5:	e8 ee fc ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8025fa:	83 ec 04             	sub    $0x4,%esp
  8025fd:	68 64 4f 80 00       	push   $0x804f64
  802602:	68 ab 00 00 00       	push   $0xab
  802607:	68 d3 4e 80 00       	push   $0x804ed3
  80260c:	e8 99 ec ff ff       	call   8012aa <_panic>

00802611 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
  802614:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802617:	e8 cc fc ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80261c:	83 ec 04             	sub    $0x4,%esp
  80261f:	68 88 4f 80 00       	push   $0x804f88
  802624:	68 ef 00 00 00       	push   $0xef
  802629:	68 d3 4e 80 00       	push   $0x804ed3
  80262e:	e8 77 ec ff ff       	call   8012aa <_panic>

00802633 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
  802636:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802639:	83 ec 04             	sub    $0x4,%esp
  80263c:	68 b0 4f 80 00       	push   $0x804fb0
  802641:	68 03 01 00 00       	push   $0x103
  802646:	68 d3 4e 80 00       	push   $0x804ed3
  80264b:	e8 5a ec ff ff       	call   8012aa <_panic>

00802650 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802656:	83 ec 04             	sub    $0x4,%esp
  802659:	68 d4 4f 80 00       	push   $0x804fd4
  80265e:	68 0e 01 00 00       	push   $0x10e
  802663:	68 d3 4e 80 00       	push   $0x804ed3
  802668:	e8 3d ec ff ff       	call   8012aa <_panic>

0080266d <shrink>:

}
void shrink(uint32 newSize)
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
  802670:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802673:	83 ec 04             	sub    $0x4,%esp
  802676:	68 d4 4f 80 00       	push   $0x804fd4
  80267b:	68 13 01 00 00       	push   $0x113
  802680:	68 d3 4e 80 00       	push   $0x804ed3
  802685:	e8 20 ec ff ff       	call   8012aa <_panic>

0080268a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802690:	83 ec 04             	sub    $0x4,%esp
  802693:	68 d4 4f 80 00       	push   $0x804fd4
  802698:	68 18 01 00 00       	push   $0x118
  80269d:	68 d3 4e 80 00       	push   $0x804ed3
  8026a2:	e8 03 ec ff ff       	call   8012aa <_panic>

008026a7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
  8026aa:	57                   	push   %edi
  8026ab:	56                   	push   %esi
  8026ac:	53                   	push   %ebx
  8026ad:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026bc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8026bf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8026c2:	cd 30                	int    $0x30
  8026c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8026c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8026ca:	83 c4 10             	add    $0x10,%esp
  8026cd:	5b                   	pop    %ebx
  8026ce:	5e                   	pop    %esi
  8026cf:	5f                   	pop    %edi
  8026d0:	5d                   	pop    %ebp
  8026d1:	c3                   	ret    

008026d2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8026d2:	55                   	push   %ebp
  8026d3:	89 e5                	mov    %esp,%ebp
  8026d5:	83 ec 04             	sub    $0x4,%esp
  8026d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8026db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8026de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 00                	push   $0x0
  8026e9:	52                   	push   %edx
  8026ea:	ff 75 0c             	pushl  0xc(%ebp)
  8026ed:	50                   	push   %eax
  8026ee:	6a 00                	push   $0x0
  8026f0:	e8 b2 ff ff ff       	call   8026a7 <syscall>
  8026f5:	83 c4 18             	add    $0x18,%esp
}
  8026f8:	90                   	nop
  8026f9:	c9                   	leave  
  8026fa:	c3                   	ret    

008026fb <sys_cgetc>:

int
sys_cgetc(void)
{
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 01                	push   $0x1
  80270a:	e8 98 ff ff ff       	call   8026a7 <syscall>
  80270f:	83 c4 18             	add    $0x18,%esp
}
  802712:	c9                   	leave  
  802713:	c3                   	ret    

00802714 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802717:	8b 55 0c             	mov    0xc(%ebp),%edx
  80271a:	8b 45 08             	mov    0x8(%ebp),%eax
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	6a 00                	push   $0x0
  802723:	52                   	push   %edx
  802724:	50                   	push   %eax
  802725:	6a 05                	push   $0x5
  802727:	e8 7b ff ff ff       	call   8026a7 <syscall>
  80272c:	83 c4 18             	add    $0x18,%esp
}
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

00802731 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	56                   	push   %esi
  802735:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802736:	8b 75 18             	mov    0x18(%ebp),%esi
  802739:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80273c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80273f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802742:	8b 45 08             	mov    0x8(%ebp),%eax
  802745:	56                   	push   %esi
  802746:	53                   	push   %ebx
  802747:	51                   	push   %ecx
  802748:	52                   	push   %edx
  802749:	50                   	push   %eax
  80274a:	6a 06                	push   $0x6
  80274c:	e8 56 ff ff ff       	call   8026a7 <syscall>
  802751:	83 c4 18             	add    $0x18,%esp
}
  802754:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802757:	5b                   	pop    %ebx
  802758:	5e                   	pop    %esi
  802759:	5d                   	pop    %ebp
  80275a:	c3                   	ret    

0080275b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80275b:	55                   	push   %ebp
  80275c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80275e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802761:	8b 45 08             	mov    0x8(%ebp),%eax
  802764:	6a 00                	push   $0x0
  802766:	6a 00                	push   $0x0
  802768:	6a 00                	push   $0x0
  80276a:	52                   	push   %edx
  80276b:	50                   	push   %eax
  80276c:	6a 07                	push   $0x7
  80276e:	e8 34 ff ff ff       	call   8026a7 <syscall>
  802773:	83 c4 18             	add    $0x18,%esp
}
  802776:	c9                   	leave  
  802777:	c3                   	ret    

00802778 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	ff 75 0c             	pushl  0xc(%ebp)
  802784:	ff 75 08             	pushl  0x8(%ebp)
  802787:	6a 08                	push   $0x8
  802789:	e8 19 ff ff ff       	call   8026a7 <syscall>
  80278e:	83 c4 18             	add    $0x18,%esp
}
  802791:	c9                   	leave  
  802792:	c3                   	ret    

00802793 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802793:	55                   	push   %ebp
  802794:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 09                	push   $0x9
  8027a2:	e8 00 ff ff ff       	call   8026a7 <syscall>
  8027a7:	83 c4 18             	add    $0x18,%esp
}
  8027aa:	c9                   	leave  
  8027ab:	c3                   	ret    

008027ac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8027af:	6a 00                	push   $0x0
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 0a                	push   $0xa
  8027bb:	e8 e7 fe ff ff       	call   8026a7 <syscall>
  8027c0:	83 c4 18             	add    $0x18,%esp
}
  8027c3:	c9                   	leave  
  8027c4:	c3                   	ret    

008027c5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 0b                	push   $0xb
  8027d4:	e8 ce fe ff ff       	call   8026a7 <syscall>
  8027d9:	83 c4 18             	add    $0x18,%esp
}
  8027dc:	c9                   	leave  
  8027dd:	c3                   	ret    

008027de <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	ff 75 0c             	pushl  0xc(%ebp)
  8027ea:	ff 75 08             	pushl  0x8(%ebp)
  8027ed:	6a 0f                	push   $0xf
  8027ef:	e8 b3 fe ff ff       	call   8026a7 <syscall>
  8027f4:	83 c4 18             	add    $0x18,%esp
	return;
  8027f7:	90                   	nop
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	6a 00                	push   $0x0
  802803:	ff 75 0c             	pushl  0xc(%ebp)
  802806:	ff 75 08             	pushl  0x8(%ebp)
  802809:	6a 10                	push   $0x10
  80280b:	e8 97 fe ff ff       	call   8026a7 <syscall>
  802810:	83 c4 18             	add    $0x18,%esp
	return ;
  802813:	90                   	nop
}
  802814:	c9                   	leave  
  802815:	c3                   	ret    

00802816 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802816:	55                   	push   %ebp
  802817:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802819:	6a 00                	push   $0x0
  80281b:	6a 00                	push   $0x0
  80281d:	ff 75 10             	pushl  0x10(%ebp)
  802820:	ff 75 0c             	pushl  0xc(%ebp)
  802823:	ff 75 08             	pushl  0x8(%ebp)
  802826:	6a 11                	push   $0x11
  802828:	e8 7a fe ff ff       	call   8026a7 <syscall>
  80282d:	83 c4 18             	add    $0x18,%esp
	return ;
  802830:	90                   	nop
}
  802831:	c9                   	leave  
  802832:	c3                   	ret    

00802833 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802833:	55                   	push   %ebp
  802834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802836:	6a 00                	push   $0x0
  802838:	6a 00                	push   $0x0
  80283a:	6a 00                	push   $0x0
  80283c:	6a 00                	push   $0x0
  80283e:	6a 00                	push   $0x0
  802840:	6a 0c                	push   $0xc
  802842:	e8 60 fe ff ff       	call   8026a7 <syscall>
  802847:	83 c4 18             	add    $0x18,%esp
}
  80284a:	c9                   	leave  
  80284b:	c3                   	ret    

0080284c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	ff 75 08             	pushl  0x8(%ebp)
  80285a:	6a 0d                	push   $0xd
  80285c:	e8 46 fe ff ff       	call   8026a7 <syscall>
  802861:	83 c4 18             	add    $0x18,%esp
}
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	6a 0e                	push   $0xe
  802875:	e8 2d fe ff ff       	call   8026a7 <syscall>
  80287a:	83 c4 18             	add    $0x18,%esp
}
  80287d:	90                   	nop
  80287e:	c9                   	leave  
  80287f:	c3                   	ret    

00802880 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 13                	push   $0x13
  80288f:	e8 13 fe ff ff       	call   8026a7 <syscall>
  802894:	83 c4 18             	add    $0x18,%esp
}
  802897:	90                   	nop
  802898:	c9                   	leave  
  802899:	c3                   	ret    

0080289a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80289a:	55                   	push   %ebp
  80289b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80289d:	6a 00                	push   $0x0
  80289f:	6a 00                	push   $0x0
  8028a1:	6a 00                	push   $0x0
  8028a3:	6a 00                	push   $0x0
  8028a5:	6a 00                	push   $0x0
  8028a7:	6a 14                	push   $0x14
  8028a9:	e8 f9 fd ff ff       	call   8026a7 <syscall>
  8028ae:	83 c4 18             	add    $0x18,%esp
}
  8028b1:	90                   	nop
  8028b2:	c9                   	leave  
  8028b3:	c3                   	ret    

008028b4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
  8028b7:	83 ec 04             	sub    $0x4,%esp
  8028ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8028c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028c4:	6a 00                	push   $0x0
  8028c6:	6a 00                	push   $0x0
  8028c8:	6a 00                	push   $0x0
  8028ca:	6a 00                	push   $0x0
  8028cc:	50                   	push   %eax
  8028cd:	6a 15                	push   $0x15
  8028cf:	e8 d3 fd ff ff       	call   8026a7 <syscall>
  8028d4:	83 c4 18             	add    $0x18,%esp
}
  8028d7:	90                   	nop
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    

008028da <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 16                	push   $0x16
  8028e9:	e8 b9 fd ff ff       	call   8026a7 <syscall>
  8028ee:	83 c4 18             	add    $0x18,%esp
}
  8028f1:	90                   	nop
  8028f2:	c9                   	leave  
  8028f3:	c3                   	ret    

008028f4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8028f4:	55                   	push   %ebp
  8028f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	ff 75 0c             	pushl  0xc(%ebp)
  802903:	50                   	push   %eax
  802904:	6a 17                	push   $0x17
  802906:	e8 9c fd ff ff       	call   8026a7 <syscall>
  80290b:	83 c4 18             	add    $0x18,%esp
}
  80290e:	c9                   	leave  
  80290f:	c3                   	ret    

00802910 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802913:	8b 55 0c             	mov    0xc(%ebp),%edx
  802916:	8b 45 08             	mov    0x8(%ebp),%eax
  802919:	6a 00                	push   $0x0
  80291b:	6a 00                	push   $0x0
  80291d:	6a 00                	push   $0x0
  80291f:	52                   	push   %edx
  802920:	50                   	push   %eax
  802921:	6a 1a                	push   $0x1a
  802923:	e8 7f fd ff ff       	call   8026a7 <syscall>
  802928:	83 c4 18             	add    $0x18,%esp
}
  80292b:	c9                   	leave  
  80292c:	c3                   	ret    

0080292d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80292d:	55                   	push   %ebp
  80292e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802930:	8b 55 0c             	mov    0xc(%ebp),%edx
  802933:	8b 45 08             	mov    0x8(%ebp),%eax
  802936:	6a 00                	push   $0x0
  802938:	6a 00                	push   $0x0
  80293a:	6a 00                	push   $0x0
  80293c:	52                   	push   %edx
  80293d:	50                   	push   %eax
  80293e:	6a 18                	push   $0x18
  802940:	e8 62 fd ff ff       	call   8026a7 <syscall>
  802945:	83 c4 18             	add    $0x18,%esp
}
  802948:	90                   	nop
  802949:	c9                   	leave  
  80294a:	c3                   	ret    

0080294b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80294b:	55                   	push   %ebp
  80294c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80294e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	6a 00                	push   $0x0
  802956:	6a 00                	push   $0x0
  802958:	6a 00                	push   $0x0
  80295a:	52                   	push   %edx
  80295b:	50                   	push   %eax
  80295c:	6a 19                	push   $0x19
  80295e:	e8 44 fd ff ff       	call   8026a7 <syscall>
  802963:	83 c4 18             	add    $0x18,%esp
}
  802966:	90                   	nop
  802967:	c9                   	leave  
  802968:	c3                   	ret    

00802969 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802969:	55                   	push   %ebp
  80296a:	89 e5                	mov    %esp,%ebp
  80296c:	83 ec 04             	sub    $0x4,%esp
  80296f:	8b 45 10             	mov    0x10(%ebp),%eax
  802972:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802975:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802978:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80297c:	8b 45 08             	mov    0x8(%ebp),%eax
  80297f:	6a 00                	push   $0x0
  802981:	51                   	push   %ecx
  802982:	52                   	push   %edx
  802983:	ff 75 0c             	pushl  0xc(%ebp)
  802986:	50                   	push   %eax
  802987:	6a 1b                	push   $0x1b
  802989:	e8 19 fd ff ff       	call   8026a7 <syscall>
  80298e:	83 c4 18             	add    $0x18,%esp
}
  802991:	c9                   	leave  
  802992:	c3                   	ret    

00802993 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802993:	55                   	push   %ebp
  802994:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802996:	8b 55 0c             	mov    0xc(%ebp),%edx
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	6a 00                	push   $0x0
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	52                   	push   %edx
  8029a3:	50                   	push   %eax
  8029a4:	6a 1c                	push   $0x1c
  8029a6:	e8 fc fc ff ff       	call   8026a7 <syscall>
  8029ab:	83 c4 18             	add    $0x18,%esp
}
  8029ae:	c9                   	leave  
  8029af:	c3                   	ret    

008029b0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8029b0:	55                   	push   %ebp
  8029b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8029b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	51                   	push   %ecx
  8029c1:	52                   	push   %edx
  8029c2:	50                   	push   %eax
  8029c3:	6a 1d                	push   $0x1d
  8029c5:	e8 dd fc ff ff       	call   8026a7 <syscall>
  8029ca:	83 c4 18             	add    $0x18,%esp
}
  8029cd:	c9                   	leave  
  8029ce:	c3                   	ret    

008029cf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8029cf:	55                   	push   %ebp
  8029d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8029d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	52                   	push   %edx
  8029df:	50                   	push   %eax
  8029e0:	6a 1e                	push   $0x1e
  8029e2:	e8 c0 fc ff ff       	call   8026a7 <syscall>
  8029e7:	83 c4 18             	add    $0x18,%esp
}
  8029ea:	c9                   	leave  
  8029eb:	c3                   	ret    

008029ec <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8029ec:	55                   	push   %ebp
  8029ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8029ef:	6a 00                	push   $0x0
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 1f                	push   $0x1f
  8029fb:	e8 a7 fc ff ff       	call   8026a7 <syscall>
  802a00:	83 c4 18             	add    $0x18,%esp
}
  802a03:	c9                   	leave  
  802a04:	c3                   	ret    

00802a05 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802a05:	55                   	push   %ebp
  802a06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	6a 00                	push   $0x0
  802a0d:	ff 75 14             	pushl  0x14(%ebp)
  802a10:	ff 75 10             	pushl  0x10(%ebp)
  802a13:	ff 75 0c             	pushl  0xc(%ebp)
  802a16:	50                   	push   %eax
  802a17:	6a 20                	push   $0x20
  802a19:	e8 89 fc ff ff       	call   8026a7 <syscall>
  802a1e:	83 c4 18             	add    $0x18,%esp
}
  802a21:	c9                   	leave  
  802a22:	c3                   	ret    

00802a23 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802a23:	55                   	push   %ebp
  802a24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	6a 00                	push   $0x0
  802a2b:	6a 00                	push   $0x0
  802a2d:	6a 00                	push   $0x0
  802a2f:	6a 00                	push   $0x0
  802a31:	50                   	push   %eax
  802a32:	6a 21                	push   $0x21
  802a34:	e8 6e fc ff ff       	call   8026a7 <syscall>
  802a39:	83 c4 18             	add    $0x18,%esp
}
  802a3c:	90                   	nop
  802a3d:	c9                   	leave  
  802a3e:	c3                   	ret    

00802a3f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802a3f:	55                   	push   %ebp
  802a40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802a42:	8b 45 08             	mov    0x8(%ebp),%eax
  802a45:	6a 00                	push   $0x0
  802a47:	6a 00                	push   $0x0
  802a49:	6a 00                	push   $0x0
  802a4b:	6a 00                	push   $0x0
  802a4d:	50                   	push   %eax
  802a4e:	6a 22                	push   $0x22
  802a50:	e8 52 fc ff ff       	call   8026a7 <syscall>
  802a55:	83 c4 18             	add    $0x18,%esp
}
  802a58:	c9                   	leave  
  802a59:	c3                   	ret    

00802a5a <sys_getenvid>:

int32 sys_getenvid(void)
{
  802a5a:	55                   	push   %ebp
  802a5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802a5d:	6a 00                	push   $0x0
  802a5f:	6a 00                	push   $0x0
  802a61:	6a 00                	push   $0x0
  802a63:	6a 00                	push   $0x0
  802a65:	6a 00                	push   $0x0
  802a67:	6a 02                	push   $0x2
  802a69:	e8 39 fc ff ff       	call   8026a7 <syscall>
  802a6e:	83 c4 18             	add    $0x18,%esp
}
  802a71:	c9                   	leave  
  802a72:	c3                   	ret    

00802a73 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802a73:	55                   	push   %ebp
  802a74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	6a 00                	push   $0x0
  802a7c:	6a 00                	push   $0x0
  802a7e:	6a 00                	push   $0x0
  802a80:	6a 03                	push   $0x3
  802a82:	e8 20 fc ff ff       	call   8026a7 <syscall>
  802a87:	83 c4 18             	add    $0x18,%esp
}
  802a8a:	c9                   	leave  
  802a8b:	c3                   	ret    

00802a8c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802a8c:	55                   	push   %ebp
  802a8d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802a8f:	6a 00                	push   $0x0
  802a91:	6a 00                	push   $0x0
  802a93:	6a 00                	push   $0x0
  802a95:	6a 00                	push   $0x0
  802a97:	6a 00                	push   $0x0
  802a99:	6a 04                	push   $0x4
  802a9b:	e8 07 fc ff ff       	call   8026a7 <syscall>
  802aa0:	83 c4 18             	add    $0x18,%esp
}
  802aa3:	c9                   	leave  
  802aa4:	c3                   	ret    

00802aa5 <sys_exit_env>:


void sys_exit_env(void)
{
  802aa5:	55                   	push   %ebp
  802aa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 00                	push   $0x0
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 23                	push   $0x23
  802ab4:	e8 ee fb ff ff       	call   8026a7 <syscall>
  802ab9:	83 c4 18             	add    $0x18,%esp
}
  802abc:	90                   	nop
  802abd:	c9                   	leave  
  802abe:	c3                   	ret    

00802abf <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802abf:	55                   	push   %ebp
  802ac0:	89 e5                	mov    %esp,%ebp
  802ac2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802ac5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802ac8:	8d 50 04             	lea    0x4(%eax),%edx
  802acb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802ace:	6a 00                	push   $0x0
  802ad0:	6a 00                	push   $0x0
  802ad2:	6a 00                	push   $0x0
  802ad4:	52                   	push   %edx
  802ad5:	50                   	push   %eax
  802ad6:	6a 24                	push   $0x24
  802ad8:	e8 ca fb ff ff       	call   8026a7 <syscall>
  802add:	83 c4 18             	add    $0x18,%esp
	return result;
  802ae0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ae3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802ae6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ae9:	89 01                	mov    %eax,(%ecx)
  802aeb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802aee:	8b 45 08             	mov    0x8(%ebp),%eax
  802af1:	c9                   	leave  
  802af2:	c2 04 00             	ret    $0x4

00802af5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802af5:	55                   	push   %ebp
  802af6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802af8:	6a 00                	push   $0x0
  802afa:	6a 00                	push   $0x0
  802afc:	ff 75 10             	pushl  0x10(%ebp)
  802aff:	ff 75 0c             	pushl  0xc(%ebp)
  802b02:	ff 75 08             	pushl  0x8(%ebp)
  802b05:	6a 12                	push   $0x12
  802b07:	e8 9b fb ff ff       	call   8026a7 <syscall>
  802b0c:	83 c4 18             	add    $0x18,%esp
	return ;
  802b0f:	90                   	nop
}
  802b10:	c9                   	leave  
  802b11:	c3                   	ret    

00802b12 <sys_rcr2>:
uint32 sys_rcr2()
{
  802b12:	55                   	push   %ebp
  802b13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802b15:	6a 00                	push   $0x0
  802b17:	6a 00                	push   $0x0
  802b19:	6a 00                	push   $0x0
  802b1b:	6a 00                	push   $0x0
  802b1d:	6a 00                	push   $0x0
  802b1f:	6a 25                	push   $0x25
  802b21:	e8 81 fb ff ff       	call   8026a7 <syscall>
  802b26:	83 c4 18             	add    $0x18,%esp
}
  802b29:	c9                   	leave  
  802b2a:	c3                   	ret    

00802b2b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802b2b:	55                   	push   %ebp
  802b2c:	89 e5                	mov    %esp,%ebp
  802b2e:	83 ec 04             	sub    $0x4,%esp
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802b37:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	50                   	push   %eax
  802b44:	6a 26                	push   $0x26
  802b46:	e8 5c fb ff ff       	call   8026a7 <syscall>
  802b4b:	83 c4 18             	add    $0x18,%esp
	return ;
  802b4e:	90                   	nop
}
  802b4f:	c9                   	leave  
  802b50:	c3                   	ret    

00802b51 <rsttst>:
void rsttst()
{
  802b51:	55                   	push   %ebp
  802b52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802b54:	6a 00                	push   $0x0
  802b56:	6a 00                	push   $0x0
  802b58:	6a 00                	push   $0x0
  802b5a:	6a 00                	push   $0x0
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 28                	push   $0x28
  802b60:	e8 42 fb ff ff       	call   8026a7 <syscall>
  802b65:	83 c4 18             	add    $0x18,%esp
	return ;
  802b68:	90                   	nop
}
  802b69:	c9                   	leave  
  802b6a:	c3                   	ret    

00802b6b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802b6b:	55                   	push   %ebp
  802b6c:	89 e5                	mov    %esp,%ebp
  802b6e:	83 ec 04             	sub    $0x4,%esp
  802b71:	8b 45 14             	mov    0x14(%ebp),%eax
  802b74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802b77:	8b 55 18             	mov    0x18(%ebp),%edx
  802b7a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b7e:	52                   	push   %edx
  802b7f:	50                   	push   %eax
  802b80:	ff 75 10             	pushl  0x10(%ebp)
  802b83:	ff 75 0c             	pushl  0xc(%ebp)
  802b86:	ff 75 08             	pushl  0x8(%ebp)
  802b89:	6a 27                	push   $0x27
  802b8b:	e8 17 fb ff ff       	call   8026a7 <syscall>
  802b90:	83 c4 18             	add    $0x18,%esp
	return ;
  802b93:	90                   	nop
}
  802b94:	c9                   	leave  
  802b95:	c3                   	ret    

00802b96 <chktst>:
void chktst(uint32 n)
{
  802b96:	55                   	push   %ebp
  802b97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b99:	6a 00                	push   $0x0
  802b9b:	6a 00                	push   $0x0
  802b9d:	6a 00                	push   $0x0
  802b9f:	6a 00                	push   $0x0
  802ba1:	ff 75 08             	pushl  0x8(%ebp)
  802ba4:	6a 29                	push   $0x29
  802ba6:	e8 fc fa ff ff       	call   8026a7 <syscall>
  802bab:	83 c4 18             	add    $0x18,%esp
	return ;
  802bae:	90                   	nop
}
  802baf:	c9                   	leave  
  802bb0:	c3                   	ret    

00802bb1 <inctst>:

void inctst()
{
  802bb1:	55                   	push   %ebp
  802bb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802bb4:	6a 00                	push   $0x0
  802bb6:	6a 00                	push   $0x0
  802bb8:	6a 00                	push   $0x0
  802bba:	6a 00                	push   $0x0
  802bbc:	6a 00                	push   $0x0
  802bbe:	6a 2a                	push   $0x2a
  802bc0:	e8 e2 fa ff ff       	call   8026a7 <syscall>
  802bc5:	83 c4 18             	add    $0x18,%esp
	return ;
  802bc8:	90                   	nop
}
  802bc9:	c9                   	leave  
  802bca:	c3                   	ret    

00802bcb <gettst>:
uint32 gettst()
{
  802bcb:	55                   	push   %ebp
  802bcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802bce:	6a 00                	push   $0x0
  802bd0:	6a 00                	push   $0x0
  802bd2:	6a 00                	push   $0x0
  802bd4:	6a 00                	push   $0x0
  802bd6:	6a 00                	push   $0x0
  802bd8:	6a 2b                	push   $0x2b
  802bda:	e8 c8 fa ff ff       	call   8026a7 <syscall>
  802bdf:	83 c4 18             	add    $0x18,%esp
}
  802be2:	c9                   	leave  
  802be3:	c3                   	ret    

00802be4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802be4:	55                   	push   %ebp
  802be5:	89 e5                	mov    %esp,%ebp
  802be7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bea:	6a 00                	push   $0x0
  802bec:	6a 00                	push   $0x0
  802bee:	6a 00                	push   $0x0
  802bf0:	6a 00                	push   $0x0
  802bf2:	6a 00                	push   $0x0
  802bf4:	6a 2c                	push   $0x2c
  802bf6:	e8 ac fa ff ff       	call   8026a7 <syscall>
  802bfb:	83 c4 18             	add    $0x18,%esp
  802bfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802c01:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802c05:	75 07                	jne    802c0e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802c07:	b8 01 00 00 00       	mov    $0x1,%eax
  802c0c:	eb 05                	jmp    802c13 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c13:	c9                   	leave  
  802c14:	c3                   	ret    

00802c15 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802c15:	55                   	push   %ebp
  802c16:	89 e5                	mov    %esp,%ebp
  802c18:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c1b:	6a 00                	push   $0x0
  802c1d:	6a 00                	push   $0x0
  802c1f:	6a 00                	push   $0x0
  802c21:	6a 00                	push   $0x0
  802c23:	6a 00                	push   $0x0
  802c25:	6a 2c                	push   $0x2c
  802c27:	e8 7b fa ff ff       	call   8026a7 <syscall>
  802c2c:	83 c4 18             	add    $0x18,%esp
  802c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802c32:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802c36:	75 07                	jne    802c3f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802c38:	b8 01 00 00 00       	mov    $0x1,%eax
  802c3d:	eb 05                	jmp    802c44 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802c3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c44:	c9                   	leave  
  802c45:	c3                   	ret    

00802c46 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802c46:	55                   	push   %ebp
  802c47:	89 e5                	mov    %esp,%ebp
  802c49:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c4c:	6a 00                	push   $0x0
  802c4e:	6a 00                	push   $0x0
  802c50:	6a 00                	push   $0x0
  802c52:	6a 00                	push   $0x0
  802c54:	6a 00                	push   $0x0
  802c56:	6a 2c                	push   $0x2c
  802c58:	e8 4a fa ff ff       	call   8026a7 <syscall>
  802c5d:	83 c4 18             	add    $0x18,%esp
  802c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802c63:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802c67:	75 07                	jne    802c70 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802c69:	b8 01 00 00 00       	mov    $0x1,%eax
  802c6e:	eb 05                	jmp    802c75 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c75:	c9                   	leave  
  802c76:	c3                   	ret    

00802c77 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802c77:	55                   	push   %ebp
  802c78:	89 e5                	mov    %esp,%ebp
  802c7a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c7d:	6a 00                	push   $0x0
  802c7f:	6a 00                	push   $0x0
  802c81:	6a 00                	push   $0x0
  802c83:	6a 00                	push   $0x0
  802c85:	6a 00                	push   $0x0
  802c87:	6a 2c                	push   $0x2c
  802c89:	e8 19 fa ff ff       	call   8026a7 <syscall>
  802c8e:	83 c4 18             	add    $0x18,%esp
  802c91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802c94:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802c98:	75 07                	jne    802ca1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802c9a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c9f:	eb 05                	jmp    802ca6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ca6:	c9                   	leave  
  802ca7:	c3                   	ret    

00802ca8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ca8:	55                   	push   %ebp
  802ca9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	6a 00                	push   $0x0
  802cb1:	6a 00                	push   $0x0
  802cb3:	ff 75 08             	pushl  0x8(%ebp)
  802cb6:	6a 2d                	push   $0x2d
  802cb8:	e8 ea f9 ff ff       	call   8026a7 <syscall>
  802cbd:	83 c4 18             	add    $0x18,%esp
	return ;
  802cc0:	90                   	nop
}
  802cc1:	c9                   	leave  
  802cc2:	c3                   	ret    

00802cc3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802cc3:	55                   	push   %ebp
  802cc4:	89 e5                	mov    %esp,%ebp
  802cc6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802cc7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802cca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	6a 00                	push   $0x0
  802cd5:	53                   	push   %ebx
  802cd6:	51                   	push   %ecx
  802cd7:	52                   	push   %edx
  802cd8:	50                   	push   %eax
  802cd9:	6a 2e                	push   $0x2e
  802cdb:	e8 c7 f9 ff ff       	call   8026a7 <syscall>
  802ce0:	83 c4 18             	add    $0x18,%esp
}
  802ce3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ce6:	c9                   	leave  
  802ce7:	c3                   	ret    

00802ce8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	6a 00                	push   $0x0
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	52                   	push   %edx
  802cf8:	50                   	push   %eax
  802cf9:	6a 2f                	push   $0x2f
  802cfb:	e8 a7 f9 ff ff       	call   8026a7 <syscall>
  802d00:	83 c4 18             	add    $0x18,%esp
}
  802d03:	c9                   	leave  
  802d04:	c3                   	ret    

00802d05 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802d05:	55                   	push   %ebp
  802d06:	89 e5                	mov    %esp,%ebp
  802d08:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802d0b:	83 ec 0c             	sub    $0xc,%esp
  802d0e:	68 e4 4f 80 00       	push   $0x804fe4
  802d13:	e8 46 e8 ff ff       	call   80155e <cprintf>
  802d18:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802d1b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802d22:	83 ec 0c             	sub    $0xc,%esp
  802d25:	68 10 50 80 00       	push   $0x805010
  802d2a:	e8 2f e8 ff ff       	call   80155e <cprintf>
  802d2f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802d32:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d36:	a1 38 61 80 00       	mov    0x806138,%eax
  802d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d3e:	eb 56                	jmp    802d96 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802d40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d44:	74 1c                	je     802d62 <print_mem_block_lists+0x5d>
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	8b 50 08             	mov    0x8(%eax),%edx
  802d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4f:	8b 48 08             	mov    0x8(%eax),%ecx
  802d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d55:	8b 40 0c             	mov    0xc(%eax),%eax
  802d58:	01 c8                	add    %ecx,%eax
  802d5a:	39 c2                	cmp    %eax,%edx
  802d5c:	73 04                	jae    802d62 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802d5e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 50 08             	mov    0x8(%eax),%edx
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6e:	01 c2                	add    %eax,%edx
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 40 08             	mov    0x8(%eax),%eax
  802d76:	83 ec 04             	sub    $0x4,%esp
  802d79:	52                   	push   %edx
  802d7a:	50                   	push   %eax
  802d7b:	68 25 50 80 00       	push   $0x805025
  802d80:	e8 d9 e7 ff ff       	call   80155e <cprintf>
  802d85:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d8e:	a1 40 61 80 00       	mov    0x806140,%eax
  802d93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9a:	74 07                	je     802da3 <print_mem_block_lists+0x9e>
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 00                	mov    (%eax),%eax
  802da1:	eb 05                	jmp    802da8 <print_mem_block_lists+0xa3>
  802da3:	b8 00 00 00 00       	mov    $0x0,%eax
  802da8:	a3 40 61 80 00       	mov    %eax,0x806140
  802dad:	a1 40 61 80 00       	mov    0x806140,%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	75 8a                	jne    802d40 <print_mem_block_lists+0x3b>
  802db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dba:	75 84                	jne    802d40 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802dbc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802dc0:	75 10                	jne    802dd2 <print_mem_block_lists+0xcd>
  802dc2:	83 ec 0c             	sub    $0xc,%esp
  802dc5:	68 34 50 80 00       	push   $0x805034
  802dca:	e8 8f e7 ff ff       	call   80155e <cprintf>
  802dcf:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802dd2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802dd9:	83 ec 0c             	sub    $0xc,%esp
  802ddc:	68 58 50 80 00       	push   $0x805058
  802de1:	e8 78 e7 ff ff       	call   80155e <cprintf>
  802de6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802de9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802ded:	a1 40 60 80 00       	mov    0x806040,%eax
  802df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df5:	eb 56                	jmp    802e4d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802df7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dfb:	74 1c                	je     802e19 <print_mem_block_lists+0x114>
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 50 08             	mov    0x8(%eax),%edx
  802e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e06:	8b 48 08             	mov    0x8(%eax),%ecx
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0f:	01 c8                	add    %ecx,%eax
  802e11:	39 c2                	cmp    %eax,%edx
  802e13:	73 04                	jae    802e19 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802e15:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 50 08             	mov    0x8(%eax),%edx
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	8b 40 0c             	mov    0xc(%eax),%eax
  802e25:	01 c2                	add    %eax,%edx
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 40 08             	mov    0x8(%eax),%eax
  802e2d:	83 ec 04             	sub    $0x4,%esp
  802e30:	52                   	push   %edx
  802e31:	50                   	push   %eax
  802e32:	68 25 50 80 00       	push   $0x805025
  802e37:	e8 22 e7 ff ff       	call   80155e <cprintf>
  802e3c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802e45:	a1 48 60 80 00       	mov    0x806048,%eax
  802e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e51:	74 07                	je     802e5a <print_mem_block_lists+0x155>
  802e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e56:	8b 00                	mov    (%eax),%eax
  802e58:	eb 05                	jmp    802e5f <print_mem_block_lists+0x15a>
  802e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5f:	a3 48 60 80 00       	mov    %eax,0x806048
  802e64:	a1 48 60 80 00       	mov    0x806048,%eax
  802e69:	85 c0                	test   %eax,%eax
  802e6b:	75 8a                	jne    802df7 <print_mem_block_lists+0xf2>
  802e6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e71:	75 84                	jne    802df7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802e73:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802e77:	75 10                	jne    802e89 <print_mem_block_lists+0x184>
  802e79:	83 ec 0c             	sub    $0xc,%esp
  802e7c:	68 70 50 80 00       	push   $0x805070
  802e81:	e8 d8 e6 ff ff       	call   80155e <cprintf>
  802e86:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802e89:	83 ec 0c             	sub    $0xc,%esp
  802e8c:	68 e4 4f 80 00       	push   $0x804fe4
  802e91:	e8 c8 e6 ff ff       	call   80155e <cprintf>
  802e96:	83 c4 10             	add    $0x10,%esp

}
  802e99:	90                   	nop
  802e9a:	c9                   	leave  
  802e9b:	c3                   	ret    

00802e9c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802e9c:	55                   	push   %ebp
  802e9d:	89 e5                	mov    %esp,%ebp
  802e9f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802ea2:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  802ea9:	00 00 00 
  802eac:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  802eb3:	00 00 00 
  802eb6:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  802ebd:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802ec0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ec7:	e9 9e 00 00 00       	jmp    802f6a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802ecc:	a1 50 60 80 00       	mov    0x806050,%eax
  802ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed4:	c1 e2 04             	shl    $0x4,%edx
  802ed7:	01 d0                	add    %edx,%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	75 14                	jne    802ef1 <initialize_MemBlocksList+0x55>
  802edd:	83 ec 04             	sub    $0x4,%esp
  802ee0:	68 98 50 80 00       	push   $0x805098
  802ee5:	6a 46                	push   $0x46
  802ee7:	68 bb 50 80 00       	push   $0x8050bb
  802eec:	e8 b9 e3 ff ff       	call   8012aa <_panic>
  802ef1:	a1 50 60 80 00       	mov    0x806050,%eax
  802ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef9:	c1 e2 04             	shl    $0x4,%edx
  802efc:	01 d0                	add    %edx,%eax
  802efe:	8b 15 48 61 80 00    	mov    0x806148,%edx
  802f04:	89 10                	mov    %edx,(%eax)
  802f06:	8b 00                	mov    (%eax),%eax
  802f08:	85 c0                	test   %eax,%eax
  802f0a:	74 18                	je     802f24 <initialize_MemBlocksList+0x88>
  802f0c:	a1 48 61 80 00       	mov    0x806148,%eax
  802f11:	8b 15 50 60 80 00    	mov    0x806050,%edx
  802f17:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802f1a:	c1 e1 04             	shl    $0x4,%ecx
  802f1d:	01 ca                	add    %ecx,%edx
  802f1f:	89 50 04             	mov    %edx,0x4(%eax)
  802f22:	eb 12                	jmp    802f36 <initialize_MemBlocksList+0x9a>
  802f24:	a1 50 60 80 00       	mov    0x806050,%eax
  802f29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f2c:	c1 e2 04             	shl    $0x4,%edx
  802f2f:	01 d0                	add    %edx,%eax
  802f31:	a3 4c 61 80 00       	mov    %eax,0x80614c
  802f36:	a1 50 60 80 00       	mov    0x806050,%eax
  802f3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f3e:	c1 e2 04             	shl    $0x4,%edx
  802f41:	01 d0                	add    %edx,%eax
  802f43:	a3 48 61 80 00       	mov    %eax,0x806148
  802f48:	a1 50 60 80 00       	mov    0x806050,%eax
  802f4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f50:	c1 e2 04             	shl    $0x4,%edx
  802f53:	01 d0                	add    %edx,%eax
  802f55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5c:	a1 54 61 80 00       	mov    0x806154,%eax
  802f61:	40                   	inc    %eax
  802f62:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802f67:	ff 45 f4             	incl   -0xc(%ebp)
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f70:	0f 82 56 ff ff ff    	jb     802ecc <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802f76:	90                   	nop
  802f77:	c9                   	leave  
  802f78:	c3                   	ret    

00802f79 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802f79:	55                   	push   %ebp
  802f7a:	89 e5                	mov    %esp,%ebp
  802f7c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	8b 00                	mov    (%eax),%eax
  802f84:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802f87:	eb 19                	jmp    802fa2 <find_block+0x29>
	{
		if(va==point->sva)
  802f89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f8c:	8b 40 08             	mov    0x8(%eax),%eax
  802f8f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f92:	75 05                	jne    802f99 <find_block+0x20>
		   return point;
  802f94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f97:	eb 36                	jmp    802fcf <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	8b 40 08             	mov    0x8(%eax),%eax
  802f9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802fa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802fa6:	74 07                	je     802faf <find_block+0x36>
  802fa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	eb 05                	jmp    802fb4 <find_block+0x3b>
  802faf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb7:	89 42 08             	mov    %eax,0x8(%edx)
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	8b 40 08             	mov    0x8(%eax),%eax
  802fc0:	85 c0                	test   %eax,%eax
  802fc2:	75 c5                	jne    802f89 <find_block+0x10>
  802fc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802fc8:	75 bf                	jne    802f89 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802fca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fcf:	c9                   	leave  
  802fd0:	c3                   	ret    

00802fd1 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802fd1:	55                   	push   %ebp
  802fd2:	89 e5                	mov    %esp,%ebp
  802fd4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802fd7:	a1 40 60 80 00       	mov    0x806040,%eax
  802fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802fdf:	a1 44 60 80 00       	mov    0x806044,%eax
  802fe4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802fed:	74 24                	je     803013 <insert_sorted_allocList+0x42>
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	8b 50 08             	mov    0x8(%eax),%edx
  802ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff8:	8b 40 08             	mov    0x8(%eax),%eax
  802ffb:	39 c2                	cmp    %eax,%edx
  802ffd:	76 14                	jbe    803013 <insert_sorted_allocList+0x42>
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	8b 50 08             	mov    0x8(%eax),%edx
  803005:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803008:	8b 40 08             	mov    0x8(%eax),%eax
  80300b:	39 c2                	cmp    %eax,%edx
  80300d:	0f 82 60 01 00 00    	jb     803173 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  803013:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803017:	75 65                	jne    80307e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  803019:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301d:	75 14                	jne    803033 <insert_sorted_allocList+0x62>
  80301f:	83 ec 04             	sub    $0x4,%esp
  803022:	68 98 50 80 00       	push   $0x805098
  803027:	6a 6b                	push   $0x6b
  803029:	68 bb 50 80 00       	push   $0x8050bb
  80302e:	e8 77 e2 ff ff       	call   8012aa <_panic>
  803033:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	89 10                	mov    %edx,(%eax)
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	8b 00                	mov    (%eax),%eax
  803043:	85 c0                	test   %eax,%eax
  803045:	74 0d                	je     803054 <insert_sorted_allocList+0x83>
  803047:	a1 40 60 80 00       	mov    0x806040,%eax
  80304c:	8b 55 08             	mov    0x8(%ebp),%edx
  80304f:	89 50 04             	mov    %edx,0x4(%eax)
  803052:	eb 08                	jmp    80305c <insert_sorted_allocList+0x8b>
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	a3 44 60 80 00       	mov    %eax,0x806044
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	a3 40 60 80 00       	mov    %eax,0x806040
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803073:	40                   	inc    %eax
  803074:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803079:	e9 dc 01 00 00       	jmp    80325a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	8b 50 08             	mov    0x8(%eax),%edx
  803084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803087:	8b 40 08             	mov    0x8(%eax),%eax
  80308a:	39 c2                	cmp    %eax,%edx
  80308c:	77 6c                	ja     8030fa <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80308e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803092:	74 06                	je     80309a <insert_sorted_allocList+0xc9>
  803094:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803098:	75 14                	jne    8030ae <insert_sorted_allocList+0xdd>
  80309a:	83 ec 04             	sub    $0x4,%esp
  80309d:	68 d4 50 80 00       	push   $0x8050d4
  8030a2:	6a 6f                	push   $0x6f
  8030a4:	68 bb 50 80 00       	push   $0x8050bb
  8030a9:	e8 fc e1 ff ff       	call   8012aa <_panic>
  8030ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b1:	8b 50 04             	mov    0x4(%eax),%edx
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c0:	89 10                	mov    %edx,(%eax)
  8030c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c5:	8b 40 04             	mov    0x4(%eax),%eax
  8030c8:	85 c0                	test   %eax,%eax
  8030ca:	74 0d                	je     8030d9 <insert_sorted_allocList+0x108>
  8030cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cf:	8b 40 04             	mov    0x4(%eax),%eax
  8030d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d5:	89 10                	mov    %edx,(%eax)
  8030d7:	eb 08                	jmp    8030e1 <insert_sorted_allocList+0x110>
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	a3 40 60 80 00       	mov    %eax,0x806040
  8030e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ea:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8030ef:	40                   	inc    %eax
  8030f0:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8030f5:	e9 60 01 00 00       	jmp    80325a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	8b 50 08             	mov    0x8(%eax),%edx
  803100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803103:	8b 40 08             	mov    0x8(%eax),%eax
  803106:	39 c2                	cmp    %eax,%edx
  803108:	0f 82 4c 01 00 00    	jb     80325a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80310e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803112:	75 14                	jne    803128 <insert_sorted_allocList+0x157>
  803114:	83 ec 04             	sub    $0x4,%esp
  803117:	68 0c 51 80 00       	push   $0x80510c
  80311c:	6a 73                	push   $0x73
  80311e:	68 bb 50 80 00       	push   $0x8050bb
  803123:	e8 82 e1 ff ff       	call   8012aa <_panic>
  803128:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	89 50 04             	mov    %edx,0x4(%eax)
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	8b 40 04             	mov    0x4(%eax),%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 0c                	je     80314a <insert_sorted_allocList+0x179>
  80313e:	a1 44 60 80 00       	mov    0x806044,%eax
  803143:	8b 55 08             	mov    0x8(%ebp),%edx
  803146:	89 10                	mov    %edx,(%eax)
  803148:	eb 08                	jmp    803152 <insert_sorted_allocList+0x181>
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	a3 40 60 80 00       	mov    %eax,0x806040
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	a3 44 60 80 00       	mov    %eax,0x806044
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803163:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803168:	40                   	inc    %eax
  803169:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80316e:	e9 e7 00 00 00       	jmp    80325a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  803173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803176:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  803179:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  803180:	a1 40 60 80 00       	mov    0x806040,%eax
  803185:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803188:	e9 9d 00 00 00       	jmp    80322a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	8b 00                	mov    (%eax),%eax
  803192:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	8b 50 08             	mov    0x8(%eax),%edx
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	8b 40 08             	mov    0x8(%eax),%eax
  8031a1:	39 c2                	cmp    %eax,%edx
  8031a3:	76 7d                	jbe    803222 <insert_sorted_allocList+0x251>
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	8b 50 08             	mov    0x8(%eax),%edx
  8031ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ae:	8b 40 08             	mov    0x8(%eax),%eax
  8031b1:	39 c2                	cmp    %eax,%edx
  8031b3:	73 6d                	jae    803222 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8031b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b9:	74 06                	je     8031c1 <insert_sorted_allocList+0x1f0>
  8031bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031bf:	75 14                	jne    8031d5 <insert_sorted_allocList+0x204>
  8031c1:	83 ec 04             	sub    $0x4,%esp
  8031c4:	68 30 51 80 00       	push   $0x805130
  8031c9:	6a 7f                	push   $0x7f
  8031cb:	68 bb 50 80 00       	push   $0x8050bb
  8031d0:	e8 d5 e0 ff ff       	call   8012aa <_panic>
  8031d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d8:	8b 10                	mov    (%eax),%edx
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	89 10                	mov    %edx,(%eax)
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	8b 00                	mov    (%eax),%eax
  8031e4:	85 c0                	test   %eax,%eax
  8031e6:	74 0b                	je     8031f3 <insert_sorted_allocList+0x222>
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f0:	89 50 04             	mov    %edx,0x4(%eax)
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f9:	89 10                	mov    %edx,(%eax)
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803201:	89 50 04             	mov    %edx,0x4(%eax)
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	8b 00                	mov    (%eax),%eax
  803209:	85 c0                	test   %eax,%eax
  80320b:	75 08                	jne    803215 <insert_sorted_allocList+0x244>
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	a3 44 60 80 00       	mov    %eax,0x806044
  803215:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80321a:	40                   	inc    %eax
  80321b:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  803220:	eb 39                	jmp    80325b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  803222:	a1 48 60 80 00       	mov    0x806048,%eax
  803227:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80322a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322e:	74 07                	je     803237 <insert_sorted_allocList+0x266>
  803230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803233:	8b 00                	mov    (%eax),%eax
  803235:	eb 05                	jmp    80323c <insert_sorted_allocList+0x26b>
  803237:	b8 00 00 00 00       	mov    $0x0,%eax
  80323c:	a3 48 60 80 00       	mov    %eax,0x806048
  803241:	a1 48 60 80 00       	mov    0x806048,%eax
  803246:	85 c0                	test   %eax,%eax
  803248:	0f 85 3f ff ff ff    	jne    80318d <insert_sorted_allocList+0x1bc>
  80324e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803252:	0f 85 35 ff ff ff    	jne    80318d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803258:	eb 01                	jmp    80325b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80325a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80325b:	90                   	nop
  80325c:	c9                   	leave  
  80325d:	c3                   	ret    

0080325e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80325e:	55                   	push   %ebp
  80325f:	89 e5                	mov    %esp,%ebp
  803261:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803264:	a1 38 61 80 00       	mov    0x806138,%eax
  803269:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80326c:	e9 85 01 00 00       	jmp    8033f6 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  803271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803274:	8b 40 0c             	mov    0xc(%eax),%eax
  803277:	3b 45 08             	cmp    0x8(%ebp),%eax
  80327a:	0f 82 6e 01 00 00    	jb     8033ee <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  803280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803283:	8b 40 0c             	mov    0xc(%eax),%eax
  803286:	3b 45 08             	cmp    0x8(%ebp),%eax
  803289:	0f 85 8a 00 00 00    	jne    803319 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80328f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803293:	75 17                	jne    8032ac <alloc_block_FF+0x4e>
  803295:	83 ec 04             	sub    $0x4,%esp
  803298:	68 64 51 80 00       	push   $0x805164
  80329d:	68 93 00 00 00       	push   $0x93
  8032a2:	68 bb 50 80 00       	push   $0x8050bb
  8032a7:	e8 fe df ff ff       	call   8012aa <_panic>
  8032ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	85 c0                	test   %eax,%eax
  8032b3:	74 10                	je     8032c5 <alloc_block_FF+0x67>
  8032b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b8:	8b 00                	mov    (%eax),%eax
  8032ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032bd:	8b 52 04             	mov    0x4(%edx),%edx
  8032c0:	89 50 04             	mov    %edx,0x4(%eax)
  8032c3:	eb 0b                	jmp    8032d0 <alloc_block_FF+0x72>
  8032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c8:	8b 40 04             	mov    0x4(%eax),%eax
  8032cb:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8032d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d3:	8b 40 04             	mov    0x4(%eax),%eax
  8032d6:	85 c0                	test   %eax,%eax
  8032d8:	74 0f                	je     8032e9 <alloc_block_FF+0x8b>
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 40 04             	mov    0x4(%eax),%eax
  8032e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e3:	8b 12                	mov    (%edx),%edx
  8032e5:	89 10                	mov    %edx,(%eax)
  8032e7:	eb 0a                	jmp    8032f3 <alloc_block_FF+0x95>
  8032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ec:	8b 00                	mov    (%eax),%eax
  8032ee:	a3 38 61 80 00       	mov    %eax,0x806138
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803306:	a1 44 61 80 00       	mov    0x806144,%eax
  80330b:	48                   	dec    %eax
  80330c:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  803311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803314:	e9 10 01 00 00       	jmp    803429 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  803319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331c:	8b 40 0c             	mov    0xc(%eax),%eax
  80331f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803322:	0f 86 c6 00 00 00    	jbe    8033ee <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803328:	a1 48 61 80 00       	mov    0x806148,%eax
  80332d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  803330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803333:	8b 50 08             	mov    0x8(%eax),%edx
  803336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803339:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80333c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333f:	8b 55 08             	mov    0x8(%ebp),%edx
  803342:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803345:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803349:	75 17                	jne    803362 <alloc_block_FF+0x104>
  80334b:	83 ec 04             	sub    $0x4,%esp
  80334e:	68 64 51 80 00       	push   $0x805164
  803353:	68 9b 00 00 00       	push   $0x9b
  803358:	68 bb 50 80 00       	push   $0x8050bb
  80335d:	e8 48 df ff ff       	call   8012aa <_panic>
  803362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	85 c0                	test   %eax,%eax
  803369:	74 10                	je     80337b <alloc_block_FF+0x11d>
  80336b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336e:	8b 00                	mov    (%eax),%eax
  803370:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803373:	8b 52 04             	mov    0x4(%edx),%edx
  803376:	89 50 04             	mov    %edx,0x4(%eax)
  803379:	eb 0b                	jmp    803386 <alloc_block_FF+0x128>
  80337b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337e:	8b 40 04             	mov    0x4(%eax),%eax
  803381:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803389:	8b 40 04             	mov    0x4(%eax),%eax
  80338c:	85 c0                	test   %eax,%eax
  80338e:	74 0f                	je     80339f <alloc_block_FF+0x141>
  803390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803393:	8b 40 04             	mov    0x4(%eax),%eax
  803396:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803399:	8b 12                	mov    (%edx),%edx
  80339b:	89 10                	mov    %edx,(%eax)
  80339d:	eb 0a                	jmp    8033a9 <alloc_block_FF+0x14b>
  80339f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	a3 48 61 80 00       	mov    %eax,0x806148
  8033a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033bc:	a1 54 61 80 00       	mov    0x806154,%eax
  8033c1:	48                   	dec    %eax
  8033c2:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  8033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ca:	8b 50 08             	mov    0x8(%eax),%edx
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	01 c2                	add    %eax,%edx
  8033d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d5:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033db:	8b 40 0c             	mov    0xc(%eax),%eax
  8033de:	2b 45 08             	sub    0x8(%ebp),%eax
  8033e1:	89 c2                	mov    %eax,%edx
  8033e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e6:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8033e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ec:	eb 3b                	jmp    803429 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8033ee:	a1 40 61 80 00       	mov    0x806140,%eax
  8033f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033fa:	74 07                	je     803403 <alloc_block_FF+0x1a5>
  8033fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ff:	8b 00                	mov    (%eax),%eax
  803401:	eb 05                	jmp    803408 <alloc_block_FF+0x1aa>
  803403:	b8 00 00 00 00       	mov    $0x0,%eax
  803408:	a3 40 61 80 00       	mov    %eax,0x806140
  80340d:	a1 40 61 80 00       	mov    0x806140,%eax
  803412:	85 c0                	test   %eax,%eax
  803414:	0f 85 57 fe ff ff    	jne    803271 <alloc_block_FF+0x13>
  80341a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341e:	0f 85 4d fe ff ff    	jne    803271 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  803424:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803429:	c9                   	leave  
  80342a:	c3                   	ret    

0080342b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80342b:	55                   	push   %ebp
  80342c:	89 e5                	mov    %esp,%ebp
  80342e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  803431:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803438:	a1 38 61 80 00       	mov    0x806138,%eax
  80343d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803440:	e9 df 00 00 00       	jmp    803524 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	8b 40 0c             	mov    0xc(%eax),%eax
  80344b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80344e:	0f 82 c8 00 00 00    	jb     80351c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803457:	8b 40 0c             	mov    0xc(%eax),%eax
  80345a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80345d:	0f 85 8a 00 00 00    	jne    8034ed <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803467:	75 17                	jne    803480 <alloc_block_BF+0x55>
  803469:	83 ec 04             	sub    $0x4,%esp
  80346c:	68 64 51 80 00       	push   $0x805164
  803471:	68 b7 00 00 00       	push   $0xb7
  803476:	68 bb 50 80 00       	push   $0x8050bb
  80347b:	e8 2a de ff ff       	call   8012aa <_panic>
  803480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803483:	8b 00                	mov    (%eax),%eax
  803485:	85 c0                	test   %eax,%eax
  803487:	74 10                	je     803499 <alloc_block_BF+0x6e>
  803489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803491:	8b 52 04             	mov    0x4(%edx),%edx
  803494:	89 50 04             	mov    %edx,0x4(%eax)
  803497:	eb 0b                	jmp    8034a4 <alloc_block_BF+0x79>
  803499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349c:	8b 40 04             	mov    0x4(%eax),%eax
  80349f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8034a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a7:	8b 40 04             	mov    0x4(%eax),%eax
  8034aa:	85 c0                	test   %eax,%eax
  8034ac:	74 0f                	je     8034bd <alloc_block_BF+0x92>
  8034ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b1:	8b 40 04             	mov    0x4(%eax),%eax
  8034b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b7:	8b 12                	mov    (%edx),%edx
  8034b9:	89 10                	mov    %edx,(%eax)
  8034bb:	eb 0a                	jmp    8034c7 <alloc_block_BF+0x9c>
  8034bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c0:	8b 00                	mov    (%eax),%eax
  8034c2:	a3 38 61 80 00       	mov    %eax,0x806138
  8034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034da:	a1 44 61 80 00       	mov    0x806144,%eax
  8034df:	48                   	dec    %eax
  8034e0:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	e9 4d 01 00 00       	jmp    80363a <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8034ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034f6:	76 24                	jbe    80351c <alloc_block_BF+0xf1>
  8034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8034fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803501:	73 19                	jae    80351c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803503:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80350a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350d:	8b 40 0c             	mov    0xc(%eax),%eax
  803510:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803516:	8b 40 08             	mov    0x8(%eax),%eax
  803519:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80351c:	a1 40 61 80 00       	mov    0x806140,%eax
  803521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803528:	74 07                	je     803531 <alloc_block_BF+0x106>
  80352a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	eb 05                	jmp    803536 <alloc_block_BF+0x10b>
  803531:	b8 00 00 00 00       	mov    $0x0,%eax
  803536:	a3 40 61 80 00       	mov    %eax,0x806140
  80353b:	a1 40 61 80 00       	mov    0x806140,%eax
  803540:	85 c0                	test   %eax,%eax
  803542:	0f 85 fd fe ff ff    	jne    803445 <alloc_block_BF+0x1a>
  803548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354c:	0f 85 f3 fe ff ff    	jne    803445 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803552:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803556:	0f 84 d9 00 00 00    	je     803635 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80355c:	a1 48 61 80 00       	mov    0x806148,%eax
  803561:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803564:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803567:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80356a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80356d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803570:	8b 55 08             	mov    0x8(%ebp),%edx
  803573:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803576:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80357a:	75 17                	jne    803593 <alloc_block_BF+0x168>
  80357c:	83 ec 04             	sub    $0x4,%esp
  80357f:	68 64 51 80 00       	push   $0x805164
  803584:	68 c7 00 00 00       	push   $0xc7
  803589:	68 bb 50 80 00       	push   $0x8050bb
  80358e:	e8 17 dd ff ff       	call   8012aa <_panic>
  803593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803596:	8b 00                	mov    (%eax),%eax
  803598:	85 c0                	test   %eax,%eax
  80359a:	74 10                	je     8035ac <alloc_block_BF+0x181>
  80359c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359f:	8b 00                	mov    (%eax),%eax
  8035a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a4:	8b 52 04             	mov    0x4(%edx),%edx
  8035a7:	89 50 04             	mov    %edx,0x4(%eax)
  8035aa:	eb 0b                	jmp    8035b7 <alloc_block_BF+0x18c>
  8035ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035af:	8b 40 04             	mov    0x4(%eax),%eax
  8035b2:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8035b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ba:	8b 40 04             	mov    0x4(%eax),%eax
  8035bd:	85 c0                	test   %eax,%eax
  8035bf:	74 0f                	je     8035d0 <alloc_block_BF+0x1a5>
  8035c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c4:	8b 40 04             	mov    0x4(%eax),%eax
  8035c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035ca:	8b 12                	mov    (%edx),%edx
  8035cc:	89 10                	mov    %edx,(%eax)
  8035ce:	eb 0a                	jmp    8035da <alloc_block_BF+0x1af>
  8035d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d3:	8b 00                	mov    (%eax),%eax
  8035d5:	a3 48 61 80 00       	mov    %eax,0x806148
  8035da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ed:	a1 54 61 80 00       	mov    0x806154,%eax
  8035f2:	48                   	dec    %eax
  8035f3:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8035f8:	83 ec 08             	sub    $0x8,%esp
  8035fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8035fe:	68 38 61 80 00       	push   $0x806138
  803603:	e8 71 f9 ff ff       	call   802f79 <find_block>
  803608:	83 c4 10             	add    $0x10,%esp
  80360b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80360e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803611:	8b 50 08             	mov    0x8(%eax),%edx
  803614:	8b 45 08             	mov    0x8(%ebp),%eax
  803617:	01 c2                	add    %eax,%edx
  803619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80361c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80361f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803622:	8b 40 0c             	mov    0xc(%eax),%eax
  803625:	2b 45 08             	sub    0x8(%ebp),%eax
  803628:	89 c2                	mov    %eax,%edx
  80362a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80362d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803633:	eb 05                	jmp    80363a <alloc_block_BF+0x20f>
	}
	return NULL;
  803635:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80363a:	c9                   	leave  
  80363b:	c3                   	ret    

0080363c <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80363c:	55                   	push   %ebp
  80363d:	89 e5                	mov    %esp,%ebp
  80363f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803642:	a1 28 60 80 00       	mov    0x806028,%eax
  803647:	85 c0                	test   %eax,%eax
  803649:	0f 85 de 01 00 00    	jne    80382d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80364f:	a1 38 61 80 00       	mov    0x806138,%eax
  803654:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803657:	e9 9e 01 00 00       	jmp    8037fa <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80365c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365f:	8b 40 0c             	mov    0xc(%eax),%eax
  803662:	3b 45 08             	cmp    0x8(%ebp),%eax
  803665:	0f 82 87 01 00 00    	jb     8037f2 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80366b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366e:	8b 40 0c             	mov    0xc(%eax),%eax
  803671:	3b 45 08             	cmp    0x8(%ebp),%eax
  803674:	0f 85 95 00 00 00    	jne    80370f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80367a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367e:	75 17                	jne    803697 <alloc_block_NF+0x5b>
  803680:	83 ec 04             	sub    $0x4,%esp
  803683:	68 64 51 80 00       	push   $0x805164
  803688:	68 e0 00 00 00       	push   $0xe0
  80368d:	68 bb 50 80 00       	push   $0x8050bb
  803692:	e8 13 dc ff ff       	call   8012aa <_panic>
  803697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	85 c0                	test   %eax,%eax
  80369e:	74 10                	je     8036b0 <alloc_block_NF+0x74>
  8036a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a3:	8b 00                	mov    (%eax),%eax
  8036a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036a8:	8b 52 04             	mov    0x4(%edx),%edx
  8036ab:	89 50 04             	mov    %edx,0x4(%eax)
  8036ae:	eb 0b                	jmp    8036bb <alloc_block_NF+0x7f>
  8036b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b3:	8b 40 04             	mov    0x4(%eax),%eax
  8036b6:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8036bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036be:	8b 40 04             	mov    0x4(%eax),%eax
  8036c1:	85 c0                	test   %eax,%eax
  8036c3:	74 0f                	je     8036d4 <alloc_block_NF+0x98>
  8036c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c8:	8b 40 04             	mov    0x4(%eax),%eax
  8036cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ce:	8b 12                	mov    (%edx),%edx
  8036d0:	89 10                	mov    %edx,(%eax)
  8036d2:	eb 0a                	jmp    8036de <alloc_block_NF+0xa2>
  8036d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d7:	8b 00                	mov    (%eax),%eax
  8036d9:	a3 38 61 80 00       	mov    %eax,0x806138
  8036de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f1:	a1 44 61 80 00       	mov    0x806144,%eax
  8036f6:	48                   	dec    %eax
  8036f7:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  8036fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ff:	8b 40 08             	mov    0x8(%eax),%eax
  803702:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  803707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370a:	e9 f8 04 00 00       	jmp    803c07 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80370f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803712:	8b 40 0c             	mov    0xc(%eax),%eax
  803715:	3b 45 08             	cmp    0x8(%ebp),%eax
  803718:	0f 86 d4 00 00 00    	jbe    8037f2 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80371e:	a1 48 61 80 00       	mov    0x806148,%eax
  803723:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803729:	8b 50 08             	mov    0x8(%eax),%edx
  80372c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803735:	8b 55 08             	mov    0x8(%ebp),%edx
  803738:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80373b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80373f:	75 17                	jne    803758 <alloc_block_NF+0x11c>
  803741:	83 ec 04             	sub    $0x4,%esp
  803744:	68 64 51 80 00       	push   $0x805164
  803749:	68 e9 00 00 00       	push   $0xe9
  80374e:	68 bb 50 80 00       	push   $0x8050bb
  803753:	e8 52 db ff ff       	call   8012aa <_panic>
  803758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375b:	8b 00                	mov    (%eax),%eax
  80375d:	85 c0                	test   %eax,%eax
  80375f:	74 10                	je     803771 <alloc_block_NF+0x135>
  803761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803764:	8b 00                	mov    (%eax),%eax
  803766:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803769:	8b 52 04             	mov    0x4(%edx),%edx
  80376c:	89 50 04             	mov    %edx,0x4(%eax)
  80376f:	eb 0b                	jmp    80377c <alloc_block_NF+0x140>
  803771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803774:	8b 40 04             	mov    0x4(%eax),%eax
  803777:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80377c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377f:	8b 40 04             	mov    0x4(%eax),%eax
  803782:	85 c0                	test   %eax,%eax
  803784:	74 0f                	je     803795 <alloc_block_NF+0x159>
  803786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803789:	8b 40 04             	mov    0x4(%eax),%eax
  80378c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80378f:	8b 12                	mov    (%edx),%edx
  803791:	89 10                	mov    %edx,(%eax)
  803793:	eb 0a                	jmp    80379f <alloc_block_NF+0x163>
  803795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803798:	8b 00                	mov    (%eax),%eax
  80379a:	a3 48 61 80 00       	mov    %eax,0x806148
  80379f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b2:	a1 54 61 80 00       	mov    0x806154,%eax
  8037b7:	48                   	dec    %eax
  8037b8:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  8037bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c0:	8b 40 08             	mov    0x8(%eax),%eax
  8037c3:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  8037c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cb:	8b 50 08             	mov    0x8(%eax),%edx
  8037ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d1:	01 c2                	add    %eax,%edx
  8037d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d6:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8037d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8037df:	2b 45 08             	sub    0x8(%ebp),%eax
  8037e2:	89 c2                	mov    %eax,%edx
  8037e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e7:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8037ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ed:	e9 15 04 00 00       	jmp    803c07 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8037f2:	a1 40 61 80 00       	mov    0x806140,%eax
  8037f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037fe:	74 07                	je     803807 <alloc_block_NF+0x1cb>
  803800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803803:	8b 00                	mov    (%eax),%eax
  803805:	eb 05                	jmp    80380c <alloc_block_NF+0x1d0>
  803807:	b8 00 00 00 00       	mov    $0x0,%eax
  80380c:	a3 40 61 80 00       	mov    %eax,0x806140
  803811:	a1 40 61 80 00       	mov    0x806140,%eax
  803816:	85 c0                	test   %eax,%eax
  803818:	0f 85 3e fe ff ff    	jne    80365c <alloc_block_NF+0x20>
  80381e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803822:	0f 85 34 fe ff ff    	jne    80365c <alloc_block_NF+0x20>
  803828:	e9 d5 03 00 00       	jmp    803c02 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80382d:	a1 38 61 80 00       	mov    0x806138,%eax
  803832:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803835:	e9 b1 01 00 00       	jmp    8039eb <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80383a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383d:	8b 50 08             	mov    0x8(%eax),%edx
  803840:	a1 28 60 80 00       	mov    0x806028,%eax
  803845:	39 c2                	cmp    %eax,%edx
  803847:	0f 82 96 01 00 00    	jb     8039e3 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80384d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803850:	8b 40 0c             	mov    0xc(%eax),%eax
  803853:	3b 45 08             	cmp    0x8(%ebp),%eax
  803856:	0f 82 87 01 00 00    	jb     8039e3 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80385c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385f:	8b 40 0c             	mov    0xc(%eax),%eax
  803862:	3b 45 08             	cmp    0x8(%ebp),%eax
  803865:	0f 85 95 00 00 00    	jne    803900 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80386b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80386f:	75 17                	jne    803888 <alloc_block_NF+0x24c>
  803871:	83 ec 04             	sub    $0x4,%esp
  803874:	68 64 51 80 00       	push   $0x805164
  803879:	68 fc 00 00 00       	push   $0xfc
  80387e:	68 bb 50 80 00       	push   $0x8050bb
  803883:	e8 22 da ff ff       	call   8012aa <_panic>
  803888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388b:	8b 00                	mov    (%eax),%eax
  80388d:	85 c0                	test   %eax,%eax
  80388f:	74 10                	je     8038a1 <alloc_block_NF+0x265>
  803891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803894:	8b 00                	mov    (%eax),%eax
  803896:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803899:	8b 52 04             	mov    0x4(%edx),%edx
  80389c:	89 50 04             	mov    %edx,0x4(%eax)
  80389f:	eb 0b                	jmp    8038ac <alloc_block_NF+0x270>
  8038a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a4:	8b 40 04             	mov    0x4(%eax),%eax
  8038a7:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8038ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038af:	8b 40 04             	mov    0x4(%eax),%eax
  8038b2:	85 c0                	test   %eax,%eax
  8038b4:	74 0f                	je     8038c5 <alloc_block_NF+0x289>
  8038b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b9:	8b 40 04             	mov    0x4(%eax),%eax
  8038bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038bf:	8b 12                	mov    (%edx),%edx
  8038c1:	89 10                	mov    %edx,(%eax)
  8038c3:	eb 0a                	jmp    8038cf <alloc_block_NF+0x293>
  8038c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c8:	8b 00                	mov    (%eax),%eax
  8038ca:	a3 38 61 80 00       	mov    %eax,0x806138
  8038cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e2:	a1 44 61 80 00       	mov    0x806144,%eax
  8038e7:	48                   	dec    %eax
  8038e8:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  8038ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f0:	8b 40 08             	mov    0x8(%eax),%eax
  8038f3:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  8038f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fb:	e9 07 03 00 00       	jmp    803c07 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803903:	8b 40 0c             	mov    0xc(%eax),%eax
  803906:	3b 45 08             	cmp    0x8(%ebp),%eax
  803909:	0f 86 d4 00 00 00    	jbe    8039e3 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80390f:	a1 48 61 80 00       	mov    0x806148,%eax
  803914:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391a:	8b 50 08             	mov    0x8(%eax),%edx
  80391d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803920:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803923:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803926:	8b 55 08             	mov    0x8(%ebp),%edx
  803929:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80392c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803930:	75 17                	jne    803949 <alloc_block_NF+0x30d>
  803932:	83 ec 04             	sub    $0x4,%esp
  803935:	68 64 51 80 00       	push   $0x805164
  80393a:	68 04 01 00 00       	push   $0x104
  80393f:	68 bb 50 80 00       	push   $0x8050bb
  803944:	e8 61 d9 ff ff       	call   8012aa <_panic>
  803949:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	85 c0                	test   %eax,%eax
  803950:	74 10                	je     803962 <alloc_block_NF+0x326>
  803952:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803955:	8b 00                	mov    (%eax),%eax
  803957:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80395a:	8b 52 04             	mov    0x4(%edx),%edx
  80395d:	89 50 04             	mov    %edx,0x4(%eax)
  803960:	eb 0b                	jmp    80396d <alloc_block_NF+0x331>
  803962:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803965:	8b 40 04             	mov    0x4(%eax),%eax
  803968:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80396d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803970:	8b 40 04             	mov    0x4(%eax),%eax
  803973:	85 c0                	test   %eax,%eax
  803975:	74 0f                	je     803986 <alloc_block_NF+0x34a>
  803977:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397a:	8b 40 04             	mov    0x4(%eax),%eax
  80397d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803980:	8b 12                	mov    (%edx),%edx
  803982:	89 10                	mov    %edx,(%eax)
  803984:	eb 0a                	jmp    803990 <alloc_block_NF+0x354>
  803986:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803989:	8b 00                	mov    (%eax),%eax
  80398b:	a3 48 61 80 00       	mov    %eax,0x806148
  803990:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803993:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803999:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a3:	a1 54 61 80 00       	mov    0x806154,%eax
  8039a8:	48                   	dec    %eax
  8039a9:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  8039ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b1:	8b 40 08             	mov    0x8(%eax),%eax
  8039b4:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  8039b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bc:	8b 50 08             	mov    0x8(%eax),%edx
  8039bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c2:	01 c2                	add    %eax,%edx
  8039c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8039ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d0:	2b 45 08             	sub    0x8(%ebp),%eax
  8039d3:	89 c2                	mov    %eax,%edx
  8039d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8039db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039de:	e9 24 02 00 00       	jmp    803c07 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8039e3:	a1 40 61 80 00       	mov    0x806140,%eax
  8039e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ef:	74 07                	je     8039f8 <alloc_block_NF+0x3bc>
  8039f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f4:	8b 00                	mov    (%eax),%eax
  8039f6:	eb 05                	jmp    8039fd <alloc_block_NF+0x3c1>
  8039f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fd:	a3 40 61 80 00       	mov    %eax,0x806140
  803a02:	a1 40 61 80 00       	mov    0x806140,%eax
  803a07:	85 c0                	test   %eax,%eax
  803a09:	0f 85 2b fe ff ff    	jne    80383a <alloc_block_NF+0x1fe>
  803a0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a13:	0f 85 21 fe ff ff    	jne    80383a <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803a19:	a1 38 61 80 00       	mov    0x806138,%eax
  803a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a21:	e9 ae 01 00 00       	jmp    803bd4 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a29:	8b 50 08             	mov    0x8(%eax),%edx
  803a2c:	a1 28 60 80 00       	mov    0x806028,%eax
  803a31:	39 c2                	cmp    %eax,%edx
  803a33:	0f 83 93 01 00 00    	jae    803bcc <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  803a3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a42:	0f 82 84 01 00 00    	jb     803bcc <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4b:	8b 40 0c             	mov    0xc(%eax),%eax
  803a4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a51:	0f 85 95 00 00 00    	jne    803aec <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a5b:	75 17                	jne    803a74 <alloc_block_NF+0x438>
  803a5d:	83 ec 04             	sub    $0x4,%esp
  803a60:	68 64 51 80 00       	push   $0x805164
  803a65:	68 14 01 00 00       	push   $0x114
  803a6a:	68 bb 50 80 00       	push   $0x8050bb
  803a6f:	e8 36 d8 ff ff       	call   8012aa <_panic>
  803a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a77:	8b 00                	mov    (%eax),%eax
  803a79:	85 c0                	test   %eax,%eax
  803a7b:	74 10                	je     803a8d <alloc_block_NF+0x451>
  803a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a80:	8b 00                	mov    (%eax),%eax
  803a82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a85:	8b 52 04             	mov    0x4(%edx),%edx
  803a88:	89 50 04             	mov    %edx,0x4(%eax)
  803a8b:	eb 0b                	jmp    803a98 <alloc_block_NF+0x45c>
  803a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a90:	8b 40 04             	mov    0x4(%eax),%eax
  803a93:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9b:	8b 40 04             	mov    0x4(%eax),%eax
  803a9e:	85 c0                	test   %eax,%eax
  803aa0:	74 0f                	je     803ab1 <alloc_block_NF+0x475>
  803aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa5:	8b 40 04             	mov    0x4(%eax),%eax
  803aa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aab:	8b 12                	mov    (%edx),%edx
  803aad:	89 10                	mov    %edx,(%eax)
  803aaf:	eb 0a                	jmp    803abb <alloc_block_NF+0x47f>
  803ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab4:	8b 00                	mov    (%eax),%eax
  803ab6:	a3 38 61 80 00       	mov    %eax,0x806138
  803abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ace:	a1 44 61 80 00       	mov    0x806144,%eax
  803ad3:	48                   	dec    %eax
  803ad4:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adc:	8b 40 08             	mov    0x8(%eax),%eax
  803adf:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae7:	e9 1b 01 00 00       	jmp    803c07 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aef:	8b 40 0c             	mov    0xc(%eax),%eax
  803af2:	3b 45 08             	cmp    0x8(%ebp),%eax
  803af5:	0f 86 d1 00 00 00    	jbe    803bcc <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803afb:	a1 48 61 80 00       	mov    0x806148,%eax
  803b00:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b06:	8b 50 08             	mov    0x8(%eax),%edx
  803b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b0c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b12:	8b 55 08             	mov    0x8(%ebp),%edx
  803b15:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803b18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b1c:	75 17                	jne    803b35 <alloc_block_NF+0x4f9>
  803b1e:	83 ec 04             	sub    $0x4,%esp
  803b21:	68 64 51 80 00       	push   $0x805164
  803b26:	68 1c 01 00 00       	push   $0x11c
  803b2b:	68 bb 50 80 00       	push   $0x8050bb
  803b30:	e8 75 d7 ff ff       	call   8012aa <_panic>
  803b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b38:	8b 00                	mov    (%eax),%eax
  803b3a:	85 c0                	test   %eax,%eax
  803b3c:	74 10                	je     803b4e <alloc_block_NF+0x512>
  803b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b41:	8b 00                	mov    (%eax),%eax
  803b43:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b46:	8b 52 04             	mov    0x4(%edx),%edx
  803b49:	89 50 04             	mov    %edx,0x4(%eax)
  803b4c:	eb 0b                	jmp    803b59 <alloc_block_NF+0x51d>
  803b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b51:	8b 40 04             	mov    0x4(%eax),%eax
  803b54:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b5c:	8b 40 04             	mov    0x4(%eax),%eax
  803b5f:	85 c0                	test   %eax,%eax
  803b61:	74 0f                	je     803b72 <alloc_block_NF+0x536>
  803b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b66:	8b 40 04             	mov    0x4(%eax),%eax
  803b69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b6c:	8b 12                	mov    (%edx),%edx
  803b6e:	89 10                	mov    %edx,(%eax)
  803b70:	eb 0a                	jmp    803b7c <alloc_block_NF+0x540>
  803b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b75:	8b 00                	mov    (%eax),%eax
  803b77:	a3 48 61 80 00       	mov    %eax,0x806148
  803b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b8f:	a1 54 61 80 00       	mov    0x806154,%eax
  803b94:	48                   	dec    %eax
  803b95:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b9d:	8b 40 08             	mov    0x8(%eax),%eax
  803ba0:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba8:	8b 50 08             	mov    0x8(%eax),%edx
  803bab:	8b 45 08             	mov    0x8(%ebp),%eax
  803bae:	01 c2                	add    %eax,%edx
  803bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb9:	8b 40 0c             	mov    0xc(%eax),%eax
  803bbc:	2b 45 08             	sub    0x8(%ebp),%eax
  803bbf:	89 c2                	mov    %eax,%edx
  803bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bca:	eb 3b                	jmp    803c07 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803bcc:	a1 40 61 80 00       	mov    0x806140,%eax
  803bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bd8:	74 07                	je     803be1 <alloc_block_NF+0x5a5>
  803bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdd:	8b 00                	mov    (%eax),%eax
  803bdf:	eb 05                	jmp    803be6 <alloc_block_NF+0x5aa>
  803be1:	b8 00 00 00 00       	mov    $0x0,%eax
  803be6:	a3 40 61 80 00       	mov    %eax,0x806140
  803beb:	a1 40 61 80 00       	mov    0x806140,%eax
  803bf0:	85 c0                	test   %eax,%eax
  803bf2:	0f 85 2e fe ff ff    	jne    803a26 <alloc_block_NF+0x3ea>
  803bf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bfc:	0f 85 24 fe ff ff    	jne    803a26 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803c02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c07:	c9                   	leave  
  803c08:	c3                   	ret    

00803c09 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803c09:	55                   	push   %ebp
  803c0a:	89 e5                	mov    %esp,%ebp
  803c0c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803c0f:	a1 38 61 80 00       	mov    0x806138,%eax
  803c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803c17:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803c1c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803c1f:	a1 38 61 80 00       	mov    0x806138,%eax
  803c24:	85 c0                	test   %eax,%eax
  803c26:	74 14                	je     803c3c <insert_sorted_with_merge_freeList+0x33>
  803c28:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2b:	8b 50 08             	mov    0x8(%eax),%edx
  803c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c31:	8b 40 08             	mov    0x8(%eax),%eax
  803c34:	39 c2                	cmp    %eax,%edx
  803c36:	0f 87 9b 01 00 00    	ja     803dd7 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c40:	75 17                	jne    803c59 <insert_sorted_with_merge_freeList+0x50>
  803c42:	83 ec 04             	sub    $0x4,%esp
  803c45:	68 98 50 80 00       	push   $0x805098
  803c4a:	68 38 01 00 00       	push   $0x138
  803c4f:	68 bb 50 80 00       	push   $0x8050bb
  803c54:	e8 51 d6 ff ff       	call   8012aa <_panic>
  803c59:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c62:	89 10                	mov    %edx,(%eax)
  803c64:	8b 45 08             	mov    0x8(%ebp),%eax
  803c67:	8b 00                	mov    (%eax),%eax
  803c69:	85 c0                	test   %eax,%eax
  803c6b:	74 0d                	je     803c7a <insert_sorted_with_merge_freeList+0x71>
  803c6d:	a1 38 61 80 00       	mov    0x806138,%eax
  803c72:	8b 55 08             	mov    0x8(%ebp),%edx
  803c75:	89 50 04             	mov    %edx,0x4(%eax)
  803c78:	eb 08                	jmp    803c82 <insert_sorted_with_merge_freeList+0x79>
  803c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7d:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803c82:	8b 45 08             	mov    0x8(%ebp),%eax
  803c85:	a3 38 61 80 00       	mov    %eax,0x806138
  803c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c94:	a1 44 61 80 00       	mov    0x806144,%eax
  803c99:	40                   	inc    %eax
  803c9a:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803c9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ca3:	0f 84 a8 06 00 00    	je     804351 <insert_sorted_with_merge_freeList+0x748>
  803ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  803cac:	8b 50 08             	mov    0x8(%eax),%edx
  803caf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb2:	8b 40 0c             	mov    0xc(%eax),%eax
  803cb5:	01 c2                	add    %eax,%edx
  803cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cba:	8b 40 08             	mov    0x8(%eax),%eax
  803cbd:	39 c2                	cmp    %eax,%edx
  803cbf:	0f 85 8c 06 00 00    	jne    804351 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc8:	8b 50 0c             	mov    0xc(%eax),%edx
  803ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cce:	8b 40 0c             	mov    0xc(%eax),%eax
  803cd1:	01 c2                	add    %eax,%edx
  803cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd6:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803cd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cdd:	75 17                	jne    803cf6 <insert_sorted_with_merge_freeList+0xed>
  803cdf:	83 ec 04             	sub    $0x4,%esp
  803ce2:	68 64 51 80 00       	push   $0x805164
  803ce7:	68 3c 01 00 00       	push   $0x13c
  803cec:	68 bb 50 80 00       	push   $0x8050bb
  803cf1:	e8 b4 d5 ff ff       	call   8012aa <_panic>
  803cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cf9:	8b 00                	mov    (%eax),%eax
  803cfb:	85 c0                	test   %eax,%eax
  803cfd:	74 10                	je     803d0f <insert_sorted_with_merge_freeList+0x106>
  803cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d02:	8b 00                	mov    (%eax),%eax
  803d04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d07:	8b 52 04             	mov    0x4(%edx),%edx
  803d0a:	89 50 04             	mov    %edx,0x4(%eax)
  803d0d:	eb 0b                	jmp    803d1a <insert_sorted_with_merge_freeList+0x111>
  803d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d12:	8b 40 04             	mov    0x4(%eax),%eax
  803d15:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d1d:	8b 40 04             	mov    0x4(%eax),%eax
  803d20:	85 c0                	test   %eax,%eax
  803d22:	74 0f                	je     803d33 <insert_sorted_with_merge_freeList+0x12a>
  803d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d27:	8b 40 04             	mov    0x4(%eax),%eax
  803d2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d2d:	8b 12                	mov    (%edx),%edx
  803d2f:	89 10                	mov    %edx,(%eax)
  803d31:	eb 0a                	jmp    803d3d <insert_sorted_with_merge_freeList+0x134>
  803d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d36:	8b 00                	mov    (%eax),%eax
  803d38:	a3 38 61 80 00       	mov    %eax,0x806138
  803d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d50:	a1 44 61 80 00       	mov    0x806144,%eax
  803d55:	48                   	dec    %eax
  803d56:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  803d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d5e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803d6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d73:	75 17                	jne    803d8c <insert_sorted_with_merge_freeList+0x183>
  803d75:	83 ec 04             	sub    $0x4,%esp
  803d78:	68 98 50 80 00       	push   $0x805098
  803d7d:	68 3f 01 00 00       	push   $0x13f
  803d82:	68 bb 50 80 00       	push   $0x8050bb
  803d87:	e8 1e d5 ff ff       	call   8012aa <_panic>
  803d8c:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d95:	89 10                	mov    %edx,(%eax)
  803d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d9a:	8b 00                	mov    (%eax),%eax
  803d9c:	85 c0                	test   %eax,%eax
  803d9e:	74 0d                	je     803dad <insert_sorted_with_merge_freeList+0x1a4>
  803da0:	a1 48 61 80 00       	mov    0x806148,%eax
  803da5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803da8:	89 50 04             	mov    %edx,0x4(%eax)
  803dab:	eb 08                	jmp    803db5 <insert_sorted_with_merge_freeList+0x1ac>
  803dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db0:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db8:	a3 48 61 80 00       	mov    %eax,0x806148
  803dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dc7:	a1 54 61 80 00       	mov    0x806154,%eax
  803dcc:	40                   	inc    %eax
  803dcd:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803dd2:	e9 7a 05 00 00       	jmp    804351 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  803dda:	8b 50 08             	mov    0x8(%eax),%edx
  803ddd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803de0:	8b 40 08             	mov    0x8(%eax),%eax
  803de3:	39 c2                	cmp    %eax,%edx
  803de5:	0f 82 14 01 00 00    	jb     803eff <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803deb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dee:	8b 50 08             	mov    0x8(%eax),%edx
  803df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803df4:	8b 40 0c             	mov    0xc(%eax),%eax
  803df7:	01 c2                	add    %eax,%edx
  803df9:	8b 45 08             	mov    0x8(%ebp),%eax
  803dfc:	8b 40 08             	mov    0x8(%eax),%eax
  803dff:	39 c2                	cmp    %eax,%edx
  803e01:	0f 85 90 00 00 00    	jne    803e97 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803e07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e0a:	8b 50 0c             	mov    0xc(%eax),%edx
  803e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e10:	8b 40 0c             	mov    0xc(%eax),%eax
  803e13:	01 c2                	add    %eax,%edx
  803e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e18:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e1e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803e25:	8b 45 08             	mov    0x8(%ebp),%eax
  803e28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803e2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e33:	75 17                	jne    803e4c <insert_sorted_with_merge_freeList+0x243>
  803e35:	83 ec 04             	sub    $0x4,%esp
  803e38:	68 98 50 80 00       	push   $0x805098
  803e3d:	68 49 01 00 00       	push   $0x149
  803e42:	68 bb 50 80 00       	push   $0x8050bb
  803e47:	e8 5e d4 ff ff       	call   8012aa <_panic>
  803e4c:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803e52:	8b 45 08             	mov    0x8(%ebp),%eax
  803e55:	89 10                	mov    %edx,(%eax)
  803e57:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5a:	8b 00                	mov    (%eax),%eax
  803e5c:	85 c0                	test   %eax,%eax
  803e5e:	74 0d                	je     803e6d <insert_sorted_with_merge_freeList+0x264>
  803e60:	a1 48 61 80 00       	mov    0x806148,%eax
  803e65:	8b 55 08             	mov    0x8(%ebp),%edx
  803e68:	89 50 04             	mov    %edx,0x4(%eax)
  803e6b:	eb 08                	jmp    803e75 <insert_sorted_with_merge_freeList+0x26c>
  803e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e70:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803e75:	8b 45 08             	mov    0x8(%ebp),%eax
  803e78:	a3 48 61 80 00       	mov    %eax,0x806148
  803e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e87:	a1 54 61 80 00       	mov    0x806154,%eax
  803e8c:	40                   	inc    %eax
  803e8d:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e92:	e9 bb 04 00 00       	jmp    804352 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803e97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e9b:	75 17                	jne    803eb4 <insert_sorted_with_merge_freeList+0x2ab>
  803e9d:	83 ec 04             	sub    $0x4,%esp
  803ea0:	68 0c 51 80 00       	push   $0x80510c
  803ea5:	68 4c 01 00 00       	push   $0x14c
  803eaa:	68 bb 50 80 00       	push   $0x8050bb
  803eaf:	e8 f6 d3 ff ff       	call   8012aa <_panic>
  803eb4:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803eba:	8b 45 08             	mov    0x8(%ebp),%eax
  803ebd:	89 50 04             	mov    %edx,0x4(%eax)
  803ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec3:	8b 40 04             	mov    0x4(%eax),%eax
  803ec6:	85 c0                	test   %eax,%eax
  803ec8:	74 0c                	je     803ed6 <insert_sorted_with_merge_freeList+0x2cd>
  803eca:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  803ed2:	89 10                	mov    %edx,(%eax)
  803ed4:	eb 08                	jmp    803ede <insert_sorted_with_merge_freeList+0x2d5>
  803ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed9:	a3 38 61 80 00       	mov    %eax,0x806138
  803ede:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee1:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eef:	a1 44 61 80 00       	mov    0x806144,%eax
  803ef4:	40                   	inc    %eax
  803ef5:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803efa:	e9 53 04 00 00       	jmp    804352 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803eff:	a1 38 61 80 00       	mov    0x806138,%eax
  803f04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f07:	e9 15 04 00 00       	jmp    804321 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f0f:	8b 00                	mov    (%eax),%eax
  803f11:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803f14:	8b 45 08             	mov    0x8(%ebp),%eax
  803f17:	8b 50 08             	mov    0x8(%eax),%edx
  803f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f1d:	8b 40 08             	mov    0x8(%eax),%eax
  803f20:	39 c2                	cmp    %eax,%edx
  803f22:	0f 86 f1 03 00 00    	jbe    804319 <insert_sorted_with_merge_freeList+0x710>
  803f28:	8b 45 08             	mov    0x8(%ebp),%eax
  803f2b:	8b 50 08             	mov    0x8(%eax),%edx
  803f2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f31:	8b 40 08             	mov    0x8(%eax),%eax
  803f34:	39 c2                	cmp    %eax,%edx
  803f36:	0f 83 dd 03 00 00    	jae    804319 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f3f:	8b 50 08             	mov    0x8(%eax),%edx
  803f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f45:	8b 40 0c             	mov    0xc(%eax),%eax
  803f48:	01 c2                	add    %eax,%edx
  803f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4d:	8b 40 08             	mov    0x8(%eax),%eax
  803f50:	39 c2                	cmp    %eax,%edx
  803f52:	0f 85 b9 01 00 00    	jne    804111 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803f58:	8b 45 08             	mov    0x8(%ebp),%eax
  803f5b:	8b 50 08             	mov    0x8(%eax),%edx
  803f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803f61:	8b 40 0c             	mov    0xc(%eax),%eax
  803f64:	01 c2                	add    %eax,%edx
  803f66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f69:	8b 40 08             	mov    0x8(%eax),%eax
  803f6c:	39 c2                	cmp    %eax,%edx
  803f6e:	0f 85 0d 01 00 00    	jne    804081 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f77:	8b 50 0c             	mov    0xc(%eax),%edx
  803f7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f7d:	8b 40 0c             	mov    0xc(%eax),%eax
  803f80:	01 c2                	add    %eax,%edx
  803f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f85:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803f88:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803f8c:	75 17                	jne    803fa5 <insert_sorted_with_merge_freeList+0x39c>
  803f8e:	83 ec 04             	sub    $0x4,%esp
  803f91:	68 64 51 80 00       	push   $0x805164
  803f96:	68 5c 01 00 00       	push   $0x15c
  803f9b:	68 bb 50 80 00       	push   $0x8050bb
  803fa0:	e8 05 d3 ff ff       	call   8012aa <_panic>
  803fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fa8:	8b 00                	mov    (%eax),%eax
  803faa:	85 c0                	test   %eax,%eax
  803fac:	74 10                	je     803fbe <insert_sorted_with_merge_freeList+0x3b5>
  803fae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fb1:	8b 00                	mov    (%eax),%eax
  803fb3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fb6:	8b 52 04             	mov    0x4(%edx),%edx
  803fb9:	89 50 04             	mov    %edx,0x4(%eax)
  803fbc:	eb 0b                	jmp    803fc9 <insert_sorted_with_merge_freeList+0x3c0>
  803fbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fc1:	8b 40 04             	mov    0x4(%eax),%eax
  803fc4:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fcc:	8b 40 04             	mov    0x4(%eax),%eax
  803fcf:	85 c0                	test   %eax,%eax
  803fd1:	74 0f                	je     803fe2 <insert_sorted_with_merge_freeList+0x3d9>
  803fd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fd6:	8b 40 04             	mov    0x4(%eax),%eax
  803fd9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fdc:	8b 12                	mov    (%edx),%edx
  803fde:	89 10                	mov    %edx,(%eax)
  803fe0:	eb 0a                	jmp    803fec <insert_sorted_with_merge_freeList+0x3e3>
  803fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fe5:	8b 00                	mov    (%eax),%eax
  803fe7:	a3 38 61 80 00       	mov    %eax,0x806138
  803fec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ff8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fff:	a1 44 61 80 00       	mov    0x806144,%eax
  804004:	48                   	dec    %eax
  804005:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  80400a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80400d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  804014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804017:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80401e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804022:	75 17                	jne    80403b <insert_sorted_with_merge_freeList+0x432>
  804024:	83 ec 04             	sub    $0x4,%esp
  804027:	68 98 50 80 00       	push   $0x805098
  80402c:	68 5f 01 00 00       	push   $0x15f
  804031:	68 bb 50 80 00       	push   $0x8050bb
  804036:	e8 6f d2 ff ff       	call   8012aa <_panic>
  80403b:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804041:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804044:	89 10                	mov    %edx,(%eax)
  804046:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804049:	8b 00                	mov    (%eax),%eax
  80404b:	85 c0                	test   %eax,%eax
  80404d:	74 0d                	je     80405c <insert_sorted_with_merge_freeList+0x453>
  80404f:	a1 48 61 80 00       	mov    0x806148,%eax
  804054:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804057:	89 50 04             	mov    %edx,0x4(%eax)
  80405a:	eb 08                	jmp    804064 <insert_sorted_with_merge_freeList+0x45b>
  80405c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80405f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804064:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804067:	a3 48 61 80 00       	mov    %eax,0x806148
  80406c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80406f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804076:	a1 54 61 80 00       	mov    0x806154,%eax
  80407b:	40                   	inc    %eax
  80407c:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  804081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804084:	8b 50 0c             	mov    0xc(%eax),%edx
  804087:	8b 45 08             	mov    0x8(%ebp),%eax
  80408a:	8b 40 0c             	mov    0xc(%eax),%eax
  80408d:	01 c2                	add    %eax,%edx
  80408f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804092:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  804095:	8b 45 08             	mov    0x8(%ebp),%eax
  804098:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80409f:	8b 45 08             	mov    0x8(%ebp),%eax
  8040a2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8040a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040ad:	75 17                	jne    8040c6 <insert_sorted_with_merge_freeList+0x4bd>
  8040af:	83 ec 04             	sub    $0x4,%esp
  8040b2:	68 98 50 80 00       	push   $0x805098
  8040b7:	68 64 01 00 00       	push   $0x164
  8040bc:	68 bb 50 80 00       	push   $0x8050bb
  8040c1:	e8 e4 d1 ff ff       	call   8012aa <_panic>
  8040c6:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8040cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8040cf:	89 10                	mov    %edx,(%eax)
  8040d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d4:	8b 00                	mov    (%eax),%eax
  8040d6:	85 c0                	test   %eax,%eax
  8040d8:	74 0d                	je     8040e7 <insert_sorted_with_merge_freeList+0x4de>
  8040da:	a1 48 61 80 00       	mov    0x806148,%eax
  8040df:	8b 55 08             	mov    0x8(%ebp),%edx
  8040e2:	89 50 04             	mov    %edx,0x4(%eax)
  8040e5:	eb 08                	jmp    8040ef <insert_sorted_with_merge_freeList+0x4e6>
  8040e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ea:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8040ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f2:	a3 48 61 80 00       	mov    %eax,0x806148
  8040f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804101:	a1 54 61 80 00       	mov    0x806154,%eax
  804106:	40                   	inc    %eax
  804107:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  80410c:	e9 41 02 00 00       	jmp    804352 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804111:	8b 45 08             	mov    0x8(%ebp),%eax
  804114:	8b 50 08             	mov    0x8(%eax),%edx
  804117:	8b 45 08             	mov    0x8(%ebp),%eax
  80411a:	8b 40 0c             	mov    0xc(%eax),%eax
  80411d:	01 c2                	add    %eax,%edx
  80411f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804122:	8b 40 08             	mov    0x8(%eax),%eax
  804125:	39 c2                	cmp    %eax,%edx
  804127:	0f 85 7c 01 00 00    	jne    8042a9 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80412d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804131:	74 06                	je     804139 <insert_sorted_with_merge_freeList+0x530>
  804133:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804137:	75 17                	jne    804150 <insert_sorted_with_merge_freeList+0x547>
  804139:	83 ec 04             	sub    $0x4,%esp
  80413c:	68 d4 50 80 00       	push   $0x8050d4
  804141:	68 69 01 00 00       	push   $0x169
  804146:	68 bb 50 80 00       	push   $0x8050bb
  80414b:	e8 5a d1 ff ff       	call   8012aa <_panic>
  804150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804153:	8b 50 04             	mov    0x4(%eax),%edx
  804156:	8b 45 08             	mov    0x8(%ebp),%eax
  804159:	89 50 04             	mov    %edx,0x4(%eax)
  80415c:	8b 45 08             	mov    0x8(%ebp),%eax
  80415f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804162:	89 10                	mov    %edx,(%eax)
  804164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804167:	8b 40 04             	mov    0x4(%eax),%eax
  80416a:	85 c0                	test   %eax,%eax
  80416c:	74 0d                	je     80417b <insert_sorted_with_merge_freeList+0x572>
  80416e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804171:	8b 40 04             	mov    0x4(%eax),%eax
  804174:	8b 55 08             	mov    0x8(%ebp),%edx
  804177:	89 10                	mov    %edx,(%eax)
  804179:	eb 08                	jmp    804183 <insert_sorted_with_merge_freeList+0x57a>
  80417b:	8b 45 08             	mov    0x8(%ebp),%eax
  80417e:	a3 38 61 80 00       	mov    %eax,0x806138
  804183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804186:	8b 55 08             	mov    0x8(%ebp),%edx
  804189:	89 50 04             	mov    %edx,0x4(%eax)
  80418c:	a1 44 61 80 00       	mov    0x806144,%eax
  804191:	40                   	inc    %eax
  804192:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  804197:	8b 45 08             	mov    0x8(%ebp),%eax
  80419a:	8b 50 0c             	mov    0xc(%eax),%edx
  80419d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8041a3:	01 c2                	add    %eax,%edx
  8041a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8041a8:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8041ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8041af:	75 17                	jne    8041c8 <insert_sorted_with_merge_freeList+0x5bf>
  8041b1:	83 ec 04             	sub    $0x4,%esp
  8041b4:	68 64 51 80 00       	push   $0x805164
  8041b9:	68 6b 01 00 00       	push   $0x16b
  8041be:	68 bb 50 80 00       	push   $0x8050bb
  8041c3:	e8 e2 d0 ff ff       	call   8012aa <_panic>
  8041c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041cb:	8b 00                	mov    (%eax),%eax
  8041cd:	85 c0                	test   %eax,%eax
  8041cf:	74 10                	je     8041e1 <insert_sorted_with_merge_freeList+0x5d8>
  8041d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041d4:	8b 00                	mov    (%eax),%eax
  8041d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041d9:	8b 52 04             	mov    0x4(%edx),%edx
  8041dc:	89 50 04             	mov    %edx,0x4(%eax)
  8041df:	eb 0b                	jmp    8041ec <insert_sorted_with_merge_freeList+0x5e3>
  8041e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041e4:	8b 40 04             	mov    0x4(%eax),%eax
  8041e7:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8041ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041ef:	8b 40 04             	mov    0x4(%eax),%eax
  8041f2:	85 c0                	test   %eax,%eax
  8041f4:	74 0f                	je     804205 <insert_sorted_with_merge_freeList+0x5fc>
  8041f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041f9:	8b 40 04             	mov    0x4(%eax),%eax
  8041fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041ff:	8b 12                	mov    (%edx),%edx
  804201:	89 10                	mov    %edx,(%eax)
  804203:	eb 0a                	jmp    80420f <insert_sorted_with_merge_freeList+0x606>
  804205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804208:	8b 00                	mov    (%eax),%eax
  80420a:	a3 38 61 80 00       	mov    %eax,0x806138
  80420f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804212:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804218:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80421b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804222:	a1 44 61 80 00       	mov    0x806144,%eax
  804227:	48                   	dec    %eax
  804228:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  80422d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804230:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  804237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80423a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  804241:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804245:	75 17                	jne    80425e <insert_sorted_with_merge_freeList+0x655>
  804247:	83 ec 04             	sub    $0x4,%esp
  80424a:	68 98 50 80 00       	push   $0x805098
  80424f:	68 6e 01 00 00       	push   $0x16e
  804254:	68 bb 50 80 00       	push   $0x8050bb
  804259:	e8 4c d0 ff ff       	call   8012aa <_panic>
  80425e:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804267:	89 10                	mov    %edx,(%eax)
  804269:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80426c:	8b 00                	mov    (%eax),%eax
  80426e:	85 c0                	test   %eax,%eax
  804270:	74 0d                	je     80427f <insert_sorted_with_merge_freeList+0x676>
  804272:	a1 48 61 80 00       	mov    0x806148,%eax
  804277:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80427a:	89 50 04             	mov    %edx,0x4(%eax)
  80427d:	eb 08                	jmp    804287 <insert_sorted_with_merge_freeList+0x67e>
  80427f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804282:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80428a:	a3 48 61 80 00       	mov    %eax,0x806148
  80428f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804292:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804299:	a1 54 61 80 00       	mov    0x806154,%eax
  80429e:	40                   	inc    %eax
  80429f:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  8042a4:	e9 a9 00 00 00       	jmp    804352 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8042a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042ad:	74 06                	je     8042b5 <insert_sorted_with_merge_freeList+0x6ac>
  8042af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042b3:	75 17                	jne    8042cc <insert_sorted_with_merge_freeList+0x6c3>
  8042b5:	83 ec 04             	sub    $0x4,%esp
  8042b8:	68 30 51 80 00       	push   $0x805130
  8042bd:	68 73 01 00 00       	push   $0x173
  8042c2:	68 bb 50 80 00       	push   $0x8050bb
  8042c7:	e8 de cf ff ff       	call   8012aa <_panic>
  8042cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042cf:	8b 10                	mov    (%eax),%edx
  8042d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8042d4:	89 10                	mov    %edx,(%eax)
  8042d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8042d9:	8b 00                	mov    (%eax),%eax
  8042db:	85 c0                	test   %eax,%eax
  8042dd:	74 0b                	je     8042ea <insert_sorted_with_merge_freeList+0x6e1>
  8042df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042e2:	8b 00                	mov    (%eax),%eax
  8042e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8042e7:	89 50 04             	mov    %edx,0x4(%eax)
  8042ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8042f0:	89 10                	mov    %edx,(%eax)
  8042f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8042f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042f8:	89 50 04             	mov    %edx,0x4(%eax)
  8042fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8042fe:	8b 00                	mov    (%eax),%eax
  804300:	85 c0                	test   %eax,%eax
  804302:	75 08                	jne    80430c <insert_sorted_with_merge_freeList+0x703>
  804304:	8b 45 08             	mov    0x8(%ebp),%eax
  804307:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80430c:	a1 44 61 80 00       	mov    0x806144,%eax
  804311:	40                   	inc    %eax
  804312:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  804317:	eb 39                	jmp    804352 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  804319:	a1 40 61 80 00       	mov    0x806140,%eax
  80431e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804321:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804325:	74 07                	je     80432e <insert_sorted_with_merge_freeList+0x725>
  804327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80432a:	8b 00                	mov    (%eax),%eax
  80432c:	eb 05                	jmp    804333 <insert_sorted_with_merge_freeList+0x72a>
  80432e:	b8 00 00 00 00       	mov    $0x0,%eax
  804333:	a3 40 61 80 00       	mov    %eax,0x806140
  804338:	a1 40 61 80 00       	mov    0x806140,%eax
  80433d:	85 c0                	test   %eax,%eax
  80433f:	0f 85 c7 fb ff ff    	jne    803f0c <insert_sorted_with_merge_freeList+0x303>
  804345:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804349:	0f 85 bd fb ff ff    	jne    803f0c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80434f:	eb 01                	jmp    804352 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  804351:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804352:	90                   	nop
  804353:	c9                   	leave  
  804354:	c3                   	ret    
  804355:	66 90                	xchg   %ax,%ax
  804357:	90                   	nop

00804358 <__udivdi3>:
  804358:	55                   	push   %ebp
  804359:	57                   	push   %edi
  80435a:	56                   	push   %esi
  80435b:	53                   	push   %ebx
  80435c:	83 ec 1c             	sub    $0x1c,%esp
  80435f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804363:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804367:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80436b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80436f:	89 ca                	mov    %ecx,%edx
  804371:	89 f8                	mov    %edi,%eax
  804373:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804377:	85 f6                	test   %esi,%esi
  804379:	75 2d                	jne    8043a8 <__udivdi3+0x50>
  80437b:	39 cf                	cmp    %ecx,%edi
  80437d:	77 65                	ja     8043e4 <__udivdi3+0x8c>
  80437f:	89 fd                	mov    %edi,%ebp
  804381:	85 ff                	test   %edi,%edi
  804383:	75 0b                	jne    804390 <__udivdi3+0x38>
  804385:	b8 01 00 00 00       	mov    $0x1,%eax
  80438a:	31 d2                	xor    %edx,%edx
  80438c:	f7 f7                	div    %edi
  80438e:	89 c5                	mov    %eax,%ebp
  804390:	31 d2                	xor    %edx,%edx
  804392:	89 c8                	mov    %ecx,%eax
  804394:	f7 f5                	div    %ebp
  804396:	89 c1                	mov    %eax,%ecx
  804398:	89 d8                	mov    %ebx,%eax
  80439a:	f7 f5                	div    %ebp
  80439c:	89 cf                	mov    %ecx,%edi
  80439e:	89 fa                	mov    %edi,%edx
  8043a0:	83 c4 1c             	add    $0x1c,%esp
  8043a3:	5b                   	pop    %ebx
  8043a4:	5e                   	pop    %esi
  8043a5:	5f                   	pop    %edi
  8043a6:	5d                   	pop    %ebp
  8043a7:	c3                   	ret    
  8043a8:	39 ce                	cmp    %ecx,%esi
  8043aa:	77 28                	ja     8043d4 <__udivdi3+0x7c>
  8043ac:	0f bd fe             	bsr    %esi,%edi
  8043af:	83 f7 1f             	xor    $0x1f,%edi
  8043b2:	75 40                	jne    8043f4 <__udivdi3+0x9c>
  8043b4:	39 ce                	cmp    %ecx,%esi
  8043b6:	72 0a                	jb     8043c2 <__udivdi3+0x6a>
  8043b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8043bc:	0f 87 9e 00 00 00    	ja     804460 <__udivdi3+0x108>
  8043c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8043c7:	89 fa                	mov    %edi,%edx
  8043c9:	83 c4 1c             	add    $0x1c,%esp
  8043cc:	5b                   	pop    %ebx
  8043cd:	5e                   	pop    %esi
  8043ce:	5f                   	pop    %edi
  8043cf:	5d                   	pop    %ebp
  8043d0:	c3                   	ret    
  8043d1:	8d 76 00             	lea    0x0(%esi),%esi
  8043d4:	31 ff                	xor    %edi,%edi
  8043d6:	31 c0                	xor    %eax,%eax
  8043d8:	89 fa                	mov    %edi,%edx
  8043da:	83 c4 1c             	add    $0x1c,%esp
  8043dd:	5b                   	pop    %ebx
  8043de:	5e                   	pop    %esi
  8043df:	5f                   	pop    %edi
  8043e0:	5d                   	pop    %ebp
  8043e1:	c3                   	ret    
  8043e2:	66 90                	xchg   %ax,%ax
  8043e4:	89 d8                	mov    %ebx,%eax
  8043e6:	f7 f7                	div    %edi
  8043e8:	31 ff                	xor    %edi,%edi
  8043ea:	89 fa                	mov    %edi,%edx
  8043ec:	83 c4 1c             	add    $0x1c,%esp
  8043ef:	5b                   	pop    %ebx
  8043f0:	5e                   	pop    %esi
  8043f1:	5f                   	pop    %edi
  8043f2:	5d                   	pop    %ebp
  8043f3:	c3                   	ret    
  8043f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8043f9:	89 eb                	mov    %ebp,%ebx
  8043fb:	29 fb                	sub    %edi,%ebx
  8043fd:	89 f9                	mov    %edi,%ecx
  8043ff:	d3 e6                	shl    %cl,%esi
  804401:	89 c5                	mov    %eax,%ebp
  804403:	88 d9                	mov    %bl,%cl
  804405:	d3 ed                	shr    %cl,%ebp
  804407:	89 e9                	mov    %ebp,%ecx
  804409:	09 f1                	or     %esi,%ecx
  80440b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80440f:	89 f9                	mov    %edi,%ecx
  804411:	d3 e0                	shl    %cl,%eax
  804413:	89 c5                	mov    %eax,%ebp
  804415:	89 d6                	mov    %edx,%esi
  804417:	88 d9                	mov    %bl,%cl
  804419:	d3 ee                	shr    %cl,%esi
  80441b:	89 f9                	mov    %edi,%ecx
  80441d:	d3 e2                	shl    %cl,%edx
  80441f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804423:	88 d9                	mov    %bl,%cl
  804425:	d3 e8                	shr    %cl,%eax
  804427:	09 c2                	or     %eax,%edx
  804429:	89 d0                	mov    %edx,%eax
  80442b:	89 f2                	mov    %esi,%edx
  80442d:	f7 74 24 0c          	divl   0xc(%esp)
  804431:	89 d6                	mov    %edx,%esi
  804433:	89 c3                	mov    %eax,%ebx
  804435:	f7 e5                	mul    %ebp
  804437:	39 d6                	cmp    %edx,%esi
  804439:	72 19                	jb     804454 <__udivdi3+0xfc>
  80443b:	74 0b                	je     804448 <__udivdi3+0xf0>
  80443d:	89 d8                	mov    %ebx,%eax
  80443f:	31 ff                	xor    %edi,%edi
  804441:	e9 58 ff ff ff       	jmp    80439e <__udivdi3+0x46>
  804446:	66 90                	xchg   %ax,%ax
  804448:	8b 54 24 08          	mov    0x8(%esp),%edx
  80444c:	89 f9                	mov    %edi,%ecx
  80444e:	d3 e2                	shl    %cl,%edx
  804450:	39 c2                	cmp    %eax,%edx
  804452:	73 e9                	jae    80443d <__udivdi3+0xe5>
  804454:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804457:	31 ff                	xor    %edi,%edi
  804459:	e9 40 ff ff ff       	jmp    80439e <__udivdi3+0x46>
  80445e:	66 90                	xchg   %ax,%ax
  804460:	31 c0                	xor    %eax,%eax
  804462:	e9 37 ff ff ff       	jmp    80439e <__udivdi3+0x46>
  804467:	90                   	nop

00804468 <__umoddi3>:
  804468:	55                   	push   %ebp
  804469:	57                   	push   %edi
  80446a:	56                   	push   %esi
  80446b:	53                   	push   %ebx
  80446c:	83 ec 1c             	sub    $0x1c,%esp
  80446f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804473:	8b 74 24 34          	mov    0x34(%esp),%esi
  804477:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80447b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80447f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804483:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804487:	89 f3                	mov    %esi,%ebx
  804489:	89 fa                	mov    %edi,%edx
  80448b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80448f:	89 34 24             	mov    %esi,(%esp)
  804492:	85 c0                	test   %eax,%eax
  804494:	75 1a                	jne    8044b0 <__umoddi3+0x48>
  804496:	39 f7                	cmp    %esi,%edi
  804498:	0f 86 a2 00 00 00    	jbe    804540 <__umoddi3+0xd8>
  80449e:	89 c8                	mov    %ecx,%eax
  8044a0:	89 f2                	mov    %esi,%edx
  8044a2:	f7 f7                	div    %edi
  8044a4:	89 d0                	mov    %edx,%eax
  8044a6:	31 d2                	xor    %edx,%edx
  8044a8:	83 c4 1c             	add    $0x1c,%esp
  8044ab:	5b                   	pop    %ebx
  8044ac:	5e                   	pop    %esi
  8044ad:	5f                   	pop    %edi
  8044ae:	5d                   	pop    %ebp
  8044af:	c3                   	ret    
  8044b0:	39 f0                	cmp    %esi,%eax
  8044b2:	0f 87 ac 00 00 00    	ja     804564 <__umoddi3+0xfc>
  8044b8:	0f bd e8             	bsr    %eax,%ebp
  8044bb:	83 f5 1f             	xor    $0x1f,%ebp
  8044be:	0f 84 ac 00 00 00    	je     804570 <__umoddi3+0x108>
  8044c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8044c9:	29 ef                	sub    %ebp,%edi
  8044cb:	89 fe                	mov    %edi,%esi
  8044cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8044d1:	89 e9                	mov    %ebp,%ecx
  8044d3:	d3 e0                	shl    %cl,%eax
  8044d5:	89 d7                	mov    %edx,%edi
  8044d7:	89 f1                	mov    %esi,%ecx
  8044d9:	d3 ef                	shr    %cl,%edi
  8044db:	09 c7                	or     %eax,%edi
  8044dd:	89 e9                	mov    %ebp,%ecx
  8044df:	d3 e2                	shl    %cl,%edx
  8044e1:	89 14 24             	mov    %edx,(%esp)
  8044e4:	89 d8                	mov    %ebx,%eax
  8044e6:	d3 e0                	shl    %cl,%eax
  8044e8:	89 c2                	mov    %eax,%edx
  8044ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044ee:	d3 e0                	shl    %cl,%eax
  8044f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044f8:	89 f1                	mov    %esi,%ecx
  8044fa:	d3 e8                	shr    %cl,%eax
  8044fc:	09 d0                	or     %edx,%eax
  8044fe:	d3 eb                	shr    %cl,%ebx
  804500:	89 da                	mov    %ebx,%edx
  804502:	f7 f7                	div    %edi
  804504:	89 d3                	mov    %edx,%ebx
  804506:	f7 24 24             	mull   (%esp)
  804509:	89 c6                	mov    %eax,%esi
  80450b:	89 d1                	mov    %edx,%ecx
  80450d:	39 d3                	cmp    %edx,%ebx
  80450f:	0f 82 87 00 00 00    	jb     80459c <__umoddi3+0x134>
  804515:	0f 84 91 00 00 00    	je     8045ac <__umoddi3+0x144>
  80451b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80451f:	29 f2                	sub    %esi,%edx
  804521:	19 cb                	sbb    %ecx,%ebx
  804523:	89 d8                	mov    %ebx,%eax
  804525:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804529:	d3 e0                	shl    %cl,%eax
  80452b:	89 e9                	mov    %ebp,%ecx
  80452d:	d3 ea                	shr    %cl,%edx
  80452f:	09 d0                	or     %edx,%eax
  804531:	89 e9                	mov    %ebp,%ecx
  804533:	d3 eb                	shr    %cl,%ebx
  804535:	89 da                	mov    %ebx,%edx
  804537:	83 c4 1c             	add    $0x1c,%esp
  80453a:	5b                   	pop    %ebx
  80453b:	5e                   	pop    %esi
  80453c:	5f                   	pop    %edi
  80453d:	5d                   	pop    %ebp
  80453e:	c3                   	ret    
  80453f:	90                   	nop
  804540:	89 fd                	mov    %edi,%ebp
  804542:	85 ff                	test   %edi,%edi
  804544:	75 0b                	jne    804551 <__umoddi3+0xe9>
  804546:	b8 01 00 00 00       	mov    $0x1,%eax
  80454b:	31 d2                	xor    %edx,%edx
  80454d:	f7 f7                	div    %edi
  80454f:	89 c5                	mov    %eax,%ebp
  804551:	89 f0                	mov    %esi,%eax
  804553:	31 d2                	xor    %edx,%edx
  804555:	f7 f5                	div    %ebp
  804557:	89 c8                	mov    %ecx,%eax
  804559:	f7 f5                	div    %ebp
  80455b:	89 d0                	mov    %edx,%eax
  80455d:	e9 44 ff ff ff       	jmp    8044a6 <__umoddi3+0x3e>
  804562:	66 90                	xchg   %ax,%ax
  804564:	89 c8                	mov    %ecx,%eax
  804566:	89 f2                	mov    %esi,%edx
  804568:	83 c4 1c             	add    $0x1c,%esp
  80456b:	5b                   	pop    %ebx
  80456c:	5e                   	pop    %esi
  80456d:	5f                   	pop    %edi
  80456e:	5d                   	pop    %ebp
  80456f:	c3                   	ret    
  804570:	3b 04 24             	cmp    (%esp),%eax
  804573:	72 06                	jb     80457b <__umoddi3+0x113>
  804575:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804579:	77 0f                	ja     80458a <__umoddi3+0x122>
  80457b:	89 f2                	mov    %esi,%edx
  80457d:	29 f9                	sub    %edi,%ecx
  80457f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804583:	89 14 24             	mov    %edx,(%esp)
  804586:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80458a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80458e:	8b 14 24             	mov    (%esp),%edx
  804591:	83 c4 1c             	add    $0x1c,%esp
  804594:	5b                   	pop    %ebx
  804595:	5e                   	pop    %esi
  804596:	5f                   	pop    %edi
  804597:	5d                   	pop    %ebp
  804598:	c3                   	ret    
  804599:	8d 76 00             	lea    0x0(%esi),%esi
  80459c:	2b 04 24             	sub    (%esp),%eax
  80459f:	19 fa                	sbb    %edi,%edx
  8045a1:	89 d1                	mov    %edx,%ecx
  8045a3:	89 c6                	mov    %eax,%esi
  8045a5:	e9 71 ff ff ff       	jmp    80451b <__umoddi3+0xb3>
  8045aa:	66 90                	xchg   %ax,%ax
  8045ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8045b0:	72 ea                	jb     80459c <__umoddi3+0x134>
  8045b2:	89 d9                	mov    %ebx,%ecx
  8045b4:	e9 62 ff ff ff       	jmp    80451b <__umoddi3+0xb3>
