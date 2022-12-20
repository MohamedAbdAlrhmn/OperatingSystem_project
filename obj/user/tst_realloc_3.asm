
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
  800062:	68 20 3c 80 00       	push   $0x803c20
  800067:	e8 e3 09 00 00       	call   800a4f <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 80 1d 00 00       	call   801df4 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 18 1e 00 00       	call   801e94 <sys_pf_calculate_allocated_pages>
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
  8000ab:	68 44 3c 80 00       	push   $0x803c44
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 74 3c 80 00       	push   $0x803c74
  8000b7:	e8 df 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 30 1d 00 00       	call   801df4 <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 8c 3c 80 00       	push   $0x803c8c
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 74 3c 80 00       	push   $0x803c74
  8000dc:	e8 ba 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 ae 1d 00 00       	call   801e94 <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 f8 3c 80 00       	push   $0x803cf8
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 74 3c 80 00       	push   $0x803c74
  8000fd:	e8 99 06 00 00       	call   80079b <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 ed 1c 00 00       	call   801df4 <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 85 1d 00 00       	call   801e94 <sys_pf_calculate_allocated_pages>
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
  800156:	68 44 3c 80 00       	push   $0x803c44
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 74 3c 80 00       	push   $0x803c74
  800162:	e8 34 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 88 1c 00 00       	call   801df4 <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 8c 3c 80 00       	push   $0x803c8c
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 74 3c 80 00       	push   $0x803c74
  800184:	e8 12 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 06 1d 00 00       	call   801e94 <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 f8 3c 80 00       	push   $0x803cf8
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 74 3c 80 00       	push   $0x803c74
  8001a5:	e8 f1 05 00 00       	call   80079b <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 45 1c 00 00       	call   801df4 <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 dd 1c 00 00       	call   801e94 <sys_pf_calculate_allocated_pages>
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
  800201:	68 44 3c 80 00       	push   $0x803c44
  800206:	6a 23                	push   $0x23
  800208:	68 74 3c 80 00       	push   $0x803c74
  80020d:	e8 89 05 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 dd 1b 00 00       	call   801df4 <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 8c 3c 80 00       	push   $0x803c8c
  800228:	6a 25                	push   $0x25
  80022a:	68 74 3c 80 00       	push   $0x803c74
  80022f:	e8 67 05 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 5b 1c 00 00       	call   801e94 <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 f8 3c 80 00       	push   $0x803cf8
  800249:	6a 26                	push   $0x26
  80024b:	68 74 3c 80 00       	push   $0x803c74
  800250:	e8 46 05 00 00       	call   80079b <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 9a 1b 00 00       	call   801df4 <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 32 1c 00 00       	call   801e94 <sys_pf_calculate_allocated_pages>
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
  8002a8:	68 44 3c 80 00       	push   $0x803c44
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 74 3c 80 00       	push   $0x803c74
  8002b4:	e8 e2 04 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 36 1b 00 00       	call   801df4 <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 8c 3c 80 00       	push   $0x803c8c
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 74 3c 80 00       	push   $0x803c74
  8002d6:	e8 c0 04 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 b4 1b 00 00       	call   801e94 <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 f8 3c 80 00       	push   $0x803cf8
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 74 3c 80 00       	push   $0x803c74
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
  800422:	e8 cd 19 00 00       	call   801df4 <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 65 1a 00 00       	call   801e94 <sys_pf_calculate_allocated_pages>
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
  800450:	e8 1d 18 00 00       	call   801c72 <realloc>
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
  800478:	68 28 3d 80 00       	push   $0x803d28
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 74 3c 80 00       	push   $0x803c74
  800484:	e8 12 03 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 06 1a 00 00       	call   801e94 <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 5c 3d 80 00       	push   $0x803d5c
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 74 3c 80 00       	push   $0x803c74
  8004a5:	e8 f1 02 00 00       	call   80079b <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 8d 3d 80 00       	push   $0x803d8d
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
  800501:	68 94 3d 80 00       	push   $0x803d94
  800506:	6a 7a                	push   $0x7a
  800508:	68 74 3c 80 00       	push   $0x803c74
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
  800559:	68 94 3d 80 00       	push   $0x803d94
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 74 3c 80 00       	push   $0x803c74
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
  8005bb:	68 94 3d 80 00       	push   $0x803d94
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 74 3c 80 00       	push   $0x803c74
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
  800616:	68 94 3d 80 00       	push   $0x803d94
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 74 3c 80 00       	push   $0x803c74
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
  80063a:	68 cc 3d 80 00       	push   $0x803dcc
  80063f:	e8 a0 03 00 00       	call   8009e4 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 d8 3d 80 00       	push   $0x803dd8
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
  800665:	e8 6a 1a 00 00       	call   8020d4 <sys_getenvindex>
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
  8006d0:	e8 0c 18 00 00       	call   801ee1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	68 2c 3e 80 00       	push   $0x803e2c
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
  800700:	68 54 3e 80 00       	push   $0x803e54
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
  800731:	68 7c 3e 80 00       	push   $0x803e7c
  800736:	e8 14 03 00 00       	call   800a4f <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073e:	a1 20 50 80 00       	mov    0x805020,%eax
  800743:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	50                   	push   %eax
  80074d:	68 d4 3e 80 00       	push   $0x803ed4
  800752:	e8 f8 02 00 00       	call   800a4f <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	68 2c 3e 80 00       	push   $0x803e2c
  800762:	e8 e8 02 00 00       	call   800a4f <cprintf>
  800767:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80076a:	e8 8c 17 00 00       	call   801efb <sys_enable_interrupt>

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
  800782:	e8 19 19 00 00       	call   8020a0 <sys_destroy_env>
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
  800793:	e8 6e 19 00 00       	call   802106 <sys_exit_env>
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
  8007bc:	68 e8 3e 80 00       	push   $0x803ee8
  8007c1:	e8 89 02 00 00       	call   800a4f <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c9:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	68 ed 3e 80 00       	push   $0x803eed
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
  8007f9:	68 09 3f 80 00       	push   $0x803f09
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
  800825:	68 0c 3f 80 00       	push   $0x803f0c
  80082a:	6a 26                	push   $0x26
  80082c:	68 58 3f 80 00       	push   $0x803f58
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
  8008f7:	68 64 3f 80 00       	push   $0x803f64
  8008fc:	6a 3a                	push   $0x3a
  8008fe:	68 58 3f 80 00       	push   $0x803f58
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
  800967:	68 b8 3f 80 00       	push   $0x803fb8
  80096c:	6a 44                	push   $0x44
  80096e:	68 58 3f 80 00       	push   $0x803f58
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
  8009c1:	e8 6d 13 00 00       	call   801d33 <sys_cputs>
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
  800a38:	e8 f6 12 00 00       	call   801d33 <sys_cputs>
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
  800a82:	e8 5a 14 00 00       	call   801ee1 <sys_disable_interrupt>
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
  800aa2:	e8 54 14 00 00       	call   801efb <sys_enable_interrupt>
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
  800aec:	e8 c7 2e 00 00       	call   8039b8 <__udivdi3>
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
  800b3c:	e8 87 2f 00 00       	call   803ac8 <__umoddi3>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	05 34 42 80 00       	add    $0x804234,%eax
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
  800c97:	8b 04 85 58 42 80 00 	mov    0x804258(,%eax,4),%eax
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
  800d78:	8b 34 9d a0 40 80 00 	mov    0x8040a0(,%ebx,4),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 19                	jne    800d9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d83:	53                   	push   %ebx
  800d84:	68 45 42 80 00       	push   $0x804245
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
  800d9d:	68 4e 42 80 00       	push   $0x80424e
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
  800dca:	be 51 42 80 00       	mov    $0x804251,%esi
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
  8017f0:	68 b0 43 80 00       	push   $0x8043b0
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
  8018c0:	e8 b2 05 00 00       	call   801e77 <sys_allocate_chunk>
  8018c5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018c8:	a1 20 51 80 00       	mov    0x805120,%eax
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	50                   	push   %eax
  8018d1:	e8 27 0c 00 00       	call   8024fd <initialize_MemBlocksList>
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
  8018fe:	68 d5 43 80 00       	push   $0x8043d5
  801903:	6a 33                	push   $0x33
  801905:	68 f3 43 80 00       	push   $0x8043f3
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
  80197d:	68 00 44 80 00       	push   $0x804400
  801982:	6a 34                	push   $0x34
  801984:	68 f3 43 80 00       	push   $0x8043f3
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
  801a15:	e8 2b 08 00 00       	call   802245 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	74 11                	je     801a2f <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	ff 75 e8             	pushl  -0x18(%ebp)
  801a24:	e8 96 0e 00 00       	call   8028bf <alloc_block_FF>
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
  801a3b:	e8 f2 0b 00 00       	call   802632 <insert_sorted_allocList>
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
  801a55:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	83 ec 08             	sub    $0x8,%esp
  801a5e:	50                   	push   %eax
  801a5f:	68 40 50 80 00       	push   $0x805040
  801a64:	e8 71 0b 00 00       	call   8025da <find_block>
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801a6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a73:	0f 84 a6 00 00 00    	je     801b1f <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7c:	8b 50 0c             	mov    0xc(%eax),%edx
  801a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a82:	8b 40 08             	mov    0x8(%eax),%eax
  801a85:	83 ec 08             	sub    $0x8,%esp
  801a88:	52                   	push   %edx
  801a89:	50                   	push   %eax
  801a8a:	e8 b0 03 00 00       	call   801e3f <sys_free_user_mem>
  801a8f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801a92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a96:	75 14                	jne    801aac <free+0x5a>
  801a98:	83 ec 04             	sub    $0x4,%esp
  801a9b:	68 d5 43 80 00       	push   $0x8043d5
  801aa0:	6a 74                	push   $0x74
  801aa2:	68 f3 43 80 00       	push   $0x8043f3
  801aa7:	e8 ef ec ff ff       	call   80079b <_panic>
  801aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaf:	8b 00                	mov    (%eax),%eax
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	74 10                	je     801ac5 <free+0x73>
  801ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab8:	8b 00                	mov    (%eax),%eax
  801aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801abd:	8b 52 04             	mov    0x4(%edx),%edx
  801ac0:	89 50 04             	mov    %edx,0x4(%eax)
  801ac3:	eb 0b                	jmp    801ad0 <free+0x7e>
  801ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac8:	8b 40 04             	mov    0x4(%eax),%eax
  801acb:	a3 44 50 80 00       	mov    %eax,0x805044
  801ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad3:	8b 40 04             	mov    0x4(%eax),%eax
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	74 0f                	je     801ae9 <free+0x97>
  801ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801add:	8b 40 04             	mov    0x4(%eax),%eax
  801ae0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae3:	8b 12                	mov    (%edx),%edx
  801ae5:	89 10                	mov    %edx,(%eax)
  801ae7:	eb 0a                	jmp    801af3 <free+0xa1>
  801ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aec:	8b 00                	mov    (%eax),%eax
  801aee:	a3 40 50 80 00       	mov    %eax,0x805040
  801af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b06:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801b0b:	48                   	dec    %eax
  801b0c:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801b11:	83 ec 0c             	sub    $0xc,%esp
  801b14:	ff 75 f4             	pushl  -0xc(%ebp)
  801b17:	e8 4e 17 00 00       	call   80326a <insert_sorted_with_merge_freeList>
  801b1c:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801b1f:	90                   	nop
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	83 ec 38             	sub    $0x38,%esp
  801b28:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b2e:	e8 a6 fc ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b37:	75 0a                	jne    801b43 <smalloc+0x21>
  801b39:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3e:	e9 8b 00 00 00       	jmp    801bce <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801b43:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b50:	01 d0                	add    %edx,%eax
  801b52:	48                   	dec    %eax
  801b53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b59:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5e:	f7 75 f0             	divl   -0x10(%ebp)
  801b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b64:	29 d0                	sub    %edx,%eax
  801b66:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801b69:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b70:	e8 d0 06 00 00       	call   802245 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b75:	85 c0                	test   %eax,%eax
  801b77:	74 11                	je     801b8a <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801b79:	83 ec 0c             	sub    $0xc,%esp
  801b7c:	ff 75 e8             	pushl  -0x18(%ebp)
  801b7f:	e8 3b 0d 00 00       	call   8028bf <alloc_block_FF>
  801b84:	83 c4 10             	add    $0x10,%esp
  801b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b8e:	74 39                	je     801bc9 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b93:	8b 40 08             	mov    0x8(%eax),%eax
  801b96:	89 c2                	mov    %eax,%edx
  801b98:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b9c:	52                   	push   %edx
  801b9d:	50                   	push   %eax
  801b9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ba1:	ff 75 08             	pushl  0x8(%ebp)
  801ba4:	e8 21 04 00 00       	call   801fca <sys_createSharedObject>
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801baf:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801bb3:	74 14                	je     801bc9 <smalloc+0xa7>
  801bb5:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801bb9:	74 0e                	je     801bc9 <smalloc+0xa7>
  801bbb:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801bbf:	74 08                	je     801bc9 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc4:	8b 40 08             	mov    0x8(%eax),%eax
  801bc7:	eb 05                	jmp    801bce <smalloc+0xac>
	}
	return NULL;
  801bc9:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bd6:	e8 fe fb ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801bdb:	83 ec 08             	sub    $0x8,%esp
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	ff 75 08             	pushl  0x8(%ebp)
  801be4:	e8 0b 04 00 00       	call   801ff4 <sys_getSizeOfSharedObject>
  801be9:	83 c4 10             	add    $0x10,%esp
  801bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801bef:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801bf3:	74 76                	je     801c6b <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801bf5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801bfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c02:	01 d0                	add    %edx,%eax
  801c04:	48                   	dec    %eax
  801c05:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c10:	f7 75 ec             	divl   -0x14(%ebp)
  801c13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c16:	29 d0                	sub    %edx,%eax
  801c18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801c1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c22:	e8 1e 06 00 00       	call   802245 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c27:	85 c0                	test   %eax,%eax
  801c29:	74 11                	je     801c3c <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801c2b:	83 ec 0c             	sub    $0xc,%esp
  801c2e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c31:	e8 89 0c 00 00       	call   8028bf <alloc_block_FF>
  801c36:	83 c4 10             	add    $0x10,%esp
  801c39:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801c3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c40:	74 29                	je     801c6b <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c45:	8b 40 08             	mov    0x8(%eax),%eax
  801c48:	83 ec 04             	sub    $0x4,%esp
  801c4b:	50                   	push   %eax
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	ff 75 08             	pushl  0x8(%ebp)
  801c52:	e8 ba 03 00 00       	call   802011 <sys_getSharedObject>
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801c5d:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801c61:	74 08                	je     801c6b <sget+0x9b>
				return (void *)mem_block->sva;
  801c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c66:	8b 40 08             	mov    0x8(%eax),%eax
  801c69:	eb 05                	jmp    801c70 <sget+0xa0>
		}
	}
	return NULL;
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c78:	e8 5c fb ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	68 24 44 80 00       	push   $0x804424
  801c85:	68 f7 00 00 00       	push   $0xf7
  801c8a:	68 f3 43 80 00       	push   $0x8043f3
  801c8f:	e8 07 eb ff ff       	call   80079b <_panic>

00801c94 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c9a:	83 ec 04             	sub    $0x4,%esp
  801c9d:	68 4c 44 80 00       	push   $0x80444c
  801ca2:	68 0c 01 00 00       	push   $0x10c
  801ca7:	68 f3 43 80 00       	push   $0x8043f3
  801cac:	e8 ea ea ff ff       	call   80079b <_panic>

00801cb1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cb7:	83 ec 04             	sub    $0x4,%esp
  801cba:	68 70 44 80 00       	push   $0x804470
  801cbf:	68 44 01 00 00       	push   $0x144
  801cc4:	68 f3 43 80 00       	push   $0x8043f3
  801cc9:	e8 cd ea ff ff       	call   80079b <_panic>

00801cce <shrink>:

}
void shrink(uint32 newSize)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cd4:	83 ec 04             	sub    $0x4,%esp
  801cd7:	68 70 44 80 00       	push   $0x804470
  801cdc:	68 49 01 00 00       	push   $0x149
  801ce1:	68 f3 43 80 00       	push   $0x8043f3
  801ce6:	e8 b0 ea ff ff       	call   80079b <_panic>

00801ceb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cf1:	83 ec 04             	sub    $0x4,%esp
  801cf4:	68 70 44 80 00       	push   $0x804470
  801cf9:	68 4e 01 00 00       	push   $0x14e
  801cfe:	68 f3 43 80 00       	push   $0x8043f3
  801d03:	e8 93 ea ff ff       	call   80079b <_panic>

00801d08 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	57                   	push   %edi
  801d0c:	56                   	push   %esi
  801d0d:	53                   	push   %ebx
  801d0e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d17:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d1a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d1d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d20:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d23:	cd 30                	int    $0x30
  801d25:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d2b:	83 c4 10             	add    $0x10,%esp
  801d2e:	5b                   	pop    %ebx
  801d2f:	5e                   	pop    %esi
  801d30:	5f                   	pop    %edi
  801d31:	5d                   	pop    %ebp
  801d32:	c3                   	ret    

00801d33 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 04             	sub    $0x4,%esp
  801d39:	8b 45 10             	mov    0x10(%ebp),%eax
  801d3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d3f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	52                   	push   %edx
  801d4b:	ff 75 0c             	pushl  0xc(%ebp)
  801d4e:	50                   	push   %eax
  801d4f:	6a 00                	push   $0x0
  801d51:	e8 b2 ff ff ff       	call   801d08 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	90                   	nop
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sys_cgetc>:

int
sys_cgetc(void)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 01                	push   $0x1
  801d6b:	e8 98 ff ff ff       	call   801d08 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	52                   	push   %edx
  801d85:	50                   	push   %eax
  801d86:	6a 05                	push   $0x5
  801d88:	e8 7b ff ff ff       	call   801d08 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	56                   	push   %esi
  801d96:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d97:	8b 75 18             	mov    0x18(%ebp),%esi
  801d9a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	56                   	push   %esi
  801da7:	53                   	push   %ebx
  801da8:	51                   	push   %ecx
  801da9:	52                   	push   %edx
  801daa:	50                   	push   %eax
  801dab:	6a 06                	push   $0x6
  801dad:	e8 56 ff ff ff       	call   801d08 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db8:	5b                   	pop    %ebx
  801db9:	5e                   	pop    %esi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    

00801dbc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	52                   	push   %edx
  801dcc:	50                   	push   %eax
  801dcd:	6a 07                	push   $0x7
  801dcf:	e8 34 ff ff ff       	call   801d08 <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	ff 75 0c             	pushl  0xc(%ebp)
  801de5:	ff 75 08             	pushl  0x8(%ebp)
  801de8:	6a 08                	push   $0x8
  801dea:	e8 19 ff ff ff       	call   801d08 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 09                	push   $0x9
  801e03:	e8 00 ff ff ff       	call   801d08 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 0a                	push   $0xa
  801e1c:	e8 e7 fe ff ff       	call   801d08 <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 0b                	push   $0xb
  801e35:	e8 ce fe ff ff       	call   801d08 <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	ff 75 0c             	pushl  0xc(%ebp)
  801e4b:	ff 75 08             	pushl  0x8(%ebp)
  801e4e:	6a 0f                	push   $0xf
  801e50:	e8 b3 fe ff ff       	call   801d08 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
	return;
  801e58:	90                   	nop
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	ff 75 0c             	pushl  0xc(%ebp)
  801e67:	ff 75 08             	pushl  0x8(%ebp)
  801e6a:	6a 10                	push   $0x10
  801e6c:	e8 97 fe ff ff       	call   801d08 <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
	return ;
  801e74:	90                   	nop
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	ff 75 10             	pushl  0x10(%ebp)
  801e81:	ff 75 0c             	pushl  0xc(%ebp)
  801e84:	ff 75 08             	pushl  0x8(%ebp)
  801e87:	6a 11                	push   $0x11
  801e89:	e8 7a fe ff ff       	call   801d08 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e91:	90                   	nop
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 0c                	push   $0xc
  801ea3:	e8 60 fe ff ff       	call   801d08 <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	ff 75 08             	pushl  0x8(%ebp)
  801ebb:	6a 0d                	push   $0xd
  801ebd:	e8 46 fe ff ff       	call   801d08 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 0e                	push   $0xe
  801ed6:	e8 2d fe ff ff       	call   801d08 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	90                   	nop
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 13                	push   $0x13
  801ef0:	e8 13 fe ff ff       	call   801d08 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	90                   	nop
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 14                	push   $0x14
  801f0a:	e8 f9 fd ff ff       	call   801d08 <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
}
  801f12:	90                   	nop
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 04             	sub    $0x4,%esp
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f21:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	50                   	push   %eax
  801f2e:	6a 15                	push   $0x15
  801f30:	e8 d3 fd ff ff       	call   801d08 <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
}
  801f38:	90                   	nop
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 16                	push   $0x16
  801f4a:	e8 b9 fd ff ff       	call   801d08 <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
}
  801f52:	90                   	nop
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	ff 75 0c             	pushl  0xc(%ebp)
  801f64:	50                   	push   %eax
  801f65:	6a 17                	push   $0x17
  801f67:	e8 9c fd ff ff       	call   801d08 <syscall>
  801f6c:	83 c4 18             	add    $0x18,%esp
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f77:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	52                   	push   %edx
  801f81:	50                   	push   %eax
  801f82:	6a 1a                	push   $0x1a
  801f84:	e8 7f fd ff ff       	call   801d08 <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	52                   	push   %edx
  801f9e:	50                   	push   %eax
  801f9f:	6a 18                	push   $0x18
  801fa1:	e8 62 fd ff ff       	call   801d08 <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
}
  801fa9:	90                   	nop
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801faf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	52                   	push   %edx
  801fbc:	50                   	push   %eax
  801fbd:	6a 19                	push   $0x19
  801fbf:	e8 44 fd ff ff       	call   801d08 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	90                   	nop
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	83 ec 04             	sub    $0x4,%esp
  801fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fd6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fd9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	51                   	push   %ecx
  801fe3:	52                   	push   %edx
  801fe4:	ff 75 0c             	pushl  0xc(%ebp)
  801fe7:	50                   	push   %eax
  801fe8:	6a 1b                	push   $0x1b
  801fea:	e8 19 fd ff ff       	call   801d08 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ff7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	52                   	push   %edx
  802004:	50                   	push   %eax
  802005:	6a 1c                	push   $0x1c
  802007:	e8 fc fc ff ff       	call   801d08 <syscall>
  80200c:	83 c4 18             	add    $0x18,%esp
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802014:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	51                   	push   %ecx
  802022:	52                   	push   %edx
  802023:	50                   	push   %eax
  802024:	6a 1d                	push   $0x1d
  802026:	e8 dd fc ff ff       	call   801d08 <syscall>
  80202b:	83 c4 18             	add    $0x18,%esp
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802033:	8b 55 0c             	mov    0xc(%ebp),%edx
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	52                   	push   %edx
  802040:	50                   	push   %eax
  802041:	6a 1e                	push   $0x1e
  802043:	e8 c0 fc ff ff       	call   801d08 <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 1f                	push   $0x1f
  80205c:	e8 a7 fc ff ff       	call   801d08 <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	6a 00                	push   $0x0
  80206e:	ff 75 14             	pushl  0x14(%ebp)
  802071:	ff 75 10             	pushl  0x10(%ebp)
  802074:	ff 75 0c             	pushl  0xc(%ebp)
  802077:	50                   	push   %eax
  802078:	6a 20                	push   $0x20
  80207a:	e8 89 fc ff ff       	call   801d08 <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	50                   	push   %eax
  802093:	6a 21                	push   $0x21
  802095:	e8 6e fc ff ff       	call   801d08 <syscall>
  80209a:	83 c4 18             	add    $0x18,%esp
}
  80209d:	90                   	nop
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	50                   	push   %eax
  8020af:	6a 22                	push   $0x22
  8020b1:	e8 52 fc ff ff       	call   801d08 <syscall>
  8020b6:	83 c4 18             	add    $0x18,%esp
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 02                	push   $0x2
  8020ca:	e8 39 fc ff ff       	call   801d08 <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 03                	push   $0x3
  8020e3:	e8 20 fc ff ff       	call   801d08 <syscall>
  8020e8:	83 c4 18             	add    $0x18,%esp
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 04                	push   $0x4
  8020fc:	e8 07 fc ff ff       	call   801d08 <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <sys_exit_env>:


void sys_exit_env(void)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 23                	push   $0x23
  802115:	e8 ee fb ff ff       	call   801d08 <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
}
  80211d:	90                   	nop
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802126:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802129:	8d 50 04             	lea    0x4(%eax),%edx
  80212c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	52                   	push   %edx
  802136:	50                   	push   %eax
  802137:	6a 24                	push   $0x24
  802139:	e8 ca fb ff ff       	call   801d08 <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
	return result;
  802141:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802144:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802147:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80214a:	89 01                	mov    %eax,(%ecx)
  80214c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	c9                   	leave  
  802153:	c2 04 00             	ret    $0x4

00802156 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	ff 75 10             	pushl  0x10(%ebp)
  802160:	ff 75 0c             	pushl  0xc(%ebp)
  802163:	ff 75 08             	pushl  0x8(%ebp)
  802166:	6a 12                	push   $0x12
  802168:	e8 9b fb ff ff       	call   801d08 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
	return ;
  802170:	90                   	nop
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_rcr2>:
uint32 sys_rcr2()
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 25                	push   $0x25
  802182:	e8 81 fb ff ff       	call   801d08 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802198:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	50                   	push   %eax
  8021a5:	6a 26                	push   $0x26
  8021a7:	e8 5c fb ff ff       	call   801d08 <syscall>
  8021ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8021af:	90                   	nop
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <rsttst>:
void rsttst()
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 28                	push   $0x28
  8021c1:	e8 42 fb ff ff       	call   801d08 <syscall>
  8021c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c9:	90                   	nop
}
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    

008021cc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	83 ec 04             	sub    $0x4,%esp
  8021d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021d8:	8b 55 18             	mov    0x18(%ebp),%edx
  8021db:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021df:	52                   	push   %edx
  8021e0:	50                   	push   %eax
  8021e1:	ff 75 10             	pushl  0x10(%ebp)
  8021e4:	ff 75 0c             	pushl  0xc(%ebp)
  8021e7:	ff 75 08             	pushl  0x8(%ebp)
  8021ea:	6a 27                	push   $0x27
  8021ec:	e8 17 fb ff ff       	call   801d08 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f4:	90                   	nop
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <chktst>:
void chktst(uint32 n)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	ff 75 08             	pushl  0x8(%ebp)
  802205:	6a 29                	push   $0x29
  802207:	e8 fc fa ff ff       	call   801d08 <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
	return ;
  80220f:	90                   	nop
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <inctst>:

void inctst()
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 2a                	push   $0x2a
  802221:	e8 e2 fa ff ff       	call   801d08 <syscall>
  802226:	83 c4 18             	add    $0x18,%esp
	return ;
  802229:	90                   	nop
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <gettst>:
uint32 gettst()
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 2b                	push   $0x2b
  80223b:	e8 c8 fa ff ff       	call   801d08 <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 2c                	push   $0x2c
  802257:	e8 ac fa ff ff       	call   801d08 <syscall>
  80225c:	83 c4 18             	add    $0x18,%esp
  80225f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802262:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802266:	75 07                	jne    80226f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802268:	b8 01 00 00 00       	mov    $0x1,%eax
  80226d:	eb 05                	jmp    802274 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80226f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 2c                	push   $0x2c
  802288:	e8 7b fa ff ff       	call   801d08 <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
  802290:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802293:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802297:	75 07                	jne    8022a0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802299:	b8 01 00 00 00       	mov    $0x1,%eax
  80229e:	eb 05                	jmp    8022a5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
  8022aa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 2c                	push   $0x2c
  8022b9:	e8 4a fa ff ff       	call   801d08 <syscall>
  8022be:	83 c4 18             	add    $0x18,%esp
  8022c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022c4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022c8:	75 07                	jne    8022d1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cf:	eb 05                	jmp    8022d6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 2c                	push   $0x2c
  8022ea:	e8 19 fa ff ff       	call   801d08 <syscall>
  8022ef:	83 c4 18             	add    $0x18,%esp
  8022f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022f5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022f9:	75 07                	jne    802302 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022fb:	b8 01 00 00 00       	mov    $0x1,%eax
  802300:	eb 05                	jmp    802307 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802302:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	ff 75 08             	pushl  0x8(%ebp)
  802317:	6a 2d                	push   $0x2d
  802319:	e8 ea f9 ff ff       	call   801d08 <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
	return ;
  802321:	90                   	nop
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802328:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80232b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80232e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	6a 00                	push   $0x0
  802336:	53                   	push   %ebx
  802337:	51                   	push   %ecx
  802338:	52                   	push   %edx
  802339:	50                   	push   %eax
  80233a:	6a 2e                	push   $0x2e
  80233c:	e8 c7 f9 ff ff       	call   801d08 <syscall>
  802341:	83 c4 18             	add    $0x18,%esp
}
  802344:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80234c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	52                   	push   %edx
  802359:	50                   	push   %eax
  80235a:	6a 2f                	push   $0x2f
  80235c:	e8 a7 f9 ff ff       	call   801d08 <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
  802369:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80236c:	83 ec 0c             	sub    $0xc,%esp
  80236f:	68 80 44 80 00       	push   $0x804480
  802374:	e8 d6 e6 ff ff       	call   800a4f <cprintf>
  802379:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80237c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802383:	83 ec 0c             	sub    $0xc,%esp
  802386:	68 ac 44 80 00       	push   $0x8044ac
  80238b:	e8 bf e6 ff ff       	call   800a4f <cprintf>
  802390:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802393:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802397:	a1 38 51 80 00       	mov    0x805138,%eax
  80239c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239f:	eb 56                	jmp    8023f7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023a5:	74 1c                	je     8023c3 <print_mem_block_lists+0x5d>
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 50 08             	mov    0x8(%eax),%edx
  8023ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b0:	8b 48 08             	mov    0x8(%eax),%ecx
  8023b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b9:	01 c8                	add    %ecx,%eax
  8023bb:	39 c2                	cmp    %eax,%edx
  8023bd:	73 04                	jae    8023c3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023bf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 50 08             	mov    0x8(%eax),%edx
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cf:	01 c2                	add    %eax,%edx
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 40 08             	mov    0x8(%eax),%eax
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	52                   	push   %edx
  8023db:	50                   	push   %eax
  8023dc:	68 c1 44 80 00       	push   $0x8044c1
  8023e1:	e8 69 e6 ff ff       	call   800a4f <cprintf>
  8023e6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023ef:	a1 40 51 80 00       	mov    0x805140,%eax
  8023f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fb:	74 07                	je     802404 <print_mem_block_lists+0x9e>
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	eb 05                	jmp    802409 <print_mem_block_lists+0xa3>
  802404:	b8 00 00 00 00       	mov    $0x0,%eax
  802409:	a3 40 51 80 00       	mov    %eax,0x805140
  80240e:	a1 40 51 80 00       	mov    0x805140,%eax
  802413:	85 c0                	test   %eax,%eax
  802415:	75 8a                	jne    8023a1 <print_mem_block_lists+0x3b>
  802417:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241b:	75 84                	jne    8023a1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80241d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802421:	75 10                	jne    802433 <print_mem_block_lists+0xcd>
  802423:	83 ec 0c             	sub    $0xc,%esp
  802426:	68 d0 44 80 00       	push   $0x8044d0
  80242b:	e8 1f e6 ff ff       	call   800a4f <cprintf>
  802430:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802433:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80243a:	83 ec 0c             	sub    $0xc,%esp
  80243d:	68 f4 44 80 00       	push   $0x8044f4
  802442:	e8 08 e6 ff ff       	call   800a4f <cprintf>
  802447:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80244a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80244e:	a1 40 50 80 00       	mov    0x805040,%eax
  802453:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802456:	eb 56                	jmp    8024ae <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802458:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80245c:	74 1c                	je     80247a <print_mem_block_lists+0x114>
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 50 08             	mov    0x8(%eax),%edx
  802464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802467:	8b 48 08             	mov    0x8(%eax),%ecx
  80246a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246d:	8b 40 0c             	mov    0xc(%eax),%eax
  802470:	01 c8                	add    %ecx,%eax
  802472:	39 c2                	cmp    %eax,%edx
  802474:	73 04                	jae    80247a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802476:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 50 08             	mov    0x8(%eax),%edx
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 40 0c             	mov    0xc(%eax),%eax
  802486:	01 c2                	add    %eax,%edx
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 40 08             	mov    0x8(%eax),%eax
  80248e:	83 ec 04             	sub    $0x4,%esp
  802491:	52                   	push   %edx
  802492:	50                   	push   %eax
  802493:	68 c1 44 80 00       	push   $0x8044c1
  802498:	e8 b2 e5 ff ff       	call   800a4f <cprintf>
  80249d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024a6:	a1 48 50 80 00       	mov    0x805048,%eax
  8024ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b2:	74 07                	je     8024bb <print_mem_block_lists+0x155>
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 00                	mov    (%eax),%eax
  8024b9:	eb 05                	jmp    8024c0 <print_mem_block_lists+0x15a>
  8024bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c0:	a3 48 50 80 00       	mov    %eax,0x805048
  8024c5:	a1 48 50 80 00       	mov    0x805048,%eax
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	75 8a                	jne    802458 <print_mem_block_lists+0xf2>
  8024ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d2:	75 84                	jne    802458 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024d4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024d8:	75 10                	jne    8024ea <print_mem_block_lists+0x184>
  8024da:	83 ec 0c             	sub    $0xc,%esp
  8024dd:	68 0c 45 80 00       	push   $0x80450c
  8024e2:	e8 68 e5 ff ff       	call   800a4f <cprintf>
  8024e7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024ea:	83 ec 0c             	sub    $0xc,%esp
  8024ed:	68 80 44 80 00       	push   $0x804480
  8024f2:	e8 58 e5 ff ff       	call   800a4f <cprintf>
  8024f7:	83 c4 10             	add    $0x10,%esp

}
  8024fa:	90                   	nop
  8024fb:	c9                   	leave  
  8024fc:	c3                   	ret    

008024fd <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024fd:	55                   	push   %ebp
  8024fe:	89 e5                	mov    %esp,%ebp
  802500:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802503:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80250a:	00 00 00 
  80250d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802514:	00 00 00 
  802517:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80251e:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802521:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802528:	e9 9e 00 00 00       	jmp    8025cb <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80252d:	a1 50 50 80 00       	mov    0x805050,%eax
  802532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802535:	c1 e2 04             	shl    $0x4,%edx
  802538:	01 d0                	add    %edx,%eax
  80253a:	85 c0                	test   %eax,%eax
  80253c:	75 14                	jne    802552 <initialize_MemBlocksList+0x55>
  80253e:	83 ec 04             	sub    $0x4,%esp
  802541:	68 34 45 80 00       	push   $0x804534
  802546:	6a 46                	push   $0x46
  802548:	68 57 45 80 00       	push   $0x804557
  80254d:	e8 49 e2 ff ff       	call   80079b <_panic>
  802552:	a1 50 50 80 00       	mov    0x805050,%eax
  802557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255a:	c1 e2 04             	shl    $0x4,%edx
  80255d:	01 d0                	add    %edx,%eax
  80255f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802565:	89 10                	mov    %edx,(%eax)
  802567:	8b 00                	mov    (%eax),%eax
  802569:	85 c0                	test   %eax,%eax
  80256b:	74 18                	je     802585 <initialize_MemBlocksList+0x88>
  80256d:	a1 48 51 80 00       	mov    0x805148,%eax
  802572:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802578:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80257b:	c1 e1 04             	shl    $0x4,%ecx
  80257e:	01 ca                	add    %ecx,%edx
  802580:	89 50 04             	mov    %edx,0x4(%eax)
  802583:	eb 12                	jmp    802597 <initialize_MemBlocksList+0x9a>
  802585:	a1 50 50 80 00       	mov    0x805050,%eax
  80258a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258d:	c1 e2 04             	shl    $0x4,%edx
  802590:	01 d0                	add    %edx,%eax
  802592:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802597:	a1 50 50 80 00       	mov    0x805050,%eax
  80259c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259f:	c1 e2 04             	shl    $0x4,%edx
  8025a2:	01 d0                	add    %edx,%eax
  8025a4:	a3 48 51 80 00       	mov    %eax,0x805148
  8025a9:	a1 50 50 80 00       	mov    0x805050,%eax
  8025ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b1:	c1 e2 04             	shl    $0x4,%edx
  8025b4:	01 d0                	add    %edx,%eax
  8025b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025bd:	a1 54 51 80 00       	mov    0x805154,%eax
  8025c2:	40                   	inc    %eax
  8025c3:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8025c8:	ff 45 f4             	incl   -0xc(%ebp)
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d1:	0f 82 56 ff ff ff    	jb     80252d <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8025d7:	90                   	nop
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	8b 00                	mov    (%eax),%eax
  8025e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025e8:	eb 19                	jmp    802603 <find_block+0x29>
	{
		if(va==point->sva)
  8025ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ed:	8b 40 08             	mov    0x8(%eax),%eax
  8025f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025f3:	75 05                	jne    8025fa <find_block+0x20>
		   return point;
  8025f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f8:	eb 36                	jmp    802630 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	8b 40 08             	mov    0x8(%eax),%eax
  802600:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802603:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802607:	74 07                	je     802610 <find_block+0x36>
  802609:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80260c:	8b 00                	mov    (%eax),%eax
  80260e:	eb 05                	jmp    802615 <find_block+0x3b>
  802610:	b8 00 00 00 00       	mov    $0x0,%eax
  802615:	8b 55 08             	mov    0x8(%ebp),%edx
  802618:	89 42 08             	mov    %eax,0x8(%edx)
  80261b:	8b 45 08             	mov    0x8(%ebp),%eax
  80261e:	8b 40 08             	mov    0x8(%eax),%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	75 c5                	jne    8025ea <find_block+0x10>
  802625:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802629:	75 bf                	jne    8025ea <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80262b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802630:	c9                   	leave  
  802631:	c3                   	ret    

00802632 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802632:	55                   	push   %ebp
  802633:	89 e5                	mov    %esp,%ebp
  802635:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802638:	a1 40 50 80 00       	mov    0x805040,%eax
  80263d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802640:	a1 44 50 80 00       	mov    0x805044,%eax
  802645:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80264e:	74 24                	je     802674 <insert_sorted_allocList+0x42>
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	8b 50 08             	mov    0x8(%eax),%edx
  802656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802659:	8b 40 08             	mov    0x8(%eax),%eax
  80265c:	39 c2                	cmp    %eax,%edx
  80265e:	76 14                	jbe    802674 <insert_sorted_allocList+0x42>
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	8b 50 08             	mov    0x8(%eax),%edx
  802666:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802669:	8b 40 08             	mov    0x8(%eax),%eax
  80266c:	39 c2                	cmp    %eax,%edx
  80266e:	0f 82 60 01 00 00    	jb     8027d4 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802674:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802678:	75 65                	jne    8026df <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80267a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267e:	75 14                	jne    802694 <insert_sorted_allocList+0x62>
  802680:	83 ec 04             	sub    $0x4,%esp
  802683:	68 34 45 80 00       	push   $0x804534
  802688:	6a 6b                	push   $0x6b
  80268a:	68 57 45 80 00       	push   $0x804557
  80268f:	e8 07 e1 ff ff       	call   80079b <_panic>
  802694:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80269a:	8b 45 08             	mov    0x8(%ebp),%eax
  80269d:	89 10                	mov    %edx,(%eax)
  80269f:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a2:	8b 00                	mov    (%eax),%eax
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	74 0d                	je     8026b5 <insert_sorted_allocList+0x83>
  8026a8:	a1 40 50 80 00       	mov    0x805040,%eax
  8026ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b0:	89 50 04             	mov    %edx,0x4(%eax)
  8026b3:	eb 08                	jmp    8026bd <insert_sorted_allocList+0x8b>
  8026b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b8:	a3 44 50 80 00       	mov    %eax,0x805044
  8026bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c0:	a3 40 50 80 00       	mov    %eax,0x805040
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026cf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026d4:	40                   	inc    %eax
  8026d5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026da:	e9 dc 01 00 00       	jmp    8028bb <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	8b 50 08             	mov    0x8(%eax),%edx
  8026e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e8:	8b 40 08             	mov    0x8(%eax),%eax
  8026eb:	39 c2                	cmp    %eax,%edx
  8026ed:	77 6c                	ja     80275b <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8026ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f3:	74 06                	je     8026fb <insert_sorted_allocList+0xc9>
  8026f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026f9:	75 14                	jne    80270f <insert_sorted_allocList+0xdd>
  8026fb:	83 ec 04             	sub    $0x4,%esp
  8026fe:	68 70 45 80 00       	push   $0x804570
  802703:	6a 6f                	push   $0x6f
  802705:	68 57 45 80 00       	push   $0x804557
  80270a:	e8 8c e0 ff ff       	call   80079b <_panic>
  80270f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802712:	8b 50 04             	mov    0x4(%eax),%edx
  802715:	8b 45 08             	mov    0x8(%ebp),%eax
  802718:	89 50 04             	mov    %edx,0x4(%eax)
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802721:	89 10                	mov    %edx,(%eax)
  802723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802726:	8b 40 04             	mov    0x4(%eax),%eax
  802729:	85 c0                	test   %eax,%eax
  80272b:	74 0d                	je     80273a <insert_sorted_allocList+0x108>
  80272d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802730:	8b 40 04             	mov    0x4(%eax),%eax
  802733:	8b 55 08             	mov    0x8(%ebp),%edx
  802736:	89 10                	mov    %edx,(%eax)
  802738:	eb 08                	jmp    802742 <insert_sorted_allocList+0x110>
  80273a:	8b 45 08             	mov    0x8(%ebp),%eax
  80273d:	a3 40 50 80 00       	mov    %eax,0x805040
  802742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802745:	8b 55 08             	mov    0x8(%ebp),%edx
  802748:	89 50 04             	mov    %edx,0x4(%eax)
  80274b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802750:	40                   	inc    %eax
  802751:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802756:	e9 60 01 00 00       	jmp    8028bb <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	8b 50 08             	mov    0x8(%eax),%edx
  802761:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802764:	8b 40 08             	mov    0x8(%eax),%eax
  802767:	39 c2                	cmp    %eax,%edx
  802769:	0f 82 4c 01 00 00    	jb     8028bb <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80276f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802773:	75 14                	jne    802789 <insert_sorted_allocList+0x157>
  802775:	83 ec 04             	sub    $0x4,%esp
  802778:	68 a8 45 80 00       	push   $0x8045a8
  80277d:	6a 73                	push   $0x73
  80277f:	68 57 45 80 00       	push   $0x804557
  802784:	e8 12 e0 ff ff       	call   80079b <_panic>
  802789:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	89 50 04             	mov    %edx,0x4(%eax)
  802795:	8b 45 08             	mov    0x8(%ebp),%eax
  802798:	8b 40 04             	mov    0x4(%eax),%eax
  80279b:	85 c0                	test   %eax,%eax
  80279d:	74 0c                	je     8027ab <insert_sorted_allocList+0x179>
  80279f:	a1 44 50 80 00       	mov    0x805044,%eax
  8027a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a7:	89 10                	mov    %edx,(%eax)
  8027a9:	eb 08                	jmp    8027b3 <insert_sorted_allocList+0x181>
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	a3 40 50 80 00       	mov    %eax,0x805040
  8027b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b6:	a3 44 50 80 00       	mov    %eax,0x805044
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027c9:	40                   	inc    %eax
  8027ca:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027cf:	e9 e7 00 00 00       	jmp    8028bb <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8027d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8027da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8027e1:	a1 40 50 80 00       	mov    0x805040,%eax
  8027e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e9:	e9 9d 00 00 00       	jmp    80288b <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 00                	mov    (%eax),%eax
  8027f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	8b 50 08             	mov    0x8(%eax),%edx
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 40 08             	mov    0x8(%eax),%eax
  802802:	39 c2                	cmp    %eax,%edx
  802804:	76 7d                	jbe    802883 <insert_sorted_allocList+0x251>
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	8b 50 08             	mov    0x8(%eax),%edx
  80280c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280f:	8b 40 08             	mov    0x8(%eax),%eax
  802812:	39 c2                	cmp    %eax,%edx
  802814:	73 6d                	jae    802883 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802816:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281a:	74 06                	je     802822 <insert_sorted_allocList+0x1f0>
  80281c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802820:	75 14                	jne    802836 <insert_sorted_allocList+0x204>
  802822:	83 ec 04             	sub    $0x4,%esp
  802825:	68 cc 45 80 00       	push   $0x8045cc
  80282a:	6a 7f                	push   $0x7f
  80282c:	68 57 45 80 00       	push   $0x804557
  802831:	e8 65 df ff ff       	call   80079b <_panic>
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	8b 10                	mov    (%eax),%edx
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	89 10                	mov    %edx,(%eax)
  802840:	8b 45 08             	mov    0x8(%ebp),%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	85 c0                	test   %eax,%eax
  802847:	74 0b                	je     802854 <insert_sorted_allocList+0x222>
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	8b 55 08             	mov    0x8(%ebp),%edx
  802851:	89 50 04             	mov    %edx,0x4(%eax)
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 55 08             	mov    0x8(%ebp),%edx
  80285a:	89 10                	mov    %edx,(%eax)
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802862:	89 50 04             	mov    %edx,0x4(%eax)
  802865:	8b 45 08             	mov    0x8(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	85 c0                	test   %eax,%eax
  80286c:	75 08                	jne    802876 <insert_sorted_allocList+0x244>
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	a3 44 50 80 00       	mov    %eax,0x805044
  802876:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80287b:	40                   	inc    %eax
  80287c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802881:	eb 39                	jmp    8028bc <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802883:	a1 48 50 80 00       	mov    0x805048,%eax
  802888:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288f:	74 07                	je     802898 <insert_sorted_allocList+0x266>
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	8b 00                	mov    (%eax),%eax
  802896:	eb 05                	jmp    80289d <insert_sorted_allocList+0x26b>
  802898:	b8 00 00 00 00       	mov    $0x0,%eax
  80289d:	a3 48 50 80 00       	mov    %eax,0x805048
  8028a2:	a1 48 50 80 00       	mov    0x805048,%eax
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	0f 85 3f ff ff ff    	jne    8027ee <insert_sorted_allocList+0x1bc>
  8028af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b3:	0f 85 35 ff ff ff    	jne    8027ee <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028b9:	eb 01                	jmp    8028bc <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028bb:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028bc:	90                   	nop
  8028bd:	c9                   	leave  
  8028be:	c3                   	ret    

008028bf <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8028bf:	55                   	push   %ebp
  8028c0:	89 e5                	mov    %esp,%ebp
  8028c2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028c5:	a1 38 51 80 00       	mov    0x805138,%eax
  8028ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cd:	e9 85 01 00 00       	jmp    802a57 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028db:	0f 82 6e 01 00 00    	jb     802a4f <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ea:	0f 85 8a 00 00 00    	jne    80297a <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8028f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f4:	75 17                	jne    80290d <alloc_block_FF+0x4e>
  8028f6:	83 ec 04             	sub    $0x4,%esp
  8028f9:	68 00 46 80 00       	push   $0x804600
  8028fe:	68 93 00 00 00       	push   $0x93
  802903:	68 57 45 80 00       	push   $0x804557
  802908:	e8 8e de ff ff       	call   80079b <_panic>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	74 10                	je     802926 <alloc_block_FF+0x67>
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 00                	mov    (%eax),%eax
  80291b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291e:	8b 52 04             	mov    0x4(%edx),%edx
  802921:	89 50 04             	mov    %edx,0x4(%eax)
  802924:	eb 0b                	jmp    802931 <alloc_block_FF+0x72>
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	8b 40 04             	mov    0x4(%eax),%eax
  80292c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 40 04             	mov    0x4(%eax),%eax
  802937:	85 c0                	test   %eax,%eax
  802939:	74 0f                	je     80294a <alloc_block_FF+0x8b>
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 40 04             	mov    0x4(%eax),%eax
  802941:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802944:	8b 12                	mov    (%edx),%edx
  802946:	89 10                	mov    %edx,(%eax)
  802948:	eb 0a                	jmp    802954 <alloc_block_FF+0x95>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	a3 38 51 80 00       	mov    %eax,0x805138
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802967:	a1 44 51 80 00       	mov    0x805144,%eax
  80296c:	48                   	dec    %eax
  80296d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	e9 10 01 00 00       	jmp    802a8a <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 40 0c             	mov    0xc(%eax),%eax
  802980:	3b 45 08             	cmp    0x8(%ebp),%eax
  802983:	0f 86 c6 00 00 00    	jbe    802a4f <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802989:	a1 48 51 80 00       	mov    0x805148,%eax
  80298e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	8b 50 08             	mov    0x8(%eax),%edx
  802997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299a:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80299d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a3:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029aa:	75 17                	jne    8029c3 <alloc_block_FF+0x104>
  8029ac:	83 ec 04             	sub    $0x4,%esp
  8029af:	68 00 46 80 00       	push   $0x804600
  8029b4:	68 9b 00 00 00       	push   $0x9b
  8029b9:	68 57 45 80 00       	push   $0x804557
  8029be:	e8 d8 dd ff ff       	call   80079b <_panic>
  8029c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c6:	8b 00                	mov    (%eax),%eax
  8029c8:	85 c0                	test   %eax,%eax
  8029ca:	74 10                	je     8029dc <alloc_block_FF+0x11d>
  8029cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cf:	8b 00                	mov    (%eax),%eax
  8029d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d4:	8b 52 04             	mov    0x4(%edx),%edx
  8029d7:	89 50 04             	mov    %edx,0x4(%eax)
  8029da:	eb 0b                	jmp    8029e7 <alloc_block_FF+0x128>
  8029dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029df:	8b 40 04             	mov    0x4(%eax),%eax
  8029e2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ea:	8b 40 04             	mov    0x4(%eax),%eax
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	74 0f                	je     802a00 <alloc_block_FF+0x141>
  8029f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f4:	8b 40 04             	mov    0x4(%eax),%eax
  8029f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029fa:	8b 12                	mov    (%edx),%edx
  8029fc:	89 10                	mov    %edx,(%eax)
  8029fe:	eb 0a                	jmp    802a0a <alloc_block_FF+0x14b>
  802a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	a3 48 51 80 00       	mov    %eax,0x805148
  802a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1d:	a1 54 51 80 00       	mov    0x805154,%eax
  802a22:	48                   	dec    %eax
  802a23:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 50 08             	mov    0x8(%eax),%edx
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	01 c2                	add    %eax,%edx
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a42:	89 c2                	mov    %eax,%edx
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4d:	eb 3b                	jmp    802a8a <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a4f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5b:	74 07                	je     802a64 <alloc_block_FF+0x1a5>
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8b 00                	mov    (%eax),%eax
  802a62:	eb 05                	jmp    802a69 <alloc_block_FF+0x1aa>
  802a64:	b8 00 00 00 00       	mov    $0x0,%eax
  802a69:	a3 40 51 80 00       	mov    %eax,0x805140
  802a6e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a73:	85 c0                	test   %eax,%eax
  802a75:	0f 85 57 fe ff ff    	jne    8028d2 <alloc_block_FF+0x13>
  802a7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7f:	0f 85 4d fe ff ff    	jne    8028d2 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802a85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a8a:	c9                   	leave  
  802a8b:	c3                   	ret    

00802a8c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a8c:	55                   	push   %ebp
  802a8d:	89 e5                	mov    %esp,%ebp
  802a8f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802a92:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a99:	a1 38 51 80 00       	mov    0x805138,%eax
  802a9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa1:	e9 df 00 00 00       	jmp    802b85 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 40 0c             	mov    0xc(%eax),%eax
  802aac:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aaf:	0f 82 c8 00 00 00    	jb     802b7d <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 40 0c             	mov    0xc(%eax),%eax
  802abb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802abe:	0f 85 8a 00 00 00    	jne    802b4e <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802ac4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac8:	75 17                	jne    802ae1 <alloc_block_BF+0x55>
  802aca:	83 ec 04             	sub    $0x4,%esp
  802acd:	68 00 46 80 00       	push   $0x804600
  802ad2:	68 b7 00 00 00       	push   $0xb7
  802ad7:	68 57 45 80 00       	push   $0x804557
  802adc:	e8 ba dc ff ff       	call   80079b <_panic>
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 00                	mov    (%eax),%eax
  802ae6:	85 c0                	test   %eax,%eax
  802ae8:	74 10                	je     802afa <alloc_block_BF+0x6e>
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 00                	mov    (%eax),%eax
  802aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af2:	8b 52 04             	mov    0x4(%edx),%edx
  802af5:	89 50 04             	mov    %edx,0x4(%eax)
  802af8:	eb 0b                	jmp    802b05 <alloc_block_BF+0x79>
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	8b 40 04             	mov    0x4(%eax),%eax
  802b00:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 40 04             	mov    0x4(%eax),%eax
  802b0b:	85 c0                	test   %eax,%eax
  802b0d:	74 0f                	je     802b1e <alloc_block_BF+0x92>
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 04             	mov    0x4(%eax),%eax
  802b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b18:	8b 12                	mov    (%edx),%edx
  802b1a:	89 10                	mov    %edx,(%eax)
  802b1c:	eb 0a                	jmp    802b28 <alloc_block_BF+0x9c>
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	a3 38 51 80 00       	mov    %eax,0x805138
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3b:	a1 44 51 80 00       	mov    0x805144,%eax
  802b40:	48                   	dec    %eax
  802b41:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	e9 4d 01 00 00       	jmp    802c9b <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 40 0c             	mov    0xc(%eax),%eax
  802b54:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b57:	76 24                	jbe    802b7d <alloc_block_BF+0xf1>
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b62:	73 19                	jae    802b7d <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802b64:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 40 08             	mov    0x8(%eax),%eax
  802b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b7d:	a1 40 51 80 00       	mov    0x805140,%eax
  802b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b89:	74 07                	je     802b92 <alloc_block_BF+0x106>
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	eb 05                	jmp    802b97 <alloc_block_BF+0x10b>
  802b92:	b8 00 00 00 00       	mov    $0x0,%eax
  802b97:	a3 40 51 80 00       	mov    %eax,0x805140
  802b9c:	a1 40 51 80 00       	mov    0x805140,%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	0f 85 fd fe ff ff    	jne    802aa6 <alloc_block_BF+0x1a>
  802ba9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bad:	0f 85 f3 fe ff ff    	jne    802aa6 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802bb3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bb7:	0f 84 d9 00 00 00    	je     802c96 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bbd:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802bc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bcb:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802bce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd4:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802bd7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bdb:	75 17                	jne    802bf4 <alloc_block_BF+0x168>
  802bdd:	83 ec 04             	sub    $0x4,%esp
  802be0:	68 00 46 80 00       	push   $0x804600
  802be5:	68 c7 00 00 00       	push   $0xc7
  802bea:	68 57 45 80 00       	push   $0x804557
  802bef:	e8 a7 db ff ff       	call   80079b <_panic>
  802bf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	74 10                	je     802c0d <alloc_block_BF+0x181>
  802bfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c05:	8b 52 04             	mov    0x4(%edx),%edx
  802c08:	89 50 04             	mov    %edx,0x4(%eax)
  802c0b:	eb 0b                	jmp    802c18 <alloc_block_BF+0x18c>
  802c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c10:	8b 40 04             	mov    0x4(%eax),%eax
  802c13:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1b:	8b 40 04             	mov    0x4(%eax),%eax
  802c1e:	85 c0                	test   %eax,%eax
  802c20:	74 0f                	je     802c31 <alloc_block_BF+0x1a5>
  802c22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c25:	8b 40 04             	mov    0x4(%eax),%eax
  802c28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c2b:	8b 12                	mov    (%edx),%edx
  802c2d:	89 10                	mov    %edx,(%eax)
  802c2f:	eb 0a                	jmp    802c3b <alloc_block_BF+0x1af>
  802c31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	a3 48 51 80 00       	mov    %eax,0x805148
  802c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4e:	a1 54 51 80 00       	mov    0x805154,%eax
  802c53:	48                   	dec    %eax
  802c54:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802c59:	83 ec 08             	sub    $0x8,%esp
  802c5c:	ff 75 ec             	pushl  -0x14(%ebp)
  802c5f:	68 38 51 80 00       	push   $0x805138
  802c64:	e8 71 f9 ff ff       	call   8025da <find_block>
  802c69:	83 c4 10             	add    $0x10,%esp
  802c6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c72:	8b 50 08             	mov    0x8(%eax),%edx
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	01 c2                	add    %eax,%edx
  802c7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7d:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802c80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c83:	8b 40 0c             	mov    0xc(%eax),%eax
  802c86:	2b 45 08             	sub    0x8(%ebp),%eax
  802c89:	89 c2                	mov    %eax,%edx
  802c8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c8e:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c94:	eb 05                	jmp    802c9b <alloc_block_BF+0x20f>
	}
	return NULL;
  802c96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9b:	c9                   	leave  
  802c9c:	c3                   	ret    

00802c9d <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c9d:	55                   	push   %ebp
  802c9e:	89 e5                	mov    %esp,%ebp
  802ca0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802ca3:	a1 28 50 80 00       	mov    0x805028,%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	0f 85 de 01 00 00    	jne    802e8e <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802cb0:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb8:	e9 9e 01 00 00       	jmp    802e5b <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc6:	0f 82 87 01 00 00    	jb     802e53 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd5:	0f 85 95 00 00 00    	jne    802d70 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802cdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdf:	75 17                	jne    802cf8 <alloc_block_NF+0x5b>
  802ce1:	83 ec 04             	sub    $0x4,%esp
  802ce4:	68 00 46 80 00       	push   $0x804600
  802ce9:	68 e0 00 00 00       	push   $0xe0
  802cee:	68 57 45 80 00       	push   $0x804557
  802cf3:	e8 a3 da ff ff       	call   80079b <_panic>
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 00                	mov    (%eax),%eax
  802cfd:	85 c0                	test   %eax,%eax
  802cff:	74 10                	je     802d11 <alloc_block_NF+0x74>
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 00                	mov    (%eax),%eax
  802d06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d09:	8b 52 04             	mov    0x4(%edx),%edx
  802d0c:	89 50 04             	mov    %edx,0x4(%eax)
  802d0f:	eb 0b                	jmp    802d1c <alloc_block_NF+0x7f>
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 40 04             	mov    0x4(%eax),%eax
  802d17:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	8b 40 04             	mov    0x4(%eax),%eax
  802d22:	85 c0                	test   %eax,%eax
  802d24:	74 0f                	je     802d35 <alloc_block_NF+0x98>
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 40 04             	mov    0x4(%eax),%eax
  802d2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2f:	8b 12                	mov    (%edx),%edx
  802d31:	89 10                	mov    %edx,(%eax)
  802d33:	eb 0a                	jmp    802d3f <alloc_block_NF+0xa2>
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	a3 38 51 80 00       	mov    %eax,0x805138
  802d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d52:	a1 44 51 80 00       	mov    0x805144,%eax
  802d57:	48                   	dec    %eax
  802d58:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 40 08             	mov    0x8(%eax),%eax
  802d63:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	e9 f8 04 00 00       	jmp    803268 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 40 0c             	mov    0xc(%eax),%eax
  802d76:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d79:	0f 86 d4 00 00 00    	jbe    802e53 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d7f:	a1 48 51 80 00       	mov    0x805148,%eax
  802d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	8b 50 08             	mov    0x8(%eax),%edx
  802d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d90:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d96:	8b 55 08             	mov    0x8(%ebp),%edx
  802d99:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da0:	75 17                	jne    802db9 <alloc_block_NF+0x11c>
  802da2:	83 ec 04             	sub    $0x4,%esp
  802da5:	68 00 46 80 00       	push   $0x804600
  802daa:	68 e9 00 00 00       	push   $0xe9
  802daf:	68 57 45 80 00       	push   $0x804557
  802db4:	e8 e2 d9 ff ff       	call   80079b <_panic>
  802db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	85 c0                	test   %eax,%eax
  802dc0:	74 10                	je     802dd2 <alloc_block_NF+0x135>
  802dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc5:	8b 00                	mov    (%eax),%eax
  802dc7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dca:	8b 52 04             	mov    0x4(%edx),%edx
  802dcd:	89 50 04             	mov    %edx,0x4(%eax)
  802dd0:	eb 0b                	jmp    802ddd <alloc_block_NF+0x140>
  802dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd5:	8b 40 04             	mov    0x4(%eax),%eax
  802dd8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de0:	8b 40 04             	mov    0x4(%eax),%eax
  802de3:	85 c0                	test   %eax,%eax
  802de5:	74 0f                	je     802df6 <alloc_block_NF+0x159>
  802de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dea:	8b 40 04             	mov    0x4(%eax),%eax
  802ded:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df0:	8b 12                	mov    (%edx),%edx
  802df2:	89 10                	mov    %edx,(%eax)
  802df4:	eb 0a                	jmp    802e00 <alloc_block_NF+0x163>
  802df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df9:	8b 00                	mov    (%eax),%eax
  802dfb:	a3 48 51 80 00       	mov    %eax,0x805148
  802e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e13:	a1 54 51 80 00       	mov    0x805154,%eax
  802e18:	48                   	dec    %eax
  802e19:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e21:	8b 40 08             	mov    0x8(%eax),%eax
  802e24:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 50 08             	mov    0x8(%eax),%edx
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	01 c2                	add    %eax,%edx
  802e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e37:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e40:	2b 45 08             	sub    0x8(%ebp),%eax
  802e43:	89 c2                	mov    %eax,%edx
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4e:	e9 15 04 00 00       	jmp    803268 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e53:	a1 40 51 80 00       	mov    0x805140,%eax
  802e58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5f:	74 07                	je     802e68 <alloc_block_NF+0x1cb>
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 00                	mov    (%eax),%eax
  802e66:	eb 05                	jmp    802e6d <alloc_block_NF+0x1d0>
  802e68:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6d:	a3 40 51 80 00       	mov    %eax,0x805140
  802e72:	a1 40 51 80 00       	mov    0x805140,%eax
  802e77:	85 c0                	test   %eax,%eax
  802e79:	0f 85 3e fe ff ff    	jne    802cbd <alloc_block_NF+0x20>
  802e7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e83:	0f 85 34 fe ff ff    	jne    802cbd <alloc_block_NF+0x20>
  802e89:	e9 d5 03 00 00       	jmp    803263 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e8e:	a1 38 51 80 00       	mov    0x805138,%eax
  802e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e96:	e9 b1 01 00 00       	jmp    80304c <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ea1:	a1 28 50 80 00       	mov    0x805028,%eax
  802ea6:	39 c2                	cmp    %eax,%edx
  802ea8:	0f 82 96 01 00 00    	jb     803044 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb7:	0f 82 87 01 00 00    	jb     803044 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec6:	0f 85 95 00 00 00    	jne    802f61 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ecc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed0:	75 17                	jne    802ee9 <alloc_block_NF+0x24c>
  802ed2:	83 ec 04             	sub    $0x4,%esp
  802ed5:	68 00 46 80 00       	push   $0x804600
  802eda:	68 fc 00 00 00       	push   $0xfc
  802edf:	68 57 45 80 00       	push   $0x804557
  802ee4:	e8 b2 d8 ff ff       	call   80079b <_panic>
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	74 10                	je     802f02 <alloc_block_NF+0x265>
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 00                	mov    (%eax),%eax
  802ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efa:	8b 52 04             	mov    0x4(%edx),%edx
  802efd:	89 50 04             	mov    %edx,0x4(%eax)
  802f00:	eb 0b                	jmp    802f0d <alloc_block_NF+0x270>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 40 04             	mov    0x4(%eax),%eax
  802f08:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 40 04             	mov    0x4(%eax),%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	74 0f                	je     802f26 <alloc_block_NF+0x289>
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	8b 40 04             	mov    0x4(%eax),%eax
  802f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f20:	8b 12                	mov    (%edx),%edx
  802f22:	89 10                	mov    %edx,(%eax)
  802f24:	eb 0a                	jmp    802f30 <alloc_block_NF+0x293>
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	a3 38 51 80 00       	mov    %eax,0x805138
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f43:	a1 44 51 80 00       	mov    0x805144,%eax
  802f48:	48                   	dec    %eax
  802f49:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 40 08             	mov    0x8(%eax),%eax
  802f54:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	e9 07 03 00 00       	jmp    803268 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f64:	8b 40 0c             	mov    0xc(%eax),%eax
  802f67:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f6a:	0f 86 d4 00 00 00    	jbe    803044 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f70:	a1 48 51 80 00       	mov    0x805148,%eax
  802f75:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 50 08             	mov    0x8(%eax),%edx
  802f7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f81:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f87:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f8d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f91:	75 17                	jne    802faa <alloc_block_NF+0x30d>
  802f93:	83 ec 04             	sub    $0x4,%esp
  802f96:	68 00 46 80 00       	push   $0x804600
  802f9b:	68 04 01 00 00       	push   $0x104
  802fa0:	68 57 45 80 00       	push   $0x804557
  802fa5:	e8 f1 d7 ff ff       	call   80079b <_panic>
  802faa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	85 c0                	test   %eax,%eax
  802fb1:	74 10                	je     802fc3 <alloc_block_NF+0x326>
  802fb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fbb:	8b 52 04             	mov    0x4(%edx),%edx
  802fbe:	89 50 04             	mov    %edx,0x4(%eax)
  802fc1:	eb 0b                	jmp    802fce <alloc_block_NF+0x331>
  802fc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc6:	8b 40 04             	mov    0x4(%eax),%eax
  802fc9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	74 0f                	je     802fe7 <alloc_block_NF+0x34a>
  802fd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdb:	8b 40 04             	mov    0x4(%eax),%eax
  802fde:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe1:	8b 12                	mov    (%edx),%edx
  802fe3:	89 10                	mov    %edx,(%eax)
  802fe5:	eb 0a                	jmp    802ff1 <alloc_block_NF+0x354>
  802fe7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fea:	8b 00                	mov    (%eax),%eax
  802fec:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803004:	a1 54 51 80 00       	mov    0x805154,%eax
  803009:	48                   	dec    %eax
  80300a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80300f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803012:	8b 40 08             	mov    0x8(%eax),%eax
  803015:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	8b 50 08             	mov    0x8(%eax),%edx
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	01 c2                	add    %eax,%edx
  803025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803028:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	8b 40 0c             	mov    0xc(%eax),%eax
  803031:	2b 45 08             	sub    0x8(%ebp),%eax
  803034:	89 c2                	mov    %eax,%edx
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80303c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303f:	e9 24 02 00 00       	jmp    803268 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803044:	a1 40 51 80 00       	mov    0x805140,%eax
  803049:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803050:	74 07                	je     803059 <alloc_block_NF+0x3bc>
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	eb 05                	jmp    80305e <alloc_block_NF+0x3c1>
  803059:	b8 00 00 00 00       	mov    $0x0,%eax
  80305e:	a3 40 51 80 00       	mov    %eax,0x805140
  803063:	a1 40 51 80 00       	mov    0x805140,%eax
  803068:	85 c0                	test   %eax,%eax
  80306a:	0f 85 2b fe ff ff    	jne    802e9b <alloc_block_NF+0x1fe>
  803070:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803074:	0f 85 21 fe ff ff    	jne    802e9b <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80307a:	a1 38 51 80 00       	mov    0x805138,%eax
  80307f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803082:	e9 ae 01 00 00       	jmp    803235 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308a:	8b 50 08             	mov    0x8(%eax),%edx
  80308d:	a1 28 50 80 00       	mov    0x805028,%eax
  803092:	39 c2                	cmp    %eax,%edx
  803094:	0f 83 93 01 00 00    	jae    80322d <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309d:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030a3:	0f 82 84 01 00 00    	jb     80322d <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8030af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b2:	0f 85 95 00 00 00    	jne    80314d <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bc:	75 17                	jne    8030d5 <alloc_block_NF+0x438>
  8030be:	83 ec 04             	sub    $0x4,%esp
  8030c1:	68 00 46 80 00       	push   $0x804600
  8030c6:	68 14 01 00 00       	push   $0x114
  8030cb:	68 57 45 80 00       	push   $0x804557
  8030d0:	e8 c6 d6 ff ff       	call   80079b <_panic>
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	8b 00                	mov    (%eax),%eax
  8030da:	85 c0                	test   %eax,%eax
  8030dc:	74 10                	je     8030ee <alloc_block_NF+0x451>
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	8b 00                	mov    (%eax),%eax
  8030e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e6:	8b 52 04             	mov    0x4(%edx),%edx
  8030e9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ec:	eb 0b                	jmp    8030f9 <alloc_block_NF+0x45c>
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	8b 40 04             	mov    0x4(%eax),%eax
  8030f4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fc:	8b 40 04             	mov    0x4(%eax),%eax
  8030ff:	85 c0                	test   %eax,%eax
  803101:	74 0f                	je     803112 <alloc_block_NF+0x475>
  803103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803106:	8b 40 04             	mov    0x4(%eax),%eax
  803109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310c:	8b 12                	mov    (%edx),%edx
  80310e:	89 10                	mov    %edx,(%eax)
  803110:	eb 0a                	jmp    80311c <alloc_block_NF+0x47f>
  803112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803115:	8b 00                	mov    (%eax),%eax
  803117:	a3 38 51 80 00       	mov    %eax,0x805138
  80311c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803128:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312f:	a1 44 51 80 00       	mov    0x805144,%eax
  803134:	48                   	dec    %eax
  803135:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	8b 40 08             	mov    0x8(%eax),%eax
  803140:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	e9 1b 01 00 00       	jmp    803268 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80314d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803150:	8b 40 0c             	mov    0xc(%eax),%eax
  803153:	3b 45 08             	cmp    0x8(%ebp),%eax
  803156:	0f 86 d1 00 00 00    	jbe    80322d <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80315c:	a1 48 51 80 00       	mov    0x805148,%eax
  803161:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	8b 50 08             	mov    0x8(%eax),%edx
  80316a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803170:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803173:	8b 55 08             	mov    0x8(%ebp),%edx
  803176:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803179:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80317d:	75 17                	jne    803196 <alloc_block_NF+0x4f9>
  80317f:	83 ec 04             	sub    $0x4,%esp
  803182:	68 00 46 80 00       	push   $0x804600
  803187:	68 1c 01 00 00       	push   $0x11c
  80318c:	68 57 45 80 00       	push   $0x804557
  803191:	e8 05 d6 ff ff       	call   80079b <_panic>
  803196:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	74 10                	je     8031af <alloc_block_NF+0x512>
  80319f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a2:	8b 00                	mov    (%eax),%eax
  8031a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031a7:	8b 52 04             	mov    0x4(%edx),%edx
  8031aa:	89 50 04             	mov    %edx,0x4(%eax)
  8031ad:	eb 0b                	jmp    8031ba <alloc_block_NF+0x51d>
  8031af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b2:	8b 40 04             	mov    0x4(%eax),%eax
  8031b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031bd:	8b 40 04             	mov    0x4(%eax),%eax
  8031c0:	85 c0                	test   %eax,%eax
  8031c2:	74 0f                	je     8031d3 <alloc_block_NF+0x536>
  8031c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031cd:	8b 12                	mov    (%edx),%edx
  8031cf:	89 10                	mov    %edx,(%eax)
  8031d1:	eb 0a                	jmp    8031dd <alloc_block_NF+0x540>
  8031d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d6:	8b 00                	mov    (%eax),%eax
  8031d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8031dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f5:	48                   	dec    %eax
  8031f6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fe:	8b 40 08             	mov    0x8(%eax),%eax
  803201:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803209:	8b 50 08             	mov    0x8(%eax),%edx
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	01 c2                	add    %eax,%edx
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321a:	8b 40 0c             	mov    0xc(%eax),%eax
  80321d:	2b 45 08             	sub    0x8(%ebp),%eax
  803220:	89 c2                	mov    %eax,%edx
  803222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803225:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322b:	eb 3b                	jmp    803268 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80322d:	a1 40 51 80 00       	mov    0x805140,%eax
  803232:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803235:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803239:	74 07                	je     803242 <alloc_block_NF+0x5a5>
  80323b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323e:	8b 00                	mov    (%eax),%eax
  803240:	eb 05                	jmp    803247 <alloc_block_NF+0x5aa>
  803242:	b8 00 00 00 00       	mov    $0x0,%eax
  803247:	a3 40 51 80 00       	mov    %eax,0x805140
  80324c:	a1 40 51 80 00       	mov    0x805140,%eax
  803251:	85 c0                	test   %eax,%eax
  803253:	0f 85 2e fe ff ff    	jne    803087 <alloc_block_NF+0x3ea>
  803259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325d:	0f 85 24 fe ff ff    	jne    803087 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803263:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803268:	c9                   	leave  
  803269:	c3                   	ret    

0080326a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80326a:	55                   	push   %ebp
  80326b:	89 e5                	mov    %esp,%ebp
  80326d:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803270:	a1 38 51 80 00       	mov    0x805138,%eax
  803275:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803278:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80327d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803280:	a1 38 51 80 00       	mov    0x805138,%eax
  803285:	85 c0                	test   %eax,%eax
  803287:	74 14                	je     80329d <insert_sorted_with_merge_freeList+0x33>
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	8b 50 08             	mov    0x8(%eax),%edx
  80328f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803292:	8b 40 08             	mov    0x8(%eax),%eax
  803295:	39 c2                	cmp    %eax,%edx
  803297:	0f 87 9b 01 00 00    	ja     803438 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80329d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a1:	75 17                	jne    8032ba <insert_sorted_with_merge_freeList+0x50>
  8032a3:	83 ec 04             	sub    $0x4,%esp
  8032a6:	68 34 45 80 00       	push   $0x804534
  8032ab:	68 38 01 00 00       	push   $0x138
  8032b0:	68 57 45 80 00       	push   $0x804557
  8032b5:	e8 e1 d4 ff ff       	call   80079b <_panic>
  8032ba:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	89 10                	mov    %edx,(%eax)
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	8b 00                	mov    (%eax),%eax
  8032ca:	85 c0                	test   %eax,%eax
  8032cc:	74 0d                	je     8032db <insert_sorted_with_merge_freeList+0x71>
  8032ce:	a1 38 51 80 00       	mov    0x805138,%eax
  8032d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d6:	89 50 04             	mov    %edx,0x4(%eax)
  8032d9:	eb 08                	jmp    8032e3 <insert_sorted_with_merge_freeList+0x79>
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	a3 38 51 80 00       	mov    %eax,0x805138
  8032eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f5:	a1 44 51 80 00       	mov    0x805144,%eax
  8032fa:	40                   	inc    %eax
  8032fb:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803300:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803304:	0f 84 a8 06 00 00    	je     8039b2 <insert_sorted_with_merge_freeList+0x748>
  80330a:	8b 45 08             	mov    0x8(%ebp),%eax
  80330d:	8b 50 08             	mov    0x8(%eax),%edx
  803310:	8b 45 08             	mov    0x8(%ebp),%eax
  803313:	8b 40 0c             	mov    0xc(%eax),%eax
  803316:	01 c2                	add    %eax,%edx
  803318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331b:	8b 40 08             	mov    0x8(%eax),%eax
  80331e:	39 c2                	cmp    %eax,%edx
  803320:	0f 85 8c 06 00 00    	jne    8039b2 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	8b 50 0c             	mov    0xc(%eax),%edx
  80332c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332f:	8b 40 0c             	mov    0xc(%eax),%eax
  803332:	01 c2                	add    %eax,%edx
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80333a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80333e:	75 17                	jne    803357 <insert_sorted_with_merge_freeList+0xed>
  803340:	83 ec 04             	sub    $0x4,%esp
  803343:	68 00 46 80 00       	push   $0x804600
  803348:	68 3c 01 00 00       	push   $0x13c
  80334d:	68 57 45 80 00       	push   $0x804557
  803352:	e8 44 d4 ff ff       	call   80079b <_panic>
  803357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	85 c0                	test   %eax,%eax
  80335e:	74 10                	je     803370 <insert_sorted_with_merge_freeList+0x106>
  803360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803363:	8b 00                	mov    (%eax),%eax
  803365:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803368:	8b 52 04             	mov    0x4(%edx),%edx
  80336b:	89 50 04             	mov    %edx,0x4(%eax)
  80336e:	eb 0b                	jmp    80337b <insert_sorted_with_merge_freeList+0x111>
  803370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803373:	8b 40 04             	mov    0x4(%eax),%eax
  803376:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80337b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337e:	8b 40 04             	mov    0x4(%eax),%eax
  803381:	85 c0                	test   %eax,%eax
  803383:	74 0f                	je     803394 <insert_sorted_with_merge_freeList+0x12a>
  803385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803388:	8b 40 04             	mov    0x4(%eax),%eax
  80338b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80338e:	8b 12                	mov    (%edx),%edx
  803390:	89 10                	mov    %edx,(%eax)
  803392:	eb 0a                	jmp    80339e <insert_sorted_with_merge_freeList+0x134>
  803394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	a3 38 51 80 00       	mov    %eax,0x805138
  80339e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b1:	a1 44 51 80 00       	mov    0x805144,%eax
  8033b6:	48                   	dec    %eax
  8033b7:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8033bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8033c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8033d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033d4:	75 17                	jne    8033ed <insert_sorted_with_merge_freeList+0x183>
  8033d6:	83 ec 04             	sub    $0x4,%esp
  8033d9:	68 34 45 80 00       	push   $0x804534
  8033de:	68 3f 01 00 00       	push   $0x13f
  8033e3:	68 57 45 80 00       	push   $0x804557
  8033e8:	e8 ae d3 ff ff       	call   80079b <_panic>
  8033ed:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f6:	89 10                	mov    %edx,(%eax)
  8033f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fb:	8b 00                	mov    (%eax),%eax
  8033fd:	85 c0                	test   %eax,%eax
  8033ff:	74 0d                	je     80340e <insert_sorted_with_merge_freeList+0x1a4>
  803401:	a1 48 51 80 00       	mov    0x805148,%eax
  803406:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803409:	89 50 04             	mov    %edx,0x4(%eax)
  80340c:	eb 08                	jmp    803416 <insert_sorted_with_merge_freeList+0x1ac>
  80340e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803411:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803419:	a3 48 51 80 00       	mov    %eax,0x805148
  80341e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803421:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803428:	a1 54 51 80 00       	mov    0x805154,%eax
  80342d:	40                   	inc    %eax
  80342e:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803433:	e9 7a 05 00 00       	jmp    8039b2 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	8b 50 08             	mov    0x8(%eax),%edx
  80343e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803441:	8b 40 08             	mov    0x8(%eax),%eax
  803444:	39 c2                	cmp    %eax,%edx
  803446:	0f 82 14 01 00 00    	jb     803560 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80344c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80344f:	8b 50 08             	mov    0x8(%eax),%edx
  803452:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803455:	8b 40 0c             	mov    0xc(%eax),%eax
  803458:	01 c2                	add    %eax,%edx
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	8b 40 08             	mov    0x8(%eax),%eax
  803460:	39 c2                	cmp    %eax,%edx
  803462:	0f 85 90 00 00 00    	jne    8034f8 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803468:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346b:	8b 50 0c             	mov    0xc(%eax),%edx
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	8b 40 0c             	mov    0xc(%eax),%eax
  803474:	01 c2                	add    %eax,%edx
  803476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803479:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80347c:	8b 45 08             	mov    0x8(%ebp),%eax
  80347f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803490:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803494:	75 17                	jne    8034ad <insert_sorted_with_merge_freeList+0x243>
  803496:	83 ec 04             	sub    $0x4,%esp
  803499:	68 34 45 80 00       	push   $0x804534
  80349e:	68 49 01 00 00       	push   $0x149
  8034a3:	68 57 45 80 00       	push   $0x804557
  8034a8:	e8 ee d2 ff ff       	call   80079b <_panic>
  8034ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b6:	89 10                	mov    %edx,(%eax)
  8034b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bb:	8b 00                	mov    (%eax),%eax
  8034bd:	85 c0                	test   %eax,%eax
  8034bf:	74 0d                	je     8034ce <insert_sorted_with_merge_freeList+0x264>
  8034c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c9:	89 50 04             	mov    %edx,0x4(%eax)
  8034cc:	eb 08                	jmp    8034d6 <insert_sorted_with_merge_freeList+0x26c>
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ed:	40                   	inc    %eax
  8034ee:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034f3:	e9 bb 04 00 00       	jmp    8039b3 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8034f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034fc:	75 17                	jne    803515 <insert_sorted_with_merge_freeList+0x2ab>
  8034fe:	83 ec 04             	sub    $0x4,%esp
  803501:	68 a8 45 80 00       	push   $0x8045a8
  803506:	68 4c 01 00 00       	push   $0x14c
  80350b:	68 57 45 80 00       	push   $0x804557
  803510:	e8 86 d2 ff ff       	call   80079b <_panic>
  803515:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80351b:	8b 45 08             	mov    0x8(%ebp),%eax
  80351e:	89 50 04             	mov    %edx,0x4(%eax)
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	8b 40 04             	mov    0x4(%eax),%eax
  803527:	85 c0                	test   %eax,%eax
  803529:	74 0c                	je     803537 <insert_sorted_with_merge_freeList+0x2cd>
  80352b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803530:	8b 55 08             	mov    0x8(%ebp),%edx
  803533:	89 10                	mov    %edx,(%eax)
  803535:	eb 08                	jmp    80353f <insert_sorted_with_merge_freeList+0x2d5>
  803537:	8b 45 08             	mov    0x8(%ebp),%eax
  80353a:	a3 38 51 80 00       	mov    %eax,0x805138
  80353f:	8b 45 08             	mov    0x8(%ebp),%eax
  803542:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803547:	8b 45 08             	mov    0x8(%ebp),%eax
  80354a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803550:	a1 44 51 80 00       	mov    0x805144,%eax
  803555:	40                   	inc    %eax
  803556:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80355b:	e9 53 04 00 00       	jmp    8039b3 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803560:	a1 38 51 80 00       	mov    0x805138,%eax
  803565:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803568:	e9 15 04 00 00       	jmp    803982 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80356d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803570:	8b 00                	mov    (%eax),%eax
  803572:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803575:	8b 45 08             	mov    0x8(%ebp),%eax
  803578:	8b 50 08             	mov    0x8(%eax),%edx
  80357b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357e:	8b 40 08             	mov    0x8(%eax),%eax
  803581:	39 c2                	cmp    %eax,%edx
  803583:	0f 86 f1 03 00 00    	jbe    80397a <insert_sorted_with_merge_freeList+0x710>
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	8b 50 08             	mov    0x8(%eax),%edx
  80358f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803592:	8b 40 08             	mov    0x8(%eax),%eax
  803595:	39 c2                	cmp    %eax,%edx
  803597:	0f 83 dd 03 00 00    	jae    80397a <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80359d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a0:	8b 50 08             	mov    0x8(%eax),%edx
  8035a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a9:	01 c2                	add    %eax,%edx
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	8b 40 08             	mov    0x8(%eax),%eax
  8035b1:	39 c2                	cmp    %eax,%edx
  8035b3:	0f 85 b9 01 00 00    	jne    803772 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bc:	8b 50 08             	mov    0x8(%eax),%edx
  8035bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c5:	01 c2                	add    %eax,%edx
  8035c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ca:	8b 40 08             	mov    0x8(%eax),%eax
  8035cd:	39 c2                	cmp    %eax,%edx
  8035cf:	0f 85 0d 01 00 00    	jne    8036e2 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8035d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d8:	8b 50 0c             	mov    0xc(%eax),%edx
  8035db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035de:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e1:	01 c2                	add    %eax,%edx
  8035e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e6:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035ed:	75 17                	jne    803606 <insert_sorted_with_merge_freeList+0x39c>
  8035ef:	83 ec 04             	sub    $0x4,%esp
  8035f2:	68 00 46 80 00       	push   $0x804600
  8035f7:	68 5c 01 00 00       	push   $0x15c
  8035fc:	68 57 45 80 00       	push   $0x804557
  803601:	e8 95 d1 ff ff       	call   80079b <_panic>
  803606:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803609:	8b 00                	mov    (%eax),%eax
  80360b:	85 c0                	test   %eax,%eax
  80360d:	74 10                	je     80361f <insert_sorted_with_merge_freeList+0x3b5>
  80360f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803612:	8b 00                	mov    (%eax),%eax
  803614:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803617:	8b 52 04             	mov    0x4(%edx),%edx
  80361a:	89 50 04             	mov    %edx,0x4(%eax)
  80361d:	eb 0b                	jmp    80362a <insert_sorted_with_merge_freeList+0x3c0>
  80361f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803622:	8b 40 04             	mov    0x4(%eax),%eax
  803625:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80362a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362d:	8b 40 04             	mov    0x4(%eax),%eax
  803630:	85 c0                	test   %eax,%eax
  803632:	74 0f                	je     803643 <insert_sorted_with_merge_freeList+0x3d9>
  803634:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803637:	8b 40 04             	mov    0x4(%eax),%eax
  80363a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80363d:	8b 12                	mov    (%edx),%edx
  80363f:	89 10                	mov    %edx,(%eax)
  803641:	eb 0a                	jmp    80364d <insert_sorted_with_merge_freeList+0x3e3>
  803643:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803646:	8b 00                	mov    (%eax),%eax
  803648:	a3 38 51 80 00       	mov    %eax,0x805138
  80364d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803659:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803660:	a1 44 51 80 00       	mov    0x805144,%eax
  803665:	48                   	dec    %eax
  803666:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80366b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803675:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803678:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80367f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803683:	75 17                	jne    80369c <insert_sorted_with_merge_freeList+0x432>
  803685:	83 ec 04             	sub    $0x4,%esp
  803688:	68 34 45 80 00       	push   $0x804534
  80368d:	68 5f 01 00 00       	push   $0x15f
  803692:	68 57 45 80 00       	push   $0x804557
  803697:	e8 ff d0 ff ff       	call   80079b <_panic>
  80369c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a5:	89 10                	mov    %edx,(%eax)
  8036a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036aa:	8b 00                	mov    (%eax),%eax
  8036ac:	85 c0                	test   %eax,%eax
  8036ae:	74 0d                	je     8036bd <insert_sorted_with_merge_freeList+0x453>
  8036b0:	a1 48 51 80 00       	mov    0x805148,%eax
  8036b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036b8:	89 50 04             	mov    %edx,0x4(%eax)
  8036bb:	eb 08                	jmp    8036c5 <insert_sorted_with_merge_freeList+0x45b>
  8036bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8036cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d7:	a1 54 51 80 00       	mov    0x805154,%eax
  8036dc:	40                   	inc    %eax
  8036dd:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8036e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e5:	8b 50 0c             	mov    0xc(%eax),%edx
  8036e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ee:	01 c2                	add    %eax,%edx
  8036f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f3:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8036f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803700:	8b 45 08             	mov    0x8(%ebp),%eax
  803703:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80370a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80370e:	75 17                	jne    803727 <insert_sorted_with_merge_freeList+0x4bd>
  803710:	83 ec 04             	sub    $0x4,%esp
  803713:	68 34 45 80 00       	push   $0x804534
  803718:	68 64 01 00 00       	push   $0x164
  80371d:	68 57 45 80 00       	push   $0x804557
  803722:	e8 74 d0 ff ff       	call   80079b <_panic>
  803727:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80372d:	8b 45 08             	mov    0x8(%ebp),%eax
  803730:	89 10                	mov    %edx,(%eax)
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	8b 00                	mov    (%eax),%eax
  803737:	85 c0                	test   %eax,%eax
  803739:	74 0d                	je     803748 <insert_sorted_with_merge_freeList+0x4de>
  80373b:	a1 48 51 80 00       	mov    0x805148,%eax
  803740:	8b 55 08             	mov    0x8(%ebp),%edx
  803743:	89 50 04             	mov    %edx,0x4(%eax)
  803746:	eb 08                	jmp    803750 <insert_sorted_with_merge_freeList+0x4e6>
  803748:	8b 45 08             	mov    0x8(%ebp),%eax
  80374b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803750:	8b 45 08             	mov    0x8(%ebp),%eax
  803753:	a3 48 51 80 00       	mov    %eax,0x805148
  803758:	8b 45 08             	mov    0x8(%ebp),%eax
  80375b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803762:	a1 54 51 80 00       	mov    0x805154,%eax
  803767:	40                   	inc    %eax
  803768:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80376d:	e9 41 02 00 00       	jmp    8039b3 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803772:	8b 45 08             	mov    0x8(%ebp),%eax
  803775:	8b 50 08             	mov    0x8(%eax),%edx
  803778:	8b 45 08             	mov    0x8(%ebp),%eax
  80377b:	8b 40 0c             	mov    0xc(%eax),%eax
  80377e:	01 c2                	add    %eax,%edx
  803780:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803783:	8b 40 08             	mov    0x8(%eax),%eax
  803786:	39 c2                	cmp    %eax,%edx
  803788:	0f 85 7c 01 00 00    	jne    80390a <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80378e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803792:	74 06                	je     80379a <insert_sorted_with_merge_freeList+0x530>
  803794:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803798:	75 17                	jne    8037b1 <insert_sorted_with_merge_freeList+0x547>
  80379a:	83 ec 04             	sub    $0x4,%esp
  80379d:	68 70 45 80 00       	push   $0x804570
  8037a2:	68 69 01 00 00       	push   $0x169
  8037a7:	68 57 45 80 00       	push   $0x804557
  8037ac:	e8 ea cf ff ff       	call   80079b <_panic>
  8037b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b4:	8b 50 04             	mov    0x4(%eax),%edx
  8037b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ba:	89 50 04             	mov    %edx,0x4(%eax)
  8037bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037c3:	89 10                	mov    %edx,(%eax)
  8037c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c8:	8b 40 04             	mov    0x4(%eax),%eax
  8037cb:	85 c0                	test   %eax,%eax
  8037cd:	74 0d                	je     8037dc <insert_sorted_with_merge_freeList+0x572>
  8037cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d2:	8b 40 04             	mov    0x4(%eax),%eax
  8037d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d8:	89 10                	mov    %edx,(%eax)
  8037da:	eb 08                	jmp    8037e4 <insert_sorted_with_merge_freeList+0x57a>
  8037dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037df:	a3 38 51 80 00       	mov    %eax,0x805138
  8037e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ea:	89 50 04             	mov    %edx,0x4(%eax)
  8037ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8037f2:	40                   	inc    %eax
  8037f3:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8037f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8037fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803801:	8b 40 0c             	mov    0xc(%eax),%eax
  803804:	01 c2                	add    %eax,%edx
  803806:	8b 45 08             	mov    0x8(%ebp),%eax
  803809:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80380c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803810:	75 17                	jne    803829 <insert_sorted_with_merge_freeList+0x5bf>
  803812:	83 ec 04             	sub    $0x4,%esp
  803815:	68 00 46 80 00       	push   $0x804600
  80381a:	68 6b 01 00 00       	push   $0x16b
  80381f:	68 57 45 80 00       	push   $0x804557
  803824:	e8 72 cf ff ff       	call   80079b <_panic>
  803829:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382c:	8b 00                	mov    (%eax),%eax
  80382e:	85 c0                	test   %eax,%eax
  803830:	74 10                	je     803842 <insert_sorted_with_merge_freeList+0x5d8>
  803832:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803835:	8b 00                	mov    (%eax),%eax
  803837:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80383a:	8b 52 04             	mov    0x4(%edx),%edx
  80383d:	89 50 04             	mov    %edx,0x4(%eax)
  803840:	eb 0b                	jmp    80384d <insert_sorted_with_merge_freeList+0x5e3>
  803842:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803845:	8b 40 04             	mov    0x4(%eax),%eax
  803848:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80384d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803850:	8b 40 04             	mov    0x4(%eax),%eax
  803853:	85 c0                	test   %eax,%eax
  803855:	74 0f                	je     803866 <insert_sorted_with_merge_freeList+0x5fc>
  803857:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385a:	8b 40 04             	mov    0x4(%eax),%eax
  80385d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803860:	8b 12                	mov    (%edx),%edx
  803862:	89 10                	mov    %edx,(%eax)
  803864:	eb 0a                	jmp    803870 <insert_sorted_with_merge_freeList+0x606>
  803866:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803869:	8b 00                	mov    (%eax),%eax
  80386b:	a3 38 51 80 00       	mov    %eax,0x805138
  803870:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803873:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803879:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803883:	a1 44 51 80 00       	mov    0x805144,%eax
  803888:	48                   	dec    %eax
  803889:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80388e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803891:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803898:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8038a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038a6:	75 17                	jne    8038bf <insert_sorted_with_merge_freeList+0x655>
  8038a8:	83 ec 04             	sub    $0x4,%esp
  8038ab:	68 34 45 80 00       	push   $0x804534
  8038b0:	68 6e 01 00 00       	push   $0x16e
  8038b5:	68 57 45 80 00       	push   $0x804557
  8038ba:	e8 dc ce ff ff       	call   80079b <_panic>
  8038bf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c8:	89 10                	mov    %edx,(%eax)
  8038ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038cd:	8b 00                	mov    (%eax),%eax
  8038cf:	85 c0                	test   %eax,%eax
  8038d1:	74 0d                	je     8038e0 <insert_sorted_with_merge_freeList+0x676>
  8038d3:	a1 48 51 80 00       	mov    0x805148,%eax
  8038d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038db:	89 50 04             	mov    %edx,0x4(%eax)
  8038de:	eb 08                	jmp    8038e8 <insert_sorted_with_merge_freeList+0x67e>
  8038e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8038f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8038ff:	40                   	inc    %eax
  803900:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803905:	e9 a9 00 00 00       	jmp    8039b3 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80390a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80390e:	74 06                	je     803916 <insert_sorted_with_merge_freeList+0x6ac>
  803910:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803914:	75 17                	jne    80392d <insert_sorted_with_merge_freeList+0x6c3>
  803916:	83 ec 04             	sub    $0x4,%esp
  803919:	68 cc 45 80 00       	push   $0x8045cc
  80391e:	68 73 01 00 00       	push   $0x173
  803923:	68 57 45 80 00       	push   $0x804557
  803928:	e8 6e ce ff ff       	call   80079b <_panic>
  80392d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803930:	8b 10                	mov    (%eax),%edx
  803932:	8b 45 08             	mov    0x8(%ebp),%eax
  803935:	89 10                	mov    %edx,(%eax)
  803937:	8b 45 08             	mov    0x8(%ebp),%eax
  80393a:	8b 00                	mov    (%eax),%eax
  80393c:	85 c0                	test   %eax,%eax
  80393e:	74 0b                	je     80394b <insert_sorted_with_merge_freeList+0x6e1>
  803940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803943:	8b 00                	mov    (%eax),%eax
  803945:	8b 55 08             	mov    0x8(%ebp),%edx
  803948:	89 50 04             	mov    %edx,0x4(%eax)
  80394b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394e:	8b 55 08             	mov    0x8(%ebp),%edx
  803951:	89 10                	mov    %edx,(%eax)
  803953:	8b 45 08             	mov    0x8(%ebp),%eax
  803956:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803959:	89 50 04             	mov    %edx,0x4(%eax)
  80395c:	8b 45 08             	mov    0x8(%ebp),%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	85 c0                	test   %eax,%eax
  803963:	75 08                	jne    80396d <insert_sorted_with_merge_freeList+0x703>
  803965:	8b 45 08             	mov    0x8(%ebp),%eax
  803968:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80396d:	a1 44 51 80 00       	mov    0x805144,%eax
  803972:	40                   	inc    %eax
  803973:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803978:	eb 39                	jmp    8039b3 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80397a:	a1 40 51 80 00       	mov    0x805140,%eax
  80397f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803982:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803986:	74 07                	je     80398f <insert_sorted_with_merge_freeList+0x725>
  803988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398b:	8b 00                	mov    (%eax),%eax
  80398d:	eb 05                	jmp    803994 <insert_sorted_with_merge_freeList+0x72a>
  80398f:	b8 00 00 00 00       	mov    $0x0,%eax
  803994:	a3 40 51 80 00       	mov    %eax,0x805140
  803999:	a1 40 51 80 00       	mov    0x805140,%eax
  80399e:	85 c0                	test   %eax,%eax
  8039a0:	0f 85 c7 fb ff ff    	jne    80356d <insert_sorted_with_merge_freeList+0x303>
  8039a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039aa:	0f 85 bd fb ff ff    	jne    80356d <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039b0:	eb 01                	jmp    8039b3 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8039b2:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039b3:	90                   	nop
  8039b4:	c9                   	leave  
  8039b5:	c3                   	ret    
  8039b6:	66 90                	xchg   %ax,%ax

008039b8 <__udivdi3>:
  8039b8:	55                   	push   %ebp
  8039b9:	57                   	push   %edi
  8039ba:	56                   	push   %esi
  8039bb:	53                   	push   %ebx
  8039bc:	83 ec 1c             	sub    $0x1c,%esp
  8039bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039cf:	89 ca                	mov    %ecx,%edx
  8039d1:	89 f8                	mov    %edi,%eax
  8039d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039d7:	85 f6                	test   %esi,%esi
  8039d9:	75 2d                	jne    803a08 <__udivdi3+0x50>
  8039db:	39 cf                	cmp    %ecx,%edi
  8039dd:	77 65                	ja     803a44 <__udivdi3+0x8c>
  8039df:	89 fd                	mov    %edi,%ebp
  8039e1:	85 ff                	test   %edi,%edi
  8039e3:	75 0b                	jne    8039f0 <__udivdi3+0x38>
  8039e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8039ea:	31 d2                	xor    %edx,%edx
  8039ec:	f7 f7                	div    %edi
  8039ee:	89 c5                	mov    %eax,%ebp
  8039f0:	31 d2                	xor    %edx,%edx
  8039f2:	89 c8                	mov    %ecx,%eax
  8039f4:	f7 f5                	div    %ebp
  8039f6:	89 c1                	mov    %eax,%ecx
  8039f8:	89 d8                	mov    %ebx,%eax
  8039fa:	f7 f5                	div    %ebp
  8039fc:	89 cf                	mov    %ecx,%edi
  8039fe:	89 fa                	mov    %edi,%edx
  803a00:	83 c4 1c             	add    $0x1c,%esp
  803a03:	5b                   	pop    %ebx
  803a04:	5e                   	pop    %esi
  803a05:	5f                   	pop    %edi
  803a06:	5d                   	pop    %ebp
  803a07:	c3                   	ret    
  803a08:	39 ce                	cmp    %ecx,%esi
  803a0a:	77 28                	ja     803a34 <__udivdi3+0x7c>
  803a0c:	0f bd fe             	bsr    %esi,%edi
  803a0f:	83 f7 1f             	xor    $0x1f,%edi
  803a12:	75 40                	jne    803a54 <__udivdi3+0x9c>
  803a14:	39 ce                	cmp    %ecx,%esi
  803a16:	72 0a                	jb     803a22 <__udivdi3+0x6a>
  803a18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a1c:	0f 87 9e 00 00 00    	ja     803ac0 <__udivdi3+0x108>
  803a22:	b8 01 00 00 00       	mov    $0x1,%eax
  803a27:	89 fa                	mov    %edi,%edx
  803a29:	83 c4 1c             	add    $0x1c,%esp
  803a2c:	5b                   	pop    %ebx
  803a2d:	5e                   	pop    %esi
  803a2e:	5f                   	pop    %edi
  803a2f:	5d                   	pop    %ebp
  803a30:	c3                   	ret    
  803a31:	8d 76 00             	lea    0x0(%esi),%esi
  803a34:	31 ff                	xor    %edi,%edi
  803a36:	31 c0                	xor    %eax,%eax
  803a38:	89 fa                	mov    %edi,%edx
  803a3a:	83 c4 1c             	add    $0x1c,%esp
  803a3d:	5b                   	pop    %ebx
  803a3e:	5e                   	pop    %esi
  803a3f:	5f                   	pop    %edi
  803a40:	5d                   	pop    %ebp
  803a41:	c3                   	ret    
  803a42:	66 90                	xchg   %ax,%ax
  803a44:	89 d8                	mov    %ebx,%eax
  803a46:	f7 f7                	div    %edi
  803a48:	31 ff                	xor    %edi,%edi
  803a4a:	89 fa                	mov    %edi,%edx
  803a4c:	83 c4 1c             	add    $0x1c,%esp
  803a4f:	5b                   	pop    %ebx
  803a50:	5e                   	pop    %esi
  803a51:	5f                   	pop    %edi
  803a52:	5d                   	pop    %ebp
  803a53:	c3                   	ret    
  803a54:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a59:	89 eb                	mov    %ebp,%ebx
  803a5b:	29 fb                	sub    %edi,%ebx
  803a5d:	89 f9                	mov    %edi,%ecx
  803a5f:	d3 e6                	shl    %cl,%esi
  803a61:	89 c5                	mov    %eax,%ebp
  803a63:	88 d9                	mov    %bl,%cl
  803a65:	d3 ed                	shr    %cl,%ebp
  803a67:	89 e9                	mov    %ebp,%ecx
  803a69:	09 f1                	or     %esi,%ecx
  803a6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a6f:	89 f9                	mov    %edi,%ecx
  803a71:	d3 e0                	shl    %cl,%eax
  803a73:	89 c5                	mov    %eax,%ebp
  803a75:	89 d6                	mov    %edx,%esi
  803a77:	88 d9                	mov    %bl,%cl
  803a79:	d3 ee                	shr    %cl,%esi
  803a7b:	89 f9                	mov    %edi,%ecx
  803a7d:	d3 e2                	shl    %cl,%edx
  803a7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a83:	88 d9                	mov    %bl,%cl
  803a85:	d3 e8                	shr    %cl,%eax
  803a87:	09 c2                	or     %eax,%edx
  803a89:	89 d0                	mov    %edx,%eax
  803a8b:	89 f2                	mov    %esi,%edx
  803a8d:	f7 74 24 0c          	divl   0xc(%esp)
  803a91:	89 d6                	mov    %edx,%esi
  803a93:	89 c3                	mov    %eax,%ebx
  803a95:	f7 e5                	mul    %ebp
  803a97:	39 d6                	cmp    %edx,%esi
  803a99:	72 19                	jb     803ab4 <__udivdi3+0xfc>
  803a9b:	74 0b                	je     803aa8 <__udivdi3+0xf0>
  803a9d:	89 d8                	mov    %ebx,%eax
  803a9f:	31 ff                	xor    %edi,%edi
  803aa1:	e9 58 ff ff ff       	jmp    8039fe <__udivdi3+0x46>
  803aa6:	66 90                	xchg   %ax,%ax
  803aa8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803aac:	89 f9                	mov    %edi,%ecx
  803aae:	d3 e2                	shl    %cl,%edx
  803ab0:	39 c2                	cmp    %eax,%edx
  803ab2:	73 e9                	jae    803a9d <__udivdi3+0xe5>
  803ab4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ab7:	31 ff                	xor    %edi,%edi
  803ab9:	e9 40 ff ff ff       	jmp    8039fe <__udivdi3+0x46>
  803abe:	66 90                	xchg   %ax,%ax
  803ac0:	31 c0                	xor    %eax,%eax
  803ac2:	e9 37 ff ff ff       	jmp    8039fe <__udivdi3+0x46>
  803ac7:	90                   	nop

00803ac8 <__umoddi3>:
  803ac8:	55                   	push   %ebp
  803ac9:	57                   	push   %edi
  803aca:	56                   	push   %esi
  803acb:	53                   	push   %ebx
  803acc:	83 ec 1c             	sub    $0x1c,%esp
  803acf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ad3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ad7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803adb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803adf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ae3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ae7:	89 f3                	mov    %esi,%ebx
  803ae9:	89 fa                	mov    %edi,%edx
  803aeb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aef:	89 34 24             	mov    %esi,(%esp)
  803af2:	85 c0                	test   %eax,%eax
  803af4:	75 1a                	jne    803b10 <__umoddi3+0x48>
  803af6:	39 f7                	cmp    %esi,%edi
  803af8:	0f 86 a2 00 00 00    	jbe    803ba0 <__umoddi3+0xd8>
  803afe:	89 c8                	mov    %ecx,%eax
  803b00:	89 f2                	mov    %esi,%edx
  803b02:	f7 f7                	div    %edi
  803b04:	89 d0                	mov    %edx,%eax
  803b06:	31 d2                	xor    %edx,%edx
  803b08:	83 c4 1c             	add    $0x1c,%esp
  803b0b:	5b                   	pop    %ebx
  803b0c:	5e                   	pop    %esi
  803b0d:	5f                   	pop    %edi
  803b0e:	5d                   	pop    %ebp
  803b0f:	c3                   	ret    
  803b10:	39 f0                	cmp    %esi,%eax
  803b12:	0f 87 ac 00 00 00    	ja     803bc4 <__umoddi3+0xfc>
  803b18:	0f bd e8             	bsr    %eax,%ebp
  803b1b:	83 f5 1f             	xor    $0x1f,%ebp
  803b1e:	0f 84 ac 00 00 00    	je     803bd0 <__umoddi3+0x108>
  803b24:	bf 20 00 00 00       	mov    $0x20,%edi
  803b29:	29 ef                	sub    %ebp,%edi
  803b2b:	89 fe                	mov    %edi,%esi
  803b2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b31:	89 e9                	mov    %ebp,%ecx
  803b33:	d3 e0                	shl    %cl,%eax
  803b35:	89 d7                	mov    %edx,%edi
  803b37:	89 f1                	mov    %esi,%ecx
  803b39:	d3 ef                	shr    %cl,%edi
  803b3b:	09 c7                	or     %eax,%edi
  803b3d:	89 e9                	mov    %ebp,%ecx
  803b3f:	d3 e2                	shl    %cl,%edx
  803b41:	89 14 24             	mov    %edx,(%esp)
  803b44:	89 d8                	mov    %ebx,%eax
  803b46:	d3 e0                	shl    %cl,%eax
  803b48:	89 c2                	mov    %eax,%edx
  803b4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b4e:	d3 e0                	shl    %cl,%eax
  803b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b54:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b58:	89 f1                	mov    %esi,%ecx
  803b5a:	d3 e8                	shr    %cl,%eax
  803b5c:	09 d0                	or     %edx,%eax
  803b5e:	d3 eb                	shr    %cl,%ebx
  803b60:	89 da                	mov    %ebx,%edx
  803b62:	f7 f7                	div    %edi
  803b64:	89 d3                	mov    %edx,%ebx
  803b66:	f7 24 24             	mull   (%esp)
  803b69:	89 c6                	mov    %eax,%esi
  803b6b:	89 d1                	mov    %edx,%ecx
  803b6d:	39 d3                	cmp    %edx,%ebx
  803b6f:	0f 82 87 00 00 00    	jb     803bfc <__umoddi3+0x134>
  803b75:	0f 84 91 00 00 00    	je     803c0c <__umoddi3+0x144>
  803b7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b7f:	29 f2                	sub    %esi,%edx
  803b81:	19 cb                	sbb    %ecx,%ebx
  803b83:	89 d8                	mov    %ebx,%eax
  803b85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b89:	d3 e0                	shl    %cl,%eax
  803b8b:	89 e9                	mov    %ebp,%ecx
  803b8d:	d3 ea                	shr    %cl,%edx
  803b8f:	09 d0                	or     %edx,%eax
  803b91:	89 e9                	mov    %ebp,%ecx
  803b93:	d3 eb                	shr    %cl,%ebx
  803b95:	89 da                	mov    %ebx,%edx
  803b97:	83 c4 1c             	add    $0x1c,%esp
  803b9a:	5b                   	pop    %ebx
  803b9b:	5e                   	pop    %esi
  803b9c:	5f                   	pop    %edi
  803b9d:	5d                   	pop    %ebp
  803b9e:	c3                   	ret    
  803b9f:	90                   	nop
  803ba0:	89 fd                	mov    %edi,%ebp
  803ba2:	85 ff                	test   %edi,%edi
  803ba4:	75 0b                	jne    803bb1 <__umoddi3+0xe9>
  803ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bab:	31 d2                	xor    %edx,%edx
  803bad:	f7 f7                	div    %edi
  803baf:	89 c5                	mov    %eax,%ebp
  803bb1:	89 f0                	mov    %esi,%eax
  803bb3:	31 d2                	xor    %edx,%edx
  803bb5:	f7 f5                	div    %ebp
  803bb7:	89 c8                	mov    %ecx,%eax
  803bb9:	f7 f5                	div    %ebp
  803bbb:	89 d0                	mov    %edx,%eax
  803bbd:	e9 44 ff ff ff       	jmp    803b06 <__umoddi3+0x3e>
  803bc2:	66 90                	xchg   %ax,%ax
  803bc4:	89 c8                	mov    %ecx,%eax
  803bc6:	89 f2                	mov    %esi,%edx
  803bc8:	83 c4 1c             	add    $0x1c,%esp
  803bcb:	5b                   	pop    %ebx
  803bcc:	5e                   	pop    %esi
  803bcd:	5f                   	pop    %edi
  803bce:	5d                   	pop    %ebp
  803bcf:	c3                   	ret    
  803bd0:	3b 04 24             	cmp    (%esp),%eax
  803bd3:	72 06                	jb     803bdb <__umoddi3+0x113>
  803bd5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bd9:	77 0f                	ja     803bea <__umoddi3+0x122>
  803bdb:	89 f2                	mov    %esi,%edx
  803bdd:	29 f9                	sub    %edi,%ecx
  803bdf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803be3:	89 14 24             	mov    %edx,(%esp)
  803be6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bea:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bee:	8b 14 24             	mov    (%esp),%edx
  803bf1:	83 c4 1c             	add    $0x1c,%esp
  803bf4:	5b                   	pop    %ebx
  803bf5:	5e                   	pop    %esi
  803bf6:	5f                   	pop    %edi
  803bf7:	5d                   	pop    %ebp
  803bf8:	c3                   	ret    
  803bf9:	8d 76 00             	lea    0x0(%esi),%esi
  803bfc:	2b 04 24             	sub    (%esp),%eax
  803bff:	19 fa                	sbb    %edi,%edx
  803c01:	89 d1                	mov    %edx,%ecx
  803c03:	89 c6                	mov    %eax,%esi
  803c05:	e9 71 ff ff ff       	jmp    803b7b <__umoddi3+0xb3>
  803c0a:	66 90                	xchg   %ax,%ax
  803c0c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c10:	72 ea                	jb     803bfc <__umoddi3+0x134>
  803c12:	89 d9                	mov    %ebx,%ecx
  803c14:	e9 62 ff ff ff       	jmp    803b7b <__umoddi3+0xb3>
