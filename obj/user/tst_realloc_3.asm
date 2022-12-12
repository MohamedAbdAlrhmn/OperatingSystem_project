
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
  800062:	68 a0 3a 80 00       	push   $0x803aa0
  800067:	e8 e3 09 00 00       	call   800a4f <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 eb 1b 00 00       	call   801c5f <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 83 1c 00 00       	call   801cff <sys_pf_calculate_allocated_pages>
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
  8000ab:	68 c4 3a 80 00       	push   $0x803ac4
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 f4 3a 80 00       	push   $0x803af4
  8000b7:	e8 df 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 9b 1b 00 00       	call   801c5f <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 0c 3b 80 00       	push   $0x803b0c
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 f4 3a 80 00       	push   $0x803af4
  8000dc:	e8 ba 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 19 1c 00 00       	call   801cff <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 78 3b 80 00       	push   $0x803b78
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 f4 3a 80 00       	push   $0x803af4
  8000fd:	e8 99 06 00 00       	call   80079b <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 58 1b 00 00       	call   801c5f <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 f0 1b 00 00       	call   801cff <sys_pf_calculate_allocated_pages>
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
  800156:	68 c4 3a 80 00       	push   $0x803ac4
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 f4 3a 80 00       	push   $0x803af4
  800162:	e8 34 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 f3 1a 00 00       	call   801c5f <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 0c 3b 80 00       	push   $0x803b0c
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 f4 3a 80 00       	push   $0x803af4
  800184:	e8 12 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 71 1b 00 00       	call   801cff <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 78 3b 80 00       	push   $0x803b78
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 f4 3a 80 00       	push   $0x803af4
  8001a5:	e8 f1 05 00 00       	call   80079b <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 b0 1a 00 00       	call   801c5f <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 48 1b 00 00       	call   801cff <sys_pf_calculate_allocated_pages>
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
  800201:	68 c4 3a 80 00       	push   $0x803ac4
  800206:	6a 23                	push   $0x23
  800208:	68 f4 3a 80 00       	push   $0x803af4
  80020d:	e8 89 05 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 48 1a 00 00       	call   801c5f <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 0c 3b 80 00       	push   $0x803b0c
  800228:	6a 25                	push   $0x25
  80022a:	68 f4 3a 80 00       	push   $0x803af4
  80022f:	e8 67 05 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 c6 1a 00 00       	call   801cff <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 78 3b 80 00       	push   $0x803b78
  800249:	6a 26                	push   $0x26
  80024b:	68 f4 3a 80 00       	push   $0x803af4
  800250:	e8 46 05 00 00       	call   80079b <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 05 1a 00 00       	call   801c5f <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 9d 1a 00 00       	call   801cff <sys_pf_calculate_allocated_pages>
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
  8002a8:	68 c4 3a 80 00       	push   $0x803ac4
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 f4 3a 80 00       	push   $0x803af4
  8002b4:	e8 e2 04 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 a1 19 00 00       	call   801c5f <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 0c 3b 80 00       	push   $0x803b0c
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 f4 3a 80 00       	push   $0x803af4
  8002d6:	e8 c0 04 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 1f 1a 00 00       	call   801cff <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 78 3b 80 00       	push   $0x803b78
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 f4 3a 80 00       	push   $0x803af4
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
  800422:	e8 38 18 00 00       	call   801c5f <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 d0 18 00 00       	call   801cff <sys_pf_calculate_allocated_pages>
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
  800450:	e8 88 16 00 00       	call   801add <realloc>
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
  800478:	68 a8 3b 80 00       	push   $0x803ba8
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 f4 3a 80 00       	push   $0x803af4
  800484:	e8 12 03 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 71 18 00 00       	call   801cff <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 dc 3b 80 00       	push   $0x803bdc
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 f4 3a 80 00       	push   $0x803af4
  8004a5:	e8 f1 02 00 00       	call   80079b <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 0d 3c 80 00       	push   $0x803c0d
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
  800501:	68 14 3c 80 00       	push   $0x803c14
  800506:	6a 7a                	push   $0x7a
  800508:	68 f4 3a 80 00       	push   $0x803af4
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
  800559:	68 14 3c 80 00       	push   $0x803c14
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 f4 3a 80 00       	push   $0x803af4
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
  8005bb:	68 14 3c 80 00       	push   $0x803c14
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 f4 3a 80 00       	push   $0x803af4
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
  800616:	68 14 3c 80 00       	push   $0x803c14
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 f4 3a 80 00       	push   $0x803af4
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
  80063a:	68 4c 3c 80 00       	push   $0x803c4c
  80063f:	e8 a0 03 00 00       	call   8009e4 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 58 3c 80 00       	push   $0x803c58
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
  800665:	e8 d5 18 00 00       	call   801f3f <sys_getenvindex>
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
  8006d0:	e8 77 16 00 00       	call   801d4c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	68 ac 3c 80 00       	push   $0x803cac
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
  800700:	68 d4 3c 80 00       	push   $0x803cd4
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
  800731:	68 fc 3c 80 00       	push   $0x803cfc
  800736:	e8 14 03 00 00       	call   800a4f <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073e:	a1 20 50 80 00       	mov    0x805020,%eax
  800743:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	50                   	push   %eax
  80074d:	68 54 3d 80 00       	push   $0x803d54
  800752:	e8 f8 02 00 00       	call   800a4f <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	68 ac 3c 80 00       	push   $0x803cac
  800762:	e8 e8 02 00 00       	call   800a4f <cprintf>
  800767:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80076a:	e8 f7 15 00 00       	call   801d66 <sys_enable_interrupt>

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
  800782:	e8 84 17 00 00       	call   801f0b <sys_destroy_env>
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
  800793:	e8 d9 17 00 00       	call   801f71 <sys_exit_env>
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
  8007bc:	68 68 3d 80 00       	push   $0x803d68
  8007c1:	e8 89 02 00 00       	call   800a4f <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c9:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	68 6d 3d 80 00       	push   $0x803d6d
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
  8007f9:	68 89 3d 80 00       	push   $0x803d89
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
  800825:	68 8c 3d 80 00       	push   $0x803d8c
  80082a:	6a 26                	push   $0x26
  80082c:	68 d8 3d 80 00       	push   $0x803dd8
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
  8008f7:	68 e4 3d 80 00       	push   $0x803de4
  8008fc:	6a 3a                	push   $0x3a
  8008fe:	68 d8 3d 80 00       	push   $0x803dd8
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
  800967:	68 38 3e 80 00       	push   $0x803e38
  80096c:	6a 44                	push   $0x44
  80096e:	68 d8 3d 80 00       	push   $0x803dd8
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
  8009c1:	e8 d8 11 00 00       	call   801b9e <sys_cputs>
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
  800a38:	e8 61 11 00 00       	call   801b9e <sys_cputs>
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
  800a82:	e8 c5 12 00 00       	call   801d4c <sys_disable_interrupt>
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
  800aa2:	e8 bf 12 00 00       	call   801d66 <sys_enable_interrupt>
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
  800aec:	e8 33 2d 00 00       	call   803824 <__udivdi3>
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
  800b3c:	e8 f3 2d 00 00       	call   803934 <__umoddi3>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	05 b4 40 80 00       	add    $0x8040b4,%eax
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
  800c97:	8b 04 85 d8 40 80 00 	mov    0x8040d8(,%eax,4),%eax
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
  800d78:	8b 34 9d 20 3f 80 00 	mov    0x803f20(,%ebx,4),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 19                	jne    800d9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d83:	53                   	push   %ebx
  800d84:	68 c5 40 80 00       	push   $0x8040c5
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
  800d9d:	68 ce 40 80 00       	push   $0x8040ce
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
  800dca:	be d1 40 80 00       	mov    $0x8040d1,%esi
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
  8017f0:	68 30 42 80 00       	push   $0x804230
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
  8018c0:	e8 1d 04 00 00       	call   801ce2 <sys_allocate_chunk>
  8018c5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018c8:	a1 20 51 80 00       	mov    0x805120,%eax
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	50                   	push   %eax
  8018d1:	e8 92 0a 00 00       	call   802368 <initialize_MemBlocksList>
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
  8018fe:	68 55 42 80 00       	push   $0x804255
  801903:	6a 33                	push   $0x33
  801905:	68 73 42 80 00       	push   $0x804273
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
  80197d:	68 80 42 80 00       	push   $0x804280
  801982:	6a 34                	push   $0x34
  801984:	68 73 42 80 00       	push   $0x804273
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
  8019f2:	68 a4 42 80 00       	push   $0x8042a4
  8019f7:	6a 46                	push   $0x46
  8019f9:	68 73 42 80 00       	push   $0x804273
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
  801a0e:	68 cc 42 80 00       	push   $0x8042cc
  801a13:	6a 61                	push   $0x61
  801a15:	68 73 42 80 00       	push   $0x804273
  801a1a:	e8 7c ed ff ff       	call   80079b <_panic>

00801a1f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 38             	sub    $0x38,%esp
  801a25:	8b 45 10             	mov    0x10(%ebp),%eax
  801a28:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a2b:	e8 a9 fd ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a34:	75 07                	jne    801a3d <smalloc+0x1e>
  801a36:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3b:	eb 7c                	jmp    801ab9 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a3d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4a:	01 d0                	add    %edx,%eax
  801a4c:	48                   	dec    %eax
  801a4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a53:	ba 00 00 00 00       	mov    $0x0,%edx
  801a58:	f7 75 f0             	divl   -0x10(%ebp)
  801a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a5e:	29 d0                	sub    %edx,%eax
  801a60:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801a63:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a6a:	e8 41 06 00 00       	call   8020b0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	74 11                	je     801a84 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801a73:	83 ec 0c             	sub    $0xc,%esp
  801a76:	ff 75 e8             	pushl  -0x18(%ebp)
  801a79:	e8 ac 0c 00 00       	call   80272a <alloc_block_FF>
  801a7e:	83 c4 10             	add    $0x10,%esp
  801a81:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801a84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a88:	74 2a                	je     801ab4 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8d:	8b 40 08             	mov    0x8(%eax),%eax
  801a90:	89 c2                	mov    %eax,%edx
  801a92:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a96:	52                   	push   %edx
  801a97:	50                   	push   %eax
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	e8 92 03 00 00       	call   801e35 <sys_createSharedObject>
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801aa9:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801aad:	74 05                	je     801ab4 <smalloc+0x95>
			return (void*)virtual_address;
  801aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ab2:	eb 05                	jmp    801ab9 <smalloc+0x9a>
	}
	return NULL;
  801ab4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ac1:	e8 13 fd ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801ac6:	83 ec 04             	sub    $0x4,%esp
  801ac9:	68 f0 42 80 00       	push   $0x8042f0
  801ace:	68 a2 00 00 00       	push   $0xa2
  801ad3:	68 73 42 80 00       	push   $0x804273
  801ad8:	e8 be ec ff ff       	call   80079b <_panic>

00801add <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ae3:	e8 f1 fc ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ae8:	83 ec 04             	sub    $0x4,%esp
  801aeb:	68 14 43 80 00       	push   $0x804314
  801af0:	68 e6 00 00 00       	push   $0xe6
  801af5:	68 73 42 80 00       	push   $0x804273
  801afa:	e8 9c ec ff ff       	call   80079b <_panic>

00801aff <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	68 3c 43 80 00       	push   $0x80433c
  801b0d:	68 fa 00 00 00       	push   $0xfa
  801b12:	68 73 42 80 00       	push   $0x804273
  801b17:	e8 7f ec ff ff       	call   80079b <_panic>

00801b1c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b22:	83 ec 04             	sub    $0x4,%esp
  801b25:	68 60 43 80 00       	push   $0x804360
  801b2a:	68 05 01 00 00       	push   $0x105
  801b2f:	68 73 42 80 00       	push   $0x804273
  801b34:	e8 62 ec ff ff       	call   80079b <_panic>

00801b39 <shrink>:

}
void shrink(uint32 newSize)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b3f:	83 ec 04             	sub    $0x4,%esp
  801b42:	68 60 43 80 00       	push   $0x804360
  801b47:	68 0a 01 00 00       	push   $0x10a
  801b4c:	68 73 42 80 00       	push   $0x804273
  801b51:	e8 45 ec ff ff       	call   80079b <_panic>

00801b56 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b5c:	83 ec 04             	sub    $0x4,%esp
  801b5f:	68 60 43 80 00       	push   $0x804360
  801b64:	68 0f 01 00 00       	push   $0x10f
  801b69:	68 73 42 80 00       	push   $0x804273
  801b6e:	e8 28 ec ff ff       	call   80079b <_panic>

00801b73 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	57                   	push   %edi
  801b77:	56                   	push   %esi
  801b78:	53                   	push   %ebx
  801b79:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b85:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b88:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b8b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b8e:	cd 30                	int    $0x30
  801b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b96:	83 c4 10             	add    $0x10,%esp
  801b99:	5b                   	pop    %ebx
  801b9a:	5e                   	pop    %esi
  801b9b:	5f                   	pop    %edi
  801b9c:	5d                   	pop    %ebp
  801b9d:	c3                   	ret    

00801b9e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801baa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	52                   	push   %edx
  801bb6:	ff 75 0c             	pushl  0xc(%ebp)
  801bb9:	50                   	push   %eax
  801bba:	6a 00                	push   $0x0
  801bbc:	e8 b2 ff ff ff       	call   801b73 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	90                   	nop
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_cgetc>:

int
sys_cgetc(void)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 01                	push   $0x1
  801bd6:	e8 98 ff ff ff       	call   801b73 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	52                   	push   %edx
  801bf0:	50                   	push   %eax
  801bf1:	6a 05                	push   $0x5
  801bf3:	e8 7b ff ff ff       	call   801b73 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	56                   	push   %esi
  801c01:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c02:	8b 75 18             	mov    0x18(%ebp),%esi
  801c05:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	56                   	push   %esi
  801c12:	53                   	push   %ebx
  801c13:	51                   	push   %ecx
  801c14:	52                   	push   %edx
  801c15:	50                   	push   %eax
  801c16:	6a 06                	push   $0x6
  801c18:	e8 56 ff ff ff       	call   801b73 <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5d                   	pop    %ebp
  801c26:	c3                   	ret    

00801c27 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	52                   	push   %edx
  801c37:	50                   	push   %eax
  801c38:	6a 07                	push   $0x7
  801c3a:	e8 34 ff ff ff       	call   801b73 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	ff 75 0c             	pushl  0xc(%ebp)
  801c50:	ff 75 08             	pushl  0x8(%ebp)
  801c53:	6a 08                	push   $0x8
  801c55:	e8 19 ff ff ff       	call   801b73 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 09                	push   $0x9
  801c6e:	e8 00 ff ff ff       	call   801b73 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 0a                	push   $0xa
  801c87:	e8 e7 fe ff ff       	call   801b73 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 0b                	push   $0xb
  801ca0:	e8 ce fe ff ff       	call   801b73 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	ff 75 0c             	pushl  0xc(%ebp)
  801cb6:	ff 75 08             	pushl  0x8(%ebp)
  801cb9:	6a 0f                	push   $0xf
  801cbb:	e8 b3 fe ff ff       	call   801b73 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
	return;
  801cc3:	90                   	nop
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	ff 75 0c             	pushl  0xc(%ebp)
  801cd2:	ff 75 08             	pushl  0x8(%ebp)
  801cd5:	6a 10                	push   $0x10
  801cd7:	e8 97 fe ff ff       	call   801b73 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdf:	90                   	nop
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	ff 75 10             	pushl  0x10(%ebp)
  801cec:	ff 75 0c             	pushl  0xc(%ebp)
  801cef:	ff 75 08             	pushl  0x8(%ebp)
  801cf2:	6a 11                	push   $0x11
  801cf4:	e8 7a fe ff ff       	call   801b73 <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfc:	90                   	nop
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 0c                	push   $0xc
  801d0e:	e8 60 fe ff ff       	call   801b73 <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	ff 75 08             	pushl  0x8(%ebp)
  801d26:	6a 0d                	push   $0xd
  801d28:	e8 46 fe ff ff       	call   801b73 <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 0e                	push   $0xe
  801d41:	e8 2d fe ff ff       	call   801b73 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
}
  801d49:	90                   	nop
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 13                	push   $0x13
  801d5b:	e8 13 fe ff ff       	call   801b73 <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
}
  801d63:	90                   	nop
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 14                	push   $0x14
  801d75:	e8 f9 fd ff ff       	call   801b73 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	90                   	nop
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 04             	sub    $0x4,%esp
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d8c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	50                   	push   %eax
  801d99:	6a 15                	push   $0x15
  801d9b:	e8 d3 fd ff ff       	call   801b73 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	90                   	nop
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 16                	push   $0x16
  801db5:	e8 b9 fd ff ff       	call   801b73 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	90                   	nop
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	ff 75 0c             	pushl  0xc(%ebp)
  801dcf:	50                   	push   %eax
  801dd0:	6a 17                	push   $0x17
  801dd2:	e8 9c fd ff ff       	call   801b73 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ddf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	52                   	push   %edx
  801dec:	50                   	push   %eax
  801ded:	6a 1a                	push   $0x1a
  801def:	e8 7f fd ff ff       	call   801b73 <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	52                   	push   %edx
  801e09:	50                   	push   %eax
  801e0a:	6a 18                	push   $0x18
  801e0c:	e8 62 fd ff ff       	call   801b73 <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
}
  801e14:	90                   	nop
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	52                   	push   %edx
  801e27:	50                   	push   %eax
  801e28:	6a 19                	push   $0x19
  801e2a:	e8 44 fd ff ff       	call   801b73 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	90                   	nop
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 04             	sub    $0x4,%esp
  801e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e41:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e44:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	6a 00                	push   $0x0
  801e4d:	51                   	push   %ecx
  801e4e:	52                   	push   %edx
  801e4f:	ff 75 0c             	pushl  0xc(%ebp)
  801e52:	50                   	push   %eax
  801e53:	6a 1b                	push   $0x1b
  801e55:	e8 19 fd ff ff       	call   801b73 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	52                   	push   %edx
  801e6f:	50                   	push   %eax
  801e70:	6a 1c                	push   $0x1c
  801e72:	e8 fc fc ff ff       	call   801b73 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	51                   	push   %ecx
  801e8d:	52                   	push   %edx
  801e8e:	50                   	push   %eax
  801e8f:	6a 1d                	push   $0x1d
  801e91:	e8 dd fc ff ff       	call   801b73 <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	52                   	push   %edx
  801eab:	50                   	push   %eax
  801eac:	6a 1e                	push   $0x1e
  801eae:	e8 c0 fc ff ff       	call   801b73 <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 1f                	push   $0x1f
  801ec7:	e8 a7 fc ff ff       	call   801b73 <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	ff 75 14             	pushl  0x14(%ebp)
  801edc:	ff 75 10             	pushl  0x10(%ebp)
  801edf:	ff 75 0c             	pushl  0xc(%ebp)
  801ee2:	50                   	push   %eax
  801ee3:	6a 20                	push   $0x20
  801ee5:	e8 89 fc ff ff       	call   801b73 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	50                   	push   %eax
  801efe:	6a 21                	push   $0x21
  801f00:	e8 6e fc ff ff       	call   801b73 <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
}
  801f08:	90                   	nop
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	50                   	push   %eax
  801f1a:	6a 22                	push   $0x22
  801f1c:	e8 52 fc ff ff       	call   801b73 <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 02                	push   $0x2
  801f35:	e8 39 fc ff ff       	call   801b73 <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 03                	push   $0x3
  801f4e:	e8 20 fc ff ff       	call   801b73 <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 04                	push   $0x4
  801f67:	e8 07 fc ff ff       	call   801b73 <syscall>
  801f6c:	83 c4 18             	add    $0x18,%esp
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <sys_exit_env>:


void sys_exit_env(void)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 23                	push   $0x23
  801f80:	e8 ee fb ff ff       	call   801b73 <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
}
  801f88:	90                   	nop
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f91:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f94:	8d 50 04             	lea    0x4(%eax),%edx
  801f97:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	52                   	push   %edx
  801fa1:	50                   	push   %eax
  801fa2:	6a 24                	push   $0x24
  801fa4:	e8 ca fb ff ff       	call   801b73 <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
	return result;
  801fac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801faf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fb5:	89 01                	mov    %eax,(%ecx)
  801fb7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	c9                   	leave  
  801fbe:	c2 04 00             	ret    $0x4

00801fc1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	ff 75 10             	pushl  0x10(%ebp)
  801fcb:	ff 75 0c             	pushl  0xc(%ebp)
  801fce:	ff 75 08             	pushl  0x8(%ebp)
  801fd1:	6a 12                	push   $0x12
  801fd3:	e8 9b fb ff ff       	call   801b73 <syscall>
  801fd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801fdb:	90                   	nop
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_rcr2>:
uint32 sys_rcr2()
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 25                	push   $0x25
  801fed:	e8 81 fb ff ff       	call   801b73 <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 04             	sub    $0x4,%esp
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802003:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	50                   	push   %eax
  802010:	6a 26                	push   $0x26
  802012:	e8 5c fb ff ff       	call   801b73 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
	return ;
  80201a:	90                   	nop
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <rsttst>:
void rsttst()
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 28                	push   $0x28
  80202c:	e8 42 fb ff ff       	call   801b73 <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
	return ;
  802034:	90                   	nop
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 04             	sub    $0x4,%esp
  80203d:	8b 45 14             	mov    0x14(%ebp),%eax
  802040:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802043:	8b 55 18             	mov    0x18(%ebp),%edx
  802046:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80204a:	52                   	push   %edx
  80204b:	50                   	push   %eax
  80204c:	ff 75 10             	pushl  0x10(%ebp)
  80204f:	ff 75 0c             	pushl  0xc(%ebp)
  802052:	ff 75 08             	pushl  0x8(%ebp)
  802055:	6a 27                	push   $0x27
  802057:	e8 17 fb ff ff       	call   801b73 <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
	return ;
  80205f:	90                   	nop
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <chktst>:
void chktst(uint32 n)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	ff 75 08             	pushl  0x8(%ebp)
  802070:	6a 29                	push   $0x29
  802072:	e8 fc fa ff ff       	call   801b73 <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
	return ;
  80207a:	90                   	nop
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <inctst>:

void inctst()
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 2a                	push   $0x2a
  80208c:	e8 e2 fa ff ff       	call   801b73 <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
	return ;
  802094:	90                   	nop
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <gettst>:
uint32 gettst()
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 2b                	push   $0x2b
  8020a6:	e8 c8 fa ff ff       	call   801b73 <syscall>
  8020ab:	83 c4 18             	add    $0x18,%esp
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 2c                	push   $0x2c
  8020c2:	e8 ac fa ff ff       	call   801b73 <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
  8020ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020cd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020d1:	75 07                	jne    8020da <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d8:	eb 05                	jmp    8020df <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 2c                	push   $0x2c
  8020f3:	e8 7b fa ff ff       	call   801b73 <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
  8020fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020fe:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802102:	75 07                	jne    80210b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802104:	b8 01 00 00 00       	mov    $0x1,%eax
  802109:	eb 05                	jmp    802110 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 2c                	push   $0x2c
  802124:	e8 4a fa ff ff       	call   801b73 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
  80212c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80212f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802133:	75 07                	jne    80213c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802135:	b8 01 00 00 00       	mov    $0x1,%eax
  80213a:	eb 05                	jmp    802141 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 2c                	push   $0x2c
  802155:	e8 19 fa ff ff       	call   801b73 <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
  80215d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802160:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802164:	75 07                	jne    80216d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802166:	b8 01 00 00 00       	mov    $0x1,%eax
  80216b:	eb 05                	jmp    802172 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80216d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	ff 75 08             	pushl  0x8(%ebp)
  802182:	6a 2d                	push   $0x2d
  802184:	e8 ea f9 ff ff       	call   801b73 <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
	return ;
  80218c:	90                   	nop
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802193:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802196:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802199:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	6a 00                	push   $0x0
  8021a1:	53                   	push   %ebx
  8021a2:	51                   	push   %ecx
  8021a3:	52                   	push   %edx
  8021a4:	50                   	push   %eax
  8021a5:	6a 2e                	push   $0x2e
  8021a7:	e8 c7 f9 ff ff       	call   801b73 <syscall>
  8021ac:	83 c4 18             	add    $0x18,%esp
}
  8021af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	52                   	push   %edx
  8021c4:	50                   	push   %eax
  8021c5:	6a 2f                	push   $0x2f
  8021c7:	e8 a7 f9 ff ff       	call   801b73 <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8021d7:	83 ec 0c             	sub    $0xc,%esp
  8021da:	68 70 43 80 00       	push   $0x804370
  8021df:	e8 6b e8 ff ff       	call   800a4f <cprintf>
  8021e4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8021e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8021ee:	83 ec 0c             	sub    $0xc,%esp
  8021f1:	68 9c 43 80 00       	push   $0x80439c
  8021f6:	e8 54 e8 ff ff       	call   800a4f <cprintf>
  8021fb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8021fe:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802202:	a1 38 51 80 00       	mov    0x805138,%eax
  802207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220a:	eb 56                	jmp    802262 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80220c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802210:	74 1c                	je     80222e <print_mem_block_lists+0x5d>
  802212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802215:	8b 50 08             	mov    0x8(%eax),%edx
  802218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221b:	8b 48 08             	mov    0x8(%eax),%ecx
  80221e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802221:	8b 40 0c             	mov    0xc(%eax),%eax
  802224:	01 c8                	add    %ecx,%eax
  802226:	39 c2                	cmp    %eax,%edx
  802228:	73 04                	jae    80222e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80222a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	8b 50 08             	mov    0x8(%eax),%edx
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	8b 40 0c             	mov    0xc(%eax),%eax
  80223a:	01 c2                	add    %eax,%edx
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	8b 40 08             	mov    0x8(%eax),%eax
  802242:	83 ec 04             	sub    $0x4,%esp
  802245:	52                   	push   %edx
  802246:	50                   	push   %eax
  802247:	68 b1 43 80 00       	push   $0x8043b1
  80224c:	e8 fe e7 ff ff       	call   800a4f <cprintf>
  802251:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802257:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80225a:	a1 40 51 80 00       	mov    0x805140,%eax
  80225f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802262:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802266:	74 07                	je     80226f <print_mem_block_lists+0x9e>
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	8b 00                	mov    (%eax),%eax
  80226d:	eb 05                	jmp    802274 <print_mem_block_lists+0xa3>
  80226f:	b8 00 00 00 00       	mov    $0x0,%eax
  802274:	a3 40 51 80 00       	mov    %eax,0x805140
  802279:	a1 40 51 80 00       	mov    0x805140,%eax
  80227e:	85 c0                	test   %eax,%eax
  802280:	75 8a                	jne    80220c <print_mem_block_lists+0x3b>
  802282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802286:	75 84                	jne    80220c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802288:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80228c:	75 10                	jne    80229e <print_mem_block_lists+0xcd>
  80228e:	83 ec 0c             	sub    $0xc,%esp
  802291:	68 c0 43 80 00       	push   $0x8043c0
  802296:	e8 b4 e7 ff ff       	call   800a4f <cprintf>
  80229b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80229e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8022a5:	83 ec 0c             	sub    $0xc,%esp
  8022a8:	68 e4 43 80 00       	push   $0x8043e4
  8022ad:	e8 9d e7 ff ff       	call   800a4f <cprintf>
  8022b2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8022b5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022b9:	a1 40 50 80 00       	mov    0x805040,%eax
  8022be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c1:	eb 56                	jmp    802319 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022c7:	74 1c                	je     8022e5 <print_mem_block_lists+0x114>
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	8b 50 08             	mov    0x8(%eax),%edx
  8022cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d2:	8b 48 08             	mov    0x8(%eax),%ecx
  8022d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8022db:	01 c8                	add    %ecx,%eax
  8022dd:	39 c2                	cmp    %eax,%edx
  8022df:	73 04                	jae    8022e5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8022e1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e8:	8b 50 08             	mov    0x8(%eax),%edx
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f1:	01 c2                	add    %eax,%edx
  8022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f6:	8b 40 08             	mov    0x8(%eax),%eax
  8022f9:	83 ec 04             	sub    $0x4,%esp
  8022fc:	52                   	push   %edx
  8022fd:	50                   	push   %eax
  8022fe:	68 b1 43 80 00       	push   $0x8043b1
  802303:	e8 47 e7 ff ff       	call   800a4f <cprintf>
  802308:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802311:	a1 48 50 80 00       	mov    0x805048,%eax
  802316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802319:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231d:	74 07                	je     802326 <print_mem_block_lists+0x155>
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	8b 00                	mov    (%eax),%eax
  802324:	eb 05                	jmp    80232b <print_mem_block_lists+0x15a>
  802326:	b8 00 00 00 00       	mov    $0x0,%eax
  80232b:	a3 48 50 80 00       	mov    %eax,0x805048
  802330:	a1 48 50 80 00       	mov    0x805048,%eax
  802335:	85 c0                	test   %eax,%eax
  802337:	75 8a                	jne    8022c3 <print_mem_block_lists+0xf2>
  802339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233d:	75 84                	jne    8022c3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80233f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802343:	75 10                	jne    802355 <print_mem_block_lists+0x184>
  802345:	83 ec 0c             	sub    $0xc,%esp
  802348:	68 fc 43 80 00       	push   $0x8043fc
  80234d:	e8 fd e6 ff ff       	call   800a4f <cprintf>
  802352:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802355:	83 ec 0c             	sub    $0xc,%esp
  802358:	68 70 43 80 00       	push   $0x804370
  80235d:	e8 ed e6 ff ff       	call   800a4f <cprintf>
  802362:	83 c4 10             	add    $0x10,%esp

}
  802365:	90                   	nop
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80236e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802375:	00 00 00 
  802378:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80237f:	00 00 00 
  802382:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802389:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80238c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802393:	e9 9e 00 00 00       	jmp    802436 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802398:	a1 50 50 80 00       	mov    0x805050,%eax
  80239d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a0:	c1 e2 04             	shl    $0x4,%edx
  8023a3:	01 d0                	add    %edx,%eax
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	75 14                	jne    8023bd <initialize_MemBlocksList+0x55>
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	68 24 44 80 00       	push   $0x804424
  8023b1:	6a 46                	push   $0x46
  8023b3:	68 47 44 80 00       	push   $0x804447
  8023b8:	e8 de e3 ff ff       	call   80079b <_panic>
  8023bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8023c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c5:	c1 e2 04             	shl    $0x4,%edx
  8023c8:	01 d0                	add    %edx,%eax
  8023ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8023d0:	89 10                	mov    %edx,(%eax)
  8023d2:	8b 00                	mov    (%eax),%eax
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	74 18                	je     8023f0 <initialize_MemBlocksList+0x88>
  8023d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8023dd:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8023e3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023e6:	c1 e1 04             	shl    $0x4,%ecx
  8023e9:	01 ca                	add    %ecx,%edx
  8023eb:	89 50 04             	mov    %edx,0x4(%eax)
  8023ee:	eb 12                	jmp    802402 <initialize_MemBlocksList+0x9a>
  8023f0:	a1 50 50 80 00       	mov    0x805050,%eax
  8023f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f8:	c1 e2 04             	shl    $0x4,%edx
  8023fb:	01 d0                	add    %edx,%eax
  8023fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802402:	a1 50 50 80 00       	mov    0x805050,%eax
  802407:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240a:	c1 e2 04             	shl    $0x4,%edx
  80240d:	01 d0                	add    %edx,%eax
  80240f:	a3 48 51 80 00       	mov    %eax,0x805148
  802414:	a1 50 50 80 00       	mov    0x805050,%eax
  802419:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241c:	c1 e2 04             	shl    $0x4,%edx
  80241f:	01 d0                	add    %edx,%eax
  802421:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802428:	a1 54 51 80 00       	mov    0x805154,%eax
  80242d:	40                   	inc    %eax
  80242e:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802433:	ff 45 f4             	incl   -0xc(%ebp)
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	3b 45 08             	cmp    0x8(%ebp),%eax
  80243c:	0f 82 56 ff ff ff    	jb     802398 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802442:	90                   	nop
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
  802448:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	8b 00                	mov    (%eax),%eax
  802450:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802453:	eb 19                	jmp    80246e <find_block+0x29>
	{
		if(va==point->sva)
  802455:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802458:	8b 40 08             	mov    0x8(%eax),%eax
  80245b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80245e:	75 05                	jne    802465 <find_block+0x20>
		   return point;
  802460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802463:	eb 36                	jmp    80249b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	8b 40 08             	mov    0x8(%eax),%eax
  80246b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80246e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802472:	74 07                	je     80247b <find_block+0x36>
  802474:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	eb 05                	jmp    802480 <find_block+0x3b>
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
  802480:	8b 55 08             	mov    0x8(%ebp),%edx
  802483:	89 42 08             	mov    %eax,0x8(%edx)
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	8b 40 08             	mov    0x8(%eax),%eax
  80248c:	85 c0                	test   %eax,%eax
  80248e:	75 c5                	jne    802455 <find_block+0x10>
  802490:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802494:	75 bf                	jne    802455 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802496:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
  8024a0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8024a3:	a1 40 50 80 00       	mov    0x805040,%eax
  8024a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8024ab:	a1 44 50 80 00       	mov    0x805044,%eax
  8024b0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8024b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024b9:	74 24                	je     8024df <insert_sorted_allocList+0x42>
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	8b 50 08             	mov    0x8(%eax),%edx
  8024c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c4:	8b 40 08             	mov    0x8(%eax),%eax
  8024c7:	39 c2                	cmp    %eax,%edx
  8024c9:	76 14                	jbe    8024df <insert_sorted_allocList+0x42>
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	8b 50 08             	mov    0x8(%eax),%edx
  8024d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d4:	8b 40 08             	mov    0x8(%eax),%eax
  8024d7:	39 c2                	cmp    %eax,%edx
  8024d9:	0f 82 60 01 00 00    	jb     80263f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8024df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024e3:	75 65                	jne    80254a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8024e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e9:	75 14                	jne    8024ff <insert_sorted_allocList+0x62>
  8024eb:	83 ec 04             	sub    $0x4,%esp
  8024ee:	68 24 44 80 00       	push   $0x804424
  8024f3:	6a 6b                	push   $0x6b
  8024f5:	68 47 44 80 00       	push   $0x804447
  8024fa:	e8 9c e2 ff ff       	call   80079b <_panic>
  8024ff:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802505:	8b 45 08             	mov    0x8(%ebp),%eax
  802508:	89 10                	mov    %edx,(%eax)
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	85 c0                	test   %eax,%eax
  802511:	74 0d                	je     802520 <insert_sorted_allocList+0x83>
  802513:	a1 40 50 80 00       	mov    0x805040,%eax
  802518:	8b 55 08             	mov    0x8(%ebp),%edx
  80251b:	89 50 04             	mov    %edx,0x4(%eax)
  80251e:	eb 08                	jmp    802528 <insert_sorted_allocList+0x8b>
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	a3 44 50 80 00       	mov    %eax,0x805044
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	a3 40 50 80 00       	mov    %eax,0x805040
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80253a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80253f:	40                   	inc    %eax
  802540:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802545:	e9 dc 01 00 00       	jmp    802726 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	8b 50 08             	mov    0x8(%eax),%edx
  802550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802553:	8b 40 08             	mov    0x8(%eax),%eax
  802556:	39 c2                	cmp    %eax,%edx
  802558:	77 6c                	ja     8025c6 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80255a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80255e:	74 06                	je     802566 <insert_sorted_allocList+0xc9>
  802560:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802564:	75 14                	jne    80257a <insert_sorted_allocList+0xdd>
  802566:	83 ec 04             	sub    $0x4,%esp
  802569:	68 60 44 80 00       	push   $0x804460
  80256e:	6a 6f                	push   $0x6f
  802570:	68 47 44 80 00       	push   $0x804447
  802575:	e8 21 e2 ff ff       	call   80079b <_panic>
  80257a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257d:	8b 50 04             	mov    0x4(%eax),%edx
  802580:	8b 45 08             	mov    0x8(%ebp),%eax
  802583:	89 50 04             	mov    %edx,0x4(%eax)
  802586:	8b 45 08             	mov    0x8(%ebp),%eax
  802589:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80258c:	89 10                	mov    %edx,(%eax)
  80258e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802591:	8b 40 04             	mov    0x4(%eax),%eax
  802594:	85 c0                	test   %eax,%eax
  802596:	74 0d                	je     8025a5 <insert_sorted_allocList+0x108>
  802598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259b:	8b 40 04             	mov    0x4(%eax),%eax
  80259e:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a1:	89 10                	mov    %edx,(%eax)
  8025a3:	eb 08                	jmp    8025ad <insert_sorted_allocList+0x110>
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	a3 40 50 80 00       	mov    %eax,0x805040
  8025ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b3:	89 50 04             	mov    %edx,0x4(%eax)
  8025b6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025bb:	40                   	inc    %eax
  8025bc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025c1:	e9 60 01 00 00       	jmp    802726 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	8b 50 08             	mov    0x8(%eax),%edx
  8025cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cf:	8b 40 08             	mov    0x8(%eax),%eax
  8025d2:	39 c2                	cmp    %eax,%edx
  8025d4:	0f 82 4c 01 00 00    	jb     802726 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8025da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025de:	75 14                	jne    8025f4 <insert_sorted_allocList+0x157>
  8025e0:	83 ec 04             	sub    $0x4,%esp
  8025e3:	68 98 44 80 00       	push   $0x804498
  8025e8:	6a 73                	push   $0x73
  8025ea:	68 47 44 80 00       	push   $0x804447
  8025ef:	e8 a7 e1 ff ff       	call   80079b <_panic>
  8025f4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	89 50 04             	mov    %edx,0x4(%eax)
  802600:	8b 45 08             	mov    0x8(%ebp),%eax
  802603:	8b 40 04             	mov    0x4(%eax),%eax
  802606:	85 c0                	test   %eax,%eax
  802608:	74 0c                	je     802616 <insert_sorted_allocList+0x179>
  80260a:	a1 44 50 80 00       	mov    0x805044,%eax
  80260f:	8b 55 08             	mov    0x8(%ebp),%edx
  802612:	89 10                	mov    %edx,(%eax)
  802614:	eb 08                	jmp    80261e <insert_sorted_allocList+0x181>
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	a3 40 50 80 00       	mov    %eax,0x805040
  80261e:	8b 45 08             	mov    0x8(%ebp),%eax
  802621:	a3 44 50 80 00       	mov    %eax,0x805044
  802626:	8b 45 08             	mov    0x8(%ebp),%eax
  802629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802634:	40                   	inc    %eax
  802635:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80263a:	e9 e7 00 00 00       	jmp    802726 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80263f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802642:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802645:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80264c:	a1 40 50 80 00       	mov    0x805040,%eax
  802651:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802654:	e9 9d 00 00 00       	jmp    8026f6 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	8b 50 08             	mov    0x8(%eax),%edx
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 40 08             	mov    0x8(%eax),%eax
  80266d:	39 c2                	cmp    %eax,%edx
  80266f:	76 7d                	jbe    8026ee <insert_sorted_allocList+0x251>
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	8b 50 08             	mov    0x8(%eax),%edx
  802677:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80267a:	8b 40 08             	mov    0x8(%eax),%eax
  80267d:	39 c2                	cmp    %eax,%edx
  80267f:	73 6d                	jae    8026ee <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802681:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802685:	74 06                	je     80268d <insert_sorted_allocList+0x1f0>
  802687:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80268b:	75 14                	jne    8026a1 <insert_sorted_allocList+0x204>
  80268d:	83 ec 04             	sub    $0x4,%esp
  802690:	68 bc 44 80 00       	push   $0x8044bc
  802695:	6a 7f                	push   $0x7f
  802697:	68 47 44 80 00       	push   $0x804447
  80269c:	e8 fa e0 ff ff       	call   80079b <_panic>
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 10                	mov    (%eax),%edx
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	89 10                	mov    %edx,(%eax)
  8026ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ae:	8b 00                	mov    (%eax),%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	74 0b                	je     8026bf <insert_sorted_allocList+0x222>
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	8b 00                	mov    (%eax),%eax
  8026b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bc:	89 50 04             	mov    %edx,0x4(%eax)
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c5:	89 10                	mov    %edx,(%eax)
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cd:	89 50 04             	mov    %edx,0x4(%eax)
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	8b 00                	mov    (%eax),%eax
  8026d5:	85 c0                	test   %eax,%eax
  8026d7:	75 08                	jne    8026e1 <insert_sorted_allocList+0x244>
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	a3 44 50 80 00       	mov    %eax,0x805044
  8026e1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026e6:	40                   	inc    %eax
  8026e7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8026ec:	eb 39                	jmp    802727 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8026ee:	a1 48 50 80 00       	mov    0x805048,%eax
  8026f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fa:	74 07                	je     802703 <insert_sorted_allocList+0x266>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 00                	mov    (%eax),%eax
  802701:	eb 05                	jmp    802708 <insert_sorted_allocList+0x26b>
  802703:	b8 00 00 00 00       	mov    $0x0,%eax
  802708:	a3 48 50 80 00       	mov    %eax,0x805048
  80270d:	a1 48 50 80 00       	mov    0x805048,%eax
  802712:	85 c0                	test   %eax,%eax
  802714:	0f 85 3f ff ff ff    	jne    802659 <insert_sorted_allocList+0x1bc>
  80271a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271e:	0f 85 35 ff ff ff    	jne    802659 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802724:	eb 01                	jmp    802727 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802726:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802727:	90                   	nop
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802730:	a1 38 51 80 00       	mov    0x805138,%eax
  802735:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802738:	e9 85 01 00 00       	jmp    8028c2 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 40 0c             	mov    0xc(%eax),%eax
  802743:	3b 45 08             	cmp    0x8(%ebp),%eax
  802746:	0f 82 6e 01 00 00    	jb     8028ba <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 40 0c             	mov    0xc(%eax),%eax
  802752:	3b 45 08             	cmp    0x8(%ebp),%eax
  802755:	0f 85 8a 00 00 00    	jne    8027e5 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80275b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275f:	75 17                	jne    802778 <alloc_block_FF+0x4e>
  802761:	83 ec 04             	sub    $0x4,%esp
  802764:	68 f0 44 80 00       	push   $0x8044f0
  802769:	68 93 00 00 00       	push   $0x93
  80276e:	68 47 44 80 00       	push   $0x804447
  802773:	e8 23 e0 ff ff       	call   80079b <_panic>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	74 10                	je     802791 <alloc_block_FF+0x67>
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 00                	mov    (%eax),%eax
  802786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802789:	8b 52 04             	mov    0x4(%edx),%edx
  80278c:	89 50 04             	mov    %edx,0x4(%eax)
  80278f:	eb 0b                	jmp    80279c <alloc_block_FF+0x72>
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 40 04             	mov    0x4(%eax),%eax
  802797:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 40 04             	mov    0x4(%eax),%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	74 0f                	je     8027b5 <alloc_block_FF+0x8b>
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027af:	8b 12                	mov    (%edx),%edx
  8027b1:	89 10                	mov    %edx,(%eax)
  8027b3:	eb 0a                	jmp    8027bf <alloc_block_FF+0x95>
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 00                	mov    (%eax),%eax
  8027ba:	a3 38 51 80 00       	mov    %eax,0x805138
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d2:	a1 44 51 80 00       	mov    0x805144,%eax
  8027d7:	48                   	dec    %eax
  8027d8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	e9 10 01 00 00       	jmp    8028f5 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ee:	0f 86 c6 00 00 00    	jbe    8028ba <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8027f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 50 08             	mov    0x8(%eax),%edx
  802802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802805:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280b:	8b 55 08             	mov    0x8(%ebp),%edx
  80280e:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802811:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802815:	75 17                	jne    80282e <alloc_block_FF+0x104>
  802817:	83 ec 04             	sub    $0x4,%esp
  80281a:	68 f0 44 80 00       	push   $0x8044f0
  80281f:	68 9b 00 00 00       	push   $0x9b
  802824:	68 47 44 80 00       	push   $0x804447
  802829:	e8 6d df ff ff       	call   80079b <_panic>
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	74 10                	je     802847 <alloc_block_FF+0x11d>
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80283f:	8b 52 04             	mov    0x4(%edx),%edx
  802842:	89 50 04             	mov    %edx,0x4(%eax)
  802845:	eb 0b                	jmp    802852 <alloc_block_FF+0x128>
  802847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284a:	8b 40 04             	mov    0x4(%eax),%eax
  80284d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802855:	8b 40 04             	mov    0x4(%eax),%eax
  802858:	85 c0                	test   %eax,%eax
  80285a:	74 0f                	je     80286b <alloc_block_FF+0x141>
  80285c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285f:	8b 40 04             	mov    0x4(%eax),%eax
  802862:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802865:	8b 12                	mov    (%edx),%edx
  802867:	89 10                	mov    %edx,(%eax)
  802869:	eb 0a                	jmp    802875 <alloc_block_FF+0x14b>
  80286b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	a3 48 51 80 00       	mov    %eax,0x805148
  802875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802878:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802881:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802888:	a1 54 51 80 00       	mov    0x805154,%eax
  80288d:	48                   	dec    %eax
  80288e:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 50 08             	mov    0x8(%eax),%edx
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	01 c2                	add    %eax,%edx
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028aa:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ad:	89 c2                	mov    %eax,%edx
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8028b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b8:	eb 3b                	jmp    8028f5 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8028bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c6:	74 07                	je     8028cf <alloc_block_FF+0x1a5>
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	eb 05                	jmp    8028d4 <alloc_block_FF+0x1aa>
  8028cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d4:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d9:	a1 40 51 80 00       	mov    0x805140,%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	0f 85 57 fe ff ff    	jne    80273d <alloc_block_FF+0x13>
  8028e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ea:	0f 85 4d fe ff ff    	jne    80273d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8028f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f5:	c9                   	leave  
  8028f6:	c3                   	ret    

008028f7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8028f7:	55                   	push   %ebp
  8028f8:	89 e5                	mov    %esp,%ebp
  8028fa:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8028fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802904:	a1 38 51 80 00       	mov    0x805138,%eax
  802909:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290c:	e9 df 00 00 00       	jmp    8029f0 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 40 0c             	mov    0xc(%eax),%eax
  802917:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291a:	0f 82 c8 00 00 00    	jb     8029e8 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 40 0c             	mov    0xc(%eax),%eax
  802926:	3b 45 08             	cmp    0x8(%ebp),%eax
  802929:	0f 85 8a 00 00 00    	jne    8029b9 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80292f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802933:	75 17                	jne    80294c <alloc_block_BF+0x55>
  802935:	83 ec 04             	sub    $0x4,%esp
  802938:	68 f0 44 80 00       	push   $0x8044f0
  80293d:	68 b7 00 00 00       	push   $0xb7
  802942:	68 47 44 80 00       	push   $0x804447
  802947:	e8 4f de ff ff       	call   80079b <_panic>
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	85 c0                	test   %eax,%eax
  802953:	74 10                	je     802965 <alloc_block_BF+0x6e>
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295d:	8b 52 04             	mov    0x4(%edx),%edx
  802960:	89 50 04             	mov    %edx,0x4(%eax)
  802963:	eb 0b                	jmp    802970 <alloc_block_BF+0x79>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 40 04             	mov    0x4(%eax),%eax
  802976:	85 c0                	test   %eax,%eax
  802978:	74 0f                	je     802989 <alloc_block_BF+0x92>
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 40 04             	mov    0x4(%eax),%eax
  802980:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802983:	8b 12                	mov    (%edx),%edx
  802985:	89 10                	mov    %edx,(%eax)
  802987:	eb 0a                	jmp    802993 <alloc_block_BF+0x9c>
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 00                	mov    (%eax),%eax
  80298e:	a3 38 51 80 00       	mov    %eax,0x805138
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8029ab:	48                   	dec    %eax
  8029ac:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	e9 4d 01 00 00       	jmp    802b06 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c2:	76 24                	jbe    8029e8 <alloc_block_BF+0xf1>
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029cd:	73 19                	jae    8029e8 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8029cf:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 40 08             	mov    0x8(%eax),%eax
  8029e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f4:	74 07                	je     8029fd <alloc_block_BF+0x106>
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	eb 05                	jmp    802a02 <alloc_block_BF+0x10b>
  8029fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802a02:	a3 40 51 80 00       	mov    %eax,0x805140
  802a07:	a1 40 51 80 00       	mov    0x805140,%eax
  802a0c:	85 c0                	test   %eax,%eax
  802a0e:	0f 85 fd fe ff ff    	jne    802911 <alloc_block_BF+0x1a>
  802a14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a18:	0f 85 f3 fe ff ff    	jne    802911 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802a1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a22:	0f 84 d9 00 00 00    	je     802b01 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a28:	a1 48 51 80 00       	mov    0x805148,%eax
  802a2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a36:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802a39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a3f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802a42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a46:	75 17                	jne    802a5f <alloc_block_BF+0x168>
  802a48:	83 ec 04             	sub    $0x4,%esp
  802a4b:	68 f0 44 80 00       	push   $0x8044f0
  802a50:	68 c7 00 00 00       	push   $0xc7
  802a55:	68 47 44 80 00       	push   $0x804447
  802a5a:	e8 3c dd ff ff       	call   80079b <_panic>
  802a5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a62:	8b 00                	mov    (%eax),%eax
  802a64:	85 c0                	test   %eax,%eax
  802a66:	74 10                	je     802a78 <alloc_block_BF+0x181>
  802a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6b:	8b 00                	mov    (%eax),%eax
  802a6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a70:	8b 52 04             	mov    0x4(%edx),%edx
  802a73:	89 50 04             	mov    %edx,0x4(%eax)
  802a76:	eb 0b                	jmp    802a83 <alloc_block_BF+0x18c>
  802a78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7b:	8b 40 04             	mov    0x4(%eax),%eax
  802a7e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a86:	8b 40 04             	mov    0x4(%eax),%eax
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	74 0f                	je     802a9c <alloc_block_BF+0x1a5>
  802a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a90:	8b 40 04             	mov    0x4(%eax),%eax
  802a93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a96:	8b 12                	mov    (%edx),%edx
  802a98:	89 10                	mov    %edx,(%eax)
  802a9a:	eb 0a                	jmp    802aa6 <alloc_block_BF+0x1af>
  802a9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a9f:	8b 00                	mov    (%eax),%eax
  802aa1:	a3 48 51 80 00       	mov    %eax,0x805148
  802aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab9:	a1 54 51 80 00       	mov    0x805154,%eax
  802abe:	48                   	dec    %eax
  802abf:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802ac4:	83 ec 08             	sub    $0x8,%esp
  802ac7:	ff 75 ec             	pushl  -0x14(%ebp)
  802aca:	68 38 51 80 00       	push   $0x805138
  802acf:	e8 71 f9 ff ff       	call   802445 <find_block>
  802ad4:	83 c4 10             	add    $0x10,%esp
  802ad7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802ada:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802add:	8b 50 08             	mov    0x8(%eax),%edx
  802ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae3:	01 c2                	add    %eax,%edx
  802ae5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae8:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802aeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aee:	8b 40 0c             	mov    0xc(%eax),%eax
  802af1:	2b 45 08             	sub    0x8(%ebp),%eax
  802af4:	89 c2                	mov    %eax,%edx
  802af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af9:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aff:	eb 05                	jmp    802b06 <alloc_block_BF+0x20f>
	}
	return NULL;
  802b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b06:	c9                   	leave  
  802b07:	c3                   	ret    

00802b08 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b08:	55                   	push   %ebp
  802b09:	89 e5                	mov    %esp,%ebp
  802b0b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802b0e:	a1 28 50 80 00       	mov    0x805028,%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	0f 85 de 01 00 00    	jne    802cf9 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b1b:	a1 38 51 80 00       	mov    0x805138,%eax
  802b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b23:	e9 9e 01 00 00       	jmp    802cc6 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b31:	0f 82 87 01 00 00    	jb     802cbe <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b40:	0f 85 95 00 00 00    	jne    802bdb <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802b46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4a:	75 17                	jne    802b63 <alloc_block_NF+0x5b>
  802b4c:	83 ec 04             	sub    $0x4,%esp
  802b4f:	68 f0 44 80 00       	push   $0x8044f0
  802b54:	68 e0 00 00 00       	push   $0xe0
  802b59:	68 47 44 80 00       	push   $0x804447
  802b5e:	e8 38 dc ff ff       	call   80079b <_panic>
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	74 10                	je     802b7c <alloc_block_NF+0x74>
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b74:	8b 52 04             	mov    0x4(%edx),%edx
  802b77:	89 50 04             	mov    %edx,0x4(%eax)
  802b7a:	eb 0b                	jmp    802b87 <alloc_block_NF+0x7f>
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 40 04             	mov    0x4(%eax),%eax
  802b82:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 40 04             	mov    0x4(%eax),%eax
  802b8d:	85 c0                	test   %eax,%eax
  802b8f:	74 0f                	je     802ba0 <alloc_block_NF+0x98>
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 40 04             	mov    0x4(%eax),%eax
  802b97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9a:	8b 12                	mov    (%edx),%edx
  802b9c:	89 10                	mov    %edx,(%eax)
  802b9e:	eb 0a                	jmp    802baa <alloc_block_NF+0xa2>
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	a3 38 51 80 00       	mov    %eax,0x805138
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbd:	a1 44 51 80 00       	mov    0x805144,%eax
  802bc2:	48                   	dec    %eax
  802bc3:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	8b 40 08             	mov    0x8(%eax),%eax
  802bce:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	e9 f8 04 00 00       	jmp    8030d3 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 40 0c             	mov    0xc(%eax),%eax
  802be1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be4:	0f 86 d4 00 00 00    	jbe    802cbe <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bea:	a1 48 51 80 00       	mov    0x805148,%eax
  802bef:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 50 08             	mov    0x8(%eax),%edx
  802bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfb:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c01:	8b 55 08             	mov    0x8(%ebp),%edx
  802c04:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c0b:	75 17                	jne    802c24 <alloc_block_NF+0x11c>
  802c0d:	83 ec 04             	sub    $0x4,%esp
  802c10:	68 f0 44 80 00       	push   $0x8044f0
  802c15:	68 e9 00 00 00       	push   $0xe9
  802c1a:	68 47 44 80 00       	push   $0x804447
  802c1f:	e8 77 db ff ff       	call   80079b <_panic>
  802c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	74 10                	je     802c3d <alloc_block_NF+0x135>
  802c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c35:	8b 52 04             	mov    0x4(%edx),%edx
  802c38:	89 50 04             	mov    %edx,0x4(%eax)
  802c3b:	eb 0b                	jmp    802c48 <alloc_block_NF+0x140>
  802c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c40:	8b 40 04             	mov    0x4(%eax),%eax
  802c43:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	74 0f                	je     802c61 <alloc_block_NF+0x159>
  802c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c55:	8b 40 04             	mov    0x4(%eax),%eax
  802c58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c5b:	8b 12                	mov    (%edx),%edx
  802c5d:	89 10                	mov    %edx,(%eax)
  802c5f:	eb 0a                	jmp    802c6b <alloc_block_NF+0x163>
  802c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	a3 48 51 80 00       	mov    %eax,0x805148
  802c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7e:	a1 54 51 80 00       	mov    0x805154,%eax
  802c83:	48                   	dec    %eax
  802c84:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8c:	8b 40 08             	mov    0x8(%eax),%eax
  802c8f:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 50 08             	mov    0x8(%eax),%edx
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	01 c2                	add    %eax,%edx
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cab:	2b 45 08             	sub    0x8(%ebp),%eax
  802cae:	89 c2                	mov    %eax,%edx
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb9:	e9 15 04 00 00       	jmp    8030d3 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802cbe:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cca:	74 07                	je     802cd3 <alloc_block_NF+0x1cb>
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 00                	mov    (%eax),%eax
  802cd1:	eb 05                	jmp    802cd8 <alloc_block_NF+0x1d0>
  802cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd8:	a3 40 51 80 00       	mov    %eax,0x805140
  802cdd:	a1 40 51 80 00       	mov    0x805140,%eax
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	0f 85 3e fe ff ff    	jne    802b28 <alloc_block_NF+0x20>
  802cea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cee:	0f 85 34 fe ff ff    	jne    802b28 <alloc_block_NF+0x20>
  802cf4:	e9 d5 03 00 00       	jmp    8030ce <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cf9:	a1 38 51 80 00       	mov    0x805138,%eax
  802cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d01:	e9 b1 01 00 00       	jmp    802eb7 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 50 08             	mov    0x8(%eax),%edx
  802d0c:	a1 28 50 80 00       	mov    0x805028,%eax
  802d11:	39 c2                	cmp    %eax,%edx
  802d13:	0f 82 96 01 00 00    	jb     802eaf <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d22:	0f 82 87 01 00 00    	jb     802eaf <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d31:	0f 85 95 00 00 00    	jne    802dcc <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3b:	75 17                	jne    802d54 <alloc_block_NF+0x24c>
  802d3d:	83 ec 04             	sub    $0x4,%esp
  802d40:	68 f0 44 80 00       	push   $0x8044f0
  802d45:	68 fc 00 00 00       	push   $0xfc
  802d4a:	68 47 44 80 00       	push   $0x804447
  802d4f:	e8 47 da ff ff       	call   80079b <_panic>
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 00                	mov    (%eax),%eax
  802d59:	85 c0                	test   %eax,%eax
  802d5b:	74 10                	je     802d6d <alloc_block_NF+0x265>
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d65:	8b 52 04             	mov    0x4(%edx),%edx
  802d68:	89 50 04             	mov    %edx,0x4(%eax)
  802d6b:	eb 0b                	jmp    802d78 <alloc_block_NF+0x270>
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 40 04             	mov    0x4(%eax),%eax
  802d73:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 40 04             	mov    0x4(%eax),%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	74 0f                	je     802d91 <alloc_block_NF+0x289>
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 40 04             	mov    0x4(%eax),%eax
  802d88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8b:	8b 12                	mov    (%edx),%edx
  802d8d:	89 10                	mov    %edx,(%eax)
  802d8f:	eb 0a                	jmp    802d9b <alloc_block_NF+0x293>
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	a3 38 51 80 00       	mov    %eax,0x805138
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dae:	a1 44 51 80 00       	mov    0x805144,%eax
  802db3:	48                   	dec    %eax
  802db4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 40 08             	mov    0x8(%eax),%eax
  802dbf:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	e9 07 03 00 00       	jmp    8030d3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dd5:	0f 86 d4 00 00 00    	jbe    802eaf <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ddb:	a1 48 51 80 00       	mov    0x805148,%eax
  802de0:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	8b 50 08             	mov    0x8(%eax),%edx
  802de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dec:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802def:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df2:	8b 55 08             	mov    0x8(%ebp),%edx
  802df5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802df8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dfc:	75 17                	jne    802e15 <alloc_block_NF+0x30d>
  802dfe:	83 ec 04             	sub    $0x4,%esp
  802e01:	68 f0 44 80 00       	push   $0x8044f0
  802e06:	68 04 01 00 00       	push   $0x104
  802e0b:	68 47 44 80 00       	push   $0x804447
  802e10:	e8 86 d9 ff ff       	call   80079b <_panic>
  802e15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e18:	8b 00                	mov    (%eax),%eax
  802e1a:	85 c0                	test   %eax,%eax
  802e1c:	74 10                	je     802e2e <alloc_block_NF+0x326>
  802e1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e26:	8b 52 04             	mov    0x4(%edx),%edx
  802e29:	89 50 04             	mov    %edx,0x4(%eax)
  802e2c:	eb 0b                	jmp    802e39 <alloc_block_NF+0x331>
  802e2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e31:	8b 40 04             	mov    0x4(%eax),%eax
  802e34:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3c:	8b 40 04             	mov    0x4(%eax),%eax
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	74 0f                	je     802e52 <alloc_block_NF+0x34a>
  802e43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e46:	8b 40 04             	mov    0x4(%eax),%eax
  802e49:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e4c:	8b 12                	mov    (%edx),%edx
  802e4e:	89 10                	mov    %edx,(%eax)
  802e50:	eb 0a                	jmp    802e5c <alloc_block_NF+0x354>
  802e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	a3 48 51 80 00       	mov    %eax,0x805148
  802e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6f:	a1 54 51 80 00       	mov    0x805154,%eax
  802e74:	48                   	dec    %eax
  802e75:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7d:	8b 40 08             	mov    0x8(%eax),%eax
  802e80:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 50 08             	mov    0x8(%eax),%edx
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	01 c2                	add    %eax,%edx
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9c:	2b 45 08             	sub    0x8(%ebp),%eax
  802e9f:	89 c2                	mov    %eax,%edx
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ea7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eaa:	e9 24 02 00 00       	jmp    8030d3 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802eaf:	a1 40 51 80 00       	mov    0x805140,%eax
  802eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebb:	74 07                	je     802ec4 <alloc_block_NF+0x3bc>
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	eb 05                	jmp    802ec9 <alloc_block_NF+0x3c1>
  802ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec9:	a3 40 51 80 00       	mov    %eax,0x805140
  802ece:	a1 40 51 80 00       	mov    0x805140,%eax
  802ed3:	85 c0                	test   %eax,%eax
  802ed5:	0f 85 2b fe ff ff    	jne    802d06 <alloc_block_NF+0x1fe>
  802edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edf:	0f 85 21 fe ff ff    	jne    802d06 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ee5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eed:	e9 ae 01 00 00       	jmp    8030a0 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 50 08             	mov    0x8(%eax),%edx
  802ef8:	a1 28 50 80 00       	mov    0x805028,%eax
  802efd:	39 c2                	cmp    %eax,%edx
  802eff:	0f 83 93 01 00 00    	jae    803098 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f08:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f0e:	0f 82 84 01 00 00    	jb     803098 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f1d:	0f 85 95 00 00 00    	jne    802fb8 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f27:	75 17                	jne    802f40 <alloc_block_NF+0x438>
  802f29:	83 ec 04             	sub    $0x4,%esp
  802f2c:	68 f0 44 80 00       	push   $0x8044f0
  802f31:	68 14 01 00 00       	push   $0x114
  802f36:	68 47 44 80 00       	push   $0x804447
  802f3b:	e8 5b d8 ff ff       	call   80079b <_panic>
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	8b 00                	mov    (%eax),%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	74 10                	je     802f59 <alloc_block_NF+0x451>
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 00                	mov    (%eax),%eax
  802f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f51:	8b 52 04             	mov    0x4(%edx),%edx
  802f54:	89 50 04             	mov    %edx,0x4(%eax)
  802f57:	eb 0b                	jmp    802f64 <alloc_block_NF+0x45c>
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 40 04             	mov    0x4(%eax),%eax
  802f5f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 40 04             	mov    0x4(%eax),%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	74 0f                	je     802f7d <alloc_block_NF+0x475>
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	8b 40 04             	mov    0x4(%eax),%eax
  802f74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f77:	8b 12                	mov    (%edx),%edx
  802f79:	89 10                	mov    %edx,(%eax)
  802f7b:	eb 0a                	jmp    802f87 <alloc_block_NF+0x47f>
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	a3 38 51 80 00       	mov    %eax,0x805138
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9f:	48                   	dec    %eax
  802fa0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 40 08             	mov    0x8(%eax),%eax
  802fab:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	e9 1b 01 00 00       	jmp    8030d3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fc1:	0f 86 d1 00 00 00    	jbe    803098 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fc7:	a1 48 51 80 00       	mov    0x805148,%eax
  802fcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd2:	8b 50 08             	mov    0x8(%eax),%edx
  802fd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fde:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fe4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fe8:	75 17                	jne    803001 <alloc_block_NF+0x4f9>
  802fea:	83 ec 04             	sub    $0x4,%esp
  802fed:	68 f0 44 80 00       	push   $0x8044f0
  802ff2:	68 1c 01 00 00       	push   $0x11c
  802ff7:	68 47 44 80 00       	push   $0x804447
  802ffc:	e8 9a d7 ff ff       	call   80079b <_panic>
  803001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803004:	8b 00                	mov    (%eax),%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	74 10                	je     80301a <alloc_block_NF+0x512>
  80300a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803012:	8b 52 04             	mov    0x4(%edx),%edx
  803015:	89 50 04             	mov    %edx,0x4(%eax)
  803018:	eb 0b                	jmp    803025 <alloc_block_NF+0x51d>
  80301a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301d:	8b 40 04             	mov    0x4(%eax),%eax
  803020:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803028:	8b 40 04             	mov    0x4(%eax),%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	74 0f                	je     80303e <alloc_block_NF+0x536>
  80302f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803032:	8b 40 04             	mov    0x4(%eax),%eax
  803035:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803038:	8b 12                	mov    (%edx),%edx
  80303a:	89 10                	mov    %edx,(%eax)
  80303c:	eb 0a                	jmp    803048 <alloc_block_NF+0x540>
  80303e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803041:	8b 00                	mov    (%eax),%eax
  803043:	a3 48 51 80 00       	mov    %eax,0x805148
  803048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803051:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803054:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305b:	a1 54 51 80 00       	mov    0x805154,%eax
  803060:	48                   	dec    %eax
  803061:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803066:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803069:	8b 40 08             	mov    0x8(%eax),%eax
  80306c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 50 08             	mov    0x8(%eax),%edx
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	01 c2                	add    %eax,%edx
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803085:	8b 40 0c             	mov    0xc(%eax),%eax
  803088:	2b 45 08             	sub    0x8(%ebp),%eax
  80308b:	89 c2                	mov    %eax,%edx
  80308d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803090:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803093:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803096:	eb 3b                	jmp    8030d3 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803098:	a1 40 51 80 00       	mov    0x805140,%eax
  80309d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a4:	74 07                	je     8030ad <alloc_block_NF+0x5a5>
  8030a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a9:	8b 00                	mov    (%eax),%eax
  8030ab:	eb 05                	jmp    8030b2 <alloc_block_NF+0x5aa>
  8030ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b2:	a3 40 51 80 00       	mov    %eax,0x805140
  8030b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8030bc:	85 c0                	test   %eax,%eax
  8030be:	0f 85 2e fe ff ff    	jne    802ef2 <alloc_block_NF+0x3ea>
  8030c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c8:	0f 85 24 fe ff ff    	jne    802ef2 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8030ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030d3:	c9                   	leave  
  8030d4:	c3                   	ret    

008030d5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030d5:	55                   	push   %ebp
  8030d6:	89 e5                	mov    %esp,%ebp
  8030d8:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8030db:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8030e3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030e8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8030eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	74 14                	je     803108 <insert_sorted_with_merge_freeList+0x33>
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	8b 50 08             	mov    0x8(%eax),%edx
  8030fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fd:	8b 40 08             	mov    0x8(%eax),%eax
  803100:	39 c2                	cmp    %eax,%edx
  803102:	0f 87 9b 01 00 00    	ja     8032a3 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803108:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310c:	75 17                	jne    803125 <insert_sorted_with_merge_freeList+0x50>
  80310e:	83 ec 04             	sub    $0x4,%esp
  803111:	68 24 44 80 00       	push   $0x804424
  803116:	68 38 01 00 00       	push   $0x138
  80311b:	68 47 44 80 00       	push   $0x804447
  803120:	e8 76 d6 ff ff       	call   80079b <_panic>
  803125:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	89 10                	mov    %edx,(%eax)
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	8b 00                	mov    (%eax),%eax
  803135:	85 c0                	test   %eax,%eax
  803137:	74 0d                	je     803146 <insert_sorted_with_merge_freeList+0x71>
  803139:	a1 38 51 80 00       	mov    0x805138,%eax
  80313e:	8b 55 08             	mov    0x8(%ebp),%edx
  803141:	89 50 04             	mov    %edx,0x4(%eax)
  803144:	eb 08                	jmp    80314e <insert_sorted_with_merge_freeList+0x79>
  803146:	8b 45 08             	mov    0x8(%ebp),%eax
  803149:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	a3 38 51 80 00       	mov    %eax,0x805138
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803160:	a1 44 51 80 00       	mov    0x805144,%eax
  803165:	40                   	inc    %eax
  803166:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80316b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80316f:	0f 84 a8 06 00 00    	je     80381d <insert_sorted_with_merge_freeList+0x748>
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	8b 50 08             	mov    0x8(%eax),%edx
  80317b:	8b 45 08             	mov    0x8(%ebp),%eax
  80317e:	8b 40 0c             	mov    0xc(%eax),%eax
  803181:	01 c2                	add    %eax,%edx
  803183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803186:	8b 40 08             	mov    0x8(%eax),%eax
  803189:	39 c2                	cmp    %eax,%edx
  80318b:	0f 85 8c 06 00 00    	jne    80381d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	8b 50 0c             	mov    0xc(%eax),%edx
  803197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319a:	8b 40 0c             	mov    0xc(%eax),%eax
  80319d:	01 c2                	add    %eax,%edx
  80319f:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a2:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8031a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031a9:	75 17                	jne    8031c2 <insert_sorted_with_merge_freeList+0xed>
  8031ab:	83 ec 04             	sub    $0x4,%esp
  8031ae:	68 f0 44 80 00       	push   $0x8044f0
  8031b3:	68 3c 01 00 00       	push   $0x13c
  8031b8:	68 47 44 80 00       	push   $0x804447
  8031bd:	e8 d9 d5 ff ff       	call   80079b <_panic>
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	74 10                	je     8031db <insert_sorted_with_merge_freeList+0x106>
  8031cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ce:	8b 00                	mov    (%eax),%eax
  8031d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d3:	8b 52 04             	mov    0x4(%edx),%edx
  8031d6:	89 50 04             	mov    %edx,0x4(%eax)
  8031d9:	eb 0b                	jmp    8031e6 <insert_sorted_with_merge_freeList+0x111>
  8031db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031de:	8b 40 04             	mov    0x4(%eax),%eax
  8031e1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e9:	8b 40 04             	mov    0x4(%eax),%eax
  8031ec:	85 c0                	test   %eax,%eax
  8031ee:	74 0f                	je     8031ff <insert_sorted_with_merge_freeList+0x12a>
  8031f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f3:	8b 40 04             	mov    0x4(%eax),%eax
  8031f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f9:	8b 12                	mov    (%edx),%edx
  8031fb:	89 10                	mov    %edx,(%eax)
  8031fd:	eb 0a                	jmp    803209 <insert_sorted_with_merge_freeList+0x134>
  8031ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	a3 38 51 80 00       	mov    %eax,0x805138
  803209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803215:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321c:	a1 44 51 80 00       	mov    0x805144,%eax
  803221:	48                   	dec    %eax
  803222:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803234:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80323b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80323f:	75 17                	jne    803258 <insert_sorted_with_merge_freeList+0x183>
  803241:	83 ec 04             	sub    $0x4,%esp
  803244:	68 24 44 80 00       	push   $0x804424
  803249:	68 3f 01 00 00       	push   $0x13f
  80324e:	68 47 44 80 00       	push   $0x804447
  803253:	e8 43 d5 ff ff       	call   80079b <_panic>
  803258:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80325e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803261:	89 10                	mov    %edx,(%eax)
  803263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803266:	8b 00                	mov    (%eax),%eax
  803268:	85 c0                	test   %eax,%eax
  80326a:	74 0d                	je     803279 <insert_sorted_with_merge_freeList+0x1a4>
  80326c:	a1 48 51 80 00       	mov    0x805148,%eax
  803271:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803274:	89 50 04             	mov    %edx,0x4(%eax)
  803277:	eb 08                	jmp    803281 <insert_sorted_with_merge_freeList+0x1ac>
  803279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803284:	a3 48 51 80 00       	mov    %eax,0x805148
  803289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803293:	a1 54 51 80 00       	mov    0x805154,%eax
  803298:	40                   	inc    %eax
  803299:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80329e:	e9 7a 05 00 00       	jmp    80381d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	8b 50 08             	mov    0x8(%eax),%edx
  8032a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ac:	8b 40 08             	mov    0x8(%eax),%eax
  8032af:	39 c2                	cmp    %eax,%edx
  8032b1:	0f 82 14 01 00 00    	jb     8033cb <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8032b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ba:	8b 50 08             	mov    0x8(%eax),%edx
  8032bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c3:	01 c2                	add    %eax,%edx
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	8b 40 08             	mov    0x8(%eax),%eax
  8032cb:	39 c2                	cmp    %eax,%edx
  8032cd:	0f 85 90 00 00 00    	jne    803363 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8032d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8032df:	01 c2                	add    %eax,%edx
  8032e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e4:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ff:	75 17                	jne    803318 <insert_sorted_with_merge_freeList+0x243>
  803301:	83 ec 04             	sub    $0x4,%esp
  803304:	68 24 44 80 00       	push   $0x804424
  803309:	68 49 01 00 00       	push   $0x149
  80330e:	68 47 44 80 00       	push   $0x804447
  803313:	e8 83 d4 ff ff       	call   80079b <_panic>
  803318:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	89 10                	mov    %edx,(%eax)
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	8b 00                	mov    (%eax),%eax
  803328:	85 c0                	test   %eax,%eax
  80332a:	74 0d                	je     803339 <insert_sorted_with_merge_freeList+0x264>
  80332c:	a1 48 51 80 00       	mov    0x805148,%eax
  803331:	8b 55 08             	mov    0x8(%ebp),%edx
  803334:	89 50 04             	mov    %edx,0x4(%eax)
  803337:	eb 08                	jmp    803341 <insert_sorted_with_merge_freeList+0x26c>
  803339:	8b 45 08             	mov    0x8(%ebp),%eax
  80333c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	a3 48 51 80 00       	mov    %eax,0x805148
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803353:	a1 54 51 80 00       	mov    0x805154,%eax
  803358:	40                   	inc    %eax
  803359:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80335e:	e9 bb 04 00 00       	jmp    80381e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803363:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803367:	75 17                	jne    803380 <insert_sorted_with_merge_freeList+0x2ab>
  803369:	83 ec 04             	sub    $0x4,%esp
  80336c:	68 98 44 80 00       	push   $0x804498
  803371:	68 4c 01 00 00       	push   $0x14c
  803376:	68 47 44 80 00       	push   $0x804447
  80337b:	e8 1b d4 ff ff       	call   80079b <_panic>
  803380:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	89 50 04             	mov    %edx,0x4(%eax)
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	8b 40 04             	mov    0x4(%eax),%eax
  803392:	85 c0                	test   %eax,%eax
  803394:	74 0c                	je     8033a2 <insert_sorted_with_merge_freeList+0x2cd>
  803396:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80339b:	8b 55 08             	mov    0x8(%ebp),%edx
  80339e:	89 10                	mov    %edx,(%eax)
  8033a0:	eb 08                	jmp    8033aa <insert_sorted_with_merge_freeList+0x2d5>
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	a3 38 51 80 00       	mov    %eax,0x805138
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c0:	40                   	inc    %eax
  8033c1:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033c6:	e9 53 04 00 00       	jmp    80381e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8033d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d3:	e9 15 04 00 00       	jmp    8037ed <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033db:	8b 00                	mov    (%eax),%eax
  8033dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e3:	8b 50 08             	mov    0x8(%eax),%edx
  8033e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e9:	8b 40 08             	mov    0x8(%eax),%eax
  8033ec:	39 c2                	cmp    %eax,%edx
  8033ee:	0f 86 f1 03 00 00    	jbe    8037e5 <insert_sorted_with_merge_freeList+0x710>
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	8b 50 08             	mov    0x8(%eax),%edx
  8033fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fd:	8b 40 08             	mov    0x8(%eax),%eax
  803400:	39 c2                	cmp    %eax,%edx
  803402:	0f 83 dd 03 00 00    	jae    8037e5 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340b:	8b 50 08             	mov    0x8(%eax),%edx
  80340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803411:	8b 40 0c             	mov    0xc(%eax),%eax
  803414:	01 c2                	add    %eax,%edx
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	8b 40 08             	mov    0x8(%eax),%eax
  80341c:	39 c2                	cmp    %eax,%edx
  80341e:	0f 85 b9 01 00 00    	jne    8035dd <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803424:	8b 45 08             	mov    0x8(%ebp),%eax
  803427:	8b 50 08             	mov    0x8(%eax),%edx
  80342a:	8b 45 08             	mov    0x8(%ebp),%eax
  80342d:	8b 40 0c             	mov    0xc(%eax),%eax
  803430:	01 c2                	add    %eax,%edx
  803432:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803435:	8b 40 08             	mov    0x8(%eax),%eax
  803438:	39 c2                	cmp    %eax,%edx
  80343a:	0f 85 0d 01 00 00    	jne    80354d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803443:	8b 50 0c             	mov    0xc(%eax),%edx
  803446:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803449:	8b 40 0c             	mov    0xc(%eax),%eax
  80344c:	01 c2                	add    %eax,%edx
  80344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803451:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803454:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803458:	75 17                	jne    803471 <insert_sorted_with_merge_freeList+0x39c>
  80345a:	83 ec 04             	sub    $0x4,%esp
  80345d:	68 f0 44 80 00       	push   $0x8044f0
  803462:	68 5c 01 00 00       	push   $0x15c
  803467:	68 47 44 80 00       	push   $0x804447
  80346c:	e8 2a d3 ff ff       	call   80079b <_panic>
  803471:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803474:	8b 00                	mov    (%eax),%eax
  803476:	85 c0                	test   %eax,%eax
  803478:	74 10                	je     80348a <insert_sorted_with_merge_freeList+0x3b5>
  80347a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347d:	8b 00                	mov    (%eax),%eax
  80347f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803482:	8b 52 04             	mov    0x4(%edx),%edx
  803485:	89 50 04             	mov    %edx,0x4(%eax)
  803488:	eb 0b                	jmp    803495 <insert_sorted_with_merge_freeList+0x3c0>
  80348a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348d:	8b 40 04             	mov    0x4(%eax),%eax
  803490:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803495:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803498:	8b 40 04             	mov    0x4(%eax),%eax
  80349b:	85 c0                	test   %eax,%eax
  80349d:	74 0f                	je     8034ae <insert_sorted_with_merge_freeList+0x3d9>
  80349f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a2:	8b 40 04             	mov    0x4(%eax),%eax
  8034a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a8:	8b 12                	mov    (%edx),%edx
  8034aa:	89 10                	mov    %edx,(%eax)
  8034ac:	eb 0a                	jmp    8034b8 <insert_sorted_with_merge_freeList+0x3e3>
  8034ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b1:	8b 00                	mov    (%eax),%eax
  8034b3:	a3 38 51 80 00       	mov    %eax,0x805138
  8034b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8034d0:	48                   	dec    %eax
  8034d1:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8034d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8034e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034ee:	75 17                	jne    803507 <insert_sorted_with_merge_freeList+0x432>
  8034f0:	83 ec 04             	sub    $0x4,%esp
  8034f3:	68 24 44 80 00       	push   $0x804424
  8034f8:	68 5f 01 00 00       	push   $0x15f
  8034fd:	68 47 44 80 00       	push   $0x804447
  803502:	e8 94 d2 ff ff       	call   80079b <_panic>
  803507:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80350d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803510:	89 10                	mov    %edx,(%eax)
  803512:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803515:	8b 00                	mov    (%eax),%eax
  803517:	85 c0                	test   %eax,%eax
  803519:	74 0d                	je     803528 <insert_sorted_with_merge_freeList+0x453>
  80351b:	a1 48 51 80 00       	mov    0x805148,%eax
  803520:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803523:	89 50 04             	mov    %edx,0x4(%eax)
  803526:	eb 08                	jmp    803530 <insert_sorted_with_merge_freeList+0x45b>
  803528:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803530:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803533:	a3 48 51 80 00       	mov    %eax,0x805148
  803538:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803542:	a1 54 51 80 00       	mov    0x805154,%eax
  803547:	40                   	inc    %eax
  803548:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80354d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803550:	8b 50 0c             	mov    0xc(%eax),%edx
  803553:	8b 45 08             	mov    0x8(%ebp),%eax
  803556:	8b 40 0c             	mov    0xc(%eax),%eax
  803559:	01 c2                	add    %eax,%edx
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803561:	8b 45 08             	mov    0x8(%ebp),%eax
  803564:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80356b:	8b 45 08             	mov    0x8(%ebp),%eax
  80356e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803575:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803579:	75 17                	jne    803592 <insert_sorted_with_merge_freeList+0x4bd>
  80357b:	83 ec 04             	sub    $0x4,%esp
  80357e:	68 24 44 80 00       	push   $0x804424
  803583:	68 64 01 00 00       	push   $0x164
  803588:	68 47 44 80 00       	push   $0x804447
  80358d:	e8 09 d2 ff ff       	call   80079b <_panic>
  803592:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803598:	8b 45 08             	mov    0x8(%ebp),%eax
  80359b:	89 10                	mov    %edx,(%eax)
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	8b 00                	mov    (%eax),%eax
  8035a2:	85 c0                	test   %eax,%eax
  8035a4:	74 0d                	je     8035b3 <insert_sorted_with_merge_freeList+0x4de>
  8035a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8035ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ae:	89 50 04             	mov    %edx,0x4(%eax)
  8035b1:	eb 08                	jmp    8035bb <insert_sorted_with_merge_freeList+0x4e6>
  8035b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035be:	a3 48 51 80 00       	mov    %eax,0x805148
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035cd:	a1 54 51 80 00       	mov    0x805154,%eax
  8035d2:	40                   	inc    %eax
  8035d3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8035d8:	e9 41 02 00 00       	jmp    80381e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e0:	8b 50 08             	mov    0x8(%eax),%edx
  8035e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e9:	01 c2                	add    %eax,%edx
  8035eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ee:	8b 40 08             	mov    0x8(%eax),%eax
  8035f1:	39 c2                	cmp    %eax,%edx
  8035f3:	0f 85 7c 01 00 00    	jne    803775 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8035f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035fd:	74 06                	je     803605 <insert_sorted_with_merge_freeList+0x530>
  8035ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803603:	75 17                	jne    80361c <insert_sorted_with_merge_freeList+0x547>
  803605:	83 ec 04             	sub    $0x4,%esp
  803608:	68 60 44 80 00       	push   $0x804460
  80360d:	68 69 01 00 00       	push   $0x169
  803612:	68 47 44 80 00       	push   $0x804447
  803617:	e8 7f d1 ff ff       	call   80079b <_panic>
  80361c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361f:	8b 50 04             	mov    0x4(%eax),%edx
  803622:	8b 45 08             	mov    0x8(%ebp),%eax
  803625:	89 50 04             	mov    %edx,0x4(%eax)
  803628:	8b 45 08             	mov    0x8(%ebp),%eax
  80362b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80362e:	89 10                	mov    %edx,(%eax)
  803630:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803633:	8b 40 04             	mov    0x4(%eax),%eax
  803636:	85 c0                	test   %eax,%eax
  803638:	74 0d                	je     803647 <insert_sorted_with_merge_freeList+0x572>
  80363a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363d:	8b 40 04             	mov    0x4(%eax),%eax
  803640:	8b 55 08             	mov    0x8(%ebp),%edx
  803643:	89 10                	mov    %edx,(%eax)
  803645:	eb 08                	jmp    80364f <insert_sorted_with_merge_freeList+0x57a>
  803647:	8b 45 08             	mov    0x8(%ebp),%eax
  80364a:	a3 38 51 80 00       	mov    %eax,0x805138
  80364f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803652:	8b 55 08             	mov    0x8(%ebp),%edx
  803655:	89 50 04             	mov    %edx,0x4(%eax)
  803658:	a1 44 51 80 00       	mov    0x805144,%eax
  80365d:	40                   	inc    %eax
  80365e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803663:	8b 45 08             	mov    0x8(%ebp),%eax
  803666:	8b 50 0c             	mov    0xc(%eax),%edx
  803669:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366c:	8b 40 0c             	mov    0xc(%eax),%eax
  80366f:	01 c2                	add    %eax,%edx
  803671:	8b 45 08             	mov    0x8(%ebp),%eax
  803674:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803677:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80367b:	75 17                	jne    803694 <insert_sorted_with_merge_freeList+0x5bf>
  80367d:	83 ec 04             	sub    $0x4,%esp
  803680:	68 f0 44 80 00       	push   $0x8044f0
  803685:	68 6b 01 00 00       	push   $0x16b
  80368a:	68 47 44 80 00       	push   $0x804447
  80368f:	e8 07 d1 ff ff       	call   80079b <_panic>
  803694:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803697:	8b 00                	mov    (%eax),%eax
  803699:	85 c0                	test   %eax,%eax
  80369b:	74 10                	je     8036ad <insert_sorted_with_merge_freeList+0x5d8>
  80369d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a0:	8b 00                	mov    (%eax),%eax
  8036a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036a5:	8b 52 04             	mov    0x4(%edx),%edx
  8036a8:	89 50 04             	mov    %edx,0x4(%eax)
  8036ab:	eb 0b                	jmp    8036b8 <insert_sorted_with_merge_freeList+0x5e3>
  8036ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b0:	8b 40 04             	mov    0x4(%eax),%eax
  8036b3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bb:	8b 40 04             	mov    0x4(%eax),%eax
  8036be:	85 c0                	test   %eax,%eax
  8036c0:	74 0f                	je     8036d1 <insert_sorted_with_merge_freeList+0x5fc>
  8036c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c5:	8b 40 04             	mov    0x4(%eax),%eax
  8036c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036cb:	8b 12                	mov    (%edx),%edx
  8036cd:	89 10                	mov    %edx,(%eax)
  8036cf:	eb 0a                	jmp    8036db <insert_sorted_with_merge_freeList+0x606>
  8036d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d4:	8b 00                	mov    (%eax),%eax
  8036d6:	a3 38 51 80 00       	mov    %eax,0x805138
  8036db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8036f3:	48                   	dec    %eax
  8036f4:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8036f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803703:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803706:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80370d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803711:	75 17                	jne    80372a <insert_sorted_with_merge_freeList+0x655>
  803713:	83 ec 04             	sub    $0x4,%esp
  803716:	68 24 44 80 00       	push   $0x804424
  80371b:	68 6e 01 00 00       	push   $0x16e
  803720:	68 47 44 80 00       	push   $0x804447
  803725:	e8 71 d0 ff ff       	call   80079b <_panic>
  80372a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803730:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803733:	89 10                	mov    %edx,(%eax)
  803735:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803738:	8b 00                	mov    (%eax),%eax
  80373a:	85 c0                	test   %eax,%eax
  80373c:	74 0d                	je     80374b <insert_sorted_with_merge_freeList+0x676>
  80373e:	a1 48 51 80 00       	mov    0x805148,%eax
  803743:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803746:	89 50 04             	mov    %edx,0x4(%eax)
  803749:	eb 08                	jmp    803753 <insert_sorted_with_merge_freeList+0x67e>
  80374b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803753:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803756:	a3 48 51 80 00       	mov    %eax,0x805148
  80375b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803765:	a1 54 51 80 00       	mov    0x805154,%eax
  80376a:	40                   	inc    %eax
  80376b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803770:	e9 a9 00 00 00       	jmp    80381e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803775:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803779:	74 06                	je     803781 <insert_sorted_with_merge_freeList+0x6ac>
  80377b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80377f:	75 17                	jne    803798 <insert_sorted_with_merge_freeList+0x6c3>
  803781:	83 ec 04             	sub    $0x4,%esp
  803784:	68 bc 44 80 00       	push   $0x8044bc
  803789:	68 73 01 00 00       	push   $0x173
  80378e:	68 47 44 80 00       	push   $0x804447
  803793:	e8 03 d0 ff ff       	call   80079b <_panic>
  803798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379b:	8b 10                	mov    (%eax),%edx
  80379d:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a0:	89 10                	mov    %edx,(%eax)
  8037a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a5:	8b 00                	mov    (%eax),%eax
  8037a7:	85 c0                	test   %eax,%eax
  8037a9:	74 0b                	je     8037b6 <insert_sorted_with_merge_freeList+0x6e1>
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	8b 00                	mov    (%eax),%eax
  8037b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8037b3:	89 50 04             	mov    %edx,0x4(%eax)
  8037b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8037bc:	89 10                	mov    %edx,(%eax)
  8037be:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037c4:	89 50 04             	mov    %edx,0x4(%eax)
  8037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ca:	8b 00                	mov    (%eax),%eax
  8037cc:	85 c0                	test   %eax,%eax
  8037ce:	75 08                	jne    8037d8 <insert_sorted_with_merge_freeList+0x703>
  8037d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037d8:	a1 44 51 80 00       	mov    0x805144,%eax
  8037dd:	40                   	inc    %eax
  8037de:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8037e3:	eb 39                	jmp    80381e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8037e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8037ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f1:	74 07                	je     8037fa <insert_sorted_with_merge_freeList+0x725>
  8037f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f6:	8b 00                	mov    (%eax),%eax
  8037f8:	eb 05                	jmp    8037ff <insert_sorted_with_merge_freeList+0x72a>
  8037fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ff:	a3 40 51 80 00       	mov    %eax,0x805140
  803804:	a1 40 51 80 00       	mov    0x805140,%eax
  803809:	85 c0                	test   %eax,%eax
  80380b:	0f 85 c7 fb ff ff    	jne    8033d8 <insert_sorted_with_merge_freeList+0x303>
  803811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803815:	0f 85 bd fb ff ff    	jne    8033d8 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80381b:	eb 01                	jmp    80381e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80381d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80381e:	90                   	nop
  80381f:	c9                   	leave  
  803820:	c3                   	ret    
  803821:	66 90                	xchg   %ax,%ax
  803823:	90                   	nop

00803824 <__udivdi3>:
  803824:	55                   	push   %ebp
  803825:	57                   	push   %edi
  803826:	56                   	push   %esi
  803827:	53                   	push   %ebx
  803828:	83 ec 1c             	sub    $0x1c,%esp
  80382b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80382f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803833:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803837:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80383b:	89 ca                	mov    %ecx,%edx
  80383d:	89 f8                	mov    %edi,%eax
  80383f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803843:	85 f6                	test   %esi,%esi
  803845:	75 2d                	jne    803874 <__udivdi3+0x50>
  803847:	39 cf                	cmp    %ecx,%edi
  803849:	77 65                	ja     8038b0 <__udivdi3+0x8c>
  80384b:	89 fd                	mov    %edi,%ebp
  80384d:	85 ff                	test   %edi,%edi
  80384f:	75 0b                	jne    80385c <__udivdi3+0x38>
  803851:	b8 01 00 00 00       	mov    $0x1,%eax
  803856:	31 d2                	xor    %edx,%edx
  803858:	f7 f7                	div    %edi
  80385a:	89 c5                	mov    %eax,%ebp
  80385c:	31 d2                	xor    %edx,%edx
  80385e:	89 c8                	mov    %ecx,%eax
  803860:	f7 f5                	div    %ebp
  803862:	89 c1                	mov    %eax,%ecx
  803864:	89 d8                	mov    %ebx,%eax
  803866:	f7 f5                	div    %ebp
  803868:	89 cf                	mov    %ecx,%edi
  80386a:	89 fa                	mov    %edi,%edx
  80386c:	83 c4 1c             	add    $0x1c,%esp
  80386f:	5b                   	pop    %ebx
  803870:	5e                   	pop    %esi
  803871:	5f                   	pop    %edi
  803872:	5d                   	pop    %ebp
  803873:	c3                   	ret    
  803874:	39 ce                	cmp    %ecx,%esi
  803876:	77 28                	ja     8038a0 <__udivdi3+0x7c>
  803878:	0f bd fe             	bsr    %esi,%edi
  80387b:	83 f7 1f             	xor    $0x1f,%edi
  80387e:	75 40                	jne    8038c0 <__udivdi3+0x9c>
  803880:	39 ce                	cmp    %ecx,%esi
  803882:	72 0a                	jb     80388e <__udivdi3+0x6a>
  803884:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803888:	0f 87 9e 00 00 00    	ja     80392c <__udivdi3+0x108>
  80388e:	b8 01 00 00 00       	mov    $0x1,%eax
  803893:	89 fa                	mov    %edi,%edx
  803895:	83 c4 1c             	add    $0x1c,%esp
  803898:	5b                   	pop    %ebx
  803899:	5e                   	pop    %esi
  80389a:	5f                   	pop    %edi
  80389b:	5d                   	pop    %ebp
  80389c:	c3                   	ret    
  80389d:	8d 76 00             	lea    0x0(%esi),%esi
  8038a0:	31 ff                	xor    %edi,%edi
  8038a2:	31 c0                	xor    %eax,%eax
  8038a4:	89 fa                	mov    %edi,%edx
  8038a6:	83 c4 1c             	add    $0x1c,%esp
  8038a9:	5b                   	pop    %ebx
  8038aa:	5e                   	pop    %esi
  8038ab:	5f                   	pop    %edi
  8038ac:	5d                   	pop    %ebp
  8038ad:	c3                   	ret    
  8038ae:	66 90                	xchg   %ax,%ax
  8038b0:	89 d8                	mov    %ebx,%eax
  8038b2:	f7 f7                	div    %edi
  8038b4:	31 ff                	xor    %edi,%edi
  8038b6:	89 fa                	mov    %edi,%edx
  8038b8:	83 c4 1c             	add    $0x1c,%esp
  8038bb:	5b                   	pop    %ebx
  8038bc:	5e                   	pop    %esi
  8038bd:	5f                   	pop    %edi
  8038be:	5d                   	pop    %ebp
  8038bf:	c3                   	ret    
  8038c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038c5:	89 eb                	mov    %ebp,%ebx
  8038c7:	29 fb                	sub    %edi,%ebx
  8038c9:	89 f9                	mov    %edi,%ecx
  8038cb:	d3 e6                	shl    %cl,%esi
  8038cd:	89 c5                	mov    %eax,%ebp
  8038cf:	88 d9                	mov    %bl,%cl
  8038d1:	d3 ed                	shr    %cl,%ebp
  8038d3:	89 e9                	mov    %ebp,%ecx
  8038d5:	09 f1                	or     %esi,%ecx
  8038d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038db:	89 f9                	mov    %edi,%ecx
  8038dd:	d3 e0                	shl    %cl,%eax
  8038df:	89 c5                	mov    %eax,%ebp
  8038e1:	89 d6                	mov    %edx,%esi
  8038e3:	88 d9                	mov    %bl,%cl
  8038e5:	d3 ee                	shr    %cl,%esi
  8038e7:	89 f9                	mov    %edi,%ecx
  8038e9:	d3 e2                	shl    %cl,%edx
  8038eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ef:	88 d9                	mov    %bl,%cl
  8038f1:	d3 e8                	shr    %cl,%eax
  8038f3:	09 c2                	or     %eax,%edx
  8038f5:	89 d0                	mov    %edx,%eax
  8038f7:	89 f2                	mov    %esi,%edx
  8038f9:	f7 74 24 0c          	divl   0xc(%esp)
  8038fd:	89 d6                	mov    %edx,%esi
  8038ff:	89 c3                	mov    %eax,%ebx
  803901:	f7 e5                	mul    %ebp
  803903:	39 d6                	cmp    %edx,%esi
  803905:	72 19                	jb     803920 <__udivdi3+0xfc>
  803907:	74 0b                	je     803914 <__udivdi3+0xf0>
  803909:	89 d8                	mov    %ebx,%eax
  80390b:	31 ff                	xor    %edi,%edi
  80390d:	e9 58 ff ff ff       	jmp    80386a <__udivdi3+0x46>
  803912:	66 90                	xchg   %ax,%ax
  803914:	8b 54 24 08          	mov    0x8(%esp),%edx
  803918:	89 f9                	mov    %edi,%ecx
  80391a:	d3 e2                	shl    %cl,%edx
  80391c:	39 c2                	cmp    %eax,%edx
  80391e:	73 e9                	jae    803909 <__udivdi3+0xe5>
  803920:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803923:	31 ff                	xor    %edi,%edi
  803925:	e9 40 ff ff ff       	jmp    80386a <__udivdi3+0x46>
  80392a:	66 90                	xchg   %ax,%ax
  80392c:	31 c0                	xor    %eax,%eax
  80392e:	e9 37 ff ff ff       	jmp    80386a <__udivdi3+0x46>
  803933:	90                   	nop

00803934 <__umoddi3>:
  803934:	55                   	push   %ebp
  803935:	57                   	push   %edi
  803936:	56                   	push   %esi
  803937:	53                   	push   %ebx
  803938:	83 ec 1c             	sub    $0x1c,%esp
  80393b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80393f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803943:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803947:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80394b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80394f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803953:	89 f3                	mov    %esi,%ebx
  803955:	89 fa                	mov    %edi,%edx
  803957:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80395b:	89 34 24             	mov    %esi,(%esp)
  80395e:	85 c0                	test   %eax,%eax
  803960:	75 1a                	jne    80397c <__umoddi3+0x48>
  803962:	39 f7                	cmp    %esi,%edi
  803964:	0f 86 a2 00 00 00    	jbe    803a0c <__umoddi3+0xd8>
  80396a:	89 c8                	mov    %ecx,%eax
  80396c:	89 f2                	mov    %esi,%edx
  80396e:	f7 f7                	div    %edi
  803970:	89 d0                	mov    %edx,%eax
  803972:	31 d2                	xor    %edx,%edx
  803974:	83 c4 1c             	add    $0x1c,%esp
  803977:	5b                   	pop    %ebx
  803978:	5e                   	pop    %esi
  803979:	5f                   	pop    %edi
  80397a:	5d                   	pop    %ebp
  80397b:	c3                   	ret    
  80397c:	39 f0                	cmp    %esi,%eax
  80397e:	0f 87 ac 00 00 00    	ja     803a30 <__umoddi3+0xfc>
  803984:	0f bd e8             	bsr    %eax,%ebp
  803987:	83 f5 1f             	xor    $0x1f,%ebp
  80398a:	0f 84 ac 00 00 00    	je     803a3c <__umoddi3+0x108>
  803990:	bf 20 00 00 00       	mov    $0x20,%edi
  803995:	29 ef                	sub    %ebp,%edi
  803997:	89 fe                	mov    %edi,%esi
  803999:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80399d:	89 e9                	mov    %ebp,%ecx
  80399f:	d3 e0                	shl    %cl,%eax
  8039a1:	89 d7                	mov    %edx,%edi
  8039a3:	89 f1                	mov    %esi,%ecx
  8039a5:	d3 ef                	shr    %cl,%edi
  8039a7:	09 c7                	or     %eax,%edi
  8039a9:	89 e9                	mov    %ebp,%ecx
  8039ab:	d3 e2                	shl    %cl,%edx
  8039ad:	89 14 24             	mov    %edx,(%esp)
  8039b0:	89 d8                	mov    %ebx,%eax
  8039b2:	d3 e0                	shl    %cl,%eax
  8039b4:	89 c2                	mov    %eax,%edx
  8039b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ba:	d3 e0                	shl    %cl,%eax
  8039bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039c4:	89 f1                	mov    %esi,%ecx
  8039c6:	d3 e8                	shr    %cl,%eax
  8039c8:	09 d0                	or     %edx,%eax
  8039ca:	d3 eb                	shr    %cl,%ebx
  8039cc:	89 da                	mov    %ebx,%edx
  8039ce:	f7 f7                	div    %edi
  8039d0:	89 d3                	mov    %edx,%ebx
  8039d2:	f7 24 24             	mull   (%esp)
  8039d5:	89 c6                	mov    %eax,%esi
  8039d7:	89 d1                	mov    %edx,%ecx
  8039d9:	39 d3                	cmp    %edx,%ebx
  8039db:	0f 82 87 00 00 00    	jb     803a68 <__umoddi3+0x134>
  8039e1:	0f 84 91 00 00 00    	je     803a78 <__umoddi3+0x144>
  8039e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039eb:	29 f2                	sub    %esi,%edx
  8039ed:	19 cb                	sbb    %ecx,%ebx
  8039ef:	89 d8                	mov    %ebx,%eax
  8039f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039f5:	d3 e0                	shl    %cl,%eax
  8039f7:	89 e9                	mov    %ebp,%ecx
  8039f9:	d3 ea                	shr    %cl,%edx
  8039fb:	09 d0                	or     %edx,%eax
  8039fd:	89 e9                	mov    %ebp,%ecx
  8039ff:	d3 eb                	shr    %cl,%ebx
  803a01:	89 da                	mov    %ebx,%edx
  803a03:	83 c4 1c             	add    $0x1c,%esp
  803a06:	5b                   	pop    %ebx
  803a07:	5e                   	pop    %esi
  803a08:	5f                   	pop    %edi
  803a09:	5d                   	pop    %ebp
  803a0a:	c3                   	ret    
  803a0b:	90                   	nop
  803a0c:	89 fd                	mov    %edi,%ebp
  803a0e:	85 ff                	test   %edi,%edi
  803a10:	75 0b                	jne    803a1d <__umoddi3+0xe9>
  803a12:	b8 01 00 00 00       	mov    $0x1,%eax
  803a17:	31 d2                	xor    %edx,%edx
  803a19:	f7 f7                	div    %edi
  803a1b:	89 c5                	mov    %eax,%ebp
  803a1d:	89 f0                	mov    %esi,%eax
  803a1f:	31 d2                	xor    %edx,%edx
  803a21:	f7 f5                	div    %ebp
  803a23:	89 c8                	mov    %ecx,%eax
  803a25:	f7 f5                	div    %ebp
  803a27:	89 d0                	mov    %edx,%eax
  803a29:	e9 44 ff ff ff       	jmp    803972 <__umoddi3+0x3e>
  803a2e:	66 90                	xchg   %ax,%ax
  803a30:	89 c8                	mov    %ecx,%eax
  803a32:	89 f2                	mov    %esi,%edx
  803a34:	83 c4 1c             	add    $0x1c,%esp
  803a37:	5b                   	pop    %ebx
  803a38:	5e                   	pop    %esi
  803a39:	5f                   	pop    %edi
  803a3a:	5d                   	pop    %ebp
  803a3b:	c3                   	ret    
  803a3c:	3b 04 24             	cmp    (%esp),%eax
  803a3f:	72 06                	jb     803a47 <__umoddi3+0x113>
  803a41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a45:	77 0f                	ja     803a56 <__umoddi3+0x122>
  803a47:	89 f2                	mov    %esi,%edx
  803a49:	29 f9                	sub    %edi,%ecx
  803a4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a4f:	89 14 24             	mov    %edx,(%esp)
  803a52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a56:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a5a:	8b 14 24             	mov    (%esp),%edx
  803a5d:	83 c4 1c             	add    $0x1c,%esp
  803a60:	5b                   	pop    %ebx
  803a61:	5e                   	pop    %esi
  803a62:	5f                   	pop    %edi
  803a63:	5d                   	pop    %ebp
  803a64:	c3                   	ret    
  803a65:	8d 76 00             	lea    0x0(%esi),%esi
  803a68:	2b 04 24             	sub    (%esp),%eax
  803a6b:	19 fa                	sbb    %edi,%edx
  803a6d:	89 d1                	mov    %edx,%ecx
  803a6f:	89 c6                	mov    %eax,%esi
  803a71:	e9 71 ff ff ff       	jmp    8039e7 <__umoddi3+0xb3>
  803a76:	66 90                	xchg   %ax,%ax
  803a78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a7c:	72 ea                	jb     803a68 <__umoddi3+0x134>
  803a7e:	89 d9                	mov    %ebx,%ecx
  803a80:	e9 62 ff ff ff       	jmp    8039e7 <__umoddi3+0xb3>
