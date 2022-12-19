
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
  800062:	68 40 47 80 00       	push   $0x804740
  800067:	e8 f2 14 00 00       	call   80155e <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 8f 28 00 00       	call   802903 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 27 29 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  8000a1:	68 64 47 80 00       	push   $0x804764
  8000a6:	6a 11                	push   $0x11
  8000a8:	68 94 47 80 00       	push   $0x804794
  8000ad:	e8 f8 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000b5:	e8 49 28 00 00       	call   802903 <sys_calculate_free_frames>
  8000ba:	29 c3                	sub    %eax,%ebx
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 ac 47 80 00       	push   $0x8047ac
  8000cb:	6a 13                	push   $0x13
  8000cd:	68 94 47 80 00       	push   $0x804794
  8000d2:	e8 d3 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256)panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 c7 28 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  8000dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 18 48 80 00       	push   $0x804818
  8000ee:	6a 14                	push   $0x14
  8000f0:	68 94 47 80 00       	push   $0x804794
  8000f5:	e8 b0 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000fa:	e8 04 28 00 00       	call   802903 <sys_calculate_free_frames>
  8000ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800102:	e8 9c 28 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  800133:	68 64 47 80 00       	push   $0x804764
  800138:	6a 19                	push   $0x19
  80013a:	68 94 47 80 00       	push   $0x804794
  80013f:	e8 66 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800144:	e8 ba 27 00 00       	call   802903 <sys_calculate_free_frames>
  800149:	89 c2                	mov    %eax,%edx
  80014b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014e:	39 c2                	cmp    %eax,%edx
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 ac 47 80 00       	push   $0x8047ac
  80015a:	6a 1b                	push   $0x1b
  80015c:	68 94 47 80 00       	push   $0x804794
  800161:	e8 44 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800166:	e8 38 28 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  80016b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80016e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 18 48 80 00       	push   $0x804818
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 94 47 80 00       	push   $0x804794
  800184:	e8 21 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800189:	e8 75 27 00 00       	call   802903 <sys_calculate_free_frames>
  80018e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800191:	e8 0d 28 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  8001c4:	68 64 47 80 00       	push   $0x804764
  8001c9:	6a 21                	push   $0x21
  8001cb:	68 94 47 80 00       	push   $0x804794
  8001d0:	e8 d5 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001d5:	e8 29 27 00 00       	call   802903 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 ac 47 80 00       	push   $0x8047ac
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 94 47 80 00       	push   $0x804794
  8001f2:	e8 b3 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8001f7:	e8 a7 27 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  8001fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 18 48 80 00       	push   $0x804818
  80020e:	6a 24                	push   $0x24
  800210:	68 94 47 80 00       	push   $0x804794
  800215:	e8 90 10 00 00       	call   8012aa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80021a:	e8 e4 26 00 00       	call   802903 <sys_calculate_free_frames>
  80021f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800222:	e8 7c 27 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  800259:	68 64 47 80 00       	push   $0x804764
  80025e:	6a 2a                	push   $0x2a
  800260:	68 94 47 80 00       	push   $0x804794
  800265:	e8 40 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026a:	e8 94 26 00 00       	call   802903 <sys_calculate_free_frames>
  80026f:	89 c2                	mov    %eax,%edx
  800271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 ac 47 80 00       	push   $0x8047ac
  800280:	6a 2c                	push   $0x2c
  800282:	68 94 47 80 00       	push   $0x804794
  800287:	e8 1e 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80028c:	e8 12 27 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	3d 00 01 00 00       	cmp    $0x100,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 18 48 80 00       	push   $0x804818
  8002a3:	6a 2d                	push   $0x2d
  8002a5:	68 94 47 80 00       	push   $0x804794
  8002aa:	e8 fb 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 4f 26 00 00       	call   802903 <sys_calculate_free_frames>
  8002b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 e7 26 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  8002ed:	68 64 47 80 00       	push   $0x804764
  8002f2:	6a 33                	push   $0x33
  8002f4:	68 94 47 80 00       	push   $0x804794
  8002f9:	e8 ac 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800301:	e8 fd 25 00 00       	call   802903 <sys_calculate_free_frames>
  800306:	29 c3                	sub    %eax,%ebx
  800308:	89 d8                	mov    %ebx,%eax
  80030a:	83 f8 01             	cmp    $0x1,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 ac 47 80 00       	push   $0x8047ac
  800317:	6a 35                	push   $0x35
  800319:	68 94 47 80 00       	push   $0x804794
  80031e:	e8 87 0f 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800323:	e8 7b 26 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800328:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 18 48 80 00       	push   $0x804818
  80033a:	6a 36                	push   $0x36
  80033c:	68 94 47 80 00       	push   $0x804794
  800341:	e8 64 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800346:	e8 b8 25 00 00       	call   802903 <sys_calculate_free_frames>
  80034b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80034e:	e8 50 26 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  800389:	68 64 47 80 00       	push   $0x804764
  80038e:	6a 3c                	push   $0x3c
  800390:	68 94 47 80 00       	push   $0x804794
  800395:	e8 10 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039a:	e8 64 25 00 00       	call   802903 <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 ac 47 80 00       	push   $0x8047ac
  8003b0:	6a 3e                	push   $0x3e
  8003b2:	68 94 47 80 00       	push   $0x804794
  8003b7:	e8 ee 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003bc:	e8 e2 25 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  8003c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 18 48 80 00       	push   $0x804818
  8003d3:	6a 3f                	push   $0x3f
  8003d5:	68 94 47 80 00       	push   $0x804794
  8003da:	e8 cb 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 1f 25 00 00       	call   802903 <sys_calculate_free_frames>
  8003e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 b7 25 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  800421:	68 64 47 80 00       	push   $0x804764
  800426:	6a 45                	push   $0x45
  800428:	68 94 47 80 00       	push   $0x804794
  80042d:	e8 78 0e 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800432:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800435:	e8 c9 24 00 00       	call   802903 <sys_calculate_free_frames>
  80043a:	29 c3                	sub    %eax,%ebx
  80043c:	89 d8                	mov    %ebx,%eax
  80043e:	83 f8 01             	cmp    $0x1,%eax
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 ac 47 80 00       	push   $0x8047ac
  80044b:	6a 47                	push   $0x47
  80044d:	68 94 47 80 00       	push   $0x804794
  800452:	e8 53 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800457:	e8 47 25 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  80045c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80045f:	3d 00 03 00 00       	cmp    $0x300,%eax
  800464:	74 14                	je     80047a <_main+0x442>
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 18 48 80 00       	push   $0x804818
  80046e:	6a 48                	push   $0x48
  800470:	68 94 47 80 00       	push   $0x804794
  800475:	e8 30 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80047a:	e8 84 24 00 00       	call   802903 <sys_calculate_free_frames>
  80047f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800482:	e8 1c 25 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  8004c4:	68 64 47 80 00       	push   $0x804764
  8004c9:	6a 4e                	push   $0x4e
  8004cb:	68 94 47 80 00       	push   $0x804794
  8004d0:	e8 d5 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8004d8:	e8 26 24 00 00       	call   802903 <sys_calculate_free_frames>
  8004dd:	29 c3                	sub    %eax,%ebx
  8004df:	89 d8                	mov    %ebx,%eax
  8004e1:	83 f8 01             	cmp    $0x1,%eax
  8004e4:	74 14                	je     8004fa <_main+0x4c2>
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 ac 47 80 00       	push   $0x8047ac
  8004ee:	6a 50                	push   $0x50
  8004f0:	68 94 47 80 00       	push   $0x804794
  8004f5:	e8 b0 0d 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8004fa:	e8 a4 24 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  8004ff:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800502:	3d 00 03 00 00       	cmp    $0x300,%eax
  800507:	74 14                	je     80051d <_main+0x4e5>
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 18 48 80 00       	push   $0x804818
  800511:	6a 51                	push   $0x51
  800513:	68 94 47 80 00       	push   $0x804794
  800518:	e8 8d 0d 00 00       	call   8012aa <_panic>


		//NEW
		//Filling the remaining size of user heap
		freeFrames = sys_calculate_free_frames() ;
  80051d:	e8 e1 23 00 00       	call   802903 <sys_calculate_free_frames>
  800522:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800525:	e8 79 24 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  80057f:	68 64 47 80 00       	push   $0x804764
  800584:	6a 5a                	push   $0x5a
  800586:	68 94 47 80 00       	push   $0x804794
  80058b:	e8 1a 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800590:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800593:	e8 6b 23 00 00       	call   802903 <sys_calculate_free_frames>
  800598:	29 c3                	sub    %eax,%ebx
  80059a:	89 d8                	mov    %ebx,%eax
  80059c:	83 f8 7c             	cmp    $0x7c,%eax
  80059f:	74 14                	je     8005b5 <_main+0x57d>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 ac 47 80 00       	push   $0x8047ac
  8005a9:	6a 5c                	push   $0x5c
  8005ab:	68 94 47 80 00       	push   $0x804794
  8005b0:	e8 f5 0c 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005b5:	e8 e9 23 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  8005ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8005bd:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 18 48 80 00       	push   $0x804818
  8005cc:	6a 5d                	push   $0x5d
  8005ce:	68 94 47 80 00       	push   $0x804794
  8005d3:	e8 d2 0c 00 00       	call   8012aa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 26 23 00 00       	call   802903 <sys_calculate_free_frames>
  8005dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e0:	e8 be 23 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8005e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	50                   	push   %eax
  8005ef:	e8 6d 1f 00 00       	call   802561 <free>
  8005f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005f7:	e8 a7 23 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  8005fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
  800601:	89 d0                	mov    %edx,%eax
  800603:	3d 00 01 00 00       	cmp    $0x100,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 48 48 80 00       	push   $0x804848
  800612:	6a 68                	push   $0x68
  800614:	68 94 47 80 00       	push   $0x804794
  800619:	e8 8c 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80061e:	e8 e0 22 00 00       	call   802903 <sys_calculate_free_frames>
  800623:	89 c2                	mov    %eax,%edx
  800625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	74 14                	je     800640 <_main+0x608>
  80062c:	83 ec 04             	sub    $0x4,%esp
  80062f:	68 84 48 80 00       	push   $0x804884
  800634:	6a 69                	push   $0x69
  800636:	68 94 47 80 00       	push   $0x804794
  80063b:	e8 6a 0c 00 00       	call   8012aa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800640:	e8 be 22 00 00       	call   802903 <sys_calculate_free_frames>
  800645:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800648:	e8 56 23 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800650:	8b 45 90             	mov    -0x70(%ebp),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	50                   	push   %eax
  800657:	e8 05 1f 00 00       	call   802561 <free>
  80065c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80065f:	e8 3f 23 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800667:	29 c2                	sub    %eax,%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800670:	74 14                	je     800686 <_main+0x64e>
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	68 48 48 80 00       	push   $0x804848
  80067a:	6a 70                	push   $0x70
  80067c:	68 94 47 80 00       	push   $0x804794
  800681:	e8 24 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800686:	e8 78 22 00 00       	call   802903 <sys_calculate_free_frames>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 84 48 80 00       	push   $0x804884
  80069c:	6a 71                	push   $0x71
  80069e:	68 94 47 80 00       	push   $0x804794
  8006a3:	e8 02 0c 00 00       	call   8012aa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006a8:	e8 56 22 00 00       	call   802903 <sys_calculate_free_frames>
  8006ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006b0:	e8 ee 22 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8006b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	50                   	push   %eax
  8006bf:	e8 9d 1e 00 00       	call   802561 <free>
  8006c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006c7:	e8 d7 22 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  8006cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cf:	29 c2                	sub    %eax,%edx
  8006d1:	89 d0                	mov    %edx,%eax
  8006d3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006d8:	74 14                	je     8006ee <_main+0x6b6>
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	68 48 48 80 00       	push   $0x804848
  8006e2:	6a 78                	push   $0x78
  8006e4:	68 94 47 80 00       	push   $0x804794
  8006e9:	e8 bc 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006ee:	e8 10 22 00 00       	call   802903 <sys_calculate_free_frames>
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f8:	39 c2                	cmp    %eax,%edx
  8006fa:	74 14                	je     800710 <_main+0x6d8>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 84 48 80 00       	push   $0x804884
  800704:	6a 79                	push   $0x79
  800706:	68 94 47 80 00       	push   $0x804794
  80070b:	e8 9a 0b 00 00       	call   8012aa <_panic>

		//NEW
		//free the latest Hole (the big one)
		freeFrames = sys_calculate_free_frames() ;
  800710:	e8 ee 21 00 00       	call   802903 <sys_calculate_free_frames>
  800715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800718:	e8 86 22 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  800720:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	50                   	push   %eax
  800727:	e8 35 1e 00 00       	call   802561 <free>
  80072c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
  80072f:	e8 6f 22 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
  800739:	89 d0                	mov    %edx,%eax
  80073b:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  800740:	74 17                	je     800759 <_main+0x721>
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	68 48 48 80 00       	push   $0x804848
  80074a:	68 81 00 00 00       	push   $0x81
  80074f:	68 94 47 80 00       	push   $0x804794
  800754:	e8 51 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800759:	e8 a5 21 00 00       	call   802903 <sys_calculate_free_frames>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800763:	39 c2                	cmp    %eax,%edx
  800765:	74 17                	je     80077e <_main+0x746>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 84 48 80 00       	push   $0x804884
  80076f:	68 82 00 00 00       	push   $0x82
  800774:	68 94 47 80 00       	push   $0x804794
  800779:	e8 2c 0b 00 00       	call   8012aa <_panic>
	}
	int cnt = 0;
  80077e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800785:	e8 79 21 00 00       	call   802903 <sys_calculate_free_frames>
  80078a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80078d:	e8 11 22 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  8007c2:	68 64 47 80 00       	push   $0x804764
  8007c7:	68 8e 00 00 00       	push   $0x8e
  8007cc:	68 94 47 80 00       	push   $0x804794
  8007d1:	e8 d4 0a 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8007d6:	e8 28 21 00 00       	call   802903 <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 ac 47 80 00       	push   $0x8047ac
  8007ec:	68 90 00 00 00       	push   $0x90
  8007f1:	68 94 47 80 00       	push   $0x804794
  8007f6:	e8 af 0a 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  8007fb:	e8 a3 21 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800800:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800803:	3d 80 00 00 00       	cmp    $0x80,%eax
  800808:	74 17                	je     800821 <_main+0x7e9>
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 18 48 80 00       	push   $0x804818
  800812:	68 91 00 00 00       	push   $0x91
  800817:	68 94 47 80 00       	push   $0x804794
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
  80088b:	e8 73 20 00 00       	call   802903 <sys_calculate_free_frames>
  800890:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800893:	e8 0b 21 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  8008b3:	e8 c9 1e 00 00       	call   802781 <realloc>
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
  8008d2:	68 d0 48 80 00       	push   $0x8048d0
  8008d7:	68 ae 00 00 00       	push   $0xae
  8008dc:	68 94 47 80 00       	push   $0x804794
  8008e1:	e8 c4 09 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008e6:	e8 18 20 00 00       	call   802903 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 04 49 80 00       	push   $0x804904
  8008fc:	68 b0 00 00 00       	push   $0xb0
  800901:	68 94 47 80 00       	push   $0x804794
  800906:	e8 9f 09 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are re-allocated in PageFile");
  80090b:	e8 93 20 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800910:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800913:	83 f8 40             	cmp    $0x40,%eax
  800916:	74 17                	je     80092f <_main+0x8f7>
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 74 49 80 00       	push   $0x804974
  800920:	68 b1 00 00 00       	push   $0xb1
  800925:	68 94 47 80 00       	push   $0x804794
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
  8009b9:	68 a8 49 80 00       	push   $0x8049a8
  8009be:	68 c6 00 00 00       	push   $0xc6
  8009c3:	68 94 47 80 00       	push   $0x804794
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
  8009f7:	68 a8 49 80 00       	push   $0x8049a8
  8009fc:	68 cc 00 00 00       	push   $0xcc
  800a01:	68 94 47 80 00       	push   $0x804794
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
  800a3b:	68 a8 49 80 00       	push   $0x8049a8
  800a40:	68 d2 00 00 00       	push   $0xd2
  800a45:	68 94 47 80 00       	push   $0x804794
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
  800a7e:	68 a8 49 80 00       	push   $0x8049a8
  800a83:	68 d8 00 00 00       	push   $0xd8
  800a88:	68 94 47 80 00       	push   $0x804794
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
  800aa0:	e8 5e 1e 00 00       	call   802903 <sys_calculate_free_frames>
  800aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800aa8:	e8 f6 1e 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800ab0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	50                   	push   %eax
  800ab7:	e8 a5 1a 00 00       	call   802561 <free>
  800abc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800abf:	e8 df 1e 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800ad0:	74 17                	je     800ae9 <_main+0xab1>
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	68 e0 49 80 00       	push   $0x8049e0
  800ada:	68 e0 00 00 00       	push   $0xe0
  800adf:	68 94 47 80 00       	push   $0x804794
  800ae4:	e8 c1 07 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ae9:	e8 15 1e 00 00       	call   802903 <sys_calculate_free_frames>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	83 f8 05             	cmp    $0x5,%eax
  800afa:	74 17                	je     800b13 <_main+0xadb>
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	68 84 48 80 00       	push   $0x804884
  800b04:	68 e1 00 00 00       	push   $0xe1
  800b09:	68 94 47 80 00       	push   $0x804794
  800b0e:	e8 97 07 00 00       	call   8012aa <_panic>

		vcprintf("\b\b\b40%", NULL);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	6a 00                	push   $0x0
  800b18:	68 34 4a 80 00       	push   $0x804a34
  800b1d:	e8 d1 09 00 00       	call   8014f3 <vcprintf>
  800b22:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800b25:	e8 d9 1d 00 00       	call   802903 <sys_calculate_free_frames>
  800b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b2d:	e8 71 1e 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  800b6b:	68 64 47 80 00       	push   $0x804764
  800b70:	68 eb 00 00 00       	push   $0xeb
  800b75:	68 94 47 80 00       	push   $0x804794
  800b7a:	e8 2b 07 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b7f:	e8 7f 1d 00 00       	call   802903 <sys_calculate_free_frames>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	74 17                	je     800ba4 <_main+0xb6c>
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	68 ac 47 80 00       	push   $0x8047ac
  800b95:	68 ed 00 00 00       	push   $0xed
  800b9a:	68 94 47 80 00       	push   $0x804794
  800b9f:	e8 06 07 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800ba4:	e8 fa 1d 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800ba9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800bac:	3d 80 01 00 00       	cmp    $0x180,%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 18 48 80 00       	push   $0x804818
  800bbb:	68 ee 00 00 00       	push   $0xee
  800bc0:	68 94 47 80 00       	push   $0x804794
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
  800c3b:	e8 c3 1c 00 00       	call   802903 <sys_calculate_free_frames>
  800c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 5b 1d 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  800c6a:	e8 12 1b 00 00       	call   802781 <realloc>
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
  800c8c:	68 d0 48 80 00       	push   $0x8048d0
  800c91:	68 07 01 00 00       	push   $0x107
  800c96:	68 94 47 80 00       	push   $0x804794
  800c9b:	e8 0a 06 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");

		//if((sys_calculate_free_frames() - freeFrames) != 3) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  800ca0:	e8 fe 1c 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800ca5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cad:	74 17                	je     800cc6 <_main+0xc8e>
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	68 74 49 80 00       	push   $0x804974
  800cb7:	68 0b 01 00 00       	push   $0x10b
  800cbc:	68 94 47 80 00       	push   $0x804794
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
  800d59:	68 a8 49 80 00       	push   $0x8049a8
  800d5e:	68 22 01 00 00       	push   $0x122
  800d63:	68 94 47 80 00       	push   $0x804794
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
  800d97:	68 a8 49 80 00       	push   $0x8049a8
  800d9c:	68 2a 01 00 00       	push   $0x12a
  800da1:	68 94 47 80 00       	push   $0x804794
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
  800ddb:	68 a8 49 80 00       	push   $0x8049a8
  800de0:	68 31 01 00 00       	push   $0x131
  800de5:	68 94 47 80 00       	push   $0x804794
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
  800e1e:	68 a8 49 80 00       	push   $0x8049a8
  800e23:	68 37 01 00 00       	push   $0x137
  800e28:	68 94 47 80 00       	push   $0x804794
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
  800e40:	e8 be 1a 00 00       	call   802903 <sys_calculate_free_frames>
  800e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e48:	e8 56 1b 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800e50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	e8 05 17 00 00       	call   802561 <free>
  800e5c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e5f:	e8 3f 1b 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	3d 80 02 00 00       	cmp    $0x280,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 e0 49 80 00       	push   $0x8049e0
  800e7a:	68 40 01 00 00       	push   $0x140
  800e7f:	68 94 47 80 00       	push   $0x804794
  800e84:	e8 21 04 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b70%", NULL);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	6a 00                	push   $0x0
  800e8e:	68 3b 4a 80 00       	push   $0x804a3b
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
  800f02:	e8 fc 19 00 00       	call   802903 <sys_calculate_free_frames>
  800f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f0a:	e8 94 1a 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
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
  800f25:	e8 57 18 00 00       	call   802781 <realloc>
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
  800f50:	68 d0 48 80 00       	push   $0x8048d0
  800f55:	68 60 01 00 00       	push   $0x160
  800f5a:	68 94 47 80 00       	push   $0x804794
  800f5f:	e8 46 03 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are re-allocated in PageFile");
  800f64:	e8 3a 1a 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  800f69:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f6c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800f71:	74 17                	je     800f8a <_main+0xf52>
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 74 49 80 00       	push   $0x804974
  800f7b:	68 63 01 00 00       	push   $0x163
  800f80:	68 94 47 80 00       	push   $0x804794
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
  801014:	68 a8 49 80 00       	push   $0x8049a8
  801019:	68 79 01 00 00       	push   $0x179
  80101e:	68 94 47 80 00       	push   $0x804794
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
  801052:	68 a8 49 80 00       	push   $0x8049a8
  801057:	68 81 01 00 00       	push   $0x181
  80105c:	68 94 47 80 00       	push   $0x804794
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
  801096:	68 a8 49 80 00       	push   $0x8049a8
  80109b:	68 88 01 00 00       	push   $0x188
  8010a0:	68 94 47 80 00       	push   $0x804794
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
  8010d9:	68 a8 49 80 00       	push   $0x8049a8
  8010de:	68 8e 01 00 00       	push   $0x18e
  8010e3:	68 94 47 80 00       	push   $0x804794
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
  8010fb:	e8 03 18 00 00       	call   802903 <sys_calculate_free_frames>
  801100:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801103:	e8 9b 18 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  801108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[0]);
  80110b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	e8 4a 14 00 00       	call   802561 <free>
  801117:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  80111a:	e8 84 18 00 00       	call   8029a3 <sys_pf_calculate_allocated_pages>
  80111f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112b:	74 17                	je     801144 <_main+0x110c>
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 e0 49 80 00       	push   $0x8049e0
  801135:	68 96 01 00 00       	push   $0x196
  80113a:	68 94 47 80 00       	push   $0x804794
  80113f:	e8 66 01 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 2) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 00                	push   $0x0
  801149:	68 42 4a 80 00       	push   $0x804a42
  80114e:	e8 a0 03 00 00       	call   8014f3 <vcprintf>
  801153:	83 c4 10             	add    $0x10,%esp
	}

	cprintf("Congratulations!! test realloc [1] completed successfully.\n");
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 4c 4a 80 00       	push   $0x804a4c
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
  801174:	e8 6a 1a 00 00       	call   802be3 <sys_getenvindex>
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
  8011df:	e8 0c 18 00 00       	call   8029f0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	68 a0 4a 80 00       	push   $0x804aa0
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
  80120f:	68 c8 4a 80 00       	push   $0x804ac8
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
  801240:	68 f0 4a 80 00       	push   $0x804af0
  801245:	e8 14 03 00 00       	call   80155e <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80124d:	a1 20 60 80 00       	mov    0x806020,%eax
  801252:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	50                   	push   %eax
  80125c:	68 48 4b 80 00       	push   $0x804b48
  801261:	e8 f8 02 00 00       	call   80155e <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	68 a0 4a 80 00       	push   $0x804aa0
  801271:	e8 e8 02 00 00       	call   80155e <cprintf>
  801276:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801279:	e8 8c 17 00 00       	call   802a0a <sys_enable_interrupt>

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
  801291:	e8 19 19 00 00       	call   802baf <sys_destroy_env>
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
  8012a2:	e8 6e 19 00 00       	call   802c15 <sys_exit_env>
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
  8012cb:	68 5c 4b 80 00       	push   $0x804b5c
  8012d0:	e8 89 02 00 00       	call   80155e <cprintf>
  8012d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8012d8:	a1 00 60 80 00       	mov    0x806000,%eax
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	50                   	push   %eax
  8012e4:	68 61 4b 80 00       	push   $0x804b61
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
  801308:	68 7d 4b 80 00       	push   $0x804b7d
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
  801334:	68 80 4b 80 00       	push   $0x804b80
  801339:	6a 26                	push   $0x26
  80133b:	68 cc 4b 80 00       	push   $0x804bcc
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
  801406:	68 d8 4b 80 00       	push   $0x804bd8
  80140b:	6a 3a                	push   $0x3a
  80140d:	68 cc 4b 80 00       	push   $0x804bcc
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
  801476:	68 2c 4c 80 00       	push   $0x804c2c
  80147b:	6a 44                	push   $0x44
  80147d:	68 cc 4b 80 00       	push   $0x804bcc
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
  8014d0:	e8 6d 13 00 00       	call   802842 <sys_cputs>
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
  801547:	e8 f6 12 00 00       	call   802842 <sys_cputs>
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
  801591:	e8 5a 14 00 00       	call   8029f0 <sys_disable_interrupt>
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
  8015b1:	e8 54 14 00 00       	call   802a0a <sys_enable_interrupt>
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
  8015fb:	e8 c8 2e 00 00       	call   8044c8 <__udivdi3>
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
  80164b:	e8 88 2f 00 00       	call   8045d8 <__umoddi3>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	05 94 4e 80 00       	add    $0x804e94,%eax
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
  8017a6:	8b 04 85 b8 4e 80 00 	mov    0x804eb8(,%eax,4),%eax
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
  801887:	8b 34 9d 00 4d 80 00 	mov    0x804d00(,%ebx,4),%esi
  80188e:	85 f6                	test   %esi,%esi
  801890:	75 19                	jne    8018ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801892:	53                   	push   %ebx
  801893:	68 a5 4e 80 00       	push   $0x804ea5
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
  8018ac:	68 ae 4e 80 00       	push   $0x804eae
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
  8018d9:	be b1 4e 80 00       	mov    $0x804eb1,%esi
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
  8022ff:	68 10 50 80 00       	push   $0x805010
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
  8023cf:	e8 b2 05 00 00       	call   802986 <sys_allocate_chunk>
  8023d4:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8023d7:	a1 20 61 80 00       	mov    0x806120,%eax
  8023dc:	83 ec 0c             	sub    $0xc,%esp
  8023df:	50                   	push   %eax
  8023e0:	e8 27 0c 00 00       	call   80300c <initialize_MemBlocksList>
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
  80240d:	68 35 50 80 00       	push   $0x805035
  802412:	6a 33                	push   $0x33
  802414:	68 53 50 80 00       	push   $0x805053
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
  80248c:	68 60 50 80 00       	push   $0x805060
  802491:	6a 34                	push   $0x34
  802493:	68 53 50 80 00       	push   $0x805053
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
  8024e9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8024ec:	e8 f7 fd ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8024f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024f5:	75 07                	jne    8024fe <malloc+0x18>
  8024f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fc:	eb 61                	jmp    80255f <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8024fe:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802505:	8b 55 08             	mov    0x8(%ebp),%edx
  802508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250b:	01 d0                	add    %edx,%eax
  80250d:	48                   	dec    %eax
  80250e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802514:	ba 00 00 00 00       	mov    $0x0,%edx
  802519:	f7 75 f0             	divl   -0x10(%ebp)
  80251c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251f:	29 d0                	sub    %edx,%eax
  802521:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802524:	e8 2b 08 00 00       	call   802d54 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802529:	85 c0                	test   %eax,%eax
  80252b:	74 11                	je     80253e <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80252d:	83 ec 0c             	sub    $0xc,%esp
  802530:	ff 75 e8             	pushl  -0x18(%ebp)
  802533:	e8 96 0e 00 00       	call   8033ce <alloc_block_FF>
  802538:	83 c4 10             	add    $0x10,%esp
  80253b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80253e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802542:	74 16                	je     80255a <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  802544:	83 ec 0c             	sub    $0xc,%esp
  802547:	ff 75 f4             	pushl  -0xc(%ebp)
  80254a:	e8 f2 0b 00 00       	call   803141 <insert_sorted_allocList>
  80254f:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 40 08             	mov    0x8(%eax),%eax
  802558:	eb 05                	jmp    80255f <malloc+0x79>
	}

    return NULL;
  80255a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	83 ec 08             	sub    $0x8,%esp
  80256d:	50                   	push   %eax
  80256e:	68 40 60 80 00       	push   $0x806040
  802573:	e8 71 0b 00 00       	call   8030e9 <find_block>
  802578:	83 c4 10             	add    $0x10,%esp
  80257b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80257e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802582:	0f 84 a6 00 00 00    	je     80262e <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 50 0c             	mov    0xc(%eax),%edx
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 40 08             	mov    0x8(%eax),%eax
  802594:	83 ec 08             	sub    $0x8,%esp
  802597:	52                   	push   %edx
  802598:	50                   	push   %eax
  802599:	e8 b0 03 00 00       	call   80294e <sys_free_user_mem>
  80259e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8025a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a5:	75 14                	jne    8025bb <free+0x5a>
  8025a7:	83 ec 04             	sub    $0x4,%esp
  8025aa:	68 35 50 80 00       	push   $0x805035
  8025af:	6a 74                	push   $0x74
  8025b1:	68 53 50 80 00       	push   $0x805053
  8025b6:	e8 ef ec ff ff       	call   8012aa <_panic>
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	8b 00                	mov    (%eax),%eax
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	74 10                	je     8025d4 <free+0x73>
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cc:	8b 52 04             	mov    0x4(%edx),%edx
  8025cf:	89 50 04             	mov    %edx,0x4(%eax)
  8025d2:	eb 0b                	jmp    8025df <free+0x7e>
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 40 04             	mov    0x4(%eax),%eax
  8025da:	a3 44 60 80 00       	mov    %eax,0x806044
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 40 04             	mov    0x4(%eax),%eax
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	74 0f                	je     8025f8 <free+0x97>
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 40 04             	mov    0x4(%eax),%eax
  8025ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f2:	8b 12                	mov    (%edx),%edx
  8025f4:	89 10                	mov    %edx,(%eax)
  8025f6:	eb 0a                	jmp    802602 <free+0xa1>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	a3 40 60 80 00       	mov    %eax,0x806040
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802615:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80261a:	48                   	dec    %eax
  80261b:	a3 4c 60 80 00       	mov    %eax,0x80604c
		insert_sorted_with_merge_freeList(free_block);
  802620:	83 ec 0c             	sub    $0xc,%esp
  802623:	ff 75 f4             	pushl  -0xc(%ebp)
  802626:	e8 4e 17 00 00       	call   803d79 <insert_sorted_with_merge_freeList>
  80262b:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80262e:	90                   	nop
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	83 ec 38             	sub    $0x38,%esp
  802637:	8b 45 10             	mov    0x10(%ebp),%eax
  80263a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80263d:	e8 a6 fc ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  802642:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802646:	75 0a                	jne    802652 <smalloc+0x21>
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
  80264d:	e9 8b 00 00 00       	jmp    8026dd <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802652:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802659:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265f:	01 d0                	add    %edx,%eax
  802661:	48                   	dec    %eax
  802662:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802665:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802668:	ba 00 00 00 00       	mov    $0x0,%edx
  80266d:	f7 75 f0             	divl   -0x10(%ebp)
  802670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802673:	29 d0                	sub    %edx,%eax
  802675:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802678:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80267f:	e8 d0 06 00 00       	call   802d54 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802684:	85 c0                	test   %eax,%eax
  802686:	74 11                	je     802699 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  802688:	83 ec 0c             	sub    $0xc,%esp
  80268b:	ff 75 e8             	pushl  -0x18(%ebp)
  80268e:	e8 3b 0d 00 00       	call   8033ce <alloc_block_FF>
  802693:	83 c4 10             	add    $0x10,%esp
  802696:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  802699:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269d:	74 39                	je     8026d8 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 40 08             	mov    0x8(%eax),%eax
  8026a5:	89 c2                	mov    %eax,%edx
  8026a7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8026ab:	52                   	push   %edx
  8026ac:	50                   	push   %eax
  8026ad:	ff 75 0c             	pushl  0xc(%ebp)
  8026b0:	ff 75 08             	pushl  0x8(%ebp)
  8026b3:	e8 21 04 00 00       	call   802ad9 <sys_createSharedObject>
  8026b8:	83 c4 10             	add    $0x10,%esp
  8026bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8026be:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8026c2:	74 14                	je     8026d8 <smalloc+0xa7>
  8026c4:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8026c8:	74 0e                	je     8026d8 <smalloc+0xa7>
  8026ca:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8026ce:	74 08                	je     8026d8 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 40 08             	mov    0x8(%eax),%eax
  8026d6:	eb 05                	jmp    8026dd <smalloc+0xac>
	}
	return NULL;
  8026d8:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8026dd:	c9                   	leave  
  8026de:	c3                   	ret    

008026df <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8026df:	55                   	push   %ebp
  8026e0:	89 e5                	mov    %esp,%ebp
  8026e2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8026e5:	e8 fe fb ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8026ea:	83 ec 08             	sub    $0x8,%esp
  8026ed:	ff 75 0c             	pushl  0xc(%ebp)
  8026f0:	ff 75 08             	pushl  0x8(%ebp)
  8026f3:	e8 0b 04 00 00       	call   802b03 <sys_getSizeOfSharedObject>
  8026f8:	83 c4 10             	add    $0x10,%esp
  8026fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8026fe:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  802702:	74 76                	je     80277a <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802704:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80270b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80270e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802711:	01 d0                	add    %edx,%eax
  802713:	48                   	dec    %eax
  802714:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802717:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271a:	ba 00 00 00 00       	mov    $0x0,%edx
  80271f:	f7 75 ec             	divl   -0x14(%ebp)
  802722:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802725:	29 d0                	sub    %edx,%eax
  802727:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80272a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802731:	e8 1e 06 00 00       	call   802d54 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802736:	85 c0                	test   %eax,%eax
  802738:	74 11                	je     80274b <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80273a:	83 ec 0c             	sub    $0xc,%esp
  80273d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802740:	e8 89 0c 00 00       	call   8033ce <alloc_block_FF>
  802745:	83 c4 10             	add    $0x10,%esp
  802748:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80274b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274f:	74 29                	je     80277a <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 40 08             	mov    0x8(%eax),%eax
  802757:	83 ec 04             	sub    $0x4,%esp
  80275a:	50                   	push   %eax
  80275b:	ff 75 0c             	pushl  0xc(%ebp)
  80275e:	ff 75 08             	pushl  0x8(%ebp)
  802761:	e8 ba 03 00 00       	call   802b20 <sys_getSharedObject>
  802766:	83 c4 10             	add    $0x10,%esp
  802769:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80276c:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  802770:	74 08                	je     80277a <sget+0x9b>
				return (void *)mem_block->sva;
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 40 08             	mov    0x8(%eax),%eax
  802778:	eb 05                	jmp    80277f <sget+0xa0>
		}
	}
	return NULL;
  80277a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80277f:	c9                   	leave  
  802780:	c3                   	ret    

00802781 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802781:	55                   	push   %ebp
  802782:	89 e5                	mov    %esp,%ebp
  802784:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802787:	e8 5c fb ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80278c:	83 ec 04             	sub    $0x4,%esp
  80278f:	68 84 50 80 00       	push   $0x805084
  802794:	68 f7 00 00 00       	push   $0xf7
  802799:	68 53 50 80 00       	push   $0x805053
  80279e:	e8 07 eb ff ff       	call   8012aa <_panic>

008027a3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8027a3:	55                   	push   %ebp
  8027a4:	89 e5                	mov    %esp,%ebp
  8027a6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8027a9:	83 ec 04             	sub    $0x4,%esp
  8027ac:	68 ac 50 80 00       	push   $0x8050ac
  8027b1:	68 0b 01 00 00       	push   $0x10b
  8027b6:	68 53 50 80 00       	push   $0x805053
  8027bb:	e8 ea ea ff ff       	call   8012aa <_panic>

008027c0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027c6:	83 ec 04             	sub    $0x4,%esp
  8027c9:	68 d0 50 80 00       	push   $0x8050d0
  8027ce:	68 16 01 00 00       	push   $0x116
  8027d3:	68 53 50 80 00       	push   $0x805053
  8027d8:	e8 cd ea ff ff       	call   8012aa <_panic>

008027dd <shrink>:

}
void shrink(uint32 newSize)
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
  8027e0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027e3:	83 ec 04             	sub    $0x4,%esp
  8027e6:	68 d0 50 80 00       	push   $0x8050d0
  8027eb:	68 1b 01 00 00       	push   $0x11b
  8027f0:	68 53 50 80 00       	push   $0x805053
  8027f5:	e8 b0 ea ff ff       	call   8012aa <_panic>

008027fa <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802800:	83 ec 04             	sub    $0x4,%esp
  802803:	68 d0 50 80 00       	push   $0x8050d0
  802808:	68 20 01 00 00       	push   $0x120
  80280d:	68 53 50 80 00       	push   $0x805053
  802812:	e8 93 ea ff ff       	call   8012aa <_panic>

00802817 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
  80281a:	57                   	push   %edi
  80281b:	56                   	push   %esi
  80281c:	53                   	push   %ebx
  80281d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802820:	8b 45 08             	mov    0x8(%ebp),%eax
  802823:	8b 55 0c             	mov    0xc(%ebp),%edx
  802826:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802829:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80282c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80282f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802832:	cd 30                	int    $0x30
  802834:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80283a:	83 c4 10             	add    $0x10,%esp
  80283d:	5b                   	pop    %ebx
  80283e:	5e                   	pop    %esi
  80283f:	5f                   	pop    %edi
  802840:	5d                   	pop    %ebp
  802841:	c3                   	ret    

00802842 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	8b 45 10             	mov    0x10(%ebp),%eax
  80284b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80284e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	6a 00                	push   $0x0
  802857:	6a 00                	push   $0x0
  802859:	52                   	push   %edx
  80285a:	ff 75 0c             	pushl  0xc(%ebp)
  80285d:	50                   	push   %eax
  80285e:	6a 00                	push   $0x0
  802860:	e8 b2 ff ff ff       	call   802817 <syscall>
  802865:	83 c4 18             	add    $0x18,%esp
}
  802868:	90                   	nop
  802869:	c9                   	leave  
  80286a:	c3                   	ret    

0080286b <sys_cgetc>:

int
sys_cgetc(void)
{
  80286b:	55                   	push   %ebp
  80286c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80286e:	6a 00                	push   $0x0
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 00                	push   $0x0
  802878:	6a 01                	push   $0x1
  80287a:	e8 98 ff ff ff       	call   802817 <syscall>
  80287f:	83 c4 18             	add    $0x18,%esp
}
  802882:	c9                   	leave  
  802883:	c3                   	ret    

00802884 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802884:	55                   	push   %ebp
  802885:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80288a:	8b 45 08             	mov    0x8(%ebp),%eax
  80288d:	6a 00                	push   $0x0
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	52                   	push   %edx
  802894:	50                   	push   %eax
  802895:	6a 05                	push   $0x5
  802897:	e8 7b ff ff ff       	call   802817 <syscall>
  80289c:	83 c4 18             	add    $0x18,%esp
}
  80289f:	c9                   	leave  
  8028a0:	c3                   	ret    

008028a1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
  8028a4:	56                   	push   %esi
  8028a5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8028a6:	8b 75 18             	mov    0x18(%ebp),%esi
  8028a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	56                   	push   %esi
  8028b6:	53                   	push   %ebx
  8028b7:	51                   	push   %ecx
  8028b8:	52                   	push   %edx
  8028b9:	50                   	push   %eax
  8028ba:	6a 06                	push   $0x6
  8028bc:	e8 56 ff ff ff       	call   802817 <syscall>
  8028c1:	83 c4 18             	add    $0x18,%esp
}
  8028c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028c7:	5b                   	pop    %ebx
  8028c8:	5e                   	pop    %esi
  8028c9:	5d                   	pop    %ebp
  8028ca:	c3                   	ret    

008028cb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8028ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	52                   	push   %edx
  8028db:	50                   	push   %eax
  8028dc:	6a 07                	push   $0x7
  8028de:	e8 34 ff ff ff       	call   802817 <syscall>
  8028e3:	83 c4 18             	add    $0x18,%esp
}
  8028e6:	c9                   	leave  
  8028e7:	c3                   	ret    

008028e8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8028e8:	55                   	push   %ebp
  8028e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	ff 75 0c             	pushl  0xc(%ebp)
  8028f4:	ff 75 08             	pushl  0x8(%ebp)
  8028f7:	6a 08                	push   $0x8
  8028f9:	e8 19 ff ff ff       	call   802817 <syscall>
  8028fe:	83 c4 18             	add    $0x18,%esp
}
  802901:	c9                   	leave  
  802902:	c3                   	ret    

00802903 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802903:	55                   	push   %ebp
  802904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802906:	6a 00                	push   $0x0
  802908:	6a 00                	push   $0x0
  80290a:	6a 00                	push   $0x0
  80290c:	6a 00                	push   $0x0
  80290e:	6a 00                	push   $0x0
  802910:	6a 09                	push   $0x9
  802912:	e8 00 ff ff ff       	call   802817 <syscall>
  802917:	83 c4 18             	add    $0x18,%esp
}
  80291a:	c9                   	leave  
  80291b:	c3                   	ret    

0080291c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80291f:	6a 00                	push   $0x0
  802921:	6a 00                	push   $0x0
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 0a                	push   $0xa
  80292b:	e8 e7 fe ff ff       	call   802817 <syscall>
  802930:	83 c4 18             	add    $0x18,%esp
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802938:	6a 00                	push   $0x0
  80293a:	6a 00                	push   $0x0
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 0b                	push   $0xb
  802944:	e8 ce fe ff ff       	call   802817 <syscall>
  802949:	83 c4 18             	add    $0x18,%esp
}
  80294c:	c9                   	leave  
  80294d:	c3                   	ret    

0080294e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	6a 00                	push   $0x0
  802957:	ff 75 0c             	pushl  0xc(%ebp)
  80295a:	ff 75 08             	pushl  0x8(%ebp)
  80295d:	6a 0f                	push   $0xf
  80295f:	e8 b3 fe ff ff       	call   802817 <syscall>
  802964:	83 c4 18             	add    $0x18,%esp
	return;
  802967:	90                   	nop
}
  802968:	c9                   	leave  
  802969:	c3                   	ret    

0080296a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80296d:	6a 00                	push   $0x0
  80296f:	6a 00                	push   $0x0
  802971:	6a 00                	push   $0x0
  802973:	ff 75 0c             	pushl  0xc(%ebp)
  802976:	ff 75 08             	pushl  0x8(%ebp)
  802979:	6a 10                	push   $0x10
  80297b:	e8 97 fe ff ff       	call   802817 <syscall>
  802980:	83 c4 18             	add    $0x18,%esp
	return ;
  802983:	90                   	nop
}
  802984:	c9                   	leave  
  802985:	c3                   	ret    

00802986 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	ff 75 10             	pushl  0x10(%ebp)
  802990:	ff 75 0c             	pushl  0xc(%ebp)
  802993:	ff 75 08             	pushl  0x8(%ebp)
  802996:	6a 11                	push   $0x11
  802998:	e8 7a fe ff ff       	call   802817 <syscall>
  80299d:	83 c4 18             	add    $0x18,%esp
	return ;
  8029a0:	90                   	nop
}
  8029a1:	c9                   	leave  
  8029a2:	c3                   	ret    

008029a3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8029a3:	55                   	push   %ebp
  8029a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8029a6:	6a 00                	push   $0x0
  8029a8:	6a 00                	push   $0x0
  8029aa:	6a 00                	push   $0x0
  8029ac:	6a 00                	push   $0x0
  8029ae:	6a 00                	push   $0x0
  8029b0:	6a 0c                	push   $0xc
  8029b2:	e8 60 fe ff ff       	call   802817 <syscall>
  8029b7:	83 c4 18             	add    $0x18,%esp
}
  8029ba:	c9                   	leave  
  8029bb:	c3                   	ret    

008029bc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8029bc:	55                   	push   %ebp
  8029bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 00                	push   $0x0
  8029c7:	ff 75 08             	pushl  0x8(%ebp)
  8029ca:	6a 0d                	push   $0xd
  8029cc:	e8 46 fe ff ff       	call   802817 <syscall>
  8029d1:	83 c4 18             	add    $0x18,%esp
}
  8029d4:	c9                   	leave  
  8029d5:	c3                   	ret    

008029d6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8029d6:	55                   	push   %ebp
  8029d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8029d9:	6a 00                	push   $0x0
  8029db:	6a 00                	push   $0x0
  8029dd:	6a 00                	push   $0x0
  8029df:	6a 00                	push   $0x0
  8029e1:	6a 00                	push   $0x0
  8029e3:	6a 0e                	push   $0xe
  8029e5:	e8 2d fe ff ff       	call   802817 <syscall>
  8029ea:	83 c4 18             	add    $0x18,%esp
}
  8029ed:	90                   	nop
  8029ee:	c9                   	leave  
  8029ef:	c3                   	ret    

008029f0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8029f0:	55                   	push   %ebp
  8029f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	6a 00                	push   $0x0
  8029fd:	6a 13                	push   $0x13
  8029ff:	e8 13 fe ff ff       	call   802817 <syscall>
  802a04:	83 c4 18             	add    $0x18,%esp
}
  802a07:	90                   	nop
  802a08:	c9                   	leave  
  802a09:	c3                   	ret    

00802a0a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802a0a:	55                   	push   %ebp
  802a0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802a0d:	6a 00                	push   $0x0
  802a0f:	6a 00                	push   $0x0
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	6a 00                	push   $0x0
  802a17:	6a 14                	push   $0x14
  802a19:	e8 f9 fd ff ff       	call   802817 <syscall>
  802a1e:	83 c4 18             	add    $0x18,%esp
}
  802a21:	90                   	nop
  802a22:	c9                   	leave  
  802a23:	c3                   	ret    

00802a24 <sys_cputc>:


void
sys_cputc(const char c)
{
  802a24:	55                   	push   %ebp
  802a25:	89 e5                	mov    %esp,%ebp
  802a27:	83 ec 04             	sub    $0x4,%esp
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802a30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a34:	6a 00                	push   $0x0
  802a36:	6a 00                	push   $0x0
  802a38:	6a 00                	push   $0x0
  802a3a:	6a 00                	push   $0x0
  802a3c:	50                   	push   %eax
  802a3d:	6a 15                	push   $0x15
  802a3f:	e8 d3 fd ff ff       	call   802817 <syscall>
  802a44:	83 c4 18             	add    $0x18,%esp
}
  802a47:	90                   	nop
  802a48:	c9                   	leave  
  802a49:	c3                   	ret    

00802a4a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802a4a:	55                   	push   %ebp
  802a4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802a4d:	6a 00                	push   $0x0
  802a4f:	6a 00                	push   $0x0
  802a51:	6a 00                	push   $0x0
  802a53:	6a 00                	push   $0x0
  802a55:	6a 00                	push   $0x0
  802a57:	6a 16                	push   $0x16
  802a59:	e8 b9 fd ff ff       	call   802817 <syscall>
  802a5e:	83 c4 18             	add    $0x18,%esp
}
  802a61:	90                   	nop
  802a62:	c9                   	leave  
  802a63:	c3                   	ret    

00802a64 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802a64:	55                   	push   %ebp
  802a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	6a 00                	push   $0x0
  802a6c:	6a 00                	push   $0x0
  802a6e:	6a 00                	push   $0x0
  802a70:	ff 75 0c             	pushl  0xc(%ebp)
  802a73:	50                   	push   %eax
  802a74:	6a 17                	push   $0x17
  802a76:	e8 9c fd ff ff       	call   802817 <syscall>
  802a7b:	83 c4 18             	add    $0x18,%esp
}
  802a7e:	c9                   	leave  
  802a7f:	c3                   	ret    

00802a80 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802a80:	55                   	push   %ebp
  802a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	6a 00                	push   $0x0
  802a8b:	6a 00                	push   $0x0
  802a8d:	6a 00                	push   $0x0
  802a8f:	52                   	push   %edx
  802a90:	50                   	push   %eax
  802a91:	6a 1a                	push   $0x1a
  802a93:	e8 7f fd ff ff       	call   802817 <syscall>
  802a98:	83 c4 18             	add    $0x18,%esp
}
  802a9b:	c9                   	leave  
  802a9c:	c3                   	ret    

00802a9d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802a9d:	55                   	push   %ebp
  802a9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 00                	push   $0x0
  802aac:	52                   	push   %edx
  802aad:	50                   	push   %eax
  802aae:	6a 18                	push   $0x18
  802ab0:	e8 62 fd ff ff       	call   802817 <syscall>
  802ab5:	83 c4 18             	add    $0x18,%esp
}
  802ab8:	90                   	nop
  802ab9:	c9                   	leave  
  802aba:	c3                   	ret    

00802abb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802abb:	55                   	push   %ebp
  802abc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802abe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 00                	push   $0x0
  802aca:	52                   	push   %edx
  802acb:	50                   	push   %eax
  802acc:	6a 19                	push   $0x19
  802ace:	e8 44 fd ff ff       	call   802817 <syscall>
  802ad3:	83 c4 18             	add    $0x18,%esp
}
  802ad6:	90                   	nop
  802ad7:	c9                   	leave  
  802ad8:	c3                   	ret    

00802ad9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802ad9:	55                   	push   %ebp
  802ada:	89 e5                	mov    %esp,%ebp
  802adc:	83 ec 04             	sub    $0x4,%esp
  802adf:	8b 45 10             	mov    0x10(%ebp),%eax
  802ae2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802ae5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ae8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	6a 00                	push   $0x0
  802af1:	51                   	push   %ecx
  802af2:	52                   	push   %edx
  802af3:	ff 75 0c             	pushl  0xc(%ebp)
  802af6:	50                   	push   %eax
  802af7:	6a 1b                	push   $0x1b
  802af9:	e8 19 fd ff ff       	call   802817 <syscall>
  802afe:	83 c4 18             	add    $0x18,%esp
}
  802b01:	c9                   	leave  
  802b02:	c3                   	ret    

00802b03 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802b03:	55                   	push   %ebp
  802b04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	6a 00                	push   $0x0
  802b0e:	6a 00                	push   $0x0
  802b10:	6a 00                	push   $0x0
  802b12:	52                   	push   %edx
  802b13:	50                   	push   %eax
  802b14:	6a 1c                	push   $0x1c
  802b16:	e8 fc fc ff ff       	call   802817 <syscall>
  802b1b:	83 c4 18             	add    $0x18,%esp
}
  802b1e:	c9                   	leave  
  802b1f:	c3                   	ret    

00802b20 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802b20:	55                   	push   %ebp
  802b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802b23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b29:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2c:	6a 00                	push   $0x0
  802b2e:	6a 00                	push   $0x0
  802b30:	51                   	push   %ecx
  802b31:	52                   	push   %edx
  802b32:	50                   	push   %eax
  802b33:	6a 1d                	push   $0x1d
  802b35:	e8 dd fc ff ff       	call   802817 <syscall>
  802b3a:	83 c4 18             	add    $0x18,%esp
}
  802b3d:	c9                   	leave  
  802b3e:	c3                   	ret    

00802b3f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802b3f:	55                   	push   %ebp
  802b40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b45:	8b 45 08             	mov    0x8(%ebp),%eax
  802b48:	6a 00                	push   $0x0
  802b4a:	6a 00                	push   $0x0
  802b4c:	6a 00                	push   $0x0
  802b4e:	52                   	push   %edx
  802b4f:	50                   	push   %eax
  802b50:	6a 1e                	push   $0x1e
  802b52:	e8 c0 fc ff ff       	call   802817 <syscall>
  802b57:	83 c4 18             	add    $0x18,%esp
}
  802b5a:	c9                   	leave  
  802b5b:	c3                   	ret    

00802b5c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802b5c:	55                   	push   %ebp
  802b5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802b5f:	6a 00                	push   $0x0
  802b61:	6a 00                	push   $0x0
  802b63:	6a 00                	push   $0x0
  802b65:	6a 00                	push   $0x0
  802b67:	6a 00                	push   $0x0
  802b69:	6a 1f                	push   $0x1f
  802b6b:	e8 a7 fc ff ff       	call   802817 <syscall>
  802b70:	83 c4 18             	add    $0x18,%esp
}
  802b73:	c9                   	leave  
  802b74:	c3                   	ret    

00802b75 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802b75:	55                   	push   %ebp
  802b76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	6a 00                	push   $0x0
  802b7d:	ff 75 14             	pushl  0x14(%ebp)
  802b80:	ff 75 10             	pushl  0x10(%ebp)
  802b83:	ff 75 0c             	pushl  0xc(%ebp)
  802b86:	50                   	push   %eax
  802b87:	6a 20                	push   $0x20
  802b89:	e8 89 fc ff ff       	call   802817 <syscall>
  802b8e:	83 c4 18             	add    $0x18,%esp
}
  802b91:	c9                   	leave  
  802b92:	c3                   	ret    

00802b93 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802b93:	55                   	push   %ebp
  802b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	6a 00                	push   $0x0
  802b9b:	6a 00                	push   $0x0
  802b9d:	6a 00                	push   $0x0
  802b9f:	6a 00                	push   $0x0
  802ba1:	50                   	push   %eax
  802ba2:	6a 21                	push   $0x21
  802ba4:	e8 6e fc ff ff       	call   802817 <syscall>
  802ba9:	83 c4 18             	add    $0x18,%esp
}
  802bac:	90                   	nop
  802bad:	c9                   	leave  
  802bae:	c3                   	ret    

00802baf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802baf:	55                   	push   %ebp
  802bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	6a 00                	push   $0x0
  802bb7:	6a 00                	push   $0x0
  802bb9:	6a 00                	push   $0x0
  802bbb:	6a 00                	push   $0x0
  802bbd:	50                   	push   %eax
  802bbe:	6a 22                	push   $0x22
  802bc0:	e8 52 fc ff ff       	call   802817 <syscall>
  802bc5:	83 c4 18             	add    $0x18,%esp
}
  802bc8:	c9                   	leave  
  802bc9:	c3                   	ret    

00802bca <sys_getenvid>:

int32 sys_getenvid(void)
{
  802bca:	55                   	push   %ebp
  802bcb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802bcd:	6a 00                	push   $0x0
  802bcf:	6a 00                	push   $0x0
  802bd1:	6a 00                	push   $0x0
  802bd3:	6a 00                	push   $0x0
  802bd5:	6a 00                	push   $0x0
  802bd7:	6a 02                	push   $0x2
  802bd9:	e8 39 fc ff ff       	call   802817 <syscall>
  802bde:	83 c4 18             	add    $0x18,%esp
}
  802be1:	c9                   	leave  
  802be2:	c3                   	ret    

00802be3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802be3:	55                   	push   %ebp
  802be4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802be6:	6a 00                	push   $0x0
  802be8:	6a 00                	push   $0x0
  802bea:	6a 00                	push   $0x0
  802bec:	6a 00                	push   $0x0
  802bee:	6a 00                	push   $0x0
  802bf0:	6a 03                	push   $0x3
  802bf2:	e8 20 fc ff ff       	call   802817 <syscall>
  802bf7:	83 c4 18             	add    $0x18,%esp
}
  802bfa:	c9                   	leave  
  802bfb:	c3                   	ret    

00802bfc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802bfc:	55                   	push   %ebp
  802bfd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802bff:	6a 00                	push   $0x0
  802c01:	6a 00                	push   $0x0
  802c03:	6a 00                	push   $0x0
  802c05:	6a 00                	push   $0x0
  802c07:	6a 00                	push   $0x0
  802c09:	6a 04                	push   $0x4
  802c0b:	e8 07 fc ff ff       	call   802817 <syscall>
  802c10:	83 c4 18             	add    $0x18,%esp
}
  802c13:	c9                   	leave  
  802c14:	c3                   	ret    

00802c15 <sys_exit_env>:


void sys_exit_env(void)
{
  802c15:	55                   	push   %ebp
  802c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802c18:	6a 00                	push   $0x0
  802c1a:	6a 00                	push   $0x0
  802c1c:	6a 00                	push   $0x0
  802c1e:	6a 00                	push   $0x0
  802c20:	6a 00                	push   $0x0
  802c22:	6a 23                	push   $0x23
  802c24:	e8 ee fb ff ff       	call   802817 <syscall>
  802c29:	83 c4 18             	add    $0x18,%esp
}
  802c2c:	90                   	nop
  802c2d:	c9                   	leave  
  802c2e:	c3                   	ret    

00802c2f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802c2f:	55                   	push   %ebp
  802c30:	89 e5                	mov    %esp,%ebp
  802c32:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802c35:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c38:	8d 50 04             	lea    0x4(%eax),%edx
  802c3b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c3e:	6a 00                	push   $0x0
  802c40:	6a 00                	push   $0x0
  802c42:	6a 00                	push   $0x0
  802c44:	52                   	push   %edx
  802c45:	50                   	push   %eax
  802c46:	6a 24                	push   $0x24
  802c48:	e8 ca fb ff ff       	call   802817 <syscall>
  802c4d:	83 c4 18             	add    $0x18,%esp
	return result;
  802c50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802c56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c59:	89 01                	mov    %eax,(%ecx)
  802c5b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	c9                   	leave  
  802c62:	c2 04 00             	ret    $0x4

00802c65 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802c65:	55                   	push   %ebp
  802c66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802c68:	6a 00                	push   $0x0
  802c6a:	6a 00                	push   $0x0
  802c6c:	ff 75 10             	pushl  0x10(%ebp)
  802c6f:	ff 75 0c             	pushl  0xc(%ebp)
  802c72:	ff 75 08             	pushl  0x8(%ebp)
  802c75:	6a 12                	push   $0x12
  802c77:	e8 9b fb ff ff       	call   802817 <syscall>
  802c7c:	83 c4 18             	add    $0x18,%esp
	return ;
  802c7f:	90                   	nop
}
  802c80:	c9                   	leave  
  802c81:	c3                   	ret    

00802c82 <sys_rcr2>:
uint32 sys_rcr2()
{
  802c82:	55                   	push   %ebp
  802c83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802c85:	6a 00                	push   $0x0
  802c87:	6a 00                	push   $0x0
  802c89:	6a 00                	push   $0x0
  802c8b:	6a 00                	push   $0x0
  802c8d:	6a 00                	push   $0x0
  802c8f:	6a 25                	push   $0x25
  802c91:	e8 81 fb ff ff       	call   802817 <syscall>
  802c96:	83 c4 18             	add    $0x18,%esp
}
  802c99:	c9                   	leave  
  802c9a:	c3                   	ret    

00802c9b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802c9b:	55                   	push   %ebp
  802c9c:	89 e5                	mov    %esp,%ebp
  802c9e:	83 ec 04             	sub    $0x4,%esp
  802ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ca7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	6a 00                	push   $0x0
  802cb1:	6a 00                	push   $0x0
  802cb3:	50                   	push   %eax
  802cb4:	6a 26                	push   $0x26
  802cb6:	e8 5c fb ff ff       	call   802817 <syscall>
  802cbb:	83 c4 18             	add    $0x18,%esp
	return ;
  802cbe:	90                   	nop
}
  802cbf:	c9                   	leave  
  802cc0:	c3                   	ret    

00802cc1 <rsttst>:
void rsttst()
{
  802cc1:	55                   	push   %ebp
  802cc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802cc4:	6a 00                	push   $0x0
  802cc6:	6a 00                	push   $0x0
  802cc8:	6a 00                	push   $0x0
  802cca:	6a 00                	push   $0x0
  802ccc:	6a 00                	push   $0x0
  802cce:	6a 28                	push   $0x28
  802cd0:	e8 42 fb ff ff       	call   802817 <syscall>
  802cd5:	83 c4 18             	add    $0x18,%esp
	return ;
  802cd8:	90                   	nop
}
  802cd9:	c9                   	leave  
  802cda:	c3                   	ret    

00802cdb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802cdb:	55                   	push   %ebp
  802cdc:	89 e5                	mov    %esp,%ebp
  802cde:	83 ec 04             	sub    $0x4,%esp
  802ce1:	8b 45 14             	mov    0x14(%ebp),%eax
  802ce4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802ce7:	8b 55 18             	mov    0x18(%ebp),%edx
  802cea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802cee:	52                   	push   %edx
  802cef:	50                   	push   %eax
  802cf0:	ff 75 10             	pushl  0x10(%ebp)
  802cf3:	ff 75 0c             	pushl  0xc(%ebp)
  802cf6:	ff 75 08             	pushl  0x8(%ebp)
  802cf9:	6a 27                	push   $0x27
  802cfb:	e8 17 fb ff ff       	call   802817 <syscall>
  802d00:	83 c4 18             	add    $0x18,%esp
	return ;
  802d03:	90                   	nop
}
  802d04:	c9                   	leave  
  802d05:	c3                   	ret    

00802d06 <chktst>:
void chktst(uint32 n)
{
  802d06:	55                   	push   %ebp
  802d07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802d09:	6a 00                	push   $0x0
  802d0b:	6a 00                	push   $0x0
  802d0d:	6a 00                	push   $0x0
  802d0f:	6a 00                	push   $0x0
  802d11:	ff 75 08             	pushl  0x8(%ebp)
  802d14:	6a 29                	push   $0x29
  802d16:	e8 fc fa ff ff       	call   802817 <syscall>
  802d1b:	83 c4 18             	add    $0x18,%esp
	return ;
  802d1e:	90                   	nop
}
  802d1f:	c9                   	leave  
  802d20:	c3                   	ret    

00802d21 <inctst>:

void inctst()
{
  802d21:	55                   	push   %ebp
  802d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802d24:	6a 00                	push   $0x0
  802d26:	6a 00                	push   $0x0
  802d28:	6a 00                	push   $0x0
  802d2a:	6a 00                	push   $0x0
  802d2c:	6a 00                	push   $0x0
  802d2e:	6a 2a                	push   $0x2a
  802d30:	e8 e2 fa ff ff       	call   802817 <syscall>
  802d35:	83 c4 18             	add    $0x18,%esp
	return ;
  802d38:	90                   	nop
}
  802d39:	c9                   	leave  
  802d3a:	c3                   	ret    

00802d3b <gettst>:
uint32 gettst()
{
  802d3b:	55                   	push   %ebp
  802d3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802d3e:	6a 00                	push   $0x0
  802d40:	6a 00                	push   $0x0
  802d42:	6a 00                	push   $0x0
  802d44:	6a 00                	push   $0x0
  802d46:	6a 00                	push   $0x0
  802d48:	6a 2b                	push   $0x2b
  802d4a:	e8 c8 fa ff ff       	call   802817 <syscall>
  802d4f:	83 c4 18             	add    $0x18,%esp
}
  802d52:	c9                   	leave  
  802d53:	c3                   	ret    

00802d54 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802d54:	55                   	push   %ebp
  802d55:	89 e5                	mov    %esp,%ebp
  802d57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d5a:	6a 00                	push   $0x0
  802d5c:	6a 00                	push   $0x0
  802d5e:	6a 00                	push   $0x0
  802d60:	6a 00                	push   $0x0
  802d62:	6a 00                	push   $0x0
  802d64:	6a 2c                	push   $0x2c
  802d66:	e8 ac fa ff ff       	call   802817 <syscall>
  802d6b:	83 c4 18             	add    $0x18,%esp
  802d6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802d71:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802d75:	75 07                	jne    802d7e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802d77:	b8 01 00 00 00       	mov    $0x1,%eax
  802d7c:	eb 05                	jmp    802d83 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d83:	c9                   	leave  
  802d84:	c3                   	ret    

00802d85 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802d85:	55                   	push   %ebp
  802d86:	89 e5                	mov    %esp,%ebp
  802d88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d8b:	6a 00                	push   $0x0
  802d8d:	6a 00                	push   $0x0
  802d8f:	6a 00                	push   $0x0
  802d91:	6a 00                	push   $0x0
  802d93:	6a 00                	push   $0x0
  802d95:	6a 2c                	push   $0x2c
  802d97:	e8 7b fa ff ff       	call   802817 <syscall>
  802d9c:	83 c4 18             	add    $0x18,%esp
  802d9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802da2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802da6:	75 07                	jne    802daf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802da8:	b8 01 00 00 00       	mov    $0x1,%eax
  802dad:	eb 05                	jmp    802db4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802db4:	c9                   	leave  
  802db5:	c3                   	ret    

00802db6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802db6:	55                   	push   %ebp
  802db7:	89 e5                	mov    %esp,%ebp
  802db9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802dbc:	6a 00                	push   $0x0
  802dbe:	6a 00                	push   $0x0
  802dc0:	6a 00                	push   $0x0
  802dc2:	6a 00                	push   $0x0
  802dc4:	6a 00                	push   $0x0
  802dc6:	6a 2c                	push   $0x2c
  802dc8:	e8 4a fa ff ff       	call   802817 <syscall>
  802dcd:	83 c4 18             	add    $0x18,%esp
  802dd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802dd3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802dd7:	75 07                	jne    802de0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  802dde:	eb 05                	jmp    802de5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802de5:	c9                   	leave  
  802de6:	c3                   	ret    

00802de7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802de7:	55                   	push   %ebp
  802de8:	89 e5                	mov    %esp,%ebp
  802dea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ded:	6a 00                	push   $0x0
  802def:	6a 00                	push   $0x0
  802df1:	6a 00                	push   $0x0
  802df3:	6a 00                	push   $0x0
  802df5:	6a 00                	push   $0x0
  802df7:	6a 2c                	push   $0x2c
  802df9:	e8 19 fa ff ff       	call   802817 <syscall>
  802dfe:	83 c4 18             	add    $0x18,%esp
  802e01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802e04:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802e08:	75 07                	jne    802e11 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  802e0f:	eb 05                	jmp    802e16 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e16:	c9                   	leave  
  802e17:	c3                   	ret    

00802e18 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802e18:	55                   	push   %ebp
  802e19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802e1b:	6a 00                	push   $0x0
  802e1d:	6a 00                	push   $0x0
  802e1f:	6a 00                	push   $0x0
  802e21:	6a 00                	push   $0x0
  802e23:	ff 75 08             	pushl  0x8(%ebp)
  802e26:	6a 2d                	push   $0x2d
  802e28:	e8 ea f9 ff ff       	call   802817 <syscall>
  802e2d:	83 c4 18             	add    $0x18,%esp
	return ;
  802e30:	90                   	nop
}
  802e31:	c9                   	leave  
  802e32:	c3                   	ret    

00802e33 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802e33:	55                   	push   %ebp
  802e34:	89 e5                	mov    %esp,%ebp
  802e36:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802e37:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	6a 00                	push   $0x0
  802e45:	53                   	push   %ebx
  802e46:	51                   	push   %ecx
  802e47:	52                   	push   %edx
  802e48:	50                   	push   %eax
  802e49:	6a 2e                	push   $0x2e
  802e4b:	e8 c7 f9 ff ff       	call   802817 <syscall>
  802e50:	83 c4 18             	add    $0x18,%esp
}
  802e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e56:	c9                   	leave  
  802e57:	c3                   	ret    

00802e58 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802e58:	55                   	push   %ebp
  802e59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	6a 00                	push   $0x0
  802e63:	6a 00                	push   $0x0
  802e65:	6a 00                	push   $0x0
  802e67:	52                   	push   %edx
  802e68:	50                   	push   %eax
  802e69:	6a 2f                	push   $0x2f
  802e6b:	e8 a7 f9 ff ff       	call   802817 <syscall>
  802e70:	83 c4 18             	add    $0x18,%esp
}
  802e73:	c9                   	leave  
  802e74:	c3                   	ret    

00802e75 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802e75:	55                   	push   %ebp
  802e76:	89 e5                	mov    %esp,%ebp
  802e78:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802e7b:	83 ec 0c             	sub    $0xc,%esp
  802e7e:	68 e0 50 80 00       	push   $0x8050e0
  802e83:	e8 d6 e6 ff ff       	call   80155e <cprintf>
  802e88:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802e8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802e92:	83 ec 0c             	sub    $0xc,%esp
  802e95:	68 0c 51 80 00       	push   $0x80510c
  802e9a:	e8 bf e6 ff ff       	call   80155e <cprintf>
  802e9f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802ea2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ea6:	a1 38 61 80 00       	mov    0x806138,%eax
  802eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eae:	eb 56                	jmp    802f06 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802eb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eb4:	74 1c                	je     802ed2 <print_mem_block_lists+0x5d>
  802eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb9:	8b 50 08             	mov    0x8(%eax),%edx
  802ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebf:	8b 48 08             	mov    0x8(%eax),%ecx
  802ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec8:	01 c8                	add    %ecx,%eax
  802eca:	39 c2                	cmp    %eax,%edx
  802ecc:	73 04                	jae    802ed2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802ece:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 50 08             	mov    0x8(%eax),%edx
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ede:	01 c2                	add    %eax,%edx
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	8b 40 08             	mov    0x8(%eax),%eax
  802ee6:	83 ec 04             	sub    $0x4,%esp
  802ee9:	52                   	push   %edx
  802eea:	50                   	push   %eax
  802eeb:	68 21 51 80 00       	push   $0x805121
  802ef0:	e8 69 e6 ff ff       	call   80155e <cprintf>
  802ef5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802efe:	a1 40 61 80 00       	mov    0x806140,%eax
  802f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0a:	74 07                	je     802f13 <print_mem_block_lists+0x9e>
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 00                	mov    (%eax),%eax
  802f11:	eb 05                	jmp    802f18 <print_mem_block_lists+0xa3>
  802f13:	b8 00 00 00 00       	mov    $0x0,%eax
  802f18:	a3 40 61 80 00       	mov    %eax,0x806140
  802f1d:	a1 40 61 80 00       	mov    0x806140,%eax
  802f22:	85 c0                	test   %eax,%eax
  802f24:	75 8a                	jne    802eb0 <print_mem_block_lists+0x3b>
  802f26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2a:	75 84                	jne    802eb0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802f2c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802f30:	75 10                	jne    802f42 <print_mem_block_lists+0xcd>
  802f32:	83 ec 0c             	sub    $0xc,%esp
  802f35:	68 30 51 80 00       	push   $0x805130
  802f3a:	e8 1f e6 ff ff       	call   80155e <cprintf>
  802f3f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802f42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802f49:	83 ec 0c             	sub    $0xc,%esp
  802f4c:	68 54 51 80 00       	push   $0x805154
  802f51:	e8 08 e6 ff ff       	call   80155e <cprintf>
  802f56:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802f59:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802f5d:	a1 40 60 80 00       	mov    0x806040,%eax
  802f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f65:	eb 56                	jmp    802fbd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802f67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f6b:	74 1c                	je     802f89 <print_mem_block_lists+0x114>
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 50 08             	mov    0x8(%eax),%edx
  802f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f76:	8b 48 08             	mov    0x8(%eax),%ecx
  802f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7f:	01 c8                	add    %ecx,%eax
  802f81:	39 c2                	cmp    %eax,%edx
  802f83:	73 04                	jae    802f89 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802f85:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	8b 50 08             	mov    0x8(%eax),%edx
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 40 0c             	mov    0xc(%eax),%eax
  802f95:	01 c2                	add    %eax,%edx
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 40 08             	mov    0x8(%eax),%eax
  802f9d:	83 ec 04             	sub    $0x4,%esp
  802fa0:	52                   	push   %edx
  802fa1:	50                   	push   %eax
  802fa2:	68 21 51 80 00       	push   $0x805121
  802fa7:	e8 b2 e5 ff ff       	call   80155e <cprintf>
  802fac:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802fb5:	a1 48 60 80 00       	mov    0x806048,%eax
  802fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc1:	74 07                	je     802fca <print_mem_block_lists+0x155>
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	eb 05                	jmp    802fcf <print_mem_block_lists+0x15a>
  802fca:	b8 00 00 00 00       	mov    $0x0,%eax
  802fcf:	a3 48 60 80 00       	mov    %eax,0x806048
  802fd4:	a1 48 60 80 00       	mov    0x806048,%eax
  802fd9:	85 c0                	test   %eax,%eax
  802fdb:	75 8a                	jne    802f67 <print_mem_block_lists+0xf2>
  802fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe1:	75 84                	jne    802f67 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802fe3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802fe7:	75 10                	jne    802ff9 <print_mem_block_lists+0x184>
  802fe9:	83 ec 0c             	sub    $0xc,%esp
  802fec:	68 6c 51 80 00       	push   $0x80516c
  802ff1:	e8 68 e5 ff ff       	call   80155e <cprintf>
  802ff6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802ff9:	83 ec 0c             	sub    $0xc,%esp
  802ffc:	68 e0 50 80 00       	push   $0x8050e0
  803001:	e8 58 e5 ff ff       	call   80155e <cprintf>
  803006:	83 c4 10             	add    $0x10,%esp

}
  803009:	90                   	nop
  80300a:	c9                   	leave  
  80300b:	c3                   	ret    

0080300c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80300c:	55                   	push   %ebp
  80300d:	89 e5                	mov    %esp,%ebp
  80300f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  803012:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  803019:	00 00 00 
  80301c:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  803023:	00 00 00 
  803026:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  80302d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  803030:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803037:	e9 9e 00 00 00       	jmp    8030da <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80303c:	a1 50 60 80 00       	mov    0x806050,%eax
  803041:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803044:	c1 e2 04             	shl    $0x4,%edx
  803047:	01 d0                	add    %edx,%eax
  803049:	85 c0                	test   %eax,%eax
  80304b:	75 14                	jne    803061 <initialize_MemBlocksList+0x55>
  80304d:	83 ec 04             	sub    $0x4,%esp
  803050:	68 94 51 80 00       	push   $0x805194
  803055:	6a 46                	push   $0x46
  803057:	68 b7 51 80 00       	push   $0x8051b7
  80305c:	e8 49 e2 ff ff       	call   8012aa <_panic>
  803061:	a1 50 60 80 00       	mov    0x806050,%eax
  803066:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803069:	c1 e2 04             	shl    $0x4,%edx
  80306c:	01 d0                	add    %edx,%eax
  80306e:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803074:	89 10                	mov    %edx,(%eax)
  803076:	8b 00                	mov    (%eax),%eax
  803078:	85 c0                	test   %eax,%eax
  80307a:	74 18                	je     803094 <initialize_MemBlocksList+0x88>
  80307c:	a1 48 61 80 00       	mov    0x806148,%eax
  803081:	8b 15 50 60 80 00    	mov    0x806050,%edx
  803087:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80308a:	c1 e1 04             	shl    $0x4,%ecx
  80308d:	01 ca                	add    %ecx,%edx
  80308f:	89 50 04             	mov    %edx,0x4(%eax)
  803092:	eb 12                	jmp    8030a6 <initialize_MemBlocksList+0x9a>
  803094:	a1 50 60 80 00       	mov    0x806050,%eax
  803099:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80309c:	c1 e2 04             	shl    $0x4,%edx
  80309f:	01 d0                	add    %edx,%eax
  8030a1:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8030a6:	a1 50 60 80 00       	mov    0x806050,%eax
  8030ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ae:	c1 e2 04             	shl    $0x4,%edx
  8030b1:	01 d0                	add    %edx,%eax
  8030b3:	a3 48 61 80 00       	mov    %eax,0x806148
  8030b8:	a1 50 60 80 00       	mov    0x806050,%eax
  8030bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c0:	c1 e2 04             	shl    $0x4,%edx
  8030c3:	01 d0                	add    %edx,%eax
  8030c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cc:	a1 54 61 80 00       	mov    0x806154,%eax
  8030d1:	40                   	inc    %eax
  8030d2:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8030d7:	ff 45 f4             	incl   -0xc(%ebp)
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030e0:	0f 82 56 ff ff ff    	jb     80303c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8030e6:	90                   	nop
  8030e7:	c9                   	leave  
  8030e8:	c3                   	ret    

008030e9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8030e9:	55                   	push   %ebp
  8030ea:	89 e5                	mov    %esp,%ebp
  8030ec:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	8b 00                	mov    (%eax),%eax
  8030f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8030f7:	eb 19                	jmp    803112 <find_block+0x29>
	{
		if(va==point->sva)
  8030f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030fc:	8b 40 08             	mov    0x8(%eax),%eax
  8030ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803102:	75 05                	jne    803109 <find_block+0x20>
		   return point;
  803104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803107:	eb 36                	jmp    80313f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	8b 40 08             	mov    0x8(%eax),%eax
  80310f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803112:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803116:	74 07                	je     80311f <find_block+0x36>
  803118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80311b:	8b 00                	mov    (%eax),%eax
  80311d:	eb 05                	jmp    803124 <find_block+0x3b>
  80311f:	b8 00 00 00 00       	mov    $0x0,%eax
  803124:	8b 55 08             	mov    0x8(%ebp),%edx
  803127:	89 42 08             	mov    %eax,0x8(%edx)
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	8b 40 08             	mov    0x8(%eax),%eax
  803130:	85 c0                	test   %eax,%eax
  803132:	75 c5                	jne    8030f9 <find_block+0x10>
  803134:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803138:	75 bf                	jne    8030f9 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80313a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80313f:	c9                   	leave  
  803140:	c3                   	ret    

00803141 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803141:	55                   	push   %ebp
  803142:	89 e5                	mov    %esp,%ebp
  803144:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  803147:	a1 40 60 80 00       	mov    0x806040,%eax
  80314c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80314f:	a1 44 60 80 00       	mov    0x806044,%eax
  803154:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  803157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80315d:	74 24                	je     803183 <insert_sorted_allocList+0x42>
  80315f:	8b 45 08             	mov    0x8(%ebp),%eax
  803162:	8b 50 08             	mov    0x8(%eax),%edx
  803165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803168:	8b 40 08             	mov    0x8(%eax),%eax
  80316b:	39 c2                	cmp    %eax,%edx
  80316d:	76 14                	jbe    803183 <insert_sorted_allocList+0x42>
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	8b 50 08             	mov    0x8(%eax),%edx
  803175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803178:	8b 40 08             	mov    0x8(%eax),%eax
  80317b:	39 c2                	cmp    %eax,%edx
  80317d:	0f 82 60 01 00 00    	jb     8032e3 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  803183:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803187:	75 65                	jne    8031ee <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  803189:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318d:	75 14                	jne    8031a3 <insert_sorted_allocList+0x62>
  80318f:	83 ec 04             	sub    $0x4,%esp
  803192:	68 94 51 80 00       	push   $0x805194
  803197:	6a 6b                	push   $0x6b
  803199:	68 b7 51 80 00       	push   $0x8051b7
  80319e:	e8 07 e1 ff ff       	call   8012aa <_panic>
  8031a3:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	89 10                	mov    %edx,(%eax)
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	8b 00                	mov    (%eax),%eax
  8031b3:	85 c0                	test   %eax,%eax
  8031b5:	74 0d                	je     8031c4 <insert_sorted_allocList+0x83>
  8031b7:	a1 40 60 80 00       	mov    0x806040,%eax
  8031bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bf:	89 50 04             	mov    %edx,0x4(%eax)
  8031c2:	eb 08                	jmp    8031cc <insert_sorted_allocList+0x8b>
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	a3 44 60 80 00       	mov    %eax,0x806044
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	a3 40 60 80 00       	mov    %eax,0x806040
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031de:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8031e3:	40                   	inc    %eax
  8031e4:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8031e9:	e9 dc 01 00 00       	jmp    8033ca <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	8b 50 08             	mov    0x8(%eax),%edx
  8031f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f7:	8b 40 08             	mov    0x8(%eax),%eax
  8031fa:	39 c2                	cmp    %eax,%edx
  8031fc:	77 6c                	ja     80326a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8031fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803202:	74 06                	je     80320a <insert_sorted_allocList+0xc9>
  803204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803208:	75 14                	jne    80321e <insert_sorted_allocList+0xdd>
  80320a:	83 ec 04             	sub    $0x4,%esp
  80320d:	68 d0 51 80 00       	push   $0x8051d0
  803212:	6a 6f                	push   $0x6f
  803214:	68 b7 51 80 00       	push   $0x8051b7
  803219:	e8 8c e0 ff ff       	call   8012aa <_panic>
  80321e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803221:	8b 50 04             	mov    0x4(%eax),%edx
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	89 50 04             	mov    %edx,0x4(%eax)
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803230:	89 10                	mov    %edx,(%eax)
  803232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803235:	8b 40 04             	mov    0x4(%eax),%eax
  803238:	85 c0                	test   %eax,%eax
  80323a:	74 0d                	je     803249 <insert_sorted_allocList+0x108>
  80323c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323f:	8b 40 04             	mov    0x4(%eax),%eax
  803242:	8b 55 08             	mov    0x8(%ebp),%edx
  803245:	89 10                	mov    %edx,(%eax)
  803247:	eb 08                	jmp    803251 <insert_sorted_allocList+0x110>
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	a3 40 60 80 00       	mov    %eax,0x806040
  803251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803254:	8b 55 08             	mov    0x8(%ebp),%edx
  803257:	89 50 04             	mov    %edx,0x4(%eax)
  80325a:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80325f:	40                   	inc    %eax
  803260:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803265:	e9 60 01 00 00       	jmp    8033ca <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	8b 50 08             	mov    0x8(%eax),%edx
  803270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803273:	8b 40 08             	mov    0x8(%eax),%eax
  803276:	39 c2                	cmp    %eax,%edx
  803278:	0f 82 4c 01 00 00    	jb     8033ca <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80327e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803282:	75 14                	jne    803298 <insert_sorted_allocList+0x157>
  803284:	83 ec 04             	sub    $0x4,%esp
  803287:	68 08 52 80 00       	push   $0x805208
  80328c:	6a 73                	push   $0x73
  80328e:	68 b7 51 80 00       	push   $0x8051b7
  803293:	e8 12 e0 ff ff       	call   8012aa <_panic>
  803298:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	89 50 04             	mov    %edx,0x4(%eax)
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	8b 40 04             	mov    0x4(%eax),%eax
  8032aa:	85 c0                	test   %eax,%eax
  8032ac:	74 0c                	je     8032ba <insert_sorted_allocList+0x179>
  8032ae:	a1 44 60 80 00       	mov    0x806044,%eax
  8032b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b6:	89 10                	mov    %edx,(%eax)
  8032b8:	eb 08                	jmp    8032c2 <insert_sorted_allocList+0x181>
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	a3 40 60 80 00       	mov    %eax,0x806040
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	a3 44 60 80 00       	mov    %eax,0x806044
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d3:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8032d8:	40                   	inc    %eax
  8032d9:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8032de:	e9 e7 00 00 00       	jmp    8033ca <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8032e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8032e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8032f0:	a1 40 60 80 00       	mov    0x806040,%eax
  8032f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f8:	e9 9d 00 00 00       	jmp    80339a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	8b 00                	mov    (%eax),%eax
  803302:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	8b 50 08             	mov    0x8(%eax),%edx
  80330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330e:	8b 40 08             	mov    0x8(%eax),%eax
  803311:	39 c2                	cmp    %eax,%edx
  803313:	76 7d                	jbe    803392 <insert_sorted_allocList+0x251>
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	8b 50 08             	mov    0x8(%eax),%edx
  80331b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331e:	8b 40 08             	mov    0x8(%eax),%eax
  803321:	39 c2                	cmp    %eax,%edx
  803323:	73 6d                	jae    803392 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  803325:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803329:	74 06                	je     803331 <insert_sorted_allocList+0x1f0>
  80332b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80332f:	75 14                	jne    803345 <insert_sorted_allocList+0x204>
  803331:	83 ec 04             	sub    $0x4,%esp
  803334:	68 2c 52 80 00       	push   $0x80522c
  803339:	6a 7f                	push   $0x7f
  80333b:	68 b7 51 80 00       	push   $0x8051b7
  803340:	e8 65 df ff ff       	call   8012aa <_panic>
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	8b 10                	mov    (%eax),%edx
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	89 10                	mov    %edx,(%eax)
  80334f:	8b 45 08             	mov    0x8(%ebp),%eax
  803352:	8b 00                	mov    (%eax),%eax
  803354:	85 c0                	test   %eax,%eax
  803356:	74 0b                	je     803363 <insert_sorted_allocList+0x222>
  803358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	8b 55 08             	mov    0x8(%ebp),%edx
  803360:	89 50 04             	mov    %edx,0x4(%eax)
  803363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803366:	8b 55 08             	mov    0x8(%ebp),%edx
  803369:	89 10                	mov    %edx,(%eax)
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803371:	89 50 04             	mov    %edx,0x4(%eax)
  803374:	8b 45 08             	mov    0x8(%ebp),%eax
  803377:	8b 00                	mov    (%eax),%eax
  803379:	85 c0                	test   %eax,%eax
  80337b:	75 08                	jne    803385 <insert_sorted_allocList+0x244>
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	a3 44 60 80 00       	mov    %eax,0x806044
  803385:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80338a:	40                   	inc    %eax
  80338b:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  803390:	eb 39                	jmp    8033cb <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  803392:	a1 48 60 80 00       	mov    0x806048,%eax
  803397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80339a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80339e:	74 07                	je     8033a7 <insert_sorted_allocList+0x266>
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	8b 00                	mov    (%eax),%eax
  8033a5:	eb 05                	jmp    8033ac <insert_sorted_allocList+0x26b>
  8033a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ac:	a3 48 60 80 00       	mov    %eax,0x806048
  8033b1:	a1 48 60 80 00       	mov    0x806048,%eax
  8033b6:	85 c0                	test   %eax,%eax
  8033b8:	0f 85 3f ff ff ff    	jne    8032fd <insert_sorted_allocList+0x1bc>
  8033be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c2:	0f 85 35 ff ff ff    	jne    8032fd <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8033c8:	eb 01                	jmp    8033cb <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8033ca:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8033cb:	90                   	nop
  8033cc:	c9                   	leave  
  8033cd:	c3                   	ret    

008033ce <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8033ce:	55                   	push   %ebp
  8033cf:	89 e5                	mov    %esp,%ebp
  8033d1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8033d4:	a1 38 61 80 00       	mov    0x806138,%eax
  8033d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033dc:	e9 85 01 00 00       	jmp    803566 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8033e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033ea:	0f 82 6e 01 00 00    	jb     80355e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033f9:	0f 85 8a 00 00 00    	jne    803489 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8033ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803403:	75 17                	jne    80341c <alloc_block_FF+0x4e>
  803405:	83 ec 04             	sub    $0x4,%esp
  803408:	68 60 52 80 00       	push   $0x805260
  80340d:	68 93 00 00 00       	push   $0x93
  803412:	68 b7 51 80 00       	push   $0x8051b7
  803417:	e8 8e de ff ff       	call   8012aa <_panic>
  80341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341f:	8b 00                	mov    (%eax),%eax
  803421:	85 c0                	test   %eax,%eax
  803423:	74 10                	je     803435 <alloc_block_FF+0x67>
  803425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80342d:	8b 52 04             	mov    0x4(%edx),%edx
  803430:	89 50 04             	mov    %edx,0x4(%eax)
  803433:	eb 0b                	jmp    803440 <alloc_block_FF+0x72>
  803435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803438:	8b 40 04             	mov    0x4(%eax),%eax
  80343b:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803443:	8b 40 04             	mov    0x4(%eax),%eax
  803446:	85 c0                	test   %eax,%eax
  803448:	74 0f                	je     803459 <alloc_block_FF+0x8b>
  80344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344d:	8b 40 04             	mov    0x4(%eax),%eax
  803450:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803453:	8b 12                	mov    (%edx),%edx
  803455:	89 10                	mov    %edx,(%eax)
  803457:	eb 0a                	jmp    803463 <alloc_block_FF+0x95>
  803459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	a3 38 61 80 00       	mov    %eax,0x806138
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803476:	a1 44 61 80 00       	mov    0x806144,%eax
  80347b:	48                   	dec    %eax
  80347c:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  803481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803484:	e9 10 01 00 00       	jmp    803599 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  803489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348c:	8b 40 0c             	mov    0xc(%eax),%eax
  80348f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803492:	0f 86 c6 00 00 00    	jbe    80355e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803498:	a1 48 61 80 00       	mov    0x806148,%eax
  80349d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8034a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a3:	8b 50 08             	mov    0x8(%eax),%edx
  8034a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a9:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8034ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034af:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b2:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8034b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034b9:	75 17                	jne    8034d2 <alloc_block_FF+0x104>
  8034bb:	83 ec 04             	sub    $0x4,%esp
  8034be:	68 60 52 80 00       	push   $0x805260
  8034c3:	68 9b 00 00 00       	push   $0x9b
  8034c8:	68 b7 51 80 00       	push   $0x8051b7
  8034cd:	e8 d8 dd ff ff       	call   8012aa <_panic>
  8034d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d5:	8b 00                	mov    (%eax),%eax
  8034d7:	85 c0                	test   %eax,%eax
  8034d9:	74 10                	je     8034eb <alloc_block_FF+0x11d>
  8034db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034de:	8b 00                	mov    (%eax),%eax
  8034e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034e3:	8b 52 04             	mov    0x4(%edx),%edx
  8034e6:	89 50 04             	mov    %edx,0x4(%eax)
  8034e9:	eb 0b                	jmp    8034f6 <alloc_block_FF+0x128>
  8034eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ee:	8b 40 04             	mov    0x4(%eax),%eax
  8034f1:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8034f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f9:	8b 40 04             	mov    0x4(%eax),%eax
  8034fc:	85 c0                	test   %eax,%eax
  8034fe:	74 0f                	je     80350f <alloc_block_FF+0x141>
  803500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803503:	8b 40 04             	mov    0x4(%eax),%eax
  803506:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803509:	8b 12                	mov    (%edx),%edx
  80350b:	89 10                	mov    %edx,(%eax)
  80350d:	eb 0a                	jmp    803519 <alloc_block_FF+0x14b>
  80350f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	a3 48 61 80 00       	mov    %eax,0x806148
  803519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803525:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80352c:	a1 54 61 80 00       	mov    0x806154,%eax
  803531:	48                   	dec    %eax
  803532:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  803537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353a:	8b 50 08             	mov    0x8(%eax),%edx
  80353d:	8b 45 08             	mov    0x8(%ebp),%eax
  803540:	01 c2                	add    %eax,%edx
  803542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803545:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354b:	8b 40 0c             	mov    0xc(%eax),%eax
  80354e:	2b 45 08             	sub    0x8(%ebp),%eax
  803551:	89 c2                	mov    %eax,%edx
  803553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803556:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  803559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355c:	eb 3b                	jmp    803599 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80355e:	a1 40 61 80 00       	mov    0x806140,%eax
  803563:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803566:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80356a:	74 07                	je     803573 <alloc_block_FF+0x1a5>
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 00                	mov    (%eax),%eax
  803571:	eb 05                	jmp    803578 <alloc_block_FF+0x1aa>
  803573:	b8 00 00 00 00       	mov    $0x0,%eax
  803578:	a3 40 61 80 00       	mov    %eax,0x806140
  80357d:	a1 40 61 80 00       	mov    0x806140,%eax
  803582:	85 c0                	test   %eax,%eax
  803584:	0f 85 57 fe ff ff    	jne    8033e1 <alloc_block_FF+0x13>
  80358a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80358e:	0f 85 4d fe ff ff    	jne    8033e1 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  803594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803599:	c9                   	leave  
  80359a:	c3                   	ret    

0080359b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80359b:	55                   	push   %ebp
  80359c:	89 e5                	mov    %esp,%ebp
  80359e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8035a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8035a8:	a1 38 61 80 00       	mov    0x806138,%eax
  8035ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035b0:	e9 df 00 00 00       	jmp    803694 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8035b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8035bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035be:	0f 82 c8 00 00 00    	jb     80368c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035cd:	0f 85 8a 00 00 00    	jne    80365d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8035d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035d7:	75 17                	jne    8035f0 <alloc_block_BF+0x55>
  8035d9:	83 ec 04             	sub    $0x4,%esp
  8035dc:	68 60 52 80 00       	push   $0x805260
  8035e1:	68 b7 00 00 00       	push   $0xb7
  8035e6:	68 b7 51 80 00       	push   $0x8051b7
  8035eb:	e8 ba dc ff ff       	call   8012aa <_panic>
  8035f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f3:	8b 00                	mov    (%eax),%eax
  8035f5:	85 c0                	test   %eax,%eax
  8035f7:	74 10                	je     803609 <alloc_block_BF+0x6e>
  8035f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fc:	8b 00                	mov    (%eax),%eax
  8035fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803601:	8b 52 04             	mov    0x4(%edx),%edx
  803604:	89 50 04             	mov    %edx,0x4(%eax)
  803607:	eb 0b                	jmp    803614 <alloc_block_BF+0x79>
  803609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360c:	8b 40 04             	mov    0x4(%eax),%eax
  80360f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803617:	8b 40 04             	mov    0x4(%eax),%eax
  80361a:	85 c0                	test   %eax,%eax
  80361c:	74 0f                	je     80362d <alloc_block_BF+0x92>
  80361e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803621:	8b 40 04             	mov    0x4(%eax),%eax
  803624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803627:	8b 12                	mov    (%edx),%edx
  803629:	89 10                	mov    %edx,(%eax)
  80362b:	eb 0a                	jmp    803637 <alloc_block_BF+0x9c>
  80362d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803630:	8b 00                	mov    (%eax),%eax
  803632:	a3 38 61 80 00       	mov    %eax,0x806138
  803637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364a:	a1 44 61 80 00       	mov    0x806144,%eax
  80364f:	48                   	dec    %eax
  803650:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  803655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803658:	e9 4d 01 00 00       	jmp    8037aa <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80365d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803660:	8b 40 0c             	mov    0xc(%eax),%eax
  803663:	3b 45 08             	cmp    0x8(%ebp),%eax
  803666:	76 24                	jbe    80368c <alloc_block_BF+0xf1>
  803668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366b:	8b 40 0c             	mov    0xc(%eax),%eax
  80366e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803671:	73 19                	jae    80368c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803673:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367d:	8b 40 0c             	mov    0xc(%eax),%eax
  803680:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803686:	8b 40 08             	mov    0x8(%eax),%eax
  803689:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80368c:	a1 40 61 80 00       	mov    0x806140,%eax
  803691:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803698:	74 07                	je     8036a1 <alloc_block_BF+0x106>
  80369a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369d:	8b 00                	mov    (%eax),%eax
  80369f:	eb 05                	jmp    8036a6 <alloc_block_BF+0x10b>
  8036a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a6:	a3 40 61 80 00       	mov    %eax,0x806140
  8036ab:	a1 40 61 80 00       	mov    0x806140,%eax
  8036b0:	85 c0                	test   %eax,%eax
  8036b2:	0f 85 fd fe ff ff    	jne    8035b5 <alloc_block_BF+0x1a>
  8036b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036bc:	0f 85 f3 fe ff ff    	jne    8035b5 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8036c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036c6:	0f 84 d9 00 00 00    	je     8037a5 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8036cc:	a1 48 61 80 00       	mov    0x806148,%eax
  8036d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8036d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036da:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8036dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e3:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8036e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036ea:	75 17                	jne    803703 <alloc_block_BF+0x168>
  8036ec:	83 ec 04             	sub    $0x4,%esp
  8036ef:	68 60 52 80 00       	push   $0x805260
  8036f4:	68 c7 00 00 00       	push   $0xc7
  8036f9:	68 b7 51 80 00       	push   $0x8051b7
  8036fe:	e8 a7 db ff ff       	call   8012aa <_panic>
  803703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803706:	8b 00                	mov    (%eax),%eax
  803708:	85 c0                	test   %eax,%eax
  80370a:	74 10                	je     80371c <alloc_block_BF+0x181>
  80370c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370f:	8b 00                	mov    (%eax),%eax
  803711:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803714:	8b 52 04             	mov    0x4(%edx),%edx
  803717:	89 50 04             	mov    %edx,0x4(%eax)
  80371a:	eb 0b                	jmp    803727 <alloc_block_BF+0x18c>
  80371c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371f:	8b 40 04             	mov    0x4(%eax),%eax
  803722:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372a:	8b 40 04             	mov    0x4(%eax),%eax
  80372d:	85 c0                	test   %eax,%eax
  80372f:	74 0f                	je     803740 <alloc_block_BF+0x1a5>
  803731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803734:	8b 40 04             	mov    0x4(%eax),%eax
  803737:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80373a:	8b 12                	mov    (%edx),%edx
  80373c:	89 10                	mov    %edx,(%eax)
  80373e:	eb 0a                	jmp    80374a <alloc_block_BF+0x1af>
  803740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803743:	8b 00                	mov    (%eax),%eax
  803745:	a3 48 61 80 00       	mov    %eax,0x806148
  80374a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803756:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375d:	a1 54 61 80 00       	mov    0x806154,%eax
  803762:	48                   	dec    %eax
  803763:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803768:	83 ec 08             	sub    $0x8,%esp
  80376b:	ff 75 ec             	pushl  -0x14(%ebp)
  80376e:	68 38 61 80 00       	push   $0x806138
  803773:	e8 71 f9 ff ff       	call   8030e9 <find_block>
  803778:	83 c4 10             	add    $0x10,%esp
  80377b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80377e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803781:	8b 50 08             	mov    0x8(%eax),%edx
  803784:	8b 45 08             	mov    0x8(%ebp),%eax
  803787:	01 c2                	add    %eax,%edx
  803789:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80378c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80378f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803792:	8b 40 0c             	mov    0xc(%eax),%eax
  803795:	2b 45 08             	sub    0x8(%ebp),%eax
  803798:	89 c2                	mov    %eax,%edx
  80379a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80379d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8037a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a3:	eb 05                	jmp    8037aa <alloc_block_BF+0x20f>
	}
	return NULL;
  8037a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037aa:	c9                   	leave  
  8037ab:	c3                   	ret    

008037ac <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8037ac:	55                   	push   %ebp
  8037ad:	89 e5                	mov    %esp,%ebp
  8037af:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8037b2:	a1 28 60 80 00       	mov    0x806028,%eax
  8037b7:	85 c0                	test   %eax,%eax
  8037b9:	0f 85 de 01 00 00    	jne    80399d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8037bf:	a1 38 61 80 00       	mov    0x806138,%eax
  8037c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037c7:	e9 9e 01 00 00       	jmp    80396a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8037cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037d5:	0f 82 87 01 00 00    	jb     803962 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8037db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037de:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037e4:	0f 85 95 00 00 00    	jne    80387f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8037ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ee:	75 17                	jne    803807 <alloc_block_NF+0x5b>
  8037f0:	83 ec 04             	sub    $0x4,%esp
  8037f3:	68 60 52 80 00       	push   $0x805260
  8037f8:	68 e0 00 00 00       	push   $0xe0
  8037fd:	68 b7 51 80 00       	push   $0x8051b7
  803802:	e8 a3 da ff ff       	call   8012aa <_panic>
  803807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	85 c0                	test   %eax,%eax
  80380e:	74 10                	je     803820 <alloc_block_NF+0x74>
  803810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803813:	8b 00                	mov    (%eax),%eax
  803815:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803818:	8b 52 04             	mov    0x4(%edx),%edx
  80381b:	89 50 04             	mov    %edx,0x4(%eax)
  80381e:	eb 0b                	jmp    80382b <alloc_block_NF+0x7f>
  803820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803823:	8b 40 04             	mov    0x4(%eax),%eax
  803826:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80382b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382e:	8b 40 04             	mov    0x4(%eax),%eax
  803831:	85 c0                	test   %eax,%eax
  803833:	74 0f                	je     803844 <alloc_block_NF+0x98>
  803835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803838:	8b 40 04             	mov    0x4(%eax),%eax
  80383b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80383e:	8b 12                	mov    (%edx),%edx
  803840:	89 10                	mov    %edx,(%eax)
  803842:	eb 0a                	jmp    80384e <alloc_block_NF+0xa2>
  803844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803847:	8b 00                	mov    (%eax),%eax
  803849:	a3 38 61 80 00       	mov    %eax,0x806138
  80384e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803851:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803861:	a1 44 61 80 00       	mov    0x806144,%eax
  803866:	48                   	dec    %eax
  803867:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  80386c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386f:	8b 40 08             	mov    0x8(%eax),%eax
  803872:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  803877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387a:	e9 f8 04 00 00       	jmp    803d77 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80387f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803882:	8b 40 0c             	mov    0xc(%eax),%eax
  803885:	3b 45 08             	cmp    0x8(%ebp),%eax
  803888:	0f 86 d4 00 00 00    	jbe    803962 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80388e:	a1 48 61 80 00       	mov    0x806148,%eax
  803893:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803899:	8b 50 08             	mov    0x8(%eax),%edx
  80389c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80389f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8038a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8038a8:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8038ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038af:	75 17                	jne    8038c8 <alloc_block_NF+0x11c>
  8038b1:	83 ec 04             	sub    $0x4,%esp
  8038b4:	68 60 52 80 00       	push   $0x805260
  8038b9:	68 e9 00 00 00       	push   $0xe9
  8038be:	68 b7 51 80 00       	push   $0x8051b7
  8038c3:	e8 e2 d9 ff ff       	call   8012aa <_panic>
  8038c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038cb:	8b 00                	mov    (%eax),%eax
  8038cd:	85 c0                	test   %eax,%eax
  8038cf:	74 10                	je     8038e1 <alloc_block_NF+0x135>
  8038d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d4:	8b 00                	mov    (%eax),%eax
  8038d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038d9:	8b 52 04             	mov    0x4(%edx),%edx
  8038dc:	89 50 04             	mov    %edx,0x4(%eax)
  8038df:	eb 0b                	jmp    8038ec <alloc_block_NF+0x140>
  8038e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e4:	8b 40 04             	mov    0x4(%eax),%eax
  8038e7:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8038ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ef:	8b 40 04             	mov    0x4(%eax),%eax
  8038f2:	85 c0                	test   %eax,%eax
  8038f4:	74 0f                	je     803905 <alloc_block_NF+0x159>
  8038f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f9:	8b 40 04             	mov    0x4(%eax),%eax
  8038fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038ff:	8b 12                	mov    (%edx),%edx
  803901:	89 10                	mov    %edx,(%eax)
  803903:	eb 0a                	jmp    80390f <alloc_block_NF+0x163>
  803905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803908:	8b 00                	mov    (%eax),%eax
  80390a:	a3 48 61 80 00       	mov    %eax,0x806148
  80390f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803922:	a1 54 61 80 00       	mov    0x806154,%eax
  803927:	48                   	dec    %eax
  803928:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  80392d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803930:	8b 40 08             	mov    0x8(%eax),%eax
  803933:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  803938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393b:	8b 50 08             	mov    0x8(%eax),%edx
  80393e:	8b 45 08             	mov    0x8(%ebp),%eax
  803941:	01 c2                	add    %eax,%edx
  803943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803946:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394c:	8b 40 0c             	mov    0xc(%eax),%eax
  80394f:	2b 45 08             	sub    0x8(%ebp),%eax
  803952:	89 c2                	mov    %eax,%edx
  803954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803957:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80395a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395d:	e9 15 04 00 00       	jmp    803d77 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803962:	a1 40 61 80 00       	mov    0x806140,%eax
  803967:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80396a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80396e:	74 07                	je     803977 <alloc_block_NF+0x1cb>
  803970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803973:	8b 00                	mov    (%eax),%eax
  803975:	eb 05                	jmp    80397c <alloc_block_NF+0x1d0>
  803977:	b8 00 00 00 00       	mov    $0x0,%eax
  80397c:	a3 40 61 80 00       	mov    %eax,0x806140
  803981:	a1 40 61 80 00       	mov    0x806140,%eax
  803986:	85 c0                	test   %eax,%eax
  803988:	0f 85 3e fe ff ff    	jne    8037cc <alloc_block_NF+0x20>
  80398e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803992:	0f 85 34 fe ff ff    	jne    8037cc <alloc_block_NF+0x20>
  803998:	e9 d5 03 00 00       	jmp    803d72 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80399d:	a1 38 61 80 00       	mov    0x806138,%eax
  8039a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039a5:	e9 b1 01 00 00       	jmp    803b5b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8039aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ad:	8b 50 08             	mov    0x8(%eax),%edx
  8039b0:	a1 28 60 80 00       	mov    0x806028,%eax
  8039b5:	39 c2                	cmp    %eax,%edx
  8039b7:	0f 82 96 01 00 00    	jb     803b53 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8039bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8039c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039c6:	0f 82 87 01 00 00    	jb     803b53 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8039cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039d5:	0f 85 95 00 00 00    	jne    803a70 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8039db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039df:	75 17                	jne    8039f8 <alloc_block_NF+0x24c>
  8039e1:	83 ec 04             	sub    $0x4,%esp
  8039e4:	68 60 52 80 00       	push   $0x805260
  8039e9:	68 fc 00 00 00       	push   $0xfc
  8039ee:	68 b7 51 80 00       	push   $0x8051b7
  8039f3:	e8 b2 d8 ff ff       	call   8012aa <_panic>
  8039f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fb:	8b 00                	mov    (%eax),%eax
  8039fd:	85 c0                	test   %eax,%eax
  8039ff:	74 10                	je     803a11 <alloc_block_NF+0x265>
  803a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a04:	8b 00                	mov    (%eax),%eax
  803a06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a09:	8b 52 04             	mov    0x4(%edx),%edx
  803a0c:	89 50 04             	mov    %edx,0x4(%eax)
  803a0f:	eb 0b                	jmp    803a1c <alloc_block_NF+0x270>
  803a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a14:	8b 40 04             	mov    0x4(%eax),%eax
  803a17:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1f:	8b 40 04             	mov    0x4(%eax),%eax
  803a22:	85 c0                	test   %eax,%eax
  803a24:	74 0f                	je     803a35 <alloc_block_NF+0x289>
  803a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a29:	8b 40 04             	mov    0x4(%eax),%eax
  803a2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a2f:	8b 12                	mov    (%edx),%edx
  803a31:	89 10                	mov    %edx,(%eax)
  803a33:	eb 0a                	jmp    803a3f <alloc_block_NF+0x293>
  803a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a38:	8b 00                	mov    (%eax),%eax
  803a3a:	a3 38 61 80 00       	mov    %eax,0x806138
  803a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a52:	a1 44 61 80 00       	mov    0x806144,%eax
  803a57:	48                   	dec    %eax
  803a58:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a60:	8b 40 08             	mov    0x8(%eax),%eax
  803a63:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6b:	e9 07 03 00 00       	jmp    803d77 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a73:	8b 40 0c             	mov    0xc(%eax),%eax
  803a76:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a79:	0f 86 d4 00 00 00    	jbe    803b53 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803a7f:	a1 48 61 80 00       	mov    0x806148,%eax
  803a84:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8a:	8b 50 08             	mov    0x8(%eax),%edx
  803a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a90:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803a93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a96:	8b 55 08             	mov    0x8(%ebp),%edx
  803a99:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803a9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803aa0:	75 17                	jne    803ab9 <alloc_block_NF+0x30d>
  803aa2:	83 ec 04             	sub    $0x4,%esp
  803aa5:	68 60 52 80 00       	push   $0x805260
  803aaa:	68 04 01 00 00       	push   $0x104
  803aaf:	68 b7 51 80 00       	push   $0x8051b7
  803ab4:	e8 f1 d7 ff ff       	call   8012aa <_panic>
  803ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803abc:	8b 00                	mov    (%eax),%eax
  803abe:	85 c0                	test   %eax,%eax
  803ac0:	74 10                	je     803ad2 <alloc_block_NF+0x326>
  803ac2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac5:	8b 00                	mov    (%eax),%eax
  803ac7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803aca:	8b 52 04             	mov    0x4(%edx),%edx
  803acd:	89 50 04             	mov    %edx,0x4(%eax)
  803ad0:	eb 0b                	jmp    803add <alloc_block_NF+0x331>
  803ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ad5:	8b 40 04             	mov    0x4(%eax),%eax
  803ad8:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae0:	8b 40 04             	mov    0x4(%eax),%eax
  803ae3:	85 c0                	test   %eax,%eax
  803ae5:	74 0f                	je     803af6 <alloc_block_NF+0x34a>
  803ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aea:	8b 40 04             	mov    0x4(%eax),%eax
  803aed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803af0:	8b 12                	mov    (%edx),%edx
  803af2:	89 10                	mov    %edx,(%eax)
  803af4:	eb 0a                	jmp    803b00 <alloc_block_NF+0x354>
  803af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af9:	8b 00                	mov    (%eax),%eax
  803afb:	a3 48 61 80 00       	mov    %eax,0x806148
  803b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b13:	a1 54 61 80 00       	mov    0x806154,%eax
  803b18:	48                   	dec    %eax
  803b19:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803b1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b21:	8b 40 08             	mov    0x8(%eax),%eax
  803b24:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2c:	8b 50 08             	mov    0x8(%eax),%edx
  803b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b32:	01 c2                	add    %eax,%edx
  803b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b37:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3d:	8b 40 0c             	mov    0xc(%eax),%eax
  803b40:	2b 45 08             	sub    0x8(%ebp),%eax
  803b43:	89 c2                	mov    %eax,%edx
  803b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b48:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803b4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b4e:	e9 24 02 00 00       	jmp    803d77 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803b53:	a1 40 61 80 00       	mov    0x806140,%eax
  803b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b5f:	74 07                	je     803b68 <alloc_block_NF+0x3bc>
  803b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b64:	8b 00                	mov    (%eax),%eax
  803b66:	eb 05                	jmp    803b6d <alloc_block_NF+0x3c1>
  803b68:	b8 00 00 00 00       	mov    $0x0,%eax
  803b6d:	a3 40 61 80 00       	mov    %eax,0x806140
  803b72:	a1 40 61 80 00       	mov    0x806140,%eax
  803b77:	85 c0                	test   %eax,%eax
  803b79:	0f 85 2b fe ff ff    	jne    8039aa <alloc_block_NF+0x1fe>
  803b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b83:	0f 85 21 fe ff ff    	jne    8039aa <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803b89:	a1 38 61 80 00       	mov    0x806138,%eax
  803b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b91:	e9 ae 01 00 00       	jmp    803d44 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b99:	8b 50 08             	mov    0x8(%eax),%edx
  803b9c:	a1 28 60 80 00       	mov    0x806028,%eax
  803ba1:	39 c2                	cmp    %eax,%edx
  803ba3:	0f 83 93 01 00 00    	jae    803d3c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bac:	8b 40 0c             	mov    0xc(%eax),%eax
  803baf:	3b 45 08             	cmp    0x8(%ebp),%eax
  803bb2:	0f 82 84 01 00 00    	jb     803d3c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbb:	8b 40 0c             	mov    0xc(%eax),%eax
  803bbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  803bc1:	0f 85 95 00 00 00    	jne    803c5c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803bc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bcb:	75 17                	jne    803be4 <alloc_block_NF+0x438>
  803bcd:	83 ec 04             	sub    $0x4,%esp
  803bd0:	68 60 52 80 00       	push   $0x805260
  803bd5:	68 14 01 00 00       	push   $0x114
  803bda:	68 b7 51 80 00       	push   $0x8051b7
  803bdf:	e8 c6 d6 ff ff       	call   8012aa <_panic>
  803be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be7:	8b 00                	mov    (%eax),%eax
  803be9:	85 c0                	test   %eax,%eax
  803beb:	74 10                	je     803bfd <alloc_block_NF+0x451>
  803bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf0:	8b 00                	mov    (%eax),%eax
  803bf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bf5:	8b 52 04             	mov    0x4(%edx),%edx
  803bf8:	89 50 04             	mov    %edx,0x4(%eax)
  803bfb:	eb 0b                	jmp    803c08 <alloc_block_NF+0x45c>
  803bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c00:	8b 40 04             	mov    0x4(%eax),%eax
  803c03:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0b:	8b 40 04             	mov    0x4(%eax),%eax
  803c0e:	85 c0                	test   %eax,%eax
  803c10:	74 0f                	je     803c21 <alloc_block_NF+0x475>
  803c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c15:	8b 40 04             	mov    0x4(%eax),%eax
  803c18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c1b:	8b 12                	mov    (%edx),%edx
  803c1d:	89 10                	mov    %edx,(%eax)
  803c1f:	eb 0a                	jmp    803c2b <alloc_block_NF+0x47f>
  803c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c24:	8b 00                	mov    (%eax),%eax
  803c26:	a3 38 61 80 00       	mov    %eax,0x806138
  803c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c3e:	a1 44 61 80 00       	mov    0x806144,%eax
  803c43:	48                   	dec    %eax
  803c44:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4c:	8b 40 08             	mov    0x8(%eax),%eax
  803c4f:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c57:	e9 1b 01 00 00       	jmp    803d77 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5f:	8b 40 0c             	mov    0xc(%eax),%eax
  803c62:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c65:	0f 86 d1 00 00 00    	jbe    803d3c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803c6b:	a1 48 61 80 00       	mov    0x806148,%eax
  803c70:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c76:	8b 50 08             	mov    0x8(%eax),%edx
  803c79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c7c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c82:	8b 55 08             	mov    0x8(%ebp),%edx
  803c85:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803c88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c8c:	75 17                	jne    803ca5 <alloc_block_NF+0x4f9>
  803c8e:	83 ec 04             	sub    $0x4,%esp
  803c91:	68 60 52 80 00       	push   $0x805260
  803c96:	68 1c 01 00 00       	push   $0x11c
  803c9b:	68 b7 51 80 00       	push   $0x8051b7
  803ca0:	e8 05 d6 ff ff       	call   8012aa <_panic>
  803ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ca8:	8b 00                	mov    (%eax),%eax
  803caa:	85 c0                	test   %eax,%eax
  803cac:	74 10                	je     803cbe <alloc_block_NF+0x512>
  803cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cb1:	8b 00                	mov    (%eax),%eax
  803cb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cb6:	8b 52 04             	mov    0x4(%edx),%edx
  803cb9:	89 50 04             	mov    %edx,0x4(%eax)
  803cbc:	eb 0b                	jmp    803cc9 <alloc_block_NF+0x51d>
  803cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cc1:	8b 40 04             	mov    0x4(%eax),%eax
  803cc4:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ccc:	8b 40 04             	mov    0x4(%eax),%eax
  803ccf:	85 c0                	test   %eax,%eax
  803cd1:	74 0f                	je     803ce2 <alloc_block_NF+0x536>
  803cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cd6:	8b 40 04             	mov    0x4(%eax),%eax
  803cd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cdc:	8b 12                	mov    (%edx),%edx
  803cde:	89 10                	mov    %edx,(%eax)
  803ce0:	eb 0a                	jmp    803cec <alloc_block_NF+0x540>
  803ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ce5:	8b 00                	mov    (%eax),%eax
  803ce7:	a3 48 61 80 00       	mov    %eax,0x806148
  803cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cff:	a1 54 61 80 00       	mov    0x806154,%eax
  803d04:	48                   	dec    %eax
  803d05:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d0d:	8b 40 08             	mov    0x8(%eax),%eax
  803d10:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d18:	8b 50 08             	mov    0x8(%eax),%edx
  803d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1e:	01 c2                	add    %eax,%edx
  803d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d23:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d29:	8b 40 0c             	mov    0xc(%eax),%eax
  803d2c:	2b 45 08             	sub    0x8(%ebp),%eax
  803d2f:	89 c2                	mov    %eax,%edx
  803d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d34:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803d37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d3a:	eb 3b                	jmp    803d77 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803d3c:	a1 40 61 80 00       	mov    0x806140,%eax
  803d41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d48:	74 07                	je     803d51 <alloc_block_NF+0x5a5>
  803d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4d:	8b 00                	mov    (%eax),%eax
  803d4f:	eb 05                	jmp    803d56 <alloc_block_NF+0x5aa>
  803d51:	b8 00 00 00 00       	mov    $0x0,%eax
  803d56:	a3 40 61 80 00       	mov    %eax,0x806140
  803d5b:	a1 40 61 80 00       	mov    0x806140,%eax
  803d60:	85 c0                	test   %eax,%eax
  803d62:	0f 85 2e fe ff ff    	jne    803b96 <alloc_block_NF+0x3ea>
  803d68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d6c:	0f 85 24 fe ff ff    	jne    803b96 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803d72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d77:	c9                   	leave  
  803d78:	c3                   	ret    

00803d79 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803d79:	55                   	push   %ebp
  803d7a:	89 e5                	mov    %esp,%ebp
  803d7c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803d7f:	a1 38 61 80 00       	mov    0x806138,%eax
  803d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803d87:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803d8c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803d8f:	a1 38 61 80 00       	mov    0x806138,%eax
  803d94:	85 c0                	test   %eax,%eax
  803d96:	74 14                	je     803dac <insert_sorted_with_merge_freeList+0x33>
  803d98:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9b:	8b 50 08             	mov    0x8(%eax),%edx
  803d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803da1:	8b 40 08             	mov    0x8(%eax),%eax
  803da4:	39 c2                	cmp    %eax,%edx
  803da6:	0f 87 9b 01 00 00    	ja     803f47 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803dac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803db0:	75 17                	jne    803dc9 <insert_sorted_with_merge_freeList+0x50>
  803db2:	83 ec 04             	sub    $0x4,%esp
  803db5:	68 94 51 80 00       	push   $0x805194
  803dba:	68 38 01 00 00       	push   $0x138
  803dbf:	68 b7 51 80 00       	push   $0x8051b7
  803dc4:	e8 e1 d4 ff ff       	call   8012aa <_panic>
  803dc9:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd2:	89 10                	mov    %edx,(%eax)
  803dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd7:	8b 00                	mov    (%eax),%eax
  803dd9:	85 c0                	test   %eax,%eax
  803ddb:	74 0d                	je     803dea <insert_sorted_with_merge_freeList+0x71>
  803ddd:	a1 38 61 80 00       	mov    0x806138,%eax
  803de2:	8b 55 08             	mov    0x8(%ebp),%edx
  803de5:	89 50 04             	mov    %edx,0x4(%eax)
  803de8:	eb 08                	jmp    803df2 <insert_sorted_with_merge_freeList+0x79>
  803dea:	8b 45 08             	mov    0x8(%ebp),%eax
  803ded:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803df2:	8b 45 08             	mov    0x8(%ebp),%eax
  803df5:	a3 38 61 80 00       	mov    %eax,0x806138
  803dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  803dfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e04:	a1 44 61 80 00       	mov    0x806144,%eax
  803e09:	40                   	inc    %eax
  803e0a:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803e0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e13:	0f 84 a8 06 00 00    	je     8044c1 <insert_sorted_with_merge_freeList+0x748>
  803e19:	8b 45 08             	mov    0x8(%ebp),%eax
  803e1c:	8b 50 08             	mov    0x8(%eax),%edx
  803e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e22:	8b 40 0c             	mov    0xc(%eax),%eax
  803e25:	01 c2                	add    %eax,%edx
  803e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e2a:	8b 40 08             	mov    0x8(%eax),%eax
  803e2d:	39 c2                	cmp    %eax,%edx
  803e2f:	0f 85 8c 06 00 00    	jne    8044c1 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803e35:	8b 45 08             	mov    0x8(%ebp),%eax
  803e38:	8b 50 0c             	mov    0xc(%eax),%edx
  803e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e3e:	8b 40 0c             	mov    0xc(%eax),%eax
  803e41:	01 c2                	add    %eax,%edx
  803e43:	8b 45 08             	mov    0x8(%ebp),%eax
  803e46:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803e49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e4d:	75 17                	jne    803e66 <insert_sorted_with_merge_freeList+0xed>
  803e4f:	83 ec 04             	sub    $0x4,%esp
  803e52:	68 60 52 80 00       	push   $0x805260
  803e57:	68 3c 01 00 00       	push   $0x13c
  803e5c:	68 b7 51 80 00       	push   $0x8051b7
  803e61:	e8 44 d4 ff ff       	call   8012aa <_panic>
  803e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e69:	8b 00                	mov    (%eax),%eax
  803e6b:	85 c0                	test   %eax,%eax
  803e6d:	74 10                	je     803e7f <insert_sorted_with_merge_freeList+0x106>
  803e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e72:	8b 00                	mov    (%eax),%eax
  803e74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e77:	8b 52 04             	mov    0x4(%edx),%edx
  803e7a:	89 50 04             	mov    %edx,0x4(%eax)
  803e7d:	eb 0b                	jmp    803e8a <insert_sorted_with_merge_freeList+0x111>
  803e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e82:	8b 40 04             	mov    0x4(%eax),%eax
  803e85:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e8d:	8b 40 04             	mov    0x4(%eax),%eax
  803e90:	85 c0                	test   %eax,%eax
  803e92:	74 0f                	je     803ea3 <insert_sorted_with_merge_freeList+0x12a>
  803e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e97:	8b 40 04             	mov    0x4(%eax),%eax
  803e9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e9d:	8b 12                	mov    (%edx),%edx
  803e9f:	89 10                	mov    %edx,(%eax)
  803ea1:	eb 0a                	jmp    803ead <insert_sorted_with_merge_freeList+0x134>
  803ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ea6:	8b 00                	mov    (%eax),%eax
  803ea8:	a3 38 61 80 00       	mov    %eax,0x806138
  803ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ec0:	a1 44 61 80 00       	mov    0x806144,%eax
  803ec5:	48                   	dec    %eax
  803ec6:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  803ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ece:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ed8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803edf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ee3:	75 17                	jne    803efc <insert_sorted_with_merge_freeList+0x183>
  803ee5:	83 ec 04             	sub    $0x4,%esp
  803ee8:	68 94 51 80 00       	push   $0x805194
  803eed:	68 3f 01 00 00       	push   $0x13f
  803ef2:	68 b7 51 80 00       	push   $0x8051b7
  803ef7:	e8 ae d3 ff ff       	call   8012aa <_panic>
  803efc:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f05:	89 10                	mov    %edx,(%eax)
  803f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f0a:	8b 00                	mov    (%eax),%eax
  803f0c:	85 c0                	test   %eax,%eax
  803f0e:	74 0d                	je     803f1d <insert_sorted_with_merge_freeList+0x1a4>
  803f10:	a1 48 61 80 00       	mov    0x806148,%eax
  803f15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f18:	89 50 04             	mov    %edx,0x4(%eax)
  803f1b:	eb 08                	jmp    803f25 <insert_sorted_with_merge_freeList+0x1ac>
  803f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f20:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f28:	a3 48 61 80 00       	mov    %eax,0x806148
  803f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f37:	a1 54 61 80 00       	mov    0x806154,%eax
  803f3c:	40                   	inc    %eax
  803f3d:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803f42:	e9 7a 05 00 00       	jmp    8044c1 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803f47:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4a:	8b 50 08             	mov    0x8(%eax),%edx
  803f4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f50:	8b 40 08             	mov    0x8(%eax),%eax
  803f53:	39 c2                	cmp    %eax,%edx
  803f55:	0f 82 14 01 00 00    	jb     80406f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803f5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f5e:	8b 50 08             	mov    0x8(%eax),%edx
  803f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f64:	8b 40 0c             	mov    0xc(%eax),%eax
  803f67:	01 c2                	add    %eax,%edx
  803f69:	8b 45 08             	mov    0x8(%ebp),%eax
  803f6c:	8b 40 08             	mov    0x8(%eax),%eax
  803f6f:	39 c2                	cmp    %eax,%edx
  803f71:	0f 85 90 00 00 00    	jne    804007 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f7a:	8b 50 0c             	mov    0xc(%eax),%edx
  803f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f80:	8b 40 0c             	mov    0xc(%eax),%eax
  803f83:	01 c2                	add    %eax,%edx
  803f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f88:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803f95:	8b 45 08             	mov    0x8(%ebp),%eax
  803f98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803f9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803fa3:	75 17                	jne    803fbc <insert_sorted_with_merge_freeList+0x243>
  803fa5:	83 ec 04             	sub    $0x4,%esp
  803fa8:	68 94 51 80 00       	push   $0x805194
  803fad:	68 49 01 00 00       	push   $0x149
  803fb2:	68 b7 51 80 00       	push   $0x8051b7
  803fb7:	e8 ee d2 ff ff       	call   8012aa <_panic>
  803fbc:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc5:	89 10                	mov    %edx,(%eax)
  803fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803fca:	8b 00                	mov    (%eax),%eax
  803fcc:	85 c0                	test   %eax,%eax
  803fce:	74 0d                	je     803fdd <insert_sorted_with_merge_freeList+0x264>
  803fd0:	a1 48 61 80 00       	mov    0x806148,%eax
  803fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  803fd8:	89 50 04             	mov    %edx,0x4(%eax)
  803fdb:	eb 08                	jmp    803fe5 <insert_sorted_with_merge_freeList+0x26c>
  803fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe0:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe8:	a3 48 61 80 00       	mov    %eax,0x806148
  803fed:	8b 45 08             	mov    0x8(%ebp),%eax
  803ff0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ff7:	a1 54 61 80 00       	mov    0x806154,%eax
  803ffc:	40                   	inc    %eax
  803ffd:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804002:	e9 bb 04 00 00       	jmp    8044c2 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  804007:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80400b:	75 17                	jne    804024 <insert_sorted_with_merge_freeList+0x2ab>
  80400d:	83 ec 04             	sub    $0x4,%esp
  804010:	68 08 52 80 00       	push   $0x805208
  804015:	68 4c 01 00 00       	push   $0x14c
  80401a:	68 b7 51 80 00       	push   $0x8051b7
  80401f:	e8 86 d2 ff ff       	call   8012aa <_panic>
  804024:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  80402a:	8b 45 08             	mov    0x8(%ebp),%eax
  80402d:	89 50 04             	mov    %edx,0x4(%eax)
  804030:	8b 45 08             	mov    0x8(%ebp),%eax
  804033:	8b 40 04             	mov    0x4(%eax),%eax
  804036:	85 c0                	test   %eax,%eax
  804038:	74 0c                	je     804046 <insert_sorted_with_merge_freeList+0x2cd>
  80403a:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80403f:	8b 55 08             	mov    0x8(%ebp),%edx
  804042:	89 10                	mov    %edx,(%eax)
  804044:	eb 08                	jmp    80404e <insert_sorted_with_merge_freeList+0x2d5>
  804046:	8b 45 08             	mov    0x8(%ebp),%eax
  804049:	a3 38 61 80 00       	mov    %eax,0x806138
  80404e:	8b 45 08             	mov    0x8(%ebp),%eax
  804051:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804056:	8b 45 08             	mov    0x8(%ebp),%eax
  804059:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80405f:	a1 44 61 80 00       	mov    0x806144,%eax
  804064:	40                   	inc    %eax
  804065:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80406a:	e9 53 04 00 00       	jmp    8044c2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80406f:	a1 38 61 80 00       	mov    0x806138,%eax
  804074:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804077:	e9 15 04 00 00       	jmp    804491 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80407c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80407f:	8b 00                	mov    (%eax),%eax
  804081:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  804084:	8b 45 08             	mov    0x8(%ebp),%eax
  804087:	8b 50 08             	mov    0x8(%eax),%edx
  80408a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80408d:	8b 40 08             	mov    0x8(%eax),%eax
  804090:	39 c2                	cmp    %eax,%edx
  804092:	0f 86 f1 03 00 00    	jbe    804489 <insert_sorted_with_merge_freeList+0x710>
  804098:	8b 45 08             	mov    0x8(%ebp),%eax
  80409b:	8b 50 08             	mov    0x8(%eax),%edx
  80409e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040a1:	8b 40 08             	mov    0x8(%eax),%eax
  8040a4:	39 c2                	cmp    %eax,%edx
  8040a6:	0f 83 dd 03 00 00    	jae    804489 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8040ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040af:	8b 50 08             	mov    0x8(%eax),%edx
  8040b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8040b8:	01 c2                	add    %eax,%edx
  8040ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8040bd:	8b 40 08             	mov    0x8(%eax),%eax
  8040c0:	39 c2                	cmp    %eax,%edx
  8040c2:	0f 85 b9 01 00 00    	jne    804281 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8040c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8040cb:	8b 50 08             	mov    0x8(%eax),%edx
  8040ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8040d4:	01 c2                	add    %eax,%edx
  8040d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040d9:	8b 40 08             	mov    0x8(%eax),%eax
  8040dc:	39 c2                	cmp    %eax,%edx
  8040de:	0f 85 0d 01 00 00    	jne    8041f1 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8040e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8040ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8040f0:	01 c2                	add    %eax,%edx
  8040f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040f5:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8040f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8040fc:	75 17                	jne    804115 <insert_sorted_with_merge_freeList+0x39c>
  8040fe:	83 ec 04             	sub    $0x4,%esp
  804101:	68 60 52 80 00       	push   $0x805260
  804106:	68 5c 01 00 00       	push   $0x15c
  80410b:	68 b7 51 80 00       	push   $0x8051b7
  804110:	e8 95 d1 ff ff       	call   8012aa <_panic>
  804115:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804118:	8b 00                	mov    (%eax),%eax
  80411a:	85 c0                	test   %eax,%eax
  80411c:	74 10                	je     80412e <insert_sorted_with_merge_freeList+0x3b5>
  80411e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804121:	8b 00                	mov    (%eax),%eax
  804123:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804126:	8b 52 04             	mov    0x4(%edx),%edx
  804129:	89 50 04             	mov    %edx,0x4(%eax)
  80412c:	eb 0b                	jmp    804139 <insert_sorted_with_merge_freeList+0x3c0>
  80412e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804131:	8b 40 04             	mov    0x4(%eax),%eax
  804134:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80413c:	8b 40 04             	mov    0x4(%eax),%eax
  80413f:	85 c0                	test   %eax,%eax
  804141:	74 0f                	je     804152 <insert_sorted_with_merge_freeList+0x3d9>
  804143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804146:	8b 40 04             	mov    0x4(%eax),%eax
  804149:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80414c:	8b 12                	mov    (%edx),%edx
  80414e:	89 10                	mov    %edx,(%eax)
  804150:	eb 0a                	jmp    80415c <insert_sorted_with_merge_freeList+0x3e3>
  804152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804155:	8b 00                	mov    (%eax),%eax
  804157:	a3 38 61 80 00       	mov    %eax,0x806138
  80415c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80415f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804165:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804168:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80416f:	a1 44 61 80 00       	mov    0x806144,%eax
  804174:	48                   	dec    %eax
  804175:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  80417a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80417d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  804184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804187:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80418e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804192:	75 17                	jne    8041ab <insert_sorted_with_merge_freeList+0x432>
  804194:	83 ec 04             	sub    $0x4,%esp
  804197:	68 94 51 80 00       	push   $0x805194
  80419c:	68 5f 01 00 00       	push   $0x15f
  8041a1:	68 b7 51 80 00       	push   $0x8051b7
  8041a6:	e8 ff d0 ff ff       	call   8012aa <_panic>
  8041ab:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8041b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041b4:	89 10                	mov    %edx,(%eax)
  8041b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041b9:	8b 00                	mov    (%eax),%eax
  8041bb:	85 c0                	test   %eax,%eax
  8041bd:	74 0d                	je     8041cc <insert_sorted_with_merge_freeList+0x453>
  8041bf:	a1 48 61 80 00       	mov    0x806148,%eax
  8041c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041c7:	89 50 04             	mov    %edx,0x4(%eax)
  8041ca:	eb 08                	jmp    8041d4 <insert_sorted_with_merge_freeList+0x45b>
  8041cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041cf:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8041d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041d7:	a3 48 61 80 00       	mov    %eax,0x806148
  8041dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041e6:	a1 54 61 80 00       	mov    0x806154,%eax
  8041eb:	40                   	inc    %eax
  8041ec:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  8041f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041f4:	8b 50 0c             	mov    0xc(%eax),%edx
  8041f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8041fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8041fd:	01 c2                	add    %eax,%edx
  8041ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804202:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  804205:	8b 45 08             	mov    0x8(%ebp),%eax
  804208:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80420f:	8b 45 08             	mov    0x8(%ebp),%eax
  804212:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  804219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80421d:	75 17                	jne    804236 <insert_sorted_with_merge_freeList+0x4bd>
  80421f:	83 ec 04             	sub    $0x4,%esp
  804222:	68 94 51 80 00       	push   $0x805194
  804227:	68 64 01 00 00       	push   $0x164
  80422c:	68 b7 51 80 00       	push   $0x8051b7
  804231:	e8 74 d0 ff ff       	call   8012aa <_panic>
  804236:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80423c:	8b 45 08             	mov    0x8(%ebp),%eax
  80423f:	89 10                	mov    %edx,(%eax)
  804241:	8b 45 08             	mov    0x8(%ebp),%eax
  804244:	8b 00                	mov    (%eax),%eax
  804246:	85 c0                	test   %eax,%eax
  804248:	74 0d                	je     804257 <insert_sorted_with_merge_freeList+0x4de>
  80424a:	a1 48 61 80 00       	mov    0x806148,%eax
  80424f:	8b 55 08             	mov    0x8(%ebp),%edx
  804252:	89 50 04             	mov    %edx,0x4(%eax)
  804255:	eb 08                	jmp    80425f <insert_sorted_with_merge_freeList+0x4e6>
  804257:	8b 45 08             	mov    0x8(%ebp),%eax
  80425a:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80425f:	8b 45 08             	mov    0x8(%ebp),%eax
  804262:	a3 48 61 80 00       	mov    %eax,0x806148
  804267:	8b 45 08             	mov    0x8(%ebp),%eax
  80426a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804271:	a1 54 61 80 00       	mov    0x806154,%eax
  804276:	40                   	inc    %eax
  804277:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  80427c:	e9 41 02 00 00       	jmp    8044c2 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804281:	8b 45 08             	mov    0x8(%ebp),%eax
  804284:	8b 50 08             	mov    0x8(%eax),%edx
  804287:	8b 45 08             	mov    0x8(%ebp),%eax
  80428a:	8b 40 0c             	mov    0xc(%eax),%eax
  80428d:	01 c2                	add    %eax,%edx
  80428f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804292:	8b 40 08             	mov    0x8(%eax),%eax
  804295:	39 c2                	cmp    %eax,%edx
  804297:	0f 85 7c 01 00 00    	jne    804419 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80429d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8042a1:	74 06                	je     8042a9 <insert_sorted_with_merge_freeList+0x530>
  8042a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042a7:	75 17                	jne    8042c0 <insert_sorted_with_merge_freeList+0x547>
  8042a9:	83 ec 04             	sub    $0x4,%esp
  8042ac:	68 d0 51 80 00       	push   $0x8051d0
  8042b1:	68 69 01 00 00       	push   $0x169
  8042b6:	68 b7 51 80 00       	push   $0x8051b7
  8042bb:	e8 ea cf ff ff       	call   8012aa <_panic>
  8042c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042c3:	8b 50 04             	mov    0x4(%eax),%edx
  8042c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8042c9:	89 50 04             	mov    %edx,0x4(%eax)
  8042cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8042cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042d2:	89 10                	mov    %edx,(%eax)
  8042d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042d7:	8b 40 04             	mov    0x4(%eax),%eax
  8042da:	85 c0                	test   %eax,%eax
  8042dc:	74 0d                	je     8042eb <insert_sorted_with_merge_freeList+0x572>
  8042de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042e1:	8b 40 04             	mov    0x4(%eax),%eax
  8042e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8042e7:	89 10                	mov    %edx,(%eax)
  8042e9:	eb 08                	jmp    8042f3 <insert_sorted_with_merge_freeList+0x57a>
  8042eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ee:	a3 38 61 80 00       	mov    %eax,0x806138
  8042f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8042f9:	89 50 04             	mov    %edx,0x4(%eax)
  8042fc:	a1 44 61 80 00       	mov    0x806144,%eax
  804301:	40                   	inc    %eax
  804302:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  804307:	8b 45 08             	mov    0x8(%ebp),%eax
  80430a:	8b 50 0c             	mov    0xc(%eax),%edx
  80430d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804310:	8b 40 0c             	mov    0xc(%eax),%eax
  804313:	01 c2                	add    %eax,%edx
  804315:	8b 45 08             	mov    0x8(%ebp),%eax
  804318:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80431b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80431f:	75 17                	jne    804338 <insert_sorted_with_merge_freeList+0x5bf>
  804321:	83 ec 04             	sub    $0x4,%esp
  804324:	68 60 52 80 00       	push   $0x805260
  804329:	68 6b 01 00 00       	push   $0x16b
  80432e:	68 b7 51 80 00       	push   $0x8051b7
  804333:	e8 72 cf ff ff       	call   8012aa <_panic>
  804338:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80433b:	8b 00                	mov    (%eax),%eax
  80433d:	85 c0                	test   %eax,%eax
  80433f:	74 10                	je     804351 <insert_sorted_with_merge_freeList+0x5d8>
  804341:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804344:	8b 00                	mov    (%eax),%eax
  804346:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804349:	8b 52 04             	mov    0x4(%edx),%edx
  80434c:	89 50 04             	mov    %edx,0x4(%eax)
  80434f:	eb 0b                	jmp    80435c <insert_sorted_with_merge_freeList+0x5e3>
  804351:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804354:	8b 40 04             	mov    0x4(%eax),%eax
  804357:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80435c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80435f:	8b 40 04             	mov    0x4(%eax),%eax
  804362:	85 c0                	test   %eax,%eax
  804364:	74 0f                	je     804375 <insert_sorted_with_merge_freeList+0x5fc>
  804366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804369:	8b 40 04             	mov    0x4(%eax),%eax
  80436c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80436f:	8b 12                	mov    (%edx),%edx
  804371:	89 10                	mov    %edx,(%eax)
  804373:	eb 0a                	jmp    80437f <insert_sorted_with_merge_freeList+0x606>
  804375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804378:	8b 00                	mov    (%eax),%eax
  80437a:	a3 38 61 80 00       	mov    %eax,0x806138
  80437f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804382:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804388:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80438b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804392:	a1 44 61 80 00       	mov    0x806144,%eax
  804397:	48                   	dec    %eax
  804398:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  80439d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8043a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043aa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8043b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8043b5:	75 17                	jne    8043ce <insert_sorted_with_merge_freeList+0x655>
  8043b7:	83 ec 04             	sub    $0x4,%esp
  8043ba:	68 94 51 80 00       	push   $0x805194
  8043bf:	68 6e 01 00 00       	push   $0x16e
  8043c4:	68 b7 51 80 00       	push   $0x8051b7
  8043c9:	e8 dc ce ff ff       	call   8012aa <_panic>
  8043ce:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8043d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043d7:	89 10                	mov    %edx,(%eax)
  8043d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043dc:	8b 00                	mov    (%eax),%eax
  8043de:	85 c0                	test   %eax,%eax
  8043e0:	74 0d                	je     8043ef <insert_sorted_with_merge_freeList+0x676>
  8043e2:	a1 48 61 80 00       	mov    0x806148,%eax
  8043e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8043ea:	89 50 04             	mov    %edx,0x4(%eax)
  8043ed:	eb 08                	jmp    8043f7 <insert_sorted_with_merge_freeList+0x67e>
  8043ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043f2:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8043f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043fa:	a3 48 61 80 00       	mov    %eax,0x806148
  8043ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804402:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804409:	a1 54 61 80 00       	mov    0x806154,%eax
  80440e:	40                   	inc    %eax
  80440f:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  804414:	e9 a9 00 00 00       	jmp    8044c2 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  804419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80441d:	74 06                	je     804425 <insert_sorted_with_merge_freeList+0x6ac>
  80441f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804423:	75 17                	jne    80443c <insert_sorted_with_merge_freeList+0x6c3>
  804425:	83 ec 04             	sub    $0x4,%esp
  804428:	68 2c 52 80 00       	push   $0x80522c
  80442d:	68 73 01 00 00       	push   $0x173
  804432:	68 b7 51 80 00       	push   $0x8051b7
  804437:	e8 6e ce ff ff       	call   8012aa <_panic>
  80443c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80443f:	8b 10                	mov    (%eax),%edx
  804441:	8b 45 08             	mov    0x8(%ebp),%eax
  804444:	89 10                	mov    %edx,(%eax)
  804446:	8b 45 08             	mov    0x8(%ebp),%eax
  804449:	8b 00                	mov    (%eax),%eax
  80444b:	85 c0                	test   %eax,%eax
  80444d:	74 0b                	je     80445a <insert_sorted_with_merge_freeList+0x6e1>
  80444f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804452:	8b 00                	mov    (%eax),%eax
  804454:	8b 55 08             	mov    0x8(%ebp),%edx
  804457:	89 50 04             	mov    %edx,0x4(%eax)
  80445a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80445d:	8b 55 08             	mov    0x8(%ebp),%edx
  804460:	89 10                	mov    %edx,(%eax)
  804462:	8b 45 08             	mov    0x8(%ebp),%eax
  804465:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804468:	89 50 04             	mov    %edx,0x4(%eax)
  80446b:	8b 45 08             	mov    0x8(%ebp),%eax
  80446e:	8b 00                	mov    (%eax),%eax
  804470:	85 c0                	test   %eax,%eax
  804472:	75 08                	jne    80447c <insert_sorted_with_merge_freeList+0x703>
  804474:	8b 45 08             	mov    0x8(%ebp),%eax
  804477:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80447c:	a1 44 61 80 00       	mov    0x806144,%eax
  804481:	40                   	inc    %eax
  804482:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  804487:	eb 39                	jmp    8044c2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  804489:	a1 40 61 80 00       	mov    0x806140,%eax
  80448e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804495:	74 07                	je     80449e <insert_sorted_with_merge_freeList+0x725>
  804497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80449a:	8b 00                	mov    (%eax),%eax
  80449c:	eb 05                	jmp    8044a3 <insert_sorted_with_merge_freeList+0x72a>
  80449e:	b8 00 00 00 00       	mov    $0x0,%eax
  8044a3:	a3 40 61 80 00       	mov    %eax,0x806140
  8044a8:	a1 40 61 80 00       	mov    0x806140,%eax
  8044ad:	85 c0                	test   %eax,%eax
  8044af:	0f 85 c7 fb ff ff    	jne    80407c <insert_sorted_with_merge_freeList+0x303>
  8044b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044b9:	0f 85 bd fb ff ff    	jne    80407c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8044bf:	eb 01                	jmp    8044c2 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8044c1:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8044c2:	90                   	nop
  8044c3:	c9                   	leave  
  8044c4:	c3                   	ret    
  8044c5:	66 90                	xchg   %ax,%ax
  8044c7:	90                   	nop

008044c8 <__udivdi3>:
  8044c8:	55                   	push   %ebp
  8044c9:	57                   	push   %edi
  8044ca:	56                   	push   %esi
  8044cb:	53                   	push   %ebx
  8044cc:	83 ec 1c             	sub    $0x1c,%esp
  8044cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8044d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8044d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8044df:	89 ca                	mov    %ecx,%edx
  8044e1:	89 f8                	mov    %edi,%eax
  8044e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8044e7:	85 f6                	test   %esi,%esi
  8044e9:	75 2d                	jne    804518 <__udivdi3+0x50>
  8044eb:	39 cf                	cmp    %ecx,%edi
  8044ed:	77 65                	ja     804554 <__udivdi3+0x8c>
  8044ef:	89 fd                	mov    %edi,%ebp
  8044f1:	85 ff                	test   %edi,%edi
  8044f3:	75 0b                	jne    804500 <__udivdi3+0x38>
  8044f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8044fa:	31 d2                	xor    %edx,%edx
  8044fc:	f7 f7                	div    %edi
  8044fe:	89 c5                	mov    %eax,%ebp
  804500:	31 d2                	xor    %edx,%edx
  804502:	89 c8                	mov    %ecx,%eax
  804504:	f7 f5                	div    %ebp
  804506:	89 c1                	mov    %eax,%ecx
  804508:	89 d8                	mov    %ebx,%eax
  80450a:	f7 f5                	div    %ebp
  80450c:	89 cf                	mov    %ecx,%edi
  80450e:	89 fa                	mov    %edi,%edx
  804510:	83 c4 1c             	add    $0x1c,%esp
  804513:	5b                   	pop    %ebx
  804514:	5e                   	pop    %esi
  804515:	5f                   	pop    %edi
  804516:	5d                   	pop    %ebp
  804517:	c3                   	ret    
  804518:	39 ce                	cmp    %ecx,%esi
  80451a:	77 28                	ja     804544 <__udivdi3+0x7c>
  80451c:	0f bd fe             	bsr    %esi,%edi
  80451f:	83 f7 1f             	xor    $0x1f,%edi
  804522:	75 40                	jne    804564 <__udivdi3+0x9c>
  804524:	39 ce                	cmp    %ecx,%esi
  804526:	72 0a                	jb     804532 <__udivdi3+0x6a>
  804528:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80452c:	0f 87 9e 00 00 00    	ja     8045d0 <__udivdi3+0x108>
  804532:	b8 01 00 00 00       	mov    $0x1,%eax
  804537:	89 fa                	mov    %edi,%edx
  804539:	83 c4 1c             	add    $0x1c,%esp
  80453c:	5b                   	pop    %ebx
  80453d:	5e                   	pop    %esi
  80453e:	5f                   	pop    %edi
  80453f:	5d                   	pop    %ebp
  804540:	c3                   	ret    
  804541:	8d 76 00             	lea    0x0(%esi),%esi
  804544:	31 ff                	xor    %edi,%edi
  804546:	31 c0                	xor    %eax,%eax
  804548:	89 fa                	mov    %edi,%edx
  80454a:	83 c4 1c             	add    $0x1c,%esp
  80454d:	5b                   	pop    %ebx
  80454e:	5e                   	pop    %esi
  80454f:	5f                   	pop    %edi
  804550:	5d                   	pop    %ebp
  804551:	c3                   	ret    
  804552:	66 90                	xchg   %ax,%ax
  804554:	89 d8                	mov    %ebx,%eax
  804556:	f7 f7                	div    %edi
  804558:	31 ff                	xor    %edi,%edi
  80455a:	89 fa                	mov    %edi,%edx
  80455c:	83 c4 1c             	add    $0x1c,%esp
  80455f:	5b                   	pop    %ebx
  804560:	5e                   	pop    %esi
  804561:	5f                   	pop    %edi
  804562:	5d                   	pop    %ebp
  804563:	c3                   	ret    
  804564:	bd 20 00 00 00       	mov    $0x20,%ebp
  804569:	89 eb                	mov    %ebp,%ebx
  80456b:	29 fb                	sub    %edi,%ebx
  80456d:	89 f9                	mov    %edi,%ecx
  80456f:	d3 e6                	shl    %cl,%esi
  804571:	89 c5                	mov    %eax,%ebp
  804573:	88 d9                	mov    %bl,%cl
  804575:	d3 ed                	shr    %cl,%ebp
  804577:	89 e9                	mov    %ebp,%ecx
  804579:	09 f1                	or     %esi,%ecx
  80457b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80457f:	89 f9                	mov    %edi,%ecx
  804581:	d3 e0                	shl    %cl,%eax
  804583:	89 c5                	mov    %eax,%ebp
  804585:	89 d6                	mov    %edx,%esi
  804587:	88 d9                	mov    %bl,%cl
  804589:	d3 ee                	shr    %cl,%esi
  80458b:	89 f9                	mov    %edi,%ecx
  80458d:	d3 e2                	shl    %cl,%edx
  80458f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804593:	88 d9                	mov    %bl,%cl
  804595:	d3 e8                	shr    %cl,%eax
  804597:	09 c2                	or     %eax,%edx
  804599:	89 d0                	mov    %edx,%eax
  80459b:	89 f2                	mov    %esi,%edx
  80459d:	f7 74 24 0c          	divl   0xc(%esp)
  8045a1:	89 d6                	mov    %edx,%esi
  8045a3:	89 c3                	mov    %eax,%ebx
  8045a5:	f7 e5                	mul    %ebp
  8045a7:	39 d6                	cmp    %edx,%esi
  8045a9:	72 19                	jb     8045c4 <__udivdi3+0xfc>
  8045ab:	74 0b                	je     8045b8 <__udivdi3+0xf0>
  8045ad:	89 d8                	mov    %ebx,%eax
  8045af:	31 ff                	xor    %edi,%edi
  8045b1:	e9 58 ff ff ff       	jmp    80450e <__udivdi3+0x46>
  8045b6:	66 90                	xchg   %ax,%ax
  8045b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8045bc:	89 f9                	mov    %edi,%ecx
  8045be:	d3 e2                	shl    %cl,%edx
  8045c0:	39 c2                	cmp    %eax,%edx
  8045c2:	73 e9                	jae    8045ad <__udivdi3+0xe5>
  8045c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8045c7:	31 ff                	xor    %edi,%edi
  8045c9:	e9 40 ff ff ff       	jmp    80450e <__udivdi3+0x46>
  8045ce:	66 90                	xchg   %ax,%ax
  8045d0:	31 c0                	xor    %eax,%eax
  8045d2:	e9 37 ff ff ff       	jmp    80450e <__udivdi3+0x46>
  8045d7:	90                   	nop

008045d8 <__umoddi3>:
  8045d8:	55                   	push   %ebp
  8045d9:	57                   	push   %edi
  8045da:	56                   	push   %esi
  8045db:	53                   	push   %ebx
  8045dc:	83 ec 1c             	sub    $0x1c,%esp
  8045df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8045e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8045e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8045eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8045ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8045f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8045f7:	89 f3                	mov    %esi,%ebx
  8045f9:	89 fa                	mov    %edi,%edx
  8045fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045ff:	89 34 24             	mov    %esi,(%esp)
  804602:	85 c0                	test   %eax,%eax
  804604:	75 1a                	jne    804620 <__umoddi3+0x48>
  804606:	39 f7                	cmp    %esi,%edi
  804608:	0f 86 a2 00 00 00    	jbe    8046b0 <__umoddi3+0xd8>
  80460e:	89 c8                	mov    %ecx,%eax
  804610:	89 f2                	mov    %esi,%edx
  804612:	f7 f7                	div    %edi
  804614:	89 d0                	mov    %edx,%eax
  804616:	31 d2                	xor    %edx,%edx
  804618:	83 c4 1c             	add    $0x1c,%esp
  80461b:	5b                   	pop    %ebx
  80461c:	5e                   	pop    %esi
  80461d:	5f                   	pop    %edi
  80461e:	5d                   	pop    %ebp
  80461f:	c3                   	ret    
  804620:	39 f0                	cmp    %esi,%eax
  804622:	0f 87 ac 00 00 00    	ja     8046d4 <__umoddi3+0xfc>
  804628:	0f bd e8             	bsr    %eax,%ebp
  80462b:	83 f5 1f             	xor    $0x1f,%ebp
  80462e:	0f 84 ac 00 00 00    	je     8046e0 <__umoddi3+0x108>
  804634:	bf 20 00 00 00       	mov    $0x20,%edi
  804639:	29 ef                	sub    %ebp,%edi
  80463b:	89 fe                	mov    %edi,%esi
  80463d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804641:	89 e9                	mov    %ebp,%ecx
  804643:	d3 e0                	shl    %cl,%eax
  804645:	89 d7                	mov    %edx,%edi
  804647:	89 f1                	mov    %esi,%ecx
  804649:	d3 ef                	shr    %cl,%edi
  80464b:	09 c7                	or     %eax,%edi
  80464d:	89 e9                	mov    %ebp,%ecx
  80464f:	d3 e2                	shl    %cl,%edx
  804651:	89 14 24             	mov    %edx,(%esp)
  804654:	89 d8                	mov    %ebx,%eax
  804656:	d3 e0                	shl    %cl,%eax
  804658:	89 c2                	mov    %eax,%edx
  80465a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80465e:	d3 e0                	shl    %cl,%eax
  804660:	89 44 24 04          	mov    %eax,0x4(%esp)
  804664:	8b 44 24 08          	mov    0x8(%esp),%eax
  804668:	89 f1                	mov    %esi,%ecx
  80466a:	d3 e8                	shr    %cl,%eax
  80466c:	09 d0                	or     %edx,%eax
  80466e:	d3 eb                	shr    %cl,%ebx
  804670:	89 da                	mov    %ebx,%edx
  804672:	f7 f7                	div    %edi
  804674:	89 d3                	mov    %edx,%ebx
  804676:	f7 24 24             	mull   (%esp)
  804679:	89 c6                	mov    %eax,%esi
  80467b:	89 d1                	mov    %edx,%ecx
  80467d:	39 d3                	cmp    %edx,%ebx
  80467f:	0f 82 87 00 00 00    	jb     80470c <__umoddi3+0x134>
  804685:	0f 84 91 00 00 00    	je     80471c <__umoddi3+0x144>
  80468b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80468f:	29 f2                	sub    %esi,%edx
  804691:	19 cb                	sbb    %ecx,%ebx
  804693:	89 d8                	mov    %ebx,%eax
  804695:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804699:	d3 e0                	shl    %cl,%eax
  80469b:	89 e9                	mov    %ebp,%ecx
  80469d:	d3 ea                	shr    %cl,%edx
  80469f:	09 d0                	or     %edx,%eax
  8046a1:	89 e9                	mov    %ebp,%ecx
  8046a3:	d3 eb                	shr    %cl,%ebx
  8046a5:	89 da                	mov    %ebx,%edx
  8046a7:	83 c4 1c             	add    $0x1c,%esp
  8046aa:	5b                   	pop    %ebx
  8046ab:	5e                   	pop    %esi
  8046ac:	5f                   	pop    %edi
  8046ad:	5d                   	pop    %ebp
  8046ae:	c3                   	ret    
  8046af:	90                   	nop
  8046b0:	89 fd                	mov    %edi,%ebp
  8046b2:	85 ff                	test   %edi,%edi
  8046b4:	75 0b                	jne    8046c1 <__umoddi3+0xe9>
  8046b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8046bb:	31 d2                	xor    %edx,%edx
  8046bd:	f7 f7                	div    %edi
  8046bf:	89 c5                	mov    %eax,%ebp
  8046c1:	89 f0                	mov    %esi,%eax
  8046c3:	31 d2                	xor    %edx,%edx
  8046c5:	f7 f5                	div    %ebp
  8046c7:	89 c8                	mov    %ecx,%eax
  8046c9:	f7 f5                	div    %ebp
  8046cb:	89 d0                	mov    %edx,%eax
  8046cd:	e9 44 ff ff ff       	jmp    804616 <__umoddi3+0x3e>
  8046d2:	66 90                	xchg   %ax,%ax
  8046d4:	89 c8                	mov    %ecx,%eax
  8046d6:	89 f2                	mov    %esi,%edx
  8046d8:	83 c4 1c             	add    $0x1c,%esp
  8046db:	5b                   	pop    %ebx
  8046dc:	5e                   	pop    %esi
  8046dd:	5f                   	pop    %edi
  8046de:	5d                   	pop    %ebp
  8046df:	c3                   	ret    
  8046e0:	3b 04 24             	cmp    (%esp),%eax
  8046e3:	72 06                	jb     8046eb <__umoddi3+0x113>
  8046e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8046e9:	77 0f                	ja     8046fa <__umoddi3+0x122>
  8046eb:	89 f2                	mov    %esi,%edx
  8046ed:	29 f9                	sub    %edi,%ecx
  8046ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8046f3:	89 14 24             	mov    %edx,(%esp)
  8046f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8046fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8046fe:	8b 14 24             	mov    (%esp),%edx
  804701:	83 c4 1c             	add    $0x1c,%esp
  804704:	5b                   	pop    %ebx
  804705:	5e                   	pop    %esi
  804706:	5f                   	pop    %edi
  804707:	5d                   	pop    %ebp
  804708:	c3                   	ret    
  804709:	8d 76 00             	lea    0x0(%esi),%esi
  80470c:	2b 04 24             	sub    (%esp),%eax
  80470f:	19 fa                	sbb    %edi,%edx
  804711:	89 d1                	mov    %edx,%ecx
  804713:	89 c6                	mov    %eax,%esi
  804715:	e9 71 ff ff ff       	jmp    80468b <__umoddi3+0xb3>
  80471a:	66 90                	xchg   %ax,%ax
  80471c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804720:	72 ea                	jb     80470c <__umoddi3+0x134>
  804722:	89 d9                	mov    %ebx,%ecx
  804724:	e9 62 ff ff ff       	jmp    80468b <__umoddi3+0xb3>
