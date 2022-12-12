
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
  800062:	68 a0 45 80 00       	push   $0x8045a0
  800067:	e8 f2 14 00 00       	call   80155e <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 fa 26 00 00       	call   80276e <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 92 27 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  8000a1:	68 c4 45 80 00       	push   $0x8045c4
  8000a6:	6a 11                	push   $0x11
  8000a8:	68 f4 45 80 00       	push   $0x8045f4
  8000ad:	e8 f8 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000b5:	e8 b4 26 00 00       	call   80276e <sys_calculate_free_frames>
  8000ba:	29 c3                	sub    %eax,%ebx
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 0c 46 80 00       	push   $0x80460c
  8000cb:	6a 13                	push   $0x13
  8000cd:	68 f4 45 80 00       	push   $0x8045f4
  8000d2:	e8 d3 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256)panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 32 27 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  8000dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 78 46 80 00       	push   $0x804678
  8000ee:	6a 14                	push   $0x14
  8000f0:	68 f4 45 80 00       	push   $0x8045f4
  8000f5:	e8 b0 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000fa:	e8 6f 26 00 00       	call   80276e <sys_calculate_free_frames>
  8000ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800102:	e8 07 27 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  800133:	68 c4 45 80 00       	push   $0x8045c4
  800138:	6a 19                	push   $0x19
  80013a:	68 f4 45 80 00       	push   $0x8045f4
  80013f:	e8 66 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800144:	e8 25 26 00 00       	call   80276e <sys_calculate_free_frames>
  800149:	89 c2                	mov    %eax,%edx
  80014b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014e:	39 c2                	cmp    %eax,%edx
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 0c 46 80 00       	push   $0x80460c
  80015a:	6a 1b                	push   $0x1b
  80015c:	68 f4 45 80 00       	push   $0x8045f4
  800161:	e8 44 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800166:	e8 a3 26 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  80016b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80016e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 78 46 80 00       	push   $0x804678
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 f4 45 80 00       	push   $0x8045f4
  800184:	e8 21 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800189:	e8 e0 25 00 00       	call   80276e <sys_calculate_free_frames>
  80018e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800191:	e8 78 26 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  8001c4:	68 c4 45 80 00       	push   $0x8045c4
  8001c9:	6a 21                	push   $0x21
  8001cb:	68 f4 45 80 00       	push   $0x8045f4
  8001d0:	e8 d5 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001d5:	e8 94 25 00 00       	call   80276e <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 0c 46 80 00       	push   $0x80460c
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 f4 45 80 00       	push   $0x8045f4
  8001f2:	e8 b3 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8001f7:	e8 12 26 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  8001fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 78 46 80 00       	push   $0x804678
  80020e:	6a 24                	push   $0x24
  800210:	68 f4 45 80 00       	push   $0x8045f4
  800215:	e8 90 10 00 00       	call   8012aa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80021a:	e8 4f 25 00 00       	call   80276e <sys_calculate_free_frames>
  80021f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800222:	e8 e7 25 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  800259:	68 c4 45 80 00       	push   $0x8045c4
  80025e:	6a 2a                	push   $0x2a
  800260:	68 f4 45 80 00       	push   $0x8045f4
  800265:	e8 40 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026a:	e8 ff 24 00 00       	call   80276e <sys_calculate_free_frames>
  80026f:	89 c2                	mov    %eax,%edx
  800271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 0c 46 80 00       	push   $0x80460c
  800280:	6a 2c                	push   $0x2c
  800282:	68 f4 45 80 00       	push   $0x8045f4
  800287:	e8 1e 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80028c:	e8 7d 25 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	3d 00 01 00 00       	cmp    $0x100,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 78 46 80 00       	push   $0x804678
  8002a3:	6a 2d                	push   $0x2d
  8002a5:	68 f4 45 80 00       	push   $0x8045f4
  8002aa:	e8 fb 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 ba 24 00 00       	call   80276e <sys_calculate_free_frames>
  8002b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 52 25 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  8002ed:	68 c4 45 80 00       	push   $0x8045c4
  8002f2:	6a 33                	push   $0x33
  8002f4:	68 f4 45 80 00       	push   $0x8045f4
  8002f9:	e8 ac 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800301:	e8 68 24 00 00       	call   80276e <sys_calculate_free_frames>
  800306:	29 c3                	sub    %eax,%ebx
  800308:	89 d8                	mov    %ebx,%eax
  80030a:	83 f8 01             	cmp    $0x1,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 0c 46 80 00       	push   $0x80460c
  800317:	6a 35                	push   $0x35
  800319:	68 f4 45 80 00       	push   $0x8045f4
  80031e:	e8 87 0f 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800323:	e8 e6 24 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800328:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 78 46 80 00       	push   $0x804678
  80033a:	6a 36                	push   $0x36
  80033c:	68 f4 45 80 00       	push   $0x8045f4
  800341:	e8 64 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800346:	e8 23 24 00 00       	call   80276e <sys_calculate_free_frames>
  80034b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80034e:	e8 bb 24 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  800389:	68 c4 45 80 00       	push   $0x8045c4
  80038e:	6a 3c                	push   $0x3c
  800390:	68 f4 45 80 00       	push   $0x8045f4
  800395:	e8 10 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039a:	e8 cf 23 00 00       	call   80276e <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 0c 46 80 00       	push   $0x80460c
  8003b0:	6a 3e                	push   $0x3e
  8003b2:	68 f4 45 80 00       	push   $0x8045f4
  8003b7:	e8 ee 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003bc:	e8 4d 24 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  8003c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 78 46 80 00       	push   $0x804678
  8003d3:	6a 3f                	push   $0x3f
  8003d5:	68 f4 45 80 00       	push   $0x8045f4
  8003da:	e8 cb 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 8a 23 00 00       	call   80276e <sys_calculate_free_frames>
  8003e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 22 24 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  800421:	68 c4 45 80 00       	push   $0x8045c4
  800426:	6a 45                	push   $0x45
  800428:	68 f4 45 80 00       	push   $0x8045f4
  80042d:	e8 78 0e 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800432:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800435:	e8 34 23 00 00       	call   80276e <sys_calculate_free_frames>
  80043a:	29 c3                	sub    %eax,%ebx
  80043c:	89 d8                	mov    %ebx,%eax
  80043e:	83 f8 01             	cmp    $0x1,%eax
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 0c 46 80 00       	push   $0x80460c
  80044b:	6a 47                	push   $0x47
  80044d:	68 f4 45 80 00       	push   $0x8045f4
  800452:	e8 53 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800457:	e8 b2 23 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  80045c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80045f:	3d 00 03 00 00       	cmp    $0x300,%eax
  800464:	74 14                	je     80047a <_main+0x442>
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 78 46 80 00       	push   $0x804678
  80046e:	6a 48                	push   $0x48
  800470:	68 f4 45 80 00       	push   $0x8045f4
  800475:	e8 30 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80047a:	e8 ef 22 00 00       	call   80276e <sys_calculate_free_frames>
  80047f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800482:	e8 87 23 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  8004c4:	68 c4 45 80 00       	push   $0x8045c4
  8004c9:	6a 4e                	push   $0x4e
  8004cb:	68 f4 45 80 00       	push   $0x8045f4
  8004d0:	e8 d5 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8004d8:	e8 91 22 00 00       	call   80276e <sys_calculate_free_frames>
  8004dd:	29 c3                	sub    %eax,%ebx
  8004df:	89 d8                	mov    %ebx,%eax
  8004e1:	83 f8 01             	cmp    $0x1,%eax
  8004e4:	74 14                	je     8004fa <_main+0x4c2>
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 0c 46 80 00       	push   $0x80460c
  8004ee:	6a 50                	push   $0x50
  8004f0:	68 f4 45 80 00       	push   $0x8045f4
  8004f5:	e8 b0 0d 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8004fa:	e8 0f 23 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  8004ff:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800502:	3d 00 03 00 00       	cmp    $0x300,%eax
  800507:	74 14                	je     80051d <_main+0x4e5>
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 78 46 80 00       	push   $0x804678
  800511:	6a 51                	push   $0x51
  800513:	68 f4 45 80 00       	push   $0x8045f4
  800518:	e8 8d 0d 00 00       	call   8012aa <_panic>


		//NEW
		//Filling the remaining size of user heap
		freeFrames = sys_calculate_free_frames() ;
  80051d:	e8 4c 22 00 00       	call   80276e <sys_calculate_free_frames>
  800522:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800525:	e8 e4 22 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  80057f:	68 c4 45 80 00       	push   $0x8045c4
  800584:	6a 5a                	push   $0x5a
  800586:	68 f4 45 80 00       	push   $0x8045f4
  80058b:	e8 1a 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800590:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800593:	e8 d6 21 00 00       	call   80276e <sys_calculate_free_frames>
  800598:	29 c3                	sub    %eax,%ebx
  80059a:	89 d8                	mov    %ebx,%eax
  80059c:	83 f8 7c             	cmp    $0x7c,%eax
  80059f:	74 14                	je     8005b5 <_main+0x57d>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 0c 46 80 00       	push   $0x80460c
  8005a9:	6a 5c                	push   $0x5c
  8005ab:	68 f4 45 80 00       	push   $0x8045f4
  8005b0:	e8 f5 0c 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005b5:	e8 54 22 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  8005ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8005bd:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 78 46 80 00       	push   $0x804678
  8005cc:	6a 5d                	push   $0x5d
  8005ce:	68 f4 45 80 00       	push   $0x8045f4
  8005d3:	e8 d2 0c 00 00       	call   8012aa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 91 21 00 00       	call   80276e <sys_calculate_free_frames>
  8005dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e0:	e8 29 22 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8005e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	50                   	push   %eax
  8005ef:	e8 20 1f 00 00       	call   802514 <free>
  8005f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005f7:	e8 12 22 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  8005fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
  800601:	89 d0                	mov    %edx,%eax
  800603:	3d 00 01 00 00       	cmp    $0x100,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 a8 46 80 00       	push   $0x8046a8
  800612:	6a 68                	push   $0x68
  800614:	68 f4 45 80 00       	push   $0x8045f4
  800619:	e8 8c 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80061e:	e8 4b 21 00 00       	call   80276e <sys_calculate_free_frames>
  800623:	89 c2                	mov    %eax,%edx
  800625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	74 14                	je     800640 <_main+0x608>
  80062c:	83 ec 04             	sub    $0x4,%esp
  80062f:	68 e4 46 80 00       	push   $0x8046e4
  800634:	6a 69                	push   $0x69
  800636:	68 f4 45 80 00       	push   $0x8045f4
  80063b:	e8 6a 0c 00 00       	call   8012aa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800640:	e8 29 21 00 00       	call   80276e <sys_calculate_free_frames>
  800645:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800648:	e8 c1 21 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800650:	8b 45 90             	mov    -0x70(%ebp),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	50                   	push   %eax
  800657:	e8 b8 1e 00 00       	call   802514 <free>
  80065c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80065f:	e8 aa 21 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800667:	29 c2                	sub    %eax,%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800670:	74 14                	je     800686 <_main+0x64e>
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	68 a8 46 80 00       	push   $0x8046a8
  80067a:	6a 70                	push   $0x70
  80067c:	68 f4 45 80 00       	push   $0x8045f4
  800681:	e8 24 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800686:	e8 e3 20 00 00       	call   80276e <sys_calculate_free_frames>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 e4 46 80 00       	push   $0x8046e4
  80069c:	6a 71                	push   $0x71
  80069e:	68 f4 45 80 00       	push   $0x8045f4
  8006a3:	e8 02 0c 00 00       	call   8012aa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006a8:	e8 c1 20 00 00       	call   80276e <sys_calculate_free_frames>
  8006ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006b0:	e8 59 21 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8006b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	50                   	push   %eax
  8006bf:	e8 50 1e 00 00       	call   802514 <free>
  8006c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006c7:	e8 42 21 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  8006cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cf:	29 c2                	sub    %eax,%edx
  8006d1:	89 d0                	mov    %edx,%eax
  8006d3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006d8:	74 14                	je     8006ee <_main+0x6b6>
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	68 a8 46 80 00       	push   $0x8046a8
  8006e2:	6a 78                	push   $0x78
  8006e4:	68 f4 45 80 00       	push   $0x8045f4
  8006e9:	e8 bc 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006ee:	e8 7b 20 00 00       	call   80276e <sys_calculate_free_frames>
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f8:	39 c2                	cmp    %eax,%edx
  8006fa:	74 14                	je     800710 <_main+0x6d8>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 e4 46 80 00       	push   $0x8046e4
  800704:	6a 79                	push   $0x79
  800706:	68 f4 45 80 00       	push   $0x8045f4
  80070b:	e8 9a 0b 00 00       	call   8012aa <_panic>

		//NEW
		//free the latest Hole (the big one)
		freeFrames = sys_calculate_free_frames() ;
  800710:	e8 59 20 00 00       	call   80276e <sys_calculate_free_frames>
  800715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800718:	e8 f1 20 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  800720:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	50                   	push   %eax
  800727:	e8 e8 1d 00 00       	call   802514 <free>
  80072c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
  80072f:	e8 da 20 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
  800739:	89 d0                	mov    %edx,%eax
  80073b:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  800740:	74 17                	je     800759 <_main+0x721>
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	68 a8 46 80 00       	push   $0x8046a8
  80074a:	68 81 00 00 00       	push   $0x81
  80074f:	68 f4 45 80 00       	push   $0x8045f4
  800754:	e8 51 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800759:	e8 10 20 00 00       	call   80276e <sys_calculate_free_frames>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800763:	39 c2                	cmp    %eax,%edx
  800765:	74 17                	je     80077e <_main+0x746>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 e4 46 80 00       	push   $0x8046e4
  80076f:	68 82 00 00 00       	push   $0x82
  800774:	68 f4 45 80 00       	push   $0x8045f4
  800779:	e8 2c 0b 00 00       	call   8012aa <_panic>
	}
	int cnt = 0;
  80077e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800785:	e8 e4 1f 00 00       	call   80276e <sys_calculate_free_frames>
  80078a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80078d:	e8 7c 20 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  8007c2:	68 c4 45 80 00       	push   $0x8045c4
  8007c7:	68 8e 00 00 00       	push   $0x8e
  8007cc:	68 f4 45 80 00       	push   $0x8045f4
  8007d1:	e8 d4 0a 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8007d6:	e8 93 1f 00 00       	call   80276e <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 0c 46 80 00       	push   $0x80460c
  8007ec:	68 90 00 00 00       	push   $0x90
  8007f1:	68 f4 45 80 00       	push   $0x8045f4
  8007f6:	e8 af 0a 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  8007fb:	e8 0e 20 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800800:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800803:	3d 80 00 00 00       	cmp    $0x80,%eax
  800808:	74 17                	je     800821 <_main+0x7e9>
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 78 46 80 00       	push   $0x804678
  800812:	68 91 00 00 00       	push   $0x91
  800817:	68 f4 45 80 00       	push   $0x8045f4
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
  80088b:	e8 de 1e 00 00       	call   80276e <sys_calculate_free_frames>
  800890:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800893:	e8 76 1f 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  8008b3:	e8 34 1d 00 00       	call   8025ec <realloc>
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
  8008d2:	68 30 47 80 00       	push   $0x804730
  8008d7:	68 ae 00 00 00       	push   $0xae
  8008dc:	68 f4 45 80 00       	push   $0x8045f4
  8008e1:	e8 c4 09 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008e6:	e8 83 1e 00 00       	call   80276e <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 64 47 80 00       	push   $0x804764
  8008fc:	68 b0 00 00 00       	push   $0xb0
  800901:	68 f4 45 80 00       	push   $0x8045f4
  800906:	e8 9f 09 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are re-allocated in PageFile");
  80090b:	e8 fe 1e 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800910:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800913:	83 f8 40             	cmp    $0x40,%eax
  800916:	74 17                	je     80092f <_main+0x8f7>
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 d4 47 80 00       	push   $0x8047d4
  800920:	68 b1 00 00 00       	push   $0xb1
  800925:	68 f4 45 80 00       	push   $0x8045f4
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
  8009b9:	68 08 48 80 00       	push   $0x804808
  8009be:	68 c6 00 00 00       	push   $0xc6
  8009c3:	68 f4 45 80 00       	push   $0x8045f4
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
  8009f7:	68 08 48 80 00       	push   $0x804808
  8009fc:	68 cc 00 00 00       	push   $0xcc
  800a01:	68 f4 45 80 00       	push   $0x8045f4
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
  800a3b:	68 08 48 80 00       	push   $0x804808
  800a40:	68 d2 00 00 00       	push   $0xd2
  800a45:	68 f4 45 80 00       	push   $0x8045f4
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
  800a7e:	68 08 48 80 00       	push   $0x804808
  800a83:	68 d8 00 00 00       	push   $0xd8
  800a88:	68 f4 45 80 00       	push   $0x8045f4
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
  800aa0:	e8 c9 1c 00 00       	call   80276e <sys_calculate_free_frames>
  800aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800aa8:	e8 61 1d 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800ab0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	50                   	push   %eax
  800ab7:	e8 58 1a 00 00       	call   802514 <free>
  800abc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800abf:	e8 4a 1d 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800ad0:	74 17                	je     800ae9 <_main+0xab1>
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	68 40 48 80 00       	push   $0x804840
  800ada:	68 e0 00 00 00       	push   $0xe0
  800adf:	68 f4 45 80 00       	push   $0x8045f4
  800ae4:	e8 c1 07 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ae9:	e8 80 1c 00 00       	call   80276e <sys_calculate_free_frames>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	83 f8 05             	cmp    $0x5,%eax
  800afa:	74 17                	je     800b13 <_main+0xadb>
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	68 e4 46 80 00       	push   $0x8046e4
  800b04:	68 e1 00 00 00       	push   $0xe1
  800b09:	68 f4 45 80 00       	push   $0x8045f4
  800b0e:	e8 97 07 00 00       	call   8012aa <_panic>

		vcprintf("\b\b\b40%", NULL);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	6a 00                	push   $0x0
  800b18:	68 94 48 80 00       	push   $0x804894
  800b1d:	e8 d1 09 00 00       	call   8014f3 <vcprintf>
  800b22:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800b25:	e8 44 1c 00 00       	call   80276e <sys_calculate_free_frames>
  800b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b2d:	e8 dc 1c 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  800b6b:	68 c4 45 80 00       	push   $0x8045c4
  800b70:	68 eb 00 00 00       	push   $0xeb
  800b75:	68 f4 45 80 00       	push   $0x8045f4
  800b7a:	e8 2b 07 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b7f:	e8 ea 1b 00 00       	call   80276e <sys_calculate_free_frames>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	74 17                	je     800ba4 <_main+0xb6c>
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	68 0c 46 80 00       	push   $0x80460c
  800b95:	68 ed 00 00 00       	push   $0xed
  800b9a:	68 f4 45 80 00       	push   $0x8045f4
  800b9f:	e8 06 07 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800ba4:	e8 65 1c 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800ba9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800bac:	3d 80 01 00 00       	cmp    $0x180,%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 78 46 80 00       	push   $0x804678
  800bbb:	68 ee 00 00 00       	push   $0xee
  800bc0:	68 f4 45 80 00       	push   $0x8045f4
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
  800c3b:	e8 2e 1b 00 00       	call   80276e <sys_calculate_free_frames>
  800c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 c6 1b 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  800c6a:	e8 7d 19 00 00       	call   8025ec <realloc>
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
  800c8c:	68 30 47 80 00       	push   $0x804730
  800c91:	68 07 01 00 00       	push   $0x107
  800c96:	68 f4 45 80 00       	push   $0x8045f4
  800c9b:	e8 0a 06 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");

		//if((sys_calculate_free_frames() - freeFrames) != 3) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  800ca0:	e8 69 1b 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800ca5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cad:	74 17                	je     800cc6 <_main+0xc8e>
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	68 d4 47 80 00       	push   $0x8047d4
  800cb7:	68 0b 01 00 00       	push   $0x10b
  800cbc:	68 f4 45 80 00       	push   $0x8045f4
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
  800d59:	68 08 48 80 00       	push   $0x804808
  800d5e:	68 22 01 00 00       	push   $0x122
  800d63:	68 f4 45 80 00       	push   $0x8045f4
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
  800d97:	68 08 48 80 00       	push   $0x804808
  800d9c:	68 2a 01 00 00       	push   $0x12a
  800da1:	68 f4 45 80 00       	push   $0x8045f4
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
  800ddb:	68 08 48 80 00       	push   $0x804808
  800de0:	68 31 01 00 00       	push   $0x131
  800de5:	68 f4 45 80 00       	push   $0x8045f4
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
  800e1e:	68 08 48 80 00       	push   $0x804808
  800e23:	68 37 01 00 00       	push   $0x137
  800e28:	68 f4 45 80 00       	push   $0x8045f4
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
  800e40:	e8 29 19 00 00       	call   80276e <sys_calculate_free_frames>
  800e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e48:	e8 c1 19 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800e50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	e8 b8 16 00 00       	call   802514 <free>
  800e5c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e5f:	e8 aa 19 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	3d 80 02 00 00       	cmp    $0x280,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 40 48 80 00       	push   $0x804840
  800e7a:	68 40 01 00 00       	push   $0x140
  800e7f:	68 f4 45 80 00       	push   $0x8045f4
  800e84:	e8 21 04 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b70%", NULL);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	6a 00                	push   $0x0
  800e8e:	68 9b 48 80 00       	push   $0x80489b
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
  800f02:	e8 67 18 00 00       	call   80276e <sys_calculate_free_frames>
  800f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f0a:	e8 ff 18 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
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
  800f25:	e8 c2 16 00 00       	call   8025ec <realloc>
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
  800f50:	68 30 47 80 00       	push   $0x804730
  800f55:	68 60 01 00 00       	push   $0x160
  800f5a:	68 f4 45 80 00       	push   $0x8045f4
  800f5f:	e8 46 03 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are re-allocated in PageFile");
  800f64:	e8 a5 18 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  800f69:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f6c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800f71:	74 17                	je     800f8a <_main+0xf52>
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 d4 47 80 00       	push   $0x8047d4
  800f7b:	68 63 01 00 00       	push   $0x163
  800f80:	68 f4 45 80 00       	push   $0x8045f4
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
  801014:	68 08 48 80 00       	push   $0x804808
  801019:	68 79 01 00 00       	push   $0x179
  80101e:	68 f4 45 80 00       	push   $0x8045f4
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
  801052:	68 08 48 80 00       	push   $0x804808
  801057:	68 81 01 00 00       	push   $0x181
  80105c:	68 f4 45 80 00       	push   $0x8045f4
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
  801096:	68 08 48 80 00       	push   $0x804808
  80109b:	68 88 01 00 00       	push   $0x188
  8010a0:	68 f4 45 80 00       	push   $0x8045f4
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
  8010d9:	68 08 48 80 00       	push   $0x804808
  8010de:	68 8e 01 00 00       	push   $0x18e
  8010e3:	68 f4 45 80 00       	push   $0x8045f4
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
  8010fb:	e8 6e 16 00 00       	call   80276e <sys_calculate_free_frames>
  801100:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801103:	e8 06 17 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  801108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[0]);
  80110b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	e8 fd 13 00 00       	call   802514 <free>
  801117:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  80111a:	e8 ef 16 00 00       	call   80280e <sys_pf_calculate_allocated_pages>
  80111f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112b:	74 17                	je     801144 <_main+0x110c>
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 40 48 80 00       	push   $0x804840
  801135:	68 96 01 00 00       	push   $0x196
  80113a:	68 f4 45 80 00       	push   $0x8045f4
  80113f:	e8 66 01 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 2) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 00                	push   $0x0
  801149:	68 a2 48 80 00       	push   $0x8048a2
  80114e:	e8 a0 03 00 00       	call   8014f3 <vcprintf>
  801153:	83 c4 10             	add    $0x10,%esp
	}

	cprintf("Congratulations!! test realloc [1] completed successfully.\n");
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 ac 48 80 00       	push   $0x8048ac
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
  801174:	e8 d5 18 00 00       	call   802a4e <sys_getenvindex>
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
  8011df:	e8 77 16 00 00       	call   80285b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	68 00 49 80 00       	push   $0x804900
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
  80120f:	68 28 49 80 00       	push   $0x804928
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
  801240:	68 50 49 80 00       	push   $0x804950
  801245:	e8 14 03 00 00       	call   80155e <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80124d:	a1 20 60 80 00       	mov    0x806020,%eax
  801252:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	50                   	push   %eax
  80125c:	68 a8 49 80 00       	push   $0x8049a8
  801261:	e8 f8 02 00 00       	call   80155e <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	68 00 49 80 00       	push   $0x804900
  801271:	e8 e8 02 00 00       	call   80155e <cprintf>
  801276:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801279:	e8 f7 15 00 00       	call   802875 <sys_enable_interrupt>

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
  801291:	e8 84 17 00 00       	call   802a1a <sys_destroy_env>
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
  8012a2:	e8 d9 17 00 00       	call   802a80 <sys_exit_env>
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
  8012cb:	68 bc 49 80 00       	push   $0x8049bc
  8012d0:	e8 89 02 00 00       	call   80155e <cprintf>
  8012d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8012d8:	a1 00 60 80 00       	mov    0x806000,%eax
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	50                   	push   %eax
  8012e4:	68 c1 49 80 00       	push   $0x8049c1
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
  801308:	68 dd 49 80 00       	push   $0x8049dd
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
  801334:	68 e0 49 80 00       	push   $0x8049e0
  801339:	6a 26                	push   $0x26
  80133b:	68 2c 4a 80 00       	push   $0x804a2c
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
  801406:	68 38 4a 80 00       	push   $0x804a38
  80140b:	6a 3a                	push   $0x3a
  80140d:	68 2c 4a 80 00       	push   $0x804a2c
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
  801476:	68 8c 4a 80 00       	push   $0x804a8c
  80147b:	6a 44                	push   $0x44
  80147d:	68 2c 4a 80 00       	push   $0x804a2c
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
  8014d0:	e8 d8 11 00 00       	call   8026ad <sys_cputs>
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
  801547:	e8 61 11 00 00       	call   8026ad <sys_cputs>
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
  801591:	e8 c5 12 00 00       	call   80285b <sys_disable_interrupt>
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
  8015b1:	e8 bf 12 00 00       	call   802875 <sys_enable_interrupt>
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
  8015fb:	e8 30 2d 00 00       	call   804330 <__udivdi3>
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
  80164b:	e8 f0 2d 00 00       	call   804440 <__umoddi3>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	05 f4 4c 80 00       	add    $0x804cf4,%eax
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
  8017a6:	8b 04 85 18 4d 80 00 	mov    0x804d18(,%eax,4),%eax
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
  801887:	8b 34 9d 60 4b 80 00 	mov    0x804b60(,%ebx,4),%esi
  80188e:	85 f6                	test   %esi,%esi
  801890:	75 19                	jne    8018ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801892:	53                   	push   %ebx
  801893:	68 05 4d 80 00       	push   $0x804d05
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
  8018ac:	68 0e 4d 80 00       	push   $0x804d0e
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
  8018d9:	be 11 4d 80 00       	mov    $0x804d11,%esi
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
  8022ff:	68 70 4e 80 00       	push   $0x804e70
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
  8023cf:	e8 1d 04 00 00       	call   8027f1 <sys_allocate_chunk>
  8023d4:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8023d7:	a1 20 61 80 00       	mov    0x806120,%eax
  8023dc:	83 ec 0c             	sub    $0xc,%esp
  8023df:	50                   	push   %eax
  8023e0:	e8 92 0a 00 00       	call   802e77 <initialize_MemBlocksList>
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
  80240d:	68 95 4e 80 00       	push   $0x804e95
  802412:	6a 33                	push   $0x33
  802414:	68 b3 4e 80 00       	push   $0x804eb3
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
  80248c:	68 c0 4e 80 00       	push   $0x804ec0
  802491:	6a 34                	push   $0x34
  802493:	68 b3 4e 80 00       	push   $0x804eb3
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
  802501:	68 e4 4e 80 00       	push   $0x804ee4
  802506:	6a 46                	push   $0x46
  802508:	68 b3 4e 80 00       	push   $0x804eb3
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
  80251d:	68 0c 4f 80 00       	push   $0x804f0c
  802522:	6a 61                	push   $0x61
  802524:	68 b3 4e 80 00       	push   $0x804eb3
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
  802543:	75 07                	jne    80254c <smalloc+0x1e>
  802545:	b8 00 00 00 00       	mov    $0x0,%eax
  80254a:	eb 7c                	jmp    8025c8 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80254c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802553:	8b 55 0c             	mov    0xc(%ebp),%edx
  802556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802559:	01 d0                	add    %edx,%eax
  80255b:	48                   	dec    %eax
  80255c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80255f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802562:	ba 00 00 00 00       	mov    $0x0,%edx
  802567:	f7 75 f0             	divl   -0x10(%ebp)
  80256a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256d:	29 d0                	sub    %edx,%eax
  80256f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802572:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802579:	e8 41 06 00 00       	call   802bbf <sys_isUHeapPlacementStrategyFIRSTFIT>
  80257e:	85 c0                	test   %eax,%eax
  802580:	74 11                	je     802593 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  802582:	83 ec 0c             	sub    $0xc,%esp
  802585:	ff 75 e8             	pushl  -0x18(%ebp)
  802588:	e8 ac 0c 00 00       	call   803239 <alloc_block_FF>
  80258d:	83 c4 10             	add    $0x10,%esp
  802590:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  802593:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802597:	74 2a                	je     8025c3 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 40 08             	mov    0x8(%eax),%eax
  80259f:	89 c2                	mov    %eax,%edx
  8025a1:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8025a5:	52                   	push   %edx
  8025a6:	50                   	push   %eax
  8025a7:	ff 75 0c             	pushl  0xc(%ebp)
  8025aa:	ff 75 08             	pushl  0x8(%ebp)
  8025ad:	e8 92 03 00 00       	call   802944 <sys_createSharedObject>
  8025b2:	83 c4 10             	add    $0x10,%esp
  8025b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8025b8:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8025bc:	74 05                	je     8025c3 <smalloc+0x95>
			return (void*)virtual_address;
  8025be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c1:	eb 05                	jmp    8025c8 <smalloc+0x9a>
	}
	return NULL;
  8025c3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
  8025cd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8025d0:	e8 13 fd ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8025d5:	83 ec 04             	sub    $0x4,%esp
  8025d8:	68 30 4f 80 00       	push   $0x804f30
  8025dd:	68 a2 00 00 00       	push   $0xa2
  8025e2:	68 b3 4e 80 00       	push   $0x804eb3
  8025e7:	e8 be ec ff ff       	call   8012aa <_panic>

008025ec <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8025f2:	e8 f1 fc ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8025f7:	83 ec 04             	sub    $0x4,%esp
  8025fa:	68 54 4f 80 00       	push   $0x804f54
  8025ff:	68 e6 00 00 00       	push   $0xe6
  802604:	68 b3 4e 80 00       	push   $0x804eb3
  802609:	e8 9c ec ff ff       	call   8012aa <_panic>

0080260e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
  802611:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802614:	83 ec 04             	sub    $0x4,%esp
  802617:	68 7c 4f 80 00       	push   $0x804f7c
  80261c:	68 fa 00 00 00       	push   $0xfa
  802621:	68 b3 4e 80 00       	push   $0x804eb3
  802626:	e8 7f ec ff ff       	call   8012aa <_panic>

0080262b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
  80262e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	68 a0 4f 80 00       	push   $0x804fa0
  802639:	68 05 01 00 00       	push   $0x105
  80263e:	68 b3 4e 80 00       	push   $0x804eb3
  802643:	e8 62 ec ff ff       	call   8012aa <_panic>

00802648 <shrink>:

}
void shrink(uint32 newSize)
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
  80264b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80264e:	83 ec 04             	sub    $0x4,%esp
  802651:	68 a0 4f 80 00       	push   $0x804fa0
  802656:	68 0a 01 00 00       	push   $0x10a
  80265b:	68 b3 4e 80 00       	push   $0x804eb3
  802660:	e8 45 ec ff ff       	call   8012aa <_panic>

00802665 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80266b:	83 ec 04             	sub    $0x4,%esp
  80266e:	68 a0 4f 80 00       	push   $0x804fa0
  802673:	68 0f 01 00 00       	push   $0x10f
  802678:	68 b3 4e 80 00       	push   $0x804eb3
  80267d:	e8 28 ec ff ff       	call   8012aa <_panic>

00802682 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
  802685:	57                   	push   %edi
  802686:	56                   	push   %esi
  802687:	53                   	push   %ebx
  802688:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80268b:	8b 45 08             	mov    0x8(%ebp),%eax
  80268e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802691:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802694:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802697:	8b 7d 18             	mov    0x18(%ebp),%edi
  80269a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80269d:	cd 30                	int    $0x30
  80269f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8026a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8026a5:	83 c4 10             	add    $0x10,%esp
  8026a8:	5b                   	pop    %ebx
  8026a9:	5e                   	pop    %esi
  8026aa:	5f                   	pop    %edi
  8026ab:	5d                   	pop    %ebp
  8026ac:	c3                   	ret    

008026ad <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	83 ec 04             	sub    $0x4,%esp
  8026b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8026b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8026b9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	52                   	push   %edx
  8026c5:	ff 75 0c             	pushl  0xc(%ebp)
  8026c8:	50                   	push   %eax
  8026c9:	6a 00                	push   $0x0
  8026cb:	e8 b2 ff ff ff       	call   802682 <syscall>
  8026d0:	83 c4 18             	add    $0x18,%esp
}
  8026d3:	90                   	nop
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

008026d6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 01                	push   $0x1
  8026e5:	e8 98 ff ff ff       	call   802682 <syscall>
  8026ea:	83 c4 18             	add    $0x18,%esp
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8026f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 00                	push   $0x0
  8026fe:	52                   	push   %edx
  8026ff:	50                   	push   %eax
  802700:	6a 05                	push   $0x5
  802702:	e8 7b ff ff ff       	call   802682 <syscall>
  802707:	83 c4 18             	add    $0x18,%esp
}
  80270a:	c9                   	leave  
  80270b:	c3                   	ret    

0080270c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80270c:	55                   	push   %ebp
  80270d:	89 e5                	mov    %esp,%ebp
  80270f:	56                   	push   %esi
  802710:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802711:	8b 75 18             	mov    0x18(%ebp),%esi
  802714:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802717:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80271a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80271d:	8b 45 08             	mov    0x8(%ebp),%eax
  802720:	56                   	push   %esi
  802721:	53                   	push   %ebx
  802722:	51                   	push   %ecx
  802723:	52                   	push   %edx
  802724:	50                   	push   %eax
  802725:	6a 06                	push   $0x6
  802727:	e8 56 ff ff ff       	call   802682 <syscall>
  80272c:	83 c4 18             	add    $0x18,%esp
}
  80272f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802732:	5b                   	pop    %ebx
  802733:	5e                   	pop    %esi
  802734:	5d                   	pop    %ebp
  802735:	c3                   	ret    

00802736 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	52                   	push   %edx
  802746:	50                   	push   %eax
  802747:	6a 07                	push   $0x7
  802749:	e8 34 ff ff ff       	call   802682 <syscall>
  80274e:	83 c4 18             	add    $0x18,%esp
}
  802751:	c9                   	leave  
  802752:	c3                   	ret    

00802753 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802753:	55                   	push   %ebp
  802754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	ff 75 0c             	pushl  0xc(%ebp)
  80275f:	ff 75 08             	pushl  0x8(%ebp)
  802762:	6a 08                	push   $0x8
  802764:	e8 19 ff ff ff       	call   802682 <syscall>
  802769:	83 c4 18             	add    $0x18,%esp
}
  80276c:	c9                   	leave  
  80276d:	c3                   	ret    

0080276e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 09                	push   $0x9
  80277d:	e8 00 ff ff ff       	call   802682 <syscall>
  802782:	83 c4 18             	add    $0x18,%esp
}
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	6a 00                	push   $0x0
  802794:	6a 0a                	push   $0xa
  802796:	e8 e7 fe ff ff       	call   802682 <syscall>
  80279b:	83 c4 18             	add    $0x18,%esp
}
  80279e:	c9                   	leave  
  80279f:	c3                   	ret    

008027a0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8027a0:	55                   	push   %ebp
  8027a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 0b                	push   $0xb
  8027af:	e8 ce fe ff ff       	call   802682 <syscall>
  8027b4:	83 c4 18             	add    $0x18,%esp
}
  8027b7:	c9                   	leave  
  8027b8:	c3                   	ret    

008027b9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8027b9:	55                   	push   %ebp
  8027ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	ff 75 0c             	pushl  0xc(%ebp)
  8027c5:	ff 75 08             	pushl  0x8(%ebp)
  8027c8:	6a 0f                	push   $0xf
  8027ca:	e8 b3 fe ff ff       	call   802682 <syscall>
  8027cf:	83 c4 18             	add    $0x18,%esp
	return;
  8027d2:	90                   	nop
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 00                	push   $0x0
  8027de:	ff 75 0c             	pushl  0xc(%ebp)
  8027e1:	ff 75 08             	pushl  0x8(%ebp)
  8027e4:	6a 10                	push   $0x10
  8027e6:	e8 97 fe ff ff       	call   802682 <syscall>
  8027eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ee:	90                   	nop
}
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    

008027f1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	ff 75 10             	pushl  0x10(%ebp)
  8027fb:	ff 75 0c             	pushl  0xc(%ebp)
  8027fe:	ff 75 08             	pushl  0x8(%ebp)
  802801:	6a 11                	push   $0x11
  802803:	e8 7a fe ff ff       	call   802682 <syscall>
  802808:	83 c4 18             	add    $0x18,%esp
	return ;
  80280b:	90                   	nop
}
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    

0080280e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	6a 0c                	push   $0xc
  80281d:	e8 60 fe ff ff       	call   802682 <syscall>
  802822:	83 c4 18             	add    $0x18,%esp
}
  802825:	c9                   	leave  
  802826:	c3                   	ret    

00802827 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802827:	55                   	push   %ebp
  802828:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 00                	push   $0x0
  802832:	ff 75 08             	pushl  0x8(%ebp)
  802835:	6a 0d                	push   $0xd
  802837:	e8 46 fe ff ff       	call   802682 <syscall>
  80283c:	83 c4 18             	add    $0x18,%esp
}
  80283f:	c9                   	leave  
  802840:	c3                   	ret    

00802841 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	6a 00                	push   $0x0
  80284a:	6a 00                	push   $0x0
  80284c:	6a 00                	push   $0x0
  80284e:	6a 0e                	push   $0xe
  802850:	e8 2d fe ff ff       	call   802682 <syscall>
  802855:	83 c4 18             	add    $0x18,%esp
}
  802858:	90                   	nop
  802859:	c9                   	leave  
  80285a:	c3                   	ret    

0080285b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80285e:	6a 00                	push   $0x0
  802860:	6a 00                	push   $0x0
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	6a 13                	push   $0x13
  80286a:	e8 13 fe ff ff       	call   802682 <syscall>
  80286f:	83 c4 18             	add    $0x18,%esp
}
  802872:	90                   	nop
  802873:	c9                   	leave  
  802874:	c3                   	ret    

00802875 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802878:	6a 00                	push   $0x0
  80287a:	6a 00                	push   $0x0
  80287c:	6a 00                	push   $0x0
  80287e:	6a 00                	push   $0x0
  802880:	6a 00                	push   $0x0
  802882:	6a 14                	push   $0x14
  802884:	e8 f9 fd ff ff       	call   802682 <syscall>
  802889:	83 c4 18             	add    $0x18,%esp
}
  80288c:	90                   	nop
  80288d:	c9                   	leave  
  80288e:	c3                   	ret    

0080288f <sys_cputc>:


void
sys_cputc(const char c)
{
  80288f:	55                   	push   %ebp
  802890:	89 e5                	mov    %esp,%ebp
  802892:	83 ec 04             	sub    $0x4,%esp
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80289b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80289f:	6a 00                	push   $0x0
  8028a1:	6a 00                	push   $0x0
  8028a3:	6a 00                	push   $0x0
  8028a5:	6a 00                	push   $0x0
  8028a7:	50                   	push   %eax
  8028a8:	6a 15                	push   $0x15
  8028aa:	e8 d3 fd ff ff       	call   802682 <syscall>
  8028af:	83 c4 18             	add    $0x18,%esp
}
  8028b2:	90                   	nop
  8028b3:	c9                   	leave  
  8028b4:	c3                   	ret    

008028b5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8028b5:	55                   	push   %ebp
  8028b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 00                	push   $0x0
  8028c2:	6a 16                	push   $0x16
  8028c4:	e8 b9 fd ff ff       	call   802682 <syscall>
  8028c9:	83 c4 18             	add    $0x18,%esp
}
  8028cc:	90                   	nop
  8028cd:	c9                   	leave  
  8028ce:	c3                   	ret    

008028cf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8028cf:	55                   	push   %ebp
  8028d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	6a 00                	push   $0x0
  8028d7:	6a 00                	push   $0x0
  8028d9:	6a 00                	push   $0x0
  8028db:	ff 75 0c             	pushl  0xc(%ebp)
  8028de:	50                   	push   %eax
  8028df:	6a 17                	push   $0x17
  8028e1:	e8 9c fd ff ff       	call   802682 <syscall>
  8028e6:	83 c4 18             	add    $0x18,%esp
}
  8028e9:	c9                   	leave  
  8028ea:	c3                   	ret    

008028eb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8028eb:	55                   	push   %ebp
  8028ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8028ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	6a 00                	push   $0x0
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 00                	push   $0x0
  8028fa:	52                   	push   %edx
  8028fb:	50                   	push   %eax
  8028fc:	6a 1a                	push   $0x1a
  8028fe:	e8 7f fd ff ff       	call   802682 <syscall>
  802903:	83 c4 18             	add    $0x18,%esp
}
  802906:	c9                   	leave  
  802907:	c3                   	ret    

00802908 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802908:	55                   	push   %ebp
  802909:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80290b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	52                   	push   %edx
  802918:	50                   	push   %eax
  802919:	6a 18                	push   $0x18
  80291b:	e8 62 fd ff ff       	call   802682 <syscall>
  802920:	83 c4 18             	add    $0x18,%esp
}
  802923:	90                   	nop
  802924:	c9                   	leave  
  802925:	c3                   	ret    

00802926 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802929:	8b 55 0c             	mov    0xc(%ebp),%edx
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	6a 00                	push   $0x0
  802931:	6a 00                	push   $0x0
  802933:	6a 00                	push   $0x0
  802935:	52                   	push   %edx
  802936:	50                   	push   %eax
  802937:	6a 19                	push   $0x19
  802939:	e8 44 fd ff ff       	call   802682 <syscall>
  80293e:	83 c4 18             	add    $0x18,%esp
}
  802941:	90                   	nop
  802942:	c9                   	leave  
  802943:	c3                   	ret    

00802944 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
  802947:	83 ec 04             	sub    $0x4,%esp
  80294a:	8b 45 10             	mov    0x10(%ebp),%eax
  80294d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802950:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802953:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	6a 00                	push   $0x0
  80295c:	51                   	push   %ecx
  80295d:	52                   	push   %edx
  80295e:	ff 75 0c             	pushl  0xc(%ebp)
  802961:	50                   	push   %eax
  802962:	6a 1b                	push   $0x1b
  802964:	e8 19 fd ff ff       	call   802682 <syscall>
  802969:	83 c4 18             	add    $0x18,%esp
}
  80296c:	c9                   	leave  
  80296d:	c3                   	ret    

0080296e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802971:	8b 55 0c             	mov    0xc(%ebp),%edx
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	6a 00                	push   $0x0
  802979:	6a 00                	push   $0x0
  80297b:	6a 00                	push   $0x0
  80297d:	52                   	push   %edx
  80297e:	50                   	push   %eax
  80297f:	6a 1c                	push   $0x1c
  802981:	e8 fc fc ff ff       	call   802682 <syscall>
  802986:	83 c4 18             	add    $0x18,%esp
}
  802989:	c9                   	leave  
  80298a:	c3                   	ret    

0080298b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80298e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802991:	8b 55 0c             	mov    0xc(%ebp),%edx
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	6a 00                	push   $0x0
  802999:	6a 00                	push   $0x0
  80299b:	51                   	push   %ecx
  80299c:	52                   	push   %edx
  80299d:	50                   	push   %eax
  80299e:	6a 1d                	push   $0x1d
  8029a0:	e8 dd fc ff ff       	call   802682 <syscall>
  8029a5:	83 c4 18             	add    $0x18,%esp
}
  8029a8:	c9                   	leave  
  8029a9:	c3                   	ret    

008029aa <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8029aa:	55                   	push   %ebp
  8029ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8029ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	6a 00                	push   $0x0
  8029b5:	6a 00                	push   $0x0
  8029b7:	6a 00                	push   $0x0
  8029b9:	52                   	push   %edx
  8029ba:	50                   	push   %eax
  8029bb:	6a 1e                	push   $0x1e
  8029bd:	e8 c0 fc ff ff       	call   802682 <syscall>
  8029c2:	83 c4 18             	add    $0x18,%esp
}
  8029c5:	c9                   	leave  
  8029c6:	c3                   	ret    

008029c7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8029c7:	55                   	push   %ebp
  8029c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8029ca:	6a 00                	push   $0x0
  8029cc:	6a 00                	push   $0x0
  8029ce:	6a 00                	push   $0x0
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 1f                	push   $0x1f
  8029d6:	e8 a7 fc ff ff       	call   802682 <syscall>
  8029db:	83 c4 18             	add    $0x18,%esp
}
  8029de:	c9                   	leave  
  8029df:	c3                   	ret    

008029e0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8029e0:	55                   	push   %ebp
  8029e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	6a 00                	push   $0x0
  8029e8:	ff 75 14             	pushl  0x14(%ebp)
  8029eb:	ff 75 10             	pushl  0x10(%ebp)
  8029ee:	ff 75 0c             	pushl  0xc(%ebp)
  8029f1:	50                   	push   %eax
  8029f2:	6a 20                	push   $0x20
  8029f4:	e8 89 fc ff ff       	call   802682 <syscall>
  8029f9:	83 c4 18             	add    $0x18,%esp
}
  8029fc:	c9                   	leave  
  8029fd:	c3                   	ret    

008029fe <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8029fe:	55                   	push   %ebp
  8029ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	50                   	push   %eax
  802a0d:	6a 21                	push   $0x21
  802a0f:	e8 6e fc ff ff       	call   802682 <syscall>
  802a14:	83 c4 18             	add    $0x18,%esp
}
  802a17:	90                   	nop
  802a18:	c9                   	leave  
  802a19:	c3                   	ret    

00802a1a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802a1a:	55                   	push   %ebp
  802a1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	6a 00                	push   $0x0
  802a22:	6a 00                	push   $0x0
  802a24:	6a 00                	push   $0x0
  802a26:	6a 00                	push   $0x0
  802a28:	50                   	push   %eax
  802a29:	6a 22                	push   $0x22
  802a2b:	e8 52 fc ff ff       	call   802682 <syscall>
  802a30:	83 c4 18             	add    $0x18,%esp
}
  802a33:	c9                   	leave  
  802a34:	c3                   	ret    

00802a35 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802a35:	55                   	push   %ebp
  802a36:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802a38:	6a 00                	push   $0x0
  802a3a:	6a 00                	push   $0x0
  802a3c:	6a 00                	push   $0x0
  802a3e:	6a 00                	push   $0x0
  802a40:	6a 00                	push   $0x0
  802a42:	6a 02                	push   $0x2
  802a44:	e8 39 fc ff ff       	call   802682 <syscall>
  802a49:	83 c4 18             	add    $0x18,%esp
}
  802a4c:	c9                   	leave  
  802a4d:	c3                   	ret    

00802a4e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802a4e:	55                   	push   %ebp
  802a4f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802a51:	6a 00                	push   $0x0
  802a53:	6a 00                	push   $0x0
  802a55:	6a 00                	push   $0x0
  802a57:	6a 00                	push   $0x0
  802a59:	6a 00                	push   $0x0
  802a5b:	6a 03                	push   $0x3
  802a5d:	e8 20 fc ff ff       	call   802682 <syscall>
  802a62:	83 c4 18             	add    $0x18,%esp
}
  802a65:	c9                   	leave  
  802a66:	c3                   	ret    

00802a67 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802a67:	55                   	push   %ebp
  802a68:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802a6a:	6a 00                	push   $0x0
  802a6c:	6a 00                	push   $0x0
  802a6e:	6a 00                	push   $0x0
  802a70:	6a 00                	push   $0x0
  802a72:	6a 00                	push   $0x0
  802a74:	6a 04                	push   $0x4
  802a76:	e8 07 fc ff ff       	call   802682 <syscall>
  802a7b:	83 c4 18             	add    $0x18,%esp
}
  802a7e:	c9                   	leave  
  802a7f:	c3                   	ret    

00802a80 <sys_exit_env>:


void sys_exit_env(void)
{
  802a80:	55                   	push   %ebp
  802a81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a83:	6a 00                	push   $0x0
  802a85:	6a 00                	push   $0x0
  802a87:	6a 00                	push   $0x0
  802a89:	6a 00                	push   $0x0
  802a8b:	6a 00                	push   $0x0
  802a8d:	6a 23                	push   $0x23
  802a8f:	e8 ee fb ff ff       	call   802682 <syscall>
  802a94:	83 c4 18             	add    $0x18,%esp
}
  802a97:	90                   	nop
  802a98:	c9                   	leave  
  802a99:	c3                   	ret    

00802a9a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802a9a:	55                   	push   %ebp
  802a9b:	89 e5                	mov    %esp,%ebp
  802a9d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802aa0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802aa3:	8d 50 04             	lea    0x4(%eax),%edx
  802aa6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 00                	push   $0x0
  802aaf:	52                   	push   %edx
  802ab0:	50                   	push   %eax
  802ab1:	6a 24                	push   $0x24
  802ab3:	e8 ca fb ff ff       	call   802682 <syscall>
  802ab8:	83 c4 18             	add    $0x18,%esp
	return result;
  802abb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802abe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802ac1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ac4:	89 01                	mov    %eax,(%ecx)
  802ac6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	c9                   	leave  
  802acd:	c2 04 00             	ret    $0x4

00802ad0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802ad0:	55                   	push   %ebp
  802ad1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802ad3:	6a 00                	push   $0x0
  802ad5:	6a 00                	push   $0x0
  802ad7:	ff 75 10             	pushl  0x10(%ebp)
  802ada:	ff 75 0c             	pushl  0xc(%ebp)
  802add:	ff 75 08             	pushl  0x8(%ebp)
  802ae0:	6a 12                	push   $0x12
  802ae2:	e8 9b fb ff ff       	call   802682 <syscall>
  802ae7:	83 c4 18             	add    $0x18,%esp
	return ;
  802aea:	90                   	nop
}
  802aeb:	c9                   	leave  
  802aec:	c3                   	ret    

00802aed <sys_rcr2>:
uint32 sys_rcr2()
{
  802aed:	55                   	push   %ebp
  802aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802af0:	6a 00                	push   $0x0
  802af2:	6a 00                	push   $0x0
  802af4:	6a 00                	push   $0x0
  802af6:	6a 00                	push   $0x0
  802af8:	6a 00                	push   $0x0
  802afa:	6a 25                	push   $0x25
  802afc:	e8 81 fb ff ff       	call   802682 <syscall>
  802b01:	83 c4 18             	add    $0x18,%esp
}
  802b04:	c9                   	leave  
  802b05:	c3                   	ret    

00802b06 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802b06:	55                   	push   %ebp
  802b07:	89 e5                	mov    %esp,%ebp
  802b09:	83 ec 04             	sub    $0x4,%esp
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802b12:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802b16:	6a 00                	push   $0x0
  802b18:	6a 00                	push   $0x0
  802b1a:	6a 00                	push   $0x0
  802b1c:	6a 00                	push   $0x0
  802b1e:	50                   	push   %eax
  802b1f:	6a 26                	push   $0x26
  802b21:	e8 5c fb ff ff       	call   802682 <syscall>
  802b26:	83 c4 18             	add    $0x18,%esp
	return ;
  802b29:	90                   	nop
}
  802b2a:	c9                   	leave  
  802b2b:	c3                   	ret    

00802b2c <rsttst>:
void rsttst()
{
  802b2c:	55                   	push   %ebp
  802b2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802b2f:	6a 00                	push   $0x0
  802b31:	6a 00                	push   $0x0
  802b33:	6a 00                	push   $0x0
  802b35:	6a 00                	push   $0x0
  802b37:	6a 00                	push   $0x0
  802b39:	6a 28                	push   $0x28
  802b3b:	e8 42 fb ff ff       	call   802682 <syscall>
  802b40:	83 c4 18             	add    $0x18,%esp
	return ;
  802b43:	90                   	nop
}
  802b44:	c9                   	leave  
  802b45:	c3                   	ret    

00802b46 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802b46:	55                   	push   %ebp
  802b47:	89 e5                	mov    %esp,%ebp
  802b49:	83 ec 04             	sub    $0x4,%esp
  802b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  802b4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802b52:	8b 55 18             	mov    0x18(%ebp),%edx
  802b55:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b59:	52                   	push   %edx
  802b5a:	50                   	push   %eax
  802b5b:	ff 75 10             	pushl  0x10(%ebp)
  802b5e:	ff 75 0c             	pushl  0xc(%ebp)
  802b61:	ff 75 08             	pushl  0x8(%ebp)
  802b64:	6a 27                	push   $0x27
  802b66:	e8 17 fb ff ff       	call   802682 <syscall>
  802b6b:	83 c4 18             	add    $0x18,%esp
	return ;
  802b6e:	90                   	nop
}
  802b6f:	c9                   	leave  
  802b70:	c3                   	ret    

00802b71 <chktst>:
void chktst(uint32 n)
{
  802b71:	55                   	push   %ebp
  802b72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b74:	6a 00                	push   $0x0
  802b76:	6a 00                	push   $0x0
  802b78:	6a 00                	push   $0x0
  802b7a:	6a 00                	push   $0x0
  802b7c:	ff 75 08             	pushl  0x8(%ebp)
  802b7f:	6a 29                	push   $0x29
  802b81:	e8 fc fa ff ff       	call   802682 <syscall>
  802b86:	83 c4 18             	add    $0x18,%esp
	return ;
  802b89:	90                   	nop
}
  802b8a:	c9                   	leave  
  802b8b:	c3                   	ret    

00802b8c <inctst>:

void inctst()
{
  802b8c:	55                   	push   %ebp
  802b8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b8f:	6a 00                	push   $0x0
  802b91:	6a 00                	push   $0x0
  802b93:	6a 00                	push   $0x0
  802b95:	6a 00                	push   $0x0
  802b97:	6a 00                	push   $0x0
  802b99:	6a 2a                	push   $0x2a
  802b9b:	e8 e2 fa ff ff       	call   802682 <syscall>
  802ba0:	83 c4 18             	add    $0x18,%esp
	return ;
  802ba3:	90                   	nop
}
  802ba4:	c9                   	leave  
  802ba5:	c3                   	ret    

00802ba6 <gettst>:
uint32 gettst()
{
  802ba6:	55                   	push   %ebp
  802ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802ba9:	6a 00                	push   $0x0
  802bab:	6a 00                	push   $0x0
  802bad:	6a 00                	push   $0x0
  802baf:	6a 00                	push   $0x0
  802bb1:	6a 00                	push   $0x0
  802bb3:	6a 2b                	push   $0x2b
  802bb5:	e8 c8 fa ff ff       	call   802682 <syscall>
  802bba:	83 c4 18             	add    $0x18,%esp
}
  802bbd:	c9                   	leave  
  802bbe:	c3                   	ret    

00802bbf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802bbf:	55                   	push   %ebp
  802bc0:	89 e5                	mov    %esp,%ebp
  802bc2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	6a 00                	push   $0x0
  802bcb:	6a 00                	push   $0x0
  802bcd:	6a 00                	push   $0x0
  802bcf:	6a 2c                	push   $0x2c
  802bd1:	e8 ac fa ff ff       	call   802682 <syscall>
  802bd6:	83 c4 18             	add    $0x18,%esp
  802bd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802bdc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802be0:	75 07                	jne    802be9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802be2:	b8 01 00 00 00       	mov    $0x1,%eax
  802be7:	eb 05                	jmp    802bee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bee:	c9                   	leave  
  802bef:	c3                   	ret    

00802bf0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802bf0:	55                   	push   %ebp
  802bf1:	89 e5                	mov    %esp,%ebp
  802bf3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bf6:	6a 00                	push   $0x0
  802bf8:	6a 00                	push   $0x0
  802bfa:	6a 00                	push   $0x0
  802bfc:	6a 00                	push   $0x0
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 2c                	push   $0x2c
  802c02:	e8 7b fa ff ff       	call   802682 <syscall>
  802c07:	83 c4 18             	add    $0x18,%esp
  802c0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802c0d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802c11:	75 07                	jne    802c1a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802c13:	b8 01 00 00 00       	mov    $0x1,%eax
  802c18:	eb 05                	jmp    802c1f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802c1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c1f:	c9                   	leave  
  802c20:	c3                   	ret    

00802c21 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802c21:	55                   	push   %ebp
  802c22:	89 e5                	mov    %esp,%ebp
  802c24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c27:	6a 00                	push   $0x0
  802c29:	6a 00                	push   $0x0
  802c2b:	6a 00                	push   $0x0
  802c2d:	6a 00                	push   $0x0
  802c2f:	6a 00                	push   $0x0
  802c31:	6a 2c                	push   $0x2c
  802c33:	e8 4a fa ff ff       	call   802682 <syscall>
  802c38:	83 c4 18             	add    $0x18,%esp
  802c3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802c3e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802c42:	75 07                	jne    802c4b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802c44:	b8 01 00 00 00       	mov    $0x1,%eax
  802c49:	eb 05                	jmp    802c50 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802c4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c50:	c9                   	leave  
  802c51:	c3                   	ret    

00802c52 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802c52:	55                   	push   %ebp
  802c53:	89 e5                	mov    %esp,%ebp
  802c55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c58:	6a 00                	push   $0x0
  802c5a:	6a 00                	push   $0x0
  802c5c:	6a 00                	push   $0x0
  802c5e:	6a 00                	push   $0x0
  802c60:	6a 00                	push   $0x0
  802c62:	6a 2c                	push   $0x2c
  802c64:	e8 19 fa ff ff       	call   802682 <syscall>
  802c69:	83 c4 18             	add    $0x18,%esp
  802c6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802c6f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802c73:	75 07                	jne    802c7c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802c75:	b8 01 00 00 00       	mov    $0x1,%eax
  802c7a:	eb 05                	jmp    802c81 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802c7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c81:	c9                   	leave  
  802c82:	c3                   	ret    

00802c83 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c83:	55                   	push   %ebp
  802c84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802c86:	6a 00                	push   $0x0
  802c88:	6a 00                	push   $0x0
  802c8a:	6a 00                	push   $0x0
  802c8c:	6a 00                	push   $0x0
  802c8e:	ff 75 08             	pushl  0x8(%ebp)
  802c91:	6a 2d                	push   $0x2d
  802c93:	e8 ea f9 ff ff       	call   802682 <syscall>
  802c98:	83 c4 18             	add    $0x18,%esp
	return ;
  802c9b:	90                   	nop
}
  802c9c:	c9                   	leave  
  802c9d:	c3                   	ret    

00802c9e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802c9e:	55                   	push   %ebp
  802c9f:	89 e5                	mov    %esp,%ebp
  802ca1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802ca2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ca5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	6a 00                	push   $0x0
  802cb0:	53                   	push   %ebx
  802cb1:	51                   	push   %ecx
  802cb2:	52                   	push   %edx
  802cb3:	50                   	push   %eax
  802cb4:	6a 2e                	push   $0x2e
  802cb6:	e8 c7 f9 ff ff       	call   802682 <syscall>
  802cbb:	83 c4 18             	add    $0x18,%esp
}
  802cbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802cc1:	c9                   	leave  
  802cc2:	c3                   	ret    

00802cc3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802cc3:	55                   	push   %ebp
  802cc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	6a 00                	push   $0x0
  802cce:	6a 00                	push   $0x0
  802cd0:	6a 00                	push   $0x0
  802cd2:	52                   	push   %edx
  802cd3:	50                   	push   %eax
  802cd4:	6a 2f                	push   $0x2f
  802cd6:	e8 a7 f9 ff ff       	call   802682 <syscall>
  802cdb:	83 c4 18             	add    $0x18,%esp
}
  802cde:	c9                   	leave  
  802cdf:	c3                   	ret    

00802ce0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802ce0:	55                   	push   %ebp
  802ce1:	89 e5                	mov    %esp,%ebp
  802ce3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802ce6:	83 ec 0c             	sub    $0xc,%esp
  802ce9:	68 b0 4f 80 00       	push   $0x804fb0
  802cee:	e8 6b e8 ff ff       	call   80155e <cprintf>
  802cf3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802cf6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802cfd:	83 ec 0c             	sub    $0xc,%esp
  802d00:	68 dc 4f 80 00       	push   $0x804fdc
  802d05:	e8 54 e8 ff ff       	call   80155e <cprintf>
  802d0a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802d0d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d11:	a1 38 61 80 00       	mov    0x806138,%eax
  802d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d19:	eb 56                	jmp    802d71 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d1f:	74 1c                	je     802d3d <print_mem_block_lists+0x5d>
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 50 08             	mov    0x8(%eax),%edx
  802d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2a:	8b 48 08             	mov    0x8(%eax),%ecx
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	8b 40 0c             	mov    0xc(%eax),%eax
  802d33:	01 c8                	add    %ecx,%eax
  802d35:	39 c2                	cmp    %eax,%edx
  802d37:	73 04                	jae    802d3d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802d39:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 50 08             	mov    0x8(%eax),%edx
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	8b 40 0c             	mov    0xc(%eax),%eax
  802d49:	01 c2                	add    %eax,%edx
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 40 08             	mov    0x8(%eax),%eax
  802d51:	83 ec 04             	sub    $0x4,%esp
  802d54:	52                   	push   %edx
  802d55:	50                   	push   %eax
  802d56:	68 f1 4f 80 00       	push   $0x804ff1
  802d5b:	e8 fe e7 ff ff       	call   80155e <cprintf>
  802d60:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d69:	a1 40 61 80 00       	mov    0x806140,%eax
  802d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d75:	74 07                	je     802d7e <print_mem_block_lists+0x9e>
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	8b 00                	mov    (%eax),%eax
  802d7c:	eb 05                	jmp    802d83 <print_mem_block_lists+0xa3>
  802d7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d83:	a3 40 61 80 00       	mov    %eax,0x806140
  802d88:	a1 40 61 80 00       	mov    0x806140,%eax
  802d8d:	85 c0                	test   %eax,%eax
  802d8f:	75 8a                	jne    802d1b <print_mem_block_lists+0x3b>
  802d91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d95:	75 84                	jne    802d1b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802d97:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802d9b:	75 10                	jne    802dad <print_mem_block_lists+0xcd>
  802d9d:	83 ec 0c             	sub    $0xc,%esp
  802da0:	68 00 50 80 00       	push   $0x805000
  802da5:	e8 b4 e7 ff ff       	call   80155e <cprintf>
  802daa:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802dad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802db4:	83 ec 0c             	sub    $0xc,%esp
  802db7:	68 24 50 80 00       	push   $0x805024
  802dbc:	e8 9d e7 ff ff       	call   80155e <cprintf>
  802dc1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802dc4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802dc8:	a1 40 60 80 00       	mov    0x806040,%eax
  802dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd0:	eb 56                	jmp    802e28 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802dd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd6:	74 1c                	je     802df4 <print_mem_block_lists+0x114>
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 50 08             	mov    0x8(%eax),%edx
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	8b 48 08             	mov    0x8(%eax),%ecx
  802de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dea:	01 c8                	add    %ecx,%eax
  802dec:	39 c2                	cmp    %eax,%edx
  802dee:	73 04                	jae    802df4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802df0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	8b 50 08             	mov    0x8(%eax),%edx
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802e00:	01 c2                	add    %eax,%edx
  802e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e05:	8b 40 08             	mov    0x8(%eax),%eax
  802e08:	83 ec 04             	sub    $0x4,%esp
  802e0b:	52                   	push   %edx
  802e0c:	50                   	push   %eax
  802e0d:	68 f1 4f 80 00       	push   $0x804ff1
  802e12:	e8 47 e7 ff ff       	call   80155e <cprintf>
  802e17:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802e20:	a1 48 60 80 00       	mov    0x806048,%eax
  802e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2c:	74 07                	je     802e35 <print_mem_block_lists+0x155>
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	eb 05                	jmp    802e3a <print_mem_block_lists+0x15a>
  802e35:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3a:	a3 48 60 80 00       	mov    %eax,0x806048
  802e3f:	a1 48 60 80 00       	mov    0x806048,%eax
  802e44:	85 c0                	test   %eax,%eax
  802e46:	75 8a                	jne    802dd2 <print_mem_block_lists+0xf2>
  802e48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4c:	75 84                	jne    802dd2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802e4e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802e52:	75 10                	jne    802e64 <print_mem_block_lists+0x184>
  802e54:	83 ec 0c             	sub    $0xc,%esp
  802e57:	68 3c 50 80 00       	push   $0x80503c
  802e5c:	e8 fd e6 ff ff       	call   80155e <cprintf>
  802e61:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802e64:	83 ec 0c             	sub    $0xc,%esp
  802e67:	68 b0 4f 80 00       	push   $0x804fb0
  802e6c:	e8 ed e6 ff ff       	call   80155e <cprintf>
  802e71:	83 c4 10             	add    $0x10,%esp

}
  802e74:	90                   	nop
  802e75:	c9                   	leave  
  802e76:	c3                   	ret    

00802e77 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802e77:	55                   	push   %ebp
  802e78:	89 e5                	mov    %esp,%ebp
  802e7a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802e7d:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  802e84:	00 00 00 
  802e87:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  802e8e:	00 00 00 
  802e91:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  802e98:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802e9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ea2:	e9 9e 00 00 00       	jmp    802f45 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802ea7:	a1 50 60 80 00       	mov    0x806050,%eax
  802eac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eaf:	c1 e2 04             	shl    $0x4,%edx
  802eb2:	01 d0                	add    %edx,%eax
  802eb4:	85 c0                	test   %eax,%eax
  802eb6:	75 14                	jne    802ecc <initialize_MemBlocksList+0x55>
  802eb8:	83 ec 04             	sub    $0x4,%esp
  802ebb:	68 64 50 80 00       	push   $0x805064
  802ec0:	6a 46                	push   $0x46
  802ec2:	68 87 50 80 00       	push   $0x805087
  802ec7:	e8 de e3 ff ff       	call   8012aa <_panic>
  802ecc:	a1 50 60 80 00       	mov    0x806050,%eax
  802ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed4:	c1 e2 04             	shl    $0x4,%edx
  802ed7:	01 d0                	add    %edx,%eax
  802ed9:	8b 15 48 61 80 00    	mov    0x806148,%edx
  802edf:	89 10                	mov    %edx,(%eax)
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	74 18                	je     802eff <initialize_MemBlocksList+0x88>
  802ee7:	a1 48 61 80 00       	mov    0x806148,%eax
  802eec:	8b 15 50 60 80 00    	mov    0x806050,%edx
  802ef2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802ef5:	c1 e1 04             	shl    $0x4,%ecx
  802ef8:	01 ca                	add    %ecx,%edx
  802efa:	89 50 04             	mov    %edx,0x4(%eax)
  802efd:	eb 12                	jmp    802f11 <initialize_MemBlocksList+0x9a>
  802eff:	a1 50 60 80 00       	mov    0x806050,%eax
  802f04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f07:	c1 e2 04             	shl    $0x4,%edx
  802f0a:	01 d0                	add    %edx,%eax
  802f0c:	a3 4c 61 80 00       	mov    %eax,0x80614c
  802f11:	a1 50 60 80 00       	mov    0x806050,%eax
  802f16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f19:	c1 e2 04             	shl    $0x4,%edx
  802f1c:	01 d0                	add    %edx,%eax
  802f1e:	a3 48 61 80 00       	mov    %eax,0x806148
  802f23:	a1 50 60 80 00       	mov    0x806050,%eax
  802f28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f2b:	c1 e2 04             	shl    $0x4,%edx
  802f2e:	01 d0                	add    %edx,%eax
  802f30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f37:	a1 54 61 80 00       	mov    0x806154,%eax
  802f3c:	40                   	inc    %eax
  802f3d:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802f42:	ff 45 f4             	incl   -0xc(%ebp)
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f4b:	0f 82 56 ff ff ff    	jb     802ea7 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802f51:	90                   	nop
  802f52:	c9                   	leave  
  802f53:	c3                   	ret    

00802f54 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802f54:	55                   	push   %ebp
  802f55:	89 e5                	mov    %esp,%ebp
  802f57:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	8b 00                	mov    (%eax),%eax
  802f5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802f62:	eb 19                	jmp    802f7d <find_block+0x29>
	{
		if(va==point->sva)
  802f64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f67:	8b 40 08             	mov    0x8(%eax),%eax
  802f6a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f6d:	75 05                	jne    802f74 <find_block+0x20>
		   return point;
  802f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f72:	eb 36                	jmp    802faa <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	8b 40 08             	mov    0x8(%eax),%eax
  802f7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802f7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802f81:	74 07                	je     802f8a <find_block+0x36>
  802f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f86:	8b 00                	mov    (%eax),%eax
  802f88:	eb 05                	jmp    802f8f <find_block+0x3b>
  802f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f92:	89 42 08             	mov    %eax,0x8(%edx)
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	8b 40 08             	mov    0x8(%eax),%eax
  802f9b:	85 c0                	test   %eax,%eax
  802f9d:	75 c5                	jne    802f64 <find_block+0x10>
  802f9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802fa3:	75 bf                	jne    802f64 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802fa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802faa:	c9                   	leave  
  802fab:	c3                   	ret    

00802fac <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802fac:	55                   	push   %ebp
  802fad:	89 e5                	mov    %esp,%ebp
  802faf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802fb2:	a1 40 60 80 00       	mov    0x806040,%eax
  802fb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802fba:	a1 44 60 80 00       	mov    0x806044,%eax
  802fbf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802fc8:	74 24                	je     802fee <insert_sorted_allocList+0x42>
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	8b 50 08             	mov    0x8(%eax),%edx
  802fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd3:	8b 40 08             	mov    0x8(%eax),%eax
  802fd6:	39 c2                	cmp    %eax,%edx
  802fd8:	76 14                	jbe    802fee <insert_sorted_allocList+0x42>
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	8b 50 08             	mov    0x8(%eax),%edx
  802fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe3:	8b 40 08             	mov    0x8(%eax),%eax
  802fe6:	39 c2                	cmp    %eax,%edx
  802fe8:	0f 82 60 01 00 00    	jb     80314e <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802fee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ff2:	75 65                	jne    803059 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802ff4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff8:	75 14                	jne    80300e <insert_sorted_allocList+0x62>
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	68 64 50 80 00       	push   $0x805064
  803002:	6a 6b                	push   $0x6b
  803004:	68 87 50 80 00       	push   $0x805087
  803009:	e8 9c e2 ff ff       	call   8012aa <_panic>
  80300e:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	89 10                	mov    %edx,(%eax)
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	8b 00                	mov    (%eax),%eax
  80301e:	85 c0                	test   %eax,%eax
  803020:	74 0d                	je     80302f <insert_sorted_allocList+0x83>
  803022:	a1 40 60 80 00       	mov    0x806040,%eax
  803027:	8b 55 08             	mov    0x8(%ebp),%edx
  80302a:	89 50 04             	mov    %edx,0x4(%eax)
  80302d:	eb 08                	jmp    803037 <insert_sorted_allocList+0x8b>
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	a3 44 60 80 00       	mov    %eax,0x806044
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	a3 40 60 80 00       	mov    %eax,0x806040
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803049:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80304e:	40                   	inc    %eax
  80304f:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803054:	e9 dc 01 00 00       	jmp    803235 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	8b 50 08             	mov    0x8(%eax),%edx
  80305f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803062:	8b 40 08             	mov    0x8(%eax),%eax
  803065:	39 c2                	cmp    %eax,%edx
  803067:	77 6c                	ja     8030d5 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  803069:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80306d:	74 06                	je     803075 <insert_sorted_allocList+0xc9>
  80306f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803073:	75 14                	jne    803089 <insert_sorted_allocList+0xdd>
  803075:	83 ec 04             	sub    $0x4,%esp
  803078:	68 a0 50 80 00       	push   $0x8050a0
  80307d:	6a 6f                	push   $0x6f
  80307f:	68 87 50 80 00       	push   $0x805087
  803084:	e8 21 e2 ff ff       	call   8012aa <_panic>
  803089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308c:	8b 50 04             	mov    0x4(%eax),%edx
  80308f:	8b 45 08             	mov    0x8(%ebp),%eax
  803092:	89 50 04             	mov    %edx,0x4(%eax)
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80309b:	89 10                	mov    %edx,(%eax)
  80309d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a0:	8b 40 04             	mov    0x4(%eax),%eax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	74 0d                	je     8030b4 <insert_sorted_allocList+0x108>
  8030a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030aa:	8b 40 04             	mov    0x4(%eax),%eax
  8030ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b0:	89 10                	mov    %edx,(%eax)
  8030b2:	eb 08                	jmp    8030bc <insert_sorted_allocList+0x110>
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	a3 40 60 80 00       	mov    %eax,0x806040
  8030bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c2:	89 50 04             	mov    %edx,0x4(%eax)
  8030c5:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8030ca:	40                   	inc    %eax
  8030cb:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8030d0:	e9 60 01 00 00       	jmp    803235 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	8b 50 08             	mov    0x8(%eax),%edx
  8030db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030de:	8b 40 08             	mov    0x8(%eax),%eax
  8030e1:	39 c2                	cmp    %eax,%edx
  8030e3:	0f 82 4c 01 00 00    	jb     803235 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8030e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ed:	75 14                	jne    803103 <insert_sorted_allocList+0x157>
  8030ef:	83 ec 04             	sub    $0x4,%esp
  8030f2:	68 d8 50 80 00       	push   $0x8050d8
  8030f7:	6a 73                	push   $0x73
  8030f9:	68 87 50 80 00       	push   $0x805087
  8030fe:	e8 a7 e1 ff ff       	call   8012aa <_panic>
  803103:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	89 50 04             	mov    %edx,0x4(%eax)
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	8b 40 04             	mov    0x4(%eax),%eax
  803115:	85 c0                	test   %eax,%eax
  803117:	74 0c                	je     803125 <insert_sorted_allocList+0x179>
  803119:	a1 44 60 80 00       	mov    0x806044,%eax
  80311e:	8b 55 08             	mov    0x8(%ebp),%edx
  803121:	89 10                	mov    %edx,(%eax)
  803123:	eb 08                	jmp    80312d <insert_sorted_allocList+0x181>
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	a3 40 60 80 00       	mov    %eax,0x806040
  80312d:	8b 45 08             	mov    0x8(%ebp),%eax
  803130:	a3 44 60 80 00       	mov    %eax,0x806044
  803135:	8b 45 08             	mov    0x8(%ebp),%eax
  803138:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803143:	40                   	inc    %eax
  803144:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803149:	e9 e7 00 00 00       	jmp    803235 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80314e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803151:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  803154:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80315b:	a1 40 60 80 00       	mov    0x806040,%eax
  803160:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803163:	e9 9d 00 00 00       	jmp    803205 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	8b 00                	mov    (%eax),%eax
  80316d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	8b 50 08             	mov    0x8(%eax),%edx
  803176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803179:	8b 40 08             	mov    0x8(%eax),%eax
  80317c:	39 c2                	cmp    %eax,%edx
  80317e:	76 7d                	jbe    8031fd <insert_sorted_allocList+0x251>
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	8b 50 08             	mov    0x8(%eax),%edx
  803186:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803189:	8b 40 08             	mov    0x8(%eax),%eax
  80318c:	39 c2                	cmp    %eax,%edx
  80318e:	73 6d                	jae    8031fd <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  803190:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803194:	74 06                	je     80319c <insert_sorted_allocList+0x1f0>
  803196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80319a:	75 14                	jne    8031b0 <insert_sorted_allocList+0x204>
  80319c:	83 ec 04             	sub    $0x4,%esp
  80319f:	68 fc 50 80 00       	push   $0x8050fc
  8031a4:	6a 7f                	push   $0x7f
  8031a6:	68 87 50 80 00       	push   $0x805087
  8031ab:	e8 fa e0 ff ff       	call   8012aa <_panic>
  8031b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b3:	8b 10                	mov    (%eax),%edx
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	89 10                	mov    %edx,(%eax)
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	8b 00                	mov    (%eax),%eax
  8031bf:	85 c0                	test   %eax,%eax
  8031c1:	74 0b                	je     8031ce <insert_sorted_allocList+0x222>
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 00                	mov    (%eax),%eax
  8031c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031cb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d4:	89 10                	mov    %edx,(%eax)
  8031d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031dc:	89 50 04             	mov    %edx,0x4(%eax)
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	8b 00                	mov    (%eax),%eax
  8031e4:	85 c0                	test   %eax,%eax
  8031e6:	75 08                	jne    8031f0 <insert_sorted_allocList+0x244>
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	a3 44 60 80 00       	mov    %eax,0x806044
  8031f0:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8031f5:	40                   	inc    %eax
  8031f6:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  8031fb:	eb 39                	jmp    803236 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8031fd:	a1 48 60 80 00       	mov    0x806048,%eax
  803202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803209:	74 07                	je     803212 <insert_sorted_allocList+0x266>
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	eb 05                	jmp    803217 <insert_sorted_allocList+0x26b>
  803212:	b8 00 00 00 00       	mov    $0x0,%eax
  803217:	a3 48 60 80 00       	mov    %eax,0x806048
  80321c:	a1 48 60 80 00       	mov    0x806048,%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	0f 85 3f ff ff ff    	jne    803168 <insert_sorted_allocList+0x1bc>
  803229:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322d:	0f 85 35 ff ff ff    	jne    803168 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803233:	eb 01                	jmp    803236 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803235:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803236:	90                   	nop
  803237:	c9                   	leave  
  803238:	c3                   	ret    

00803239 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803239:	55                   	push   %ebp
  80323a:	89 e5                	mov    %esp,%ebp
  80323c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80323f:	a1 38 61 80 00       	mov    0x806138,%eax
  803244:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803247:	e9 85 01 00 00       	jmp    8033d1 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80324c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324f:	8b 40 0c             	mov    0xc(%eax),%eax
  803252:	3b 45 08             	cmp    0x8(%ebp),%eax
  803255:	0f 82 6e 01 00 00    	jb     8033c9 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325e:	8b 40 0c             	mov    0xc(%eax),%eax
  803261:	3b 45 08             	cmp    0x8(%ebp),%eax
  803264:	0f 85 8a 00 00 00    	jne    8032f4 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80326a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326e:	75 17                	jne    803287 <alloc_block_FF+0x4e>
  803270:	83 ec 04             	sub    $0x4,%esp
  803273:	68 30 51 80 00       	push   $0x805130
  803278:	68 93 00 00 00       	push   $0x93
  80327d:	68 87 50 80 00       	push   $0x805087
  803282:	e8 23 e0 ff ff       	call   8012aa <_panic>
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	74 10                	je     8032a0 <alloc_block_FF+0x67>
  803290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803293:	8b 00                	mov    (%eax),%eax
  803295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803298:	8b 52 04             	mov    0x4(%edx),%edx
  80329b:	89 50 04             	mov    %edx,0x4(%eax)
  80329e:	eb 0b                	jmp    8032ab <alloc_block_FF+0x72>
  8032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a3:	8b 40 04             	mov    0x4(%eax),%eax
  8032a6:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8032ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ae:	8b 40 04             	mov    0x4(%eax),%eax
  8032b1:	85 c0                	test   %eax,%eax
  8032b3:	74 0f                	je     8032c4 <alloc_block_FF+0x8b>
  8032b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b8:	8b 40 04             	mov    0x4(%eax),%eax
  8032bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032be:	8b 12                	mov    (%edx),%edx
  8032c0:	89 10                	mov    %edx,(%eax)
  8032c2:	eb 0a                	jmp    8032ce <alloc_block_FF+0x95>
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	8b 00                	mov    (%eax),%eax
  8032c9:	a3 38 61 80 00       	mov    %eax,0x806138
  8032ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e1:	a1 44 61 80 00       	mov    0x806144,%eax
  8032e6:	48                   	dec    %eax
  8032e7:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  8032ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ef:	e9 10 01 00 00       	jmp    803404 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8032f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032fd:	0f 86 c6 00 00 00    	jbe    8033c9 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803303:	a1 48 61 80 00       	mov    0x806148,%eax
  803308:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330e:	8b 50 08             	mov    0x8(%eax),%edx
  803311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803314:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  803317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331a:	8b 55 08             	mov    0x8(%ebp),%edx
  80331d:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803320:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803324:	75 17                	jne    80333d <alloc_block_FF+0x104>
  803326:	83 ec 04             	sub    $0x4,%esp
  803329:	68 30 51 80 00       	push   $0x805130
  80332e:	68 9b 00 00 00       	push   $0x9b
  803333:	68 87 50 80 00       	push   $0x805087
  803338:	e8 6d df ff ff       	call   8012aa <_panic>
  80333d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803340:	8b 00                	mov    (%eax),%eax
  803342:	85 c0                	test   %eax,%eax
  803344:	74 10                	je     803356 <alloc_block_FF+0x11d>
  803346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80334e:	8b 52 04             	mov    0x4(%edx),%edx
  803351:	89 50 04             	mov    %edx,0x4(%eax)
  803354:	eb 0b                	jmp    803361 <alloc_block_FF+0x128>
  803356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803359:	8b 40 04             	mov    0x4(%eax),%eax
  80335c:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803364:	8b 40 04             	mov    0x4(%eax),%eax
  803367:	85 c0                	test   %eax,%eax
  803369:	74 0f                	je     80337a <alloc_block_FF+0x141>
  80336b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336e:	8b 40 04             	mov    0x4(%eax),%eax
  803371:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803374:	8b 12                	mov    (%edx),%edx
  803376:	89 10                	mov    %edx,(%eax)
  803378:	eb 0a                	jmp    803384 <alloc_block_FF+0x14b>
  80337a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	a3 48 61 80 00       	mov    %eax,0x806148
  803384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803387:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803390:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803397:	a1 54 61 80 00       	mov    0x806154,%eax
  80339c:	48                   	dec    %eax
  80339d:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  8033a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a5:	8b 50 08             	mov    0x8(%eax),%edx
  8033a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ab:	01 c2                	add    %eax,%edx
  8033ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b0:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b9:	2b 45 08             	sub    0x8(%ebp),%eax
  8033bc:	89 c2                	mov    %eax,%edx
  8033be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c1:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8033c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c7:	eb 3b                	jmp    803404 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8033c9:	a1 40 61 80 00       	mov    0x806140,%eax
  8033ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d5:	74 07                	je     8033de <alloc_block_FF+0x1a5>
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	8b 00                	mov    (%eax),%eax
  8033dc:	eb 05                	jmp    8033e3 <alloc_block_FF+0x1aa>
  8033de:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e3:	a3 40 61 80 00       	mov    %eax,0x806140
  8033e8:	a1 40 61 80 00       	mov    0x806140,%eax
  8033ed:	85 c0                	test   %eax,%eax
  8033ef:	0f 85 57 fe ff ff    	jne    80324c <alloc_block_FF+0x13>
  8033f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f9:	0f 85 4d fe ff ff    	jne    80324c <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8033ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803404:	c9                   	leave  
  803405:	c3                   	ret    

00803406 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803406:	55                   	push   %ebp
  803407:	89 e5                	mov    %esp,%ebp
  803409:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80340c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803413:	a1 38 61 80 00       	mov    0x806138,%eax
  803418:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80341b:	e9 df 00 00 00       	jmp    8034ff <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803423:	8b 40 0c             	mov    0xc(%eax),%eax
  803426:	3b 45 08             	cmp    0x8(%ebp),%eax
  803429:	0f 82 c8 00 00 00    	jb     8034f7 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80342f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803432:	8b 40 0c             	mov    0xc(%eax),%eax
  803435:	3b 45 08             	cmp    0x8(%ebp),%eax
  803438:	0f 85 8a 00 00 00    	jne    8034c8 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80343e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803442:	75 17                	jne    80345b <alloc_block_BF+0x55>
  803444:	83 ec 04             	sub    $0x4,%esp
  803447:	68 30 51 80 00       	push   $0x805130
  80344c:	68 b7 00 00 00       	push   $0xb7
  803451:	68 87 50 80 00       	push   $0x805087
  803456:	e8 4f de ff ff       	call   8012aa <_panic>
  80345b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345e:	8b 00                	mov    (%eax),%eax
  803460:	85 c0                	test   %eax,%eax
  803462:	74 10                	je     803474 <alloc_block_BF+0x6e>
  803464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803467:	8b 00                	mov    (%eax),%eax
  803469:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80346c:	8b 52 04             	mov    0x4(%edx),%edx
  80346f:	89 50 04             	mov    %edx,0x4(%eax)
  803472:	eb 0b                	jmp    80347f <alloc_block_BF+0x79>
  803474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803477:	8b 40 04             	mov    0x4(%eax),%eax
  80347a:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	8b 40 04             	mov    0x4(%eax),%eax
  803485:	85 c0                	test   %eax,%eax
  803487:	74 0f                	je     803498 <alloc_block_BF+0x92>
  803489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348c:	8b 40 04             	mov    0x4(%eax),%eax
  80348f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803492:	8b 12                	mov    (%edx),%edx
  803494:	89 10                	mov    %edx,(%eax)
  803496:	eb 0a                	jmp    8034a2 <alloc_block_BF+0x9c>
  803498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349b:	8b 00                	mov    (%eax),%eax
  80349d:	a3 38 61 80 00       	mov    %eax,0x806138
  8034a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b5:	a1 44 61 80 00       	mov    0x806144,%eax
  8034ba:	48                   	dec    %eax
  8034bb:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	e9 4d 01 00 00       	jmp    803615 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8034c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034d1:	76 24                	jbe    8034f7 <alloc_block_BF+0xf1>
  8034d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034dc:	73 19                	jae    8034f7 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8034de:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8034eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8034ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f1:	8b 40 08             	mov    0x8(%eax),%eax
  8034f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8034f7:	a1 40 61 80 00       	mov    0x806140,%eax
  8034fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803503:	74 07                	je     80350c <alloc_block_BF+0x106>
  803505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803508:	8b 00                	mov    (%eax),%eax
  80350a:	eb 05                	jmp    803511 <alloc_block_BF+0x10b>
  80350c:	b8 00 00 00 00       	mov    $0x0,%eax
  803511:	a3 40 61 80 00       	mov    %eax,0x806140
  803516:	a1 40 61 80 00       	mov    0x806140,%eax
  80351b:	85 c0                	test   %eax,%eax
  80351d:	0f 85 fd fe ff ff    	jne    803420 <alloc_block_BF+0x1a>
  803523:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803527:	0f 85 f3 fe ff ff    	jne    803420 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80352d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803531:	0f 84 d9 00 00 00    	je     803610 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803537:	a1 48 61 80 00       	mov    0x806148,%eax
  80353c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80353f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803542:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803545:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354b:	8b 55 08             	mov    0x8(%ebp),%edx
  80354e:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803551:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803555:	75 17                	jne    80356e <alloc_block_BF+0x168>
  803557:	83 ec 04             	sub    $0x4,%esp
  80355a:	68 30 51 80 00       	push   $0x805130
  80355f:	68 c7 00 00 00       	push   $0xc7
  803564:	68 87 50 80 00       	push   $0x805087
  803569:	e8 3c dd ff ff       	call   8012aa <_panic>
  80356e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803571:	8b 00                	mov    (%eax),%eax
  803573:	85 c0                	test   %eax,%eax
  803575:	74 10                	je     803587 <alloc_block_BF+0x181>
  803577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357a:	8b 00                	mov    (%eax),%eax
  80357c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80357f:	8b 52 04             	mov    0x4(%edx),%edx
  803582:	89 50 04             	mov    %edx,0x4(%eax)
  803585:	eb 0b                	jmp    803592 <alloc_block_BF+0x18c>
  803587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358a:	8b 40 04             	mov    0x4(%eax),%eax
  80358d:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803595:	8b 40 04             	mov    0x4(%eax),%eax
  803598:	85 c0                	test   %eax,%eax
  80359a:	74 0f                	je     8035ab <alloc_block_BF+0x1a5>
  80359c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359f:	8b 40 04             	mov    0x4(%eax),%eax
  8035a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a5:	8b 12                	mov    (%edx),%edx
  8035a7:	89 10                	mov    %edx,(%eax)
  8035a9:	eb 0a                	jmp    8035b5 <alloc_block_BF+0x1af>
  8035ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ae:	8b 00                	mov    (%eax),%eax
  8035b0:	a3 48 61 80 00       	mov    %eax,0x806148
  8035b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c8:	a1 54 61 80 00       	mov    0x806154,%eax
  8035cd:	48                   	dec    %eax
  8035ce:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8035d3:	83 ec 08             	sub    $0x8,%esp
  8035d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8035d9:	68 38 61 80 00       	push   $0x806138
  8035de:	e8 71 f9 ff ff       	call   802f54 <find_block>
  8035e3:	83 c4 10             	add    $0x10,%esp
  8035e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8035e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ec:	8b 50 08             	mov    0x8(%eax),%edx
  8035ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f2:	01 c2                	add    %eax,%edx
  8035f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035f7:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8035fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803600:	2b 45 08             	sub    0x8(%ebp),%eax
  803603:	89 c2                	mov    %eax,%edx
  803605:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803608:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80360b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360e:	eb 05                	jmp    803615 <alloc_block_BF+0x20f>
	}
	return NULL;
  803610:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803615:	c9                   	leave  
  803616:	c3                   	ret    

00803617 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803617:	55                   	push   %ebp
  803618:	89 e5                	mov    %esp,%ebp
  80361a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80361d:	a1 28 60 80 00       	mov    0x806028,%eax
  803622:	85 c0                	test   %eax,%eax
  803624:	0f 85 de 01 00 00    	jne    803808 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80362a:	a1 38 61 80 00       	mov    0x806138,%eax
  80362f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803632:	e9 9e 01 00 00       	jmp    8037d5 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363a:	8b 40 0c             	mov    0xc(%eax),%eax
  80363d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803640:	0f 82 87 01 00 00    	jb     8037cd <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803649:	8b 40 0c             	mov    0xc(%eax),%eax
  80364c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80364f:	0f 85 95 00 00 00    	jne    8036ea <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803655:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803659:	75 17                	jne    803672 <alloc_block_NF+0x5b>
  80365b:	83 ec 04             	sub    $0x4,%esp
  80365e:	68 30 51 80 00       	push   $0x805130
  803663:	68 e0 00 00 00       	push   $0xe0
  803668:	68 87 50 80 00       	push   $0x805087
  80366d:	e8 38 dc ff ff       	call   8012aa <_panic>
  803672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803675:	8b 00                	mov    (%eax),%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	74 10                	je     80368b <alloc_block_NF+0x74>
  80367b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367e:	8b 00                	mov    (%eax),%eax
  803680:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803683:	8b 52 04             	mov    0x4(%edx),%edx
  803686:	89 50 04             	mov    %edx,0x4(%eax)
  803689:	eb 0b                	jmp    803696 <alloc_block_NF+0x7f>
  80368b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368e:	8b 40 04             	mov    0x4(%eax),%eax
  803691:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803699:	8b 40 04             	mov    0x4(%eax),%eax
  80369c:	85 c0                	test   %eax,%eax
  80369e:	74 0f                	je     8036af <alloc_block_NF+0x98>
  8036a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a3:	8b 40 04             	mov    0x4(%eax),%eax
  8036a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036a9:	8b 12                	mov    (%edx),%edx
  8036ab:	89 10                	mov    %edx,(%eax)
  8036ad:	eb 0a                	jmp    8036b9 <alloc_block_NF+0xa2>
  8036af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b2:	8b 00                	mov    (%eax),%eax
  8036b4:	a3 38 61 80 00       	mov    %eax,0x806138
  8036b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036cc:	a1 44 61 80 00       	mov    0x806144,%eax
  8036d1:	48                   	dec    %eax
  8036d2:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  8036d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036da:	8b 40 08             	mov    0x8(%eax),%eax
  8036dd:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  8036e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e5:	e9 f8 04 00 00       	jmp    803be2 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036f3:	0f 86 d4 00 00 00    	jbe    8037cd <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8036f9:	a1 48 61 80 00       	mov    0x806148,%eax
  8036fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803704:	8b 50 08             	mov    0x8(%eax),%edx
  803707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370a:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80370d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803710:	8b 55 08             	mov    0x8(%ebp),%edx
  803713:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803716:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80371a:	75 17                	jne    803733 <alloc_block_NF+0x11c>
  80371c:	83 ec 04             	sub    $0x4,%esp
  80371f:	68 30 51 80 00       	push   $0x805130
  803724:	68 e9 00 00 00       	push   $0xe9
  803729:	68 87 50 80 00       	push   $0x805087
  80372e:	e8 77 db ff ff       	call   8012aa <_panic>
  803733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803736:	8b 00                	mov    (%eax),%eax
  803738:	85 c0                	test   %eax,%eax
  80373a:	74 10                	je     80374c <alloc_block_NF+0x135>
  80373c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373f:	8b 00                	mov    (%eax),%eax
  803741:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803744:	8b 52 04             	mov    0x4(%edx),%edx
  803747:	89 50 04             	mov    %edx,0x4(%eax)
  80374a:	eb 0b                	jmp    803757 <alloc_block_NF+0x140>
  80374c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374f:	8b 40 04             	mov    0x4(%eax),%eax
  803752:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375a:	8b 40 04             	mov    0x4(%eax),%eax
  80375d:	85 c0                	test   %eax,%eax
  80375f:	74 0f                	je     803770 <alloc_block_NF+0x159>
  803761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803764:	8b 40 04             	mov    0x4(%eax),%eax
  803767:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80376a:	8b 12                	mov    (%edx),%edx
  80376c:	89 10                	mov    %edx,(%eax)
  80376e:	eb 0a                	jmp    80377a <alloc_block_NF+0x163>
  803770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803773:	8b 00                	mov    (%eax),%eax
  803775:	a3 48 61 80 00       	mov    %eax,0x806148
  80377a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803786:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80378d:	a1 54 61 80 00       	mov    0x806154,%eax
  803792:	48                   	dec    %eax
  803793:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  803798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379b:	8b 40 08             	mov    0x8(%eax),%eax
  80379e:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  8037a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a6:	8b 50 08             	mov    0x8(%eax),%edx
  8037a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ac:	01 c2                	add    %eax,%edx
  8037ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b1:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8037b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ba:	2b 45 08             	sub    0x8(%ebp),%eax
  8037bd:	89 c2                	mov    %eax,%edx
  8037bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c2:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8037c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c8:	e9 15 04 00 00       	jmp    803be2 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8037cd:	a1 40 61 80 00       	mov    0x806140,%eax
  8037d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d9:	74 07                	je     8037e2 <alloc_block_NF+0x1cb>
  8037db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037de:	8b 00                	mov    (%eax),%eax
  8037e0:	eb 05                	jmp    8037e7 <alloc_block_NF+0x1d0>
  8037e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e7:	a3 40 61 80 00       	mov    %eax,0x806140
  8037ec:	a1 40 61 80 00       	mov    0x806140,%eax
  8037f1:	85 c0                	test   %eax,%eax
  8037f3:	0f 85 3e fe ff ff    	jne    803637 <alloc_block_NF+0x20>
  8037f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037fd:	0f 85 34 fe ff ff    	jne    803637 <alloc_block_NF+0x20>
  803803:	e9 d5 03 00 00       	jmp    803bdd <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803808:	a1 38 61 80 00       	mov    0x806138,%eax
  80380d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803810:	e9 b1 01 00 00       	jmp    8039c6 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803818:	8b 50 08             	mov    0x8(%eax),%edx
  80381b:	a1 28 60 80 00       	mov    0x806028,%eax
  803820:	39 c2                	cmp    %eax,%edx
  803822:	0f 82 96 01 00 00    	jb     8039be <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382b:	8b 40 0c             	mov    0xc(%eax),%eax
  80382e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803831:	0f 82 87 01 00 00    	jb     8039be <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383a:	8b 40 0c             	mov    0xc(%eax),%eax
  80383d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803840:	0f 85 95 00 00 00    	jne    8038db <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803846:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80384a:	75 17                	jne    803863 <alloc_block_NF+0x24c>
  80384c:	83 ec 04             	sub    $0x4,%esp
  80384f:	68 30 51 80 00       	push   $0x805130
  803854:	68 fc 00 00 00       	push   $0xfc
  803859:	68 87 50 80 00       	push   $0x805087
  80385e:	e8 47 da ff ff       	call   8012aa <_panic>
  803863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803866:	8b 00                	mov    (%eax),%eax
  803868:	85 c0                	test   %eax,%eax
  80386a:	74 10                	je     80387c <alloc_block_NF+0x265>
  80386c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386f:	8b 00                	mov    (%eax),%eax
  803871:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803874:	8b 52 04             	mov    0x4(%edx),%edx
  803877:	89 50 04             	mov    %edx,0x4(%eax)
  80387a:	eb 0b                	jmp    803887 <alloc_block_NF+0x270>
  80387c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387f:	8b 40 04             	mov    0x4(%eax),%eax
  803882:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388a:	8b 40 04             	mov    0x4(%eax),%eax
  80388d:	85 c0                	test   %eax,%eax
  80388f:	74 0f                	je     8038a0 <alloc_block_NF+0x289>
  803891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803894:	8b 40 04             	mov    0x4(%eax),%eax
  803897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80389a:	8b 12                	mov    (%edx),%edx
  80389c:	89 10                	mov    %edx,(%eax)
  80389e:	eb 0a                	jmp    8038aa <alloc_block_NF+0x293>
  8038a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a3:	8b 00                	mov    (%eax),%eax
  8038a5:	a3 38 61 80 00       	mov    %eax,0x806138
  8038aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038bd:	a1 44 61 80 00       	mov    0x806144,%eax
  8038c2:	48                   	dec    %eax
  8038c3:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  8038c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cb:	8b 40 08             	mov    0x8(%eax),%eax
  8038ce:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  8038d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d6:	e9 07 03 00 00       	jmp    803be2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8038db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038de:	8b 40 0c             	mov    0xc(%eax),%eax
  8038e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038e4:	0f 86 d4 00 00 00    	jbe    8039be <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8038ea:	a1 48 61 80 00       	mov    0x806148,%eax
  8038ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8038f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f5:	8b 50 08             	mov    0x8(%eax),%edx
  8038f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038fb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8038fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803901:	8b 55 08             	mov    0x8(%ebp),%edx
  803904:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803907:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80390b:	75 17                	jne    803924 <alloc_block_NF+0x30d>
  80390d:	83 ec 04             	sub    $0x4,%esp
  803910:	68 30 51 80 00       	push   $0x805130
  803915:	68 04 01 00 00       	push   $0x104
  80391a:	68 87 50 80 00       	push   $0x805087
  80391f:	e8 86 d9 ff ff       	call   8012aa <_panic>
  803924:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803927:	8b 00                	mov    (%eax),%eax
  803929:	85 c0                	test   %eax,%eax
  80392b:	74 10                	je     80393d <alloc_block_NF+0x326>
  80392d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803930:	8b 00                	mov    (%eax),%eax
  803932:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803935:	8b 52 04             	mov    0x4(%edx),%edx
  803938:	89 50 04             	mov    %edx,0x4(%eax)
  80393b:	eb 0b                	jmp    803948 <alloc_block_NF+0x331>
  80393d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803940:	8b 40 04             	mov    0x4(%eax),%eax
  803943:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803948:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394b:	8b 40 04             	mov    0x4(%eax),%eax
  80394e:	85 c0                	test   %eax,%eax
  803950:	74 0f                	je     803961 <alloc_block_NF+0x34a>
  803952:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803955:	8b 40 04             	mov    0x4(%eax),%eax
  803958:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80395b:	8b 12                	mov    (%edx),%edx
  80395d:	89 10                	mov    %edx,(%eax)
  80395f:	eb 0a                	jmp    80396b <alloc_block_NF+0x354>
  803961:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803964:	8b 00                	mov    (%eax),%eax
  803966:	a3 48 61 80 00       	mov    %eax,0x806148
  80396b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803974:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803977:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80397e:	a1 54 61 80 00       	mov    0x806154,%eax
  803983:	48                   	dec    %eax
  803984:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803989:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398c:	8b 40 08             	mov    0x8(%eax),%eax
  80398f:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803997:	8b 50 08             	mov    0x8(%eax),%edx
  80399a:	8b 45 08             	mov    0x8(%ebp),%eax
  80399d:	01 c2                	add    %eax,%edx
  80399f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a2:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8039a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8039ab:	2b 45 08             	sub    0x8(%ebp),%eax
  8039ae:	89 c2                	mov    %eax,%edx
  8039b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8039b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b9:	e9 24 02 00 00       	jmp    803be2 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8039be:	a1 40 61 80 00       	mov    0x806140,%eax
  8039c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ca:	74 07                	je     8039d3 <alloc_block_NF+0x3bc>
  8039cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cf:	8b 00                	mov    (%eax),%eax
  8039d1:	eb 05                	jmp    8039d8 <alloc_block_NF+0x3c1>
  8039d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d8:	a3 40 61 80 00       	mov    %eax,0x806140
  8039dd:	a1 40 61 80 00       	mov    0x806140,%eax
  8039e2:	85 c0                	test   %eax,%eax
  8039e4:	0f 85 2b fe ff ff    	jne    803815 <alloc_block_NF+0x1fe>
  8039ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ee:	0f 85 21 fe ff ff    	jne    803815 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8039f4:	a1 38 61 80 00       	mov    0x806138,%eax
  8039f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039fc:	e9 ae 01 00 00       	jmp    803baf <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a04:	8b 50 08             	mov    0x8(%eax),%edx
  803a07:	a1 28 60 80 00       	mov    0x806028,%eax
  803a0c:	39 c2                	cmp    %eax,%edx
  803a0e:	0f 83 93 01 00 00    	jae    803ba7 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a17:	8b 40 0c             	mov    0xc(%eax),%eax
  803a1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a1d:	0f 82 84 01 00 00    	jb     803ba7 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a26:	8b 40 0c             	mov    0xc(%eax),%eax
  803a29:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a2c:	0f 85 95 00 00 00    	jne    803ac7 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803a32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a36:	75 17                	jne    803a4f <alloc_block_NF+0x438>
  803a38:	83 ec 04             	sub    $0x4,%esp
  803a3b:	68 30 51 80 00       	push   $0x805130
  803a40:	68 14 01 00 00       	push   $0x114
  803a45:	68 87 50 80 00       	push   $0x805087
  803a4a:	e8 5b d8 ff ff       	call   8012aa <_panic>
  803a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a52:	8b 00                	mov    (%eax),%eax
  803a54:	85 c0                	test   %eax,%eax
  803a56:	74 10                	je     803a68 <alloc_block_NF+0x451>
  803a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5b:	8b 00                	mov    (%eax),%eax
  803a5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a60:	8b 52 04             	mov    0x4(%edx),%edx
  803a63:	89 50 04             	mov    %edx,0x4(%eax)
  803a66:	eb 0b                	jmp    803a73 <alloc_block_NF+0x45c>
  803a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6b:	8b 40 04             	mov    0x4(%eax),%eax
  803a6e:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a76:	8b 40 04             	mov    0x4(%eax),%eax
  803a79:	85 c0                	test   %eax,%eax
  803a7b:	74 0f                	je     803a8c <alloc_block_NF+0x475>
  803a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a80:	8b 40 04             	mov    0x4(%eax),%eax
  803a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a86:	8b 12                	mov    (%edx),%edx
  803a88:	89 10                	mov    %edx,(%eax)
  803a8a:	eb 0a                	jmp    803a96 <alloc_block_NF+0x47f>
  803a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8f:	8b 00                	mov    (%eax),%eax
  803a91:	a3 38 61 80 00       	mov    %eax,0x806138
  803a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aa9:	a1 44 61 80 00       	mov    0x806144,%eax
  803aae:	48                   	dec    %eax
  803aaf:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab7:	8b 40 08             	mov    0x8(%eax),%eax
  803aba:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac2:	e9 1b 01 00 00       	jmp    803be2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aca:	8b 40 0c             	mov    0xc(%eax),%eax
  803acd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ad0:	0f 86 d1 00 00 00    	jbe    803ba7 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803ad6:	a1 48 61 80 00       	mov    0x806148,%eax
  803adb:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae1:	8b 50 08             	mov    0x8(%eax),%edx
  803ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ae7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aed:	8b 55 08             	mov    0x8(%ebp),%edx
  803af0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803af3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803af7:	75 17                	jne    803b10 <alloc_block_NF+0x4f9>
  803af9:	83 ec 04             	sub    $0x4,%esp
  803afc:	68 30 51 80 00       	push   $0x805130
  803b01:	68 1c 01 00 00       	push   $0x11c
  803b06:	68 87 50 80 00       	push   $0x805087
  803b0b:	e8 9a d7 ff ff       	call   8012aa <_panic>
  803b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b13:	8b 00                	mov    (%eax),%eax
  803b15:	85 c0                	test   %eax,%eax
  803b17:	74 10                	je     803b29 <alloc_block_NF+0x512>
  803b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b1c:	8b 00                	mov    (%eax),%eax
  803b1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b21:	8b 52 04             	mov    0x4(%edx),%edx
  803b24:	89 50 04             	mov    %edx,0x4(%eax)
  803b27:	eb 0b                	jmp    803b34 <alloc_block_NF+0x51d>
  803b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b2c:	8b 40 04             	mov    0x4(%eax),%eax
  803b2f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b37:	8b 40 04             	mov    0x4(%eax),%eax
  803b3a:	85 c0                	test   %eax,%eax
  803b3c:	74 0f                	je     803b4d <alloc_block_NF+0x536>
  803b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b41:	8b 40 04             	mov    0x4(%eax),%eax
  803b44:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b47:	8b 12                	mov    (%edx),%edx
  803b49:	89 10                	mov    %edx,(%eax)
  803b4b:	eb 0a                	jmp    803b57 <alloc_block_NF+0x540>
  803b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b50:	8b 00                	mov    (%eax),%eax
  803b52:	a3 48 61 80 00       	mov    %eax,0x806148
  803b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b6a:	a1 54 61 80 00       	mov    0x806154,%eax
  803b6f:	48                   	dec    %eax
  803b70:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b78:	8b 40 08             	mov    0x8(%eax),%eax
  803b7b:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b83:	8b 50 08             	mov    0x8(%eax),%edx
  803b86:	8b 45 08             	mov    0x8(%ebp),%eax
  803b89:	01 c2                	add    %eax,%edx
  803b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b8e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b94:	8b 40 0c             	mov    0xc(%eax),%eax
  803b97:	2b 45 08             	sub    0x8(%ebp),%eax
  803b9a:	89 c2                	mov    %eax,%edx
  803b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ba5:	eb 3b                	jmp    803be2 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803ba7:	a1 40 61 80 00       	mov    0x806140,%eax
  803bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803baf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bb3:	74 07                	je     803bbc <alloc_block_NF+0x5a5>
  803bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb8:	8b 00                	mov    (%eax),%eax
  803bba:	eb 05                	jmp    803bc1 <alloc_block_NF+0x5aa>
  803bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc1:	a3 40 61 80 00       	mov    %eax,0x806140
  803bc6:	a1 40 61 80 00       	mov    0x806140,%eax
  803bcb:	85 c0                	test   %eax,%eax
  803bcd:	0f 85 2e fe ff ff    	jne    803a01 <alloc_block_NF+0x3ea>
  803bd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bd7:	0f 85 24 fe ff ff    	jne    803a01 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803be2:	c9                   	leave  
  803be3:	c3                   	ret    

00803be4 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803be4:	55                   	push   %ebp
  803be5:	89 e5                	mov    %esp,%ebp
  803be7:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803bea:	a1 38 61 80 00       	mov    0x806138,%eax
  803bef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803bf2:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803bf7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803bfa:	a1 38 61 80 00       	mov    0x806138,%eax
  803bff:	85 c0                	test   %eax,%eax
  803c01:	74 14                	je     803c17 <insert_sorted_with_merge_freeList+0x33>
  803c03:	8b 45 08             	mov    0x8(%ebp),%eax
  803c06:	8b 50 08             	mov    0x8(%eax),%edx
  803c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c0c:	8b 40 08             	mov    0x8(%eax),%eax
  803c0f:	39 c2                	cmp    %eax,%edx
  803c11:	0f 87 9b 01 00 00    	ja     803db2 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803c17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c1b:	75 17                	jne    803c34 <insert_sorted_with_merge_freeList+0x50>
  803c1d:	83 ec 04             	sub    $0x4,%esp
  803c20:	68 64 50 80 00       	push   $0x805064
  803c25:	68 38 01 00 00       	push   $0x138
  803c2a:	68 87 50 80 00       	push   $0x805087
  803c2f:	e8 76 d6 ff ff       	call   8012aa <_panic>
  803c34:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3d:	89 10                	mov    %edx,(%eax)
  803c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c42:	8b 00                	mov    (%eax),%eax
  803c44:	85 c0                	test   %eax,%eax
  803c46:	74 0d                	je     803c55 <insert_sorted_with_merge_freeList+0x71>
  803c48:	a1 38 61 80 00       	mov    0x806138,%eax
  803c4d:	8b 55 08             	mov    0x8(%ebp),%edx
  803c50:	89 50 04             	mov    %edx,0x4(%eax)
  803c53:	eb 08                	jmp    803c5d <insert_sorted_with_merge_freeList+0x79>
  803c55:	8b 45 08             	mov    0x8(%ebp),%eax
  803c58:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c60:	a3 38 61 80 00       	mov    %eax,0x806138
  803c65:	8b 45 08             	mov    0x8(%ebp),%eax
  803c68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c6f:	a1 44 61 80 00       	mov    0x806144,%eax
  803c74:	40                   	inc    %eax
  803c75:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803c7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c7e:	0f 84 a8 06 00 00    	je     80432c <insert_sorted_with_merge_freeList+0x748>
  803c84:	8b 45 08             	mov    0x8(%ebp),%eax
  803c87:	8b 50 08             	mov    0x8(%eax),%edx
  803c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  803c90:	01 c2                	add    %eax,%edx
  803c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c95:	8b 40 08             	mov    0x8(%eax),%eax
  803c98:	39 c2                	cmp    %eax,%edx
  803c9a:	0f 85 8c 06 00 00    	jne    80432c <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca3:	8b 50 0c             	mov    0xc(%eax),%edx
  803ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ca9:	8b 40 0c             	mov    0xc(%eax),%eax
  803cac:	01 c2                	add    %eax,%edx
  803cae:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb1:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803cb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cb8:	75 17                	jne    803cd1 <insert_sorted_with_merge_freeList+0xed>
  803cba:	83 ec 04             	sub    $0x4,%esp
  803cbd:	68 30 51 80 00       	push   $0x805130
  803cc2:	68 3c 01 00 00       	push   $0x13c
  803cc7:	68 87 50 80 00       	push   $0x805087
  803ccc:	e8 d9 d5 ff ff       	call   8012aa <_panic>
  803cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd4:	8b 00                	mov    (%eax),%eax
  803cd6:	85 c0                	test   %eax,%eax
  803cd8:	74 10                	je     803cea <insert_sorted_with_merge_freeList+0x106>
  803cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cdd:	8b 00                	mov    (%eax),%eax
  803cdf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ce2:	8b 52 04             	mov    0x4(%edx),%edx
  803ce5:	89 50 04             	mov    %edx,0x4(%eax)
  803ce8:	eb 0b                	jmp    803cf5 <insert_sorted_with_merge_freeList+0x111>
  803cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ced:	8b 40 04             	mov    0x4(%eax),%eax
  803cf0:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cf8:	8b 40 04             	mov    0x4(%eax),%eax
  803cfb:	85 c0                	test   %eax,%eax
  803cfd:	74 0f                	je     803d0e <insert_sorted_with_merge_freeList+0x12a>
  803cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d02:	8b 40 04             	mov    0x4(%eax),%eax
  803d05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d08:	8b 12                	mov    (%edx),%edx
  803d0a:	89 10                	mov    %edx,(%eax)
  803d0c:	eb 0a                	jmp    803d18 <insert_sorted_with_merge_freeList+0x134>
  803d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d11:	8b 00                	mov    (%eax),%eax
  803d13:	a3 38 61 80 00       	mov    %eax,0x806138
  803d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d2b:	a1 44 61 80 00       	mov    0x806144,%eax
  803d30:	48                   	dec    %eax
  803d31:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  803d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d39:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803d4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d4e:	75 17                	jne    803d67 <insert_sorted_with_merge_freeList+0x183>
  803d50:	83 ec 04             	sub    $0x4,%esp
  803d53:	68 64 50 80 00       	push   $0x805064
  803d58:	68 3f 01 00 00       	push   $0x13f
  803d5d:	68 87 50 80 00       	push   $0x805087
  803d62:	e8 43 d5 ff ff       	call   8012aa <_panic>
  803d67:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d70:	89 10                	mov    %edx,(%eax)
  803d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d75:	8b 00                	mov    (%eax),%eax
  803d77:	85 c0                	test   %eax,%eax
  803d79:	74 0d                	je     803d88 <insert_sorted_with_merge_freeList+0x1a4>
  803d7b:	a1 48 61 80 00       	mov    0x806148,%eax
  803d80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d83:	89 50 04             	mov    %edx,0x4(%eax)
  803d86:	eb 08                	jmp    803d90 <insert_sorted_with_merge_freeList+0x1ac>
  803d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d8b:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d93:	a3 48 61 80 00       	mov    %eax,0x806148
  803d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803da2:	a1 54 61 80 00       	mov    0x806154,%eax
  803da7:	40                   	inc    %eax
  803da8:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803dad:	e9 7a 05 00 00       	jmp    80432c <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803db2:	8b 45 08             	mov    0x8(%ebp),%eax
  803db5:	8b 50 08             	mov    0x8(%eax),%edx
  803db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dbb:	8b 40 08             	mov    0x8(%eax),%eax
  803dbe:	39 c2                	cmp    %eax,%edx
  803dc0:	0f 82 14 01 00 00    	jb     803eda <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dc9:	8b 50 08             	mov    0x8(%eax),%edx
  803dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dcf:	8b 40 0c             	mov    0xc(%eax),%eax
  803dd2:	01 c2                	add    %eax,%edx
  803dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd7:	8b 40 08             	mov    0x8(%eax),%eax
  803dda:	39 c2                	cmp    %eax,%edx
  803ddc:	0f 85 90 00 00 00    	jne    803e72 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803de5:	8b 50 0c             	mov    0xc(%eax),%edx
  803de8:	8b 45 08             	mov    0x8(%ebp),%eax
  803deb:	8b 40 0c             	mov    0xc(%eax),%eax
  803dee:	01 c2                	add    %eax,%edx
  803df0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803df3:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803df6:	8b 45 08             	mov    0x8(%ebp),%eax
  803df9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803e00:	8b 45 08             	mov    0x8(%ebp),%eax
  803e03:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803e0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e0e:	75 17                	jne    803e27 <insert_sorted_with_merge_freeList+0x243>
  803e10:	83 ec 04             	sub    $0x4,%esp
  803e13:	68 64 50 80 00       	push   $0x805064
  803e18:	68 49 01 00 00       	push   $0x149
  803e1d:	68 87 50 80 00       	push   $0x805087
  803e22:	e8 83 d4 ff ff       	call   8012aa <_panic>
  803e27:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e30:	89 10                	mov    %edx,(%eax)
  803e32:	8b 45 08             	mov    0x8(%ebp),%eax
  803e35:	8b 00                	mov    (%eax),%eax
  803e37:	85 c0                	test   %eax,%eax
  803e39:	74 0d                	je     803e48 <insert_sorted_with_merge_freeList+0x264>
  803e3b:	a1 48 61 80 00       	mov    0x806148,%eax
  803e40:	8b 55 08             	mov    0x8(%ebp),%edx
  803e43:	89 50 04             	mov    %edx,0x4(%eax)
  803e46:	eb 08                	jmp    803e50 <insert_sorted_with_merge_freeList+0x26c>
  803e48:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4b:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803e50:	8b 45 08             	mov    0x8(%ebp),%eax
  803e53:	a3 48 61 80 00       	mov    %eax,0x806148
  803e58:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e62:	a1 54 61 80 00       	mov    0x806154,%eax
  803e67:	40                   	inc    %eax
  803e68:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e6d:	e9 bb 04 00 00       	jmp    80432d <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803e72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e76:	75 17                	jne    803e8f <insert_sorted_with_merge_freeList+0x2ab>
  803e78:	83 ec 04             	sub    $0x4,%esp
  803e7b:	68 d8 50 80 00       	push   $0x8050d8
  803e80:	68 4c 01 00 00       	push   $0x14c
  803e85:	68 87 50 80 00       	push   $0x805087
  803e8a:	e8 1b d4 ff ff       	call   8012aa <_panic>
  803e8f:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803e95:	8b 45 08             	mov    0x8(%ebp),%eax
  803e98:	89 50 04             	mov    %edx,0x4(%eax)
  803e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ea1:	85 c0                	test   %eax,%eax
  803ea3:	74 0c                	je     803eb1 <insert_sorted_with_merge_freeList+0x2cd>
  803ea5:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803eaa:	8b 55 08             	mov    0x8(%ebp),%edx
  803ead:	89 10                	mov    %edx,(%eax)
  803eaf:	eb 08                	jmp    803eb9 <insert_sorted_with_merge_freeList+0x2d5>
  803eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb4:	a3 38 61 80 00       	mov    %eax,0x806138
  803eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  803ebc:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eca:	a1 44 61 80 00       	mov    0x806144,%eax
  803ecf:	40                   	inc    %eax
  803ed0:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803ed5:	e9 53 04 00 00       	jmp    80432d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803eda:	a1 38 61 80 00       	mov    0x806138,%eax
  803edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ee2:	e9 15 04 00 00       	jmp    8042fc <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eea:	8b 00                	mov    (%eax),%eax
  803eec:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803eef:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef2:	8b 50 08             	mov    0x8(%eax),%edx
  803ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef8:	8b 40 08             	mov    0x8(%eax),%eax
  803efb:	39 c2                	cmp    %eax,%edx
  803efd:	0f 86 f1 03 00 00    	jbe    8042f4 <insert_sorted_with_merge_freeList+0x710>
  803f03:	8b 45 08             	mov    0x8(%ebp),%eax
  803f06:	8b 50 08             	mov    0x8(%eax),%edx
  803f09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f0c:	8b 40 08             	mov    0x8(%eax),%eax
  803f0f:	39 c2                	cmp    %eax,%edx
  803f11:	0f 83 dd 03 00 00    	jae    8042f4 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f1a:	8b 50 08             	mov    0x8(%eax),%edx
  803f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f20:	8b 40 0c             	mov    0xc(%eax),%eax
  803f23:	01 c2                	add    %eax,%edx
  803f25:	8b 45 08             	mov    0x8(%ebp),%eax
  803f28:	8b 40 08             	mov    0x8(%eax),%eax
  803f2b:	39 c2                	cmp    %eax,%edx
  803f2d:	0f 85 b9 01 00 00    	jne    8040ec <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803f33:	8b 45 08             	mov    0x8(%ebp),%eax
  803f36:	8b 50 08             	mov    0x8(%eax),%edx
  803f39:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3c:	8b 40 0c             	mov    0xc(%eax),%eax
  803f3f:	01 c2                	add    %eax,%edx
  803f41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f44:	8b 40 08             	mov    0x8(%eax),%eax
  803f47:	39 c2                	cmp    %eax,%edx
  803f49:	0f 85 0d 01 00 00    	jne    80405c <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f52:	8b 50 0c             	mov    0xc(%eax),%edx
  803f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f58:	8b 40 0c             	mov    0xc(%eax),%eax
  803f5b:	01 c2                	add    %eax,%edx
  803f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f60:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803f63:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803f67:	75 17                	jne    803f80 <insert_sorted_with_merge_freeList+0x39c>
  803f69:	83 ec 04             	sub    $0x4,%esp
  803f6c:	68 30 51 80 00       	push   $0x805130
  803f71:	68 5c 01 00 00       	push   $0x15c
  803f76:	68 87 50 80 00       	push   $0x805087
  803f7b:	e8 2a d3 ff ff       	call   8012aa <_panic>
  803f80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f83:	8b 00                	mov    (%eax),%eax
  803f85:	85 c0                	test   %eax,%eax
  803f87:	74 10                	je     803f99 <insert_sorted_with_merge_freeList+0x3b5>
  803f89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f8c:	8b 00                	mov    (%eax),%eax
  803f8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f91:	8b 52 04             	mov    0x4(%edx),%edx
  803f94:	89 50 04             	mov    %edx,0x4(%eax)
  803f97:	eb 0b                	jmp    803fa4 <insert_sorted_with_merge_freeList+0x3c0>
  803f99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f9c:	8b 40 04             	mov    0x4(%eax),%eax
  803f9f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803fa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fa7:	8b 40 04             	mov    0x4(%eax),%eax
  803faa:	85 c0                	test   %eax,%eax
  803fac:	74 0f                	je     803fbd <insert_sorted_with_merge_freeList+0x3d9>
  803fae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fb1:	8b 40 04             	mov    0x4(%eax),%eax
  803fb4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fb7:	8b 12                	mov    (%edx),%edx
  803fb9:	89 10                	mov    %edx,(%eax)
  803fbb:	eb 0a                	jmp    803fc7 <insert_sorted_with_merge_freeList+0x3e3>
  803fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fc0:	8b 00                	mov    (%eax),%eax
  803fc2:	a3 38 61 80 00       	mov    %eax,0x806138
  803fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fda:	a1 44 61 80 00       	mov    0x806144,%eax
  803fdf:	48                   	dec    %eax
  803fe0:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  803fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fe8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803fef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ff2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803ff9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ffd:	75 17                	jne    804016 <insert_sorted_with_merge_freeList+0x432>
  803fff:	83 ec 04             	sub    $0x4,%esp
  804002:	68 64 50 80 00       	push   $0x805064
  804007:	68 5f 01 00 00       	push   $0x15f
  80400c:	68 87 50 80 00       	push   $0x805087
  804011:	e8 94 d2 ff ff       	call   8012aa <_panic>
  804016:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80401c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80401f:	89 10                	mov    %edx,(%eax)
  804021:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804024:	8b 00                	mov    (%eax),%eax
  804026:	85 c0                	test   %eax,%eax
  804028:	74 0d                	je     804037 <insert_sorted_with_merge_freeList+0x453>
  80402a:	a1 48 61 80 00       	mov    0x806148,%eax
  80402f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804032:	89 50 04             	mov    %edx,0x4(%eax)
  804035:	eb 08                	jmp    80403f <insert_sorted_with_merge_freeList+0x45b>
  804037:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80403a:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80403f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804042:	a3 48 61 80 00       	mov    %eax,0x806148
  804047:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80404a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804051:	a1 54 61 80 00       	mov    0x806154,%eax
  804056:	40                   	inc    %eax
  804057:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  80405c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80405f:	8b 50 0c             	mov    0xc(%eax),%edx
  804062:	8b 45 08             	mov    0x8(%ebp),%eax
  804065:	8b 40 0c             	mov    0xc(%eax),%eax
  804068:	01 c2                	add    %eax,%edx
  80406a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80406d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  804070:	8b 45 08             	mov    0x8(%ebp),%eax
  804073:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80407a:	8b 45 08             	mov    0x8(%ebp),%eax
  80407d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  804084:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804088:	75 17                	jne    8040a1 <insert_sorted_with_merge_freeList+0x4bd>
  80408a:	83 ec 04             	sub    $0x4,%esp
  80408d:	68 64 50 80 00       	push   $0x805064
  804092:	68 64 01 00 00       	push   $0x164
  804097:	68 87 50 80 00       	push   $0x805087
  80409c:	e8 09 d2 ff ff       	call   8012aa <_panic>
  8040a1:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8040a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040aa:	89 10                	mov    %edx,(%eax)
  8040ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8040af:	8b 00                	mov    (%eax),%eax
  8040b1:	85 c0                	test   %eax,%eax
  8040b3:	74 0d                	je     8040c2 <insert_sorted_with_merge_freeList+0x4de>
  8040b5:	a1 48 61 80 00       	mov    0x806148,%eax
  8040ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8040bd:	89 50 04             	mov    %edx,0x4(%eax)
  8040c0:	eb 08                	jmp    8040ca <insert_sorted_with_merge_freeList+0x4e6>
  8040c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8040c5:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8040ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8040cd:	a3 48 61 80 00       	mov    %eax,0x806148
  8040d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040dc:	a1 54 61 80 00       	mov    0x806154,%eax
  8040e1:	40                   	inc    %eax
  8040e2:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  8040e7:	e9 41 02 00 00       	jmp    80432d <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8040ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ef:	8b 50 08             	mov    0x8(%eax),%edx
  8040f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8040f8:	01 c2                	add    %eax,%edx
  8040fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040fd:	8b 40 08             	mov    0x8(%eax),%eax
  804100:	39 c2                	cmp    %eax,%edx
  804102:	0f 85 7c 01 00 00    	jne    804284 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  804108:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80410c:	74 06                	je     804114 <insert_sorted_with_merge_freeList+0x530>
  80410e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804112:	75 17                	jne    80412b <insert_sorted_with_merge_freeList+0x547>
  804114:	83 ec 04             	sub    $0x4,%esp
  804117:	68 a0 50 80 00       	push   $0x8050a0
  80411c:	68 69 01 00 00       	push   $0x169
  804121:	68 87 50 80 00       	push   $0x805087
  804126:	e8 7f d1 ff ff       	call   8012aa <_panic>
  80412b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80412e:	8b 50 04             	mov    0x4(%eax),%edx
  804131:	8b 45 08             	mov    0x8(%ebp),%eax
  804134:	89 50 04             	mov    %edx,0x4(%eax)
  804137:	8b 45 08             	mov    0x8(%ebp),%eax
  80413a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80413d:	89 10                	mov    %edx,(%eax)
  80413f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804142:	8b 40 04             	mov    0x4(%eax),%eax
  804145:	85 c0                	test   %eax,%eax
  804147:	74 0d                	je     804156 <insert_sorted_with_merge_freeList+0x572>
  804149:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80414c:	8b 40 04             	mov    0x4(%eax),%eax
  80414f:	8b 55 08             	mov    0x8(%ebp),%edx
  804152:	89 10                	mov    %edx,(%eax)
  804154:	eb 08                	jmp    80415e <insert_sorted_with_merge_freeList+0x57a>
  804156:	8b 45 08             	mov    0x8(%ebp),%eax
  804159:	a3 38 61 80 00       	mov    %eax,0x806138
  80415e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804161:	8b 55 08             	mov    0x8(%ebp),%edx
  804164:	89 50 04             	mov    %edx,0x4(%eax)
  804167:	a1 44 61 80 00       	mov    0x806144,%eax
  80416c:	40                   	inc    %eax
  80416d:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  804172:	8b 45 08             	mov    0x8(%ebp),%eax
  804175:	8b 50 0c             	mov    0xc(%eax),%edx
  804178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80417b:	8b 40 0c             	mov    0xc(%eax),%eax
  80417e:	01 c2                	add    %eax,%edx
  804180:	8b 45 08             	mov    0x8(%ebp),%eax
  804183:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  804186:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80418a:	75 17                	jne    8041a3 <insert_sorted_with_merge_freeList+0x5bf>
  80418c:	83 ec 04             	sub    $0x4,%esp
  80418f:	68 30 51 80 00       	push   $0x805130
  804194:	68 6b 01 00 00       	push   $0x16b
  804199:	68 87 50 80 00       	push   $0x805087
  80419e:	e8 07 d1 ff ff       	call   8012aa <_panic>
  8041a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041a6:	8b 00                	mov    (%eax),%eax
  8041a8:	85 c0                	test   %eax,%eax
  8041aa:	74 10                	je     8041bc <insert_sorted_with_merge_freeList+0x5d8>
  8041ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041af:	8b 00                	mov    (%eax),%eax
  8041b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041b4:	8b 52 04             	mov    0x4(%edx),%edx
  8041b7:	89 50 04             	mov    %edx,0x4(%eax)
  8041ba:	eb 0b                	jmp    8041c7 <insert_sorted_with_merge_freeList+0x5e3>
  8041bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041bf:	8b 40 04             	mov    0x4(%eax),%eax
  8041c2:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8041c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041ca:	8b 40 04             	mov    0x4(%eax),%eax
  8041cd:	85 c0                	test   %eax,%eax
  8041cf:	74 0f                	je     8041e0 <insert_sorted_with_merge_freeList+0x5fc>
  8041d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041d4:	8b 40 04             	mov    0x4(%eax),%eax
  8041d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041da:	8b 12                	mov    (%edx),%edx
  8041dc:	89 10                	mov    %edx,(%eax)
  8041de:	eb 0a                	jmp    8041ea <insert_sorted_with_merge_freeList+0x606>
  8041e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041e3:	8b 00                	mov    (%eax),%eax
  8041e5:	a3 38 61 80 00       	mov    %eax,0x806138
  8041ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041fd:	a1 44 61 80 00       	mov    0x806144,%eax
  804202:	48                   	dec    %eax
  804203:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  804208:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80420b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  804212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804215:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80421c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804220:	75 17                	jne    804239 <insert_sorted_with_merge_freeList+0x655>
  804222:	83 ec 04             	sub    $0x4,%esp
  804225:	68 64 50 80 00       	push   $0x805064
  80422a:	68 6e 01 00 00       	push   $0x16e
  80422f:	68 87 50 80 00       	push   $0x805087
  804234:	e8 71 d0 ff ff       	call   8012aa <_panic>
  804239:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80423f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804242:	89 10                	mov    %edx,(%eax)
  804244:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804247:	8b 00                	mov    (%eax),%eax
  804249:	85 c0                	test   %eax,%eax
  80424b:	74 0d                	je     80425a <insert_sorted_with_merge_freeList+0x676>
  80424d:	a1 48 61 80 00       	mov    0x806148,%eax
  804252:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804255:	89 50 04             	mov    %edx,0x4(%eax)
  804258:	eb 08                	jmp    804262 <insert_sorted_with_merge_freeList+0x67e>
  80425a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80425d:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804262:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804265:	a3 48 61 80 00       	mov    %eax,0x806148
  80426a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80426d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804274:	a1 54 61 80 00       	mov    0x806154,%eax
  804279:	40                   	inc    %eax
  80427a:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  80427f:	e9 a9 00 00 00       	jmp    80432d <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  804284:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804288:	74 06                	je     804290 <insert_sorted_with_merge_freeList+0x6ac>
  80428a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80428e:	75 17                	jne    8042a7 <insert_sorted_with_merge_freeList+0x6c3>
  804290:	83 ec 04             	sub    $0x4,%esp
  804293:	68 fc 50 80 00       	push   $0x8050fc
  804298:	68 73 01 00 00       	push   $0x173
  80429d:	68 87 50 80 00       	push   $0x805087
  8042a2:	e8 03 d0 ff ff       	call   8012aa <_panic>
  8042a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042aa:	8b 10                	mov    (%eax),%edx
  8042ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8042af:	89 10                	mov    %edx,(%eax)
  8042b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8042b4:	8b 00                	mov    (%eax),%eax
  8042b6:	85 c0                	test   %eax,%eax
  8042b8:	74 0b                	je     8042c5 <insert_sorted_with_merge_freeList+0x6e1>
  8042ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042bd:	8b 00                	mov    (%eax),%eax
  8042bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8042c2:	89 50 04             	mov    %edx,0x4(%eax)
  8042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8042cb:	89 10                	mov    %edx,(%eax)
  8042cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8042d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042d3:	89 50 04             	mov    %edx,0x4(%eax)
  8042d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8042d9:	8b 00                	mov    (%eax),%eax
  8042db:	85 c0                	test   %eax,%eax
  8042dd:	75 08                	jne    8042e7 <insert_sorted_with_merge_freeList+0x703>
  8042df:	8b 45 08             	mov    0x8(%ebp),%eax
  8042e2:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8042e7:	a1 44 61 80 00       	mov    0x806144,%eax
  8042ec:	40                   	inc    %eax
  8042ed:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  8042f2:	eb 39                	jmp    80432d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8042f4:	a1 40 61 80 00       	mov    0x806140,%eax
  8042f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8042fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804300:	74 07                	je     804309 <insert_sorted_with_merge_freeList+0x725>
  804302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804305:	8b 00                	mov    (%eax),%eax
  804307:	eb 05                	jmp    80430e <insert_sorted_with_merge_freeList+0x72a>
  804309:	b8 00 00 00 00       	mov    $0x0,%eax
  80430e:	a3 40 61 80 00       	mov    %eax,0x806140
  804313:	a1 40 61 80 00       	mov    0x806140,%eax
  804318:	85 c0                	test   %eax,%eax
  80431a:	0f 85 c7 fb ff ff    	jne    803ee7 <insert_sorted_with_merge_freeList+0x303>
  804320:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804324:	0f 85 bd fb ff ff    	jne    803ee7 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80432a:	eb 01                	jmp    80432d <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80432c:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80432d:	90                   	nop
  80432e:	c9                   	leave  
  80432f:	c3                   	ret    

00804330 <__udivdi3>:
  804330:	55                   	push   %ebp
  804331:	57                   	push   %edi
  804332:	56                   	push   %esi
  804333:	53                   	push   %ebx
  804334:	83 ec 1c             	sub    $0x1c,%esp
  804337:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80433b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80433f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804343:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804347:	89 ca                	mov    %ecx,%edx
  804349:	89 f8                	mov    %edi,%eax
  80434b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80434f:	85 f6                	test   %esi,%esi
  804351:	75 2d                	jne    804380 <__udivdi3+0x50>
  804353:	39 cf                	cmp    %ecx,%edi
  804355:	77 65                	ja     8043bc <__udivdi3+0x8c>
  804357:	89 fd                	mov    %edi,%ebp
  804359:	85 ff                	test   %edi,%edi
  80435b:	75 0b                	jne    804368 <__udivdi3+0x38>
  80435d:	b8 01 00 00 00       	mov    $0x1,%eax
  804362:	31 d2                	xor    %edx,%edx
  804364:	f7 f7                	div    %edi
  804366:	89 c5                	mov    %eax,%ebp
  804368:	31 d2                	xor    %edx,%edx
  80436a:	89 c8                	mov    %ecx,%eax
  80436c:	f7 f5                	div    %ebp
  80436e:	89 c1                	mov    %eax,%ecx
  804370:	89 d8                	mov    %ebx,%eax
  804372:	f7 f5                	div    %ebp
  804374:	89 cf                	mov    %ecx,%edi
  804376:	89 fa                	mov    %edi,%edx
  804378:	83 c4 1c             	add    $0x1c,%esp
  80437b:	5b                   	pop    %ebx
  80437c:	5e                   	pop    %esi
  80437d:	5f                   	pop    %edi
  80437e:	5d                   	pop    %ebp
  80437f:	c3                   	ret    
  804380:	39 ce                	cmp    %ecx,%esi
  804382:	77 28                	ja     8043ac <__udivdi3+0x7c>
  804384:	0f bd fe             	bsr    %esi,%edi
  804387:	83 f7 1f             	xor    $0x1f,%edi
  80438a:	75 40                	jne    8043cc <__udivdi3+0x9c>
  80438c:	39 ce                	cmp    %ecx,%esi
  80438e:	72 0a                	jb     80439a <__udivdi3+0x6a>
  804390:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804394:	0f 87 9e 00 00 00    	ja     804438 <__udivdi3+0x108>
  80439a:	b8 01 00 00 00       	mov    $0x1,%eax
  80439f:	89 fa                	mov    %edi,%edx
  8043a1:	83 c4 1c             	add    $0x1c,%esp
  8043a4:	5b                   	pop    %ebx
  8043a5:	5e                   	pop    %esi
  8043a6:	5f                   	pop    %edi
  8043a7:	5d                   	pop    %ebp
  8043a8:	c3                   	ret    
  8043a9:	8d 76 00             	lea    0x0(%esi),%esi
  8043ac:	31 ff                	xor    %edi,%edi
  8043ae:	31 c0                	xor    %eax,%eax
  8043b0:	89 fa                	mov    %edi,%edx
  8043b2:	83 c4 1c             	add    $0x1c,%esp
  8043b5:	5b                   	pop    %ebx
  8043b6:	5e                   	pop    %esi
  8043b7:	5f                   	pop    %edi
  8043b8:	5d                   	pop    %ebp
  8043b9:	c3                   	ret    
  8043ba:	66 90                	xchg   %ax,%ax
  8043bc:	89 d8                	mov    %ebx,%eax
  8043be:	f7 f7                	div    %edi
  8043c0:	31 ff                	xor    %edi,%edi
  8043c2:	89 fa                	mov    %edi,%edx
  8043c4:	83 c4 1c             	add    $0x1c,%esp
  8043c7:	5b                   	pop    %ebx
  8043c8:	5e                   	pop    %esi
  8043c9:	5f                   	pop    %edi
  8043ca:	5d                   	pop    %ebp
  8043cb:	c3                   	ret    
  8043cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8043d1:	89 eb                	mov    %ebp,%ebx
  8043d3:	29 fb                	sub    %edi,%ebx
  8043d5:	89 f9                	mov    %edi,%ecx
  8043d7:	d3 e6                	shl    %cl,%esi
  8043d9:	89 c5                	mov    %eax,%ebp
  8043db:	88 d9                	mov    %bl,%cl
  8043dd:	d3 ed                	shr    %cl,%ebp
  8043df:	89 e9                	mov    %ebp,%ecx
  8043e1:	09 f1                	or     %esi,%ecx
  8043e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8043e7:	89 f9                	mov    %edi,%ecx
  8043e9:	d3 e0                	shl    %cl,%eax
  8043eb:	89 c5                	mov    %eax,%ebp
  8043ed:	89 d6                	mov    %edx,%esi
  8043ef:	88 d9                	mov    %bl,%cl
  8043f1:	d3 ee                	shr    %cl,%esi
  8043f3:	89 f9                	mov    %edi,%ecx
  8043f5:	d3 e2                	shl    %cl,%edx
  8043f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043fb:	88 d9                	mov    %bl,%cl
  8043fd:	d3 e8                	shr    %cl,%eax
  8043ff:	09 c2                	or     %eax,%edx
  804401:	89 d0                	mov    %edx,%eax
  804403:	89 f2                	mov    %esi,%edx
  804405:	f7 74 24 0c          	divl   0xc(%esp)
  804409:	89 d6                	mov    %edx,%esi
  80440b:	89 c3                	mov    %eax,%ebx
  80440d:	f7 e5                	mul    %ebp
  80440f:	39 d6                	cmp    %edx,%esi
  804411:	72 19                	jb     80442c <__udivdi3+0xfc>
  804413:	74 0b                	je     804420 <__udivdi3+0xf0>
  804415:	89 d8                	mov    %ebx,%eax
  804417:	31 ff                	xor    %edi,%edi
  804419:	e9 58 ff ff ff       	jmp    804376 <__udivdi3+0x46>
  80441e:	66 90                	xchg   %ax,%ax
  804420:	8b 54 24 08          	mov    0x8(%esp),%edx
  804424:	89 f9                	mov    %edi,%ecx
  804426:	d3 e2                	shl    %cl,%edx
  804428:	39 c2                	cmp    %eax,%edx
  80442a:	73 e9                	jae    804415 <__udivdi3+0xe5>
  80442c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80442f:	31 ff                	xor    %edi,%edi
  804431:	e9 40 ff ff ff       	jmp    804376 <__udivdi3+0x46>
  804436:	66 90                	xchg   %ax,%ax
  804438:	31 c0                	xor    %eax,%eax
  80443a:	e9 37 ff ff ff       	jmp    804376 <__udivdi3+0x46>
  80443f:	90                   	nop

00804440 <__umoddi3>:
  804440:	55                   	push   %ebp
  804441:	57                   	push   %edi
  804442:	56                   	push   %esi
  804443:	53                   	push   %ebx
  804444:	83 ec 1c             	sub    $0x1c,%esp
  804447:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80444b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80444f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804453:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804457:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80445b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80445f:	89 f3                	mov    %esi,%ebx
  804461:	89 fa                	mov    %edi,%edx
  804463:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804467:	89 34 24             	mov    %esi,(%esp)
  80446a:	85 c0                	test   %eax,%eax
  80446c:	75 1a                	jne    804488 <__umoddi3+0x48>
  80446e:	39 f7                	cmp    %esi,%edi
  804470:	0f 86 a2 00 00 00    	jbe    804518 <__umoddi3+0xd8>
  804476:	89 c8                	mov    %ecx,%eax
  804478:	89 f2                	mov    %esi,%edx
  80447a:	f7 f7                	div    %edi
  80447c:	89 d0                	mov    %edx,%eax
  80447e:	31 d2                	xor    %edx,%edx
  804480:	83 c4 1c             	add    $0x1c,%esp
  804483:	5b                   	pop    %ebx
  804484:	5e                   	pop    %esi
  804485:	5f                   	pop    %edi
  804486:	5d                   	pop    %ebp
  804487:	c3                   	ret    
  804488:	39 f0                	cmp    %esi,%eax
  80448a:	0f 87 ac 00 00 00    	ja     80453c <__umoddi3+0xfc>
  804490:	0f bd e8             	bsr    %eax,%ebp
  804493:	83 f5 1f             	xor    $0x1f,%ebp
  804496:	0f 84 ac 00 00 00    	je     804548 <__umoddi3+0x108>
  80449c:	bf 20 00 00 00       	mov    $0x20,%edi
  8044a1:	29 ef                	sub    %ebp,%edi
  8044a3:	89 fe                	mov    %edi,%esi
  8044a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8044a9:	89 e9                	mov    %ebp,%ecx
  8044ab:	d3 e0                	shl    %cl,%eax
  8044ad:	89 d7                	mov    %edx,%edi
  8044af:	89 f1                	mov    %esi,%ecx
  8044b1:	d3 ef                	shr    %cl,%edi
  8044b3:	09 c7                	or     %eax,%edi
  8044b5:	89 e9                	mov    %ebp,%ecx
  8044b7:	d3 e2                	shl    %cl,%edx
  8044b9:	89 14 24             	mov    %edx,(%esp)
  8044bc:	89 d8                	mov    %ebx,%eax
  8044be:	d3 e0                	shl    %cl,%eax
  8044c0:	89 c2                	mov    %eax,%edx
  8044c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044c6:	d3 e0                	shl    %cl,%eax
  8044c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044d0:	89 f1                	mov    %esi,%ecx
  8044d2:	d3 e8                	shr    %cl,%eax
  8044d4:	09 d0                	or     %edx,%eax
  8044d6:	d3 eb                	shr    %cl,%ebx
  8044d8:	89 da                	mov    %ebx,%edx
  8044da:	f7 f7                	div    %edi
  8044dc:	89 d3                	mov    %edx,%ebx
  8044de:	f7 24 24             	mull   (%esp)
  8044e1:	89 c6                	mov    %eax,%esi
  8044e3:	89 d1                	mov    %edx,%ecx
  8044e5:	39 d3                	cmp    %edx,%ebx
  8044e7:	0f 82 87 00 00 00    	jb     804574 <__umoddi3+0x134>
  8044ed:	0f 84 91 00 00 00    	je     804584 <__umoddi3+0x144>
  8044f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8044f7:	29 f2                	sub    %esi,%edx
  8044f9:	19 cb                	sbb    %ecx,%ebx
  8044fb:	89 d8                	mov    %ebx,%eax
  8044fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804501:	d3 e0                	shl    %cl,%eax
  804503:	89 e9                	mov    %ebp,%ecx
  804505:	d3 ea                	shr    %cl,%edx
  804507:	09 d0                	or     %edx,%eax
  804509:	89 e9                	mov    %ebp,%ecx
  80450b:	d3 eb                	shr    %cl,%ebx
  80450d:	89 da                	mov    %ebx,%edx
  80450f:	83 c4 1c             	add    $0x1c,%esp
  804512:	5b                   	pop    %ebx
  804513:	5e                   	pop    %esi
  804514:	5f                   	pop    %edi
  804515:	5d                   	pop    %ebp
  804516:	c3                   	ret    
  804517:	90                   	nop
  804518:	89 fd                	mov    %edi,%ebp
  80451a:	85 ff                	test   %edi,%edi
  80451c:	75 0b                	jne    804529 <__umoddi3+0xe9>
  80451e:	b8 01 00 00 00       	mov    $0x1,%eax
  804523:	31 d2                	xor    %edx,%edx
  804525:	f7 f7                	div    %edi
  804527:	89 c5                	mov    %eax,%ebp
  804529:	89 f0                	mov    %esi,%eax
  80452b:	31 d2                	xor    %edx,%edx
  80452d:	f7 f5                	div    %ebp
  80452f:	89 c8                	mov    %ecx,%eax
  804531:	f7 f5                	div    %ebp
  804533:	89 d0                	mov    %edx,%eax
  804535:	e9 44 ff ff ff       	jmp    80447e <__umoddi3+0x3e>
  80453a:	66 90                	xchg   %ax,%ax
  80453c:	89 c8                	mov    %ecx,%eax
  80453e:	89 f2                	mov    %esi,%edx
  804540:	83 c4 1c             	add    $0x1c,%esp
  804543:	5b                   	pop    %ebx
  804544:	5e                   	pop    %esi
  804545:	5f                   	pop    %edi
  804546:	5d                   	pop    %ebp
  804547:	c3                   	ret    
  804548:	3b 04 24             	cmp    (%esp),%eax
  80454b:	72 06                	jb     804553 <__umoddi3+0x113>
  80454d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804551:	77 0f                	ja     804562 <__umoddi3+0x122>
  804553:	89 f2                	mov    %esi,%edx
  804555:	29 f9                	sub    %edi,%ecx
  804557:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80455b:	89 14 24             	mov    %edx,(%esp)
  80455e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804562:	8b 44 24 04          	mov    0x4(%esp),%eax
  804566:	8b 14 24             	mov    (%esp),%edx
  804569:	83 c4 1c             	add    $0x1c,%esp
  80456c:	5b                   	pop    %ebx
  80456d:	5e                   	pop    %esi
  80456e:	5f                   	pop    %edi
  80456f:	5d                   	pop    %ebp
  804570:	c3                   	ret    
  804571:	8d 76 00             	lea    0x0(%esi),%esi
  804574:	2b 04 24             	sub    (%esp),%eax
  804577:	19 fa                	sbb    %edi,%edx
  804579:	89 d1                	mov    %edx,%ecx
  80457b:	89 c6                	mov    %eax,%esi
  80457d:	e9 71 ff ff ff       	jmp    8044f3 <__umoddi3+0xb3>
  804582:	66 90                	xchg   %ax,%ax
  804584:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804588:	72 ea                	jb     804574 <__umoddi3+0x134>
  80458a:	89 d9                	mov    %ebx,%ecx
  80458c:	e9 62 ff ff ff       	jmp    8044f3 <__umoddi3+0xb3>
