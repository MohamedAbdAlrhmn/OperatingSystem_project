
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
  800062:	68 80 3b 80 00       	push   $0x803b80
  800067:	e8 e3 09 00 00       	call   800a4f <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 ca 1c 00 00       	call   801d3e <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 62 1d 00 00       	call   801dde <sys_pf_calculate_allocated_pages>
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
  8000ab:	68 a4 3b 80 00       	push   $0x803ba4
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 d4 3b 80 00       	push   $0x803bd4
  8000b7:	e8 df 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 7a 1c 00 00       	call   801d3e <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 ec 3b 80 00       	push   $0x803bec
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 d4 3b 80 00       	push   $0x803bd4
  8000dc:	e8 ba 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 f8 1c 00 00       	call   801dde <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 58 3c 80 00       	push   $0x803c58
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 d4 3b 80 00       	push   $0x803bd4
  8000fd:	e8 99 06 00 00       	call   80079b <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 37 1c 00 00       	call   801d3e <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 cf 1c 00 00       	call   801dde <sys_pf_calculate_allocated_pages>
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
  800156:	68 a4 3b 80 00       	push   $0x803ba4
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 d4 3b 80 00       	push   $0x803bd4
  800162:	e8 34 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 d2 1b 00 00       	call   801d3e <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 ec 3b 80 00       	push   $0x803bec
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 d4 3b 80 00       	push   $0x803bd4
  800184:	e8 12 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 50 1c 00 00       	call   801dde <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 58 3c 80 00       	push   $0x803c58
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 d4 3b 80 00       	push   $0x803bd4
  8001a5:	e8 f1 05 00 00       	call   80079b <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 8f 1b 00 00       	call   801d3e <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 27 1c 00 00       	call   801dde <sys_pf_calculate_allocated_pages>
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
  800201:	68 a4 3b 80 00       	push   $0x803ba4
  800206:	6a 23                	push   $0x23
  800208:	68 d4 3b 80 00       	push   $0x803bd4
  80020d:	e8 89 05 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 27 1b 00 00       	call   801d3e <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 ec 3b 80 00       	push   $0x803bec
  800228:	6a 25                	push   $0x25
  80022a:	68 d4 3b 80 00       	push   $0x803bd4
  80022f:	e8 67 05 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 a5 1b 00 00       	call   801dde <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 58 3c 80 00       	push   $0x803c58
  800249:	6a 26                	push   $0x26
  80024b:	68 d4 3b 80 00       	push   $0x803bd4
  800250:	e8 46 05 00 00       	call   80079b <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 e4 1a 00 00       	call   801d3e <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 7c 1b 00 00       	call   801dde <sys_pf_calculate_allocated_pages>
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
  8002a8:	68 a4 3b 80 00       	push   $0x803ba4
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 d4 3b 80 00       	push   $0x803bd4
  8002b4:	e8 e2 04 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 80 1a 00 00       	call   801d3e <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 ec 3b 80 00       	push   $0x803bec
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 d4 3b 80 00       	push   $0x803bd4
  8002d6:	e8 c0 04 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 fe 1a 00 00       	call   801dde <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 58 3c 80 00       	push   $0x803c58
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 d4 3b 80 00       	push   $0x803bd4
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
  800422:	e8 17 19 00 00       	call   801d3e <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 af 19 00 00       	call   801dde <sys_pf_calculate_allocated_pages>
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
  800450:	e8 67 17 00 00       	call   801bbc <realloc>
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
  800478:	68 88 3c 80 00       	push   $0x803c88
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 d4 3b 80 00       	push   $0x803bd4
  800484:	e8 12 03 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 50 19 00 00       	call   801dde <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 bc 3c 80 00       	push   $0x803cbc
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 d4 3b 80 00       	push   $0x803bd4
  8004a5:	e8 f1 02 00 00       	call   80079b <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 ed 3c 80 00       	push   $0x803ced
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
  800501:	68 f4 3c 80 00       	push   $0x803cf4
  800506:	6a 7a                	push   $0x7a
  800508:	68 d4 3b 80 00       	push   $0x803bd4
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
  800559:	68 f4 3c 80 00       	push   $0x803cf4
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 d4 3b 80 00       	push   $0x803bd4
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
  8005bb:	68 f4 3c 80 00       	push   $0x803cf4
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 d4 3b 80 00       	push   $0x803bd4
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
  800616:	68 f4 3c 80 00       	push   $0x803cf4
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 d4 3b 80 00       	push   $0x803bd4
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
  80063a:	68 2c 3d 80 00       	push   $0x803d2c
  80063f:	e8 a0 03 00 00       	call   8009e4 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 38 3d 80 00       	push   $0x803d38
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
  800665:	e8 b4 19 00 00       	call   80201e <sys_getenvindex>
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
  8006d0:	e8 56 17 00 00       	call   801e2b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	68 8c 3d 80 00       	push   $0x803d8c
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
  800700:	68 b4 3d 80 00       	push   $0x803db4
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
  800731:	68 dc 3d 80 00       	push   $0x803ddc
  800736:	e8 14 03 00 00       	call   800a4f <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073e:	a1 20 50 80 00       	mov    0x805020,%eax
  800743:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	50                   	push   %eax
  80074d:	68 34 3e 80 00       	push   $0x803e34
  800752:	e8 f8 02 00 00       	call   800a4f <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	68 8c 3d 80 00       	push   $0x803d8c
  800762:	e8 e8 02 00 00       	call   800a4f <cprintf>
  800767:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80076a:	e8 d6 16 00 00       	call   801e45 <sys_enable_interrupt>

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
  800782:	e8 63 18 00 00       	call   801fea <sys_destroy_env>
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
  800793:	e8 b8 18 00 00       	call   802050 <sys_exit_env>
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
  8007bc:	68 48 3e 80 00       	push   $0x803e48
  8007c1:	e8 89 02 00 00       	call   800a4f <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c9:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	68 4d 3e 80 00       	push   $0x803e4d
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
  8007f9:	68 69 3e 80 00       	push   $0x803e69
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
  800825:	68 6c 3e 80 00       	push   $0x803e6c
  80082a:	6a 26                	push   $0x26
  80082c:	68 b8 3e 80 00       	push   $0x803eb8
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
  8008f7:	68 c4 3e 80 00       	push   $0x803ec4
  8008fc:	6a 3a                	push   $0x3a
  8008fe:	68 b8 3e 80 00       	push   $0x803eb8
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
  800967:	68 18 3f 80 00       	push   $0x803f18
  80096c:	6a 44                	push   $0x44
  80096e:	68 b8 3e 80 00       	push   $0x803eb8
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
  8009c1:	e8 b7 12 00 00       	call   801c7d <sys_cputs>
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
  800a38:	e8 40 12 00 00       	call   801c7d <sys_cputs>
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
  800a82:	e8 a4 13 00 00       	call   801e2b <sys_disable_interrupt>
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
  800aa2:	e8 9e 13 00 00       	call   801e45 <sys_enable_interrupt>
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
  800aec:	e8 0f 2e 00 00       	call   803900 <__udivdi3>
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
  800b3c:	e8 cf 2e 00 00       	call   803a10 <__umoddi3>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	05 94 41 80 00       	add    $0x804194,%eax
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
  800c97:	8b 04 85 b8 41 80 00 	mov    0x8041b8(,%eax,4),%eax
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
  800d78:	8b 34 9d 00 40 80 00 	mov    0x804000(,%ebx,4),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 19                	jne    800d9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d83:	53                   	push   %ebx
  800d84:	68 a5 41 80 00       	push   $0x8041a5
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
  800d9d:	68 ae 41 80 00       	push   $0x8041ae
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
  800dca:	be b1 41 80 00       	mov    $0x8041b1,%esi
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
  8017f0:	68 10 43 80 00       	push   $0x804310
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8018a3:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8018aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018b2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018b7:	83 ec 04             	sub    $0x4,%esp
  8018ba:	6a 06                	push   $0x6
  8018bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8018bf:	50                   	push   %eax
  8018c0:	e8 fc 04 00 00       	call   801dc1 <sys_allocate_chunk>
  8018c5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018c8:	a1 20 51 80 00       	mov    0x805120,%eax
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	50                   	push   %eax
  8018d1:	e8 71 0b 00 00       	call   802447 <initialize_MemBlocksList>
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
  8018fe:	68 35 43 80 00       	push   $0x804335
  801903:	6a 33                	push   $0x33
  801905:	68 53 43 80 00       	push   $0x804353
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
  80197d:	68 60 43 80 00       	push   $0x804360
  801982:	6a 34                	push   $0x34
  801984:	68 53 43 80 00       	push   $0x804353
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
  8019da:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019dd:	e8 f7 fd ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  8019e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019e6:	75 07                	jne    8019ef <malloc+0x18>
  8019e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ed:	eb 61                	jmp    801a50 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8019ef:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fc:	01 d0                	add    %edx,%eax
  8019fe:	48                   	dec    %eax
  8019ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a05:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0a:	f7 75 f0             	divl   -0x10(%ebp)
  801a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a10:	29 d0                	sub    %edx,%eax
  801a12:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a15:	e8 75 07 00 00       	call   80218f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	74 11                	je     801a2f <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	ff 75 e8             	pushl  -0x18(%ebp)
  801a24:	e8 e0 0d 00 00       	call   802809 <alloc_block_FF>
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a33:	74 16                	je     801a4b <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801a35:	83 ec 0c             	sub    $0xc,%esp
  801a38:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3b:	e8 3c 0b 00 00       	call   80257c <insert_sorted_allocList>
  801a40:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a46:	8b 40 08             	mov    0x8(%eax),%eax
  801a49:	eb 05                	jmp    801a50 <malloc+0x79>
	}

    return NULL;
  801a4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801a58:	83 ec 04             	sub    $0x4,%esp
  801a5b:	68 84 43 80 00       	push   $0x804384
  801a60:	6a 6f                	push   $0x6f
  801a62:	68 53 43 80 00       	push   $0x804353
  801a67:	e8 2f ed ff ff       	call   80079b <_panic>

00801a6c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 38             	sub    $0x38,%esp
  801a72:	8b 45 10             	mov    0x10(%ebp),%eax
  801a75:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a78:	e8 5c fd ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a81:	75 0a                	jne    801a8d <smalloc+0x21>
  801a83:	b8 00 00 00 00       	mov    $0x0,%eax
  801a88:	e9 8b 00 00 00       	jmp    801b18 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a8d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9a:	01 d0                	add    %edx,%eax
  801a9c:	48                   	dec    %eax
  801a9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa3:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa8:	f7 75 f0             	divl   -0x10(%ebp)
  801aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aae:	29 d0                	sub    %edx,%eax
  801ab0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801ab3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801aba:	e8 d0 06 00 00       	call   80218f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	74 11                	je     801ad4 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801ac3:	83 ec 0c             	sub    $0xc,%esp
  801ac6:	ff 75 e8             	pushl  -0x18(%ebp)
  801ac9:	e8 3b 0d 00 00       	call   802809 <alloc_block_FF>
  801ace:	83 c4 10             	add    $0x10,%esp
  801ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801ad4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ad8:	74 39                	je     801b13 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801add:	8b 40 08             	mov    0x8(%eax),%eax
  801ae0:	89 c2                	mov    %eax,%edx
  801ae2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ae6:	52                   	push   %edx
  801ae7:	50                   	push   %eax
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	ff 75 08             	pushl  0x8(%ebp)
  801aee:	e8 21 04 00 00       	call   801f14 <sys_createSharedObject>
  801af3:	83 c4 10             	add    $0x10,%esp
  801af6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801af9:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801afd:	74 14                	je     801b13 <smalloc+0xa7>
  801aff:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801b03:	74 0e                	je     801b13 <smalloc+0xa7>
  801b05:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801b09:	74 08                	je     801b13 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0e:	8b 40 08             	mov    0x8(%eax),%eax
  801b11:	eb 05                	jmp    801b18 <smalloc+0xac>
	}
	return NULL;
  801b13:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b20:	e8 b4 fc ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b25:	83 ec 08             	sub    $0x8,%esp
  801b28:	ff 75 0c             	pushl  0xc(%ebp)
  801b2b:	ff 75 08             	pushl  0x8(%ebp)
  801b2e:	e8 0b 04 00 00       	call   801f3e <sys_getSizeOfSharedObject>
  801b33:	83 c4 10             	add    $0x10,%esp
  801b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801b39:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801b3d:	74 76                	je     801bb5 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801b3f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b4c:	01 d0                	add    %edx,%eax
  801b4e:	48                   	dec    %eax
  801b4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b55:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5a:	f7 75 ec             	divl   -0x14(%ebp)
  801b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b60:	29 d0                	sub    %edx,%eax
  801b62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b6c:	e8 1e 06 00 00       	call   80218f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b71:	85 c0                	test   %eax,%eax
  801b73:	74 11                	je     801b86 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801b75:	83 ec 0c             	sub    $0xc,%esp
  801b78:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b7b:	e8 89 0c 00 00       	call   802809 <alloc_block_FF>
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801b86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b8a:	74 29                	je     801bb5 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8f:	8b 40 08             	mov    0x8(%eax),%eax
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	50                   	push   %eax
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	e8 ba 03 00 00       	call   801f5b <sys_getSharedObject>
  801ba1:	83 c4 10             	add    $0x10,%esp
  801ba4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801ba7:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801bab:	74 08                	je     801bb5 <sget+0x9b>
				return (void *)mem_block->sva;
  801bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb0:	8b 40 08             	mov    0x8(%eax),%eax
  801bb3:	eb 05                	jmp    801bba <sget+0xa0>
		}
	}
	return (void *)NULL;
  801bb5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bc2:	e8 12 fc ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	68 a8 43 80 00       	push   $0x8043a8
  801bcf:	68 f1 00 00 00       	push   $0xf1
  801bd4:	68 53 43 80 00       	push   $0x804353
  801bd9:	e8 bd eb ff ff       	call   80079b <_panic>

00801bde <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	68 d0 43 80 00       	push   $0x8043d0
  801bec:	68 05 01 00 00       	push   $0x105
  801bf1:	68 53 43 80 00       	push   $0x804353
  801bf6:	e8 a0 eb ff ff       	call   80079b <_panic>

00801bfb <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c01:	83 ec 04             	sub    $0x4,%esp
  801c04:	68 f4 43 80 00       	push   $0x8043f4
  801c09:	68 10 01 00 00       	push   $0x110
  801c0e:	68 53 43 80 00       	push   $0x804353
  801c13:	e8 83 eb ff ff       	call   80079b <_panic>

00801c18 <shrink>:

}
void shrink(uint32 newSize)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c1e:	83 ec 04             	sub    $0x4,%esp
  801c21:	68 f4 43 80 00       	push   $0x8043f4
  801c26:	68 15 01 00 00       	push   $0x115
  801c2b:	68 53 43 80 00       	push   $0x804353
  801c30:	e8 66 eb ff ff       	call   80079b <_panic>

00801c35 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c3b:	83 ec 04             	sub    $0x4,%esp
  801c3e:	68 f4 43 80 00       	push   $0x8043f4
  801c43:	68 1a 01 00 00       	push   $0x11a
  801c48:	68 53 43 80 00       	push   $0x804353
  801c4d:	e8 49 eb ff ff       	call   80079b <_panic>

00801c52 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	57                   	push   %edi
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c61:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c64:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c67:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c6a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c6d:	cd 30                	int    $0x30
  801c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c75:	83 c4 10             	add    $0x10,%esp
  801c78:	5b                   	pop    %ebx
  801c79:	5e                   	pop    %esi
  801c7a:	5f                   	pop    %edi
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    

00801c7d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	8b 45 10             	mov    0x10(%ebp),%eax
  801c86:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c89:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	52                   	push   %edx
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	50                   	push   %eax
  801c99:	6a 00                	push   $0x0
  801c9b:	e8 b2 ff ff ff       	call   801c52 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	90                   	nop
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 01                	push   $0x1
  801cb5:	e8 98 ff ff ff       	call   801c52 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	52                   	push   %edx
  801ccf:	50                   	push   %eax
  801cd0:	6a 05                	push   $0x5
  801cd2:	e8 7b ff ff ff       	call   801c52 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	56                   	push   %esi
  801ce0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ce1:	8b 75 18             	mov    0x18(%ebp),%esi
  801ce4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	56                   	push   %esi
  801cf1:	53                   	push   %ebx
  801cf2:	51                   	push   %ecx
  801cf3:	52                   	push   %edx
  801cf4:	50                   	push   %eax
  801cf5:	6a 06                	push   $0x6
  801cf7:	e8 56 ff ff ff       	call   801c52 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d02:	5b                   	pop    %ebx
  801d03:	5e                   	pop    %esi
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    

00801d06 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	52                   	push   %edx
  801d16:	50                   	push   %eax
  801d17:	6a 07                	push   $0x7
  801d19:	e8 34 ff ff ff       	call   801c52 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	ff 75 0c             	pushl  0xc(%ebp)
  801d2f:	ff 75 08             	pushl  0x8(%ebp)
  801d32:	6a 08                	push   $0x8
  801d34:	e8 19 ff ff ff       	call   801c52 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 09                	push   $0x9
  801d4d:	e8 00 ff ff ff       	call   801c52 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 0a                	push   $0xa
  801d66:	e8 e7 fe ff ff       	call   801c52 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 0b                	push   $0xb
  801d7f:	e8 ce fe ff ff       	call   801c52 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	ff 75 08             	pushl  0x8(%ebp)
  801d98:	6a 0f                	push   $0xf
  801d9a:	e8 b3 fe ff ff       	call   801c52 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
	return;
  801da2:	90                   	nop
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	ff 75 0c             	pushl  0xc(%ebp)
  801db1:	ff 75 08             	pushl  0x8(%ebp)
  801db4:	6a 10                	push   $0x10
  801db6:	e8 97 fe ff ff       	call   801c52 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbe:	90                   	nop
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	ff 75 10             	pushl  0x10(%ebp)
  801dcb:	ff 75 0c             	pushl  0xc(%ebp)
  801dce:	ff 75 08             	pushl  0x8(%ebp)
  801dd1:	6a 11                	push   $0x11
  801dd3:	e8 7a fe ff ff       	call   801c52 <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddb:	90                   	nop
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 0c                	push   $0xc
  801ded:	e8 60 fe ff ff       	call   801c52 <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	ff 75 08             	pushl  0x8(%ebp)
  801e05:	6a 0d                	push   $0xd
  801e07:	e8 46 fe ff ff       	call   801c52 <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 0e                	push   $0xe
  801e20:	e8 2d fe ff ff       	call   801c52 <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
}
  801e28:	90                   	nop
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 13                	push   $0x13
  801e3a:	e8 13 fe ff ff       	call   801c52 <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
}
  801e42:	90                   	nop
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 14                	push   $0x14
  801e54:	e8 f9 fd ff ff       	call   801c52 <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
}
  801e5c:	90                   	nop
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_cputc>:


void
sys_cputc(const char c)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e6b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	50                   	push   %eax
  801e78:	6a 15                	push   $0x15
  801e7a:	e8 d3 fd ff ff       	call   801c52 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
}
  801e82:	90                   	nop
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 16                	push   $0x16
  801e94:	e8 b9 fd ff ff       	call   801c52 <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
}
  801e9c:	90                   	nop
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	ff 75 0c             	pushl  0xc(%ebp)
  801eae:	50                   	push   %eax
  801eaf:	6a 17                	push   $0x17
  801eb1:	e8 9c fd ff ff       	call   801c52 <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ebe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	52                   	push   %edx
  801ecb:	50                   	push   %eax
  801ecc:	6a 1a                	push   $0x1a
  801ece:	e8 7f fd ff ff       	call   801c52 <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	52                   	push   %edx
  801ee8:	50                   	push   %eax
  801ee9:	6a 18                	push   $0x18
  801eeb:	e8 62 fd ff ff       	call   801c52 <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	90                   	nop
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	52                   	push   %edx
  801f06:	50                   	push   %eax
  801f07:	6a 19                	push   $0x19
  801f09:	e8 44 fd ff ff       	call   801c52 <syscall>
  801f0e:	83 c4 18             	add    $0x18,%esp
}
  801f11:	90                   	nop
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 04             	sub    $0x4,%esp
  801f1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f20:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f23:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	6a 00                	push   $0x0
  801f2c:	51                   	push   %ecx
  801f2d:	52                   	push   %edx
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	50                   	push   %eax
  801f32:	6a 1b                	push   $0x1b
  801f34:	e8 19 fd ff ff       	call   801c52 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	52                   	push   %edx
  801f4e:	50                   	push   %eax
  801f4f:	6a 1c                	push   $0x1c
  801f51:	e8 fc fc ff ff       	call   801c52 <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	51                   	push   %ecx
  801f6c:	52                   	push   %edx
  801f6d:	50                   	push   %eax
  801f6e:	6a 1d                	push   $0x1d
  801f70:	e8 dd fc ff ff       	call   801c52 <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	52                   	push   %edx
  801f8a:	50                   	push   %eax
  801f8b:	6a 1e                	push   $0x1e
  801f8d:	e8 c0 fc ff ff       	call   801c52 <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 1f                	push   $0x1f
  801fa6:	e8 a7 fc ff ff       	call   801c52 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	6a 00                	push   $0x0
  801fb8:	ff 75 14             	pushl  0x14(%ebp)
  801fbb:	ff 75 10             	pushl  0x10(%ebp)
  801fbe:	ff 75 0c             	pushl  0xc(%ebp)
  801fc1:	50                   	push   %eax
  801fc2:	6a 20                	push   $0x20
  801fc4:	e8 89 fc ff ff       	call   801c52 <syscall>
  801fc9:	83 c4 18             	add    $0x18,%esp
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	50                   	push   %eax
  801fdd:	6a 21                	push   $0x21
  801fdf:	e8 6e fc ff ff       	call   801c52 <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
}
  801fe7:	90                   	nop
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	50                   	push   %eax
  801ff9:	6a 22                	push   $0x22
  801ffb:	e8 52 fc ff ff       	call   801c52 <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 02                	push   $0x2
  802014:	e8 39 fc ff ff       	call   801c52 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 03                	push   $0x3
  80202d:	e8 20 fc ff ff       	call   801c52 <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 04                	push   $0x4
  802046:	e8 07 fc ff ff       	call   801c52 <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_exit_env>:


void sys_exit_env(void)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 23                	push   $0x23
  80205f:	e8 ee fb ff ff       	call   801c52 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
}
  802067:	90                   	nop
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802070:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802073:	8d 50 04             	lea    0x4(%eax),%edx
  802076:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	52                   	push   %edx
  802080:	50                   	push   %eax
  802081:	6a 24                	push   $0x24
  802083:	e8 ca fb ff ff       	call   801c52 <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
	return result;
  80208b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80208e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802091:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802094:	89 01                	mov    %eax,(%ecx)
  802096:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	c9                   	leave  
  80209d:	c2 04 00             	ret    $0x4

008020a0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	ff 75 10             	pushl  0x10(%ebp)
  8020aa:	ff 75 0c             	pushl  0xc(%ebp)
  8020ad:	ff 75 08             	pushl  0x8(%ebp)
  8020b0:	6a 12                	push   $0x12
  8020b2:	e8 9b fb ff ff       	call   801c52 <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ba:	90                   	nop
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sys_rcr2>:
uint32 sys_rcr2()
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 25                	push   $0x25
  8020cc:	e8 81 fb ff ff       	call   801c52 <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 04             	sub    $0x4,%esp
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020e2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	50                   	push   %eax
  8020ef:	6a 26                	push   $0x26
  8020f1:	e8 5c fb ff ff       	call   801c52 <syscall>
  8020f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f9:	90                   	nop
}
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <rsttst>:
void rsttst()
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 28                	push   $0x28
  80210b:	e8 42 fb ff ff       	call   801c52 <syscall>
  802110:	83 c4 18             	add    $0x18,%esp
	return ;
  802113:	90                   	nop
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 04             	sub    $0x4,%esp
  80211c:	8b 45 14             	mov    0x14(%ebp),%eax
  80211f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802122:	8b 55 18             	mov    0x18(%ebp),%edx
  802125:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802129:	52                   	push   %edx
  80212a:	50                   	push   %eax
  80212b:	ff 75 10             	pushl  0x10(%ebp)
  80212e:	ff 75 0c             	pushl  0xc(%ebp)
  802131:	ff 75 08             	pushl  0x8(%ebp)
  802134:	6a 27                	push   $0x27
  802136:	e8 17 fb ff ff       	call   801c52 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
	return ;
  80213e:	90                   	nop
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <chktst>:
void chktst(uint32 n)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	ff 75 08             	pushl  0x8(%ebp)
  80214f:	6a 29                	push   $0x29
  802151:	e8 fc fa ff ff       	call   801c52 <syscall>
  802156:	83 c4 18             	add    $0x18,%esp
	return ;
  802159:	90                   	nop
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <inctst>:

void inctst()
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 2a                	push   $0x2a
  80216b:	e8 e2 fa ff ff       	call   801c52 <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
	return ;
  802173:	90                   	nop
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <gettst>:
uint32 gettst()
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 2b                	push   $0x2b
  802185:	e8 c8 fa ff ff       	call   801c52 <syscall>
  80218a:	83 c4 18             	add    $0x18,%esp
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 2c                	push   $0x2c
  8021a1:	e8 ac fa ff ff       	call   801c52 <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
  8021a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021ac:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021b0:	75 07                	jne    8021b9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b7:	eb 05                	jmp    8021be <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 2c                	push   $0x2c
  8021d2:	e8 7b fa ff ff       	call   801c52 <syscall>
  8021d7:	83 c4 18             	add    $0x18,%esp
  8021da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021dd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021e1:	75 07                	jne    8021ea <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e8:	eb 05                	jmp    8021ef <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 2c                	push   $0x2c
  802203:	e8 4a fa ff ff       	call   801c52 <syscall>
  802208:	83 c4 18             	add    $0x18,%esp
  80220b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80220e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802212:	75 07                	jne    80221b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802214:	b8 01 00 00 00       	mov    $0x1,%eax
  802219:	eb 05                	jmp    802220 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80221b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 2c                	push   $0x2c
  802234:	e8 19 fa ff ff       	call   801c52 <syscall>
  802239:	83 c4 18             	add    $0x18,%esp
  80223c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80223f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802243:	75 07                	jne    80224c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802245:	b8 01 00 00 00       	mov    $0x1,%eax
  80224a:	eb 05                	jmp    802251 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80224c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	ff 75 08             	pushl  0x8(%ebp)
  802261:	6a 2d                	push   $0x2d
  802263:	e8 ea f9 ff ff       	call   801c52 <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
	return ;
  80226b:	90                   	nop
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802272:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802275:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802278:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	6a 00                	push   $0x0
  802280:	53                   	push   %ebx
  802281:	51                   	push   %ecx
  802282:	52                   	push   %edx
  802283:	50                   	push   %eax
  802284:	6a 2e                	push   $0x2e
  802286:	e8 c7 f9 ff ff       	call   801c52 <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802296:	8b 55 0c             	mov    0xc(%ebp),%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	52                   	push   %edx
  8022a3:	50                   	push   %eax
  8022a4:	6a 2f                	push   $0x2f
  8022a6:	e8 a7 f9 ff ff       	call   801c52 <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022b6:	83 ec 0c             	sub    $0xc,%esp
  8022b9:	68 04 44 80 00       	push   $0x804404
  8022be:	e8 8c e7 ff ff       	call   800a4f <cprintf>
  8022c3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022cd:	83 ec 0c             	sub    $0xc,%esp
  8022d0:	68 30 44 80 00       	push   $0x804430
  8022d5:	e8 75 e7 ff ff       	call   800a4f <cprintf>
  8022da:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022dd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8022e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e9:	eb 56                	jmp    802341 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022ef:	74 1c                	je     80230d <print_mem_block_lists+0x5d>
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 50 08             	mov    0x8(%eax),%edx
  8022f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fa:	8b 48 08             	mov    0x8(%eax),%ecx
  8022fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802300:	8b 40 0c             	mov    0xc(%eax),%eax
  802303:	01 c8                	add    %ecx,%eax
  802305:	39 c2                	cmp    %eax,%edx
  802307:	73 04                	jae    80230d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802309:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8b 50 08             	mov    0x8(%eax),%edx
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 40 0c             	mov    0xc(%eax),%eax
  802319:	01 c2                	add    %eax,%edx
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 40 08             	mov    0x8(%eax),%eax
  802321:	83 ec 04             	sub    $0x4,%esp
  802324:	52                   	push   %edx
  802325:	50                   	push   %eax
  802326:	68 45 44 80 00       	push   $0x804445
  80232b:	e8 1f e7 ff ff       	call   800a4f <cprintf>
  802330:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802339:	a1 40 51 80 00       	mov    0x805140,%eax
  80233e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802341:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802345:	74 07                	je     80234e <print_mem_block_lists+0x9e>
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 00                	mov    (%eax),%eax
  80234c:	eb 05                	jmp    802353 <print_mem_block_lists+0xa3>
  80234e:	b8 00 00 00 00       	mov    $0x0,%eax
  802353:	a3 40 51 80 00       	mov    %eax,0x805140
  802358:	a1 40 51 80 00       	mov    0x805140,%eax
  80235d:	85 c0                	test   %eax,%eax
  80235f:	75 8a                	jne    8022eb <print_mem_block_lists+0x3b>
  802361:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802365:	75 84                	jne    8022eb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802367:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80236b:	75 10                	jne    80237d <print_mem_block_lists+0xcd>
  80236d:	83 ec 0c             	sub    $0xc,%esp
  802370:	68 54 44 80 00       	push   $0x804454
  802375:	e8 d5 e6 ff ff       	call   800a4f <cprintf>
  80237a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80237d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802384:	83 ec 0c             	sub    $0xc,%esp
  802387:	68 78 44 80 00       	push   $0x804478
  80238c:	e8 be e6 ff ff       	call   800a4f <cprintf>
  802391:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802394:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802398:	a1 40 50 80 00       	mov    0x805040,%eax
  80239d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a0:	eb 56                	jmp    8023f8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023a6:	74 1c                	je     8023c4 <print_mem_block_lists+0x114>
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 50 08             	mov    0x8(%eax),%edx
  8023ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b1:	8b 48 08             	mov    0x8(%eax),%ecx
  8023b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ba:	01 c8                	add    %ecx,%eax
  8023bc:	39 c2                	cmp    %eax,%edx
  8023be:	73 04                	jae    8023c4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023c0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 50 08             	mov    0x8(%eax),%edx
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d0:	01 c2                	add    %eax,%edx
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 40 08             	mov    0x8(%eax),%eax
  8023d8:	83 ec 04             	sub    $0x4,%esp
  8023db:	52                   	push   %edx
  8023dc:	50                   	push   %eax
  8023dd:	68 45 44 80 00       	push   $0x804445
  8023e2:	e8 68 e6 ff ff       	call   800a4f <cprintf>
  8023e7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023f0:	a1 48 50 80 00       	mov    0x805048,%eax
  8023f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fc:	74 07                	je     802405 <print_mem_block_lists+0x155>
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	eb 05                	jmp    80240a <print_mem_block_lists+0x15a>
  802405:	b8 00 00 00 00       	mov    $0x0,%eax
  80240a:	a3 48 50 80 00       	mov    %eax,0x805048
  80240f:	a1 48 50 80 00       	mov    0x805048,%eax
  802414:	85 c0                	test   %eax,%eax
  802416:	75 8a                	jne    8023a2 <print_mem_block_lists+0xf2>
  802418:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241c:	75 84                	jne    8023a2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80241e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802422:	75 10                	jne    802434 <print_mem_block_lists+0x184>
  802424:	83 ec 0c             	sub    $0xc,%esp
  802427:	68 90 44 80 00       	push   $0x804490
  80242c:	e8 1e e6 ff ff       	call   800a4f <cprintf>
  802431:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802434:	83 ec 0c             	sub    $0xc,%esp
  802437:	68 04 44 80 00       	push   $0x804404
  80243c:	e8 0e e6 ff ff       	call   800a4f <cprintf>
  802441:	83 c4 10             	add    $0x10,%esp

}
  802444:	90                   	nop
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80244d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802454:	00 00 00 
  802457:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80245e:	00 00 00 
  802461:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802468:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80246b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802472:	e9 9e 00 00 00       	jmp    802515 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802477:	a1 50 50 80 00       	mov    0x805050,%eax
  80247c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247f:	c1 e2 04             	shl    $0x4,%edx
  802482:	01 d0                	add    %edx,%eax
  802484:	85 c0                	test   %eax,%eax
  802486:	75 14                	jne    80249c <initialize_MemBlocksList+0x55>
  802488:	83 ec 04             	sub    $0x4,%esp
  80248b:	68 b8 44 80 00       	push   $0x8044b8
  802490:	6a 46                	push   $0x46
  802492:	68 db 44 80 00       	push   $0x8044db
  802497:	e8 ff e2 ff ff       	call   80079b <_panic>
  80249c:	a1 50 50 80 00       	mov    0x805050,%eax
  8024a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a4:	c1 e2 04             	shl    $0x4,%edx
  8024a7:	01 d0                	add    %edx,%eax
  8024a9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024af:	89 10                	mov    %edx,(%eax)
  8024b1:	8b 00                	mov    (%eax),%eax
  8024b3:	85 c0                	test   %eax,%eax
  8024b5:	74 18                	je     8024cf <initialize_MemBlocksList+0x88>
  8024b7:	a1 48 51 80 00       	mov    0x805148,%eax
  8024bc:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024c2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024c5:	c1 e1 04             	shl    $0x4,%ecx
  8024c8:	01 ca                	add    %ecx,%edx
  8024ca:	89 50 04             	mov    %edx,0x4(%eax)
  8024cd:	eb 12                	jmp    8024e1 <initialize_MemBlocksList+0x9a>
  8024cf:	a1 50 50 80 00       	mov    0x805050,%eax
  8024d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d7:	c1 e2 04             	shl    $0x4,%edx
  8024da:	01 d0                	add    %edx,%eax
  8024dc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024e1:	a1 50 50 80 00       	mov    0x805050,%eax
  8024e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e9:	c1 e2 04             	shl    $0x4,%edx
  8024ec:	01 d0                	add    %edx,%eax
  8024ee:	a3 48 51 80 00       	mov    %eax,0x805148
  8024f3:	a1 50 50 80 00       	mov    0x805050,%eax
  8024f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fb:	c1 e2 04             	shl    $0x4,%edx
  8024fe:	01 d0                	add    %edx,%eax
  802500:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802507:	a1 54 51 80 00       	mov    0x805154,%eax
  80250c:	40                   	inc    %eax
  80250d:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802512:	ff 45 f4             	incl   -0xc(%ebp)
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251b:	0f 82 56 ff ff ff    	jb     802477 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802521:	90                   	nop
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	8b 00                	mov    (%eax),%eax
  80252f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802532:	eb 19                	jmp    80254d <find_block+0x29>
	{
		if(va==point->sva)
  802534:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802537:	8b 40 08             	mov    0x8(%eax),%eax
  80253a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80253d:	75 05                	jne    802544 <find_block+0x20>
		   return point;
  80253f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802542:	eb 36                	jmp    80257a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	8b 40 08             	mov    0x8(%eax),%eax
  80254a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80254d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802551:	74 07                	je     80255a <find_block+0x36>
  802553:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802556:	8b 00                	mov    (%eax),%eax
  802558:	eb 05                	jmp    80255f <find_block+0x3b>
  80255a:	b8 00 00 00 00       	mov    $0x0,%eax
  80255f:	8b 55 08             	mov    0x8(%ebp),%edx
  802562:	89 42 08             	mov    %eax,0x8(%edx)
  802565:	8b 45 08             	mov    0x8(%ebp),%eax
  802568:	8b 40 08             	mov    0x8(%eax),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	75 c5                	jne    802534 <find_block+0x10>
  80256f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802573:	75 bf                	jne    802534 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802575:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80257a:	c9                   	leave  
  80257b:	c3                   	ret    

0080257c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80257c:	55                   	push   %ebp
  80257d:	89 e5                	mov    %esp,%ebp
  80257f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802582:	a1 40 50 80 00       	mov    0x805040,%eax
  802587:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80258a:	a1 44 50 80 00       	mov    0x805044,%eax
  80258f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802595:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802598:	74 24                	je     8025be <insert_sorted_allocList+0x42>
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	8b 50 08             	mov    0x8(%eax),%edx
  8025a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a3:	8b 40 08             	mov    0x8(%eax),%eax
  8025a6:	39 c2                	cmp    %eax,%edx
  8025a8:	76 14                	jbe    8025be <insert_sorted_allocList+0x42>
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	8b 50 08             	mov    0x8(%eax),%edx
  8025b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b3:	8b 40 08             	mov    0x8(%eax),%eax
  8025b6:	39 c2                	cmp    %eax,%edx
  8025b8:	0f 82 60 01 00 00    	jb     80271e <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8025be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c2:	75 65                	jne    802629 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8025c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025c8:	75 14                	jne    8025de <insert_sorted_allocList+0x62>
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	68 b8 44 80 00       	push   $0x8044b8
  8025d2:	6a 6b                	push   $0x6b
  8025d4:	68 db 44 80 00       	push   $0x8044db
  8025d9:	e8 bd e1 ff ff       	call   80079b <_panic>
  8025de:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	89 10                	mov    %edx,(%eax)
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	8b 00                	mov    (%eax),%eax
  8025ee:	85 c0                	test   %eax,%eax
  8025f0:	74 0d                	je     8025ff <insert_sorted_allocList+0x83>
  8025f2:	a1 40 50 80 00       	mov    0x805040,%eax
  8025f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025fa:	89 50 04             	mov    %edx,0x4(%eax)
  8025fd:	eb 08                	jmp    802607 <insert_sorted_allocList+0x8b>
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802602:	a3 44 50 80 00       	mov    %eax,0x805044
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	a3 40 50 80 00       	mov    %eax,0x805040
  80260f:	8b 45 08             	mov    0x8(%ebp),%eax
  802612:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802619:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80261e:	40                   	inc    %eax
  80261f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802624:	e9 dc 01 00 00       	jmp    802805 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	8b 50 08             	mov    0x8(%eax),%edx
  80262f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802632:	8b 40 08             	mov    0x8(%eax),%eax
  802635:	39 c2                	cmp    %eax,%edx
  802637:	77 6c                	ja     8026a5 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802639:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80263d:	74 06                	je     802645 <insert_sorted_allocList+0xc9>
  80263f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802643:	75 14                	jne    802659 <insert_sorted_allocList+0xdd>
  802645:	83 ec 04             	sub    $0x4,%esp
  802648:	68 f4 44 80 00       	push   $0x8044f4
  80264d:	6a 6f                	push   $0x6f
  80264f:	68 db 44 80 00       	push   $0x8044db
  802654:	e8 42 e1 ff ff       	call   80079b <_panic>
  802659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265c:	8b 50 04             	mov    0x4(%eax),%edx
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	89 50 04             	mov    %edx,0x4(%eax)
  802665:	8b 45 08             	mov    0x8(%ebp),%eax
  802668:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80266b:	89 10                	mov    %edx,(%eax)
  80266d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802670:	8b 40 04             	mov    0x4(%eax),%eax
  802673:	85 c0                	test   %eax,%eax
  802675:	74 0d                	je     802684 <insert_sorted_allocList+0x108>
  802677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267a:	8b 40 04             	mov    0x4(%eax),%eax
  80267d:	8b 55 08             	mov    0x8(%ebp),%edx
  802680:	89 10                	mov    %edx,(%eax)
  802682:	eb 08                	jmp    80268c <insert_sorted_allocList+0x110>
  802684:	8b 45 08             	mov    0x8(%ebp),%eax
  802687:	a3 40 50 80 00       	mov    %eax,0x805040
  80268c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268f:	8b 55 08             	mov    0x8(%ebp),%edx
  802692:	89 50 04             	mov    %edx,0x4(%eax)
  802695:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80269a:	40                   	inc    %eax
  80269b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026a0:	e9 60 01 00 00       	jmp    802805 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8026a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a8:	8b 50 08             	mov    0x8(%eax),%edx
  8026ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ae:	8b 40 08             	mov    0x8(%eax),%eax
  8026b1:	39 c2                	cmp    %eax,%edx
  8026b3:	0f 82 4c 01 00 00    	jb     802805 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8026b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026bd:	75 14                	jne    8026d3 <insert_sorted_allocList+0x157>
  8026bf:	83 ec 04             	sub    $0x4,%esp
  8026c2:	68 2c 45 80 00       	push   $0x80452c
  8026c7:	6a 73                	push   $0x73
  8026c9:	68 db 44 80 00       	push   $0x8044db
  8026ce:	e8 c8 e0 ff ff       	call   80079b <_panic>
  8026d3:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	89 50 04             	mov    %edx,0x4(%eax)
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	8b 40 04             	mov    0x4(%eax),%eax
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	74 0c                	je     8026f5 <insert_sorted_allocList+0x179>
  8026e9:	a1 44 50 80 00       	mov    0x805044,%eax
  8026ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f1:	89 10                	mov    %edx,(%eax)
  8026f3:	eb 08                	jmp    8026fd <insert_sorted_allocList+0x181>
  8026f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f8:	a3 40 50 80 00       	mov    %eax,0x805040
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	a3 44 50 80 00       	mov    %eax,0x805044
  802705:	8b 45 08             	mov    0x8(%ebp),%eax
  802708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802713:	40                   	inc    %eax
  802714:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802719:	e9 e7 00 00 00       	jmp    802805 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80271e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802721:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802724:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80272b:	a1 40 50 80 00       	mov    0x805040,%eax
  802730:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802733:	e9 9d 00 00 00       	jmp    8027d5 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802740:	8b 45 08             	mov    0x8(%ebp),%eax
  802743:	8b 50 08             	mov    0x8(%eax),%edx
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 40 08             	mov    0x8(%eax),%eax
  80274c:	39 c2                	cmp    %eax,%edx
  80274e:	76 7d                	jbe    8027cd <insert_sorted_allocList+0x251>
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	8b 50 08             	mov    0x8(%eax),%edx
  802756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802759:	8b 40 08             	mov    0x8(%eax),%eax
  80275c:	39 c2                	cmp    %eax,%edx
  80275e:	73 6d                	jae    8027cd <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802760:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802764:	74 06                	je     80276c <insert_sorted_allocList+0x1f0>
  802766:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80276a:	75 14                	jne    802780 <insert_sorted_allocList+0x204>
  80276c:	83 ec 04             	sub    $0x4,%esp
  80276f:	68 50 45 80 00       	push   $0x804550
  802774:	6a 7f                	push   $0x7f
  802776:	68 db 44 80 00       	push   $0x8044db
  80277b:	e8 1b e0 ff ff       	call   80079b <_panic>
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 10                	mov    (%eax),%edx
  802785:	8b 45 08             	mov    0x8(%ebp),%eax
  802788:	89 10                	mov    %edx,(%eax)
  80278a:	8b 45 08             	mov    0x8(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	85 c0                	test   %eax,%eax
  802791:	74 0b                	je     80279e <insert_sorted_allocList+0x222>
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	8b 55 08             	mov    0x8(%ebp),%edx
  80279b:	89 50 04             	mov    %edx,0x4(%eax)
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a4:	89 10                	mov    %edx,(%eax)
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ac:	89 50 04             	mov    %edx,0x4(%eax)
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	75 08                	jne    8027c0 <insert_sorted_allocList+0x244>
  8027b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bb:	a3 44 50 80 00       	mov    %eax,0x805044
  8027c0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027c5:	40                   	inc    %eax
  8027c6:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8027cb:	eb 39                	jmp    802806 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8027cd:	a1 48 50 80 00       	mov    0x805048,%eax
  8027d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d9:	74 07                	je     8027e2 <insert_sorted_allocList+0x266>
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	eb 05                	jmp    8027e7 <insert_sorted_allocList+0x26b>
  8027e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e7:	a3 48 50 80 00       	mov    %eax,0x805048
  8027ec:	a1 48 50 80 00       	mov    0x805048,%eax
  8027f1:	85 c0                	test   %eax,%eax
  8027f3:	0f 85 3f ff ff ff    	jne    802738 <insert_sorted_allocList+0x1bc>
  8027f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fd:	0f 85 35 ff ff ff    	jne    802738 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802803:	eb 01                	jmp    802806 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802805:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802806:	90                   	nop
  802807:	c9                   	leave  
  802808:	c3                   	ret    

00802809 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
  80280c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80280f:	a1 38 51 80 00       	mov    0x805138,%eax
  802814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802817:	e9 85 01 00 00       	jmp    8029a1 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 40 0c             	mov    0xc(%eax),%eax
  802822:	3b 45 08             	cmp    0x8(%ebp),%eax
  802825:	0f 82 6e 01 00 00    	jb     802999 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 40 0c             	mov    0xc(%eax),%eax
  802831:	3b 45 08             	cmp    0x8(%ebp),%eax
  802834:	0f 85 8a 00 00 00    	jne    8028c4 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80283a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283e:	75 17                	jne    802857 <alloc_block_FF+0x4e>
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	68 84 45 80 00       	push   $0x804584
  802848:	68 93 00 00 00       	push   $0x93
  80284d:	68 db 44 80 00       	push   $0x8044db
  802852:	e8 44 df ff ff       	call   80079b <_panic>
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 00                	mov    (%eax),%eax
  80285c:	85 c0                	test   %eax,%eax
  80285e:	74 10                	je     802870 <alloc_block_FF+0x67>
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 00                	mov    (%eax),%eax
  802865:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802868:	8b 52 04             	mov    0x4(%edx),%edx
  80286b:	89 50 04             	mov    %edx,0x4(%eax)
  80286e:	eb 0b                	jmp    80287b <alloc_block_FF+0x72>
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	8b 40 04             	mov    0x4(%eax),%eax
  802876:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 40 04             	mov    0x4(%eax),%eax
  802881:	85 c0                	test   %eax,%eax
  802883:	74 0f                	je     802894 <alloc_block_FF+0x8b>
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 40 04             	mov    0x4(%eax),%eax
  80288b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288e:	8b 12                	mov    (%edx),%edx
  802890:	89 10                	mov    %edx,(%eax)
  802892:	eb 0a                	jmp    80289e <alloc_block_FF+0x95>
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 00                	mov    (%eax),%eax
  802899:	a3 38 51 80 00       	mov    %eax,0x805138
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b1:	a1 44 51 80 00       	mov    0x805144,%eax
  8028b6:	48                   	dec    %eax
  8028b7:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	e9 10 01 00 00       	jmp    8029d4 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028cd:	0f 86 c6 00 00 00    	jbe    802999 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028d3:	a1 48 51 80 00       	mov    0x805148,%eax
  8028d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 50 08             	mov    0x8(%eax),%edx
  8028e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e4:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8028e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ed:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028f4:	75 17                	jne    80290d <alloc_block_FF+0x104>
  8028f6:	83 ec 04             	sub    $0x4,%esp
  8028f9:	68 84 45 80 00       	push   $0x804584
  8028fe:	68 9b 00 00 00       	push   $0x9b
  802903:	68 db 44 80 00       	push   $0x8044db
  802908:	e8 8e de ff ff       	call   80079b <_panic>
  80290d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	74 10                	je     802926 <alloc_block_FF+0x11d>
  802916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802919:	8b 00                	mov    (%eax),%eax
  80291b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291e:	8b 52 04             	mov    0x4(%edx),%edx
  802921:	89 50 04             	mov    %edx,0x4(%eax)
  802924:	eb 0b                	jmp    802931 <alloc_block_FF+0x128>
  802926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802929:	8b 40 04             	mov    0x4(%eax),%eax
  80292c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802934:	8b 40 04             	mov    0x4(%eax),%eax
  802937:	85 c0                	test   %eax,%eax
  802939:	74 0f                	je     80294a <alloc_block_FF+0x141>
  80293b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293e:	8b 40 04             	mov    0x4(%eax),%eax
  802941:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802944:	8b 12                	mov    (%edx),%edx
  802946:	89 10                	mov    %edx,(%eax)
  802948:	eb 0a                	jmp    802954 <alloc_block_FF+0x14b>
  80294a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	a3 48 51 80 00       	mov    %eax,0x805148
  802954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802960:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802967:	a1 54 51 80 00       	mov    0x805154,%eax
  80296c:	48                   	dec    %eax
  80296d:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 50 08             	mov    0x8(%eax),%edx
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	01 c2                	add    %eax,%edx
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 40 0c             	mov    0xc(%eax),%eax
  802989:	2b 45 08             	sub    0x8(%ebp),%eax
  80298c:	89 c2                	mov    %eax,%edx
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802997:	eb 3b                	jmp    8029d4 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802999:	a1 40 51 80 00       	mov    0x805140,%eax
  80299e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a5:	74 07                	je     8029ae <alloc_block_FF+0x1a5>
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 00                	mov    (%eax),%eax
  8029ac:	eb 05                	jmp    8029b3 <alloc_block_FF+0x1aa>
  8029ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b3:	a3 40 51 80 00       	mov    %eax,0x805140
  8029b8:	a1 40 51 80 00       	mov    0x805140,%eax
  8029bd:	85 c0                	test   %eax,%eax
  8029bf:	0f 85 57 fe ff ff    	jne    80281c <alloc_block_FF+0x13>
  8029c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c9:	0f 85 4d fe ff ff    	jne    80281c <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8029cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029d4:	c9                   	leave  
  8029d5:	c3                   	ret    

008029d6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8029d6:	55                   	push   %ebp
  8029d7:	89 e5                	mov    %esp,%ebp
  8029d9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8029dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029e3:	a1 38 51 80 00       	mov    0x805138,%eax
  8029e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029eb:	e9 df 00 00 00       	jmp    802acf <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f9:	0f 82 c8 00 00 00    	jb     802ac7 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 40 0c             	mov    0xc(%eax),%eax
  802a05:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a08:	0f 85 8a 00 00 00    	jne    802a98 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802a0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a12:	75 17                	jne    802a2b <alloc_block_BF+0x55>
  802a14:	83 ec 04             	sub    $0x4,%esp
  802a17:	68 84 45 80 00       	push   $0x804584
  802a1c:	68 b7 00 00 00       	push   $0xb7
  802a21:	68 db 44 80 00       	push   $0x8044db
  802a26:	e8 70 dd ff ff       	call   80079b <_panic>
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 00                	mov    (%eax),%eax
  802a30:	85 c0                	test   %eax,%eax
  802a32:	74 10                	je     802a44 <alloc_block_BF+0x6e>
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 00                	mov    (%eax),%eax
  802a39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3c:	8b 52 04             	mov    0x4(%edx),%edx
  802a3f:	89 50 04             	mov    %edx,0x4(%eax)
  802a42:	eb 0b                	jmp    802a4f <alloc_block_BF+0x79>
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	8b 40 04             	mov    0x4(%eax),%eax
  802a4a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a52:	8b 40 04             	mov    0x4(%eax),%eax
  802a55:	85 c0                	test   %eax,%eax
  802a57:	74 0f                	je     802a68 <alloc_block_BF+0x92>
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 40 04             	mov    0x4(%eax),%eax
  802a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a62:	8b 12                	mov    (%edx),%edx
  802a64:	89 10                	mov    %edx,(%eax)
  802a66:	eb 0a                	jmp    802a72 <alloc_block_BF+0x9c>
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 00                	mov    (%eax),%eax
  802a6d:	a3 38 51 80 00       	mov    %eax,0x805138
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a85:	a1 44 51 80 00       	mov    0x805144,%eax
  802a8a:	48                   	dec    %eax
  802a8b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	e9 4d 01 00 00       	jmp    802be5 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa1:	76 24                	jbe    802ac7 <alloc_block_BF+0xf1>
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802aac:	73 19                	jae    802ac7 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802aae:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 40 0c             	mov    0xc(%eax),%eax
  802abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 40 08             	mov    0x8(%eax),%eax
  802ac4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ac7:	a1 40 51 80 00       	mov    0x805140,%eax
  802acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802acf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad3:	74 07                	je     802adc <alloc_block_BF+0x106>
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	eb 05                	jmp    802ae1 <alloc_block_BF+0x10b>
  802adc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae1:	a3 40 51 80 00       	mov    %eax,0x805140
  802ae6:	a1 40 51 80 00       	mov    0x805140,%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	0f 85 fd fe ff ff    	jne    8029f0 <alloc_block_BF+0x1a>
  802af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af7:	0f 85 f3 fe ff ff    	jne    8029f0 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802afd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b01:	0f 84 d9 00 00 00    	je     802be0 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b07:	a1 48 51 80 00       	mov    0x805148,%eax
  802b0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b12:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b15:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1e:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802b21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b25:	75 17                	jne    802b3e <alloc_block_BF+0x168>
  802b27:	83 ec 04             	sub    $0x4,%esp
  802b2a:	68 84 45 80 00       	push   $0x804584
  802b2f:	68 c7 00 00 00       	push   $0xc7
  802b34:	68 db 44 80 00       	push   $0x8044db
  802b39:	e8 5d dc ff ff       	call   80079b <_panic>
  802b3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	74 10                	je     802b57 <alloc_block_BF+0x181>
  802b47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b4f:	8b 52 04             	mov    0x4(%edx),%edx
  802b52:	89 50 04             	mov    %edx,0x4(%eax)
  802b55:	eb 0b                	jmp    802b62 <alloc_block_BF+0x18c>
  802b57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b5a:	8b 40 04             	mov    0x4(%eax),%eax
  802b5d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b65:	8b 40 04             	mov    0x4(%eax),%eax
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	74 0f                	je     802b7b <alloc_block_BF+0x1a5>
  802b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6f:	8b 40 04             	mov    0x4(%eax),%eax
  802b72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b75:	8b 12                	mov    (%edx),%edx
  802b77:	89 10                	mov    %edx,(%eax)
  802b79:	eb 0a                	jmp    802b85 <alloc_block_BF+0x1af>
  802b7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	a3 48 51 80 00       	mov    %eax,0x805148
  802b85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b98:	a1 54 51 80 00       	mov    0x805154,%eax
  802b9d:	48                   	dec    %eax
  802b9e:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802ba3:	83 ec 08             	sub    $0x8,%esp
  802ba6:	ff 75 ec             	pushl  -0x14(%ebp)
  802ba9:	68 38 51 80 00       	push   $0x805138
  802bae:	e8 71 f9 ff ff       	call   802524 <find_block>
  802bb3:	83 c4 10             	add    $0x10,%esp
  802bb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802bb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bbc:	8b 50 08             	mov    0x8(%eax),%edx
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	01 c2                	add    %eax,%edx
  802bc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc7:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802bca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd0:	2b 45 08             	sub    0x8(%ebp),%eax
  802bd3:	89 c2                	mov    %eax,%edx
  802bd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd8:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bde:	eb 05                	jmp    802be5 <alloc_block_BF+0x20f>
	}
	return NULL;
  802be0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be5:	c9                   	leave  
  802be6:	c3                   	ret    

00802be7 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802be7:	55                   	push   %ebp
  802be8:	89 e5                	mov    %esp,%ebp
  802bea:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802bed:	a1 28 50 80 00       	mov    0x805028,%eax
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	0f 85 de 01 00 00    	jne    802dd8 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802bfa:	a1 38 51 80 00       	mov    0x805138,%eax
  802bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c02:	e9 9e 01 00 00       	jmp    802da5 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c10:	0f 82 87 01 00 00    	jb     802d9d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1f:	0f 85 95 00 00 00    	jne    802cba <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c29:	75 17                	jne    802c42 <alloc_block_NF+0x5b>
  802c2b:	83 ec 04             	sub    $0x4,%esp
  802c2e:	68 84 45 80 00       	push   $0x804584
  802c33:	68 e0 00 00 00       	push   $0xe0
  802c38:	68 db 44 80 00       	push   $0x8044db
  802c3d:	e8 59 db ff ff       	call   80079b <_panic>
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 00                	mov    (%eax),%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	74 10                	je     802c5b <alloc_block_NF+0x74>
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c53:	8b 52 04             	mov    0x4(%edx),%edx
  802c56:	89 50 04             	mov    %edx,0x4(%eax)
  802c59:	eb 0b                	jmp    802c66 <alloc_block_NF+0x7f>
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 40 04             	mov    0x4(%eax),%eax
  802c61:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 40 04             	mov    0x4(%eax),%eax
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	74 0f                	je     802c7f <alloc_block_NF+0x98>
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 40 04             	mov    0x4(%eax),%eax
  802c76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c79:	8b 12                	mov    (%edx),%edx
  802c7b:	89 10                	mov    %edx,(%eax)
  802c7d:	eb 0a                	jmp    802c89 <alloc_block_NF+0xa2>
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	8b 00                	mov    (%eax),%eax
  802c84:	a3 38 51 80 00       	mov    %eax,0x805138
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9c:	a1 44 51 80 00       	mov    0x805144,%eax
  802ca1:	48                   	dec    %eax
  802ca2:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 40 08             	mov    0x8(%eax),%eax
  802cad:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	e9 f8 04 00 00       	jmp    8031b2 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc3:	0f 86 d4 00 00 00    	jbe    802d9d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cc9:	a1 48 51 80 00       	mov    0x805148,%eax
  802cce:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 50 08             	mov    0x8(%eax),%edx
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce3:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ce6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cea:	75 17                	jne    802d03 <alloc_block_NF+0x11c>
  802cec:	83 ec 04             	sub    $0x4,%esp
  802cef:	68 84 45 80 00       	push   $0x804584
  802cf4:	68 e9 00 00 00       	push   $0xe9
  802cf9:	68 db 44 80 00       	push   $0x8044db
  802cfe:	e8 98 da ff ff       	call   80079b <_panic>
  802d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d06:	8b 00                	mov    (%eax),%eax
  802d08:	85 c0                	test   %eax,%eax
  802d0a:	74 10                	je     802d1c <alloc_block_NF+0x135>
  802d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0f:	8b 00                	mov    (%eax),%eax
  802d11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d14:	8b 52 04             	mov    0x4(%edx),%edx
  802d17:	89 50 04             	mov    %edx,0x4(%eax)
  802d1a:	eb 0b                	jmp    802d27 <alloc_block_NF+0x140>
  802d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1f:	8b 40 04             	mov    0x4(%eax),%eax
  802d22:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2a:	8b 40 04             	mov    0x4(%eax),%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	74 0f                	je     802d40 <alloc_block_NF+0x159>
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	8b 40 04             	mov    0x4(%eax),%eax
  802d37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3a:	8b 12                	mov    (%edx),%edx
  802d3c:	89 10                	mov    %edx,(%eax)
  802d3e:	eb 0a                	jmp    802d4a <alloc_block_NF+0x163>
  802d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d43:	8b 00                	mov    (%eax),%eax
  802d45:	a3 48 51 80 00       	mov    %eax,0x805148
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5d:	a1 54 51 80 00       	mov    0x805154,%eax
  802d62:	48                   	dec    %eax
  802d63:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6b:	8b 40 08             	mov    0x8(%eax),%eax
  802d6e:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 50 08             	mov    0x8(%eax),%edx
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	01 c2                	add    %eax,%edx
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8a:	2b 45 08             	sub    0x8(%ebp),%eax
  802d8d:	89 c2                	mov    %eax,%edx
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d98:	e9 15 04 00 00       	jmp    8031b2 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d9d:	a1 40 51 80 00       	mov    0x805140,%eax
  802da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da9:	74 07                	je     802db2 <alloc_block_NF+0x1cb>
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 00                	mov    (%eax),%eax
  802db0:	eb 05                	jmp    802db7 <alloc_block_NF+0x1d0>
  802db2:	b8 00 00 00 00       	mov    $0x0,%eax
  802db7:	a3 40 51 80 00       	mov    %eax,0x805140
  802dbc:	a1 40 51 80 00       	mov    0x805140,%eax
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	0f 85 3e fe ff ff    	jne    802c07 <alloc_block_NF+0x20>
  802dc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dcd:	0f 85 34 fe ff ff    	jne    802c07 <alloc_block_NF+0x20>
  802dd3:	e9 d5 03 00 00       	jmp    8031ad <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dd8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de0:	e9 b1 01 00 00       	jmp    802f96 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 50 08             	mov    0x8(%eax),%edx
  802deb:	a1 28 50 80 00       	mov    0x805028,%eax
  802df0:	39 c2                	cmp    %eax,%edx
  802df2:	0f 82 96 01 00 00    	jb     802f8e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e01:	0f 82 87 01 00 00    	jb     802f8e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e10:	0f 85 95 00 00 00    	jne    802eab <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1a:	75 17                	jne    802e33 <alloc_block_NF+0x24c>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 84 45 80 00       	push   $0x804584
  802e24:	68 fc 00 00 00       	push   $0xfc
  802e29:	68 db 44 80 00       	push   $0x8044db
  802e2e:	e8 68 d9 ff ff       	call   80079b <_panic>
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	85 c0                	test   %eax,%eax
  802e3a:	74 10                	je     802e4c <alloc_block_NF+0x265>
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	8b 00                	mov    (%eax),%eax
  802e41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e44:	8b 52 04             	mov    0x4(%edx),%edx
  802e47:	89 50 04             	mov    %edx,0x4(%eax)
  802e4a:	eb 0b                	jmp    802e57 <alloc_block_NF+0x270>
  802e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4f:	8b 40 04             	mov    0x4(%eax),%eax
  802e52:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 0f                	je     802e70 <alloc_block_NF+0x289>
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6a:	8b 12                	mov    (%edx),%edx
  802e6c:	89 10                	mov    %edx,(%eax)
  802e6e:	eb 0a                	jmp    802e7a <alloc_block_NF+0x293>
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	a3 38 51 80 00       	mov    %eax,0x805138
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e92:	48                   	dec    %eax
  802e93:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 40 08             	mov    0x8(%eax),%eax
  802e9e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	e9 07 03 00 00       	jmp    8031b2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb4:	0f 86 d4 00 00 00    	jbe    802f8e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802eba:	a1 48 51 80 00       	mov    0x805148,%eax
  802ebf:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 50 08             	mov    0x8(%eax),%edx
  802ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ece:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ed7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802edb:	75 17                	jne    802ef4 <alloc_block_NF+0x30d>
  802edd:	83 ec 04             	sub    $0x4,%esp
  802ee0:	68 84 45 80 00       	push   $0x804584
  802ee5:	68 04 01 00 00       	push   $0x104
  802eea:	68 db 44 80 00       	push   $0x8044db
  802eef:	e8 a7 d8 ff ff       	call   80079b <_panic>
  802ef4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef7:	8b 00                	mov    (%eax),%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	74 10                	je     802f0d <alloc_block_NF+0x326>
  802efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f05:	8b 52 04             	mov    0x4(%edx),%edx
  802f08:	89 50 04             	mov    %edx,0x4(%eax)
  802f0b:	eb 0b                	jmp    802f18 <alloc_block_NF+0x331>
  802f0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f10:	8b 40 04             	mov    0x4(%eax),%eax
  802f13:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1b:	8b 40 04             	mov    0x4(%eax),%eax
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	74 0f                	je     802f31 <alloc_block_NF+0x34a>
  802f22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f2b:	8b 12                	mov    (%edx),%edx
  802f2d:	89 10                	mov    %edx,(%eax)
  802f2f:	eb 0a                	jmp    802f3b <alloc_block_NF+0x354>
  802f31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	a3 48 51 80 00       	mov    %eax,0x805148
  802f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4e:	a1 54 51 80 00       	mov    0x805154,%eax
  802f53:	48                   	dec    %eax
  802f54:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5c:	8b 40 08             	mov    0x8(%eax),%eax
  802f5f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 50 08             	mov    0x8(%eax),%edx
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	01 c2                	add    %eax,%edx
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7b:	2b 45 08             	sub    0x8(%ebp),%eax
  802f7e:	89 c2                	mov    %eax,%edx
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f89:	e9 24 02 00 00       	jmp    8031b2 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f8e:	a1 40 51 80 00       	mov    0x805140,%eax
  802f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9a:	74 07                	je     802fa3 <alloc_block_NF+0x3bc>
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	eb 05                	jmp    802fa8 <alloc_block_NF+0x3c1>
  802fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa8:	a3 40 51 80 00       	mov    %eax,0x805140
  802fad:	a1 40 51 80 00       	mov    0x805140,%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	0f 85 2b fe ff ff    	jne    802de5 <alloc_block_NF+0x1fe>
  802fba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fbe:	0f 85 21 fe ff ff    	jne    802de5 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fc4:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fcc:	e9 ae 01 00 00       	jmp    80317f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	8b 50 08             	mov    0x8(%eax),%edx
  802fd7:	a1 28 50 80 00       	mov    0x805028,%eax
  802fdc:	39 c2                	cmp    %eax,%edx
  802fde:	0f 83 93 01 00 00    	jae    803177 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fea:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fed:	0f 82 84 01 00 00    	jb     803177 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ffc:	0f 85 95 00 00 00    	jne    803097 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803002:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803006:	75 17                	jne    80301f <alloc_block_NF+0x438>
  803008:	83 ec 04             	sub    $0x4,%esp
  80300b:	68 84 45 80 00       	push   $0x804584
  803010:	68 14 01 00 00       	push   $0x114
  803015:	68 db 44 80 00       	push   $0x8044db
  80301a:	e8 7c d7 ff ff       	call   80079b <_panic>
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	8b 00                	mov    (%eax),%eax
  803024:	85 c0                	test   %eax,%eax
  803026:	74 10                	je     803038 <alloc_block_NF+0x451>
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	8b 00                	mov    (%eax),%eax
  80302d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803030:	8b 52 04             	mov    0x4(%edx),%edx
  803033:	89 50 04             	mov    %edx,0x4(%eax)
  803036:	eb 0b                	jmp    803043 <alloc_block_NF+0x45c>
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 40 04             	mov    0x4(%eax),%eax
  80303e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803046:	8b 40 04             	mov    0x4(%eax),%eax
  803049:	85 c0                	test   %eax,%eax
  80304b:	74 0f                	je     80305c <alloc_block_NF+0x475>
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	8b 40 04             	mov    0x4(%eax),%eax
  803053:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803056:	8b 12                	mov    (%edx),%edx
  803058:	89 10                	mov    %edx,(%eax)
  80305a:	eb 0a                	jmp    803066 <alloc_block_NF+0x47f>
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	a3 38 51 80 00       	mov    %eax,0x805138
  803066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803079:	a1 44 51 80 00       	mov    0x805144,%eax
  80307e:	48                   	dec    %eax
  80307f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 40 08             	mov    0x8(%eax),%eax
  80308a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	e9 1b 01 00 00       	jmp    8031b2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 40 0c             	mov    0xc(%eax),%eax
  80309d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030a0:	0f 86 d1 00 00 00    	jbe    803177 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b1:	8b 50 08             	mov    0x8(%eax),%edx
  8030b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030c7:	75 17                	jne    8030e0 <alloc_block_NF+0x4f9>
  8030c9:	83 ec 04             	sub    $0x4,%esp
  8030cc:	68 84 45 80 00       	push   $0x804584
  8030d1:	68 1c 01 00 00       	push   $0x11c
  8030d6:	68 db 44 80 00       	push   $0x8044db
  8030db:	e8 bb d6 ff ff       	call   80079b <_panic>
  8030e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e3:	8b 00                	mov    (%eax),%eax
  8030e5:	85 c0                	test   %eax,%eax
  8030e7:	74 10                	je     8030f9 <alloc_block_NF+0x512>
  8030e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ec:	8b 00                	mov    (%eax),%eax
  8030ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030f1:	8b 52 04             	mov    0x4(%edx),%edx
  8030f4:	89 50 04             	mov    %edx,0x4(%eax)
  8030f7:	eb 0b                	jmp    803104 <alloc_block_NF+0x51d>
  8030f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fc:	8b 40 04             	mov    0x4(%eax),%eax
  8030ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803104:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803107:	8b 40 04             	mov    0x4(%eax),%eax
  80310a:	85 c0                	test   %eax,%eax
  80310c:	74 0f                	je     80311d <alloc_block_NF+0x536>
  80310e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803111:	8b 40 04             	mov    0x4(%eax),%eax
  803114:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803117:	8b 12                	mov    (%edx),%edx
  803119:	89 10                	mov    %edx,(%eax)
  80311b:	eb 0a                	jmp    803127 <alloc_block_NF+0x540>
  80311d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	a3 48 51 80 00       	mov    %eax,0x805148
  803127:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803130:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803133:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313a:	a1 54 51 80 00       	mov    0x805154,%eax
  80313f:	48                   	dec    %eax
  803140:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803145:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803148:	8b 40 08             	mov    0x8(%eax),%eax
  80314b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803153:	8b 50 08             	mov    0x8(%eax),%edx
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	01 c2                	add    %eax,%edx
  80315b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803164:	8b 40 0c             	mov    0xc(%eax),%eax
  803167:	2b 45 08             	sub    0x8(%ebp),%eax
  80316a:	89 c2                	mov    %eax,%edx
  80316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803172:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803175:	eb 3b                	jmp    8031b2 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803177:	a1 40 51 80 00       	mov    0x805140,%eax
  80317c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80317f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803183:	74 07                	je     80318c <alloc_block_NF+0x5a5>
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	8b 00                	mov    (%eax),%eax
  80318a:	eb 05                	jmp    803191 <alloc_block_NF+0x5aa>
  80318c:	b8 00 00 00 00       	mov    $0x0,%eax
  803191:	a3 40 51 80 00       	mov    %eax,0x805140
  803196:	a1 40 51 80 00       	mov    0x805140,%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	0f 85 2e fe ff ff    	jne    802fd1 <alloc_block_NF+0x3ea>
  8031a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a7:	0f 85 24 fe ff ff    	jne    802fd1 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8031ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031b2:	c9                   	leave  
  8031b3:	c3                   	ret    

008031b4 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8031b4:	55                   	push   %ebp
  8031b5:	89 e5                	mov    %esp,%ebp
  8031b7:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8031ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8031bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8031c2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031c7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8031ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	74 14                	je     8031e7 <insert_sorted_with_merge_freeList+0x33>
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	8b 50 08             	mov    0x8(%eax),%edx
  8031d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dc:	8b 40 08             	mov    0x8(%eax),%eax
  8031df:	39 c2                	cmp    %eax,%edx
  8031e1:	0f 87 9b 01 00 00    	ja     803382 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8031e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031eb:	75 17                	jne    803204 <insert_sorted_with_merge_freeList+0x50>
  8031ed:	83 ec 04             	sub    $0x4,%esp
  8031f0:	68 b8 44 80 00       	push   $0x8044b8
  8031f5:	68 38 01 00 00       	push   $0x138
  8031fa:	68 db 44 80 00       	push   $0x8044db
  8031ff:	e8 97 d5 ff ff       	call   80079b <_panic>
  803204:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	89 10                	mov    %edx,(%eax)
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	8b 00                	mov    (%eax),%eax
  803214:	85 c0                	test   %eax,%eax
  803216:	74 0d                	je     803225 <insert_sorted_with_merge_freeList+0x71>
  803218:	a1 38 51 80 00       	mov    0x805138,%eax
  80321d:	8b 55 08             	mov    0x8(%ebp),%edx
  803220:	89 50 04             	mov    %edx,0x4(%eax)
  803223:	eb 08                	jmp    80322d <insert_sorted_with_merge_freeList+0x79>
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	a3 38 51 80 00       	mov    %eax,0x805138
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323f:	a1 44 51 80 00       	mov    0x805144,%eax
  803244:	40                   	inc    %eax
  803245:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80324a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80324e:	0f 84 a8 06 00 00    	je     8038fc <insert_sorted_with_merge_freeList+0x748>
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	8b 50 08             	mov    0x8(%eax),%edx
  80325a:	8b 45 08             	mov    0x8(%ebp),%eax
  80325d:	8b 40 0c             	mov    0xc(%eax),%eax
  803260:	01 c2                	add    %eax,%edx
  803262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803265:	8b 40 08             	mov    0x8(%eax),%eax
  803268:	39 c2                	cmp    %eax,%edx
  80326a:	0f 85 8c 06 00 00    	jne    8038fc <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	8b 50 0c             	mov    0xc(%eax),%edx
  803276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803279:	8b 40 0c             	mov    0xc(%eax),%eax
  80327c:	01 c2                	add    %eax,%edx
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803284:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803288:	75 17                	jne    8032a1 <insert_sorted_with_merge_freeList+0xed>
  80328a:	83 ec 04             	sub    $0x4,%esp
  80328d:	68 84 45 80 00       	push   $0x804584
  803292:	68 3c 01 00 00       	push   $0x13c
  803297:	68 db 44 80 00       	push   $0x8044db
  80329c:	e8 fa d4 ff ff       	call   80079b <_panic>
  8032a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a4:	8b 00                	mov    (%eax),%eax
  8032a6:	85 c0                	test   %eax,%eax
  8032a8:	74 10                	je     8032ba <insert_sorted_with_merge_freeList+0x106>
  8032aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ad:	8b 00                	mov    (%eax),%eax
  8032af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032b2:	8b 52 04             	mov    0x4(%edx),%edx
  8032b5:	89 50 04             	mov    %edx,0x4(%eax)
  8032b8:	eb 0b                	jmp    8032c5 <insert_sorted_with_merge_freeList+0x111>
  8032ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032bd:	8b 40 04             	mov    0x4(%eax),%eax
  8032c0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c8:	8b 40 04             	mov    0x4(%eax),%eax
  8032cb:	85 c0                	test   %eax,%eax
  8032cd:	74 0f                	je     8032de <insert_sorted_with_merge_freeList+0x12a>
  8032cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d2:	8b 40 04             	mov    0x4(%eax),%eax
  8032d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032d8:	8b 12                	mov    (%edx),%edx
  8032da:	89 10                	mov    %edx,(%eax)
  8032dc:	eb 0a                	jmp    8032e8 <insert_sorted_with_merge_freeList+0x134>
  8032de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	a3 38 51 80 00       	mov    %eax,0x805138
  8032e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032fb:	a1 44 51 80 00       	mov    0x805144,%eax
  803300:	48                   	dec    %eax
  803301:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803309:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803313:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80331a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80331e:	75 17                	jne    803337 <insert_sorted_with_merge_freeList+0x183>
  803320:	83 ec 04             	sub    $0x4,%esp
  803323:	68 b8 44 80 00       	push   $0x8044b8
  803328:	68 3f 01 00 00       	push   $0x13f
  80332d:	68 db 44 80 00       	push   $0x8044db
  803332:	e8 64 d4 ff ff       	call   80079b <_panic>
  803337:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80333d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803340:	89 10                	mov    %edx,(%eax)
  803342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	85 c0                	test   %eax,%eax
  803349:	74 0d                	je     803358 <insert_sorted_with_merge_freeList+0x1a4>
  80334b:	a1 48 51 80 00       	mov    0x805148,%eax
  803350:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803353:	89 50 04             	mov    %edx,0x4(%eax)
  803356:	eb 08                	jmp    803360 <insert_sorted_with_merge_freeList+0x1ac>
  803358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803363:	a3 48 51 80 00       	mov    %eax,0x805148
  803368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803372:	a1 54 51 80 00       	mov    0x805154,%eax
  803377:	40                   	inc    %eax
  803378:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80337d:	e9 7a 05 00 00       	jmp    8038fc <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803382:	8b 45 08             	mov    0x8(%ebp),%eax
  803385:	8b 50 08             	mov    0x8(%eax),%edx
  803388:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338b:	8b 40 08             	mov    0x8(%eax),%eax
  80338e:	39 c2                	cmp    %eax,%edx
  803390:	0f 82 14 01 00 00    	jb     8034aa <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803399:	8b 50 08             	mov    0x8(%eax),%edx
  80339c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339f:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a2:	01 c2                	add    %eax,%edx
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	8b 40 08             	mov    0x8(%eax),%eax
  8033aa:	39 c2                	cmp    %eax,%edx
  8033ac:	0f 85 90 00 00 00    	jne    803442 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8033b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8033b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033be:	01 c2                	add    %eax,%edx
  8033c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c3:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8033d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8033da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033de:	75 17                	jne    8033f7 <insert_sorted_with_merge_freeList+0x243>
  8033e0:	83 ec 04             	sub    $0x4,%esp
  8033e3:	68 b8 44 80 00       	push   $0x8044b8
  8033e8:	68 49 01 00 00       	push   $0x149
  8033ed:	68 db 44 80 00       	push   $0x8044db
  8033f2:	e8 a4 d3 ff ff       	call   80079b <_panic>
  8033f7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	89 10                	mov    %edx,(%eax)
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	8b 00                	mov    (%eax),%eax
  803407:	85 c0                	test   %eax,%eax
  803409:	74 0d                	je     803418 <insert_sorted_with_merge_freeList+0x264>
  80340b:	a1 48 51 80 00       	mov    0x805148,%eax
  803410:	8b 55 08             	mov    0x8(%ebp),%edx
  803413:	89 50 04             	mov    %edx,0x4(%eax)
  803416:	eb 08                	jmp    803420 <insert_sorted_with_merge_freeList+0x26c>
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	a3 48 51 80 00       	mov    %eax,0x805148
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803432:	a1 54 51 80 00       	mov    0x805154,%eax
  803437:	40                   	inc    %eax
  803438:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80343d:	e9 bb 04 00 00       	jmp    8038fd <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803442:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803446:	75 17                	jne    80345f <insert_sorted_with_merge_freeList+0x2ab>
  803448:	83 ec 04             	sub    $0x4,%esp
  80344b:	68 2c 45 80 00       	push   $0x80452c
  803450:	68 4c 01 00 00       	push   $0x14c
  803455:	68 db 44 80 00       	push   $0x8044db
  80345a:	e8 3c d3 ff ff       	call   80079b <_panic>
  80345f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	89 50 04             	mov    %edx,0x4(%eax)
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	8b 40 04             	mov    0x4(%eax),%eax
  803471:	85 c0                	test   %eax,%eax
  803473:	74 0c                	je     803481 <insert_sorted_with_merge_freeList+0x2cd>
  803475:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80347a:	8b 55 08             	mov    0x8(%ebp),%edx
  80347d:	89 10                	mov    %edx,(%eax)
  80347f:	eb 08                	jmp    803489 <insert_sorted_with_merge_freeList+0x2d5>
  803481:	8b 45 08             	mov    0x8(%ebp),%eax
  803484:	a3 38 51 80 00       	mov    %eax,0x805138
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80349a:	a1 44 51 80 00       	mov    0x805144,%eax
  80349f:	40                   	inc    %eax
  8034a0:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034a5:	e9 53 04 00 00       	jmp    8038fd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034aa:	a1 38 51 80 00       	mov    0x805138,%eax
  8034af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034b2:	e9 15 04 00 00       	jmp    8038cc <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8034b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8034bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c2:	8b 50 08             	mov    0x8(%eax),%edx
  8034c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c8:	8b 40 08             	mov    0x8(%eax),%eax
  8034cb:	39 c2                	cmp    %eax,%edx
  8034cd:	0f 86 f1 03 00 00    	jbe    8038c4 <insert_sorted_with_merge_freeList+0x710>
  8034d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d6:	8b 50 08             	mov    0x8(%eax),%edx
  8034d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034dc:	8b 40 08             	mov    0x8(%eax),%eax
  8034df:	39 c2                	cmp    %eax,%edx
  8034e1:	0f 83 dd 03 00 00    	jae    8038c4 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8034e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ea:	8b 50 08             	mov    0x8(%eax),%edx
  8034ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f3:	01 c2                	add    %eax,%edx
  8034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f8:	8b 40 08             	mov    0x8(%eax),%eax
  8034fb:	39 c2                	cmp    %eax,%edx
  8034fd:	0f 85 b9 01 00 00    	jne    8036bc <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803503:	8b 45 08             	mov    0x8(%ebp),%eax
  803506:	8b 50 08             	mov    0x8(%eax),%edx
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	8b 40 0c             	mov    0xc(%eax),%eax
  80350f:	01 c2                	add    %eax,%edx
  803511:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803514:	8b 40 08             	mov    0x8(%eax),%eax
  803517:	39 c2                	cmp    %eax,%edx
  803519:	0f 85 0d 01 00 00    	jne    80362c <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80351f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803522:	8b 50 0c             	mov    0xc(%eax),%edx
  803525:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803528:	8b 40 0c             	mov    0xc(%eax),%eax
  80352b:	01 c2                	add    %eax,%edx
  80352d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803530:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803533:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803537:	75 17                	jne    803550 <insert_sorted_with_merge_freeList+0x39c>
  803539:	83 ec 04             	sub    $0x4,%esp
  80353c:	68 84 45 80 00       	push   $0x804584
  803541:	68 5c 01 00 00       	push   $0x15c
  803546:	68 db 44 80 00       	push   $0x8044db
  80354b:	e8 4b d2 ff ff       	call   80079b <_panic>
  803550:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803553:	8b 00                	mov    (%eax),%eax
  803555:	85 c0                	test   %eax,%eax
  803557:	74 10                	je     803569 <insert_sorted_with_merge_freeList+0x3b5>
  803559:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355c:	8b 00                	mov    (%eax),%eax
  80355e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803561:	8b 52 04             	mov    0x4(%edx),%edx
  803564:	89 50 04             	mov    %edx,0x4(%eax)
  803567:	eb 0b                	jmp    803574 <insert_sorted_with_merge_freeList+0x3c0>
  803569:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356c:	8b 40 04             	mov    0x4(%eax),%eax
  80356f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803574:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803577:	8b 40 04             	mov    0x4(%eax),%eax
  80357a:	85 c0                	test   %eax,%eax
  80357c:	74 0f                	je     80358d <insert_sorted_with_merge_freeList+0x3d9>
  80357e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803581:	8b 40 04             	mov    0x4(%eax),%eax
  803584:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803587:	8b 12                	mov    (%edx),%edx
  803589:	89 10                	mov    %edx,(%eax)
  80358b:	eb 0a                	jmp    803597 <insert_sorted_with_merge_freeList+0x3e3>
  80358d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803590:	8b 00                	mov    (%eax),%eax
  803592:	a3 38 51 80 00       	mov    %eax,0x805138
  803597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80359a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8035af:	48                   	dec    %eax
  8035b0:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8035b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8035bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035cd:	75 17                	jne    8035e6 <insert_sorted_with_merge_freeList+0x432>
  8035cf:	83 ec 04             	sub    $0x4,%esp
  8035d2:	68 b8 44 80 00       	push   $0x8044b8
  8035d7:	68 5f 01 00 00       	push   $0x15f
  8035dc:	68 db 44 80 00       	push   $0x8044db
  8035e1:	e8 b5 d1 ff ff       	call   80079b <_panic>
  8035e6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ef:	89 10                	mov    %edx,(%eax)
  8035f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f4:	8b 00                	mov    (%eax),%eax
  8035f6:	85 c0                	test   %eax,%eax
  8035f8:	74 0d                	je     803607 <insert_sorted_with_merge_freeList+0x453>
  8035fa:	a1 48 51 80 00       	mov    0x805148,%eax
  8035ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803602:	89 50 04             	mov    %edx,0x4(%eax)
  803605:	eb 08                	jmp    80360f <insert_sorted_with_merge_freeList+0x45b>
  803607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80360f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803612:	a3 48 51 80 00       	mov    %eax,0x805148
  803617:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803621:	a1 54 51 80 00       	mov    0x805154,%eax
  803626:	40                   	inc    %eax
  803627:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80362c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362f:	8b 50 0c             	mov    0xc(%eax),%edx
  803632:	8b 45 08             	mov    0x8(%ebp),%eax
  803635:	8b 40 0c             	mov    0xc(%eax),%eax
  803638:	01 c2                	add    %eax,%edx
  80363a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803640:	8b 45 08             	mov    0x8(%ebp),%eax
  803643:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80364a:	8b 45 08             	mov    0x8(%ebp),%eax
  80364d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803654:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803658:	75 17                	jne    803671 <insert_sorted_with_merge_freeList+0x4bd>
  80365a:	83 ec 04             	sub    $0x4,%esp
  80365d:	68 b8 44 80 00       	push   $0x8044b8
  803662:	68 64 01 00 00       	push   $0x164
  803667:	68 db 44 80 00       	push   $0x8044db
  80366c:	e8 2a d1 ff ff       	call   80079b <_panic>
  803671:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803677:	8b 45 08             	mov    0x8(%ebp),%eax
  80367a:	89 10                	mov    %edx,(%eax)
  80367c:	8b 45 08             	mov    0x8(%ebp),%eax
  80367f:	8b 00                	mov    (%eax),%eax
  803681:	85 c0                	test   %eax,%eax
  803683:	74 0d                	je     803692 <insert_sorted_with_merge_freeList+0x4de>
  803685:	a1 48 51 80 00       	mov    0x805148,%eax
  80368a:	8b 55 08             	mov    0x8(%ebp),%edx
  80368d:	89 50 04             	mov    %edx,0x4(%eax)
  803690:	eb 08                	jmp    80369a <insert_sorted_with_merge_freeList+0x4e6>
  803692:	8b 45 08             	mov    0x8(%ebp),%eax
  803695:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80369a:	8b 45 08             	mov    0x8(%ebp),%eax
  80369d:	a3 48 51 80 00       	mov    %eax,0x805148
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ac:	a1 54 51 80 00       	mov    0x805154,%eax
  8036b1:	40                   	inc    %eax
  8036b2:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036b7:	e9 41 02 00 00       	jmp    8038fd <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bf:	8b 50 08             	mov    0x8(%eax),%edx
  8036c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c8:	01 c2                	add    %eax,%edx
  8036ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cd:	8b 40 08             	mov    0x8(%eax),%eax
  8036d0:	39 c2                	cmp    %eax,%edx
  8036d2:	0f 85 7c 01 00 00    	jne    803854 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8036d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036dc:	74 06                	je     8036e4 <insert_sorted_with_merge_freeList+0x530>
  8036de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e2:	75 17                	jne    8036fb <insert_sorted_with_merge_freeList+0x547>
  8036e4:	83 ec 04             	sub    $0x4,%esp
  8036e7:	68 f4 44 80 00       	push   $0x8044f4
  8036ec:	68 69 01 00 00       	push   $0x169
  8036f1:	68 db 44 80 00       	push   $0x8044db
  8036f6:	e8 a0 d0 ff ff       	call   80079b <_panic>
  8036fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fe:	8b 50 04             	mov    0x4(%eax),%edx
  803701:	8b 45 08             	mov    0x8(%ebp),%eax
  803704:	89 50 04             	mov    %edx,0x4(%eax)
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80370d:	89 10                	mov    %edx,(%eax)
  80370f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803712:	8b 40 04             	mov    0x4(%eax),%eax
  803715:	85 c0                	test   %eax,%eax
  803717:	74 0d                	je     803726 <insert_sorted_with_merge_freeList+0x572>
  803719:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371c:	8b 40 04             	mov    0x4(%eax),%eax
  80371f:	8b 55 08             	mov    0x8(%ebp),%edx
  803722:	89 10                	mov    %edx,(%eax)
  803724:	eb 08                	jmp    80372e <insert_sorted_with_merge_freeList+0x57a>
  803726:	8b 45 08             	mov    0x8(%ebp),%eax
  803729:	a3 38 51 80 00       	mov    %eax,0x805138
  80372e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803731:	8b 55 08             	mov    0x8(%ebp),%edx
  803734:	89 50 04             	mov    %edx,0x4(%eax)
  803737:	a1 44 51 80 00       	mov    0x805144,%eax
  80373c:	40                   	inc    %eax
  80373d:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803742:	8b 45 08             	mov    0x8(%ebp),%eax
  803745:	8b 50 0c             	mov    0xc(%eax),%edx
  803748:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374b:	8b 40 0c             	mov    0xc(%eax),%eax
  80374e:	01 c2                	add    %eax,%edx
  803750:	8b 45 08             	mov    0x8(%ebp),%eax
  803753:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803756:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80375a:	75 17                	jne    803773 <insert_sorted_with_merge_freeList+0x5bf>
  80375c:	83 ec 04             	sub    $0x4,%esp
  80375f:	68 84 45 80 00       	push   $0x804584
  803764:	68 6b 01 00 00       	push   $0x16b
  803769:	68 db 44 80 00       	push   $0x8044db
  80376e:	e8 28 d0 ff ff       	call   80079b <_panic>
  803773:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803776:	8b 00                	mov    (%eax),%eax
  803778:	85 c0                	test   %eax,%eax
  80377a:	74 10                	je     80378c <insert_sorted_with_merge_freeList+0x5d8>
  80377c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377f:	8b 00                	mov    (%eax),%eax
  803781:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803784:	8b 52 04             	mov    0x4(%edx),%edx
  803787:	89 50 04             	mov    %edx,0x4(%eax)
  80378a:	eb 0b                	jmp    803797 <insert_sorted_with_merge_freeList+0x5e3>
  80378c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378f:	8b 40 04             	mov    0x4(%eax),%eax
  803792:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379a:	8b 40 04             	mov    0x4(%eax),%eax
  80379d:	85 c0                	test   %eax,%eax
  80379f:	74 0f                	je     8037b0 <insert_sorted_with_merge_freeList+0x5fc>
  8037a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a4:	8b 40 04             	mov    0x4(%eax),%eax
  8037a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037aa:	8b 12                	mov    (%edx),%edx
  8037ac:	89 10                	mov    %edx,(%eax)
  8037ae:	eb 0a                	jmp    8037ba <insert_sorted_with_merge_freeList+0x606>
  8037b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b3:	8b 00                	mov    (%eax),%eax
  8037b5:	a3 38 51 80 00       	mov    %eax,0x805138
  8037ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037cd:	a1 44 51 80 00       	mov    0x805144,%eax
  8037d2:	48                   	dec    %eax
  8037d3:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8037d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037db:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8037e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037f0:	75 17                	jne    803809 <insert_sorted_with_merge_freeList+0x655>
  8037f2:	83 ec 04             	sub    $0x4,%esp
  8037f5:	68 b8 44 80 00       	push   $0x8044b8
  8037fa:	68 6e 01 00 00       	push   $0x16e
  8037ff:	68 db 44 80 00       	push   $0x8044db
  803804:	e8 92 cf ff ff       	call   80079b <_panic>
  803809:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80380f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803812:	89 10                	mov    %edx,(%eax)
  803814:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803817:	8b 00                	mov    (%eax),%eax
  803819:	85 c0                	test   %eax,%eax
  80381b:	74 0d                	je     80382a <insert_sorted_with_merge_freeList+0x676>
  80381d:	a1 48 51 80 00       	mov    0x805148,%eax
  803822:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803825:	89 50 04             	mov    %edx,0x4(%eax)
  803828:	eb 08                	jmp    803832 <insert_sorted_with_merge_freeList+0x67e>
  80382a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803832:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803835:	a3 48 51 80 00       	mov    %eax,0x805148
  80383a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803844:	a1 54 51 80 00       	mov    0x805154,%eax
  803849:	40                   	inc    %eax
  80384a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80384f:	e9 a9 00 00 00       	jmp    8038fd <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803854:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803858:	74 06                	je     803860 <insert_sorted_with_merge_freeList+0x6ac>
  80385a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80385e:	75 17                	jne    803877 <insert_sorted_with_merge_freeList+0x6c3>
  803860:	83 ec 04             	sub    $0x4,%esp
  803863:	68 50 45 80 00       	push   $0x804550
  803868:	68 73 01 00 00       	push   $0x173
  80386d:	68 db 44 80 00       	push   $0x8044db
  803872:	e8 24 cf ff ff       	call   80079b <_panic>
  803877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387a:	8b 10                	mov    (%eax),%edx
  80387c:	8b 45 08             	mov    0x8(%ebp),%eax
  80387f:	89 10                	mov    %edx,(%eax)
  803881:	8b 45 08             	mov    0x8(%ebp),%eax
  803884:	8b 00                	mov    (%eax),%eax
  803886:	85 c0                	test   %eax,%eax
  803888:	74 0b                	je     803895 <insert_sorted_with_merge_freeList+0x6e1>
  80388a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388d:	8b 00                	mov    (%eax),%eax
  80388f:	8b 55 08             	mov    0x8(%ebp),%edx
  803892:	89 50 04             	mov    %edx,0x4(%eax)
  803895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803898:	8b 55 08             	mov    0x8(%ebp),%edx
  80389b:	89 10                	mov    %edx,(%eax)
  80389d:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038a3:	89 50 04             	mov    %edx,0x4(%eax)
  8038a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a9:	8b 00                	mov    (%eax),%eax
  8038ab:	85 c0                	test   %eax,%eax
  8038ad:	75 08                	jne    8038b7 <insert_sorted_with_merge_freeList+0x703>
  8038af:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8038bc:	40                   	inc    %eax
  8038bd:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8038c2:	eb 39                	jmp    8038fd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038c4:	a1 40 51 80 00       	mov    0x805140,%eax
  8038c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038d0:	74 07                	je     8038d9 <insert_sorted_with_merge_freeList+0x725>
  8038d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d5:	8b 00                	mov    (%eax),%eax
  8038d7:	eb 05                	jmp    8038de <insert_sorted_with_merge_freeList+0x72a>
  8038d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8038de:	a3 40 51 80 00       	mov    %eax,0x805140
  8038e3:	a1 40 51 80 00       	mov    0x805140,%eax
  8038e8:	85 c0                	test   %eax,%eax
  8038ea:	0f 85 c7 fb ff ff    	jne    8034b7 <insert_sorted_with_merge_freeList+0x303>
  8038f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f4:	0f 85 bd fb ff ff    	jne    8034b7 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038fa:	eb 01                	jmp    8038fd <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8038fc:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038fd:	90                   	nop
  8038fe:	c9                   	leave  
  8038ff:	c3                   	ret    

00803900 <__udivdi3>:
  803900:	55                   	push   %ebp
  803901:	57                   	push   %edi
  803902:	56                   	push   %esi
  803903:	53                   	push   %ebx
  803904:	83 ec 1c             	sub    $0x1c,%esp
  803907:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80390b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80390f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803913:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803917:	89 ca                	mov    %ecx,%edx
  803919:	89 f8                	mov    %edi,%eax
  80391b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80391f:	85 f6                	test   %esi,%esi
  803921:	75 2d                	jne    803950 <__udivdi3+0x50>
  803923:	39 cf                	cmp    %ecx,%edi
  803925:	77 65                	ja     80398c <__udivdi3+0x8c>
  803927:	89 fd                	mov    %edi,%ebp
  803929:	85 ff                	test   %edi,%edi
  80392b:	75 0b                	jne    803938 <__udivdi3+0x38>
  80392d:	b8 01 00 00 00       	mov    $0x1,%eax
  803932:	31 d2                	xor    %edx,%edx
  803934:	f7 f7                	div    %edi
  803936:	89 c5                	mov    %eax,%ebp
  803938:	31 d2                	xor    %edx,%edx
  80393a:	89 c8                	mov    %ecx,%eax
  80393c:	f7 f5                	div    %ebp
  80393e:	89 c1                	mov    %eax,%ecx
  803940:	89 d8                	mov    %ebx,%eax
  803942:	f7 f5                	div    %ebp
  803944:	89 cf                	mov    %ecx,%edi
  803946:	89 fa                	mov    %edi,%edx
  803948:	83 c4 1c             	add    $0x1c,%esp
  80394b:	5b                   	pop    %ebx
  80394c:	5e                   	pop    %esi
  80394d:	5f                   	pop    %edi
  80394e:	5d                   	pop    %ebp
  80394f:	c3                   	ret    
  803950:	39 ce                	cmp    %ecx,%esi
  803952:	77 28                	ja     80397c <__udivdi3+0x7c>
  803954:	0f bd fe             	bsr    %esi,%edi
  803957:	83 f7 1f             	xor    $0x1f,%edi
  80395a:	75 40                	jne    80399c <__udivdi3+0x9c>
  80395c:	39 ce                	cmp    %ecx,%esi
  80395e:	72 0a                	jb     80396a <__udivdi3+0x6a>
  803960:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803964:	0f 87 9e 00 00 00    	ja     803a08 <__udivdi3+0x108>
  80396a:	b8 01 00 00 00       	mov    $0x1,%eax
  80396f:	89 fa                	mov    %edi,%edx
  803971:	83 c4 1c             	add    $0x1c,%esp
  803974:	5b                   	pop    %ebx
  803975:	5e                   	pop    %esi
  803976:	5f                   	pop    %edi
  803977:	5d                   	pop    %ebp
  803978:	c3                   	ret    
  803979:	8d 76 00             	lea    0x0(%esi),%esi
  80397c:	31 ff                	xor    %edi,%edi
  80397e:	31 c0                	xor    %eax,%eax
  803980:	89 fa                	mov    %edi,%edx
  803982:	83 c4 1c             	add    $0x1c,%esp
  803985:	5b                   	pop    %ebx
  803986:	5e                   	pop    %esi
  803987:	5f                   	pop    %edi
  803988:	5d                   	pop    %ebp
  803989:	c3                   	ret    
  80398a:	66 90                	xchg   %ax,%ax
  80398c:	89 d8                	mov    %ebx,%eax
  80398e:	f7 f7                	div    %edi
  803990:	31 ff                	xor    %edi,%edi
  803992:	89 fa                	mov    %edi,%edx
  803994:	83 c4 1c             	add    $0x1c,%esp
  803997:	5b                   	pop    %ebx
  803998:	5e                   	pop    %esi
  803999:	5f                   	pop    %edi
  80399a:	5d                   	pop    %ebp
  80399b:	c3                   	ret    
  80399c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039a1:	89 eb                	mov    %ebp,%ebx
  8039a3:	29 fb                	sub    %edi,%ebx
  8039a5:	89 f9                	mov    %edi,%ecx
  8039a7:	d3 e6                	shl    %cl,%esi
  8039a9:	89 c5                	mov    %eax,%ebp
  8039ab:	88 d9                	mov    %bl,%cl
  8039ad:	d3 ed                	shr    %cl,%ebp
  8039af:	89 e9                	mov    %ebp,%ecx
  8039b1:	09 f1                	or     %esi,%ecx
  8039b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039b7:	89 f9                	mov    %edi,%ecx
  8039b9:	d3 e0                	shl    %cl,%eax
  8039bb:	89 c5                	mov    %eax,%ebp
  8039bd:	89 d6                	mov    %edx,%esi
  8039bf:	88 d9                	mov    %bl,%cl
  8039c1:	d3 ee                	shr    %cl,%esi
  8039c3:	89 f9                	mov    %edi,%ecx
  8039c5:	d3 e2                	shl    %cl,%edx
  8039c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039cb:	88 d9                	mov    %bl,%cl
  8039cd:	d3 e8                	shr    %cl,%eax
  8039cf:	09 c2                	or     %eax,%edx
  8039d1:	89 d0                	mov    %edx,%eax
  8039d3:	89 f2                	mov    %esi,%edx
  8039d5:	f7 74 24 0c          	divl   0xc(%esp)
  8039d9:	89 d6                	mov    %edx,%esi
  8039db:	89 c3                	mov    %eax,%ebx
  8039dd:	f7 e5                	mul    %ebp
  8039df:	39 d6                	cmp    %edx,%esi
  8039e1:	72 19                	jb     8039fc <__udivdi3+0xfc>
  8039e3:	74 0b                	je     8039f0 <__udivdi3+0xf0>
  8039e5:	89 d8                	mov    %ebx,%eax
  8039e7:	31 ff                	xor    %edi,%edi
  8039e9:	e9 58 ff ff ff       	jmp    803946 <__udivdi3+0x46>
  8039ee:	66 90                	xchg   %ax,%ax
  8039f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039f4:	89 f9                	mov    %edi,%ecx
  8039f6:	d3 e2                	shl    %cl,%edx
  8039f8:	39 c2                	cmp    %eax,%edx
  8039fa:	73 e9                	jae    8039e5 <__udivdi3+0xe5>
  8039fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039ff:	31 ff                	xor    %edi,%edi
  803a01:	e9 40 ff ff ff       	jmp    803946 <__udivdi3+0x46>
  803a06:	66 90                	xchg   %ax,%ax
  803a08:	31 c0                	xor    %eax,%eax
  803a0a:	e9 37 ff ff ff       	jmp    803946 <__udivdi3+0x46>
  803a0f:	90                   	nop

00803a10 <__umoddi3>:
  803a10:	55                   	push   %ebp
  803a11:	57                   	push   %edi
  803a12:	56                   	push   %esi
  803a13:	53                   	push   %ebx
  803a14:	83 ec 1c             	sub    $0x1c,%esp
  803a17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a2f:	89 f3                	mov    %esi,%ebx
  803a31:	89 fa                	mov    %edi,%edx
  803a33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a37:	89 34 24             	mov    %esi,(%esp)
  803a3a:	85 c0                	test   %eax,%eax
  803a3c:	75 1a                	jne    803a58 <__umoddi3+0x48>
  803a3e:	39 f7                	cmp    %esi,%edi
  803a40:	0f 86 a2 00 00 00    	jbe    803ae8 <__umoddi3+0xd8>
  803a46:	89 c8                	mov    %ecx,%eax
  803a48:	89 f2                	mov    %esi,%edx
  803a4a:	f7 f7                	div    %edi
  803a4c:	89 d0                	mov    %edx,%eax
  803a4e:	31 d2                	xor    %edx,%edx
  803a50:	83 c4 1c             	add    $0x1c,%esp
  803a53:	5b                   	pop    %ebx
  803a54:	5e                   	pop    %esi
  803a55:	5f                   	pop    %edi
  803a56:	5d                   	pop    %ebp
  803a57:	c3                   	ret    
  803a58:	39 f0                	cmp    %esi,%eax
  803a5a:	0f 87 ac 00 00 00    	ja     803b0c <__umoddi3+0xfc>
  803a60:	0f bd e8             	bsr    %eax,%ebp
  803a63:	83 f5 1f             	xor    $0x1f,%ebp
  803a66:	0f 84 ac 00 00 00    	je     803b18 <__umoddi3+0x108>
  803a6c:	bf 20 00 00 00       	mov    $0x20,%edi
  803a71:	29 ef                	sub    %ebp,%edi
  803a73:	89 fe                	mov    %edi,%esi
  803a75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a79:	89 e9                	mov    %ebp,%ecx
  803a7b:	d3 e0                	shl    %cl,%eax
  803a7d:	89 d7                	mov    %edx,%edi
  803a7f:	89 f1                	mov    %esi,%ecx
  803a81:	d3 ef                	shr    %cl,%edi
  803a83:	09 c7                	or     %eax,%edi
  803a85:	89 e9                	mov    %ebp,%ecx
  803a87:	d3 e2                	shl    %cl,%edx
  803a89:	89 14 24             	mov    %edx,(%esp)
  803a8c:	89 d8                	mov    %ebx,%eax
  803a8e:	d3 e0                	shl    %cl,%eax
  803a90:	89 c2                	mov    %eax,%edx
  803a92:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a96:	d3 e0                	shl    %cl,%eax
  803a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aa0:	89 f1                	mov    %esi,%ecx
  803aa2:	d3 e8                	shr    %cl,%eax
  803aa4:	09 d0                	or     %edx,%eax
  803aa6:	d3 eb                	shr    %cl,%ebx
  803aa8:	89 da                	mov    %ebx,%edx
  803aaa:	f7 f7                	div    %edi
  803aac:	89 d3                	mov    %edx,%ebx
  803aae:	f7 24 24             	mull   (%esp)
  803ab1:	89 c6                	mov    %eax,%esi
  803ab3:	89 d1                	mov    %edx,%ecx
  803ab5:	39 d3                	cmp    %edx,%ebx
  803ab7:	0f 82 87 00 00 00    	jb     803b44 <__umoddi3+0x134>
  803abd:	0f 84 91 00 00 00    	je     803b54 <__umoddi3+0x144>
  803ac3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ac7:	29 f2                	sub    %esi,%edx
  803ac9:	19 cb                	sbb    %ecx,%ebx
  803acb:	89 d8                	mov    %ebx,%eax
  803acd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ad1:	d3 e0                	shl    %cl,%eax
  803ad3:	89 e9                	mov    %ebp,%ecx
  803ad5:	d3 ea                	shr    %cl,%edx
  803ad7:	09 d0                	or     %edx,%eax
  803ad9:	89 e9                	mov    %ebp,%ecx
  803adb:	d3 eb                	shr    %cl,%ebx
  803add:	89 da                	mov    %ebx,%edx
  803adf:	83 c4 1c             	add    $0x1c,%esp
  803ae2:	5b                   	pop    %ebx
  803ae3:	5e                   	pop    %esi
  803ae4:	5f                   	pop    %edi
  803ae5:	5d                   	pop    %ebp
  803ae6:	c3                   	ret    
  803ae7:	90                   	nop
  803ae8:	89 fd                	mov    %edi,%ebp
  803aea:	85 ff                	test   %edi,%edi
  803aec:	75 0b                	jne    803af9 <__umoddi3+0xe9>
  803aee:	b8 01 00 00 00       	mov    $0x1,%eax
  803af3:	31 d2                	xor    %edx,%edx
  803af5:	f7 f7                	div    %edi
  803af7:	89 c5                	mov    %eax,%ebp
  803af9:	89 f0                	mov    %esi,%eax
  803afb:	31 d2                	xor    %edx,%edx
  803afd:	f7 f5                	div    %ebp
  803aff:	89 c8                	mov    %ecx,%eax
  803b01:	f7 f5                	div    %ebp
  803b03:	89 d0                	mov    %edx,%eax
  803b05:	e9 44 ff ff ff       	jmp    803a4e <__umoddi3+0x3e>
  803b0a:	66 90                	xchg   %ax,%ax
  803b0c:	89 c8                	mov    %ecx,%eax
  803b0e:	89 f2                	mov    %esi,%edx
  803b10:	83 c4 1c             	add    $0x1c,%esp
  803b13:	5b                   	pop    %ebx
  803b14:	5e                   	pop    %esi
  803b15:	5f                   	pop    %edi
  803b16:	5d                   	pop    %ebp
  803b17:	c3                   	ret    
  803b18:	3b 04 24             	cmp    (%esp),%eax
  803b1b:	72 06                	jb     803b23 <__umoddi3+0x113>
  803b1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b21:	77 0f                	ja     803b32 <__umoddi3+0x122>
  803b23:	89 f2                	mov    %esi,%edx
  803b25:	29 f9                	sub    %edi,%ecx
  803b27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b2b:	89 14 24             	mov    %edx,(%esp)
  803b2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b32:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b36:	8b 14 24             	mov    (%esp),%edx
  803b39:	83 c4 1c             	add    $0x1c,%esp
  803b3c:	5b                   	pop    %ebx
  803b3d:	5e                   	pop    %esi
  803b3e:	5f                   	pop    %edi
  803b3f:	5d                   	pop    %ebp
  803b40:	c3                   	ret    
  803b41:	8d 76 00             	lea    0x0(%esi),%esi
  803b44:	2b 04 24             	sub    (%esp),%eax
  803b47:	19 fa                	sbb    %edi,%edx
  803b49:	89 d1                	mov    %edx,%ecx
  803b4b:	89 c6                	mov    %eax,%esi
  803b4d:	e9 71 ff ff ff       	jmp    803ac3 <__umoddi3+0xb3>
  803b52:	66 90                	xchg   %ax,%ax
  803b54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b58:	72 ea                	jb     803b44 <__umoddi3+0x134>
  803b5a:	89 d9                	mov    %ebx,%ecx
  803b5c:	e9 62 ff ff ff       	jmp    803ac3 <__umoddi3+0xb3>
