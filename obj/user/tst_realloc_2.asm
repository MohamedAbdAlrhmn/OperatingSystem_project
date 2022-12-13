
obj/user/tst_realloc_2:     file format elf32-i386


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
  800031:	e8 b7 12 00 00       	call   8012ed <libmain>
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
  800040:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  800047:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
  800054:	b9 14 00 00 00       	mov    $0x14,%ecx
  800059:	b8 00 00 00 00       	mov    $0x0,%eax
  80005e:	89 d7                	mov    %edx,%edi
  800060:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  800062:	83 ec 0c             	sub    $0xc,%esp
  800065:	68 00 48 80 00       	push   $0x804800
  80006a:	e8 6e 16 00 00       	call   8016dd <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800072:	e8 55 29 00 00       	call   8029cc <sys_calculate_free_frames>
  800077:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80007a:	e8 ed 29 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  800082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800085:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	50                   	push   %eax
  80008c:	e8 d4 25 00 00       	call   802665 <malloc>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8000a0:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a5:	74 14                	je     8000bb <_main+0x83>
  8000a7:	83 ec 04             	sub    $0x4,%esp
  8000aa:	68 24 48 80 00       	push   $0x804824
  8000af:	6a 11                	push   $0x11
  8000b1:	68 54 48 80 00       	push   $0x804854
  8000b6:	e8 6e 13 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000be:	e8 09 29 00 00       	call   8029cc <sys_calculate_free_frames>
  8000c3:	29 c3                	sub    %eax,%ebx
  8000c5:	89 d8                	mov    %ebx,%eax
  8000c7:	83 f8 01             	cmp    $0x1,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 6c 48 80 00       	push   $0x80486c
  8000d4:	6a 13                	push   $0x13
  8000d6:	68 54 48 80 00       	push   $0x804854
  8000db:	e8 49 13 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8000e0:	e8 87 29 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8000e5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8000e8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 d8 48 80 00       	push   $0x8048d8
  8000f7:	6a 14                	push   $0x14
  8000f9:	68 54 48 80 00       	push   $0x804854
  8000fe:	e8 26 13 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800103:	e8 c4 28 00 00       	call   8029cc <sys_calculate_free_frames>
  800108:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 5c 29 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800110:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	50                   	push   %eax
  80011d:	e8 43 25 00 00       	call   802665 <malloc>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80012b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800131:	89 c2                	mov    %eax,%edx
  800133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800136:	05 00 00 00 80       	add    $0x80000000,%eax
  80013b:	39 c2                	cmp    %eax,%edx
  80013d:	74 14                	je     800153 <_main+0x11b>
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 24 48 80 00       	push   $0x804824
  800147:	6a 1a                	push   $0x1a
  800149:	68 54 48 80 00       	push   $0x804854
  80014e:	e8 d6 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800153:	e8 74 28 00 00       	call   8029cc <sys_calculate_free_frames>
  800158:	89 c2                	mov    %eax,%edx
  80015a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015d:	39 c2                	cmp    %eax,%edx
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 6c 48 80 00       	push   $0x80486c
  800169:	6a 1c                	push   $0x1c
  80016b:	68 54 48 80 00       	push   $0x804854
  800170:	e8 b4 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800175:	e8 f2 28 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  80017a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017d:	3d 00 01 00 00       	cmp    $0x100,%eax
  800182:	74 14                	je     800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 d8 48 80 00       	push   $0x8048d8
  80018c:	6a 1d                	push   $0x1d
  80018e:	68 54 48 80 00       	push   $0x804854
  800193:	e8 91 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800198:	e8 2f 28 00 00       	call   8029cc <sys_calculate_free_frames>
  80019d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001a0:	e8 c7 28 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8001a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ab:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	50                   	push   %eax
  8001b2:	e8 ae 24 00 00       	call   802665 <malloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001bd:	8b 45 80             	mov    -0x80(%ebp),%eax
  8001c0:	89 c2                	mov    %eax,%edx
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 24 48 80 00       	push   $0x804824
  8001d8:	6a 23                	push   $0x23
  8001da:	68 54 48 80 00       	push   $0x804854
  8001df:	e8 45 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001e4:	e8 e3 27 00 00       	call   8029cc <sys_calculate_free_frames>
  8001e9:	89 c2                	mov    %eax,%edx
  8001eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	74 14                	je     800206 <_main+0x1ce>
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	68 6c 48 80 00       	push   $0x80486c
  8001fa:	6a 25                	push   $0x25
  8001fc:	68 54 48 80 00       	push   $0x804854
  800201:	e8 23 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800206:	e8 61 28 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  80020b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80020e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800213:	74 14                	je     800229 <_main+0x1f1>
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	68 d8 48 80 00       	push   $0x8048d8
  80021d:	6a 26                	push   $0x26
  80021f:	68 54 48 80 00       	push   $0x804854
  800224:	e8 00 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800229:	e8 9e 27 00 00       	call   8029cc <sys_calculate_free_frames>
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800231:	e8 36 28 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800236:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	50                   	push   %eax
  800243:	e8 1d 24 00 00       	call   802665 <malloc>
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80024e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800251:	89 c1                	mov    %eax,%ecx
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	05 00 00 00 80       	add    $0x80000000,%eax
  800261:	39 c1                	cmp    %eax,%ecx
  800263:	74 14                	je     800279 <_main+0x241>
  800265:	83 ec 04             	sub    $0x4,%esp
  800268:	68 24 48 80 00       	push   $0x804824
  80026d:	6a 2c                	push   $0x2c
  80026f:	68 54 48 80 00       	push   $0x804854
  800274:	e8 b0 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800279:	e8 4e 27 00 00       	call   8029cc <sys_calculate_free_frames>
  80027e:	89 c2                	mov    %eax,%edx
  800280:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 6c 48 80 00       	push   $0x80486c
  80028f:	6a 2e                	push   $0x2e
  800291:	68 54 48 80 00       	push   $0x804854
  800296:	e8 8e 11 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80029b:	e8 cc 27 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8002a0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002a3:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002a8:	74 14                	je     8002be <_main+0x286>
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 d8 48 80 00       	push   $0x8048d8
  8002b2:	6a 2f                	push   $0x2f
  8002b4:	68 54 48 80 00       	push   $0x804854
  8002b9:	e8 6b 11 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002be:	e8 09 27 00 00       	call   8029cc <sys_calculate_free_frames>
  8002c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002c6:	e8 a1 27 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8002cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d1:	01 c0                	add    %eax,%eax
  8002d3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 86 23 00 00       	call   802665 <malloc>
  8002df:	83 c4 10             	add    $0x10,%esp
  8002e2:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002e5:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002e8:	89 c2                	mov    %eax,%edx
  8002ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	05 00 00 00 80       	add    $0x80000000,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 14                	je     80030d <_main+0x2d5>
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 24 48 80 00       	push   $0x804824
  800301:	6a 35                	push   $0x35
  800303:	68 54 48 80 00       	push   $0x804854
  800308:	e8 1c 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80030d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800310:	e8 b7 26 00 00       	call   8029cc <sys_calculate_free_frames>
  800315:	29 c3                	sub    %eax,%ebx
  800317:	89 d8                	mov    %ebx,%eax
  800319:	83 f8 01             	cmp    $0x1,%eax
  80031c:	74 14                	je     800332 <_main+0x2fa>
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	68 6c 48 80 00       	push   $0x80486c
  800326:	6a 37                	push   $0x37
  800328:	68 54 48 80 00       	push   $0x804854
  80032d:	e8 f7 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800332:	e8 35 27 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800337:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80033a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033f:	74 14                	je     800355 <_main+0x31d>
  800341:	83 ec 04             	sub    $0x4,%esp
  800344:	68 d8 48 80 00       	push   $0x8048d8
  800349:	6a 38                	push   $0x38
  80034b:	68 54 48 80 00       	push   $0x804854
  800350:	e8 d4 10 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800355:	e8 72 26 00 00       	call   8029cc <sys_calculate_free_frames>
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035d:	e8 0a 27 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800362:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	50                   	push   %eax
  800371:	e8 ef 22 00 00       	call   802665 <malloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80037c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80037f:	89 c1                	mov    %eax,%ecx
  800381:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800384:	89 d0                	mov    %edx,%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	01 d0                	add    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	05 00 00 00 80       	add    $0x80000000,%eax
  800391:	39 c1                	cmp    %eax,%ecx
  800393:	74 14                	je     8003a9 <_main+0x371>
  800395:	83 ec 04             	sub    $0x4,%esp
  800398:	68 24 48 80 00       	push   $0x804824
  80039d:	6a 3e                	push   $0x3e
  80039f:	68 54 48 80 00       	push   $0x804854
  8003a4:	e8 80 10 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003a9:	e8 1e 26 00 00       	call   8029cc <sys_calculate_free_frames>
  8003ae:	89 c2                	mov    %eax,%edx
  8003b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 6c 48 80 00       	push   $0x80486c
  8003bf:	6a 40                	push   $0x40
  8003c1:	68 54 48 80 00       	push   $0x804854
  8003c6:	e8 5e 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003cb:	e8 9c 26 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8003d0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 d8 48 80 00       	push   $0x8048d8
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 54 48 80 00       	push   $0x804854
  8003e9:	e8 3b 10 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003ee:	e8 d9 25 00 00       	call   8029cc <sys_calculate_free_frames>
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003f6:	e8 71 26 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8003fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800401:	89 c2                	mov    %eax,%edx
  800403:	01 d2                	add    %edx,%edx
  800405:	01 d0                	add    %edx,%eax
  800407:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	50                   	push   %eax
  80040e:	e8 52 22 00 00       	call   802665 <malloc>
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800419:	8b 45 90             	mov    -0x70(%ebp),%eax
  80041c:	89 c2                	mov    %eax,%edx
  80041e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	05 00 00 00 80       	add    $0x80000000,%eax
  800429:	39 c2                	cmp    %eax,%edx
  80042b:	74 14                	je     800441 <_main+0x409>
  80042d:	83 ec 04             	sub    $0x4,%esp
  800430:	68 24 48 80 00       	push   $0x804824
  800435:	6a 47                	push   $0x47
  800437:	68 54 48 80 00       	push   $0x804854
  80043c:	e8 e8 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800441:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800444:	e8 83 25 00 00       	call   8029cc <sys_calculate_free_frames>
  800449:	29 c3                	sub    %eax,%ebx
  80044b:	89 d8                	mov    %ebx,%eax
  80044d:	83 f8 01             	cmp    $0x1,%eax
  800450:	74 14                	je     800466 <_main+0x42e>
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	68 6c 48 80 00       	push   $0x80486c
  80045a:	6a 49                	push   $0x49
  80045c:	68 54 48 80 00       	push   $0x804854
  800461:	e8 c3 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800466:	e8 01 26 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  80046b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80046e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 d8 48 80 00       	push   $0x8048d8
  80047d:	6a 4a                	push   $0x4a
  80047f:	68 54 48 80 00       	push   $0x804854
  800484:	e8 a0 0f 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800489:	e8 3e 25 00 00       	call   8029cc <sys_calculate_free_frames>
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800491:	e8 d6 25 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800496:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	01 d2                	add    %edx,%edx
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8004a5:	83 ec 0c             	sub    $0xc,%esp
  8004a8:	50                   	push   %eax
  8004a9:	e8 b7 21 00 00       	call   802665 <malloc>
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004b4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004b7:	89 c1                	mov    %eax,%ecx
  8004b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004bc:	89 d0                	mov    %edx,%eax
  8004be:	c1 e0 02             	shl    $0x2,%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	01 c0                	add    %eax,%eax
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8004cc:	39 c1                	cmp    %eax,%ecx
  8004ce:	74 14                	je     8004e4 <_main+0x4ac>
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	68 24 48 80 00       	push   $0x804824
  8004d8:	6a 50                	push   $0x50
  8004da:	68 54 48 80 00       	push   $0x804854
  8004df:	e8 45 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004e4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e7:	e8 e0 24 00 00       	call   8029cc <sys_calculate_free_frames>
  8004ec:	29 c3                	sub    %eax,%ebx
  8004ee:	89 d8                	mov    %ebx,%eax
  8004f0:	83 f8 01             	cmp    $0x1,%eax
  8004f3:	74 14                	je     800509 <_main+0x4d1>
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 6c 48 80 00       	push   $0x80486c
  8004fd:	6a 52                	push   $0x52
  8004ff:	68 54 48 80 00       	push   $0x804854
  800504:	e8 20 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800509:	e8 5e 25 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  80050e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800511:	3d 00 03 00 00       	cmp    $0x300,%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 d8 48 80 00       	push   $0x8048d8
  800520:	6a 53                	push   $0x53
  800522:	68 54 48 80 00       	push   $0x804854
  800527:	e8 fd 0e 00 00       	call   801429 <_panic>

		//Allocate the remaining space in user heap
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 9b 24 00 00       	call   8029cc <sys_calculate_free_frames>
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800534:	e8 33 25 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800539:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc((USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega - kilo);
  80053c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	01 c0                	add    %eax,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	01 c0                	add    %eax,%eax
  80054b:	f7 d8                	neg    %eax
  80054d:	89 c2                	mov    %eax,%edx
  80054f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800552:	29 c2                	sub    %eax,%edx
  800554:	89 d0                	mov    %edx,%eax
  800556:	05 00 00 00 20       	add    $0x20000000,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 01 21 00 00       	call   802665 <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80056a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056d:	89 c1                	mov    %eax,%ecx
  80056f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800572:	89 d0                	mov    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	01 c0                	add    %eax,%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	01 c0                	add    %eax,%eax
  80057e:	05 00 00 00 80       	add    $0x80000000,%eax
  800583:	39 c1                	cmp    %eax,%ecx
  800585:	74 14                	je     80059b <_main+0x563>
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	68 24 48 80 00       	push   $0x804824
  80058f:	6a 59                	push   $0x59
  800591:	68 54 48 80 00       	push   $0x804854
  800596:	e8 8e 0e 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80059b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059e:	e8 29 24 00 00       	call   8029cc <sys_calculate_free_frames>
  8005a3:	29 c3                	sub    %eax,%ebx
  8005a5:	89 d8                	mov    %ebx,%eax
  8005a7:	83 f8 7c             	cmp    $0x7c,%eax
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 6c 48 80 00       	push   $0x80486c
  8005b4:	6a 5b                	push   $0x5b
  8005b6:	68 54 48 80 00       	push   $0x804854
  8005bb:	e8 69 0e 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005c0:	e8 a7 24 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8005c5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8005c8:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005cd:	74 14                	je     8005e3 <_main+0x5ab>
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 d8 48 80 00       	push   $0x8048d8
  8005d7:	6a 5c                	push   $0x5c
  8005d9:	68 54 48 80 00       	push   $0x804854
  8005de:	e8 46 0e 00 00       	call   801429 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005e3:	e8 e4 23 00 00       	call   8029cc <sys_calculate_free_frames>
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005eb:	e8 7c 24 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  8005f3:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	e8 de 20 00 00       	call   8026e0 <free>
  800602:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800605:	e8 62 24 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  80060a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80060d:	29 c2                	sub    %eax,%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	3d 00 01 00 00       	cmp    $0x100,%eax
  800616:	74 14                	je     80062c <_main+0x5f4>
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	68 08 49 80 00       	push   $0x804908
  800620:	6a 67                	push   $0x67
  800622:	68 54 48 80 00       	push   $0x804854
  800627:	e8 fd 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80062c:	e8 9b 23 00 00       	call   8029cc <sys_calculate_free_frames>
  800631:	89 c2                	mov    %eax,%edx
  800633:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800636:	39 c2                	cmp    %eax,%edx
  800638:	74 14                	je     80064e <_main+0x616>
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	68 44 49 80 00       	push   $0x804944
  800642:	6a 68                	push   $0x68
  800644:	68 54 48 80 00       	push   $0x804854
  800649:	e8 db 0d 00 00       	call   801429 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80064e:	e8 79 23 00 00       	call   8029cc <sys_calculate_free_frames>
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800656:	e8 11 24 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  80065b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  80065e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800661:	83 ec 0c             	sub    $0xc,%esp
  800664:	50                   	push   %eax
  800665:	e8 76 20 00 00       	call   8026e0 <free>
  80066a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80066d:	e8 fa 23 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800672:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800675:	29 c2                	sub    %eax,%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	3d 00 02 00 00       	cmp    $0x200,%eax
  80067e:	74 14                	je     800694 <_main+0x65c>
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	68 08 49 80 00       	push   $0x804908
  800688:	6a 6f                	push   $0x6f
  80068a:	68 54 48 80 00       	push   $0x804854
  80068f:	e8 95 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800694:	e8 33 23 00 00       	call   8029cc <sys_calculate_free_frames>
  800699:	89 c2                	mov    %eax,%edx
  80069b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069e:	39 c2                	cmp    %eax,%edx
  8006a0:	74 14                	je     8006b6 <_main+0x67e>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 44 49 80 00       	push   $0x804944
  8006aa:	6a 70                	push   $0x70
  8006ac:	68 54 48 80 00       	push   $0x804854
  8006b1:	e8 73 0d 00 00       	call   801429 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006b6:	e8 11 23 00 00       	call   8029cc <sys_calculate_free_frames>
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006be:	e8 a9 23 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8006c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  8006c6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006c9:	83 ec 0c             	sub    $0xc,%esp
  8006cc:	50                   	push   %eax
  8006cd:	e8 0e 20 00 00       	call   8026e0 <free>
  8006d2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006d5:	e8 92 23 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8006da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006dd:	29 c2                	sub    %eax,%edx
  8006df:	89 d0                	mov    %edx,%eax
  8006e1:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006e6:	74 14                	je     8006fc <_main+0x6c4>
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	68 08 49 80 00       	push   $0x804908
  8006f0:	6a 77                	push   $0x77
  8006f2:	68 54 48 80 00       	push   $0x804854
  8006f7:	e8 2d 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006fc:	e8 cb 22 00 00       	call   8029cc <sys_calculate_free_frames>
  800701:	89 c2                	mov    %eax,%edx
  800703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 14                	je     80071e <_main+0x6e6>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 44 49 80 00       	push   $0x804944
  800712:	6a 78                	push   $0x78
  800714:	68 54 48 80 00       	push   $0x804854
  800719:	e8 0b 0d 00 00       	call   801429 <_panic>
//		free(ptr_allocations[8]);
//		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
//		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
//		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
	}
	int cnt = 0;
  80071e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 03                	push   $0x3
  80072a:	e8 35 26 00 00       	call   802d64 <sys_bypassPageFault>
  80072f:	83 c4 10             	add    $0x10,%esp

	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate with size = 0*/

		char *byteArr = (char *) ptr_allocations[0];
  800732:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//Reallocate with size = 0 [delete it]
		freeFrames = sys_calculate_free_frames() ;
  80073b:	e8 8c 22 00 00       	call   8029cc <sys_calculate_free_frames>
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800743:	e8 24 23 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800748:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 0);
  80074b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	6a 00                	push   $0x0
  800756:	50                   	push   %eax
  800757:	e8 ee 20 00 00       	call   80284a <realloc>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != 0) panic("Wrong start address for the re-allocated space...it should return NULL!");
  800765:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80076b:	85 c0                	test   %eax,%eax
  80076d:	74 17                	je     800786 <_main+0x74e>
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	68 90 49 80 00       	push   $0x804990
  800777:	68 94 00 00 00       	push   $0x94
  80077c:	68 54 48 80 00       	push   $0x804854
  800781:	e8 a3 0c 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800786:	e8 41 22 00 00       	call   8029cc <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	39 c2                	cmp    %eax,%edx
  800792:	74 17                	je     8007ab <_main+0x773>
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	68 d8 49 80 00       	push   $0x8049d8
  80079c:	68 96 00 00 00       	push   $0x96
  8007a1:	68 54 48 80 00       	push   $0x804854
  8007a6:	e8 7e 0c 00 00       	call   801429 <_panic>
		if((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8007ab:	e8 bc 22 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8007b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007b3:	29 c2                	sub    %eax,%edx
  8007b5:	89 d0                	mov    %edx,%eax
  8007b7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 48 4a 80 00       	push   $0x804a48
  8007c6:	68 97 00 00 00       	push   $0x97
  8007cb:	68 54 48 80 00       	push   $0x804854
  8007d0:	e8 54 0c 00 00       	call   801429 <_panic>

		//[2] test memory access
		byteArr[0] = 10;
  8007d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("successful access to re-allocated space with size 0!! it should not be succeeded");
  8007db:	e8 6b 25 00 00       	call   802d4b <sys_rcr2>
  8007e0:	89 c2                	mov    %eax,%edx
  8007e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 17                	je     800800 <_main+0x7c8>
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 7c 4a 80 00       	push   $0x804a7c
  8007f1:	68 9b 00 00 00       	push   $0x9b
  8007f6:	68 54 48 80 00       	push   $0x804854
  8007fb:	e8 29 0c 00 00       	call   801429 <_panic>
		byteArr[(1*Mega-kilo)/sizeof(char) - 1] = 10;
  800800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800803:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800806:	8d 50 ff             	lea    -0x1(%eax),%edx
  800809:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[(1*Mega-kilo)/sizeof(char) - 1])) panic("successful access to reallocated space of size 0!! it should not be succeeded");
  800811:	e8 35 25 00 00       	call   802d4b <sys_rcr2>
  800816:	89 c2                	mov    %eax,%edx
  800818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80081e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800821:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800824:	01 c8                	add    %ecx,%eax
  800826:	39 c2                	cmp    %eax,%edx
  800828:	74 17                	je     800841 <_main+0x809>
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	68 d0 4a 80 00       	push   $0x804ad0
  800832:	68 9d 00 00 00       	push   $0x9d
  800837:	68 54 48 80 00       	push   $0x804854
  80083c:	e8 e8 0b 00 00       	call   801429 <_panic>

		//set it to 0 again to cancel the bypassing option
		sys_bypassPageFault(0);
  800841:	83 ec 0c             	sub    $0xc,%esp
  800844:	6a 00                	push   $0x0
  800846:	e8 19 25 00 00       	call   802d64 <sys_bypassPageFault>
  80084b:	83 c4 10             	add    $0x10,%esp

		vcprintf("\b\b\b20%", NULL);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	6a 00                	push   $0x0
  800853:	68 1e 4b 80 00       	push   $0x804b1e
  800858:	e8 15 0e 00 00       	call   801672 <vcprintf>
  80085d:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate with address = NULL*/

		//new allocation with size = 2.5 MB, should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800860:	e8 67 21 00 00       	call   8029cc <sys_calculate_free_frames>
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800868:	e8 ff 21 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  80086d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(NULL, 2*Mega + 510*kilo);
  800870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800873:	89 d0                	mov    %edx,%eax
  800875:	c1 e0 08             	shl    $0x8,%eax
  800878:	29 d0                	sub    %edx,%eax
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	01 c0                	add    %eax,%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	50                   	push   %eax
  800887:	6a 00                	push   $0x0
  800889:	e8 bc 1f 00 00       	call   80284a <realloc>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800894:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800897:	89 c2                	mov    %eax,%edx
  800899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80089c:	c1 e0 03             	shl    $0x3,%eax
  80089f:	05 00 00 00 80       	add    $0x80000000,%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	83 ec 04             	sub    $0x4,%esp
  8008ab:	68 24 48 80 00       	push   $0x804824
  8008b0:	68 aa 00 00 00       	push   $0xaa
  8008b5:	68 54 48 80 00       	push   $0x804854
  8008ba:	e8 6a 0b 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 640) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008bf:	e8 08 21 00 00       	call   8029cc <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	68 d8 49 80 00       	push   $0x8049d8
  8008d5:	68 ac 00 00 00       	push   $0xac
  8008da:	68 54 48 80 00       	push   $0x804854
  8008df:	e8 45 0b 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 640) panic("Extra or less pages are re-allocated in PageFile");
  8008e4:	e8 83 21 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8008e9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008ec:	3d 80 02 00 00       	cmp    $0x280,%eax
  8008f1:	74 17                	je     80090a <_main+0x8d2>
  8008f3:	83 ec 04             	sub    $0x4,%esp
  8008f6:	68 48 4a 80 00       	push   $0x804a48
  8008fb:	68 ad 00 00 00       	push   $0xad
  800900:	68 54 48 80 00       	push   $0x804854
  800905:	e8 1f 0b 00 00       	call   801429 <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[10];
  80090a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80090d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfInt1 = (2*Mega + 510*kilo)/sizeof(int) - 1;
  800910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800913:	89 d0                	mov    %edx,%eax
  800915:	c1 e0 08             	shl    $0x8,%eax
  800918:	29 d0                	sub    %edx,%eax
  80091a:	89 c2                	mov    %eax,%edx
  80091c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	01 c0                	add    %eax,%eax
  800923:	c1 e8 02             	shr    $0x2,%eax
  800926:	48                   	dec    %eax
  800927:	89 45 d0             	mov    %eax,-0x30(%ebp)

		int i = 0;
  80092a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  800931:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800938:	eb 17                	jmp    800951 <_main+0x919>
		{
			intArr[i] = i;
  80093a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800947:	01 c2                	add    %eax,%edx
  800949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094c:	89 02                	mov    %eax,(%edx)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  80094e:	ff 45 f0             	incl   -0x10(%ebp)
  800951:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800955:	7e e3                	jle    80093a <_main+0x902>
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800957:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80095a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095d:	eb 17                	jmp    800976 <_main+0x93e>
		{
			intArr[i] = i;
  80095f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800962:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80096c:	01 c2                	add    %eax,%edx
  80096e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800971:	89 02                	mov    %eax,(%edx)
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800973:	ff 4d f0             	decl   -0x10(%ebp)
  800976:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800979:	83 e8 63             	sub    $0x63,%eax
  80097c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80097f:	7e de                	jle    80095f <_main+0x927>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800981:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800988:	eb 33                	jmp    8009bd <_main+0x985>
		{
			cnt++;
  80098a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800997:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80099a:	01 d0                	add    %edx,%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009a1:	74 17                	je     8009ba <_main+0x982>
  8009a3:	83 ec 04             	sub    $0x4,%esp
  8009a6:	68 28 4b 80 00       	push   $0x804b28
  8009ab:	68 ca 00 00 00       	push   $0xca
  8009b0:	68 54 48 80 00       	push   $0x804854
  8009b5:	e8 6f 0a 00 00       	call   801429 <_panic>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  8009ba:	ff 45 f0             	incl   -0x10(%ebp)
  8009bd:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8009c1:	7e c7                	jle    80098a <_main+0x952>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	eb 33                	jmp    8009fe <_main+0x9c6>
		{
			cnt++;
  8009cb:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009e2:	74 17                	je     8009fb <_main+0x9c3>
  8009e4:	83 ec 04             	sub    $0x4,%esp
  8009e7:	68 28 4b 80 00       	push   $0x804b28
  8009ec:	68 d0 00 00 00       	push   $0xd0
  8009f1:	68 54 48 80 00       	push   $0x804854
  8009f6:	e8 2e 0a 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009fb:	ff 4d f0             	decl   -0x10(%ebp)
  8009fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a01:	83 e8 63             	sub    $0x63,%eax
  800a04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a07:	7e c2                	jle    8009cb <_main+0x993>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		vcprintf("\b\b\b40%", NULL);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	68 60 4b 80 00       	push   $0x804b60
  800a13:	e8 5a 0c 00 00       	call   801672 <vcprintf>
  800a18:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate in the existing internal fragment (no additional pages are required)*/

		//Reallocate last allocation with 1 extra KB [should be placed in the existing 2 KB internal fragment]
		freeFrames = sys_calculate_free_frames() ;
  800a1b:	e8 ac 1f 00 00       	call   8029cc <sys_calculate_free_frames>
  800a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a23:	e8 44 20 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800a28:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(ptr_allocations[10], 2*Mega + 510*kilo + kilo);
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	c1 e0 08             	shl    $0x8,%eax
  800a33:	29 d0                	sub    %edx,%eax
  800a35:	89 c2                	mov    %eax,%edx
  800a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a3a:	01 d0                	add    %edx,%eax
  800a3c:	01 c0                	add    %eax,%eax
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	52                   	push   %edx
  800a4e:	50                   	push   %eax
  800a4f:	e8 f6 1d 00 00       	call   80284a <realloc>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 a0             	mov    %eax,-0x60(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800a5a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a62:	c1 e0 03             	shl    $0x3,%eax
  800a65:	05 00 00 00 80       	add    $0x80000000,%eax
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	68 68 4b 80 00       	push   $0x804b68
  800a76:	68 dc 00 00 00       	push   $0xdc
  800a7b:	68 54 48 80 00       	push   $0x804854
  800a80:	e8 a4 09 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");

		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800a85:	e8 42 1f 00 00       	call   8029cc <sys_calculate_free_frames>
  800a8a:	89 c2                	mov    %eax,%edx
  800a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8f:	39 c2                	cmp    %eax,%edx
  800a91:	74 17                	je     800aaa <_main+0xa72>
  800a93:	83 ec 04             	sub    $0x4,%esp
  800a96:	68 d8 49 80 00       	push   $0x8049d8
  800a9b:	68 df 00 00 00       	push   $0xdf
  800aa0:	68 54 48 80 00       	push   $0x804854
  800aa5:	e8 7f 09 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800aaa:	e8 bd 1f 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800aaf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 48 4a 80 00       	push   $0x804a48
  800abc:	68 e0 00 00 00       	push   $0xe0
  800ac1:	68 54 48 80 00       	push   $0x804854
  800ac6:	e8 5e 09 00 00       	call   801429 <_panic>

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;
  800acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	c1 e0 08             	shl    $0x8,%eax
  800ad3:	29 d0                	sub    %edx,%eax
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ada:	01 d0                	add    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	89 c2                	mov    %eax,%edx
  800ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ae3:	01 d0                	add    %edx,%eax
  800ae5:	c1 e8 02             	shr    $0x2,%eax
  800ae8:	48                   	dec    %eax
  800ae9:	89 45 cc             	mov    %eax,-0x34(%ebp)

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800aec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800aef:	40                   	inc    %eax
  800af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af3:	eb 17                	jmp    800b0c <_main+0xad4>
		{
			intArr[i] = i ;
  800af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b02:	01 c2                	add    %eax,%edx
  800b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b07:	89 02                	mov    %eax,(%edx)
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800b09:	ff 45 f0             	incl   -0x10(%ebp)
  800b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b0f:	83 c0 65             	add    $0x65,%eax
  800b12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b15:	7f de                	jg     800af5 <_main+0xabd>
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1d:	eb 17                	jmp    800b36 <_main+0xafe>
		{
			intArr[i] = i ;
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b2c:	01 c2                	add    %eax,%edx
  800b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b31:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b33:	ff 4d f0             	decl   -0x10(%ebp)
  800b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b39:	83 e8 63             	sub    $0x63,%eax
  800b3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b3f:	7e de                	jle    800b1f <_main+0xae7>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b48:	eb 33                	jmp    800b7d <_main+0xb45>
		{
			cnt++;
  800b4a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b5a:	01 d0                	add    %edx,%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b61:	74 17                	je     800b7a <_main+0xb42>
  800b63:	83 ec 04             	sub    $0x4,%esp
  800b66:	68 28 4b 80 00       	push   $0x804b28
  800b6b:	68 f4 00 00 00       	push   $0xf4
  800b70:	68 54 48 80 00       	push   $0x804854
  800b75:	e8 af 08 00 00       	call   801429 <_panic>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b7a:	ff 45 f0             	incl   -0x10(%ebp)
  800b7d:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800b81:	7e c7                	jle    800b4a <_main+0xb12>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800b83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b86:	48                   	dec    %eax
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	eb 33                	jmp    800bbf <_main+0xb87>
		{
			cnt++;
  800b8c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b9c:	01 d0                	add    %edx,%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ba3:	74 17                	je     800bbc <_main+0xb84>
  800ba5:	83 ec 04             	sub    $0x4,%esp
  800ba8:	68 28 4b 80 00       	push   $0x804b28
  800bad:	68 f9 00 00 00       	push   $0xf9
  800bb2:	68 54 48 80 00       	push   $0x804854
  800bb7:	e8 6d 08 00 00       	call   801429 <_panic>
		for (i=0; i < 100 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800bbc:	ff 4d f0             	decl   -0x10(%ebp)
  800bbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc2:	83 e8 63             	sub    $0x63,%eax
  800bc5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bc8:	7e c2                	jle    800b8c <_main+0xb54>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800bca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bcd:	40                   	inc    %eax
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	eb 33                	jmp    800c06 <_main+0xbce>
		{
			cnt++;
  800bd3:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800be3:	01 d0                	add    %edx,%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bea:	74 17                	je     800c03 <_main+0xbcb>
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	68 28 4b 80 00       	push   $0x804b28
  800bf4:	68 fe 00 00 00       	push   $0xfe
  800bf9:	68 54 48 80 00       	push   $0x804854
  800bfe:	e8 26 08 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800c03:	ff 45 f0             	incl   -0x10(%ebp)
  800c06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c09:	83 c0 65             	add    $0x65,%eax
  800c0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c0f:	7f c2                	jg     800bd3 <_main+0xb9b>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	eb 33                	jmp    800c4c <_main+0xc14>
		{
			cnt++;
  800c19:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c29:	01 d0                	add    %edx,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c30:	74 17                	je     800c49 <_main+0xc11>
  800c32:	83 ec 04             	sub    $0x4,%esp
  800c35:	68 28 4b 80 00       	push   $0x804b28
  800c3a:	68 03 01 00 00       	push   $0x103
  800c3f:	68 54 48 80 00       	push   $0x804854
  800c44:	e8 e0 07 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c49:	ff 4d f0             	decl   -0x10(%ebp)
  800c4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c4f:	83 e8 63             	sub    $0x63,%eax
  800c52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c55:	7e c2                	jle    800c19 <_main+0xbe1>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800c57:	e8 70 1d 00 00       	call   8029cc <sys_calculate_free_frames>
  800c5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c5f:	e8 08 1e 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800c64:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[10]);
  800c67:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	e8 6d 1a 00 00       	call   8026e0 <free>
  800c73:	83 c4 10             	add    $0x10,%esp

		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800c76:	e8 f1 1d 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800c7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c7e:	29 c2                	sub    %eax,%edx
  800c80:	89 d0                	mov    %edx,%eax
  800c82:	3d 80 02 00 00       	cmp    $0x280,%eax
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 9c 4b 80 00       	push   $0x804b9c
  800c91:	68 0d 01 00 00       	push   $0x10d
  800c96:	68 54 48 80 00       	push   $0x804854
  800c9b:	e8 89 07 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800ca0:	e8 27 1d 00 00       	call   8029cc <sys_calculate_free_frames>
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800caa:	29 c2                	sub    %eax,%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	83 f8 03             	cmp    $0x3,%eax
  800cb1:	74 17                	je     800cca <_main+0xc92>
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	68 f0 4b 80 00       	push   $0x804bf0
  800cbb:	68 0e 01 00 00       	push   $0x10e
  800cc0:	68 54 48 80 00       	push   $0x804854
  800cc5:	e8 5f 07 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b60%", NULL);
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	6a 00                	push   $0x0
  800ccf:	68 54 4c 80 00       	push   $0x804c54
  800cd4:	e8 99 09 00 00       	call   801672 <vcprintf>
  800cd9:	83 c4 10             	add    $0x10,%esp

		/*CASE4: Re-allocate that can NOT fit in any free fragment*/

		//Fill 3rd allocation with data
		intArr = (int*) ptr_allocations[2];
  800cdc:	8b 45 80             	mov    -0x80(%ebp),%eax
  800cdf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ce5:	c1 e8 02             	shr    $0x2,%eax
  800ce8:	48                   	dec    %eax
  800ce9:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  800cec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800cf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cfa:	eb 17                	jmp    800d13 <_main+0xcdb>
		{
			intArr[i] = i ;
  800cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d09:	01 c2                	add    %eax,%edx
  800d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0e:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800d10:	ff 45 f0             	incl   -0x10(%ebp)
  800d13:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800d17:	7e e3                	jle    800cfc <_main+0xcc4>
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d1f:	eb 17                	jmp    800d38 <_main+0xd00>
		{
			intArr[i] = i;
  800d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d2e:	01 c2                	add    %eax,%edx
  800d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d33:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d35:	ff 4d ec             	decl   -0x14(%ebp)
  800d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d3b:	83 e8 64             	sub    $0x64,%eax
  800d3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d41:	7c de                	jl     800d21 <_main+0xce9>
		{
			intArr[i] = i;
		}

		//Reallocate it to large size that can't be fit in any free segment
		freeFrames = sys_calculate_free_frames() ;
  800d43:	e8 84 1c 00 00       	call   8029cc <sys_calculate_free_frames>
  800d48:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d4b:	e8 1c 1d 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800d50:	89 45 dc             	mov    %eax,-0x24(%ebp)
		void* origAddress = ptr_allocations[2];
  800d53:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d56:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = realloc(ptr_allocations[2], (USER_HEAP_MAX - USER_HEAP_START - 13*Mega));
  800d59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d5c:	89 d0                	mov    %edx,%eax
  800d5e:	01 c0                	add    %eax,%eax
  800d60:	01 d0                	add    %edx,%eax
  800d62:	c1 e0 02             	shl    $0x2,%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	f7 d8                	neg    %eax
  800d69:	8d 90 00 00 00 20    	lea    0x20000000(%eax),%edx
  800d6f:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	52                   	push   %edx
  800d76:	50                   	push   %eax
  800d77:	e8 ce 1a 00 00       	call   80284a <realloc>
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	89 45 80             	mov    %eax,-0x80(%ebp)

		//cprintf("%x\n", ptr_allocations[2]);
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[2] != 0) panic("Wrong start address for the re-allocated space... ");
  800d82:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d85:	85 c0                	test   %eax,%eax
  800d87:	74 17                	je     800da0 <_main+0xd68>
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	68 68 4b 80 00       	push   $0x804b68
  800d91:	68 2d 01 00 00       	push   $0x12d
  800d96:	68 54 48 80 00       	push   $0x804854
  800d9b:	e8 89 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800da0:	e8 27 1c 00 00       	call   8029cc <sys_calculate_free_frames>
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800daa:	39 c2                	cmp    %eax,%edx
  800dac:	74 17                	je     800dc5 <_main+0xd8d>
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	68 d8 49 80 00       	push   $0x8049d8
  800db6:	68 2f 01 00 00       	push   $0x12f
  800dbb:	68 54 48 80 00       	push   $0x804854
  800dc0:	e8 64 06 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800dc5:	e8 a2 1c 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800dca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dcd:	74 17                	je     800de6 <_main+0xdae>
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	68 48 4a 80 00       	push   $0x804a48
  800dd7:	68 30 01 00 00       	push   $0x130
  800ddc:	68 54 48 80 00       	push   $0x804854
  800de1:	e8 43 06 00 00       	call   801429 <_panic>

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800de6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ded:	eb 33                	jmp    800e22 <_main+0xdea>
		{
			cnt++;
  800def:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dff:	01 d0                	add    %edx,%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e06:	74 17                	je     800e1f <_main+0xde7>
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	68 28 4b 80 00       	push   $0x804b28
  800e10:	68 36 01 00 00       	push   $0x136
  800e15:	68 54 48 80 00       	push   $0x804854
  800e1a:	e8 0a 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800e1f:	ff 45 f0             	incl   -0x10(%ebp)
  800e22:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800e26:	7e c7                	jle    800def <_main+0xdb7>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2e:	eb 33                	jmp    800e63 <_main+0xe2b>
		{
			cnt++;
  800e30:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e47:	74 17                	je     800e60 <_main+0xe28>
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	68 28 4b 80 00       	push   $0x804b28
  800e51:	68 3c 01 00 00       	push   $0x13c
  800e56:	68 54 48 80 00       	push   $0x804854
  800e5b:	e8 c9 05 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e60:	ff 4d f0             	decl   -0x10(%ebp)
  800e63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e66:	83 e8 64             	sub    $0x64,%eax
  800e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6c:	7c c2                	jl     800e30 <_main+0xdf8>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after FAILURE expansion
		freeFrames = sys_calculate_free_frames() ;
  800e6e:	e8 59 1b 00 00       	call   8029cc <sys_calculate_free_frames>
  800e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e76:	e8 f1 1b 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800e7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(origAddress);
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	ff 75 c8             	pushl  -0x38(%ebp)
  800e84:	e8 57 18 00 00       	call   8026e0 <free>
  800e89:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e8c:	e8 db 1b 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800e94:	29 c2                	sub    %eax,%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	3d 00 01 00 00       	cmp    $0x100,%eax
  800e9d:	74 17                	je     800eb6 <_main+0xe7e>
  800e9f:	83 ec 04             	sub    $0x4,%esp
  800ea2:	68 9c 4b 80 00       	push   $0x804b9c
  800ea7:	68 44 01 00 00       	push   $0x144
  800eac:	68 54 48 80 00       	push   $0x804854
  800eb1:	e8 73 05 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800eb6:	e8 11 1b 00 00       	call   8029cc <sys_calculate_free_frames>
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	83 f8 03             	cmp    $0x3,%eax
  800ec7:	74 17                	je     800ee0 <_main+0xea8>
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	68 f0 4b 80 00       	push   $0x804bf0
  800ed1:	68 45 01 00 00       	push   $0x145
  800ed6:	68 54 48 80 00       	push   $0x804854
  800edb:	e8 49 05 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b80%", NULL);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	6a 00                	push   $0x0
  800ee5:	68 5b 4c 80 00       	push   $0x804c5b
  800eea:	e8 83 07 00 00       	call   801672 <vcprintf>
  800eef:	83 c4 10             	add    $0x10,%esp
		/*CASE5: Re-allocate that test FIRST FIT strategy*/

		//[1] create 4 MB hole at beginning of the heap

		//Take 2 MB from currently 3 MB hole at beginning of the heap
		freeFrames = sys_calculate_free_frames() ;
  800ef2:	e8 d5 1a 00 00       	call   8029cc <sys_calculate_free_frames>
  800ef7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800efa:	e8 6d 1b 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800eff:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(2*Mega-kilo);
  800f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f05:	01 c0                	add    %eax,%eax
  800f07:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	e8 52 17 00 00       	call   802665 <malloc>
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800f19:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800f1c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800f21:	74 17                	je     800f3a <_main+0xf02>
  800f23:	83 ec 04             	sub    $0x4,%esp
  800f26:	68 24 48 80 00       	push   $0x804824
  800f2b:	68 51 01 00 00       	push   $0x151
  800f30:	68 54 48 80 00       	push   $0x804854
  800f35:	e8 ef 04 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800f3a:	e8 8d 1a 00 00       	call   8029cc <sys_calculate_free_frames>
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	39 c2                	cmp    %eax,%edx
  800f46:	74 17                	je     800f5f <_main+0xf27>
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	68 6c 48 80 00       	push   $0x80486c
  800f50:	68 53 01 00 00       	push   $0x153
  800f55:	68 54 48 80 00       	push   $0x804854
  800f5a:	e8 ca 04 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800f5f:	e8 08 1b 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800f64:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800f67:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f6c:	74 17                	je     800f85 <_main+0xf4d>
  800f6e:	83 ec 04             	sub    $0x4,%esp
  800f71:	68 d8 48 80 00       	push   $0x8048d8
  800f76:	68 54 01 00 00       	push   $0x154
  800f7b:	68 54 48 80 00       	push   $0x804854
  800f80:	e8 a4 04 00 00       	call   801429 <_panic>

		//remove 1 MB allocation between 1 MB hole and 2 MB hole to create 4 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f85:	e8 42 1a 00 00       	call   8029cc <sys_calculate_free_frames>
  800f8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8d:	e8 da 1a 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800f92:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800f95:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	e8 3f 17 00 00       	call   8026e0 <free>
  800fa1:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fa4:	e8 c3 1a 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  800fa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	3d 00 01 00 00       	cmp    $0x100,%eax
  800fb5:	74 17                	je     800fce <_main+0xf96>
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	68 08 49 80 00       	push   $0x804908
  800fbf:	68 5b 01 00 00       	push   $0x15b
  800fc4:	68 54 48 80 00       	push   $0x804854
  800fc9:	e8 5b 04 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fce:	e8 f9 19 00 00       	call   8029cc <sys_calculate_free_frames>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd8:	39 c2                	cmp    %eax,%edx
  800fda:	74 17                	je     800ff3 <_main+0xfbb>
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 44 49 80 00       	push   $0x804944
  800fe4:	68 5c 01 00 00       	push   $0x15c
  800fe9:	68 54 48 80 00       	push   $0x804854
  800fee:	e8 36 04 00 00       	call   801429 <_panic>
		{
			//allocate 1 page after each 3 MB
			sys_allocateMem(i, PAGE_SIZE) ;
		}*/

		malloc(5*Mega-kilo);
  800ff3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ff6:	89 d0                	mov    %edx,%eax
  800ff8:	c1 e0 02             	shl    $0x2,%eax
  800ffb:	01 d0                	add    %edx,%eax
  800ffd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	50                   	push   %eax
  801004:	e8 5c 16 00 00       	call   802665 <malloc>
  801009:	83 c4 10             	add    $0x10,%esp

		//Fill last 3MB allocation with data
		intArr = (int*) ptr_allocations[7];
  80100c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80100f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;
  801012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801015:	89 c2                	mov    %eax,%edx
  801017:	01 d2                	add    %edx,%edx
  801019:	01 d0                	add    %edx,%eax
  80101b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80101e:	c1 e8 02             	shr    $0x2,%eax
  801021:	48                   	dec    %eax
  801022:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  801025:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  80102c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801033:	eb 17                	jmp    80104c <_main+0x1014>
		{
			intArr[i] = i ;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801042:	01 c2                	add    %eax,%edx
  801044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801047:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[7];
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  801049:	ff 45 f0             	incl   -0x10(%ebp)
  80104c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  801050:	7e e3                	jle    801035 <_main+0xffd>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801052:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801055:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801058:	eb 17                	jmp    801071 <_main+0x1039>
		{
			intArr[i] = i;
  80105a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801064:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801067:	01 c2                	add    %eax,%edx
  801069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106c:	89 02                	mov    %eax,(%edx)
		for (i=0; i < 100 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  80106e:	ff 4d f0             	decl   -0x10(%ebp)
  801071:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801074:	83 e8 64             	sub    $0x64,%eax
  801077:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80107a:	7c de                	jl     80105a <_main+0x1022>
		{
			intArr[i] = i;
		}

		//Reallocate it to 4 MB, so that it can only fit at the 1st fragment
		freeFrames = sys_calculate_free_frames() ;
  80107c:	e8 4b 19 00 00       	call   8029cc <sys_calculate_free_frames>
  801081:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801084:	e8 e3 19 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  801089:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = realloc(ptr_allocations[7], 4*Mega-kilo);
  80108c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80108f:	c1 e0 02             	shl    $0x2,%eax
  801092:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	52                   	push   %edx
  80109e:	50                   	push   %eax
  80109f:	e8 a6 17 00 00       	call   80284a <realloc>
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	89 45 94             	mov    %eax,-0x6c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the re-allocated space... ");
  8010aa:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b2:	01 c0                	add    %eax,%eax
  8010b4:	05 00 00 00 80       	add    $0x80000000,%eax
  8010b9:	39 c2                	cmp    %eax,%edx
  8010bb:	74 17                	je     8010d4 <_main+0x109c>
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	68 68 4b 80 00       	push   $0x804b68
  8010c5:	68 7d 01 00 00       	push   $0x17d
  8010ca:	68 54 48 80 00       	push   $0x804854
  8010cf:	e8 55 03 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 - 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 2) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8010d4:	e8 93 19 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  8010d9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8010dc:	3d 00 01 00 00       	cmp    $0x100,%eax
  8010e1:	74 17                	je     8010fa <_main+0x10c2>
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	68 48 4a 80 00       	push   $0x804a48
  8010eb:	68 80 01 00 00       	push   $0x180
  8010f0:	68 54 48 80 00       	push   $0x804854
  8010f5:	e8 2f 03 00 00       	call   801429 <_panic>


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
  8010fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010fd:	c1 e0 02             	shl    $0x2,%eax
  801100:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801103:	c1 e8 02             	shr    $0x2,%eax
  801106:	48                   	dec    %eax
  801107:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[7];
  80110a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80110d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801110:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801113:	40                   	inc    %eax
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801117:	eb 17                	jmp    801130 <_main+0x10f8>
		{
			intArr[i] = i ;
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801123:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801126:	01 c2                	add    %eax,%edx
  801128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112b:	89 02                	mov    %eax,(%edx)


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[7];
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  80112d:	ff 45 f0             	incl   -0x10(%ebp)
  801130:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801133:	83 c0 65             	add    $0x65,%eax
  801136:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801139:	7f de                	jg     801119 <_main+0x10e1>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80113b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80113e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801141:	eb 17                	jmp    80115a <_main+0x1122>
		{
			intArr[i] = i;
  801143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801150:	01 c2                	add    %eax,%edx
  801152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801155:	89 02                	mov    %eax,(%edx)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801157:	ff 4d f0             	decl   -0x10(%ebp)
  80115a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80115d:	83 e8 64             	sub    $0x64,%eax
  801160:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801163:	7c de                	jl     801143 <_main+0x110b>
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  801165:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80116c:	eb 33                	jmp    8011a1 <_main+0x1169>
		{
			cnt++;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  801171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801185:	74 17                	je     80119e <_main+0x1166>
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	68 28 4b 80 00       	push   $0x804b28
  80118f:	68 93 01 00 00       	push   $0x193
  801194:	68 54 48 80 00       	push   $0x804854
  801199:	e8 8b 02 00 00       	call   801429 <_panic>
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  80119e:	ff 45 f0             	incl   -0x10(%ebp)
  8011a1:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8011a5:	7e c7                	jle    80116e <_main+0x1136>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ad:	eb 33                	jmp    8011e2 <_main+0x11aa>
		{
			cnt++;
  8011af:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011bf:	01 d0                	add    %edx,%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c6:	74 17                	je     8011df <_main+0x11a7>
  8011c8:	83 ec 04             	sub    $0x4,%esp
  8011cb:	68 28 4b 80 00       	push   $0x804b28
  8011d0:	68 99 01 00 00       	push   $0x199
  8011d5:	68 54 48 80 00       	push   $0x804854
  8011da:	e8 4a 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011df:	ff 4d f0             	decl   -0x10(%ebp)
  8011e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011e5:	83 e8 64             	sub    $0x64,%eax
  8011e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011eb:	7c c2                	jl     8011af <_main+0x1177>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  8011ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011f0:	40                   	inc    %eax
  8011f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f4:	eb 33                	jmp    801229 <_main+0x11f1>
		{
			cnt++;
  8011f6:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801206:	01 d0                	add    %edx,%eax
  801208:	8b 00                	mov    (%eax),%eax
  80120a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120d:	74 17                	je     801226 <_main+0x11ee>
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	68 28 4b 80 00       	push   $0x804b28
  801217:	68 9f 01 00 00       	push   $0x19f
  80121c:	68 54 48 80 00       	push   $0x804854
  801221:	e8 03 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801226:	ff 45 f0             	incl   -0x10(%ebp)
  801229:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80122c:	83 c0 65             	add    $0x65,%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7f c2                	jg     8011f6 <_main+0x11be>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801234:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123a:	eb 33                	jmp    80126f <_main+0x1237>
		{
			cnt++;
  80123c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801249:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80124c:	01 d0                	add    %edx,%eax
  80124e:	8b 00                	mov    (%eax),%eax
  801250:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801253:	74 17                	je     80126c <_main+0x1234>
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	68 28 4b 80 00       	push   $0x804b28
  80125d:	68 a5 01 00 00       	push   $0x1a5
  801262:	68 54 48 80 00       	push   $0x804854
  801267:	e8 bd 01 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80126c:	ff 4d f0             	decl   -0x10(%ebp)
  80126f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801272:	83 e8 64             	sub    $0x64,%eax
  801275:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801278:	7c c2                	jl     80123c <_main+0x1204>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  80127a:	e8 4d 17 00 00       	call   8029cc <sys_calculate_free_frames>
  80127f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801282:	e8 e5 17 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  801287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[7]);
  80128a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 4a 14 00 00       	call   8026e0 <free>
  801296:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  801299:	e8 ce 17 00 00       	call   802a6c <sys_pf_calculate_allocated_pages>
  80129e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012a1:	29 c2                	sub    %eax,%edx
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012aa:	74 17                	je     8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 9c 4b 80 00       	push   $0x804b9c
  8012b4:	68 ad 01 00 00       	push   $0x1ad
  8012b9:	68 54 48 80 00       	push   $0x804854
  8012be:	e8 66 01 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	6a 00                	push   $0x0
  8012c8:	68 62 4c 80 00       	push   $0x804c62
  8012cd:	e8 a0 03 00 00       	call   801672 <vcprintf>
  8012d2:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [2] completed successfully.\n");
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	68 6c 4c 80 00       	push   $0x804c6c
  8012dd:	e8 fb 03 00 00       	call   8016dd <cprintf>
  8012e2:	83 c4 10             	add    $0x10,%esp

	return;
  8012e5:	90                   	nop
}
  8012e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5f                   	pop    %edi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8012f3:	e8 b4 19 00 00       	call   802cac <sys_getenvindex>
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8012fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	c1 e0 03             	shl    $0x3,%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	01 c0                	add    %eax,%eax
  801307:	01 d0                	add    %edx,%eax
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	01 d0                	add    %edx,%eax
  801312:	c1 e0 04             	shl    $0x4,%eax
  801315:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80131a:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80131f:	a1 20 60 80 00       	mov    0x806020,%eax
  801324:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80132a:	84 c0                	test   %al,%al
  80132c:	74 0f                	je     80133d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80132e:	a1 20 60 80 00       	mov    0x806020,%eax
  801333:	05 5c 05 00 00       	add    $0x55c,%eax
  801338:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80133d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801341:	7e 0a                	jle    80134d <libmain+0x60>
		binaryname = argv[0];
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	ff 75 08             	pushl  0x8(%ebp)
  801356:	e8 dd ec ff ff       	call   800038 <_main>
  80135b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80135e:	e8 56 17 00 00       	call   802ab9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	68 c0 4c 80 00       	push   $0x804cc0
  80136b:	e8 6d 03 00 00       	call   8016dd <cprintf>
  801370:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801373:	a1 20 60 80 00       	mov    0x806020,%eax
  801378:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80137e:	a1 20 60 80 00       	mov    0x806020,%eax
  801383:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	52                   	push   %edx
  80138d:	50                   	push   %eax
  80138e:	68 e8 4c 80 00       	push   $0x804ce8
  801393:	e8 45 03 00 00       	call   8016dd <cprintf>
  801398:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80139b:	a1 20 60 80 00       	mov    0x806020,%eax
  8013a0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8013a6:	a1 20 60 80 00       	mov    0x806020,%eax
  8013ab:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8013b1:	a1 20 60 80 00       	mov    0x806020,%eax
  8013b6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8013bc:	51                   	push   %ecx
  8013bd:	52                   	push   %edx
  8013be:	50                   	push   %eax
  8013bf:	68 10 4d 80 00       	push   $0x804d10
  8013c4:	e8 14 03 00 00       	call   8016dd <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8013cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8013d1:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	50                   	push   %eax
  8013db:	68 68 4d 80 00       	push   $0x804d68
  8013e0:	e8 f8 02 00 00       	call   8016dd <cprintf>
  8013e5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	68 c0 4c 80 00       	push   $0x804cc0
  8013f0:	e8 e8 02 00 00       	call   8016dd <cprintf>
  8013f5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8013f8:	e8 d6 16 00 00       	call   802ad3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8013fd:	e8 19 00 00 00       	call   80141b <exit>
}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	6a 00                	push   $0x0
  801410:	e8 63 18 00 00       	call   802c78 <sys_destroy_env>
  801415:	83 c4 10             	add    $0x10,%esp
}
  801418:	90                   	nop
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <exit>:

void
exit(void)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801421:	e8 b8 18 00 00       	call   802cde <sys_exit_env>
}
  801426:	90                   	nop
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80142f:	8d 45 10             	lea    0x10(%ebp),%eax
  801432:	83 c0 04             	add    $0x4,%eax
  801435:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801438:	a1 5c 61 80 00       	mov    0x80615c,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 16                	je     801457 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801441:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	50                   	push   %eax
  80144a:	68 7c 4d 80 00       	push   $0x804d7c
  80144f:	e8 89 02 00 00       	call   8016dd <cprintf>
  801454:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801457:	a1 00 60 80 00       	mov    0x806000,%eax
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	ff 75 08             	pushl  0x8(%ebp)
  801462:	50                   	push   %eax
  801463:	68 81 4d 80 00       	push   $0x804d81
  801468:	e8 70 02 00 00       	call   8016dd <cprintf>
  80146d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	ff 75 f4             	pushl  -0xc(%ebp)
  801479:	50                   	push   %eax
  80147a:	e8 f3 01 00 00       	call   801672 <vcprintf>
  80147f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	6a 00                	push   $0x0
  801487:	68 9d 4d 80 00       	push   $0x804d9d
  80148c:	e8 e1 01 00 00       	call   801672 <vcprintf>
  801491:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801494:	e8 82 ff ff ff       	call   80141b <exit>

	// should not return here
	while (1) ;
  801499:	eb fe                	jmp    801499 <_panic+0x70>

0080149b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8014a1:	a1 20 60 80 00       	mov    0x806020,%eax
  8014a6:	8b 50 74             	mov    0x74(%eax),%edx
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	39 c2                	cmp    %eax,%edx
  8014ae:	74 14                	je     8014c4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	68 a0 4d 80 00       	push   $0x804da0
  8014b8:	6a 26                	push   $0x26
  8014ba:	68 ec 4d 80 00       	push   $0x804dec
  8014bf:	e8 65 ff ff ff       	call   801429 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8014c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8014cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014d2:	e9 c2 00 00 00       	jmp    801599 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	75 08                	jne    8014f4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8014ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8014ef:	e9 a2 00 00 00       	jmp    801596 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8014f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8014fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801502:	eb 69                	jmp    80156d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801504:	a1 20 60 80 00       	mov    0x806020,%eax
  801509:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80150f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	01 c0                	add    %eax,%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	c1 e0 03             	shl    $0x3,%eax
  80151b:	01 c8                	add    %ecx,%eax
  80151d:	8a 40 04             	mov    0x4(%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	75 46                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801524:	a1 20 60 80 00       	mov    0x806020,%eax
  801529:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80152f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801532:	89 d0                	mov    %edx,%eax
  801534:	01 c0                	add    %eax,%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	c1 e0 03             	shl    $0x3,%eax
  80153b:	01 c8                	add    %ecx,%eax
  80153d:	8b 00                	mov    (%eax),%eax
  80153f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801542:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801545:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80154c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	01 c8                	add    %ecx,%eax
  80155b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80155d:	39 c2                	cmp    %eax,%edx
  80155f:	75 09                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801561:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801568:	eb 12                	jmp    80157c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80156a:	ff 45 e8             	incl   -0x18(%ebp)
  80156d:	a1 20 60 80 00       	mov    0x806020,%eax
  801572:	8b 50 74             	mov    0x74(%eax),%edx
  801575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801578:	39 c2                	cmp    %eax,%edx
  80157a:	77 88                	ja     801504 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80157c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801580:	75 14                	jne    801596 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 f8 4d 80 00       	push   $0x804df8
  80158a:	6a 3a                	push   $0x3a
  80158c:	68 ec 4d 80 00       	push   $0x804dec
  801591:	e8 93 fe ff ff       	call   801429 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801596:	ff 45 f0             	incl   -0x10(%ebp)
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80159f:	0f 8c 32 ff ff ff    	jl     8014d7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8015a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015b3:	eb 26                	jmp    8015db <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8015b5:	a1 20 60 80 00       	mov    0x806020,%eax
  8015ba:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8015c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015c3:	89 d0                	mov    %edx,%eax
  8015c5:	01 c0                	add    %eax,%eax
  8015c7:	01 d0                	add    %edx,%eax
  8015c9:	c1 e0 03             	shl    $0x3,%eax
  8015cc:	01 c8                	add    %ecx,%eax
  8015ce:	8a 40 04             	mov    0x4(%eax),%al
  8015d1:	3c 01                	cmp    $0x1,%al
  8015d3:	75 03                	jne    8015d8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8015d5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015d8:	ff 45 e0             	incl   -0x20(%ebp)
  8015db:	a1 20 60 80 00       	mov    0x806020,%eax
  8015e0:	8b 50 74             	mov    0x74(%eax),%edx
  8015e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e6:	39 c2                	cmp    %eax,%edx
  8015e8:	77 cb                	ja     8015b5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8015ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015f0:	74 14                	je     801606 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 4c 4e 80 00       	push   $0x804e4c
  8015fa:	6a 44                	push   $0x44
  8015fc:	68 ec 4d 80 00       	push   $0x804dec
  801601:	e8 23 fe ff ff       	call   801429 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801606:	90                   	nop
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	8b 00                	mov    (%eax),%eax
  801614:	8d 48 01             	lea    0x1(%eax),%ecx
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	89 0a                	mov    %ecx,(%edx)
  80161c:	8b 55 08             	mov    0x8(%ebp),%edx
  80161f:	88 d1                	mov    %dl,%cl
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	8b 00                	mov    (%eax),%eax
  80162d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801632:	75 2c                	jne    801660 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801634:	a0 24 60 80 00       	mov    0x806024,%al
  801639:	0f b6 c0             	movzbl %al,%eax
  80163c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163f:	8b 12                	mov    (%edx),%edx
  801641:	89 d1                	mov    %edx,%ecx
  801643:	8b 55 0c             	mov    0xc(%ebp),%edx
  801646:	83 c2 08             	add    $0x8,%edx
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	50                   	push   %eax
  80164d:	51                   	push   %ecx
  80164e:	52                   	push   %edx
  80164f:	e8 b7 12 00 00       	call   80290b <sys_cputs>
  801654:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801660:	8b 45 0c             	mov    0xc(%ebp),%eax
  801663:	8b 40 04             	mov    0x4(%eax),%eax
  801666:	8d 50 01             	lea    0x1(%eax),%edx
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80166f:	90                   	nop
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80167b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801682:	00 00 00 
	b.cnt = 0;
  801685:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80168c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	68 09 16 80 00       	push   $0x801609
  8016a1:	e8 11 02 00 00       	call   8018b7 <vprintfmt>
  8016a6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8016a9:	a0 24 60 80 00       	mov    0x806024,%al
  8016ae:	0f b6 c0             	movzbl %al,%eax
  8016b1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	50                   	push   %eax
  8016bb:	52                   	push   %edx
  8016bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016c2:	83 c0 08             	add    $0x8,%eax
  8016c5:	50                   	push   %eax
  8016c6:	e8 40 12 00 00       	call   80290b <sys_cputs>
  8016cb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8016ce:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  8016d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <cprintf>:

int cprintf(const char *fmt, ...) {
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8016e3:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  8016ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8016ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	83 ec 08             	sub    $0x8,%esp
  8016f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	e8 73 ff ff ff       	call   801672 <vcprintf>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801710:	e8 a4 13 00 00       	call   802ab9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801715:	8d 45 0c             	lea    0xc(%ebp),%eax
  801718:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	83 ec 08             	sub    $0x8,%esp
  801721:	ff 75 f4             	pushl  -0xc(%ebp)
  801724:	50                   	push   %eax
  801725:	e8 48 ff ff ff       	call   801672 <vcprintf>
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801730:	e8 9e 13 00 00       	call   802ad3 <sys_enable_interrupt>
	return cnt;
  801735:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	53                   	push   %ebx
  80173e:	83 ec 14             	sub    $0x14,%esp
  801741:	8b 45 10             	mov    0x10(%ebp),%eax
  801744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801747:	8b 45 14             	mov    0x14(%ebp),%eax
  80174a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80174d:	8b 45 18             	mov    0x18(%ebp),%eax
  801750:	ba 00 00 00 00       	mov    $0x0,%edx
  801755:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801758:	77 55                	ja     8017af <printnum+0x75>
  80175a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80175d:	72 05                	jb     801764 <printnum+0x2a>
  80175f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801762:	77 4b                	ja     8017af <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801764:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801767:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80176a:	8b 45 18             	mov    0x18(%ebp),%eax
  80176d:	ba 00 00 00 00       	mov    $0x0,%edx
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	ff 75 f4             	pushl  -0xc(%ebp)
  801777:	ff 75 f0             	pushl  -0x10(%ebp)
  80177a:	e8 11 2e 00 00       	call   804590 <__udivdi3>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	ff 75 20             	pushl  0x20(%ebp)
  801788:	53                   	push   %ebx
  801789:	ff 75 18             	pushl  0x18(%ebp)
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	e8 a1 ff ff ff       	call   80173a <printnum>
  801799:	83 c4 20             	add    $0x20,%esp
  80179c:	eb 1a                	jmp    8017b8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80179e:	83 ec 08             	sub    $0x8,%esp
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 20             	pushl  0x20(%ebp)
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	ff d0                	call   *%eax
  8017ac:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8017af:	ff 4d 1c             	decl   0x1c(%ebp)
  8017b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8017b6:	7f e6                	jg     80179e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017b8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8017bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	53                   	push   %ebx
  8017c7:	51                   	push   %ecx
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	e8 d1 2e 00 00       	call   8046a0 <__umoddi3>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	05 b4 50 80 00       	add    $0x8050b4,%eax
  8017d7:	8a 00                	mov    (%eax),%al
  8017d9:	0f be c0             	movsbl %al,%eax
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	50                   	push   %eax
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	ff d0                	call   *%eax
  8017e8:	83 c4 10             	add    $0x10,%esp
}
  8017eb:	90                   	nop
  8017ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8017f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8017f8:	7e 1c                	jle    801816 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 00                	mov    (%eax),%eax
  8017ff:	8d 50 08             	lea    0x8(%eax),%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	89 10                	mov    %edx,(%eax)
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	83 e8 08             	sub    $0x8,%eax
  80180f:	8b 50 04             	mov    0x4(%eax),%edx
  801812:	8b 00                	mov    (%eax),%eax
  801814:	eb 40                	jmp    801856 <getuint+0x65>
	else if (lflag)
  801816:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80181a:	74 1e                	je     80183a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8b 00                	mov    (%eax),%eax
  801821:	8d 50 04             	lea    0x4(%eax),%edx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	89 10                	mov    %edx,(%eax)
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8b 00                	mov    (%eax),%eax
  80182e:	83 e8 04             	sub    $0x4,%eax
  801831:	8b 00                	mov    (%eax),%eax
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
  801838:	eb 1c                	jmp    801856 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	8b 00                	mov    (%eax),%eax
  80183f:	8d 50 04             	lea    0x4(%eax),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	89 10                	mov    %edx,(%eax)
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 00                	mov    (%eax),%eax
  80184c:	83 e8 04             	sub    $0x4,%eax
  80184f:	8b 00                	mov    (%eax),%eax
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    

00801858 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80185b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80185f:	7e 1c                	jle    80187d <getint+0x25>
		return va_arg(*ap, long long);
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	8b 00                	mov    (%eax),%eax
  801866:	8d 50 08             	lea    0x8(%eax),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	89 10                	mov    %edx,(%eax)
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8b 00                	mov    (%eax),%eax
  801873:	83 e8 08             	sub    $0x8,%eax
  801876:	8b 50 04             	mov    0x4(%eax),%edx
  801879:	8b 00                	mov    (%eax),%eax
  80187b:	eb 38                	jmp    8018b5 <getint+0x5d>
	else if (lflag)
  80187d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801881:	74 1a                	je     80189d <getint+0x45>
		return va_arg(*ap, long);
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8b 00                	mov    (%eax),%eax
  801888:	8d 50 04             	lea    0x4(%eax),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	89 10                	mov    %edx,(%eax)
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	8b 00                	mov    (%eax),%eax
  801895:	83 e8 04             	sub    $0x4,%eax
  801898:	8b 00                	mov    (%eax),%eax
  80189a:	99                   	cltd   
  80189b:	eb 18                	jmp    8018b5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8b 00                	mov    (%eax),%eax
  8018a2:	8d 50 04             	lea    0x4(%eax),%edx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	89 10                	mov    %edx,(%eax)
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8b 00                	mov    (%eax),%eax
  8018af:	83 e8 04             	sub    $0x4,%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	99                   	cltd   
}
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
  8018bc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018bf:	eb 17                	jmp    8018d8 <vprintfmt+0x21>
			if (ch == '\0')
  8018c1:	85 db                	test   %ebx,%ebx
  8018c3:	0f 84 af 03 00 00    	je     801c78 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	53                   	push   %ebx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	ff d0                	call   *%eax
  8018d5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	8d 50 01             	lea    0x1(%eax),%edx
  8018de:	89 55 10             	mov    %edx,0x10(%ebp)
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	0f b6 d8             	movzbl %al,%ebx
  8018e6:	83 fb 25             	cmp    $0x25,%ebx
  8018e9:	75 d6                	jne    8018c1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8018eb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8018ef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8018f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8018fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801904:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80190b:	8b 45 10             	mov    0x10(%ebp),%eax
  80190e:	8d 50 01             	lea    0x1(%eax),%edx
  801911:	89 55 10             	mov    %edx,0x10(%ebp)
  801914:	8a 00                	mov    (%eax),%al
  801916:	0f b6 d8             	movzbl %al,%ebx
  801919:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80191c:	83 f8 55             	cmp    $0x55,%eax
  80191f:	0f 87 2b 03 00 00    	ja     801c50 <vprintfmt+0x399>
  801925:	8b 04 85 d8 50 80 00 	mov    0x8050d8(,%eax,4),%eax
  80192c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80192e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801932:	eb d7                	jmp    80190b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801934:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801938:	eb d1                	jmp    80190b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80193a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801941:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801944:	89 d0                	mov    %edx,%eax
  801946:	c1 e0 02             	shl    $0x2,%eax
  801949:	01 d0                	add    %edx,%eax
  80194b:	01 c0                	add    %eax,%eax
  80194d:	01 d8                	add    %ebx,%eax
  80194f:	83 e8 30             	sub    $0x30,%eax
  801952:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	8a 00                	mov    (%eax),%al
  80195a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80195d:	83 fb 2f             	cmp    $0x2f,%ebx
  801960:	7e 3e                	jle    8019a0 <vprintfmt+0xe9>
  801962:	83 fb 39             	cmp    $0x39,%ebx
  801965:	7f 39                	jg     8019a0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801967:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80196a:	eb d5                	jmp    801941 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80196c:	8b 45 14             	mov    0x14(%ebp),%eax
  80196f:	83 c0 04             	add    $0x4,%eax
  801972:	89 45 14             	mov    %eax,0x14(%ebp)
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	83 e8 04             	sub    $0x4,%eax
  80197b:	8b 00                	mov    (%eax),%eax
  80197d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801980:	eb 1f                	jmp    8019a1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801982:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801986:	79 83                	jns    80190b <vprintfmt+0x54>
				width = 0;
  801988:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80198f:	e9 77 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801994:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80199b:	e9 6b ff ff ff       	jmp    80190b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8019a0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8019a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019a5:	0f 89 60 ff ff ff    	jns    80190b <vprintfmt+0x54>
				width = precision, precision = -1;
  8019ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8019b8:	e9 4e ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8019bd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8019c0:	e9 46 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8019c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c8:	83 c0 04             	add    $0x4,%eax
  8019cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8019ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d1:	83 e8 04             	sub    $0x4,%eax
  8019d4:	8b 00                	mov    (%eax),%eax
  8019d6:	83 ec 08             	sub    $0x8,%esp
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	50                   	push   %eax
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	ff d0                	call   *%eax
  8019e2:	83 c4 10             	add    $0x10,%esp
			break;
  8019e5:	e9 89 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8019ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ed:	83 c0 04             	add    $0x4,%eax
  8019f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8019f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f6:	83 e8 04             	sub    $0x4,%eax
  8019f9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8019fb:	85 db                	test   %ebx,%ebx
  8019fd:	79 02                	jns    801a01 <vprintfmt+0x14a>
				err = -err;
  8019ff:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801a01:	83 fb 64             	cmp    $0x64,%ebx
  801a04:	7f 0b                	jg     801a11 <vprintfmt+0x15a>
  801a06:	8b 34 9d 20 4f 80 00 	mov    0x804f20(,%ebx,4),%esi
  801a0d:	85 f6                	test   %esi,%esi
  801a0f:	75 19                	jne    801a2a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801a11:	53                   	push   %ebx
  801a12:	68 c5 50 80 00       	push   $0x8050c5
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	e8 5e 02 00 00       	call   801c80 <printfmt>
  801a22:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a25:	e9 49 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a2a:	56                   	push   %esi
  801a2b:	68 ce 50 80 00       	push   $0x8050ce
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	e8 45 02 00 00       	call   801c80 <printfmt>
  801a3b:	83 c4 10             	add    $0x10,%esp
			break;
  801a3e:	e9 30 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	83 c0 04             	add    $0x4,%eax
  801a49:	89 45 14             	mov    %eax,0x14(%ebp)
  801a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4f:	83 e8 04             	sub    $0x4,%eax
  801a52:	8b 30                	mov    (%eax),%esi
  801a54:	85 f6                	test   %esi,%esi
  801a56:	75 05                	jne    801a5d <vprintfmt+0x1a6>
				p = "(null)";
  801a58:	be d1 50 80 00       	mov    $0x8050d1,%esi
			if (width > 0 && padc != '-')
  801a5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a61:	7e 6d                	jle    801ad0 <vprintfmt+0x219>
  801a63:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801a67:	74 67                	je     801ad0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	50                   	push   %eax
  801a70:	56                   	push   %esi
  801a71:	e8 0c 03 00 00       	call   801d82 <strnlen>
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801a7c:	eb 16                	jmp    801a94 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801a7e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	ff d0                	call   *%eax
  801a8e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801a91:	ff 4d e4             	decl   -0x1c(%ebp)
  801a94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a98:	7f e4                	jg     801a7e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a9a:	eb 34                	jmp    801ad0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801a9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801aa0:	74 1c                	je     801abe <vprintfmt+0x207>
  801aa2:	83 fb 1f             	cmp    $0x1f,%ebx
  801aa5:	7e 05                	jle    801aac <vprintfmt+0x1f5>
  801aa7:	83 fb 7e             	cmp    $0x7e,%ebx
  801aaa:	7e 12                	jle    801abe <vprintfmt+0x207>
					putch('?', putdat);
  801aac:	83 ec 08             	sub    $0x8,%esp
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	6a 3f                	push   $0x3f
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	ff d0                	call   *%eax
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	eb 0f                	jmp    801acd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	53                   	push   %ebx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	ff d0                	call   *%eax
  801aca:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801acd:	ff 4d e4             	decl   -0x1c(%ebp)
  801ad0:	89 f0                	mov    %esi,%eax
  801ad2:	8d 70 01             	lea    0x1(%eax),%esi
  801ad5:	8a 00                	mov    (%eax),%al
  801ad7:	0f be d8             	movsbl %al,%ebx
  801ada:	85 db                	test   %ebx,%ebx
  801adc:	74 24                	je     801b02 <vprintfmt+0x24b>
  801ade:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ae2:	78 b8                	js     801a9c <vprintfmt+0x1e5>
  801ae4:	ff 4d e0             	decl   -0x20(%ebp)
  801ae7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801aeb:	79 af                	jns    801a9c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aed:	eb 13                	jmp    801b02 <vprintfmt+0x24b>
				putch(' ', putdat);
  801aef:	83 ec 08             	sub    $0x8,%esp
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	6a 20                	push   $0x20
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	ff d0                	call   *%eax
  801afc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aff:	ff 4d e4             	decl   -0x1c(%ebp)
  801b02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b06:	7f e7                	jg     801aef <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801b08:	e9 66 01 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	ff 75 e8             	pushl  -0x18(%ebp)
  801b13:	8d 45 14             	lea    0x14(%ebp),%eax
  801b16:	50                   	push   %eax
  801b17:	e8 3c fd ff ff       	call   801858 <getint>
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2b:	85 d2                	test   %edx,%edx
  801b2d:	79 23                	jns    801b52 <vprintfmt+0x29b>
				putch('-', putdat);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	6a 2d                	push   $0x2d
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	ff d0                	call   *%eax
  801b3c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b45:	f7 d8                	neg    %eax
  801b47:	83 d2 00             	adc    $0x0,%edx
  801b4a:	f7 da                	neg    %edx
  801b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801b52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b59:	e9 bc 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	ff 75 e8             	pushl  -0x18(%ebp)
  801b64:	8d 45 14             	lea    0x14(%ebp),%eax
  801b67:	50                   	push   %eax
  801b68:	e8 84 fc ff ff       	call   8017f1 <getuint>
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801b76:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b7d:	e9 98 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	6a 58                	push   $0x58
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	ff d0                	call   *%eax
  801b8f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b92:	83 ec 08             	sub    $0x8,%esp
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	6a 58                	push   $0x58
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	ff d0                	call   *%eax
  801b9f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	6a 58                	push   $0x58
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	ff d0                	call   *%eax
  801baf:	83 c4 10             	add    $0x10,%esp
			break;
  801bb2:	e9 bc 00 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	6a 30                	push   $0x30
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	ff d0                	call   *%eax
  801bc4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	6a 78                	push   $0x78
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	ff d0                	call   *%eax
  801bd4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bda:	83 c0 04             	add    $0x4,%eax
  801bdd:	89 45 14             	mov    %eax,0x14(%ebp)
  801be0:	8b 45 14             	mov    0x14(%ebp),%eax
  801be3:	83 e8 04             	sub    $0x4,%eax
  801be6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801bf9:	eb 1f                	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	ff 75 e8             	pushl  -0x18(%ebp)
  801c01:	8d 45 14             	lea    0x14(%ebp),%eax
  801c04:	50                   	push   %eax
  801c05:	e8 e7 fb ff ff       	call   8017f1 <getuint>
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801c13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801c1a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	52                   	push   %edx
  801c25:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c28:	50                   	push   %eax
  801c29:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	ff 75 08             	pushl  0x8(%ebp)
  801c35:	e8 00 fb ff ff       	call   80173a <printnum>
  801c3a:	83 c4 20             	add    $0x20,%esp
			break;
  801c3d:	eb 34                	jmp    801c73 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801c3f:	83 ec 08             	sub    $0x8,%esp
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	53                   	push   %ebx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	ff d0                	call   *%eax
  801c4b:	83 c4 10             	add    $0x10,%esp
			break;
  801c4e:	eb 23                	jmp    801c73 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801c50:	83 ec 08             	sub    $0x8,%esp
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	6a 25                	push   $0x25
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	ff d0                	call   *%eax
  801c5d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c60:	ff 4d 10             	decl   0x10(%ebp)
  801c63:	eb 03                	jmp    801c68 <vprintfmt+0x3b1>
  801c65:	ff 4d 10             	decl   0x10(%ebp)
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	48                   	dec    %eax
  801c6c:	8a 00                	mov    (%eax),%al
  801c6e:	3c 25                	cmp    $0x25,%al
  801c70:	75 f3                	jne    801c65 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801c72:	90                   	nop
		}
	}
  801c73:	e9 47 fc ff ff       	jmp    8018bf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801c78:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801c79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801c86:	8d 45 10             	lea    0x10(%ebp),%eax
  801c89:	83 c0 04             	add    $0x4,%eax
  801c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c92:	ff 75 f4             	pushl  -0xc(%ebp)
  801c95:	50                   	push   %eax
  801c96:	ff 75 0c             	pushl  0xc(%ebp)
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	e8 16 fc ff ff       	call   8018b7 <vprintfmt>
  801ca1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ca4:	90                   	nop
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cad:	8b 40 08             	mov    0x8(%eax),%eax
  801cb0:	8d 50 01             	lea    0x1(%eax),%edx
  801cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbc:	8b 10                	mov    (%eax),%edx
  801cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc1:	8b 40 04             	mov    0x4(%eax),%eax
  801cc4:	39 c2                	cmp    %eax,%edx
  801cc6:	73 12                	jae    801cda <sprintputch+0x33>
		*b->buf++ = ch;
  801cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccb:	8b 00                	mov    (%eax),%eax
  801ccd:	8d 48 01             	lea    0x1(%eax),%ecx
  801cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd3:	89 0a                	mov    %ecx,(%edx)
  801cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd8:	88 10                	mov    %dl,(%eax)
}
  801cda:	90                   	nop
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    

00801cdd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cec:	8d 50 ff             	lea    -0x1(%eax),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801cfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d02:	74 06                	je     801d0a <vsnprintf+0x2d>
  801d04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d08:	7f 07                	jg     801d11 <vsnprintf+0x34>
		return -E_INVAL;
  801d0a:	b8 03 00 00 00       	mov    $0x3,%eax
  801d0f:	eb 20                	jmp    801d31 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801d11:	ff 75 14             	pushl  0x14(%ebp)
  801d14:	ff 75 10             	pushl  0x10(%ebp)
  801d17:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	68 a7 1c 80 00       	push   $0x801ca7
  801d20:	e8 92 fb ff ff       	call   8018b7 <vprintfmt>
  801d25:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801d39:	8d 45 10             	lea    0x10(%ebp),%eax
  801d3c:	83 c0 04             	add    $0x4,%eax
  801d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801d42:	8b 45 10             	mov    0x10(%ebp),%eax
  801d45:	ff 75 f4             	pushl  -0xc(%ebp)
  801d48:	50                   	push   %eax
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	ff 75 08             	pushl  0x8(%ebp)
  801d4f:	e8 89 ff ff ff       	call   801cdd <vsnprintf>
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d6c:	eb 06                	jmp    801d74 <strlen+0x15>
		n++;
  801d6e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d71:	ff 45 08             	incl   0x8(%ebp)
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	8a 00                	mov    (%eax),%al
  801d79:	84 c0                	test   %al,%al
  801d7b:	75 f1                	jne    801d6e <strlen+0xf>
		n++;
	return n;
  801d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d8f:	eb 09                	jmp    801d9a <strnlen+0x18>
		n++;
  801d91:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d94:	ff 45 08             	incl   0x8(%ebp)
  801d97:	ff 4d 0c             	decl   0xc(%ebp)
  801d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d9e:	74 09                	je     801da9 <strnlen+0x27>
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8a 00                	mov    (%eax),%al
  801da5:	84 c0                	test   %al,%al
  801da7:	75 e8                	jne    801d91 <strnlen+0xf>
		n++;
	return n;
  801da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801dba:	90                   	nop
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	8d 50 01             	lea    0x1(%eax),%edx
  801dc1:	89 55 08             	mov    %edx,0x8(%ebp)
  801dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801dcd:	8a 12                	mov    (%edx),%dl
  801dcf:	88 10                	mov    %dl,(%eax)
  801dd1:	8a 00                	mov    (%eax),%al
  801dd3:	84 c0                	test   %al,%al
  801dd5:	75 e4                	jne    801dbb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801def:	eb 1f                	jmp    801e10 <strncpy+0x34>
		*dst++ = *src;
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	8d 50 01             	lea    0x1(%eax),%edx
  801df7:	89 55 08             	mov    %edx,0x8(%ebp)
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8a 12                	mov    (%edx),%dl
  801dff:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e04:	8a 00                	mov    (%eax),%al
  801e06:	84 c0                	test   %al,%al
  801e08:	74 03                	je     801e0d <strncpy+0x31>
			src++;
  801e0a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801e0d:	ff 45 fc             	incl   -0x4(%ebp)
  801e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e13:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e16:	72 d9                	jb     801df1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801e18:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801e29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e2d:	74 30                	je     801e5f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801e2f:	eb 16                	jmp    801e47 <strlcpy+0x2a>
			*dst++ = *src++;
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	8d 50 01             	lea    0x1(%eax),%edx
  801e37:	89 55 08             	mov    %edx,0x8(%ebp)
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e40:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e43:	8a 12                	mov    (%edx),%dl
  801e45:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e47:	ff 4d 10             	decl   0x10(%ebp)
  801e4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e4e:	74 09                	je     801e59 <strlcpy+0x3c>
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	8a 00                	mov    (%eax),%al
  801e55:	84 c0                	test   %al,%al
  801e57:	75 d8                	jne    801e31 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e65:	29 c2                	sub    %eax,%edx
  801e67:	89 d0                	mov    %edx,%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e6e:	eb 06                	jmp    801e76 <strcmp+0xb>
		p++, q++;
  801e70:	ff 45 08             	incl   0x8(%ebp)
  801e73:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8a 00                	mov    (%eax),%al
  801e7b:	84 c0                	test   %al,%al
  801e7d:	74 0e                	je     801e8d <strcmp+0x22>
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	8a 10                	mov    (%eax),%dl
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	8a 00                	mov    (%eax),%al
  801e89:	38 c2                	cmp    %al,%dl
  801e8b:	74 e3                	je     801e70 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	8a 00                	mov    (%eax),%al
  801e92:	0f b6 d0             	movzbl %al,%edx
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	8a 00                	mov    (%eax),%al
  801e9a:	0f b6 c0             	movzbl %al,%eax
  801e9d:	29 c2                	sub    %eax,%edx
  801e9f:	89 d0                	mov    %edx,%eax
}
  801ea1:	5d                   	pop    %ebp
  801ea2:	c3                   	ret    

00801ea3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801ea6:	eb 09                	jmp    801eb1 <strncmp+0xe>
		n--, p++, q++;
  801ea8:	ff 4d 10             	decl   0x10(%ebp)
  801eab:	ff 45 08             	incl   0x8(%ebp)
  801eae:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801eb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eb5:	74 17                	je     801ece <strncmp+0x2b>
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	8a 00                	mov    (%eax),%al
  801ebc:	84 c0                	test   %al,%al
  801ebe:	74 0e                	je     801ece <strncmp+0x2b>
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	8a 10                	mov    (%eax),%dl
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	8a 00                	mov    (%eax),%al
  801eca:	38 c2                	cmp    %al,%dl
  801ecc:	74 da                	je     801ea8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ed2:	75 07                	jne    801edb <strncmp+0x38>
		return 0;
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	eb 14                	jmp    801eef <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	8a 00                	mov    (%eax),%al
  801ee0:	0f b6 d0             	movzbl %al,%edx
  801ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee6:	8a 00                	mov    (%eax),%al
  801ee8:	0f b6 c0             	movzbl %al,%eax
  801eeb:	29 c2                	sub    %eax,%edx
  801eed:	89 d0                	mov    %edx,%eax
}
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    

00801ef1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 04             	sub    $0x4,%esp
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801efd:	eb 12                	jmp    801f11 <strchr+0x20>
		if (*s == c)
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	8a 00                	mov    (%eax),%al
  801f04:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f07:	75 05                	jne    801f0e <strchr+0x1d>
			return (char *) s;
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	eb 11                	jmp    801f1f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801f0e:	ff 45 08             	incl   0x8(%ebp)
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8a 00                	mov    (%eax),%al
  801f16:	84 c0                	test   %al,%al
  801f18:	75 e5                	jne    801eff <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 04             	sub    $0x4,%esp
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f2d:	eb 0d                	jmp    801f3c <strfind+0x1b>
		if (*s == c)
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	8a 00                	mov    (%eax),%al
  801f34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f37:	74 0e                	je     801f47 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f39:	ff 45 08             	incl   0x8(%ebp)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	8a 00                	mov    (%eax),%al
  801f41:	84 c0                	test   %al,%al
  801f43:	75 ea                	jne    801f2f <strfind+0xe>
  801f45:	eb 01                	jmp    801f48 <strfind+0x27>
		if (*s == c)
			break;
  801f47:	90                   	nop
	return (char *) s;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801f59:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801f5f:	eb 0e                	jmp    801f6f <memset+0x22>
		*p++ = c;
  801f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f64:	8d 50 01             	lea    0x1(%eax),%edx
  801f67:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801f6f:	ff 4d f8             	decl   -0x8(%ebp)
  801f72:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f76:	79 e9                	jns    801f61 <memset+0x14>
		*p++ = c;

	return v;
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801f8f:	eb 16                	jmp    801fa7 <memcpy+0x2a>
		*d++ = *s++;
  801f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f94:	8d 50 01             	lea    0x1(%eax),%edx
  801f97:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fa0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801fa3:	8a 12                	mov    (%edx),%dl
  801fa5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  801faa:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fad:	89 55 10             	mov    %edx,0x10(%ebp)
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	75 dd                	jne    801f91 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fd1:	73 50                	jae    802023 <memmove+0x6a>
  801fd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd9:	01 d0                	add    %edx,%eax
  801fdb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fde:	76 43                	jbe    802023 <memmove+0x6a>
		s += n;
  801fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fec:	eb 10                	jmp    801ffe <memmove+0x45>
			*--d = *--s;
  801fee:	ff 4d f8             	decl   -0x8(%ebp)
  801ff1:	ff 4d fc             	decl   -0x4(%ebp)
  801ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff7:	8a 10                	mov    (%eax),%dl
  801ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ffc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  802001:	8d 50 ff             	lea    -0x1(%eax),%edx
  802004:	89 55 10             	mov    %edx,0x10(%ebp)
  802007:	85 c0                	test   %eax,%eax
  802009:	75 e3                	jne    801fee <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80200b:	eb 23                	jmp    802030 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80200d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802010:	8d 50 01             	lea    0x1(%eax),%edx
  802013:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802016:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802019:	8d 4a 01             	lea    0x1(%edx),%ecx
  80201c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80201f:	8a 12                	mov    (%edx),%dl
  802021:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802023:	8b 45 10             	mov    0x10(%ebp),%eax
  802026:	8d 50 ff             	lea    -0x1(%eax),%edx
  802029:	89 55 10             	mov    %edx,0x10(%ebp)
  80202c:	85 c0                	test   %eax,%eax
  80202e:	75 dd                	jne    80200d <memmove+0x54>
			*d++ = *s++;

	return dst;
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802041:	8b 45 0c             	mov    0xc(%ebp),%eax
  802044:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802047:	eb 2a                	jmp    802073 <memcmp+0x3e>
		if (*s1 != *s2)
  802049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204c:	8a 10                	mov    (%eax),%dl
  80204e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802051:	8a 00                	mov    (%eax),%al
  802053:	38 c2                	cmp    %al,%dl
  802055:	74 16                	je     80206d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205a:	8a 00                	mov    (%eax),%al
  80205c:	0f b6 d0             	movzbl %al,%edx
  80205f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802062:	8a 00                	mov    (%eax),%al
  802064:	0f b6 c0             	movzbl %al,%eax
  802067:	29 c2                	sub    %eax,%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	eb 18                	jmp    802085 <memcmp+0x50>
		s1++, s2++;
  80206d:	ff 45 fc             	incl   -0x4(%ebp)
  802070:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802073:	8b 45 10             	mov    0x10(%ebp),%eax
  802076:	8d 50 ff             	lea    -0x1(%eax),%edx
  802079:	89 55 10             	mov    %edx,0x10(%ebp)
  80207c:	85 c0                	test   %eax,%eax
  80207e:	75 c9                	jne    802049 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80208d:	8b 55 08             	mov    0x8(%ebp),%edx
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	01 d0                	add    %edx,%eax
  802095:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802098:	eb 15                	jmp    8020af <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	8a 00                	mov    (%eax),%al
  80209f:	0f b6 d0             	movzbl %al,%edx
  8020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a5:	0f b6 c0             	movzbl %al,%eax
  8020a8:	39 c2                	cmp    %eax,%edx
  8020aa:	74 0d                	je     8020b9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8020ac:	ff 45 08             	incl   0x8(%ebp)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020b5:	72 e3                	jb     80209a <memfind+0x13>
  8020b7:	eb 01                	jmp    8020ba <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8020b9:	90                   	nop
	return (void *) s;
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8020c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d3:	eb 03                	jmp    8020d8 <strtol+0x19>
		s++;
  8020d5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	8a 00                	mov    (%eax),%al
  8020dd:	3c 20                	cmp    $0x20,%al
  8020df:	74 f4                	je     8020d5 <strtol+0x16>
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8a 00                	mov    (%eax),%al
  8020e6:	3c 09                	cmp    $0x9,%al
  8020e8:	74 eb                	je     8020d5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	8a 00                	mov    (%eax),%al
  8020ef:	3c 2b                	cmp    $0x2b,%al
  8020f1:	75 05                	jne    8020f8 <strtol+0x39>
		s++;
  8020f3:	ff 45 08             	incl   0x8(%ebp)
  8020f6:	eb 13                	jmp    80210b <strtol+0x4c>
	else if (*s == '-')
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	8a 00                	mov    (%eax),%al
  8020fd:	3c 2d                	cmp    $0x2d,%al
  8020ff:	75 0a                	jne    80210b <strtol+0x4c>
		s++, neg = 1;
  802101:	ff 45 08             	incl   0x8(%ebp)
  802104:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80210b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210f:	74 06                	je     802117 <strtol+0x58>
  802111:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802115:	75 20                	jne    802137 <strtol+0x78>
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	8a 00                	mov    (%eax),%al
  80211c:	3c 30                	cmp    $0x30,%al
  80211e:	75 17                	jne    802137 <strtol+0x78>
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	40                   	inc    %eax
  802124:	8a 00                	mov    (%eax),%al
  802126:	3c 78                	cmp    $0x78,%al
  802128:	75 0d                	jne    802137 <strtol+0x78>
		s += 2, base = 16;
  80212a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80212e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802135:	eb 28                	jmp    80215f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802137:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213b:	75 15                	jne    802152 <strtol+0x93>
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	8a 00                	mov    (%eax),%al
  802142:	3c 30                	cmp    $0x30,%al
  802144:	75 0c                	jne    802152 <strtol+0x93>
		s++, base = 8;
  802146:	ff 45 08             	incl   0x8(%ebp)
  802149:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802150:	eb 0d                	jmp    80215f <strtol+0xa0>
	else if (base == 0)
  802152:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802156:	75 07                	jne    80215f <strtol+0xa0>
		base = 10;
  802158:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8a 00                	mov    (%eax),%al
  802164:	3c 2f                	cmp    $0x2f,%al
  802166:	7e 19                	jle    802181 <strtol+0xc2>
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	8a 00                	mov    (%eax),%al
  80216d:	3c 39                	cmp    $0x39,%al
  80216f:	7f 10                	jg     802181 <strtol+0xc2>
			dig = *s - '0';
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	8a 00                	mov    (%eax),%al
  802176:	0f be c0             	movsbl %al,%eax
  802179:	83 e8 30             	sub    $0x30,%eax
  80217c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217f:	eb 42                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8a 00                	mov    (%eax),%al
  802186:	3c 60                	cmp    $0x60,%al
  802188:	7e 19                	jle    8021a3 <strtol+0xe4>
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8a 00                	mov    (%eax),%al
  80218f:	3c 7a                	cmp    $0x7a,%al
  802191:	7f 10                	jg     8021a3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8a 00                	mov    (%eax),%al
  802198:	0f be c0             	movsbl %al,%eax
  80219b:	83 e8 57             	sub    $0x57,%eax
  80219e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a1:	eb 20                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8a 00                	mov    (%eax),%al
  8021a8:	3c 40                	cmp    $0x40,%al
  8021aa:	7e 39                	jle    8021e5 <strtol+0x126>
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8a 00                	mov    (%eax),%al
  8021b1:	3c 5a                	cmp    $0x5a,%al
  8021b3:	7f 30                	jg     8021e5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8a 00                	mov    (%eax),%al
  8021ba:	0f be c0             	movsbl %al,%eax
  8021bd:	83 e8 37             	sub    $0x37,%eax
  8021c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021c9:	7d 19                	jge    8021e4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021cb:	ff 45 08             	incl   0x8(%ebp)
  8021ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021d5:	89 c2                	mov    %eax,%edx
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	01 d0                	add    %edx,%eax
  8021dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021df:	e9 7b ff ff ff       	jmp    80215f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021e4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021e9:	74 08                	je     8021f3 <strtol+0x134>
		*endptr = (char *) s;
  8021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f7:	74 07                	je     802200 <strtol+0x141>
  8021f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021fc:	f7 d8                	neg    %eax
  8021fe:	eb 03                	jmp    802203 <strtol+0x144>
  802200:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <ltostr>:

void
ltostr(long value, char *str)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80220b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802212:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221d:	79 13                	jns    802232 <ltostr+0x2d>
	{
		neg = 1;
  80221f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802226:	8b 45 0c             	mov    0xc(%ebp),%eax
  802229:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80222c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80222f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80223a:	99                   	cltd   
  80223b:	f7 f9                	idiv   %ecx
  80223d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802240:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802243:	8d 50 01             	lea    0x1(%eax),%edx
  802246:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802249:	89 c2                	mov    %eax,%edx
  80224b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224e:	01 d0                	add    %edx,%eax
  802250:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802253:	83 c2 30             	add    $0x30,%edx
  802256:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802258:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80225b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802260:	f7 e9                	imul   %ecx
  802262:	c1 fa 02             	sar    $0x2,%edx
  802265:	89 c8                	mov    %ecx,%eax
  802267:	c1 f8 1f             	sar    $0x1f,%eax
  80226a:	29 c2                	sub    %eax,%edx
  80226c:	89 d0                	mov    %edx,%eax
  80226e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802274:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802279:	f7 e9                	imul   %ecx
  80227b:	c1 fa 02             	sar    $0x2,%edx
  80227e:	89 c8                	mov    %ecx,%eax
  802280:	c1 f8 1f             	sar    $0x1f,%eax
  802283:	29 c2                	sub    %eax,%edx
  802285:	89 d0                	mov    %edx,%eax
  802287:	c1 e0 02             	shl    $0x2,%eax
  80228a:	01 d0                	add    %edx,%eax
  80228c:	01 c0                	add    %eax,%eax
  80228e:	29 c1                	sub    %eax,%ecx
  802290:	89 ca                	mov    %ecx,%edx
  802292:	85 d2                	test   %edx,%edx
  802294:	75 9c                	jne    802232 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802296:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80229d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022a0:	48                   	dec    %eax
  8022a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8022a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022a8:	74 3d                	je     8022e7 <ltostr+0xe2>
		start = 1 ;
  8022aa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8022b1:	eb 34                	jmp    8022e7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	8a 00                	mov    (%eax),%al
  8022bd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8022c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c6:	01 c2                	add    %eax,%edx
  8022c8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ce:	01 c8                	add    %ecx,%eax
  8022d0:	8a 00                	mov    (%eax),%al
  8022d2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8022d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022da:	01 c2                	add    %eax,%edx
  8022dc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8022df:	88 02                	mov    %al,(%edx)
		start++ ;
  8022e1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8022e4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022ed:	7c c4                	jl     8022b3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8022ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8022f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f5:	01 d0                	add    %edx,%eax
  8022f7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8022fa:	90                   	nop
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	e8 54 fa ff ff       	call   801d5f <strlen>
  80230b:	83 c4 04             	add    $0x4,%esp
  80230e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802311:	ff 75 0c             	pushl  0xc(%ebp)
  802314:	e8 46 fa ff ff       	call   801d5f <strlen>
  802319:	83 c4 04             	add    $0x4,%esp
  80231c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80231f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802326:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80232d:	eb 17                	jmp    802346 <strcconcat+0x49>
		final[s] = str1[s] ;
  80232f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802332:	8b 45 10             	mov    0x10(%ebp),%eax
  802335:	01 c2                	add    %eax,%edx
  802337:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	01 c8                	add    %ecx,%eax
  80233f:	8a 00                	mov    (%eax),%al
  802341:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802343:	ff 45 fc             	incl   -0x4(%ebp)
  802346:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802349:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80234c:	7c e1                	jl     80232f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80234e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802355:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80235c:	eb 1f                	jmp    80237d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80235e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802361:	8d 50 01             	lea    0x1(%eax),%edx
  802364:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802367:	89 c2                	mov    %eax,%edx
  802369:	8b 45 10             	mov    0x10(%ebp),%eax
  80236c:	01 c2                	add    %eax,%edx
  80236e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	01 c8                	add    %ecx,%eax
  802376:	8a 00                	mov    (%eax),%al
  802378:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80237a:	ff 45 f8             	incl   -0x8(%ebp)
  80237d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802380:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802383:	7c d9                	jl     80235e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802385:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802388:	8b 45 10             	mov    0x10(%ebp),%eax
  80238b:	01 d0                	add    %edx,%eax
  80238d:	c6 00 00             	movb   $0x0,(%eax)
}
  802390:	90                   	nop
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802396:	8b 45 14             	mov    0x14(%ebp),%eax
  802399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80239f:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023b6:	eb 0c                	jmp    8023c4 <strsplit+0x31>
			*string++ = 0;
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8d 50 01             	lea    0x1(%eax),%edx
  8023be:	89 55 08             	mov    %edx,0x8(%ebp)
  8023c1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	8a 00                	mov    (%eax),%al
  8023c9:	84 c0                	test   %al,%al
  8023cb:	74 18                	je     8023e5 <strsplit+0x52>
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8a 00                	mov    (%eax),%al
  8023d2:	0f be c0             	movsbl %al,%eax
  8023d5:	50                   	push   %eax
  8023d6:	ff 75 0c             	pushl  0xc(%ebp)
  8023d9:	e8 13 fb ff ff       	call   801ef1 <strchr>
  8023de:	83 c4 08             	add    $0x8,%esp
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	75 d3                	jne    8023b8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	8a 00                	mov    (%eax),%al
  8023ea:	84 c0                	test   %al,%al
  8023ec:	74 5a                	je     802448 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8023ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	83 f8 0f             	cmp    $0xf,%eax
  8023f6:	75 07                	jne    8023ff <strsplit+0x6c>
		{
			return 0;
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	eb 66                	jmp    802465 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	8d 48 01             	lea    0x1(%eax),%ecx
  802407:	8b 55 14             	mov    0x14(%ebp),%edx
  80240a:	89 0a                	mov    %ecx,(%edx)
  80240c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802413:	8b 45 10             	mov    0x10(%ebp),%eax
  802416:	01 c2                	add    %eax,%edx
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80241d:	eb 03                	jmp    802422 <strsplit+0x8f>
			string++;
  80241f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	8a 00                	mov    (%eax),%al
  802427:	84 c0                	test   %al,%al
  802429:	74 8b                	je     8023b6 <strsplit+0x23>
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	8a 00                	mov    (%eax),%al
  802430:	0f be c0             	movsbl %al,%eax
  802433:	50                   	push   %eax
  802434:	ff 75 0c             	pushl  0xc(%ebp)
  802437:	e8 b5 fa ff ff       	call   801ef1 <strchr>
  80243c:	83 c4 08             	add    $0x8,%esp
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 dc                	je     80241f <strsplit+0x8c>
			string++;
	}
  802443:	e9 6e ff ff ff       	jmp    8023b6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802448:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802449:	8b 45 14             	mov    0x14(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802455:	8b 45 10             	mov    0x10(%ebp),%eax
  802458:	01 d0                	add    %edx,%eax
  80245a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802460:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80246d:	a1 04 60 80 00       	mov    0x806004,%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 1f                	je     802495 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802476:	e8 1d 00 00 00       	call   802498 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80247b:	83 ec 0c             	sub    $0xc,%esp
  80247e:	68 30 52 80 00       	push   $0x805230
  802483:	e8 55 f2 ff ff       	call   8016dd <cprintf>
  802488:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80248b:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  802492:	00 00 00 
	}
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80249e:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8024a5:	00 00 00 
  8024a8:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8024af:	00 00 00 
  8024b2:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8024b9:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8024bc:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  8024c3:	00 00 00 
  8024c6:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  8024cd:	00 00 00 
  8024d0:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  8024d7:	00 00 00 
	uint32 arr_size = 0;
  8024da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8024e1:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8024e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024f0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024f5:	a3 50 60 80 00       	mov    %eax,0x806050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8024fa:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  802501:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  802504:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80250b:	a1 20 61 80 00       	mov    0x806120,%eax
  802510:	c1 e0 04             	shl    $0x4,%eax
  802513:	89 c2                	mov    %eax,%edx
  802515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802518:	01 d0                	add    %edx,%eax
  80251a:	48                   	dec    %eax
  80251b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80251e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802521:	ba 00 00 00 00       	mov    $0x0,%edx
  802526:	f7 75 ec             	divl   -0x14(%ebp)
  802529:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80252c:	29 d0                	sub    %edx,%eax
  80252e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  802531:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  802538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802540:	2d 00 10 00 00       	sub    $0x1000,%eax
  802545:	83 ec 04             	sub    $0x4,%esp
  802548:	6a 06                	push   $0x6
  80254a:	ff 75 f4             	pushl  -0xc(%ebp)
  80254d:	50                   	push   %eax
  80254e:	e8 fc 04 00 00       	call   802a4f <sys_allocate_chunk>
  802553:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802556:	a1 20 61 80 00       	mov    0x806120,%eax
  80255b:	83 ec 0c             	sub    $0xc,%esp
  80255e:	50                   	push   %eax
  80255f:	e8 71 0b 00 00       	call   8030d5 <initialize_MemBlocksList>
  802564:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  802567:	a1 48 61 80 00       	mov    0x806148,%eax
  80256c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  80256f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802572:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  802579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  802583:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802587:	75 14                	jne    80259d <initialize_dyn_block_system+0x105>
  802589:	83 ec 04             	sub    $0x4,%esp
  80258c:	68 55 52 80 00       	push   $0x805255
  802591:	6a 33                	push   $0x33
  802593:	68 73 52 80 00       	push   $0x805273
  802598:	e8 8c ee ff ff       	call   801429 <_panic>
  80259d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	85 c0                	test   %eax,%eax
  8025a4:	74 10                	je     8025b6 <initialize_dyn_block_system+0x11e>
  8025a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025ae:	8b 52 04             	mov    0x4(%edx),%edx
  8025b1:	89 50 04             	mov    %edx,0x4(%eax)
  8025b4:	eb 0b                	jmp    8025c1 <initialize_dyn_block_system+0x129>
  8025b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b9:	8b 40 04             	mov    0x4(%eax),%eax
  8025bc:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8025c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c4:	8b 40 04             	mov    0x4(%eax),%eax
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	74 0f                	je     8025da <initialize_dyn_block_system+0x142>
  8025cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ce:	8b 40 04             	mov    0x4(%eax),%eax
  8025d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025d4:	8b 12                	mov    (%edx),%edx
  8025d6:	89 10                	mov    %edx,(%eax)
  8025d8:	eb 0a                	jmp    8025e4 <initialize_dyn_block_system+0x14c>
  8025da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	a3 48 61 80 00       	mov    %eax,0x806148
  8025e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f7:	a1 54 61 80 00       	mov    0x806154,%eax
  8025fc:	48                   	dec    %eax
  8025fd:	a3 54 61 80 00       	mov    %eax,0x806154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  802602:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802606:	75 14                	jne    80261c <initialize_dyn_block_system+0x184>
  802608:	83 ec 04             	sub    $0x4,%esp
  80260b:	68 80 52 80 00       	push   $0x805280
  802610:	6a 34                	push   $0x34
  802612:	68 73 52 80 00       	push   $0x805273
  802617:	e8 0d ee ff ff       	call   801429 <_panic>
  80261c:	8b 15 38 61 80 00    	mov    0x806138,%edx
  802622:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802625:	89 10                	mov    %edx,(%eax)
  802627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262a:	8b 00                	mov    (%eax),%eax
  80262c:	85 c0                	test   %eax,%eax
  80262e:	74 0d                	je     80263d <initialize_dyn_block_system+0x1a5>
  802630:	a1 38 61 80 00       	mov    0x806138,%eax
  802635:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802638:	89 50 04             	mov    %edx,0x4(%eax)
  80263b:	eb 08                	jmp    802645 <initialize_dyn_block_system+0x1ad>
  80263d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802640:	a3 3c 61 80 00       	mov    %eax,0x80613c
  802645:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802648:	a3 38 61 80 00       	mov    %eax,0x806138
  80264d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802650:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802657:	a1 44 61 80 00       	mov    0x806144,%eax
  80265c:	40                   	inc    %eax
  80265d:	a3 44 61 80 00       	mov    %eax,0x806144
}
  802662:	90                   	nop
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80266b:	e8 f7 fd ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  802670:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802674:	75 07                	jne    80267d <malloc+0x18>
  802676:	b8 00 00 00 00       	mov    $0x0,%eax
  80267b:	eb 61                	jmp    8026de <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  80267d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802684:	8b 55 08             	mov    0x8(%ebp),%edx
  802687:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268a:	01 d0                	add    %edx,%eax
  80268c:	48                   	dec    %eax
  80268d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802690:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802693:	ba 00 00 00 00       	mov    $0x0,%edx
  802698:	f7 75 f0             	divl   -0x10(%ebp)
  80269b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269e:	29 d0                	sub    %edx,%eax
  8026a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8026a3:	e8 75 07 00 00       	call   802e1d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	74 11                	je     8026bd <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8026ac:	83 ec 0c             	sub    $0xc,%esp
  8026af:	ff 75 e8             	pushl  -0x18(%ebp)
  8026b2:	e8 e0 0d 00 00       	call   803497 <alloc_block_FF>
  8026b7:	83 c4 10             	add    $0x10,%esp
  8026ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  8026bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c1:	74 16                	je     8026d9 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  8026c3:	83 ec 0c             	sub    $0xc,%esp
  8026c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c9:	e8 3c 0b 00 00       	call   80320a <insert_sorted_allocList>
  8026ce:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 40 08             	mov    0x8(%eax),%eax
  8026d7:	eb 05                	jmp    8026de <malloc+0x79>
	}

    return NULL;
  8026d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026de:	c9                   	leave  
  8026df:	c3                   	ret    

008026e0 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
  8026e3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8026e6:	83 ec 04             	sub    $0x4,%esp
  8026e9:	68 a4 52 80 00       	push   $0x8052a4
  8026ee:	6a 6f                	push   $0x6f
  8026f0:	68 73 52 80 00       	push   $0x805273
  8026f5:	e8 2f ed ff ff       	call   801429 <_panic>

008026fa <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	83 ec 38             	sub    $0x38,%esp
  802700:	8b 45 10             	mov    0x10(%ebp),%eax
  802703:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802706:	e8 5c fd ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  80270b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80270f:	75 0a                	jne    80271b <smalloc+0x21>
  802711:	b8 00 00 00 00       	mov    $0x0,%eax
  802716:	e9 8b 00 00 00       	jmp    8027a6 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80271b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802722:	8b 55 0c             	mov    0xc(%ebp),%edx
  802725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802728:	01 d0                	add    %edx,%eax
  80272a:	48                   	dec    %eax
  80272b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80272e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802731:	ba 00 00 00 00       	mov    $0x0,%edx
  802736:	f7 75 f0             	divl   -0x10(%ebp)
  802739:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273c:	29 d0                	sub    %edx,%eax
  80273e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802741:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802748:	e8 d0 06 00 00       	call   802e1d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80274d:	85 c0                	test   %eax,%eax
  80274f:	74 11                	je     802762 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  802751:	83 ec 0c             	sub    $0xc,%esp
  802754:	ff 75 e8             	pushl  -0x18(%ebp)
  802757:	e8 3b 0d 00 00       	call   803497 <alloc_block_FF>
  80275c:	83 c4 10             	add    $0x10,%esp
  80275f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  802762:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802766:	74 39                	je     8027a1 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 08             	mov    0x8(%eax),%eax
  80276e:	89 c2                	mov    %eax,%edx
  802770:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802774:	52                   	push   %edx
  802775:	50                   	push   %eax
  802776:	ff 75 0c             	pushl  0xc(%ebp)
  802779:	ff 75 08             	pushl  0x8(%ebp)
  80277c:	e8 21 04 00 00       	call   802ba2 <sys_createSharedObject>
  802781:	83 c4 10             	add    $0x10,%esp
  802784:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  802787:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80278b:	74 14                	je     8027a1 <smalloc+0xa7>
  80278d:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  802791:	74 0e                	je     8027a1 <smalloc+0xa7>
  802793:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  802797:	74 08                	je     8027a1 <smalloc+0xa7>
			return (void*) mem_block->sva;
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 08             	mov    0x8(%eax),%eax
  80279f:	eb 05                	jmp    8027a6 <smalloc+0xac>
	}
	return NULL;
  8027a1:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8027a6:	c9                   	leave  
  8027a7:	c3                   	ret    

008027a8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
  8027ab:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8027ae:	e8 b4 fc ff ff       	call   802467 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8027b3:	83 ec 08             	sub    $0x8,%esp
  8027b6:	ff 75 0c             	pushl  0xc(%ebp)
  8027b9:	ff 75 08             	pushl  0x8(%ebp)
  8027bc:	e8 0b 04 00 00       	call   802bcc <sys_getSizeOfSharedObject>
  8027c1:	83 c4 10             	add    $0x10,%esp
  8027c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8027c7:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8027cb:	74 76                	je     802843 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8027cd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8027d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027da:	01 d0                	add    %edx,%eax
  8027dc:	48                   	dec    %eax
  8027dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e8:	f7 75 ec             	divl   -0x14(%ebp)
  8027eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ee:	29 d0                	sub    %edx,%eax
  8027f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8027f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8027fa:	e8 1e 06 00 00       	call   802e1d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8027ff:	85 c0                	test   %eax,%eax
  802801:	74 11                	je     802814 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  802803:	83 ec 0c             	sub    $0xc,%esp
  802806:	ff 75 e4             	pushl  -0x1c(%ebp)
  802809:	e8 89 0c 00 00       	call   803497 <alloc_block_FF>
  80280e:	83 c4 10             	add    $0x10,%esp
  802811:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  802814:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802818:	74 29                	je     802843 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 40 08             	mov    0x8(%eax),%eax
  802820:	83 ec 04             	sub    $0x4,%esp
  802823:	50                   	push   %eax
  802824:	ff 75 0c             	pushl  0xc(%ebp)
  802827:	ff 75 08             	pushl  0x8(%ebp)
  80282a:	e8 ba 03 00 00       	call   802be9 <sys_getSharedObject>
  80282f:	83 c4 10             	add    $0x10,%esp
  802832:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  802835:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  802839:	74 08                	je     802843 <sget+0x9b>
				return (void *)mem_block->sva;
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 40 08             	mov    0x8(%eax),%eax
  802841:	eb 05                	jmp    802848 <sget+0xa0>
		}
	}
	return (void *)NULL;
  802843:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802848:	c9                   	leave  
  802849:	c3                   	ret    

0080284a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80284a:	55                   	push   %ebp
  80284b:	89 e5                	mov    %esp,%ebp
  80284d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802850:	e8 12 fc ff ff       	call   802467 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802855:	83 ec 04             	sub    $0x4,%esp
  802858:	68 c8 52 80 00       	push   $0x8052c8
  80285d:	68 f1 00 00 00       	push   $0xf1
  802862:	68 73 52 80 00       	push   $0x805273
  802867:	e8 bd eb ff ff       	call   801429 <_panic>

0080286c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
  80286f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802872:	83 ec 04             	sub    $0x4,%esp
  802875:	68 f0 52 80 00       	push   $0x8052f0
  80287a:	68 05 01 00 00       	push   $0x105
  80287f:	68 73 52 80 00       	push   $0x805273
  802884:	e8 a0 eb ff ff       	call   801429 <_panic>

00802889 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802889:	55                   	push   %ebp
  80288a:	89 e5                	mov    %esp,%ebp
  80288c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80288f:	83 ec 04             	sub    $0x4,%esp
  802892:	68 14 53 80 00       	push   $0x805314
  802897:	68 10 01 00 00       	push   $0x110
  80289c:	68 73 52 80 00       	push   $0x805273
  8028a1:	e8 83 eb ff ff       	call   801429 <_panic>

008028a6 <shrink>:

}
void shrink(uint32 newSize)
{
  8028a6:	55                   	push   %ebp
  8028a7:	89 e5                	mov    %esp,%ebp
  8028a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8028ac:	83 ec 04             	sub    $0x4,%esp
  8028af:	68 14 53 80 00       	push   $0x805314
  8028b4:	68 15 01 00 00       	push   $0x115
  8028b9:	68 73 52 80 00       	push   $0x805273
  8028be:	e8 66 eb ff ff       	call   801429 <_panic>

008028c3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8028c3:	55                   	push   %ebp
  8028c4:	89 e5                	mov    %esp,%ebp
  8028c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8028c9:	83 ec 04             	sub    $0x4,%esp
  8028cc:	68 14 53 80 00       	push   $0x805314
  8028d1:	68 1a 01 00 00       	push   $0x11a
  8028d6:	68 73 52 80 00       	push   $0x805273
  8028db:	e8 49 eb ff ff       	call   801429 <_panic>

008028e0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
  8028e3:	57                   	push   %edi
  8028e4:	56                   	push   %esi
  8028e5:	53                   	push   %ebx
  8028e6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028f5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8028f8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8028fb:	cd 30                	int    $0x30
  8028fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802900:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802903:	83 c4 10             	add    $0x10,%esp
  802906:	5b                   	pop    %ebx
  802907:	5e                   	pop    %esi
  802908:	5f                   	pop    %edi
  802909:	5d                   	pop    %ebp
  80290a:	c3                   	ret    

0080290b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80290b:	55                   	push   %ebp
  80290c:	89 e5                	mov    %esp,%ebp
  80290e:	83 ec 04             	sub    $0x4,%esp
  802911:	8b 45 10             	mov    0x10(%ebp),%eax
  802914:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802917:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	52                   	push   %edx
  802923:	ff 75 0c             	pushl  0xc(%ebp)
  802926:	50                   	push   %eax
  802927:	6a 00                	push   $0x0
  802929:	e8 b2 ff ff ff       	call   8028e0 <syscall>
  80292e:	83 c4 18             	add    $0x18,%esp
}
  802931:	90                   	nop
  802932:	c9                   	leave  
  802933:	c3                   	ret    

00802934 <sys_cgetc>:

int
sys_cgetc(void)
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802937:	6a 00                	push   $0x0
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 01                	push   $0x1
  802943:	e8 98 ff ff ff       	call   8028e0 <syscall>
  802948:	83 c4 18             	add    $0x18,%esp
}
  80294b:	c9                   	leave  
  80294c:	c3                   	ret    

0080294d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80294d:	55                   	push   %ebp
  80294e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802950:	8b 55 0c             	mov    0xc(%ebp),%edx
  802953:	8b 45 08             	mov    0x8(%ebp),%eax
  802956:	6a 00                	push   $0x0
  802958:	6a 00                	push   $0x0
  80295a:	6a 00                	push   $0x0
  80295c:	52                   	push   %edx
  80295d:	50                   	push   %eax
  80295e:	6a 05                	push   $0x5
  802960:	e8 7b ff ff ff       	call   8028e0 <syscall>
  802965:	83 c4 18             	add    $0x18,%esp
}
  802968:	c9                   	leave  
  802969:	c3                   	ret    

0080296a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
  80296d:	56                   	push   %esi
  80296e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80296f:	8b 75 18             	mov    0x18(%ebp),%esi
  802972:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802975:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	56                   	push   %esi
  80297f:	53                   	push   %ebx
  802980:	51                   	push   %ecx
  802981:	52                   	push   %edx
  802982:	50                   	push   %eax
  802983:	6a 06                	push   $0x6
  802985:	e8 56 ff ff ff       	call   8028e0 <syscall>
  80298a:	83 c4 18             	add    $0x18,%esp
}
  80298d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802990:	5b                   	pop    %ebx
  802991:	5e                   	pop    %esi
  802992:	5d                   	pop    %ebp
  802993:	c3                   	ret    

00802994 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802994:	55                   	push   %ebp
  802995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802997:	8b 55 0c             	mov    0xc(%ebp),%edx
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	6a 00                	push   $0x0
  80299f:	6a 00                	push   $0x0
  8029a1:	6a 00                	push   $0x0
  8029a3:	52                   	push   %edx
  8029a4:	50                   	push   %eax
  8029a5:	6a 07                	push   $0x7
  8029a7:	e8 34 ff ff ff       	call   8028e0 <syscall>
  8029ac:	83 c4 18             	add    $0x18,%esp
}
  8029af:	c9                   	leave  
  8029b0:	c3                   	ret    

008029b1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8029b1:	55                   	push   %ebp
  8029b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8029b4:	6a 00                	push   $0x0
  8029b6:	6a 00                	push   $0x0
  8029b8:	6a 00                	push   $0x0
  8029ba:	ff 75 0c             	pushl  0xc(%ebp)
  8029bd:	ff 75 08             	pushl  0x8(%ebp)
  8029c0:	6a 08                	push   $0x8
  8029c2:	e8 19 ff ff ff       	call   8028e0 <syscall>
  8029c7:	83 c4 18             	add    $0x18,%esp
}
  8029ca:	c9                   	leave  
  8029cb:	c3                   	ret    

008029cc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8029cc:	55                   	push   %ebp
  8029cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8029cf:	6a 00                	push   $0x0
  8029d1:	6a 00                	push   $0x0
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 00                	push   $0x0
  8029d7:	6a 00                	push   $0x0
  8029d9:	6a 09                	push   $0x9
  8029db:	e8 00 ff ff ff       	call   8028e0 <syscall>
  8029e0:	83 c4 18             	add    $0x18,%esp
}
  8029e3:	c9                   	leave  
  8029e4:	c3                   	ret    

008029e5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8029e5:	55                   	push   %ebp
  8029e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8029e8:	6a 00                	push   $0x0
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 0a                	push   $0xa
  8029f4:	e8 e7 fe ff ff       	call   8028e0 <syscall>
  8029f9:	83 c4 18             	add    $0x18,%esp
}
  8029fc:	c9                   	leave  
  8029fd:	c3                   	ret    

008029fe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8029fe:	55                   	push   %ebp
  8029ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802a01:	6a 00                	push   $0x0
  802a03:	6a 00                	push   $0x0
  802a05:	6a 00                	push   $0x0
  802a07:	6a 00                	push   $0x0
  802a09:	6a 00                	push   $0x0
  802a0b:	6a 0b                	push   $0xb
  802a0d:	e8 ce fe ff ff       	call   8028e0 <syscall>
  802a12:	83 c4 18             	add    $0x18,%esp
}
  802a15:	c9                   	leave  
  802a16:	c3                   	ret    

00802a17 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802a17:	55                   	push   %ebp
  802a18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 00                	push   $0x0
  802a20:	ff 75 0c             	pushl  0xc(%ebp)
  802a23:	ff 75 08             	pushl  0x8(%ebp)
  802a26:	6a 0f                	push   $0xf
  802a28:	e8 b3 fe ff ff       	call   8028e0 <syscall>
  802a2d:	83 c4 18             	add    $0x18,%esp
	return;
  802a30:	90                   	nop
}
  802a31:	c9                   	leave  
  802a32:	c3                   	ret    

00802a33 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802a33:	55                   	push   %ebp
  802a34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802a36:	6a 00                	push   $0x0
  802a38:	6a 00                	push   $0x0
  802a3a:	6a 00                	push   $0x0
  802a3c:	ff 75 0c             	pushl  0xc(%ebp)
  802a3f:	ff 75 08             	pushl  0x8(%ebp)
  802a42:	6a 10                	push   $0x10
  802a44:	e8 97 fe ff ff       	call   8028e0 <syscall>
  802a49:	83 c4 18             	add    $0x18,%esp
	return ;
  802a4c:	90                   	nop
}
  802a4d:	c9                   	leave  
  802a4e:	c3                   	ret    

00802a4f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802a4f:	55                   	push   %ebp
  802a50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802a52:	6a 00                	push   $0x0
  802a54:	6a 00                	push   $0x0
  802a56:	ff 75 10             	pushl  0x10(%ebp)
  802a59:	ff 75 0c             	pushl  0xc(%ebp)
  802a5c:	ff 75 08             	pushl  0x8(%ebp)
  802a5f:	6a 11                	push   $0x11
  802a61:	e8 7a fe ff ff       	call   8028e0 <syscall>
  802a66:	83 c4 18             	add    $0x18,%esp
	return ;
  802a69:	90                   	nop
}
  802a6a:	c9                   	leave  
  802a6b:	c3                   	ret    

00802a6c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802a6c:	55                   	push   %ebp
  802a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802a6f:	6a 00                	push   $0x0
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	6a 00                	push   $0x0
  802a79:	6a 0c                	push   $0xc
  802a7b:	e8 60 fe ff ff       	call   8028e0 <syscall>
  802a80:	83 c4 18             	add    $0x18,%esp
}
  802a83:	c9                   	leave  
  802a84:	c3                   	ret    

00802a85 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802a85:	55                   	push   %ebp
  802a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802a88:	6a 00                	push   $0x0
  802a8a:	6a 00                	push   $0x0
  802a8c:	6a 00                	push   $0x0
  802a8e:	6a 00                	push   $0x0
  802a90:	ff 75 08             	pushl  0x8(%ebp)
  802a93:	6a 0d                	push   $0xd
  802a95:	e8 46 fe ff ff       	call   8028e0 <syscall>
  802a9a:	83 c4 18             	add    $0x18,%esp
}
  802a9d:	c9                   	leave  
  802a9e:	c3                   	ret    

00802a9f <sys_scarce_memory>:

void sys_scarce_memory()
{
  802a9f:	55                   	push   %ebp
  802aa0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802aa2:	6a 00                	push   $0x0
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 0e                	push   $0xe
  802aae:	e8 2d fe ff ff       	call   8028e0 <syscall>
  802ab3:	83 c4 18             	add    $0x18,%esp
}
  802ab6:	90                   	nop
  802ab7:	c9                   	leave  
  802ab8:	c3                   	ret    

00802ab9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802ab9:	55                   	push   %ebp
  802aba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802abc:	6a 00                	push   $0x0
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	6a 00                	push   $0x0
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 13                	push   $0x13
  802ac8:	e8 13 fe ff ff       	call   8028e0 <syscall>
  802acd:	83 c4 18             	add    $0x18,%esp
}
  802ad0:	90                   	nop
  802ad1:	c9                   	leave  
  802ad2:	c3                   	ret    

00802ad3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802ad3:	55                   	push   %ebp
  802ad4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802ad6:	6a 00                	push   $0x0
  802ad8:	6a 00                	push   $0x0
  802ada:	6a 00                	push   $0x0
  802adc:	6a 00                	push   $0x0
  802ade:	6a 00                	push   $0x0
  802ae0:	6a 14                	push   $0x14
  802ae2:	e8 f9 fd ff ff       	call   8028e0 <syscall>
  802ae7:	83 c4 18             	add    $0x18,%esp
}
  802aea:	90                   	nop
  802aeb:	c9                   	leave  
  802aec:	c3                   	ret    

00802aed <sys_cputc>:


void
sys_cputc(const char c)
{
  802aed:	55                   	push   %ebp
  802aee:	89 e5                	mov    %esp,%ebp
  802af0:	83 ec 04             	sub    $0x4,%esp
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802af9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802afd:	6a 00                	push   $0x0
  802aff:	6a 00                	push   $0x0
  802b01:	6a 00                	push   $0x0
  802b03:	6a 00                	push   $0x0
  802b05:	50                   	push   %eax
  802b06:	6a 15                	push   $0x15
  802b08:	e8 d3 fd ff ff       	call   8028e0 <syscall>
  802b0d:	83 c4 18             	add    $0x18,%esp
}
  802b10:	90                   	nop
  802b11:	c9                   	leave  
  802b12:	c3                   	ret    

00802b13 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802b13:	55                   	push   %ebp
  802b14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802b16:	6a 00                	push   $0x0
  802b18:	6a 00                	push   $0x0
  802b1a:	6a 00                	push   $0x0
  802b1c:	6a 00                	push   $0x0
  802b1e:	6a 00                	push   $0x0
  802b20:	6a 16                	push   $0x16
  802b22:	e8 b9 fd ff ff       	call   8028e0 <syscall>
  802b27:	83 c4 18             	add    $0x18,%esp
}
  802b2a:	90                   	nop
  802b2b:	c9                   	leave  
  802b2c:	c3                   	ret    

00802b2d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802b2d:	55                   	push   %ebp
  802b2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	6a 00                	push   $0x0
  802b35:	6a 00                	push   $0x0
  802b37:	6a 00                	push   $0x0
  802b39:	ff 75 0c             	pushl  0xc(%ebp)
  802b3c:	50                   	push   %eax
  802b3d:	6a 17                	push   $0x17
  802b3f:	e8 9c fd ff ff       	call   8028e0 <syscall>
  802b44:	83 c4 18             	add    $0x18,%esp
}
  802b47:	c9                   	leave  
  802b48:	c3                   	ret    

00802b49 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802b49:	55                   	push   %ebp
  802b4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	6a 00                	push   $0x0
  802b54:	6a 00                	push   $0x0
  802b56:	6a 00                	push   $0x0
  802b58:	52                   	push   %edx
  802b59:	50                   	push   %eax
  802b5a:	6a 1a                	push   $0x1a
  802b5c:	e8 7f fd ff ff       	call   8028e0 <syscall>
  802b61:	83 c4 18             	add    $0x18,%esp
}
  802b64:	c9                   	leave  
  802b65:	c3                   	ret    

00802b66 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802b66:	55                   	push   %ebp
  802b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	6a 00                	push   $0x0
  802b71:	6a 00                	push   $0x0
  802b73:	6a 00                	push   $0x0
  802b75:	52                   	push   %edx
  802b76:	50                   	push   %eax
  802b77:	6a 18                	push   $0x18
  802b79:	e8 62 fd ff ff       	call   8028e0 <syscall>
  802b7e:	83 c4 18             	add    $0x18,%esp
}
  802b81:	90                   	nop
  802b82:	c9                   	leave  
  802b83:	c3                   	ret    

00802b84 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802b84:	55                   	push   %ebp
  802b85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	6a 00                	push   $0x0
  802b8f:	6a 00                	push   $0x0
  802b91:	6a 00                	push   $0x0
  802b93:	52                   	push   %edx
  802b94:	50                   	push   %eax
  802b95:	6a 19                	push   $0x19
  802b97:	e8 44 fd ff ff       	call   8028e0 <syscall>
  802b9c:	83 c4 18             	add    $0x18,%esp
}
  802b9f:	90                   	nop
  802ba0:	c9                   	leave  
  802ba1:	c3                   	ret    

00802ba2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802ba2:	55                   	push   %ebp
  802ba3:	89 e5                	mov    %esp,%ebp
  802ba5:	83 ec 04             	sub    $0x4,%esp
  802ba8:	8b 45 10             	mov    0x10(%ebp),%eax
  802bab:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802bae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802bb1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	6a 00                	push   $0x0
  802bba:	51                   	push   %ecx
  802bbb:	52                   	push   %edx
  802bbc:	ff 75 0c             	pushl  0xc(%ebp)
  802bbf:	50                   	push   %eax
  802bc0:	6a 1b                	push   $0x1b
  802bc2:	e8 19 fd ff ff       	call   8028e0 <syscall>
  802bc7:	83 c4 18             	add    $0x18,%esp
}
  802bca:	c9                   	leave  
  802bcb:	c3                   	ret    

00802bcc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802bcc:	55                   	push   %ebp
  802bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	6a 00                	push   $0x0
  802bd7:	6a 00                	push   $0x0
  802bd9:	6a 00                	push   $0x0
  802bdb:	52                   	push   %edx
  802bdc:	50                   	push   %eax
  802bdd:	6a 1c                	push   $0x1c
  802bdf:	e8 fc fc ff ff       	call   8028e0 <syscall>
  802be4:	83 c4 18             	add    $0x18,%esp
}
  802be7:	c9                   	leave  
  802be8:	c3                   	ret    

00802be9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802be9:	55                   	push   %ebp
  802bea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802bec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802bef:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	6a 00                	push   $0x0
  802bf7:	6a 00                	push   $0x0
  802bf9:	51                   	push   %ecx
  802bfa:	52                   	push   %edx
  802bfb:	50                   	push   %eax
  802bfc:	6a 1d                	push   $0x1d
  802bfe:	e8 dd fc ff ff       	call   8028e0 <syscall>
  802c03:	83 c4 18             	add    $0x18,%esp
}
  802c06:	c9                   	leave  
  802c07:	c3                   	ret    

00802c08 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802c08:	55                   	push   %ebp
  802c09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	6a 00                	push   $0x0
  802c13:	6a 00                	push   $0x0
  802c15:	6a 00                	push   $0x0
  802c17:	52                   	push   %edx
  802c18:	50                   	push   %eax
  802c19:	6a 1e                	push   $0x1e
  802c1b:	e8 c0 fc ff ff       	call   8028e0 <syscall>
  802c20:	83 c4 18             	add    $0x18,%esp
}
  802c23:	c9                   	leave  
  802c24:	c3                   	ret    

00802c25 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802c25:	55                   	push   %ebp
  802c26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802c28:	6a 00                	push   $0x0
  802c2a:	6a 00                	push   $0x0
  802c2c:	6a 00                	push   $0x0
  802c2e:	6a 00                	push   $0x0
  802c30:	6a 00                	push   $0x0
  802c32:	6a 1f                	push   $0x1f
  802c34:	e8 a7 fc ff ff       	call   8028e0 <syscall>
  802c39:	83 c4 18             	add    $0x18,%esp
}
  802c3c:	c9                   	leave  
  802c3d:	c3                   	ret    

00802c3e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802c3e:	55                   	push   %ebp
  802c3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	6a 00                	push   $0x0
  802c46:	ff 75 14             	pushl  0x14(%ebp)
  802c49:	ff 75 10             	pushl  0x10(%ebp)
  802c4c:	ff 75 0c             	pushl  0xc(%ebp)
  802c4f:	50                   	push   %eax
  802c50:	6a 20                	push   $0x20
  802c52:	e8 89 fc ff ff       	call   8028e0 <syscall>
  802c57:	83 c4 18             	add    $0x18,%esp
}
  802c5a:	c9                   	leave  
  802c5b:	c3                   	ret    

00802c5c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802c5c:	55                   	push   %ebp
  802c5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	6a 00                	push   $0x0
  802c64:	6a 00                	push   $0x0
  802c66:	6a 00                	push   $0x0
  802c68:	6a 00                	push   $0x0
  802c6a:	50                   	push   %eax
  802c6b:	6a 21                	push   $0x21
  802c6d:	e8 6e fc ff ff       	call   8028e0 <syscall>
  802c72:	83 c4 18             	add    $0x18,%esp
}
  802c75:	90                   	nop
  802c76:	c9                   	leave  
  802c77:	c3                   	ret    

00802c78 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802c78:	55                   	push   %ebp
  802c79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	6a 00                	push   $0x0
  802c80:	6a 00                	push   $0x0
  802c82:	6a 00                	push   $0x0
  802c84:	6a 00                	push   $0x0
  802c86:	50                   	push   %eax
  802c87:	6a 22                	push   $0x22
  802c89:	e8 52 fc ff ff       	call   8028e0 <syscall>
  802c8e:	83 c4 18             	add    $0x18,%esp
}
  802c91:	c9                   	leave  
  802c92:	c3                   	ret    

00802c93 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802c93:	55                   	push   %ebp
  802c94:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802c96:	6a 00                	push   $0x0
  802c98:	6a 00                	push   $0x0
  802c9a:	6a 00                	push   $0x0
  802c9c:	6a 00                	push   $0x0
  802c9e:	6a 00                	push   $0x0
  802ca0:	6a 02                	push   $0x2
  802ca2:	e8 39 fc ff ff       	call   8028e0 <syscall>
  802ca7:	83 c4 18             	add    $0x18,%esp
}
  802caa:	c9                   	leave  
  802cab:	c3                   	ret    

00802cac <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802cac:	55                   	push   %ebp
  802cad:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802caf:	6a 00                	push   $0x0
  802cb1:	6a 00                	push   $0x0
  802cb3:	6a 00                	push   $0x0
  802cb5:	6a 00                	push   $0x0
  802cb7:	6a 00                	push   $0x0
  802cb9:	6a 03                	push   $0x3
  802cbb:	e8 20 fc ff ff       	call   8028e0 <syscall>
  802cc0:	83 c4 18             	add    $0x18,%esp
}
  802cc3:	c9                   	leave  
  802cc4:	c3                   	ret    

00802cc5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802cc5:	55                   	push   %ebp
  802cc6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802cc8:	6a 00                	push   $0x0
  802cca:	6a 00                	push   $0x0
  802ccc:	6a 00                	push   $0x0
  802cce:	6a 00                	push   $0x0
  802cd0:	6a 00                	push   $0x0
  802cd2:	6a 04                	push   $0x4
  802cd4:	e8 07 fc ff ff       	call   8028e0 <syscall>
  802cd9:	83 c4 18             	add    $0x18,%esp
}
  802cdc:	c9                   	leave  
  802cdd:	c3                   	ret    

00802cde <sys_exit_env>:


void sys_exit_env(void)
{
  802cde:	55                   	push   %ebp
  802cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802ce1:	6a 00                	push   $0x0
  802ce3:	6a 00                	push   $0x0
  802ce5:	6a 00                	push   $0x0
  802ce7:	6a 00                	push   $0x0
  802ce9:	6a 00                	push   $0x0
  802ceb:	6a 23                	push   $0x23
  802ced:	e8 ee fb ff ff       	call   8028e0 <syscall>
  802cf2:	83 c4 18             	add    $0x18,%esp
}
  802cf5:	90                   	nop
  802cf6:	c9                   	leave  
  802cf7:	c3                   	ret    

00802cf8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802cf8:	55                   	push   %ebp
  802cf9:	89 e5                	mov    %esp,%ebp
  802cfb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802cfe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802d01:	8d 50 04             	lea    0x4(%eax),%edx
  802d04:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802d07:	6a 00                	push   $0x0
  802d09:	6a 00                	push   $0x0
  802d0b:	6a 00                	push   $0x0
  802d0d:	52                   	push   %edx
  802d0e:	50                   	push   %eax
  802d0f:	6a 24                	push   $0x24
  802d11:	e8 ca fb ff ff       	call   8028e0 <syscall>
  802d16:	83 c4 18             	add    $0x18,%esp
	return result;
  802d19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802d1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d22:	89 01                	mov    %eax,(%ecx)
  802d24:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	c9                   	leave  
  802d2b:	c2 04 00             	ret    $0x4

00802d2e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802d2e:	55                   	push   %ebp
  802d2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802d31:	6a 00                	push   $0x0
  802d33:	6a 00                	push   $0x0
  802d35:	ff 75 10             	pushl  0x10(%ebp)
  802d38:	ff 75 0c             	pushl  0xc(%ebp)
  802d3b:	ff 75 08             	pushl  0x8(%ebp)
  802d3e:	6a 12                	push   $0x12
  802d40:	e8 9b fb ff ff       	call   8028e0 <syscall>
  802d45:	83 c4 18             	add    $0x18,%esp
	return ;
  802d48:	90                   	nop
}
  802d49:	c9                   	leave  
  802d4a:	c3                   	ret    

00802d4b <sys_rcr2>:
uint32 sys_rcr2()
{
  802d4b:	55                   	push   %ebp
  802d4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802d4e:	6a 00                	push   $0x0
  802d50:	6a 00                	push   $0x0
  802d52:	6a 00                	push   $0x0
  802d54:	6a 00                	push   $0x0
  802d56:	6a 00                	push   $0x0
  802d58:	6a 25                	push   $0x25
  802d5a:	e8 81 fb ff ff       	call   8028e0 <syscall>
  802d5f:	83 c4 18             	add    $0x18,%esp
}
  802d62:	c9                   	leave  
  802d63:	c3                   	ret    

00802d64 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802d64:	55                   	push   %ebp
  802d65:	89 e5                	mov    %esp,%ebp
  802d67:	83 ec 04             	sub    $0x4,%esp
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802d70:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802d74:	6a 00                	push   $0x0
  802d76:	6a 00                	push   $0x0
  802d78:	6a 00                	push   $0x0
  802d7a:	6a 00                	push   $0x0
  802d7c:	50                   	push   %eax
  802d7d:	6a 26                	push   $0x26
  802d7f:	e8 5c fb ff ff       	call   8028e0 <syscall>
  802d84:	83 c4 18             	add    $0x18,%esp
	return ;
  802d87:	90                   	nop
}
  802d88:	c9                   	leave  
  802d89:	c3                   	ret    

00802d8a <rsttst>:
void rsttst()
{
  802d8a:	55                   	push   %ebp
  802d8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802d8d:	6a 00                	push   $0x0
  802d8f:	6a 00                	push   $0x0
  802d91:	6a 00                	push   $0x0
  802d93:	6a 00                	push   $0x0
  802d95:	6a 00                	push   $0x0
  802d97:	6a 28                	push   $0x28
  802d99:	e8 42 fb ff ff       	call   8028e0 <syscall>
  802d9e:	83 c4 18             	add    $0x18,%esp
	return ;
  802da1:	90                   	nop
}
  802da2:	c9                   	leave  
  802da3:	c3                   	ret    

00802da4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802da4:	55                   	push   %ebp
  802da5:	89 e5                	mov    %esp,%ebp
  802da7:	83 ec 04             	sub    $0x4,%esp
  802daa:	8b 45 14             	mov    0x14(%ebp),%eax
  802dad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802db0:	8b 55 18             	mov    0x18(%ebp),%edx
  802db3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802db7:	52                   	push   %edx
  802db8:	50                   	push   %eax
  802db9:	ff 75 10             	pushl  0x10(%ebp)
  802dbc:	ff 75 0c             	pushl  0xc(%ebp)
  802dbf:	ff 75 08             	pushl  0x8(%ebp)
  802dc2:	6a 27                	push   $0x27
  802dc4:	e8 17 fb ff ff       	call   8028e0 <syscall>
  802dc9:	83 c4 18             	add    $0x18,%esp
	return ;
  802dcc:	90                   	nop
}
  802dcd:	c9                   	leave  
  802dce:	c3                   	ret    

00802dcf <chktst>:
void chktst(uint32 n)
{
  802dcf:	55                   	push   %ebp
  802dd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802dd2:	6a 00                	push   $0x0
  802dd4:	6a 00                	push   $0x0
  802dd6:	6a 00                	push   $0x0
  802dd8:	6a 00                	push   $0x0
  802dda:	ff 75 08             	pushl  0x8(%ebp)
  802ddd:	6a 29                	push   $0x29
  802ddf:	e8 fc fa ff ff       	call   8028e0 <syscall>
  802de4:	83 c4 18             	add    $0x18,%esp
	return ;
  802de7:	90                   	nop
}
  802de8:	c9                   	leave  
  802de9:	c3                   	ret    

00802dea <inctst>:

void inctst()
{
  802dea:	55                   	push   %ebp
  802deb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802ded:	6a 00                	push   $0x0
  802def:	6a 00                	push   $0x0
  802df1:	6a 00                	push   $0x0
  802df3:	6a 00                	push   $0x0
  802df5:	6a 00                	push   $0x0
  802df7:	6a 2a                	push   $0x2a
  802df9:	e8 e2 fa ff ff       	call   8028e0 <syscall>
  802dfe:	83 c4 18             	add    $0x18,%esp
	return ;
  802e01:	90                   	nop
}
  802e02:	c9                   	leave  
  802e03:	c3                   	ret    

00802e04 <gettst>:
uint32 gettst()
{
  802e04:	55                   	push   %ebp
  802e05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802e07:	6a 00                	push   $0x0
  802e09:	6a 00                	push   $0x0
  802e0b:	6a 00                	push   $0x0
  802e0d:	6a 00                	push   $0x0
  802e0f:	6a 00                	push   $0x0
  802e11:	6a 2b                	push   $0x2b
  802e13:	e8 c8 fa ff ff       	call   8028e0 <syscall>
  802e18:	83 c4 18             	add    $0x18,%esp
}
  802e1b:	c9                   	leave  
  802e1c:	c3                   	ret    

00802e1d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802e1d:	55                   	push   %ebp
  802e1e:	89 e5                	mov    %esp,%ebp
  802e20:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e23:	6a 00                	push   $0x0
  802e25:	6a 00                	push   $0x0
  802e27:	6a 00                	push   $0x0
  802e29:	6a 00                	push   $0x0
  802e2b:	6a 00                	push   $0x0
  802e2d:	6a 2c                	push   $0x2c
  802e2f:	e8 ac fa ff ff       	call   8028e0 <syscall>
  802e34:	83 c4 18             	add    $0x18,%esp
  802e37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802e3a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802e3e:	75 07                	jne    802e47 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802e40:	b8 01 00 00 00       	mov    $0x1,%eax
  802e45:	eb 05                	jmp    802e4c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e4c:	c9                   	leave  
  802e4d:	c3                   	ret    

00802e4e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802e4e:	55                   	push   %ebp
  802e4f:	89 e5                	mov    %esp,%ebp
  802e51:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e54:	6a 00                	push   $0x0
  802e56:	6a 00                	push   $0x0
  802e58:	6a 00                	push   $0x0
  802e5a:	6a 00                	push   $0x0
  802e5c:	6a 00                	push   $0x0
  802e5e:	6a 2c                	push   $0x2c
  802e60:	e8 7b fa ff ff       	call   8028e0 <syscall>
  802e65:	83 c4 18             	add    $0x18,%esp
  802e68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802e6b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802e6f:	75 07                	jne    802e78 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802e71:	b8 01 00 00 00       	mov    $0x1,%eax
  802e76:	eb 05                	jmp    802e7d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802e78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e7d:	c9                   	leave  
  802e7e:	c3                   	ret    

00802e7f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802e7f:	55                   	push   %ebp
  802e80:	89 e5                	mov    %esp,%ebp
  802e82:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e85:	6a 00                	push   $0x0
  802e87:	6a 00                	push   $0x0
  802e89:	6a 00                	push   $0x0
  802e8b:	6a 00                	push   $0x0
  802e8d:	6a 00                	push   $0x0
  802e8f:	6a 2c                	push   $0x2c
  802e91:	e8 4a fa ff ff       	call   8028e0 <syscall>
  802e96:	83 c4 18             	add    $0x18,%esp
  802e99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802e9c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802ea0:	75 07                	jne    802ea9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802ea2:	b8 01 00 00 00       	mov    $0x1,%eax
  802ea7:	eb 05                	jmp    802eae <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802ea9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eae:	c9                   	leave  
  802eaf:	c3                   	ret    

00802eb0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802eb0:	55                   	push   %ebp
  802eb1:	89 e5                	mov    %esp,%ebp
  802eb3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 00                	push   $0x0
  802ebe:	6a 00                	push   $0x0
  802ec0:	6a 2c                	push   $0x2c
  802ec2:	e8 19 fa ff ff       	call   8028e0 <syscall>
  802ec7:	83 c4 18             	add    $0x18,%esp
  802eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802ecd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802ed1:	75 07                	jne    802eda <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802ed3:	b8 01 00 00 00       	mov    $0x1,%eax
  802ed8:	eb 05                	jmp    802edf <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802eda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802edf:	c9                   	leave  
  802ee0:	c3                   	ret    

00802ee1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ee1:	55                   	push   %ebp
  802ee2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802ee4:	6a 00                	push   $0x0
  802ee6:	6a 00                	push   $0x0
  802ee8:	6a 00                	push   $0x0
  802eea:	6a 00                	push   $0x0
  802eec:	ff 75 08             	pushl  0x8(%ebp)
  802eef:	6a 2d                	push   $0x2d
  802ef1:	e8 ea f9 ff ff       	call   8028e0 <syscall>
  802ef6:	83 c4 18             	add    $0x18,%esp
	return ;
  802ef9:	90                   	nop
}
  802efa:	c9                   	leave  
  802efb:	c3                   	ret    

00802efc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802efc:	55                   	push   %ebp
  802efd:	89 e5                	mov    %esp,%ebp
  802eff:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802f00:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f03:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	6a 00                	push   $0x0
  802f0e:	53                   	push   %ebx
  802f0f:	51                   	push   %ecx
  802f10:	52                   	push   %edx
  802f11:	50                   	push   %eax
  802f12:	6a 2e                	push   $0x2e
  802f14:	e8 c7 f9 ff ff       	call   8028e0 <syscall>
  802f19:	83 c4 18             	add    $0x18,%esp
}
  802f1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f1f:	c9                   	leave  
  802f20:	c3                   	ret    

00802f21 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802f21:	55                   	push   %ebp
  802f22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	6a 00                	push   $0x0
  802f2c:	6a 00                	push   $0x0
  802f2e:	6a 00                	push   $0x0
  802f30:	52                   	push   %edx
  802f31:	50                   	push   %eax
  802f32:	6a 2f                	push   $0x2f
  802f34:	e8 a7 f9 ff ff       	call   8028e0 <syscall>
  802f39:	83 c4 18             	add    $0x18,%esp
}
  802f3c:	c9                   	leave  
  802f3d:	c3                   	ret    

00802f3e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802f3e:	55                   	push   %ebp
  802f3f:	89 e5                	mov    %esp,%ebp
  802f41:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802f44:	83 ec 0c             	sub    $0xc,%esp
  802f47:	68 24 53 80 00       	push   $0x805324
  802f4c:	e8 8c e7 ff ff       	call   8016dd <cprintf>
  802f51:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802f54:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802f5b:	83 ec 0c             	sub    $0xc,%esp
  802f5e:	68 50 53 80 00       	push   $0x805350
  802f63:	e8 75 e7 ff ff       	call   8016dd <cprintf>
  802f68:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802f6b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f6f:	a1 38 61 80 00       	mov    0x806138,%eax
  802f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f77:	eb 56                	jmp    802fcf <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802f79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f7d:	74 1c                	je     802f9b <print_mem_block_lists+0x5d>
  802f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f82:	8b 50 08             	mov    0x8(%eax),%edx
  802f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f88:	8b 48 08             	mov    0x8(%eax),%ecx
  802f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f91:	01 c8                	add    %ecx,%eax
  802f93:	39 c2                	cmp    %eax,%edx
  802f95:	73 04                	jae    802f9b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802f97:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9e:	8b 50 08             	mov    0x8(%eax),%edx
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa7:	01 c2                	add    %eax,%edx
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	8b 40 08             	mov    0x8(%eax),%eax
  802faf:	83 ec 04             	sub    $0x4,%esp
  802fb2:	52                   	push   %edx
  802fb3:	50                   	push   %eax
  802fb4:	68 65 53 80 00       	push   $0x805365
  802fb9:	e8 1f e7 ff ff       	call   8016dd <cprintf>
  802fbe:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802fc7:	a1 40 61 80 00       	mov    0x806140,%eax
  802fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd3:	74 07                	je     802fdc <print_mem_block_lists+0x9e>
  802fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	eb 05                	jmp    802fe1 <print_mem_block_lists+0xa3>
  802fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe1:	a3 40 61 80 00       	mov    %eax,0x806140
  802fe6:	a1 40 61 80 00       	mov    0x806140,%eax
  802feb:	85 c0                	test   %eax,%eax
  802fed:	75 8a                	jne    802f79 <print_mem_block_lists+0x3b>
  802fef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff3:	75 84                	jne    802f79 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802ff5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802ff9:	75 10                	jne    80300b <print_mem_block_lists+0xcd>
  802ffb:	83 ec 0c             	sub    $0xc,%esp
  802ffe:	68 74 53 80 00       	push   $0x805374
  803003:	e8 d5 e6 ff ff       	call   8016dd <cprintf>
  803008:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80300b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  803012:	83 ec 0c             	sub    $0xc,%esp
  803015:	68 98 53 80 00       	push   $0x805398
  80301a:	e8 be e6 ff ff       	call   8016dd <cprintf>
  80301f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  803022:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803026:	a1 40 60 80 00       	mov    0x806040,%eax
  80302b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80302e:	eb 56                	jmp    803086 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803030:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803034:	74 1c                	je     803052 <print_mem_block_lists+0x114>
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	8b 50 08             	mov    0x8(%eax),%edx
  80303c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303f:	8b 48 08             	mov    0x8(%eax),%ecx
  803042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803045:	8b 40 0c             	mov    0xc(%eax),%eax
  803048:	01 c8                	add    %ecx,%eax
  80304a:	39 c2                	cmp    %eax,%edx
  80304c:	73 04                	jae    803052 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80304e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 50 08             	mov    0x8(%eax),%edx
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 40 0c             	mov    0xc(%eax),%eax
  80305e:	01 c2                	add    %eax,%edx
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	8b 40 08             	mov    0x8(%eax),%eax
  803066:	83 ec 04             	sub    $0x4,%esp
  803069:	52                   	push   %edx
  80306a:	50                   	push   %eax
  80306b:	68 65 53 80 00       	push   $0x805365
  803070:	e8 68 e6 ff ff       	call   8016dd <cprintf>
  803075:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80307e:	a1 48 60 80 00       	mov    0x806048,%eax
  803083:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803086:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80308a:	74 07                	je     803093 <print_mem_block_lists+0x155>
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	eb 05                	jmp    803098 <print_mem_block_lists+0x15a>
  803093:	b8 00 00 00 00       	mov    $0x0,%eax
  803098:	a3 48 60 80 00       	mov    %eax,0x806048
  80309d:	a1 48 60 80 00       	mov    0x806048,%eax
  8030a2:	85 c0                	test   %eax,%eax
  8030a4:	75 8a                	jne    803030 <print_mem_block_lists+0xf2>
  8030a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030aa:	75 84                	jne    803030 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8030ac:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8030b0:	75 10                	jne    8030c2 <print_mem_block_lists+0x184>
  8030b2:	83 ec 0c             	sub    $0xc,%esp
  8030b5:	68 b0 53 80 00       	push   $0x8053b0
  8030ba:	e8 1e e6 ff ff       	call   8016dd <cprintf>
  8030bf:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8030c2:	83 ec 0c             	sub    $0xc,%esp
  8030c5:	68 24 53 80 00       	push   $0x805324
  8030ca:	e8 0e e6 ff ff       	call   8016dd <cprintf>
  8030cf:	83 c4 10             	add    $0x10,%esp

}
  8030d2:	90                   	nop
  8030d3:	c9                   	leave  
  8030d4:	c3                   	ret    

008030d5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8030d5:	55                   	push   %ebp
  8030d6:	89 e5                	mov    %esp,%ebp
  8030d8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8030db:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  8030e2:	00 00 00 
  8030e5:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  8030ec:	00 00 00 
  8030ef:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  8030f6:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8030f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803100:	e9 9e 00 00 00       	jmp    8031a3 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  803105:	a1 50 60 80 00       	mov    0x806050,%eax
  80310a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310d:	c1 e2 04             	shl    $0x4,%edx
  803110:	01 d0                	add    %edx,%eax
  803112:	85 c0                	test   %eax,%eax
  803114:	75 14                	jne    80312a <initialize_MemBlocksList+0x55>
  803116:	83 ec 04             	sub    $0x4,%esp
  803119:	68 d8 53 80 00       	push   $0x8053d8
  80311e:	6a 46                	push   $0x46
  803120:	68 fb 53 80 00       	push   $0x8053fb
  803125:	e8 ff e2 ff ff       	call   801429 <_panic>
  80312a:	a1 50 60 80 00       	mov    0x806050,%eax
  80312f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803132:	c1 e2 04             	shl    $0x4,%edx
  803135:	01 d0                	add    %edx,%eax
  803137:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80313d:	89 10                	mov    %edx,(%eax)
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	74 18                	je     80315d <initialize_MemBlocksList+0x88>
  803145:	a1 48 61 80 00       	mov    0x806148,%eax
  80314a:	8b 15 50 60 80 00    	mov    0x806050,%edx
  803150:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803153:	c1 e1 04             	shl    $0x4,%ecx
  803156:	01 ca                	add    %ecx,%edx
  803158:	89 50 04             	mov    %edx,0x4(%eax)
  80315b:	eb 12                	jmp    80316f <initialize_MemBlocksList+0x9a>
  80315d:	a1 50 60 80 00       	mov    0x806050,%eax
  803162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803165:	c1 e2 04             	shl    $0x4,%edx
  803168:	01 d0                	add    %edx,%eax
  80316a:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80316f:	a1 50 60 80 00       	mov    0x806050,%eax
  803174:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803177:	c1 e2 04             	shl    $0x4,%edx
  80317a:	01 d0                	add    %edx,%eax
  80317c:	a3 48 61 80 00       	mov    %eax,0x806148
  803181:	a1 50 60 80 00       	mov    0x806050,%eax
  803186:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803189:	c1 e2 04             	shl    $0x4,%edx
  80318c:	01 d0                	add    %edx,%eax
  80318e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803195:	a1 54 61 80 00       	mov    0x806154,%eax
  80319a:	40                   	inc    %eax
  80319b:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8031a0:	ff 45 f4             	incl   -0xc(%ebp)
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031a9:	0f 82 56 ff ff ff    	jb     803105 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8031af:	90                   	nop
  8031b0:	c9                   	leave  
  8031b1:	c3                   	ret    

008031b2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8031b2:	55                   	push   %ebp
  8031b3:	89 e5                	mov    %esp,%ebp
  8031b5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	8b 00                	mov    (%eax),%eax
  8031bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8031c0:	eb 19                	jmp    8031db <find_block+0x29>
	{
		if(va==point->sva)
  8031c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031c5:	8b 40 08             	mov    0x8(%eax),%eax
  8031c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031cb:	75 05                	jne    8031d2 <find_block+0x20>
		   return point;
  8031cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031d0:	eb 36                	jmp    803208 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	8b 40 08             	mov    0x8(%eax),%eax
  8031d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8031db:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8031df:	74 07                	je     8031e8 <find_block+0x36>
  8031e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031e4:	8b 00                	mov    (%eax),%eax
  8031e6:	eb 05                	jmp    8031ed <find_block+0x3b>
  8031e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f0:	89 42 08             	mov    %eax,0x8(%edx)
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	8b 40 08             	mov    0x8(%eax),%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	75 c5                	jne    8031c2 <find_block+0x10>
  8031fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803201:	75 bf                	jne    8031c2 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  803203:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803208:	c9                   	leave  
  803209:	c3                   	ret    

0080320a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80320a:	55                   	push   %ebp
  80320b:	89 e5                	mov    %esp,%ebp
  80320d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  803210:	a1 40 60 80 00       	mov    0x806040,%eax
  803215:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  803218:	a1 44 60 80 00       	mov    0x806044,%eax
  80321d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  803220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803223:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803226:	74 24                	je     80324c <insert_sorted_allocList+0x42>
  803228:	8b 45 08             	mov    0x8(%ebp),%eax
  80322b:	8b 50 08             	mov    0x8(%eax),%edx
  80322e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803231:	8b 40 08             	mov    0x8(%eax),%eax
  803234:	39 c2                	cmp    %eax,%edx
  803236:	76 14                	jbe    80324c <insert_sorted_allocList+0x42>
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	8b 50 08             	mov    0x8(%eax),%edx
  80323e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803241:	8b 40 08             	mov    0x8(%eax),%eax
  803244:	39 c2                	cmp    %eax,%edx
  803246:	0f 82 60 01 00 00    	jb     8033ac <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80324c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803250:	75 65                	jne    8032b7 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  803252:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803256:	75 14                	jne    80326c <insert_sorted_allocList+0x62>
  803258:	83 ec 04             	sub    $0x4,%esp
  80325b:	68 d8 53 80 00       	push   $0x8053d8
  803260:	6a 6b                	push   $0x6b
  803262:	68 fb 53 80 00       	push   $0x8053fb
  803267:	e8 bd e1 ff ff       	call   801429 <_panic>
  80326c:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	89 10                	mov    %edx,(%eax)
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	85 c0                	test   %eax,%eax
  80327e:	74 0d                	je     80328d <insert_sorted_allocList+0x83>
  803280:	a1 40 60 80 00       	mov    0x806040,%eax
  803285:	8b 55 08             	mov    0x8(%ebp),%edx
  803288:	89 50 04             	mov    %edx,0x4(%eax)
  80328b:	eb 08                	jmp    803295 <insert_sorted_allocList+0x8b>
  80328d:	8b 45 08             	mov    0x8(%ebp),%eax
  803290:	a3 44 60 80 00       	mov    %eax,0x806044
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	a3 40 60 80 00       	mov    %eax,0x806040
  80329d:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a7:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8032ac:	40                   	inc    %eax
  8032ad:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8032b2:	e9 dc 01 00 00       	jmp    803493 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	8b 50 08             	mov    0x8(%eax),%edx
  8032bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c0:	8b 40 08             	mov    0x8(%eax),%eax
  8032c3:	39 c2                	cmp    %eax,%edx
  8032c5:	77 6c                	ja     803333 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8032c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032cb:	74 06                	je     8032d3 <insert_sorted_allocList+0xc9>
  8032cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d1:	75 14                	jne    8032e7 <insert_sorted_allocList+0xdd>
  8032d3:	83 ec 04             	sub    $0x4,%esp
  8032d6:	68 14 54 80 00       	push   $0x805414
  8032db:	6a 6f                	push   $0x6f
  8032dd:	68 fb 53 80 00       	push   $0x8053fb
  8032e2:	e8 42 e1 ff ff       	call   801429 <_panic>
  8032e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ea:	8b 50 04             	mov    0x4(%eax),%edx
  8032ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f0:	89 50 04             	mov    %edx,0x4(%eax)
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032f9:	89 10                	mov    %edx,(%eax)
  8032fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fe:	8b 40 04             	mov    0x4(%eax),%eax
  803301:	85 c0                	test   %eax,%eax
  803303:	74 0d                	je     803312 <insert_sorted_allocList+0x108>
  803305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803308:	8b 40 04             	mov    0x4(%eax),%eax
  80330b:	8b 55 08             	mov    0x8(%ebp),%edx
  80330e:	89 10                	mov    %edx,(%eax)
  803310:	eb 08                	jmp    80331a <insert_sorted_allocList+0x110>
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	a3 40 60 80 00       	mov    %eax,0x806040
  80331a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331d:	8b 55 08             	mov    0x8(%ebp),%edx
  803320:	89 50 04             	mov    %edx,0x4(%eax)
  803323:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803328:	40                   	inc    %eax
  803329:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80332e:	e9 60 01 00 00       	jmp    803493 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	8b 50 08             	mov    0x8(%eax),%edx
  803339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333c:	8b 40 08             	mov    0x8(%eax),%eax
  80333f:	39 c2                	cmp    %eax,%edx
  803341:	0f 82 4c 01 00 00    	jb     803493 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  803347:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334b:	75 14                	jne    803361 <insert_sorted_allocList+0x157>
  80334d:	83 ec 04             	sub    $0x4,%esp
  803350:	68 4c 54 80 00       	push   $0x80544c
  803355:	6a 73                	push   $0x73
  803357:	68 fb 53 80 00       	push   $0x8053fb
  80335c:	e8 c8 e0 ff ff       	call   801429 <_panic>
  803361:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	89 50 04             	mov    %edx,0x4(%eax)
  80336d:	8b 45 08             	mov    0x8(%ebp),%eax
  803370:	8b 40 04             	mov    0x4(%eax),%eax
  803373:	85 c0                	test   %eax,%eax
  803375:	74 0c                	je     803383 <insert_sorted_allocList+0x179>
  803377:	a1 44 60 80 00       	mov    0x806044,%eax
  80337c:	8b 55 08             	mov    0x8(%ebp),%edx
  80337f:	89 10                	mov    %edx,(%eax)
  803381:	eb 08                	jmp    80338b <insert_sorted_allocList+0x181>
  803383:	8b 45 08             	mov    0x8(%ebp),%eax
  803386:	a3 40 60 80 00       	mov    %eax,0x806040
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	a3 44 60 80 00       	mov    %eax,0x806044
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339c:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8033a1:	40                   	inc    %eax
  8033a2:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8033a7:	e9 e7 00 00 00       	jmp    803493 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8033ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8033b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8033b9:	a1 40 60 80 00       	mov    0x806040,%eax
  8033be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c1:	e9 9d 00 00 00       	jmp    803463 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	8b 00                	mov    (%eax),%eax
  8033cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d1:	8b 50 08             	mov    0x8(%eax),%edx
  8033d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d7:	8b 40 08             	mov    0x8(%eax),%eax
  8033da:	39 c2                	cmp    %eax,%edx
  8033dc:	76 7d                	jbe    80345b <insert_sorted_allocList+0x251>
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	8b 50 08             	mov    0x8(%eax),%edx
  8033e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e7:	8b 40 08             	mov    0x8(%eax),%eax
  8033ea:	39 c2                	cmp    %eax,%edx
  8033ec:	73 6d                	jae    80345b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8033ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f2:	74 06                	je     8033fa <insert_sorted_allocList+0x1f0>
  8033f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033f8:	75 14                	jne    80340e <insert_sorted_allocList+0x204>
  8033fa:	83 ec 04             	sub    $0x4,%esp
  8033fd:	68 70 54 80 00       	push   $0x805470
  803402:	6a 7f                	push   $0x7f
  803404:	68 fb 53 80 00       	push   $0x8053fb
  803409:	e8 1b e0 ff ff       	call   801429 <_panic>
  80340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803411:	8b 10                	mov    (%eax),%edx
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	89 10                	mov    %edx,(%eax)
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	8b 00                	mov    (%eax),%eax
  80341d:	85 c0                	test   %eax,%eax
  80341f:	74 0b                	je     80342c <insert_sorted_allocList+0x222>
  803421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803424:	8b 00                	mov    (%eax),%eax
  803426:	8b 55 08             	mov    0x8(%ebp),%edx
  803429:	89 50 04             	mov    %edx,0x4(%eax)
  80342c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342f:	8b 55 08             	mov    0x8(%ebp),%edx
  803432:	89 10                	mov    %edx,(%eax)
  803434:	8b 45 08             	mov    0x8(%ebp),%eax
  803437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80343a:	89 50 04             	mov    %edx,0x4(%eax)
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	8b 00                	mov    (%eax),%eax
  803442:	85 c0                	test   %eax,%eax
  803444:	75 08                	jne    80344e <insert_sorted_allocList+0x244>
  803446:	8b 45 08             	mov    0x8(%ebp),%eax
  803449:	a3 44 60 80 00       	mov    %eax,0x806044
  80344e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803453:	40                   	inc    %eax
  803454:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  803459:	eb 39                	jmp    803494 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80345b:	a1 48 60 80 00       	mov    0x806048,%eax
  803460:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803467:	74 07                	je     803470 <insert_sorted_allocList+0x266>
  803469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346c:	8b 00                	mov    (%eax),%eax
  80346e:	eb 05                	jmp    803475 <insert_sorted_allocList+0x26b>
  803470:	b8 00 00 00 00       	mov    $0x0,%eax
  803475:	a3 48 60 80 00       	mov    %eax,0x806048
  80347a:	a1 48 60 80 00       	mov    0x806048,%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	0f 85 3f ff ff ff    	jne    8033c6 <insert_sorted_allocList+0x1bc>
  803487:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80348b:	0f 85 35 ff ff ff    	jne    8033c6 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803491:	eb 01                	jmp    803494 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803493:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803494:	90                   	nop
  803495:	c9                   	leave  
  803496:	c3                   	ret    

00803497 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803497:	55                   	push   %ebp
  803498:	89 e5                	mov    %esp,%ebp
  80349a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80349d:	a1 38 61 80 00       	mov    0x806138,%eax
  8034a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034a5:	e9 85 01 00 00       	jmp    80362f <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8034aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034b3:	0f 82 6e 01 00 00    	jb     803627 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8034bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034c2:	0f 85 8a 00 00 00    	jne    803552 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8034c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034cc:	75 17                	jne    8034e5 <alloc_block_FF+0x4e>
  8034ce:	83 ec 04             	sub    $0x4,%esp
  8034d1:	68 a4 54 80 00       	push   $0x8054a4
  8034d6:	68 93 00 00 00       	push   $0x93
  8034db:	68 fb 53 80 00       	push   $0x8053fb
  8034e0:	e8 44 df ff ff       	call   801429 <_panic>
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	85 c0                	test   %eax,%eax
  8034ec:	74 10                	je     8034fe <alloc_block_FF+0x67>
  8034ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f1:	8b 00                	mov    (%eax),%eax
  8034f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f6:	8b 52 04             	mov    0x4(%edx),%edx
  8034f9:	89 50 04             	mov    %edx,0x4(%eax)
  8034fc:	eb 0b                	jmp    803509 <alloc_block_FF+0x72>
  8034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803501:	8b 40 04             	mov    0x4(%eax),%eax
  803504:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350c:	8b 40 04             	mov    0x4(%eax),%eax
  80350f:	85 c0                	test   %eax,%eax
  803511:	74 0f                	je     803522 <alloc_block_FF+0x8b>
  803513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803516:	8b 40 04             	mov    0x4(%eax),%eax
  803519:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80351c:	8b 12                	mov    (%edx),%edx
  80351e:	89 10                	mov    %edx,(%eax)
  803520:	eb 0a                	jmp    80352c <alloc_block_FF+0x95>
  803522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803525:	8b 00                	mov    (%eax),%eax
  803527:	a3 38 61 80 00       	mov    %eax,0x806138
  80352c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803538:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353f:	a1 44 61 80 00       	mov    0x806144,%eax
  803544:	48                   	dec    %eax
  803545:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  80354a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354d:	e9 10 01 00 00       	jmp    803662 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  803552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803555:	8b 40 0c             	mov    0xc(%eax),%eax
  803558:	3b 45 08             	cmp    0x8(%ebp),%eax
  80355b:	0f 86 c6 00 00 00    	jbe    803627 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803561:	a1 48 61 80 00       	mov    0x806148,%eax
  803566:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  803569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356c:	8b 50 08             	mov    0x8(%eax),%edx
  80356f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803572:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  803575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803578:	8b 55 08             	mov    0x8(%ebp),%edx
  80357b:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80357e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803582:	75 17                	jne    80359b <alloc_block_FF+0x104>
  803584:	83 ec 04             	sub    $0x4,%esp
  803587:	68 a4 54 80 00       	push   $0x8054a4
  80358c:	68 9b 00 00 00       	push   $0x9b
  803591:	68 fb 53 80 00       	push   $0x8053fb
  803596:	e8 8e de ff ff       	call   801429 <_panic>
  80359b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359e:	8b 00                	mov    (%eax),%eax
  8035a0:	85 c0                	test   %eax,%eax
  8035a2:	74 10                	je     8035b4 <alloc_block_FF+0x11d>
  8035a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a7:	8b 00                	mov    (%eax),%eax
  8035a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ac:	8b 52 04             	mov    0x4(%edx),%edx
  8035af:	89 50 04             	mov    %edx,0x4(%eax)
  8035b2:	eb 0b                	jmp    8035bf <alloc_block_FF+0x128>
  8035b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b7:	8b 40 04             	mov    0x4(%eax),%eax
  8035ba:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8035bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c2:	8b 40 04             	mov    0x4(%eax),%eax
  8035c5:	85 c0                	test   %eax,%eax
  8035c7:	74 0f                	je     8035d8 <alloc_block_FF+0x141>
  8035c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035cc:	8b 40 04             	mov    0x4(%eax),%eax
  8035cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035d2:	8b 12                	mov    (%edx),%edx
  8035d4:	89 10                	mov    %edx,(%eax)
  8035d6:	eb 0a                	jmp    8035e2 <alloc_block_FF+0x14b>
  8035d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035db:	8b 00                	mov    (%eax),%eax
  8035dd:	a3 48 61 80 00       	mov    %eax,0x806148
  8035e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f5:	a1 54 61 80 00       	mov    0x806154,%eax
  8035fa:	48                   	dec    %eax
  8035fb:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  803600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803603:	8b 50 08             	mov    0x8(%eax),%edx
  803606:	8b 45 08             	mov    0x8(%ebp),%eax
  803609:	01 c2                	add    %eax,%edx
  80360b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803614:	8b 40 0c             	mov    0xc(%eax),%eax
  803617:	2b 45 08             	sub    0x8(%ebp),%eax
  80361a:	89 c2                	mov    %eax,%edx
  80361c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  803622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803625:	eb 3b                	jmp    803662 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803627:	a1 40 61 80 00       	mov    0x806140,%eax
  80362c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80362f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803633:	74 07                	je     80363c <alloc_block_FF+0x1a5>
  803635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803638:	8b 00                	mov    (%eax),%eax
  80363a:	eb 05                	jmp    803641 <alloc_block_FF+0x1aa>
  80363c:	b8 00 00 00 00       	mov    $0x0,%eax
  803641:	a3 40 61 80 00       	mov    %eax,0x806140
  803646:	a1 40 61 80 00       	mov    0x806140,%eax
  80364b:	85 c0                	test   %eax,%eax
  80364d:	0f 85 57 fe ff ff    	jne    8034aa <alloc_block_FF+0x13>
  803653:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803657:	0f 85 4d fe ff ff    	jne    8034aa <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80365d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803662:	c9                   	leave  
  803663:	c3                   	ret    

00803664 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803664:	55                   	push   %ebp
  803665:	89 e5                	mov    %esp,%ebp
  803667:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80366a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803671:	a1 38 61 80 00       	mov    0x806138,%eax
  803676:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803679:	e9 df 00 00 00       	jmp    80375d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80367e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803681:	8b 40 0c             	mov    0xc(%eax),%eax
  803684:	3b 45 08             	cmp    0x8(%ebp),%eax
  803687:	0f 82 c8 00 00 00    	jb     803755 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80368d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803690:	8b 40 0c             	mov    0xc(%eax),%eax
  803693:	3b 45 08             	cmp    0x8(%ebp),%eax
  803696:	0f 85 8a 00 00 00    	jne    803726 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80369c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a0:	75 17                	jne    8036b9 <alloc_block_BF+0x55>
  8036a2:	83 ec 04             	sub    $0x4,%esp
  8036a5:	68 a4 54 80 00       	push   $0x8054a4
  8036aa:	68 b7 00 00 00       	push   $0xb7
  8036af:	68 fb 53 80 00       	push   $0x8053fb
  8036b4:	e8 70 dd ff ff       	call   801429 <_panic>
  8036b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bc:	8b 00                	mov    (%eax),%eax
  8036be:	85 c0                	test   %eax,%eax
  8036c0:	74 10                	je     8036d2 <alloc_block_BF+0x6e>
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	8b 00                	mov    (%eax),%eax
  8036c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ca:	8b 52 04             	mov    0x4(%edx),%edx
  8036cd:	89 50 04             	mov    %edx,0x4(%eax)
  8036d0:	eb 0b                	jmp    8036dd <alloc_block_BF+0x79>
  8036d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d5:	8b 40 04             	mov    0x4(%eax),%eax
  8036d8:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8036dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e0:	8b 40 04             	mov    0x4(%eax),%eax
  8036e3:	85 c0                	test   %eax,%eax
  8036e5:	74 0f                	je     8036f6 <alloc_block_BF+0x92>
  8036e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ea:	8b 40 04             	mov    0x4(%eax),%eax
  8036ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f0:	8b 12                	mov    (%edx),%edx
  8036f2:	89 10                	mov    %edx,(%eax)
  8036f4:	eb 0a                	jmp    803700 <alloc_block_BF+0x9c>
  8036f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f9:	8b 00                	mov    (%eax),%eax
  8036fb:	a3 38 61 80 00       	mov    %eax,0x806138
  803700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803703:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803713:	a1 44 61 80 00       	mov    0x806144,%eax
  803718:	48                   	dec    %eax
  803719:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  80371e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803721:	e9 4d 01 00 00       	jmp    803873 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803729:	8b 40 0c             	mov    0xc(%eax),%eax
  80372c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80372f:	76 24                	jbe    803755 <alloc_block_BF+0xf1>
  803731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803734:	8b 40 0c             	mov    0xc(%eax),%eax
  803737:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80373a:	73 19                	jae    803755 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80373c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  803743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803746:	8b 40 0c             	mov    0xc(%eax),%eax
  803749:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80374c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374f:	8b 40 08             	mov    0x8(%eax),%eax
  803752:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803755:	a1 40 61 80 00       	mov    0x806140,%eax
  80375a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80375d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803761:	74 07                	je     80376a <alloc_block_BF+0x106>
  803763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803766:	8b 00                	mov    (%eax),%eax
  803768:	eb 05                	jmp    80376f <alloc_block_BF+0x10b>
  80376a:	b8 00 00 00 00       	mov    $0x0,%eax
  80376f:	a3 40 61 80 00       	mov    %eax,0x806140
  803774:	a1 40 61 80 00       	mov    0x806140,%eax
  803779:	85 c0                	test   %eax,%eax
  80377b:	0f 85 fd fe ff ff    	jne    80367e <alloc_block_BF+0x1a>
  803781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803785:	0f 85 f3 fe ff ff    	jne    80367e <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80378b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80378f:	0f 84 d9 00 00 00    	je     80386e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803795:	a1 48 61 80 00       	mov    0x806148,%eax
  80379a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80379d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037a3:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8037a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ac:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8037af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037b3:	75 17                	jne    8037cc <alloc_block_BF+0x168>
  8037b5:	83 ec 04             	sub    $0x4,%esp
  8037b8:	68 a4 54 80 00       	push   $0x8054a4
  8037bd:	68 c7 00 00 00       	push   $0xc7
  8037c2:	68 fb 53 80 00       	push   $0x8053fb
  8037c7:	e8 5d dc ff ff       	call   801429 <_panic>
  8037cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cf:	8b 00                	mov    (%eax),%eax
  8037d1:	85 c0                	test   %eax,%eax
  8037d3:	74 10                	je     8037e5 <alloc_block_BF+0x181>
  8037d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d8:	8b 00                	mov    (%eax),%eax
  8037da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037dd:	8b 52 04             	mov    0x4(%edx),%edx
  8037e0:	89 50 04             	mov    %edx,0x4(%eax)
  8037e3:	eb 0b                	jmp    8037f0 <alloc_block_BF+0x18c>
  8037e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e8:	8b 40 04             	mov    0x4(%eax),%eax
  8037eb:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8037f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f3:	8b 40 04             	mov    0x4(%eax),%eax
  8037f6:	85 c0                	test   %eax,%eax
  8037f8:	74 0f                	je     803809 <alloc_block_BF+0x1a5>
  8037fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fd:	8b 40 04             	mov    0x4(%eax),%eax
  803800:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803803:	8b 12                	mov    (%edx),%edx
  803805:	89 10                	mov    %edx,(%eax)
  803807:	eb 0a                	jmp    803813 <alloc_block_BF+0x1af>
  803809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380c:	8b 00                	mov    (%eax),%eax
  80380e:	a3 48 61 80 00       	mov    %eax,0x806148
  803813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803816:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80381c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803826:	a1 54 61 80 00       	mov    0x806154,%eax
  80382b:	48                   	dec    %eax
  80382c:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803831:	83 ec 08             	sub    $0x8,%esp
  803834:	ff 75 ec             	pushl  -0x14(%ebp)
  803837:	68 38 61 80 00       	push   $0x806138
  80383c:	e8 71 f9 ff ff       	call   8031b2 <find_block>
  803841:	83 c4 10             	add    $0x10,%esp
  803844:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803847:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80384a:	8b 50 08             	mov    0x8(%eax),%edx
  80384d:	8b 45 08             	mov    0x8(%ebp),%eax
  803850:	01 c2                	add    %eax,%edx
  803852:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803855:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803858:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80385b:	8b 40 0c             	mov    0xc(%eax),%eax
  80385e:	2b 45 08             	sub    0x8(%ebp),%eax
  803861:	89 c2                	mov    %eax,%edx
  803863:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803866:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386c:	eb 05                	jmp    803873 <alloc_block_BF+0x20f>
	}
	return NULL;
  80386e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803873:	c9                   	leave  
  803874:	c3                   	ret    

00803875 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803875:	55                   	push   %ebp
  803876:	89 e5                	mov    %esp,%ebp
  803878:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80387b:	a1 28 60 80 00       	mov    0x806028,%eax
  803880:	85 c0                	test   %eax,%eax
  803882:	0f 85 de 01 00 00    	jne    803a66 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803888:	a1 38 61 80 00       	mov    0x806138,%eax
  80388d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803890:	e9 9e 01 00 00       	jmp    803a33 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803898:	8b 40 0c             	mov    0xc(%eax),%eax
  80389b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80389e:	0f 82 87 01 00 00    	jb     803a2b <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8038a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8038aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038ad:	0f 85 95 00 00 00    	jne    803948 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8038b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038b7:	75 17                	jne    8038d0 <alloc_block_NF+0x5b>
  8038b9:	83 ec 04             	sub    $0x4,%esp
  8038bc:	68 a4 54 80 00       	push   $0x8054a4
  8038c1:	68 e0 00 00 00       	push   $0xe0
  8038c6:	68 fb 53 80 00       	push   $0x8053fb
  8038cb:	e8 59 db ff ff       	call   801429 <_panic>
  8038d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d3:	8b 00                	mov    (%eax),%eax
  8038d5:	85 c0                	test   %eax,%eax
  8038d7:	74 10                	je     8038e9 <alloc_block_NF+0x74>
  8038d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038dc:	8b 00                	mov    (%eax),%eax
  8038de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038e1:	8b 52 04             	mov    0x4(%edx),%edx
  8038e4:	89 50 04             	mov    %edx,0x4(%eax)
  8038e7:	eb 0b                	jmp    8038f4 <alloc_block_NF+0x7f>
  8038e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ec:	8b 40 04             	mov    0x4(%eax),%eax
  8038ef:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8038f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f7:	8b 40 04             	mov    0x4(%eax),%eax
  8038fa:	85 c0                	test   %eax,%eax
  8038fc:	74 0f                	je     80390d <alloc_block_NF+0x98>
  8038fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803901:	8b 40 04             	mov    0x4(%eax),%eax
  803904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803907:	8b 12                	mov    (%edx),%edx
  803909:	89 10                	mov    %edx,(%eax)
  80390b:	eb 0a                	jmp    803917 <alloc_block_NF+0xa2>
  80390d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803910:	8b 00                	mov    (%eax),%eax
  803912:	a3 38 61 80 00       	mov    %eax,0x806138
  803917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803923:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80392a:	a1 44 61 80 00       	mov    0x806144,%eax
  80392f:	48                   	dec    %eax
  803930:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  803935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803938:	8b 40 08             	mov    0x8(%eax),%eax
  80393b:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  803940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803943:	e9 f8 04 00 00       	jmp    803e40 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394b:	8b 40 0c             	mov    0xc(%eax),%eax
  80394e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803951:	0f 86 d4 00 00 00    	jbe    803a2b <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803957:	a1 48 61 80 00       	mov    0x806148,%eax
  80395c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80395f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803962:	8b 50 08             	mov    0x8(%eax),%edx
  803965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803968:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80396b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80396e:	8b 55 08             	mov    0x8(%ebp),%edx
  803971:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803974:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803978:	75 17                	jne    803991 <alloc_block_NF+0x11c>
  80397a:	83 ec 04             	sub    $0x4,%esp
  80397d:	68 a4 54 80 00       	push   $0x8054a4
  803982:	68 e9 00 00 00       	push   $0xe9
  803987:	68 fb 53 80 00       	push   $0x8053fb
  80398c:	e8 98 da ff ff       	call   801429 <_panic>
  803991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803994:	8b 00                	mov    (%eax),%eax
  803996:	85 c0                	test   %eax,%eax
  803998:	74 10                	je     8039aa <alloc_block_NF+0x135>
  80399a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80399d:	8b 00                	mov    (%eax),%eax
  80399f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039a2:	8b 52 04             	mov    0x4(%edx),%edx
  8039a5:	89 50 04             	mov    %edx,0x4(%eax)
  8039a8:	eb 0b                	jmp    8039b5 <alloc_block_NF+0x140>
  8039aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ad:	8b 40 04             	mov    0x4(%eax),%eax
  8039b0:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8039b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b8:	8b 40 04             	mov    0x4(%eax),%eax
  8039bb:	85 c0                	test   %eax,%eax
  8039bd:	74 0f                	je     8039ce <alloc_block_NF+0x159>
  8039bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c2:	8b 40 04             	mov    0x4(%eax),%eax
  8039c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039c8:	8b 12                	mov    (%edx),%edx
  8039ca:	89 10                	mov    %edx,(%eax)
  8039cc:	eb 0a                	jmp    8039d8 <alloc_block_NF+0x163>
  8039ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d1:	8b 00                	mov    (%eax),%eax
  8039d3:	a3 48 61 80 00       	mov    %eax,0x806148
  8039d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039eb:	a1 54 61 80 00       	mov    0x806154,%eax
  8039f0:	48                   	dec    %eax
  8039f1:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  8039f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f9:	8b 40 08             	mov    0x8(%eax),%eax
  8039fc:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  803a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a04:	8b 50 08             	mov    0x8(%eax),%edx
  803a07:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0a:	01 c2                	add    %eax,%edx
  803a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a15:	8b 40 0c             	mov    0xc(%eax),%eax
  803a18:	2b 45 08             	sub    0x8(%ebp),%eax
  803a1b:	89 c2                	mov    %eax,%edx
  803a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a20:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a26:	e9 15 04 00 00       	jmp    803e40 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803a2b:	a1 40 61 80 00       	mov    0x806140,%eax
  803a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a37:	74 07                	je     803a40 <alloc_block_NF+0x1cb>
  803a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3c:	8b 00                	mov    (%eax),%eax
  803a3e:	eb 05                	jmp    803a45 <alloc_block_NF+0x1d0>
  803a40:	b8 00 00 00 00       	mov    $0x0,%eax
  803a45:	a3 40 61 80 00       	mov    %eax,0x806140
  803a4a:	a1 40 61 80 00       	mov    0x806140,%eax
  803a4f:	85 c0                	test   %eax,%eax
  803a51:	0f 85 3e fe ff ff    	jne    803895 <alloc_block_NF+0x20>
  803a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a5b:	0f 85 34 fe ff ff    	jne    803895 <alloc_block_NF+0x20>
  803a61:	e9 d5 03 00 00       	jmp    803e3b <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803a66:	a1 38 61 80 00       	mov    0x806138,%eax
  803a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a6e:	e9 b1 01 00 00       	jmp    803c24 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a76:	8b 50 08             	mov    0x8(%eax),%edx
  803a79:	a1 28 60 80 00       	mov    0x806028,%eax
  803a7e:	39 c2                	cmp    %eax,%edx
  803a80:	0f 82 96 01 00 00    	jb     803c1c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a89:	8b 40 0c             	mov    0xc(%eax),%eax
  803a8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a8f:	0f 82 87 01 00 00    	jb     803c1c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a98:	8b 40 0c             	mov    0xc(%eax),%eax
  803a9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a9e:	0f 85 95 00 00 00    	jne    803b39 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803aa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aa8:	75 17                	jne    803ac1 <alloc_block_NF+0x24c>
  803aaa:	83 ec 04             	sub    $0x4,%esp
  803aad:	68 a4 54 80 00       	push   $0x8054a4
  803ab2:	68 fc 00 00 00       	push   $0xfc
  803ab7:	68 fb 53 80 00       	push   $0x8053fb
  803abc:	e8 68 d9 ff ff       	call   801429 <_panic>
  803ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac4:	8b 00                	mov    (%eax),%eax
  803ac6:	85 c0                	test   %eax,%eax
  803ac8:	74 10                	je     803ada <alloc_block_NF+0x265>
  803aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acd:	8b 00                	mov    (%eax),%eax
  803acf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ad2:	8b 52 04             	mov    0x4(%edx),%edx
  803ad5:	89 50 04             	mov    %edx,0x4(%eax)
  803ad8:	eb 0b                	jmp    803ae5 <alloc_block_NF+0x270>
  803ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803add:	8b 40 04             	mov    0x4(%eax),%eax
  803ae0:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae8:	8b 40 04             	mov    0x4(%eax),%eax
  803aeb:	85 c0                	test   %eax,%eax
  803aed:	74 0f                	je     803afe <alloc_block_NF+0x289>
  803aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af2:	8b 40 04             	mov    0x4(%eax),%eax
  803af5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803af8:	8b 12                	mov    (%edx),%edx
  803afa:	89 10                	mov    %edx,(%eax)
  803afc:	eb 0a                	jmp    803b08 <alloc_block_NF+0x293>
  803afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b01:	8b 00                	mov    (%eax),%eax
  803b03:	a3 38 61 80 00       	mov    %eax,0x806138
  803b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b1b:	a1 44 61 80 00       	mov    0x806144,%eax
  803b20:	48                   	dec    %eax
  803b21:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b29:	8b 40 08             	mov    0x8(%eax),%eax
  803b2c:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b34:	e9 07 03 00 00       	jmp    803e40 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3c:	8b 40 0c             	mov    0xc(%eax),%eax
  803b3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b42:	0f 86 d4 00 00 00    	jbe    803c1c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803b48:	a1 48 61 80 00       	mov    0x806148,%eax
  803b4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b53:	8b 50 08             	mov    0x8(%eax),%edx
  803b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b59:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803b5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b5f:	8b 55 08             	mov    0x8(%ebp),%edx
  803b62:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803b65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b69:	75 17                	jne    803b82 <alloc_block_NF+0x30d>
  803b6b:	83 ec 04             	sub    $0x4,%esp
  803b6e:	68 a4 54 80 00       	push   $0x8054a4
  803b73:	68 04 01 00 00       	push   $0x104
  803b78:	68 fb 53 80 00       	push   $0x8053fb
  803b7d:	e8 a7 d8 ff ff       	call   801429 <_panic>
  803b82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b85:	8b 00                	mov    (%eax),%eax
  803b87:	85 c0                	test   %eax,%eax
  803b89:	74 10                	je     803b9b <alloc_block_NF+0x326>
  803b8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b8e:	8b 00                	mov    (%eax),%eax
  803b90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b93:	8b 52 04             	mov    0x4(%edx),%edx
  803b96:	89 50 04             	mov    %edx,0x4(%eax)
  803b99:	eb 0b                	jmp    803ba6 <alloc_block_NF+0x331>
  803b9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ba1:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba9:	8b 40 04             	mov    0x4(%eax),%eax
  803bac:	85 c0                	test   %eax,%eax
  803bae:	74 0f                	je     803bbf <alloc_block_NF+0x34a>
  803bb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb3:	8b 40 04             	mov    0x4(%eax),%eax
  803bb6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bb9:	8b 12                	mov    (%edx),%edx
  803bbb:	89 10                	mov    %edx,(%eax)
  803bbd:	eb 0a                	jmp    803bc9 <alloc_block_NF+0x354>
  803bbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc2:	8b 00                	mov    (%eax),%eax
  803bc4:	a3 48 61 80 00       	mov    %eax,0x806148
  803bc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bdc:	a1 54 61 80 00       	mov    0x806154,%eax
  803be1:	48                   	dec    %eax
  803be2:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803be7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bea:	8b 40 08             	mov    0x8(%eax),%eax
  803bed:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf5:	8b 50 08             	mov    0x8(%eax),%edx
  803bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfb:	01 c2                	add    %eax,%edx
  803bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c00:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c06:	8b 40 0c             	mov    0xc(%eax),%eax
  803c09:	2b 45 08             	sub    0x8(%ebp),%eax
  803c0c:	89 c2                	mov    %eax,%edx
  803c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c11:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c17:	e9 24 02 00 00       	jmp    803e40 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803c1c:	a1 40 61 80 00       	mov    0x806140,%eax
  803c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c28:	74 07                	je     803c31 <alloc_block_NF+0x3bc>
  803c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2d:	8b 00                	mov    (%eax),%eax
  803c2f:	eb 05                	jmp    803c36 <alloc_block_NF+0x3c1>
  803c31:	b8 00 00 00 00       	mov    $0x0,%eax
  803c36:	a3 40 61 80 00       	mov    %eax,0x806140
  803c3b:	a1 40 61 80 00       	mov    0x806140,%eax
  803c40:	85 c0                	test   %eax,%eax
  803c42:	0f 85 2b fe ff ff    	jne    803a73 <alloc_block_NF+0x1fe>
  803c48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c4c:	0f 85 21 fe ff ff    	jne    803a73 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803c52:	a1 38 61 80 00       	mov    0x806138,%eax
  803c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c5a:	e9 ae 01 00 00       	jmp    803e0d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c62:	8b 50 08             	mov    0x8(%eax),%edx
  803c65:	a1 28 60 80 00       	mov    0x806028,%eax
  803c6a:	39 c2                	cmp    %eax,%edx
  803c6c:	0f 83 93 01 00 00    	jae    803e05 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c75:	8b 40 0c             	mov    0xc(%eax),%eax
  803c78:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c7b:	0f 82 84 01 00 00    	jb     803e05 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c84:	8b 40 0c             	mov    0xc(%eax),%eax
  803c87:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c8a:	0f 85 95 00 00 00    	jne    803d25 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803c90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c94:	75 17                	jne    803cad <alloc_block_NF+0x438>
  803c96:	83 ec 04             	sub    $0x4,%esp
  803c99:	68 a4 54 80 00       	push   $0x8054a4
  803c9e:	68 14 01 00 00       	push   $0x114
  803ca3:	68 fb 53 80 00       	push   $0x8053fb
  803ca8:	e8 7c d7 ff ff       	call   801429 <_panic>
  803cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb0:	8b 00                	mov    (%eax),%eax
  803cb2:	85 c0                	test   %eax,%eax
  803cb4:	74 10                	je     803cc6 <alloc_block_NF+0x451>
  803cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb9:	8b 00                	mov    (%eax),%eax
  803cbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cbe:	8b 52 04             	mov    0x4(%edx),%edx
  803cc1:	89 50 04             	mov    %edx,0x4(%eax)
  803cc4:	eb 0b                	jmp    803cd1 <alloc_block_NF+0x45c>
  803cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc9:	8b 40 04             	mov    0x4(%eax),%eax
  803ccc:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd4:	8b 40 04             	mov    0x4(%eax),%eax
  803cd7:	85 c0                	test   %eax,%eax
  803cd9:	74 0f                	je     803cea <alloc_block_NF+0x475>
  803cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cde:	8b 40 04             	mov    0x4(%eax),%eax
  803ce1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ce4:	8b 12                	mov    (%edx),%edx
  803ce6:	89 10                	mov    %edx,(%eax)
  803ce8:	eb 0a                	jmp    803cf4 <alloc_block_NF+0x47f>
  803cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ced:	8b 00                	mov    (%eax),%eax
  803cef:	a3 38 61 80 00       	mov    %eax,0x806138
  803cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d07:	a1 44 61 80 00       	mov    0x806144,%eax
  803d0c:	48                   	dec    %eax
  803d0d:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d15:	8b 40 08             	mov    0x8(%eax),%eax
  803d18:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d20:	e9 1b 01 00 00       	jmp    803e40 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d28:	8b 40 0c             	mov    0xc(%eax),%eax
  803d2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d2e:	0f 86 d1 00 00 00    	jbe    803e05 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803d34:	a1 48 61 80 00       	mov    0x806148,%eax
  803d39:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3f:	8b 50 08             	mov    0x8(%eax),%edx
  803d42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d45:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  803d4e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803d51:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803d55:	75 17                	jne    803d6e <alloc_block_NF+0x4f9>
  803d57:	83 ec 04             	sub    $0x4,%esp
  803d5a:	68 a4 54 80 00       	push   $0x8054a4
  803d5f:	68 1c 01 00 00       	push   $0x11c
  803d64:	68 fb 53 80 00       	push   $0x8053fb
  803d69:	e8 bb d6 ff ff       	call   801429 <_panic>
  803d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d71:	8b 00                	mov    (%eax),%eax
  803d73:	85 c0                	test   %eax,%eax
  803d75:	74 10                	je     803d87 <alloc_block_NF+0x512>
  803d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d7a:	8b 00                	mov    (%eax),%eax
  803d7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d7f:	8b 52 04             	mov    0x4(%edx),%edx
  803d82:	89 50 04             	mov    %edx,0x4(%eax)
  803d85:	eb 0b                	jmp    803d92 <alloc_block_NF+0x51d>
  803d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d8a:	8b 40 04             	mov    0x4(%eax),%eax
  803d8d:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d95:	8b 40 04             	mov    0x4(%eax),%eax
  803d98:	85 c0                	test   %eax,%eax
  803d9a:	74 0f                	je     803dab <alloc_block_NF+0x536>
  803d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d9f:	8b 40 04             	mov    0x4(%eax),%eax
  803da2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803da5:	8b 12                	mov    (%edx),%edx
  803da7:	89 10                	mov    %edx,(%eax)
  803da9:	eb 0a                	jmp    803db5 <alloc_block_NF+0x540>
  803dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dae:	8b 00                	mov    (%eax),%eax
  803db0:	a3 48 61 80 00       	mov    %eax,0x806148
  803db5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803db8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dc8:	a1 54 61 80 00       	mov    0x806154,%eax
  803dcd:	48                   	dec    %eax
  803dce:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803dd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dd6:	8b 40 08             	mov    0x8(%eax),%eax
  803dd9:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de1:	8b 50 08             	mov    0x8(%eax),%edx
  803de4:	8b 45 08             	mov    0x8(%ebp),%eax
  803de7:	01 c2                	add    %eax,%edx
  803de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dec:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df2:	8b 40 0c             	mov    0xc(%eax),%eax
  803df5:	2b 45 08             	sub    0x8(%ebp),%eax
  803df8:	89 c2                	mov    %eax,%edx
  803dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfd:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803e00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e03:	eb 3b                	jmp    803e40 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803e05:	a1 40 61 80 00       	mov    0x806140,%eax
  803e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e11:	74 07                	je     803e1a <alloc_block_NF+0x5a5>
  803e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e16:	8b 00                	mov    (%eax),%eax
  803e18:	eb 05                	jmp    803e1f <alloc_block_NF+0x5aa>
  803e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e1f:	a3 40 61 80 00       	mov    %eax,0x806140
  803e24:	a1 40 61 80 00       	mov    0x806140,%eax
  803e29:	85 c0                	test   %eax,%eax
  803e2b:	0f 85 2e fe ff ff    	jne    803c5f <alloc_block_NF+0x3ea>
  803e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e35:	0f 85 24 fe ff ff    	jne    803c5f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803e3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e40:	c9                   	leave  
  803e41:	c3                   	ret    

00803e42 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803e42:	55                   	push   %ebp
  803e43:	89 e5                	mov    %esp,%ebp
  803e45:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803e48:	a1 38 61 80 00       	mov    0x806138,%eax
  803e4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803e50:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803e55:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803e58:	a1 38 61 80 00       	mov    0x806138,%eax
  803e5d:	85 c0                	test   %eax,%eax
  803e5f:	74 14                	je     803e75 <insert_sorted_with_merge_freeList+0x33>
  803e61:	8b 45 08             	mov    0x8(%ebp),%eax
  803e64:	8b 50 08             	mov    0x8(%eax),%edx
  803e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e6a:	8b 40 08             	mov    0x8(%eax),%eax
  803e6d:	39 c2                	cmp    %eax,%edx
  803e6f:	0f 87 9b 01 00 00    	ja     804010 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803e75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e79:	75 17                	jne    803e92 <insert_sorted_with_merge_freeList+0x50>
  803e7b:	83 ec 04             	sub    $0x4,%esp
  803e7e:	68 d8 53 80 00       	push   $0x8053d8
  803e83:	68 38 01 00 00       	push   $0x138
  803e88:	68 fb 53 80 00       	push   $0x8053fb
  803e8d:	e8 97 d5 ff ff       	call   801429 <_panic>
  803e92:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803e98:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9b:	89 10                	mov    %edx,(%eax)
  803e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea0:	8b 00                	mov    (%eax),%eax
  803ea2:	85 c0                	test   %eax,%eax
  803ea4:	74 0d                	je     803eb3 <insert_sorted_with_merge_freeList+0x71>
  803ea6:	a1 38 61 80 00       	mov    0x806138,%eax
  803eab:	8b 55 08             	mov    0x8(%ebp),%edx
  803eae:	89 50 04             	mov    %edx,0x4(%eax)
  803eb1:	eb 08                	jmp    803ebb <insert_sorted_with_merge_freeList+0x79>
  803eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb6:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ebe:	a3 38 61 80 00       	mov    %eax,0x806138
  803ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ecd:	a1 44 61 80 00       	mov    0x806144,%eax
  803ed2:	40                   	inc    %eax
  803ed3:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803ed8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803edc:	0f 84 a8 06 00 00    	je     80458a <insert_sorted_with_merge_freeList+0x748>
  803ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee5:	8b 50 08             	mov    0x8(%eax),%edx
  803ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  803eeb:	8b 40 0c             	mov    0xc(%eax),%eax
  803eee:	01 c2                	add    %eax,%edx
  803ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ef3:	8b 40 08             	mov    0x8(%eax),%eax
  803ef6:	39 c2                	cmp    %eax,%edx
  803ef8:	0f 85 8c 06 00 00    	jne    80458a <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803efe:	8b 45 08             	mov    0x8(%ebp),%eax
  803f01:	8b 50 0c             	mov    0xc(%eax),%edx
  803f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f07:	8b 40 0c             	mov    0xc(%eax),%eax
  803f0a:	01 c2                	add    %eax,%edx
  803f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803f12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f16:	75 17                	jne    803f2f <insert_sorted_with_merge_freeList+0xed>
  803f18:	83 ec 04             	sub    $0x4,%esp
  803f1b:	68 a4 54 80 00       	push   $0x8054a4
  803f20:	68 3c 01 00 00       	push   $0x13c
  803f25:	68 fb 53 80 00       	push   $0x8053fb
  803f2a:	e8 fa d4 ff ff       	call   801429 <_panic>
  803f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f32:	8b 00                	mov    (%eax),%eax
  803f34:	85 c0                	test   %eax,%eax
  803f36:	74 10                	je     803f48 <insert_sorted_with_merge_freeList+0x106>
  803f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f3b:	8b 00                	mov    (%eax),%eax
  803f3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f40:	8b 52 04             	mov    0x4(%edx),%edx
  803f43:	89 50 04             	mov    %edx,0x4(%eax)
  803f46:	eb 0b                	jmp    803f53 <insert_sorted_with_merge_freeList+0x111>
  803f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f4b:	8b 40 04             	mov    0x4(%eax),%eax
  803f4e:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f56:	8b 40 04             	mov    0x4(%eax),%eax
  803f59:	85 c0                	test   %eax,%eax
  803f5b:	74 0f                	je     803f6c <insert_sorted_with_merge_freeList+0x12a>
  803f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f60:	8b 40 04             	mov    0x4(%eax),%eax
  803f63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f66:	8b 12                	mov    (%edx),%edx
  803f68:	89 10                	mov    %edx,(%eax)
  803f6a:	eb 0a                	jmp    803f76 <insert_sorted_with_merge_freeList+0x134>
  803f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f6f:	8b 00                	mov    (%eax),%eax
  803f71:	a3 38 61 80 00       	mov    %eax,0x806138
  803f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f89:	a1 44 61 80 00       	mov    0x806144,%eax
  803f8e:	48                   	dec    %eax
  803f8f:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  803f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803fa8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803fac:	75 17                	jne    803fc5 <insert_sorted_with_merge_freeList+0x183>
  803fae:	83 ec 04             	sub    $0x4,%esp
  803fb1:	68 d8 53 80 00       	push   $0x8053d8
  803fb6:	68 3f 01 00 00       	push   $0x13f
  803fbb:	68 fb 53 80 00       	push   $0x8053fb
  803fc0:	e8 64 d4 ff ff       	call   801429 <_panic>
  803fc5:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fce:	89 10                	mov    %edx,(%eax)
  803fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fd3:	8b 00                	mov    (%eax),%eax
  803fd5:	85 c0                	test   %eax,%eax
  803fd7:	74 0d                	je     803fe6 <insert_sorted_with_merge_freeList+0x1a4>
  803fd9:	a1 48 61 80 00       	mov    0x806148,%eax
  803fde:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fe1:	89 50 04             	mov    %edx,0x4(%eax)
  803fe4:	eb 08                	jmp    803fee <insert_sorted_with_merge_freeList+0x1ac>
  803fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fe9:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff1:	a3 48 61 80 00       	mov    %eax,0x806148
  803ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804000:	a1 54 61 80 00       	mov    0x806154,%eax
  804005:	40                   	inc    %eax
  804006:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80400b:	e9 7a 05 00 00       	jmp    80458a <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  804010:	8b 45 08             	mov    0x8(%ebp),%eax
  804013:	8b 50 08             	mov    0x8(%eax),%edx
  804016:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804019:	8b 40 08             	mov    0x8(%eax),%eax
  80401c:	39 c2                	cmp    %eax,%edx
  80401e:	0f 82 14 01 00 00    	jb     804138 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  804024:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804027:	8b 50 08             	mov    0x8(%eax),%edx
  80402a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80402d:	8b 40 0c             	mov    0xc(%eax),%eax
  804030:	01 c2                	add    %eax,%edx
  804032:	8b 45 08             	mov    0x8(%ebp),%eax
  804035:	8b 40 08             	mov    0x8(%eax),%eax
  804038:	39 c2                	cmp    %eax,%edx
  80403a:	0f 85 90 00 00 00    	jne    8040d0 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  804040:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804043:	8b 50 0c             	mov    0xc(%eax),%edx
  804046:	8b 45 08             	mov    0x8(%ebp),%eax
  804049:	8b 40 0c             	mov    0xc(%eax),%eax
  80404c:	01 c2                	add    %eax,%edx
  80404e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804051:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  804054:	8b 45 08             	mov    0x8(%ebp),%eax
  804057:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80405e:	8b 45 08             	mov    0x8(%ebp),%eax
  804061:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  804068:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80406c:	75 17                	jne    804085 <insert_sorted_with_merge_freeList+0x243>
  80406e:	83 ec 04             	sub    $0x4,%esp
  804071:	68 d8 53 80 00       	push   $0x8053d8
  804076:	68 49 01 00 00       	push   $0x149
  80407b:	68 fb 53 80 00       	push   $0x8053fb
  804080:	e8 a4 d3 ff ff       	call   801429 <_panic>
  804085:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80408b:	8b 45 08             	mov    0x8(%ebp),%eax
  80408e:	89 10                	mov    %edx,(%eax)
  804090:	8b 45 08             	mov    0x8(%ebp),%eax
  804093:	8b 00                	mov    (%eax),%eax
  804095:	85 c0                	test   %eax,%eax
  804097:	74 0d                	je     8040a6 <insert_sorted_with_merge_freeList+0x264>
  804099:	a1 48 61 80 00       	mov    0x806148,%eax
  80409e:	8b 55 08             	mov    0x8(%ebp),%edx
  8040a1:	89 50 04             	mov    %edx,0x4(%eax)
  8040a4:	eb 08                	jmp    8040ae <insert_sorted_with_merge_freeList+0x26c>
  8040a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040a9:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8040ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b1:	a3 48 61 80 00       	mov    %eax,0x806148
  8040b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040c0:	a1 54 61 80 00       	mov    0x806154,%eax
  8040c5:	40                   	inc    %eax
  8040c6:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8040cb:	e9 bb 04 00 00       	jmp    80458b <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8040d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040d4:	75 17                	jne    8040ed <insert_sorted_with_merge_freeList+0x2ab>
  8040d6:	83 ec 04             	sub    $0x4,%esp
  8040d9:	68 4c 54 80 00       	push   $0x80544c
  8040de:	68 4c 01 00 00       	push   $0x14c
  8040e3:	68 fb 53 80 00       	push   $0x8053fb
  8040e8:	e8 3c d3 ff ff       	call   801429 <_panic>
  8040ed:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  8040f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f6:	89 50 04             	mov    %edx,0x4(%eax)
  8040f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040fc:	8b 40 04             	mov    0x4(%eax),%eax
  8040ff:	85 c0                	test   %eax,%eax
  804101:	74 0c                	je     80410f <insert_sorted_with_merge_freeList+0x2cd>
  804103:	a1 3c 61 80 00       	mov    0x80613c,%eax
  804108:	8b 55 08             	mov    0x8(%ebp),%edx
  80410b:	89 10                	mov    %edx,(%eax)
  80410d:	eb 08                	jmp    804117 <insert_sorted_with_merge_freeList+0x2d5>
  80410f:	8b 45 08             	mov    0x8(%ebp),%eax
  804112:	a3 38 61 80 00       	mov    %eax,0x806138
  804117:	8b 45 08             	mov    0x8(%ebp),%eax
  80411a:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80411f:	8b 45 08             	mov    0x8(%ebp),%eax
  804122:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804128:	a1 44 61 80 00       	mov    0x806144,%eax
  80412d:	40                   	inc    %eax
  80412e:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804133:	e9 53 04 00 00       	jmp    80458b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  804138:	a1 38 61 80 00       	mov    0x806138,%eax
  80413d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804140:	e9 15 04 00 00       	jmp    80455a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  804145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804148:	8b 00                	mov    (%eax),%eax
  80414a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80414d:	8b 45 08             	mov    0x8(%ebp),%eax
  804150:	8b 50 08             	mov    0x8(%eax),%edx
  804153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804156:	8b 40 08             	mov    0x8(%eax),%eax
  804159:	39 c2                	cmp    %eax,%edx
  80415b:	0f 86 f1 03 00 00    	jbe    804552 <insert_sorted_with_merge_freeList+0x710>
  804161:	8b 45 08             	mov    0x8(%ebp),%eax
  804164:	8b 50 08             	mov    0x8(%eax),%edx
  804167:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80416a:	8b 40 08             	mov    0x8(%eax),%eax
  80416d:	39 c2                	cmp    %eax,%edx
  80416f:	0f 83 dd 03 00 00    	jae    804552 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  804175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804178:	8b 50 08             	mov    0x8(%eax),%edx
  80417b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80417e:	8b 40 0c             	mov    0xc(%eax),%eax
  804181:	01 c2                	add    %eax,%edx
  804183:	8b 45 08             	mov    0x8(%ebp),%eax
  804186:	8b 40 08             	mov    0x8(%eax),%eax
  804189:	39 c2                	cmp    %eax,%edx
  80418b:	0f 85 b9 01 00 00    	jne    80434a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804191:	8b 45 08             	mov    0x8(%ebp),%eax
  804194:	8b 50 08             	mov    0x8(%eax),%edx
  804197:	8b 45 08             	mov    0x8(%ebp),%eax
  80419a:	8b 40 0c             	mov    0xc(%eax),%eax
  80419d:	01 c2                	add    %eax,%edx
  80419f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041a2:	8b 40 08             	mov    0x8(%eax),%eax
  8041a5:	39 c2                	cmp    %eax,%edx
  8041a7:	0f 85 0d 01 00 00    	jne    8042ba <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8041ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041b0:	8b 50 0c             	mov    0xc(%eax),%edx
  8041b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8041b9:	01 c2                	add    %eax,%edx
  8041bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041be:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8041c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8041c5:	75 17                	jne    8041de <insert_sorted_with_merge_freeList+0x39c>
  8041c7:	83 ec 04             	sub    $0x4,%esp
  8041ca:	68 a4 54 80 00       	push   $0x8054a4
  8041cf:	68 5c 01 00 00       	push   $0x15c
  8041d4:	68 fb 53 80 00       	push   $0x8053fb
  8041d9:	e8 4b d2 ff ff       	call   801429 <_panic>
  8041de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041e1:	8b 00                	mov    (%eax),%eax
  8041e3:	85 c0                	test   %eax,%eax
  8041e5:	74 10                	je     8041f7 <insert_sorted_with_merge_freeList+0x3b5>
  8041e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041ea:	8b 00                	mov    (%eax),%eax
  8041ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041ef:	8b 52 04             	mov    0x4(%edx),%edx
  8041f2:	89 50 04             	mov    %edx,0x4(%eax)
  8041f5:	eb 0b                	jmp    804202 <insert_sorted_with_merge_freeList+0x3c0>
  8041f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041fa:	8b 40 04             	mov    0x4(%eax),%eax
  8041fd:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804205:	8b 40 04             	mov    0x4(%eax),%eax
  804208:	85 c0                	test   %eax,%eax
  80420a:	74 0f                	je     80421b <insert_sorted_with_merge_freeList+0x3d9>
  80420c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80420f:	8b 40 04             	mov    0x4(%eax),%eax
  804212:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804215:	8b 12                	mov    (%edx),%edx
  804217:	89 10                	mov    %edx,(%eax)
  804219:	eb 0a                	jmp    804225 <insert_sorted_with_merge_freeList+0x3e3>
  80421b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80421e:	8b 00                	mov    (%eax),%eax
  804220:	a3 38 61 80 00       	mov    %eax,0x806138
  804225:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804228:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80422e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804231:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804238:	a1 44 61 80 00       	mov    0x806144,%eax
  80423d:	48                   	dec    %eax
  80423e:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  804243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804246:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80424d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804250:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  804257:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80425b:	75 17                	jne    804274 <insert_sorted_with_merge_freeList+0x432>
  80425d:	83 ec 04             	sub    $0x4,%esp
  804260:	68 d8 53 80 00       	push   $0x8053d8
  804265:	68 5f 01 00 00       	push   $0x15f
  80426a:	68 fb 53 80 00       	push   $0x8053fb
  80426f:	e8 b5 d1 ff ff       	call   801429 <_panic>
  804274:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80427a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80427d:	89 10                	mov    %edx,(%eax)
  80427f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804282:	8b 00                	mov    (%eax),%eax
  804284:	85 c0                	test   %eax,%eax
  804286:	74 0d                	je     804295 <insert_sorted_with_merge_freeList+0x453>
  804288:	a1 48 61 80 00       	mov    0x806148,%eax
  80428d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804290:	89 50 04             	mov    %edx,0x4(%eax)
  804293:	eb 08                	jmp    80429d <insert_sorted_with_merge_freeList+0x45b>
  804295:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804298:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80429d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042a0:	a3 48 61 80 00       	mov    %eax,0x806148
  8042a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042af:	a1 54 61 80 00       	mov    0x806154,%eax
  8042b4:	40                   	inc    %eax
  8042b5:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  8042ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042bd:	8b 50 0c             	mov    0xc(%eax),%edx
  8042c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8042c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8042c6:	01 c2                	add    %eax,%edx
  8042c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042cb:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8042ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8042d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8042d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8042db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8042e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042e6:	75 17                	jne    8042ff <insert_sorted_with_merge_freeList+0x4bd>
  8042e8:	83 ec 04             	sub    $0x4,%esp
  8042eb:	68 d8 53 80 00       	push   $0x8053d8
  8042f0:	68 64 01 00 00       	push   $0x164
  8042f5:	68 fb 53 80 00       	push   $0x8053fb
  8042fa:	e8 2a d1 ff ff       	call   801429 <_panic>
  8042ff:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804305:	8b 45 08             	mov    0x8(%ebp),%eax
  804308:	89 10                	mov    %edx,(%eax)
  80430a:	8b 45 08             	mov    0x8(%ebp),%eax
  80430d:	8b 00                	mov    (%eax),%eax
  80430f:	85 c0                	test   %eax,%eax
  804311:	74 0d                	je     804320 <insert_sorted_with_merge_freeList+0x4de>
  804313:	a1 48 61 80 00       	mov    0x806148,%eax
  804318:	8b 55 08             	mov    0x8(%ebp),%edx
  80431b:	89 50 04             	mov    %edx,0x4(%eax)
  80431e:	eb 08                	jmp    804328 <insert_sorted_with_merge_freeList+0x4e6>
  804320:	8b 45 08             	mov    0x8(%ebp),%eax
  804323:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804328:	8b 45 08             	mov    0x8(%ebp),%eax
  80432b:	a3 48 61 80 00       	mov    %eax,0x806148
  804330:	8b 45 08             	mov    0x8(%ebp),%eax
  804333:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80433a:	a1 54 61 80 00       	mov    0x806154,%eax
  80433f:	40                   	inc    %eax
  804340:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  804345:	e9 41 02 00 00       	jmp    80458b <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80434a:	8b 45 08             	mov    0x8(%ebp),%eax
  80434d:	8b 50 08             	mov    0x8(%eax),%edx
  804350:	8b 45 08             	mov    0x8(%ebp),%eax
  804353:	8b 40 0c             	mov    0xc(%eax),%eax
  804356:	01 c2                	add    %eax,%edx
  804358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80435b:	8b 40 08             	mov    0x8(%eax),%eax
  80435e:	39 c2                	cmp    %eax,%edx
  804360:	0f 85 7c 01 00 00    	jne    8044e2 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  804366:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80436a:	74 06                	je     804372 <insert_sorted_with_merge_freeList+0x530>
  80436c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804370:	75 17                	jne    804389 <insert_sorted_with_merge_freeList+0x547>
  804372:	83 ec 04             	sub    $0x4,%esp
  804375:	68 14 54 80 00       	push   $0x805414
  80437a:	68 69 01 00 00       	push   $0x169
  80437f:	68 fb 53 80 00       	push   $0x8053fb
  804384:	e8 a0 d0 ff ff       	call   801429 <_panic>
  804389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80438c:	8b 50 04             	mov    0x4(%eax),%edx
  80438f:	8b 45 08             	mov    0x8(%ebp),%eax
  804392:	89 50 04             	mov    %edx,0x4(%eax)
  804395:	8b 45 08             	mov    0x8(%ebp),%eax
  804398:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80439b:	89 10                	mov    %edx,(%eax)
  80439d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043a0:	8b 40 04             	mov    0x4(%eax),%eax
  8043a3:	85 c0                	test   %eax,%eax
  8043a5:	74 0d                	je     8043b4 <insert_sorted_with_merge_freeList+0x572>
  8043a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043aa:	8b 40 04             	mov    0x4(%eax),%eax
  8043ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8043b0:	89 10                	mov    %edx,(%eax)
  8043b2:	eb 08                	jmp    8043bc <insert_sorted_with_merge_freeList+0x57a>
  8043b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8043b7:	a3 38 61 80 00       	mov    %eax,0x806138
  8043bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8043c2:	89 50 04             	mov    %edx,0x4(%eax)
  8043c5:	a1 44 61 80 00       	mov    0x806144,%eax
  8043ca:	40                   	inc    %eax
  8043cb:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  8043d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8043d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8043d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8043dc:	01 c2                	add    %eax,%edx
  8043de:	8b 45 08             	mov    0x8(%ebp),%eax
  8043e1:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8043e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8043e8:	75 17                	jne    804401 <insert_sorted_with_merge_freeList+0x5bf>
  8043ea:	83 ec 04             	sub    $0x4,%esp
  8043ed:	68 a4 54 80 00       	push   $0x8054a4
  8043f2:	68 6b 01 00 00       	push   $0x16b
  8043f7:	68 fb 53 80 00       	push   $0x8053fb
  8043fc:	e8 28 d0 ff ff       	call   801429 <_panic>
  804401:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804404:	8b 00                	mov    (%eax),%eax
  804406:	85 c0                	test   %eax,%eax
  804408:	74 10                	je     80441a <insert_sorted_with_merge_freeList+0x5d8>
  80440a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80440d:	8b 00                	mov    (%eax),%eax
  80440f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804412:	8b 52 04             	mov    0x4(%edx),%edx
  804415:	89 50 04             	mov    %edx,0x4(%eax)
  804418:	eb 0b                	jmp    804425 <insert_sorted_with_merge_freeList+0x5e3>
  80441a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80441d:	8b 40 04             	mov    0x4(%eax),%eax
  804420:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804425:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804428:	8b 40 04             	mov    0x4(%eax),%eax
  80442b:	85 c0                	test   %eax,%eax
  80442d:	74 0f                	je     80443e <insert_sorted_with_merge_freeList+0x5fc>
  80442f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804432:	8b 40 04             	mov    0x4(%eax),%eax
  804435:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804438:	8b 12                	mov    (%edx),%edx
  80443a:	89 10                	mov    %edx,(%eax)
  80443c:	eb 0a                	jmp    804448 <insert_sorted_with_merge_freeList+0x606>
  80443e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804441:	8b 00                	mov    (%eax),%eax
  804443:	a3 38 61 80 00       	mov    %eax,0x806138
  804448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80444b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804451:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804454:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80445b:	a1 44 61 80 00       	mov    0x806144,%eax
  804460:	48                   	dec    %eax
  804461:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  804466:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804469:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  804470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804473:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80447a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80447e:	75 17                	jne    804497 <insert_sorted_with_merge_freeList+0x655>
  804480:	83 ec 04             	sub    $0x4,%esp
  804483:	68 d8 53 80 00       	push   $0x8053d8
  804488:	68 6e 01 00 00       	push   $0x16e
  80448d:	68 fb 53 80 00       	push   $0x8053fb
  804492:	e8 92 cf ff ff       	call   801429 <_panic>
  804497:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80449d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044a0:	89 10                	mov    %edx,(%eax)
  8044a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044a5:	8b 00                	mov    (%eax),%eax
  8044a7:	85 c0                	test   %eax,%eax
  8044a9:	74 0d                	je     8044b8 <insert_sorted_with_merge_freeList+0x676>
  8044ab:	a1 48 61 80 00       	mov    0x806148,%eax
  8044b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8044b3:	89 50 04             	mov    %edx,0x4(%eax)
  8044b6:	eb 08                	jmp    8044c0 <insert_sorted_with_merge_freeList+0x67e>
  8044b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044bb:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8044c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044c3:	a3 48 61 80 00       	mov    %eax,0x806148
  8044c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044d2:	a1 54 61 80 00       	mov    0x806154,%eax
  8044d7:	40                   	inc    %eax
  8044d8:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  8044dd:	e9 a9 00 00 00       	jmp    80458b <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8044e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044e6:	74 06                	je     8044ee <insert_sorted_with_merge_freeList+0x6ac>
  8044e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8044ec:	75 17                	jne    804505 <insert_sorted_with_merge_freeList+0x6c3>
  8044ee:	83 ec 04             	sub    $0x4,%esp
  8044f1:	68 70 54 80 00       	push   $0x805470
  8044f6:	68 73 01 00 00       	push   $0x173
  8044fb:	68 fb 53 80 00       	push   $0x8053fb
  804500:	e8 24 cf ff ff       	call   801429 <_panic>
  804505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804508:	8b 10                	mov    (%eax),%edx
  80450a:	8b 45 08             	mov    0x8(%ebp),%eax
  80450d:	89 10                	mov    %edx,(%eax)
  80450f:	8b 45 08             	mov    0x8(%ebp),%eax
  804512:	8b 00                	mov    (%eax),%eax
  804514:	85 c0                	test   %eax,%eax
  804516:	74 0b                	je     804523 <insert_sorted_with_merge_freeList+0x6e1>
  804518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80451b:	8b 00                	mov    (%eax),%eax
  80451d:	8b 55 08             	mov    0x8(%ebp),%edx
  804520:	89 50 04             	mov    %edx,0x4(%eax)
  804523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804526:	8b 55 08             	mov    0x8(%ebp),%edx
  804529:	89 10                	mov    %edx,(%eax)
  80452b:	8b 45 08             	mov    0x8(%ebp),%eax
  80452e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804531:	89 50 04             	mov    %edx,0x4(%eax)
  804534:	8b 45 08             	mov    0x8(%ebp),%eax
  804537:	8b 00                	mov    (%eax),%eax
  804539:	85 c0                	test   %eax,%eax
  80453b:	75 08                	jne    804545 <insert_sorted_with_merge_freeList+0x703>
  80453d:	8b 45 08             	mov    0x8(%ebp),%eax
  804540:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804545:	a1 44 61 80 00       	mov    0x806144,%eax
  80454a:	40                   	inc    %eax
  80454b:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  804550:	eb 39                	jmp    80458b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  804552:	a1 40 61 80 00       	mov    0x806140,%eax
  804557:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80455a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80455e:	74 07                	je     804567 <insert_sorted_with_merge_freeList+0x725>
  804560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804563:	8b 00                	mov    (%eax),%eax
  804565:	eb 05                	jmp    80456c <insert_sorted_with_merge_freeList+0x72a>
  804567:	b8 00 00 00 00       	mov    $0x0,%eax
  80456c:	a3 40 61 80 00       	mov    %eax,0x806140
  804571:	a1 40 61 80 00       	mov    0x806140,%eax
  804576:	85 c0                	test   %eax,%eax
  804578:	0f 85 c7 fb ff ff    	jne    804145 <insert_sorted_with_merge_freeList+0x303>
  80457e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804582:	0f 85 bd fb ff ff    	jne    804145 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804588:	eb 01                	jmp    80458b <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80458a:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80458b:	90                   	nop
  80458c:	c9                   	leave  
  80458d:	c3                   	ret    
  80458e:	66 90                	xchg   %ax,%ax

00804590 <__udivdi3>:
  804590:	55                   	push   %ebp
  804591:	57                   	push   %edi
  804592:	56                   	push   %esi
  804593:	53                   	push   %ebx
  804594:	83 ec 1c             	sub    $0x1c,%esp
  804597:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80459b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80459f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8045a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8045a7:	89 ca                	mov    %ecx,%edx
  8045a9:	89 f8                	mov    %edi,%eax
  8045ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8045af:	85 f6                	test   %esi,%esi
  8045b1:	75 2d                	jne    8045e0 <__udivdi3+0x50>
  8045b3:	39 cf                	cmp    %ecx,%edi
  8045b5:	77 65                	ja     80461c <__udivdi3+0x8c>
  8045b7:	89 fd                	mov    %edi,%ebp
  8045b9:	85 ff                	test   %edi,%edi
  8045bb:	75 0b                	jne    8045c8 <__udivdi3+0x38>
  8045bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8045c2:	31 d2                	xor    %edx,%edx
  8045c4:	f7 f7                	div    %edi
  8045c6:	89 c5                	mov    %eax,%ebp
  8045c8:	31 d2                	xor    %edx,%edx
  8045ca:	89 c8                	mov    %ecx,%eax
  8045cc:	f7 f5                	div    %ebp
  8045ce:	89 c1                	mov    %eax,%ecx
  8045d0:	89 d8                	mov    %ebx,%eax
  8045d2:	f7 f5                	div    %ebp
  8045d4:	89 cf                	mov    %ecx,%edi
  8045d6:	89 fa                	mov    %edi,%edx
  8045d8:	83 c4 1c             	add    $0x1c,%esp
  8045db:	5b                   	pop    %ebx
  8045dc:	5e                   	pop    %esi
  8045dd:	5f                   	pop    %edi
  8045de:	5d                   	pop    %ebp
  8045df:	c3                   	ret    
  8045e0:	39 ce                	cmp    %ecx,%esi
  8045e2:	77 28                	ja     80460c <__udivdi3+0x7c>
  8045e4:	0f bd fe             	bsr    %esi,%edi
  8045e7:	83 f7 1f             	xor    $0x1f,%edi
  8045ea:	75 40                	jne    80462c <__udivdi3+0x9c>
  8045ec:	39 ce                	cmp    %ecx,%esi
  8045ee:	72 0a                	jb     8045fa <__udivdi3+0x6a>
  8045f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8045f4:	0f 87 9e 00 00 00    	ja     804698 <__udivdi3+0x108>
  8045fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8045ff:	89 fa                	mov    %edi,%edx
  804601:	83 c4 1c             	add    $0x1c,%esp
  804604:	5b                   	pop    %ebx
  804605:	5e                   	pop    %esi
  804606:	5f                   	pop    %edi
  804607:	5d                   	pop    %ebp
  804608:	c3                   	ret    
  804609:	8d 76 00             	lea    0x0(%esi),%esi
  80460c:	31 ff                	xor    %edi,%edi
  80460e:	31 c0                	xor    %eax,%eax
  804610:	89 fa                	mov    %edi,%edx
  804612:	83 c4 1c             	add    $0x1c,%esp
  804615:	5b                   	pop    %ebx
  804616:	5e                   	pop    %esi
  804617:	5f                   	pop    %edi
  804618:	5d                   	pop    %ebp
  804619:	c3                   	ret    
  80461a:	66 90                	xchg   %ax,%ax
  80461c:	89 d8                	mov    %ebx,%eax
  80461e:	f7 f7                	div    %edi
  804620:	31 ff                	xor    %edi,%edi
  804622:	89 fa                	mov    %edi,%edx
  804624:	83 c4 1c             	add    $0x1c,%esp
  804627:	5b                   	pop    %ebx
  804628:	5e                   	pop    %esi
  804629:	5f                   	pop    %edi
  80462a:	5d                   	pop    %ebp
  80462b:	c3                   	ret    
  80462c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804631:	89 eb                	mov    %ebp,%ebx
  804633:	29 fb                	sub    %edi,%ebx
  804635:	89 f9                	mov    %edi,%ecx
  804637:	d3 e6                	shl    %cl,%esi
  804639:	89 c5                	mov    %eax,%ebp
  80463b:	88 d9                	mov    %bl,%cl
  80463d:	d3 ed                	shr    %cl,%ebp
  80463f:	89 e9                	mov    %ebp,%ecx
  804641:	09 f1                	or     %esi,%ecx
  804643:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804647:	89 f9                	mov    %edi,%ecx
  804649:	d3 e0                	shl    %cl,%eax
  80464b:	89 c5                	mov    %eax,%ebp
  80464d:	89 d6                	mov    %edx,%esi
  80464f:	88 d9                	mov    %bl,%cl
  804651:	d3 ee                	shr    %cl,%esi
  804653:	89 f9                	mov    %edi,%ecx
  804655:	d3 e2                	shl    %cl,%edx
  804657:	8b 44 24 08          	mov    0x8(%esp),%eax
  80465b:	88 d9                	mov    %bl,%cl
  80465d:	d3 e8                	shr    %cl,%eax
  80465f:	09 c2                	or     %eax,%edx
  804661:	89 d0                	mov    %edx,%eax
  804663:	89 f2                	mov    %esi,%edx
  804665:	f7 74 24 0c          	divl   0xc(%esp)
  804669:	89 d6                	mov    %edx,%esi
  80466b:	89 c3                	mov    %eax,%ebx
  80466d:	f7 e5                	mul    %ebp
  80466f:	39 d6                	cmp    %edx,%esi
  804671:	72 19                	jb     80468c <__udivdi3+0xfc>
  804673:	74 0b                	je     804680 <__udivdi3+0xf0>
  804675:	89 d8                	mov    %ebx,%eax
  804677:	31 ff                	xor    %edi,%edi
  804679:	e9 58 ff ff ff       	jmp    8045d6 <__udivdi3+0x46>
  80467e:	66 90                	xchg   %ax,%ax
  804680:	8b 54 24 08          	mov    0x8(%esp),%edx
  804684:	89 f9                	mov    %edi,%ecx
  804686:	d3 e2                	shl    %cl,%edx
  804688:	39 c2                	cmp    %eax,%edx
  80468a:	73 e9                	jae    804675 <__udivdi3+0xe5>
  80468c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80468f:	31 ff                	xor    %edi,%edi
  804691:	e9 40 ff ff ff       	jmp    8045d6 <__udivdi3+0x46>
  804696:	66 90                	xchg   %ax,%ax
  804698:	31 c0                	xor    %eax,%eax
  80469a:	e9 37 ff ff ff       	jmp    8045d6 <__udivdi3+0x46>
  80469f:	90                   	nop

008046a0 <__umoddi3>:
  8046a0:	55                   	push   %ebp
  8046a1:	57                   	push   %edi
  8046a2:	56                   	push   %esi
  8046a3:	53                   	push   %ebx
  8046a4:	83 ec 1c             	sub    $0x1c,%esp
  8046a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8046ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8046af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8046b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8046b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8046bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8046bf:	89 f3                	mov    %esi,%ebx
  8046c1:	89 fa                	mov    %edi,%edx
  8046c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8046c7:	89 34 24             	mov    %esi,(%esp)
  8046ca:	85 c0                	test   %eax,%eax
  8046cc:	75 1a                	jne    8046e8 <__umoddi3+0x48>
  8046ce:	39 f7                	cmp    %esi,%edi
  8046d0:	0f 86 a2 00 00 00    	jbe    804778 <__umoddi3+0xd8>
  8046d6:	89 c8                	mov    %ecx,%eax
  8046d8:	89 f2                	mov    %esi,%edx
  8046da:	f7 f7                	div    %edi
  8046dc:	89 d0                	mov    %edx,%eax
  8046de:	31 d2                	xor    %edx,%edx
  8046e0:	83 c4 1c             	add    $0x1c,%esp
  8046e3:	5b                   	pop    %ebx
  8046e4:	5e                   	pop    %esi
  8046e5:	5f                   	pop    %edi
  8046e6:	5d                   	pop    %ebp
  8046e7:	c3                   	ret    
  8046e8:	39 f0                	cmp    %esi,%eax
  8046ea:	0f 87 ac 00 00 00    	ja     80479c <__umoddi3+0xfc>
  8046f0:	0f bd e8             	bsr    %eax,%ebp
  8046f3:	83 f5 1f             	xor    $0x1f,%ebp
  8046f6:	0f 84 ac 00 00 00    	je     8047a8 <__umoddi3+0x108>
  8046fc:	bf 20 00 00 00       	mov    $0x20,%edi
  804701:	29 ef                	sub    %ebp,%edi
  804703:	89 fe                	mov    %edi,%esi
  804705:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804709:	89 e9                	mov    %ebp,%ecx
  80470b:	d3 e0                	shl    %cl,%eax
  80470d:	89 d7                	mov    %edx,%edi
  80470f:	89 f1                	mov    %esi,%ecx
  804711:	d3 ef                	shr    %cl,%edi
  804713:	09 c7                	or     %eax,%edi
  804715:	89 e9                	mov    %ebp,%ecx
  804717:	d3 e2                	shl    %cl,%edx
  804719:	89 14 24             	mov    %edx,(%esp)
  80471c:	89 d8                	mov    %ebx,%eax
  80471e:	d3 e0                	shl    %cl,%eax
  804720:	89 c2                	mov    %eax,%edx
  804722:	8b 44 24 08          	mov    0x8(%esp),%eax
  804726:	d3 e0                	shl    %cl,%eax
  804728:	89 44 24 04          	mov    %eax,0x4(%esp)
  80472c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804730:	89 f1                	mov    %esi,%ecx
  804732:	d3 e8                	shr    %cl,%eax
  804734:	09 d0                	or     %edx,%eax
  804736:	d3 eb                	shr    %cl,%ebx
  804738:	89 da                	mov    %ebx,%edx
  80473a:	f7 f7                	div    %edi
  80473c:	89 d3                	mov    %edx,%ebx
  80473e:	f7 24 24             	mull   (%esp)
  804741:	89 c6                	mov    %eax,%esi
  804743:	89 d1                	mov    %edx,%ecx
  804745:	39 d3                	cmp    %edx,%ebx
  804747:	0f 82 87 00 00 00    	jb     8047d4 <__umoddi3+0x134>
  80474d:	0f 84 91 00 00 00    	je     8047e4 <__umoddi3+0x144>
  804753:	8b 54 24 04          	mov    0x4(%esp),%edx
  804757:	29 f2                	sub    %esi,%edx
  804759:	19 cb                	sbb    %ecx,%ebx
  80475b:	89 d8                	mov    %ebx,%eax
  80475d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804761:	d3 e0                	shl    %cl,%eax
  804763:	89 e9                	mov    %ebp,%ecx
  804765:	d3 ea                	shr    %cl,%edx
  804767:	09 d0                	or     %edx,%eax
  804769:	89 e9                	mov    %ebp,%ecx
  80476b:	d3 eb                	shr    %cl,%ebx
  80476d:	89 da                	mov    %ebx,%edx
  80476f:	83 c4 1c             	add    $0x1c,%esp
  804772:	5b                   	pop    %ebx
  804773:	5e                   	pop    %esi
  804774:	5f                   	pop    %edi
  804775:	5d                   	pop    %ebp
  804776:	c3                   	ret    
  804777:	90                   	nop
  804778:	89 fd                	mov    %edi,%ebp
  80477a:	85 ff                	test   %edi,%edi
  80477c:	75 0b                	jne    804789 <__umoddi3+0xe9>
  80477e:	b8 01 00 00 00       	mov    $0x1,%eax
  804783:	31 d2                	xor    %edx,%edx
  804785:	f7 f7                	div    %edi
  804787:	89 c5                	mov    %eax,%ebp
  804789:	89 f0                	mov    %esi,%eax
  80478b:	31 d2                	xor    %edx,%edx
  80478d:	f7 f5                	div    %ebp
  80478f:	89 c8                	mov    %ecx,%eax
  804791:	f7 f5                	div    %ebp
  804793:	89 d0                	mov    %edx,%eax
  804795:	e9 44 ff ff ff       	jmp    8046de <__umoddi3+0x3e>
  80479a:	66 90                	xchg   %ax,%ax
  80479c:	89 c8                	mov    %ecx,%eax
  80479e:	89 f2                	mov    %esi,%edx
  8047a0:	83 c4 1c             	add    $0x1c,%esp
  8047a3:	5b                   	pop    %ebx
  8047a4:	5e                   	pop    %esi
  8047a5:	5f                   	pop    %edi
  8047a6:	5d                   	pop    %ebp
  8047a7:	c3                   	ret    
  8047a8:	3b 04 24             	cmp    (%esp),%eax
  8047ab:	72 06                	jb     8047b3 <__umoddi3+0x113>
  8047ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8047b1:	77 0f                	ja     8047c2 <__umoddi3+0x122>
  8047b3:	89 f2                	mov    %esi,%edx
  8047b5:	29 f9                	sub    %edi,%ecx
  8047b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8047bb:	89 14 24             	mov    %edx,(%esp)
  8047be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8047c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8047c6:	8b 14 24             	mov    (%esp),%edx
  8047c9:	83 c4 1c             	add    $0x1c,%esp
  8047cc:	5b                   	pop    %ebx
  8047cd:	5e                   	pop    %esi
  8047ce:	5f                   	pop    %edi
  8047cf:	5d                   	pop    %ebp
  8047d0:	c3                   	ret    
  8047d1:	8d 76 00             	lea    0x0(%esi),%esi
  8047d4:	2b 04 24             	sub    (%esp),%eax
  8047d7:	19 fa                	sbb    %edi,%edx
  8047d9:	89 d1                	mov    %edx,%ecx
  8047db:	89 c6                	mov    %eax,%esi
  8047dd:	e9 71 ff ff ff       	jmp    804753 <__umoddi3+0xb3>
  8047e2:	66 90                	xchg   %ax,%ax
  8047e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8047e8:	72 ea                	jb     8047d4 <__umoddi3+0x134>
  8047ea:	89 d9                	mov    %ebx,%ecx
  8047ec:	e9 62 ff ff ff       	jmp    804753 <__umoddi3+0xb3>
