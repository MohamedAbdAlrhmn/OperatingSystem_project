
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
  800065:	68 c0 48 80 00       	push   $0x8048c0
  80006a:	e8 6e 16 00 00       	call   8016dd <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800072:	e8 0b 2a 00 00       	call   802a82 <sys_calculate_free_frames>
  800077:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80007a:	e8 a3 2a 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  8000aa:	68 e4 48 80 00       	push   $0x8048e4
  8000af:	6a 11                	push   $0x11
  8000b1:	68 14 49 80 00       	push   $0x804914
  8000b6:	e8 6e 13 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000be:	e8 bf 29 00 00       	call   802a82 <sys_calculate_free_frames>
  8000c3:	29 c3                	sub    %eax,%ebx
  8000c5:	89 d8                	mov    %ebx,%eax
  8000c7:	83 f8 01             	cmp    $0x1,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 2c 49 80 00       	push   $0x80492c
  8000d4:	6a 13                	push   $0x13
  8000d6:	68 14 49 80 00       	push   $0x804914
  8000db:	e8 49 13 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8000e0:	e8 3d 2a 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  8000e5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8000e8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 98 49 80 00       	push   $0x804998
  8000f7:	6a 14                	push   $0x14
  8000f9:	68 14 49 80 00       	push   $0x804914
  8000fe:	e8 26 13 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800103:	e8 7a 29 00 00       	call   802a82 <sys_calculate_free_frames>
  800108:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 12 2a 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  800142:	68 e4 48 80 00       	push   $0x8048e4
  800147:	6a 1a                	push   $0x1a
  800149:	68 14 49 80 00       	push   $0x804914
  80014e:	e8 d6 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800153:	e8 2a 29 00 00       	call   802a82 <sys_calculate_free_frames>
  800158:	89 c2                	mov    %eax,%edx
  80015a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015d:	39 c2                	cmp    %eax,%edx
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 2c 49 80 00       	push   $0x80492c
  800169:	6a 1c                	push   $0x1c
  80016b:	68 14 49 80 00       	push   $0x804914
  800170:	e8 b4 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800175:	e8 a8 29 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  80017a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017d:	3d 00 01 00 00       	cmp    $0x100,%eax
  800182:	74 14                	je     800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 98 49 80 00       	push   $0x804998
  80018c:	6a 1d                	push   $0x1d
  80018e:	68 14 49 80 00       	push   $0x804914
  800193:	e8 91 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800198:	e8 e5 28 00 00       	call   802a82 <sys_calculate_free_frames>
  80019d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001a0:	e8 7d 29 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  8001d3:	68 e4 48 80 00       	push   $0x8048e4
  8001d8:	6a 23                	push   $0x23
  8001da:	68 14 49 80 00       	push   $0x804914
  8001df:	e8 45 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001e4:	e8 99 28 00 00       	call   802a82 <sys_calculate_free_frames>
  8001e9:	89 c2                	mov    %eax,%edx
  8001eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	74 14                	je     800206 <_main+0x1ce>
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	68 2c 49 80 00       	push   $0x80492c
  8001fa:	6a 25                	push   $0x25
  8001fc:	68 14 49 80 00       	push   $0x804914
  800201:	e8 23 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800206:	e8 17 29 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  80020b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80020e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800213:	74 14                	je     800229 <_main+0x1f1>
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	68 98 49 80 00       	push   $0x804998
  80021d:	6a 26                	push   $0x26
  80021f:	68 14 49 80 00       	push   $0x804914
  800224:	e8 00 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800229:	e8 54 28 00 00       	call   802a82 <sys_calculate_free_frames>
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800231:	e8 ec 28 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  800268:	68 e4 48 80 00       	push   $0x8048e4
  80026d:	6a 2c                	push   $0x2c
  80026f:	68 14 49 80 00       	push   $0x804914
  800274:	e8 b0 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800279:	e8 04 28 00 00       	call   802a82 <sys_calculate_free_frames>
  80027e:	89 c2                	mov    %eax,%edx
  800280:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 2c 49 80 00       	push   $0x80492c
  80028f:	6a 2e                	push   $0x2e
  800291:	68 14 49 80 00       	push   $0x804914
  800296:	e8 8e 11 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80029b:	e8 82 28 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  8002a0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002a3:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002a8:	74 14                	je     8002be <_main+0x286>
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 98 49 80 00       	push   $0x804998
  8002b2:	6a 2f                	push   $0x2f
  8002b4:	68 14 49 80 00       	push   $0x804914
  8002b9:	e8 6b 11 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002be:	e8 bf 27 00 00       	call   802a82 <sys_calculate_free_frames>
  8002c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002c6:	e8 57 28 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  8002fc:	68 e4 48 80 00       	push   $0x8048e4
  800301:	6a 35                	push   $0x35
  800303:	68 14 49 80 00       	push   $0x804914
  800308:	e8 1c 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80030d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800310:	e8 6d 27 00 00       	call   802a82 <sys_calculate_free_frames>
  800315:	29 c3                	sub    %eax,%ebx
  800317:	89 d8                	mov    %ebx,%eax
  800319:	83 f8 01             	cmp    $0x1,%eax
  80031c:	74 14                	je     800332 <_main+0x2fa>
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	68 2c 49 80 00       	push   $0x80492c
  800326:	6a 37                	push   $0x37
  800328:	68 14 49 80 00       	push   $0x804914
  80032d:	e8 f7 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800332:	e8 eb 27 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  800337:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80033a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033f:	74 14                	je     800355 <_main+0x31d>
  800341:	83 ec 04             	sub    $0x4,%esp
  800344:	68 98 49 80 00       	push   $0x804998
  800349:	6a 38                	push   $0x38
  80034b:	68 14 49 80 00       	push   $0x804914
  800350:	e8 d4 10 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800355:	e8 28 27 00 00       	call   802a82 <sys_calculate_free_frames>
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035d:	e8 c0 27 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  800398:	68 e4 48 80 00       	push   $0x8048e4
  80039d:	6a 3e                	push   $0x3e
  80039f:	68 14 49 80 00       	push   $0x804914
  8003a4:	e8 80 10 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003a9:	e8 d4 26 00 00       	call   802a82 <sys_calculate_free_frames>
  8003ae:	89 c2                	mov    %eax,%edx
  8003b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 2c 49 80 00       	push   $0x80492c
  8003bf:	6a 40                	push   $0x40
  8003c1:	68 14 49 80 00       	push   $0x804914
  8003c6:	e8 5e 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003cb:	e8 52 27 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  8003d0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 98 49 80 00       	push   $0x804998
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 14 49 80 00       	push   $0x804914
  8003e9:	e8 3b 10 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003ee:	e8 8f 26 00 00       	call   802a82 <sys_calculate_free_frames>
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003f6:	e8 27 27 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  800430:	68 e4 48 80 00       	push   $0x8048e4
  800435:	6a 47                	push   $0x47
  800437:	68 14 49 80 00       	push   $0x804914
  80043c:	e8 e8 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800441:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800444:	e8 39 26 00 00       	call   802a82 <sys_calculate_free_frames>
  800449:	29 c3                	sub    %eax,%ebx
  80044b:	89 d8                	mov    %ebx,%eax
  80044d:	83 f8 01             	cmp    $0x1,%eax
  800450:	74 14                	je     800466 <_main+0x42e>
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	68 2c 49 80 00       	push   $0x80492c
  80045a:	6a 49                	push   $0x49
  80045c:	68 14 49 80 00       	push   $0x804914
  800461:	e8 c3 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800466:	e8 b7 26 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  80046b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80046e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 98 49 80 00       	push   $0x804998
  80047d:	6a 4a                	push   $0x4a
  80047f:	68 14 49 80 00       	push   $0x804914
  800484:	e8 a0 0f 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800489:	e8 f4 25 00 00       	call   802a82 <sys_calculate_free_frames>
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800491:	e8 8c 26 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  8004d3:	68 e4 48 80 00       	push   $0x8048e4
  8004d8:	6a 50                	push   $0x50
  8004da:	68 14 49 80 00       	push   $0x804914
  8004df:	e8 45 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004e4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e7:	e8 96 25 00 00       	call   802a82 <sys_calculate_free_frames>
  8004ec:	29 c3                	sub    %eax,%ebx
  8004ee:	89 d8                	mov    %ebx,%eax
  8004f0:	83 f8 01             	cmp    $0x1,%eax
  8004f3:	74 14                	je     800509 <_main+0x4d1>
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 2c 49 80 00       	push   $0x80492c
  8004fd:	6a 52                	push   $0x52
  8004ff:	68 14 49 80 00       	push   $0x804914
  800504:	e8 20 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800509:	e8 14 26 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  80050e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800511:	3d 00 03 00 00       	cmp    $0x300,%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 98 49 80 00       	push   $0x804998
  800520:	6a 53                	push   $0x53
  800522:	68 14 49 80 00       	push   $0x804914
  800527:	e8 fd 0e 00 00       	call   801429 <_panic>

		//Allocate the remaining space in user heap
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 51 25 00 00       	call   802a82 <sys_calculate_free_frames>
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800534:	e8 e9 25 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  80058a:	68 e4 48 80 00       	push   $0x8048e4
  80058f:	6a 59                	push   $0x59
  800591:	68 14 49 80 00       	push   $0x804914
  800596:	e8 8e 0e 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80059b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059e:	e8 df 24 00 00       	call   802a82 <sys_calculate_free_frames>
  8005a3:	29 c3                	sub    %eax,%ebx
  8005a5:	89 d8                	mov    %ebx,%eax
  8005a7:	83 f8 7c             	cmp    $0x7c,%eax
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 2c 49 80 00       	push   $0x80492c
  8005b4:	6a 5b                	push   $0x5b
  8005b6:	68 14 49 80 00       	push   $0x804914
  8005bb:	e8 69 0e 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005c0:	e8 5d 25 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  8005c5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8005c8:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005cd:	74 14                	je     8005e3 <_main+0x5ab>
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 98 49 80 00       	push   $0x804998
  8005d7:	6a 5c                	push   $0x5c
  8005d9:	68 14 49 80 00       	push   $0x804914
  8005de:	e8 46 0e 00 00       	call   801429 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005e3:	e8 9a 24 00 00       	call   802a82 <sys_calculate_free_frames>
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005eb:	e8 32 25 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  8005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  8005f3:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	e8 de 20 00 00       	call   8026e0 <free>
  800602:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800605:	e8 18 25 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  80060a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80060d:	29 c2                	sub    %eax,%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	3d 00 01 00 00       	cmp    $0x100,%eax
  800616:	74 14                	je     80062c <_main+0x5f4>
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	68 c8 49 80 00       	push   $0x8049c8
  800620:	6a 67                	push   $0x67
  800622:	68 14 49 80 00       	push   $0x804914
  800627:	e8 fd 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80062c:	e8 51 24 00 00       	call   802a82 <sys_calculate_free_frames>
  800631:	89 c2                	mov    %eax,%edx
  800633:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800636:	39 c2                	cmp    %eax,%edx
  800638:	74 14                	je     80064e <_main+0x616>
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	68 04 4a 80 00       	push   $0x804a04
  800642:	6a 68                	push   $0x68
  800644:	68 14 49 80 00       	push   $0x804914
  800649:	e8 db 0d 00 00       	call   801429 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80064e:	e8 2f 24 00 00       	call   802a82 <sys_calculate_free_frames>
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800656:	e8 c7 24 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  80065b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  80065e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800661:	83 ec 0c             	sub    $0xc,%esp
  800664:	50                   	push   %eax
  800665:	e8 76 20 00 00       	call   8026e0 <free>
  80066a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80066d:	e8 b0 24 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  800672:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800675:	29 c2                	sub    %eax,%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	3d 00 02 00 00       	cmp    $0x200,%eax
  80067e:	74 14                	je     800694 <_main+0x65c>
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	68 c8 49 80 00       	push   $0x8049c8
  800688:	6a 6f                	push   $0x6f
  80068a:	68 14 49 80 00       	push   $0x804914
  80068f:	e8 95 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800694:	e8 e9 23 00 00       	call   802a82 <sys_calculate_free_frames>
  800699:	89 c2                	mov    %eax,%edx
  80069b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069e:	39 c2                	cmp    %eax,%edx
  8006a0:	74 14                	je     8006b6 <_main+0x67e>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 04 4a 80 00       	push   $0x804a04
  8006aa:	6a 70                	push   $0x70
  8006ac:	68 14 49 80 00       	push   $0x804914
  8006b1:	e8 73 0d 00 00       	call   801429 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006b6:	e8 c7 23 00 00       	call   802a82 <sys_calculate_free_frames>
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006be:	e8 5f 24 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  8006c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  8006c6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006c9:	83 ec 0c             	sub    $0xc,%esp
  8006cc:	50                   	push   %eax
  8006cd:	e8 0e 20 00 00       	call   8026e0 <free>
  8006d2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006d5:	e8 48 24 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  8006da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006dd:	29 c2                	sub    %eax,%edx
  8006df:	89 d0                	mov    %edx,%eax
  8006e1:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006e6:	74 14                	je     8006fc <_main+0x6c4>
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	68 c8 49 80 00       	push   $0x8049c8
  8006f0:	6a 77                	push   $0x77
  8006f2:	68 14 49 80 00       	push   $0x804914
  8006f7:	e8 2d 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006fc:	e8 81 23 00 00       	call   802a82 <sys_calculate_free_frames>
  800701:	89 c2                	mov    %eax,%edx
  800703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 14                	je     80071e <_main+0x6e6>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 04 4a 80 00       	push   $0x804a04
  800712:	6a 78                	push   $0x78
  800714:	68 14 49 80 00       	push   $0x804914
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
  80072a:	e8 eb 26 00 00       	call   802e1a <sys_bypassPageFault>
  80072f:	83 c4 10             	add    $0x10,%esp

	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate with size = 0*/

		char *byteArr = (char *) ptr_allocations[0];
  800732:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//Reallocate with size = 0 [delete it]
		freeFrames = sys_calculate_free_frames() ;
  80073b:	e8 42 23 00 00       	call   802a82 <sys_calculate_free_frames>
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800743:	e8 da 23 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  800748:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 0);
  80074b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	6a 00                	push   $0x0
  800756:	50                   	push   %eax
  800757:	e8 a4 21 00 00       	call   802900 <realloc>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != 0) panic("Wrong start address for the re-allocated space...it should return NULL!");
  800765:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80076b:	85 c0                	test   %eax,%eax
  80076d:	74 17                	je     800786 <_main+0x74e>
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	68 50 4a 80 00       	push   $0x804a50
  800777:	68 94 00 00 00       	push   $0x94
  80077c:	68 14 49 80 00       	push   $0x804914
  800781:	e8 a3 0c 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800786:	e8 f7 22 00 00       	call   802a82 <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	39 c2                	cmp    %eax,%edx
  800792:	74 17                	je     8007ab <_main+0x773>
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	68 98 4a 80 00       	push   $0x804a98
  80079c:	68 96 00 00 00       	push   $0x96
  8007a1:	68 14 49 80 00       	push   $0x804914
  8007a6:	e8 7e 0c 00 00       	call   801429 <_panic>
		if((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8007ab:	e8 72 23 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  8007b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007b3:	29 c2                	sub    %eax,%edx
  8007b5:	89 d0                	mov    %edx,%eax
  8007b7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 08 4b 80 00       	push   $0x804b08
  8007c6:	68 97 00 00 00       	push   $0x97
  8007cb:	68 14 49 80 00       	push   $0x804914
  8007d0:	e8 54 0c 00 00       	call   801429 <_panic>

		//[2] test memory access
		byteArr[0] = 10;
  8007d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("successful access to re-allocated space with size 0!! it should not be succeeded");
  8007db:	e8 21 26 00 00       	call   802e01 <sys_rcr2>
  8007e0:	89 c2                	mov    %eax,%edx
  8007e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 17                	je     800800 <_main+0x7c8>
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 3c 4b 80 00       	push   $0x804b3c
  8007f1:	68 9b 00 00 00       	push   $0x9b
  8007f6:	68 14 49 80 00       	push   $0x804914
  8007fb:	e8 29 0c 00 00       	call   801429 <_panic>
		byteArr[(1*Mega-kilo)/sizeof(char) - 1] = 10;
  800800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800803:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800806:	8d 50 ff             	lea    -0x1(%eax),%edx
  800809:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[(1*Mega-kilo)/sizeof(char) - 1])) panic("successful access to reallocated space of size 0!! it should not be succeeded");
  800811:	e8 eb 25 00 00       	call   802e01 <sys_rcr2>
  800816:	89 c2                	mov    %eax,%edx
  800818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80081e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800821:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800824:	01 c8                	add    %ecx,%eax
  800826:	39 c2                	cmp    %eax,%edx
  800828:	74 17                	je     800841 <_main+0x809>
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	68 90 4b 80 00       	push   $0x804b90
  800832:	68 9d 00 00 00       	push   $0x9d
  800837:	68 14 49 80 00       	push   $0x804914
  80083c:	e8 e8 0b 00 00       	call   801429 <_panic>

		//set it to 0 again to cancel the bypassing option
		sys_bypassPageFault(0);
  800841:	83 ec 0c             	sub    $0xc,%esp
  800844:	6a 00                	push   $0x0
  800846:	e8 cf 25 00 00       	call   802e1a <sys_bypassPageFault>
  80084b:	83 c4 10             	add    $0x10,%esp

		vcprintf("\b\b\b20%", NULL);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	6a 00                	push   $0x0
  800853:	68 de 4b 80 00       	push   $0x804bde
  800858:	e8 15 0e 00 00       	call   801672 <vcprintf>
  80085d:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate with address = NULL*/

		//new allocation with size = 2.5 MB, should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800860:	e8 1d 22 00 00       	call   802a82 <sys_calculate_free_frames>
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800868:	e8 b5 22 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  800889:	e8 72 20 00 00       	call   802900 <realloc>
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
  8008ab:	68 e4 48 80 00       	push   $0x8048e4
  8008b0:	68 aa 00 00 00       	push   $0xaa
  8008b5:	68 14 49 80 00       	push   $0x804914
  8008ba:	e8 6a 0b 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 640) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008bf:	e8 be 21 00 00       	call   802a82 <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	68 98 4a 80 00       	push   $0x804a98
  8008d5:	68 ac 00 00 00       	push   $0xac
  8008da:	68 14 49 80 00       	push   $0x804914
  8008df:	e8 45 0b 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 640) panic("Extra or less pages are re-allocated in PageFile");
  8008e4:	e8 39 22 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  8008e9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008ec:	3d 80 02 00 00       	cmp    $0x280,%eax
  8008f1:	74 17                	je     80090a <_main+0x8d2>
  8008f3:	83 ec 04             	sub    $0x4,%esp
  8008f6:	68 08 4b 80 00       	push   $0x804b08
  8008fb:	68 ad 00 00 00       	push   $0xad
  800900:	68 14 49 80 00       	push   $0x804914
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
  8009a6:	68 e8 4b 80 00       	push   $0x804be8
  8009ab:	68 ca 00 00 00       	push   $0xca
  8009b0:	68 14 49 80 00       	push   $0x804914
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
  8009e7:	68 e8 4b 80 00       	push   $0x804be8
  8009ec:	68 d0 00 00 00       	push   $0xd0
  8009f1:	68 14 49 80 00       	push   $0x804914
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
  800a0e:	68 20 4c 80 00       	push   $0x804c20
  800a13:	e8 5a 0c 00 00       	call   801672 <vcprintf>
  800a18:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate in the existing internal fragment (no additional pages are required)*/

		//Reallocate last allocation with 1 extra KB [should be placed in the existing 2 KB internal fragment]
		freeFrames = sys_calculate_free_frames() ;
  800a1b:	e8 62 20 00 00       	call   802a82 <sys_calculate_free_frames>
  800a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a23:	e8 fa 20 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  800a4f:	e8 ac 1e 00 00       	call   802900 <realloc>
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
  800a71:	68 28 4c 80 00       	push   $0x804c28
  800a76:	68 dc 00 00 00       	push   $0xdc
  800a7b:	68 14 49 80 00       	push   $0x804914
  800a80:	e8 a4 09 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");

		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800a85:	e8 f8 1f 00 00       	call   802a82 <sys_calculate_free_frames>
  800a8a:	89 c2                	mov    %eax,%edx
  800a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8f:	39 c2                	cmp    %eax,%edx
  800a91:	74 17                	je     800aaa <_main+0xa72>
  800a93:	83 ec 04             	sub    $0x4,%esp
  800a96:	68 98 4a 80 00       	push   $0x804a98
  800a9b:	68 df 00 00 00       	push   $0xdf
  800aa0:	68 14 49 80 00       	push   $0x804914
  800aa5:	e8 7f 09 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800aaa:	e8 73 20 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  800aaf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 08 4b 80 00       	push   $0x804b08
  800abc:	68 e0 00 00 00       	push   $0xe0
  800ac1:	68 14 49 80 00       	push   $0x804914
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
  800b66:	68 e8 4b 80 00       	push   $0x804be8
  800b6b:	68 f4 00 00 00       	push   $0xf4
  800b70:	68 14 49 80 00       	push   $0x804914
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
  800ba8:	68 e8 4b 80 00       	push   $0x804be8
  800bad:	68 f9 00 00 00       	push   $0xf9
  800bb2:	68 14 49 80 00       	push   $0x804914
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
  800bef:	68 e8 4b 80 00       	push   $0x804be8
  800bf4:	68 fe 00 00 00       	push   $0xfe
  800bf9:	68 14 49 80 00       	push   $0x804914
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
  800c35:	68 e8 4b 80 00       	push   $0x804be8
  800c3a:	68 03 01 00 00       	push   $0x103
  800c3f:	68 14 49 80 00       	push   $0x804914
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
  800c57:	e8 26 1e 00 00       	call   802a82 <sys_calculate_free_frames>
  800c5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c5f:	e8 be 1e 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  800c64:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[10]);
  800c67:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	e8 6d 1a 00 00       	call   8026e0 <free>
  800c73:	83 c4 10             	add    $0x10,%esp

		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800c76:	e8 a7 1e 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  800c7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c7e:	29 c2                	sub    %eax,%edx
  800c80:	89 d0                	mov    %edx,%eax
  800c82:	3d 80 02 00 00       	cmp    $0x280,%eax
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 5c 4c 80 00       	push   $0x804c5c
  800c91:	68 0d 01 00 00       	push   $0x10d
  800c96:	68 14 49 80 00       	push   $0x804914
  800c9b:	e8 89 07 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800ca0:	e8 dd 1d 00 00       	call   802a82 <sys_calculate_free_frames>
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800caa:	29 c2                	sub    %eax,%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	83 f8 03             	cmp    $0x3,%eax
  800cb1:	74 17                	je     800cca <_main+0xc92>
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	68 b0 4c 80 00       	push   $0x804cb0
  800cbb:	68 0e 01 00 00       	push   $0x10e
  800cc0:	68 14 49 80 00       	push   $0x804914
  800cc5:	e8 5f 07 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b60%", NULL);
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	6a 00                	push   $0x0
  800ccf:	68 14 4d 80 00       	push   $0x804d14
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
  800d43:	e8 3a 1d 00 00       	call   802a82 <sys_calculate_free_frames>
  800d48:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d4b:	e8 d2 1d 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  800d77:	e8 84 1b 00 00       	call   802900 <realloc>
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	89 45 80             	mov    %eax,-0x80(%ebp)

		//cprintf("%x\n", ptr_allocations[2]);
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[2] != 0) panic("Wrong start address for the re-allocated space... ");
  800d82:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d85:	85 c0                	test   %eax,%eax
  800d87:	74 17                	je     800da0 <_main+0xd68>
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	68 28 4c 80 00       	push   $0x804c28
  800d91:	68 2d 01 00 00       	push   $0x12d
  800d96:	68 14 49 80 00       	push   $0x804914
  800d9b:	e8 89 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800da0:	e8 dd 1c 00 00       	call   802a82 <sys_calculate_free_frames>
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800daa:	39 c2                	cmp    %eax,%edx
  800dac:	74 17                	je     800dc5 <_main+0xd8d>
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	68 98 4a 80 00       	push   $0x804a98
  800db6:	68 2f 01 00 00       	push   $0x12f
  800dbb:	68 14 49 80 00       	push   $0x804914
  800dc0:	e8 64 06 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800dc5:	e8 58 1d 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  800dca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dcd:	74 17                	je     800de6 <_main+0xdae>
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	68 08 4b 80 00       	push   $0x804b08
  800dd7:	68 30 01 00 00       	push   $0x130
  800ddc:	68 14 49 80 00       	push   $0x804914
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
  800e0b:	68 e8 4b 80 00       	push   $0x804be8
  800e10:	68 36 01 00 00       	push   $0x136
  800e15:	68 14 49 80 00       	push   $0x804914
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
  800e4c:	68 e8 4b 80 00       	push   $0x804be8
  800e51:	68 3c 01 00 00       	push   $0x13c
  800e56:	68 14 49 80 00       	push   $0x804914
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
  800e6e:	e8 0f 1c 00 00       	call   802a82 <sys_calculate_free_frames>
  800e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e76:	e8 a7 1c 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  800e7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(origAddress);
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	ff 75 c8             	pushl  -0x38(%ebp)
  800e84:	e8 57 18 00 00       	call   8026e0 <free>
  800e89:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e8c:	e8 91 1c 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  800e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800e94:	29 c2                	sub    %eax,%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	3d 00 01 00 00       	cmp    $0x100,%eax
  800e9d:	74 17                	je     800eb6 <_main+0xe7e>
  800e9f:	83 ec 04             	sub    $0x4,%esp
  800ea2:	68 5c 4c 80 00       	push   $0x804c5c
  800ea7:	68 44 01 00 00       	push   $0x144
  800eac:	68 14 49 80 00       	push   $0x804914
  800eb1:	e8 73 05 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800eb6:	e8 c7 1b 00 00       	call   802a82 <sys_calculate_free_frames>
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	83 f8 03             	cmp    $0x3,%eax
  800ec7:	74 17                	je     800ee0 <_main+0xea8>
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	68 b0 4c 80 00       	push   $0x804cb0
  800ed1:	68 45 01 00 00       	push   $0x145
  800ed6:	68 14 49 80 00       	push   $0x804914
  800edb:	e8 49 05 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b80%", NULL);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	6a 00                	push   $0x0
  800ee5:	68 1b 4d 80 00       	push   $0x804d1b
  800eea:	e8 83 07 00 00       	call   801672 <vcprintf>
  800eef:	83 c4 10             	add    $0x10,%esp
		/*CASE5: Re-allocate that test FIRST FIT strategy*/

		//[1] create 4 MB hole at beginning of the heap

		//Take 2 MB from currently 3 MB hole at beginning of the heap
		freeFrames = sys_calculate_free_frames() ;
  800ef2:	e8 8b 1b 00 00       	call   802a82 <sys_calculate_free_frames>
  800ef7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800efa:	e8 23 1c 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  800f26:	68 e4 48 80 00       	push   $0x8048e4
  800f2b:	68 51 01 00 00       	push   $0x151
  800f30:	68 14 49 80 00       	push   $0x804914
  800f35:	e8 ef 04 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800f3a:	e8 43 1b 00 00       	call   802a82 <sys_calculate_free_frames>
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	39 c2                	cmp    %eax,%edx
  800f46:	74 17                	je     800f5f <_main+0xf27>
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	68 2c 49 80 00       	push   $0x80492c
  800f50:	68 53 01 00 00       	push   $0x153
  800f55:	68 14 49 80 00       	push   $0x804914
  800f5a:	e8 ca 04 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800f5f:	e8 be 1b 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  800f64:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800f67:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f6c:	74 17                	je     800f85 <_main+0xf4d>
  800f6e:	83 ec 04             	sub    $0x4,%esp
  800f71:	68 98 49 80 00       	push   $0x804998
  800f76:	68 54 01 00 00       	push   $0x154
  800f7b:	68 14 49 80 00       	push   $0x804914
  800f80:	e8 a4 04 00 00       	call   801429 <_panic>

		//remove 1 MB allocation between 1 MB hole and 2 MB hole to create 4 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f85:	e8 f8 1a 00 00       	call   802a82 <sys_calculate_free_frames>
  800f8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8d:	e8 90 1b 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  800f92:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800f95:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	e8 3f 17 00 00       	call   8026e0 <free>
  800fa1:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fa4:	e8 79 1b 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  800fa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	3d 00 01 00 00       	cmp    $0x100,%eax
  800fb5:	74 17                	je     800fce <_main+0xf96>
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	68 c8 49 80 00       	push   $0x8049c8
  800fbf:	68 5b 01 00 00       	push   $0x15b
  800fc4:	68 14 49 80 00       	push   $0x804914
  800fc9:	e8 5b 04 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fce:	e8 af 1a 00 00       	call   802a82 <sys_calculate_free_frames>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd8:	39 c2                	cmp    %eax,%edx
  800fda:	74 17                	je     800ff3 <_main+0xfbb>
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 04 4a 80 00       	push   $0x804a04
  800fe4:	68 5c 01 00 00       	push   $0x15c
  800fe9:	68 14 49 80 00       	push   $0x804914
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
  80107c:	e8 01 1a 00 00       	call   802a82 <sys_calculate_free_frames>
  801081:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801084:	e8 99 1a 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
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
  80109f:	e8 5c 18 00 00       	call   802900 <realloc>
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
  8010c0:	68 28 4c 80 00       	push   $0x804c28
  8010c5:	68 7d 01 00 00       	push   $0x17d
  8010ca:	68 14 49 80 00       	push   $0x804914
  8010cf:	e8 55 03 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 - 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 2) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8010d4:	e8 49 1a 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  8010d9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8010dc:	3d 00 01 00 00       	cmp    $0x100,%eax
  8010e1:	74 17                	je     8010fa <_main+0x10c2>
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	68 08 4b 80 00       	push   $0x804b08
  8010eb:	68 80 01 00 00       	push   $0x180
  8010f0:	68 14 49 80 00       	push   $0x804914
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
  80118a:	68 e8 4b 80 00       	push   $0x804be8
  80118f:	68 93 01 00 00       	push   $0x193
  801194:	68 14 49 80 00       	push   $0x804914
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
  8011cb:	68 e8 4b 80 00       	push   $0x804be8
  8011d0:	68 99 01 00 00       	push   $0x199
  8011d5:	68 14 49 80 00       	push   $0x804914
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
  801212:	68 e8 4b 80 00       	push   $0x804be8
  801217:	68 9f 01 00 00       	push   $0x19f
  80121c:	68 14 49 80 00       	push   $0x804914
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
  801258:	68 e8 4b 80 00       	push   $0x804be8
  80125d:	68 a5 01 00 00       	push   $0x1a5
  801262:	68 14 49 80 00       	push   $0x804914
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
  80127a:	e8 03 18 00 00       	call   802a82 <sys_calculate_free_frames>
  80127f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801282:	e8 9b 18 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  801287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[7]);
  80128a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 4a 14 00 00       	call   8026e0 <free>
  801296:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  801299:	e8 84 18 00 00       	call   802b22 <sys_pf_calculate_allocated_pages>
  80129e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012a1:	29 c2                	sub    %eax,%edx
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012aa:	74 17                	je     8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 5c 4c 80 00       	push   $0x804c5c
  8012b4:	68 ad 01 00 00       	push   $0x1ad
  8012b9:	68 14 49 80 00       	push   $0x804914
  8012be:	e8 66 01 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	6a 00                	push   $0x0
  8012c8:	68 22 4d 80 00       	push   $0x804d22
  8012cd:	e8 a0 03 00 00       	call   801672 <vcprintf>
  8012d2:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [2] completed successfully.\n");
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	68 2c 4d 80 00       	push   $0x804d2c
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
  8012f3:	e8 6a 1a 00 00       	call   802d62 <sys_getenvindex>
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
  80135e:	e8 0c 18 00 00       	call   802b6f <sys_disable_interrupt>
	cprintf("**************************************\n");
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	68 80 4d 80 00       	push   $0x804d80
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
  80138e:	68 a8 4d 80 00       	push   $0x804da8
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
  8013bf:	68 d0 4d 80 00       	push   $0x804dd0
  8013c4:	e8 14 03 00 00       	call   8016dd <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8013cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8013d1:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	50                   	push   %eax
  8013db:	68 28 4e 80 00       	push   $0x804e28
  8013e0:	e8 f8 02 00 00       	call   8016dd <cprintf>
  8013e5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	68 80 4d 80 00       	push   $0x804d80
  8013f0:	e8 e8 02 00 00       	call   8016dd <cprintf>
  8013f5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8013f8:	e8 8c 17 00 00       	call   802b89 <sys_enable_interrupt>

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
  801410:	e8 19 19 00 00       	call   802d2e <sys_destroy_env>
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
  801421:	e8 6e 19 00 00       	call   802d94 <sys_exit_env>
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
  80144a:	68 3c 4e 80 00       	push   $0x804e3c
  80144f:	e8 89 02 00 00       	call   8016dd <cprintf>
  801454:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801457:	a1 00 60 80 00       	mov    0x806000,%eax
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	ff 75 08             	pushl  0x8(%ebp)
  801462:	50                   	push   %eax
  801463:	68 41 4e 80 00       	push   $0x804e41
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
  801487:	68 5d 4e 80 00       	push   $0x804e5d
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
  8014b3:	68 60 4e 80 00       	push   $0x804e60
  8014b8:	6a 26                	push   $0x26
  8014ba:	68 ac 4e 80 00       	push   $0x804eac
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
  801585:	68 b8 4e 80 00       	push   $0x804eb8
  80158a:	6a 3a                	push   $0x3a
  80158c:	68 ac 4e 80 00       	push   $0x804eac
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
  8015f5:	68 0c 4f 80 00       	push   $0x804f0c
  8015fa:	6a 44                	push   $0x44
  8015fc:	68 ac 4e 80 00       	push   $0x804eac
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
  80164f:	e8 6d 13 00 00       	call   8029c1 <sys_cputs>
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
  8016c6:	e8 f6 12 00 00       	call   8029c1 <sys_cputs>
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
  801710:	e8 5a 14 00 00       	call   802b6f <sys_disable_interrupt>
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
  801730:	e8 54 14 00 00       	call   802b89 <sys_enable_interrupt>
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
  80177a:	e8 c5 2e 00 00       	call   804644 <__udivdi3>
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
  8017ca:	e8 85 2f 00 00       	call   804754 <__umoddi3>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	05 74 51 80 00       	add    $0x805174,%eax
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
  801925:	8b 04 85 98 51 80 00 	mov    0x805198(,%eax,4),%eax
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
  801a06:	8b 34 9d e0 4f 80 00 	mov    0x804fe0(,%ebx,4),%esi
  801a0d:	85 f6                	test   %esi,%esi
  801a0f:	75 19                	jne    801a2a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801a11:	53                   	push   %ebx
  801a12:	68 85 51 80 00       	push   $0x805185
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
  801a2b:	68 8e 51 80 00       	push   $0x80518e
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
  801a58:	be 91 51 80 00       	mov    $0x805191,%esi
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
  80247e:	68 f0 52 80 00       	push   $0x8052f0
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
  80254e:	e8 b2 05 00 00       	call   802b05 <sys_allocate_chunk>
  802553:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802556:	a1 20 61 80 00       	mov    0x806120,%eax
  80255b:	83 ec 0c             	sub    $0xc,%esp
  80255e:	50                   	push   %eax
  80255f:	e8 27 0c 00 00       	call   80318b <initialize_MemBlocksList>
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
  80258c:	68 15 53 80 00       	push   $0x805315
  802591:	6a 33                	push   $0x33
  802593:	68 33 53 80 00       	push   $0x805333
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
  80260b:	68 40 53 80 00       	push   $0x805340
  802610:	6a 34                	push   $0x34
  802612:	68 33 53 80 00       	push   $0x805333
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
  8026a3:	e8 2b 08 00 00       	call   802ed3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	74 11                	je     8026bd <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8026ac:	83 ec 0c             	sub    $0xc,%esp
  8026af:	ff 75 e8             	pushl  -0x18(%ebp)
  8026b2:	e8 96 0e 00 00       	call   80354d <alloc_block_FF>
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
  8026c9:	e8 f2 0b 00 00       	call   8032c0 <insert_sorted_allocList>
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
  8026e3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8026e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e9:	83 ec 08             	sub    $0x8,%esp
  8026ec:	50                   	push   %eax
  8026ed:	68 40 60 80 00       	push   $0x806040
  8026f2:	e8 71 0b 00 00       	call   803268 <find_block>
  8026f7:	83 c4 10             	add    $0x10,%esp
  8026fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8026fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802701:	0f 84 a6 00 00 00    	je     8027ad <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 50 0c             	mov    0xc(%eax),%edx
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 40 08             	mov    0x8(%eax),%eax
  802713:	83 ec 08             	sub    $0x8,%esp
  802716:	52                   	push   %edx
  802717:	50                   	push   %eax
  802718:	e8 b0 03 00 00       	call   802acd <sys_free_user_mem>
  80271d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  802720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802724:	75 14                	jne    80273a <free+0x5a>
  802726:	83 ec 04             	sub    $0x4,%esp
  802729:	68 15 53 80 00       	push   $0x805315
  80272e:	6a 74                	push   $0x74
  802730:	68 33 53 80 00       	push   $0x805333
  802735:	e8 ef ec ff ff       	call   801429 <_panic>
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 00                	mov    (%eax),%eax
  80273f:	85 c0                	test   %eax,%eax
  802741:	74 10                	je     802753 <free+0x73>
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 00                	mov    (%eax),%eax
  802748:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274b:	8b 52 04             	mov    0x4(%edx),%edx
  80274e:	89 50 04             	mov    %edx,0x4(%eax)
  802751:	eb 0b                	jmp    80275e <free+0x7e>
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 04             	mov    0x4(%eax),%eax
  802759:	a3 44 60 80 00       	mov    %eax,0x806044
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 40 04             	mov    0x4(%eax),%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	74 0f                	je     802777 <free+0x97>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 04             	mov    0x4(%eax),%eax
  80276e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802771:	8b 12                	mov    (%edx),%edx
  802773:	89 10                	mov    %edx,(%eax)
  802775:	eb 0a                	jmp    802781 <free+0xa1>
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	a3 40 60 80 00       	mov    %eax,0x806040
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802794:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802799:	48                   	dec    %eax
  80279a:	a3 4c 60 80 00       	mov    %eax,0x80604c
		insert_sorted_with_merge_freeList(free_block);
  80279f:	83 ec 0c             	sub    $0xc,%esp
  8027a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8027a5:	e8 4e 17 00 00       	call   803ef8 <insert_sorted_with_merge_freeList>
  8027aa:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8027ad:	90                   	nop
  8027ae:	c9                   	leave  
  8027af:	c3                   	ret    

008027b0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
  8027b3:	83 ec 38             	sub    $0x38,%esp
  8027b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8027b9:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8027bc:	e8 a6 fc ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  8027c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027c5:	75 0a                	jne    8027d1 <smalloc+0x21>
  8027c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cc:	e9 8b 00 00 00       	jmp    80285c <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8027d1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8027d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027de:	01 d0                	add    %edx,%eax
  8027e0:	48                   	dec    %eax
  8027e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ec:	f7 75 f0             	divl   -0x10(%ebp)
  8027ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f2:	29 d0                	sub    %edx,%eax
  8027f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8027f7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8027fe:	e8 d0 06 00 00       	call   802ed3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802803:	85 c0                	test   %eax,%eax
  802805:	74 11                	je     802818 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  802807:	83 ec 0c             	sub    $0xc,%esp
  80280a:	ff 75 e8             	pushl  -0x18(%ebp)
  80280d:	e8 3b 0d 00 00       	call   80354d <alloc_block_FF>
  802812:	83 c4 10             	add    $0x10,%esp
  802815:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  802818:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281c:	74 39                	je     802857 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 40 08             	mov    0x8(%eax),%eax
  802824:	89 c2                	mov    %eax,%edx
  802826:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80282a:	52                   	push   %edx
  80282b:	50                   	push   %eax
  80282c:	ff 75 0c             	pushl  0xc(%ebp)
  80282f:	ff 75 08             	pushl  0x8(%ebp)
  802832:	e8 21 04 00 00       	call   802c58 <sys_createSharedObject>
  802837:	83 c4 10             	add    $0x10,%esp
  80283a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80283d:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802841:	74 14                	je     802857 <smalloc+0xa7>
  802843:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  802847:	74 0e                	je     802857 <smalloc+0xa7>
  802849:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80284d:	74 08                	je     802857 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 40 08             	mov    0x8(%eax),%eax
  802855:	eb 05                	jmp    80285c <smalloc+0xac>
	}
	return NULL;
  802857:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80285c:	c9                   	leave  
  80285d:	c3                   	ret    

0080285e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
  802861:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802864:	e8 fe fb ff ff       	call   802467 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802869:	83 ec 08             	sub    $0x8,%esp
  80286c:	ff 75 0c             	pushl  0xc(%ebp)
  80286f:	ff 75 08             	pushl  0x8(%ebp)
  802872:	e8 0b 04 00 00       	call   802c82 <sys_getSizeOfSharedObject>
  802877:	83 c4 10             	add    $0x10,%esp
  80287a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80287d:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  802881:	74 76                	je     8028f9 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802883:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80288a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80288d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802890:	01 d0                	add    %edx,%eax
  802892:	48                   	dec    %eax
  802893:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802896:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802899:	ba 00 00 00 00       	mov    $0x0,%edx
  80289e:	f7 75 ec             	divl   -0x14(%ebp)
  8028a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a4:	29 d0                	sub    %edx,%eax
  8028a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8028a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8028b0:	e8 1e 06 00 00       	call   802ed3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8028b5:	85 c0                	test   %eax,%eax
  8028b7:	74 11                	je     8028ca <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8028b9:	83 ec 0c             	sub    $0xc,%esp
  8028bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8028bf:	e8 89 0c 00 00       	call   80354d <alloc_block_FF>
  8028c4:	83 c4 10             	add    $0x10,%esp
  8028c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8028ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ce:	74 29                	je     8028f9 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 40 08             	mov    0x8(%eax),%eax
  8028d6:	83 ec 04             	sub    $0x4,%esp
  8028d9:	50                   	push   %eax
  8028da:	ff 75 0c             	pushl  0xc(%ebp)
  8028dd:	ff 75 08             	pushl  0x8(%ebp)
  8028e0:	e8 ba 03 00 00       	call   802c9f <sys_getSharedObject>
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8028eb:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8028ef:	74 08                	je     8028f9 <sget+0x9b>
				return (void *)mem_block->sva;
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 40 08             	mov    0x8(%eax),%eax
  8028f7:	eb 05                	jmp    8028fe <sget+0xa0>
		}
	}
	return NULL;
  8028f9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8028fe:	c9                   	leave  
  8028ff:	c3                   	ret    

00802900 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802906:	e8 5c fb ff ff       	call   802467 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80290b:	83 ec 04             	sub    $0x4,%esp
  80290e:	68 64 53 80 00       	push   $0x805364
  802913:	68 f7 00 00 00       	push   $0xf7
  802918:	68 33 53 80 00       	push   $0x805333
  80291d:	e8 07 eb ff ff       	call   801429 <_panic>

00802922 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
  802925:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802928:	83 ec 04             	sub    $0x4,%esp
  80292b:	68 8c 53 80 00       	push   $0x80538c
  802930:	68 0c 01 00 00       	push   $0x10c
  802935:	68 33 53 80 00       	push   $0x805333
  80293a:	e8 ea ea ff ff       	call   801429 <_panic>

0080293f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
  802942:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802945:	83 ec 04             	sub    $0x4,%esp
  802948:	68 b0 53 80 00       	push   $0x8053b0
  80294d:	68 44 01 00 00       	push   $0x144
  802952:	68 33 53 80 00       	push   $0x805333
  802957:	e8 cd ea ff ff       	call   801429 <_panic>

0080295c <shrink>:

}
void shrink(uint32 newSize)
{
  80295c:	55                   	push   %ebp
  80295d:	89 e5                	mov    %esp,%ebp
  80295f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802962:	83 ec 04             	sub    $0x4,%esp
  802965:	68 b0 53 80 00       	push   $0x8053b0
  80296a:	68 49 01 00 00       	push   $0x149
  80296f:	68 33 53 80 00       	push   $0x805333
  802974:	e8 b0 ea ff ff       	call   801429 <_panic>

00802979 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802979:	55                   	push   %ebp
  80297a:	89 e5                	mov    %esp,%ebp
  80297c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80297f:	83 ec 04             	sub    $0x4,%esp
  802982:	68 b0 53 80 00       	push   $0x8053b0
  802987:	68 4e 01 00 00       	push   $0x14e
  80298c:	68 33 53 80 00       	push   $0x805333
  802991:	e8 93 ea ff ff       	call   801429 <_panic>

00802996 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802996:	55                   	push   %ebp
  802997:	89 e5                	mov    %esp,%ebp
  802999:	57                   	push   %edi
  80299a:	56                   	push   %esi
  80299b:	53                   	push   %ebx
  80299c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029ab:	8b 7d 18             	mov    0x18(%ebp),%edi
  8029ae:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8029b1:	cd 30                	int    $0x30
  8029b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8029b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8029b9:	83 c4 10             	add    $0x10,%esp
  8029bc:	5b                   	pop    %ebx
  8029bd:	5e                   	pop    %esi
  8029be:	5f                   	pop    %edi
  8029bf:	5d                   	pop    %ebp
  8029c0:	c3                   	ret    

008029c1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8029c1:	55                   	push   %ebp
  8029c2:	89 e5                	mov    %esp,%ebp
  8029c4:	83 ec 04             	sub    $0x4,%esp
  8029c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8029ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8029cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	52                   	push   %edx
  8029d9:	ff 75 0c             	pushl  0xc(%ebp)
  8029dc:	50                   	push   %eax
  8029dd:	6a 00                	push   $0x0
  8029df:	e8 b2 ff ff ff       	call   802996 <syscall>
  8029e4:	83 c4 18             	add    $0x18,%esp
}
  8029e7:	90                   	nop
  8029e8:	c9                   	leave  
  8029e9:	c3                   	ret    

008029ea <sys_cgetc>:

int
sys_cgetc(void)
{
  8029ea:	55                   	push   %ebp
  8029eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 00                	push   $0x0
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 01                	push   $0x1
  8029f9:	e8 98 ff ff ff       	call   802996 <syscall>
  8029fe:	83 c4 18             	add    $0x18,%esp
}
  802a01:	c9                   	leave  
  802a02:	c3                   	ret    

00802a03 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802a03:	55                   	push   %ebp
  802a04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802a06:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 00                	push   $0x0
  802a12:	52                   	push   %edx
  802a13:	50                   	push   %eax
  802a14:	6a 05                	push   $0x5
  802a16:	e8 7b ff ff ff       	call   802996 <syscall>
  802a1b:	83 c4 18             	add    $0x18,%esp
}
  802a1e:	c9                   	leave  
  802a1f:	c3                   	ret    

00802a20 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802a20:	55                   	push   %ebp
  802a21:	89 e5                	mov    %esp,%ebp
  802a23:	56                   	push   %esi
  802a24:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802a25:	8b 75 18             	mov    0x18(%ebp),%esi
  802a28:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a31:	8b 45 08             	mov    0x8(%ebp),%eax
  802a34:	56                   	push   %esi
  802a35:	53                   	push   %ebx
  802a36:	51                   	push   %ecx
  802a37:	52                   	push   %edx
  802a38:	50                   	push   %eax
  802a39:	6a 06                	push   $0x6
  802a3b:	e8 56 ff ff ff       	call   802996 <syscall>
  802a40:	83 c4 18             	add    $0x18,%esp
}
  802a43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a46:	5b                   	pop    %ebx
  802a47:	5e                   	pop    %esi
  802a48:	5d                   	pop    %ebp
  802a49:	c3                   	ret    

00802a4a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802a4a:	55                   	push   %ebp
  802a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a50:	8b 45 08             	mov    0x8(%ebp),%eax
  802a53:	6a 00                	push   $0x0
  802a55:	6a 00                	push   $0x0
  802a57:	6a 00                	push   $0x0
  802a59:	52                   	push   %edx
  802a5a:	50                   	push   %eax
  802a5b:	6a 07                	push   $0x7
  802a5d:	e8 34 ff ff ff       	call   802996 <syscall>
  802a62:	83 c4 18             	add    $0x18,%esp
}
  802a65:	c9                   	leave  
  802a66:	c3                   	ret    

00802a67 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a67:	55                   	push   %ebp
  802a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a6a:	6a 00                	push   $0x0
  802a6c:	6a 00                	push   $0x0
  802a6e:	6a 00                	push   $0x0
  802a70:	ff 75 0c             	pushl  0xc(%ebp)
  802a73:	ff 75 08             	pushl  0x8(%ebp)
  802a76:	6a 08                	push   $0x8
  802a78:	e8 19 ff ff ff       	call   802996 <syscall>
  802a7d:	83 c4 18             	add    $0x18,%esp
}
  802a80:	c9                   	leave  
  802a81:	c3                   	ret    

00802a82 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a82:	55                   	push   %ebp
  802a83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a85:	6a 00                	push   $0x0
  802a87:	6a 00                	push   $0x0
  802a89:	6a 00                	push   $0x0
  802a8b:	6a 00                	push   $0x0
  802a8d:	6a 00                	push   $0x0
  802a8f:	6a 09                	push   $0x9
  802a91:	e8 00 ff ff ff       	call   802996 <syscall>
  802a96:	83 c4 18             	add    $0x18,%esp
}
  802a99:	c9                   	leave  
  802a9a:	c3                   	ret    

00802a9b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802a9b:	55                   	push   %ebp
  802a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802a9e:	6a 00                	push   $0x0
  802aa0:	6a 00                	push   $0x0
  802aa2:	6a 00                	push   $0x0
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 0a                	push   $0xa
  802aaa:	e8 e7 fe ff ff       	call   802996 <syscall>
  802aaf:	83 c4 18             	add    $0x18,%esp
}
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 00                	push   $0x0
  802abd:	6a 00                	push   $0x0
  802abf:	6a 00                	push   $0x0
  802ac1:	6a 0b                	push   $0xb
  802ac3:	e8 ce fe ff ff       	call   802996 <syscall>
  802ac8:	83 c4 18             	add    $0x18,%esp
}
  802acb:	c9                   	leave  
  802acc:	c3                   	ret    

00802acd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802acd:	55                   	push   %ebp
  802ace:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802ad0:	6a 00                	push   $0x0
  802ad2:	6a 00                	push   $0x0
  802ad4:	6a 00                	push   $0x0
  802ad6:	ff 75 0c             	pushl  0xc(%ebp)
  802ad9:	ff 75 08             	pushl  0x8(%ebp)
  802adc:	6a 0f                	push   $0xf
  802ade:	e8 b3 fe ff ff       	call   802996 <syscall>
  802ae3:	83 c4 18             	add    $0x18,%esp
	return;
  802ae6:	90                   	nop
}
  802ae7:	c9                   	leave  
  802ae8:	c3                   	ret    

00802ae9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802ae9:	55                   	push   %ebp
  802aea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802aec:	6a 00                	push   $0x0
  802aee:	6a 00                	push   $0x0
  802af0:	6a 00                	push   $0x0
  802af2:	ff 75 0c             	pushl  0xc(%ebp)
  802af5:	ff 75 08             	pushl  0x8(%ebp)
  802af8:	6a 10                	push   $0x10
  802afa:	e8 97 fe ff ff       	call   802996 <syscall>
  802aff:	83 c4 18             	add    $0x18,%esp
	return ;
  802b02:	90                   	nop
}
  802b03:	c9                   	leave  
  802b04:	c3                   	ret    

00802b05 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b05:	55                   	push   %ebp
  802b06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b08:	6a 00                	push   $0x0
  802b0a:	6a 00                	push   $0x0
  802b0c:	ff 75 10             	pushl  0x10(%ebp)
  802b0f:	ff 75 0c             	pushl  0xc(%ebp)
  802b12:	ff 75 08             	pushl  0x8(%ebp)
  802b15:	6a 11                	push   $0x11
  802b17:	e8 7a fe ff ff       	call   802996 <syscall>
  802b1c:	83 c4 18             	add    $0x18,%esp
	return ;
  802b1f:	90                   	nop
}
  802b20:	c9                   	leave  
  802b21:	c3                   	ret    

00802b22 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802b22:	55                   	push   %ebp
  802b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802b25:	6a 00                	push   $0x0
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 00                	push   $0x0
  802b2d:	6a 00                	push   $0x0
  802b2f:	6a 0c                	push   $0xc
  802b31:	e8 60 fe ff ff       	call   802996 <syscall>
  802b36:	83 c4 18             	add    $0x18,%esp
}
  802b39:	c9                   	leave  
  802b3a:	c3                   	ret    

00802b3b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 00                	push   $0x0
  802b42:	6a 00                	push   $0x0
  802b44:	6a 00                	push   $0x0
  802b46:	ff 75 08             	pushl  0x8(%ebp)
  802b49:	6a 0d                	push   $0xd
  802b4b:	e8 46 fe ff ff       	call   802996 <syscall>
  802b50:	83 c4 18             	add    $0x18,%esp
}
  802b53:	c9                   	leave  
  802b54:	c3                   	ret    

00802b55 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802b55:	55                   	push   %ebp
  802b56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802b58:	6a 00                	push   $0x0
  802b5a:	6a 00                	push   $0x0
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	6a 0e                	push   $0xe
  802b64:	e8 2d fe ff ff       	call   802996 <syscall>
  802b69:	83 c4 18             	add    $0x18,%esp
}
  802b6c:	90                   	nop
  802b6d:	c9                   	leave  
  802b6e:	c3                   	ret    

00802b6f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802b6f:	55                   	push   %ebp
  802b70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 00                	push   $0x0
  802b78:	6a 00                	push   $0x0
  802b7a:	6a 00                	push   $0x0
  802b7c:	6a 13                	push   $0x13
  802b7e:	e8 13 fe ff ff       	call   802996 <syscall>
  802b83:	83 c4 18             	add    $0x18,%esp
}
  802b86:	90                   	nop
  802b87:	c9                   	leave  
  802b88:	c3                   	ret    

00802b89 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802b89:	55                   	push   %ebp
  802b8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802b8c:	6a 00                	push   $0x0
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 00                	push   $0x0
  802b92:	6a 00                	push   $0x0
  802b94:	6a 00                	push   $0x0
  802b96:	6a 14                	push   $0x14
  802b98:	e8 f9 fd ff ff       	call   802996 <syscall>
  802b9d:	83 c4 18             	add    $0x18,%esp
}
  802ba0:	90                   	nop
  802ba1:	c9                   	leave  
  802ba2:	c3                   	ret    

00802ba3 <sys_cputc>:


void
sys_cputc(const char c)
{
  802ba3:	55                   	push   %ebp
  802ba4:	89 e5                	mov    %esp,%ebp
  802ba6:	83 ec 04             	sub    $0x4,%esp
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802baf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802bb3:	6a 00                	push   $0x0
  802bb5:	6a 00                	push   $0x0
  802bb7:	6a 00                	push   $0x0
  802bb9:	6a 00                	push   $0x0
  802bbb:	50                   	push   %eax
  802bbc:	6a 15                	push   $0x15
  802bbe:	e8 d3 fd ff ff       	call   802996 <syscall>
  802bc3:	83 c4 18             	add    $0x18,%esp
}
  802bc6:	90                   	nop
  802bc7:	c9                   	leave  
  802bc8:	c3                   	ret    

00802bc9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802bc9:	55                   	push   %ebp
  802bca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802bcc:	6a 00                	push   $0x0
  802bce:	6a 00                	push   $0x0
  802bd0:	6a 00                	push   $0x0
  802bd2:	6a 00                	push   $0x0
  802bd4:	6a 00                	push   $0x0
  802bd6:	6a 16                	push   $0x16
  802bd8:	e8 b9 fd ff ff       	call   802996 <syscall>
  802bdd:	83 c4 18             	add    $0x18,%esp
}
  802be0:	90                   	nop
  802be1:	c9                   	leave  
  802be2:	c3                   	ret    

00802be3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802be3:	55                   	push   %ebp
  802be4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	6a 00                	push   $0x0
  802beb:	6a 00                	push   $0x0
  802bed:	6a 00                	push   $0x0
  802bef:	ff 75 0c             	pushl  0xc(%ebp)
  802bf2:	50                   	push   %eax
  802bf3:	6a 17                	push   $0x17
  802bf5:	e8 9c fd ff ff       	call   802996 <syscall>
  802bfa:	83 c4 18             	add    $0x18,%esp
}
  802bfd:	c9                   	leave  
  802bfe:	c3                   	ret    

00802bff <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802bff:	55                   	push   %ebp
  802c00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c02:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	6a 00                	push   $0x0
  802c0a:	6a 00                	push   $0x0
  802c0c:	6a 00                	push   $0x0
  802c0e:	52                   	push   %edx
  802c0f:	50                   	push   %eax
  802c10:	6a 1a                	push   $0x1a
  802c12:	e8 7f fd ff ff       	call   802996 <syscall>
  802c17:	83 c4 18             	add    $0x18,%esp
}
  802c1a:	c9                   	leave  
  802c1b:	c3                   	ret    

00802c1c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c1c:	55                   	push   %ebp
  802c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	6a 00                	push   $0x0
  802c27:	6a 00                	push   $0x0
  802c29:	6a 00                	push   $0x0
  802c2b:	52                   	push   %edx
  802c2c:	50                   	push   %eax
  802c2d:	6a 18                	push   $0x18
  802c2f:	e8 62 fd ff ff       	call   802996 <syscall>
  802c34:	83 c4 18             	add    $0x18,%esp
}
  802c37:	90                   	nop
  802c38:	c9                   	leave  
  802c39:	c3                   	ret    

00802c3a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c3a:	55                   	push   %ebp
  802c3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	6a 00                	push   $0x0
  802c45:	6a 00                	push   $0x0
  802c47:	6a 00                	push   $0x0
  802c49:	52                   	push   %edx
  802c4a:	50                   	push   %eax
  802c4b:	6a 19                	push   $0x19
  802c4d:	e8 44 fd ff ff       	call   802996 <syscall>
  802c52:	83 c4 18             	add    $0x18,%esp
}
  802c55:	90                   	nop
  802c56:	c9                   	leave  
  802c57:	c3                   	ret    

00802c58 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802c58:	55                   	push   %ebp
  802c59:	89 e5                	mov    %esp,%ebp
  802c5b:	83 ec 04             	sub    $0x4,%esp
  802c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  802c61:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802c64:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c67:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	6a 00                	push   $0x0
  802c70:	51                   	push   %ecx
  802c71:	52                   	push   %edx
  802c72:	ff 75 0c             	pushl  0xc(%ebp)
  802c75:	50                   	push   %eax
  802c76:	6a 1b                	push   $0x1b
  802c78:	e8 19 fd ff ff       	call   802996 <syscall>
  802c7d:	83 c4 18             	add    $0x18,%esp
}
  802c80:	c9                   	leave  
  802c81:	c3                   	ret    

00802c82 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802c82:	55                   	push   %ebp
  802c83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	6a 00                	push   $0x0
  802c8d:	6a 00                	push   $0x0
  802c8f:	6a 00                	push   $0x0
  802c91:	52                   	push   %edx
  802c92:	50                   	push   %eax
  802c93:	6a 1c                	push   $0x1c
  802c95:	e8 fc fc ff ff       	call   802996 <syscall>
  802c9a:	83 c4 18             	add    $0x18,%esp
}
  802c9d:	c9                   	leave  
  802c9e:	c3                   	ret    

00802c9f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802c9f:	55                   	push   %ebp
  802ca0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802ca2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ca5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	51                   	push   %ecx
  802cb0:	52                   	push   %edx
  802cb1:	50                   	push   %eax
  802cb2:	6a 1d                	push   $0x1d
  802cb4:	e8 dd fc ff ff       	call   802996 <syscall>
  802cb9:	83 c4 18             	add    $0x18,%esp
}
  802cbc:	c9                   	leave  
  802cbd:	c3                   	ret    

00802cbe <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802cbe:	55                   	push   %ebp
  802cbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc7:	6a 00                	push   $0x0
  802cc9:	6a 00                	push   $0x0
  802ccb:	6a 00                	push   $0x0
  802ccd:	52                   	push   %edx
  802cce:	50                   	push   %eax
  802ccf:	6a 1e                	push   $0x1e
  802cd1:	e8 c0 fc ff ff       	call   802996 <syscall>
  802cd6:	83 c4 18             	add    $0x18,%esp
}
  802cd9:	c9                   	leave  
  802cda:	c3                   	ret    

00802cdb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802cdb:	55                   	push   %ebp
  802cdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802cde:	6a 00                	push   $0x0
  802ce0:	6a 00                	push   $0x0
  802ce2:	6a 00                	push   $0x0
  802ce4:	6a 00                	push   $0x0
  802ce6:	6a 00                	push   $0x0
  802ce8:	6a 1f                	push   $0x1f
  802cea:	e8 a7 fc ff ff       	call   802996 <syscall>
  802cef:	83 c4 18             	add    $0x18,%esp
}
  802cf2:	c9                   	leave  
  802cf3:	c3                   	ret    

00802cf4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802cf4:	55                   	push   %ebp
  802cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	6a 00                	push   $0x0
  802cfc:	ff 75 14             	pushl  0x14(%ebp)
  802cff:	ff 75 10             	pushl  0x10(%ebp)
  802d02:	ff 75 0c             	pushl  0xc(%ebp)
  802d05:	50                   	push   %eax
  802d06:	6a 20                	push   $0x20
  802d08:	e8 89 fc ff ff       	call   802996 <syscall>
  802d0d:	83 c4 18             	add    $0x18,%esp
}
  802d10:	c9                   	leave  
  802d11:	c3                   	ret    

00802d12 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802d12:	55                   	push   %ebp
  802d13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	6a 00                	push   $0x0
  802d1a:	6a 00                	push   $0x0
  802d1c:	6a 00                	push   $0x0
  802d1e:	6a 00                	push   $0x0
  802d20:	50                   	push   %eax
  802d21:	6a 21                	push   $0x21
  802d23:	e8 6e fc ff ff       	call   802996 <syscall>
  802d28:	83 c4 18             	add    $0x18,%esp
}
  802d2b:	90                   	nop
  802d2c:	c9                   	leave  
  802d2d:	c3                   	ret    

00802d2e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802d2e:	55                   	push   %ebp
  802d2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	6a 00                	push   $0x0
  802d36:	6a 00                	push   $0x0
  802d38:	6a 00                	push   $0x0
  802d3a:	6a 00                	push   $0x0
  802d3c:	50                   	push   %eax
  802d3d:	6a 22                	push   $0x22
  802d3f:	e8 52 fc ff ff       	call   802996 <syscall>
  802d44:	83 c4 18             	add    $0x18,%esp
}
  802d47:	c9                   	leave  
  802d48:	c3                   	ret    

00802d49 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802d49:	55                   	push   %ebp
  802d4a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802d4c:	6a 00                	push   $0x0
  802d4e:	6a 00                	push   $0x0
  802d50:	6a 00                	push   $0x0
  802d52:	6a 00                	push   $0x0
  802d54:	6a 00                	push   $0x0
  802d56:	6a 02                	push   $0x2
  802d58:	e8 39 fc ff ff       	call   802996 <syscall>
  802d5d:	83 c4 18             	add    $0x18,%esp
}
  802d60:	c9                   	leave  
  802d61:	c3                   	ret    

00802d62 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802d62:	55                   	push   %ebp
  802d63:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802d65:	6a 00                	push   $0x0
  802d67:	6a 00                	push   $0x0
  802d69:	6a 00                	push   $0x0
  802d6b:	6a 00                	push   $0x0
  802d6d:	6a 00                	push   $0x0
  802d6f:	6a 03                	push   $0x3
  802d71:	e8 20 fc ff ff       	call   802996 <syscall>
  802d76:	83 c4 18             	add    $0x18,%esp
}
  802d79:	c9                   	leave  
  802d7a:	c3                   	ret    

00802d7b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802d7b:	55                   	push   %ebp
  802d7c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802d7e:	6a 00                	push   $0x0
  802d80:	6a 00                	push   $0x0
  802d82:	6a 00                	push   $0x0
  802d84:	6a 00                	push   $0x0
  802d86:	6a 00                	push   $0x0
  802d88:	6a 04                	push   $0x4
  802d8a:	e8 07 fc ff ff       	call   802996 <syscall>
  802d8f:	83 c4 18             	add    $0x18,%esp
}
  802d92:	c9                   	leave  
  802d93:	c3                   	ret    

00802d94 <sys_exit_env>:


void sys_exit_env(void)
{
  802d94:	55                   	push   %ebp
  802d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802d97:	6a 00                	push   $0x0
  802d99:	6a 00                	push   $0x0
  802d9b:	6a 00                	push   $0x0
  802d9d:	6a 00                	push   $0x0
  802d9f:	6a 00                	push   $0x0
  802da1:	6a 23                	push   $0x23
  802da3:	e8 ee fb ff ff       	call   802996 <syscall>
  802da8:	83 c4 18             	add    $0x18,%esp
}
  802dab:	90                   	nop
  802dac:	c9                   	leave  
  802dad:	c3                   	ret    

00802dae <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802dae:	55                   	push   %ebp
  802daf:	89 e5                	mov    %esp,%ebp
  802db1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802db4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802db7:	8d 50 04             	lea    0x4(%eax),%edx
  802dba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802dbd:	6a 00                	push   $0x0
  802dbf:	6a 00                	push   $0x0
  802dc1:	6a 00                	push   $0x0
  802dc3:	52                   	push   %edx
  802dc4:	50                   	push   %eax
  802dc5:	6a 24                	push   $0x24
  802dc7:	e8 ca fb ff ff       	call   802996 <syscall>
  802dcc:	83 c4 18             	add    $0x18,%esp
	return result;
  802dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802dd5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802dd8:	89 01                	mov    %eax,(%ecx)
  802dda:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	c9                   	leave  
  802de1:	c2 04 00             	ret    $0x4

00802de4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802de4:	55                   	push   %ebp
  802de5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802de7:	6a 00                	push   $0x0
  802de9:	6a 00                	push   $0x0
  802deb:	ff 75 10             	pushl  0x10(%ebp)
  802dee:	ff 75 0c             	pushl  0xc(%ebp)
  802df1:	ff 75 08             	pushl  0x8(%ebp)
  802df4:	6a 12                	push   $0x12
  802df6:	e8 9b fb ff ff       	call   802996 <syscall>
  802dfb:	83 c4 18             	add    $0x18,%esp
	return ;
  802dfe:	90                   	nop
}
  802dff:	c9                   	leave  
  802e00:	c3                   	ret    

00802e01 <sys_rcr2>:
uint32 sys_rcr2()
{
  802e01:	55                   	push   %ebp
  802e02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802e04:	6a 00                	push   $0x0
  802e06:	6a 00                	push   $0x0
  802e08:	6a 00                	push   $0x0
  802e0a:	6a 00                	push   $0x0
  802e0c:	6a 00                	push   $0x0
  802e0e:	6a 25                	push   $0x25
  802e10:	e8 81 fb ff ff       	call   802996 <syscall>
  802e15:	83 c4 18             	add    $0x18,%esp
}
  802e18:	c9                   	leave  
  802e19:	c3                   	ret    

00802e1a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802e1a:	55                   	push   %ebp
  802e1b:	89 e5                	mov    %esp,%ebp
  802e1d:	83 ec 04             	sub    $0x4,%esp
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802e26:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802e2a:	6a 00                	push   $0x0
  802e2c:	6a 00                	push   $0x0
  802e2e:	6a 00                	push   $0x0
  802e30:	6a 00                	push   $0x0
  802e32:	50                   	push   %eax
  802e33:	6a 26                	push   $0x26
  802e35:	e8 5c fb ff ff       	call   802996 <syscall>
  802e3a:	83 c4 18             	add    $0x18,%esp
	return ;
  802e3d:	90                   	nop
}
  802e3e:	c9                   	leave  
  802e3f:	c3                   	ret    

00802e40 <rsttst>:
void rsttst()
{
  802e40:	55                   	push   %ebp
  802e41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802e43:	6a 00                	push   $0x0
  802e45:	6a 00                	push   $0x0
  802e47:	6a 00                	push   $0x0
  802e49:	6a 00                	push   $0x0
  802e4b:	6a 00                	push   $0x0
  802e4d:	6a 28                	push   $0x28
  802e4f:	e8 42 fb ff ff       	call   802996 <syscall>
  802e54:	83 c4 18             	add    $0x18,%esp
	return ;
  802e57:	90                   	nop
}
  802e58:	c9                   	leave  
  802e59:	c3                   	ret    

00802e5a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802e5a:	55                   	push   %ebp
  802e5b:	89 e5                	mov    %esp,%ebp
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	8b 45 14             	mov    0x14(%ebp),%eax
  802e63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802e66:	8b 55 18             	mov    0x18(%ebp),%edx
  802e69:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e6d:	52                   	push   %edx
  802e6e:	50                   	push   %eax
  802e6f:	ff 75 10             	pushl  0x10(%ebp)
  802e72:	ff 75 0c             	pushl  0xc(%ebp)
  802e75:	ff 75 08             	pushl  0x8(%ebp)
  802e78:	6a 27                	push   $0x27
  802e7a:	e8 17 fb ff ff       	call   802996 <syscall>
  802e7f:	83 c4 18             	add    $0x18,%esp
	return ;
  802e82:	90                   	nop
}
  802e83:	c9                   	leave  
  802e84:	c3                   	ret    

00802e85 <chktst>:
void chktst(uint32 n)
{
  802e85:	55                   	push   %ebp
  802e86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802e88:	6a 00                	push   $0x0
  802e8a:	6a 00                	push   $0x0
  802e8c:	6a 00                	push   $0x0
  802e8e:	6a 00                	push   $0x0
  802e90:	ff 75 08             	pushl  0x8(%ebp)
  802e93:	6a 29                	push   $0x29
  802e95:	e8 fc fa ff ff       	call   802996 <syscall>
  802e9a:	83 c4 18             	add    $0x18,%esp
	return ;
  802e9d:	90                   	nop
}
  802e9e:	c9                   	leave  
  802e9f:	c3                   	ret    

00802ea0 <inctst>:

void inctst()
{
  802ea0:	55                   	push   %ebp
  802ea1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802ea3:	6a 00                	push   $0x0
  802ea5:	6a 00                	push   $0x0
  802ea7:	6a 00                	push   $0x0
  802ea9:	6a 00                	push   $0x0
  802eab:	6a 00                	push   $0x0
  802ead:	6a 2a                	push   $0x2a
  802eaf:	e8 e2 fa ff ff       	call   802996 <syscall>
  802eb4:	83 c4 18             	add    $0x18,%esp
	return ;
  802eb7:	90                   	nop
}
  802eb8:	c9                   	leave  
  802eb9:	c3                   	ret    

00802eba <gettst>:
uint32 gettst()
{
  802eba:	55                   	push   %ebp
  802ebb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802ebd:	6a 00                	push   $0x0
  802ebf:	6a 00                	push   $0x0
  802ec1:	6a 00                	push   $0x0
  802ec3:	6a 00                	push   $0x0
  802ec5:	6a 00                	push   $0x0
  802ec7:	6a 2b                	push   $0x2b
  802ec9:	e8 c8 fa ff ff       	call   802996 <syscall>
  802ece:	83 c4 18             	add    $0x18,%esp
}
  802ed1:	c9                   	leave  
  802ed2:	c3                   	ret    

00802ed3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802ed3:	55                   	push   %ebp
  802ed4:	89 e5                	mov    %esp,%ebp
  802ed6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ed9:	6a 00                	push   $0x0
  802edb:	6a 00                	push   $0x0
  802edd:	6a 00                	push   $0x0
  802edf:	6a 00                	push   $0x0
  802ee1:	6a 00                	push   $0x0
  802ee3:	6a 2c                	push   $0x2c
  802ee5:	e8 ac fa ff ff       	call   802996 <syscall>
  802eea:	83 c4 18             	add    $0x18,%esp
  802eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802ef0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802ef4:	75 07                	jne    802efd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802ef6:	b8 01 00 00 00       	mov    $0x1,%eax
  802efb:	eb 05                	jmp    802f02 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802efd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f02:	c9                   	leave  
  802f03:	c3                   	ret    

00802f04 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802f04:	55                   	push   %ebp
  802f05:	89 e5                	mov    %esp,%ebp
  802f07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f0a:	6a 00                	push   $0x0
  802f0c:	6a 00                	push   $0x0
  802f0e:	6a 00                	push   $0x0
  802f10:	6a 00                	push   $0x0
  802f12:	6a 00                	push   $0x0
  802f14:	6a 2c                	push   $0x2c
  802f16:	e8 7b fa ff ff       	call   802996 <syscall>
  802f1b:	83 c4 18             	add    $0x18,%esp
  802f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802f21:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802f25:	75 07                	jne    802f2e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802f27:	b8 01 00 00 00       	mov    $0x1,%eax
  802f2c:	eb 05                	jmp    802f33 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802f2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f33:	c9                   	leave  
  802f34:	c3                   	ret    

00802f35 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802f35:	55                   	push   %ebp
  802f36:	89 e5                	mov    %esp,%ebp
  802f38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f3b:	6a 00                	push   $0x0
  802f3d:	6a 00                	push   $0x0
  802f3f:	6a 00                	push   $0x0
  802f41:	6a 00                	push   $0x0
  802f43:	6a 00                	push   $0x0
  802f45:	6a 2c                	push   $0x2c
  802f47:	e8 4a fa ff ff       	call   802996 <syscall>
  802f4c:	83 c4 18             	add    $0x18,%esp
  802f4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802f52:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802f56:	75 07                	jne    802f5f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802f58:	b8 01 00 00 00       	mov    $0x1,%eax
  802f5d:	eb 05                	jmp    802f64 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802f5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f64:	c9                   	leave  
  802f65:	c3                   	ret    

00802f66 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802f66:	55                   	push   %ebp
  802f67:	89 e5                	mov    %esp,%ebp
  802f69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f6c:	6a 00                	push   $0x0
  802f6e:	6a 00                	push   $0x0
  802f70:	6a 00                	push   $0x0
  802f72:	6a 00                	push   $0x0
  802f74:	6a 00                	push   $0x0
  802f76:	6a 2c                	push   $0x2c
  802f78:	e8 19 fa ff ff       	call   802996 <syscall>
  802f7d:	83 c4 18             	add    $0x18,%esp
  802f80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802f83:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802f87:	75 07                	jne    802f90 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802f89:	b8 01 00 00 00       	mov    $0x1,%eax
  802f8e:	eb 05                	jmp    802f95 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802f90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f95:	c9                   	leave  
  802f96:	c3                   	ret    

00802f97 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802f97:	55                   	push   %ebp
  802f98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802f9a:	6a 00                	push   $0x0
  802f9c:	6a 00                	push   $0x0
  802f9e:	6a 00                	push   $0x0
  802fa0:	6a 00                	push   $0x0
  802fa2:	ff 75 08             	pushl  0x8(%ebp)
  802fa5:	6a 2d                	push   $0x2d
  802fa7:	e8 ea f9 ff ff       	call   802996 <syscall>
  802fac:	83 c4 18             	add    $0x18,%esp
	return ;
  802faf:	90                   	nop
}
  802fb0:	c9                   	leave  
  802fb1:	c3                   	ret    

00802fb2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802fb2:	55                   	push   %ebp
  802fb3:	89 e5                	mov    %esp,%ebp
  802fb5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802fb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	6a 00                	push   $0x0
  802fc4:	53                   	push   %ebx
  802fc5:	51                   	push   %ecx
  802fc6:	52                   	push   %edx
  802fc7:	50                   	push   %eax
  802fc8:	6a 2e                	push   $0x2e
  802fca:	e8 c7 f9 ff ff       	call   802996 <syscall>
  802fcf:	83 c4 18             	add    $0x18,%esp
}
  802fd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fd5:	c9                   	leave  
  802fd6:	c3                   	ret    

00802fd7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802fd7:	55                   	push   %ebp
  802fd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 00                	push   $0x0
  802fe4:	6a 00                	push   $0x0
  802fe6:	52                   	push   %edx
  802fe7:	50                   	push   %eax
  802fe8:	6a 2f                	push   $0x2f
  802fea:	e8 a7 f9 ff ff       	call   802996 <syscall>
  802fef:	83 c4 18             	add    $0x18,%esp
}
  802ff2:	c9                   	leave  
  802ff3:	c3                   	ret    

00802ff4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802ff4:	55                   	push   %ebp
  802ff5:	89 e5                	mov    %esp,%ebp
  802ff7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802ffa:	83 ec 0c             	sub    $0xc,%esp
  802ffd:	68 c0 53 80 00       	push   $0x8053c0
  803002:	e8 d6 e6 ff ff       	call   8016dd <cprintf>
  803007:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80300a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  803011:	83 ec 0c             	sub    $0xc,%esp
  803014:	68 ec 53 80 00       	push   $0x8053ec
  803019:	e8 bf e6 ff ff       	call   8016dd <cprintf>
  80301e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  803021:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803025:	a1 38 61 80 00       	mov    0x806138,%eax
  80302a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80302d:	eb 56                	jmp    803085 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80302f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803033:	74 1c                	je     803051 <print_mem_block_lists+0x5d>
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	8b 50 08             	mov    0x8(%eax),%edx
  80303b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303e:	8b 48 08             	mov    0x8(%eax),%ecx
  803041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803044:	8b 40 0c             	mov    0xc(%eax),%eax
  803047:	01 c8                	add    %ecx,%eax
  803049:	39 c2                	cmp    %eax,%edx
  80304b:	73 04                	jae    803051 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80304d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	8b 50 08             	mov    0x8(%eax),%edx
  803057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305a:	8b 40 0c             	mov    0xc(%eax),%eax
  80305d:	01 c2                	add    %eax,%edx
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	8b 40 08             	mov    0x8(%eax),%eax
  803065:	83 ec 04             	sub    $0x4,%esp
  803068:	52                   	push   %edx
  803069:	50                   	push   %eax
  80306a:	68 01 54 80 00       	push   $0x805401
  80306f:	e8 69 e6 ff ff       	call   8016dd <cprintf>
  803074:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80307d:	a1 40 61 80 00       	mov    0x806140,%eax
  803082:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803085:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803089:	74 07                	je     803092 <print_mem_block_lists+0x9e>
  80308b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	eb 05                	jmp    803097 <print_mem_block_lists+0xa3>
  803092:	b8 00 00 00 00       	mov    $0x0,%eax
  803097:	a3 40 61 80 00       	mov    %eax,0x806140
  80309c:	a1 40 61 80 00       	mov    0x806140,%eax
  8030a1:	85 c0                	test   %eax,%eax
  8030a3:	75 8a                	jne    80302f <print_mem_block_lists+0x3b>
  8030a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a9:	75 84                	jne    80302f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8030ab:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8030af:	75 10                	jne    8030c1 <print_mem_block_lists+0xcd>
  8030b1:	83 ec 0c             	sub    $0xc,%esp
  8030b4:	68 10 54 80 00       	push   $0x805410
  8030b9:	e8 1f e6 ff ff       	call   8016dd <cprintf>
  8030be:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8030c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8030c8:	83 ec 0c             	sub    $0xc,%esp
  8030cb:	68 34 54 80 00       	push   $0x805434
  8030d0:	e8 08 e6 ff ff       	call   8016dd <cprintf>
  8030d5:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8030d8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8030dc:	a1 40 60 80 00       	mov    0x806040,%eax
  8030e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e4:	eb 56                	jmp    80313c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8030e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ea:	74 1c                	je     803108 <print_mem_block_lists+0x114>
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	8b 50 08             	mov    0x8(%eax),%edx
  8030f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f5:	8b 48 08             	mov    0x8(%eax),%ecx
  8030f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fe:	01 c8                	add    %ecx,%eax
  803100:	39 c2                	cmp    %eax,%edx
  803102:	73 04                	jae    803108 <print_mem_block_lists+0x114>
			sorted = 0 ;
  803104:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	8b 50 08             	mov    0x8(%eax),%edx
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 40 0c             	mov    0xc(%eax),%eax
  803114:	01 c2                	add    %eax,%edx
  803116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803119:	8b 40 08             	mov    0x8(%eax),%eax
  80311c:	83 ec 04             	sub    $0x4,%esp
  80311f:	52                   	push   %edx
  803120:	50                   	push   %eax
  803121:	68 01 54 80 00       	push   $0x805401
  803126:	e8 b2 e5 ff ff       	call   8016dd <cprintf>
  80312b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80312e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803131:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803134:	a1 48 60 80 00       	mov    0x806048,%eax
  803139:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80313c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803140:	74 07                	je     803149 <print_mem_block_lists+0x155>
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	eb 05                	jmp    80314e <print_mem_block_lists+0x15a>
  803149:	b8 00 00 00 00       	mov    $0x0,%eax
  80314e:	a3 48 60 80 00       	mov    %eax,0x806048
  803153:	a1 48 60 80 00       	mov    0x806048,%eax
  803158:	85 c0                	test   %eax,%eax
  80315a:	75 8a                	jne    8030e6 <print_mem_block_lists+0xf2>
  80315c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803160:	75 84                	jne    8030e6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803162:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803166:	75 10                	jne    803178 <print_mem_block_lists+0x184>
  803168:	83 ec 0c             	sub    $0xc,%esp
  80316b:	68 4c 54 80 00       	push   $0x80544c
  803170:	e8 68 e5 ff ff       	call   8016dd <cprintf>
  803175:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803178:	83 ec 0c             	sub    $0xc,%esp
  80317b:	68 c0 53 80 00       	push   $0x8053c0
  803180:	e8 58 e5 ff ff       	call   8016dd <cprintf>
  803185:	83 c4 10             	add    $0x10,%esp

}
  803188:	90                   	nop
  803189:	c9                   	leave  
  80318a:	c3                   	ret    

0080318b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80318b:	55                   	push   %ebp
  80318c:	89 e5                	mov    %esp,%ebp
  80318e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  803191:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  803198:	00 00 00 
  80319b:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  8031a2:	00 00 00 
  8031a5:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  8031ac:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8031af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031b6:	e9 9e 00 00 00       	jmp    803259 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8031bb:	a1 50 60 80 00       	mov    0x806050,%eax
  8031c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031c3:	c1 e2 04             	shl    $0x4,%edx
  8031c6:	01 d0                	add    %edx,%eax
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	75 14                	jne    8031e0 <initialize_MemBlocksList+0x55>
  8031cc:	83 ec 04             	sub    $0x4,%esp
  8031cf:	68 74 54 80 00       	push   $0x805474
  8031d4:	6a 46                	push   $0x46
  8031d6:	68 97 54 80 00       	push   $0x805497
  8031db:	e8 49 e2 ff ff       	call   801429 <_panic>
  8031e0:	a1 50 60 80 00       	mov    0x806050,%eax
  8031e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031e8:	c1 e2 04             	shl    $0x4,%edx
  8031eb:	01 d0                	add    %edx,%eax
  8031ed:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8031f3:	89 10                	mov    %edx,(%eax)
  8031f5:	8b 00                	mov    (%eax),%eax
  8031f7:	85 c0                	test   %eax,%eax
  8031f9:	74 18                	je     803213 <initialize_MemBlocksList+0x88>
  8031fb:	a1 48 61 80 00       	mov    0x806148,%eax
  803200:	8b 15 50 60 80 00    	mov    0x806050,%edx
  803206:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803209:	c1 e1 04             	shl    $0x4,%ecx
  80320c:	01 ca                	add    %ecx,%edx
  80320e:	89 50 04             	mov    %edx,0x4(%eax)
  803211:	eb 12                	jmp    803225 <initialize_MemBlocksList+0x9a>
  803213:	a1 50 60 80 00       	mov    0x806050,%eax
  803218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80321b:	c1 e2 04             	shl    $0x4,%edx
  80321e:	01 d0                	add    %edx,%eax
  803220:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803225:	a1 50 60 80 00       	mov    0x806050,%eax
  80322a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80322d:	c1 e2 04             	shl    $0x4,%edx
  803230:	01 d0                	add    %edx,%eax
  803232:	a3 48 61 80 00       	mov    %eax,0x806148
  803237:	a1 50 60 80 00       	mov    0x806050,%eax
  80323c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323f:	c1 e2 04             	shl    $0x4,%edx
  803242:	01 d0                	add    %edx,%eax
  803244:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324b:	a1 54 61 80 00       	mov    0x806154,%eax
  803250:	40                   	inc    %eax
  803251:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  803256:	ff 45 f4             	incl   -0xc(%ebp)
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80325f:	0f 82 56 ff ff ff    	jb     8031bb <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  803265:	90                   	nop
  803266:	c9                   	leave  
  803267:	c3                   	ret    

00803268 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803268:	55                   	push   %ebp
  803269:	89 e5                	mov    %esp,%ebp
  80326b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	8b 00                	mov    (%eax),%eax
  803273:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803276:	eb 19                	jmp    803291 <find_block+0x29>
	{
		if(va==point->sva)
  803278:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80327b:	8b 40 08             	mov    0x8(%eax),%eax
  80327e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803281:	75 05                	jne    803288 <find_block+0x20>
		   return point;
  803283:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803286:	eb 36                	jmp    8032be <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	8b 40 08             	mov    0x8(%eax),%eax
  80328e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803291:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803295:	74 07                	je     80329e <find_block+0x36>
  803297:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	eb 05                	jmp    8032a3 <find_block+0x3b>
  80329e:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a6:	89 42 08             	mov    %eax,0x8(%edx)
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 40 08             	mov    0x8(%eax),%eax
  8032af:	85 c0                	test   %eax,%eax
  8032b1:	75 c5                	jne    803278 <find_block+0x10>
  8032b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8032b7:	75 bf                	jne    803278 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8032b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032be:	c9                   	leave  
  8032bf:	c3                   	ret    

008032c0 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8032c0:	55                   	push   %ebp
  8032c1:	89 e5                	mov    %esp,%ebp
  8032c3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8032c6:	a1 40 60 80 00       	mov    0x806040,%eax
  8032cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8032ce:	a1 44 60 80 00       	mov    0x806044,%eax
  8032d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8032d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8032dc:	74 24                	je     803302 <insert_sorted_allocList+0x42>
  8032de:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e1:	8b 50 08             	mov    0x8(%eax),%edx
  8032e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e7:	8b 40 08             	mov    0x8(%eax),%eax
  8032ea:	39 c2                	cmp    %eax,%edx
  8032ec:	76 14                	jbe    803302 <insert_sorted_allocList+0x42>
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	8b 50 08             	mov    0x8(%eax),%edx
  8032f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f7:	8b 40 08             	mov    0x8(%eax),%eax
  8032fa:	39 c2                	cmp    %eax,%edx
  8032fc:	0f 82 60 01 00 00    	jb     803462 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  803302:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803306:	75 65                	jne    80336d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  803308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80330c:	75 14                	jne    803322 <insert_sorted_allocList+0x62>
  80330e:	83 ec 04             	sub    $0x4,%esp
  803311:	68 74 54 80 00       	push   $0x805474
  803316:	6a 6b                	push   $0x6b
  803318:	68 97 54 80 00       	push   $0x805497
  80331d:	e8 07 e1 ff ff       	call   801429 <_panic>
  803322:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	89 10                	mov    %edx,(%eax)
  80332d:	8b 45 08             	mov    0x8(%ebp),%eax
  803330:	8b 00                	mov    (%eax),%eax
  803332:	85 c0                	test   %eax,%eax
  803334:	74 0d                	je     803343 <insert_sorted_allocList+0x83>
  803336:	a1 40 60 80 00       	mov    0x806040,%eax
  80333b:	8b 55 08             	mov    0x8(%ebp),%edx
  80333e:	89 50 04             	mov    %edx,0x4(%eax)
  803341:	eb 08                	jmp    80334b <insert_sorted_allocList+0x8b>
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	a3 44 60 80 00       	mov    %eax,0x806044
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	a3 40 60 80 00       	mov    %eax,0x806040
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335d:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803362:	40                   	inc    %eax
  803363:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803368:	e9 dc 01 00 00       	jmp    803549 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80336d:	8b 45 08             	mov    0x8(%ebp),%eax
  803370:	8b 50 08             	mov    0x8(%eax),%edx
  803373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803376:	8b 40 08             	mov    0x8(%eax),%eax
  803379:	39 c2                	cmp    %eax,%edx
  80337b:	77 6c                	ja     8033e9 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80337d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803381:	74 06                	je     803389 <insert_sorted_allocList+0xc9>
  803383:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803387:	75 14                	jne    80339d <insert_sorted_allocList+0xdd>
  803389:	83 ec 04             	sub    $0x4,%esp
  80338c:	68 b0 54 80 00       	push   $0x8054b0
  803391:	6a 6f                	push   $0x6f
  803393:	68 97 54 80 00       	push   $0x805497
  803398:	e8 8c e0 ff ff       	call   801429 <_panic>
  80339d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a0:	8b 50 04             	mov    0x4(%eax),%edx
  8033a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a6:	89 50 04             	mov    %edx,0x4(%eax)
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033af:	89 10                	mov    %edx,(%eax)
  8033b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b4:	8b 40 04             	mov    0x4(%eax),%eax
  8033b7:	85 c0                	test   %eax,%eax
  8033b9:	74 0d                	je     8033c8 <insert_sorted_allocList+0x108>
  8033bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033be:	8b 40 04             	mov    0x4(%eax),%eax
  8033c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c4:	89 10                	mov    %edx,(%eax)
  8033c6:	eb 08                	jmp    8033d0 <insert_sorted_allocList+0x110>
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	a3 40 60 80 00       	mov    %eax,0x806040
  8033d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d6:	89 50 04             	mov    %edx,0x4(%eax)
  8033d9:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8033de:	40                   	inc    %eax
  8033df:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8033e4:	e9 60 01 00 00       	jmp    803549 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	8b 50 08             	mov    0x8(%eax),%edx
  8033ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f2:	8b 40 08             	mov    0x8(%eax),%eax
  8033f5:	39 c2                	cmp    %eax,%edx
  8033f7:	0f 82 4c 01 00 00    	jb     803549 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8033fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803401:	75 14                	jne    803417 <insert_sorted_allocList+0x157>
  803403:	83 ec 04             	sub    $0x4,%esp
  803406:	68 e8 54 80 00       	push   $0x8054e8
  80340b:	6a 73                	push   $0x73
  80340d:	68 97 54 80 00       	push   $0x805497
  803412:	e8 12 e0 ff ff       	call   801429 <_panic>
  803417:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	89 50 04             	mov    %edx,0x4(%eax)
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	8b 40 04             	mov    0x4(%eax),%eax
  803429:	85 c0                	test   %eax,%eax
  80342b:	74 0c                	je     803439 <insert_sorted_allocList+0x179>
  80342d:	a1 44 60 80 00       	mov    0x806044,%eax
  803432:	8b 55 08             	mov    0x8(%ebp),%edx
  803435:	89 10                	mov    %edx,(%eax)
  803437:	eb 08                	jmp    803441 <insert_sorted_allocList+0x181>
  803439:	8b 45 08             	mov    0x8(%ebp),%eax
  80343c:	a3 40 60 80 00       	mov    %eax,0x806040
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	a3 44 60 80 00       	mov    %eax,0x806044
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803452:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803457:	40                   	inc    %eax
  803458:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80345d:	e9 e7 00 00 00       	jmp    803549 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  803462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803465:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  803468:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80346f:	a1 40 60 80 00       	mov    0x806040,%eax
  803474:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803477:	e9 9d 00 00 00       	jmp    803519 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80347c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  803484:	8b 45 08             	mov    0x8(%ebp),%eax
  803487:	8b 50 08             	mov    0x8(%eax),%edx
  80348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348d:	8b 40 08             	mov    0x8(%eax),%eax
  803490:	39 c2                	cmp    %eax,%edx
  803492:	76 7d                	jbe    803511 <insert_sorted_allocList+0x251>
  803494:	8b 45 08             	mov    0x8(%ebp),%eax
  803497:	8b 50 08             	mov    0x8(%eax),%edx
  80349a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349d:	8b 40 08             	mov    0x8(%eax),%eax
  8034a0:	39 c2                	cmp    %eax,%edx
  8034a2:	73 6d                	jae    803511 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8034a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a8:	74 06                	je     8034b0 <insert_sorted_allocList+0x1f0>
  8034aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ae:	75 14                	jne    8034c4 <insert_sorted_allocList+0x204>
  8034b0:	83 ec 04             	sub    $0x4,%esp
  8034b3:	68 0c 55 80 00       	push   $0x80550c
  8034b8:	6a 7f                	push   $0x7f
  8034ba:	68 97 54 80 00       	push   $0x805497
  8034bf:	e8 65 df ff ff       	call   801429 <_panic>
  8034c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c7:	8b 10                	mov    (%eax),%edx
  8034c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cc:	89 10                	mov    %edx,(%eax)
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	8b 00                	mov    (%eax),%eax
  8034d3:	85 c0                	test   %eax,%eax
  8034d5:	74 0b                	je     8034e2 <insert_sorted_allocList+0x222>
  8034d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034da:	8b 00                	mov    (%eax),%eax
  8034dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8034df:	89 50 04             	mov    %edx,0x4(%eax)
  8034e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e8:	89 10                	mov    %edx,(%eax)
  8034ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f0:	89 50 04             	mov    %edx,0x4(%eax)
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	8b 00                	mov    (%eax),%eax
  8034f8:	85 c0                	test   %eax,%eax
  8034fa:	75 08                	jne    803504 <insert_sorted_allocList+0x244>
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	a3 44 60 80 00       	mov    %eax,0x806044
  803504:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803509:	40                   	inc    %eax
  80350a:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  80350f:	eb 39                	jmp    80354a <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  803511:	a1 48 60 80 00       	mov    0x806048,%eax
  803516:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80351d:	74 07                	je     803526 <insert_sorted_allocList+0x266>
  80351f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803522:	8b 00                	mov    (%eax),%eax
  803524:	eb 05                	jmp    80352b <insert_sorted_allocList+0x26b>
  803526:	b8 00 00 00 00       	mov    $0x0,%eax
  80352b:	a3 48 60 80 00       	mov    %eax,0x806048
  803530:	a1 48 60 80 00       	mov    0x806048,%eax
  803535:	85 c0                	test   %eax,%eax
  803537:	0f 85 3f ff ff ff    	jne    80347c <insert_sorted_allocList+0x1bc>
  80353d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803541:	0f 85 35 ff ff ff    	jne    80347c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803547:	eb 01                	jmp    80354a <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803549:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80354a:	90                   	nop
  80354b:	c9                   	leave  
  80354c:	c3                   	ret    

0080354d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80354d:	55                   	push   %ebp
  80354e:	89 e5                	mov    %esp,%ebp
  803550:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803553:	a1 38 61 80 00       	mov    0x806138,%eax
  803558:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80355b:	e9 85 01 00 00       	jmp    8036e5 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  803560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803563:	8b 40 0c             	mov    0xc(%eax),%eax
  803566:	3b 45 08             	cmp    0x8(%ebp),%eax
  803569:	0f 82 6e 01 00 00    	jb     8036dd <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80356f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803572:	8b 40 0c             	mov    0xc(%eax),%eax
  803575:	3b 45 08             	cmp    0x8(%ebp),%eax
  803578:	0f 85 8a 00 00 00    	jne    803608 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80357e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803582:	75 17                	jne    80359b <alloc_block_FF+0x4e>
  803584:	83 ec 04             	sub    $0x4,%esp
  803587:	68 40 55 80 00       	push   $0x805540
  80358c:	68 93 00 00 00       	push   $0x93
  803591:	68 97 54 80 00       	push   $0x805497
  803596:	e8 8e de ff ff       	call   801429 <_panic>
  80359b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359e:	8b 00                	mov    (%eax),%eax
  8035a0:	85 c0                	test   %eax,%eax
  8035a2:	74 10                	je     8035b4 <alloc_block_FF+0x67>
  8035a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a7:	8b 00                	mov    (%eax),%eax
  8035a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ac:	8b 52 04             	mov    0x4(%edx),%edx
  8035af:	89 50 04             	mov    %edx,0x4(%eax)
  8035b2:	eb 0b                	jmp    8035bf <alloc_block_FF+0x72>
  8035b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b7:	8b 40 04             	mov    0x4(%eax),%eax
  8035ba:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8035bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c2:	8b 40 04             	mov    0x4(%eax),%eax
  8035c5:	85 c0                	test   %eax,%eax
  8035c7:	74 0f                	je     8035d8 <alloc_block_FF+0x8b>
  8035c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cc:	8b 40 04             	mov    0x4(%eax),%eax
  8035cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035d2:	8b 12                	mov    (%edx),%edx
  8035d4:	89 10                	mov    %edx,(%eax)
  8035d6:	eb 0a                	jmp    8035e2 <alloc_block_FF+0x95>
  8035d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035db:	8b 00                	mov    (%eax),%eax
  8035dd:	a3 38 61 80 00       	mov    %eax,0x806138
  8035e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f5:	a1 44 61 80 00       	mov    0x806144,%eax
  8035fa:	48                   	dec    %eax
  8035fb:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  803600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803603:	e9 10 01 00 00       	jmp    803718 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	8b 40 0c             	mov    0xc(%eax),%eax
  80360e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803611:	0f 86 c6 00 00 00    	jbe    8036dd <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803617:	a1 48 61 80 00       	mov    0x806148,%eax
  80361c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803622:	8b 50 08             	mov    0x8(%eax),%edx
  803625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803628:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80362b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80362e:	8b 55 08             	mov    0x8(%ebp),%edx
  803631:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803634:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803638:	75 17                	jne    803651 <alloc_block_FF+0x104>
  80363a:	83 ec 04             	sub    $0x4,%esp
  80363d:	68 40 55 80 00       	push   $0x805540
  803642:	68 9b 00 00 00       	push   $0x9b
  803647:	68 97 54 80 00       	push   $0x805497
  80364c:	e8 d8 dd ff ff       	call   801429 <_panic>
  803651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803654:	8b 00                	mov    (%eax),%eax
  803656:	85 c0                	test   %eax,%eax
  803658:	74 10                	je     80366a <alloc_block_FF+0x11d>
  80365a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80365d:	8b 00                	mov    (%eax),%eax
  80365f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803662:	8b 52 04             	mov    0x4(%edx),%edx
  803665:	89 50 04             	mov    %edx,0x4(%eax)
  803668:	eb 0b                	jmp    803675 <alloc_block_FF+0x128>
  80366a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366d:	8b 40 04             	mov    0x4(%eax),%eax
  803670:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803678:	8b 40 04             	mov    0x4(%eax),%eax
  80367b:	85 c0                	test   %eax,%eax
  80367d:	74 0f                	je     80368e <alloc_block_FF+0x141>
  80367f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803682:	8b 40 04             	mov    0x4(%eax),%eax
  803685:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803688:	8b 12                	mov    (%edx),%edx
  80368a:	89 10                	mov    %edx,(%eax)
  80368c:	eb 0a                	jmp    803698 <alloc_block_FF+0x14b>
  80368e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803691:	8b 00                	mov    (%eax),%eax
  803693:	a3 48 61 80 00       	mov    %eax,0x806148
  803698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ab:	a1 54 61 80 00       	mov    0x806154,%eax
  8036b0:	48                   	dec    %eax
  8036b1:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  8036b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b9:	8b 50 08             	mov    0x8(%eax),%edx
  8036bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bf:	01 c2                	add    %eax,%edx
  8036c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c4:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8036c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8036cd:	2b 45 08             	sub    0x8(%ebp),%eax
  8036d0:	89 c2                	mov    %eax,%edx
  8036d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d5:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8036d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036db:	eb 3b                	jmp    803718 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8036dd:	a1 40 61 80 00       	mov    0x806140,%eax
  8036e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e9:	74 07                	je     8036f2 <alloc_block_FF+0x1a5>
  8036eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ee:	8b 00                	mov    (%eax),%eax
  8036f0:	eb 05                	jmp    8036f7 <alloc_block_FF+0x1aa>
  8036f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f7:	a3 40 61 80 00       	mov    %eax,0x806140
  8036fc:	a1 40 61 80 00       	mov    0x806140,%eax
  803701:	85 c0                	test   %eax,%eax
  803703:	0f 85 57 fe ff ff    	jne    803560 <alloc_block_FF+0x13>
  803709:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80370d:	0f 85 4d fe ff ff    	jne    803560 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  803713:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803718:	c9                   	leave  
  803719:	c3                   	ret    

0080371a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80371a:	55                   	push   %ebp
  80371b:	89 e5                	mov    %esp,%ebp
  80371d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  803720:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803727:	a1 38 61 80 00       	mov    0x806138,%eax
  80372c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80372f:	e9 df 00 00 00       	jmp    803813 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803737:	8b 40 0c             	mov    0xc(%eax),%eax
  80373a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80373d:	0f 82 c8 00 00 00    	jb     80380b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803746:	8b 40 0c             	mov    0xc(%eax),%eax
  803749:	3b 45 08             	cmp    0x8(%ebp),%eax
  80374c:	0f 85 8a 00 00 00    	jne    8037dc <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803752:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803756:	75 17                	jne    80376f <alloc_block_BF+0x55>
  803758:	83 ec 04             	sub    $0x4,%esp
  80375b:	68 40 55 80 00       	push   $0x805540
  803760:	68 b7 00 00 00       	push   $0xb7
  803765:	68 97 54 80 00       	push   $0x805497
  80376a:	e8 ba dc ff ff       	call   801429 <_panic>
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	8b 00                	mov    (%eax),%eax
  803774:	85 c0                	test   %eax,%eax
  803776:	74 10                	je     803788 <alloc_block_BF+0x6e>
  803778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377b:	8b 00                	mov    (%eax),%eax
  80377d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803780:	8b 52 04             	mov    0x4(%edx),%edx
  803783:	89 50 04             	mov    %edx,0x4(%eax)
  803786:	eb 0b                	jmp    803793 <alloc_block_BF+0x79>
  803788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378b:	8b 40 04             	mov    0x4(%eax),%eax
  80378e:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803796:	8b 40 04             	mov    0x4(%eax),%eax
  803799:	85 c0                	test   %eax,%eax
  80379b:	74 0f                	je     8037ac <alloc_block_BF+0x92>
  80379d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a0:	8b 40 04             	mov    0x4(%eax),%eax
  8037a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037a6:	8b 12                	mov    (%edx),%edx
  8037a8:	89 10                	mov    %edx,(%eax)
  8037aa:	eb 0a                	jmp    8037b6 <alloc_block_BF+0x9c>
  8037ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037af:	8b 00                	mov    (%eax),%eax
  8037b1:	a3 38 61 80 00       	mov    %eax,0x806138
  8037b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c9:	a1 44 61 80 00       	mov    0x806144,%eax
  8037ce:	48                   	dec    %eax
  8037cf:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  8037d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d7:	e9 4d 01 00 00       	jmp    803929 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8037dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037df:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037e5:	76 24                	jbe    80380b <alloc_block_BF+0xf1>
  8037e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8037f0:	73 19                	jae    80380b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8037f2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8037f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803805:	8b 40 08             	mov    0x8(%eax),%eax
  803808:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80380b:	a1 40 61 80 00       	mov    0x806140,%eax
  803810:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803813:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803817:	74 07                	je     803820 <alloc_block_BF+0x106>
  803819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	eb 05                	jmp    803825 <alloc_block_BF+0x10b>
  803820:	b8 00 00 00 00       	mov    $0x0,%eax
  803825:	a3 40 61 80 00       	mov    %eax,0x806140
  80382a:	a1 40 61 80 00       	mov    0x806140,%eax
  80382f:	85 c0                	test   %eax,%eax
  803831:	0f 85 fd fe ff ff    	jne    803734 <alloc_block_BF+0x1a>
  803837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80383b:	0f 85 f3 fe ff ff    	jne    803734 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803841:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803845:	0f 84 d9 00 00 00    	je     803924 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80384b:	a1 48 61 80 00       	mov    0x806148,%eax
  803850:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803856:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803859:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80385c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385f:	8b 55 08             	mov    0x8(%ebp),%edx
  803862:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803865:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803869:	75 17                	jne    803882 <alloc_block_BF+0x168>
  80386b:	83 ec 04             	sub    $0x4,%esp
  80386e:	68 40 55 80 00       	push   $0x805540
  803873:	68 c7 00 00 00       	push   $0xc7
  803878:	68 97 54 80 00       	push   $0x805497
  80387d:	e8 a7 db ff ff       	call   801429 <_panic>
  803882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803885:	8b 00                	mov    (%eax),%eax
  803887:	85 c0                	test   %eax,%eax
  803889:	74 10                	je     80389b <alloc_block_BF+0x181>
  80388b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388e:	8b 00                	mov    (%eax),%eax
  803890:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803893:	8b 52 04             	mov    0x4(%edx),%edx
  803896:	89 50 04             	mov    %edx,0x4(%eax)
  803899:	eb 0b                	jmp    8038a6 <alloc_block_BF+0x18c>
  80389b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389e:	8b 40 04             	mov    0x4(%eax),%eax
  8038a1:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8038a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a9:	8b 40 04             	mov    0x4(%eax),%eax
  8038ac:	85 c0                	test   %eax,%eax
  8038ae:	74 0f                	je     8038bf <alloc_block_BF+0x1a5>
  8038b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b3:	8b 40 04             	mov    0x4(%eax),%eax
  8038b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b9:	8b 12                	mov    (%edx),%edx
  8038bb:	89 10                	mov    %edx,(%eax)
  8038bd:	eb 0a                	jmp    8038c9 <alloc_block_BF+0x1af>
  8038bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c2:	8b 00                	mov    (%eax),%eax
  8038c4:	a3 48 61 80 00       	mov    %eax,0x806148
  8038c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038dc:	a1 54 61 80 00       	mov    0x806154,%eax
  8038e1:	48                   	dec    %eax
  8038e2:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8038e7:	83 ec 08             	sub    $0x8,%esp
  8038ea:	ff 75 ec             	pushl  -0x14(%ebp)
  8038ed:	68 38 61 80 00       	push   $0x806138
  8038f2:	e8 71 f9 ff ff       	call   803268 <find_block>
  8038f7:	83 c4 10             	add    $0x10,%esp
  8038fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8038fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803900:	8b 50 08             	mov    0x8(%eax),%edx
  803903:	8b 45 08             	mov    0x8(%ebp),%eax
  803906:	01 c2                	add    %eax,%edx
  803908:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80390b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80390e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803911:	8b 40 0c             	mov    0xc(%eax),%eax
  803914:	2b 45 08             	sub    0x8(%ebp),%eax
  803917:	89 c2                	mov    %eax,%edx
  803919:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80391c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80391f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803922:	eb 05                	jmp    803929 <alloc_block_BF+0x20f>
	}
	return NULL;
  803924:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803929:	c9                   	leave  
  80392a:	c3                   	ret    

0080392b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80392b:	55                   	push   %ebp
  80392c:	89 e5                	mov    %esp,%ebp
  80392e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803931:	a1 28 60 80 00       	mov    0x806028,%eax
  803936:	85 c0                	test   %eax,%eax
  803938:	0f 85 de 01 00 00    	jne    803b1c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80393e:	a1 38 61 80 00       	mov    0x806138,%eax
  803943:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803946:	e9 9e 01 00 00       	jmp    803ae9 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80394b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394e:	8b 40 0c             	mov    0xc(%eax),%eax
  803951:	3b 45 08             	cmp    0x8(%ebp),%eax
  803954:	0f 82 87 01 00 00    	jb     803ae1 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80395a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395d:	8b 40 0c             	mov    0xc(%eax),%eax
  803960:	3b 45 08             	cmp    0x8(%ebp),%eax
  803963:	0f 85 95 00 00 00    	jne    8039fe <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803969:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80396d:	75 17                	jne    803986 <alloc_block_NF+0x5b>
  80396f:	83 ec 04             	sub    $0x4,%esp
  803972:	68 40 55 80 00       	push   $0x805540
  803977:	68 e0 00 00 00       	push   $0xe0
  80397c:	68 97 54 80 00       	push   $0x805497
  803981:	e8 a3 da ff ff       	call   801429 <_panic>
  803986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803989:	8b 00                	mov    (%eax),%eax
  80398b:	85 c0                	test   %eax,%eax
  80398d:	74 10                	je     80399f <alloc_block_NF+0x74>
  80398f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803992:	8b 00                	mov    (%eax),%eax
  803994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803997:	8b 52 04             	mov    0x4(%edx),%edx
  80399a:	89 50 04             	mov    %edx,0x4(%eax)
  80399d:	eb 0b                	jmp    8039aa <alloc_block_NF+0x7f>
  80399f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a2:	8b 40 04             	mov    0x4(%eax),%eax
  8039a5:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8039aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ad:	8b 40 04             	mov    0x4(%eax),%eax
  8039b0:	85 c0                	test   %eax,%eax
  8039b2:	74 0f                	je     8039c3 <alloc_block_NF+0x98>
  8039b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b7:	8b 40 04             	mov    0x4(%eax),%eax
  8039ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039bd:	8b 12                	mov    (%edx),%edx
  8039bf:	89 10                	mov    %edx,(%eax)
  8039c1:	eb 0a                	jmp    8039cd <alloc_block_NF+0xa2>
  8039c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c6:	8b 00                	mov    (%eax),%eax
  8039c8:	a3 38 61 80 00       	mov    %eax,0x806138
  8039cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e0:	a1 44 61 80 00       	mov    0x806144,%eax
  8039e5:	48                   	dec    %eax
  8039e6:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  8039eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ee:	8b 40 08             	mov    0x8(%eax),%eax
  8039f1:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  8039f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f9:	e9 f8 04 00 00       	jmp    803ef6 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8039fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a01:	8b 40 0c             	mov    0xc(%eax),%eax
  803a04:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a07:	0f 86 d4 00 00 00    	jbe    803ae1 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803a0d:	a1 48 61 80 00       	mov    0x806148,%eax
  803a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a18:	8b 50 08             	mov    0x8(%eax),%edx
  803a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a24:	8b 55 08             	mov    0x8(%ebp),%edx
  803a27:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803a2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a2e:	75 17                	jne    803a47 <alloc_block_NF+0x11c>
  803a30:	83 ec 04             	sub    $0x4,%esp
  803a33:	68 40 55 80 00       	push   $0x805540
  803a38:	68 e9 00 00 00       	push   $0xe9
  803a3d:	68 97 54 80 00       	push   $0x805497
  803a42:	e8 e2 d9 ff ff       	call   801429 <_panic>
  803a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a4a:	8b 00                	mov    (%eax),%eax
  803a4c:	85 c0                	test   %eax,%eax
  803a4e:	74 10                	je     803a60 <alloc_block_NF+0x135>
  803a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a53:	8b 00                	mov    (%eax),%eax
  803a55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a58:	8b 52 04             	mov    0x4(%edx),%edx
  803a5b:	89 50 04             	mov    %edx,0x4(%eax)
  803a5e:	eb 0b                	jmp    803a6b <alloc_block_NF+0x140>
  803a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a63:	8b 40 04             	mov    0x4(%eax),%eax
  803a66:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6e:	8b 40 04             	mov    0x4(%eax),%eax
  803a71:	85 c0                	test   %eax,%eax
  803a73:	74 0f                	je     803a84 <alloc_block_NF+0x159>
  803a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a78:	8b 40 04             	mov    0x4(%eax),%eax
  803a7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a7e:	8b 12                	mov    (%edx),%edx
  803a80:	89 10                	mov    %edx,(%eax)
  803a82:	eb 0a                	jmp    803a8e <alloc_block_NF+0x163>
  803a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a87:	8b 00                	mov    (%eax),%eax
  803a89:	a3 48 61 80 00       	mov    %eax,0x806148
  803a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aa1:	a1 54 61 80 00       	mov    0x806154,%eax
  803aa6:	48                   	dec    %eax
  803aa7:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  803aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aaf:	8b 40 08             	mov    0x8(%eax),%eax
  803ab2:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  803ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aba:	8b 50 08             	mov    0x8(%eax),%edx
  803abd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac0:	01 c2                	add    %eax,%edx
  803ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac5:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acb:	8b 40 0c             	mov    0xc(%eax),%eax
  803ace:	2b 45 08             	sub    0x8(%ebp),%eax
  803ad1:	89 c2                	mov    %eax,%edx
  803ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad6:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803adc:	e9 15 04 00 00       	jmp    803ef6 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803ae1:	a1 40 61 80 00       	mov    0x806140,%eax
  803ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aed:	74 07                	je     803af6 <alloc_block_NF+0x1cb>
  803aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af2:	8b 00                	mov    (%eax),%eax
  803af4:	eb 05                	jmp    803afb <alloc_block_NF+0x1d0>
  803af6:	b8 00 00 00 00       	mov    $0x0,%eax
  803afb:	a3 40 61 80 00       	mov    %eax,0x806140
  803b00:	a1 40 61 80 00       	mov    0x806140,%eax
  803b05:	85 c0                	test   %eax,%eax
  803b07:	0f 85 3e fe ff ff    	jne    80394b <alloc_block_NF+0x20>
  803b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b11:	0f 85 34 fe ff ff    	jne    80394b <alloc_block_NF+0x20>
  803b17:	e9 d5 03 00 00       	jmp    803ef1 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803b1c:	a1 38 61 80 00       	mov    0x806138,%eax
  803b21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b24:	e9 b1 01 00 00       	jmp    803cda <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2c:	8b 50 08             	mov    0x8(%eax),%edx
  803b2f:	a1 28 60 80 00       	mov    0x806028,%eax
  803b34:	39 c2                	cmp    %eax,%edx
  803b36:	0f 82 96 01 00 00    	jb     803cd2 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3f:	8b 40 0c             	mov    0xc(%eax),%eax
  803b42:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b45:	0f 82 87 01 00 00    	jb     803cd2 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4e:	8b 40 0c             	mov    0xc(%eax),%eax
  803b51:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b54:	0f 85 95 00 00 00    	jne    803bef <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803b5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b5e:	75 17                	jne    803b77 <alloc_block_NF+0x24c>
  803b60:	83 ec 04             	sub    $0x4,%esp
  803b63:	68 40 55 80 00       	push   $0x805540
  803b68:	68 fc 00 00 00       	push   $0xfc
  803b6d:	68 97 54 80 00       	push   $0x805497
  803b72:	e8 b2 d8 ff ff       	call   801429 <_panic>
  803b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7a:	8b 00                	mov    (%eax),%eax
  803b7c:	85 c0                	test   %eax,%eax
  803b7e:	74 10                	je     803b90 <alloc_block_NF+0x265>
  803b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b83:	8b 00                	mov    (%eax),%eax
  803b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b88:	8b 52 04             	mov    0x4(%edx),%edx
  803b8b:	89 50 04             	mov    %edx,0x4(%eax)
  803b8e:	eb 0b                	jmp    803b9b <alloc_block_NF+0x270>
  803b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b93:	8b 40 04             	mov    0x4(%eax),%eax
  803b96:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ba1:	85 c0                	test   %eax,%eax
  803ba3:	74 0f                	je     803bb4 <alloc_block_NF+0x289>
  803ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba8:	8b 40 04             	mov    0x4(%eax),%eax
  803bab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bae:	8b 12                	mov    (%edx),%edx
  803bb0:	89 10                	mov    %edx,(%eax)
  803bb2:	eb 0a                	jmp    803bbe <alloc_block_NF+0x293>
  803bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb7:	8b 00                	mov    (%eax),%eax
  803bb9:	a3 38 61 80 00       	mov    %eax,0x806138
  803bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bd1:	a1 44 61 80 00       	mov    0x806144,%eax
  803bd6:	48                   	dec    %eax
  803bd7:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdf:	8b 40 08             	mov    0x8(%eax),%eax
  803be2:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bea:	e9 07 03 00 00       	jmp    803ef6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  803bf5:	3b 45 08             	cmp    0x8(%ebp),%eax
  803bf8:	0f 86 d4 00 00 00    	jbe    803cd2 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803bfe:	a1 48 61 80 00       	mov    0x806148,%eax
  803c03:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c09:	8b 50 08             	mov    0x8(%eax),%edx
  803c0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803c12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c15:	8b 55 08             	mov    0x8(%ebp),%edx
  803c18:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803c1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c1f:	75 17                	jne    803c38 <alloc_block_NF+0x30d>
  803c21:	83 ec 04             	sub    $0x4,%esp
  803c24:	68 40 55 80 00       	push   $0x805540
  803c29:	68 04 01 00 00       	push   $0x104
  803c2e:	68 97 54 80 00       	push   $0x805497
  803c33:	e8 f1 d7 ff ff       	call   801429 <_panic>
  803c38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c3b:	8b 00                	mov    (%eax),%eax
  803c3d:	85 c0                	test   %eax,%eax
  803c3f:	74 10                	je     803c51 <alloc_block_NF+0x326>
  803c41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c44:	8b 00                	mov    (%eax),%eax
  803c46:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c49:	8b 52 04             	mov    0x4(%edx),%edx
  803c4c:	89 50 04             	mov    %edx,0x4(%eax)
  803c4f:	eb 0b                	jmp    803c5c <alloc_block_NF+0x331>
  803c51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c54:	8b 40 04             	mov    0x4(%eax),%eax
  803c57:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803c5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5f:	8b 40 04             	mov    0x4(%eax),%eax
  803c62:	85 c0                	test   %eax,%eax
  803c64:	74 0f                	je     803c75 <alloc_block_NF+0x34a>
  803c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c69:	8b 40 04             	mov    0x4(%eax),%eax
  803c6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c6f:	8b 12                	mov    (%edx),%edx
  803c71:	89 10                	mov    %edx,(%eax)
  803c73:	eb 0a                	jmp    803c7f <alloc_block_NF+0x354>
  803c75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c78:	8b 00                	mov    (%eax),%eax
  803c7a:	a3 48 61 80 00       	mov    %eax,0x806148
  803c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c92:	a1 54 61 80 00       	mov    0x806154,%eax
  803c97:	48                   	dec    %eax
  803c98:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803c9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca0:	8b 40 08             	mov    0x8(%eax),%eax
  803ca3:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cab:	8b 50 08             	mov    0x8(%eax),%edx
  803cae:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb1:	01 c2                	add    %eax,%edx
  803cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbc:	8b 40 0c             	mov    0xc(%eax),%eax
  803cbf:	2b 45 08             	sub    0x8(%ebp),%eax
  803cc2:	89 c2                	mov    %eax,%edx
  803cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803cca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ccd:	e9 24 02 00 00       	jmp    803ef6 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803cd2:	a1 40 61 80 00       	mov    0x806140,%eax
  803cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cde:	74 07                	je     803ce7 <alloc_block_NF+0x3bc>
  803ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce3:	8b 00                	mov    (%eax),%eax
  803ce5:	eb 05                	jmp    803cec <alloc_block_NF+0x3c1>
  803ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  803cec:	a3 40 61 80 00       	mov    %eax,0x806140
  803cf1:	a1 40 61 80 00       	mov    0x806140,%eax
  803cf6:	85 c0                	test   %eax,%eax
  803cf8:	0f 85 2b fe ff ff    	jne    803b29 <alloc_block_NF+0x1fe>
  803cfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d02:	0f 85 21 fe ff ff    	jne    803b29 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803d08:	a1 38 61 80 00       	mov    0x806138,%eax
  803d0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d10:	e9 ae 01 00 00       	jmp    803ec3 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d18:	8b 50 08             	mov    0x8(%eax),%edx
  803d1b:	a1 28 60 80 00       	mov    0x806028,%eax
  803d20:	39 c2                	cmp    %eax,%edx
  803d22:	0f 83 93 01 00 00    	jae    803ebb <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  803d2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d31:	0f 82 84 01 00 00    	jb     803ebb <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3a:	8b 40 0c             	mov    0xc(%eax),%eax
  803d3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d40:	0f 85 95 00 00 00    	jne    803ddb <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803d46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d4a:	75 17                	jne    803d63 <alloc_block_NF+0x438>
  803d4c:	83 ec 04             	sub    $0x4,%esp
  803d4f:	68 40 55 80 00       	push   $0x805540
  803d54:	68 14 01 00 00       	push   $0x114
  803d59:	68 97 54 80 00       	push   $0x805497
  803d5e:	e8 c6 d6 ff ff       	call   801429 <_panic>
  803d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d66:	8b 00                	mov    (%eax),%eax
  803d68:	85 c0                	test   %eax,%eax
  803d6a:	74 10                	je     803d7c <alloc_block_NF+0x451>
  803d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6f:	8b 00                	mov    (%eax),%eax
  803d71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d74:	8b 52 04             	mov    0x4(%edx),%edx
  803d77:	89 50 04             	mov    %edx,0x4(%eax)
  803d7a:	eb 0b                	jmp    803d87 <alloc_block_NF+0x45c>
  803d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d7f:	8b 40 04             	mov    0x4(%eax),%eax
  803d82:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8a:	8b 40 04             	mov    0x4(%eax),%eax
  803d8d:	85 c0                	test   %eax,%eax
  803d8f:	74 0f                	je     803da0 <alloc_block_NF+0x475>
  803d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d94:	8b 40 04             	mov    0x4(%eax),%eax
  803d97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d9a:	8b 12                	mov    (%edx),%edx
  803d9c:	89 10                	mov    %edx,(%eax)
  803d9e:	eb 0a                	jmp    803daa <alloc_block_NF+0x47f>
  803da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da3:	8b 00                	mov    (%eax),%eax
  803da5:	a3 38 61 80 00       	mov    %eax,0x806138
  803daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dbd:	a1 44 61 80 00       	mov    0x806144,%eax
  803dc2:	48                   	dec    %eax
  803dc3:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dcb:	8b 40 08             	mov    0x8(%eax),%eax
  803dce:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd6:	e9 1b 01 00 00       	jmp    803ef6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dde:	8b 40 0c             	mov    0xc(%eax),%eax
  803de1:	3b 45 08             	cmp    0x8(%ebp),%eax
  803de4:	0f 86 d1 00 00 00    	jbe    803ebb <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803dea:	a1 48 61 80 00       	mov    0x806148,%eax
  803def:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df5:	8b 50 08             	mov    0x8(%eax),%edx
  803df8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dfb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803dfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e01:	8b 55 08             	mov    0x8(%ebp),%edx
  803e04:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803e07:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e0b:	75 17                	jne    803e24 <alloc_block_NF+0x4f9>
  803e0d:	83 ec 04             	sub    $0x4,%esp
  803e10:	68 40 55 80 00       	push   $0x805540
  803e15:	68 1c 01 00 00       	push   $0x11c
  803e1a:	68 97 54 80 00       	push   $0x805497
  803e1f:	e8 05 d6 ff ff       	call   801429 <_panic>
  803e24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e27:	8b 00                	mov    (%eax),%eax
  803e29:	85 c0                	test   %eax,%eax
  803e2b:	74 10                	je     803e3d <alloc_block_NF+0x512>
  803e2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e30:	8b 00                	mov    (%eax),%eax
  803e32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e35:	8b 52 04             	mov    0x4(%edx),%edx
  803e38:	89 50 04             	mov    %edx,0x4(%eax)
  803e3b:	eb 0b                	jmp    803e48 <alloc_block_NF+0x51d>
  803e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e40:	8b 40 04             	mov    0x4(%eax),%eax
  803e43:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803e48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e4b:	8b 40 04             	mov    0x4(%eax),%eax
  803e4e:	85 c0                	test   %eax,%eax
  803e50:	74 0f                	je     803e61 <alloc_block_NF+0x536>
  803e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e55:	8b 40 04             	mov    0x4(%eax),%eax
  803e58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e5b:	8b 12                	mov    (%edx),%edx
  803e5d:	89 10                	mov    %edx,(%eax)
  803e5f:	eb 0a                	jmp    803e6b <alloc_block_NF+0x540>
  803e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e64:	8b 00                	mov    (%eax),%eax
  803e66:	a3 48 61 80 00       	mov    %eax,0x806148
  803e6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e7e:	a1 54 61 80 00       	mov    0x806154,%eax
  803e83:	48                   	dec    %eax
  803e84:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e8c:	8b 40 08             	mov    0x8(%eax),%eax
  803e8f:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e97:	8b 50 08             	mov    0x8(%eax),%edx
  803e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9d:	01 c2                	add    %eax,%edx
  803e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea2:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea8:	8b 40 0c             	mov    0xc(%eax),%eax
  803eab:	2b 45 08             	sub    0x8(%ebp),%eax
  803eae:	89 c2                	mov    %eax,%edx
  803eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eb9:	eb 3b                	jmp    803ef6 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803ebb:	a1 40 61 80 00       	mov    0x806140,%eax
  803ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ec3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ec7:	74 07                	je     803ed0 <alloc_block_NF+0x5a5>
  803ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ecc:	8b 00                	mov    (%eax),%eax
  803ece:	eb 05                	jmp    803ed5 <alloc_block_NF+0x5aa>
  803ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ed5:	a3 40 61 80 00       	mov    %eax,0x806140
  803eda:	a1 40 61 80 00       	mov    0x806140,%eax
  803edf:	85 c0                	test   %eax,%eax
  803ee1:	0f 85 2e fe ff ff    	jne    803d15 <alloc_block_NF+0x3ea>
  803ee7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eeb:	0f 85 24 fe ff ff    	jne    803d15 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803ef1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ef6:	c9                   	leave  
  803ef7:	c3                   	ret    

00803ef8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803ef8:	55                   	push   %ebp
  803ef9:	89 e5                	mov    %esp,%ebp
  803efb:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803efe:	a1 38 61 80 00       	mov    0x806138,%eax
  803f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803f06:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803f0b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803f0e:	a1 38 61 80 00       	mov    0x806138,%eax
  803f13:	85 c0                	test   %eax,%eax
  803f15:	74 14                	je     803f2b <insert_sorted_with_merge_freeList+0x33>
  803f17:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1a:	8b 50 08             	mov    0x8(%eax),%edx
  803f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f20:	8b 40 08             	mov    0x8(%eax),%eax
  803f23:	39 c2                	cmp    %eax,%edx
  803f25:	0f 87 9b 01 00 00    	ja     8040c6 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803f2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f2f:	75 17                	jne    803f48 <insert_sorted_with_merge_freeList+0x50>
  803f31:	83 ec 04             	sub    $0x4,%esp
  803f34:	68 74 54 80 00       	push   $0x805474
  803f39:	68 38 01 00 00       	push   $0x138
  803f3e:	68 97 54 80 00       	push   $0x805497
  803f43:	e8 e1 d4 ff ff       	call   801429 <_panic>
  803f48:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803f51:	89 10                	mov    %edx,(%eax)
  803f53:	8b 45 08             	mov    0x8(%ebp),%eax
  803f56:	8b 00                	mov    (%eax),%eax
  803f58:	85 c0                	test   %eax,%eax
  803f5a:	74 0d                	je     803f69 <insert_sorted_with_merge_freeList+0x71>
  803f5c:	a1 38 61 80 00       	mov    0x806138,%eax
  803f61:	8b 55 08             	mov    0x8(%ebp),%edx
  803f64:	89 50 04             	mov    %edx,0x4(%eax)
  803f67:	eb 08                	jmp    803f71 <insert_sorted_with_merge_freeList+0x79>
  803f69:	8b 45 08             	mov    0x8(%ebp),%eax
  803f6c:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803f71:	8b 45 08             	mov    0x8(%ebp),%eax
  803f74:	a3 38 61 80 00       	mov    %eax,0x806138
  803f79:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f83:	a1 44 61 80 00       	mov    0x806144,%eax
  803f88:	40                   	inc    %eax
  803f89:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803f8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f92:	0f 84 a8 06 00 00    	je     804640 <insert_sorted_with_merge_freeList+0x748>
  803f98:	8b 45 08             	mov    0x8(%ebp),%eax
  803f9b:	8b 50 08             	mov    0x8(%eax),%edx
  803f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa1:	8b 40 0c             	mov    0xc(%eax),%eax
  803fa4:	01 c2                	add    %eax,%edx
  803fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa9:	8b 40 08             	mov    0x8(%eax),%eax
  803fac:	39 c2                	cmp    %eax,%edx
  803fae:	0f 85 8c 06 00 00    	jne    804640 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb7:	8b 50 0c             	mov    0xc(%eax),%edx
  803fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fbd:	8b 40 0c             	mov    0xc(%eax),%eax
  803fc0:	01 c2                	add    %eax,%edx
  803fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc5:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803fc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803fcc:	75 17                	jne    803fe5 <insert_sorted_with_merge_freeList+0xed>
  803fce:	83 ec 04             	sub    $0x4,%esp
  803fd1:	68 40 55 80 00       	push   $0x805540
  803fd6:	68 3c 01 00 00       	push   $0x13c
  803fdb:	68 97 54 80 00       	push   $0x805497
  803fe0:	e8 44 d4 ff ff       	call   801429 <_panic>
  803fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fe8:	8b 00                	mov    (%eax),%eax
  803fea:	85 c0                	test   %eax,%eax
  803fec:	74 10                	je     803ffe <insert_sorted_with_merge_freeList+0x106>
  803fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff1:	8b 00                	mov    (%eax),%eax
  803ff3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ff6:	8b 52 04             	mov    0x4(%edx),%edx
  803ff9:	89 50 04             	mov    %edx,0x4(%eax)
  803ffc:	eb 0b                	jmp    804009 <insert_sorted_with_merge_freeList+0x111>
  803ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804001:	8b 40 04             	mov    0x4(%eax),%eax
  804004:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80400c:	8b 40 04             	mov    0x4(%eax),%eax
  80400f:	85 c0                	test   %eax,%eax
  804011:	74 0f                	je     804022 <insert_sorted_with_merge_freeList+0x12a>
  804013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804016:	8b 40 04             	mov    0x4(%eax),%eax
  804019:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80401c:	8b 12                	mov    (%edx),%edx
  80401e:	89 10                	mov    %edx,(%eax)
  804020:	eb 0a                	jmp    80402c <insert_sorted_with_merge_freeList+0x134>
  804022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804025:	8b 00                	mov    (%eax),%eax
  804027:	a3 38 61 80 00       	mov    %eax,0x806138
  80402c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80402f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804038:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80403f:	a1 44 61 80 00       	mov    0x806144,%eax
  804044:	48                   	dec    %eax
  804045:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  80404a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80404d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  804054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804057:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80405e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804062:	75 17                	jne    80407b <insert_sorted_with_merge_freeList+0x183>
  804064:	83 ec 04             	sub    $0x4,%esp
  804067:	68 74 54 80 00       	push   $0x805474
  80406c:	68 3f 01 00 00       	push   $0x13f
  804071:	68 97 54 80 00       	push   $0x805497
  804076:	e8 ae d3 ff ff       	call   801429 <_panic>
  80407b:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804084:	89 10                	mov    %edx,(%eax)
  804086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804089:	8b 00                	mov    (%eax),%eax
  80408b:	85 c0                	test   %eax,%eax
  80408d:	74 0d                	je     80409c <insert_sorted_with_merge_freeList+0x1a4>
  80408f:	a1 48 61 80 00       	mov    0x806148,%eax
  804094:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804097:	89 50 04             	mov    %edx,0x4(%eax)
  80409a:	eb 08                	jmp    8040a4 <insert_sorted_with_merge_freeList+0x1ac>
  80409c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80409f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8040a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040a7:	a3 48 61 80 00       	mov    %eax,0x806148
  8040ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040b6:	a1 54 61 80 00       	mov    0x806154,%eax
  8040bb:	40                   	inc    %eax
  8040bc:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8040c1:	e9 7a 05 00 00       	jmp    804640 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8040c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040c9:	8b 50 08             	mov    0x8(%eax),%edx
  8040cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040cf:	8b 40 08             	mov    0x8(%eax),%eax
  8040d2:	39 c2                	cmp    %eax,%edx
  8040d4:	0f 82 14 01 00 00    	jb     8041ee <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8040da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040dd:	8b 50 08             	mov    0x8(%eax),%edx
  8040e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8040e6:	01 c2                	add    %eax,%edx
  8040e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8040eb:	8b 40 08             	mov    0x8(%eax),%eax
  8040ee:	39 c2                	cmp    %eax,%edx
  8040f0:	0f 85 90 00 00 00    	jne    804186 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8040f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8040fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ff:	8b 40 0c             	mov    0xc(%eax),%eax
  804102:	01 c2                	add    %eax,%edx
  804104:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804107:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80410a:	8b 45 08             	mov    0x8(%ebp),%eax
  80410d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  804114:	8b 45 08             	mov    0x8(%ebp),%eax
  804117:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80411e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804122:	75 17                	jne    80413b <insert_sorted_with_merge_freeList+0x243>
  804124:	83 ec 04             	sub    $0x4,%esp
  804127:	68 74 54 80 00       	push   $0x805474
  80412c:	68 49 01 00 00       	push   $0x149
  804131:	68 97 54 80 00       	push   $0x805497
  804136:	e8 ee d2 ff ff       	call   801429 <_panic>
  80413b:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804141:	8b 45 08             	mov    0x8(%ebp),%eax
  804144:	89 10                	mov    %edx,(%eax)
  804146:	8b 45 08             	mov    0x8(%ebp),%eax
  804149:	8b 00                	mov    (%eax),%eax
  80414b:	85 c0                	test   %eax,%eax
  80414d:	74 0d                	je     80415c <insert_sorted_with_merge_freeList+0x264>
  80414f:	a1 48 61 80 00       	mov    0x806148,%eax
  804154:	8b 55 08             	mov    0x8(%ebp),%edx
  804157:	89 50 04             	mov    %edx,0x4(%eax)
  80415a:	eb 08                	jmp    804164 <insert_sorted_with_merge_freeList+0x26c>
  80415c:	8b 45 08             	mov    0x8(%ebp),%eax
  80415f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804164:	8b 45 08             	mov    0x8(%ebp),%eax
  804167:	a3 48 61 80 00       	mov    %eax,0x806148
  80416c:	8b 45 08             	mov    0x8(%ebp),%eax
  80416f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804176:	a1 54 61 80 00       	mov    0x806154,%eax
  80417b:	40                   	inc    %eax
  80417c:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804181:	e9 bb 04 00 00       	jmp    804641 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  804186:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80418a:	75 17                	jne    8041a3 <insert_sorted_with_merge_freeList+0x2ab>
  80418c:	83 ec 04             	sub    $0x4,%esp
  80418f:	68 e8 54 80 00       	push   $0x8054e8
  804194:	68 4c 01 00 00       	push   $0x14c
  804199:	68 97 54 80 00       	push   $0x805497
  80419e:	e8 86 d2 ff ff       	call   801429 <_panic>
  8041a3:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  8041a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ac:	89 50 04             	mov    %edx,0x4(%eax)
  8041af:	8b 45 08             	mov    0x8(%ebp),%eax
  8041b2:	8b 40 04             	mov    0x4(%eax),%eax
  8041b5:	85 c0                	test   %eax,%eax
  8041b7:	74 0c                	je     8041c5 <insert_sorted_with_merge_freeList+0x2cd>
  8041b9:	a1 3c 61 80 00       	mov    0x80613c,%eax
  8041be:	8b 55 08             	mov    0x8(%ebp),%edx
  8041c1:	89 10                	mov    %edx,(%eax)
  8041c3:	eb 08                	jmp    8041cd <insert_sorted_with_merge_freeList+0x2d5>
  8041c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8041c8:	a3 38 61 80 00       	mov    %eax,0x806138
  8041cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d0:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8041d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041de:	a1 44 61 80 00       	mov    0x806144,%eax
  8041e3:	40                   	inc    %eax
  8041e4:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8041e9:	e9 53 04 00 00       	jmp    804641 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8041ee:	a1 38 61 80 00       	mov    0x806138,%eax
  8041f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8041f6:	e9 15 04 00 00       	jmp    804610 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8041fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041fe:	8b 00                	mov    (%eax),%eax
  804200:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  804203:	8b 45 08             	mov    0x8(%ebp),%eax
  804206:	8b 50 08             	mov    0x8(%eax),%edx
  804209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80420c:	8b 40 08             	mov    0x8(%eax),%eax
  80420f:	39 c2                	cmp    %eax,%edx
  804211:	0f 86 f1 03 00 00    	jbe    804608 <insert_sorted_with_merge_freeList+0x710>
  804217:	8b 45 08             	mov    0x8(%ebp),%eax
  80421a:	8b 50 08             	mov    0x8(%eax),%edx
  80421d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804220:	8b 40 08             	mov    0x8(%eax),%eax
  804223:	39 c2                	cmp    %eax,%edx
  804225:	0f 83 dd 03 00 00    	jae    804608 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80422b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80422e:	8b 50 08             	mov    0x8(%eax),%edx
  804231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804234:	8b 40 0c             	mov    0xc(%eax),%eax
  804237:	01 c2                	add    %eax,%edx
  804239:	8b 45 08             	mov    0x8(%ebp),%eax
  80423c:	8b 40 08             	mov    0x8(%eax),%eax
  80423f:	39 c2                	cmp    %eax,%edx
  804241:	0f 85 b9 01 00 00    	jne    804400 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804247:	8b 45 08             	mov    0x8(%ebp),%eax
  80424a:	8b 50 08             	mov    0x8(%eax),%edx
  80424d:	8b 45 08             	mov    0x8(%ebp),%eax
  804250:	8b 40 0c             	mov    0xc(%eax),%eax
  804253:	01 c2                	add    %eax,%edx
  804255:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804258:	8b 40 08             	mov    0x8(%eax),%eax
  80425b:	39 c2                	cmp    %eax,%edx
  80425d:	0f 85 0d 01 00 00    	jne    804370 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  804263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804266:	8b 50 0c             	mov    0xc(%eax),%edx
  804269:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80426c:	8b 40 0c             	mov    0xc(%eax),%eax
  80426f:	01 c2                	add    %eax,%edx
  804271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804274:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  804277:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80427b:	75 17                	jne    804294 <insert_sorted_with_merge_freeList+0x39c>
  80427d:	83 ec 04             	sub    $0x4,%esp
  804280:	68 40 55 80 00       	push   $0x805540
  804285:	68 5c 01 00 00       	push   $0x15c
  80428a:	68 97 54 80 00       	push   $0x805497
  80428f:	e8 95 d1 ff ff       	call   801429 <_panic>
  804294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804297:	8b 00                	mov    (%eax),%eax
  804299:	85 c0                	test   %eax,%eax
  80429b:	74 10                	je     8042ad <insert_sorted_with_merge_freeList+0x3b5>
  80429d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042a0:	8b 00                	mov    (%eax),%eax
  8042a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042a5:	8b 52 04             	mov    0x4(%edx),%edx
  8042a8:	89 50 04             	mov    %edx,0x4(%eax)
  8042ab:	eb 0b                	jmp    8042b8 <insert_sorted_with_merge_freeList+0x3c0>
  8042ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042b0:	8b 40 04             	mov    0x4(%eax),%eax
  8042b3:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8042b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042bb:	8b 40 04             	mov    0x4(%eax),%eax
  8042be:	85 c0                	test   %eax,%eax
  8042c0:	74 0f                	je     8042d1 <insert_sorted_with_merge_freeList+0x3d9>
  8042c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042c5:	8b 40 04             	mov    0x4(%eax),%eax
  8042c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042cb:	8b 12                	mov    (%edx),%edx
  8042cd:	89 10                	mov    %edx,(%eax)
  8042cf:	eb 0a                	jmp    8042db <insert_sorted_with_merge_freeList+0x3e3>
  8042d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042d4:	8b 00                	mov    (%eax),%eax
  8042d6:	a3 38 61 80 00       	mov    %eax,0x806138
  8042db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042ee:	a1 44 61 80 00       	mov    0x806144,%eax
  8042f3:	48                   	dec    %eax
  8042f4:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  8042f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  804303:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804306:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80430d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804311:	75 17                	jne    80432a <insert_sorted_with_merge_freeList+0x432>
  804313:	83 ec 04             	sub    $0x4,%esp
  804316:	68 74 54 80 00       	push   $0x805474
  80431b:	68 5f 01 00 00       	push   $0x15f
  804320:	68 97 54 80 00       	push   $0x805497
  804325:	e8 ff d0 ff ff       	call   801429 <_panic>
  80432a:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804330:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804333:	89 10                	mov    %edx,(%eax)
  804335:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804338:	8b 00                	mov    (%eax),%eax
  80433a:	85 c0                	test   %eax,%eax
  80433c:	74 0d                	je     80434b <insert_sorted_with_merge_freeList+0x453>
  80433e:	a1 48 61 80 00       	mov    0x806148,%eax
  804343:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804346:	89 50 04             	mov    %edx,0x4(%eax)
  804349:	eb 08                	jmp    804353 <insert_sorted_with_merge_freeList+0x45b>
  80434b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80434e:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804353:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804356:	a3 48 61 80 00       	mov    %eax,0x806148
  80435b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80435e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804365:	a1 54 61 80 00       	mov    0x806154,%eax
  80436a:	40                   	inc    %eax
  80436b:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  804370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804373:	8b 50 0c             	mov    0xc(%eax),%edx
  804376:	8b 45 08             	mov    0x8(%ebp),%eax
  804379:	8b 40 0c             	mov    0xc(%eax),%eax
  80437c:	01 c2                	add    %eax,%edx
  80437e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804381:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  804384:	8b 45 08             	mov    0x8(%ebp),%eax
  804387:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80438e:	8b 45 08             	mov    0x8(%ebp),%eax
  804391:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  804398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80439c:	75 17                	jne    8043b5 <insert_sorted_with_merge_freeList+0x4bd>
  80439e:	83 ec 04             	sub    $0x4,%esp
  8043a1:	68 74 54 80 00       	push   $0x805474
  8043a6:	68 64 01 00 00       	push   $0x164
  8043ab:	68 97 54 80 00       	push   $0x805497
  8043b0:	e8 74 d0 ff ff       	call   801429 <_panic>
  8043b5:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8043bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8043be:	89 10                	mov    %edx,(%eax)
  8043c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8043c3:	8b 00                	mov    (%eax),%eax
  8043c5:	85 c0                	test   %eax,%eax
  8043c7:	74 0d                	je     8043d6 <insert_sorted_with_merge_freeList+0x4de>
  8043c9:	a1 48 61 80 00       	mov    0x806148,%eax
  8043ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8043d1:	89 50 04             	mov    %edx,0x4(%eax)
  8043d4:	eb 08                	jmp    8043de <insert_sorted_with_merge_freeList+0x4e6>
  8043d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8043d9:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8043de:	8b 45 08             	mov    0x8(%ebp),%eax
  8043e1:	a3 48 61 80 00       	mov    %eax,0x806148
  8043e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8043e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043f0:	a1 54 61 80 00       	mov    0x806154,%eax
  8043f5:	40                   	inc    %eax
  8043f6:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  8043fb:	e9 41 02 00 00       	jmp    804641 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804400:	8b 45 08             	mov    0x8(%ebp),%eax
  804403:	8b 50 08             	mov    0x8(%eax),%edx
  804406:	8b 45 08             	mov    0x8(%ebp),%eax
  804409:	8b 40 0c             	mov    0xc(%eax),%eax
  80440c:	01 c2                	add    %eax,%edx
  80440e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804411:	8b 40 08             	mov    0x8(%eax),%eax
  804414:	39 c2                	cmp    %eax,%edx
  804416:	0f 85 7c 01 00 00    	jne    804598 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80441c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804420:	74 06                	je     804428 <insert_sorted_with_merge_freeList+0x530>
  804422:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804426:	75 17                	jne    80443f <insert_sorted_with_merge_freeList+0x547>
  804428:	83 ec 04             	sub    $0x4,%esp
  80442b:	68 b0 54 80 00       	push   $0x8054b0
  804430:	68 69 01 00 00       	push   $0x169
  804435:	68 97 54 80 00       	push   $0x805497
  80443a:	e8 ea cf ff ff       	call   801429 <_panic>
  80443f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804442:	8b 50 04             	mov    0x4(%eax),%edx
  804445:	8b 45 08             	mov    0x8(%ebp),%eax
  804448:	89 50 04             	mov    %edx,0x4(%eax)
  80444b:	8b 45 08             	mov    0x8(%ebp),%eax
  80444e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804451:	89 10                	mov    %edx,(%eax)
  804453:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804456:	8b 40 04             	mov    0x4(%eax),%eax
  804459:	85 c0                	test   %eax,%eax
  80445b:	74 0d                	je     80446a <insert_sorted_with_merge_freeList+0x572>
  80445d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804460:	8b 40 04             	mov    0x4(%eax),%eax
  804463:	8b 55 08             	mov    0x8(%ebp),%edx
  804466:	89 10                	mov    %edx,(%eax)
  804468:	eb 08                	jmp    804472 <insert_sorted_with_merge_freeList+0x57a>
  80446a:	8b 45 08             	mov    0x8(%ebp),%eax
  80446d:	a3 38 61 80 00       	mov    %eax,0x806138
  804472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804475:	8b 55 08             	mov    0x8(%ebp),%edx
  804478:	89 50 04             	mov    %edx,0x4(%eax)
  80447b:	a1 44 61 80 00       	mov    0x806144,%eax
  804480:	40                   	inc    %eax
  804481:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  804486:	8b 45 08             	mov    0x8(%ebp),%eax
  804489:	8b 50 0c             	mov    0xc(%eax),%edx
  80448c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80448f:	8b 40 0c             	mov    0xc(%eax),%eax
  804492:	01 c2                	add    %eax,%edx
  804494:	8b 45 08             	mov    0x8(%ebp),%eax
  804497:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80449a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80449e:	75 17                	jne    8044b7 <insert_sorted_with_merge_freeList+0x5bf>
  8044a0:	83 ec 04             	sub    $0x4,%esp
  8044a3:	68 40 55 80 00       	push   $0x805540
  8044a8:	68 6b 01 00 00       	push   $0x16b
  8044ad:	68 97 54 80 00       	push   $0x805497
  8044b2:	e8 72 cf ff ff       	call   801429 <_panic>
  8044b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044ba:	8b 00                	mov    (%eax),%eax
  8044bc:	85 c0                	test   %eax,%eax
  8044be:	74 10                	je     8044d0 <insert_sorted_with_merge_freeList+0x5d8>
  8044c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044c3:	8b 00                	mov    (%eax),%eax
  8044c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8044c8:	8b 52 04             	mov    0x4(%edx),%edx
  8044cb:	89 50 04             	mov    %edx,0x4(%eax)
  8044ce:	eb 0b                	jmp    8044db <insert_sorted_with_merge_freeList+0x5e3>
  8044d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044d3:	8b 40 04             	mov    0x4(%eax),%eax
  8044d6:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8044db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044de:	8b 40 04             	mov    0x4(%eax),%eax
  8044e1:	85 c0                	test   %eax,%eax
  8044e3:	74 0f                	je     8044f4 <insert_sorted_with_merge_freeList+0x5fc>
  8044e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044e8:	8b 40 04             	mov    0x4(%eax),%eax
  8044eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8044ee:	8b 12                	mov    (%edx),%edx
  8044f0:	89 10                	mov    %edx,(%eax)
  8044f2:	eb 0a                	jmp    8044fe <insert_sorted_with_merge_freeList+0x606>
  8044f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044f7:	8b 00                	mov    (%eax),%eax
  8044f9:	a3 38 61 80 00       	mov    %eax,0x806138
  8044fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804507:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80450a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804511:	a1 44 61 80 00       	mov    0x806144,%eax
  804516:	48                   	dec    %eax
  804517:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  80451c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80451f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  804526:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804529:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  804530:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804534:	75 17                	jne    80454d <insert_sorted_with_merge_freeList+0x655>
  804536:	83 ec 04             	sub    $0x4,%esp
  804539:	68 74 54 80 00       	push   $0x805474
  80453e:	68 6e 01 00 00       	push   $0x16e
  804543:	68 97 54 80 00       	push   $0x805497
  804548:	e8 dc ce ff ff       	call   801429 <_panic>
  80454d:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804553:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804556:	89 10                	mov    %edx,(%eax)
  804558:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80455b:	8b 00                	mov    (%eax),%eax
  80455d:	85 c0                	test   %eax,%eax
  80455f:	74 0d                	je     80456e <insert_sorted_with_merge_freeList+0x676>
  804561:	a1 48 61 80 00       	mov    0x806148,%eax
  804566:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804569:	89 50 04             	mov    %edx,0x4(%eax)
  80456c:	eb 08                	jmp    804576 <insert_sorted_with_merge_freeList+0x67e>
  80456e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804571:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804576:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804579:	a3 48 61 80 00       	mov    %eax,0x806148
  80457e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804581:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804588:	a1 54 61 80 00       	mov    0x806154,%eax
  80458d:	40                   	inc    %eax
  80458e:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  804593:	e9 a9 00 00 00       	jmp    804641 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  804598:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80459c:	74 06                	je     8045a4 <insert_sorted_with_merge_freeList+0x6ac>
  80459e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8045a2:	75 17                	jne    8045bb <insert_sorted_with_merge_freeList+0x6c3>
  8045a4:	83 ec 04             	sub    $0x4,%esp
  8045a7:	68 0c 55 80 00       	push   $0x80550c
  8045ac:	68 73 01 00 00       	push   $0x173
  8045b1:	68 97 54 80 00       	push   $0x805497
  8045b6:	e8 6e ce ff ff       	call   801429 <_panic>
  8045bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045be:	8b 10                	mov    (%eax),%edx
  8045c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8045c3:	89 10                	mov    %edx,(%eax)
  8045c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8045c8:	8b 00                	mov    (%eax),%eax
  8045ca:	85 c0                	test   %eax,%eax
  8045cc:	74 0b                	je     8045d9 <insert_sorted_with_merge_freeList+0x6e1>
  8045ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045d1:	8b 00                	mov    (%eax),%eax
  8045d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8045d6:	89 50 04             	mov    %edx,0x4(%eax)
  8045d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8045df:	89 10                	mov    %edx,(%eax)
  8045e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8045e7:	89 50 04             	mov    %edx,0x4(%eax)
  8045ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8045ed:	8b 00                	mov    (%eax),%eax
  8045ef:	85 c0                	test   %eax,%eax
  8045f1:	75 08                	jne    8045fb <insert_sorted_with_merge_freeList+0x703>
  8045f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8045f6:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8045fb:	a1 44 61 80 00       	mov    0x806144,%eax
  804600:	40                   	inc    %eax
  804601:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  804606:	eb 39                	jmp    804641 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  804608:	a1 40 61 80 00       	mov    0x806140,%eax
  80460d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804610:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804614:	74 07                	je     80461d <insert_sorted_with_merge_freeList+0x725>
  804616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804619:	8b 00                	mov    (%eax),%eax
  80461b:	eb 05                	jmp    804622 <insert_sorted_with_merge_freeList+0x72a>
  80461d:	b8 00 00 00 00       	mov    $0x0,%eax
  804622:	a3 40 61 80 00       	mov    %eax,0x806140
  804627:	a1 40 61 80 00       	mov    0x806140,%eax
  80462c:	85 c0                	test   %eax,%eax
  80462e:	0f 85 c7 fb ff ff    	jne    8041fb <insert_sorted_with_merge_freeList+0x303>
  804634:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804638:	0f 85 bd fb ff ff    	jne    8041fb <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80463e:	eb 01                	jmp    804641 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  804640:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804641:	90                   	nop
  804642:	c9                   	leave  
  804643:	c3                   	ret    

00804644 <__udivdi3>:
  804644:	55                   	push   %ebp
  804645:	57                   	push   %edi
  804646:	56                   	push   %esi
  804647:	53                   	push   %ebx
  804648:	83 ec 1c             	sub    $0x1c,%esp
  80464b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80464f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804653:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804657:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80465b:	89 ca                	mov    %ecx,%edx
  80465d:	89 f8                	mov    %edi,%eax
  80465f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804663:	85 f6                	test   %esi,%esi
  804665:	75 2d                	jne    804694 <__udivdi3+0x50>
  804667:	39 cf                	cmp    %ecx,%edi
  804669:	77 65                	ja     8046d0 <__udivdi3+0x8c>
  80466b:	89 fd                	mov    %edi,%ebp
  80466d:	85 ff                	test   %edi,%edi
  80466f:	75 0b                	jne    80467c <__udivdi3+0x38>
  804671:	b8 01 00 00 00       	mov    $0x1,%eax
  804676:	31 d2                	xor    %edx,%edx
  804678:	f7 f7                	div    %edi
  80467a:	89 c5                	mov    %eax,%ebp
  80467c:	31 d2                	xor    %edx,%edx
  80467e:	89 c8                	mov    %ecx,%eax
  804680:	f7 f5                	div    %ebp
  804682:	89 c1                	mov    %eax,%ecx
  804684:	89 d8                	mov    %ebx,%eax
  804686:	f7 f5                	div    %ebp
  804688:	89 cf                	mov    %ecx,%edi
  80468a:	89 fa                	mov    %edi,%edx
  80468c:	83 c4 1c             	add    $0x1c,%esp
  80468f:	5b                   	pop    %ebx
  804690:	5e                   	pop    %esi
  804691:	5f                   	pop    %edi
  804692:	5d                   	pop    %ebp
  804693:	c3                   	ret    
  804694:	39 ce                	cmp    %ecx,%esi
  804696:	77 28                	ja     8046c0 <__udivdi3+0x7c>
  804698:	0f bd fe             	bsr    %esi,%edi
  80469b:	83 f7 1f             	xor    $0x1f,%edi
  80469e:	75 40                	jne    8046e0 <__udivdi3+0x9c>
  8046a0:	39 ce                	cmp    %ecx,%esi
  8046a2:	72 0a                	jb     8046ae <__udivdi3+0x6a>
  8046a4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8046a8:	0f 87 9e 00 00 00    	ja     80474c <__udivdi3+0x108>
  8046ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8046b3:	89 fa                	mov    %edi,%edx
  8046b5:	83 c4 1c             	add    $0x1c,%esp
  8046b8:	5b                   	pop    %ebx
  8046b9:	5e                   	pop    %esi
  8046ba:	5f                   	pop    %edi
  8046bb:	5d                   	pop    %ebp
  8046bc:	c3                   	ret    
  8046bd:	8d 76 00             	lea    0x0(%esi),%esi
  8046c0:	31 ff                	xor    %edi,%edi
  8046c2:	31 c0                	xor    %eax,%eax
  8046c4:	89 fa                	mov    %edi,%edx
  8046c6:	83 c4 1c             	add    $0x1c,%esp
  8046c9:	5b                   	pop    %ebx
  8046ca:	5e                   	pop    %esi
  8046cb:	5f                   	pop    %edi
  8046cc:	5d                   	pop    %ebp
  8046cd:	c3                   	ret    
  8046ce:	66 90                	xchg   %ax,%ax
  8046d0:	89 d8                	mov    %ebx,%eax
  8046d2:	f7 f7                	div    %edi
  8046d4:	31 ff                	xor    %edi,%edi
  8046d6:	89 fa                	mov    %edi,%edx
  8046d8:	83 c4 1c             	add    $0x1c,%esp
  8046db:	5b                   	pop    %ebx
  8046dc:	5e                   	pop    %esi
  8046dd:	5f                   	pop    %edi
  8046de:	5d                   	pop    %ebp
  8046df:	c3                   	ret    
  8046e0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8046e5:	89 eb                	mov    %ebp,%ebx
  8046e7:	29 fb                	sub    %edi,%ebx
  8046e9:	89 f9                	mov    %edi,%ecx
  8046eb:	d3 e6                	shl    %cl,%esi
  8046ed:	89 c5                	mov    %eax,%ebp
  8046ef:	88 d9                	mov    %bl,%cl
  8046f1:	d3 ed                	shr    %cl,%ebp
  8046f3:	89 e9                	mov    %ebp,%ecx
  8046f5:	09 f1                	or     %esi,%ecx
  8046f7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8046fb:	89 f9                	mov    %edi,%ecx
  8046fd:	d3 e0                	shl    %cl,%eax
  8046ff:	89 c5                	mov    %eax,%ebp
  804701:	89 d6                	mov    %edx,%esi
  804703:	88 d9                	mov    %bl,%cl
  804705:	d3 ee                	shr    %cl,%esi
  804707:	89 f9                	mov    %edi,%ecx
  804709:	d3 e2                	shl    %cl,%edx
  80470b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80470f:	88 d9                	mov    %bl,%cl
  804711:	d3 e8                	shr    %cl,%eax
  804713:	09 c2                	or     %eax,%edx
  804715:	89 d0                	mov    %edx,%eax
  804717:	89 f2                	mov    %esi,%edx
  804719:	f7 74 24 0c          	divl   0xc(%esp)
  80471d:	89 d6                	mov    %edx,%esi
  80471f:	89 c3                	mov    %eax,%ebx
  804721:	f7 e5                	mul    %ebp
  804723:	39 d6                	cmp    %edx,%esi
  804725:	72 19                	jb     804740 <__udivdi3+0xfc>
  804727:	74 0b                	je     804734 <__udivdi3+0xf0>
  804729:	89 d8                	mov    %ebx,%eax
  80472b:	31 ff                	xor    %edi,%edi
  80472d:	e9 58 ff ff ff       	jmp    80468a <__udivdi3+0x46>
  804732:	66 90                	xchg   %ax,%ax
  804734:	8b 54 24 08          	mov    0x8(%esp),%edx
  804738:	89 f9                	mov    %edi,%ecx
  80473a:	d3 e2                	shl    %cl,%edx
  80473c:	39 c2                	cmp    %eax,%edx
  80473e:	73 e9                	jae    804729 <__udivdi3+0xe5>
  804740:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804743:	31 ff                	xor    %edi,%edi
  804745:	e9 40 ff ff ff       	jmp    80468a <__udivdi3+0x46>
  80474a:	66 90                	xchg   %ax,%ax
  80474c:	31 c0                	xor    %eax,%eax
  80474e:	e9 37 ff ff ff       	jmp    80468a <__udivdi3+0x46>
  804753:	90                   	nop

00804754 <__umoddi3>:
  804754:	55                   	push   %ebp
  804755:	57                   	push   %edi
  804756:	56                   	push   %esi
  804757:	53                   	push   %ebx
  804758:	83 ec 1c             	sub    $0x1c,%esp
  80475b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80475f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804763:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804767:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80476b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80476f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804773:	89 f3                	mov    %esi,%ebx
  804775:	89 fa                	mov    %edi,%edx
  804777:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80477b:	89 34 24             	mov    %esi,(%esp)
  80477e:	85 c0                	test   %eax,%eax
  804780:	75 1a                	jne    80479c <__umoddi3+0x48>
  804782:	39 f7                	cmp    %esi,%edi
  804784:	0f 86 a2 00 00 00    	jbe    80482c <__umoddi3+0xd8>
  80478a:	89 c8                	mov    %ecx,%eax
  80478c:	89 f2                	mov    %esi,%edx
  80478e:	f7 f7                	div    %edi
  804790:	89 d0                	mov    %edx,%eax
  804792:	31 d2                	xor    %edx,%edx
  804794:	83 c4 1c             	add    $0x1c,%esp
  804797:	5b                   	pop    %ebx
  804798:	5e                   	pop    %esi
  804799:	5f                   	pop    %edi
  80479a:	5d                   	pop    %ebp
  80479b:	c3                   	ret    
  80479c:	39 f0                	cmp    %esi,%eax
  80479e:	0f 87 ac 00 00 00    	ja     804850 <__umoddi3+0xfc>
  8047a4:	0f bd e8             	bsr    %eax,%ebp
  8047a7:	83 f5 1f             	xor    $0x1f,%ebp
  8047aa:	0f 84 ac 00 00 00    	je     80485c <__umoddi3+0x108>
  8047b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8047b5:	29 ef                	sub    %ebp,%edi
  8047b7:	89 fe                	mov    %edi,%esi
  8047b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8047bd:	89 e9                	mov    %ebp,%ecx
  8047bf:	d3 e0                	shl    %cl,%eax
  8047c1:	89 d7                	mov    %edx,%edi
  8047c3:	89 f1                	mov    %esi,%ecx
  8047c5:	d3 ef                	shr    %cl,%edi
  8047c7:	09 c7                	or     %eax,%edi
  8047c9:	89 e9                	mov    %ebp,%ecx
  8047cb:	d3 e2                	shl    %cl,%edx
  8047cd:	89 14 24             	mov    %edx,(%esp)
  8047d0:	89 d8                	mov    %ebx,%eax
  8047d2:	d3 e0                	shl    %cl,%eax
  8047d4:	89 c2                	mov    %eax,%edx
  8047d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047da:	d3 e0                	shl    %cl,%eax
  8047dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8047e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047e4:	89 f1                	mov    %esi,%ecx
  8047e6:	d3 e8                	shr    %cl,%eax
  8047e8:	09 d0                	or     %edx,%eax
  8047ea:	d3 eb                	shr    %cl,%ebx
  8047ec:	89 da                	mov    %ebx,%edx
  8047ee:	f7 f7                	div    %edi
  8047f0:	89 d3                	mov    %edx,%ebx
  8047f2:	f7 24 24             	mull   (%esp)
  8047f5:	89 c6                	mov    %eax,%esi
  8047f7:	89 d1                	mov    %edx,%ecx
  8047f9:	39 d3                	cmp    %edx,%ebx
  8047fb:	0f 82 87 00 00 00    	jb     804888 <__umoddi3+0x134>
  804801:	0f 84 91 00 00 00    	je     804898 <__umoddi3+0x144>
  804807:	8b 54 24 04          	mov    0x4(%esp),%edx
  80480b:	29 f2                	sub    %esi,%edx
  80480d:	19 cb                	sbb    %ecx,%ebx
  80480f:	89 d8                	mov    %ebx,%eax
  804811:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804815:	d3 e0                	shl    %cl,%eax
  804817:	89 e9                	mov    %ebp,%ecx
  804819:	d3 ea                	shr    %cl,%edx
  80481b:	09 d0                	or     %edx,%eax
  80481d:	89 e9                	mov    %ebp,%ecx
  80481f:	d3 eb                	shr    %cl,%ebx
  804821:	89 da                	mov    %ebx,%edx
  804823:	83 c4 1c             	add    $0x1c,%esp
  804826:	5b                   	pop    %ebx
  804827:	5e                   	pop    %esi
  804828:	5f                   	pop    %edi
  804829:	5d                   	pop    %ebp
  80482a:	c3                   	ret    
  80482b:	90                   	nop
  80482c:	89 fd                	mov    %edi,%ebp
  80482e:	85 ff                	test   %edi,%edi
  804830:	75 0b                	jne    80483d <__umoddi3+0xe9>
  804832:	b8 01 00 00 00       	mov    $0x1,%eax
  804837:	31 d2                	xor    %edx,%edx
  804839:	f7 f7                	div    %edi
  80483b:	89 c5                	mov    %eax,%ebp
  80483d:	89 f0                	mov    %esi,%eax
  80483f:	31 d2                	xor    %edx,%edx
  804841:	f7 f5                	div    %ebp
  804843:	89 c8                	mov    %ecx,%eax
  804845:	f7 f5                	div    %ebp
  804847:	89 d0                	mov    %edx,%eax
  804849:	e9 44 ff ff ff       	jmp    804792 <__umoddi3+0x3e>
  80484e:	66 90                	xchg   %ax,%ax
  804850:	89 c8                	mov    %ecx,%eax
  804852:	89 f2                	mov    %esi,%edx
  804854:	83 c4 1c             	add    $0x1c,%esp
  804857:	5b                   	pop    %ebx
  804858:	5e                   	pop    %esi
  804859:	5f                   	pop    %edi
  80485a:	5d                   	pop    %ebp
  80485b:	c3                   	ret    
  80485c:	3b 04 24             	cmp    (%esp),%eax
  80485f:	72 06                	jb     804867 <__umoddi3+0x113>
  804861:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804865:	77 0f                	ja     804876 <__umoddi3+0x122>
  804867:	89 f2                	mov    %esi,%edx
  804869:	29 f9                	sub    %edi,%ecx
  80486b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80486f:	89 14 24             	mov    %edx,(%esp)
  804872:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804876:	8b 44 24 04          	mov    0x4(%esp),%eax
  80487a:	8b 14 24             	mov    (%esp),%edx
  80487d:	83 c4 1c             	add    $0x1c,%esp
  804880:	5b                   	pop    %ebx
  804881:	5e                   	pop    %esi
  804882:	5f                   	pop    %edi
  804883:	5d                   	pop    %ebp
  804884:	c3                   	ret    
  804885:	8d 76 00             	lea    0x0(%esi),%esi
  804888:	2b 04 24             	sub    (%esp),%eax
  80488b:	19 fa                	sbb    %edi,%edx
  80488d:	89 d1                	mov    %edx,%ecx
  80488f:	89 c6                	mov    %eax,%esi
  804891:	e9 71 ff ff ff       	jmp    804807 <__umoddi3+0xb3>
  804896:	66 90                	xchg   %ax,%ax
  804898:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80489c:	72 ea                	jb     804888 <__umoddi3+0x134>
  80489e:	89 d9                	mov    %ebx,%ecx
  8048a0:	e9 62 ff ff ff       	jmp    804807 <__umoddi3+0xb3>
