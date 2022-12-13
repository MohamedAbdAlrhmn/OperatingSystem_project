
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
  800062:	68 00 46 80 00       	push   $0x804600
  800067:	e8 f2 14 00 00       	call   80155e <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 47 27 00 00       	call   8027bb <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 df 27 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  8000a1:	68 24 46 80 00       	push   $0x804624
  8000a6:	6a 11                	push   $0x11
  8000a8:	68 54 46 80 00       	push   $0x804654
  8000ad:	e8 f8 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000b5:	e8 01 27 00 00       	call   8027bb <sys_calculate_free_frames>
  8000ba:	29 c3                	sub    %eax,%ebx
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 6c 46 80 00       	push   $0x80466c
  8000cb:	6a 13                	push   $0x13
  8000cd:	68 54 46 80 00       	push   $0x804654
  8000d2:	e8 d3 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256)panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 7f 27 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  8000dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 d8 46 80 00       	push   $0x8046d8
  8000ee:	6a 14                	push   $0x14
  8000f0:	68 54 46 80 00       	push   $0x804654
  8000f5:	e8 b0 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000fa:	e8 bc 26 00 00       	call   8027bb <sys_calculate_free_frames>
  8000ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800102:	e8 54 27 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  800133:	68 24 46 80 00       	push   $0x804624
  800138:	6a 19                	push   $0x19
  80013a:	68 54 46 80 00       	push   $0x804654
  80013f:	e8 66 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800144:	e8 72 26 00 00       	call   8027bb <sys_calculate_free_frames>
  800149:	89 c2                	mov    %eax,%edx
  80014b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014e:	39 c2                	cmp    %eax,%edx
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 6c 46 80 00       	push   $0x80466c
  80015a:	6a 1b                	push   $0x1b
  80015c:	68 54 46 80 00       	push   $0x804654
  800161:	e8 44 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800166:	e8 f0 26 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  80016b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80016e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 d8 46 80 00       	push   $0x8046d8
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 54 46 80 00       	push   $0x804654
  800184:	e8 21 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800189:	e8 2d 26 00 00       	call   8027bb <sys_calculate_free_frames>
  80018e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800191:	e8 c5 26 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  8001c4:	68 24 46 80 00       	push   $0x804624
  8001c9:	6a 21                	push   $0x21
  8001cb:	68 54 46 80 00       	push   $0x804654
  8001d0:	e8 d5 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001d5:	e8 e1 25 00 00       	call   8027bb <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 6c 46 80 00       	push   $0x80466c
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 54 46 80 00       	push   $0x804654
  8001f2:	e8 b3 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8001f7:	e8 5f 26 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  8001fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 d8 46 80 00       	push   $0x8046d8
  80020e:	6a 24                	push   $0x24
  800210:	68 54 46 80 00       	push   $0x804654
  800215:	e8 90 10 00 00       	call   8012aa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80021a:	e8 9c 25 00 00       	call   8027bb <sys_calculate_free_frames>
  80021f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800222:	e8 34 26 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  800259:	68 24 46 80 00       	push   $0x804624
  80025e:	6a 2a                	push   $0x2a
  800260:	68 54 46 80 00       	push   $0x804654
  800265:	e8 40 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026a:	e8 4c 25 00 00       	call   8027bb <sys_calculate_free_frames>
  80026f:	89 c2                	mov    %eax,%edx
  800271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 6c 46 80 00       	push   $0x80466c
  800280:	6a 2c                	push   $0x2c
  800282:	68 54 46 80 00       	push   $0x804654
  800287:	e8 1e 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80028c:	e8 ca 25 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	3d 00 01 00 00       	cmp    $0x100,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 d8 46 80 00       	push   $0x8046d8
  8002a3:	6a 2d                	push   $0x2d
  8002a5:	68 54 46 80 00       	push   $0x804654
  8002aa:	e8 fb 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 07 25 00 00       	call   8027bb <sys_calculate_free_frames>
  8002b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 9f 25 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  8002ed:	68 24 46 80 00       	push   $0x804624
  8002f2:	6a 33                	push   $0x33
  8002f4:	68 54 46 80 00       	push   $0x804654
  8002f9:	e8 ac 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800301:	e8 b5 24 00 00       	call   8027bb <sys_calculate_free_frames>
  800306:	29 c3                	sub    %eax,%ebx
  800308:	89 d8                	mov    %ebx,%eax
  80030a:	83 f8 01             	cmp    $0x1,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 6c 46 80 00       	push   $0x80466c
  800317:	6a 35                	push   $0x35
  800319:	68 54 46 80 00       	push   $0x804654
  80031e:	e8 87 0f 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800323:	e8 33 25 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800328:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 d8 46 80 00       	push   $0x8046d8
  80033a:	6a 36                	push   $0x36
  80033c:	68 54 46 80 00       	push   $0x804654
  800341:	e8 64 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800346:	e8 70 24 00 00       	call   8027bb <sys_calculate_free_frames>
  80034b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80034e:	e8 08 25 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  800389:	68 24 46 80 00       	push   $0x804624
  80038e:	6a 3c                	push   $0x3c
  800390:	68 54 46 80 00       	push   $0x804654
  800395:	e8 10 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039a:	e8 1c 24 00 00       	call   8027bb <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 6c 46 80 00       	push   $0x80466c
  8003b0:	6a 3e                	push   $0x3e
  8003b2:	68 54 46 80 00       	push   $0x804654
  8003b7:	e8 ee 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003bc:	e8 9a 24 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  8003c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 d8 46 80 00       	push   $0x8046d8
  8003d3:	6a 3f                	push   $0x3f
  8003d5:	68 54 46 80 00       	push   $0x804654
  8003da:	e8 cb 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 d7 23 00 00       	call   8027bb <sys_calculate_free_frames>
  8003e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 6f 24 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  800421:	68 24 46 80 00       	push   $0x804624
  800426:	6a 45                	push   $0x45
  800428:	68 54 46 80 00       	push   $0x804654
  80042d:	e8 78 0e 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800432:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800435:	e8 81 23 00 00       	call   8027bb <sys_calculate_free_frames>
  80043a:	29 c3                	sub    %eax,%ebx
  80043c:	89 d8                	mov    %ebx,%eax
  80043e:	83 f8 01             	cmp    $0x1,%eax
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 6c 46 80 00       	push   $0x80466c
  80044b:	6a 47                	push   $0x47
  80044d:	68 54 46 80 00       	push   $0x804654
  800452:	e8 53 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800457:	e8 ff 23 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  80045c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80045f:	3d 00 03 00 00       	cmp    $0x300,%eax
  800464:	74 14                	je     80047a <_main+0x442>
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 d8 46 80 00       	push   $0x8046d8
  80046e:	6a 48                	push   $0x48
  800470:	68 54 46 80 00       	push   $0x804654
  800475:	e8 30 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80047a:	e8 3c 23 00 00       	call   8027bb <sys_calculate_free_frames>
  80047f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800482:	e8 d4 23 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  8004c4:	68 24 46 80 00       	push   $0x804624
  8004c9:	6a 4e                	push   $0x4e
  8004cb:	68 54 46 80 00       	push   $0x804654
  8004d0:	e8 d5 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8004d8:	e8 de 22 00 00       	call   8027bb <sys_calculate_free_frames>
  8004dd:	29 c3                	sub    %eax,%ebx
  8004df:	89 d8                	mov    %ebx,%eax
  8004e1:	83 f8 01             	cmp    $0x1,%eax
  8004e4:	74 14                	je     8004fa <_main+0x4c2>
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 6c 46 80 00       	push   $0x80466c
  8004ee:	6a 50                	push   $0x50
  8004f0:	68 54 46 80 00       	push   $0x804654
  8004f5:	e8 b0 0d 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8004fa:	e8 5c 23 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  8004ff:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800502:	3d 00 03 00 00       	cmp    $0x300,%eax
  800507:	74 14                	je     80051d <_main+0x4e5>
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 d8 46 80 00       	push   $0x8046d8
  800511:	6a 51                	push   $0x51
  800513:	68 54 46 80 00       	push   $0x804654
  800518:	e8 8d 0d 00 00       	call   8012aa <_panic>


		//NEW
		//Filling the remaining size of user heap
		freeFrames = sys_calculate_free_frames() ;
  80051d:	e8 99 22 00 00       	call   8027bb <sys_calculate_free_frames>
  800522:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800525:	e8 31 23 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  80057f:	68 24 46 80 00       	push   $0x804624
  800584:	6a 5a                	push   $0x5a
  800586:	68 54 46 80 00       	push   $0x804654
  80058b:	e8 1a 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800590:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800593:	e8 23 22 00 00       	call   8027bb <sys_calculate_free_frames>
  800598:	29 c3                	sub    %eax,%ebx
  80059a:	89 d8                	mov    %ebx,%eax
  80059c:	83 f8 7c             	cmp    $0x7c,%eax
  80059f:	74 14                	je     8005b5 <_main+0x57d>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 6c 46 80 00       	push   $0x80466c
  8005a9:	6a 5c                	push   $0x5c
  8005ab:	68 54 46 80 00       	push   $0x804654
  8005b0:	e8 f5 0c 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005b5:	e8 a1 22 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  8005ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8005bd:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 d8 46 80 00       	push   $0x8046d8
  8005cc:	6a 5d                	push   $0x5d
  8005ce:	68 54 46 80 00       	push   $0x804654
  8005d3:	e8 d2 0c 00 00       	call   8012aa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 de 21 00 00       	call   8027bb <sys_calculate_free_frames>
  8005dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e0:	e8 76 22 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8005e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	50                   	push   %eax
  8005ef:	e8 6d 1f 00 00       	call   802561 <free>
  8005f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005f7:	e8 5f 22 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  8005fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
  800601:	89 d0                	mov    %edx,%eax
  800603:	3d 00 01 00 00       	cmp    $0x100,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 08 47 80 00       	push   $0x804708
  800612:	6a 68                	push   $0x68
  800614:	68 54 46 80 00       	push   $0x804654
  800619:	e8 8c 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80061e:	e8 98 21 00 00       	call   8027bb <sys_calculate_free_frames>
  800623:	89 c2                	mov    %eax,%edx
  800625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	74 14                	je     800640 <_main+0x608>
  80062c:	83 ec 04             	sub    $0x4,%esp
  80062f:	68 44 47 80 00       	push   $0x804744
  800634:	6a 69                	push   $0x69
  800636:	68 54 46 80 00       	push   $0x804654
  80063b:	e8 6a 0c 00 00       	call   8012aa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800640:	e8 76 21 00 00       	call   8027bb <sys_calculate_free_frames>
  800645:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800648:	e8 0e 22 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800650:	8b 45 90             	mov    -0x70(%ebp),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	50                   	push   %eax
  800657:	e8 05 1f 00 00       	call   802561 <free>
  80065c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80065f:	e8 f7 21 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800667:	29 c2                	sub    %eax,%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800670:	74 14                	je     800686 <_main+0x64e>
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	68 08 47 80 00       	push   $0x804708
  80067a:	6a 70                	push   $0x70
  80067c:	68 54 46 80 00       	push   $0x804654
  800681:	e8 24 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800686:	e8 30 21 00 00       	call   8027bb <sys_calculate_free_frames>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 44 47 80 00       	push   $0x804744
  80069c:	6a 71                	push   $0x71
  80069e:	68 54 46 80 00       	push   $0x804654
  8006a3:	e8 02 0c 00 00       	call   8012aa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006a8:	e8 0e 21 00 00       	call   8027bb <sys_calculate_free_frames>
  8006ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006b0:	e8 a6 21 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8006b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	50                   	push   %eax
  8006bf:	e8 9d 1e 00 00       	call   802561 <free>
  8006c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006c7:	e8 8f 21 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  8006cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cf:	29 c2                	sub    %eax,%edx
  8006d1:	89 d0                	mov    %edx,%eax
  8006d3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006d8:	74 14                	je     8006ee <_main+0x6b6>
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	68 08 47 80 00       	push   $0x804708
  8006e2:	6a 78                	push   $0x78
  8006e4:	68 54 46 80 00       	push   $0x804654
  8006e9:	e8 bc 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006ee:	e8 c8 20 00 00       	call   8027bb <sys_calculate_free_frames>
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f8:	39 c2                	cmp    %eax,%edx
  8006fa:	74 14                	je     800710 <_main+0x6d8>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 44 47 80 00       	push   $0x804744
  800704:	6a 79                	push   $0x79
  800706:	68 54 46 80 00       	push   $0x804654
  80070b:	e8 9a 0b 00 00       	call   8012aa <_panic>

		//NEW
		//free the latest Hole (the big one)
		freeFrames = sys_calculate_free_frames() ;
  800710:	e8 a6 20 00 00       	call   8027bb <sys_calculate_free_frames>
  800715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800718:	e8 3e 21 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  800720:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	50                   	push   %eax
  800727:	e8 35 1e 00 00       	call   802561 <free>
  80072c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
  80072f:	e8 27 21 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
  800739:	89 d0                	mov    %edx,%eax
  80073b:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  800740:	74 17                	je     800759 <_main+0x721>
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	68 08 47 80 00       	push   $0x804708
  80074a:	68 81 00 00 00       	push   $0x81
  80074f:	68 54 46 80 00       	push   $0x804654
  800754:	e8 51 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800759:	e8 5d 20 00 00       	call   8027bb <sys_calculate_free_frames>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800763:	39 c2                	cmp    %eax,%edx
  800765:	74 17                	je     80077e <_main+0x746>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 44 47 80 00       	push   $0x804744
  80076f:	68 82 00 00 00       	push   $0x82
  800774:	68 54 46 80 00       	push   $0x804654
  800779:	e8 2c 0b 00 00       	call   8012aa <_panic>
	}
	int cnt = 0;
  80077e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800785:	e8 31 20 00 00       	call   8027bb <sys_calculate_free_frames>
  80078a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80078d:	e8 c9 20 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  8007c2:	68 24 46 80 00       	push   $0x804624
  8007c7:	68 8e 00 00 00       	push   $0x8e
  8007cc:	68 54 46 80 00       	push   $0x804654
  8007d1:	e8 d4 0a 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8007d6:	e8 e0 1f 00 00       	call   8027bb <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 6c 46 80 00       	push   $0x80466c
  8007ec:	68 90 00 00 00       	push   $0x90
  8007f1:	68 54 46 80 00       	push   $0x804654
  8007f6:	e8 af 0a 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  8007fb:	e8 5b 20 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800800:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800803:	3d 80 00 00 00       	cmp    $0x80,%eax
  800808:	74 17                	je     800821 <_main+0x7e9>
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 d8 46 80 00       	push   $0x8046d8
  800812:	68 91 00 00 00       	push   $0x91
  800817:	68 54 46 80 00       	push   $0x804654
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
  80088b:	e8 2b 1f 00 00       	call   8027bb <sys_calculate_free_frames>
  800890:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800893:	e8 c3 1f 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  8008b3:	e8 81 1d 00 00       	call   802639 <realloc>
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
  8008d2:	68 90 47 80 00       	push   $0x804790
  8008d7:	68 ae 00 00 00       	push   $0xae
  8008dc:	68 54 46 80 00       	push   $0x804654
  8008e1:	e8 c4 09 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008e6:	e8 d0 1e 00 00       	call   8027bb <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 c4 47 80 00       	push   $0x8047c4
  8008fc:	68 b0 00 00 00       	push   $0xb0
  800901:	68 54 46 80 00       	push   $0x804654
  800906:	e8 9f 09 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are re-allocated in PageFile");
  80090b:	e8 4b 1f 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800910:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800913:	83 f8 40             	cmp    $0x40,%eax
  800916:	74 17                	je     80092f <_main+0x8f7>
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 34 48 80 00       	push   $0x804834
  800920:	68 b1 00 00 00       	push   $0xb1
  800925:	68 54 46 80 00       	push   $0x804654
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
  8009b9:	68 68 48 80 00       	push   $0x804868
  8009be:	68 c6 00 00 00       	push   $0xc6
  8009c3:	68 54 46 80 00       	push   $0x804654
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
  8009f7:	68 68 48 80 00       	push   $0x804868
  8009fc:	68 cc 00 00 00       	push   $0xcc
  800a01:	68 54 46 80 00       	push   $0x804654
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
  800a3b:	68 68 48 80 00       	push   $0x804868
  800a40:	68 d2 00 00 00       	push   $0xd2
  800a45:	68 54 46 80 00       	push   $0x804654
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
  800a7e:	68 68 48 80 00       	push   $0x804868
  800a83:	68 d8 00 00 00       	push   $0xd8
  800a88:	68 54 46 80 00       	push   $0x804654
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
  800aa0:	e8 16 1d 00 00       	call   8027bb <sys_calculate_free_frames>
  800aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800aa8:	e8 ae 1d 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800ab0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	50                   	push   %eax
  800ab7:	e8 a5 1a 00 00       	call   802561 <free>
  800abc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800abf:	e8 97 1d 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800ad0:	74 17                	je     800ae9 <_main+0xab1>
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	68 a0 48 80 00       	push   $0x8048a0
  800ada:	68 e0 00 00 00       	push   $0xe0
  800adf:	68 54 46 80 00       	push   $0x804654
  800ae4:	e8 c1 07 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ae9:	e8 cd 1c 00 00       	call   8027bb <sys_calculate_free_frames>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	83 f8 05             	cmp    $0x5,%eax
  800afa:	74 17                	je     800b13 <_main+0xadb>
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	68 44 47 80 00       	push   $0x804744
  800b04:	68 e1 00 00 00       	push   $0xe1
  800b09:	68 54 46 80 00       	push   $0x804654
  800b0e:	e8 97 07 00 00       	call   8012aa <_panic>

		vcprintf("\b\b\b40%", NULL);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	6a 00                	push   $0x0
  800b18:	68 f4 48 80 00       	push   $0x8048f4
  800b1d:	e8 d1 09 00 00       	call   8014f3 <vcprintf>
  800b22:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800b25:	e8 91 1c 00 00       	call   8027bb <sys_calculate_free_frames>
  800b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b2d:	e8 29 1d 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  800b6b:	68 24 46 80 00       	push   $0x804624
  800b70:	68 eb 00 00 00       	push   $0xeb
  800b75:	68 54 46 80 00       	push   $0x804654
  800b7a:	e8 2b 07 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b7f:	e8 37 1c 00 00       	call   8027bb <sys_calculate_free_frames>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	74 17                	je     800ba4 <_main+0xb6c>
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	68 6c 46 80 00       	push   $0x80466c
  800b95:	68 ed 00 00 00       	push   $0xed
  800b9a:	68 54 46 80 00       	push   $0x804654
  800b9f:	e8 06 07 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800ba4:	e8 b2 1c 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800ba9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800bac:	3d 80 01 00 00       	cmp    $0x180,%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 d8 46 80 00       	push   $0x8046d8
  800bbb:	68 ee 00 00 00       	push   $0xee
  800bc0:	68 54 46 80 00       	push   $0x804654
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
  800c3b:	e8 7b 1b 00 00       	call   8027bb <sys_calculate_free_frames>
  800c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 13 1c 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  800c6a:	e8 ca 19 00 00       	call   802639 <realloc>
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
  800c8c:	68 90 47 80 00       	push   $0x804790
  800c91:	68 07 01 00 00       	push   $0x107
  800c96:	68 54 46 80 00       	push   $0x804654
  800c9b:	e8 0a 06 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");

		//if((sys_calculate_free_frames() - freeFrames) != 3) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  800ca0:	e8 b6 1b 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800ca5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cad:	74 17                	je     800cc6 <_main+0xc8e>
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	68 34 48 80 00       	push   $0x804834
  800cb7:	68 0b 01 00 00       	push   $0x10b
  800cbc:	68 54 46 80 00       	push   $0x804654
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
  800d59:	68 68 48 80 00       	push   $0x804868
  800d5e:	68 22 01 00 00       	push   $0x122
  800d63:	68 54 46 80 00       	push   $0x804654
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
  800d97:	68 68 48 80 00       	push   $0x804868
  800d9c:	68 2a 01 00 00       	push   $0x12a
  800da1:	68 54 46 80 00       	push   $0x804654
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
  800ddb:	68 68 48 80 00       	push   $0x804868
  800de0:	68 31 01 00 00       	push   $0x131
  800de5:	68 54 46 80 00       	push   $0x804654
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
  800e1e:	68 68 48 80 00       	push   $0x804868
  800e23:	68 37 01 00 00       	push   $0x137
  800e28:	68 54 46 80 00       	push   $0x804654
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
  800e40:	e8 76 19 00 00       	call   8027bb <sys_calculate_free_frames>
  800e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e48:	e8 0e 1a 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800e50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	e8 05 17 00 00       	call   802561 <free>
  800e5c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e5f:	e8 f7 19 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	3d 80 02 00 00       	cmp    $0x280,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 a0 48 80 00       	push   $0x8048a0
  800e7a:	68 40 01 00 00       	push   $0x140
  800e7f:	68 54 46 80 00       	push   $0x804654
  800e84:	e8 21 04 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b70%", NULL);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	6a 00                	push   $0x0
  800e8e:	68 fb 48 80 00       	push   $0x8048fb
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
  800f02:	e8 b4 18 00 00       	call   8027bb <sys_calculate_free_frames>
  800f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f0a:	e8 4c 19 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
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
  800f25:	e8 0f 17 00 00       	call   802639 <realloc>
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
  800f50:	68 90 47 80 00       	push   $0x804790
  800f55:	68 60 01 00 00       	push   $0x160
  800f5a:	68 54 46 80 00       	push   $0x804654
  800f5f:	e8 46 03 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are re-allocated in PageFile");
  800f64:	e8 f2 18 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  800f69:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f6c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800f71:	74 17                	je     800f8a <_main+0xf52>
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 34 48 80 00       	push   $0x804834
  800f7b:	68 63 01 00 00       	push   $0x163
  800f80:	68 54 46 80 00       	push   $0x804654
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
  801014:	68 68 48 80 00       	push   $0x804868
  801019:	68 79 01 00 00       	push   $0x179
  80101e:	68 54 46 80 00       	push   $0x804654
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
  801052:	68 68 48 80 00       	push   $0x804868
  801057:	68 81 01 00 00       	push   $0x181
  80105c:	68 54 46 80 00       	push   $0x804654
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
  801096:	68 68 48 80 00       	push   $0x804868
  80109b:	68 88 01 00 00       	push   $0x188
  8010a0:	68 54 46 80 00       	push   $0x804654
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
  8010d9:	68 68 48 80 00       	push   $0x804868
  8010de:	68 8e 01 00 00       	push   $0x18e
  8010e3:	68 54 46 80 00       	push   $0x804654
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
  8010fb:	e8 bb 16 00 00       	call   8027bb <sys_calculate_free_frames>
  801100:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801103:	e8 53 17 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  801108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[0]);
  80110b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	e8 4a 14 00 00       	call   802561 <free>
  801117:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  80111a:	e8 3c 17 00 00       	call   80285b <sys_pf_calculate_allocated_pages>
  80111f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112b:	74 17                	je     801144 <_main+0x110c>
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 a0 48 80 00       	push   $0x8048a0
  801135:	68 96 01 00 00       	push   $0x196
  80113a:	68 54 46 80 00       	push   $0x804654
  80113f:	e8 66 01 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 2) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 00                	push   $0x0
  801149:	68 02 49 80 00       	push   $0x804902
  80114e:	e8 a0 03 00 00       	call   8014f3 <vcprintf>
  801153:	83 c4 10             	add    $0x10,%esp
	}

	cprintf("Congratulations!! test realloc [1] completed successfully.\n");
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 0c 49 80 00       	push   $0x80490c
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
  801174:	e8 22 19 00 00       	call   802a9b <sys_getenvindex>
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
  8011df:	e8 c4 16 00 00       	call   8028a8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	68 60 49 80 00       	push   $0x804960
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
  80120f:	68 88 49 80 00       	push   $0x804988
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
  801240:	68 b0 49 80 00       	push   $0x8049b0
  801245:	e8 14 03 00 00       	call   80155e <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80124d:	a1 20 60 80 00       	mov    0x806020,%eax
  801252:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	50                   	push   %eax
  80125c:	68 08 4a 80 00       	push   $0x804a08
  801261:	e8 f8 02 00 00       	call   80155e <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	68 60 49 80 00       	push   $0x804960
  801271:	e8 e8 02 00 00       	call   80155e <cprintf>
  801276:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801279:	e8 44 16 00 00       	call   8028c2 <sys_enable_interrupt>

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
  801291:	e8 d1 17 00 00       	call   802a67 <sys_destroy_env>
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
  8012a2:	e8 26 18 00 00       	call   802acd <sys_exit_env>
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
  8012cb:	68 1c 4a 80 00       	push   $0x804a1c
  8012d0:	e8 89 02 00 00       	call   80155e <cprintf>
  8012d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8012d8:	a1 00 60 80 00       	mov    0x806000,%eax
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	50                   	push   %eax
  8012e4:	68 21 4a 80 00       	push   $0x804a21
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
  801308:	68 3d 4a 80 00       	push   $0x804a3d
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
  801334:	68 40 4a 80 00       	push   $0x804a40
  801339:	6a 26                	push   $0x26
  80133b:	68 8c 4a 80 00       	push   $0x804a8c
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
  801406:	68 98 4a 80 00       	push   $0x804a98
  80140b:	6a 3a                	push   $0x3a
  80140d:	68 8c 4a 80 00       	push   $0x804a8c
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
  801476:	68 ec 4a 80 00       	push   $0x804aec
  80147b:	6a 44                	push   $0x44
  80147d:	68 8c 4a 80 00       	push   $0x804a8c
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
  8014d0:	e8 25 12 00 00       	call   8026fa <sys_cputs>
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
  801547:	e8 ae 11 00 00       	call   8026fa <sys_cputs>
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
  801591:	e8 12 13 00 00       	call   8028a8 <sys_disable_interrupt>
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
  8015b1:	e8 0c 13 00 00       	call   8028c2 <sys_enable_interrupt>
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
  8015fb:	e8 80 2d 00 00       	call   804380 <__udivdi3>
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
  80164b:	e8 40 2e 00 00       	call   804490 <__umoddi3>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	05 54 4d 80 00       	add    $0x804d54,%eax
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
  8017a6:	8b 04 85 78 4d 80 00 	mov    0x804d78(,%eax,4),%eax
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
  801887:	8b 34 9d c0 4b 80 00 	mov    0x804bc0(,%ebx,4),%esi
  80188e:	85 f6                	test   %esi,%esi
  801890:	75 19                	jne    8018ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801892:	53                   	push   %ebx
  801893:	68 65 4d 80 00       	push   $0x804d65
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
  8018ac:	68 6e 4d 80 00       	push   $0x804d6e
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
  8018d9:	be 71 4d 80 00       	mov    $0x804d71,%esi
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
  8022ff:	68 d0 4e 80 00       	push   $0x804ed0
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
  8023cf:	e8 6a 04 00 00       	call   80283e <sys_allocate_chunk>
  8023d4:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8023d7:	a1 20 61 80 00       	mov    0x806120,%eax
  8023dc:	83 ec 0c             	sub    $0xc,%esp
  8023df:	50                   	push   %eax
  8023e0:	e8 df 0a 00 00       	call   802ec4 <initialize_MemBlocksList>
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
  80240d:	68 f5 4e 80 00       	push   $0x804ef5
  802412:	6a 33                	push   $0x33
  802414:	68 13 4f 80 00       	push   $0x804f13
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
  80248c:	68 20 4f 80 00       	push   $0x804f20
  802491:	6a 34                	push   $0x34
  802493:	68 13 4f 80 00       	push   $0x804f13
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
  802524:	e8 e3 06 00 00       	call   802c0c <sys_isUHeapPlacementStrategyFIRSTFIT>
  802529:	85 c0                	test   %eax,%eax
  80252b:	74 11                	je     80253e <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80252d:	83 ec 0c             	sub    $0xc,%esp
  802530:	ff 75 e8             	pushl  -0x18(%ebp)
  802533:	e8 4e 0d 00 00       	call   803286 <alloc_block_FF>
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
  80254a:	e8 aa 0a 00 00       	call   802ff9 <insert_sorted_allocList>
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
  802564:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802567:	83 ec 04             	sub    $0x4,%esp
  80256a:	68 44 4f 80 00       	push   $0x804f44
  80256f:	6a 6f                	push   $0x6f
  802571:	68 13 4f 80 00       	push   $0x804f13
  802576:	e8 2f ed ff ff       	call   8012aa <_panic>

0080257b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	83 ec 38             	sub    $0x38,%esp
  802581:	8b 45 10             	mov    0x10(%ebp),%eax
  802584:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802587:	e8 5c fd ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  80258c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802590:	75 07                	jne    802599 <smalloc+0x1e>
  802592:	b8 00 00 00 00       	mov    $0x0,%eax
  802597:	eb 7c                	jmp    802615 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802599:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8025a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a6:	01 d0                	add    %edx,%eax
  8025a8:	48                   	dec    %eax
  8025a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025af:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b4:	f7 75 f0             	divl   -0x10(%ebp)
  8025b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ba:	29 d0                	sub    %edx,%eax
  8025bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8025bf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8025c6:	e8 41 06 00 00       	call   802c0c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	74 11                	je     8025e0 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8025cf:	83 ec 0c             	sub    $0xc,%esp
  8025d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8025d5:	e8 ac 0c 00 00       	call   803286 <alloc_block_FF>
  8025da:	83 c4 10             	add    $0x10,%esp
  8025dd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8025e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e4:	74 2a                	je     802610 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 40 08             	mov    0x8(%eax),%eax
  8025ec:	89 c2                	mov    %eax,%edx
  8025ee:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8025f2:	52                   	push   %edx
  8025f3:	50                   	push   %eax
  8025f4:	ff 75 0c             	pushl  0xc(%ebp)
  8025f7:	ff 75 08             	pushl  0x8(%ebp)
  8025fa:	e8 92 03 00 00       	call   802991 <sys_createSharedObject>
  8025ff:	83 c4 10             	add    $0x10,%esp
  802602:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  802605:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802609:	74 05                	je     802610 <smalloc+0x95>
			return (void*)virtual_address;
  80260b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260e:	eb 05                	jmp    802615 <smalloc+0x9a>
	}
	return NULL;
  802610:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
  80261a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80261d:	e8 c6 fc ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802622:	83 ec 04             	sub    $0x4,%esp
  802625:	68 68 4f 80 00       	push   $0x804f68
  80262a:	68 b0 00 00 00       	push   $0xb0
  80262f:	68 13 4f 80 00       	push   $0x804f13
  802634:	e8 71 ec ff ff       	call   8012aa <_panic>

00802639 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
  80263c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80263f:	e8 a4 fc ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802644:	83 ec 04             	sub    $0x4,%esp
  802647:	68 8c 4f 80 00       	push   $0x804f8c
  80264c:	68 f4 00 00 00       	push   $0xf4
  802651:	68 13 4f 80 00       	push   $0x804f13
  802656:	e8 4f ec ff ff       	call   8012aa <_panic>

0080265b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802661:	83 ec 04             	sub    $0x4,%esp
  802664:	68 b4 4f 80 00       	push   $0x804fb4
  802669:	68 08 01 00 00       	push   $0x108
  80266e:	68 13 4f 80 00       	push   $0x804f13
  802673:	e8 32 ec ff ff       	call   8012aa <_panic>

00802678 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
  80267b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	68 d8 4f 80 00       	push   $0x804fd8
  802686:	68 13 01 00 00       	push   $0x113
  80268b:	68 13 4f 80 00       	push   $0x804f13
  802690:	e8 15 ec ff ff       	call   8012aa <_panic>

00802695 <shrink>:

}
void shrink(uint32 newSize)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80269b:	83 ec 04             	sub    $0x4,%esp
  80269e:	68 d8 4f 80 00       	push   $0x804fd8
  8026a3:	68 18 01 00 00       	push   $0x118
  8026a8:	68 13 4f 80 00       	push   $0x804f13
  8026ad:	e8 f8 eb ff ff       	call   8012aa <_panic>

008026b2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8026b2:	55                   	push   %ebp
  8026b3:	89 e5                	mov    %esp,%ebp
  8026b5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026b8:	83 ec 04             	sub    $0x4,%esp
  8026bb:	68 d8 4f 80 00       	push   $0x804fd8
  8026c0:	68 1d 01 00 00       	push   $0x11d
  8026c5:	68 13 4f 80 00       	push   $0x804f13
  8026ca:	e8 db eb ff ff       	call   8012aa <_panic>

008026cf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
  8026d2:	57                   	push   %edi
  8026d3:	56                   	push   %esi
  8026d4:	53                   	push   %ebx
  8026d5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026e4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8026e7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8026ea:	cd 30                	int    $0x30
  8026ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8026ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8026f2:	83 c4 10             	add    $0x10,%esp
  8026f5:	5b                   	pop    %ebx
  8026f6:	5e                   	pop    %esi
  8026f7:	5f                   	pop    %edi
  8026f8:	5d                   	pop    %ebp
  8026f9:	c3                   	ret    

008026fa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	83 ec 04             	sub    $0x4,%esp
  802700:	8b 45 10             	mov    0x10(%ebp),%eax
  802703:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802706:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80270a:	8b 45 08             	mov    0x8(%ebp),%eax
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	52                   	push   %edx
  802712:	ff 75 0c             	pushl  0xc(%ebp)
  802715:	50                   	push   %eax
  802716:	6a 00                	push   $0x0
  802718:	e8 b2 ff ff ff       	call   8026cf <syscall>
  80271d:	83 c4 18             	add    $0x18,%esp
}
  802720:	90                   	nop
  802721:	c9                   	leave  
  802722:	c3                   	ret    

00802723 <sys_cgetc>:

int
sys_cgetc(void)
{
  802723:	55                   	push   %ebp
  802724:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802726:	6a 00                	push   $0x0
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 01                	push   $0x1
  802732:	e8 98 ff ff ff       	call   8026cf <syscall>
  802737:	83 c4 18             	add    $0x18,%esp
}
  80273a:	c9                   	leave  
  80273b:	c3                   	ret    

0080273c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80273c:	55                   	push   %ebp
  80273d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80273f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802742:	8b 45 08             	mov    0x8(%ebp),%eax
  802745:	6a 00                	push   $0x0
  802747:	6a 00                	push   $0x0
  802749:	6a 00                	push   $0x0
  80274b:	52                   	push   %edx
  80274c:	50                   	push   %eax
  80274d:	6a 05                	push   $0x5
  80274f:	e8 7b ff ff ff       	call   8026cf <syscall>
  802754:	83 c4 18             	add    $0x18,%esp
}
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
  80275c:	56                   	push   %esi
  80275d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80275e:	8b 75 18             	mov    0x18(%ebp),%esi
  802761:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802764:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802767:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	56                   	push   %esi
  80276e:	53                   	push   %ebx
  80276f:	51                   	push   %ecx
  802770:	52                   	push   %edx
  802771:	50                   	push   %eax
  802772:	6a 06                	push   $0x6
  802774:	e8 56 ff ff ff       	call   8026cf <syscall>
  802779:	83 c4 18             	add    $0x18,%esp
}
  80277c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80277f:	5b                   	pop    %ebx
  802780:	5e                   	pop    %esi
  802781:	5d                   	pop    %ebp
  802782:	c3                   	ret    

00802783 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802786:	8b 55 0c             	mov    0xc(%ebp),%edx
  802789:	8b 45 08             	mov    0x8(%ebp),%eax
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	52                   	push   %edx
  802793:	50                   	push   %eax
  802794:	6a 07                	push   $0x7
  802796:	e8 34 ff ff ff       	call   8026cf <syscall>
  80279b:	83 c4 18             	add    $0x18,%esp
}
  80279e:	c9                   	leave  
  80279f:	c3                   	ret    

008027a0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8027a0:	55                   	push   %ebp
  8027a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	ff 75 0c             	pushl  0xc(%ebp)
  8027ac:	ff 75 08             	pushl  0x8(%ebp)
  8027af:	6a 08                	push   $0x8
  8027b1:	e8 19 ff ff ff       	call   8026cf <syscall>
  8027b6:	83 c4 18             	add    $0x18,%esp
}
  8027b9:	c9                   	leave  
  8027ba:	c3                   	ret    

008027bb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 09                	push   $0x9
  8027ca:	e8 00 ff ff ff       	call   8026cf <syscall>
  8027cf:	83 c4 18             	add    $0x18,%esp
}
  8027d2:	c9                   	leave  
  8027d3:	c3                   	ret    

008027d4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 0a                	push   $0xa
  8027e3:	e8 e7 fe ff ff       	call   8026cf <syscall>
  8027e8:	83 c4 18             	add    $0x18,%esp
}
  8027eb:	c9                   	leave  
  8027ec:	c3                   	ret    

008027ed <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8027f0:	6a 00                	push   $0x0
  8027f2:	6a 00                	push   $0x0
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 00                	push   $0x0
  8027fa:	6a 0b                	push   $0xb
  8027fc:	e8 ce fe ff ff       	call   8026cf <syscall>
  802801:	83 c4 18             	add    $0x18,%esp
}
  802804:	c9                   	leave  
  802805:	c3                   	ret    

00802806 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802809:	6a 00                	push   $0x0
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	ff 75 0c             	pushl  0xc(%ebp)
  802812:	ff 75 08             	pushl  0x8(%ebp)
  802815:	6a 0f                	push   $0xf
  802817:	e8 b3 fe ff ff       	call   8026cf <syscall>
  80281c:	83 c4 18             	add    $0x18,%esp
	return;
  80281f:	90                   	nop
}
  802820:	c9                   	leave  
  802821:	c3                   	ret    

00802822 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802822:	55                   	push   %ebp
  802823:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802825:	6a 00                	push   $0x0
  802827:	6a 00                	push   $0x0
  802829:	6a 00                	push   $0x0
  80282b:	ff 75 0c             	pushl  0xc(%ebp)
  80282e:	ff 75 08             	pushl  0x8(%ebp)
  802831:	6a 10                	push   $0x10
  802833:	e8 97 fe ff ff       	call   8026cf <syscall>
  802838:	83 c4 18             	add    $0x18,%esp
	return ;
  80283b:	90                   	nop
}
  80283c:	c9                   	leave  
  80283d:	c3                   	ret    

0080283e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80283e:	55                   	push   %ebp
  80283f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802841:	6a 00                	push   $0x0
  802843:	6a 00                	push   $0x0
  802845:	ff 75 10             	pushl  0x10(%ebp)
  802848:	ff 75 0c             	pushl  0xc(%ebp)
  80284b:	ff 75 08             	pushl  0x8(%ebp)
  80284e:	6a 11                	push   $0x11
  802850:	e8 7a fe ff ff       	call   8026cf <syscall>
  802855:	83 c4 18             	add    $0x18,%esp
	return ;
  802858:	90                   	nop
}
  802859:	c9                   	leave  
  80285a:	c3                   	ret    

0080285b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80285e:	6a 00                	push   $0x0
  802860:	6a 00                	push   $0x0
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	6a 0c                	push   $0xc
  80286a:	e8 60 fe ff ff       	call   8026cf <syscall>
  80286f:	83 c4 18             	add    $0x18,%esp
}
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802877:	6a 00                	push   $0x0
  802879:	6a 00                	push   $0x0
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	ff 75 08             	pushl  0x8(%ebp)
  802882:	6a 0d                	push   $0xd
  802884:	e8 46 fe ff ff       	call   8026cf <syscall>
  802889:	83 c4 18             	add    $0x18,%esp
}
  80288c:	c9                   	leave  
  80288d:	c3                   	ret    

0080288e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80288e:	55                   	push   %ebp
  80288f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802891:	6a 00                	push   $0x0
  802893:	6a 00                	push   $0x0
  802895:	6a 00                	push   $0x0
  802897:	6a 00                	push   $0x0
  802899:	6a 00                	push   $0x0
  80289b:	6a 0e                	push   $0xe
  80289d:	e8 2d fe ff ff       	call   8026cf <syscall>
  8028a2:	83 c4 18             	add    $0x18,%esp
}
  8028a5:	90                   	nop
  8028a6:	c9                   	leave  
  8028a7:	c3                   	ret    

008028a8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 00                	push   $0x0
  8028af:	6a 00                	push   $0x0
  8028b1:	6a 00                	push   $0x0
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 13                	push   $0x13
  8028b7:	e8 13 fe ff ff       	call   8026cf <syscall>
  8028bc:	83 c4 18             	add    $0x18,%esp
}
  8028bf:	90                   	nop
  8028c0:	c9                   	leave  
  8028c1:	c3                   	ret    

008028c2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8028c2:	55                   	push   %ebp
  8028c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 14                	push   $0x14
  8028d1:	e8 f9 fd ff ff       	call   8026cf <syscall>
  8028d6:	83 c4 18             	add    $0x18,%esp
}
  8028d9:	90                   	nop
  8028da:	c9                   	leave  
  8028db:	c3                   	ret    

008028dc <sys_cputc>:


void
sys_cputc(const char c)
{
  8028dc:	55                   	push   %ebp
  8028dd:	89 e5                	mov    %esp,%ebp
  8028df:	83 ec 04             	sub    $0x4,%esp
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8028e8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028ec:	6a 00                	push   $0x0
  8028ee:	6a 00                	push   $0x0
  8028f0:	6a 00                	push   $0x0
  8028f2:	6a 00                	push   $0x0
  8028f4:	50                   	push   %eax
  8028f5:	6a 15                	push   $0x15
  8028f7:	e8 d3 fd ff ff       	call   8026cf <syscall>
  8028fc:	83 c4 18             	add    $0x18,%esp
}
  8028ff:	90                   	nop
  802900:	c9                   	leave  
  802901:	c3                   	ret    

00802902 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802905:	6a 00                	push   $0x0
  802907:	6a 00                	push   $0x0
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 16                	push   $0x16
  802911:	e8 b9 fd ff ff       	call   8026cf <syscall>
  802916:	83 c4 18             	add    $0x18,%esp
}
  802919:	90                   	nop
  80291a:	c9                   	leave  
  80291b:	c3                   	ret    

0080291c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80291f:	8b 45 08             	mov    0x8(%ebp),%eax
  802922:	6a 00                	push   $0x0
  802924:	6a 00                	push   $0x0
  802926:	6a 00                	push   $0x0
  802928:	ff 75 0c             	pushl  0xc(%ebp)
  80292b:	50                   	push   %eax
  80292c:	6a 17                	push   $0x17
  80292e:	e8 9c fd ff ff       	call   8026cf <syscall>
  802933:	83 c4 18             	add    $0x18,%esp
}
  802936:	c9                   	leave  
  802937:	c3                   	ret    

00802938 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802938:	55                   	push   %ebp
  802939:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80293b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	6a 00                	push   $0x0
  802943:	6a 00                	push   $0x0
  802945:	6a 00                	push   $0x0
  802947:	52                   	push   %edx
  802948:	50                   	push   %eax
  802949:	6a 1a                	push   $0x1a
  80294b:	e8 7f fd ff ff       	call   8026cf <syscall>
  802950:	83 c4 18             	add    $0x18,%esp
}
  802953:	c9                   	leave  
  802954:	c3                   	ret    

00802955 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	6a 00                	push   $0x0
  802960:	6a 00                	push   $0x0
  802962:	6a 00                	push   $0x0
  802964:	52                   	push   %edx
  802965:	50                   	push   %eax
  802966:	6a 18                	push   $0x18
  802968:	e8 62 fd ff ff       	call   8026cf <syscall>
  80296d:	83 c4 18             	add    $0x18,%esp
}
  802970:	90                   	nop
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802976:	8b 55 0c             	mov    0xc(%ebp),%edx
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	52                   	push   %edx
  802983:	50                   	push   %eax
  802984:	6a 19                	push   $0x19
  802986:	e8 44 fd ff ff       	call   8026cf <syscall>
  80298b:	83 c4 18             	add    $0x18,%esp
}
  80298e:	90                   	nop
  80298f:	c9                   	leave  
  802990:	c3                   	ret    

00802991 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802991:	55                   	push   %ebp
  802992:	89 e5                	mov    %esp,%ebp
  802994:	83 ec 04             	sub    $0x4,%esp
  802997:	8b 45 10             	mov    0x10(%ebp),%eax
  80299a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80299d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8029a0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a7:	6a 00                	push   $0x0
  8029a9:	51                   	push   %ecx
  8029aa:	52                   	push   %edx
  8029ab:	ff 75 0c             	pushl  0xc(%ebp)
  8029ae:	50                   	push   %eax
  8029af:	6a 1b                	push   $0x1b
  8029b1:	e8 19 fd ff ff       	call   8026cf <syscall>
  8029b6:	83 c4 18             	add    $0x18,%esp
}
  8029b9:	c9                   	leave  
  8029ba:	c3                   	ret    

008029bb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8029bb:	55                   	push   %ebp
  8029bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8029be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	6a 00                	push   $0x0
  8029c6:	6a 00                	push   $0x0
  8029c8:	6a 00                	push   $0x0
  8029ca:	52                   	push   %edx
  8029cb:	50                   	push   %eax
  8029cc:	6a 1c                	push   $0x1c
  8029ce:	e8 fc fc ff ff       	call   8026cf <syscall>
  8029d3:	83 c4 18             	add    $0x18,%esp
}
  8029d6:	c9                   	leave  
  8029d7:	c3                   	ret    

008029d8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8029d8:	55                   	push   %ebp
  8029d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8029db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	6a 00                	push   $0x0
  8029e6:	6a 00                	push   $0x0
  8029e8:	51                   	push   %ecx
  8029e9:	52                   	push   %edx
  8029ea:	50                   	push   %eax
  8029eb:	6a 1d                	push   $0x1d
  8029ed:	e8 dd fc ff ff       	call   8026cf <syscall>
  8029f2:	83 c4 18             	add    $0x18,%esp
}
  8029f5:	c9                   	leave  
  8029f6:	c3                   	ret    

008029f7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8029fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	52                   	push   %edx
  802a07:	50                   	push   %eax
  802a08:	6a 1e                	push   $0x1e
  802a0a:	e8 c0 fc ff ff       	call   8026cf <syscall>
  802a0f:	83 c4 18             	add    $0x18,%esp
}
  802a12:	c9                   	leave  
  802a13:	c3                   	ret    

00802a14 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802a14:	55                   	push   %ebp
  802a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802a17:	6a 00                	push   $0x0
  802a19:	6a 00                	push   $0x0
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	6a 00                	push   $0x0
  802a21:	6a 1f                	push   $0x1f
  802a23:	e8 a7 fc ff ff       	call   8026cf <syscall>
  802a28:	83 c4 18             	add    $0x18,%esp
}
  802a2b:	c9                   	leave  
  802a2c:	c3                   	ret    

00802a2d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802a2d:	55                   	push   %ebp
  802a2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	6a 00                	push   $0x0
  802a35:	ff 75 14             	pushl  0x14(%ebp)
  802a38:	ff 75 10             	pushl  0x10(%ebp)
  802a3b:	ff 75 0c             	pushl  0xc(%ebp)
  802a3e:	50                   	push   %eax
  802a3f:	6a 20                	push   $0x20
  802a41:	e8 89 fc ff ff       	call   8026cf <syscall>
  802a46:	83 c4 18             	add    $0x18,%esp
}
  802a49:	c9                   	leave  
  802a4a:	c3                   	ret    

00802a4b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802a4b:	55                   	push   %ebp
  802a4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	6a 00                	push   $0x0
  802a53:	6a 00                	push   $0x0
  802a55:	6a 00                	push   $0x0
  802a57:	6a 00                	push   $0x0
  802a59:	50                   	push   %eax
  802a5a:	6a 21                	push   $0x21
  802a5c:	e8 6e fc ff ff       	call   8026cf <syscall>
  802a61:	83 c4 18             	add    $0x18,%esp
}
  802a64:	90                   	nop
  802a65:	c9                   	leave  
  802a66:	c3                   	ret    

00802a67 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802a67:	55                   	push   %ebp
  802a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	6a 00                	push   $0x0
  802a6f:	6a 00                	push   $0x0
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	50                   	push   %eax
  802a76:	6a 22                	push   $0x22
  802a78:	e8 52 fc ff ff       	call   8026cf <syscall>
  802a7d:	83 c4 18             	add    $0x18,%esp
}
  802a80:	c9                   	leave  
  802a81:	c3                   	ret    

00802a82 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802a82:	55                   	push   %ebp
  802a83:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802a85:	6a 00                	push   $0x0
  802a87:	6a 00                	push   $0x0
  802a89:	6a 00                	push   $0x0
  802a8b:	6a 00                	push   $0x0
  802a8d:	6a 00                	push   $0x0
  802a8f:	6a 02                	push   $0x2
  802a91:	e8 39 fc ff ff       	call   8026cf <syscall>
  802a96:	83 c4 18             	add    $0x18,%esp
}
  802a99:	c9                   	leave  
  802a9a:	c3                   	ret    

00802a9b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802a9b:	55                   	push   %ebp
  802a9c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802a9e:	6a 00                	push   $0x0
  802aa0:	6a 00                	push   $0x0
  802aa2:	6a 00                	push   $0x0
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 03                	push   $0x3
  802aaa:	e8 20 fc ff ff       	call   8026cf <syscall>
  802aaf:	83 c4 18             	add    $0x18,%esp
}
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 00                	push   $0x0
  802abd:	6a 00                	push   $0x0
  802abf:	6a 00                	push   $0x0
  802ac1:	6a 04                	push   $0x4
  802ac3:	e8 07 fc ff ff       	call   8026cf <syscall>
  802ac8:	83 c4 18             	add    $0x18,%esp
}
  802acb:	c9                   	leave  
  802acc:	c3                   	ret    

00802acd <sys_exit_env>:


void sys_exit_env(void)
{
  802acd:	55                   	push   %ebp
  802ace:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802ad0:	6a 00                	push   $0x0
  802ad2:	6a 00                	push   $0x0
  802ad4:	6a 00                	push   $0x0
  802ad6:	6a 00                	push   $0x0
  802ad8:	6a 00                	push   $0x0
  802ada:	6a 23                	push   $0x23
  802adc:	e8 ee fb ff ff       	call   8026cf <syscall>
  802ae1:	83 c4 18             	add    $0x18,%esp
}
  802ae4:	90                   	nop
  802ae5:	c9                   	leave  
  802ae6:	c3                   	ret    

00802ae7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802ae7:	55                   	push   %ebp
  802ae8:	89 e5                	mov    %esp,%ebp
  802aea:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802aed:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802af0:	8d 50 04             	lea    0x4(%eax),%edx
  802af3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802af6:	6a 00                	push   $0x0
  802af8:	6a 00                	push   $0x0
  802afa:	6a 00                	push   $0x0
  802afc:	52                   	push   %edx
  802afd:	50                   	push   %eax
  802afe:	6a 24                	push   $0x24
  802b00:	e8 ca fb ff ff       	call   8026cf <syscall>
  802b05:	83 c4 18             	add    $0x18,%esp
	return result;
  802b08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b11:	89 01                	mov    %eax,(%ecx)
  802b13:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	c9                   	leave  
  802b1a:	c2 04 00             	ret    $0x4

00802b1d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802b1d:	55                   	push   %ebp
  802b1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802b20:	6a 00                	push   $0x0
  802b22:	6a 00                	push   $0x0
  802b24:	ff 75 10             	pushl  0x10(%ebp)
  802b27:	ff 75 0c             	pushl  0xc(%ebp)
  802b2a:	ff 75 08             	pushl  0x8(%ebp)
  802b2d:	6a 12                	push   $0x12
  802b2f:	e8 9b fb ff ff       	call   8026cf <syscall>
  802b34:	83 c4 18             	add    $0x18,%esp
	return ;
  802b37:	90                   	nop
}
  802b38:	c9                   	leave  
  802b39:	c3                   	ret    

00802b3a <sys_rcr2>:
uint32 sys_rcr2()
{
  802b3a:	55                   	push   %ebp
  802b3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 25                	push   $0x25
  802b49:	e8 81 fb ff ff       	call   8026cf <syscall>
  802b4e:	83 c4 18             	add    $0x18,%esp
}
  802b51:	c9                   	leave  
  802b52:	c3                   	ret    

00802b53 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802b53:	55                   	push   %ebp
  802b54:	89 e5                	mov    %esp,%ebp
  802b56:	83 ec 04             	sub    $0x4,%esp
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802b5f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802b63:	6a 00                	push   $0x0
  802b65:	6a 00                	push   $0x0
  802b67:	6a 00                	push   $0x0
  802b69:	6a 00                	push   $0x0
  802b6b:	50                   	push   %eax
  802b6c:	6a 26                	push   $0x26
  802b6e:	e8 5c fb ff ff       	call   8026cf <syscall>
  802b73:	83 c4 18             	add    $0x18,%esp
	return ;
  802b76:	90                   	nop
}
  802b77:	c9                   	leave  
  802b78:	c3                   	ret    

00802b79 <rsttst>:
void rsttst()
{
  802b79:	55                   	push   %ebp
  802b7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802b7c:	6a 00                	push   $0x0
  802b7e:	6a 00                	push   $0x0
  802b80:	6a 00                	push   $0x0
  802b82:	6a 00                	push   $0x0
  802b84:	6a 00                	push   $0x0
  802b86:	6a 28                	push   $0x28
  802b88:	e8 42 fb ff ff       	call   8026cf <syscall>
  802b8d:	83 c4 18             	add    $0x18,%esp
	return ;
  802b90:	90                   	nop
}
  802b91:	c9                   	leave  
  802b92:	c3                   	ret    

00802b93 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802b93:	55                   	push   %ebp
  802b94:	89 e5                	mov    %esp,%ebp
  802b96:	83 ec 04             	sub    $0x4,%esp
  802b99:	8b 45 14             	mov    0x14(%ebp),%eax
  802b9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802b9f:	8b 55 18             	mov    0x18(%ebp),%edx
  802ba2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ba6:	52                   	push   %edx
  802ba7:	50                   	push   %eax
  802ba8:	ff 75 10             	pushl  0x10(%ebp)
  802bab:	ff 75 0c             	pushl  0xc(%ebp)
  802bae:	ff 75 08             	pushl  0x8(%ebp)
  802bb1:	6a 27                	push   $0x27
  802bb3:	e8 17 fb ff ff       	call   8026cf <syscall>
  802bb8:	83 c4 18             	add    $0x18,%esp
	return ;
  802bbb:	90                   	nop
}
  802bbc:	c9                   	leave  
  802bbd:	c3                   	ret    

00802bbe <chktst>:
void chktst(uint32 n)
{
  802bbe:	55                   	push   %ebp
  802bbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 00                	push   $0x0
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	ff 75 08             	pushl  0x8(%ebp)
  802bcc:	6a 29                	push   $0x29
  802bce:	e8 fc fa ff ff       	call   8026cf <syscall>
  802bd3:	83 c4 18             	add    $0x18,%esp
	return ;
  802bd6:	90                   	nop
}
  802bd7:	c9                   	leave  
  802bd8:	c3                   	ret    

00802bd9 <inctst>:

void inctst()
{
  802bd9:	55                   	push   %ebp
  802bda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802bdc:	6a 00                	push   $0x0
  802bde:	6a 00                	push   $0x0
  802be0:	6a 00                	push   $0x0
  802be2:	6a 00                	push   $0x0
  802be4:	6a 00                	push   $0x0
  802be6:	6a 2a                	push   $0x2a
  802be8:	e8 e2 fa ff ff       	call   8026cf <syscall>
  802bed:	83 c4 18             	add    $0x18,%esp
	return ;
  802bf0:	90                   	nop
}
  802bf1:	c9                   	leave  
  802bf2:	c3                   	ret    

00802bf3 <gettst>:
uint32 gettst()
{
  802bf3:	55                   	push   %ebp
  802bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802bf6:	6a 00                	push   $0x0
  802bf8:	6a 00                	push   $0x0
  802bfa:	6a 00                	push   $0x0
  802bfc:	6a 00                	push   $0x0
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 2b                	push   $0x2b
  802c02:	e8 c8 fa ff ff       	call   8026cf <syscall>
  802c07:	83 c4 18             	add    $0x18,%esp
}
  802c0a:	c9                   	leave  
  802c0b:	c3                   	ret    

00802c0c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802c0c:	55                   	push   %ebp
  802c0d:	89 e5                	mov    %esp,%ebp
  802c0f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c12:	6a 00                	push   $0x0
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	6a 00                	push   $0x0
  802c1a:	6a 00                	push   $0x0
  802c1c:	6a 2c                	push   $0x2c
  802c1e:	e8 ac fa ff ff       	call   8026cf <syscall>
  802c23:	83 c4 18             	add    $0x18,%esp
  802c26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802c29:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802c2d:	75 07                	jne    802c36 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802c2f:	b8 01 00 00 00       	mov    $0x1,%eax
  802c34:	eb 05                	jmp    802c3b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802c36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c3b:	c9                   	leave  
  802c3c:	c3                   	ret    

00802c3d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802c3d:	55                   	push   %ebp
  802c3e:	89 e5                	mov    %esp,%ebp
  802c40:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c43:	6a 00                	push   $0x0
  802c45:	6a 00                	push   $0x0
  802c47:	6a 00                	push   $0x0
  802c49:	6a 00                	push   $0x0
  802c4b:	6a 00                	push   $0x0
  802c4d:	6a 2c                	push   $0x2c
  802c4f:	e8 7b fa ff ff       	call   8026cf <syscall>
  802c54:	83 c4 18             	add    $0x18,%esp
  802c57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802c5a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802c5e:	75 07                	jne    802c67 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802c60:	b8 01 00 00 00       	mov    $0x1,%eax
  802c65:	eb 05                	jmp    802c6c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802c67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c6c:	c9                   	leave  
  802c6d:	c3                   	ret    

00802c6e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802c6e:	55                   	push   %ebp
  802c6f:	89 e5                	mov    %esp,%ebp
  802c71:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c74:	6a 00                	push   $0x0
  802c76:	6a 00                	push   $0x0
  802c78:	6a 00                	push   $0x0
  802c7a:	6a 00                	push   $0x0
  802c7c:	6a 00                	push   $0x0
  802c7e:	6a 2c                	push   $0x2c
  802c80:	e8 4a fa ff ff       	call   8026cf <syscall>
  802c85:	83 c4 18             	add    $0x18,%esp
  802c88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802c8b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802c8f:	75 07                	jne    802c98 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802c91:	b8 01 00 00 00       	mov    $0x1,%eax
  802c96:	eb 05                	jmp    802c9d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9d:	c9                   	leave  
  802c9e:	c3                   	ret    

00802c9f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802c9f:	55                   	push   %ebp
  802ca0:	89 e5                	mov    %esp,%ebp
  802ca2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ca5:	6a 00                	push   $0x0
  802ca7:	6a 00                	push   $0x0
  802ca9:	6a 00                	push   $0x0
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	6a 2c                	push   $0x2c
  802cb1:	e8 19 fa ff ff       	call   8026cf <syscall>
  802cb6:	83 c4 18             	add    $0x18,%esp
  802cb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802cbc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802cc0:	75 07                	jne    802cc9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  802cc7:	eb 05                	jmp    802cce <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802cc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cce:	c9                   	leave  
  802ccf:	c3                   	ret    

00802cd0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802cd0:	55                   	push   %ebp
  802cd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802cd3:	6a 00                	push   $0x0
  802cd5:	6a 00                	push   $0x0
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	ff 75 08             	pushl  0x8(%ebp)
  802cde:	6a 2d                	push   $0x2d
  802ce0:	e8 ea f9 ff ff       	call   8026cf <syscall>
  802ce5:	83 c4 18             	add    $0x18,%esp
	return ;
  802ce8:	90                   	nop
}
  802ce9:	c9                   	leave  
  802cea:	c3                   	ret    

00802ceb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802ceb:	55                   	push   %ebp
  802cec:	89 e5                	mov    %esp,%ebp
  802cee:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802cef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802cf2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	6a 00                	push   $0x0
  802cfd:	53                   	push   %ebx
  802cfe:	51                   	push   %ecx
  802cff:	52                   	push   %edx
  802d00:	50                   	push   %eax
  802d01:	6a 2e                	push   $0x2e
  802d03:	e8 c7 f9 ff ff       	call   8026cf <syscall>
  802d08:	83 c4 18             	add    $0x18,%esp
}
  802d0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d0e:	c9                   	leave  
  802d0f:	c3                   	ret    

00802d10 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802d10:	55                   	push   %ebp
  802d11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802d13:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	6a 00                	push   $0x0
  802d1b:	6a 00                	push   $0x0
  802d1d:	6a 00                	push   $0x0
  802d1f:	52                   	push   %edx
  802d20:	50                   	push   %eax
  802d21:	6a 2f                	push   $0x2f
  802d23:	e8 a7 f9 ff ff       	call   8026cf <syscall>
  802d28:	83 c4 18             	add    $0x18,%esp
}
  802d2b:	c9                   	leave  
  802d2c:	c3                   	ret    

00802d2d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802d2d:	55                   	push   %ebp
  802d2e:	89 e5                	mov    %esp,%ebp
  802d30:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802d33:	83 ec 0c             	sub    $0xc,%esp
  802d36:	68 e8 4f 80 00       	push   $0x804fe8
  802d3b:	e8 1e e8 ff ff       	call   80155e <cprintf>
  802d40:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802d43:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802d4a:	83 ec 0c             	sub    $0xc,%esp
  802d4d:	68 14 50 80 00       	push   $0x805014
  802d52:	e8 07 e8 ff ff       	call   80155e <cprintf>
  802d57:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802d5a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d5e:	a1 38 61 80 00       	mov    0x806138,%eax
  802d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d66:	eb 56                	jmp    802dbe <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802d68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d6c:	74 1c                	je     802d8a <print_mem_block_lists+0x5d>
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 50 08             	mov    0x8(%eax),%edx
  802d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d77:	8b 48 08             	mov    0x8(%eax),%ecx
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d80:	01 c8                	add    %ecx,%eax
  802d82:	39 c2                	cmp    %eax,%edx
  802d84:	73 04                	jae    802d8a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802d86:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 50 08             	mov    0x8(%eax),%edx
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 40 0c             	mov    0xc(%eax),%eax
  802d96:	01 c2                	add    %eax,%edx
  802d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9b:	8b 40 08             	mov    0x8(%eax),%eax
  802d9e:	83 ec 04             	sub    $0x4,%esp
  802da1:	52                   	push   %edx
  802da2:	50                   	push   %eax
  802da3:	68 29 50 80 00       	push   $0x805029
  802da8:	e8 b1 e7 ff ff       	call   80155e <cprintf>
  802dad:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802db6:	a1 40 61 80 00       	mov    0x806140,%eax
  802dbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc2:	74 07                	je     802dcb <print_mem_block_lists+0x9e>
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 00                	mov    (%eax),%eax
  802dc9:	eb 05                	jmp    802dd0 <print_mem_block_lists+0xa3>
  802dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd0:	a3 40 61 80 00       	mov    %eax,0x806140
  802dd5:	a1 40 61 80 00       	mov    0x806140,%eax
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	75 8a                	jne    802d68 <print_mem_block_lists+0x3b>
  802dde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de2:	75 84                	jne    802d68 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802de4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802de8:	75 10                	jne    802dfa <print_mem_block_lists+0xcd>
  802dea:	83 ec 0c             	sub    $0xc,%esp
  802ded:	68 38 50 80 00       	push   $0x805038
  802df2:	e8 67 e7 ff ff       	call   80155e <cprintf>
  802df7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802dfa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802e01:	83 ec 0c             	sub    $0xc,%esp
  802e04:	68 5c 50 80 00       	push   $0x80505c
  802e09:	e8 50 e7 ff ff       	call   80155e <cprintf>
  802e0e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802e11:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802e15:	a1 40 60 80 00       	mov    0x806040,%eax
  802e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1d:	eb 56                	jmp    802e75 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802e1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e23:	74 1c                	je     802e41 <print_mem_block_lists+0x114>
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	8b 50 08             	mov    0x8(%eax),%edx
  802e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2e:	8b 48 08             	mov    0x8(%eax),%ecx
  802e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e34:	8b 40 0c             	mov    0xc(%eax),%eax
  802e37:	01 c8                	add    %ecx,%eax
  802e39:	39 c2                	cmp    %eax,%edx
  802e3b:	73 04                	jae    802e41 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802e3d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 50 08             	mov    0x8(%eax),%edx
  802e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4d:	01 c2                	add    %eax,%edx
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 40 08             	mov    0x8(%eax),%eax
  802e55:	83 ec 04             	sub    $0x4,%esp
  802e58:	52                   	push   %edx
  802e59:	50                   	push   %eax
  802e5a:	68 29 50 80 00       	push   $0x805029
  802e5f:	e8 fa e6 ff ff       	call   80155e <cprintf>
  802e64:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802e6d:	a1 48 60 80 00       	mov    0x806048,%eax
  802e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e79:	74 07                	je     802e82 <print_mem_block_lists+0x155>
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	eb 05                	jmp    802e87 <print_mem_block_lists+0x15a>
  802e82:	b8 00 00 00 00       	mov    $0x0,%eax
  802e87:	a3 48 60 80 00       	mov    %eax,0x806048
  802e8c:	a1 48 60 80 00       	mov    0x806048,%eax
  802e91:	85 c0                	test   %eax,%eax
  802e93:	75 8a                	jne    802e1f <print_mem_block_lists+0xf2>
  802e95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e99:	75 84                	jne    802e1f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802e9b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802e9f:	75 10                	jne    802eb1 <print_mem_block_lists+0x184>
  802ea1:	83 ec 0c             	sub    $0xc,%esp
  802ea4:	68 74 50 80 00       	push   $0x805074
  802ea9:	e8 b0 e6 ff ff       	call   80155e <cprintf>
  802eae:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802eb1:	83 ec 0c             	sub    $0xc,%esp
  802eb4:	68 e8 4f 80 00       	push   $0x804fe8
  802eb9:	e8 a0 e6 ff ff       	call   80155e <cprintf>
  802ebe:	83 c4 10             	add    $0x10,%esp

}
  802ec1:	90                   	nop
  802ec2:	c9                   	leave  
  802ec3:	c3                   	ret    

00802ec4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802ec4:	55                   	push   %ebp
  802ec5:	89 e5                	mov    %esp,%ebp
  802ec7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802eca:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  802ed1:	00 00 00 
  802ed4:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  802edb:	00 00 00 
  802ede:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  802ee5:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802eef:	e9 9e 00 00 00       	jmp    802f92 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802ef4:	a1 50 60 80 00       	mov    0x806050,%eax
  802ef9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efc:	c1 e2 04             	shl    $0x4,%edx
  802eff:	01 d0                	add    %edx,%eax
  802f01:	85 c0                	test   %eax,%eax
  802f03:	75 14                	jne    802f19 <initialize_MemBlocksList+0x55>
  802f05:	83 ec 04             	sub    $0x4,%esp
  802f08:	68 9c 50 80 00       	push   $0x80509c
  802f0d:	6a 46                	push   $0x46
  802f0f:	68 bf 50 80 00       	push   $0x8050bf
  802f14:	e8 91 e3 ff ff       	call   8012aa <_panic>
  802f19:	a1 50 60 80 00       	mov    0x806050,%eax
  802f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f21:	c1 e2 04             	shl    $0x4,%edx
  802f24:	01 d0                	add    %edx,%eax
  802f26:	8b 15 48 61 80 00    	mov    0x806148,%edx
  802f2c:	89 10                	mov    %edx,(%eax)
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	85 c0                	test   %eax,%eax
  802f32:	74 18                	je     802f4c <initialize_MemBlocksList+0x88>
  802f34:	a1 48 61 80 00       	mov    0x806148,%eax
  802f39:	8b 15 50 60 80 00    	mov    0x806050,%edx
  802f3f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802f42:	c1 e1 04             	shl    $0x4,%ecx
  802f45:	01 ca                	add    %ecx,%edx
  802f47:	89 50 04             	mov    %edx,0x4(%eax)
  802f4a:	eb 12                	jmp    802f5e <initialize_MemBlocksList+0x9a>
  802f4c:	a1 50 60 80 00       	mov    0x806050,%eax
  802f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f54:	c1 e2 04             	shl    $0x4,%edx
  802f57:	01 d0                	add    %edx,%eax
  802f59:	a3 4c 61 80 00       	mov    %eax,0x80614c
  802f5e:	a1 50 60 80 00       	mov    0x806050,%eax
  802f63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f66:	c1 e2 04             	shl    $0x4,%edx
  802f69:	01 d0                	add    %edx,%eax
  802f6b:	a3 48 61 80 00       	mov    %eax,0x806148
  802f70:	a1 50 60 80 00       	mov    0x806050,%eax
  802f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f78:	c1 e2 04             	shl    $0x4,%edx
  802f7b:	01 d0                	add    %edx,%eax
  802f7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f84:	a1 54 61 80 00       	mov    0x806154,%eax
  802f89:	40                   	inc    %eax
  802f8a:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802f8f:	ff 45 f4             	incl   -0xc(%ebp)
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f98:	0f 82 56 ff ff ff    	jb     802ef4 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802f9e:	90                   	nop
  802f9f:	c9                   	leave  
  802fa0:	c3                   	ret    

00802fa1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802fa1:	55                   	push   %ebp
  802fa2:	89 e5                	mov    %esp,%ebp
  802fa4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	8b 00                	mov    (%eax),%eax
  802fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802faf:	eb 19                	jmp    802fca <find_block+0x29>
	{
		if(va==point->sva)
  802fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fb4:	8b 40 08             	mov    0x8(%eax),%eax
  802fb7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fba:	75 05                	jne    802fc1 <find_block+0x20>
		   return point;
  802fbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fbf:	eb 36                	jmp    802ff7 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	8b 40 08             	mov    0x8(%eax),%eax
  802fc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802fca:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802fce:	74 07                	je     802fd7 <find_block+0x36>
  802fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fd3:	8b 00                	mov    (%eax),%eax
  802fd5:	eb 05                	jmp    802fdc <find_block+0x3b>
  802fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  802fdf:	89 42 08             	mov    %eax,0x8(%edx)
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	8b 40 08             	mov    0x8(%eax),%eax
  802fe8:	85 c0                	test   %eax,%eax
  802fea:	75 c5                	jne    802fb1 <find_block+0x10>
  802fec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ff0:	75 bf                	jne    802fb1 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802ff2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff7:	c9                   	leave  
  802ff8:	c3                   	ret    

00802ff9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802ff9:	55                   	push   %ebp
  802ffa:	89 e5                	mov    %esp,%ebp
  802ffc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802fff:	a1 40 60 80 00       	mov    0x806040,%eax
  803004:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  803007:	a1 44 60 80 00       	mov    0x806044,%eax
  80300c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80300f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803012:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803015:	74 24                	je     80303b <insert_sorted_allocList+0x42>
  803017:	8b 45 08             	mov    0x8(%ebp),%eax
  80301a:	8b 50 08             	mov    0x8(%eax),%edx
  80301d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803020:	8b 40 08             	mov    0x8(%eax),%eax
  803023:	39 c2                	cmp    %eax,%edx
  803025:	76 14                	jbe    80303b <insert_sorted_allocList+0x42>
  803027:	8b 45 08             	mov    0x8(%ebp),%eax
  80302a:	8b 50 08             	mov    0x8(%eax),%edx
  80302d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803030:	8b 40 08             	mov    0x8(%eax),%eax
  803033:	39 c2                	cmp    %eax,%edx
  803035:	0f 82 60 01 00 00    	jb     80319b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80303b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80303f:	75 65                	jne    8030a6 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  803041:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803045:	75 14                	jne    80305b <insert_sorted_allocList+0x62>
  803047:	83 ec 04             	sub    $0x4,%esp
  80304a:	68 9c 50 80 00       	push   $0x80509c
  80304f:	6a 6b                	push   $0x6b
  803051:	68 bf 50 80 00       	push   $0x8050bf
  803056:	e8 4f e2 ff ff       	call   8012aa <_panic>
  80305b:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	89 10                	mov    %edx,(%eax)
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	8b 00                	mov    (%eax),%eax
  80306b:	85 c0                	test   %eax,%eax
  80306d:	74 0d                	je     80307c <insert_sorted_allocList+0x83>
  80306f:	a1 40 60 80 00       	mov    0x806040,%eax
  803074:	8b 55 08             	mov    0x8(%ebp),%edx
  803077:	89 50 04             	mov    %edx,0x4(%eax)
  80307a:	eb 08                	jmp    803084 <insert_sorted_allocList+0x8b>
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	a3 44 60 80 00       	mov    %eax,0x806044
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	a3 40 60 80 00       	mov    %eax,0x806040
  80308c:	8b 45 08             	mov    0x8(%ebp),%eax
  80308f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803096:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80309b:	40                   	inc    %eax
  80309c:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8030a1:	e9 dc 01 00 00       	jmp    803282 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	8b 50 08             	mov    0x8(%eax),%edx
  8030ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030af:	8b 40 08             	mov    0x8(%eax),%eax
  8030b2:	39 c2                	cmp    %eax,%edx
  8030b4:	77 6c                	ja     803122 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8030b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ba:	74 06                	je     8030c2 <insert_sorted_allocList+0xc9>
  8030bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c0:	75 14                	jne    8030d6 <insert_sorted_allocList+0xdd>
  8030c2:	83 ec 04             	sub    $0x4,%esp
  8030c5:	68 d8 50 80 00       	push   $0x8050d8
  8030ca:	6a 6f                	push   $0x6f
  8030cc:	68 bf 50 80 00       	push   $0x8050bf
  8030d1:	e8 d4 e1 ff ff       	call   8012aa <_panic>
  8030d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d9:	8b 50 04             	mov    0x4(%eax),%edx
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	89 50 04             	mov    %edx,0x4(%eax)
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030e8:	89 10                	mov    %edx,(%eax)
  8030ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ed:	8b 40 04             	mov    0x4(%eax),%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	74 0d                	je     803101 <insert_sorted_allocList+0x108>
  8030f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f7:	8b 40 04             	mov    0x4(%eax),%eax
  8030fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fd:	89 10                	mov    %edx,(%eax)
  8030ff:	eb 08                	jmp    803109 <insert_sorted_allocList+0x110>
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	a3 40 60 80 00       	mov    %eax,0x806040
  803109:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310c:	8b 55 08             	mov    0x8(%ebp),%edx
  80310f:	89 50 04             	mov    %edx,0x4(%eax)
  803112:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803117:	40                   	inc    %eax
  803118:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80311d:	e9 60 01 00 00       	jmp    803282 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	8b 50 08             	mov    0x8(%eax),%edx
  803128:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312b:	8b 40 08             	mov    0x8(%eax),%eax
  80312e:	39 c2                	cmp    %eax,%edx
  803130:	0f 82 4c 01 00 00    	jb     803282 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  803136:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313a:	75 14                	jne    803150 <insert_sorted_allocList+0x157>
  80313c:	83 ec 04             	sub    $0x4,%esp
  80313f:	68 10 51 80 00       	push   $0x805110
  803144:	6a 73                	push   $0x73
  803146:	68 bf 50 80 00       	push   $0x8050bf
  80314b:	e8 5a e1 ff ff       	call   8012aa <_panic>
  803150:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	89 50 04             	mov    %edx,0x4(%eax)
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	8b 40 04             	mov    0x4(%eax),%eax
  803162:	85 c0                	test   %eax,%eax
  803164:	74 0c                	je     803172 <insert_sorted_allocList+0x179>
  803166:	a1 44 60 80 00       	mov    0x806044,%eax
  80316b:	8b 55 08             	mov    0x8(%ebp),%edx
  80316e:	89 10                	mov    %edx,(%eax)
  803170:	eb 08                	jmp    80317a <insert_sorted_allocList+0x181>
  803172:	8b 45 08             	mov    0x8(%ebp),%eax
  803175:	a3 40 60 80 00       	mov    %eax,0x806040
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	a3 44 60 80 00       	mov    %eax,0x806044
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318b:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803190:	40                   	inc    %eax
  803191:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803196:	e9 e7 00 00 00       	jmp    803282 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80319b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8031a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8031a8:	a1 40 60 80 00       	mov    0x806040,%eax
  8031ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031b0:	e9 9d 00 00 00       	jmp    803252 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8031b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b8:	8b 00                	mov    (%eax),%eax
  8031ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	8b 50 08             	mov    0x8(%eax),%edx
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 40 08             	mov    0x8(%eax),%eax
  8031c9:	39 c2                	cmp    %eax,%edx
  8031cb:	76 7d                	jbe    80324a <insert_sorted_allocList+0x251>
  8031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d0:	8b 50 08             	mov    0x8(%eax),%edx
  8031d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d6:	8b 40 08             	mov    0x8(%eax),%eax
  8031d9:	39 c2                	cmp    %eax,%edx
  8031db:	73 6d                	jae    80324a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8031dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e1:	74 06                	je     8031e9 <insert_sorted_allocList+0x1f0>
  8031e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e7:	75 14                	jne    8031fd <insert_sorted_allocList+0x204>
  8031e9:	83 ec 04             	sub    $0x4,%esp
  8031ec:	68 34 51 80 00       	push   $0x805134
  8031f1:	6a 7f                	push   $0x7f
  8031f3:	68 bf 50 80 00       	push   $0x8050bf
  8031f8:	e8 ad e0 ff ff       	call   8012aa <_panic>
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 10                	mov    (%eax),%edx
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	89 10                	mov    %edx,(%eax)
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	85 c0                	test   %eax,%eax
  80320e:	74 0b                	je     80321b <insert_sorted_allocList+0x222>
  803210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	8b 55 08             	mov    0x8(%ebp),%edx
  803218:	89 50 04             	mov    %edx,0x4(%eax)
  80321b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321e:	8b 55 08             	mov    0x8(%ebp),%edx
  803221:	89 10                	mov    %edx,(%eax)
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803229:	89 50 04             	mov    %edx,0x4(%eax)
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	8b 00                	mov    (%eax),%eax
  803231:	85 c0                	test   %eax,%eax
  803233:	75 08                	jne    80323d <insert_sorted_allocList+0x244>
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	a3 44 60 80 00       	mov    %eax,0x806044
  80323d:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803242:	40                   	inc    %eax
  803243:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  803248:	eb 39                	jmp    803283 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80324a:	a1 48 60 80 00       	mov    0x806048,%eax
  80324f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803252:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803256:	74 07                	je     80325f <insert_sorted_allocList+0x266>
  803258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325b:	8b 00                	mov    (%eax),%eax
  80325d:	eb 05                	jmp    803264 <insert_sorted_allocList+0x26b>
  80325f:	b8 00 00 00 00       	mov    $0x0,%eax
  803264:	a3 48 60 80 00       	mov    %eax,0x806048
  803269:	a1 48 60 80 00       	mov    0x806048,%eax
  80326e:	85 c0                	test   %eax,%eax
  803270:	0f 85 3f ff ff ff    	jne    8031b5 <insert_sorted_allocList+0x1bc>
  803276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327a:	0f 85 35 ff ff ff    	jne    8031b5 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803280:	eb 01                	jmp    803283 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803282:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803283:	90                   	nop
  803284:	c9                   	leave  
  803285:	c3                   	ret    

00803286 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803286:	55                   	push   %ebp
  803287:	89 e5                	mov    %esp,%ebp
  803289:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80328c:	a1 38 61 80 00       	mov    0x806138,%eax
  803291:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803294:	e9 85 01 00 00       	jmp    80341e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  803299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329c:	8b 40 0c             	mov    0xc(%eax),%eax
  80329f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032a2:	0f 82 6e 01 00 00    	jb     803416 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8032a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032b1:	0f 85 8a 00 00 00    	jne    803341 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8032b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032bb:	75 17                	jne    8032d4 <alloc_block_FF+0x4e>
  8032bd:	83 ec 04             	sub    $0x4,%esp
  8032c0:	68 68 51 80 00       	push   $0x805168
  8032c5:	68 93 00 00 00       	push   $0x93
  8032ca:	68 bf 50 80 00       	push   $0x8050bf
  8032cf:	e8 d6 df ff ff       	call   8012aa <_panic>
  8032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	74 10                	je     8032ed <alloc_block_FF+0x67>
  8032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e0:	8b 00                	mov    (%eax),%eax
  8032e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e5:	8b 52 04             	mov    0x4(%edx),%edx
  8032e8:	89 50 04             	mov    %edx,0x4(%eax)
  8032eb:	eb 0b                	jmp    8032f8 <alloc_block_FF+0x72>
  8032ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f0:	8b 40 04             	mov    0x4(%eax),%eax
  8032f3:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8032f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fb:	8b 40 04             	mov    0x4(%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	74 0f                	je     803311 <alloc_block_FF+0x8b>
  803302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803305:	8b 40 04             	mov    0x4(%eax),%eax
  803308:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80330b:	8b 12                	mov    (%edx),%edx
  80330d:	89 10                	mov    %edx,(%eax)
  80330f:	eb 0a                	jmp    80331b <alloc_block_FF+0x95>
  803311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803314:	8b 00                	mov    (%eax),%eax
  803316:	a3 38 61 80 00       	mov    %eax,0x806138
  80331b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332e:	a1 44 61 80 00       	mov    0x806144,%eax
  803333:	48                   	dec    %eax
  803334:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  803339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333c:	e9 10 01 00 00       	jmp    803451 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  803341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803344:	8b 40 0c             	mov    0xc(%eax),%eax
  803347:	3b 45 08             	cmp    0x8(%ebp),%eax
  80334a:	0f 86 c6 00 00 00    	jbe    803416 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803350:	a1 48 61 80 00       	mov    0x806148,%eax
  803355:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  803358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335b:	8b 50 08             	mov    0x8(%eax),%edx
  80335e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803361:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  803364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803367:	8b 55 08             	mov    0x8(%ebp),%edx
  80336a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80336d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803371:	75 17                	jne    80338a <alloc_block_FF+0x104>
  803373:	83 ec 04             	sub    $0x4,%esp
  803376:	68 68 51 80 00       	push   $0x805168
  80337b:	68 9b 00 00 00       	push   $0x9b
  803380:	68 bf 50 80 00       	push   $0x8050bf
  803385:	e8 20 df ff ff       	call   8012aa <_panic>
  80338a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338d:	8b 00                	mov    (%eax),%eax
  80338f:	85 c0                	test   %eax,%eax
  803391:	74 10                	je     8033a3 <alloc_block_FF+0x11d>
  803393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80339b:	8b 52 04             	mov    0x4(%edx),%edx
  80339e:	89 50 04             	mov    %edx,0x4(%eax)
  8033a1:	eb 0b                	jmp    8033ae <alloc_block_FF+0x128>
  8033a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a6:	8b 40 04             	mov    0x4(%eax),%eax
  8033a9:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8033ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b1:	8b 40 04             	mov    0x4(%eax),%eax
  8033b4:	85 c0                	test   %eax,%eax
  8033b6:	74 0f                	je     8033c7 <alloc_block_FF+0x141>
  8033b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bb:	8b 40 04             	mov    0x4(%eax),%eax
  8033be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033c1:	8b 12                	mov    (%edx),%edx
  8033c3:	89 10                	mov    %edx,(%eax)
  8033c5:	eb 0a                	jmp    8033d1 <alloc_block_FF+0x14b>
  8033c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	a3 48 61 80 00       	mov    %eax,0x806148
  8033d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e4:	a1 54 61 80 00       	mov    0x806154,%eax
  8033e9:	48                   	dec    %eax
  8033ea:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  8033ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f2:	8b 50 08             	mov    0x8(%eax),%edx
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	01 c2                	add    %eax,%edx
  8033fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fd:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803403:	8b 40 0c             	mov    0xc(%eax),%eax
  803406:	2b 45 08             	sub    0x8(%ebp),%eax
  803409:	89 c2                	mov    %eax,%edx
  80340b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  803411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803414:	eb 3b                	jmp    803451 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803416:	a1 40 61 80 00       	mov    0x806140,%eax
  80341b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80341e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803422:	74 07                	je     80342b <alloc_block_FF+0x1a5>
  803424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803427:	8b 00                	mov    (%eax),%eax
  803429:	eb 05                	jmp    803430 <alloc_block_FF+0x1aa>
  80342b:	b8 00 00 00 00       	mov    $0x0,%eax
  803430:	a3 40 61 80 00       	mov    %eax,0x806140
  803435:	a1 40 61 80 00       	mov    0x806140,%eax
  80343a:	85 c0                	test   %eax,%eax
  80343c:	0f 85 57 fe ff ff    	jne    803299 <alloc_block_FF+0x13>
  803442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803446:	0f 85 4d fe ff ff    	jne    803299 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80344c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803451:	c9                   	leave  
  803452:	c3                   	ret    

00803453 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803453:	55                   	push   %ebp
  803454:	89 e5                	mov    %esp,%ebp
  803456:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  803459:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803460:	a1 38 61 80 00       	mov    0x806138,%eax
  803465:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803468:	e9 df 00 00 00       	jmp    80354c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80346d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803470:	8b 40 0c             	mov    0xc(%eax),%eax
  803473:	3b 45 08             	cmp    0x8(%ebp),%eax
  803476:	0f 82 c8 00 00 00    	jb     803544 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80347c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347f:	8b 40 0c             	mov    0xc(%eax),%eax
  803482:	3b 45 08             	cmp    0x8(%ebp),%eax
  803485:	0f 85 8a 00 00 00    	jne    803515 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80348b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80348f:	75 17                	jne    8034a8 <alloc_block_BF+0x55>
  803491:	83 ec 04             	sub    $0x4,%esp
  803494:	68 68 51 80 00       	push   $0x805168
  803499:	68 b7 00 00 00       	push   $0xb7
  80349e:	68 bf 50 80 00       	push   $0x8050bf
  8034a3:	e8 02 de ff ff       	call   8012aa <_panic>
  8034a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ab:	8b 00                	mov    (%eax),%eax
  8034ad:	85 c0                	test   %eax,%eax
  8034af:	74 10                	je     8034c1 <alloc_block_BF+0x6e>
  8034b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b4:	8b 00                	mov    (%eax),%eax
  8034b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b9:	8b 52 04             	mov    0x4(%edx),%edx
  8034bc:	89 50 04             	mov    %edx,0x4(%eax)
  8034bf:	eb 0b                	jmp    8034cc <alloc_block_BF+0x79>
  8034c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c4:	8b 40 04             	mov    0x4(%eax),%eax
  8034c7:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8034cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cf:	8b 40 04             	mov    0x4(%eax),%eax
  8034d2:	85 c0                	test   %eax,%eax
  8034d4:	74 0f                	je     8034e5 <alloc_block_BF+0x92>
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	8b 40 04             	mov    0x4(%eax),%eax
  8034dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034df:	8b 12                	mov    (%edx),%edx
  8034e1:	89 10                	mov    %edx,(%eax)
  8034e3:	eb 0a                	jmp    8034ef <alloc_block_BF+0x9c>
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	a3 38 61 80 00       	mov    %eax,0x806138
  8034ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803502:	a1 44 61 80 00       	mov    0x806144,%eax
  803507:	48                   	dec    %eax
  803508:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  80350d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803510:	e9 4d 01 00 00       	jmp    803662 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803518:	8b 40 0c             	mov    0xc(%eax),%eax
  80351b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80351e:	76 24                	jbe    803544 <alloc_block_BF+0xf1>
  803520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803523:	8b 40 0c             	mov    0xc(%eax),%eax
  803526:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803529:	73 19                	jae    803544 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80352b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  803532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803535:	8b 40 0c             	mov    0xc(%eax),%eax
  803538:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80353b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353e:	8b 40 08             	mov    0x8(%eax),%eax
  803541:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803544:	a1 40 61 80 00       	mov    0x806140,%eax
  803549:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80354c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803550:	74 07                	je     803559 <alloc_block_BF+0x106>
  803552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803555:	8b 00                	mov    (%eax),%eax
  803557:	eb 05                	jmp    80355e <alloc_block_BF+0x10b>
  803559:	b8 00 00 00 00       	mov    $0x0,%eax
  80355e:	a3 40 61 80 00       	mov    %eax,0x806140
  803563:	a1 40 61 80 00       	mov    0x806140,%eax
  803568:	85 c0                	test   %eax,%eax
  80356a:	0f 85 fd fe ff ff    	jne    80346d <alloc_block_BF+0x1a>
  803570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803574:	0f 85 f3 fe ff ff    	jne    80346d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80357a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80357e:	0f 84 d9 00 00 00    	je     80365d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803584:	a1 48 61 80 00       	mov    0x806148,%eax
  803589:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80358c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803592:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803598:	8b 55 08             	mov    0x8(%ebp),%edx
  80359b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80359e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a2:	75 17                	jne    8035bb <alloc_block_BF+0x168>
  8035a4:	83 ec 04             	sub    $0x4,%esp
  8035a7:	68 68 51 80 00       	push   $0x805168
  8035ac:	68 c7 00 00 00       	push   $0xc7
  8035b1:	68 bf 50 80 00       	push   $0x8050bf
  8035b6:	e8 ef dc ff ff       	call   8012aa <_panic>
  8035bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035be:	8b 00                	mov    (%eax),%eax
  8035c0:	85 c0                	test   %eax,%eax
  8035c2:	74 10                	je     8035d4 <alloc_block_BF+0x181>
  8035c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c7:	8b 00                	mov    (%eax),%eax
  8035c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035cc:	8b 52 04             	mov    0x4(%edx),%edx
  8035cf:	89 50 04             	mov    %edx,0x4(%eax)
  8035d2:	eb 0b                	jmp    8035df <alloc_block_BF+0x18c>
  8035d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d7:	8b 40 04             	mov    0x4(%eax),%eax
  8035da:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8035df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e2:	8b 40 04             	mov    0x4(%eax),%eax
  8035e5:	85 c0                	test   %eax,%eax
  8035e7:	74 0f                	je     8035f8 <alloc_block_BF+0x1a5>
  8035e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ec:	8b 40 04             	mov    0x4(%eax),%eax
  8035ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f2:	8b 12                	mov    (%edx),%edx
  8035f4:	89 10                	mov    %edx,(%eax)
  8035f6:	eb 0a                	jmp    803602 <alloc_block_BF+0x1af>
  8035f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fb:	8b 00                	mov    (%eax),%eax
  8035fd:	a3 48 61 80 00       	mov    %eax,0x806148
  803602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803605:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80360b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803615:	a1 54 61 80 00       	mov    0x806154,%eax
  80361a:	48                   	dec    %eax
  80361b:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803620:	83 ec 08             	sub    $0x8,%esp
  803623:	ff 75 ec             	pushl  -0x14(%ebp)
  803626:	68 38 61 80 00       	push   $0x806138
  80362b:	e8 71 f9 ff ff       	call   802fa1 <find_block>
  803630:	83 c4 10             	add    $0x10,%esp
  803633:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803636:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803639:	8b 50 08             	mov    0x8(%eax),%edx
  80363c:	8b 45 08             	mov    0x8(%ebp),%eax
  80363f:	01 c2                	add    %eax,%edx
  803641:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803644:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803647:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80364a:	8b 40 0c             	mov    0xc(%eax),%eax
  80364d:	2b 45 08             	sub    0x8(%ebp),%eax
  803650:	89 c2                	mov    %eax,%edx
  803652:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803655:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365b:	eb 05                	jmp    803662 <alloc_block_BF+0x20f>
	}
	return NULL;
  80365d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803662:	c9                   	leave  
  803663:	c3                   	ret    

00803664 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803664:	55                   	push   %ebp
  803665:	89 e5                	mov    %esp,%ebp
  803667:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80366a:	a1 28 60 80 00       	mov    0x806028,%eax
  80366f:	85 c0                	test   %eax,%eax
  803671:	0f 85 de 01 00 00    	jne    803855 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803677:	a1 38 61 80 00       	mov    0x806138,%eax
  80367c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80367f:	e9 9e 01 00 00       	jmp    803822 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803687:	8b 40 0c             	mov    0xc(%eax),%eax
  80368a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80368d:	0f 82 87 01 00 00    	jb     80381a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803696:	8b 40 0c             	mov    0xc(%eax),%eax
  803699:	3b 45 08             	cmp    0x8(%ebp),%eax
  80369c:	0f 85 95 00 00 00    	jne    803737 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8036a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a6:	75 17                	jne    8036bf <alloc_block_NF+0x5b>
  8036a8:	83 ec 04             	sub    $0x4,%esp
  8036ab:	68 68 51 80 00       	push   $0x805168
  8036b0:	68 e0 00 00 00       	push   $0xe0
  8036b5:	68 bf 50 80 00       	push   $0x8050bf
  8036ba:	e8 eb db ff ff       	call   8012aa <_panic>
  8036bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c2:	8b 00                	mov    (%eax),%eax
  8036c4:	85 c0                	test   %eax,%eax
  8036c6:	74 10                	je     8036d8 <alloc_block_NF+0x74>
  8036c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cb:	8b 00                	mov    (%eax),%eax
  8036cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036d0:	8b 52 04             	mov    0x4(%edx),%edx
  8036d3:	89 50 04             	mov    %edx,0x4(%eax)
  8036d6:	eb 0b                	jmp    8036e3 <alloc_block_NF+0x7f>
  8036d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036db:	8b 40 04             	mov    0x4(%eax),%eax
  8036de:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8036e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e6:	8b 40 04             	mov    0x4(%eax),%eax
  8036e9:	85 c0                	test   %eax,%eax
  8036eb:	74 0f                	je     8036fc <alloc_block_NF+0x98>
  8036ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f0:	8b 40 04             	mov    0x4(%eax),%eax
  8036f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f6:	8b 12                	mov    (%edx),%edx
  8036f8:	89 10                	mov    %edx,(%eax)
  8036fa:	eb 0a                	jmp    803706 <alloc_block_NF+0xa2>
  8036fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ff:	8b 00                	mov    (%eax),%eax
  803701:	a3 38 61 80 00       	mov    %eax,0x806138
  803706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803709:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803712:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803719:	a1 44 61 80 00       	mov    0x806144,%eax
  80371e:	48                   	dec    %eax
  80371f:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  803724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803727:	8b 40 08             	mov    0x8(%eax),%eax
  80372a:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  80372f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803732:	e9 f8 04 00 00       	jmp    803c2f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373a:	8b 40 0c             	mov    0xc(%eax),%eax
  80373d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803740:	0f 86 d4 00 00 00    	jbe    80381a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803746:	a1 48 61 80 00       	mov    0x806148,%eax
  80374b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80374e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803751:	8b 50 08             	mov    0x8(%eax),%edx
  803754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803757:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80375a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375d:	8b 55 08             	mov    0x8(%ebp),%edx
  803760:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803763:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803767:	75 17                	jne    803780 <alloc_block_NF+0x11c>
  803769:	83 ec 04             	sub    $0x4,%esp
  80376c:	68 68 51 80 00       	push   $0x805168
  803771:	68 e9 00 00 00       	push   $0xe9
  803776:	68 bf 50 80 00       	push   $0x8050bf
  80377b:	e8 2a db ff ff       	call   8012aa <_panic>
  803780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803783:	8b 00                	mov    (%eax),%eax
  803785:	85 c0                	test   %eax,%eax
  803787:	74 10                	je     803799 <alloc_block_NF+0x135>
  803789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378c:	8b 00                	mov    (%eax),%eax
  80378e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803791:	8b 52 04             	mov    0x4(%edx),%edx
  803794:	89 50 04             	mov    %edx,0x4(%eax)
  803797:	eb 0b                	jmp    8037a4 <alloc_block_NF+0x140>
  803799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379c:	8b 40 04             	mov    0x4(%eax),%eax
  80379f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8037a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a7:	8b 40 04             	mov    0x4(%eax),%eax
  8037aa:	85 c0                	test   %eax,%eax
  8037ac:	74 0f                	je     8037bd <alloc_block_NF+0x159>
  8037ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b1:	8b 40 04             	mov    0x4(%eax),%eax
  8037b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037b7:	8b 12                	mov    (%edx),%edx
  8037b9:	89 10                	mov    %edx,(%eax)
  8037bb:	eb 0a                	jmp    8037c7 <alloc_block_NF+0x163>
  8037bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c0:	8b 00                	mov    (%eax),%eax
  8037c2:	a3 48 61 80 00       	mov    %eax,0x806148
  8037c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037da:	a1 54 61 80 00       	mov    0x806154,%eax
  8037df:	48                   	dec    %eax
  8037e0:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  8037e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e8:	8b 40 08             	mov    0x8(%eax),%eax
  8037eb:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  8037f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f3:	8b 50 08             	mov    0x8(%eax),%edx
  8037f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f9:	01 c2                	add    %eax,%edx
  8037fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fe:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803804:	8b 40 0c             	mov    0xc(%eax),%eax
  803807:	2b 45 08             	sub    0x8(%ebp),%eax
  80380a:	89 c2                	mov    %eax,%edx
  80380c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803815:	e9 15 04 00 00       	jmp    803c2f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80381a:	a1 40 61 80 00       	mov    0x806140,%eax
  80381f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803822:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803826:	74 07                	je     80382f <alloc_block_NF+0x1cb>
  803828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382b:	8b 00                	mov    (%eax),%eax
  80382d:	eb 05                	jmp    803834 <alloc_block_NF+0x1d0>
  80382f:	b8 00 00 00 00       	mov    $0x0,%eax
  803834:	a3 40 61 80 00       	mov    %eax,0x806140
  803839:	a1 40 61 80 00       	mov    0x806140,%eax
  80383e:	85 c0                	test   %eax,%eax
  803840:	0f 85 3e fe ff ff    	jne    803684 <alloc_block_NF+0x20>
  803846:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80384a:	0f 85 34 fe ff ff    	jne    803684 <alloc_block_NF+0x20>
  803850:	e9 d5 03 00 00       	jmp    803c2a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803855:	a1 38 61 80 00       	mov    0x806138,%eax
  80385a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80385d:	e9 b1 01 00 00       	jmp    803a13 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803865:	8b 50 08             	mov    0x8(%eax),%edx
  803868:	a1 28 60 80 00       	mov    0x806028,%eax
  80386d:	39 c2                	cmp    %eax,%edx
  80386f:	0f 82 96 01 00 00    	jb     803a0b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803878:	8b 40 0c             	mov    0xc(%eax),%eax
  80387b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80387e:	0f 82 87 01 00 00    	jb     803a0b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803887:	8b 40 0c             	mov    0xc(%eax),%eax
  80388a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80388d:	0f 85 95 00 00 00    	jne    803928 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803893:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803897:	75 17                	jne    8038b0 <alloc_block_NF+0x24c>
  803899:	83 ec 04             	sub    $0x4,%esp
  80389c:	68 68 51 80 00       	push   $0x805168
  8038a1:	68 fc 00 00 00       	push   $0xfc
  8038a6:	68 bf 50 80 00       	push   $0x8050bf
  8038ab:	e8 fa d9 ff ff       	call   8012aa <_panic>
  8038b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b3:	8b 00                	mov    (%eax),%eax
  8038b5:	85 c0                	test   %eax,%eax
  8038b7:	74 10                	je     8038c9 <alloc_block_NF+0x265>
  8038b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bc:	8b 00                	mov    (%eax),%eax
  8038be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038c1:	8b 52 04             	mov    0x4(%edx),%edx
  8038c4:	89 50 04             	mov    %edx,0x4(%eax)
  8038c7:	eb 0b                	jmp    8038d4 <alloc_block_NF+0x270>
  8038c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cc:	8b 40 04             	mov    0x4(%eax),%eax
  8038cf:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8038d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d7:	8b 40 04             	mov    0x4(%eax),%eax
  8038da:	85 c0                	test   %eax,%eax
  8038dc:	74 0f                	je     8038ed <alloc_block_NF+0x289>
  8038de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e1:	8b 40 04             	mov    0x4(%eax),%eax
  8038e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038e7:	8b 12                	mov    (%edx),%edx
  8038e9:	89 10                	mov    %edx,(%eax)
  8038eb:	eb 0a                	jmp    8038f7 <alloc_block_NF+0x293>
  8038ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f0:	8b 00                	mov    (%eax),%eax
  8038f2:	a3 38 61 80 00       	mov    %eax,0x806138
  8038f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803903:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80390a:	a1 44 61 80 00       	mov    0x806144,%eax
  80390f:	48                   	dec    %eax
  803910:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803918:	8b 40 08             	mov    0x8(%eax),%eax
  80391b:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803923:	e9 07 03 00 00       	jmp    803c2f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392b:	8b 40 0c             	mov    0xc(%eax),%eax
  80392e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803931:	0f 86 d4 00 00 00    	jbe    803a0b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803937:	a1 48 61 80 00       	mov    0x806148,%eax
  80393c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80393f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803942:	8b 50 08             	mov    0x8(%eax),%edx
  803945:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803948:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80394b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394e:	8b 55 08             	mov    0x8(%ebp),%edx
  803951:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803954:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803958:	75 17                	jne    803971 <alloc_block_NF+0x30d>
  80395a:	83 ec 04             	sub    $0x4,%esp
  80395d:	68 68 51 80 00       	push   $0x805168
  803962:	68 04 01 00 00       	push   $0x104
  803967:	68 bf 50 80 00       	push   $0x8050bf
  80396c:	e8 39 d9 ff ff       	call   8012aa <_panic>
  803971:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803974:	8b 00                	mov    (%eax),%eax
  803976:	85 c0                	test   %eax,%eax
  803978:	74 10                	je     80398a <alloc_block_NF+0x326>
  80397a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397d:	8b 00                	mov    (%eax),%eax
  80397f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803982:	8b 52 04             	mov    0x4(%edx),%edx
  803985:	89 50 04             	mov    %edx,0x4(%eax)
  803988:	eb 0b                	jmp    803995 <alloc_block_NF+0x331>
  80398a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398d:	8b 40 04             	mov    0x4(%eax),%eax
  803990:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803995:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803998:	8b 40 04             	mov    0x4(%eax),%eax
  80399b:	85 c0                	test   %eax,%eax
  80399d:	74 0f                	je     8039ae <alloc_block_NF+0x34a>
  80399f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a2:	8b 40 04             	mov    0x4(%eax),%eax
  8039a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a8:	8b 12                	mov    (%edx),%edx
  8039aa:	89 10                	mov    %edx,(%eax)
  8039ac:	eb 0a                	jmp    8039b8 <alloc_block_NF+0x354>
  8039ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b1:	8b 00                	mov    (%eax),%eax
  8039b3:	a3 48 61 80 00       	mov    %eax,0x806148
  8039b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039cb:	a1 54 61 80 00       	mov    0x806154,%eax
  8039d0:	48                   	dec    %eax
  8039d1:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  8039d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d9:	8b 40 08             	mov    0x8(%eax),%eax
  8039dc:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  8039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e4:	8b 50 08             	mov    0x8(%eax),%edx
  8039e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ea:	01 c2                	add    %eax,%edx
  8039ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ef:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8039f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8039f8:	2b 45 08             	sub    0x8(%ebp),%eax
  8039fb:	89 c2                	mov    %eax,%edx
  8039fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a00:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803a03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a06:	e9 24 02 00 00       	jmp    803c2f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803a0b:	a1 40 61 80 00       	mov    0x806140,%eax
  803a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a17:	74 07                	je     803a20 <alloc_block_NF+0x3bc>
  803a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1c:	8b 00                	mov    (%eax),%eax
  803a1e:	eb 05                	jmp    803a25 <alloc_block_NF+0x3c1>
  803a20:	b8 00 00 00 00       	mov    $0x0,%eax
  803a25:	a3 40 61 80 00       	mov    %eax,0x806140
  803a2a:	a1 40 61 80 00       	mov    0x806140,%eax
  803a2f:	85 c0                	test   %eax,%eax
  803a31:	0f 85 2b fe ff ff    	jne    803862 <alloc_block_NF+0x1fe>
  803a37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a3b:	0f 85 21 fe ff ff    	jne    803862 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803a41:	a1 38 61 80 00       	mov    0x806138,%eax
  803a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a49:	e9 ae 01 00 00       	jmp    803bfc <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a51:	8b 50 08             	mov    0x8(%eax),%edx
  803a54:	a1 28 60 80 00       	mov    0x806028,%eax
  803a59:	39 c2                	cmp    %eax,%edx
  803a5b:	0f 83 93 01 00 00    	jae    803bf4 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a64:	8b 40 0c             	mov    0xc(%eax),%eax
  803a67:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a6a:	0f 82 84 01 00 00    	jb     803bf4 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a73:	8b 40 0c             	mov    0xc(%eax),%eax
  803a76:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a79:	0f 85 95 00 00 00    	jne    803b14 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803a7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a83:	75 17                	jne    803a9c <alloc_block_NF+0x438>
  803a85:	83 ec 04             	sub    $0x4,%esp
  803a88:	68 68 51 80 00       	push   $0x805168
  803a8d:	68 14 01 00 00       	push   $0x114
  803a92:	68 bf 50 80 00       	push   $0x8050bf
  803a97:	e8 0e d8 ff ff       	call   8012aa <_panic>
  803a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9f:	8b 00                	mov    (%eax),%eax
  803aa1:	85 c0                	test   %eax,%eax
  803aa3:	74 10                	je     803ab5 <alloc_block_NF+0x451>
  803aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa8:	8b 00                	mov    (%eax),%eax
  803aaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aad:	8b 52 04             	mov    0x4(%edx),%edx
  803ab0:	89 50 04             	mov    %edx,0x4(%eax)
  803ab3:	eb 0b                	jmp    803ac0 <alloc_block_NF+0x45c>
  803ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab8:	8b 40 04             	mov    0x4(%eax),%eax
  803abb:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac3:	8b 40 04             	mov    0x4(%eax),%eax
  803ac6:	85 c0                	test   %eax,%eax
  803ac8:	74 0f                	je     803ad9 <alloc_block_NF+0x475>
  803aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acd:	8b 40 04             	mov    0x4(%eax),%eax
  803ad0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ad3:	8b 12                	mov    (%edx),%edx
  803ad5:	89 10                	mov    %edx,(%eax)
  803ad7:	eb 0a                	jmp    803ae3 <alloc_block_NF+0x47f>
  803ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adc:	8b 00                	mov    (%eax),%eax
  803ade:	a3 38 61 80 00       	mov    %eax,0x806138
  803ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af6:	a1 44 61 80 00       	mov    0x806144,%eax
  803afb:	48                   	dec    %eax
  803afc:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b04:	8b 40 08             	mov    0x8(%eax),%eax
  803b07:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0f:	e9 1b 01 00 00       	jmp    803c2f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b17:	8b 40 0c             	mov    0xc(%eax),%eax
  803b1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b1d:	0f 86 d1 00 00 00    	jbe    803bf4 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803b23:	a1 48 61 80 00       	mov    0x806148,%eax
  803b28:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2e:	8b 50 08             	mov    0x8(%eax),%edx
  803b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b34:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b3a:	8b 55 08             	mov    0x8(%ebp),%edx
  803b3d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803b40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b44:	75 17                	jne    803b5d <alloc_block_NF+0x4f9>
  803b46:	83 ec 04             	sub    $0x4,%esp
  803b49:	68 68 51 80 00       	push   $0x805168
  803b4e:	68 1c 01 00 00       	push   $0x11c
  803b53:	68 bf 50 80 00       	push   $0x8050bf
  803b58:	e8 4d d7 ff ff       	call   8012aa <_panic>
  803b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b60:	8b 00                	mov    (%eax),%eax
  803b62:	85 c0                	test   %eax,%eax
  803b64:	74 10                	je     803b76 <alloc_block_NF+0x512>
  803b66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b69:	8b 00                	mov    (%eax),%eax
  803b6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b6e:	8b 52 04             	mov    0x4(%edx),%edx
  803b71:	89 50 04             	mov    %edx,0x4(%eax)
  803b74:	eb 0b                	jmp    803b81 <alloc_block_NF+0x51d>
  803b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b79:	8b 40 04             	mov    0x4(%eax),%eax
  803b7c:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b84:	8b 40 04             	mov    0x4(%eax),%eax
  803b87:	85 c0                	test   %eax,%eax
  803b89:	74 0f                	je     803b9a <alloc_block_NF+0x536>
  803b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b8e:	8b 40 04             	mov    0x4(%eax),%eax
  803b91:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b94:	8b 12                	mov    (%edx),%edx
  803b96:	89 10                	mov    %edx,(%eax)
  803b98:	eb 0a                	jmp    803ba4 <alloc_block_NF+0x540>
  803b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b9d:	8b 00                	mov    (%eax),%eax
  803b9f:	a3 48 61 80 00       	mov    %eax,0x806148
  803ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ba7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bb7:	a1 54 61 80 00       	mov    0x806154,%eax
  803bbc:	48                   	dec    %eax
  803bbd:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803bc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bc5:	8b 40 08             	mov    0x8(%eax),%eax
  803bc8:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd0:	8b 50 08             	mov    0x8(%eax),%edx
  803bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd6:	01 c2                	add    %eax,%edx
  803bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be1:	8b 40 0c             	mov    0xc(%eax),%eax
  803be4:	2b 45 08             	sub    0x8(%ebp),%eax
  803be7:	89 c2                	mov    %eax,%edx
  803be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bec:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bf2:	eb 3b                	jmp    803c2f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803bf4:	a1 40 61 80 00       	mov    0x806140,%eax
  803bf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c00:	74 07                	je     803c09 <alloc_block_NF+0x5a5>
  803c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c05:	8b 00                	mov    (%eax),%eax
  803c07:	eb 05                	jmp    803c0e <alloc_block_NF+0x5aa>
  803c09:	b8 00 00 00 00       	mov    $0x0,%eax
  803c0e:	a3 40 61 80 00       	mov    %eax,0x806140
  803c13:	a1 40 61 80 00       	mov    0x806140,%eax
  803c18:	85 c0                	test   %eax,%eax
  803c1a:	0f 85 2e fe ff ff    	jne    803a4e <alloc_block_NF+0x3ea>
  803c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c24:	0f 85 24 fe ff ff    	jne    803a4e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803c2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c2f:	c9                   	leave  
  803c30:	c3                   	ret    

00803c31 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803c31:	55                   	push   %ebp
  803c32:	89 e5                	mov    %esp,%ebp
  803c34:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803c37:	a1 38 61 80 00       	mov    0x806138,%eax
  803c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803c3f:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803c44:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803c47:	a1 38 61 80 00       	mov    0x806138,%eax
  803c4c:	85 c0                	test   %eax,%eax
  803c4e:	74 14                	je     803c64 <insert_sorted_with_merge_freeList+0x33>
  803c50:	8b 45 08             	mov    0x8(%ebp),%eax
  803c53:	8b 50 08             	mov    0x8(%eax),%edx
  803c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c59:	8b 40 08             	mov    0x8(%eax),%eax
  803c5c:	39 c2                	cmp    %eax,%edx
  803c5e:	0f 87 9b 01 00 00    	ja     803dff <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803c64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c68:	75 17                	jne    803c81 <insert_sorted_with_merge_freeList+0x50>
  803c6a:	83 ec 04             	sub    $0x4,%esp
  803c6d:	68 9c 50 80 00       	push   $0x80509c
  803c72:	68 38 01 00 00       	push   $0x138
  803c77:	68 bf 50 80 00       	push   $0x8050bf
  803c7c:	e8 29 d6 ff ff       	call   8012aa <_panic>
  803c81:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803c87:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8a:	89 10                	mov    %edx,(%eax)
  803c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8f:	8b 00                	mov    (%eax),%eax
  803c91:	85 c0                	test   %eax,%eax
  803c93:	74 0d                	je     803ca2 <insert_sorted_with_merge_freeList+0x71>
  803c95:	a1 38 61 80 00       	mov    0x806138,%eax
  803c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  803c9d:	89 50 04             	mov    %edx,0x4(%eax)
  803ca0:	eb 08                	jmp    803caa <insert_sorted_with_merge_freeList+0x79>
  803ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca5:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803caa:	8b 45 08             	mov    0x8(%ebp),%eax
  803cad:	a3 38 61 80 00       	mov    %eax,0x806138
  803cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cbc:	a1 44 61 80 00       	mov    0x806144,%eax
  803cc1:	40                   	inc    %eax
  803cc2:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803cc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ccb:	0f 84 a8 06 00 00    	je     804379 <insert_sorted_with_merge_freeList+0x748>
  803cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd4:	8b 50 08             	mov    0x8(%eax),%edx
  803cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cda:	8b 40 0c             	mov    0xc(%eax),%eax
  803cdd:	01 c2                	add    %eax,%edx
  803cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ce2:	8b 40 08             	mov    0x8(%eax),%eax
  803ce5:	39 c2                	cmp    %eax,%edx
  803ce7:	0f 85 8c 06 00 00    	jne    804379 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803ced:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf0:	8b 50 0c             	mov    0xc(%eax),%edx
  803cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  803cf9:	01 c2                	add    %eax,%edx
  803cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfe:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803d01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d05:	75 17                	jne    803d1e <insert_sorted_with_merge_freeList+0xed>
  803d07:	83 ec 04             	sub    $0x4,%esp
  803d0a:	68 68 51 80 00       	push   $0x805168
  803d0f:	68 3c 01 00 00       	push   $0x13c
  803d14:	68 bf 50 80 00       	push   $0x8050bf
  803d19:	e8 8c d5 ff ff       	call   8012aa <_panic>
  803d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d21:	8b 00                	mov    (%eax),%eax
  803d23:	85 c0                	test   %eax,%eax
  803d25:	74 10                	je     803d37 <insert_sorted_with_merge_freeList+0x106>
  803d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d2a:	8b 00                	mov    (%eax),%eax
  803d2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d2f:	8b 52 04             	mov    0x4(%edx),%edx
  803d32:	89 50 04             	mov    %edx,0x4(%eax)
  803d35:	eb 0b                	jmp    803d42 <insert_sorted_with_merge_freeList+0x111>
  803d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d3a:	8b 40 04             	mov    0x4(%eax),%eax
  803d3d:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d45:	8b 40 04             	mov    0x4(%eax),%eax
  803d48:	85 c0                	test   %eax,%eax
  803d4a:	74 0f                	je     803d5b <insert_sorted_with_merge_freeList+0x12a>
  803d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d4f:	8b 40 04             	mov    0x4(%eax),%eax
  803d52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d55:	8b 12                	mov    (%edx),%edx
  803d57:	89 10                	mov    %edx,(%eax)
  803d59:	eb 0a                	jmp    803d65 <insert_sorted_with_merge_freeList+0x134>
  803d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d5e:	8b 00                	mov    (%eax),%eax
  803d60:	a3 38 61 80 00       	mov    %eax,0x806138
  803d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d78:	a1 44 61 80 00       	mov    0x806144,%eax
  803d7d:	48                   	dec    %eax
  803d7e:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  803d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d86:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d90:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803d97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d9b:	75 17                	jne    803db4 <insert_sorted_with_merge_freeList+0x183>
  803d9d:	83 ec 04             	sub    $0x4,%esp
  803da0:	68 9c 50 80 00       	push   $0x80509c
  803da5:	68 3f 01 00 00       	push   $0x13f
  803daa:	68 bf 50 80 00       	push   $0x8050bf
  803daf:	e8 f6 d4 ff ff       	call   8012aa <_panic>
  803db4:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dbd:	89 10                	mov    %edx,(%eax)
  803dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc2:	8b 00                	mov    (%eax),%eax
  803dc4:	85 c0                	test   %eax,%eax
  803dc6:	74 0d                	je     803dd5 <insert_sorted_with_merge_freeList+0x1a4>
  803dc8:	a1 48 61 80 00       	mov    0x806148,%eax
  803dcd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dd0:	89 50 04             	mov    %edx,0x4(%eax)
  803dd3:	eb 08                	jmp    803ddd <insert_sorted_with_merge_freeList+0x1ac>
  803dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd8:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de0:	a3 48 61 80 00       	mov    %eax,0x806148
  803de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803def:	a1 54 61 80 00       	mov    0x806154,%eax
  803df4:	40                   	inc    %eax
  803df5:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803dfa:	e9 7a 05 00 00       	jmp    804379 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803dff:	8b 45 08             	mov    0x8(%ebp),%eax
  803e02:	8b 50 08             	mov    0x8(%eax),%edx
  803e05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e08:	8b 40 08             	mov    0x8(%eax),%eax
  803e0b:	39 c2                	cmp    %eax,%edx
  803e0d:	0f 82 14 01 00 00    	jb     803f27 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e16:	8b 50 08             	mov    0x8(%eax),%edx
  803e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  803e1f:	01 c2                	add    %eax,%edx
  803e21:	8b 45 08             	mov    0x8(%ebp),%eax
  803e24:	8b 40 08             	mov    0x8(%eax),%eax
  803e27:	39 c2                	cmp    %eax,%edx
  803e29:	0f 85 90 00 00 00    	jne    803ebf <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e32:	8b 50 0c             	mov    0xc(%eax),%edx
  803e35:	8b 45 08             	mov    0x8(%ebp),%eax
  803e38:	8b 40 0c             	mov    0xc(%eax),%eax
  803e3b:	01 c2                	add    %eax,%edx
  803e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e40:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803e43:	8b 45 08             	mov    0x8(%ebp),%eax
  803e46:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803e57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e5b:	75 17                	jne    803e74 <insert_sorted_with_merge_freeList+0x243>
  803e5d:	83 ec 04             	sub    $0x4,%esp
  803e60:	68 9c 50 80 00       	push   $0x80509c
  803e65:	68 49 01 00 00       	push   $0x149
  803e6a:	68 bf 50 80 00       	push   $0x8050bf
  803e6f:	e8 36 d4 ff ff       	call   8012aa <_panic>
  803e74:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e7d:	89 10                	mov    %edx,(%eax)
  803e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e82:	8b 00                	mov    (%eax),%eax
  803e84:	85 c0                	test   %eax,%eax
  803e86:	74 0d                	je     803e95 <insert_sorted_with_merge_freeList+0x264>
  803e88:	a1 48 61 80 00       	mov    0x806148,%eax
  803e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  803e90:	89 50 04             	mov    %edx,0x4(%eax)
  803e93:	eb 08                	jmp    803e9d <insert_sorted_with_merge_freeList+0x26c>
  803e95:	8b 45 08             	mov    0x8(%ebp),%eax
  803e98:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea0:	a3 48 61 80 00       	mov    %eax,0x806148
  803ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eaf:	a1 54 61 80 00       	mov    0x806154,%eax
  803eb4:	40                   	inc    %eax
  803eb5:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803eba:	e9 bb 04 00 00       	jmp    80437a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803ebf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ec3:	75 17                	jne    803edc <insert_sorted_with_merge_freeList+0x2ab>
  803ec5:	83 ec 04             	sub    $0x4,%esp
  803ec8:	68 10 51 80 00       	push   $0x805110
  803ecd:	68 4c 01 00 00       	push   $0x14c
  803ed2:	68 bf 50 80 00       	push   $0x8050bf
  803ed7:	e8 ce d3 ff ff       	call   8012aa <_panic>
  803edc:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee5:	89 50 04             	mov    %edx,0x4(%eax)
  803ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  803eeb:	8b 40 04             	mov    0x4(%eax),%eax
  803eee:	85 c0                	test   %eax,%eax
  803ef0:	74 0c                	je     803efe <insert_sorted_with_merge_freeList+0x2cd>
  803ef2:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803ef7:	8b 55 08             	mov    0x8(%ebp),%edx
  803efa:	89 10                	mov    %edx,(%eax)
  803efc:	eb 08                	jmp    803f06 <insert_sorted_with_merge_freeList+0x2d5>
  803efe:	8b 45 08             	mov    0x8(%ebp),%eax
  803f01:	a3 38 61 80 00       	mov    %eax,0x806138
  803f06:	8b 45 08             	mov    0x8(%ebp),%eax
  803f09:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803f11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f17:	a1 44 61 80 00       	mov    0x806144,%eax
  803f1c:	40                   	inc    %eax
  803f1d:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803f22:	e9 53 04 00 00       	jmp    80437a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803f27:	a1 38 61 80 00       	mov    0x806138,%eax
  803f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f2f:	e9 15 04 00 00       	jmp    804349 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f37:	8b 00                	mov    (%eax),%eax
  803f39:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3f:	8b 50 08             	mov    0x8(%eax),%edx
  803f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f45:	8b 40 08             	mov    0x8(%eax),%eax
  803f48:	39 c2                	cmp    %eax,%edx
  803f4a:	0f 86 f1 03 00 00    	jbe    804341 <insert_sorted_with_merge_freeList+0x710>
  803f50:	8b 45 08             	mov    0x8(%ebp),%eax
  803f53:	8b 50 08             	mov    0x8(%eax),%edx
  803f56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f59:	8b 40 08             	mov    0x8(%eax),%eax
  803f5c:	39 c2                	cmp    %eax,%edx
  803f5e:	0f 83 dd 03 00 00    	jae    804341 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f67:	8b 50 08             	mov    0x8(%eax),%edx
  803f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f6d:	8b 40 0c             	mov    0xc(%eax),%eax
  803f70:	01 c2                	add    %eax,%edx
  803f72:	8b 45 08             	mov    0x8(%ebp),%eax
  803f75:	8b 40 08             	mov    0x8(%eax),%eax
  803f78:	39 c2                	cmp    %eax,%edx
  803f7a:	0f 85 b9 01 00 00    	jne    804139 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803f80:	8b 45 08             	mov    0x8(%ebp),%eax
  803f83:	8b 50 08             	mov    0x8(%eax),%edx
  803f86:	8b 45 08             	mov    0x8(%ebp),%eax
  803f89:	8b 40 0c             	mov    0xc(%eax),%eax
  803f8c:	01 c2                	add    %eax,%edx
  803f8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f91:	8b 40 08             	mov    0x8(%eax),%eax
  803f94:	39 c2                	cmp    %eax,%edx
  803f96:	0f 85 0d 01 00 00    	jne    8040a9 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f9f:	8b 50 0c             	mov    0xc(%eax),%edx
  803fa2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fa5:	8b 40 0c             	mov    0xc(%eax),%eax
  803fa8:	01 c2                	add    %eax,%edx
  803faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fad:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803fb0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803fb4:	75 17                	jne    803fcd <insert_sorted_with_merge_freeList+0x39c>
  803fb6:	83 ec 04             	sub    $0x4,%esp
  803fb9:	68 68 51 80 00       	push   $0x805168
  803fbe:	68 5c 01 00 00       	push   $0x15c
  803fc3:	68 bf 50 80 00       	push   $0x8050bf
  803fc8:	e8 dd d2 ff ff       	call   8012aa <_panic>
  803fcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fd0:	8b 00                	mov    (%eax),%eax
  803fd2:	85 c0                	test   %eax,%eax
  803fd4:	74 10                	je     803fe6 <insert_sorted_with_merge_freeList+0x3b5>
  803fd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fd9:	8b 00                	mov    (%eax),%eax
  803fdb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fde:	8b 52 04             	mov    0x4(%edx),%edx
  803fe1:	89 50 04             	mov    %edx,0x4(%eax)
  803fe4:	eb 0b                	jmp    803ff1 <insert_sorted_with_merge_freeList+0x3c0>
  803fe6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fe9:	8b 40 04             	mov    0x4(%eax),%eax
  803fec:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ff4:	8b 40 04             	mov    0x4(%eax),%eax
  803ff7:	85 c0                	test   %eax,%eax
  803ff9:	74 0f                	je     80400a <insert_sorted_with_merge_freeList+0x3d9>
  803ffb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ffe:	8b 40 04             	mov    0x4(%eax),%eax
  804001:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804004:	8b 12                	mov    (%edx),%edx
  804006:	89 10                	mov    %edx,(%eax)
  804008:	eb 0a                	jmp    804014 <insert_sorted_with_merge_freeList+0x3e3>
  80400a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80400d:	8b 00                	mov    (%eax),%eax
  80400f:	a3 38 61 80 00       	mov    %eax,0x806138
  804014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804017:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80401d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804027:	a1 44 61 80 00       	mov    0x806144,%eax
  80402c:	48                   	dec    %eax
  80402d:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  804032:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804035:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80403c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80403f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  804046:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80404a:	75 17                	jne    804063 <insert_sorted_with_merge_freeList+0x432>
  80404c:	83 ec 04             	sub    $0x4,%esp
  80404f:	68 9c 50 80 00       	push   $0x80509c
  804054:	68 5f 01 00 00       	push   $0x15f
  804059:	68 bf 50 80 00       	push   $0x8050bf
  80405e:	e8 47 d2 ff ff       	call   8012aa <_panic>
  804063:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804069:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80406c:	89 10                	mov    %edx,(%eax)
  80406e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804071:	8b 00                	mov    (%eax),%eax
  804073:	85 c0                	test   %eax,%eax
  804075:	74 0d                	je     804084 <insert_sorted_with_merge_freeList+0x453>
  804077:	a1 48 61 80 00       	mov    0x806148,%eax
  80407c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80407f:	89 50 04             	mov    %edx,0x4(%eax)
  804082:	eb 08                	jmp    80408c <insert_sorted_with_merge_freeList+0x45b>
  804084:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804087:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80408c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80408f:	a3 48 61 80 00       	mov    %eax,0x806148
  804094:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804097:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80409e:	a1 54 61 80 00       	mov    0x806154,%eax
  8040a3:	40                   	inc    %eax
  8040a4:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  8040a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ac:	8b 50 0c             	mov    0xc(%eax),%edx
  8040af:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8040b5:	01 c2                	add    %eax,%edx
  8040b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ba:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8040bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8040c0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8040c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8040d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040d5:	75 17                	jne    8040ee <insert_sorted_with_merge_freeList+0x4bd>
  8040d7:	83 ec 04             	sub    $0x4,%esp
  8040da:	68 9c 50 80 00       	push   $0x80509c
  8040df:	68 64 01 00 00       	push   $0x164
  8040e4:	68 bf 50 80 00       	push   $0x8050bf
  8040e9:	e8 bc d1 ff ff       	call   8012aa <_panic>
  8040ee:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8040f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f7:	89 10                	mov    %edx,(%eax)
  8040f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040fc:	8b 00                	mov    (%eax),%eax
  8040fe:	85 c0                	test   %eax,%eax
  804100:	74 0d                	je     80410f <insert_sorted_with_merge_freeList+0x4de>
  804102:	a1 48 61 80 00       	mov    0x806148,%eax
  804107:	8b 55 08             	mov    0x8(%ebp),%edx
  80410a:	89 50 04             	mov    %edx,0x4(%eax)
  80410d:	eb 08                	jmp    804117 <insert_sorted_with_merge_freeList+0x4e6>
  80410f:	8b 45 08             	mov    0x8(%ebp),%eax
  804112:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804117:	8b 45 08             	mov    0x8(%ebp),%eax
  80411a:	a3 48 61 80 00       	mov    %eax,0x806148
  80411f:	8b 45 08             	mov    0x8(%ebp),%eax
  804122:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804129:	a1 54 61 80 00       	mov    0x806154,%eax
  80412e:	40                   	inc    %eax
  80412f:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  804134:	e9 41 02 00 00       	jmp    80437a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804139:	8b 45 08             	mov    0x8(%ebp),%eax
  80413c:	8b 50 08             	mov    0x8(%eax),%edx
  80413f:	8b 45 08             	mov    0x8(%ebp),%eax
  804142:	8b 40 0c             	mov    0xc(%eax),%eax
  804145:	01 c2                	add    %eax,%edx
  804147:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80414a:	8b 40 08             	mov    0x8(%eax),%eax
  80414d:	39 c2                	cmp    %eax,%edx
  80414f:	0f 85 7c 01 00 00    	jne    8042d1 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  804155:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804159:	74 06                	je     804161 <insert_sorted_with_merge_freeList+0x530>
  80415b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80415f:	75 17                	jne    804178 <insert_sorted_with_merge_freeList+0x547>
  804161:	83 ec 04             	sub    $0x4,%esp
  804164:	68 d8 50 80 00       	push   $0x8050d8
  804169:	68 69 01 00 00       	push   $0x169
  80416e:	68 bf 50 80 00       	push   $0x8050bf
  804173:	e8 32 d1 ff ff       	call   8012aa <_panic>
  804178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80417b:	8b 50 04             	mov    0x4(%eax),%edx
  80417e:	8b 45 08             	mov    0x8(%ebp),%eax
  804181:	89 50 04             	mov    %edx,0x4(%eax)
  804184:	8b 45 08             	mov    0x8(%ebp),%eax
  804187:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80418a:	89 10                	mov    %edx,(%eax)
  80418c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80418f:	8b 40 04             	mov    0x4(%eax),%eax
  804192:	85 c0                	test   %eax,%eax
  804194:	74 0d                	je     8041a3 <insert_sorted_with_merge_freeList+0x572>
  804196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804199:	8b 40 04             	mov    0x4(%eax),%eax
  80419c:	8b 55 08             	mov    0x8(%ebp),%edx
  80419f:	89 10                	mov    %edx,(%eax)
  8041a1:	eb 08                	jmp    8041ab <insert_sorted_with_merge_freeList+0x57a>
  8041a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8041a6:	a3 38 61 80 00       	mov    %eax,0x806138
  8041ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8041b1:	89 50 04             	mov    %edx,0x4(%eax)
  8041b4:	a1 44 61 80 00       	mov    0x806144,%eax
  8041b9:	40                   	inc    %eax
  8041ba:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  8041bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8041c2:	8b 50 0c             	mov    0xc(%eax),%edx
  8041c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8041cb:	01 c2                	add    %eax,%edx
  8041cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d0:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8041d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8041d7:	75 17                	jne    8041f0 <insert_sorted_with_merge_freeList+0x5bf>
  8041d9:	83 ec 04             	sub    $0x4,%esp
  8041dc:	68 68 51 80 00       	push   $0x805168
  8041e1:	68 6b 01 00 00       	push   $0x16b
  8041e6:	68 bf 50 80 00       	push   $0x8050bf
  8041eb:	e8 ba d0 ff ff       	call   8012aa <_panic>
  8041f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041f3:	8b 00                	mov    (%eax),%eax
  8041f5:	85 c0                	test   %eax,%eax
  8041f7:	74 10                	je     804209 <insert_sorted_with_merge_freeList+0x5d8>
  8041f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041fc:	8b 00                	mov    (%eax),%eax
  8041fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804201:	8b 52 04             	mov    0x4(%edx),%edx
  804204:	89 50 04             	mov    %edx,0x4(%eax)
  804207:	eb 0b                	jmp    804214 <insert_sorted_with_merge_freeList+0x5e3>
  804209:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80420c:	8b 40 04             	mov    0x4(%eax),%eax
  80420f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804217:	8b 40 04             	mov    0x4(%eax),%eax
  80421a:	85 c0                	test   %eax,%eax
  80421c:	74 0f                	je     80422d <insert_sorted_with_merge_freeList+0x5fc>
  80421e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804221:	8b 40 04             	mov    0x4(%eax),%eax
  804224:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804227:	8b 12                	mov    (%edx),%edx
  804229:	89 10                	mov    %edx,(%eax)
  80422b:	eb 0a                	jmp    804237 <insert_sorted_with_merge_freeList+0x606>
  80422d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804230:	8b 00                	mov    (%eax),%eax
  804232:	a3 38 61 80 00       	mov    %eax,0x806138
  804237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80423a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804240:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804243:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80424a:	a1 44 61 80 00       	mov    0x806144,%eax
  80424f:	48                   	dec    %eax
  804250:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  804255:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804258:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80425f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804262:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  804269:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80426d:	75 17                	jne    804286 <insert_sorted_with_merge_freeList+0x655>
  80426f:	83 ec 04             	sub    $0x4,%esp
  804272:	68 9c 50 80 00       	push   $0x80509c
  804277:	68 6e 01 00 00       	push   $0x16e
  80427c:	68 bf 50 80 00       	push   $0x8050bf
  804281:	e8 24 d0 ff ff       	call   8012aa <_panic>
  804286:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80428c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80428f:	89 10                	mov    %edx,(%eax)
  804291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804294:	8b 00                	mov    (%eax),%eax
  804296:	85 c0                	test   %eax,%eax
  804298:	74 0d                	je     8042a7 <insert_sorted_with_merge_freeList+0x676>
  80429a:	a1 48 61 80 00       	mov    0x806148,%eax
  80429f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042a2:	89 50 04             	mov    %edx,0x4(%eax)
  8042a5:	eb 08                	jmp    8042af <insert_sorted_with_merge_freeList+0x67e>
  8042a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042aa:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8042af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042b2:	a3 48 61 80 00       	mov    %eax,0x806148
  8042b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042c1:	a1 54 61 80 00       	mov    0x806154,%eax
  8042c6:	40                   	inc    %eax
  8042c7:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  8042cc:	e9 a9 00 00 00       	jmp    80437a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8042d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042d5:	74 06                	je     8042dd <insert_sorted_with_merge_freeList+0x6ac>
  8042d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042db:	75 17                	jne    8042f4 <insert_sorted_with_merge_freeList+0x6c3>
  8042dd:	83 ec 04             	sub    $0x4,%esp
  8042e0:	68 34 51 80 00       	push   $0x805134
  8042e5:	68 73 01 00 00       	push   $0x173
  8042ea:	68 bf 50 80 00       	push   $0x8050bf
  8042ef:	e8 b6 cf ff ff       	call   8012aa <_panic>
  8042f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042f7:	8b 10                	mov    (%eax),%edx
  8042f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8042fc:	89 10                	mov    %edx,(%eax)
  8042fe:	8b 45 08             	mov    0x8(%ebp),%eax
  804301:	8b 00                	mov    (%eax),%eax
  804303:	85 c0                	test   %eax,%eax
  804305:	74 0b                	je     804312 <insert_sorted_with_merge_freeList+0x6e1>
  804307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80430a:	8b 00                	mov    (%eax),%eax
  80430c:	8b 55 08             	mov    0x8(%ebp),%edx
  80430f:	89 50 04             	mov    %edx,0x4(%eax)
  804312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804315:	8b 55 08             	mov    0x8(%ebp),%edx
  804318:	89 10                	mov    %edx,(%eax)
  80431a:	8b 45 08             	mov    0x8(%ebp),%eax
  80431d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804320:	89 50 04             	mov    %edx,0x4(%eax)
  804323:	8b 45 08             	mov    0x8(%ebp),%eax
  804326:	8b 00                	mov    (%eax),%eax
  804328:	85 c0                	test   %eax,%eax
  80432a:	75 08                	jne    804334 <insert_sorted_with_merge_freeList+0x703>
  80432c:	8b 45 08             	mov    0x8(%ebp),%eax
  80432f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804334:	a1 44 61 80 00       	mov    0x806144,%eax
  804339:	40                   	inc    %eax
  80433a:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  80433f:	eb 39                	jmp    80437a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  804341:	a1 40 61 80 00       	mov    0x806140,%eax
  804346:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804349:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80434d:	74 07                	je     804356 <insert_sorted_with_merge_freeList+0x725>
  80434f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804352:	8b 00                	mov    (%eax),%eax
  804354:	eb 05                	jmp    80435b <insert_sorted_with_merge_freeList+0x72a>
  804356:	b8 00 00 00 00       	mov    $0x0,%eax
  80435b:	a3 40 61 80 00       	mov    %eax,0x806140
  804360:	a1 40 61 80 00       	mov    0x806140,%eax
  804365:	85 c0                	test   %eax,%eax
  804367:	0f 85 c7 fb ff ff    	jne    803f34 <insert_sorted_with_merge_freeList+0x303>
  80436d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804371:	0f 85 bd fb ff ff    	jne    803f34 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804377:	eb 01                	jmp    80437a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  804379:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80437a:	90                   	nop
  80437b:	c9                   	leave  
  80437c:	c3                   	ret    
  80437d:	66 90                	xchg   %ax,%ax
  80437f:	90                   	nop

00804380 <__udivdi3>:
  804380:	55                   	push   %ebp
  804381:	57                   	push   %edi
  804382:	56                   	push   %esi
  804383:	53                   	push   %ebx
  804384:	83 ec 1c             	sub    $0x1c,%esp
  804387:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80438b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80438f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804393:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804397:	89 ca                	mov    %ecx,%edx
  804399:	89 f8                	mov    %edi,%eax
  80439b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80439f:	85 f6                	test   %esi,%esi
  8043a1:	75 2d                	jne    8043d0 <__udivdi3+0x50>
  8043a3:	39 cf                	cmp    %ecx,%edi
  8043a5:	77 65                	ja     80440c <__udivdi3+0x8c>
  8043a7:	89 fd                	mov    %edi,%ebp
  8043a9:	85 ff                	test   %edi,%edi
  8043ab:	75 0b                	jne    8043b8 <__udivdi3+0x38>
  8043ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8043b2:	31 d2                	xor    %edx,%edx
  8043b4:	f7 f7                	div    %edi
  8043b6:	89 c5                	mov    %eax,%ebp
  8043b8:	31 d2                	xor    %edx,%edx
  8043ba:	89 c8                	mov    %ecx,%eax
  8043bc:	f7 f5                	div    %ebp
  8043be:	89 c1                	mov    %eax,%ecx
  8043c0:	89 d8                	mov    %ebx,%eax
  8043c2:	f7 f5                	div    %ebp
  8043c4:	89 cf                	mov    %ecx,%edi
  8043c6:	89 fa                	mov    %edi,%edx
  8043c8:	83 c4 1c             	add    $0x1c,%esp
  8043cb:	5b                   	pop    %ebx
  8043cc:	5e                   	pop    %esi
  8043cd:	5f                   	pop    %edi
  8043ce:	5d                   	pop    %ebp
  8043cf:	c3                   	ret    
  8043d0:	39 ce                	cmp    %ecx,%esi
  8043d2:	77 28                	ja     8043fc <__udivdi3+0x7c>
  8043d4:	0f bd fe             	bsr    %esi,%edi
  8043d7:	83 f7 1f             	xor    $0x1f,%edi
  8043da:	75 40                	jne    80441c <__udivdi3+0x9c>
  8043dc:	39 ce                	cmp    %ecx,%esi
  8043de:	72 0a                	jb     8043ea <__udivdi3+0x6a>
  8043e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8043e4:	0f 87 9e 00 00 00    	ja     804488 <__udivdi3+0x108>
  8043ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8043ef:	89 fa                	mov    %edi,%edx
  8043f1:	83 c4 1c             	add    $0x1c,%esp
  8043f4:	5b                   	pop    %ebx
  8043f5:	5e                   	pop    %esi
  8043f6:	5f                   	pop    %edi
  8043f7:	5d                   	pop    %ebp
  8043f8:	c3                   	ret    
  8043f9:	8d 76 00             	lea    0x0(%esi),%esi
  8043fc:	31 ff                	xor    %edi,%edi
  8043fe:	31 c0                	xor    %eax,%eax
  804400:	89 fa                	mov    %edi,%edx
  804402:	83 c4 1c             	add    $0x1c,%esp
  804405:	5b                   	pop    %ebx
  804406:	5e                   	pop    %esi
  804407:	5f                   	pop    %edi
  804408:	5d                   	pop    %ebp
  804409:	c3                   	ret    
  80440a:	66 90                	xchg   %ax,%ax
  80440c:	89 d8                	mov    %ebx,%eax
  80440e:	f7 f7                	div    %edi
  804410:	31 ff                	xor    %edi,%edi
  804412:	89 fa                	mov    %edi,%edx
  804414:	83 c4 1c             	add    $0x1c,%esp
  804417:	5b                   	pop    %ebx
  804418:	5e                   	pop    %esi
  804419:	5f                   	pop    %edi
  80441a:	5d                   	pop    %ebp
  80441b:	c3                   	ret    
  80441c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804421:	89 eb                	mov    %ebp,%ebx
  804423:	29 fb                	sub    %edi,%ebx
  804425:	89 f9                	mov    %edi,%ecx
  804427:	d3 e6                	shl    %cl,%esi
  804429:	89 c5                	mov    %eax,%ebp
  80442b:	88 d9                	mov    %bl,%cl
  80442d:	d3 ed                	shr    %cl,%ebp
  80442f:	89 e9                	mov    %ebp,%ecx
  804431:	09 f1                	or     %esi,%ecx
  804433:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804437:	89 f9                	mov    %edi,%ecx
  804439:	d3 e0                	shl    %cl,%eax
  80443b:	89 c5                	mov    %eax,%ebp
  80443d:	89 d6                	mov    %edx,%esi
  80443f:	88 d9                	mov    %bl,%cl
  804441:	d3 ee                	shr    %cl,%esi
  804443:	89 f9                	mov    %edi,%ecx
  804445:	d3 e2                	shl    %cl,%edx
  804447:	8b 44 24 08          	mov    0x8(%esp),%eax
  80444b:	88 d9                	mov    %bl,%cl
  80444d:	d3 e8                	shr    %cl,%eax
  80444f:	09 c2                	or     %eax,%edx
  804451:	89 d0                	mov    %edx,%eax
  804453:	89 f2                	mov    %esi,%edx
  804455:	f7 74 24 0c          	divl   0xc(%esp)
  804459:	89 d6                	mov    %edx,%esi
  80445b:	89 c3                	mov    %eax,%ebx
  80445d:	f7 e5                	mul    %ebp
  80445f:	39 d6                	cmp    %edx,%esi
  804461:	72 19                	jb     80447c <__udivdi3+0xfc>
  804463:	74 0b                	je     804470 <__udivdi3+0xf0>
  804465:	89 d8                	mov    %ebx,%eax
  804467:	31 ff                	xor    %edi,%edi
  804469:	e9 58 ff ff ff       	jmp    8043c6 <__udivdi3+0x46>
  80446e:	66 90                	xchg   %ax,%ax
  804470:	8b 54 24 08          	mov    0x8(%esp),%edx
  804474:	89 f9                	mov    %edi,%ecx
  804476:	d3 e2                	shl    %cl,%edx
  804478:	39 c2                	cmp    %eax,%edx
  80447a:	73 e9                	jae    804465 <__udivdi3+0xe5>
  80447c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80447f:	31 ff                	xor    %edi,%edi
  804481:	e9 40 ff ff ff       	jmp    8043c6 <__udivdi3+0x46>
  804486:	66 90                	xchg   %ax,%ax
  804488:	31 c0                	xor    %eax,%eax
  80448a:	e9 37 ff ff ff       	jmp    8043c6 <__udivdi3+0x46>
  80448f:	90                   	nop

00804490 <__umoddi3>:
  804490:	55                   	push   %ebp
  804491:	57                   	push   %edi
  804492:	56                   	push   %esi
  804493:	53                   	push   %ebx
  804494:	83 ec 1c             	sub    $0x1c,%esp
  804497:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80449b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80449f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8044a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8044af:	89 f3                	mov    %esi,%ebx
  8044b1:	89 fa                	mov    %edi,%edx
  8044b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044b7:	89 34 24             	mov    %esi,(%esp)
  8044ba:	85 c0                	test   %eax,%eax
  8044bc:	75 1a                	jne    8044d8 <__umoddi3+0x48>
  8044be:	39 f7                	cmp    %esi,%edi
  8044c0:	0f 86 a2 00 00 00    	jbe    804568 <__umoddi3+0xd8>
  8044c6:	89 c8                	mov    %ecx,%eax
  8044c8:	89 f2                	mov    %esi,%edx
  8044ca:	f7 f7                	div    %edi
  8044cc:	89 d0                	mov    %edx,%eax
  8044ce:	31 d2                	xor    %edx,%edx
  8044d0:	83 c4 1c             	add    $0x1c,%esp
  8044d3:	5b                   	pop    %ebx
  8044d4:	5e                   	pop    %esi
  8044d5:	5f                   	pop    %edi
  8044d6:	5d                   	pop    %ebp
  8044d7:	c3                   	ret    
  8044d8:	39 f0                	cmp    %esi,%eax
  8044da:	0f 87 ac 00 00 00    	ja     80458c <__umoddi3+0xfc>
  8044e0:	0f bd e8             	bsr    %eax,%ebp
  8044e3:	83 f5 1f             	xor    $0x1f,%ebp
  8044e6:	0f 84 ac 00 00 00    	je     804598 <__umoddi3+0x108>
  8044ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8044f1:	29 ef                	sub    %ebp,%edi
  8044f3:	89 fe                	mov    %edi,%esi
  8044f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8044f9:	89 e9                	mov    %ebp,%ecx
  8044fb:	d3 e0                	shl    %cl,%eax
  8044fd:	89 d7                	mov    %edx,%edi
  8044ff:	89 f1                	mov    %esi,%ecx
  804501:	d3 ef                	shr    %cl,%edi
  804503:	09 c7                	or     %eax,%edi
  804505:	89 e9                	mov    %ebp,%ecx
  804507:	d3 e2                	shl    %cl,%edx
  804509:	89 14 24             	mov    %edx,(%esp)
  80450c:	89 d8                	mov    %ebx,%eax
  80450e:	d3 e0                	shl    %cl,%eax
  804510:	89 c2                	mov    %eax,%edx
  804512:	8b 44 24 08          	mov    0x8(%esp),%eax
  804516:	d3 e0                	shl    %cl,%eax
  804518:	89 44 24 04          	mov    %eax,0x4(%esp)
  80451c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804520:	89 f1                	mov    %esi,%ecx
  804522:	d3 e8                	shr    %cl,%eax
  804524:	09 d0                	or     %edx,%eax
  804526:	d3 eb                	shr    %cl,%ebx
  804528:	89 da                	mov    %ebx,%edx
  80452a:	f7 f7                	div    %edi
  80452c:	89 d3                	mov    %edx,%ebx
  80452e:	f7 24 24             	mull   (%esp)
  804531:	89 c6                	mov    %eax,%esi
  804533:	89 d1                	mov    %edx,%ecx
  804535:	39 d3                	cmp    %edx,%ebx
  804537:	0f 82 87 00 00 00    	jb     8045c4 <__umoddi3+0x134>
  80453d:	0f 84 91 00 00 00    	je     8045d4 <__umoddi3+0x144>
  804543:	8b 54 24 04          	mov    0x4(%esp),%edx
  804547:	29 f2                	sub    %esi,%edx
  804549:	19 cb                	sbb    %ecx,%ebx
  80454b:	89 d8                	mov    %ebx,%eax
  80454d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804551:	d3 e0                	shl    %cl,%eax
  804553:	89 e9                	mov    %ebp,%ecx
  804555:	d3 ea                	shr    %cl,%edx
  804557:	09 d0                	or     %edx,%eax
  804559:	89 e9                	mov    %ebp,%ecx
  80455b:	d3 eb                	shr    %cl,%ebx
  80455d:	89 da                	mov    %ebx,%edx
  80455f:	83 c4 1c             	add    $0x1c,%esp
  804562:	5b                   	pop    %ebx
  804563:	5e                   	pop    %esi
  804564:	5f                   	pop    %edi
  804565:	5d                   	pop    %ebp
  804566:	c3                   	ret    
  804567:	90                   	nop
  804568:	89 fd                	mov    %edi,%ebp
  80456a:	85 ff                	test   %edi,%edi
  80456c:	75 0b                	jne    804579 <__umoddi3+0xe9>
  80456e:	b8 01 00 00 00       	mov    $0x1,%eax
  804573:	31 d2                	xor    %edx,%edx
  804575:	f7 f7                	div    %edi
  804577:	89 c5                	mov    %eax,%ebp
  804579:	89 f0                	mov    %esi,%eax
  80457b:	31 d2                	xor    %edx,%edx
  80457d:	f7 f5                	div    %ebp
  80457f:	89 c8                	mov    %ecx,%eax
  804581:	f7 f5                	div    %ebp
  804583:	89 d0                	mov    %edx,%eax
  804585:	e9 44 ff ff ff       	jmp    8044ce <__umoddi3+0x3e>
  80458a:	66 90                	xchg   %ax,%ax
  80458c:	89 c8                	mov    %ecx,%eax
  80458e:	89 f2                	mov    %esi,%edx
  804590:	83 c4 1c             	add    $0x1c,%esp
  804593:	5b                   	pop    %ebx
  804594:	5e                   	pop    %esi
  804595:	5f                   	pop    %edi
  804596:	5d                   	pop    %ebp
  804597:	c3                   	ret    
  804598:	3b 04 24             	cmp    (%esp),%eax
  80459b:	72 06                	jb     8045a3 <__umoddi3+0x113>
  80459d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8045a1:	77 0f                	ja     8045b2 <__umoddi3+0x122>
  8045a3:	89 f2                	mov    %esi,%edx
  8045a5:	29 f9                	sub    %edi,%ecx
  8045a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8045ab:	89 14 24             	mov    %edx,(%esp)
  8045ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8045b6:	8b 14 24             	mov    (%esp),%edx
  8045b9:	83 c4 1c             	add    $0x1c,%esp
  8045bc:	5b                   	pop    %ebx
  8045bd:	5e                   	pop    %esi
  8045be:	5f                   	pop    %edi
  8045bf:	5d                   	pop    %ebp
  8045c0:	c3                   	ret    
  8045c1:	8d 76 00             	lea    0x0(%esi),%esi
  8045c4:	2b 04 24             	sub    (%esp),%eax
  8045c7:	19 fa                	sbb    %edi,%edx
  8045c9:	89 d1                	mov    %edx,%ecx
  8045cb:	89 c6                	mov    %eax,%esi
  8045cd:	e9 71 ff ff ff       	jmp    804543 <__umoddi3+0xb3>
  8045d2:	66 90                	xchg   %ax,%ax
  8045d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8045d8:	72 ea                	jb     8045c4 <__umoddi3+0x134>
  8045da:	89 d9                	mov    %ebx,%ecx
  8045dc:	e9 62 ff ff ff       	jmp    804543 <__umoddi3+0xb3>
