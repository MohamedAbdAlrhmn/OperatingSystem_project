
obj/user/tst_realloc_3:     file format elf32-i386


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
  800031:	e8 29 06 00 00       	call   80065f <libmain>
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
  80003d:	83 ec 40             	sub    $0x40,%esp
	int Mega = 1024*1024;
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[5] = {0};
  80004e:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800051:	b9 05 00 00 00       	mov    $0x5,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 20 3a 80 00       	push   $0x803a20
  800067:	e8 e3 09 00 00       	call   800a4f <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 83 1b 00 00       	call   801bf7 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 1b 1c 00 00       	call   801c97 <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(100*kilo - kilo);
  80007f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800082:	89 d0                	mov    %edx,%eax
  800084:	01 c0                	add    %eax,%eax
  800086:	01 d0                	add    %edx,%eax
  800088:	89 c2                	mov    %eax,%edx
  80008a:	c1 e2 05             	shl    $0x5,%edx
  80008d:	01 d0                	add    %edx,%eax
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	e8 3f 19 00 00       	call   8019d7 <malloc>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000a1:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a6:	74 14                	je     8000bc <_main+0x84>
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 44 3a 80 00       	push   $0x803a44
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 74 3a 80 00       	push   $0x803a74
  8000b7:	e8 df 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 33 1b 00 00       	call   801bf7 <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 8c 3a 80 00       	push   $0x803a8c
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 74 3a 80 00       	push   $0x803a74
  8000dc:	e8 ba 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 b1 1b 00 00       	call   801c97 <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 f8 3a 80 00       	push   $0x803af8
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 74 3a 80 00       	push   $0x803a74
  8000fd:	e8 99 06 00 00       	call   80079b <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 f0 1a 00 00       	call   801bf7 <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 88 1b 00 00       	call   801c97 <sys_pf_calculate_allocated_pages>
  80010f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(20*kilo-kilo);
  800112:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800115:	89 d0                	mov    %edx,%eax
  800117:	c1 e0 03             	shl    $0x3,%eax
  80011a:	01 d0                	add    %edx,%eax
  80011c:	01 c0                	add    %eax,%eax
  80011e:	01 d0                	add    %edx,%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 ae 18 00 00       	call   8019d7 <malloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 100 * kilo)) panic("Wrong start address for the allocated space... ");
  80012f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800132:	89 c1                	mov    %eax,%ecx
  800134:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800137:	89 d0                	mov    %edx,%eax
  800139:	c1 e0 02             	shl    $0x2,%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800145:	01 d0                	add    %edx,%eax
  800147:	c1 e0 02             	shl    $0x2,%eax
  80014a:	05 00 00 00 80       	add    $0x80000000,%eax
  80014f:	39 c1                	cmp    %eax,%ecx
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 44 3a 80 00       	push   $0x803a44
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 74 3a 80 00       	push   $0x803a74
  800162:	e8 34 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 8b 1a 00 00       	call   801bf7 <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 8c 3a 80 00       	push   $0x803a8c
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 74 3a 80 00       	push   $0x803a74
  800184:	e8 12 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 09 1b 00 00       	call   801c97 <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 f8 3a 80 00       	push   $0x803af8
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 74 3a 80 00       	push   $0x803a74
  8001a5:	e8 f1 05 00 00       	call   80079b <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 48 1a 00 00       	call   801bf7 <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 e0 1a 00 00       	call   801c97 <sys_pf_calculate_allocated_pages>
  8001b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(30 * kilo -kilo);
  8001ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001bd:	89 d0                	mov    %edx,%eax
  8001bf:	01 c0                	add    %eax,%eax
  8001c1:	01 d0                	add    %edx,%eax
  8001c3:	01 c0                	add    %eax,%eax
  8001c5:	01 d0                	add    %edx,%eax
  8001c7:	c1 e0 02             	shl    $0x2,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	e8 02 18 00 00       	call   8019d7 <malloc>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 120 * kilo)) panic("Wrong start address for the allocated space... ");
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	89 c1                	mov    %eax,%ecx
  8001e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	05 00 00 00 80       	add    $0x80000000,%eax
  8001fa:	39 c1                	cmp    %eax,%ecx
  8001fc:	74 14                	je     800212 <_main+0x1da>
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	68 44 3a 80 00       	push   $0x803a44
  800206:	6a 23                	push   $0x23
  800208:	68 74 3a 80 00       	push   $0x803a74
  80020d:	e8 89 05 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 e0 19 00 00       	call   801bf7 <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 8c 3a 80 00       	push   $0x803a8c
  800228:	6a 25                	push   $0x25
  80022a:	68 74 3a 80 00       	push   $0x803a74
  80022f:	e8 67 05 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 5e 1a 00 00       	call   801c97 <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 f8 3a 80 00       	push   $0x803af8
  800249:	6a 26                	push   $0x26
  80024b:	68 74 3a 80 00       	push   $0x803a74
  800250:	e8 46 05 00 00       	call   80079b <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 9d 19 00 00       	call   801bf7 <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 35 1a 00 00       	call   801c97 <sys_pf_calculate_allocated_pages>
  800262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(40 * kilo -kilo);
  800265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800268:	89 d0                	mov    %edx,%eax
  80026a:	c1 e0 03             	shl    $0x3,%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	01 c0                	add    %eax,%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	50                   	push   %eax
  80027b:	e8 57 17 00 00       	call   8019d7 <malloc>
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 152 * kilo)) panic("Wrong start address for the allocated space... ");
  800286:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800289:	89 c1                	mov    %eax,%ecx
  80028b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80028e:	89 d0                	mov    %edx,%eax
  800290:	c1 e0 03             	shl    $0x3,%eax
  800293:	01 d0                	add    %edx,%eax
  800295:	01 c0                	add    %eax,%eax
  800297:	01 d0                	add    %edx,%eax
  800299:	c1 e0 03             	shl    $0x3,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c1                	cmp    %eax,%ecx
  8002a3:	74 14                	je     8002b9 <_main+0x281>
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	68 44 3a 80 00       	push   $0x803a44
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 74 3a 80 00       	push   $0x803a74
  8002b4:	e8 e2 04 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 39 19 00 00       	call   801bf7 <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 8c 3a 80 00       	push   $0x803a8c
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 74 3a 80 00       	push   $0x803a74
  8002d6:	e8 c0 04 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 b7 19 00 00       	call   801c97 <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 f8 3a 80 00       	push   $0x803af8
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 74 3a 80 00       	push   $0x803a74
  8002f7:	e8 9f 04 00 00       	call   80079b <_panic>


	}


	int cnt = 0;
  8002fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	//[2] Test Re-allocation
	{
		/*Reallocate the first array (100 KB) to the last hole*/

		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
  800303:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800306:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  800309:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80030c:	89 d0                	mov    %edx,%eax
  80030e:	c1 e0 02             	shl    $0x2,%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031a:	01 d0                	add    %edx,%eax
  80031c:	c1 e0 02             	shl    $0x2,%eax
  80031f:	c1 e8 02             	shr    $0x2,%eax
  800322:	48                   	dec    %eax
  800323:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int i = 0;
  800326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for (i=0; i < lastIndexOfInt1 ; i++)
  80032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800334:	eb 17                	jmp    80034d <_main+0x315>
		{
			intArr[i] = i ;
  800336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800340:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800343:	01 c2                	add    %eax,%edx
  800345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800348:	89 02                	mov    %eax,(%edx)
		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i < lastIndexOfInt1 ; i++)
  80034a:	ff 45 f4             	incl   -0xc(%ebp)
  80034d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800350:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800353:	7c e1                	jl     800336 <_main+0x2fe>
		{
			intArr[i] = i ;
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  800355:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800358:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  80035b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80035e:	89 d0                	mov    %edx,%eax
  800360:	c1 e0 02             	shl    $0x2,%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	c1 e0 02             	shl    $0x2,%eax
  800368:	c1 e8 02             	shr    $0x2,%eax
  80036b:	48                   	dec    %eax
  80036c:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  80036f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800376:	eb 17                	jmp    80038f <_main+0x357>
		{
			intArr[i] = i ;
  800378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800385:	01 c2                	add    %eax,%edx
  800387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038a:	89 02                	mov    %eax,(%edx)

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80038c:	ff 45 f4             	incl   -0xc(%ebp)
  80038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800392:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800395:	7c e1                	jl     800378 <_main+0x340>
		{
			intArr[i] = i ;
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800397:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80039a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80039d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003a0:	89 d0                	mov    %edx,%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ad:	01 d0                	add    %edx,%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	c1 e8 02             	shr    $0x2,%eax
  8003b4:	48                   	dec    %eax
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003bf:	eb 17                	jmp    8003d8 <_main+0x3a0>
		{
			intArr[i] = i ;
  8003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003d5:	ff 45 f4             	incl   -0xc(%ebp)
  8003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003db:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003de:	7c e1                	jl     8003c1 <_main+0x389>
		{
			intArr[i] = i ;
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8003e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8003e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	c1 e0 02             	shl    $0x2,%eax
  8003ee:	01 d0                	add    %edx,%eax
  8003f0:	c1 e0 03             	shl    $0x3,%eax
  8003f3:	c1 e8 02             	shr    $0x2,%eax
  8003f6:	48                   	dec    %eax
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800401:	eb 17                	jmp    80041a <_main+0x3e2>
		{
			intArr[i] = i ;
  800403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800410:	01 c2                	add    %eax,%edx
  800412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800415:	89 02                	mov    %eax,(%edx)

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800417:	ff 45 f4             	incl   -0xc(%ebp)
  80041a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800420:	7c e1                	jl     800403 <_main+0x3cb>
			intArr[i] = i ;
		}


		//Reallocate the first array to 200 KB [should be moved to after the fourth one]
		freeFrames = sys_calculate_free_frames() ;
  800422:	e8 d0 17 00 00       	call   801bf7 <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 68 18 00 00       	call   801c97 <sys_pf_calculate_allocated_pages>
  80042f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 200 * kilo - kilo);
  800432:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800435:	89 d0                	mov    %edx,%eax
  800437:	01 c0                	add    %eax,%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	89 c1                	mov    %eax,%ecx
  80043d:	c1 e1 05             	shl    $0x5,%ecx
  800440:	01 c8                	add    %ecx,%eax
  800442:	01 c0                	add    %eax,%eax
  800444:	01 d0                	add    %edx,%eax
  800446:	89 c2                	mov    %eax,%edx
  800448:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	52                   	push   %edx
  80044f:	50                   	push   %eax
  800450:	e8 20 16 00 00       	call   801a75 <realloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 192 * kilo)) panic("Wrong start address for the re-allocated space... ");
  80045b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	c1 e0 06             	shl    $0x6,%eax
  80046c:	05 00 00 00 80       	add    $0x80000000,%eax
  800471:	39 c1                	cmp    %eax,%ecx
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 28 3b 80 00       	push   $0x803b28
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 74 3a 80 00       	push   $0x803a74
  800484:	e8 12 03 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 09 18 00 00       	call   801c97 <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 5c 3b 80 00       	push   $0x803b5c
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 74 3a 80 00       	push   $0x803a74
  8004a5:	e8 f1 02 00 00       	call   80079b <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 8d 3b 80 00       	push   $0x803b8d
  8004b4:	e8 2b 05 00 00       	call   8009e4 <vcprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
  8004bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  8004c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004c5:	89 d0                	mov    %edx,%eax
  8004c7:	c1 e0 02             	shl    $0x2,%eax
  8004ca:	01 d0                	add    %edx,%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 02             	shl    $0x2,%eax
  8004d8:	c1 e8 02             	shr    $0x2,%eax
  8004db:	48                   	dec    %eax
  8004dc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8004df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e6:	eb 2d                	jmp    800515 <_main+0x4dd>
		{
			if(intArr[i] != i)
  8004e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f5:	01 d0                	add    %edx,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004fc:	74 14                	je     800512 <_main+0x4da>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 94 3b 80 00       	push   $0x803b94
  800506:	6a 7a                	push   $0x7a
  800508:	68 74 3a 80 00       	push   $0x803a74
  80050d:	e8 89 02 00 00       	call   80079b <_panic>

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800512:	ff 45 f4             	incl   -0xc(%ebp)
  800515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800518:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80051b:	7c cb                	jl     8004e8 <_main+0x4b0>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  80051d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800520:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  800523:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 02             	shl    $0x2,%eax
  800530:	c1 e8 02             	shr    $0x2,%eax
  800533:	48                   	dec    %eax
  800534:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800537:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80053e:	eb 30                	jmp    800570 <_main+0x538>
		{
			if(intArr[i] != i)
  800540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800543:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054d:	01 d0                	add    %edx,%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800554:	74 17                	je     80056d <_main+0x535>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 94 3b 80 00       	push   $0x803b94
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 74 3a 80 00       	push   $0x803a74
  800568:	e8 2e 02 00 00       	call   80079b <_panic>

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80056d:	ff 45 f4             	incl   -0xc(%ebp)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800576:	7c c8                	jl     800540 <_main+0x508>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800578:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80057e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800581:	89 d0                	mov    %edx,%eax
  800583:	01 c0                	add    %eax,%eax
  800585:	01 d0                	add    %edx,%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	01 d0                	add    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	c1 e8 02             	shr    $0x2,%eax
  800595:	48                   	dec    %eax
  800596:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005a0:	eb 30                	jmp    8005d2 <_main+0x59a>
		{
			if(intArr[i] != i)
  8005a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005b6:	74 17                	je     8005cf <_main+0x597>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 94 3b 80 00       	push   $0x803b94
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 74 3a 80 00       	push   $0x803a74
  8005ca:	e8 cc 01 00 00       	call   80079b <_panic>

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005cf:	ff 45 f4             	incl   -0xc(%ebp)
  8005d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8005d8:	7c c8                	jl     8005a2 <_main+0x56a>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8005da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8005e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	c1 e0 03             	shl    $0x3,%eax
  8005ed:	c1 e8 02             	shr    $0x2,%eax
  8005f0:	48                   	dec    %eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005fb:	eb 30                	jmp    80062d <_main+0x5f5>
		{
			if(intArr[i] != i)
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800611:	74 17                	je     80062a <_main+0x5f2>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	68 94 3b 80 00       	push   $0x803b94
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 74 3a 80 00       	push   $0x803a74
  800625:	e8 71 01 00 00       	call   80079b <_panic>

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80062a:	ff 45 f4             	incl   -0xc(%ebp)
  80062d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800630:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800633:	7c c8                	jl     8005fd <_main+0x5c5>
				panic("Wrong re-allocation: stored values are wrongly changed!");

		}


		vcprintf("\b\b\b100%\n", NULL);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	6a 00                	push   $0x0
  80063a:	68 cc 3b 80 00       	push   $0x803bcc
  80063f:	e8 a0 03 00 00       	call   8009e4 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 d8 3b 80 00       	push   $0x803bd8
  80064f:	e8 fb 03 00 00       	call   800a4f <cprintf>
  800654:	83 c4 10             	add    $0x10,%esp

	return;
  800657:	90                   	nop
}
  800658:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80065b:	5b                   	pop    %ebx
  80065c:	5f                   	pop    %edi
  80065d:	5d                   	pop    %ebp
  80065e:	c3                   	ret    

0080065f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800665:	e8 6d 18 00 00       	call   801ed7 <sys_getenvindex>
  80066a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80066d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	c1 e0 03             	shl    $0x3,%eax
  800675:	01 d0                	add    %edx,%eax
  800677:	01 c0                	add    %eax,%eax
  800679:	01 d0                	add    %edx,%eax
  80067b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800682:	01 d0                	add    %edx,%eax
  800684:	c1 e0 04             	shl    $0x4,%eax
  800687:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80068c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800691:	a1 20 50 80 00       	mov    0x805020,%eax
  800696:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80069c:	84 c0                	test   %al,%al
  80069e:	74 0f                	je     8006af <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a5:	05 5c 05 00 00       	add    $0x55c,%eax
  8006aa:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006b3:	7e 0a                	jle    8006bf <libmain+0x60>
		binaryname = argv[0];
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	ff 75 08             	pushl  0x8(%ebp)
  8006c8:	e8 6b f9 ff ff       	call   800038 <_main>
  8006cd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006d0:	e8 0f 16 00 00       	call   801ce4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	68 2c 3c 80 00       	push   $0x803c2c
  8006dd:	e8 6d 03 00 00       	call   800a4f <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ea:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	52                   	push   %edx
  8006ff:	50                   	push   %eax
  800700:	68 54 3c 80 00       	push   $0x803c54
  800705:	e8 45 03 00 00       	call   800a4f <cprintf>
  80070a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80070d:	a1 20 50 80 00       	mov    0x805020,%eax
  800712:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800718:	a1 20 50 80 00       	mov    0x805020,%eax
  80071d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800723:	a1 20 50 80 00       	mov    0x805020,%eax
  800728:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	68 7c 3c 80 00       	push   $0x803c7c
  800736:	e8 14 03 00 00       	call   800a4f <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073e:	a1 20 50 80 00       	mov    0x805020,%eax
  800743:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	50                   	push   %eax
  80074d:	68 d4 3c 80 00       	push   $0x803cd4
  800752:	e8 f8 02 00 00       	call   800a4f <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	68 2c 3c 80 00       	push   $0x803c2c
  800762:	e8 e8 02 00 00       	call   800a4f <cprintf>
  800767:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80076a:	e8 8f 15 00 00       	call   801cfe <sys_enable_interrupt>

	// exit gracefully
	exit();
  80076f:	e8 19 00 00 00       	call   80078d <exit>
}
  800774:	90                   	nop
  800775:	c9                   	leave  
  800776:	c3                   	ret    

00800777 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80077d:	83 ec 0c             	sub    $0xc,%esp
  800780:	6a 00                	push   $0x0
  800782:	e8 1c 17 00 00       	call   801ea3 <sys_destroy_env>
  800787:	83 c4 10             	add    $0x10,%esp
}
  80078a:	90                   	nop
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <exit>:

void
exit(void)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800793:	e8 71 17 00 00       	call   801f09 <sys_exit_env>
}
  800798:	90                   	nop
  800799:	c9                   	leave  
  80079a:	c3                   	ret    

0080079b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8007a4:	83 c0 04             	add    $0x4,%eax
  8007a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007aa:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	74 16                	je     8007c9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007b3:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	50                   	push   %eax
  8007bc:	68 e8 3c 80 00       	push   $0x803ce8
  8007c1:	e8 89 02 00 00       	call   800a4f <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c9:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	68 ed 3c 80 00       	push   $0x803ced
  8007da:	e8 70 02 00 00       	call   800a4f <cprintf>
  8007df:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007eb:	50                   	push   %eax
  8007ec:	e8 f3 01 00 00       	call   8009e4 <vcprintf>
  8007f1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	6a 00                	push   $0x0
  8007f9:	68 09 3d 80 00       	push   $0x803d09
  8007fe:	e8 e1 01 00 00       	call   8009e4 <vcprintf>
  800803:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800806:	e8 82 ff ff ff       	call   80078d <exit>

	// should not return here
	while (1) ;
  80080b:	eb fe                	jmp    80080b <_panic+0x70>

0080080d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 14                	je     800836 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 0c 3d 80 00       	push   $0x803d0c
  80082a:	6a 26                	push   $0x26
  80082c:	68 58 3d 80 00       	push   $0x803d58
  800831:	e8 65 ff ff ff       	call   80079b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80083d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800844:	e9 c2 00 00 00       	jmp    80090b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 d0                	add    %edx,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	85 c0                	test   %eax,%eax
  80085c:	75 08                	jne    800866 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80085e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800861:	e9 a2 00 00 00       	jmp    800908 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800866:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800874:	eb 69                	jmp    8008df <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800876:	a1 20 50 80 00       	mov    0x805020,%eax
  80087b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800881:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800884:	89 d0                	mov    %edx,%eax
  800886:	01 c0                	add    %eax,%eax
  800888:	01 d0                	add    %edx,%eax
  80088a:	c1 e0 03             	shl    $0x3,%eax
  80088d:	01 c8                	add    %ecx,%eax
  80088f:	8a 40 04             	mov    0x4(%eax),%al
  800892:	84 c0                	test   %al,%al
  800894:	75 46                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800896:	a1 20 50 80 00       	mov    0x805020,%eax
  80089b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a4:	89 d0                	mov    %edx,%eax
  8008a6:	01 c0                	add    %eax,%eax
  8008a8:	01 d0                	add    %edx,%eax
  8008aa:	c1 e0 03             	shl    $0x3,%eax
  8008ad:	01 c8                	add    %ecx,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	01 c8                	add    %ecx,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	75 09                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008da:	eb 12                	jmp    8008ee <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	ff 45 e8             	incl   -0x18(%ebp)
  8008df:	a1 20 50 80 00       	mov    0x805020,%eax
  8008e4:	8b 50 74             	mov    0x74(%eax),%edx
  8008e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008ea:	39 c2                	cmp    %eax,%edx
  8008ec:	77 88                	ja     800876 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008f2:	75 14                	jne    800908 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 64 3d 80 00       	push   $0x803d64
  8008fc:	6a 3a                	push   $0x3a
  8008fe:	68 58 3d 80 00       	push   $0x803d58
  800903:	e8 93 fe ff ff       	call   80079b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800908:	ff 45 f0             	incl   -0x10(%ebp)
  80090b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800911:	0f 8c 32 ff ff ff    	jl     800849 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800917:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800925:	eb 26                	jmp    80094d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800927:	a1 20 50 80 00       	mov    0x805020,%eax
  80092c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800932:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800935:	89 d0                	mov    %edx,%eax
  800937:	01 c0                	add    %eax,%eax
  800939:	01 d0                	add    %edx,%eax
  80093b:	c1 e0 03             	shl    $0x3,%eax
  80093e:	01 c8                	add    %ecx,%eax
  800940:	8a 40 04             	mov    0x4(%eax),%al
  800943:	3c 01                	cmp    $0x1,%al
  800945:	75 03                	jne    80094a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800947:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80094a:	ff 45 e0             	incl   -0x20(%ebp)
  80094d:	a1 20 50 80 00       	mov    0x805020,%eax
  800952:	8b 50 74             	mov    0x74(%eax),%edx
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	39 c2                	cmp    %eax,%edx
  80095a:	77 cb                	ja     800927 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800962:	74 14                	je     800978 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800964:	83 ec 04             	sub    $0x4,%esp
  800967:	68 b8 3d 80 00       	push   $0x803db8
  80096c:	6a 44                	push   $0x44
  80096e:	68 58 3d 80 00       	push   $0x803d58
  800973:	e8 23 fe ff ff       	call   80079b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800978:	90                   	nop
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	8d 48 01             	lea    0x1(%eax),%ecx
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	89 0a                	mov    %ecx,(%edx)
  80098e:	8b 55 08             	mov    0x8(%ebp),%edx
  800991:	88 d1                	mov    %dl,%cl
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a4:	75 2c                	jne    8009d2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009a6:	a0 24 50 80 00       	mov    0x805024,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b1:	8b 12                	mov    (%edx),%edx
  8009b3:	89 d1                	mov    %edx,%ecx
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	83 c2 08             	add    $0x8,%edx
  8009bb:	83 ec 04             	sub    $0x4,%esp
  8009be:	50                   	push   %eax
  8009bf:	51                   	push   %ecx
  8009c0:	52                   	push   %edx
  8009c1:	e8 70 11 00 00       	call   801b36 <sys_cputs>
  8009c6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	8b 40 04             	mov    0x4(%eax),%eax
  8009d8:	8d 50 01             	lea    0x1(%eax),%edx
  8009db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009de:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009e1:	90                   	nop
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    

008009e4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009f4:	00 00 00 
	b.cnt = 0;
  8009f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009fe:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a0d:	50                   	push   %eax
  800a0e:	68 7b 09 80 00       	push   $0x80097b
  800a13:	e8 11 02 00 00       	call   800c29 <vprintfmt>
  800a18:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a1b:	a0 24 50 80 00       	mov    0x805024,%al
  800a20:	0f b6 c0             	movzbl %al,%eax
  800a23:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	50                   	push   %eax
  800a2d:	52                   	push   %edx
  800a2e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a34:	83 c0 08             	add    $0x8,%eax
  800a37:	50                   	push   %eax
  800a38:	e8 f9 10 00 00       	call   801b36 <sys_cputs>
  800a3d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a40:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a47:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <cprintf>:

int cprintf(const char *fmt, ...) {
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a55:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a5c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6b:	50                   	push   %eax
  800a6c:	e8 73 ff ff ff       	call   8009e4 <vcprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a82:	e8 5d 12 00 00       	call   801ce4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a87:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 f4             	pushl  -0xc(%ebp)
  800a96:	50                   	push   %eax
  800a97:	e8 48 ff ff ff       	call   8009e4 <vcprintf>
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800aa2:	e8 57 12 00 00       	call   801cfe <sys_enable_interrupt>
	return cnt;
  800aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	53                   	push   %ebx
  800ab0:	83 ec 14             	sub    $0x14,%esp
  800ab3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800abf:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aca:	77 55                	ja     800b21 <printnum+0x75>
  800acc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800acf:	72 05                	jb     800ad6 <printnum+0x2a>
  800ad1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ad4:	77 4b                	ja     800b21 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ad6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ad9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800adc:	8b 45 18             	mov    0x18(%ebp),%eax
  800adf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae4:	52                   	push   %edx
  800ae5:	50                   	push   %eax
  800ae6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae9:	ff 75 f0             	pushl  -0x10(%ebp)
  800aec:	e8 cb 2c 00 00       	call   8037bc <__udivdi3>
  800af1:	83 c4 10             	add    $0x10,%esp
  800af4:	83 ec 04             	sub    $0x4,%esp
  800af7:	ff 75 20             	pushl  0x20(%ebp)
  800afa:	53                   	push   %ebx
  800afb:	ff 75 18             	pushl  0x18(%ebp)
  800afe:	52                   	push   %edx
  800aff:	50                   	push   %eax
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	ff 75 08             	pushl  0x8(%ebp)
  800b06:	e8 a1 ff ff ff       	call   800aac <printnum>
  800b0b:	83 c4 20             	add    $0x20,%esp
  800b0e:	eb 1a                	jmp    800b2a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	ff 75 20             	pushl  0x20(%ebp)
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	ff d0                	call   *%eax
  800b1e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b21:	ff 4d 1c             	decl   0x1c(%ebp)
  800b24:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b28:	7f e6                	jg     800b10 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b2a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b38:	53                   	push   %ebx
  800b39:	51                   	push   %ecx
  800b3a:	52                   	push   %edx
  800b3b:	50                   	push   %eax
  800b3c:	e8 8b 2d 00 00       	call   8038cc <__umoddi3>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	05 34 40 80 00       	add    $0x804034,%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f be c0             	movsbl %al,%eax
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	50                   	push   %eax
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
}
  800b5d:	90                   	nop
  800b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b66:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b6a:	7e 1c                	jle    800b88 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	8d 50 08             	lea    0x8(%eax),%edx
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	89 10                	mov    %edx,(%eax)
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	83 e8 08             	sub    $0x8,%eax
  800b81:	8b 50 04             	mov    0x4(%eax),%edx
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	eb 40                	jmp    800bc8 <getuint+0x65>
	else if (lflag)
  800b88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8c:	74 1e                	je     800bac <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 00                	mov    (%eax),%eax
  800b93:	8d 50 04             	lea    0x4(%eax),%edx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	89 10                	mov    %edx,(%eax)
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	83 e8 04             	sub    $0x4,%eax
  800ba3:	8b 00                	mov    (%eax),%eax
  800ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  800baa:	eb 1c                	jmp    800bc8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	8d 50 04             	lea    0x4(%eax),%edx
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 10                	mov    %edx,(%eax)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	83 e8 04             	sub    $0x4,%eax
  800bc1:	8b 00                	mov    (%eax),%eax
  800bc3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bcd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bd1:	7e 1c                	jle    800bef <getint+0x25>
		return va_arg(*ap, long long);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 00                	mov    (%eax),%eax
  800bd8:	8d 50 08             	lea    0x8(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	89 10                	mov    %edx,(%eax)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	83 e8 08             	sub    $0x8,%eax
  800be8:	8b 50 04             	mov    0x4(%eax),%edx
  800beb:	8b 00                	mov    (%eax),%eax
  800bed:	eb 38                	jmp    800c27 <getint+0x5d>
	else if (lflag)
  800bef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf3:	74 1a                	je     800c0f <getint+0x45>
		return va_arg(*ap, long);
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	8d 50 04             	lea    0x4(%eax),%edx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	89 10                	mov    %edx,(%eax)
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	83 e8 04             	sub    $0x4,%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	99                   	cltd   
  800c0d:	eb 18                	jmp    800c27 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	8d 50 04             	lea    0x4(%eax),%edx
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 10                	mov    %edx,(%eax)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8b 00                	mov    (%eax),%eax
  800c21:	83 e8 04             	sub    $0x4,%eax
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	99                   	cltd   
}
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
  800c2e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c31:	eb 17                	jmp    800c4a <vprintfmt+0x21>
			if (ch == '\0')
  800c33:	85 db                	test   %ebx,%ebx
  800c35:	0f 84 af 03 00 00    	je     800fea <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	53                   	push   %ebx
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 10             	mov    %edx,0x10(%ebp)
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f b6 d8             	movzbl %al,%ebx
  800c58:	83 fb 25             	cmp    $0x25,%ebx
  800c5b:	75 d6                	jne    800c33 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c5d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c61:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c68:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c6f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c76:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c80:	8d 50 01             	lea    0x1(%eax),%edx
  800c83:	89 55 10             	mov    %edx,0x10(%ebp)
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 d8             	movzbl %al,%ebx
  800c8b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c8e:	83 f8 55             	cmp    $0x55,%eax
  800c91:	0f 87 2b 03 00 00    	ja     800fc2 <vprintfmt+0x399>
  800c97:	8b 04 85 58 40 80 00 	mov    0x804058(,%eax,4),%eax
  800c9e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ca4:	eb d7                	jmp    800c7d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800caa:	eb d1                	jmp    800c7d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cb6:	89 d0                	mov    %edx,%eax
  800cb8:	c1 e0 02             	shl    $0x2,%eax
  800cbb:	01 d0                	add    %edx,%eax
  800cbd:	01 c0                	add    %eax,%eax
  800cbf:	01 d8                	add    %ebx,%eax
  800cc1:	83 e8 30             	sub    $0x30,%eax
  800cc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ccf:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd2:	7e 3e                	jle    800d12 <vprintfmt+0xe9>
  800cd4:	83 fb 39             	cmp    $0x39,%ebx
  800cd7:	7f 39                	jg     800d12 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cdc:	eb d5                	jmp    800cb3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	83 c0 04             	add    $0x4,%eax
  800ce4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 e8 04             	sub    $0x4,%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cf2:	eb 1f                	jmp    800d13 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf8:	79 83                	jns    800c7d <vprintfmt+0x54>
				width = 0;
  800cfa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d01:	e9 77 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d06:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d0d:	e9 6b ff ff ff       	jmp    800c7d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d12:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d17:	0f 89 60 ff ff ff    	jns    800c7d <vprintfmt+0x54>
				width = precision, precision = -1;
  800d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d23:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d2a:	e9 4e ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d2f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d32:	e9 46 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	83 c0 04             	add    $0x4,%eax
  800d3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	50                   	push   %eax
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			break;
  800d57:	e9 89 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5f:	83 c0 04             	add    $0x4,%eax
  800d62:	89 45 14             	mov    %eax,0x14(%ebp)
  800d65:	8b 45 14             	mov    0x14(%ebp),%eax
  800d68:	83 e8 04             	sub    $0x4,%eax
  800d6b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d6d:	85 db                	test   %ebx,%ebx
  800d6f:	79 02                	jns    800d73 <vprintfmt+0x14a>
				err = -err;
  800d71:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d73:	83 fb 64             	cmp    $0x64,%ebx
  800d76:	7f 0b                	jg     800d83 <vprintfmt+0x15a>
  800d78:	8b 34 9d a0 3e 80 00 	mov    0x803ea0(,%ebx,4),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 19                	jne    800d9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d83:	53                   	push   %ebx
  800d84:	68 45 40 80 00       	push   $0x804045
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	ff 75 08             	pushl  0x8(%ebp)
  800d8f:	e8 5e 02 00 00       	call   800ff2 <printfmt>
  800d94:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d97:	e9 49 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d9c:	56                   	push   %esi
  800d9d:	68 4e 40 80 00       	push   $0x80404e
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	ff 75 08             	pushl  0x8(%ebp)
  800da8:	e8 45 02 00 00       	call   800ff2 <printfmt>
  800dad:	83 c4 10             	add    $0x10,%esp
			break;
  800db0:	e9 30 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800db5:	8b 45 14             	mov    0x14(%ebp),%eax
  800db8:	83 c0 04             	add    $0x4,%eax
  800dbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	83 e8 04             	sub    $0x4,%eax
  800dc4:	8b 30                	mov    (%eax),%esi
  800dc6:	85 f6                	test   %esi,%esi
  800dc8:	75 05                	jne    800dcf <vprintfmt+0x1a6>
				p = "(null)";
  800dca:	be 51 40 80 00       	mov    $0x804051,%esi
			if (width > 0 && padc != '-')
  800dcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd3:	7e 6d                	jle    800e42 <vprintfmt+0x219>
  800dd5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dd9:	74 67                	je     800e42 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ddb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dde:	83 ec 08             	sub    $0x8,%esp
  800de1:	50                   	push   %eax
  800de2:	56                   	push   %esi
  800de3:	e8 0c 03 00 00       	call   8010f4 <strnlen>
  800de8:	83 c4 10             	add    $0x10,%esp
  800deb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dee:	eb 16                	jmp    800e06 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800df0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800df4:	83 ec 08             	sub    $0x8,%esp
  800df7:	ff 75 0c             	pushl  0xc(%ebp)
  800dfa:	50                   	push   %eax
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	ff d0                	call   *%eax
  800e00:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e03:	ff 4d e4             	decl   -0x1c(%ebp)
  800e06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0a:	7f e4                	jg     800df0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0c:	eb 34                	jmp    800e42 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e12:	74 1c                	je     800e30 <vprintfmt+0x207>
  800e14:	83 fb 1f             	cmp    $0x1f,%ebx
  800e17:	7e 05                	jle    800e1e <vprintfmt+0x1f5>
  800e19:	83 fb 7e             	cmp    $0x7e,%ebx
  800e1c:	7e 12                	jle    800e30 <vprintfmt+0x207>
					putch('?', putdat);
  800e1e:	83 ec 08             	sub    $0x8,%esp
  800e21:	ff 75 0c             	pushl  0xc(%ebp)
  800e24:	6a 3f                	push   $0x3f
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	ff d0                	call   *%eax
  800e2b:	83 c4 10             	add    $0x10,%esp
  800e2e:	eb 0f                	jmp    800e3f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	53                   	push   %ebx
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	ff d0                	call   *%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e42:	89 f0                	mov    %esi,%eax
  800e44:	8d 70 01             	lea    0x1(%eax),%esi
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	0f be d8             	movsbl %al,%ebx
  800e4c:	85 db                	test   %ebx,%ebx
  800e4e:	74 24                	je     800e74 <vprintfmt+0x24b>
  800e50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e54:	78 b8                	js     800e0e <vprintfmt+0x1e5>
  800e56:	ff 4d e0             	decl   -0x20(%ebp)
  800e59:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e5d:	79 af                	jns    800e0e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5f:	eb 13                	jmp    800e74 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	ff 75 0c             	pushl  0xc(%ebp)
  800e67:	6a 20                	push   $0x20
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	ff d0                	call   *%eax
  800e6e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e71:	ff 4d e4             	decl   -0x1c(%ebp)
  800e74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e78:	7f e7                	jg     800e61 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e7a:	e9 66 01 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 e8             	pushl  -0x18(%ebp)
  800e85:	8d 45 14             	lea    0x14(%ebp),%eax
  800e88:	50                   	push   %eax
  800e89:	e8 3c fd ff ff       	call   800bca <getint>
  800e8e:	83 c4 10             	add    $0x10,%esp
  800e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9d:	85 d2                	test   %edx,%edx
  800e9f:	79 23                	jns    800ec4 <vprintfmt+0x29b>
				putch('-', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	6a 2d                	push   $0x2d
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb7:	f7 d8                	neg    %eax
  800eb9:	83 d2 00             	adc    $0x0,%edx
  800ebc:	f7 da                	neg    %edx
  800ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ec4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ecb:	e9 bc 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed9:	50                   	push   %eax
  800eda:	e8 84 fc ff ff       	call   800b63 <getuint>
  800edf:	83 c4 10             	add    $0x10,%esp
  800ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ee8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eef:	e9 98 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	ff 75 0c             	pushl  0xc(%ebp)
  800efa:	6a 58                	push   $0x58
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	ff d0                	call   *%eax
  800f01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f04:	83 ec 08             	sub    $0x8,%esp
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	6a 58                	push   $0x58
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	ff d0                	call   *%eax
  800f11:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	ff 75 0c             	pushl  0xc(%ebp)
  800f1a:	6a 58                	push   $0x58
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	ff d0                	call   *%eax
  800f21:	83 c4 10             	add    $0x10,%esp
			break;
  800f24:	e9 bc 00 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	6a 30                	push   $0x30
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	ff d0                	call   *%eax
  800f36:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	6a 78                	push   $0x78
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff d0                	call   *%eax
  800f46:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f49:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4c:	83 c0 04             	add    $0x4,%eax
  800f4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f52:	8b 45 14             	mov    0x14(%ebp),%eax
  800f55:	83 e8 04             	sub    $0x4,%eax
  800f58:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f64:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f6b:	eb 1f                	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 e8             	pushl  -0x18(%ebp)
  800f73:	8d 45 14             	lea    0x14(%ebp),%eax
  800f76:	50                   	push   %eax
  800f77:	e8 e7 fb ff ff       	call   800b63 <getuint>
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f8c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f93:	83 ec 04             	sub    $0x4,%esp
  800f96:	52                   	push   %edx
  800f97:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f9a:	50                   	push   %eax
  800f9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9e:	ff 75 f0             	pushl  -0x10(%ebp)
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	ff 75 08             	pushl  0x8(%ebp)
  800fa7:	e8 00 fb ff ff       	call   800aac <printnum>
  800fac:	83 c4 20             	add    $0x20,%esp
			break;
  800faf:	eb 34                	jmp    800fe5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	53                   	push   %ebx
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	ff d0                	call   *%eax
  800fbd:	83 c4 10             	add    $0x10,%esp
			break;
  800fc0:	eb 23                	jmp    800fe5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fc2:	83 ec 08             	sub    $0x8,%esp
  800fc5:	ff 75 0c             	pushl  0xc(%ebp)
  800fc8:	6a 25                	push   $0x25
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	ff d0                	call   *%eax
  800fcf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fd2:	ff 4d 10             	decl   0x10(%ebp)
  800fd5:	eb 03                	jmp    800fda <vprintfmt+0x3b1>
  800fd7:	ff 4d 10             	decl   0x10(%ebp)
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	48                   	dec    %eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	3c 25                	cmp    $0x25,%al
  800fe2:	75 f3                	jne    800fd7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fe4:	90                   	nop
		}
	}
  800fe5:	e9 47 fc ff ff       	jmp    800c31 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fea:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800feb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    

00800ff2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ff8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801001:	8b 45 10             	mov    0x10(%ebp),%eax
  801004:	ff 75 f4             	pushl  -0xc(%ebp)
  801007:	50                   	push   %eax
  801008:	ff 75 0c             	pushl  0xc(%ebp)
  80100b:	ff 75 08             	pushl  0x8(%ebp)
  80100e:	e8 16 fc ff ff       	call   800c29 <vprintfmt>
  801013:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801016:	90                   	nop
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	8b 40 08             	mov    0x8(%eax),%eax
  801022:	8d 50 01             	lea    0x1(%eax),%edx
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	8b 10                	mov    (%eax),%edx
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 40 04             	mov    0x4(%eax),%eax
  801036:	39 c2                	cmp    %eax,%edx
  801038:	73 12                	jae    80104c <sprintputch+0x33>
		*b->buf++ = ch;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	8b 00                	mov    (%eax),%eax
  80103f:	8d 48 01             	lea    0x1(%eax),%ecx
  801042:	8b 55 0c             	mov    0xc(%ebp),%edx
  801045:	89 0a                	mov    %ecx,(%edx)
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	88 10                	mov    %dl,(%eax)
}
  80104c:	90                   	nop
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	01 d0                	add    %edx,%eax
  801066:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801070:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801074:	74 06                	je     80107c <vsnprintf+0x2d>
  801076:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107a:	7f 07                	jg     801083 <vsnprintf+0x34>
		return -E_INVAL;
  80107c:	b8 03 00 00 00       	mov    $0x3,%eax
  801081:	eb 20                	jmp    8010a3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801083:	ff 75 14             	pushl  0x14(%ebp)
  801086:	ff 75 10             	pushl  0x10(%ebp)
  801089:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80108c:	50                   	push   %eax
  80108d:	68 19 10 80 00       	push   $0x801019
  801092:	e8 92 fb ff ff       	call   800c29 <vprintfmt>
  801097:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80109a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80109d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ae:	83 c0 04             	add    $0x4,%eax
  8010b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ba:	50                   	push   %eax
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	ff 75 08             	pushl  0x8(%ebp)
  8010c1:	e8 89 ff ff ff       	call   80104f <vsnprintf>
  8010c6:	83 c4 10             	add    $0x10,%esp
  8010c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010de:	eb 06                	jmp    8010e6 <strlen+0x15>
		n++;
  8010e0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e3:	ff 45 08             	incl   0x8(%ebp)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	84 c0                	test   %al,%al
  8010ed:	75 f1                	jne    8010e0 <strlen+0xf>
		n++;
	return n;
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801101:	eb 09                	jmp    80110c <strnlen+0x18>
		n++;
  801103:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801106:	ff 45 08             	incl   0x8(%ebp)
  801109:	ff 4d 0c             	decl   0xc(%ebp)
  80110c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801110:	74 09                	je     80111b <strnlen+0x27>
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	84 c0                	test   %al,%al
  801119:	75 e8                	jne    801103 <strnlen+0xf>
		n++;
	return n;
  80111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80112c:	90                   	nop
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8d 50 01             	lea    0x1(%eax),%edx
  801133:	89 55 08             	mov    %edx,0x8(%ebp)
  801136:	8b 55 0c             	mov    0xc(%ebp),%edx
  801139:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80113f:	8a 12                	mov    (%edx),%dl
  801141:	88 10                	mov    %dl,(%eax)
  801143:	8a 00                	mov    (%eax),%al
  801145:	84 c0                	test   %al,%al
  801147:	75 e4                	jne    80112d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80115a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801161:	eb 1f                	jmp    801182 <strncpy+0x34>
		*dst++ = *src;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8d 50 01             	lea    0x1(%eax),%edx
  801169:	89 55 08             	mov    %edx,0x8(%ebp)
  80116c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116f:	8a 12                	mov    (%edx),%dl
  801171:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	84 c0                	test   %al,%al
  80117a:	74 03                	je     80117f <strncpy+0x31>
			src++;
  80117c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80117f:	ff 45 fc             	incl   -0x4(%ebp)
  801182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801185:	3b 45 10             	cmp    0x10(%ebp),%eax
  801188:	72 d9                	jb     801163 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80118a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80119b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119f:	74 30                	je     8011d1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011a1:	eb 16                	jmp    8011b9 <strlcpy+0x2a>
			*dst++ = *src++;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8d 50 01             	lea    0x1(%eax),%edx
  8011a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011b5:	8a 12                	mov    (%edx),%dl
  8011b7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b9:	ff 4d 10             	decl   0x10(%ebp)
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 09                	je     8011cb <strlcpy+0x3c>
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	84 c0                	test   %al,%al
  8011c9:	75 d8                	jne    8011a3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d7:	29 c2                	sub    %eax,%edx
  8011d9:	89 d0                	mov    %edx,%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011e0:	eb 06                	jmp    8011e8 <strcmp+0xb>
		p++, q++;
  8011e2:	ff 45 08             	incl   0x8(%ebp)
  8011e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	84 c0                	test   %al,%al
  8011ef:	74 0e                	je     8011ff <strcmp+0x22>
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 10                	mov    (%eax),%dl
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	38 c2                	cmp    %al,%dl
  8011fd:	74 e3                	je     8011e2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f b6 d0             	movzbl %al,%edx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	0f b6 c0             	movzbl %al,%eax
  80120f:	29 c2                	sub    %eax,%edx
  801211:	89 d0                	mov    %edx,%eax
}
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801218:	eb 09                	jmp    801223 <strncmp+0xe>
		n--, p++, q++;
  80121a:	ff 4d 10             	decl   0x10(%ebp)
  80121d:	ff 45 08             	incl   0x8(%ebp)
  801220:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801223:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801227:	74 17                	je     801240 <strncmp+0x2b>
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	84 c0                	test   %al,%al
  801230:	74 0e                	je     801240 <strncmp+0x2b>
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	8a 10                	mov    (%eax),%dl
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	38 c2                	cmp    %al,%dl
  80123e:	74 da                	je     80121a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	75 07                	jne    80124d <strncmp+0x38>
		return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 14                	jmp    801261 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	0f b6 d0             	movzbl %al,%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f b6 c0             	movzbl %al,%eax
  80125d:	29 c2                	sub    %eax,%edx
  80125f:	89 d0                	mov    %edx,%eax
}
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80126f:	eb 12                	jmp    801283 <strchr+0x20>
		if (*s == c)
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801279:	75 05                	jne    801280 <strchr+0x1d>
			return (char *) s;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	eb 11                	jmp    801291 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801280:	ff 45 08             	incl   0x8(%ebp)
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e5                	jne    801271 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 04             	sub    $0x4,%esp
  801299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80129f:	eb 0d                	jmp    8012ae <strfind+0x1b>
		if (*s == c)
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012a9:	74 0e                	je     8012b9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012ab:	ff 45 08             	incl   0x8(%ebp)
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	84 c0                	test   %al,%al
  8012b5:	75 ea                	jne    8012a1 <strfind+0xe>
  8012b7:	eb 01                	jmp    8012ba <strfind+0x27>
		if (*s == c)
			break;
  8012b9:	90                   	nop
	return (char *) s;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012d1:	eb 0e                	jmp    8012e1 <memset+0x22>
		*p++ = c;
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8d 50 01             	lea    0x1(%eax),%edx
  8012d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012df:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012e1:	ff 4d f8             	decl   -0x8(%ebp)
  8012e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012e8:	79 e9                	jns    8012d3 <memset+0x14>
		*p++ = c;

	return v;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801301:	eb 16                	jmp    801319 <memcpy+0x2a>
		*d++ = *s++;
  801303:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801306:	8d 50 01             	lea    0x1(%eax),%edx
  801309:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801312:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801315:	8a 12                	mov    (%edx),%dl
  801317:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 dd                	jne    801303 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80133d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801340:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801343:	73 50                	jae    801395 <memmove+0x6a>
  801345:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801350:	76 43                	jbe    801395 <memmove+0x6a>
		s += n;
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80135e:	eb 10                	jmp    801370 <memmove+0x45>
			*--d = *--s;
  801360:	ff 4d f8             	decl   -0x8(%ebp)
  801363:	ff 4d fc             	decl   -0x4(%ebp)
  801366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801369:	8a 10                	mov    (%eax),%dl
  80136b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801370:	8b 45 10             	mov    0x10(%ebp),%eax
  801373:	8d 50 ff             	lea    -0x1(%eax),%edx
  801376:	89 55 10             	mov    %edx,0x10(%ebp)
  801379:	85 c0                	test   %eax,%eax
  80137b:	75 e3                	jne    801360 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80137d:	eb 23                	jmp    8013a2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	8d 50 01             	lea    0x1(%eax),%edx
  801385:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801388:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80138e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801391:	8a 12                	mov    (%edx),%dl
  801393:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	8d 50 ff             	lea    -0x1(%eax),%edx
  80139b:	89 55 10             	mov    %edx,0x10(%ebp)
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	75 dd                	jne    80137f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013b9:	eb 2a                	jmp    8013e5 <memcmp+0x3e>
		if (*s1 != *s2)
  8013bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013be:	8a 10                	mov    (%eax),%dl
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	38 c2                	cmp    %al,%dl
  8013c7:	74 16                	je     8013df <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	0f b6 d0             	movzbl %al,%edx
  8013d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f b6 c0             	movzbl %al,%eax
  8013d9:	29 c2                	sub    %eax,%edx
  8013db:	89 d0                	mov    %edx,%eax
  8013dd:	eb 18                	jmp    8013f7 <memcmp+0x50>
		s1++, s2++;
  8013df:	ff 45 fc             	incl   -0x4(%ebp)
  8013e2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	75 c9                	jne    8013bb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80140a:	eb 15                	jmp    801421 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f b6 d0             	movzbl %al,%edx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	39 c2                	cmp    %eax,%edx
  80141c:	74 0d                	je     80142b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80141e:	ff 45 08             	incl   0x8(%ebp)
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801427:	72 e3                	jb     80140c <memfind+0x13>
  801429:	eb 01                	jmp    80142c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80142b:	90                   	nop
	return (void *) s;
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80143e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801445:	eb 03                	jmp    80144a <strtol+0x19>
		s++;
  801447:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 20                	cmp    $0x20,%al
  801451:	74 f4                	je     801447 <strtol+0x16>
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 09                	cmp    $0x9,%al
  80145a:	74 eb                	je     801447 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3c 2b                	cmp    $0x2b,%al
  801463:	75 05                	jne    80146a <strtol+0x39>
		s++;
  801465:	ff 45 08             	incl   0x8(%ebp)
  801468:	eb 13                	jmp    80147d <strtol+0x4c>
	else if (*s == '-')
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3c 2d                	cmp    $0x2d,%al
  801471:	75 0a                	jne    80147d <strtol+0x4c>
		s++, neg = 1;
  801473:	ff 45 08             	incl   0x8(%ebp)
  801476:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80147d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801481:	74 06                	je     801489 <strtol+0x58>
  801483:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801487:	75 20                	jne    8014a9 <strtol+0x78>
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 30                	cmp    $0x30,%al
  801490:	75 17                	jne    8014a9 <strtol+0x78>
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	40                   	inc    %eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	3c 78                	cmp    $0x78,%al
  80149a:	75 0d                	jne    8014a9 <strtol+0x78>
		s += 2, base = 16;
  80149c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014a0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014a7:	eb 28                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ad:	75 15                	jne    8014c4 <strtol+0x93>
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	3c 30                	cmp    $0x30,%al
  8014b6:	75 0c                	jne    8014c4 <strtol+0x93>
		s++, base = 8;
  8014b8:	ff 45 08             	incl   0x8(%ebp)
  8014bb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014c2:	eb 0d                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	75 07                	jne    8014d1 <strtol+0xa0>
		base = 10;
  8014ca:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	3c 2f                	cmp    $0x2f,%al
  8014d8:	7e 19                	jle    8014f3 <strtol+0xc2>
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	3c 39                	cmp    $0x39,%al
  8014e1:	7f 10                	jg     8014f3 <strtol+0xc2>
			dig = *s - '0';
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	0f be c0             	movsbl %al,%eax
  8014eb:	83 e8 30             	sub    $0x30,%eax
  8014ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f1:	eb 42                	jmp    801535 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	3c 60                	cmp    $0x60,%al
  8014fa:	7e 19                	jle    801515 <strtol+0xe4>
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	3c 7a                	cmp    $0x7a,%al
  801503:	7f 10                	jg     801515 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	0f be c0             	movsbl %al,%eax
  80150d:	83 e8 57             	sub    $0x57,%eax
  801510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801513:	eb 20                	jmp    801535 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	3c 40                	cmp    $0x40,%al
  80151c:	7e 39                	jle    801557 <strtol+0x126>
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	3c 5a                	cmp    $0x5a,%al
  801525:	7f 30                	jg     801557 <strtol+0x126>
			dig = *s - 'A' + 10;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	0f be c0             	movsbl %al,%eax
  80152f:	83 e8 37             	sub    $0x37,%eax
  801532:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801538:	3b 45 10             	cmp    0x10(%ebp),%eax
  80153b:	7d 19                	jge    801556 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80153d:	ff 45 08             	incl   0x8(%ebp)
  801540:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801543:	0f af 45 10          	imul   0x10(%ebp),%eax
  801547:	89 c2                	mov    %eax,%edx
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154c:	01 d0                	add    %edx,%eax
  80154e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801551:	e9 7b ff ff ff       	jmp    8014d1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801556:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801557:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155b:	74 08                	je     801565 <strtol+0x134>
		*endptr = (char *) s;
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8b 55 08             	mov    0x8(%ebp),%edx
  801563:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801565:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801569:	74 07                	je     801572 <strtol+0x141>
  80156b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156e:	f7 d8                	neg    %eax
  801570:	eb 03                	jmp    801575 <strtol+0x144>
  801572:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <ltostr>:

void
ltostr(long value, char *str)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80157d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801584:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80158b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158f:	79 13                	jns    8015a4 <ltostr+0x2d>
	{
		neg = 1;
  801591:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80159e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015a1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015ac:	99                   	cltd   
  8015ad:	f7 f9                	idiv   %ecx
  8015af:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b5:	8d 50 01             	lea    0x1(%eax),%edx
  8015b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015bb:	89 c2                	mov    %eax,%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c5:	83 c2 30             	add    $0x30,%edx
  8015c8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015d2:	f7 e9                	imul   %ecx
  8015d4:	c1 fa 02             	sar    $0x2,%edx
  8015d7:	89 c8                	mov    %ecx,%eax
  8015d9:	c1 f8 1f             	sar    $0x1f,%eax
  8015dc:	29 c2                	sub    %eax,%edx
  8015de:	89 d0                	mov    %edx,%eax
  8015e0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015eb:	f7 e9                	imul   %ecx
  8015ed:	c1 fa 02             	sar    $0x2,%edx
  8015f0:	89 c8                	mov    %ecx,%eax
  8015f2:	c1 f8 1f             	sar    $0x1f,%eax
  8015f5:	29 c2                	sub    %eax,%edx
  8015f7:	89 d0                	mov    %edx,%eax
  8015f9:	c1 e0 02             	shl    $0x2,%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	01 c0                	add    %eax,%eax
  801600:	29 c1                	sub    %eax,%ecx
  801602:	89 ca                	mov    %ecx,%edx
  801604:	85 d2                	test   %edx,%edx
  801606:	75 9c                	jne    8015a4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801608:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80160f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801612:	48                   	dec    %eax
  801613:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801616:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80161a:	74 3d                	je     801659 <ltostr+0xe2>
		start = 1 ;
  80161c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801623:	eb 34                	jmp    801659 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	01 d0                	add    %edx,%eax
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801635:	8b 45 0c             	mov    0xc(%ebp),%eax
  801638:	01 c2                	add    %eax,%edx
  80163a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	01 c8                	add    %ecx,%eax
  801642:	8a 00                	mov    (%eax),%al
  801644:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801646:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 c2                	add    %eax,%edx
  80164e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801651:	88 02                	mov    %al,(%edx)
		start++ ;
  801653:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801656:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165f:	7c c4                	jl     801625 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801661:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801664:	8b 45 0c             	mov    0xc(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80166c:	90                   	nop
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 54 fa ff ff       	call   8010d1 <strlen>
  80167d:	83 c4 04             	add    $0x4,%esp
  801680:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	e8 46 fa ff ff       	call   8010d1 <strlen>
  80168b:	83 c4 04             	add    $0x4,%esp
  80168e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801691:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801698:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80169f:	eb 17                	jmp    8016b8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a7:	01 c2                	add    %eax,%edx
  8016a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	01 c8                	add    %ecx,%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016b5:	ff 45 fc             	incl   -0x4(%ebp)
  8016b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016be:	7c e1                	jl     8016a1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ce:	eb 1f                	jmp    8016ef <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d3:	8d 50 01             	lea    0x1(%eax),%edx
  8016d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d9:	89 c2                	mov    %eax,%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 c2                	add    %eax,%edx
  8016e0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e6:	01 c8                	add    %ecx,%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016ec:	ff 45 f8             	incl   -0x8(%ebp)
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016f5:	7c d9                	jl     8016d0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fd:	01 d0                	add    %edx,%eax
  8016ff:	c6 00 00             	movb   $0x0,(%eax)
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801708:	8b 45 14             	mov    0x14(%ebp),%eax
  80170b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801711:	8b 45 14             	mov    0x14(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	01 d0                	add    %edx,%eax
  801722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801728:	eb 0c                	jmp    801736 <strsplit+0x31>
			*string++ = 0;
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8d 50 01             	lea    0x1(%eax),%edx
  801730:	89 55 08             	mov    %edx,0x8(%ebp)
  801733:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	84 c0                	test   %al,%al
  80173d:	74 18                	je     801757 <strsplit+0x52>
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	0f be c0             	movsbl %al,%eax
  801747:	50                   	push   %eax
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	e8 13 fb ff ff       	call   801263 <strchr>
  801750:	83 c4 08             	add    $0x8,%esp
  801753:	85 c0                	test   %eax,%eax
  801755:	75 d3                	jne    80172a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 5a                	je     8017ba <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801760:	8b 45 14             	mov    0x14(%ebp),%eax
  801763:	8b 00                	mov    (%eax),%eax
  801765:	83 f8 0f             	cmp    $0xf,%eax
  801768:	75 07                	jne    801771 <strsplit+0x6c>
		{
			return 0;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
  80176f:	eb 66                	jmp    8017d7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801771:	8b 45 14             	mov    0x14(%ebp),%eax
  801774:	8b 00                	mov    (%eax),%eax
  801776:	8d 48 01             	lea    0x1(%eax),%ecx
  801779:	8b 55 14             	mov    0x14(%ebp),%edx
  80177c:	89 0a                	mov    %ecx,(%edx)
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 c2                	add    %eax,%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80178f:	eb 03                	jmp    801794 <strsplit+0x8f>
			string++;
  801791:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	84 c0                	test   %al,%al
  80179b:	74 8b                	je     801728 <strsplit+0x23>
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	0f be c0             	movsbl %al,%eax
  8017a5:	50                   	push   %eax
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	e8 b5 fa ff ff       	call   801263 <strchr>
  8017ae:	83 c4 08             	add    $0x8,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	74 dc                	je     801791 <strsplit+0x8c>
			string++;
	}
  8017b5:	e9 6e ff ff ff       	jmp    801728 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017ba:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017be:	8b 00                	mov    (%eax),%eax
  8017c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8017df:	a1 04 50 80 00       	mov    0x805004,%eax
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	74 1f                	je     801807 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017e8:	e8 1d 00 00 00       	call   80180a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	68 b0 41 80 00       	push   $0x8041b0
  8017f5:	e8 55 f2 ff ff       	call   800a4f <cprintf>
  8017fa:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017fd:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801804:	00 00 00 
	}
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801810:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801817:	00 00 00 
  80181a:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801821:	00 00 00 
  801824:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80182b:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80182e:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801835:	00 00 00 
  801838:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80183f:	00 00 00 
  801842:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801849:	00 00 00 
	uint32 arr_size = 0;
  80184c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801853:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80185a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801862:	2d 00 10 00 00       	sub    $0x1000,%eax
  801867:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80186c:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801873:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801876:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80187d:	a1 20 51 80 00       	mov    0x805120,%eax
  801882:	c1 e0 04             	shl    $0x4,%eax
  801885:	89 c2                	mov    %eax,%edx
  801887:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80188a:	01 d0                	add    %edx,%eax
  80188c:	48                   	dec    %eax
  80188d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801890:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801893:	ba 00 00 00 00       	mov    $0x0,%edx
  801898:	f7 75 ec             	divl   -0x14(%ebp)
  80189b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80189e:	29 d0                	sub    %edx,%eax
  8018a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  8018a3:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8018aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018b2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018b7:	83 ec 04             	sub    $0x4,%esp
  8018ba:	6a 03                	push   $0x3
  8018bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8018bf:	50                   	push   %eax
  8018c0:	e8 b5 03 00 00       	call   801c7a <sys_allocate_chunk>
  8018c5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018c8:	a1 20 51 80 00       	mov    0x805120,%eax
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	50                   	push   %eax
  8018d1:	e8 2a 0a 00 00       	call   802300 <initialize_MemBlocksList>
  8018d6:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8018d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8018de:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8018e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e4:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8018eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ee:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8018f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018f9:	75 14                	jne    80190f <initialize_dyn_block_system+0x105>
  8018fb:	83 ec 04             	sub    $0x4,%esp
  8018fe:	68 d5 41 80 00       	push   $0x8041d5
  801903:	6a 33                	push   $0x33
  801905:	68 f3 41 80 00       	push   $0x8041f3
  80190a:	e8 8c ee ff ff       	call   80079b <_panic>
  80190f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801912:	8b 00                	mov    (%eax),%eax
  801914:	85 c0                	test   %eax,%eax
  801916:	74 10                	je     801928 <initialize_dyn_block_system+0x11e>
  801918:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191b:	8b 00                	mov    (%eax),%eax
  80191d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801920:	8b 52 04             	mov    0x4(%edx),%edx
  801923:	89 50 04             	mov    %edx,0x4(%eax)
  801926:	eb 0b                	jmp    801933 <initialize_dyn_block_system+0x129>
  801928:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80192b:	8b 40 04             	mov    0x4(%eax),%eax
  80192e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801933:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801936:	8b 40 04             	mov    0x4(%eax),%eax
  801939:	85 c0                	test   %eax,%eax
  80193b:	74 0f                	je     80194c <initialize_dyn_block_system+0x142>
  80193d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801940:	8b 40 04             	mov    0x4(%eax),%eax
  801943:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801946:	8b 12                	mov    (%edx),%edx
  801948:	89 10                	mov    %edx,(%eax)
  80194a:	eb 0a                	jmp    801956 <initialize_dyn_block_system+0x14c>
  80194c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80194f:	8b 00                	mov    (%eax),%eax
  801951:	a3 48 51 80 00       	mov    %eax,0x805148
  801956:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801959:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80195f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801962:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801969:	a1 54 51 80 00       	mov    0x805154,%eax
  80196e:	48                   	dec    %eax
  80196f:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801974:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801978:	75 14                	jne    80198e <initialize_dyn_block_system+0x184>
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	68 00 42 80 00       	push   $0x804200
  801982:	6a 34                	push   $0x34
  801984:	68 f3 41 80 00       	push   $0x8041f3
  801989:	e8 0d ee ff ff       	call   80079b <_panic>
  80198e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801994:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801997:	89 10                	mov    %edx,(%eax)
  801999:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80199c:	8b 00                	mov    (%eax),%eax
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	74 0d                	je     8019af <initialize_dyn_block_system+0x1a5>
  8019a2:	a1 38 51 80 00       	mov    0x805138,%eax
  8019a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019aa:	89 50 04             	mov    %edx,0x4(%eax)
  8019ad:	eb 08                	jmp    8019b7 <initialize_dyn_block_system+0x1ad>
  8019af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8019b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ba:	a3 38 51 80 00       	mov    %eax,0x805138
  8019bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8019ce:	40                   	inc    %eax
  8019cf:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8019d4:	90                   	nop
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019dd:	e8 f7 fd ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  8019e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019e6:	75 07                	jne    8019ef <malloc+0x18>
  8019e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ed:	eb 14                	jmp    801a03 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8019ef:	83 ec 04             	sub    $0x4,%esp
  8019f2:	68 24 42 80 00       	push   $0x804224
  8019f7:	6a 46                	push   $0x46
  8019f9:	68 f3 41 80 00       	push   $0x8041f3
  8019fe:	e8 98 ed ff ff       	call   80079b <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	68 4c 42 80 00       	push   $0x80424c
  801a13:	6a 61                	push   $0x61
  801a15:	68 f3 41 80 00       	push   $0x8041f3
  801a1a:	e8 7c ed ff ff       	call   80079b <_panic>

00801a1f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 18             	sub    $0x18,%esp
  801a25:	8b 45 10             	mov    0x10(%ebp),%eax
  801a28:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a2b:	e8 a9 fd ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a34:	75 07                	jne    801a3d <smalloc+0x1e>
  801a36:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3b:	eb 14                	jmp    801a51 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801a3d:	83 ec 04             	sub    $0x4,%esp
  801a40:	68 70 42 80 00       	push   $0x804270
  801a45:	6a 76                	push   $0x76
  801a47:	68 f3 41 80 00       	push   $0x8041f3
  801a4c:	e8 4a ed ff ff       	call   80079b <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a59:	e8 7b fd ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a5e:	83 ec 04             	sub    $0x4,%esp
  801a61:	68 98 42 80 00       	push   $0x804298
  801a66:	68 93 00 00 00       	push   $0x93
  801a6b:	68 f3 41 80 00       	push   $0x8041f3
  801a70:	e8 26 ed ff ff       	call   80079b <_panic>

00801a75 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a7b:	e8 59 fd ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a80:	83 ec 04             	sub    $0x4,%esp
  801a83:	68 bc 42 80 00       	push   $0x8042bc
  801a88:	68 c5 00 00 00       	push   $0xc5
  801a8d:	68 f3 41 80 00       	push   $0x8041f3
  801a92:	e8 04 ed ff ff       	call   80079b <_panic>

00801a97 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	68 e4 42 80 00       	push   $0x8042e4
  801aa5:	68 d9 00 00 00       	push   $0xd9
  801aaa:	68 f3 41 80 00       	push   $0x8041f3
  801aaf:	e8 e7 ec ff ff       	call   80079b <_panic>

00801ab4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aba:	83 ec 04             	sub    $0x4,%esp
  801abd:	68 08 43 80 00       	push   $0x804308
  801ac2:	68 e4 00 00 00       	push   $0xe4
  801ac7:	68 f3 41 80 00       	push   $0x8041f3
  801acc:	e8 ca ec ff ff       	call   80079b <_panic>

00801ad1 <shrink>:

}
void shrink(uint32 newSize)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ad7:	83 ec 04             	sub    $0x4,%esp
  801ada:	68 08 43 80 00       	push   $0x804308
  801adf:	68 e9 00 00 00       	push   $0xe9
  801ae4:	68 f3 41 80 00       	push   $0x8041f3
  801ae9:	e8 ad ec ff ff       	call   80079b <_panic>

00801aee <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801af4:	83 ec 04             	sub    $0x4,%esp
  801af7:	68 08 43 80 00       	push   $0x804308
  801afc:	68 ee 00 00 00       	push   $0xee
  801b01:	68 f3 41 80 00       	push   $0x8041f3
  801b06:	e8 90 ec ff ff       	call   80079b <_panic>

00801b0b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	57                   	push   %edi
  801b0f:	56                   	push   %esi
  801b10:	53                   	push   %ebx
  801b11:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b20:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b23:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b26:	cd 30                	int    $0x30
  801b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b2e:	83 c4 10             	add    $0x10,%esp
  801b31:	5b                   	pop    %ebx
  801b32:	5e                   	pop    %esi
  801b33:	5f                   	pop    %edi
  801b34:	5d                   	pop    %ebp
  801b35:	c3                   	ret    

00801b36 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	83 ec 04             	sub    $0x4,%esp
  801b3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b42:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	52                   	push   %edx
  801b4e:	ff 75 0c             	pushl  0xc(%ebp)
  801b51:	50                   	push   %eax
  801b52:	6a 00                	push   $0x0
  801b54:	e8 b2 ff ff ff       	call   801b0b <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	90                   	nop
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_cgetc>:

int
sys_cgetc(void)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 01                	push   $0x1
  801b6e:	e8 98 ff ff ff       	call   801b0b <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	52                   	push   %edx
  801b88:	50                   	push   %eax
  801b89:	6a 05                	push   $0x5
  801b8b:	e8 7b ff ff ff       	call   801b0b <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	56                   	push   %esi
  801b99:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b9a:	8b 75 18             	mov    0x18(%ebp),%esi
  801b9d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ba0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	56                   	push   %esi
  801baa:	53                   	push   %ebx
  801bab:	51                   	push   %ecx
  801bac:	52                   	push   %edx
  801bad:	50                   	push   %eax
  801bae:	6a 06                	push   $0x6
  801bb0:	e8 56 ff ff ff       	call   801b0b <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5e                   	pop    %esi
  801bbd:	5d                   	pop    %ebp
  801bbe:	c3                   	ret    

00801bbf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	52                   	push   %edx
  801bcf:	50                   	push   %eax
  801bd0:	6a 07                	push   $0x7
  801bd2:	e8 34 ff ff ff       	call   801b0b <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	ff 75 0c             	pushl  0xc(%ebp)
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	6a 08                	push   $0x8
  801bed:	e8 19 ff ff ff       	call   801b0b <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 09                	push   $0x9
  801c06:	e8 00 ff ff ff       	call   801b0b <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 0a                	push   $0xa
  801c1f:	e8 e7 fe ff ff       	call   801b0b <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 0b                	push   $0xb
  801c38:	e8 ce fe ff ff       	call   801b0b <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	ff 75 0c             	pushl  0xc(%ebp)
  801c4e:	ff 75 08             	pushl  0x8(%ebp)
  801c51:	6a 0f                	push   $0xf
  801c53:	e8 b3 fe ff ff       	call   801b0b <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
	return;
  801c5b:	90                   	nop
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	ff 75 0c             	pushl  0xc(%ebp)
  801c6a:	ff 75 08             	pushl  0x8(%ebp)
  801c6d:	6a 10                	push   $0x10
  801c6f:	e8 97 fe ff ff       	call   801b0b <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
	return ;
  801c77:	90                   	nop
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	ff 75 10             	pushl  0x10(%ebp)
  801c84:	ff 75 0c             	pushl  0xc(%ebp)
  801c87:	ff 75 08             	pushl  0x8(%ebp)
  801c8a:	6a 11                	push   $0x11
  801c8c:	e8 7a fe ff ff       	call   801b0b <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
	return ;
  801c94:	90                   	nop
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 0c                	push   $0xc
  801ca6:	e8 60 fe ff ff       	call   801b0b <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	ff 75 08             	pushl  0x8(%ebp)
  801cbe:	6a 0d                	push   $0xd
  801cc0:	e8 46 fe ff ff       	call   801b0b <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 0e                	push   $0xe
  801cd9:	e8 2d fe ff ff       	call   801b0b <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	90                   	nop
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 13                	push   $0x13
  801cf3:	e8 13 fe ff ff       	call   801b0b <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
}
  801cfb:	90                   	nop
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 14                	push   $0x14
  801d0d:	e8 f9 fd ff ff       	call   801b0b <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	90                   	nop
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 04             	sub    $0x4,%esp
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d24:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	50                   	push   %eax
  801d31:	6a 15                	push   $0x15
  801d33:	e8 d3 fd ff ff       	call   801b0b <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	90                   	nop
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 16                	push   $0x16
  801d4d:	e8 b9 fd ff ff       	call   801b0b <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	90                   	nop
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	ff 75 0c             	pushl  0xc(%ebp)
  801d67:	50                   	push   %eax
  801d68:	6a 17                	push   $0x17
  801d6a:	e8 9c fd ff ff       	call   801b0b <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	52                   	push   %edx
  801d84:	50                   	push   %eax
  801d85:	6a 1a                	push   $0x1a
  801d87:	e8 7f fd ff ff       	call   801b0b <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	52                   	push   %edx
  801da1:	50                   	push   %eax
  801da2:	6a 18                	push   $0x18
  801da4:	e8 62 fd ff ff       	call   801b0b <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
}
  801dac:	90                   	nop
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	52                   	push   %edx
  801dbf:	50                   	push   %eax
  801dc0:	6a 19                	push   $0x19
  801dc2:	e8 44 fd ff ff       	call   801b0b <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	90                   	nop
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 04             	sub    $0x4,%esp
  801dd3:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dd9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ddc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801de0:	8b 45 08             	mov    0x8(%ebp),%eax
  801de3:	6a 00                	push   $0x0
  801de5:	51                   	push   %ecx
  801de6:	52                   	push   %edx
  801de7:	ff 75 0c             	pushl  0xc(%ebp)
  801dea:	50                   	push   %eax
  801deb:	6a 1b                	push   $0x1b
  801ded:	e8 19 fd ff ff       	call   801b0b <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	52                   	push   %edx
  801e07:	50                   	push   %eax
  801e08:	6a 1c                	push   $0x1c
  801e0a:	e8 fc fc ff ff       	call   801b0b <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e17:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	51                   	push   %ecx
  801e25:	52                   	push   %edx
  801e26:	50                   	push   %eax
  801e27:	6a 1d                	push   $0x1d
  801e29:	e8 dd fc ff ff       	call   801b0b <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	52                   	push   %edx
  801e43:	50                   	push   %eax
  801e44:	6a 1e                	push   $0x1e
  801e46:	e8 c0 fc ff ff       	call   801b0b <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 1f                	push   $0x1f
  801e5f:	e8 a7 fc ff ff       	call   801b0b <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	6a 00                	push   $0x0
  801e71:	ff 75 14             	pushl  0x14(%ebp)
  801e74:	ff 75 10             	pushl  0x10(%ebp)
  801e77:	ff 75 0c             	pushl  0xc(%ebp)
  801e7a:	50                   	push   %eax
  801e7b:	6a 20                	push   $0x20
  801e7d:	e8 89 fc ff ff       	call   801b0b <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	50                   	push   %eax
  801e96:	6a 21                	push   $0x21
  801e98:	e8 6e fc ff ff       	call   801b0b <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
}
  801ea0:	90                   	nop
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	50                   	push   %eax
  801eb2:	6a 22                	push   $0x22
  801eb4:	e8 52 fc ff ff       	call   801b0b <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 02                	push   $0x2
  801ecd:	e8 39 fc ff ff       	call   801b0b <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 03                	push   $0x3
  801ee6:	e8 20 fc ff ff       	call   801b0b <syscall>
  801eeb:	83 c4 18             	add    $0x18,%esp
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 04                	push   $0x4
  801eff:	e8 07 fc ff ff       	call   801b0b <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_exit_env>:


void sys_exit_env(void)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 23                	push   $0x23
  801f18:	e8 ee fb ff ff       	call   801b0b <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	90                   	nop
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f29:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f2c:	8d 50 04             	lea    0x4(%eax),%edx
  801f2f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	52                   	push   %edx
  801f39:	50                   	push   %eax
  801f3a:	6a 24                	push   $0x24
  801f3c:	e8 ca fb ff ff       	call   801b0b <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
	return result;
  801f44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f4d:	89 01                	mov    %eax,(%ecx)
  801f4f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	c9                   	leave  
  801f56:	c2 04 00             	ret    $0x4

00801f59 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	ff 75 10             	pushl  0x10(%ebp)
  801f63:	ff 75 0c             	pushl  0xc(%ebp)
  801f66:	ff 75 08             	pushl  0x8(%ebp)
  801f69:	6a 12                	push   $0x12
  801f6b:	e8 9b fb ff ff       	call   801b0b <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
	return ;
  801f73:	90                   	nop
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 25                	push   $0x25
  801f85:	e8 81 fb ff ff       	call   801b0b <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	83 ec 04             	sub    $0x4,%esp
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f9b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	50                   	push   %eax
  801fa8:	6a 26                	push   $0x26
  801faa:	e8 5c fb ff ff       	call   801b0b <syscall>
  801faf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb2:	90                   	nop
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <rsttst>:
void rsttst()
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 28                	push   $0x28
  801fc4:	e8 42 fb ff ff       	call   801b0b <syscall>
  801fc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801fcc:	90                   	nop
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 04             	sub    $0x4,%esp
  801fd5:	8b 45 14             	mov    0x14(%ebp),%eax
  801fd8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fdb:	8b 55 18             	mov    0x18(%ebp),%edx
  801fde:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fe2:	52                   	push   %edx
  801fe3:	50                   	push   %eax
  801fe4:	ff 75 10             	pushl  0x10(%ebp)
  801fe7:	ff 75 0c             	pushl  0xc(%ebp)
  801fea:	ff 75 08             	pushl  0x8(%ebp)
  801fed:	6a 27                	push   $0x27
  801fef:	e8 17 fb ff ff       	call   801b0b <syscall>
  801ff4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff7:	90                   	nop
}
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <chktst>:
void chktst(uint32 n)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	ff 75 08             	pushl  0x8(%ebp)
  802008:	6a 29                	push   $0x29
  80200a:	e8 fc fa ff ff       	call   801b0b <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
	return ;
  802012:	90                   	nop
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <inctst>:

void inctst()
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 2a                	push   $0x2a
  802024:	e8 e2 fa ff ff       	call   801b0b <syscall>
  802029:	83 c4 18             	add    $0x18,%esp
	return ;
  80202c:	90                   	nop
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <gettst>:
uint32 gettst()
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 2b                	push   $0x2b
  80203e:	e8 c8 fa ff ff       	call   801b0b <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 2c                	push   $0x2c
  80205a:	e8 ac fa ff ff       	call   801b0b <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
  802062:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802065:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802069:	75 07                	jne    802072 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80206b:	b8 01 00 00 00       	mov    $0x1,%eax
  802070:	eb 05                	jmp    802077 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 2c                	push   $0x2c
  80208b:	e8 7b fa ff ff       	call   801b0b <syscall>
  802090:	83 c4 18             	add    $0x18,%esp
  802093:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802096:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80209a:	75 07                	jne    8020a3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80209c:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a1:	eb 05                	jmp    8020a8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 2c                	push   $0x2c
  8020bc:	e8 4a fa ff ff       	call   801b0b <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
  8020c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020c7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020cb:	75 07                	jne    8020d4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d2:	eb 05                	jmp    8020d9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 2c                	push   $0x2c
  8020ed:	e8 19 fa ff ff       	call   801b0b <syscall>
  8020f2:	83 c4 18             	add    $0x18,%esp
  8020f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020f8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020fc:	75 07                	jne    802105 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802103:	eb 05                	jmp    80210a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802105:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	ff 75 08             	pushl  0x8(%ebp)
  80211a:	6a 2d                	push   $0x2d
  80211c:	e8 ea f9 ff ff       	call   801b0b <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
	return ;
  802124:	90                   	nop
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80212b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80212e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802131:	8b 55 0c             	mov    0xc(%ebp),%edx
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	6a 00                	push   $0x0
  802139:	53                   	push   %ebx
  80213a:	51                   	push   %ecx
  80213b:	52                   	push   %edx
  80213c:	50                   	push   %eax
  80213d:	6a 2e                	push   $0x2e
  80213f:	e8 c7 f9 ff ff       	call   801b0b <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
}
  802147:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80214f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	52                   	push   %edx
  80215c:	50                   	push   %eax
  80215d:	6a 2f                	push   $0x2f
  80215f:	e8 a7 f9 ff ff       	call   801b0b <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80216f:	83 ec 0c             	sub    $0xc,%esp
  802172:	68 18 43 80 00       	push   $0x804318
  802177:	e8 d3 e8 ff ff       	call   800a4f <cprintf>
  80217c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80217f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802186:	83 ec 0c             	sub    $0xc,%esp
  802189:	68 44 43 80 00       	push   $0x804344
  80218e:	e8 bc e8 ff ff       	call   800a4f <cprintf>
  802193:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802196:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80219a:	a1 38 51 80 00       	mov    0x805138,%eax
  80219f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a2:	eb 56                	jmp    8021fa <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021a8:	74 1c                	je     8021c6 <print_mem_block_lists+0x5d>
  8021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ad:	8b 50 08             	mov    0x8(%eax),%edx
  8021b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b3:	8b 48 08             	mov    0x8(%eax),%ecx
  8021b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8021bc:	01 c8                	add    %ecx,%eax
  8021be:	39 c2                	cmp    %eax,%edx
  8021c0:	73 04                	jae    8021c6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021c2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c9:	8b 50 08             	mov    0x8(%eax),%edx
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d2:	01 c2                	add    %eax,%edx
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	8b 40 08             	mov    0x8(%eax),%eax
  8021da:	83 ec 04             	sub    $0x4,%esp
  8021dd:	52                   	push   %edx
  8021de:	50                   	push   %eax
  8021df:	68 59 43 80 00       	push   $0x804359
  8021e4:	e8 66 e8 ff ff       	call   800a4f <cprintf>
  8021e9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021f2:	a1 40 51 80 00       	mov    0x805140,%eax
  8021f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fe:	74 07                	je     802207 <print_mem_block_lists+0x9e>
  802200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802203:	8b 00                	mov    (%eax),%eax
  802205:	eb 05                	jmp    80220c <print_mem_block_lists+0xa3>
  802207:	b8 00 00 00 00       	mov    $0x0,%eax
  80220c:	a3 40 51 80 00       	mov    %eax,0x805140
  802211:	a1 40 51 80 00       	mov    0x805140,%eax
  802216:	85 c0                	test   %eax,%eax
  802218:	75 8a                	jne    8021a4 <print_mem_block_lists+0x3b>
  80221a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221e:	75 84                	jne    8021a4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802220:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802224:	75 10                	jne    802236 <print_mem_block_lists+0xcd>
  802226:	83 ec 0c             	sub    $0xc,%esp
  802229:	68 68 43 80 00       	push   $0x804368
  80222e:	e8 1c e8 ff ff       	call   800a4f <cprintf>
  802233:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802236:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80223d:	83 ec 0c             	sub    $0xc,%esp
  802240:	68 8c 43 80 00       	push   $0x80438c
  802245:	e8 05 e8 ff ff       	call   800a4f <cprintf>
  80224a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80224d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802251:	a1 40 50 80 00       	mov    0x805040,%eax
  802256:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802259:	eb 56                	jmp    8022b1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80225b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80225f:	74 1c                	je     80227d <print_mem_block_lists+0x114>
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	8b 50 08             	mov    0x8(%eax),%edx
  802267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226a:	8b 48 08             	mov    0x8(%eax),%ecx
  80226d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802270:	8b 40 0c             	mov    0xc(%eax),%eax
  802273:	01 c8                	add    %ecx,%eax
  802275:	39 c2                	cmp    %eax,%edx
  802277:	73 04                	jae    80227d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802279:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 50 08             	mov    0x8(%eax),%edx
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	8b 40 0c             	mov    0xc(%eax),%eax
  802289:	01 c2                	add    %eax,%edx
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 40 08             	mov    0x8(%eax),%eax
  802291:	83 ec 04             	sub    $0x4,%esp
  802294:	52                   	push   %edx
  802295:	50                   	push   %eax
  802296:	68 59 43 80 00       	push   $0x804359
  80229b:	e8 af e7 ff ff       	call   800a4f <cprintf>
  8022a0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022a9:	a1 48 50 80 00       	mov    0x805048,%eax
  8022ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b5:	74 07                	je     8022be <print_mem_block_lists+0x155>
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 00                	mov    (%eax),%eax
  8022bc:	eb 05                	jmp    8022c3 <print_mem_block_lists+0x15a>
  8022be:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c3:	a3 48 50 80 00       	mov    %eax,0x805048
  8022c8:	a1 48 50 80 00       	mov    0x805048,%eax
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	75 8a                	jne    80225b <print_mem_block_lists+0xf2>
  8022d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d5:	75 84                	jne    80225b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022d7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022db:	75 10                	jne    8022ed <print_mem_block_lists+0x184>
  8022dd:	83 ec 0c             	sub    $0xc,%esp
  8022e0:	68 a4 43 80 00       	push   $0x8043a4
  8022e5:	e8 65 e7 ff ff       	call   800a4f <cprintf>
  8022ea:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022ed:	83 ec 0c             	sub    $0xc,%esp
  8022f0:	68 18 43 80 00       	push   $0x804318
  8022f5:	e8 55 e7 ff ff       	call   800a4f <cprintf>
  8022fa:	83 c4 10             	add    $0x10,%esp

}
  8022fd:	90                   	nop
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802306:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80230d:	00 00 00 
  802310:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802317:	00 00 00 
  80231a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802321:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802324:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80232b:	e9 9e 00 00 00       	jmp    8023ce <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802330:	a1 50 50 80 00       	mov    0x805050,%eax
  802335:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802338:	c1 e2 04             	shl    $0x4,%edx
  80233b:	01 d0                	add    %edx,%eax
  80233d:	85 c0                	test   %eax,%eax
  80233f:	75 14                	jne    802355 <initialize_MemBlocksList+0x55>
  802341:	83 ec 04             	sub    $0x4,%esp
  802344:	68 cc 43 80 00       	push   $0x8043cc
  802349:	6a 46                	push   $0x46
  80234b:	68 ef 43 80 00       	push   $0x8043ef
  802350:	e8 46 e4 ff ff       	call   80079b <_panic>
  802355:	a1 50 50 80 00       	mov    0x805050,%eax
  80235a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235d:	c1 e2 04             	shl    $0x4,%edx
  802360:	01 d0                	add    %edx,%eax
  802362:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802368:	89 10                	mov    %edx,(%eax)
  80236a:	8b 00                	mov    (%eax),%eax
  80236c:	85 c0                	test   %eax,%eax
  80236e:	74 18                	je     802388 <initialize_MemBlocksList+0x88>
  802370:	a1 48 51 80 00       	mov    0x805148,%eax
  802375:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80237b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80237e:	c1 e1 04             	shl    $0x4,%ecx
  802381:	01 ca                	add    %ecx,%edx
  802383:	89 50 04             	mov    %edx,0x4(%eax)
  802386:	eb 12                	jmp    80239a <initialize_MemBlocksList+0x9a>
  802388:	a1 50 50 80 00       	mov    0x805050,%eax
  80238d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802390:	c1 e2 04             	shl    $0x4,%edx
  802393:	01 d0                	add    %edx,%eax
  802395:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80239a:	a1 50 50 80 00       	mov    0x805050,%eax
  80239f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a2:	c1 e2 04             	shl    $0x4,%edx
  8023a5:	01 d0                	add    %edx,%eax
  8023a7:	a3 48 51 80 00       	mov    %eax,0x805148
  8023ac:	a1 50 50 80 00       	mov    0x805050,%eax
  8023b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b4:	c1 e2 04             	shl    $0x4,%edx
  8023b7:	01 d0                	add    %edx,%eax
  8023b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8023c5:	40                   	inc    %eax
  8023c6:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8023cb:	ff 45 f4             	incl   -0xc(%ebp)
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d4:	0f 82 56 ff ff ff    	jb     802330 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8023da:	90                   	nop
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
  8023e0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023eb:	eb 19                	jmp    802406 <find_block+0x29>
	{
		if(va==point->sva)
  8023ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023f0:	8b 40 08             	mov    0x8(%eax),%eax
  8023f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023f6:	75 05                	jne    8023fd <find_block+0x20>
		   return point;
  8023f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023fb:	eb 36                	jmp    802433 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	8b 40 08             	mov    0x8(%eax),%eax
  802403:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802406:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80240a:	74 07                	je     802413 <find_block+0x36>
  80240c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80240f:	8b 00                	mov    (%eax),%eax
  802411:	eb 05                	jmp    802418 <find_block+0x3b>
  802413:	b8 00 00 00 00       	mov    $0x0,%eax
  802418:	8b 55 08             	mov    0x8(%ebp),%edx
  80241b:	89 42 08             	mov    %eax,0x8(%edx)
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	8b 40 08             	mov    0x8(%eax),%eax
  802424:	85 c0                	test   %eax,%eax
  802426:	75 c5                	jne    8023ed <find_block+0x10>
  802428:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80242c:	75 bf                	jne    8023ed <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80242e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80243b:	a1 40 50 80 00       	mov    0x805040,%eax
  802440:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802443:	a1 44 50 80 00       	mov    0x805044,%eax
  802448:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80244b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802451:	74 24                	je     802477 <insert_sorted_allocList+0x42>
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	8b 50 08             	mov    0x8(%eax),%edx
  802459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245c:	8b 40 08             	mov    0x8(%eax),%eax
  80245f:	39 c2                	cmp    %eax,%edx
  802461:	76 14                	jbe    802477 <insert_sorted_allocList+0x42>
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	8b 50 08             	mov    0x8(%eax),%edx
  802469:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80246c:	8b 40 08             	mov    0x8(%eax),%eax
  80246f:	39 c2                	cmp    %eax,%edx
  802471:	0f 82 60 01 00 00    	jb     8025d7 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802477:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80247b:	75 65                	jne    8024e2 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80247d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802481:	75 14                	jne    802497 <insert_sorted_allocList+0x62>
  802483:	83 ec 04             	sub    $0x4,%esp
  802486:	68 cc 43 80 00       	push   $0x8043cc
  80248b:	6a 6b                	push   $0x6b
  80248d:	68 ef 43 80 00       	push   $0x8043ef
  802492:	e8 04 e3 ff ff       	call   80079b <_panic>
  802497:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80249d:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a0:	89 10                	mov    %edx,(%eax)
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	74 0d                	je     8024b8 <insert_sorted_allocList+0x83>
  8024ab:	a1 40 50 80 00       	mov    0x805040,%eax
  8024b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b3:	89 50 04             	mov    %edx,0x4(%eax)
  8024b6:	eb 08                	jmp    8024c0 <insert_sorted_allocList+0x8b>
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	a3 44 50 80 00       	mov    %eax,0x805044
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	a3 40 50 80 00       	mov    %eax,0x805040
  8024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024d7:	40                   	inc    %eax
  8024d8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024dd:	e9 dc 01 00 00       	jmp    8026be <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	8b 50 08             	mov    0x8(%eax),%edx
  8024e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024eb:	8b 40 08             	mov    0x8(%eax),%eax
  8024ee:	39 c2                	cmp    %eax,%edx
  8024f0:	77 6c                	ja     80255e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8024f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024f6:	74 06                	je     8024fe <insert_sorted_allocList+0xc9>
  8024f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024fc:	75 14                	jne    802512 <insert_sorted_allocList+0xdd>
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	68 08 44 80 00       	push   $0x804408
  802506:	6a 6f                	push   $0x6f
  802508:	68 ef 43 80 00       	push   $0x8043ef
  80250d:	e8 89 e2 ff ff       	call   80079b <_panic>
  802512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802515:	8b 50 04             	mov    0x4(%eax),%edx
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	89 50 04             	mov    %edx,0x4(%eax)
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802524:	89 10                	mov    %edx,(%eax)
  802526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802529:	8b 40 04             	mov    0x4(%eax),%eax
  80252c:	85 c0                	test   %eax,%eax
  80252e:	74 0d                	je     80253d <insert_sorted_allocList+0x108>
  802530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802533:	8b 40 04             	mov    0x4(%eax),%eax
  802536:	8b 55 08             	mov    0x8(%ebp),%edx
  802539:	89 10                	mov    %edx,(%eax)
  80253b:	eb 08                	jmp    802545 <insert_sorted_allocList+0x110>
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	a3 40 50 80 00       	mov    %eax,0x805040
  802545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802548:	8b 55 08             	mov    0x8(%ebp),%edx
  80254b:	89 50 04             	mov    %edx,0x4(%eax)
  80254e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802553:	40                   	inc    %eax
  802554:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802559:	e9 60 01 00 00       	jmp    8026be <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	8b 50 08             	mov    0x8(%eax),%edx
  802564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802567:	8b 40 08             	mov    0x8(%eax),%eax
  80256a:	39 c2                	cmp    %eax,%edx
  80256c:	0f 82 4c 01 00 00    	jb     8026be <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802572:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802576:	75 14                	jne    80258c <insert_sorted_allocList+0x157>
  802578:	83 ec 04             	sub    $0x4,%esp
  80257b:	68 40 44 80 00       	push   $0x804440
  802580:	6a 73                	push   $0x73
  802582:	68 ef 43 80 00       	push   $0x8043ef
  802587:	e8 0f e2 ff ff       	call   80079b <_panic>
  80258c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802592:	8b 45 08             	mov    0x8(%ebp),%eax
  802595:	89 50 04             	mov    %edx,0x4(%eax)
  802598:	8b 45 08             	mov    0x8(%ebp),%eax
  80259b:	8b 40 04             	mov    0x4(%eax),%eax
  80259e:	85 c0                	test   %eax,%eax
  8025a0:	74 0c                	je     8025ae <insert_sorted_allocList+0x179>
  8025a2:	a1 44 50 80 00       	mov    0x805044,%eax
  8025a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025aa:	89 10                	mov    %edx,(%eax)
  8025ac:	eb 08                	jmp    8025b6 <insert_sorted_allocList+0x181>
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	a3 40 50 80 00       	mov    %eax,0x805040
  8025b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b9:	a3 44 50 80 00       	mov    %eax,0x805044
  8025be:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025cc:	40                   	inc    %eax
  8025cd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025d2:	e9 e7 00 00 00       	jmp    8026be <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8025d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8025dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025e4:	a1 40 50 80 00       	mov    0x805040,%eax
  8025e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ec:	e9 9d 00 00 00       	jmp    80268e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 00                	mov    (%eax),%eax
  8025f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	8b 50 08             	mov    0x8(%eax),%edx
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 40 08             	mov    0x8(%eax),%eax
  802605:	39 c2                	cmp    %eax,%edx
  802607:	76 7d                	jbe    802686 <insert_sorted_allocList+0x251>
  802609:	8b 45 08             	mov    0x8(%ebp),%eax
  80260c:	8b 50 08             	mov    0x8(%eax),%edx
  80260f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802612:	8b 40 08             	mov    0x8(%eax),%eax
  802615:	39 c2                	cmp    %eax,%edx
  802617:	73 6d                	jae    802686 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261d:	74 06                	je     802625 <insert_sorted_allocList+0x1f0>
  80261f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802623:	75 14                	jne    802639 <insert_sorted_allocList+0x204>
  802625:	83 ec 04             	sub    $0x4,%esp
  802628:	68 64 44 80 00       	push   $0x804464
  80262d:	6a 7f                	push   $0x7f
  80262f:	68 ef 43 80 00       	push   $0x8043ef
  802634:	e8 62 e1 ff ff       	call   80079b <_panic>
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 10                	mov    (%eax),%edx
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	89 10                	mov    %edx,(%eax)
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	8b 00                	mov    (%eax),%eax
  802648:	85 c0                	test   %eax,%eax
  80264a:	74 0b                	je     802657 <insert_sorted_allocList+0x222>
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 00                	mov    (%eax),%eax
  802651:	8b 55 08             	mov    0x8(%ebp),%edx
  802654:	89 50 04             	mov    %edx,0x4(%eax)
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 55 08             	mov    0x8(%ebp),%edx
  80265d:	89 10                	mov    %edx,(%eax)
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802665:	89 50 04             	mov    %edx,0x4(%eax)
  802668:	8b 45 08             	mov    0x8(%ebp),%eax
  80266b:	8b 00                	mov    (%eax),%eax
  80266d:	85 c0                	test   %eax,%eax
  80266f:	75 08                	jne    802679 <insert_sorted_allocList+0x244>
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	a3 44 50 80 00       	mov    %eax,0x805044
  802679:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80267e:	40                   	inc    %eax
  80267f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802684:	eb 39                	jmp    8026bf <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802686:	a1 48 50 80 00       	mov    0x805048,%eax
  80268b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802692:	74 07                	je     80269b <insert_sorted_allocList+0x266>
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	8b 00                	mov    (%eax),%eax
  802699:	eb 05                	jmp    8026a0 <insert_sorted_allocList+0x26b>
  80269b:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a0:	a3 48 50 80 00       	mov    %eax,0x805048
  8026a5:	a1 48 50 80 00       	mov    0x805048,%eax
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	0f 85 3f ff ff ff    	jne    8025f1 <insert_sorted_allocList+0x1bc>
  8026b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b6:	0f 85 35 ff ff ff    	jne    8025f1 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026bc:	eb 01                	jmp    8026bf <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026be:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026bf:	90                   	nop
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

008026c2 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
  8026c5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026c8:	a1 38 51 80 00       	mov    0x805138,%eax
  8026cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d0:	e9 85 01 00 00       	jmp    80285a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026de:	0f 82 6e 01 00 00    	jb     802852 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ed:	0f 85 8a 00 00 00    	jne    80277d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8026f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f7:	75 17                	jne    802710 <alloc_block_FF+0x4e>
  8026f9:	83 ec 04             	sub    $0x4,%esp
  8026fc:	68 98 44 80 00       	push   $0x804498
  802701:	68 93 00 00 00       	push   $0x93
  802706:	68 ef 43 80 00       	push   $0x8043ef
  80270b:	e8 8b e0 ff ff       	call   80079b <_panic>
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 00                	mov    (%eax),%eax
  802715:	85 c0                	test   %eax,%eax
  802717:	74 10                	je     802729 <alloc_block_FF+0x67>
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 00                	mov    (%eax),%eax
  80271e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802721:	8b 52 04             	mov    0x4(%edx),%edx
  802724:	89 50 04             	mov    %edx,0x4(%eax)
  802727:	eb 0b                	jmp    802734 <alloc_block_FF+0x72>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 40 04             	mov    0x4(%eax),%eax
  80272f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 40 04             	mov    0x4(%eax),%eax
  80273a:	85 c0                	test   %eax,%eax
  80273c:	74 0f                	je     80274d <alloc_block_FF+0x8b>
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	8b 40 04             	mov    0x4(%eax),%eax
  802744:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802747:	8b 12                	mov    (%edx),%edx
  802749:	89 10                	mov    %edx,(%eax)
  80274b:	eb 0a                	jmp    802757 <alloc_block_FF+0x95>
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	a3 38 51 80 00       	mov    %eax,0x805138
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80276a:	a1 44 51 80 00       	mov    0x805144,%eax
  80276f:	48                   	dec    %eax
  802770:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	e9 10 01 00 00       	jmp    80288d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 40 0c             	mov    0xc(%eax),%eax
  802783:	3b 45 08             	cmp    0x8(%ebp),%eax
  802786:	0f 86 c6 00 00 00    	jbe    802852 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80278c:	a1 48 51 80 00       	mov    0x805148,%eax
  802791:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 50 08             	mov    0x8(%eax),%edx
  80279a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a6:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ad:	75 17                	jne    8027c6 <alloc_block_FF+0x104>
  8027af:	83 ec 04             	sub    $0x4,%esp
  8027b2:	68 98 44 80 00       	push   $0x804498
  8027b7:	68 9b 00 00 00       	push   $0x9b
  8027bc:	68 ef 43 80 00       	push   $0x8043ef
  8027c1:	e8 d5 df ff ff       	call   80079b <_panic>
  8027c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c9:	8b 00                	mov    (%eax),%eax
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	74 10                	je     8027df <alloc_block_FF+0x11d>
  8027cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d2:	8b 00                	mov    (%eax),%eax
  8027d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d7:	8b 52 04             	mov    0x4(%edx),%edx
  8027da:	89 50 04             	mov    %edx,0x4(%eax)
  8027dd:	eb 0b                	jmp    8027ea <alloc_block_FF+0x128>
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	8b 40 04             	mov    0x4(%eax),%eax
  8027e5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ed:	8b 40 04             	mov    0x4(%eax),%eax
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	74 0f                	je     802803 <alloc_block_FF+0x141>
  8027f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f7:	8b 40 04             	mov    0x4(%eax),%eax
  8027fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027fd:	8b 12                	mov    (%edx),%edx
  8027ff:	89 10                	mov    %edx,(%eax)
  802801:	eb 0a                	jmp    80280d <alloc_block_FF+0x14b>
  802803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	a3 48 51 80 00       	mov    %eax,0x805148
  80280d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802810:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802819:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802820:	a1 54 51 80 00       	mov    0x805154,%eax
  802825:	48                   	dec    %eax
  802826:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 50 08             	mov    0x8(%eax),%edx
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	01 c2                	add    %eax,%edx
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 0c             	mov    0xc(%eax),%eax
  802842:	2b 45 08             	sub    0x8(%ebp),%eax
  802845:	89 c2                	mov    %eax,%edx
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80284d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802850:	eb 3b                	jmp    80288d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802852:	a1 40 51 80 00       	mov    0x805140,%eax
  802857:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285e:	74 07                	je     802867 <alloc_block_FF+0x1a5>
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 00                	mov    (%eax),%eax
  802865:	eb 05                	jmp    80286c <alloc_block_FF+0x1aa>
  802867:	b8 00 00 00 00       	mov    $0x0,%eax
  80286c:	a3 40 51 80 00       	mov    %eax,0x805140
  802871:	a1 40 51 80 00       	mov    0x805140,%eax
  802876:	85 c0                	test   %eax,%eax
  802878:	0f 85 57 fe ff ff    	jne    8026d5 <alloc_block_FF+0x13>
  80287e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802882:	0f 85 4d fe ff ff    	jne    8026d5 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802888:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80288d:	c9                   	leave  
  80288e:	c3                   	ret    

0080288f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80288f:	55                   	push   %ebp
  802890:	89 e5                	mov    %esp,%ebp
  802892:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802895:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80289c:	a1 38 51 80 00       	mov    0x805138,%eax
  8028a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a4:	e9 df 00 00 00       	jmp    802988 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8028af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b2:	0f 82 c8 00 00 00    	jb     802980 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c1:	0f 85 8a 00 00 00    	jne    802951 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8028c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cb:	75 17                	jne    8028e4 <alloc_block_BF+0x55>
  8028cd:	83 ec 04             	sub    $0x4,%esp
  8028d0:	68 98 44 80 00       	push   $0x804498
  8028d5:	68 b7 00 00 00       	push   $0xb7
  8028da:	68 ef 43 80 00       	push   $0x8043ef
  8028df:	e8 b7 de ff ff       	call   80079b <_panic>
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	8b 00                	mov    (%eax),%eax
  8028e9:	85 c0                	test   %eax,%eax
  8028eb:	74 10                	je     8028fd <alloc_block_BF+0x6e>
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 00                	mov    (%eax),%eax
  8028f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f5:	8b 52 04             	mov    0x4(%edx),%edx
  8028f8:	89 50 04             	mov    %edx,0x4(%eax)
  8028fb:	eb 0b                	jmp    802908 <alloc_block_BF+0x79>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 40 04             	mov    0x4(%eax),%eax
  802903:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 40 04             	mov    0x4(%eax),%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	74 0f                	je     802921 <alloc_block_BF+0x92>
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 40 04             	mov    0x4(%eax),%eax
  802918:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291b:	8b 12                	mov    (%edx),%edx
  80291d:	89 10                	mov    %edx,(%eax)
  80291f:	eb 0a                	jmp    80292b <alloc_block_BF+0x9c>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 00                	mov    (%eax),%eax
  802926:	a3 38 51 80 00       	mov    %eax,0x805138
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293e:	a1 44 51 80 00       	mov    0x805144,%eax
  802943:	48                   	dec    %eax
  802944:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	e9 4d 01 00 00       	jmp    802a9e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 40 0c             	mov    0xc(%eax),%eax
  802957:	3b 45 08             	cmp    0x8(%ebp),%eax
  80295a:	76 24                	jbe    802980 <alloc_block_BF+0xf1>
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 40 0c             	mov    0xc(%eax),%eax
  802962:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802965:	73 19                	jae    802980 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802967:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 40 0c             	mov    0xc(%eax),%eax
  802974:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 40 08             	mov    0x8(%eax),%eax
  80297d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802980:	a1 40 51 80 00       	mov    0x805140,%eax
  802985:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802988:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298c:	74 07                	je     802995 <alloc_block_BF+0x106>
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 00                	mov    (%eax),%eax
  802993:	eb 05                	jmp    80299a <alloc_block_BF+0x10b>
  802995:	b8 00 00 00 00       	mov    $0x0,%eax
  80299a:	a3 40 51 80 00       	mov    %eax,0x805140
  80299f:	a1 40 51 80 00       	mov    0x805140,%eax
  8029a4:	85 c0                	test   %eax,%eax
  8029a6:	0f 85 fd fe ff ff    	jne    8028a9 <alloc_block_BF+0x1a>
  8029ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b0:	0f 85 f3 fe ff ff    	jne    8028a9 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8029b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029ba:	0f 84 d9 00 00 00    	je     802a99 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8029c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8029c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029ce:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8029d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d7:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8029da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029de:	75 17                	jne    8029f7 <alloc_block_BF+0x168>
  8029e0:	83 ec 04             	sub    $0x4,%esp
  8029e3:	68 98 44 80 00       	push   $0x804498
  8029e8:	68 c7 00 00 00       	push   $0xc7
  8029ed:	68 ef 43 80 00       	push   $0x8043ef
  8029f2:	e8 a4 dd ff ff       	call   80079b <_panic>
  8029f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029fa:	8b 00                	mov    (%eax),%eax
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	74 10                	je     802a10 <alloc_block_BF+0x181>
  802a00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a08:	8b 52 04             	mov    0x4(%edx),%edx
  802a0b:	89 50 04             	mov    %edx,0x4(%eax)
  802a0e:	eb 0b                	jmp    802a1b <alloc_block_BF+0x18c>
  802a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a13:	8b 40 04             	mov    0x4(%eax),%eax
  802a16:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1e:	8b 40 04             	mov    0x4(%eax),%eax
  802a21:	85 c0                	test   %eax,%eax
  802a23:	74 0f                	je     802a34 <alloc_block_BF+0x1a5>
  802a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a2e:	8b 12                	mov    (%edx),%edx
  802a30:	89 10                	mov    %edx,(%eax)
  802a32:	eb 0a                	jmp    802a3e <alloc_block_BF+0x1af>
  802a34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a37:	8b 00                	mov    (%eax),%eax
  802a39:	a3 48 51 80 00       	mov    %eax,0x805148
  802a3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a51:	a1 54 51 80 00       	mov    0x805154,%eax
  802a56:	48                   	dec    %eax
  802a57:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a5c:	83 ec 08             	sub    $0x8,%esp
  802a5f:	ff 75 ec             	pushl  -0x14(%ebp)
  802a62:	68 38 51 80 00       	push   $0x805138
  802a67:	e8 71 f9 ff ff       	call   8023dd <find_block>
  802a6c:	83 c4 10             	add    $0x10,%esp
  802a6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a75:	8b 50 08             	mov    0x8(%eax),%edx
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	01 c2                	add    %eax,%edx
  802a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a80:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a86:	8b 40 0c             	mov    0xc(%eax),%eax
  802a89:	2b 45 08             	sub    0x8(%ebp),%eax
  802a8c:	89 c2                	mov    %eax,%edx
  802a8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a91:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a97:	eb 05                	jmp    802a9e <alloc_block_BF+0x20f>
	}
	return NULL;
  802a99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a9e:	c9                   	leave  
  802a9f:	c3                   	ret    

00802aa0 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802aa0:	55                   	push   %ebp
  802aa1:	89 e5                	mov    %esp,%ebp
  802aa3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802aa6:	a1 28 50 80 00       	mov    0x805028,%eax
  802aab:	85 c0                	test   %eax,%eax
  802aad:	0f 85 de 01 00 00    	jne    802c91 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ab3:	a1 38 51 80 00       	mov    0x805138,%eax
  802ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802abb:	e9 9e 01 00 00       	jmp    802c5e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac9:	0f 82 87 01 00 00    	jb     802c56 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad8:	0f 85 95 00 00 00    	jne    802b73 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802ade:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae2:	75 17                	jne    802afb <alloc_block_NF+0x5b>
  802ae4:	83 ec 04             	sub    $0x4,%esp
  802ae7:	68 98 44 80 00       	push   $0x804498
  802aec:	68 e0 00 00 00       	push   $0xe0
  802af1:	68 ef 43 80 00       	push   $0x8043ef
  802af6:	e8 a0 dc ff ff       	call   80079b <_panic>
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	8b 00                	mov    (%eax),%eax
  802b00:	85 c0                	test   %eax,%eax
  802b02:	74 10                	je     802b14 <alloc_block_NF+0x74>
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 00                	mov    (%eax),%eax
  802b09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b0c:	8b 52 04             	mov    0x4(%edx),%edx
  802b0f:	89 50 04             	mov    %edx,0x4(%eax)
  802b12:	eb 0b                	jmp    802b1f <alloc_block_NF+0x7f>
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 40 04             	mov    0x4(%eax),%eax
  802b1a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 40 04             	mov    0x4(%eax),%eax
  802b25:	85 c0                	test   %eax,%eax
  802b27:	74 0f                	je     802b38 <alloc_block_NF+0x98>
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	8b 40 04             	mov    0x4(%eax),%eax
  802b2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b32:	8b 12                	mov    (%edx),%edx
  802b34:	89 10                	mov    %edx,(%eax)
  802b36:	eb 0a                	jmp    802b42 <alloc_block_NF+0xa2>
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 00                	mov    (%eax),%eax
  802b3d:	a3 38 51 80 00       	mov    %eax,0x805138
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b55:	a1 44 51 80 00       	mov    0x805144,%eax
  802b5a:	48                   	dec    %eax
  802b5b:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	8b 40 08             	mov    0x8(%eax),%eax
  802b66:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	e9 f8 04 00 00       	jmp    80306b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 40 0c             	mov    0xc(%eax),%eax
  802b79:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b7c:	0f 86 d4 00 00 00    	jbe    802c56 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b82:	a1 48 51 80 00       	mov    0x805148,%eax
  802b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 50 08             	mov    0x8(%eax),%edx
  802b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b93:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b99:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ba3:	75 17                	jne    802bbc <alloc_block_NF+0x11c>
  802ba5:	83 ec 04             	sub    $0x4,%esp
  802ba8:	68 98 44 80 00       	push   $0x804498
  802bad:	68 e9 00 00 00       	push   $0xe9
  802bb2:	68 ef 43 80 00       	push   $0x8043ef
  802bb7:	e8 df db ff ff       	call   80079b <_panic>
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	74 10                	je     802bd5 <alloc_block_NF+0x135>
  802bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bcd:	8b 52 04             	mov    0x4(%edx),%edx
  802bd0:	89 50 04             	mov    %edx,0x4(%eax)
  802bd3:	eb 0b                	jmp    802be0 <alloc_block_NF+0x140>
  802bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd8:	8b 40 04             	mov    0x4(%eax),%eax
  802bdb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be3:	8b 40 04             	mov    0x4(%eax),%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	74 0f                	je     802bf9 <alloc_block_NF+0x159>
  802bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bed:	8b 40 04             	mov    0x4(%eax),%eax
  802bf0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf3:	8b 12                	mov    (%edx),%edx
  802bf5:	89 10                	mov    %edx,(%eax)
  802bf7:	eb 0a                	jmp    802c03 <alloc_block_NF+0x163>
  802bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfc:	8b 00                	mov    (%eax),%eax
  802bfe:	a3 48 51 80 00       	mov    %eax,0x805148
  802c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c16:	a1 54 51 80 00       	mov    0x805154,%eax
  802c1b:	48                   	dec    %eax
  802c1c:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c24:	8b 40 08             	mov    0x8(%eax),%eax
  802c27:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 50 08             	mov    0x8(%eax),%edx
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	01 c2                	add    %eax,%edx
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 40 0c             	mov    0xc(%eax),%eax
  802c43:	2b 45 08             	sub    0x8(%ebp),%eax
  802c46:	89 c2                	mov    %eax,%edx
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c51:	e9 15 04 00 00       	jmp    80306b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c56:	a1 40 51 80 00       	mov    0x805140,%eax
  802c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c62:	74 07                	je     802c6b <alloc_block_NF+0x1cb>
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	8b 00                	mov    (%eax),%eax
  802c69:	eb 05                	jmp    802c70 <alloc_block_NF+0x1d0>
  802c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c70:	a3 40 51 80 00       	mov    %eax,0x805140
  802c75:	a1 40 51 80 00       	mov    0x805140,%eax
  802c7a:	85 c0                	test   %eax,%eax
  802c7c:	0f 85 3e fe ff ff    	jne    802ac0 <alloc_block_NF+0x20>
  802c82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c86:	0f 85 34 fe ff ff    	jne    802ac0 <alloc_block_NF+0x20>
  802c8c:	e9 d5 03 00 00       	jmp    803066 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c91:	a1 38 51 80 00       	mov    0x805138,%eax
  802c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c99:	e9 b1 01 00 00       	jmp    802e4f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 50 08             	mov    0x8(%eax),%edx
  802ca4:	a1 28 50 80 00       	mov    0x805028,%eax
  802ca9:	39 c2                	cmp    %eax,%edx
  802cab:	0f 82 96 01 00 00    	jb     802e47 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cba:	0f 82 87 01 00 00    	jb     802e47 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc9:	0f 85 95 00 00 00    	jne    802d64 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd3:	75 17                	jne    802cec <alloc_block_NF+0x24c>
  802cd5:	83 ec 04             	sub    $0x4,%esp
  802cd8:	68 98 44 80 00       	push   $0x804498
  802cdd:	68 fc 00 00 00       	push   $0xfc
  802ce2:	68 ef 43 80 00       	push   $0x8043ef
  802ce7:	e8 af da ff ff       	call   80079b <_panic>
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	74 10                	je     802d05 <alloc_block_NF+0x265>
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfd:	8b 52 04             	mov    0x4(%edx),%edx
  802d00:	89 50 04             	mov    %edx,0x4(%eax)
  802d03:	eb 0b                	jmp    802d10 <alloc_block_NF+0x270>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	74 0f                	je     802d29 <alloc_block_NF+0x289>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 40 04             	mov    0x4(%eax),%eax
  802d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d23:	8b 12                	mov    (%edx),%edx
  802d25:	89 10                	mov    %edx,(%eax)
  802d27:	eb 0a                	jmp    802d33 <alloc_block_NF+0x293>
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	a3 38 51 80 00       	mov    %eax,0x805138
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d46:	a1 44 51 80 00       	mov    0x805144,%eax
  802d4b:	48                   	dec    %eax
  802d4c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 40 08             	mov    0x8(%eax),%eax
  802d57:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	e9 07 03 00 00       	jmp    80306b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d6d:	0f 86 d4 00 00 00    	jbe    802e47 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d73:	a1 48 51 80 00       	mov    0x805148,%eax
  802d78:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 50 08             	mov    0x8(%eax),%edx
  802d81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d84:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d90:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d94:	75 17                	jne    802dad <alloc_block_NF+0x30d>
  802d96:	83 ec 04             	sub    $0x4,%esp
  802d99:	68 98 44 80 00       	push   $0x804498
  802d9e:	68 04 01 00 00       	push   $0x104
  802da3:	68 ef 43 80 00       	push   $0x8043ef
  802da8:	e8 ee d9 ff ff       	call   80079b <_panic>
  802dad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db0:	8b 00                	mov    (%eax),%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	74 10                	je     802dc6 <alloc_block_NF+0x326>
  802db6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dbe:	8b 52 04             	mov    0x4(%edx),%edx
  802dc1:	89 50 04             	mov    %edx,0x4(%eax)
  802dc4:	eb 0b                	jmp    802dd1 <alloc_block_NF+0x331>
  802dc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc9:	8b 40 04             	mov    0x4(%eax),%eax
  802dcc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd4:	8b 40 04             	mov    0x4(%eax),%eax
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	74 0f                	je     802dea <alloc_block_NF+0x34a>
  802ddb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802de4:	8b 12                	mov    (%edx),%edx
  802de6:	89 10                	mov    %edx,(%eax)
  802de8:	eb 0a                	jmp    802df4 <alloc_block_NF+0x354>
  802dea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	a3 48 51 80 00       	mov    %eax,0x805148
  802df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e07:	a1 54 51 80 00       	mov    0x805154,%eax
  802e0c:	48                   	dec    %eax
  802e0d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e15:	8b 40 08             	mov    0x8(%eax),%eax
  802e18:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 50 08             	mov    0x8(%eax),%edx
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	01 c2                	add    %eax,%edx
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 40 0c             	mov    0xc(%eax),%eax
  802e34:	2b 45 08             	sub    0x8(%ebp),%eax
  802e37:	89 c2                	mov    %eax,%edx
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e42:	e9 24 02 00 00       	jmp    80306b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e47:	a1 40 51 80 00       	mov    0x805140,%eax
  802e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e53:	74 07                	je     802e5c <alloc_block_NF+0x3bc>
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	eb 05                	jmp    802e61 <alloc_block_NF+0x3c1>
  802e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e61:	a3 40 51 80 00       	mov    %eax,0x805140
  802e66:	a1 40 51 80 00       	mov    0x805140,%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	0f 85 2b fe ff ff    	jne    802c9e <alloc_block_NF+0x1fe>
  802e73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e77:	0f 85 21 fe ff ff    	jne    802c9e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e7d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e85:	e9 ae 01 00 00       	jmp    803038 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 50 08             	mov    0x8(%eax),%edx
  802e90:	a1 28 50 80 00       	mov    0x805028,%eax
  802e95:	39 c2                	cmp    %eax,%edx
  802e97:	0f 83 93 01 00 00    	jae    803030 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ea6:	0f 82 84 01 00 00    	jb     803030 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb5:	0f 85 95 00 00 00    	jne    802f50 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebf:	75 17                	jne    802ed8 <alloc_block_NF+0x438>
  802ec1:	83 ec 04             	sub    $0x4,%esp
  802ec4:	68 98 44 80 00       	push   $0x804498
  802ec9:	68 14 01 00 00       	push   $0x114
  802ece:	68 ef 43 80 00       	push   $0x8043ef
  802ed3:	e8 c3 d8 ff ff       	call   80079b <_panic>
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 00                	mov    (%eax),%eax
  802edd:	85 c0                	test   %eax,%eax
  802edf:	74 10                	je     802ef1 <alloc_block_NF+0x451>
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	8b 00                	mov    (%eax),%eax
  802ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee9:	8b 52 04             	mov    0x4(%edx),%edx
  802eec:	89 50 04             	mov    %edx,0x4(%eax)
  802eef:	eb 0b                	jmp    802efc <alloc_block_NF+0x45c>
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 40 04             	mov    0x4(%eax),%eax
  802ef7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 40 04             	mov    0x4(%eax),%eax
  802f02:	85 c0                	test   %eax,%eax
  802f04:	74 0f                	je     802f15 <alloc_block_NF+0x475>
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	8b 40 04             	mov    0x4(%eax),%eax
  802f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0f:	8b 12                	mov    (%edx),%edx
  802f11:	89 10                	mov    %edx,(%eax)
  802f13:	eb 0a                	jmp    802f1f <alloc_block_NF+0x47f>
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 00                	mov    (%eax),%eax
  802f1a:	a3 38 51 80 00       	mov    %eax,0x805138
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f32:	a1 44 51 80 00       	mov    0x805144,%eax
  802f37:	48                   	dec    %eax
  802f38:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	8b 40 08             	mov    0x8(%eax),%eax
  802f43:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	e9 1b 01 00 00       	jmp    80306b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 40 0c             	mov    0xc(%eax),%eax
  802f56:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f59:	0f 86 d1 00 00 00    	jbe    803030 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f5f:	a1 48 51 80 00       	mov    0x805148,%eax
  802f64:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	8b 50 08             	mov    0x8(%eax),%edx
  802f6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f70:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f76:	8b 55 08             	mov    0x8(%ebp),%edx
  802f79:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f80:	75 17                	jne    802f99 <alloc_block_NF+0x4f9>
  802f82:	83 ec 04             	sub    $0x4,%esp
  802f85:	68 98 44 80 00       	push   $0x804498
  802f8a:	68 1c 01 00 00       	push   $0x11c
  802f8f:	68 ef 43 80 00       	push   $0x8043ef
  802f94:	e8 02 d8 ff ff       	call   80079b <_panic>
  802f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9c:	8b 00                	mov    (%eax),%eax
  802f9e:	85 c0                	test   %eax,%eax
  802fa0:	74 10                	je     802fb2 <alloc_block_NF+0x512>
  802fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa5:	8b 00                	mov    (%eax),%eax
  802fa7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802faa:	8b 52 04             	mov    0x4(%edx),%edx
  802fad:	89 50 04             	mov    %edx,0x4(%eax)
  802fb0:	eb 0b                	jmp    802fbd <alloc_block_NF+0x51d>
  802fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb5:	8b 40 04             	mov    0x4(%eax),%eax
  802fb8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc0:	8b 40 04             	mov    0x4(%eax),%eax
  802fc3:	85 c0                	test   %eax,%eax
  802fc5:	74 0f                	je     802fd6 <alloc_block_NF+0x536>
  802fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fca:	8b 40 04             	mov    0x4(%eax),%eax
  802fcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fd0:	8b 12                	mov    (%edx),%edx
  802fd2:	89 10                	mov    %edx,(%eax)
  802fd4:	eb 0a                	jmp    802fe0 <alloc_block_NF+0x540>
  802fd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd9:	8b 00                	mov    (%eax),%eax
  802fdb:	a3 48 51 80 00       	mov    %eax,0x805148
  802fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ff8:	48                   	dec    %eax
  802ff9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803001:	8b 40 08             	mov    0x8(%eax),%eax
  803004:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 50 08             	mov    0x8(%eax),%edx
  80300f:	8b 45 08             	mov    0x8(%ebp),%eax
  803012:	01 c2                	add    %eax,%edx
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	8b 40 0c             	mov    0xc(%eax),%eax
  803020:	2b 45 08             	sub    0x8(%ebp),%eax
  803023:	89 c2                	mov    %eax,%edx
  803025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803028:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80302b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302e:	eb 3b                	jmp    80306b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803030:	a1 40 51 80 00       	mov    0x805140,%eax
  803035:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803038:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303c:	74 07                	je     803045 <alloc_block_NF+0x5a5>
  80303e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803041:	8b 00                	mov    (%eax),%eax
  803043:	eb 05                	jmp    80304a <alloc_block_NF+0x5aa>
  803045:	b8 00 00 00 00       	mov    $0x0,%eax
  80304a:	a3 40 51 80 00       	mov    %eax,0x805140
  80304f:	a1 40 51 80 00       	mov    0x805140,%eax
  803054:	85 c0                	test   %eax,%eax
  803056:	0f 85 2e fe ff ff    	jne    802e8a <alloc_block_NF+0x3ea>
  80305c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803060:	0f 85 24 fe ff ff    	jne    802e8a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803066:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80306b:	c9                   	leave  
  80306c:	c3                   	ret    

0080306d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80306d:	55                   	push   %ebp
  80306e:	89 e5                	mov    %esp,%ebp
  803070:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803073:	a1 38 51 80 00       	mov    0x805138,%eax
  803078:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80307b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803080:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803083:	a1 38 51 80 00       	mov    0x805138,%eax
  803088:	85 c0                	test   %eax,%eax
  80308a:	74 14                	je     8030a0 <insert_sorted_with_merge_freeList+0x33>
  80308c:	8b 45 08             	mov    0x8(%ebp),%eax
  80308f:	8b 50 08             	mov    0x8(%eax),%edx
  803092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803095:	8b 40 08             	mov    0x8(%eax),%eax
  803098:	39 c2                	cmp    %eax,%edx
  80309a:	0f 87 9b 01 00 00    	ja     80323b <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8030a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a4:	75 17                	jne    8030bd <insert_sorted_with_merge_freeList+0x50>
  8030a6:	83 ec 04             	sub    $0x4,%esp
  8030a9:	68 cc 43 80 00       	push   $0x8043cc
  8030ae:	68 38 01 00 00       	push   $0x138
  8030b3:	68 ef 43 80 00       	push   $0x8043ef
  8030b8:	e8 de d6 ff ff       	call   80079b <_panic>
  8030bd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	89 10                	mov    %edx,(%eax)
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	8b 00                	mov    (%eax),%eax
  8030cd:	85 c0                	test   %eax,%eax
  8030cf:	74 0d                	je     8030de <insert_sorted_with_merge_freeList+0x71>
  8030d1:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d9:	89 50 04             	mov    %edx,0x4(%eax)
  8030dc:	eb 08                	jmp    8030e6 <insert_sorted_with_merge_freeList+0x79>
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f8:	a1 44 51 80 00       	mov    0x805144,%eax
  8030fd:	40                   	inc    %eax
  8030fe:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803103:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803107:	0f 84 a8 06 00 00    	je     8037b5 <insert_sorted_with_merge_freeList+0x748>
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	8b 50 08             	mov    0x8(%eax),%edx
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	8b 40 0c             	mov    0xc(%eax),%eax
  803119:	01 c2                	add    %eax,%edx
  80311b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311e:	8b 40 08             	mov    0x8(%eax),%eax
  803121:	39 c2                	cmp    %eax,%edx
  803123:	0f 85 8c 06 00 00    	jne    8037b5 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	8b 50 0c             	mov    0xc(%eax),%edx
  80312f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803132:	8b 40 0c             	mov    0xc(%eax),%eax
  803135:	01 c2                	add    %eax,%edx
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80313d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803141:	75 17                	jne    80315a <insert_sorted_with_merge_freeList+0xed>
  803143:	83 ec 04             	sub    $0x4,%esp
  803146:	68 98 44 80 00       	push   $0x804498
  80314b:	68 3c 01 00 00       	push   $0x13c
  803150:	68 ef 43 80 00       	push   $0x8043ef
  803155:	e8 41 d6 ff ff       	call   80079b <_panic>
  80315a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315d:	8b 00                	mov    (%eax),%eax
  80315f:	85 c0                	test   %eax,%eax
  803161:	74 10                	je     803173 <insert_sorted_with_merge_freeList+0x106>
  803163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803166:	8b 00                	mov    (%eax),%eax
  803168:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80316b:	8b 52 04             	mov    0x4(%edx),%edx
  80316e:	89 50 04             	mov    %edx,0x4(%eax)
  803171:	eb 0b                	jmp    80317e <insert_sorted_with_merge_freeList+0x111>
  803173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803176:	8b 40 04             	mov    0x4(%eax),%eax
  803179:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80317e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803181:	8b 40 04             	mov    0x4(%eax),%eax
  803184:	85 c0                	test   %eax,%eax
  803186:	74 0f                	je     803197 <insert_sorted_with_merge_freeList+0x12a>
  803188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318b:	8b 40 04             	mov    0x4(%eax),%eax
  80318e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803191:	8b 12                	mov    (%edx),%edx
  803193:	89 10                	mov    %edx,(%eax)
  803195:	eb 0a                	jmp    8031a1 <insert_sorted_with_merge_freeList+0x134>
  803197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319a:	8b 00                	mov    (%eax),%eax
  80319c:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b4:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b9:	48                   	dec    %eax
  8031ba:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8031bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8031c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8031d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d7:	75 17                	jne    8031f0 <insert_sorted_with_merge_freeList+0x183>
  8031d9:	83 ec 04             	sub    $0x4,%esp
  8031dc:	68 cc 43 80 00       	push   $0x8043cc
  8031e1:	68 3f 01 00 00       	push   $0x13f
  8031e6:	68 ef 43 80 00       	push   $0x8043ef
  8031eb:	e8 ab d5 ff ff       	call   80079b <_panic>
  8031f0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f9:	89 10                	mov    %edx,(%eax)
  8031fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fe:	8b 00                	mov    (%eax),%eax
  803200:	85 c0                	test   %eax,%eax
  803202:	74 0d                	je     803211 <insert_sorted_with_merge_freeList+0x1a4>
  803204:	a1 48 51 80 00       	mov    0x805148,%eax
  803209:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80320c:	89 50 04             	mov    %edx,0x4(%eax)
  80320f:	eb 08                	jmp    803219 <insert_sorted_with_merge_freeList+0x1ac>
  803211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803214:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321c:	a3 48 51 80 00       	mov    %eax,0x805148
  803221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803224:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322b:	a1 54 51 80 00       	mov    0x805154,%eax
  803230:	40                   	inc    %eax
  803231:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803236:	e9 7a 05 00 00       	jmp    8037b5 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	8b 50 08             	mov    0x8(%eax),%edx
  803241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803244:	8b 40 08             	mov    0x8(%eax),%eax
  803247:	39 c2                	cmp    %eax,%edx
  803249:	0f 82 14 01 00 00    	jb     803363 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80324f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803252:	8b 50 08             	mov    0x8(%eax),%edx
  803255:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803258:	8b 40 0c             	mov    0xc(%eax),%eax
  80325b:	01 c2                	add    %eax,%edx
  80325d:	8b 45 08             	mov    0x8(%ebp),%eax
  803260:	8b 40 08             	mov    0x8(%eax),%eax
  803263:	39 c2                	cmp    %eax,%edx
  803265:	0f 85 90 00 00 00    	jne    8032fb <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80326b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326e:	8b 50 0c             	mov    0xc(%eax),%edx
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	8b 40 0c             	mov    0xc(%eax),%eax
  803277:	01 c2                	add    %eax,%edx
  803279:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803293:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803297:	75 17                	jne    8032b0 <insert_sorted_with_merge_freeList+0x243>
  803299:	83 ec 04             	sub    $0x4,%esp
  80329c:	68 cc 43 80 00       	push   $0x8043cc
  8032a1:	68 49 01 00 00       	push   $0x149
  8032a6:	68 ef 43 80 00       	push   $0x8043ef
  8032ab:	e8 eb d4 ff ff       	call   80079b <_panic>
  8032b0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	89 10                	mov    %edx,(%eax)
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	8b 00                	mov    (%eax),%eax
  8032c0:	85 c0                	test   %eax,%eax
  8032c2:	74 0d                	je     8032d1 <insert_sorted_with_merge_freeList+0x264>
  8032c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8032c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032cc:	89 50 04             	mov    %edx,0x4(%eax)
  8032cf:	eb 08                	jmp    8032d9 <insert_sorted_with_merge_freeList+0x26c>
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032eb:	a1 54 51 80 00       	mov    0x805154,%eax
  8032f0:	40                   	inc    %eax
  8032f1:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032f6:	e9 bb 04 00 00       	jmp    8037b6 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ff:	75 17                	jne    803318 <insert_sorted_with_merge_freeList+0x2ab>
  803301:	83 ec 04             	sub    $0x4,%esp
  803304:	68 40 44 80 00       	push   $0x804440
  803309:	68 4c 01 00 00       	push   $0x14c
  80330e:	68 ef 43 80 00       	push   $0x8043ef
  803313:	e8 83 d4 ff ff       	call   80079b <_panic>
  803318:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	89 50 04             	mov    %edx,0x4(%eax)
  803324:	8b 45 08             	mov    0x8(%ebp),%eax
  803327:	8b 40 04             	mov    0x4(%eax),%eax
  80332a:	85 c0                	test   %eax,%eax
  80332c:	74 0c                	je     80333a <insert_sorted_with_merge_freeList+0x2cd>
  80332e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803333:	8b 55 08             	mov    0x8(%ebp),%edx
  803336:	89 10                	mov    %edx,(%eax)
  803338:	eb 08                	jmp    803342 <insert_sorted_with_merge_freeList+0x2d5>
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	a3 38 51 80 00       	mov    %eax,0x805138
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803353:	a1 44 51 80 00       	mov    0x805144,%eax
  803358:	40                   	inc    %eax
  803359:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80335e:	e9 53 04 00 00       	jmp    8037b6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803363:	a1 38 51 80 00       	mov    0x805138,%eax
  803368:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336b:	e9 15 04 00 00       	jmp    803785 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803373:	8b 00                	mov    (%eax),%eax
  803375:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803378:	8b 45 08             	mov    0x8(%ebp),%eax
  80337b:	8b 50 08             	mov    0x8(%eax),%edx
  80337e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803381:	8b 40 08             	mov    0x8(%eax),%eax
  803384:	39 c2                	cmp    %eax,%edx
  803386:	0f 86 f1 03 00 00    	jbe    80377d <insert_sorted_with_merge_freeList+0x710>
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	8b 50 08             	mov    0x8(%eax),%edx
  803392:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803395:	8b 40 08             	mov    0x8(%eax),%eax
  803398:	39 c2                	cmp    %eax,%edx
  80339a:	0f 83 dd 03 00 00    	jae    80377d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	8b 50 08             	mov    0x8(%eax),%edx
  8033a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ac:	01 c2                	add    %eax,%edx
  8033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b1:	8b 40 08             	mov    0x8(%eax),%eax
  8033b4:	39 c2                	cmp    %eax,%edx
  8033b6:	0f 85 b9 01 00 00    	jne    803575 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	8b 50 08             	mov    0x8(%eax),%edx
  8033c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c8:	01 c2                	add    %eax,%edx
  8033ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cd:	8b 40 08             	mov    0x8(%eax),%eax
  8033d0:	39 c2                	cmp    %eax,%edx
  8033d2:	0f 85 0d 01 00 00    	jne    8034e5 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033db:	8b 50 0c             	mov    0xc(%eax),%edx
  8033de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e4:	01 c2                	add    %eax,%edx
  8033e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e9:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033f0:	75 17                	jne    803409 <insert_sorted_with_merge_freeList+0x39c>
  8033f2:	83 ec 04             	sub    $0x4,%esp
  8033f5:	68 98 44 80 00       	push   $0x804498
  8033fa:	68 5c 01 00 00       	push   $0x15c
  8033ff:	68 ef 43 80 00       	push   $0x8043ef
  803404:	e8 92 d3 ff ff       	call   80079b <_panic>
  803409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340c:	8b 00                	mov    (%eax),%eax
  80340e:	85 c0                	test   %eax,%eax
  803410:	74 10                	je     803422 <insert_sorted_with_merge_freeList+0x3b5>
  803412:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803415:	8b 00                	mov    (%eax),%eax
  803417:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80341a:	8b 52 04             	mov    0x4(%edx),%edx
  80341d:	89 50 04             	mov    %edx,0x4(%eax)
  803420:	eb 0b                	jmp    80342d <insert_sorted_with_merge_freeList+0x3c0>
  803422:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803425:	8b 40 04             	mov    0x4(%eax),%eax
  803428:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80342d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803430:	8b 40 04             	mov    0x4(%eax),%eax
  803433:	85 c0                	test   %eax,%eax
  803435:	74 0f                	je     803446 <insert_sorted_with_merge_freeList+0x3d9>
  803437:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343a:	8b 40 04             	mov    0x4(%eax),%eax
  80343d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803440:	8b 12                	mov    (%edx),%edx
  803442:	89 10                	mov    %edx,(%eax)
  803444:	eb 0a                	jmp    803450 <insert_sorted_with_merge_freeList+0x3e3>
  803446:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803449:	8b 00                	mov    (%eax),%eax
  80344b:	a3 38 51 80 00       	mov    %eax,0x805138
  803450:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803453:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803463:	a1 44 51 80 00       	mov    0x805144,%eax
  803468:	48                   	dec    %eax
  803469:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80346e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803471:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803478:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803482:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803486:	75 17                	jne    80349f <insert_sorted_with_merge_freeList+0x432>
  803488:	83 ec 04             	sub    $0x4,%esp
  80348b:	68 cc 43 80 00       	push   $0x8043cc
  803490:	68 5f 01 00 00       	push   $0x15f
  803495:	68 ef 43 80 00       	push   $0x8043ef
  80349a:	e8 fc d2 ff ff       	call   80079b <_panic>
  80349f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a8:	89 10                	mov    %edx,(%eax)
  8034aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ad:	8b 00                	mov    (%eax),%eax
  8034af:	85 c0                	test   %eax,%eax
  8034b1:	74 0d                	je     8034c0 <insert_sorted_with_merge_freeList+0x453>
  8034b3:	a1 48 51 80 00       	mov    0x805148,%eax
  8034b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034bb:	89 50 04             	mov    %edx,0x4(%eax)
  8034be:	eb 08                	jmp    8034c8 <insert_sorted_with_merge_freeList+0x45b>
  8034c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cb:	a3 48 51 80 00       	mov    %eax,0x805148
  8034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034da:	a1 54 51 80 00       	mov    0x805154,%eax
  8034df:	40                   	inc    %eax
  8034e0:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	8b 50 0c             	mov    0xc(%eax),%edx
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f1:	01 c2                	add    %eax,%edx
  8034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f6:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803503:	8b 45 08             	mov    0x8(%ebp),%eax
  803506:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80350d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803511:	75 17                	jne    80352a <insert_sorted_with_merge_freeList+0x4bd>
  803513:	83 ec 04             	sub    $0x4,%esp
  803516:	68 cc 43 80 00       	push   $0x8043cc
  80351b:	68 64 01 00 00       	push   $0x164
  803520:	68 ef 43 80 00       	push   $0x8043ef
  803525:	e8 71 d2 ff ff       	call   80079b <_panic>
  80352a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803530:	8b 45 08             	mov    0x8(%ebp),%eax
  803533:	89 10                	mov    %edx,(%eax)
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	8b 00                	mov    (%eax),%eax
  80353a:	85 c0                	test   %eax,%eax
  80353c:	74 0d                	je     80354b <insert_sorted_with_merge_freeList+0x4de>
  80353e:	a1 48 51 80 00       	mov    0x805148,%eax
  803543:	8b 55 08             	mov    0x8(%ebp),%edx
  803546:	89 50 04             	mov    %edx,0x4(%eax)
  803549:	eb 08                	jmp    803553 <insert_sorted_with_merge_freeList+0x4e6>
  80354b:	8b 45 08             	mov    0x8(%ebp),%eax
  80354e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803553:	8b 45 08             	mov    0x8(%ebp),%eax
  803556:	a3 48 51 80 00       	mov    %eax,0x805148
  80355b:	8b 45 08             	mov    0x8(%ebp),%eax
  80355e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803565:	a1 54 51 80 00       	mov    0x805154,%eax
  80356a:	40                   	inc    %eax
  80356b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803570:	e9 41 02 00 00       	jmp    8037b6 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803575:	8b 45 08             	mov    0x8(%ebp),%eax
  803578:	8b 50 08             	mov    0x8(%eax),%edx
  80357b:	8b 45 08             	mov    0x8(%ebp),%eax
  80357e:	8b 40 0c             	mov    0xc(%eax),%eax
  803581:	01 c2                	add    %eax,%edx
  803583:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803586:	8b 40 08             	mov    0x8(%eax),%eax
  803589:	39 c2                	cmp    %eax,%edx
  80358b:	0f 85 7c 01 00 00    	jne    80370d <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803591:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803595:	74 06                	je     80359d <insert_sorted_with_merge_freeList+0x530>
  803597:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80359b:	75 17                	jne    8035b4 <insert_sorted_with_merge_freeList+0x547>
  80359d:	83 ec 04             	sub    $0x4,%esp
  8035a0:	68 08 44 80 00       	push   $0x804408
  8035a5:	68 69 01 00 00       	push   $0x169
  8035aa:	68 ef 43 80 00       	push   $0x8043ef
  8035af:	e8 e7 d1 ff ff       	call   80079b <_panic>
  8035b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b7:	8b 50 04             	mov    0x4(%eax),%edx
  8035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bd:	89 50 04             	mov    %edx,0x4(%eax)
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035c6:	89 10                	mov    %edx,(%eax)
  8035c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035cb:	8b 40 04             	mov    0x4(%eax),%eax
  8035ce:	85 c0                	test   %eax,%eax
  8035d0:	74 0d                	je     8035df <insert_sorted_with_merge_freeList+0x572>
  8035d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d5:	8b 40 04             	mov    0x4(%eax),%eax
  8035d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8035db:	89 10                	mov    %edx,(%eax)
  8035dd:	eb 08                	jmp    8035e7 <insert_sorted_with_merge_freeList+0x57a>
  8035df:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e2:	a3 38 51 80 00       	mov    %eax,0x805138
  8035e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ed:	89 50 04             	mov    %edx,0x4(%eax)
  8035f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8035f5:	40                   	inc    %eax
  8035f6:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8035fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fe:	8b 50 0c             	mov    0xc(%eax),%edx
  803601:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803604:	8b 40 0c             	mov    0xc(%eax),%eax
  803607:	01 c2                	add    %eax,%edx
  803609:	8b 45 08             	mov    0x8(%ebp),%eax
  80360c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80360f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803613:	75 17                	jne    80362c <insert_sorted_with_merge_freeList+0x5bf>
  803615:	83 ec 04             	sub    $0x4,%esp
  803618:	68 98 44 80 00       	push   $0x804498
  80361d:	68 6b 01 00 00       	push   $0x16b
  803622:	68 ef 43 80 00       	push   $0x8043ef
  803627:	e8 6f d1 ff ff       	call   80079b <_panic>
  80362c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362f:	8b 00                	mov    (%eax),%eax
  803631:	85 c0                	test   %eax,%eax
  803633:	74 10                	je     803645 <insert_sorted_with_merge_freeList+0x5d8>
  803635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803638:	8b 00                	mov    (%eax),%eax
  80363a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80363d:	8b 52 04             	mov    0x4(%edx),%edx
  803640:	89 50 04             	mov    %edx,0x4(%eax)
  803643:	eb 0b                	jmp    803650 <insert_sorted_with_merge_freeList+0x5e3>
  803645:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803648:	8b 40 04             	mov    0x4(%eax),%eax
  80364b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803650:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803653:	8b 40 04             	mov    0x4(%eax),%eax
  803656:	85 c0                	test   %eax,%eax
  803658:	74 0f                	je     803669 <insert_sorted_with_merge_freeList+0x5fc>
  80365a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365d:	8b 40 04             	mov    0x4(%eax),%eax
  803660:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803663:	8b 12                	mov    (%edx),%edx
  803665:	89 10                	mov    %edx,(%eax)
  803667:	eb 0a                	jmp    803673 <insert_sorted_with_merge_freeList+0x606>
  803669:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366c:	8b 00                	mov    (%eax),%eax
  80366e:	a3 38 51 80 00       	mov    %eax,0x805138
  803673:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803676:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80367c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803686:	a1 44 51 80 00       	mov    0x805144,%eax
  80368b:	48                   	dec    %eax
  80368c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803691:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803694:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80369b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036a9:	75 17                	jne    8036c2 <insert_sorted_with_merge_freeList+0x655>
  8036ab:	83 ec 04             	sub    $0x4,%esp
  8036ae:	68 cc 43 80 00       	push   $0x8043cc
  8036b3:	68 6e 01 00 00       	push   $0x16e
  8036b8:	68 ef 43 80 00       	push   $0x8043ef
  8036bd:	e8 d9 d0 ff ff       	call   80079b <_panic>
  8036c2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cb:	89 10                	mov    %edx,(%eax)
  8036cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d0:	8b 00                	mov    (%eax),%eax
  8036d2:	85 c0                	test   %eax,%eax
  8036d4:	74 0d                	je     8036e3 <insert_sorted_with_merge_freeList+0x676>
  8036d6:	a1 48 51 80 00       	mov    0x805148,%eax
  8036db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036de:	89 50 04             	mov    %edx,0x4(%eax)
  8036e1:	eb 08                	jmp    8036eb <insert_sorted_with_merge_freeList+0x67e>
  8036e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ee:	a3 48 51 80 00       	mov    %eax,0x805148
  8036f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036fd:	a1 54 51 80 00       	mov    0x805154,%eax
  803702:	40                   	inc    %eax
  803703:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803708:	e9 a9 00 00 00       	jmp    8037b6 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80370d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803711:	74 06                	je     803719 <insert_sorted_with_merge_freeList+0x6ac>
  803713:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803717:	75 17                	jne    803730 <insert_sorted_with_merge_freeList+0x6c3>
  803719:	83 ec 04             	sub    $0x4,%esp
  80371c:	68 64 44 80 00       	push   $0x804464
  803721:	68 73 01 00 00       	push   $0x173
  803726:	68 ef 43 80 00       	push   $0x8043ef
  80372b:	e8 6b d0 ff ff       	call   80079b <_panic>
  803730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803733:	8b 10                	mov    (%eax),%edx
  803735:	8b 45 08             	mov    0x8(%ebp),%eax
  803738:	89 10                	mov    %edx,(%eax)
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	8b 00                	mov    (%eax),%eax
  80373f:	85 c0                	test   %eax,%eax
  803741:	74 0b                	je     80374e <insert_sorted_with_merge_freeList+0x6e1>
  803743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803746:	8b 00                	mov    (%eax),%eax
  803748:	8b 55 08             	mov    0x8(%ebp),%edx
  80374b:	89 50 04             	mov    %edx,0x4(%eax)
  80374e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803751:	8b 55 08             	mov    0x8(%ebp),%edx
  803754:	89 10                	mov    %edx,(%eax)
  803756:	8b 45 08             	mov    0x8(%ebp),%eax
  803759:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80375c:	89 50 04             	mov    %edx,0x4(%eax)
  80375f:	8b 45 08             	mov    0x8(%ebp),%eax
  803762:	8b 00                	mov    (%eax),%eax
  803764:	85 c0                	test   %eax,%eax
  803766:	75 08                	jne    803770 <insert_sorted_with_merge_freeList+0x703>
  803768:	8b 45 08             	mov    0x8(%ebp),%eax
  80376b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803770:	a1 44 51 80 00       	mov    0x805144,%eax
  803775:	40                   	inc    %eax
  803776:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80377b:	eb 39                	jmp    8037b6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80377d:	a1 40 51 80 00       	mov    0x805140,%eax
  803782:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803785:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803789:	74 07                	je     803792 <insert_sorted_with_merge_freeList+0x725>
  80378b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378e:	8b 00                	mov    (%eax),%eax
  803790:	eb 05                	jmp    803797 <insert_sorted_with_merge_freeList+0x72a>
  803792:	b8 00 00 00 00       	mov    $0x0,%eax
  803797:	a3 40 51 80 00       	mov    %eax,0x805140
  80379c:	a1 40 51 80 00       	mov    0x805140,%eax
  8037a1:	85 c0                	test   %eax,%eax
  8037a3:	0f 85 c7 fb ff ff    	jne    803370 <insert_sorted_with_merge_freeList+0x303>
  8037a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ad:	0f 85 bd fb ff ff    	jne    803370 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037b3:	eb 01                	jmp    8037b6 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037b5:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037b6:	90                   	nop
  8037b7:	c9                   	leave  
  8037b8:	c3                   	ret    
  8037b9:	66 90                	xchg   %ax,%ax
  8037bb:	90                   	nop

008037bc <__udivdi3>:
  8037bc:	55                   	push   %ebp
  8037bd:	57                   	push   %edi
  8037be:	56                   	push   %esi
  8037bf:	53                   	push   %ebx
  8037c0:	83 ec 1c             	sub    $0x1c,%esp
  8037c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037d3:	89 ca                	mov    %ecx,%edx
  8037d5:	89 f8                	mov    %edi,%eax
  8037d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037db:	85 f6                	test   %esi,%esi
  8037dd:	75 2d                	jne    80380c <__udivdi3+0x50>
  8037df:	39 cf                	cmp    %ecx,%edi
  8037e1:	77 65                	ja     803848 <__udivdi3+0x8c>
  8037e3:	89 fd                	mov    %edi,%ebp
  8037e5:	85 ff                	test   %edi,%edi
  8037e7:	75 0b                	jne    8037f4 <__udivdi3+0x38>
  8037e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8037ee:	31 d2                	xor    %edx,%edx
  8037f0:	f7 f7                	div    %edi
  8037f2:	89 c5                	mov    %eax,%ebp
  8037f4:	31 d2                	xor    %edx,%edx
  8037f6:	89 c8                	mov    %ecx,%eax
  8037f8:	f7 f5                	div    %ebp
  8037fa:	89 c1                	mov    %eax,%ecx
  8037fc:	89 d8                	mov    %ebx,%eax
  8037fe:	f7 f5                	div    %ebp
  803800:	89 cf                	mov    %ecx,%edi
  803802:	89 fa                	mov    %edi,%edx
  803804:	83 c4 1c             	add    $0x1c,%esp
  803807:	5b                   	pop    %ebx
  803808:	5e                   	pop    %esi
  803809:	5f                   	pop    %edi
  80380a:	5d                   	pop    %ebp
  80380b:	c3                   	ret    
  80380c:	39 ce                	cmp    %ecx,%esi
  80380e:	77 28                	ja     803838 <__udivdi3+0x7c>
  803810:	0f bd fe             	bsr    %esi,%edi
  803813:	83 f7 1f             	xor    $0x1f,%edi
  803816:	75 40                	jne    803858 <__udivdi3+0x9c>
  803818:	39 ce                	cmp    %ecx,%esi
  80381a:	72 0a                	jb     803826 <__udivdi3+0x6a>
  80381c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803820:	0f 87 9e 00 00 00    	ja     8038c4 <__udivdi3+0x108>
  803826:	b8 01 00 00 00       	mov    $0x1,%eax
  80382b:	89 fa                	mov    %edi,%edx
  80382d:	83 c4 1c             	add    $0x1c,%esp
  803830:	5b                   	pop    %ebx
  803831:	5e                   	pop    %esi
  803832:	5f                   	pop    %edi
  803833:	5d                   	pop    %ebp
  803834:	c3                   	ret    
  803835:	8d 76 00             	lea    0x0(%esi),%esi
  803838:	31 ff                	xor    %edi,%edi
  80383a:	31 c0                	xor    %eax,%eax
  80383c:	89 fa                	mov    %edi,%edx
  80383e:	83 c4 1c             	add    $0x1c,%esp
  803841:	5b                   	pop    %ebx
  803842:	5e                   	pop    %esi
  803843:	5f                   	pop    %edi
  803844:	5d                   	pop    %ebp
  803845:	c3                   	ret    
  803846:	66 90                	xchg   %ax,%ax
  803848:	89 d8                	mov    %ebx,%eax
  80384a:	f7 f7                	div    %edi
  80384c:	31 ff                	xor    %edi,%edi
  80384e:	89 fa                	mov    %edi,%edx
  803850:	83 c4 1c             	add    $0x1c,%esp
  803853:	5b                   	pop    %ebx
  803854:	5e                   	pop    %esi
  803855:	5f                   	pop    %edi
  803856:	5d                   	pop    %ebp
  803857:	c3                   	ret    
  803858:	bd 20 00 00 00       	mov    $0x20,%ebp
  80385d:	89 eb                	mov    %ebp,%ebx
  80385f:	29 fb                	sub    %edi,%ebx
  803861:	89 f9                	mov    %edi,%ecx
  803863:	d3 e6                	shl    %cl,%esi
  803865:	89 c5                	mov    %eax,%ebp
  803867:	88 d9                	mov    %bl,%cl
  803869:	d3 ed                	shr    %cl,%ebp
  80386b:	89 e9                	mov    %ebp,%ecx
  80386d:	09 f1                	or     %esi,%ecx
  80386f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803873:	89 f9                	mov    %edi,%ecx
  803875:	d3 e0                	shl    %cl,%eax
  803877:	89 c5                	mov    %eax,%ebp
  803879:	89 d6                	mov    %edx,%esi
  80387b:	88 d9                	mov    %bl,%cl
  80387d:	d3 ee                	shr    %cl,%esi
  80387f:	89 f9                	mov    %edi,%ecx
  803881:	d3 e2                	shl    %cl,%edx
  803883:	8b 44 24 08          	mov    0x8(%esp),%eax
  803887:	88 d9                	mov    %bl,%cl
  803889:	d3 e8                	shr    %cl,%eax
  80388b:	09 c2                	or     %eax,%edx
  80388d:	89 d0                	mov    %edx,%eax
  80388f:	89 f2                	mov    %esi,%edx
  803891:	f7 74 24 0c          	divl   0xc(%esp)
  803895:	89 d6                	mov    %edx,%esi
  803897:	89 c3                	mov    %eax,%ebx
  803899:	f7 e5                	mul    %ebp
  80389b:	39 d6                	cmp    %edx,%esi
  80389d:	72 19                	jb     8038b8 <__udivdi3+0xfc>
  80389f:	74 0b                	je     8038ac <__udivdi3+0xf0>
  8038a1:	89 d8                	mov    %ebx,%eax
  8038a3:	31 ff                	xor    %edi,%edi
  8038a5:	e9 58 ff ff ff       	jmp    803802 <__udivdi3+0x46>
  8038aa:	66 90                	xchg   %ax,%ax
  8038ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038b0:	89 f9                	mov    %edi,%ecx
  8038b2:	d3 e2                	shl    %cl,%edx
  8038b4:	39 c2                	cmp    %eax,%edx
  8038b6:	73 e9                	jae    8038a1 <__udivdi3+0xe5>
  8038b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038bb:	31 ff                	xor    %edi,%edi
  8038bd:	e9 40 ff ff ff       	jmp    803802 <__udivdi3+0x46>
  8038c2:	66 90                	xchg   %ax,%ax
  8038c4:	31 c0                	xor    %eax,%eax
  8038c6:	e9 37 ff ff ff       	jmp    803802 <__udivdi3+0x46>
  8038cb:	90                   	nop

008038cc <__umoddi3>:
  8038cc:	55                   	push   %ebp
  8038cd:	57                   	push   %edi
  8038ce:	56                   	push   %esi
  8038cf:	53                   	push   %ebx
  8038d0:	83 ec 1c             	sub    $0x1c,%esp
  8038d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038eb:	89 f3                	mov    %esi,%ebx
  8038ed:	89 fa                	mov    %edi,%edx
  8038ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038f3:	89 34 24             	mov    %esi,(%esp)
  8038f6:	85 c0                	test   %eax,%eax
  8038f8:	75 1a                	jne    803914 <__umoddi3+0x48>
  8038fa:	39 f7                	cmp    %esi,%edi
  8038fc:	0f 86 a2 00 00 00    	jbe    8039a4 <__umoddi3+0xd8>
  803902:	89 c8                	mov    %ecx,%eax
  803904:	89 f2                	mov    %esi,%edx
  803906:	f7 f7                	div    %edi
  803908:	89 d0                	mov    %edx,%eax
  80390a:	31 d2                	xor    %edx,%edx
  80390c:	83 c4 1c             	add    $0x1c,%esp
  80390f:	5b                   	pop    %ebx
  803910:	5e                   	pop    %esi
  803911:	5f                   	pop    %edi
  803912:	5d                   	pop    %ebp
  803913:	c3                   	ret    
  803914:	39 f0                	cmp    %esi,%eax
  803916:	0f 87 ac 00 00 00    	ja     8039c8 <__umoddi3+0xfc>
  80391c:	0f bd e8             	bsr    %eax,%ebp
  80391f:	83 f5 1f             	xor    $0x1f,%ebp
  803922:	0f 84 ac 00 00 00    	je     8039d4 <__umoddi3+0x108>
  803928:	bf 20 00 00 00       	mov    $0x20,%edi
  80392d:	29 ef                	sub    %ebp,%edi
  80392f:	89 fe                	mov    %edi,%esi
  803931:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803935:	89 e9                	mov    %ebp,%ecx
  803937:	d3 e0                	shl    %cl,%eax
  803939:	89 d7                	mov    %edx,%edi
  80393b:	89 f1                	mov    %esi,%ecx
  80393d:	d3 ef                	shr    %cl,%edi
  80393f:	09 c7                	or     %eax,%edi
  803941:	89 e9                	mov    %ebp,%ecx
  803943:	d3 e2                	shl    %cl,%edx
  803945:	89 14 24             	mov    %edx,(%esp)
  803948:	89 d8                	mov    %ebx,%eax
  80394a:	d3 e0                	shl    %cl,%eax
  80394c:	89 c2                	mov    %eax,%edx
  80394e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803952:	d3 e0                	shl    %cl,%eax
  803954:	89 44 24 04          	mov    %eax,0x4(%esp)
  803958:	8b 44 24 08          	mov    0x8(%esp),%eax
  80395c:	89 f1                	mov    %esi,%ecx
  80395e:	d3 e8                	shr    %cl,%eax
  803960:	09 d0                	or     %edx,%eax
  803962:	d3 eb                	shr    %cl,%ebx
  803964:	89 da                	mov    %ebx,%edx
  803966:	f7 f7                	div    %edi
  803968:	89 d3                	mov    %edx,%ebx
  80396a:	f7 24 24             	mull   (%esp)
  80396d:	89 c6                	mov    %eax,%esi
  80396f:	89 d1                	mov    %edx,%ecx
  803971:	39 d3                	cmp    %edx,%ebx
  803973:	0f 82 87 00 00 00    	jb     803a00 <__umoddi3+0x134>
  803979:	0f 84 91 00 00 00    	je     803a10 <__umoddi3+0x144>
  80397f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803983:	29 f2                	sub    %esi,%edx
  803985:	19 cb                	sbb    %ecx,%ebx
  803987:	89 d8                	mov    %ebx,%eax
  803989:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80398d:	d3 e0                	shl    %cl,%eax
  80398f:	89 e9                	mov    %ebp,%ecx
  803991:	d3 ea                	shr    %cl,%edx
  803993:	09 d0                	or     %edx,%eax
  803995:	89 e9                	mov    %ebp,%ecx
  803997:	d3 eb                	shr    %cl,%ebx
  803999:	89 da                	mov    %ebx,%edx
  80399b:	83 c4 1c             	add    $0x1c,%esp
  80399e:	5b                   	pop    %ebx
  80399f:	5e                   	pop    %esi
  8039a0:	5f                   	pop    %edi
  8039a1:	5d                   	pop    %ebp
  8039a2:	c3                   	ret    
  8039a3:	90                   	nop
  8039a4:	89 fd                	mov    %edi,%ebp
  8039a6:	85 ff                	test   %edi,%edi
  8039a8:	75 0b                	jne    8039b5 <__umoddi3+0xe9>
  8039aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8039af:	31 d2                	xor    %edx,%edx
  8039b1:	f7 f7                	div    %edi
  8039b3:	89 c5                	mov    %eax,%ebp
  8039b5:	89 f0                	mov    %esi,%eax
  8039b7:	31 d2                	xor    %edx,%edx
  8039b9:	f7 f5                	div    %ebp
  8039bb:	89 c8                	mov    %ecx,%eax
  8039bd:	f7 f5                	div    %ebp
  8039bf:	89 d0                	mov    %edx,%eax
  8039c1:	e9 44 ff ff ff       	jmp    80390a <__umoddi3+0x3e>
  8039c6:	66 90                	xchg   %ax,%ax
  8039c8:	89 c8                	mov    %ecx,%eax
  8039ca:	89 f2                	mov    %esi,%edx
  8039cc:	83 c4 1c             	add    $0x1c,%esp
  8039cf:	5b                   	pop    %ebx
  8039d0:	5e                   	pop    %esi
  8039d1:	5f                   	pop    %edi
  8039d2:	5d                   	pop    %ebp
  8039d3:	c3                   	ret    
  8039d4:	3b 04 24             	cmp    (%esp),%eax
  8039d7:	72 06                	jb     8039df <__umoddi3+0x113>
  8039d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039dd:	77 0f                	ja     8039ee <__umoddi3+0x122>
  8039df:	89 f2                	mov    %esi,%edx
  8039e1:	29 f9                	sub    %edi,%ecx
  8039e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039e7:	89 14 24             	mov    %edx,(%esp)
  8039ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039f2:	8b 14 24             	mov    (%esp),%edx
  8039f5:	83 c4 1c             	add    $0x1c,%esp
  8039f8:	5b                   	pop    %ebx
  8039f9:	5e                   	pop    %esi
  8039fa:	5f                   	pop    %edi
  8039fb:	5d                   	pop    %ebp
  8039fc:	c3                   	ret    
  8039fd:	8d 76 00             	lea    0x0(%esi),%esi
  803a00:	2b 04 24             	sub    (%esp),%eax
  803a03:	19 fa                	sbb    %edi,%edx
  803a05:	89 d1                	mov    %edx,%ecx
  803a07:	89 c6                	mov    %eax,%esi
  803a09:	e9 71 ff ff ff       	jmp    80397f <__umoddi3+0xb3>
  803a0e:	66 90                	xchg   %ax,%ax
  803a10:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a14:	72 ea                	jb     803a00 <__umoddi3+0x134>
  803a16:	89 d9                	mov    %ebx,%ecx
  803a18:	e9 62 ff ff ff       	jmp    80397f <__umoddi3+0xb3>
