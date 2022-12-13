
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
  800062:	68 e0 3a 80 00       	push   $0x803ae0
  800067:	e8 e3 09 00 00       	call   800a4f <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 38 1c 00 00       	call   801cac <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 d0 1c 00 00       	call   801d4c <sys_pf_calculate_allocated_pages>
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
  8000ab:	68 04 3b 80 00       	push   $0x803b04
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 34 3b 80 00       	push   $0x803b34
  8000b7:	e8 df 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 e8 1b 00 00       	call   801cac <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 4c 3b 80 00       	push   $0x803b4c
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 34 3b 80 00       	push   $0x803b34
  8000dc:	e8 ba 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 66 1c 00 00       	call   801d4c <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 b8 3b 80 00       	push   $0x803bb8
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 34 3b 80 00       	push   $0x803b34
  8000fd:	e8 99 06 00 00       	call   80079b <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 a5 1b 00 00       	call   801cac <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 3d 1c 00 00       	call   801d4c <sys_pf_calculate_allocated_pages>
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
  800156:	68 04 3b 80 00       	push   $0x803b04
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 34 3b 80 00       	push   $0x803b34
  800162:	e8 34 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 40 1b 00 00       	call   801cac <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 4c 3b 80 00       	push   $0x803b4c
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 34 3b 80 00       	push   $0x803b34
  800184:	e8 12 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 be 1b 00 00       	call   801d4c <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 b8 3b 80 00       	push   $0x803bb8
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 34 3b 80 00       	push   $0x803b34
  8001a5:	e8 f1 05 00 00       	call   80079b <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 fd 1a 00 00       	call   801cac <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 95 1b 00 00       	call   801d4c <sys_pf_calculate_allocated_pages>
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
  800201:	68 04 3b 80 00       	push   $0x803b04
  800206:	6a 23                	push   $0x23
  800208:	68 34 3b 80 00       	push   $0x803b34
  80020d:	e8 89 05 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 95 1a 00 00       	call   801cac <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 4c 3b 80 00       	push   $0x803b4c
  800228:	6a 25                	push   $0x25
  80022a:	68 34 3b 80 00       	push   $0x803b34
  80022f:	e8 67 05 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 13 1b 00 00       	call   801d4c <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 b8 3b 80 00       	push   $0x803bb8
  800249:	6a 26                	push   $0x26
  80024b:	68 34 3b 80 00       	push   $0x803b34
  800250:	e8 46 05 00 00       	call   80079b <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 52 1a 00 00       	call   801cac <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 ea 1a 00 00       	call   801d4c <sys_pf_calculate_allocated_pages>
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
  8002a8:	68 04 3b 80 00       	push   $0x803b04
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 34 3b 80 00       	push   $0x803b34
  8002b4:	e8 e2 04 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 ee 19 00 00       	call   801cac <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 4c 3b 80 00       	push   $0x803b4c
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 34 3b 80 00       	push   $0x803b34
  8002d6:	e8 c0 04 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 6c 1a 00 00       	call   801d4c <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 b8 3b 80 00       	push   $0x803bb8
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 34 3b 80 00       	push   $0x803b34
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
  800422:	e8 85 18 00 00       	call   801cac <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 1d 19 00 00       	call   801d4c <sys_pf_calculate_allocated_pages>
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
  800450:	e8 d5 16 00 00       	call   801b2a <realloc>
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
  800478:	68 e8 3b 80 00       	push   $0x803be8
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 34 3b 80 00       	push   $0x803b34
  800484:	e8 12 03 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 be 18 00 00       	call   801d4c <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 1c 3c 80 00       	push   $0x803c1c
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 34 3b 80 00       	push   $0x803b34
  8004a5:	e8 f1 02 00 00       	call   80079b <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 4d 3c 80 00       	push   $0x803c4d
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
  800501:	68 54 3c 80 00       	push   $0x803c54
  800506:	6a 7a                	push   $0x7a
  800508:	68 34 3b 80 00       	push   $0x803b34
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
  800559:	68 54 3c 80 00       	push   $0x803c54
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 34 3b 80 00       	push   $0x803b34
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
  8005bb:	68 54 3c 80 00       	push   $0x803c54
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 34 3b 80 00       	push   $0x803b34
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
  800616:	68 54 3c 80 00       	push   $0x803c54
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 34 3b 80 00       	push   $0x803b34
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
  80063a:	68 8c 3c 80 00       	push   $0x803c8c
  80063f:	e8 a0 03 00 00       	call   8009e4 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 98 3c 80 00       	push   $0x803c98
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
  800665:	e8 22 19 00 00       	call   801f8c <sys_getenvindex>
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
  8006d0:	e8 c4 16 00 00       	call   801d99 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	68 ec 3c 80 00       	push   $0x803cec
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
  800700:	68 14 3d 80 00       	push   $0x803d14
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
  800731:	68 3c 3d 80 00       	push   $0x803d3c
  800736:	e8 14 03 00 00       	call   800a4f <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073e:	a1 20 50 80 00       	mov    0x805020,%eax
  800743:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	50                   	push   %eax
  80074d:	68 94 3d 80 00       	push   $0x803d94
  800752:	e8 f8 02 00 00       	call   800a4f <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	68 ec 3c 80 00       	push   $0x803cec
  800762:	e8 e8 02 00 00       	call   800a4f <cprintf>
  800767:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80076a:	e8 44 16 00 00       	call   801db3 <sys_enable_interrupt>

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
  800782:	e8 d1 17 00 00       	call   801f58 <sys_destroy_env>
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
  800793:	e8 26 18 00 00       	call   801fbe <sys_exit_env>
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
  8007bc:	68 a8 3d 80 00       	push   $0x803da8
  8007c1:	e8 89 02 00 00       	call   800a4f <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c9:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	68 ad 3d 80 00       	push   $0x803dad
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
  8007f9:	68 c9 3d 80 00       	push   $0x803dc9
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
  800825:	68 cc 3d 80 00       	push   $0x803dcc
  80082a:	6a 26                	push   $0x26
  80082c:	68 18 3e 80 00       	push   $0x803e18
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
  8008f7:	68 24 3e 80 00       	push   $0x803e24
  8008fc:	6a 3a                	push   $0x3a
  8008fe:	68 18 3e 80 00       	push   $0x803e18
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
  800967:	68 78 3e 80 00       	push   $0x803e78
  80096c:	6a 44                	push   $0x44
  80096e:	68 18 3e 80 00       	push   $0x803e18
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
  8009c1:	e8 25 12 00 00       	call   801beb <sys_cputs>
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
  800a38:	e8 ae 11 00 00       	call   801beb <sys_cputs>
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
  800a82:	e8 12 13 00 00       	call   801d99 <sys_disable_interrupt>
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
  800aa2:	e8 0c 13 00 00       	call   801db3 <sys_enable_interrupt>
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
  800aec:	e8 7f 2d 00 00       	call   803870 <__udivdi3>
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
  800b3c:	e8 3f 2e 00 00       	call   803980 <__umoddi3>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	05 f4 40 80 00       	add    $0x8040f4,%eax
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
  800c97:	8b 04 85 18 41 80 00 	mov    0x804118(,%eax,4),%eax
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
  800d78:	8b 34 9d 60 3f 80 00 	mov    0x803f60(,%ebx,4),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 19                	jne    800d9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d83:	53                   	push   %ebx
  800d84:	68 05 41 80 00       	push   $0x804105
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
  800d9d:	68 0e 41 80 00       	push   $0x80410e
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
  800dca:	be 11 41 80 00       	mov    $0x804111,%esi
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
  8017f0:	68 70 42 80 00       	push   $0x804270
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
  8018c0:	e8 6a 04 00 00       	call   801d2f <sys_allocate_chunk>
  8018c5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018c8:	a1 20 51 80 00       	mov    0x805120,%eax
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	50                   	push   %eax
  8018d1:	e8 df 0a 00 00       	call   8023b5 <initialize_MemBlocksList>
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
  8018fe:	68 95 42 80 00       	push   $0x804295
  801903:	6a 33                	push   $0x33
  801905:	68 b3 42 80 00       	push   $0x8042b3
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
  80197d:	68 c0 42 80 00       	push   $0x8042c0
  801982:	6a 34                	push   $0x34
  801984:	68 b3 42 80 00       	push   $0x8042b3
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
  801a15:	e8 e3 06 00 00       	call   8020fd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	74 11                	je     801a2f <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	ff 75 e8             	pushl  -0x18(%ebp)
  801a24:	e8 4e 0d 00 00       	call   802777 <alloc_block_FF>
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
  801a3b:	e8 aa 0a 00 00       	call   8024ea <insert_sorted_allocList>
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
  801a5b:	68 e4 42 80 00       	push   $0x8042e4
  801a60:	6a 6f                	push   $0x6f
  801a62:	68 b3 42 80 00       	push   $0x8042b3
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
  801a81:	75 07                	jne    801a8a <smalloc+0x1e>
  801a83:	b8 00 00 00 00       	mov    $0x0,%eax
  801a88:	eb 7c                	jmp    801b06 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a8a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a97:	01 d0                	add    %edx,%eax
  801a99:	48                   	dec    %eax
  801a9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa0:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa5:	f7 75 f0             	divl   -0x10(%ebp)
  801aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aab:	29 d0                	sub    %edx,%eax
  801aad:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801ab0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801ab7:	e8 41 06 00 00       	call   8020fd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801abc:	85 c0                	test   %eax,%eax
  801abe:	74 11                	je     801ad1 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801ac0:	83 ec 0c             	sub    $0xc,%esp
  801ac3:	ff 75 e8             	pushl  -0x18(%ebp)
  801ac6:	e8 ac 0c 00 00       	call   802777 <alloc_block_FF>
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801ad1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ad5:	74 2a                	je     801b01 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ada:	8b 40 08             	mov    0x8(%eax),%eax
  801add:	89 c2                	mov    %eax,%edx
  801adf:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ae3:	52                   	push   %edx
  801ae4:	50                   	push   %eax
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	ff 75 08             	pushl  0x8(%ebp)
  801aeb:	e8 92 03 00 00       	call   801e82 <sys_createSharedObject>
  801af0:	83 c4 10             	add    $0x10,%esp
  801af3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801af6:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801afa:	74 05                	je     801b01 <smalloc+0x95>
			return (void*)virtual_address;
  801afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aff:	eb 05                	jmp    801b06 <smalloc+0x9a>
	}
	return NULL;
  801b01:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b0e:	e8 c6 fc ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b13:	83 ec 04             	sub    $0x4,%esp
  801b16:	68 08 43 80 00       	push   $0x804308
  801b1b:	68 b0 00 00 00       	push   $0xb0
  801b20:	68 b3 42 80 00       	push   $0x8042b3
  801b25:	e8 71 ec ff ff       	call   80079b <_panic>

00801b2a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b30:	e8 a4 fc ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b35:	83 ec 04             	sub    $0x4,%esp
  801b38:	68 2c 43 80 00       	push   $0x80432c
  801b3d:	68 f4 00 00 00       	push   $0xf4
  801b42:	68 b3 42 80 00       	push   $0x8042b3
  801b47:	e8 4f ec ff ff       	call   80079b <_panic>

00801b4c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b52:	83 ec 04             	sub    $0x4,%esp
  801b55:	68 54 43 80 00       	push   $0x804354
  801b5a:	68 08 01 00 00       	push   $0x108
  801b5f:	68 b3 42 80 00       	push   $0x8042b3
  801b64:	e8 32 ec ff ff       	call   80079b <_panic>

00801b69 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b6f:	83 ec 04             	sub    $0x4,%esp
  801b72:	68 78 43 80 00       	push   $0x804378
  801b77:	68 13 01 00 00       	push   $0x113
  801b7c:	68 b3 42 80 00       	push   $0x8042b3
  801b81:	e8 15 ec ff ff       	call   80079b <_panic>

00801b86 <shrink>:

}
void shrink(uint32 newSize)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b8c:	83 ec 04             	sub    $0x4,%esp
  801b8f:	68 78 43 80 00       	push   $0x804378
  801b94:	68 18 01 00 00       	push   $0x118
  801b99:	68 b3 42 80 00       	push   $0x8042b3
  801b9e:	e8 f8 eb ff ff       	call   80079b <_panic>

00801ba3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	68 78 43 80 00       	push   $0x804378
  801bb1:	68 1d 01 00 00       	push   $0x11d
  801bb6:	68 b3 42 80 00       	push   $0x8042b3
  801bbb:	e8 db eb ff ff       	call   80079b <_panic>

00801bc0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	57                   	push   %edi
  801bc4:	56                   	push   %esi
  801bc5:	53                   	push   %ebx
  801bc6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bd5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bd8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bdb:	cd 30                	int    $0x30
  801bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	5b                   	pop    %ebx
  801be7:	5e                   	pop    %esi
  801be8:	5f                   	pop    %edi
  801be9:	5d                   	pop    %ebp
  801bea:	c3                   	ret    

00801beb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 04             	sub    $0x4,%esp
  801bf1:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801bf7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	52                   	push   %edx
  801c03:	ff 75 0c             	pushl  0xc(%ebp)
  801c06:	50                   	push   %eax
  801c07:	6a 00                	push   $0x0
  801c09:	e8 b2 ff ff ff       	call   801bc0 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 01                	push   $0x1
  801c23:	e8 98 ff ff ff       	call   801bc0 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	52                   	push   %edx
  801c3d:	50                   	push   %eax
  801c3e:	6a 05                	push   $0x5
  801c40:	e8 7b ff ff ff       	call   801bc0 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	56                   	push   %esi
  801c4e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c4f:	8b 75 18             	mov    0x18(%ebp),%esi
  801c52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	56                   	push   %esi
  801c5f:	53                   	push   %ebx
  801c60:	51                   	push   %ecx
  801c61:	52                   	push   %edx
  801c62:	50                   	push   %eax
  801c63:	6a 06                	push   $0x6
  801c65:	e8 56 ff ff ff       	call   801bc0 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    

00801c74 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	52                   	push   %edx
  801c84:	50                   	push   %eax
  801c85:	6a 07                	push   $0x7
  801c87:	e8 34 ff ff ff       	call   801bc0 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	ff 75 0c             	pushl  0xc(%ebp)
  801c9d:	ff 75 08             	pushl  0x8(%ebp)
  801ca0:	6a 08                	push   $0x8
  801ca2:	e8 19 ff ff ff       	call   801bc0 <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 09                	push   $0x9
  801cbb:	e8 00 ff ff ff       	call   801bc0 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 0a                	push   $0xa
  801cd4:	e8 e7 fe ff ff       	call   801bc0 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 0b                	push   $0xb
  801ced:	e8 ce fe ff ff       	call   801bc0 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	ff 75 08             	pushl  0x8(%ebp)
  801d06:	6a 0f                	push   $0xf
  801d08:	e8 b3 fe ff ff       	call   801bc0 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
	return;
  801d10:	90                   	nop
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	ff 75 0c             	pushl  0xc(%ebp)
  801d1f:	ff 75 08             	pushl  0x8(%ebp)
  801d22:	6a 10                	push   $0x10
  801d24:	e8 97 fe ff ff       	call   801bc0 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2c:	90                   	nop
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	ff 75 10             	pushl  0x10(%ebp)
  801d39:	ff 75 0c             	pushl  0xc(%ebp)
  801d3c:	ff 75 08             	pushl  0x8(%ebp)
  801d3f:	6a 11                	push   $0x11
  801d41:	e8 7a fe ff ff       	call   801bc0 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
	return ;
  801d49:	90                   	nop
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 0c                	push   $0xc
  801d5b:	e8 60 fe ff ff       	call   801bc0 <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	ff 75 08             	pushl  0x8(%ebp)
  801d73:	6a 0d                	push   $0xd
  801d75:	e8 46 fe ff ff       	call   801bc0 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 0e                	push   $0xe
  801d8e:	e8 2d fe ff ff       	call   801bc0 <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	90                   	nop
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 13                	push   $0x13
  801da8:	e8 13 fe ff ff       	call   801bc0 <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
}
  801db0:	90                   	nop
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 14                	push   $0x14
  801dc2:	e8 f9 fd ff ff       	call   801bc0 <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	90                   	nop
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_cputc>:


void
sys_cputc(const char c)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 04             	sub    $0x4,%esp
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801dd9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	50                   	push   %eax
  801de6:	6a 15                	push   $0x15
  801de8:	e8 d3 fd ff ff       	call   801bc0 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	90                   	nop
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 16                	push   $0x16
  801e02:	e8 b9 fd ff ff       	call   801bc0 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	90                   	nop
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	ff 75 0c             	pushl  0xc(%ebp)
  801e1c:	50                   	push   %eax
  801e1d:	6a 17                	push   $0x17
  801e1f:	e8 9c fd ff ff       	call   801bc0 <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	52                   	push   %edx
  801e39:	50                   	push   %eax
  801e3a:	6a 1a                	push   $0x1a
  801e3c:	e8 7f fd ff ff       	call   801bc0 <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	52                   	push   %edx
  801e56:	50                   	push   %eax
  801e57:	6a 18                	push   $0x18
  801e59:	e8 62 fd ff ff       	call   801bc0 <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
}
  801e61:	90                   	nop
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	52                   	push   %edx
  801e74:	50                   	push   %eax
  801e75:	6a 19                	push   $0x19
  801e77:	e8 44 fd ff ff       	call   801bc0 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
}
  801e7f:	90                   	nop
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	83 ec 04             	sub    $0x4,%esp
  801e88:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e91:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	6a 00                	push   $0x0
  801e9a:	51                   	push   %ecx
  801e9b:	52                   	push   %edx
  801e9c:	ff 75 0c             	pushl  0xc(%ebp)
  801e9f:	50                   	push   %eax
  801ea0:	6a 1b                	push   $0x1b
  801ea2:	e8 19 fd ff ff       	call   801bc0 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	52                   	push   %edx
  801ebc:	50                   	push   %eax
  801ebd:	6a 1c                	push   $0x1c
  801ebf:	e8 fc fc ff ff       	call   801bc0 <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ecc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	51                   	push   %ecx
  801eda:	52                   	push   %edx
  801edb:	50                   	push   %eax
  801edc:	6a 1d                	push   $0x1d
  801ede:	e8 dd fc ff ff       	call   801bc0 <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	52                   	push   %edx
  801ef8:	50                   	push   %eax
  801ef9:	6a 1e                	push   $0x1e
  801efb:	e8 c0 fc ff ff       	call   801bc0 <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 1f                	push   $0x1f
  801f14:	e8 a7 fc ff ff       	call   801bc0 <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	6a 00                	push   $0x0
  801f26:	ff 75 14             	pushl  0x14(%ebp)
  801f29:	ff 75 10             	pushl  0x10(%ebp)
  801f2c:	ff 75 0c             	pushl  0xc(%ebp)
  801f2f:	50                   	push   %eax
  801f30:	6a 20                	push   $0x20
  801f32:	e8 89 fc ff ff       	call   801bc0 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	50                   	push   %eax
  801f4b:	6a 21                	push   $0x21
  801f4d:	e8 6e fc ff ff       	call   801bc0 <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	90                   	nop
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	50                   	push   %eax
  801f67:	6a 22                	push   $0x22
  801f69:	e8 52 fc ff ff       	call   801bc0 <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 02                	push   $0x2
  801f82:	e8 39 fc ff ff       	call   801bc0 <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 03                	push   $0x3
  801f9b:	e8 20 fc ff ff       	call   801bc0 <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 04                	push   $0x4
  801fb4:	e8 07 fc ff ff       	call   801bc0 <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_exit_env>:


void sys_exit_env(void)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 23                	push   $0x23
  801fcd:	e8 ee fb ff ff       	call   801bc0 <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
}
  801fd5:	90                   	nop
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fde:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fe1:	8d 50 04             	lea    0x4(%eax),%edx
  801fe4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	52                   	push   %edx
  801fee:	50                   	push   %eax
  801fef:	6a 24                	push   $0x24
  801ff1:	e8 ca fb ff ff       	call   801bc0 <syscall>
  801ff6:	83 c4 18             	add    $0x18,%esp
	return result;
  801ff9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ffc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802002:	89 01                	mov    %eax,(%ecx)
  802004:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	c9                   	leave  
  80200b:	c2 04 00             	ret    $0x4

0080200e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	ff 75 10             	pushl  0x10(%ebp)
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	ff 75 08             	pushl  0x8(%ebp)
  80201e:	6a 12                	push   $0x12
  802020:	e8 9b fb ff ff       	call   801bc0 <syscall>
  802025:	83 c4 18             	add    $0x18,%esp
	return ;
  802028:	90                   	nop
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_rcr2>:
uint32 sys_rcr2()
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 25                	push   $0x25
  80203a:	e8 81 fb ff ff       	call   801bc0 <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 04             	sub    $0x4,%esp
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802050:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	50                   	push   %eax
  80205d:	6a 26                	push   $0x26
  80205f:	e8 5c fb ff ff       	call   801bc0 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
	return ;
  802067:	90                   	nop
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <rsttst>:
void rsttst()
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 28                	push   $0x28
  802079:	e8 42 fb ff ff       	call   801bc0 <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
	return ;
  802081:	90                   	nop
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	8b 45 14             	mov    0x14(%ebp),%eax
  80208d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802090:	8b 55 18             	mov    0x18(%ebp),%edx
  802093:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802097:	52                   	push   %edx
  802098:	50                   	push   %eax
  802099:	ff 75 10             	pushl  0x10(%ebp)
  80209c:	ff 75 0c             	pushl  0xc(%ebp)
  80209f:	ff 75 08             	pushl  0x8(%ebp)
  8020a2:	6a 27                	push   $0x27
  8020a4:	e8 17 fb ff ff       	call   801bc0 <syscall>
  8020a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ac:	90                   	nop
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <chktst>:
void chktst(uint32 n)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	ff 75 08             	pushl  0x8(%ebp)
  8020bd:	6a 29                	push   $0x29
  8020bf:	e8 fc fa ff ff       	call   801bc0 <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c7:	90                   	nop
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <inctst>:

void inctst()
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 2a                	push   $0x2a
  8020d9:	e8 e2 fa ff ff       	call   801bc0 <syscall>
  8020de:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e1:	90                   	nop
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <gettst>:
uint32 gettst()
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 2b                	push   $0x2b
  8020f3:	e8 c8 fa ff ff       	call   801bc0 <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 2c                	push   $0x2c
  80210f:	e8 ac fa ff ff       	call   801bc0 <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
  802117:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80211a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80211e:	75 07                	jne    802127 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802120:	b8 01 00 00 00       	mov    $0x1,%eax
  802125:	eb 05                	jmp    80212c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 2c                	push   $0x2c
  802140:	e8 7b fa ff ff       	call   801bc0 <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
  802148:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80214b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80214f:	75 07                	jne    802158 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802151:	b8 01 00 00 00       	mov    $0x1,%eax
  802156:	eb 05                	jmp    80215d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802158:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 2c                	push   $0x2c
  802171:	e8 4a fa ff ff       	call   801bc0 <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
  802179:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80217c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802180:	75 07                	jne    802189 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802182:	b8 01 00 00 00       	mov    $0x1,%eax
  802187:	eb 05                	jmp    80218e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802189:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 2c                	push   $0x2c
  8021a2:	e8 19 fa ff ff       	call   801bc0 <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
  8021aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021ad:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021b1:	75 07                	jne    8021ba <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b8:	eb 05                	jmp    8021bf <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	ff 75 08             	pushl  0x8(%ebp)
  8021cf:	6a 2d                	push   $0x2d
  8021d1:	e8 ea f9 ff ff       	call   801bc0 <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d9:	90                   	nop
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	6a 00                	push   $0x0
  8021ee:	53                   	push   %ebx
  8021ef:	51                   	push   %ecx
  8021f0:	52                   	push   %edx
  8021f1:	50                   	push   %eax
  8021f2:	6a 2e                	push   $0x2e
  8021f4:	e8 c7 f9 ff ff       	call   801bc0 <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
}
  8021fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802204:	8b 55 0c             	mov    0xc(%ebp),%edx
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	52                   	push   %edx
  802211:	50                   	push   %eax
  802212:	6a 2f                	push   $0x2f
  802214:	e8 a7 f9 ff ff       	call   801bc0 <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802224:	83 ec 0c             	sub    $0xc,%esp
  802227:	68 88 43 80 00       	push   $0x804388
  80222c:	e8 1e e8 ff ff       	call   800a4f <cprintf>
  802231:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802234:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80223b:	83 ec 0c             	sub    $0xc,%esp
  80223e:	68 b4 43 80 00       	push   $0x8043b4
  802243:	e8 07 e8 ff ff       	call   800a4f <cprintf>
  802248:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80224b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80224f:	a1 38 51 80 00       	mov    0x805138,%eax
  802254:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802257:	eb 56                	jmp    8022af <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802259:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80225d:	74 1c                	je     80227b <print_mem_block_lists+0x5d>
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	8b 50 08             	mov    0x8(%eax),%edx
  802265:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802268:	8b 48 08             	mov    0x8(%eax),%ecx
  80226b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226e:	8b 40 0c             	mov    0xc(%eax),%eax
  802271:	01 c8                	add    %ecx,%eax
  802273:	39 c2                	cmp    %eax,%edx
  802275:	73 04                	jae    80227b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802277:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227e:	8b 50 08             	mov    0x8(%eax),%edx
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 40 0c             	mov    0xc(%eax),%eax
  802287:	01 c2                	add    %eax,%edx
  802289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228c:	8b 40 08             	mov    0x8(%eax),%eax
  80228f:	83 ec 04             	sub    $0x4,%esp
  802292:	52                   	push   %edx
  802293:	50                   	push   %eax
  802294:	68 c9 43 80 00       	push   $0x8043c9
  802299:	e8 b1 e7 ff ff       	call   800a4f <cprintf>
  80229e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022a7:	a1 40 51 80 00       	mov    0x805140,%eax
  8022ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b3:	74 07                	je     8022bc <print_mem_block_lists+0x9e>
  8022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b8:	8b 00                	mov    (%eax),%eax
  8022ba:	eb 05                	jmp    8022c1 <print_mem_block_lists+0xa3>
  8022bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c1:	a3 40 51 80 00       	mov    %eax,0x805140
  8022c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	75 8a                	jne    802259 <print_mem_block_lists+0x3b>
  8022cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d3:	75 84                	jne    802259 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8022d5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022d9:	75 10                	jne    8022eb <print_mem_block_lists+0xcd>
  8022db:	83 ec 0c             	sub    $0xc,%esp
  8022de:	68 d8 43 80 00       	push   $0x8043d8
  8022e3:	e8 67 e7 ff ff       	call   800a4f <cprintf>
  8022e8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8022eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8022f2:	83 ec 0c             	sub    $0xc,%esp
  8022f5:	68 fc 43 80 00       	push   $0x8043fc
  8022fa:	e8 50 e7 ff ff       	call   800a4f <cprintf>
  8022ff:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802302:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802306:	a1 40 50 80 00       	mov    0x805040,%eax
  80230b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230e:	eb 56                	jmp    802366 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802310:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802314:	74 1c                	je     802332 <print_mem_block_lists+0x114>
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 50 08             	mov    0x8(%eax),%edx
  80231c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231f:	8b 48 08             	mov    0x8(%eax),%ecx
  802322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802325:	8b 40 0c             	mov    0xc(%eax),%eax
  802328:	01 c8                	add    %ecx,%eax
  80232a:	39 c2                	cmp    %eax,%edx
  80232c:	73 04                	jae    802332 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80232e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	8b 50 08             	mov    0x8(%eax),%edx
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	8b 40 0c             	mov    0xc(%eax),%eax
  80233e:	01 c2                	add    %eax,%edx
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 40 08             	mov    0x8(%eax),%eax
  802346:	83 ec 04             	sub    $0x4,%esp
  802349:	52                   	push   %edx
  80234a:	50                   	push   %eax
  80234b:	68 c9 43 80 00       	push   $0x8043c9
  802350:	e8 fa e6 ff ff       	call   800a4f <cprintf>
  802355:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80235e:	a1 48 50 80 00       	mov    0x805048,%eax
  802363:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236a:	74 07                	je     802373 <print_mem_block_lists+0x155>
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 00                	mov    (%eax),%eax
  802371:	eb 05                	jmp    802378 <print_mem_block_lists+0x15a>
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
  802378:	a3 48 50 80 00       	mov    %eax,0x805048
  80237d:	a1 48 50 80 00       	mov    0x805048,%eax
  802382:	85 c0                	test   %eax,%eax
  802384:	75 8a                	jne    802310 <print_mem_block_lists+0xf2>
  802386:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238a:	75 84                	jne    802310 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80238c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802390:	75 10                	jne    8023a2 <print_mem_block_lists+0x184>
  802392:	83 ec 0c             	sub    $0xc,%esp
  802395:	68 14 44 80 00       	push   $0x804414
  80239a:	e8 b0 e6 ff ff       	call   800a4f <cprintf>
  80239f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8023a2:	83 ec 0c             	sub    $0xc,%esp
  8023a5:	68 88 43 80 00       	push   $0x804388
  8023aa:	e8 a0 e6 ff ff       	call   800a4f <cprintf>
  8023af:	83 c4 10             	add    $0x10,%esp

}
  8023b2:	90                   	nop
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
  8023b8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8023bb:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8023c2:	00 00 00 
  8023c5:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8023cc:	00 00 00 
  8023cf:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8023d6:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8023d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8023e0:	e9 9e 00 00 00       	jmp    802483 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8023e5:	a1 50 50 80 00       	mov    0x805050,%eax
  8023ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ed:	c1 e2 04             	shl    $0x4,%edx
  8023f0:	01 d0                	add    %edx,%eax
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	75 14                	jne    80240a <initialize_MemBlocksList+0x55>
  8023f6:	83 ec 04             	sub    $0x4,%esp
  8023f9:	68 3c 44 80 00       	push   $0x80443c
  8023fe:	6a 46                	push   $0x46
  802400:	68 5f 44 80 00       	push   $0x80445f
  802405:	e8 91 e3 ff ff       	call   80079b <_panic>
  80240a:	a1 50 50 80 00       	mov    0x805050,%eax
  80240f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802412:	c1 e2 04             	shl    $0x4,%edx
  802415:	01 d0                	add    %edx,%eax
  802417:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80241d:	89 10                	mov    %edx,(%eax)
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	85 c0                	test   %eax,%eax
  802423:	74 18                	je     80243d <initialize_MemBlocksList+0x88>
  802425:	a1 48 51 80 00       	mov    0x805148,%eax
  80242a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802430:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802433:	c1 e1 04             	shl    $0x4,%ecx
  802436:	01 ca                	add    %ecx,%edx
  802438:	89 50 04             	mov    %edx,0x4(%eax)
  80243b:	eb 12                	jmp    80244f <initialize_MemBlocksList+0x9a>
  80243d:	a1 50 50 80 00       	mov    0x805050,%eax
  802442:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802445:	c1 e2 04             	shl    $0x4,%edx
  802448:	01 d0                	add    %edx,%eax
  80244a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80244f:	a1 50 50 80 00       	mov    0x805050,%eax
  802454:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802457:	c1 e2 04             	shl    $0x4,%edx
  80245a:	01 d0                	add    %edx,%eax
  80245c:	a3 48 51 80 00       	mov    %eax,0x805148
  802461:	a1 50 50 80 00       	mov    0x805050,%eax
  802466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802469:	c1 e2 04             	shl    $0x4,%edx
  80246c:	01 d0                	add    %edx,%eax
  80246e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802475:	a1 54 51 80 00       	mov    0x805154,%eax
  80247a:	40                   	inc    %eax
  80247b:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802480:	ff 45 f4             	incl   -0xc(%ebp)
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	3b 45 08             	cmp    0x8(%ebp),%eax
  802489:	0f 82 56 ff ff ff    	jb     8023e5 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80248f:	90                   	nop
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024a0:	eb 19                	jmp    8024bb <find_block+0x29>
	{
		if(va==point->sva)
  8024a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024a5:	8b 40 08             	mov    0x8(%eax),%eax
  8024a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024ab:	75 05                	jne    8024b2 <find_block+0x20>
		   return point;
  8024ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024b0:	eb 36                	jmp    8024e8 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	8b 40 08             	mov    0x8(%eax),%eax
  8024b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024bf:	74 07                	je     8024c8 <find_block+0x36>
  8024c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c4:	8b 00                	mov    (%eax),%eax
  8024c6:	eb 05                	jmp    8024cd <find_block+0x3b>
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d0:	89 42 08             	mov    %eax,0x8(%edx)
  8024d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d6:	8b 40 08             	mov    0x8(%eax),%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	75 c5                	jne    8024a2 <find_block+0x10>
  8024dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024e1:	75 bf                	jne    8024a2 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8024e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8024f0:	a1 40 50 80 00       	mov    0x805040,%eax
  8024f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8024f8:	a1 44 50 80 00       	mov    0x805044,%eax
  8024fd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802503:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802506:	74 24                	je     80252c <insert_sorted_allocList+0x42>
  802508:	8b 45 08             	mov    0x8(%ebp),%eax
  80250b:	8b 50 08             	mov    0x8(%eax),%edx
  80250e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802511:	8b 40 08             	mov    0x8(%eax),%eax
  802514:	39 c2                	cmp    %eax,%edx
  802516:	76 14                	jbe    80252c <insert_sorted_allocList+0x42>
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	8b 50 08             	mov    0x8(%eax),%edx
  80251e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802521:	8b 40 08             	mov    0x8(%eax),%eax
  802524:	39 c2                	cmp    %eax,%edx
  802526:	0f 82 60 01 00 00    	jb     80268c <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80252c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802530:	75 65                	jne    802597 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802532:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802536:	75 14                	jne    80254c <insert_sorted_allocList+0x62>
  802538:	83 ec 04             	sub    $0x4,%esp
  80253b:	68 3c 44 80 00       	push   $0x80443c
  802540:	6a 6b                	push   $0x6b
  802542:	68 5f 44 80 00       	push   $0x80445f
  802547:	e8 4f e2 ff ff       	call   80079b <_panic>
  80254c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802552:	8b 45 08             	mov    0x8(%ebp),%eax
  802555:	89 10                	mov    %edx,(%eax)
  802557:	8b 45 08             	mov    0x8(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	85 c0                	test   %eax,%eax
  80255e:	74 0d                	je     80256d <insert_sorted_allocList+0x83>
  802560:	a1 40 50 80 00       	mov    0x805040,%eax
  802565:	8b 55 08             	mov    0x8(%ebp),%edx
  802568:	89 50 04             	mov    %edx,0x4(%eax)
  80256b:	eb 08                	jmp    802575 <insert_sorted_allocList+0x8b>
  80256d:	8b 45 08             	mov    0x8(%ebp),%eax
  802570:	a3 44 50 80 00       	mov    %eax,0x805044
  802575:	8b 45 08             	mov    0x8(%ebp),%eax
  802578:	a3 40 50 80 00       	mov    %eax,0x805040
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802587:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80258c:	40                   	inc    %eax
  80258d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802592:	e9 dc 01 00 00       	jmp    802773 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	8b 50 08             	mov    0x8(%eax),%edx
  80259d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a0:	8b 40 08             	mov    0x8(%eax),%eax
  8025a3:	39 c2                	cmp    %eax,%edx
  8025a5:	77 6c                	ja     802613 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8025a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ab:	74 06                	je     8025b3 <insert_sorted_allocList+0xc9>
  8025ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025b1:	75 14                	jne    8025c7 <insert_sorted_allocList+0xdd>
  8025b3:	83 ec 04             	sub    $0x4,%esp
  8025b6:	68 78 44 80 00       	push   $0x804478
  8025bb:	6a 6f                	push   $0x6f
  8025bd:	68 5f 44 80 00       	push   $0x80445f
  8025c2:	e8 d4 e1 ff ff       	call   80079b <_panic>
  8025c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ca:	8b 50 04             	mov    0x4(%eax),%edx
  8025cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d0:	89 50 04             	mov    %edx,0x4(%eax)
  8025d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025d9:	89 10                	mov    %edx,(%eax)
  8025db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025de:	8b 40 04             	mov    0x4(%eax),%eax
  8025e1:	85 c0                	test   %eax,%eax
  8025e3:	74 0d                	je     8025f2 <insert_sorted_allocList+0x108>
  8025e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e8:	8b 40 04             	mov    0x4(%eax),%eax
  8025eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ee:	89 10                	mov    %edx,(%eax)
  8025f0:	eb 08                	jmp    8025fa <insert_sorted_allocList+0x110>
  8025f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f5:	a3 40 50 80 00       	mov    %eax,0x805040
  8025fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802600:	89 50 04             	mov    %edx,0x4(%eax)
  802603:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802608:	40                   	inc    %eax
  802609:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80260e:	e9 60 01 00 00       	jmp    802773 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	8b 50 08             	mov    0x8(%eax),%edx
  802619:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261c:	8b 40 08             	mov    0x8(%eax),%eax
  80261f:	39 c2                	cmp    %eax,%edx
  802621:	0f 82 4c 01 00 00    	jb     802773 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802627:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80262b:	75 14                	jne    802641 <insert_sorted_allocList+0x157>
  80262d:	83 ec 04             	sub    $0x4,%esp
  802630:	68 b0 44 80 00       	push   $0x8044b0
  802635:	6a 73                	push   $0x73
  802637:	68 5f 44 80 00       	push   $0x80445f
  80263c:	e8 5a e1 ff ff       	call   80079b <_panic>
  802641:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	89 50 04             	mov    %edx,0x4(%eax)
  80264d:	8b 45 08             	mov    0x8(%ebp),%eax
  802650:	8b 40 04             	mov    0x4(%eax),%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	74 0c                	je     802663 <insert_sorted_allocList+0x179>
  802657:	a1 44 50 80 00       	mov    0x805044,%eax
  80265c:	8b 55 08             	mov    0x8(%ebp),%edx
  80265f:	89 10                	mov    %edx,(%eax)
  802661:	eb 08                	jmp    80266b <insert_sorted_allocList+0x181>
  802663:	8b 45 08             	mov    0x8(%ebp),%eax
  802666:	a3 40 50 80 00       	mov    %eax,0x805040
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	a3 44 50 80 00       	mov    %eax,0x805044
  802673:	8b 45 08             	mov    0x8(%ebp),%eax
  802676:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802681:	40                   	inc    %eax
  802682:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802687:	e9 e7 00 00 00       	jmp    802773 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80268c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802692:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802699:	a1 40 50 80 00       	mov    0x805040,%eax
  80269e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a1:	e9 9d 00 00 00       	jmp    802743 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 00                	mov    (%eax),%eax
  8026ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	8b 50 08             	mov    0x8(%eax),%edx
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	8b 40 08             	mov    0x8(%eax),%eax
  8026ba:	39 c2                	cmp    %eax,%edx
  8026bc:	76 7d                	jbe    80273b <insert_sorted_allocList+0x251>
  8026be:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c1:	8b 50 08             	mov    0x8(%eax),%edx
  8026c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c7:	8b 40 08             	mov    0x8(%eax),%eax
  8026ca:	39 c2                	cmp    %eax,%edx
  8026cc:	73 6d                	jae    80273b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8026ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d2:	74 06                	je     8026da <insert_sorted_allocList+0x1f0>
  8026d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026d8:	75 14                	jne    8026ee <insert_sorted_allocList+0x204>
  8026da:	83 ec 04             	sub    $0x4,%esp
  8026dd:	68 d4 44 80 00       	push   $0x8044d4
  8026e2:	6a 7f                	push   $0x7f
  8026e4:	68 5f 44 80 00       	push   $0x80445f
  8026e9:	e8 ad e0 ff ff       	call   80079b <_panic>
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 10                	mov    (%eax),%edx
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	89 10                	mov    %edx,(%eax)
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	8b 00                	mov    (%eax),%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	74 0b                	je     80270c <insert_sorted_allocList+0x222>
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 00                	mov    (%eax),%eax
  802706:	8b 55 08             	mov    0x8(%ebp),%edx
  802709:	89 50 04             	mov    %edx,0x4(%eax)
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 55 08             	mov    0x8(%ebp),%edx
  802712:	89 10                	mov    %edx,(%eax)
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271a:	89 50 04             	mov    %edx,0x4(%eax)
  80271d:	8b 45 08             	mov    0x8(%ebp),%eax
  802720:	8b 00                	mov    (%eax),%eax
  802722:	85 c0                	test   %eax,%eax
  802724:	75 08                	jne    80272e <insert_sorted_allocList+0x244>
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	a3 44 50 80 00       	mov    %eax,0x805044
  80272e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802733:	40                   	inc    %eax
  802734:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802739:	eb 39                	jmp    802774 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80273b:	a1 48 50 80 00       	mov    0x805048,%eax
  802740:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802747:	74 07                	je     802750 <insert_sorted_allocList+0x266>
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 00                	mov    (%eax),%eax
  80274e:	eb 05                	jmp    802755 <insert_sorted_allocList+0x26b>
  802750:	b8 00 00 00 00       	mov    $0x0,%eax
  802755:	a3 48 50 80 00       	mov    %eax,0x805048
  80275a:	a1 48 50 80 00       	mov    0x805048,%eax
  80275f:	85 c0                	test   %eax,%eax
  802761:	0f 85 3f ff ff ff    	jne    8026a6 <insert_sorted_allocList+0x1bc>
  802767:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276b:	0f 85 35 ff ff ff    	jne    8026a6 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802771:	eb 01                	jmp    802774 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802773:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802774:	90                   	nop
  802775:	c9                   	leave  
  802776:	c3                   	ret    

00802777 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
  80277a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80277d:	a1 38 51 80 00       	mov    0x805138,%eax
  802782:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802785:	e9 85 01 00 00       	jmp    80290f <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 40 0c             	mov    0xc(%eax),%eax
  802790:	3b 45 08             	cmp    0x8(%ebp),%eax
  802793:	0f 82 6e 01 00 00    	jb     802907 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 0c             	mov    0xc(%eax),%eax
  80279f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a2:	0f 85 8a 00 00 00    	jne    802832 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8027a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ac:	75 17                	jne    8027c5 <alloc_block_FF+0x4e>
  8027ae:	83 ec 04             	sub    $0x4,%esp
  8027b1:	68 08 45 80 00       	push   $0x804508
  8027b6:	68 93 00 00 00       	push   $0x93
  8027bb:	68 5f 44 80 00       	push   $0x80445f
  8027c0:	e8 d6 df ff ff       	call   80079b <_panic>
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 00                	mov    (%eax),%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	74 10                	je     8027de <alloc_block_FF+0x67>
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	8b 00                	mov    (%eax),%eax
  8027d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d6:	8b 52 04             	mov    0x4(%edx),%edx
  8027d9:	89 50 04             	mov    %edx,0x4(%eax)
  8027dc:	eb 0b                	jmp    8027e9 <alloc_block_FF+0x72>
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	8b 40 04             	mov    0x4(%eax),%eax
  8027e4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 04             	mov    0x4(%eax),%eax
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	74 0f                	je     802802 <alloc_block_FF+0x8b>
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 04             	mov    0x4(%eax),%eax
  8027f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fc:	8b 12                	mov    (%edx),%edx
  8027fe:	89 10                	mov    %edx,(%eax)
  802800:	eb 0a                	jmp    80280c <alloc_block_FF+0x95>
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 00                	mov    (%eax),%eax
  802807:	a3 38 51 80 00       	mov    %eax,0x805138
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281f:	a1 44 51 80 00       	mov    0x805144,%eax
  802824:	48                   	dec    %eax
  802825:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	e9 10 01 00 00       	jmp    802942 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 40 0c             	mov    0xc(%eax),%eax
  802838:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283b:	0f 86 c6 00 00 00    	jbe    802907 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802841:	a1 48 51 80 00       	mov    0x805148,%eax
  802846:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 50 08             	mov    0x8(%eax),%edx
  80284f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802852:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802858:	8b 55 08             	mov    0x8(%ebp),%edx
  80285b:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80285e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802862:	75 17                	jne    80287b <alloc_block_FF+0x104>
  802864:	83 ec 04             	sub    $0x4,%esp
  802867:	68 08 45 80 00       	push   $0x804508
  80286c:	68 9b 00 00 00       	push   $0x9b
  802871:	68 5f 44 80 00       	push   $0x80445f
  802876:	e8 20 df ff ff       	call   80079b <_panic>
  80287b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287e:	8b 00                	mov    (%eax),%eax
  802880:	85 c0                	test   %eax,%eax
  802882:	74 10                	je     802894 <alloc_block_FF+0x11d>
  802884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802887:	8b 00                	mov    (%eax),%eax
  802889:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80288c:	8b 52 04             	mov    0x4(%edx),%edx
  80288f:	89 50 04             	mov    %edx,0x4(%eax)
  802892:	eb 0b                	jmp    80289f <alloc_block_FF+0x128>
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	8b 40 04             	mov    0x4(%eax),%eax
  80289a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80289f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a2:	8b 40 04             	mov    0x4(%eax),%eax
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	74 0f                	je     8028b8 <alloc_block_FF+0x141>
  8028a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b2:	8b 12                	mov    (%edx),%edx
  8028b4:	89 10                	mov    %edx,(%eax)
  8028b6:	eb 0a                	jmp    8028c2 <alloc_block_FF+0x14b>
  8028b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bb:	8b 00                	mov    (%eax),%eax
  8028bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8028c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d5:	a1 54 51 80 00       	mov    0x805154,%eax
  8028da:	48                   	dec    %eax
  8028db:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 50 08             	mov    0x8(%eax),%edx
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	01 c2                	add    %eax,%edx
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f7:	2b 45 08             	sub    0x8(%ebp),%eax
  8028fa:	89 c2                	mov    %eax,%edx
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	eb 3b                	jmp    802942 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802907:	a1 40 51 80 00       	mov    0x805140,%eax
  80290c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802913:	74 07                	je     80291c <alloc_block_FF+0x1a5>
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	8b 00                	mov    (%eax),%eax
  80291a:	eb 05                	jmp    802921 <alloc_block_FF+0x1aa>
  80291c:	b8 00 00 00 00       	mov    $0x0,%eax
  802921:	a3 40 51 80 00       	mov    %eax,0x805140
  802926:	a1 40 51 80 00       	mov    0x805140,%eax
  80292b:	85 c0                	test   %eax,%eax
  80292d:	0f 85 57 fe ff ff    	jne    80278a <alloc_block_FF+0x13>
  802933:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802937:	0f 85 4d fe ff ff    	jne    80278a <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80293d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802942:	c9                   	leave  
  802943:	c3                   	ret    

00802944 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
  802947:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80294a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802951:	a1 38 51 80 00       	mov    0x805138,%eax
  802956:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802959:	e9 df 00 00 00       	jmp    802a3d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 40 0c             	mov    0xc(%eax),%eax
  802964:	3b 45 08             	cmp    0x8(%ebp),%eax
  802967:	0f 82 c8 00 00 00    	jb     802a35 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 40 0c             	mov    0xc(%eax),%eax
  802973:	3b 45 08             	cmp    0x8(%ebp),%eax
  802976:	0f 85 8a 00 00 00    	jne    802a06 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80297c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802980:	75 17                	jne    802999 <alloc_block_BF+0x55>
  802982:	83 ec 04             	sub    $0x4,%esp
  802985:	68 08 45 80 00       	push   $0x804508
  80298a:	68 b7 00 00 00       	push   $0xb7
  80298f:	68 5f 44 80 00       	push   $0x80445f
  802994:	e8 02 de ff ff       	call   80079b <_panic>
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	74 10                	je     8029b2 <alloc_block_BF+0x6e>
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 00                	mov    (%eax),%eax
  8029a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029aa:	8b 52 04             	mov    0x4(%edx),%edx
  8029ad:	89 50 04             	mov    %edx,0x4(%eax)
  8029b0:	eb 0b                	jmp    8029bd <alloc_block_BF+0x79>
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 40 04             	mov    0x4(%eax),%eax
  8029b8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 40 04             	mov    0x4(%eax),%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	74 0f                	je     8029d6 <alloc_block_BF+0x92>
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d0:	8b 12                	mov    (%edx),%edx
  8029d2:	89 10                	mov    %edx,(%eax)
  8029d4:	eb 0a                	jmp    8029e0 <alloc_block_BF+0x9c>
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	a3 38 51 80 00       	mov    %eax,0x805138
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f3:	a1 44 51 80 00       	mov    0x805144,%eax
  8029f8:	48                   	dec    %eax
  8029f9:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	e9 4d 01 00 00       	jmp    802b53 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a0f:	76 24                	jbe    802a35 <alloc_block_BF+0xf1>
  802a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a14:	8b 40 0c             	mov    0xc(%eax),%eax
  802a17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a1a:	73 19                	jae    802a35 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802a1c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 40 0c             	mov    0xc(%eax),%eax
  802a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 40 08             	mov    0x8(%eax),%eax
  802a32:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a35:	a1 40 51 80 00       	mov    0x805140,%eax
  802a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a41:	74 07                	je     802a4a <alloc_block_BF+0x106>
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	eb 05                	jmp    802a4f <alloc_block_BF+0x10b>
  802a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4f:	a3 40 51 80 00       	mov    %eax,0x805140
  802a54:	a1 40 51 80 00       	mov    0x805140,%eax
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	0f 85 fd fe ff ff    	jne    80295e <alloc_block_BF+0x1a>
  802a61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a65:	0f 85 f3 fe ff ff    	jne    80295e <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802a6b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a6f:	0f 84 d9 00 00 00    	je     802b4e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a75:	a1 48 51 80 00       	mov    0x805148,%eax
  802a7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802a7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a83:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a89:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8c:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802a8f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a93:	75 17                	jne    802aac <alloc_block_BF+0x168>
  802a95:	83 ec 04             	sub    $0x4,%esp
  802a98:	68 08 45 80 00       	push   $0x804508
  802a9d:	68 c7 00 00 00       	push   $0xc7
  802aa2:	68 5f 44 80 00       	push   $0x80445f
  802aa7:	e8 ef dc ff ff       	call   80079b <_panic>
  802aac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aaf:	8b 00                	mov    (%eax),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	74 10                	je     802ac5 <alloc_block_BF+0x181>
  802ab5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802abd:	8b 52 04             	mov    0x4(%edx),%edx
  802ac0:	89 50 04             	mov    %edx,0x4(%eax)
  802ac3:	eb 0b                	jmp    802ad0 <alloc_block_BF+0x18c>
  802ac5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac8:	8b 40 04             	mov    0x4(%eax),%eax
  802acb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad3:	8b 40 04             	mov    0x4(%eax),%eax
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	74 0f                	je     802ae9 <alloc_block_BF+0x1a5>
  802ada:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ae3:	8b 12                	mov    (%edx),%edx
  802ae5:	89 10                	mov    %edx,(%eax)
  802ae7:	eb 0a                	jmp    802af3 <alloc_block_BF+0x1af>
  802ae9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	a3 48 51 80 00       	mov    %eax,0x805148
  802af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b06:	a1 54 51 80 00       	mov    0x805154,%eax
  802b0b:	48                   	dec    %eax
  802b0c:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802b11:	83 ec 08             	sub    $0x8,%esp
  802b14:	ff 75 ec             	pushl  -0x14(%ebp)
  802b17:	68 38 51 80 00       	push   $0x805138
  802b1c:	e8 71 f9 ff ff       	call   802492 <find_block>
  802b21:	83 c4 10             	add    $0x10,%esp
  802b24:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2a:	8b 50 08             	mov    0x8(%eax),%edx
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	01 c2                	add    %eax,%edx
  802b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b35:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802b38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3e:	2b 45 08             	sub    0x8(%ebp),%eax
  802b41:	89 c2                	mov    %eax,%edx
  802b43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b46:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4c:	eb 05                	jmp    802b53 <alloc_block_BF+0x20f>
	}
	return NULL;
  802b4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b53:	c9                   	leave  
  802b54:	c3                   	ret    

00802b55 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b55:	55                   	push   %ebp
  802b56:	89 e5                	mov    %esp,%ebp
  802b58:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802b5b:	a1 28 50 80 00       	mov    0x805028,%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	0f 85 de 01 00 00    	jne    802d46 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b68:	a1 38 51 80 00       	mov    0x805138,%eax
  802b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b70:	e9 9e 01 00 00       	jmp    802d13 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b7e:	0f 82 87 01 00 00    	jb     802d0b <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8d:	0f 85 95 00 00 00    	jne    802c28 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802b93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b97:	75 17                	jne    802bb0 <alloc_block_NF+0x5b>
  802b99:	83 ec 04             	sub    $0x4,%esp
  802b9c:	68 08 45 80 00       	push   $0x804508
  802ba1:	68 e0 00 00 00       	push   $0xe0
  802ba6:	68 5f 44 80 00       	push   $0x80445f
  802bab:	e8 eb db ff ff       	call   80079b <_panic>
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	85 c0                	test   %eax,%eax
  802bb7:	74 10                	je     802bc9 <alloc_block_NF+0x74>
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 00                	mov    (%eax),%eax
  802bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc1:	8b 52 04             	mov    0x4(%edx),%edx
  802bc4:	89 50 04             	mov    %edx,0x4(%eax)
  802bc7:	eb 0b                	jmp    802bd4 <alloc_block_NF+0x7f>
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 40 04             	mov    0x4(%eax),%eax
  802bcf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 40 04             	mov    0x4(%eax),%eax
  802bda:	85 c0                	test   %eax,%eax
  802bdc:	74 0f                	je     802bed <alloc_block_NF+0x98>
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	8b 40 04             	mov    0x4(%eax),%eax
  802be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be7:	8b 12                	mov    (%edx),%edx
  802be9:	89 10                	mov    %edx,(%eax)
  802beb:	eb 0a                	jmp    802bf7 <alloc_block_NF+0xa2>
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 00                	mov    (%eax),%eax
  802bf2:	a3 38 51 80 00       	mov    %eax,0x805138
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0a:	a1 44 51 80 00       	mov    0x805144,%eax
  802c0f:	48                   	dec    %eax
  802c10:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	8b 40 08             	mov    0x8(%eax),%eax
  802c1b:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	e9 f8 04 00 00       	jmp    803120 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c31:	0f 86 d4 00 00 00    	jbe    802d0b <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c37:	a1 48 51 80 00       	mov    0x805148,%eax
  802c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	8b 50 08             	mov    0x8(%eax),%edx
  802c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c48:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c51:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c58:	75 17                	jne    802c71 <alloc_block_NF+0x11c>
  802c5a:	83 ec 04             	sub    $0x4,%esp
  802c5d:	68 08 45 80 00       	push   $0x804508
  802c62:	68 e9 00 00 00       	push   $0xe9
  802c67:	68 5f 44 80 00       	push   $0x80445f
  802c6c:	e8 2a db ff ff       	call   80079b <_panic>
  802c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c74:	8b 00                	mov    (%eax),%eax
  802c76:	85 c0                	test   %eax,%eax
  802c78:	74 10                	je     802c8a <alloc_block_NF+0x135>
  802c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c82:	8b 52 04             	mov    0x4(%edx),%edx
  802c85:	89 50 04             	mov    %edx,0x4(%eax)
  802c88:	eb 0b                	jmp    802c95 <alloc_block_NF+0x140>
  802c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8d:	8b 40 04             	mov    0x4(%eax),%eax
  802c90:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c98:	8b 40 04             	mov    0x4(%eax),%eax
  802c9b:	85 c0                	test   %eax,%eax
  802c9d:	74 0f                	je     802cae <alloc_block_NF+0x159>
  802c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca2:	8b 40 04             	mov    0x4(%eax),%eax
  802ca5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca8:	8b 12                	mov    (%edx),%edx
  802caa:	89 10                	mov    %edx,(%eax)
  802cac:	eb 0a                	jmp    802cb8 <alloc_block_NF+0x163>
  802cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	a3 48 51 80 00       	mov    %eax,0x805148
  802cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccb:	a1 54 51 80 00       	mov    0x805154,%eax
  802cd0:	48                   	dec    %eax
  802cd1:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd9:	8b 40 08             	mov    0x8(%eax),%eax
  802cdc:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 50 08             	mov    0x8(%eax),%edx
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	01 c2                	add    %eax,%edx
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf8:	2b 45 08             	sub    0x8(%ebp),%eax
  802cfb:	89 c2                	mov    %eax,%edx
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d06:	e9 15 04 00 00       	jmp    803120 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d0b:	a1 40 51 80 00       	mov    0x805140,%eax
  802d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d17:	74 07                	je     802d20 <alloc_block_NF+0x1cb>
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	eb 05                	jmp    802d25 <alloc_block_NF+0x1d0>
  802d20:	b8 00 00 00 00       	mov    $0x0,%eax
  802d25:	a3 40 51 80 00       	mov    %eax,0x805140
  802d2a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	0f 85 3e fe ff ff    	jne    802b75 <alloc_block_NF+0x20>
  802d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3b:	0f 85 34 fe ff ff    	jne    802b75 <alloc_block_NF+0x20>
  802d41:	e9 d5 03 00 00       	jmp    80311b <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d46:	a1 38 51 80 00       	mov    0x805138,%eax
  802d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4e:	e9 b1 01 00 00       	jmp    802f04 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d56:	8b 50 08             	mov    0x8(%eax),%edx
  802d59:	a1 28 50 80 00       	mov    0x805028,%eax
  802d5e:	39 c2                	cmp    %eax,%edx
  802d60:	0f 82 96 01 00 00    	jb     802efc <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d6f:	0f 82 87 01 00 00    	jb     802efc <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d7e:	0f 85 95 00 00 00    	jne    802e19 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d88:	75 17                	jne    802da1 <alloc_block_NF+0x24c>
  802d8a:	83 ec 04             	sub    $0x4,%esp
  802d8d:	68 08 45 80 00       	push   $0x804508
  802d92:	68 fc 00 00 00       	push   $0xfc
  802d97:	68 5f 44 80 00       	push   $0x80445f
  802d9c:	e8 fa d9 ff ff       	call   80079b <_panic>
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	85 c0                	test   %eax,%eax
  802da8:	74 10                	je     802dba <alloc_block_NF+0x265>
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db2:	8b 52 04             	mov    0x4(%edx),%edx
  802db5:	89 50 04             	mov    %edx,0x4(%eax)
  802db8:	eb 0b                	jmp    802dc5 <alloc_block_NF+0x270>
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 40 04             	mov    0x4(%eax),%eax
  802dc0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 40 04             	mov    0x4(%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 0f                	je     802dde <alloc_block_NF+0x289>
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd8:	8b 12                	mov    (%edx),%edx
  802dda:	89 10                	mov    %edx,(%eax)
  802ddc:	eb 0a                	jmp    802de8 <alloc_block_NF+0x293>
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	a3 38 51 80 00       	mov    %eax,0x805138
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfb:	a1 44 51 80 00       	mov    0x805144,%eax
  802e00:	48                   	dec    %eax
  802e01:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 40 08             	mov    0x8(%eax),%eax
  802e0c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e14:	e9 07 03 00 00       	jmp    803120 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e22:	0f 86 d4 00 00 00    	jbe    802efc <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e28:	a1 48 51 80 00       	mov    0x805148,%eax
  802e2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	8b 50 08             	mov    0x8(%eax),%edx
  802e36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e39:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e42:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e49:	75 17                	jne    802e62 <alloc_block_NF+0x30d>
  802e4b:	83 ec 04             	sub    $0x4,%esp
  802e4e:	68 08 45 80 00       	push   $0x804508
  802e53:	68 04 01 00 00       	push   $0x104
  802e58:	68 5f 44 80 00       	push   $0x80445f
  802e5d:	e8 39 d9 ff ff       	call   80079b <_panic>
  802e62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e65:	8b 00                	mov    (%eax),%eax
  802e67:	85 c0                	test   %eax,%eax
  802e69:	74 10                	je     802e7b <alloc_block_NF+0x326>
  802e6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e73:	8b 52 04             	mov    0x4(%edx),%edx
  802e76:	89 50 04             	mov    %edx,0x4(%eax)
  802e79:	eb 0b                	jmp    802e86 <alloc_block_NF+0x331>
  802e7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7e:	8b 40 04             	mov    0x4(%eax),%eax
  802e81:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e89:	8b 40 04             	mov    0x4(%eax),%eax
  802e8c:	85 c0                	test   %eax,%eax
  802e8e:	74 0f                	je     802e9f <alloc_block_NF+0x34a>
  802e90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e99:	8b 12                	mov    (%edx),%edx
  802e9b:	89 10                	mov    %edx,(%eax)
  802e9d:	eb 0a                	jmp    802ea9 <alloc_block_NF+0x354>
  802e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebc:	a1 54 51 80 00       	mov    0x805154,%eax
  802ec1:	48                   	dec    %eax
  802ec2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eca:	8b 40 08             	mov    0x8(%eax),%eax
  802ecd:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 50 08             	mov    0x8(%eax),%edx
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	01 c2                	add    %eax,%edx
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee9:	2b 45 08             	sub    0x8(%ebp),%eax
  802eec:	89 c2                	mov    %eax,%edx
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ef4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef7:	e9 24 02 00 00       	jmp    803120 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802efc:	a1 40 51 80 00       	mov    0x805140,%eax
  802f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f08:	74 07                	je     802f11 <alloc_block_NF+0x3bc>
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	eb 05                	jmp    802f16 <alloc_block_NF+0x3c1>
  802f11:	b8 00 00 00 00       	mov    $0x0,%eax
  802f16:	a3 40 51 80 00       	mov    %eax,0x805140
  802f1b:	a1 40 51 80 00       	mov    0x805140,%eax
  802f20:	85 c0                	test   %eax,%eax
  802f22:	0f 85 2b fe ff ff    	jne    802d53 <alloc_block_NF+0x1fe>
  802f28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2c:	0f 85 21 fe ff ff    	jne    802d53 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f32:	a1 38 51 80 00       	mov    0x805138,%eax
  802f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f3a:	e9 ae 01 00 00       	jmp    8030ed <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	8b 50 08             	mov    0x8(%eax),%edx
  802f45:	a1 28 50 80 00       	mov    0x805028,%eax
  802f4a:	39 c2                	cmp    %eax,%edx
  802f4c:	0f 83 93 01 00 00    	jae    8030e5 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	8b 40 0c             	mov    0xc(%eax),%eax
  802f58:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f5b:	0f 82 84 01 00 00    	jb     8030e5 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f64:	8b 40 0c             	mov    0xc(%eax),%eax
  802f67:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f6a:	0f 85 95 00 00 00    	jne    803005 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f74:	75 17                	jne    802f8d <alloc_block_NF+0x438>
  802f76:	83 ec 04             	sub    $0x4,%esp
  802f79:	68 08 45 80 00       	push   $0x804508
  802f7e:	68 14 01 00 00       	push   $0x114
  802f83:	68 5f 44 80 00       	push   $0x80445f
  802f88:	e8 0e d8 ff ff       	call   80079b <_panic>
  802f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	85 c0                	test   %eax,%eax
  802f94:	74 10                	je     802fa6 <alloc_block_NF+0x451>
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	8b 00                	mov    (%eax),%eax
  802f9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9e:	8b 52 04             	mov    0x4(%edx),%edx
  802fa1:	89 50 04             	mov    %edx,0x4(%eax)
  802fa4:	eb 0b                	jmp    802fb1 <alloc_block_NF+0x45c>
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	8b 40 04             	mov    0x4(%eax),%eax
  802fac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb4:	8b 40 04             	mov    0x4(%eax),%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	74 0f                	je     802fca <alloc_block_NF+0x475>
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	8b 40 04             	mov    0x4(%eax),%eax
  802fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc4:	8b 12                	mov    (%edx),%edx
  802fc6:	89 10                	mov    %edx,(%eax)
  802fc8:	eb 0a                	jmp    802fd4 <alloc_block_NF+0x47f>
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	8b 00                	mov    (%eax),%eax
  802fcf:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe7:	a1 44 51 80 00       	mov    0x805144,%eax
  802fec:	48                   	dec    %eax
  802fed:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	8b 40 08             	mov    0x8(%eax),%eax
  802ff8:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803000:	e9 1b 01 00 00       	jmp    803120 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 40 0c             	mov    0xc(%eax),%eax
  80300b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300e:	0f 86 d1 00 00 00    	jbe    8030e5 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803014:	a1 48 51 80 00       	mov    0x805148,%eax
  803019:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	8b 50 08             	mov    0x8(%eax),%edx
  803022:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803025:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803028:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302b:	8b 55 08             	mov    0x8(%ebp),%edx
  80302e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803031:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803035:	75 17                	jne    80304e <alloc_block_NF+0x4f9>
  803037:	83 ec 04             	sub    $0x4,%esp
  80303a:	68 08 45 80 00       	push   $0x804508
  80303f:	68 1c 01 00 00       	push   $0x11c
  803044:	68 5f 44 80 00       	push   $0x80445f
  803049:	e8 4d d7 ff ff       	call   80079b <_panic>
  80304e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	85 c0                	test   %eax,%eax
  803055:	74 10                	je     803067 <alloc_block_NF+0x512>
  803057:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305a:	8b 00                	mov    (%eax),%eax
  80305c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80305f:	8b 52 04             	mov    0x4(%edx),%edx
  803062:	89 50 04             	mov    %edx,0x4(%eax)
  803065:	eb 0b                	jmp    803072 <alloc_block_NF+0x51d>
  803067:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306a:	8b 40 04             	mov    0x4(%eax),%eax
  80306d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803072:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803075:	8b 40 04             	mov    0x4(%eax),%eax
  803078:	85 c0                	test   %eax,%eax
  80307a:	74 0f                	je     80308b <alloc_block_NF+0x536>
  80307c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307f:	8b 40 04             	mov    0x4(%eax),%eax
  803082:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803085:	8b 12                	mov    (%edx),%edx
  803087:	89 10                	mov    %edx,(%eax)
  803089:	eb 0a                	jmp    803095 <alloc_block_NF+0x540>
  80308b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	a3 48 51 80 00       	mov    %eax,0x805148
  803095:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803098:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a8:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ad:	48                   	dec    %eax
  8030ae:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b6:	8b 40 08             	mov    0x8(%eax),%eax
  8030b9:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 50 08             	mov    0x8(%eax),%edx
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	01 c2                	add    %eax,%edx
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d5:	2b 45 08             	sub    0x8(%ebp),%eax
  8030d8:	89 c2                	mov    %eax,%edx
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8030e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e3:	eb 3b                	jmp    803120 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8030ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f1:	74 07                	je     8030fa <alloc_block_NF+0x5a5>
  8030f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f6:	8b 00                	mov    (%eax),%eax
  8030f8:	eb 05                	jmp    8030ff <alloc_block_NF+0x5aa>
  8030fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ff:	a3 40 51 80 00       	mov    %eax,0x805140
  803104:	a1 40 51 80 00       	mov    0x805140,%eax
  803109:	85 c0                	test   %eax,%eax
  80310b:	0f 85 2e fe ff ff    	jne    802f3f <alloc_block_NF+0x3ea>
  803111:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803115:	0f 85 24 fe ff ff    	jne    802f3f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80311b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803120:	c9                   	leave  
  803121:	c3                   	ret    

00803122 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803122:	55                   	push   %ebp
  803123:	89 e5                	mov    %esp,%ebp
  803125:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803128:	a1 38 51 80 00       	mov    0x805138,%eax
  80312d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803130:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803135:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803138:	a1 38 51 80 00       	mov    0x805138,%eax
  80313d:	85 c0                	test   %eax,%eax
  80313f:	74 14                	je     803155 <insert_sorted_with_merge_freeList+0x33>
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	8b 50 08             	mov    0x8(%eax),%edx
  803147:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314a:	8b 40 08             	mov    0x8(%eax),%eax
  80314d:	39 c2                	cmp    %eax,%edx
  80314f:	0f 87 9b 01 00 00    	ja     8032f0 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803159:	75 17                	jne    803172 <insert_sorted_with_merge_freeList+0x50>
  80315b:	83 ec 04             	sub    $0x4,%esp
  80315e:	68 3c 44 80 00       	push   $0x80443c
  803163:	68 38 01 00 00       	push   $0x138
  803168:	68 5f 44 80 00       	push   $0x80445f
  80316d:	e8 29 d6 ff ff       	call   80079b <_panic>
  803172:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803178:	8b 45 08             	mov    0x8(%ebp),%eax
  80317b:	89 10                	mov    %edx,(%eax)
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	8b 00                	mov    (%eax),%eax
  803182:	85 c0                	test   %eax,%eax
  803184:	74 0d                	je     803193 <insert_sorted_with_merge_freeList+0x71>
  803186:	a1 38 51 80 00       	mov    0x805138,%eax
  80318b:	8b 55 08             	mov    0x8(%ebp),%edx
  80318e:	89 50 04             	mov    %edx,0x4(%eax)
  803191:	eb 08                	jmp    80319b <insert_sorted_with_merge_freeList+0x79>
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b2:	40                   	inc    %eax
  8031b3:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031bc:	0f 84 a8 06 00 00    	je     80386a <insert_sorted_with_merge_freeList+0x748>
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	8b 50 08             	mov    0x8(%eax),%edx
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ce:	01 c2                	add    %eax,%edx
  8031d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d3:	8b 40 08             	mov    0x8(%eax),%eax
  8031d6:	39 c2                	cmp    %eax,%edx
  8031d8:	0f 85 8c 06 00 00    	jne    80386a <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ea:	01 c2                	add    %eax,%edx
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ef:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8031f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031f6:	75 17                	jne    80320f <insert_sorted_with_merge_freeList+0xed>
  8031f8:	83 ec 04             	sub    $0x4,%esp
  8031fb:	68 08 45 80 00       	push   $0x804508
  803200:	68 3c 01 00 00       	push   $0x13c
  803205:	68 5f 44 80 00       	push   $0x80445f
  80320a:	e8 8c d5 ff ff       	call   80079b <_panic>
  80320f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803212:	8b 00                	mov    (%eax),%eax
  803214:	85 c0                	test   %eax,%eax
  803216:	74 10                	je     803228 <insert_sorted_with_merge_freeList+0x106>
  803218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321b:	8b 00                	mov    (%eax),%eax
  80321d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803220:	8b 52 04             	mov    0x4(%edx),%edx
  803223:	89 50 04             	mov    %edx,0x4(%eax)
  803226:	eb 0b                	jmp    803233 <insert_sorted_with_merge_freeList+0x111>
  803228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322b:	8b 40 04             	mov    0x4(%eax),%eax
  80322e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803236:	8b 40 04             	mov    0x4(%eax),%eax
  803239:	85 c0                	test   %eax,%eax
  80323b:	74 0f                	je     80324c <insert_sorted_with_merge_freeList+0x12a>
  80323d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803240:	8b 40 04             	mov    0x4(%eax),%eax
  803243:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803246:	8b 12                	mov    (%edx),%edx
  803248:	89 10                	mov    %edx,(%eax)
  80324a:	eb 0a                	jmp    803256 <insert_sorted_with_merge_freeList+0x134>
  80324c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324f:	8b 00                	mov    (%eax),%eax
  803251:	a3 38 51 80 00       	mov    %eax,0x805138
  803256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80325f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803262:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803269:	a1 44 51 80 00       	mov    0x805144,%eax
  80326e:	48                   	dec    %eax
  80326f:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803277:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80327e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803281:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80328c:	75 17                	jne    8032a5 <insert_sorted_with_merge_freeList+0x183>
  80328e:	83 ec 04             	sub    $0x4,%esp
  803291:	68 3c 44 80 00       	push   $0x80443c
  803296:	68 3f 01 00 00       	push   $0x13f
  80329b:	68 5f 44 80 00       	push   $0x80445f
  8032a0:	e8 f6 d4 ff ff       	call   80079b <_panic>
  8032a5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ae:	89 10                	mov    %edx,(%eax)
  8032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	74 0d                	je     8032c6 <insert_sorted_with_merge_freeList+0x1a4>
  8032b9:	a1 48 51 80 00       	mov    0x805148,%eax
  8032be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c1:	89 50 04             	mov    %edx,0x4(%eax)
  8032c4:	eb 08                	jmp    8032ce <insert_sorted_with_merge_freeList+0x1ac>
  8032c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d1:	a3 48 51 80 00       	mov    %eax,0x805148
  8032d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e0:	a1 54 51 80 00       	mov    0x805154,%eax
  8032e5:	40                   	inc    %eax
  8032e6:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032eb:	e9 7a 05 00 00       	jmp    80386a <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	8b 50 08             	mov    0x8(%eax),%edx
  8032f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f9:	8b 40 08             	mov    0x8(%eax),%eax
  8032fc:	39 c2                	cmp    %eax,%edx
  8032fe:	0f 82 14 01 00 00    	jb     803418 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803304:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803307:	8b 50 08             	mov    0x8(%eax),%edx
  80330a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330d:	8b 40 0c             	mov    0xc(%eax),%eax
  803310:	01 c2                	add    %eax,%edx
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	8b 40 08             	mov    0x8(%eax),%eax
  803318:	39 c2                	cmp    %eax,%edx
  80331a:	0f 85 90 00 00 00    	jne    8033b0 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803320:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803323:	8b 50 0c             	mov    0xc(%eax),%edx
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	8b 40 0c             	mov    0xc(%eax),%eax
  80332c:	01 c2                	add    %eax,%edx
  80332e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803331:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80333e:	8b 45 08             	mov    0x8(%ebp),%eax
  803341:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803348:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334c:	75 17                	jne    803365 <insert_sorted_with_merge_freeList+0x243>
  80334e:	83 ec 04             	sub    $0x4,%esp
  803351:	68 3c 44 80 00       	push   $0x80443c
  803356:	68 49 01 00 00       	push   $0x149
  80335b:	68 5f 44 80 00       	push   $0x80445f
  803360:	e8 36 d4 ff ff       	call   80079b <_panic>
  803365:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	89 10                	mov    %edx,(%eax)
  803370:	8b 45 08             	mov    0x8(%ebp),%eax
  803373:	8b 00                	mov    (%eax),%eax
  803375:	85 c0                	test   %eax,%eax
  803377:	74 0d                	je     803386 <insert_sorted_with_merge_freeList+0x264>
  803379:	a1 48 51 80 00       	mov    0x805148,%eax
  80337e:	8b 55 08             	mov    0x8(%ebp),%edx
  803381:	89 50 04             	mov    %edx,0x4(%eax)
  803384:	eb 08                	jmp    80338e <insert_sorted_with_merge_freeList+0x26c>
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	a3 48 51 80 00       	mov    %eax,0x805148
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a0:	a1 54 51 80 00       	mov    0x805154,%eax
  8033a5:	40                   	inc    %eax
  8033a6:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033ab:	e9 bb 04 00 00       	jmp    80386b <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8033b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b4:	75 17                	jne    8033cd <insert_sorted_with_merge_freeList+0x2ab>
  8033b6:	83 ec 04             	sub    $0x4,%esp
  8033b9:	68 b0 44 80 00       	push   $0x8044b0
  8033be:	68 4c 01 00 00       	push   $0x14c
  8033c3:	68 5f 44 80 00       	push   $0x80445f
  8033c8:	e8 ce d3 ff ff       	call   80079b <_panic>
  8033cd:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d6:	89 50 04             	mov    %edx,0x4(%eax)
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	8b 40 04             	mov    0x4(%eax),%eax
  8033df:	85 c0                	test   %eax,%eax
  8033e1:	74 0c                	je     8033ef <insert_sorted_with_merge_freeList+0x2cd>
  8033e3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8033eb:	89 10                	mov    %edx,(%eax)
  8033ed:	eb 08                	jmp    8033f7 <insert_sorted_with_merge_freeList+0x2d5>
  8033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803408:	a1 44 51 80 00       	mov    0x805144,%eax
  80340d:	40                   	inc    %eax
  80340e:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803413:	e9 53 04 00 00       	jmp    80386b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803418:	a1 38 51 80 00       	mov    0x805138,%eax
  80341d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803420:	e9 15 04 00 00       	jmp    80383a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	8b 50 08             	mov    0x8(%eax),%edx
  803433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803436:	8b 40 08             	mov    0x8(%eax),%eax
  803439:	39 c2                	cmp    %eax,%edx
  80343b:	0f 86 f1 03 00 00    	jbe    803832 <insert_sorted_with_merge_freeList+0x710>
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	8b 50 08             	mov    0x8(%eax),%edx
  803447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344a:	8b 40 08             	mov    0x8(%eax),%eax
  80344d:	39 c2                	cmp    %eax,%edx
  80344f:	0f 83 dd 03 00 00    	jae    803832 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803458:	8b 50 08             	mov    0x8(%eax),%edx
  80345b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345e:	8b 40 0c             	mov    0xc(%eax),%eax
  803461:	01 c2                	add    %eax,%edx
  803463:	8b 45 08             	mov    0x8(%ebp),%eax
  803466:	8b 40 08             	mov    0x8(%eax),%eax
  803469:	39 c2                	cmp    %eax,%edx
  80346b:	0f 85 b9 01 00 00    	jne    80362a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803471:	8b 45 08             	mov    0x8(%ebp),%eax
  803474:	8b 50 08             	mov    0x8(%eax),%edx
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	8b 40 0c             	mov    0xc(%eax),%eax
  80347d:	01 c2                	add    %eax,%edx
  80347f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803482:	8b 40 08             	mov    0x8(%eax),%eax
  803485:	39 c2                	cmp    %eax,%edx
  803487:	0f 85 0d 01 00 00    	jne    80359a <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 50 0c             	mov    0xc(%eax),%edx
  803493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803496:	8b 40 0c             	mov    0xc(%eax),%eax
  803499:	01 c2                	add    %eax,%edx
  80349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349e:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8034a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034a5:	75 17                	jne    8034be <insert_sorted_with_merge_freeList+0x39c>
  8034a7:	83 ec 04             	sub    $0x4,%esp
  8034aa:	68 08 45 80 00       	push   $0x804508
  8034af:	68 5c 01 00 00       	push   $0x15c
  8034b4:	68 5f 44 80 00       	push   $0x80445f
  8034b9:	e8 dd d2 ff ff       	call   80079b <_panic>
  8034be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c1:	8b 00                	mov    (%eax),%eax
  8034c3:	85 c0                	test   %eax,%eax
  8034c5:	74 10                	je     8034d7 <insert_sorted_with_merge_freeList+0x3b5>
  8034c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ca:	8b 00                	mov    (%eax),%eax
  8034cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034cf:	8b 52 04             	mov    0x4(%edx),%edx
  8034d2:	89 50 04             	mov    %edx,0x4(%eax)
  8034d5:	eb 0b                	jmp    8034e2 <insert_sorted_with_merge_freeList+0x3c0>
  8034d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034da:	8b 40 04             	mov    0x4(%eax),%eax
  8034dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e5:	8b 40 04             	mov    0x4(%eax),%eax
  8034e8:	85 c0                	test   %eax,%eax
  8034ea:	74 0f                	je     8034fb <insert_sorted_with_merge_freeList+0x3d9>
  8034ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ef:	8b 40 04             	mov    0x4(%eax),%eax
  8034f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034f5:	8b 12                	mov    (%edx),%edx
  8034f7:	89 10                	mov    %edx,(%eax)
  8034f9:	eb 0a                	jmp    803505 <insert_sorted_with_merge_freeList+0x3e3>
  8034fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fe:	8b 00                	mov    (%eax),%eax
  803500:	a3 38 51 80 00       	mov    %eax,0x805138
  803505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803508:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80350e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803511:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803518:	a1 44 51 80 00       	mov    0x805144,%eax
  80351d:	48                   	dec    %eax
  80351e:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803523:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803526:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80352d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803530:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803537:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80353b:	75 17                	jne    803554 <insert_sorted_with_merge_freeList+0x432>
  80353d:	83 ec 04             	sub    $0x4,%esp
  803540:	68 3c 44 80 00       	push   $0x80443c
  803545:	68 5f 01 00 00       	push   $0x15f
  80354a:	68 5f 44 80 00       	push   $0x80445f
  80354f:	e8 47 d2 ff ff       	call   80079b <_panic>
  803554:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80355a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355d:	89 10                	mov    %edx,(%eax)
  80355f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803562:	8b 00                	mov    (%eax),%eax
  803564:	85 c0                	test   %eax,%eax
  803566:	74 0d                	je     803575 <insert_sorted_with_merge_freeList+0x453>
  803568:	a1 48 51 80 00       	mov    0x805148,%eax
  80356d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803570:	89 50 04             	mov    %edx,0x4(%eax)
  803573:	eb 08                	jmp    80357d <insert_sorted_with_merge_freeList+0x45b>
  803575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803578:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80357d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803580:	a3 48 51 80 00       	mov    %eax,0x805148
  803585:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803588:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358f:	a1 54 51 80 00       	mov    0x805154,%eax
  803594:	40                   	inc    %eax
  803595:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80359a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359d:	8b 50 0c             	mov    0xc(%eax),%edx
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a6:	01 c2                	add    %eax,%edx
  8035a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ab:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8035ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8035b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035c6:	75 17                	jne    8035df <insert_sorted_with_merge_freeList+0x4bd>
  8035c8:	83 ec 04             	sub    $0x4,%esp
  8035cb:	68 3c 44 80 00       	push   $0x80443c
  8035d0:	68 64 01 00 00       	push   $0x164
  8035d5:	68 5f 44 80 00       	push   $0x80445f
  8035da:	e8 bc d1 ff ff       	call   80079b <_panic>
  8035df:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e8:	89 10                	mov    %edx,(%eax)
  8035ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ed:	8b 00                	mov    (%eax),%eax
  8035ef:	85 c0                	test   %eax,%eax
  8035f1:	74 0d                	je     803600 <insert_sorted_with_merge_freeList+0x4de>
  8035f3:	a1 48 51 80 00       	mov    0x805148,%eax
  8035f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8035fb:	89 50 04             	mov    %edx,0x4(%eax)
  8035fe:	eb 08                	jmp    803608 <insert_sorted_with_merge_freeList+0x4e6>
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803608:	8b 45 08             	mov    0x8(%ebp),%eax
  80360b:	a3 48 51 80 00       	mov    %eax,0x805148
  803610:	8b 45 08             	mov    0x8(%ebp),%eax
  803613:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361a:	a1 54 51 80 00       	mov    0x805154,%eax
  80361f:	40                   	inc    %eax
  803620:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803625:	e9 41 02 00 00       	jmp    80386b <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80362a:	8b 45 08             	mov    0x8(%ebp),%eax
  80362d:	8b 50 08             	mov    0x8(%eax),%edx
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	8b 40 0c             	mov    0xc(%eax),%eax
  803636:	01 c2                	add    %eax,%edx
  803638:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363b:	8b 40 08             	mov    0x8(%eax),%eax
  80363e:	39 c2                	cmp    %eax,%edx
  803640:	0f 85 7c 01 00 00    	jne    8037c2 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803646:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80364a:	74 06                	je     803652 <insert_sorted_with_merge_freeList+0x530>
  80364c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803650:	75 17                	jne    803669 <insert_sorted_with_merge_freeList+0x547>
  803652:	83 ec 04             	sub    $0x4,%esp
  803655:	68 78 44 80 00       	push   $0x804478
  80365a:	68 69 01 00 00       	push   $0x169
  80365f:	68 5f 44 80 00       	push   $0x80445f
  803664:	e8 32 d1 ff ff       	call   80079b <_panic>
  803669:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366c:	8b 50 04             	mov    0x4(%eax),%edx
  80366f:	8b 45 08             	mov    0x8(%ebp),%eax
  803672:	89 50 04             	mov    %edx,0x4(%eax)
  803675:	8b 45 08             	mov    0x8(%ebp),%eax
  803678:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80367b:	89 10                	mov    %edx,(%eax)
  80367d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803680:	8b 40 04             	mov    0x4(%eax),%eax
  803683:	85 c0                	test   %eax,%eax
  803685:	74 0d                	je     803694 <insert_sorted_with_merge_freeList+0x572>
  803687:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368a:	8b 40 04             	mov    0x4(%eax),%eax
  80368d:	8b 55 08             	mov    0x8(%ebp),%edx
  803690:	89 10                	mov    %edx,(%eax)
  803692:	eb 08                	jmp    80369c <insert_sorted_with_merge_freeList+0x57a>
  803694:	8b 45 08             	mov    0x8(%ebp),%eax
  803697:	a3 38 51 80 00       	mov    %eax,0x805138
  80369c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369f:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a2:	89 50 04             	mov    %edx,0x4(%eax)
  8036a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8036aa:	40                   	inc    %eax
  8036ab:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	8b 50 0c             	mov    0xc(%eax),%edx
  8036b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8036bc:	01 c2                	add    %eax,%edx
  8036be:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c1:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8036c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036c8:	75 17                	jne    8036e1 <insert_sorted_with_merge_freeList+0x5bf>
  8036ca:	83 ec 04             	sub    $0x4,%esp
  8036cd:	68 08 45 80 00       	push   $0x804508
  8036d2:	68 6b 01 00 00       	push   $0x16b
  8036d7:	68 5f 44 80 00       	push   $0x80445f
  8036dc:	e8 ba d0 ff ff       	call   80079b <_panic>
  8036e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e4:	8b 00                	mov    (%eax),%eax
  8036e6:	85 c0                	test   %eax,%eax
  8036e8:	74 10                	je     8036fa <insert_sorted_with_merge_freeList+0x5d8>
  8036ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ed:	8b 00                	mov    (%eax),%eax
  8036ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f2:	8b 52 04             	mov    0x4(%edx),%edx
  8036f5:	89 50 04             	mov    %edx,0x4(%eax)
  8036f8:	eb 0b                	jmp    803705 <insert_sorted_with_merge_freeList+0x5e3>
  8036fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fd:	8b 40 04             	mov    0x4(%eax),%eax
  803700:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803705:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803708:	8b 40 04             	mov    0x4(%eax),%eax
  80370b:	85 c0                	test   %eax,%eax
  80370d:	74 0f                	je     80371e <insert_sorted_with_merge_freeList+0x5fc>
  80370f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803712:	8b 40 04             	mov    0x4(%eax),%eax
  803715:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803718:	8b 12                	mov    (%edx),%edx
  80371a:	89 10                	mov    %edx,(%eax)
  80371c:	eb 0a                	jmp    803728 <insert_sorted_with_merge_freeList+0x606>
  80371e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803721:	8b 00                	mov    (%eax),%eax
  803723:	a3 38 51 80 00       	mov    %eax,0x805138
  803728:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803731:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803734:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373b:	a1 44 51 80 00       	mov    0x805144,%eax
  803740:	48                   	dec    %eax
  803741:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803746:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803749:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803750:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803753:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80375a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80375e:	75 17                	jne    803777 <insert_sorted_with_merge_freeList+0x655>
  803760:	83 ec 04             	sub    $0x4,%esp
  803763:	68 3c 44 80 00       	push   $0x80443c
  803768:	68 6e 01 00 00       	push   $0x16e
  80376d:	68 5f 44 80 00       	push   $0x80445f
  803772:	e8 24 d0 ff ff       	call   80079b <_panic>
  803777:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80377d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803780:	89 10                	mov    %edx,(%eax)
  803782:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803785:	8b 00                	mov    (%eax),%eax
  803787:	85 c0                	test   %eax,%eax
  803789:	74 0d                	je     803798 <insert_sorted_with_merge_freeList+0x676>
  80378b:	a1 48 51 80 00       	mov    0x805148,%eax
  803790:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803793:	89 50 04             	mov    %edx,0x4(%eax)
  803796:	eb 08                	jmp    8037a0 <insert_sorted_with_merge_freeList+0x67e>
  803798:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a3:	a3 48 51 80 00       	mov    %eax,0x805148
  8037a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b2:	a1 54 51 80 00       	mov    0x805154,%eax
  8037b7:	40                   	inc    %eax
  8037b8:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8037bd:	e9 a9 00 00 00       	jmp    80386b <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8037c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037c6:	74 06                	je     8037ce <insert_sorted_with_merge_freeList+0x6ac>
  8037c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037cc:	75 17                	jne    8037e5 <insert_sorted_with_merge_freeList+0x6c3>
  8037ce:	83 ec 04             	sub    $0x4,%esp
  8037d1:	68 d4 44 80 00       	push   $0x8044d4
  8037d6:	68 73 01 00 00       	push   $0x173
  8037db:	68 5f 44 80 00       	push   $0x80445f
  8037e0:	e8 b6 cf ff ff       	call   80079b <_panic>
  8037e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e8:	8b 10                	mov    (%eax),%edx
  8037ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ed:	89 10                	mov    %edx,(%eax)
  8037ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f2:	8b 00                	mov    (%eax),%eax
  8037f4:	85 c0                	test   %eax,%eax
  8037f6:	74 0b                	je     803803 <insert_sorted_with_merge_freeList+0x6e1>
  8037f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fb:	8b 00                	mov    (%eax),%eax
  8037fd:	8b 55 08             	mov    0x8(%ebp),%edx
  803800:	89 50 04             	mov    %edx,0x4(%eax)
  803803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803806:	8b 55 08             	mov    0x8(%ebp),%edx
  803809:	89 10                	mov    %edx,(%eax)
  80380b:	8b 45 08             	mov    0x8(%ebp),%eax
  80380e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803811:	89 50 04             	mov    %edx,0x4(%eax)
  803814:	8b 45 08             	mov    0x8(%ebp),%eax
  803817:	8b 00                	mov    (%eax),%eax
  803819:	85 c0                	test   %eax,%eax
  80381b:	75 08                	jne    803825 <insert_sorted_with_merge_freeList+0x703>
  80381d:	8b 45 08             	mov    0x8(%ebp),%eax
  803820:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803825:	a1 44 51 80 00       	mov    0x805144,%eax
  80382a:	40                   	inc    %eax
  80382b:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803830:	eb 39                	jmp    80386b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803832:	a1 40 51 80 00       	mov    0x805140,%eax
  803837:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80383a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80383e:	74 07                	je     803847 <insert_sorted_with_merge_freeList+0x725>
  803840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803843:	8b 00                	mov    (%eax),%eax
  803845:	eb 05                	jmp    80384c <insert_sorted_with_merge_freeList+0x72a>
  803847:	b8 00 00 00 00       	mov    $0x0,%eax
  80384c:	a3 40 51 80 00       	mov    %eax,0x805140
  803851:	a1 40 51 80 00       	mov    0x805140,%eax
  803856:	85 c0                	test   %eax,%eax
  803858:	0f 85 c7 fb ff ff    	jne    803425 <insert_sorted_with_merge_freeList+0x303>
  80385e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803862:	0f 85 bd fb ff ff    	jne    803425 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803868:	eb 01                	jmp    80386b <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80386a:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80386b:	90                   	nop
  80386c:	c9                   	leave  
  80386d:	c3                   	ret    
  80386e:	66 90                	xchg   %ax,%ax

00803870 <__udivdi3>:
  803870:	55                   	push   %ebp
  803871:	57                   	push   %edi
  803872:	56                   	push   %esi
  803873:	53                   	push   %ebx
  803874:	83 ec 1c             	sub    $0x1c,%esp
  803877:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80387b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80387f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803883:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803887:	89 ca                	mov    %ecx,%edx
  803889:	89 f8                	mov    %edi,%eax
  80388b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80388f:	85 f6                	test   %esi,%esi
  803891:	75 2d                	jne    8038c0 <__udivdi3+0x50>
  803893:	39 cf                	cmp    %ecx,%edi
  803895:	77 65                	ja     8038fc <__udivdi3+0x8c>
  803897:	89 fd                	mov    %edi,%ebp
  803899:	85 ff                	test   %edi,%edi
  80389b:	75 0b                	jne    8038a8 <__udivdi3+0x38>
  80389d:	b8 01 00 00 00       	mov    $0x1,%eax
  8038a2:	31 d2                	xor    %edx,%edx
  8038a4:	f7 f7                	div    %edi
  8038a6:	89 c5                	mov    %eax,%ebp
  8038a8:	31 d2                	xor    %edx,%edx
  8038aa:	89 c8                	mov    %ecx,%eax
  8038ac:	f7 f5                	div    %ebp
  8038ae:	89 c1                	mov    %eax,%ecx
  8038b0:	89 d8                	mov    %ebx,%eax
  8038b2:	f7 f5                	div    %ebp
  8038b4:	89 cf                	mov    %ecx,%edi
  8038b6:	89 fa                	mov    %edi,%edx
  8038b8:	83 c4 1c             	add    $0x1c,%esp
  8038bb:	5b                   	pop    %ebx
  8038bc:	5e                   	pop    %esi
  8038bd:	5f                   	pop    %edi
  8038be:	5d                   	pop    %ebp
  8038bf:	c3                   	ret    
  8038c0:	39 ce                	cmp    %ecx,%esi
  8038c2:	77 28                	ja     8038ec <__udivdi3+0x7c>
  8038c4:	0f bd fe             	bsr    %esi,%edi
  8038c7:	83 f7 1f             	xor    $0x1f,%edi
  8038ca:	75 40                	jne    80390c <__udivdi3+0x9c>
  8038cc:	39 ce                	cmp    %ecx,%esi
  8038ce:	72 0a                	jb     8038da <__udivdi3+0x6a>
  8038d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038d4:	0f 87 9e 00 00 00    	ja     803978 <__udivdi3+0x108>
  8038da:	b8 01 00 00 00       	mov    $0x1,%eax
  8038df:	89 fa                	mov    %edi,%edx
  8038e1:	83 c4 1c             	add    $0x1c,%esp
  8038e4:	5b                   	pop    %ebx
  8038e5:	5e                   	pop    %esi
  8038e6:	5f                   	pop    %edi
  8038e7:	5d                   	pop    %ebp
  8038e8:	c3                   	ret    
  8038e9:	8d 76 00             	lea    0x0(%esi),%esi
  8038ec:	31 ff                	xor    %edi,%edi
  8038ee:	31 c0                	xor    %eax,%eax
  8038f0:	89 fa                	mov    %edi,%edx
  8038f2:	83 c4 1c             	add    $0x1c,%esp
  8038f5:	5b                   	pop    %ebx
  8038f6:	5e                   	pop    %esi
  8038f7:	5f                   	pop    %edi
  8038f8:	5d                   	pop    %ebp
  8038f9:	c3                   	ret    
  8038fa:	66 90                	xchg   %ax,%ax
  8038fc:	89 d8                	mov    %ebx,%eax
  8038fe:	f7 f7                	div    %edi
  803900:	31 ff                	xor    %edi,%edi
  803902:	89 fa                	mov    %edi,%edx
  803904:	83 c4 1c             	add    $0x1c,%esp
  803907:	5b                   	pop    %ebx
  803908:	5e                   	pop    %esi
  803909:	5f                   	pop    %edi
  80390a:	5d                   	pop    %ebp
  80390b:	c3                   	ret    
  80390c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803911:	89 eb                	mov    %ebp,%ebx
  803913:	29 fb                	sub    %edi,%ebx
  803915:	89 f9                	mov    %edi,%ecx
  803917:	d3 e6                	shl    %cl,%esi
  803919:	89 c5                	mov    %eax,%ebp
  80391b:	88 d9                	mov    %bl,%cl
  80391d:	d3 ed                	shr    %cl,%ebp
  80391f:	89 e9                	mov    %ebp,%ecx
  803921:	09 f1                	or     %esi,%ecx
  803923:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803927:	89 f9                	mov    %edi,%ecx
  803929:	d3 e0                	shl    %cl,%eax
  80392b:	89 c5                	mov    %eax,%ebp
  80392d:	89 d6                	mov    %edx,%esi
  80392f:	88 d9                	mov    %bl,%cl
  803931:	d3 ee                	shr    %cl,%esi
  803933:	89 f9                	mov    %edi,%ecx
  803935:	d3 e2                	shl    %cl,%edx
  803937:	8b 44 24 08          	mov    0x8(%esp),%eax
  80393b:	88 d9                	mov    %bl,%cl
  80393d:	d3 e8                	shr    %cl,%eax
  80393f:	09 c2                	or     %eax,%edx
  803941:	89 d0                	mov    %edx,%eax
  803943:	89 f2                	mov    %esi,%edx
  803945:	f7 74 24 0c          	divl   0xc(%esp)
  803949:	89 d6                	mov    %edx,%esi
  80394b:	89 c3                	mov    %eax,%ebx
  80394d:	f7 e5                	mul    %ebp
  80394f:	39 d6                	cmp    %edx,%esi
  803951:	72 19                	jb     80396c <__udivdi3+0xfc>
  803953:	74 0b                	je     803960 <__udivdi3+0xf0>
  803955:	89 d8                	mov    %ebx,%eax
  803957:	31 ff                	xor    %edi,%edi
  803959:	e9 58 ff ff ff       	jmp    8038b6 <__udivdi3+0x46>
  80395e:	66 90                	xchg   %ax,%ax
  803960:	8b 54 24 08          	mov    0x8(%esp),%edx
  803964:	89 f9                	mov    %edi,%ecx
  803966:	d3 e2                	shl    %cl,%edx
  803968:	39 c2                	cmp    %eax,%edx
  80396a:	73 e9                	jae    803955 <__udivdi3+0xe5>
  80396c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80396f:	31 ff                	xor    %edi,%edi
  803971:	e9 40 ff ff ff       	jmp    8038b6 <__udivdi3+0x46>
  803976:	66 90                	xchg   %ax,%ax
  803978:	31 c0                	xor    %eax,%eax
  80397a:	e9 37 ff ff ff       	jmp    8038b6 <__udivdi3+0x46>
  80397f:	90                   	nop

00803980 <__umoddi3>:
  803980:	55                   	push   %ebp
  803981:	57                   	push   %edi
  803982:	56                   	push   %esi
  803983:	53                   	push   %ebx
  803984:	83 ec 1c             	sub    $0x1c,%esp
  803987:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80398b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80398f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803993:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803997:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80399b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80399f:	89 f3                	mov    %esi,%ebx
  8039a1:	89 fa                	mov    %edi,%edx
  8039a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039a7:	89 34 24             	mov    %esi,(%esp)
  8039aa:	85 c0                	test   %eax,%eax
  8039ac:	75 1a                	jne    8039c8 <__umoddi3+0x48>
  8039ae:	39 f7                	cmp    %esi,%edi
  8039b0:	0f 86 a2 00 00 00    	jbe    803a58 <__umoddi3+0xd8>
  8039b6:	89 c8                	mov    %ecx,%eax
  8039b8:	89 f2                	mov    %esi,%edx
  8039ba:	f7 f7                	div    %edi
  8039bc:	89 d0                	mov    %edx,%eax
  8039be:	31 d2                	xor    %edx,%edx
  8039c0:	83 c4 1c             	add    $0x1c,%esp
  8039c3:	5b                   	pop    %ebx
  8039c4:	5e                   	pop    %esi
  8039c5:	5f                   	pop    %edi
  8039c6:	5d                   	pop    %ebp
  8039c7:	c3                   	ret    
  8039c8:	39 f0                	cmp    %esi,%eax
  8039ca:	0f 87 ac 00 00 00    	ja     803a7c <__umoddi3+0xfc>
  8039d0:	0f bd e8             	bsr    %eax,%ebp
  8039d3:	83 f5 1f             	xor    $0x1f,%ebp
  8039d6:	0f 84 ac 00 00 00    	je     803a88 <__umoddi3+0x108>
  8039dc:	bf 20 00 00 00       	mov    $0x20,%edi
  8039e1:	29 ef                	sub    %ebp,%edi
  8039e3:	89 fe                	mov    %edi,%esi
  8039e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039e9:	89 e9                	mov    %ebp,%ecx
  8039eb:	d3 e0                	shl    %cl,%eax
  8039ed:	89 d7                	mov    %edx,%edi
  8039ef:	89 f1                	mov    %esi,%ecx
  8039f1:	d3 ef                	shr    %cl,%edi
  8039f3:	09 c7                	or     %eax,%edi
  8039f5:	89 e9                	mov    %ebp,%ecx
  8039f7:	d3 e2                	shl    %cl,%edx
  8039f9:	89 14 24             	mov    %edx,(%esp)
  8039fc:	89 d8                	mov    %ebx,%eax
  8039fe:	d3 e0                	shl    %cl,%eax
  803a00:	89 c2                	mov    %eax,%edx
  803a02:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a06:	d3 e0                	shl    %cl,%eax
  803a08:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a10:	89 f1                	mov    %esi,%ecx
  803a12:	d3 e8                	shr    %cl,%eax
  803a14:	09 d0                	or     %edx,%eax
  803a16:	d3 eb                	shr    %cl,%ebx
  803a18:	89 da                	mov    %ebx,%edx
  803a1a:	f7 f7                	div    %edi
  803a1c:	89 d3                	mov    %edx,%ebx
  803a1e:	f7 24 24             	mull   (%esp)
  803a21:	89 c6                	mov    %eax,%esi
  803a23:	89 d1                	mov    %edx,%ecx
  803a25:	39 d3                	cmp    %edx,%ebx
  803a27:	0f 82 87 00 00 00    	jb     803ab4 <__umoddi3+0x134>
  803a2d:	0f 84 91 00 00 00    	je     803ac4 <__umoddi3+0x144>
  803a33:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a37:	29 f2                	sub    %esi,%edx
  803a39:	19 cb                	sbb    %ecx,%ebx
  803a3b:	89 d8                	mov    %ebx,%eax
  803a3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a41:	d3 e0                	shl    %cl,%eax
  803a43:	89 e9                	mov    %ebp,%ecx
  803a45:	d3 ea                	shr    %cl,%edx
  803a47:	09 d0                	or     %edx,%eax
  803a49:	89 e9                	mov    %ebp,%ecx
  803a4b:	d3 eb                	shr    %cl,%ebx
  803a4d:	89 da                	mov    %ebx,%edx
  803a4f:	83 c4 1c             	add    $0x1c,%esp
  803a52:	5b                   	pop    %ebx
  803a53:	5e                   	pop    %esi
  803a54:	5f                   	pop    %edi
  803a55:	5d                   	pop    %ebp
  803a56:	c3                   	ret    
  803a57:	90                   	nop
  803a58:	89 fd                	mov    %edi,%ebp
  803a5a:	85 ff                	test   %edi,%edi
  803a5c:	75 0b                	jne    803a69 <__umoddi3+0xe9>
  803a5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a63:	31 d2                	xor    %edx,%edx
  803a65:	f7 f7                	div    %edi
  803a67:	89 c5                	mov    %eax,%ebp
  803a69:	89 f0                	mov    %esi,%eax
  803a6b:	31 d2                	xor    %edx,%edx
  803a6d:	f7 f5                	div    %ebp
  803a6f:	89 c8                	mov    %ecx,%eax
  803a71:	f7 f5                	div    %ebp
  803a73:	89 d0                	mov    %edx,%eax
  803a75:	e9 44 ff ff ff       	jmp    8039be <__umoddi3+0x3e>
  803a7a:	66 90                	xchg   %ax,%ax
  803a7c:	89 c8                	mov    %ecx,%eax
  803a7e:	89 f2                	mov    %esi,%edx
  803a80:	83 c4 1c             	add    $0x1c,%esp
  803a83:	5b                   	pop    %ebx
  803a84:	5e                   	pop    %esi
  803a85:	5f                   	pop    %edi
  803a86:	5d                   	pop    %ebp
  803a87:	c3                   	ret    
  803a88:	3b 04 24             	cmp    (%esp),%eax
  803a8b:	72 06                	jb     803a93 <__umoddi3+0x113>
  803a8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a91:	77 0f                	ja     803aa2 <__umoddi3+0x122>
  803a93:	89 f2                	mov    %esi,%edx
  803a95:	29 f9                	sub    %edi,%ecx
  803a97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a9b:	89 14 24             	mov    %edx,(%esp)
  803a9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aa2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803aa6:	8b 14 24             	mov    (%esp),%edx
  803aa9:	83 c4 1c             	add    $0x1c,%esp
  803aac:	5b                   	pop    %ebx
  803aad:	5e                   	pop    %esi
  803aae:	5f                   	pop    %edi
  803aaf:	5d                   	pop    %ebp
  803ab0:	c3                   	ret    
  803ab1:	8d 76 00             	lea    0x0(%esi),%esi
  803ab4:	2b 04 24             	sub    (%esp),%eax
  803ab7:	19 fa                	sbb    %edi,%edx
  803ab9:	89 d1                	mov    %edx,%ecx
  803abb:	89 c6                	mov    %eax,%esi
  803abd:	e9 71 ff ff ff       	jmp    803a33 <__umoddi3+0xb3>
  803ac2:	66 90                	xchg   %ax,%ax
  803ac4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ac8:	72 ea                	jb     803ab4 <__umoddi3+0x134>
  803aca:	89 d9                	mov    %ebx,%ecx
  803acc:	e9 62 ff ff ff       	jmp    803a33 <__umoddi3+0xb3>
