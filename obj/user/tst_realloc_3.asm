
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
  800062:	68 c0 3a 80 00       	push   $0x803ac0
  800067:	e8 e3 09 00 00       	call   800a4f <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 10 1c 00 00       	call   801c84 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 a8 1c 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
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
  8000ab:	68 e4 3a 80 00       	push   $0x803ae4
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 14 3b 80 00       	push   $0x803b14
  8000b7:	e8 df 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 c0 1b 00 00       	call   801c84 <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 2c 3b 80 00       	push   $0x803b2c
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 14 3b 80 00       	push   $0x803b14
  8000dc:	e8 ba 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 3e 1c 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 98 3b 80 00       	push   $0x803b98
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 14 3b 80 00       	push   $0x803b14
  8000fd:	e8 99 06 00 00       	call   80079b <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 7d 1b 00 00       	call   801c84 <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 15 1c 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
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
  800156:	68 e4 3a 80 00       	push   $0x803ae4
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 14 3b 80 00       	push   $0x803b14
  800162:	e8 34 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 18 1b 00 00       	call   801c84 <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 2c 3b 80 00       	push   $0x803b2c
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 14 3b 80 00       	push   $0x803b14
  800184:	e8 12 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 96 1b 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 98 3b 80 00       	push   $0x803b98
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 14 3b 80 00       	push   $0x803b14
  8001a5:	e8 f1 05 00 00       	call   80079b <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 d5 1a 00 00       	call   801c84 <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 6d 1b 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
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
  800201:	68 e4 3a 80 00       	push   $0x803ae4
  800206:	6a 23                	push   $0x23
  800208:	68 14 3b 80 00       	push   $0x803b14
  80020d:	e8 89 05 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 6d 1a 00 00       	call   801c84 <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 2c 3b 80 00       	push   $0x803b2c
  800228:	6a 25                	push   $0x25
  80022a:	68 14 3b 80 00       	push   $0x803b14
  80022f:	e8 67 05 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 eb 1a 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 98 3b 80 00       	push   $0x803b98
  800249:	6a 26                	push   $0x26
  80024b:	68 14 3b 80 00       	push   $0x803b14
  800250:	e8 46 05 00 00       	call   80079b <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 2a 1a 00 00       	call   801c84 <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 c2 1a 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
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
  8002a8:	68 e4 3a 80 00       	push   $0x803ae4
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 14 3b 80 00       	push   $0x803b14
  8002b4:	e8 e2 04 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 c6 19 00 00       	call   801c84 <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 2c 3b 80 00       	push   $0x803b2c
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 14 3b 80 00       	push   $0x803b14
  8002d6:	e8 c0 04 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 44 1a 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 98 3b 80 00       	push   $0x803b98
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 14 3b 80 00       	push   $0x803b14
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
  800422:	e8 5d 18 00 00       	call   801c84 <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 f5 18 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
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
  800450:	e8 ad 16 00 00       	call   801b02 <realloc>
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
  800478:	68 c8 3b 80 00       	push   $0x803bc8
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 14 3b 80 00       	push   $0x803b14
  800484:	e8 12 03 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 96 18 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 fc 3b 80 00       	push   $0x803bfc
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 14 3b 80 00       	push   $0x803b14
  8004a5:	e8 f1 02 00 00       	call   80079b <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 2d 3c 80 00       	push   $0x803c2d
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
  800501:	68 34 3c 80 00       	push   $0x803c34
  800506:	6a 7a                	push   $0x7a
  800508:	68 14 3b 80 00       	push   $0x803b14
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
  800559:	68 34 3c 80 00       	push   $0x803c34
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 14 3b 80 00       	push   $0x803b14
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
  8005bb:	68 34 3c 80 00       	push   $0x803c34
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 14 3b 80 00       	push   $0x803b14
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
  800616:	68 34 3c 80 00       	push   $0x803c34
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 14 3b 80 00       	push   $0x803b14
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
  80063a:	68 6c 3c 80 00       	push   $0x803c6c
  80063f:	e8 a0 03 00 00       	call   8009e4 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 78 3c 80 00       	push   $0x803c78
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
  800665:	e8 fa 18 00 00       	call   801f64 <sys_getenvindex>
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
  8006d0:	e8 9c 16 00 00       	call   801d71 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	68 cc 3c 80 00       	push   $0x803ccc
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
  800700:	68 f4 3c 80 00       	push   $0x803cf4
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
  800731:	68 1c 3d 80 00       	push   $0x803d1c
  800736:	e8 14 03 00 00       	call   800a4f <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073e:	a1 20 50 80 00       	mov    0x805020,%eax
  800743:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	50                   	push   %eax
  80074d:	68 74 3d 80 00       	push   $0x803d74
  800752:	e8 f8 02 00 00       	call   800a4f <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	68 cc 3c 80 00       	push   $0x803ccc
  800762:	e8 e8 02 00 00       	call   800a4f <cprintf>
  800767:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80076a:	e8 1c 16 00 00       	call   801d8b <sys_enable_interrupt>

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
  800782:	e8 a9 17 00 00       	call   801f30 <sys_destroy_env>
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
  800793:	e8 fe 17 00 00       	call   801f96 <sys_exit_env>
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
  8007bc:	68 88 3d 80 00       	push   $0x803d88
  8007c1:	e8 89 02 00 00       	call   800a4f <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c9:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	68 8d 3d 80 00       	push   $0x803d8d
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
  8007f9:	68 a9 3d 80 00       	push   $0x803da9
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
  800825:	68 ac 3d 80 00       	push   $0x803dac
  80082a:	6a 26                	push   $0x26
  80082c:	68 f8 3d 80 00       	push   $0x803df8
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
  8008f7:	68 04 3e 80 00       	push   $0x803e04
  8008fc:	6a 3a                	push   $0x3a
  8008fe:	68 f8 3d 80 00       	push   $0x803df8
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
  800967:	68 58 3e 80 00       	push   $0x803e58
  80096c:	6a 44                	push   $0x44
  80096e:	68 f8 3d 80 00       	push   $0x803df8
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
  8009c1:	e8 fd 11 00 00       	call   801bc3 <sys_cputs>
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
  800a38:	e8 86 11 00 00       	call   801bc3 <sys_cputs>
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
  800a82:	e8 ea 12 00 00       	call   801d71 <sys_disable_interrupt>
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
  800aa2:	e8 e4 12 00 00       	call   801d8b <sys_enable_interrupt>
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
  800aec:	e8 57 2d 00 00       	call   803848 <__udivdi3>
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
  800b3c:	e8 17 2e 00 00       	call   803958 <__umoddi3>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	05 d4 40 80 00       	add    $0x8040d4,%eax
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
  800c97:	8b 04 85 f8 40 80 00 	mov    0x8040f8(,%eax,4),%eax
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
  800d78:	8b 34 9d 40 3f 80 00 	mov    0x803f40(,%ebx,4),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 19                	jne    800d9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d83:	53                   	push   %ebx
  800d84:	68 e5 40 80 00       	push   $0x8040e5
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
  800d9d:	68 ee 40 80 00       	push   $0x8040ee
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
  800dca:	be f1 40 80 00       	mov    $0x8040f1,%esi
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
  8017f0:	68 50 42 80 00       	push   $0x804250
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
  8018c0:	e8 42 04 00 00       	call   801d07 <sys_allocate_chunk>
  8018c5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018c8:	a1 20 51 80 00       	mov    0x805120,%eax
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	50                   	push   %eax
  8018d1:	e8 b7 0a 00 00       	call   80238d <initialize_MemBlocksList>
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
  8018fe:	68 75 42 80 00       	push   $0x804275
  801903:	6a 33                	push   $0x33
  801905:	68 93 42 80 00       	push   $0x804293
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
  80197d:	68 a0 42 80 00       	push   $0x8042a0
  801982:	6a 34                	push   $0x34
  801984:	68 93 42 80 00       	push   $0x804293
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
  8019f2:	68 c4 42 80 00       	push   $0x8042c4
  8019f7:	6a 46                	push   $0x46
  8019f9:	68 93 42 80 00       	push   $0x804293
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
  801a0e:	68 ec 42 80 00       	push   $0x8042ec
  801a13:	6a 61                	push   $0x61
  801a15:	68 93 42 80 00       	push   $0x804293
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
  801a34:	75 0a                	jne    801a40 <smalloc+0x21>
  801a36:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3b:	e9 9e 00 00 00       	jmp    801ade <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a40:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4d:	01 d0                	add    %edx,%eax
  801a4f:	48                   	dec    %eax
  801a50:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a56:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5b:	f7 75 f0             	divl   -0x10(%ebp)
  801a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a61:	29 d0                	sub    %edx,%eax
  801a63:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801a66:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a6d:	e8 63 06 00 00       	call   8020d5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a72:	85 c0                	test   %eax,%eax
  801a74:	74 11                	je     801a87 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801a76:	83 ec 0c             	sub    $0xc,%esp
  801a79:	ff 75 e8             	pushl  -0x18(%ebp)
  801a7c:	e8 ce 0c 00 00       	call   80274f <alloc_block_FF>
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a8b:	74 4c                	je     801ad9 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a90:	8b 40 08             	mov    0x8(%eax),%eax
  801a93:	89 c2                	mov    %eax,%edx
  801a95:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	e8 b4 03 00 00       	call   801e5a <sys_createSharedObject>
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801aac:	83 ec 08             	sub    $0x8,%esp
  801aaf:	ff 75 e0             	pushl  -0x20(%ebp)
  801ab2:	68 0f 43 80 00       	push   $0x80430f
  801ab7:	e8 93 ef ff ff       	call   800a4f <cprintf>
  801abc:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801abf:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801ac3:	74 14                	je     801ad9 <smalloc+0xba>
  801ac5:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801ac9:	74 0e                	je     801ad9 <smalloc+0xba>
  801acb:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801acf:	74 08                	je     801ad9 <smalloc+0xba>
			return (void*) mem_block->sva;
  801ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad4:	8b 40 08             	mov    0x8(%eax),%eax
  801ad7:	eb 05                	jmp    801ade <smalloc+0xbf>
	}
	return NULL;
  801ad9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ae6:	e8 ee fc ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	68 24 43 80 00       	push   $0x804324
  801af3:	68 ab 00 00 00       	push   $0xab
  801af8:	68 93 42 80 00       	push   $0x804293
  801afd:	e8 99 ec ff ff       	call   80079b <_panic>

00801b02 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b08:	e8 cc fc ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b0d:	83 ec 04             	sub    $0x4,%esp
  801b10:	68 48 43 80 00       	push   $0x804348
  801b15:	68 ef 00 00 00       	push   $0xef
  801b1a:	68 93 42 80 00       	push   $0x804293
  801b1f:	e8 77 ec ff ff       	call   80079b <_panic>

00801b24 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	68 70 43 80 00       	push   $0x804370
  801b32:	68 03 01 00 00       	push   $0x103
  801b37:	68 93 42 80 00       	push   $0x804293
  801b3c:	e8 5a ec ff ff       	call   80079b <_panic>

00801b41 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	68 94 43 80 00       	push   $0x804394
  801b4f:	68 0e 01 00 00       	push   $0x10e
  801b54:	68 93 42 80 00       	push   $0x804293
  801b59:	e8 3d ec ff ff       	call   80079b <_panic>

00801b5e <shrink>:

}
void shrink(uint32 newSize)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	68 94 43 80 00       	push   $0x804394
  801b6c:	68 13 01 00 00       	push   $0x113
  801b71:	68 93 42 80 00       	push   $0x804293
  801b76:	e8 20 ec ff ff       	call   80079b <_panic>

00801b7b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b81:	83 ec 04             	sub    $0x4,%esp
  801b84:	68 94 43 80 00       	push   $0x804394
  801b89:	68 18 01 00 00       	push   $0x118
  801b8e:	68 93 42 80 00       	push   $0x804293
  801b93:	e8 03 ec ff ff       	call   80079b <_panic>

00801b98 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	57                   	push   %edi
  801b9c:	56                   	push   %esi
  801b9d:	53                   	push   %ebx
  801b9e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801baa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bad:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bb0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bb3:	cd 30                	int    $0x30
  801bb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bbb:	83 c4 10             	add    $0x10,%esp
  801bbe:	5b                   	pop    %ebx
  801bbf:	5e                   	pop    %esi
  801bc0:	5f                   	pop    %edi
  801bc1:	5d                   	pop    %ebp
  801bc2:	c3                   	ret    

00801bc3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 04             	sub    $0x4,%esp
  801bc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bcc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801bcf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	52                   	push   %edx
  801bdb:	ff 75 0c             	pushl  0xc(%ebp)
  801bde:	50                   	push   %eax
  801bdf:	6a 00                	push   $0x0
  801be1:	e8 b2 ff ff ff       	call   801b98 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	90                   	nop
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_cgetc>:

int
sys_cgetc(void)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 01                	push   $0x1
  801bfb:	e8 98 ff ff ff       	call   801b98 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	52                   	push   %edx
  801c15:	50                   	push   %eax
  801c16:	6a 05                	push   $0x5
  801c18:	e8 7b ff ff ff       	call   801b98 <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	56                   	push   %esi
  801c26:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c27:	8b 75 18             	mov    0x18(%ebp),%esi
  801c2a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	56                   	push   %esi
  801c37:	53                   	push   %ebx
  801c38:	51                   	push   %ecx
  801c39:	52                   	push   %edx
  801c3a:	50                   	push   %eax
  801c3b:	6a 06                	push   $0x6
  801c3d:	e8 56 ff ff ff       	call   801b98 <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
}
  801c45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c48:	5b                   	pop    %ebx
  801c49:	5e                   	pop    %esi
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    

00801c4c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	52                   	push   %edx
  801c5c:	50                   	push   %eax
  801c5d:	6a 07                	push   $0x7
  801c5f:	e8 34 ff ff ff       	call   801b98 <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	ff 75 0c             	pushl  0xc(%ebp)
  801c75:	ff 75 08             	pushl  0x8(%ebp)
  801c78:	6a 08                	push   $0x8
  801c7a:	e8 19 ff ff ff       	call   801b98 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 09                	push   $0x9
  801c93:	e8 00 ff ff ff       	call   801b98 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 0a                	push   $0xa
  801cac:	e8 e7 fe ff ff       	call   801b98 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 0b                	push   $0xb
  801cc5:	e8 ce fe ff ff       	call   801b98 <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	ff 75 0c             	pushl  0xc(%ebp)
  801cdb:	ff 75 08             	pushl  0x8(%ebp)
  801cde:	6a 0f                	push   $0xf
  801ce0:	e8 b3 fe ff ff       	call   801b98 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
	return;
  801ce8:	90                   	nop
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	ff 75 0c             	pushl  0xc(%ebp)
  801cf7:	ff 75 08             	pushl  0x8(%ebp)
  801cfa:	6a 10                	push   $0x10
  801cfc:	e8 97 fe ff ff       	call   801b98 <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
	return ;
  801d04:	90                   	nop
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	ff 75 10             	pushl  0x10(%ebp)
  801d11:	ff 75 0c             	pushl  0xc(%ebp)
  801d14:	ff 75 08             	pushl  0x8(%ebp)
  801d17:	6a 11                	push   $0x11
  801d19:	e8 7a fe ff ff       	call   801b98 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d21:	90                   	nop
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 0c                	push   $0xc
  801d33:	e8 60 fe ff ff       	call   801b98 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	ff 75 08             	pushl  0x8(%ebp)
  801d4b:	6a 0d                	push   $0xd
  801d4d:	e8 46 fe ff ff       	call   801b98 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 0e                	push   $0xe
  801d66:	e8 2d fe ff ff       	call   801b98 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	90                   	nop
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 13                	push   $0x13
  801d80:	e8 13 fe ff ff       	call   801b98 <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	90                   	nop
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 14                	push   $0x14
  801d9a:	e8 f9 fd ff ff       	call   801b98 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	90                   	nop
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_cputc>:


void
sys_cputc(const char c)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 04             	sub    $0x4,%esp
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801db1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	50                   	push   %eax
  801dbe:	6a 15                	push   $0x15
  801dc0:	e8 d3 fd ff ff       	call   801b98 <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	90                   	nop
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 16                	push   $0x16
  801dda:	e8 b9 fd ff ff       	call   801b98 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	90                   	nop
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	ff 75 0c             	pushl  0xc(%ebp)
  801df4:	50                   	push   %eax
  801df5:	6a 17                	push   $0x17
  801df7:	e8 9c fd ff ff       	call   801b98 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	52                   	push   %edx
  801e11:	50                   	push   %eax
  801e12:	6a 1a                	push   $0x1a
  801e14:	e8 7f fd ff ff       	call   801b98 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	52                   	push   %edx
  801e2e:	50                   	push   %eax
  801e2f:	6a 18                	push   $0x18
  801e31:	e8 62 fd ff ff       	call   801b98 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	52                   	push   %edx
  801e4c:	50                   	push   %eax
  801e4d:	6a 19                	push   $0x19
  801e4f:	e8 44 fd ff ff       	call   801b98 <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
}
  801e57:	90                   	nop
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 04             	sub    $0x4,%esp
  801e60:	8b 45 10             	mov    0x10(%ebp),%eax
  801e63:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e66:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e69:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	6a 00                	push   $0x0
  801e72:	51                   	push   %ecx
  801e73:	52                   	push   %edx
  801e74:	ff 75 0c             	pushl  0xc(%ebp)
  801e77:	50                   	push   %eax
  801e78:	6a 1b                	push   $0x1b
  801e7a:	e8 19 fd ff ff       	call   801b98 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	52                   	push   %edx
  801e94:	50                   	push   %eax
  801e95:	6a 1c                	push   $0x1c
  801e97:	e8 fc fc ff ff       	call   801b98 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ea4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	51                   	push   %ecx
  801eb2:	52                   	push   %edx
  801eb3:	50                   	push   %eax
  801eb4:	6a 1d                	push   $0x1d
  801eb6:	e8 dd fc ff ff       	call   801b98 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	52                   	push   %edx
  801ed0:	50                   	push   %eax
  801ed1:	6a 1e                	push   $0x1e
  801ed3:	e8 c0 fc ff ff       	call   801b98 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 1f                	push   $0x1f
  801eec:	e8 a7 fc ff ff       	call   801b98 <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	6a 00                	push   $0x0
  801efe:	ff 75 14             	pushl  0x14(%ebp)
  801f01:	ff 75 10             	pushl  0x10(%ebp)
  801f04:	ff 75 0c             	pushl  0xc(%ebp)
  801f07:	50                   	push   %eax
  801f08:	6a 20                	push   $0x20
  801f0a:	e8 89 fc ff ff       	call   801b98 <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	50                   	push   %eax
  801f23:	6a 21                	push   $0x21
  801f25:	e8 6e fc ff ff       	call   801b98 <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
}
  801f2d:	90                   	nop
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	50                   	push   %eax
  801f3f:	6a 22                	push   $0x22
  801f41:	e8 52 fc ff ff       	call   801b98 <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 02                	push   $0x2
  801f5a:	e8 39 fc ff ff       	call   801b98 <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 03                	push   $0x3
  801f73:	e8 20 fc ff ff       	call   801b98 <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 04                	push   $0x4
  801f8c:	e8 07 fc ff ff       	call   801b98 <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <sys_exit_env>:


void sys_exit_env(void)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 23                	push   $0x23
  801fa5:	e8 ee fb ff ff       	call   801b98 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	90                   	nop
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fb6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fb9:	8d 50 04             	lea    0x4(%eax),%edx
  801fbc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	52                   	push   %edx
  801fc6:	50                   	push   %eax
  801fc7:	6a 24                	push   $0x24
  801fc9:	e8 ca fb ff ff       	call   801b98 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
	return result;
  801fd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fda:	89 01                	mov    %eax,(%ecx)
  801fdc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe2:	c9                   	leave  
  801fe3:	c2 04 00             	ret    $0x4

00801fe6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	ff 75 10             	pushl  0x10(%ebp)
  801ff0:	ff 75 0c             	pushl  0xc(%ebp)
  801ff3:	ff 75 08             	pushl  0x8(%ebp)
  801ff6:	6a 12                	push   $0x12
  801ff8:	e8 9b fb ff ff       	call   801b98 <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
	return ;
  802000:	90                   	nop
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <sys_rcr2>:
uint32 sys_rcr2()
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 25                	push   $0x25
  802012:	e8 81 fb ff ff       	call   801b98 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	83 ec 04             	sub    $0x4,%esp
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802028:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	50                   	push   %eax
  802035:	6a 26                	push   $0x26
  802037:	e8 5c fb ff ff       	call   801b98 <syscall>
  80203c:	83 c4 18             	add    $0x18,%esp
	return ;
  80203f:	90                   	nop
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <rsttst>:
void rsttst()
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 28                	push   $0x28
  802051:	e8 42 fb ff ff       	call   801b98 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
	return ;
  802059:	90                   	nop
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	83 ec 04             	sub    $0x4,%esp
  802062:	8b 45 14             	mov    0x14(%ebp),%eax
  802065:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802068:	8b 55 18             	mov    0x18(%ebp),%edx
  80206b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80206f:	52                   	push   %edx
  802070:	50                   	push   %eax
  802071:	ff 75 10             	pushl  0x10(%ebp)
  802074:	ff 75 0c             	pushl  0xc(%ebp)
  802077:	ff 75 08             	pushl  0x8(%ebp)
  80207a:	6a 27                	push   $0x27
  80207c:	e8 17 fb ff ff       	call   801b98 <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
	return ;
  802084:	90                   	nop
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <chktst>:
void chktst(uint32 n)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	ff 75 08             	pushl  0x8(%ebp)
  802095:	6a 29                	push   $0x29
  802097:	e8 fc fa ff ff       	call   801b98 <syscall>
  80209c:	83 c4 18             	add    $0x18,%esp
	return ;
  80209f:	90                   	nop
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <inctst>:

void inctst()
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 2a                	push   $0x2a
  8020b1:	e8 e2 fa ff ff       	call   801b98 <syscall>
  8020b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b9:	90                   	nop
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <gettst>:
uint32 gettst()
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 2b                	push   $0x2b
  8020cb:	e8 c8 fa ff ff       	call   801b98 <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
}
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 2c                	push   $0x2c
  8020e7:	e8 ac fa ff ff       	call   801b98 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
  8020ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020f2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020f6:	75 07                	jne    8020ff <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fd:	eb 05                	jmp    802104 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 2c                	push   $0x2c
  802118:	e8 7b fa ff ff       	call   801b98 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
  802120:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802123:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802127:	75 07                	jne    802130 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802129:	b8 01 00 00 00       	mov    $0x1,%eax
  80212e:	eb 05                	jmp    802135 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802130:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 2c                	push   $0x2c
  802149:	e8 4a fa ff ff       	call   801b98 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
  802151:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802154:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802158:	75 07                	jne    802161 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80215a:	b8 01 00 00 00       	mov    $0x1,%eax
  80215f:	eb 05                	jmp    802166 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802161:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 2c                	push   $0x2c
  80217a:	e8 19 fa ff ff       	call   801b98 <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
  802182:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802185:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802189:	75 07                	jne    802192 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80218b:	b8 01 00 00 00       	mov    $0x1,%eax
  802190:	eb 05                	jmp    802197 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802192:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	ff 75 08             	pushl  0x8(%ebp)
  8021a7:	6a 2d                	push   $0x2d
  8021a9:	e8 ea f9 ff ff       	call   801b98 <syscall>
  8021ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b1:	90                   	nop
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	6a 00                	push   $0x0
  8021c6:	53                   	push   %ebx
  8021c7:	51                   	push   %ecx
  8021c8:	52                   	push   %edx
  8021c9:	50                   	push   %eax
  8021ca:	6a 2e                	push   $0x2e
  8021cc:	e8 c7 f9 ff ff       	call   801b98 <syscall>
  8021d1:	83 c4 18             	add    $0x18,%esp
}
  8021d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	52                   	push   %edx
  8021e9:	50                   	push   %eax
  8021ea:	6a 2f                	push   $0x2f
  8021ec:	e8 a7 f9 ff ff       	call   801b98 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8021fc:	83 ec 0c             	sub    $0xc,%esp
  8021ff:	68 a4 43 80 00       	push   $0x8043a4
  802204:	e8 46 e8 ff ff       	call   800a4f <cprintf>
  802209:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80220c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802213:	83 ec 0c             	sub    $0xc,%esp
  802216:	68 d0 43 80 00       	push   $0x8043d0
  80221b:	e8 2f e8 ff ff       	call   800a4f <cprintf>
  802220:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802223:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802227:	a1 38 51 80 00       	mov    0x805138,%eax
  80222c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80222f:	eb 56                	jmp    802287 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802231:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802235:	74 1c                	je     802253 <print_mem_block_lists+0x5d>
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	8b 50 08             	mov    0x8(%eax),%edx
  80223d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802240:	8b 48 08             	mov    0x8(%eax),%ecx
  802243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802246:	8b 40 0c             	mov    0xc(%eax),%eax
  802249:	01 c8                	add    %ecx,%eax
  80224b:	39 c2                	cmp    %eax,%edx
  80224d:	73 04                	jae    802253 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80224f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 50 08             	mov    0x8(%eax),%edx
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	8b 40 0c             	mov    0xc(%eax),%eax
  80225f:	01 c2                	add    %eax,%edx
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	8b 40 08             	mov    0x8(%eax),%eax
  802267:	83 ec 04             	sub    $0x4,%esp
  80226a:	52                   	push   %edx
  80226b:	50                   	push   %eax
  80226c:	68 e5 43 80 00       	push   $0x8043e5
  802271:	e8 d9 e7 ff ff       	call   800a4f <cprintf>
  802276:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80227f:	a1 40 51 80 00       	mov    0x805140,%eax
  802284:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802287:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228b:	74 07                	je     802294 <print_mem_block_lists+0x9e>
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	8b 00                	mov    (%eax),%eax
  802292:	eb 05                	jmp    802299 <print_mem_block_lists+0xa3>
  802294:	b8 00 00 00 00       	mov    $0x0,%eax
  802299:	a3 40 51 80 00       	mov    %eax,0x805140
  80229e:	a1 40 51 80 00       	mov    0x805140,%eax
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	75 8a                	jne    802231 <print_mem_block_lists+0x3b>
  8022a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ab:	75 84                	jne    802231 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8022ad:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022b1:	75 10                	jne    8022c3 <print_mem_block_lists+0xcd>
  8022b3:	83 ec 0c             	sub    $0xc,%esp
  8022b6:	68 f4 43 80 00       	push   $0x8043f4
  8022bb:	e8 8f e7 ff ff       	call   800a4f <cprintf>
  8022c0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8022c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8022ca:	83 ec 0c             	sub    $0xc,%esp
  8022cd:	68 18 44 80 00       	push   $0x804418
  8022d2:	e8 78 e7 ff ff       	call   800a4f <cprintf>
  8022d7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8022da:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022de:	a1 40 50 80 00       	mov    0x805040,%eax
  8022e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e6:	eb 56                	jmp    80233e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022ec:	74 1c                	je     80230a <print_mem_block_lists+0x114>
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 50 08             	mov    0x8(%eax),%edx
  8022f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f7:	8b 48 08             	mov    0x8(%eax),%ecx
  8022fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802300:	01 c8                	add    %ecx,%eax
  802302:	39 c2                	cmp    %eax,%edx
  802304:	73 04                	jae    80230a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802306:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	8b 50 08             	mov    0x8(%eax),%edx
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	8b 40 0c             	mov    0xc(%eax),%eax
  802316:	01 c2                	add    %eax,%edx
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 40 08             	mov    0x8(%eax),%eax
  80231e:	83 ec 04             	sub    $0x4,%esp
  802321:	52                   	push   %edx
  802322:	50                   	push   %eax
  802323:	68 e5 43 80 00       	push   $0x8043e5
  802328:	e8 22 e7 ff ff       	call   800a4f <cprintf>
  80232d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802336:	a1 48 50 80 00       	mov    0x805048,%eax
  80233b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802342:	74 07                	je     80234b <print_mem_block_lists+0x155>
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	eb 05                	jmp    802350 <print_mem_block_lists+0x15a>
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
  802350:	a3 48 50 80 00       	mov    %eax,0x805048
  802355:	a1 48 50 80 00       	mov    0x805048,%eax
  80235a:	85 c0                	test   %eax,%eax
  80235c:	75 8a                	jne    8022e8 <print_mem_block_lists+0xf2>
  80235e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802362:	75 84                	jne    8022e8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802364:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802368:	75 10                	jne    80237a <print_mem_block_lists+0x184>
  80236a:	83 ec 0c             	sub    $0xc,%esp
  80236d:	68 30 44 80 00       	push   $0x804430
  802372:	e8 d8 e6 ff ff       	call   800a4f <cprintf>
  802377:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80237a:	83 ec 0c             	sub    $0xc,%esp
  80237d:	68 a4 43 80 00       	push   $0x8043a4
  802382:	e8 c8 e6 ff ff       	call   800a4f <cprintf>
  802387:	83 c4 10             	add    $0x10,%esp

}
  80238a:	90                   	nop
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    

0080238d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802393:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80239a:	00 00 00 
  80239d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8023a4:	00 00 00 
  8023a7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8023ae:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8023b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8023b8:	e9 9e 00 00 00       	jmp    80245b <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8023bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8023c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c5:	c1 e2 04             	shl    $0x4,%edx
  8023c8:	01 d0                	add    %edx,%eax
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	75 14                	jne    8023e2 <initialize_MemBlocksList+0x55>
  8023ce:	83 ec 04             	sub    $0x4,%esp
  8023d1:	68 58 44 80 00       	push   $0x804458
  8023d6:	6a 46                	push   $0x46
  8023d8:	68 7b 44 80 00       	push   $0x80447b
  8023dd:	e8 b9 e3 ff ff       	call   80079b <_panic>
  8023e2:	a1 50 50 80 00       	mov    0x805050,%eax
  8023e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ea:	c1 e2 04             	shl    $0x4,%edx
  8023ed:	01 d0                	add    %edx,%eax
  8023ef:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8023f5:	89 10                	mov    %edx,(%eax)
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	74 18                	je     802415 <initialize_MemBlocksList+0x88>
  8023fd:	a1 48 51 80 00       	mov    0x805148,%eax
  802402:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802408:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80240b:	c1 e1 04             	shl    $0x4,%ecx
  80240e:	01 ca                	add    %ecx,%edx
  802410:	89 50 04             	mov    %edx,0x4(%eax)
  802413:	eb 12                	jmp    802427 <initialize_MemBlocksList+0x9a>
  802415:	a1 50 50 80 00       	mov    0x805050,%eax
  80241a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241d:	c1 e2 04             	shl    $0x4,%edx
  802420:	01 d0                	add    %edx,%eax
  802422:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802427:	a1 50 50 80 00       	mov    0x805050,%eax
  80242c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242f:	c1 e2 04             	shl    $0x4,%edx
  802432:	01 d0                	add    %edx,%eax
  802434:	a3 48 51 80 00       	mov    %eax,0x805148
  802439:	a1 50 50 80 00       	mov    0x805050,%eax
  80243e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802441:	c1 e2 04             	shl    $0x4,%edx
  802444:	01 d0                	add    %edx,%eax
  802446:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244d:	a1 54 51 80 00       	mov    0x805154,%eax
  802452:	40                   	inc    %eax
  802453:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802458:	ff 45 f4             	incl   -0xc(%ebp)
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802461:	0f 82 56 ff ff ff    	jb     8023bd <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802467:	90                   	nop
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	8b 00                	mov    (%eax),%eax
  802475:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802478:	eb 19                	jmp    802493 <find_block+0x29>
	{
		if(va==point->sva)
  80247a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80247d:	8b 40 08             	mov    0x8(%eax),%eax
  802480:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802483:	75 05                	jne    80248a <find_block+0x20>
		   return point;
  802485:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802488:	eb 36                	jmp    8024c0 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	8b 40 08             	mov    0x8(%eax),%eax
  802490:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802493:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802497:	74 07                	je     8024a0 <find_block+0x36>
  802499:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	eb 05                	jmp    8024a5 <find_block+0x3b>
  8024a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a8:	89 42 08             	mov    %eax,0x8(%edx)
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	8b 40 08             	mov    0x8(%eax),%eax
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	75 c5                	jne    80247a <find_block+0x10>
  8024b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024b9:	75 bf                	jne    80247a <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8024bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c0:	c9                   	leave  
  8024c1:	c3                   	ret    

008024c2 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
  8024c5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8024c8:	a1 40 50 80 00       	mov    0x805040,%eax
  8024cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8024d0:	a1 44 50 80 00       	mov    0x805044,%eax
  8024d5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8024d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024de:	74 24                	je     802504 <insert_sorted_allocList+0x42>
  8024e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e3:	8b 50 08             	mov    0x8(%eax),%edx
  8024e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e9:	8b 40 08             	mov    0x8(%eax),%eax
  8024ec:	39 c2                	cmp    %eax,%edx
  8024ee:	76 14                	jbe    802504 <insert_sorted_allocList+0x42>
  8024f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f3:	8b 50 08             	mov    0x8(%eax),%edx
  8024f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f9:	8b 40 08             	mov    0x8(%eax),%eax
  8024fc:	39 c2                	cmp    %eax,%edx
  8024fe:	0f 82 60 01 00 00    	jb     802664 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802504:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802508:	75 65                	jne    80256f <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80250a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80250e:	75 14                	jne    802524 <insert_sorted_allocList+0x62>
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	68 58 44 80 00       	push   $0x804458
  802518:	6a 6b                	push   $0x6b
  80251a:	68 7b 44 80 00       	push   $0x80447b
  80251f:	e8 77 e2 ff ff       	call   80079b <_panic>
  802524:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	89 10                	mov    %edx,(%eax)
  80252f:	8b 45 08             	mov    0x8(%ebp),%eax
  802532:	8b 00                	mov    (%eax),%eax
  802534:	85 c0                	test   %eax,%eax
  802536:	74 0d                	je     802545 <insert_sorted_allocList+0x83>
  802538:	a1 40 50 80 00       	mov    0x805040,%eax
  80253d:	8b 55 08             	mov    0x8(%ebp),%edx
  802540:	89 50 04             	mov    %edx,0x4(%eax)
  802543:	eb 08                	jmp    80254d <insert_sorted_allocList+0x8b>
  802545:	8b 45 08             	mov    0x8(%ebp),%eax
  802548:	a3 44 50 80 00       	mov    %eax,0x805044
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	a3 40 50 80 00       	mov    %eax,0x805040
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80255f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802564:	40                   	inc    %eax
  802565:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80256a:	e9 dc 01 00 00       	jmp    80274b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	8b 50 08             	mov    0x8(%eax),%edx
  802575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802578:	8b 40 08             	mov    0x8(%eax),%eax
  80257b:	39 c2                	cmp    %eax,%edx
  80257d:	77 6c                	ja     8025eb <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80257f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802583:	74 06                	je     80258b <insert_sorted_allocList+0xc9>
  802585:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802589:	75 14                	jne    80259f <insert_sorted_allocList+0xdd>
  80258b:	83 ec 04             	sub    $0x4,%esp
  80258e:	68 94 44 80 00       	push   $0x804494
  802593:	6a 6f                	push   $0x6f
  802595:	68 7b 44 80 00       	push   $0x80447b
  80259a:	e8 fc e1 ff ff       	call   80079b <_panic>
  80259f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a2:	8b 50 04             	mov    0x4(%eax),%edx
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	89 50 04             	mov    %edx,0x4(%eax)
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025b1:	89 10                	mov    %edx,(%eax)
  8025b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b6:	8b 40 04             	mov    0x4(%eax),%eax
  8025b9:	85 c0                	test   %eax,%eax
  8025bb:	74 0d                	je     8025ca <insert_sorted_allocList+0x108>
  8025bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c0:	8b 40 04             	mov    0x4(%eax),%eax
  8025c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c6:	89 10                	mov    %edx,(%eax)
  8025c8:	eb 08                	jmp    8025d2 <insert_sorted_allocList+0x110>
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	a3 40 50 80 00       	mov    %eax,0x805040
  8025d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d8:	89 50 04             	mov    %edx,0x4(%eax)
  8025db:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025e0:	40                   	inc    %eax
  8025e1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025e6:	e9 60 01 00 00       	jmp    80274b <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	8b 50 08             	mov    0x8(%eax),%edx
  8025f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f4:	8b 40 08             	mov    0x8(%eax),%eax
  8025f7:	39 c2                	cmp    %eax,%edx
  8025f9:	0f 82 4c 01 00 00    	jb     80274b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8025ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802603:	75 14                	jne    802619 <insert_sorted_allocList+0x157>
  802605:	83 ec 04             	sub    $0x4,%esp
  802608:	68 cc 44 80 00       	push   $0x8044cc
  80260d:	6a 73                	push   $0x73
  80260f:	68 7b 44 80 00       	push   $0x80447b
  802614:	e8 82 e1 ff ff       	call   80079b <_panic>
  802619:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	89 50 04             	mov    %edx,0x4(%eax)
  802625:	8b 45 08             	mov    0x8(%ebp),%eax
  802628:	8b 40 04             	mov    0x4(%eax),%eax
  80262b:	85 c0                	test   %eax,%eax
  80262d:	74 0c                	je     80263b <insert_sorted_allocList+0x179>
  80262f:	a1 44 50 80 00       	mov    0x805044,%eax
  802634:	8b 55 08             	mov    0x8(%ebp),%edx
  802637:	89 10                	mov    %edx,(%eax)
  802639:	eb 08                	jmp    802643 <insert_sorted_allocList+0x181>
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	a3 40 50 80 00       	mov    %eax,0x805040
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	a3 44 50 80 00       	mov    %eax,0x805044
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802654:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802659:	40                   	inc    %eax
  80265a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80265f:	e9 e7 00 00 00       	jmp    80274b <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802667:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80266a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802671:	a1 40 50 80 00       	mov    0x805040,%eax
  802676:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802679:	e9 9d 00 00 00       	jmp    80271b <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 00                	mov    (%eax),%eax
  802683:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	8b 50 08             	mov    0x8(%eax),%edx
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 40 08             	mov    0x8(%eax),%eax
  802692:	39 c2                	cmp    %eax,%edx
  802694:	76 7d                	jbe    802713 <insert_sorted_allocList+0x251>
  802696:	8b 45 08             	mov    0x8(%ebp),%eax
  802699:	8b 50 08             	mov    0x8(%eax),%edx
  80269c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80269f:	8b 40 08             	mov    0x8(%eax),%eax
  8026a2:	39 c2                	cmp    %eax,%edx
  8026a4:	73 6d                	jae    802713 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8026a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026aa:	74 06                	je     8026b2 <insert_sorted_allocList+0x1f0>
  8026ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026b0:	75 14                	jne    8026c6 <insert_sorted_allocList+0x204>
  8026b2:	83 ec 04             	sub    $0x4,%esp
  8026b5:	68 f0 44 80 00       	push   $0x8044f0
  8026ba:	6a 7f                	push   $0x7f
  8026bc:	68 7b 44 80 00       	push   $0x80447b
  8026c1:	e8 d5 e0 ff ff       	call   80079b <_panic>
  8026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c9:	8b 10                	mov    (%eax),%edx
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	89 10                	mov    %edx,(%eax)
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	8b 00                	mov    (%eax),%eax
  8026d5:	85 c0                	test   %eax,%eax
  8026d7:	74 0b                	je     8026e4 <insert_sorted_allocList+0x222>
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	8b 00                	mov    (%eax),%eax
  8026de:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e1:	89 50 04             	mov    %edx,0x4(%eax)
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ea:	89 10                	mov    %edx,(%eax)
  8026ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f2:	89 50 04             	mov    %edx,0x4(%eax)
  8026f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	75 08                	jne    802706 <insert_sorted_allocList+0x244>
  8026fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802701:	a3 44 50 80 00       	mov    %eax,0x805044
  802706:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80270b:	40                   	inc    %eax
  80270c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802711:	eb 39                	jmp    80274c <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802713:	a1 48 50 80 00       	mov    0x805048,%eax
  802718:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271f:	74 07                	je     802728 <insert_sorted_allocList+0x266>
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 00                	mov    (%eax),%eax
  802726:	eb 05                	jmp    80272d <insert_sorted_allocList+0x26b>
  802728:	b8 00 00 00 00       	mov    $0x0,%eax
  80272d:	a3 48 50 80 00       	mov    %eax,0x805048
  802732:	a1 48 50 80 00       	mov    0x805048,%eax
  802737:	85 c0                	test   %eax,%eax
  802739:	0f 85 3f ff ff ff    	jne    80267e <insert_sorted_allocList+0x1bc>
  80273f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802743:	0f 85 35 ff ff ff    	jne    80267e <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802749:	eb 01                	jmp    80274c <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80274b:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80274c:	90                   	nop
  80274d:	c9                   	leave  
  80274e:	c3                   	ret    

0080274f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80274f:	55                   	push   %ebp
  802750:	89 e5                	mov    %esp,%ebp
  802752:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802755:	a1 38 51 80 00       	mov    0x805138,%eax
  80275a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275d:	e9 85 01 00 00       	jmp    8028e7 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 40 0c             	mov    0xc(%eax),%eax
  802768:	3b 45 08             	cmp    0x8(%ebp),%eax
  80276b:	0f 82 6e 01 00 00    	jb     8028df <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 40 0c             	mov    0xc(%eax),%eax
  802777:	3b 45 08             	cmp    0x8(%ebp),%eax
  80277a:	0f 85 8a 00 00 00    	jne    80280a <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802784:	75 17                	jne    80279d <alloc_block_FF+0x4e>
  802786:	83 ec 04             	sub    $0x4,%esp
  802789:	68 24 45 80 00       	push   $0x804524
  80278e:	68 93 00 00 00       	push   $0x93
  802793:	68 7b 44 80 00       	push   $0x80447b
  802798:	e8 fe df ff ff       	call   80079b <_panic>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	74 10                	je     8027b6 <alloc_block_FF+0x67>
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 00                	mov    (%eax),%eax
  8027ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ae:	8b 52 04             	mov    0x4(%edx),%edx
  8027b1:	89 50 04             	mov    %edx,0x4(%eax)
  8027b4:	eb 0b                	jmp    8027c1 <alloc_block_FF+0x72>
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 40 04             	mov    0x4(%eax),%eax
  8027bc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	74 0f                	je     8027da <alloc_block_FF+0x8b>
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	8b 40 04             	mov    0x4(%eax),%eax
  8027d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d4:	8b 12                	mov    (%edx),%edx
  8027d6:	89 10                	mov    %edx,(%eax)
  8027d8:	eb 0a                	jmp    8027e4 <alloc_block_FF+0x95>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	a3 38 51 80 00       	mov    %eax,0x805138
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f7:	a1 44 51 80 00       	mov    0x805144,%eax
  8027fc:	48                   	dec    %eax
  8027fd:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	e9 10 01 00 00       	jmp    80291a <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 40 0c             	mov    0xc(%eax),%eax
  802810:	3b 45 08             	cmp    0x8(%ebp),%eax
  802813:	0f 86 c6 00 00 00    	jbe    8028df <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802819:	a1 48 51 80 00       	mov    0x805148,%eax
  80281e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 50 08             	mov    0x8(%eax),%edx
  802827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282a:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80282d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802830:	8b 55 08             	mov    0x8(%ebp),%edx
  802833:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802836:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80283a:	75 17                	jne    802853 <alloc_block_FF+0x104>
  80283c:	83 ec 04             	sub    $0x4,%esp
  80283f:	68 24 45 80 00       	push   $0x804524
  802844:	68 9b 00 00 00       	push   $0x9b
  802849:	68 7b 44 80 00       	push   $0x80447b
  80284e:	e8 48 df ff ff       	call   80079b <_panic>
  802853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802856:	8b 00                	mov    (%eax),%eax
  802858:	85 c0                	test   %eax,%eax
  80285a:	74 10                	je     80286c <alloc_block_FF+0x11d>
  80285c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285f:	8b 00                	mov    (%eax),%eax
  802861:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802864:	8b 52 04             	mov    0x4(%edx),%edx
  802867:	89 50 04             	mov    %edx,0x4(%eax)
  80286a:	eb 0b                	jmp    802877 <alloc_block_FF+0x128>
  80286c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286f:	8b 40 04             	mov    0x4(%eax),%eax
  802872:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287a:	8b 40 04             	mov    0x4(%eax),%eax
  80287d:	85 c0                	test   %eax,%eax
  80287f:	74 0f                	je     802890 <alloc_block_FF+0x141>
  802881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802884:	8b 40 04             	mov    0x4(%eax),%eax
  802887:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80288a:	8b 12                	mov    (%edx),%edx
  80288c:	89 10                	mov    %edx,(%eax)
  80288e:	eb 0a                	jmp    80289a <alloc_block_FF+0x14b>
  802890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	a3 48 51 80 00       	mov    %eax,0x805148
  80289a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8028b2:	48                   	dec    %eax
  8028b3:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 50 08             	mov    0x8(%eax),%edx
  8028be:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c1:	01 c2                	add    %eax,%edx
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cf:	2b 45 08             	sub    0x8(%ebp),%eax
  8028d2:	89 c2                	mov    %eax,%edx
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	eb 3b                	jmp    80291a <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028df:	a1 40 51 80 00       	mov    0x805140,%eax
  8028e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028eb:	74 07                	je     8028f4 <alloc_block_FF+0x1a5>
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 00                	mov    (%eax),%eax
  8028f2:	eb 05                	jmp    8028f9 <alloc_block_FF+0x1aa>
  8028f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f9:	a3 40 51 80 00       	mov    %eax,0x805140
  8028fe:	a1 40 51 80 00       	mov    0x805140,%eax
  802903:	85 c0                	test   %eax,%eax
  802905:	0f 85 57 fe ff ff    	jne    802762 <alloc_block_FF+0x13>
  80290b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290f:	0f 85 4d fe ff ff    	jne    802762 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802915:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80291a:	c9                   	leave  
  80291b:	c3                   	ret    

0080291c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
  80291f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802922:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802929:	a1 38 51 80 00       	mov    0x805138,%eax
  80292e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802931:	e9 df 00 00 00       	jmp    802a15 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 40 0c             	mov    0xc(%eax),%eax
  80293c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293f:	0f 82 c8 00 00 00    	jb     802a0d <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 40 0c             	mov    0xc(%eax),%eax
  80294b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294e:	0f 85 8a 00 00 00    	jne    8029de <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802954:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802958:	75 17                	jne    802971 <alloc_block_BF+0x55>
  80295a:	83 ec 04             	sub    $0x4,%esp
  80295d:	68 24 45 80 00       	push   $0x804524
  802962:	68 b7 00 00 00       	push   $0xb7
  802967:	68 7b 44 80 00       	push   $0x80447b
  80296c:	e8 2a de ff ff       	call   80079b <_panic>
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 00                	mov    (%eax),%eax
  802976:	85 c0                	test   %eax,%eax
  802978:	74 10                	je     80298a <alloc_block_BF+0x6e>
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 00                	mov    (%eax),%eax
  80297f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802982:	8b 52 04             	mov    0x4(%edx),%edx
  802985:	89 50 04             	mov    %edx,0x4(%eax)
  802988:	eb 0b                	jmp    802995 <alloc_block_BF+0x79>
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 40 04             	mov    0x4(%eax),%eax
  802990:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	8b 40 04             	mov    0x4(%eax),%eax
  80299b:	85 c0                	test   %eax,%eax
  80299d:	74 0f                	je     8029ae <alloc_block_BF+0x92>
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 40 04             	mov    0x4(%eax),%eax
  8029a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a8:	8b 12                	mov    (%edx),%edx
  8029aa:	89 10                	mov    %edx,(%eax)
  8029ac:	eb 0a                	jmp    8029b8 <alloc_block_BF+0x9c>
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 00                	mov    (%eax),%eax
  8029b3:	a3 38 51 80 00       	mov    %eax,0x805138
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8029d0:	48                   	dec    %eax
  8029d1:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	e9 4d 01 00 00       	jmp    802b2b <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e7:	76 24                	jbe    802a0d <alloc_block_BF+0xf1>
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029f2:	73 19                	jae    802a0d <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8029f4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802a01:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 40 08             	mov    0x8(%eax),%eax
  802a0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a0d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a19:	74 07                	je     802a22 <alloc_block_BF+0x106>
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 00                	mov    (%eax),%eax
  802a20:	eb 05                	jmp    802a27 <alloc_block_BF+0x10b>
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
  802a27:	a3 40 51 80 00       	mov    %eax,0x805140
  802a2c:	a1 40 51 80 00       	mov    0x805140,%eax
  802a31:	85 c0                	test   %eax,%eax
  802a33:	0f 85 fd fe ff ff    	jne    802936 <alloc_block_BF+0x1a>
  802a39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3d:	0f 85 f3 fe ff ff    	jne    802936 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802a43:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a47:	0f 84 d9 00 00 00    	je     802b26 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a4d:	a1 48 51 80 00       	mov    0x805148,%eax
  802a52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802a55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a5b:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802a5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a61:	8b 55 08             	mov    0x8(%ebp),%edx
  802a64:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802a67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a6b:	75 17                	jne    802a84 <alloc_block_BF+0x168>
  802a6d:	83 ec 04             	sub    $0x4,%esp
  802a70:	68 24 45 80 00       	push   $0x804524
  802a75:	68 c7 00 00 00       	push   $0xc7
  802a7a:	68 7b 44 80 00       	push   $0x80447b
  802a7f:	e8 17 dd ff ff       	call   80079b <_panic>
  802a84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	74 10                	je     802a9d <alloc_block_BF+0x181>
  802a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a90:	8b 00                	mov    (%eax),%eax
  802a92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a95:	8b 52 04             	mov    0x4(%edx),%edx
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
  802a9b:	eb 0b                	jmp    802aa8 <alloc_block_BF+0x18c>
  802a9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa0:	8b 40 04             	mov    0x4(%eax),%eax
  802aa3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aab:	8b 40 04             	mov    0x4(%eax),%eax
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	74 0f                	je     802ac1 <alloc_block_BF+0x1a5>
  802ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab5:	8b 40 04             	mov    0x4(%eax),%eax
  802ab8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802abb:	8b 12                	mov    (%edx),%edx
  802abd:	89 10                	mov    %edx,(%eax)
  802abf:	eb 0a                	jmp    802acb <alloc_block_BF+0x1af>
  802ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	a3 48 51 80 00       	mov    %eax,0x805148
  802acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ade:	a1 54 51 80 00       	mov    0x805154,%eax
  802ae3:	48                   	dec    %eax
  802ae4:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802ae9:	83 ec 08             	sub    $0x8,%esp
  802aec:	ff 75 ec             	pushl  -0x14(%ebp)
  802aef:	68 38 51 80 00       	push   $0x805138
  802af4:	e8 71 f9 ff ff       	call   80246a <find_block>
  802af9:	83 c4 10             	add    $0x10,%esp
  802afc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802aff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b02:	8b 50 08             	mov    0x8(%eax),%edx
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	01 c2                	add    %eax,%edx
  802b0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0d:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b13:	8b 40 0c             	mov    0xc(%eax),%eax
  802b16:	2b 45 08             	sub    0x8(%ebp),%eax
  802b19:	89 c2                	mov    %eax,%edx
  802b1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b1e:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b24:	eb 05                	jmp    802b2b <alloc_block_BF+0x20f>
	}
	return NULL;
  802b26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b2b:	c9                   	leave  
  802b2c:	c3                   	ret    

00802b2d <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b2d:	55                   	push   %ebp
  802b2e:	89 e5                	mov    %esp,%ebp
  802b30:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802b33:	a1 28 50 80 00       	mov    0x805028,%eax
  802b38:	85 c0                	test   %eax,%eax
  802b3a:	0f 85 de 01 00 00    	jne    802d1e <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b40:	a1 38 51 80 00       	mov    0x805138,%eax
  802b45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b48:	e9 9e 01 00 00       	jmp    802ceb <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 40 0c             	mov    0xc(%eax),%eax
  802b53:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b56:	0f 82 87 01 00 00    	jb     802ce3 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b62:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b65:	0f 85 95 00 00 00    	jne    802c00 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802b6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6f:	75 17                	jne    802b88 <alloc_block_NF+0x5b>
  802b71:	83 ec 04             	sub    $0x4,%esp
  802b74:	68 24 45 80 00       	push   $0x804524
  802b79:	68 e0 00 00 00       	push   $0xe0
  802b7e:	68 7b 44 80 00       	push   $0x80447b
  802b83:	e8 13 dc ff ff       	call   80079b <_panic>
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 00                	mov    (%eax),%eax
  802b8d:	85 c0                	test   %eax,%eax
  802b8f:	74 10                	je     802ba1 <alloc_block_NF+0x74>
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 00                	mov    (%eax),%eax
  802b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b99:	8b 52 04             	mov    0x4(%edx),%edx
  802b9c:	89 50 04             	mov    %edx,0x4(%eax)
  802b9f:	eb 0b                	jmp    802bac <alloc_block_NF+0x7f>
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 40 04             	mov    0x4(%eax),%eax
  802ba7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 40 04             	mov    0x4(%eax),%eax
  802bb2:	85 c0                	test   %eax,%eax
  802bb4:	74 0f                	je     802bc5 <alloc_block_NF+0x98>
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 40 04             	mov    0x4(%eax),%eax
  802bbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbf:	8b 12                	mov    (%edx),%edx
  802bc1:	89 10                	mov    %edx,(%eax)
  802bc3:	eb 0a                	jmp    802bcf <alloc_block_NF+0xa2>
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	a3 38 51 80 00       	mov    %eax,0x805138
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be2:	a1 44 51 80 00       	mov    0x805144,%eax
  802be7:	48                   	dec    %eax
  802be8:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 40 08             	mov    0x8(%eax),%eax
  802bf3:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	e9 f8 04 00 00       	jmp    8030f8 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 0c             	mov    0xc(%eax),%eax
  802c06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c09:	0f 86 d4 00 00 00    	jbe    802ce3 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c0f:	a1 48 51 80 00       	mov    0x805148,%eax
  802c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8b 50 08             	mov    0x8(%eax),%edx
  802c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c20:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	8b 55 08             	mov    0x8(%ebp),%edx
  802c29:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c30:	75 17                	jne    802c49 <alloc_block_NF+0x11c>
  802c32:	83 ec 04             	sub    $0x4,%esp
  802c35:	68 24 45 80 00       	push   $0x804524
  802c3a:	68 e9 00 00 00       	push   $0xe9
  802c3f:	68 7b 44 80 00       	push   $0x80447b
  802c44:	e8 52 db ff ff       	call   80079b <_panic>
  802c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4c:	8b 00                	mov    (%eax),%eax
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	74 10                	je     802c62 <alloc_block_NF+0x135>
  802c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c5a:	8b 52 04             	mov    0x4(%edx),%edx
  802c5d:	89 50 04             	mov    %edx,0x4(%eax)
  802c60:	eb 0b                	jmp    802c6d <alloc_block_NF+0x140>
  802c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c65:	8b 40 04             	mov    0x4(%eax),%eax
  802c68:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 0f                	je     802c86 <alloc_block_NF+0x159>
  802c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7a:	8b 40 04             	mov    0x4(%eax),%eax
  802c7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c80:	8b 12                	mov    (%edx),%edx
  802c82:	89 10                	mov    %edx,(%eax)
  802c84:	eb 0a                	jmp    802c90 <alloc_block_NF+0x163>
  802c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c89:	8b 00                	mov    (%eax),%eax
  802c8b:	a3 48 51 80 00       	mov    %eax,0x805148
  802c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ca8:	48                   	dec    %eax
  802ca9:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb1:	8b 40 08             	mov    0x8(%eax),%eax
  802cb4:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 50 08             	mov    0x8(%eax),%edx
  802cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc2:	01 c2                	add    %eax,%edx
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd0:	2b 45 08             	sub    0x8(%ebp),%eax
  802cd3:	89 c2                	mov    %eax,%edx
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cde:	e9 15 04 00 00       	jmp    8030f8 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ce3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ce8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ceb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cef:	74 07                	je     802cf8 <alloc_block_NF+0x1cb>
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 00                	mov    (%eax),%eax
  802cf6:	eb 05                	jmp    802cfd <alloc_block_NF+0x1d0>
  802cf8:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfd:	a3 40 51 80 00       	mov    %eax,0x805140
  802d02:	a1 40 51 80 00       	mov    0x805140,%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	0f 85 3e fe ff ff    	jne    802b4d <alloc_block_NF+0x20>
  802d0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d13:	0f 85 34 fe ff ff    	jne    802b4d <alloc_block_NF+0x20>
  802d19:	e9 d5 03 00 00       	jmp    8030f3 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d1e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d26:	e9 b1 01 00 00       	jmp    802edc <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 50 08             	mov    0x8(%eax),%edx
  802d31:	a1 28 50 80 00       	mov    0x805028,%eax
  802d36:	39 c2                	cmp    %eax,%edx
  802d38:	0f 82 96 01 00 00    	jb     802ed4 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	8b 40 0c             	mov    0xc(%eax),%eax
  802d44:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d47:	0f 82 87 01 00 00    	jb     802ed4 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 40 0c             	mov    0xc(%eax),%eax
  802d53:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d56:	0f 85 95 00 00 00    	jne    802df1 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d60:	75 17                	jne    802d79 <alloc_block_NF+0x24c>
  802d62:	83 ec 04             	sub    $0x4,%esp
  802d65:	68 24 45 80 00       	push   $0x804524
  802d6a:	68 fc 00 00 00       	push   $0xfc
  802d6f:	68 7b 44 80 00       	push   $0x80447b
  802d74:	e8 22 da ff ff       	call   80079b <_panic>
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	74 10                	je     802d92 <alloc_block_NF+0x265>
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 00                	mov    (%eax),%eax
  802d87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8a:	8b 52 04             	mov    0x4(%edx),%edx
  802d8d:	89 50 04             	mov    %edx,0x4(%eax)
  802d90:	eb 0b                	jmp    802d9d <alloc_block_NF+0x270>
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	8b 40 04             	mov    0x4(%eax),%eax
  802d98:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	8b 40 04             	mov    0x4(%eax),%eax
  802da3:	85 c0                	test   %eax,%eax
  802da5:	74 0f                	je     802db6 <alloc_block_NF+0x289>
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	8b 40 04             	mov    0x4(%eax),%eax
  802dad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db0:	8b 12                	mov    (%edx),%edx
  802db2:	89 10                	mov    %edx,(%eax)
  802db4:	eb 0a                	jmp    802dc0 <alloc_block_NF+0x293>
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	a3 38 51 80 00       	mov    %eax,0x805138
  802dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd3:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd8:	48                   	dec    %eax
  802dd9:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 40 08             	mov    0x8(%eax),%eax
  802de4:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	e9 07 03 00 00       	jmp    8030f8 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 40 0c             	mov    0xc(%eax),%eax
  802df7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dfa:	0f 86 d4 00 00 00    	jbe    802ed4 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e00:	a1 48 51 80 00       	mov    0x805148,%eax
  802e05:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 50 08             	mov    0x8(%eax),%edx
  802e0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e11:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e17:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e1d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e21:	75 17                	jne    802e3a <alloc_block_NF+0x30d>
  802e23:	83 ec 04             	sub    $0x4,%esp
  802e26:	68 24 45 80 00       	push   $0x804524
  802e2b:	68 04 01 00 00       	push   $0x104
  802e30:	68 7b 44 80 00       	push   $0x80447b
  802e35:	e8 61 d9 ff ff       	call   80079b <_panic>
  802e3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3d:	8b 00                	mov    (%eax),%eax
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	74 10                	je     802e53 <alloc_block_NF+0x326>
  802e43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e46:	8b 00                	mov    (%eax),%eax
  802e48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e4b:	8b 52 04             	mov    0x4(%edx),%edx
  802e4e:	89 50 04             	mov    %edx,0x4(%eax)
  802e51:	eb 0b                	jmp    802e5e <alloc_block_NF+0x331>
  802e53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e56:	8b 40 04             	mov    0x4(%eax),%eax
  802e59:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e61:	8b 40 04             	mov    0x4(%eax),%eax
  802e64:	85 c0                	test   %eax,%eax
  802e66:	74 0f                	je     802e77 <alloc_block_NF+0x34a>
  802e68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e6b:	8b 40 04             	mov    0x4(%eax),%eax
  802e6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e71:	8b 12                	mov    (%edx),%edx
  802e73:	89 10                	mov    %edx,(%eax)
  802e75:	eb 0a                	jmp    802e81 <alloc_block_NF+0x354>
  802e77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	a3 48 51 80 00       	mov    %eax,0x805148
  802e81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e94:	a1 54 51 80 00       	mov    0x805154,%eax
  802e99:	48                   	dec    %eax
  802e9a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea2:	8b 40 08             	mov    0x8(%eax),%eax
  802ea5:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	8b 50 08             	mov    0x8(%eax),%edx
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	01 c2                	add    %eax,%edx
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec1:	2b 45 08             	sub    0x8(%ebp),%eax
  802ec4:	89 c2                	mov    %eax,%edx
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ecc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecf:	e9 24 02 00 00       	jmp    8030f8 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ed4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee0:	74 07                	je     802ee9 <alloc_block_NF+0x3bc>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	eb 05                	jmp    802eee <alloc_block_NF+0x3c1>
  802ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  802eee:	a3 40 51 80 00       	mov    %eax,0x805140
  802ef3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ef8:	85 c0                	test   %eax,%eax
  802efa:	0f 85 2b fe ff ff    	jne    802d2b <alloc_block_NF+0x1fe>
  802f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f04:	0f 85 21 fe ff ff    	jne    802d2b <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f0a:	a1 38 51 80 00       	mov    0x805138,%eax
  802f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f12:	e9 ae 01 00 00       	jmp    8030c5 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	8b 50 08             	mov    0x8(%eax),%edx
  802f1d:	a1 28 50 80 00       	mov    0x805028,%eax
  802f22:	39 c2                	cmp    %eax,%edx
  802f24:	0f 83 93 01 00 00    	jae    8030bd <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f30:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f33:	0f 82 84 01 00 00    	jb     8030bd <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f42:	0f 85 95 00 00 00    	jne    802fdd <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4c:	75 17                	jne    802f65 <alloc_block_NF+0x438>
  802f4e:	83 ec 04             	sub    $0x4,%esp
  802f51:	68 24 45 80 00       	push   $0x804524
  802f56:	68 14 01 00 00       	push   $0x114
  802f5b:	68 7b 44 80 00       	push   $0x80447b
  802f60:	e8 36 d8 ff ff       	call   80079b <_panic>
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	8b 00                	mov    (%eax),%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	74 10                	je     802f7e <alloc_block_NF+0x451>
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	8b 00                	mov    (%eax),%eax
  802f73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f76:	8b 52 04             	mov    0x4(%edx),%edx
  802f79:	89 50 04             	mov    %edx,0x4(%eax)
  802f7c:	eb 0b                	jmp    802f89 <alloc_block_NF+0x45c>
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 40 04             	mov    0x4(%eax),%eax
  802f84:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	8b 40 04             	mov    0x4(%eax),%eax
  802f8f:	85 c0                	test   %eax,%eax
  802f91:	74 0f                	je     802fa2 <alloc_block_NF+0x475>
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	8b 40 04             	mov    0x4(%eax),%eax
  802f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9c:	8b 12                	mov    (%edx),%edx
  802f9e:	89 10                	mov    %edx,(%eax)
  802fa0:	eb 0a                	jmp    802fac <alloc_block_NF+0x47f>
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 00                	mov    (%eax),%eax
  802fa7:	a3 38 51 80 00       	mov    %eax,0x805138
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbf:	a1 44 51 80 00       	mov    0x805144,%eax
  802fc4:	48                   	dec    %eax
  802fc5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	8b 40 08             	mov    0x8(%eax),%eax
  802fd0:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd8:	e9 1b 01 00 00       	jmp    8030f8 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fe6:	0f 86 d1 00 00 00    	jbe    8030bd <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fec:	a1 48 51 80 00       	mov    0x805148,%eax
  802ff1:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	8b 50 08             	mov    0x8(%eax),%edx
  802ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffd:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803000:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803003:	8b 55 08             	mov    0x8(%ebp),%edx
  803006:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803009:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80300d:	75 17                	jne    803026 <alloc_block_NF+0x4f9>
  80300f:	83 ec 04             	sub    $0x4,%esp
  803012:	68 24 45 80 00       	push   $0x804524
  803017:	68 1c 01 00 00       	push   $0x11c
  80301c:	68 7b 44 80 00       	push   $0x80447b
  803021:	e8 75 d7 ff ff       	call   80079b <_panic>
  803026:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803029:	8b 00                	mov    (%eax),%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	74 10                	je     80303f <alloc_block_NF+0x512>
  80302f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803032:	8b 00                	mov    (%eax),%eax
  803034:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803037:	8b 52 04             	mov    0x4(%edx),%edx
  80303a:	89 50 04             	mov    %edx,0x4(%eax)
  80303d:	eb 0b                	jmp    80304a <alloc_block_NF+0x51d>
  80303f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80304a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304d:	8b 40 04             	mov    0x4(%eax),%eax
  803050:	85 c0                	test   %eax,%eax
  803052:	74 0f                	je     803063 <alloc_block_NF+0x536>
  803054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80305d:	8b 12                	mov    (%edx),%edx
  80305f:	89 10                	mov    %edx,(%eax)
  803061:	eb 0a                	jmp    80306d <alloc_block_NF+0x540>
  803063:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803066:	8b 00                	mov    (%eax),%eax
  803068:	a3 48 51 80 00       	mov    %eax,0x805148
  80306d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803070:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803076:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803079:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803080:	a1 54 51 80 00       	mov    0x805154,%eax
  803085:	48                   	dec    %eax
  803086:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80308b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308e:	8b 40 08             	mov    0x8(%eax),%eax
  803091:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	8b 50 08             	mov    0x8(%eax),%edx
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	01 c2                	add    %eax,%edx
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ad:	2b 45 08             	sub    0x8(%ebp),%eax
  8030b0:	89 c2                	mov    %eax,%edx
  8030b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8030b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bb:	eb 3b                	jmp    8030f8 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030bd:	a1 40 51 80 00       	mov    0x805140,%eax
  8030c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c9:	74 07                	je     8030d2 <alloc_block_NF+0x5a5>
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	8b 00                	mov    (%eax),%eax
  8030d0:	eb 05                	jmp    8030d7 <alloc_block_NF+0x5aa>
  8030d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d7:	a3 40 51 80 00       	mov    %eax,0x805140
  8030dc:	a1 40 51 80 00       	mov    0x805140,%eax
  8030e1:	85 c0                	test   %eax,%eax
  8030e3:	0f 85 2e fe ff ff    	jne    802f17 <alloc_block_NF+0x3ea>
  8030e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ed:	0f 85 24 fe ff ff    	jne    802f17 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8030f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030f8:	c9                   	leave  
  8030f9:	c3                   	ret    

008030fa <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030fa:	55                   	push   %ebp
  8030fb:	89 e5                	mov    %esp,%ebp
  8030fd:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803100:	a1 38 51 80 00       	mov    0x805138,%eax
  803105:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803108:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80310d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803110:	a1 38 51 80 00       	mov    0x805138,%eax
  803115:	85 c0                	test   %eax,%eax
  803117:	74 14                	je     80312d <insert_sorted_with_merge_freeList+0x33>
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	8b 50 08             	mov    0x8(%eax),%edx
  80311f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803122:	8b 40 08             	mov    0x8(%eax),%eax
  803125:	39 c2                	cmp    %eax,%edx
  803127:	0f 87 9b 01 00 00    	ja     8032c8 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80312d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803131:	75 17                	jne    80314a <insert_sorted_with_merge_freeList+0x50>
  803133:	83 ec 04             	sub    $0x4,%esp
  803136:	68 58 44 80 00       	push   $0x804458
  80313b:	68 38 01 00 00       	push   $0x138
  803140:	68 7b 44 80 00       	push   $0x80447b
  803145:	e8 51 d6 ff ff       	call   80079b <_panic>
  80314a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803150:	8b 45 08             	mov    0x8(%ebp),%eax
  803153:	89 10                	mov    %edx,(%eax)
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	85 c0                	test   %eax,%eax
  80315c:	74 0d                	je     80316b <insert_sorted_with_merge_freeList+0x71>
  80315e:	a1 38 51 80 00       	mov    0x805138,%eax
  803163:	8b 55 08             	mov    0x8(%ebp),%edx
  803166:	89 50 04             	mov    %edx,0x4(%eax)
  803169:	eb 08                	jmp    803173 <insert_sorted_with_merge_freeList+0x79>
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	a3 38 51 80 00       	mov    %eax,0x805138
  80317b:	8b 45 08             	mov    0x8(%ebp),%eax
  80317e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803185:	a1 44 51 80 00       	mov    0x805144,%eax
  80318a:	40                   	inc    %eax
  80318b:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803190:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803194:	0f 84 a8 06 00 00    	je     803842 <insert_sorted_with_merge_freeList+0x748>
  80319a:	8b 45 08             	mov    0x8(%ebp),%eax
  80319d:	8b 50 08             	mov    0x8(%eax),%edx
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a6:	01 c2                	add    %eax,%edx
  8031a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ab:	8b 40 08             	mov    0x8(%eax),%eax
  8031ae:	39 c2                	cmp    %eax,%edx
  8031b0:	0f 85 8c 06 00 00    	jne    803842 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	8b 50 0c             	mov    0xc(%eax),%edx
  8031bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c2:	01 c2                	add    %eax,%edx
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8031ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031ce:	75 17                	jne    8031e7 <insert_sorted_with_merge_freeList+0xed>
  8031d0:	83 ec 04             	sub    $0x4,%esp
  8031d3:	68 24 45 80 00       	push   $0x804524
  8031d8:	68 3c 01 00 00       	push   $0x13c
  8031dd:	68 7b 44 80 00       	push   $0x80447b
  8031e2:	e8 b4 d5 ff ff       	call   80079b <_panic>
  8031e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ea:	8b 00                	mov    (%eax),%eax
  8031ec:	85 c0                	test   %eax,%eax
  8031ee:	74 10                	je     803200 <insert_sorted_with_merge_freeList+0x106>
  8031f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f3:	8b 00                	mov    (%eax),%eax
  8031f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f8:	8b 52 04             	mov    0x4(%edx),%edx
  8031fb:	89 50 04             	mov    %edx,0x4(%eax)
  8031fe:	eb 0b                	jmp    80320b <insert_sorted_with_merge_freeList+0x111>
  803200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803203:	8b 40 04             	mov    0x4(%eax),%eax
  803206:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80320b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320e:	8b 40 04             	mov    0x4(%eax),%eax
  803211:	85 c0                	test   %eax,%eax
  803213:	74 0f                	je     803224 <insert_sorted_with_merge_freeList+0x12a>
  803215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803218:	8b 40 04             	mov    0x4(%eax),%eax
  80321b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80321e:	8b 12                	mov    (%edx),%edx
  803220:	89 10                	mov    %edx,(%eax)
  803222:	eb 0a                	jmp    80322e <insert_sorted_with_merge_freeList+0x134>
  803224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803227:	8b 00                	mov    (%eax),%eax
  803229:	a3 38 51 80 00       	mov    %eax,0x805138
  80322e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803237:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803241:	a1 44 51 80 00       	mov    0x805144,%eax
  803246:	48                   	dec    %eax
  803247:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80324c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803259:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803260:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803264:	75 17                	jne    80327d <insert_sorted_with_merge_freeList+0x183>
  803266:	83 ec 04             	sub    $0x4,%esp
  803269:	68 58 44 80 00       	push   $0x804458
  80326e:	68 3f 01 00 00       	push   $0x13f
  803273:	68 7b 44 80 00       	push   $0x80447b
  803278:	e8 1e d5 ff ff       	call   80079b <_panic>
  80327d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803286:	89 10                	mov    %edx,(%eax)
  803288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	85 c0                	test   %eax,%eax
  80328f:	74 0d                	je     80329e <insert_sorted_with_merge_freeList+0x1a4>
  803291:	a1 48 51 80 00       	mov    0x805148,%eax
  803296:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803299:	89 50 04             	mov    %edx,0x4(%eax)
  80329c:	eb 08                	jmp    8032a6 <insert_sorted_with_merge_freeList+0x1ac>
  80329e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8032bd:	40                   	inc    %eax
  8032be:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032c3:	e9 7a 05 00 00       	jmp    803842 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	8b 50 08             	mov    0x8(%eax),%edx
  8032ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d1:	8b 40 08             	mov    0x8(%eax),%eax
  8032d4:	39 c2                	cmp    %eax,%edx
  8032d6:	0f 82 14 01 00 00    	jb     8033f0 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8032dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032df:	8b 50 08             	mov    0x8(%eax),%edx
  8032e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e8:	01 c2                	add    %eax,%edx
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	8b 40 08             	mov    0x8(%eax),%eax
  8032f0:	39 c2                	cmp    %eax,%edx
  8032f2:	0f 85 90 00 00 00    	jne    803388 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8032f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	8b 40 0c             	mov    0xc(%eax),%eax
  803304:	01 c2                	add    %eax,%edx
  803306:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803309:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803320:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803324:	75 17                	jne    80333d <insert_sorted_with_merge_freeList+0x243>
  803326:	83 ec 04             	sub    $0x4,%esp
  803329:	68 58 44 80 00       	push   $0x804458
  80332e:	68 49 01 00 00       	push   $0x149
  803333:	68 7b 44 80 00       	push   $0x80447b
  803338:	e8 5e d4 ff ff       	call   80079b <_panic>
  80333d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	89 10                	mov    %edx,(%eax)
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	85 c0                	test   %eax,%eax
  80334f:	74 0d                	je     80335e <insert_sorted_with_merge_freeList+0x264>
  803351:	a1 48 51 80 00       	mov    0x805148,%eax
  803356:	8b 55 08             	mov    0x8(%ebp),%edx
  803359:	89 50 04             	mov    %edx,0x4(%eax)
  80335c:	eb 08                	jmp    803366 <insert_sorted_with_merge_freeList+0x26c>
  80335e:	8b 45 08             	mov    0x8(%ebp),%eax
  803361:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	a3 48 51 80 00       	mov    %eax,0x805148
  80336e:	8b 45 08             	mov    0x8(%ebp),%eax
  803371:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803378:	a1 54 51 80 00       	mov    0x805154,%eax
  80337d:	40                   	inc    %eax
  80337e:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803383:	e9 bb 04 00 00       	jmp    803843 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803388:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80338c:	75 17                	jne    8033a5 <insert_sorted_with_merge_freeList+0x2ab>
  80338e:	83 ec 04             	sub    $0x4,%esp
  803391:	68 cc 44 80 00       	push   $0x8044cc
  803396:	68 4c 01 00 00       	push   $0x14c
  80339b:	68 7b 44 80 00       	push   $0x80447b
  8033a0:	e8 f6 d3 ff ff       	call   80079b <_panic>
  8033a5:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	89 50 04             	mov    %edx,0x4(%eax)
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	8b 40 04             	mov    0x4(%eax),%eax
  8033b7:	85 c0                	test   %eax,%eax
  8033b9:	74 0c                	je     8033c7 <insert_sorted_with_merge_freeList+0x2cd>
  8033bb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c3:	89 10                	mov    %edx,(%eax)
  8033c5:	eb 08                	jmp    8033cf <insert_sorted_with_merge_freeList+0x2d5>
  8033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ca:	a3 38 51 80 00       	mov    %eax,0x805138
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e5:	40                   	inc    %eax
  8033e6:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033eb:	e9 53 04 00 00       	jmp    803843 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033f0:	a1 38 51 80 00       	mov    0x805138,%eax
  8033f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033f8:	e9 15 04 00 00       	jmp    803812 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803400:	8b 00                	mov    (%eax),%eax
  803402:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	8b 50 08             	mov    0x8(%eax),%edx
  80340b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340e:	8b 40 08             	mov    0x8(%eax),%eax
  803411:	39 c2                	cmp    %eax,%edx
  803413:	0f 86 f1 03 00 00    	jbe    80380a <insert_sorted_with_merge_freeList+0x710>
  803419:	8b 45 08             	mov    0x8(%ebp),%eax
  80341c:	8b 50 08             	mov    0x8(%eax),%edx
  80341f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803422:	8b 40 08             	mov    0x8(%eax),%eax
  803425:	39 c2                	cmp    %eax,%edx
  803427:	0f 83 dd 03 00 00    	jae    80380a <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80342d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803430:	8b 50 08             	mov    0x8(%eax),%edx
  803433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803436:	8b 40 0c             	mov    0xc(%eax),%eax
  803439:	01 c2                	add    %eax,%edx
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	8b 40 08             	mov    0x8(%eax),%eax
  803441:	39 c2                	cmp    %eax,%edx
  803443:	0f 85 b9 01 00 00    	jne    803602 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	8b 50 08             	mov    0x8(%eax),%edx
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	8b 40 0c             	mov    0xc(%eax),%eax
  803455:	01 c2                	add    %eax,%edx
  803457:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345a:	8b 40 08             	mov    0x8(%eax),%eax
  80345d:	39 c2                	cmp    %eax,%edx
  80345f:	0f 85 0d 01 00 00    	jne    803572 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803468:	8b 50 0c             	mov    0xc(%eax),%edx
  80346b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346e:	8b 40 0c             	mov    0xc(%eax),%eax
  803471:	01 c2                	add    %eax,%edx
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803479:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80347d:	75 17                	jne    803496 <insert_sorted_with_merge_freeList+0x39c>
  80347f:	83 ec 04             	sub    $0x4,%esp
  803482:	68 24 45 80 00       	push   $0x804524
  803487:	68 5c 01 00 00       	push   $0x15c
  80348c:	68 7b 44 80 00       	push   $0x80447b
  803491:	e8 05 d3 ff ff       	call   80079b <_panic>
  803496:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803499:	8b 00                	mov    (%eax),%eax
  80349b:	85 c0                	test   %eax,%eax
  80349d:	74 10                	je     8034af <insert_sorted_with_merge_freeList+0x3b5>
  80349f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a2:	8b 00                	mov    (%eax),%eax
  8034a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a7:	8b 52 04             	mov    0x4(%edx),%edx
  8034aa:	89 50 04             	mov    %edx,0x4(%eax)
  8034ad:	eb 0b                	jmp    8034ba <insert_sorted_with_merge_freeList+0x3c0>
  8034af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b2:	8b 40 04             	mov    0x4(%eax),%eax
  8034b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bd:	8b 40 04             	mov    0x4(%eax),%eax
  8034c0:	85 c0                	test   %eax,%eax
  8034c2:	74 0f                	je     8034d3 <insert_sorted_with_merge_freeList+0x3d9>
  8034c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c7:	8b 40 04             	mov    0x4(%eax),%eax
  8034ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034cd:	8b 12                	mov    (%edx),%edx
  8034cf:	89 10                	mov    %edx,(%eax)
  8034d1:	eb 0a                	jmp    8034dd <insert_sorted_with_merge_freeList+0x3e3>
  8034d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	a3 38 51 80 00       	mov    %eax,0x805138
  8034dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8034f5:	48                   	dec    %eax
  8034f6:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8034fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803508:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80350f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803513:	75 17                	jne    80352c <insert_sorted_with_merge_freeList+0x432>
  803515:	83 ec 04             	sub    $0x4,%esp
  803518:	68 58 44 80 00       	push   $0x804458
  80351d:	68 5f 01 00 00       	push   $0x15f
  803522:	68 7b 44 80 00       	push   $0x80447b
  803527:	e8 6f d2 ff ff       	call   80079b <_panic>
  80352c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803535:	89 10                	mov    %edx,(%eax)
  803537:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353a:	8b 00                	mov    (%eax),%eax
  80353c:	85 c0                	test   %eax,%eax
  80353e:	74 0d                	je     80354d <insert_sorted_with_merge_freeList+0x453>
  803540:	a1 48 51 80 00       	mov    0x805148,%eax
  803545:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803548:	89 50 04             	mov    %edx,0x4(%eax)
  80354b:	eb 08                	jmp    803555 <insert_sorted_with_merge_freeList+0x45b>
  80354d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803550:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803555:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803558:	a3 48 51 80 00       	mov    %eax,0x805148
  80355d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803560:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803567:	a1 54 51 80 00       	mov    0x805154,%eax
  80356c:	40                   	inc    %eax
  80356d:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803575:	8b 50 0c             	mov    0xc(%eax),%edx
  803578:	8b 45 08             	mov    0x8(%ebp),%eax
  80357b:	8b 40 0c             	mov    0xc(%eax),%eax
  80357e:	01 c2                	add    %eax,%edx
  803580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803583:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803586:	8b 45 08             	mov    0x8(%ebp),%eax
  803589:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803590:	8b 45 08             	mov    0x8(%ebp),%eax
  803593:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80359a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80359e:	75 17                	jne    8035b7 <insert_sorted_with_merge_freeList+0x4bd>
  8035a0:	83 ec 04             	sub    $0x4,%esp
  8035a3:	68 58 44 80 00       	push   $0x804458
  8035a8:	68 64 01 00 00       	push   $0x164
  8035ad:	68 7b 44 80 00       	push   $0x80447b
  8035b2:	e8 e4 d1 ff ff       	call   80079b <_panic>
  8035b7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	89 10                	mov    %edx,(%eax)
  8035c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c5:	8b 00                	mov    (%eax),%eax
  8035c7:	85 c0                	test   %eax,%eax
  8035c9:	74 0d                	je     8035d8 <insert_sorted_with_merge_freeList+0x4de>
  8035cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8035d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d3:	89 50 04             	mov    %edx,0x4(%eax)
  8035d6:	eb 08                	jmp    8035e0 <insert_sorted_with_merge_freeList+0x4e6>
  8035d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8035e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8035f7:	40                   	inc    %eax
  8035f8:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8035fd:	e9 41 02 00 00       	jmp    803843 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803602:	8b 45 08             	mov    0x8(%ebp),%eax
  803605:	8b 50 08             	mov    0x8(%eax),%edx
  803608:	8b 45 08             	mov    0x8(%ebp),%eax
  80360b:	8b 40 0c             	mov    0xc(%eax),%eax
  80360e:	01 c2                	add    %eax,%edx
  803610:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803613:	8b 40 08             	mov    0x8(%eax),%eax
  803616:	39 c2                	cmp    %eax,%edx
  803618:	0f 85 7c 01 00 00    	jne    80379a <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80361e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803622:	74 06                	je     80362a <insert_sorted_with_merge_freeList+0x530>
  803624:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803628:	75 17                	jne    803641 <insert_sorted_with_merge_freeList+0x547>
  80362a:	83 ec 04             	sub    $0x4,%esp
  80362d:	68 94 44 80 00       	push   $0x804494
  803632:	68 69 01 00 00       	push   $0x169
  803637:	68 7b 44 80 00       	push   $0x80447b
  80363c:	e8 5a d1 ff ff       	call   80079b <_panic>
  803641:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803644:	8b 50 04             	mov    0x4(%eax),%edx
  803647:	8b 45 08             	mov    0x8(%ebp),%eax
  80364a:	89 50 04             	mov    %edx,0x4(%eax)
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803653:	89 10                	mov    %edx,(%eax)
  803655:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803658:	8b 40 04             	mov    0x4(%eax),%eax
  80365b:	85 c0                	test   %eax,%eax
  80365d:	74 0d                	je     80366c <insert_sorted_with_merge_freeList+0x572>
  80365f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803662:	8b 40 04             	mov    0x4(%eax),%eax
  803665:	8b 55 08             	mov    0x8(%ebp),%edx
  803668:	89 10                	mov    %edx,(%eax)
  80366a:	eb 08                	jmp    803674 <insert_sorted_with_merge_freeList+0x57a>
  80366c:	8b 45 08             	mov    0x8(%ebp),%eax
  80366f:	a3 38 51 80 00       	mov    %eax,0x805138
  803674:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803677:	8b 55 08             	mov    0x8(%ebp),%edx
  80367a:	89 50 04             	mov    %edx,0x4(%eax)
  80367d:	a1 44 51 80 00       	mov    0x805144,%eax
  803682:	40                   	inc    %eax
  803683:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803688:	8b 45 08             	mov    0x8(%ebp),%eax
  80368b:	8b 50 0c             	mov    0xc(%eax),%edx
  80368e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803691:	8b 40 0c             	mov    0xc(%eax),%eax
  803694:	01 c2                	add    %eax,%edx
  803696:	8b 45 08             	mov    0x8(%ebp),%eax
  803699:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80369c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036a0:	75 17                	jne    8036b9 <insert_sorted_with_merge_freeList+0x5bf>
  8036a2:	83 ec 04             	sub    $0x4,%esp
  8036a5:	68 24 45 80 00       	push   $0x804524
  8036aa:	68 6b 01 00 00       	push   $0x16b
  8036af:	68 7b 44 80 00       	push   $0x80447b
  8036b4:	e8 e2 d0 ff ff       	call   80079b <_panic>
  8036b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bc:	8b 00                	mov    (%eax),%eax
  8036be:	85 c0                	test   %eax,%eax
  8036c0:	74 10                	je     8036d2 <insert_sorted_with_merge_freeList+0x5d8>
  8036c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c5:	8b 00                	mov    (%eax),%eax
  8036c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036ca:	8b 52 04             	mov    0x4(%edx),%edx
  8036cd:	89 50 04             	mov    %edx,0x4(%eax)
  8036d0:	eb 0b                	jmp    8036dd <insert_sorted_with_merge_freeList+0x5e3>
  8036d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d5:	8b 40 04             	mov    0x4(%eax),%eax
  8036d8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e0:	8b 40 04             	mov    0x4(%eax),%eax
  8036e3:	85 c0                	test   %eax,%eax
  8036e5:	74 0f                	je     8036f6 <insert_sorted_with_merge_freeList+0x5fc>
  8036e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ea:	8b 40 04             	mov    0x4(%eax),%eax
  8036ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f0:	8b 12                	mov    (%edx),%edx
  8036f2:	89 10                	mov    %edx,(%eax)
  8036f4:	eb 0a                	jmp    803700 <insert_sorted_with_merge_freeList+0x606>
  8036f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f9:	8b 00                	mov    (%eax),%eax
  8036fb:	a3 38 51 80 00       	mov    %eax,0x805138
  803700:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803703:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803709:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803713:	a1 44 51 80 00       	mov    0x805144,%eax
  803718:	48                   	dec    %eax
  803719:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80371e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803721:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803728:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803732:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803736:	75 17                	jne    80374f <insert_sorted_with_merge_freeList+0x655>
  803738:	83 ec 04             	sub    $0x4,%esp
  80373b:	68 58 44 80 00       	push   $0x804458
  803740:	68 6e 01 00 00       	push   $0x16e
  803745:	68 7b 44 80 00       	push   $0x80447b
  80374a:	e8 4c d0 ff ff       	call   80079b <_panic>
  80374f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803758:	89 10                	mov    %edx,(%eax)
  80375a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375d:	8b 00                	mov    (%eax),%eax
  80375f:	85 c0                	test   %eax,%eax
  803761:	74 0d                	je     803770 <insert_sorted_with_merge_freeList+0x676>
  803763:	a1 48 51 80 00       	mov    0x805148,%eax
  803768:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80376b:	89 50 04             	mov    %edx,0x4(%eax)
  80376e:	eb 08                	jmp    803778 <insert_sorted_with_merge_freeList+0x67e>
  803770:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803773:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377b:	a3 48 51 80 00       	mov    %eax,0x805148
  803780:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803783:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80378a:	a1 54 51 80 00       	mov    0x805154,%eax
  80378f:	40                   	inc    %eax
  803790:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803795:	e9 a9 00 00 00       	jmp    803843 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80379a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80379e:	74 06                	je     8037a6 <insert_sorted_with_merge_freeList+0x6ac>
  8037a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037a4:	75 17                	jne    8037bd <insert_sorted_with_merge_freeList+0x6c3>
  8037a6:	83 ec 04             	sub    $0x4,%esp
  8037a9:	68 f0 44 80 00       	push   $0x8044f0
  8037ae:	68 73 01 00 00       	push   $0x173
  8037b3:	68 7b 44 80 00       	push   $0x80447b
  8037b8:	e8 de cf ff ff       	call   80079b <_panic>
  8037bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c0:	8b 10                	mov    (%eax),%edx
  8037c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c5:	89 10                	mov    %edx,(%eax)
  8037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ca:	8b 00                	mov    (%eax),%eax
  8037cc:	85 c0                	test   %eax,%eax
  8037ce:	74 0b                	je     8037db <insert_sorted_with_merge_freeList+0x6e1>
  8037d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d3:	8b 00                	mov    (%eax),%eax
  8037d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d8:	89 50 04             	mov    %edx,0x4(%eax)
  8037db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037de:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e1:	89 10                	mov    %edx,(%eax)
  8037e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037e9:	89 50 04             	mov    %edx,0x4(%eax)
  8037ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ef:	8b 00                	mov    (%eax),%eax
  8037f1:	85 c0                	test   %eax,%eax
  8037f3:	75 08                	jne    8037fd <insert_sorted_with_merge_freeList+0x703>
  8037f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037fd:	a1 44 51 80 00       	mov    0x805144,%eax
  803802:	40                   	inc    %eax
  803803:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803808:	eb 39                	jmp    803843 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80380a:	a1 40 51 80 00       	mov    0x805140,%eax
  80380f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803816:	74 07                	je     80381f <insert_sorted_with_merge_freeList+0x725>
  803818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381b:	8b 00                	mov    (%eax),%eax
  80381d:	eb 05                	jmp    803824 <insert_sorted_with_merge_freeList+0x72a>
  80381f:	b8 00 00 00 00       	mov    $0x0,%eax
  803824:	a3 40 51 80 00       	mov    %eax,0x805140
  803829:	a1 40 51 80 00       	mov    0x805140,%eax
  80382e:	85 c0                	test   %eax,%eax
  803830:	0f 85 c7 fb ff ff    	jne    8033fd <insert_sorted_with_merge_freeList+0x303>
  803836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80383a:	0f 85 bd fb ff ff    	jne    8033fd <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803840:	eb 01                	jmp    803843 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803842:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803843:	90                   	nop
  803844:	c9                   	leave  
  803845:	c3                   	ret    
  803846:	66 90                	xchg   %ax,%ax

00803848 <__udivdi3>:
  803848:	55                   	push   %ebp
  803849:	57                   	push   %edi
  80384a:	56                   	push   %esi
  80384b:	53                   	push   %ebx
  80384c:	83 ec 1c             	sub    $0x1c,%esp
  80384f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803853:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803857:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80385b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80385f:	89 ca                	mov    %ecx,%edx
  803861:	89 f8                	mov    %edi,%eax
  803863:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803867:	85 f6                	test   %esi,%esi
  803869:	75 2d                	jne    803898 <__udivdi3+0x50>
  80386b:	39 cf                	cmp    %ecx,%edi
  80386d:	77 65                	ja     8038d4 <__udivdi3+0x8c>
  80386f:	89 fd                	mov    %edi,%ebp
  803871:	85 ff                	test   %edi,%edi
  803873:	75 0b                	jne    803880 <__udivdi3+0x38>
  803875:	b8 01 00 00 00       	mov    $0x1,%eax
  80387a:	31 d2                	xor    %edx,%edx
  80387c:	f7 f7                	div    %edi
  80387e:	89 c5                	mov    %eax,%ebp
  803880:	31 d2                	xor    %edx,%edx
  803882:	89 c8                	mov    %ecx,%eax
  803884:	f7 f5                	div    %ebp
  803886:	89 c1                	mov    %eax,%ecx
  803888:	89 d8                	mov    %ebx,%eax
  80388a:	f7 f5                	div    %ebp
  80388c:	89 cf                	mov    %ecx,%edi
  80388e:	89 fa                	mov    %edi,%edx
  803890:	83 c4 1c             	add    $0x1c,%esp
  803893:	5b                   	pop    %ebx
  803894:	5e                   	pop    %esi
  803895:	5f                   	pop    %edi
  803896:	5d                   	pop    %ebp
  803897:	c3                   	ret    
  803898:	39 ce                	cmp    %ecx,%esi
  80389a:	77 28                	ja     8038c4 <__udivdi3+0x7c>
  80389c:	0f bd fe             	bsr    %esi,%edi
  80389f:	83 f7 1f             	xor    $0x1f,%edi
  8038a2:	75 40                	jne    8038e4 <__udivdi3+0x9c>
  8038a4:	39 ce                	cmp    %ecx,%esi
  8038a6:	72 0a                	jb     8038b2 <__udivdi3+0x6a>
  8038a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038ac:	0f 87 9e 00 00 00    	ja     803950 <__udivdi3+0x108>
  8038b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038b7:	89 fa                	mov    %edi,%edx
  8038b9:	83 c4 1c             	add    $0x1c,%esp
  8038bc:	5b                   	pop    %ebx
  8038bd:	5e                   	pop    %esi
  8038be:	5f                   	pop    %edi
  8038bf:	5d                   	pop    %ebp
  8038c0:	c3                   	ret    
  8038c1:	8d 76 00             	lea    0x0(%esi),%esi
  8038c4:	31 ff                	xor    %edi,%edi
  8038c6:	31 c0                	xor    %eax,%eax
  8038c8:	89 fa                	mov    %edi,%edx
  8038ca:	83 c4 1c             	add    $0x1c,%esp
  8038cd:	5b                   	pop    %ebx
  8038ce:	5e                   	pop    %esi
  8038cf:	5f                   	pop    %edi
  8038d0:	5d                   	pop    %ebp
  8038d1:	c3                   	ret    
  8038d2:	66 90                	xchg   %ax,%ax
  8038d4:	89 d8                	mov    %ebx,%eax
  8038d6:	f7 f7                	div    %edi
  8038d8:	31 ff                	xor    %edi,%edi
  8038da:	89 fa                	mov    %edi,%edx
  8038dc:	83 c4 1c             	add    $0x1c,%esp
  8038df:	5b                   	pop    %ebx
  8038e0:	5e                   	pop    %esi
  8038e1:	5f                   	pop    %edi
  8038e2:	5d                   	pop    %ebp
  8038e3:	c3                   	ret    
  8038e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038e9:	89 eb                	mov    %ebp,%ebx
  8038eb:	29 fb                	sub    %edi,%ebx
  8038ed:	89 f9                	mov    %edi,%ecx
  8038ef:	d3 e6                	shl    %cl,%esi
  8038f1:	89 c5                	mov    %eax,%ebp
  8038f3:	88 d9                	mov    %bl,%cl
  8038f5:	d3 ed                	shr    %cl,%ebp
  8038f7:	89 e9                	mov    %ebp,%ecx
  8038f9:	09 f1                	or     %esi,%ecx
  8038fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038ff:	89 f9                	mov    %edi,%ecx
  803901:	d3 e0                	shl    %cl,%eax
  803903:	89 c5                	mov    %eax,%ebp
  803905:	89 d6                	mov    %edx,%esi
  803907:	88 d9                	mov    %bl,%cl
  803909:	d3 ee                	shr    %cl,%esi
  80390b:	89 f9                	mov    %edi,%ecx
  80390d:	d3 e2                	shl    %cl,%edx
  80390f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803913:	88 d9                	mov    %bl,%cl
  803915:	d3 e8                	shr    %cl,%eax
  803917:	09 c2                	or     %eax,%edx
  803919:	89 d0                	mov    %edx,%eax
  80391b:	89 f2                	mov    %esi,%edx
  80391d:	f7 74 24 0c          	divl   0xc(%esp)
  803921:	89 d6                	mov    %edx,%esi
  803923:	89 c3                	mov    %eax,%ebx
  803925:	f7 e5                	mul    %ebp
  803927:	39 d6                	cmp    %edx,%esi
  803929:	72 19                	jb     803944 <__udivdi3+0xfc>
  80392b:	74 0b                	je     803938 <__udivdi3+0xf0>
  80392d:	89 d8                	mov    %ebx,%eax
  80392f:	31 ff                	xor    %edi,%edi
  803931:	e9 58 ff ff ff       	jmp    80388e <__udivdi3+0x46>
  803936:	66 90                	xchg   %ax,%ax
  803938:	8b 54 24 08          	mov    0x8(%esp),%edx
  80393c:	89 f9                	mov    %edi,%ecx
  80393e:	d3 e2                	shl    %cl,%edx
  803940:	39 c2                	cmp    %eax,%edx
  803942:	73 e9                	jae    80392d <__udivdi3+0xe5>
  803944:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803947:	31 ff                	xor    %edi,%edi
  803949:	e9 40 ff ff ff       	jmp    80388e <__udivdi3+0x46>
  80394e:	66 90                	xchg   %ax,%ax
  803950:	31 c0                	xor    %eax,%eax
  803952:	e9 37 ff ff ff       	jmp    80388e <__udivdi3+0x46>
  803957:	90                   	nop

00803958 <__umoddi3>:
  803958:	55                   	push   %ebp
  803959:	57                   	push   %edi
  80395a:	56                   	push   %esi
  80395b:	53                   	push   %ebx
  80395c:	83 ec 1c             	sub    $0x1c,%esp
  80395f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803963:	8b 74 24 34          	mov    0x34(%esp),%esi
  803967:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80396b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80396f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803973:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803977:	89 f3                	mov    %esi,%ebx
  803979:	89 fa                	mov    %edi,%edx
  80397b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80397f:	89 34 24             	mov    %esi,(%esp)
  803982:	85 c0                	test   %eax,%eax
  803984:	75 1a                	jne    8039a0 <__umoddi3+0x48>
  803986:	39 f7                	cmp    %esi,%edi
  803988:	0f 86 a2 00 00 00    	jbe    803a30 <__umoddi3+0xd8>
  80398e:	89 c8                	mov    %ecx,%eax
  803990:	89 f2                	mov    %esi,%edx
  803992:	f7 f7                	div    %edi
  803994:	89 d0                	mov    %edx,%eax
  803996:	31 d2                	xor    %edx,%edx
  803998:	83 c4 1c             	add    $0x1c,%esp
  80399b:	5b                   	pop    %ebx
  80399c:	5e                   	pop    %esi
  80399d:	5f                   	pop    %edi
  80399e:	5d                   	pop    %ebp
  80399f:	c3                   	ret    
  8039a0:	39 f0                	cmp    %esi,%eax
  8039a2:	0f 87 ac 00 00 00    	ja     803a54 <__umoddi3+0xfc>
  8039a8:	0f bd e8             	bsr    %eax,%ebp
  8039ab:	83 f5 1f             	xor    $0x1f,%ebp
  8039ae:	0f 84 ac 00 00 00    	je     803a60 <__umoddi3+0x108>
  8039b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8039b9:	29 ef                	sub    %ebp,%edi
  8039bb:	89 fe                	mov    %edi,%esi
  8039bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039c1:	89 e9                	mov    %ebp,%ecx
  8039c3:	d3 e0                	shl    %cl,%eax
  8039c5:	89 d7                	mov    %edx,%edi
  8039c7:	89 f1                	mov    %esi,%ecx
  8039c9:	d3 ef                	shr    %cl,%edi
  8039cb:	09 c7                	or     %eax,%edi
  8039cd:	89 e9                	mov    %ebp,%ecx
  8039cf:	d3 e2                	shl    %cl,%edx
  8039d1:	89 14 24             	mov    %edx,(%esp)
  8039d4:	89 d8                	mov    %ebx,%eax
  8039d6:	d3 e0                	shl    %cl,%eax
  8039d8:	89 c2                	mov    %eax,%edx
  8039da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039de:	d3 e0                	shl    %cl,%eax
  8039e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039e8:	89 f1                	mov    %esi,%ecx
  8039ea:	d3 e8                	shr    %cl,%eax
  8039ec:	09 d0                	or     %edx,%eax
  8039ee:	d3 eb                	shr    %cl,%ebx
  8039f0:	89 da                	mov    %ebx,%edx
  8039f2:	f7 f7                	div    %edi
  8039f4:	89 d3                	mov    %edx,%ebx
  8039f6:	f7 24 24             	mull   (%esp)
  8039f9:	89 c6                	mov    %eax,%esi
  8039fb:	89 d1                	mov    %edx,%ecx
  8039fd:	39 d3                	cmp    %edx,%ebx
  8039ff:	0f 82 87 00 00 00    	jb     803a8c <__umoddi3+0x134>
  803a05:	0f 84 91 00 00 00    	je     803a9c <__umoddi3+0x144>
  803a0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a0f:	29 f2                	sub    %esi,%edx
  803a11:	19 cb                	sbb    %ecx,%ebx
  803a13:	89 d8                	mov    %ebx,%eax
  803a15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a19:	d3 e0                	shl    %cl,%eax
  803a1b:	89 e9                	mov    %ebp,%ecx
  803a1d:	d3 ea                	shr    %cl,%edx
  803a1f:	09 d0                	or     %edx,%eax
  803a21:	89 e9                	mov    %ebp,%ecx
  803a23:	d3 eb                	shr    %cl,%ebx
  803a25:	89 da                	mov    %ebx,%edx
  803a27:	83 c4 1c             	add    $0x1c,%esp
  803a2a:	5b                   	pop    %ebx
  803a2b:	5e                   	pop    %esi
  803a2c:	5f                   	pop    %edi
  803a2d:	5d                   	pop    %ebp
  803a2e:	c3                   	ret    
  803a2f:	90                   	nop
  803a30:	89 fd                	mov    %edi,%ebp
  803a32:	85 ff                	test   %edi,%edi
  803a34:	75 0b                	jne    803a41 <__umoddi3+0xe9>
  803a36:	b8 01 00 00 00       	mov    $0x1,%eax
  803a3b:	31 d2                	xor    %edx,%edx
  803a3d:	f7 f7                	div    %edi
  803a3f:	89 c5                	mov    %eax,%ebp
  803a41:	89 f0                	mov    %esi,%eax
  803a43:	31 d2                	xor    %edx,%edx
  803a45:	f7 f5                	div    %ebp
  803a47:	89 c8                	mov    %ecx,%eax
  803a49:	f7 f5                	div    %ebp
  803a4b:	89 d0                	mov    %edx,%eax
  803a4d:	e9 44 ff ff ff       	jmp    803996 <__umoddi3+0x3e>
  803a52:	66 90                	xchg   %ax,%ax
  803a54:	89 c8                	mov    %ecx,%eax
  803a56:	89 f2                	mov    %esi,%edx
  803a58:	83 c4 1c             	add    $0x1c,%esp
  803a5b:	5b                   	pop    %ebx
  803a5c:	5e                   	pop    %esi
  803a5d:	5f                   	pop    %edi
  803a5e:	5d                   	pop    %ebp
  803a5f:	c3                   	ret    
  803a60:	3b 04 24             	cmp    (%esp),%eax
  803a63:	72 06                	jb     803a6b <__umoddi3+0x113>
  803a65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a69:	77 0f                	ja     803a7a <__umoddi3+0x122>
  803a6b:	89 f2                	mov    %esi,%edx
  803a6d:	29 f9                	sub    %edi,%ecx
  803a6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a73:	89 14 24             	mov    %edx,(%esp)
  803a76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a7e:	8b 14 24             	mov    (%esp),%edx
  803a81:	83 c4 1c             	add    $0x1c,%esp
  803a84:	5b                   	pop    %ebx
  803a85:	5e                   	pop    %esi
  803a86:	5f                   	pop    %edi
  803a87:	5d                   	pop    %ebp
  803a88:	c3                   	ret    
  803a89:	8d 76 00             	lea    0x0(%esi),%esi
  803a8c:	2b 04 24             	sub    (%esp),%eax
  803a8f:	19 fa                	sbb    %edi,%edx
  803a91:	89 d1                	mov    %edx,%ecx
  803a93:	89 c6                	mov    %eax,%esi
  803a95:	e9 71 ff ff ff       	jmp    803a0b <__umoddi3+0xb3>
  803a9a:	66 90                	xchg   %ax,%ax
  803a9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803aa0:	72 ea                	jb     803a8c <__umoddi3+0x134>
  803aa2:	89 d9                	mov    %ebx,%ecx
  803aa4:	e9 62 ff ff ff       	jmp    803a0b <__umoddi3+0xb3>
