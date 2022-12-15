
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 6f 05 00 00       	call   8005a5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	83 ec 74             	sub    $0x74,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 50 80 00       	mov    0x805020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 c0 3a 80 00       	push   $0x803ac0
  800092:	6a 14                	push   $0x14
  800094:	68 dc 3a 80 00       	push   $0x803adc
  800099:	e8 43 06 00 00       	call   8006e1 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 75 18 00 00       	call   80191d <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	//int sizeOfMemBlocksArray = ROUNDUP(((USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE) * sizeof(struct MemBlock), PAGE_SIZE) ;
	void* ptr_allocations[20] = {0};
  8000b9:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000bc:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c6:	89 d7                	mov    %edx,%edi
  8000c8:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 b5 1b 00 00       	call   801c84 <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d2:	e8 4d 1c 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  8000d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000dd:	01 c0                	add    %eax,%eax
  8000df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	50                   	push   %eax
  8000e6:	e8 32 18 00 00       	call   80191d <malloc>
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000f1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	79 0a                	jns    800102 <_main+0xca>
  8000f8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000fb:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800100:	76 14                	jbe    800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 f0 3a 80 00       	push   $0x803af0
  80010a:	6a 23                	push   $0x23
  80010c:	68 dc 3a 80 00       	push   $0x803adc
  800111:	e8 cb 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800116:	e8 69 1b 00 00       	call   801c84 <sys_calculate_free_frames>
  80011b:	89 c2                	mov    %eax,%edx
  80011d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800120:	39 c2                	cmp    %eax,%edx
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 20 3b 80 00       	push   $0x803b20
  80012c:	6a 27                	push   $0x27
  80012e:	68 dc 3a 80 00       	push   $0x803adc
  800133:	e8 a9 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 e7 1b 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 8c 3b 80 00       	push   $0x803b8c
  80014a:	6a 28                	push   $0x28
  80014c:	68 dc 3a 80 00       	push   $0x803adc
  800151:	e8 8b 05 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 29 1b 00 00       	call   801c84 <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015e:	e8 c1 1b 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  800163:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800169:	01 c0                	add    %eax,%eax
  80016b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	50                   	push   %eax
  800172:	e8 a6 17 00 00       	call   80191d <malloc>
  800177:	83 c4 10             	add    $0x10,%esp
  80017a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80017d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800180:	89 c2                	mov    %eax,%edx
  800182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800185:	01 c0                	add    %eax,%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	72 13                	jb     8001a3 <_main+0x16b>
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	76 14                	jbe    8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 f0 3a 80 00       	push   $0x803af0
  8001ab:	6a 2d                	push   $0x2d
  8001ad:	68 dc 3a 80 00       	push   $0x803adc
  8001b2:	e8 2a 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001b7:	e8 c8 1a 00 00       	call   801c84 <sys_calculate_free_frames>
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	39 c2                	cmp    %eax,%edx
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 20 3b 80 00       	push   $0x803b20
  8001cd:	6a 2f                	push   $0x2f
  8001cf:	68 dc 3a 80 00       	push   $0x803adc
  8001d4:	e8 08 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001d9:	e8 46 1b 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  8001de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 8c 3b 80 00       	push   $0x803b8c
  8001eb:	6a 30                	push   $0x30
  8001ed:	68 dc 3a 80 00       	push   $0x803adc
  8001f2:	e8 ea 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f7:	e8 88 1a 00 00       	call   801c84 <sys_calculate_free_frames>
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 20 1b 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  800204:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	01 d2                	add    %edx,%edx
  80020e:	01 d0                	add    %edx,%eax
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	50                   	push   %eax
  800214:	e8 04 17 00 00       	call   80191d <malloc>
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80021f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800222:	89 c2                	mov    %eax,%edx
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	c1 e0 02             	shl    $0x2,%eax
  80022a:	05 00 00 00 80       	add    $0x80000000,%eax
  80022f:	39 c2                	cmp    %eax,%edx
  800231:	72 14                	jb     800247 <_main+0x20f>
  800233:	8b 45 98             	mov    -0x68(%ebp),%eax
  800236:	89 c2                	mov    %eax,%edx
  800238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023b:	c1 e0 02             	shl    $0x2,%eax
  80023e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800243:	39 c2                	cmp    %eax,%edx
  800245:	76 14                	jbe    80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 f0 3a 80 00       	push   $0x803af0
  80024f:	6a 35                	push   $0x35
  800251:	68 dc 3a 80 00       	push   $0x803adc
  800256:	e8 86 04 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80025b:	e8 24 1a 00 00       	call   801c84 <sys_calculate_free_frames>
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 20 3b 80 00       	push   $0x803b20
  800271:	6a 37                	push   $0x37
  800273:	68 dc 3a 80 00       	push   $0x803adc
  800278:	e8 64 04 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80027d:	e8 a2 1a 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  800282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 8c 3b 80 00       	push   $0x803b8c
  80028f:	6a 38                	push   $0x38
  800291:	68 dc 3a 80 00       	push   $0x803adc
  800296:	e8 46 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029b:	e8 e4 19 00 00       	call   801c84 <sys_calculate_free_frames>
  8002a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a3:	e8 7c 1a 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  8002a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8002ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ae:	89 c2                	mov    %eax,%edx
  8002b0:	01 d2                	add    %edx,%edx
  8002b2:	01 d0                	add    %edx,%eax
  8002b4:	83 ec 0c             	sub    $0xc,%esp
  8002b7:	50                   	push   %eax
  8002b8:	e8 60 16 00 00       	call   80191d <malloc>
  8002bd:	83 c4 10             	add    $0x10,%esp
  8002c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002c3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002c6:	89 c2                	mov    %eax,%edx
  8002c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cb:	c1 e0 02             	shl    $0x2,%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d3:	c1 e0 02             	shl    $0x2,%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 00 00 00 80       	add    $0x80000000,%eax
  8002dd:	39 c2                	cmp    %eax,%edx
  8002df:	72 1e                	jb     8002ff <_main+0x2c7>
  8002e1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002e4:	89 c2                	mov    %eax,%edx
  8002e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e9:	c1 e0 02             	shl    $0x2,%eax
  8002ec:	89 c1                	mov    %eax,%ecx
  8002ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f1:	c1 e0 02             	shl    $0x2,%eax
  8002f4:	01 c8                	add    %ecx,%eax
  8002f6:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002fb:	39 c2                	cmp    %eax,%edx
  8002fd:	76 14                	jbe    800313 <_main+0x2db>
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	68 f0 3a 80 00       	push   $0x803af0
  800307:	6a 3d                	push   $0x3d
  800309:	68 dc 3a 80 00       	push   $0x803adc
  80030e:	e8 ce 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800313:	e8 6c 19 00 00       	call   801c84 <sys_calculate_free_frames>
  800318:	89 c2                	mov    %eax,%edx
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	74 14                	je     800335 <_main+0x2fd>
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	68 20 3b 80 00       	push   $0x803b20
  800329:	6a 3f                	push   $0x3f
  80032b:	68 dc 3a 80 00       	push   $0x803adc
  800330:	e8 ac 03 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800335:	e8 ea 19 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  80033a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 8c 3b 80 00       	push   $0x803b8c
  800347:	6a 40                	push   $0x40
  800349:	68 dc 3a 80 00       	push   $0x803adc
  80034e:	e8 8e 03 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800353:	e8 2c 19 00 00       	call   801c84 <sys_calculate_free_frames>
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035b:	e8 c4 19 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  800360:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800363:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800366:	89 d0                	mov    %edx,%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	01 c0                	add    %eax,%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	50                   	push   %eax
  800374:	e8 a4 15 00 00       	call   80191d <malloc>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80037f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800382:	89 c2                	mov    %eax,%edx
  800384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800387:	c1 e0 02             	shl    $0x2,%eax
  80038a:	89 c1                	mov    %eax,%ecx
  80038c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80038f:	c1 e0 03             	shl    $0x3,%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	05 00 00 00 80       	add    $0x80000000,%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	72 1e                	jb     8003bb <_main+0x383>
  80039d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a5:	c1 e0 02             	shl    $0x2,%eax
  8003a8:	89 c1                	mov    %eax,%ecx
  8003aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 c8                	add    %ecx,%eax
  8003b2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	76 14                	jbe    8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 f0 3a 80 00       	push   $0x803af0
  8003c3:	6a 45                	push   $0x45
  8003c5:	68 dc 3a 80 00       	push   $0x803adc
  8003ca:	e8 12 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003cf:	e8 b0 18 00 00       	call   801c84 <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	74 14                	je     8003f1 <_main+0x3b9>
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 20 3b 80 00       	push   $0x803b20
  8003e5:	6a 47                	push   $0x47
  8003e7:	68 dc 3a 80 00       	push   $0x803adc
  8003ec:	e8 f0 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003f1:	e8 2e 19 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  8003f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003f9:	74 14                	je     80040f <_main+0x3d7>
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 8c 3b 80 00       	push   $0x803b8c
  800403:	6a 48                	push   $0x48
  800405:	68 dc 3a 80 00       	push   $0x803adc
  80040a:	e8 d2 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80040f:	e8 70 18 00 00       	call   801c84 <sys_calculate_free_frames>
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800417:	e8 08 19 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  80041c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  80041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800422:	89 c2                	mov    %eax,%edx
  800424:	01 d2                	add    %edx,%edx
  800426:	01 d0                	add    %edx,%eax
  800428:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	50                   	push   %eax
  80042f:	e8 e9 14 00 00       	call   80191d <malloc>
  800434:	83 c4 10             	add    $0x10,%esp
  800437:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80043a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80043d:	89 c2                	mov    %eax,%edx
  80043f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800442:	c1 e0 02             	shl    $0x2,%eax
  800445:	89 c1                	mov    %eax,%ecx
  800447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044a:	c1 e0 04             	shl    $0x4,%eax
  80044d:	01 c8                	add    %ecx,%eax
  80044f:	05 00 00 00 80       	add    $0x80000000,%eax
  800454:	39 c2                	cmp    %eax,%edx
  800456:	72 1e                	jb     800476 <_main+0x43e>
  800458:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80045b:	89 c2                	mov    %eax,%edx
  80045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800460:	c1 e0 02             	shl    $0x2,%eax
  800463:	89 c1                	mov    %eax,%ecx
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	c1 e0 04             	shl    $0x4,%eax
  80046b:	01 c8                	add    %ecx,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 f0 3a 80 00       	push   $0x803af0
  80047e:	6a 4d                	push   $0x4d
  800480:	68 dc 3a 80 00       	push   $0x803adc
  800485:	e8 57 02 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80048a:	e8 f5 17 00 00       	call   801c84 <sys_calculate_free_frames>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <_main+0x474>
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 ba 3b 80 00       	push   $0x803bba
  8004a0:	6a 4e                	push   $0x4e
  8004a2:	68 dc 3a 80 00       	push   $0x803adc
  8004a7:	e8 35 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ac:	e8 73 18 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  8004b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004b4:	74 14                	je     8004ca <_main+0x492>
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 8c 3b 80 00       	push   $0x803b8c
  8004be:	6a 4f                	push   $0x4f
  8004c0:	68 dc 3a 80 00       	push   $0x803adc
  8004c5:	e8 17 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ca:	e8 b5 17 00 00       	call   801c84 <sys_calculate_free_frames>
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d2:	e8 4d 18 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  8004d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004dd:	01 c0                	add    %eax,%eax
  8004df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	50                   	push   %eax
  8004e6:	e8 32 14 00 00       	call   80191d <malloc>
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8004f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004f4:	89 c1                	mov    %eax,%ecx
  8004f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004f9:	89 d0                	mov    %edx,%eax
  8004fb:	01 c0                	add    %eax,%eax
  8004fd:	01 d0                	add    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	89 c2                	mov    %eax,%edx
  800505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800508:	c1 e0 04             	shl    $0x4,%eax
  80050b:	01 d0                	add    %edx,%eax
  80050d:	05 00 00 00 80       	add    $0x80000000,%eax
  800512:	39 c1                	cmp    %eax,%ecx
  800514:	72 25                	jb     80053b <_main+0x503>
  800516:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800519:	89 c1                	mov    %eax,%ecx
  80051b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051e:	89 d0                	mov    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d0                	add    %edx,%eax
  800524:	01 c0                	add    %eax,%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	89 c2                	mov    %eax,%edx
  80052a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80052d:	c1 e0 04             	shl    $0x4,%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800537:	39 c1                	cmp    %eax,%ecx
  800539:	76 14                	jbe    80054f <_main+0x517>
  80053b:	83 ec 04             	sub    $0x4,%esp
  80053e:	68 f0 3a 80 00       	push   $0x803af0
  800543:	6a 54                	push   $0x54
  800545:	68 dc 3a 80 00       	push   $0x803adc
  80054a:	e8 92 01 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80054f:	e8 30 17 00 00       	call   801c84 <sys_calculate_free_frames>
  800554:	89 c2                	mov    %eax,%edx
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 ba 3b 80 00       	push   $0x803bba
  800565:	6a 55                	push   $0x55
  800567:	68 dc 3a 80 00       	push   $0x803adc
  80056c:	e8 70 01 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800571:	e8 ae 17 00 00       	call   801d24 <sys_pf_calculate_allocated_pages>
  800576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 8c 3b 80 00       	push   $0x803b8c
  800583:	6a 56                	push   $0x56
  800585:	68 dc 3a 80 00       	push   $0x803adc
  80058a:	e8 52 01 00 00       	call   8006e1 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	68 d0 3b 80 00       	push   $0x803bd0
  800597:	e8 f9 03 00 00       	call   800995 <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

	return;
  80059f:	90                   	nop
}
  8005a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8005a3:	c9                   	leave  
  8005a4:	c3                   	ret    

008005a5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005ab:	e8 b4 19 00 00       	call   801f64 <sys_getenvindex>
  8005b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005b6:	89 d0                	mov    %edx,%eax
  8005b8:	c1 e0 03             	shl    $0x3,%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	01 c0                	add    %eax,%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 04             	shl    $0x4,%eax
  8005cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005d2:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005dc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005e2:	84 c0                	test   %al,%al
  8005e4:	74 0f                	je     8005f5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005eb:	05 5c 05 00 00       	add    $0x55c,%eax
  8005f0:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005f9:	7e 0a                	jle    800605 <libmain+0x60>
		binaryname = argv[0];
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 25 fa ff ff       	call   800038 <_main>
  800613:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800616:	e8 56 17 00 00       	call   801d71 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	68 24 3c 80 00       	push   $0x803c24
  800623:	e8 6d 03 00 00       	call   800995 <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80062b:	a1 20 50 80 00       	mov    0x805020,%eax
  800630:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800636:	a1 20 50 80 00       	mov    0x805020,%eax
  80063b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	52                   	push   %edx
  800645:	50                   	push   %eax
  800646:	68 4c 3c 80 00       	push   $0x803c4c
  80064b:	e8 45 03 00 00       	call   800995 <cprintf>
  800650:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800653:	a1 20 50 80 00       	mov    0x805020,%eax
  800658:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80065e:	a1 20 50 80 00       	mov    0x805020,%eax
  800663:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800669:	a1 20 50 80 00       	mov    0x805020,%eax
  80066e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800674:	51                   	push   %ecx
  800675:	52                   	push   %edx
  800676:	50                   	push   %eax
  800677:	68 74 3c 80 00       	push   $0x803c74
  80067c:	e8 14 03 00 00       	call   800995 <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800684:	a1 20 50 80 00       	mov    0x805020,%eax
  800689:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	68 cc 3c 80 00       	push   $0x803ccc
  800698:	e8 f8 02 00 00       	call   800995 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	68 24 3c 80 00       	push   $0x803c24
  8006a8:	e8 e8 02 00 00       	call   800995 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b0:	e8 d6 16 00 00       	call   801d8b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006b5:	e8 19 00 00 00       	call   8006d3 <exit>
}
  8006ba:	90                   	nop
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	6a 00                	push   $0x0
  8006c8:	e8 63 18 00 00       	call   801f30 <sys_destroy_env>
  8006cd:	83 c4 10             	add    $0x10,%esp
}
  8006d0:	90                   	nop
  8006d1:	c9                   	leave  
  8006d2:	c3                   	ret    

008006d3 <exit>:

void
exit(void)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006d9:	e8 b8 18 00 00       	call   801f96 <sys_exit_env>
}
  8006de:	90                   	nop
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8006ea:	83 c0 04             	add    $0x4,%eax
  8006ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006f0:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	74 16                	je     80070f <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006f9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	50                   	push   %eax
  800702:	68 e0 3c 80 00       	push   $0x803ce0
  800707:	e8 89 02 00 00       	call   800995 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070f:	a1 00 50 80 00       	mov    0x805000,%eax
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	50                   	push   %eax
  80071b:	68 e5 3c 80 00       	push   $0x803ce5
  800720:	e8 70 02 00 00       	call   800995 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800728:	8b 45 10             	mov    0x10(%ebp),%eax
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 f4             	pushl  -0xc(%ebp)
  800731:	50                   	push   %eax
  800732:	e8 f3 01 00 00       	call   80092a <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	6a 00                	push   $0x0
  80073f:	68 01 3d 80 00       	push   $0x803d01
  800744:	e8 e1 01 00 00       	call   80092a <vcprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80074c:	e8 82 ff ff ff       	call   8006d3 <exit>

	// should not return here
	while (1) ;
  800751:	eb fe                	jmp    800751 <_panic+0x70>

00800753 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800759:	a1 20 50 80 00       	mov    0x805020,%eax
  80075e:	8b 50 74             	mov    0x74(%eax),%edx
  800761:	8b 45 0c             	mov    0xc(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 14                	je     80077c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 04 3d 80 00       	push   $0x803d04
  800770:	6a 26                	push   $0x26
  800772:	68 50 3d 80 00       	push   $0x803d50
  800777:	e8 65 ff ff ff       	call   8006e1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80077c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800783:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80078a:	e9 c2 00 00 00       	jmp    800851 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80078f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800792:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	01 d0                	add    %edx,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	85 c0                	test   %eax,%eax
  8007a2:	75 08                	jne    8007ac <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007a4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007a7:	e9 a2 00 00 00       	jmp    80084e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ba:	eb 69                	jmp    800825 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8007c1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ca:	89 d0                	mov    %edx,%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	01 d0                	add    %edx,%eax
  8007d0:	c1 e0 03             	shl    $0x3,%eax
  8007d3:	01 c8                	add    %ecx,%eax
  8007d5:	8a 40 04             	mov    0x4(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	75 46                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007dc:	a1 20 50 80 00       	mov    0x805020,%eax
  8007e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ea:	89 d0                	mov    %edx,%eax
  8007ec:	01 c0                	add    %eax,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	c1 e0 03             	shl    $0x3,%eax
  8007f3:	01 c8                	add    %ecx,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800802:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800807:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	01 c8                	add    %ecx,%eax
  800813:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800815:	39 c2                	cmp    %eax,%edx
  800817:	75 09                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800819:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800820:	eb 12                	jmp    800834 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800822:	ff 45 e8             	incl   -0x18(%ebp)
  800825:	a1 20 50 80 00       	mov    0x805020,%eax
  80082a:	8b 50 74             	mov    0x74(%eax),%edx
  80082d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800830:	39 c2                	cmp    %eax,%edx
  800832:	77 88                	ja     8007bc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800834:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800838:	75 14                	jne    80084e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80083a:	83 ec 04             	sub    $0x4,%esp
  80083d:	68 5c 3d 80 00       	push   $0x803d5c
  800842:	6a 3a                	push   $0x3a
  800844:	68 50 3d 80 00       	push   $0x803d50
  800849:	e8 93 fe ff ff       	call   8006e1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80084e:	ff 45 f0             	incl   -0x10(%ebp)
  800851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800854:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800857:	0f 8c 32 ff ff ff    	jl     80078f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80085d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800864:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80086b:	eb 26                	jmp    800893 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80086d:	a1 20 50 80 00       	mov    0x805020,%eax
  800872:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800878:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80087b:	89 d0                	mov    %edx,%eax
  80087d:	01 c0                	add    %eax,%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	c1 e0 03             	shl    $0x3,%eax
  800884:	01 c8                	add    %ecx,%eax
  800886:	8a 40 04             	mov    0x4(%eax),%al
  800889:	3c 01                	cmp    $0x1,%al
  80088b:	75 03                	jne    800890 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80088d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800890:	ff 45 e0             	incl   -0x20(%ebp)
  800893:	a1 20 50 80 00       	mov    0x805020,%eax
  800898:	8b 50 74             	mov    0x74(%eax),%edx
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	39 c2                	cmp    %eax,%edx
  8008a0:	77 cb                	ja     80086d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008a8:	74 14                	je     8008be <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008aa:	83 ec 04             	sub    $0x4,%esp
  8008ad:	68 b0 3d 80 00       	push   $0x803db0
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 50 3d 80 00       	push   $0x803d50
  8008b9:	e8 23 fe ff ff       	call   8006e1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008be:	90                   	nop
  8008bf:	c9                   	leave  
  8008c0:	c3                   	ret    

008008c1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8008cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d2:	89 0a                	mov    %ecx,(%edx)
  8008d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d7:	88 d1                	mov    %dl,%cl
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ea:	75 2c                	jne    800918 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008ec:	a0 24 50 80 00       	mov    0x805024,%al
  8008f1:	0f b6 c0             	movzbl %al,%eax
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f7:	8b 12                	mov    (%edx),%edx
  8008f9:	89 d1                	mov    %edx,%ecx
  8008fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fe:	83 c2 08             	add    $0x8,%edx
  800901:	83 ec 04             	sub    $0x4,%esp
  800904:	50                   	push   %eax
  800905:	51                   	push   %ecx
  800906:	52                   	push   %edx
  800907:	e8 b7 12 00 00       	call   801bc3 <sys_cputs>
  80090c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091b:	8b 40 04             	mov    0x4(%eax),%eax
  80091e:	8d 50 01             	lea    0x1(%eax),%edx
  800921:	8b 45 0c             	mov    0xc(%ebp),%eax
  800924:	89 50 04             	mov    %edx,0x4(%eax)
}
  800927:	90                   	nop
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800933:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80093a:	00 00 00 
	b.cnt = 0;
  80093d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800944:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	68 c1 08 80 00       	push   $0x8008c1
  800959:	e8 11 02 00 00       	call   800b6f <vprintfmt>
  80095e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800961:	a0 24 50 80 00       	mov    0x805024,%al
  800966:	0f b6 c0             	movzbl %al,%eax
  800969:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	50                   	push   %eax
  800973:	52                   	push   %edx
  800974:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80097a:	83 c0 08             	add    $0x8,%eax
  80097d:	50                   	push   %eax
  80097e:	e8 40 12 00 00       	call   801bc3 <sys_cputs>
  800983:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800986:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80098d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <cprintf>:

int cprintf(const char *fmt, ...) {
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80099b:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8009a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b1:	50                   	push   %eax
  8009b2:	e8 73 ff ff ff       	call   80092a <vcprintf>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    

008009c2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009c8:	e8 a4 13 00 00       	call   801d71 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dc:	50                   	push   %eax
  8009dd:	e8 48 ff ff ff       	call   80092a <vcprintf>
  8009e2:	83 c4 10             	add    $0x10,%esp
  8009e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009e8:	e8 9e 13 00 00       	call   801d8b <sys_enable_interrupt>
	return cnt;
  8009ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	83 ec 14             	sub    $0x14,%esp
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a05:	8b 45 18             	mov    0x18(%ebp),%eax
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a10:	77 55                	ja     800a67 <printnum+0x75>
  800a12:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a15:	72 05                	jb     800a1c <printnum+0x2a>
  800a17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a1a:	77 4b                	ja     800a67 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a1c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a1f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a22:	8b 45 18             	mov    0x18(%ebp),%eax
  800a25:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2a:	52                   	push   %edx
  800a2b:	50                   	push   %eax
  800a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a32:	e8 11 2e 00 00       	call   803848 <__udivdi3>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	83 ec 04             	sub    $0x4,%esp
  800a3d:	ff 75 20             	pushl  0x20(%ebp)
  800a40:	53                   	push   %ebx
  800a41:	ff 75 18             	pushl  0x18(%ebp)
  800a44:	52                   	push   %edx
  800a45:	50                   	push   %eax
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	e8 a1 ff ff ff       	call   8009f2 <printnum>
  800a51:	83 c4 20             	add    $0x20,%esp
  800a54:	eb 1a                	jmp    800a70 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	ff 75 20             	pushl  0x20(%ebp)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a67:	ff 4d 1c             	decl   0x1c(%ebp)
  800a6a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a6e:	7f e6                	jg     800a56 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a70:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7e:	53                   	push   %ebx
  800a7f:	51                   	push   %ecx
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	e8 d1 2e 00 00       	call   803958 <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 14 40 80 00       	add    $0x804014,%eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	0f be c0             	movsbl %al,%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
}
  800aa3:	90                   	nop
  800aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ab0:	7e 1c                	jle    800ace <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 00                	mov    (%eax),%eax
  800ab7:	8d 50 08             	lea    0x8(%eax),%edx
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	89 10                	mov    %edx,(%eax)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	83 e8 08             	sub    $0x8,%eax
  800ac7:	8b 50 04             	mov    0x4(%eax),%edx
  800aca:	8b 00                	mov    (%eax),%eax
  800acc:	eb 40                	jmp    800b0e <getuint+0x65>
	else if (lflag)
  800ace:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad2:	74 1e                	je     800af2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	8d 50 04             	lea    0x4(%eax),%edx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	89 10                	mov    %edx,(%eax)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	83 e8 04             	sub    $0x4,%eax
  800ae9:	8b 00                	mov    (%eax),%eax
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	eb 1c                	jmp    800b0e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 50 04             	lea    0x4(%eax),%edx
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 10                	mov    %edx,(%eax)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 00                	mov    (%eax),%eax
  800b04:	83 e8 04             	sub    $0x4,%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b13:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b17:	7e 1c                	jle    800b35 <getint+0x25>
		return va_arg(*ap, long long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 08             	lea    0x8(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 08             	sub    $0x8,%eax
  800b2e:	8b 50 04             	mov    0x4(%eax),%edx
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	eb 38                	jmp    800b6d <getint+0x5d>
	else if (lflag)
  800b35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b39:	74 1a                	je     800b55 <getint+0x45>
		return va_arg(*ap, long);
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	8d 50 04             	lea    0x4(%eax),%edx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	89 10                	mov    %edx,(%eax)
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	83 e8 04             	sub    $0x4,%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	99                   	cltd   
  800b53:	eb 18                	jmp    800b6d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 50 04             	lea    0x4(%eax),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 10                	mov    %edx,(%eax)
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	83 e8 04             	sub    $0x4,%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	99                   	cltd   
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b77:	eb 17                	jmp    800b90 <vprintfmt+0x21>
			if (ch == '\0')
  800b79:	85 db                	test   %ebx,%ebx
  800b7b:	0f 84 af 03 00 00    	je     800f30 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	53                   	push   %ebx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	8d 50 01             	lea    0x1(%eax),%edx
  800b96:	89 55 10             	mov    %edx,0x10(%ebp)
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	0f b6 d8             	movzbl %al,%ebx
  800b9e:	83 fb 25             	cmp    $0x25,%ebx
  800ba1:	75 d6                	jne    800b79 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ba3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ba7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bb5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bbc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc6:	8d 50 01             	lea    0x1(%eax),%edx
  800bc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	0f b6 d8             	movzbl %al,%ebx
  800bd1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bd4:	83 f8 55             	cmp    $0x55,%eax
  800bd7:	0f 87 2b 03 00 00    	ja     800f08 <vprintfmt+0x399>
  800bdd:	8b 04 85 38 40 80 00 	mov    0x804038(,%eax,4),%eax
  800be4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800be6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bea:	eb d7                	jmp    800bc3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bec:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bf0:	eb d1                	jmp    800bc3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bfc:	89 d0                	mov    %edx,%eax
  800bfe:	c1 e0 02             	shl    $0x2,%eax
  800c01:	01 d0                	add    %edx,%eax
  800c03:	01 c0                	add    %eax,%eax
  800c05:	01 d8                	add    %ebx,%eax
  800c07:	83 e8 30             	sub    $0x30,%eax
  800c0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c15:	83 fb 2f             	cmp    $0x2f,%ebx
  800c18:	7e 3e                	jle    800c58 <vprintfmt+0xe9>
  800c1a:	83 fb 39             	cmp    $0x39,%ebx
  800c1d:	7f 39                	jg     800c58 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c1f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c22:	eb d5                	jmp    800bf9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	83 c0 04             	add    $0x4,%eax
  800c2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c38:	eb 1f                	jmp    800c59 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3e:	79 83                	jns    800bc3 <vprintfmt+0x54>
				width = 0;
  800c40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c47:	e9 77 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c4c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c53:	e9 6b ff ff ff       	jmp    800bc3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c58:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5d:	0f 89 60 ff ff ff    	jns    800bc3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c69:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c70:	e9 4e ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c75:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c78:	e9 46 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 c0 04             	add    $0x4,%eax
  800c83:	89 45 14             	mov    %eax,0x14(%ebp)
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	83 e8 04             	sub    $0x4,%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	ff d0                	call   *%eax
  800c9a:	83 c4 10             	add    $0x10,%esp
			break;
  800c9d:	e9 89 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ca2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca5:	83 c0 04             	add    $0x4,%eax
  800ca8:	89 45 14             	mov    %eax,0x14(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 e8 04             	sub    $0x4,%eax
  800cb1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cb3:	85 db                	test   %ebx,%ebx
  800cb5:	79 02                	jns    800cb9 <vprintfmt+0x14a>
				err = -err;
  800cb7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cb9:	83 fb 64             	cmp    $0x64,%ebx
  800cbc:	7f 0b                	jg     800cc9 <vprintfmt+0x15a>
  800cbe:	8b 34 9d 80 3e 80 00 	mov    0x803e80(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 25 40 80 00       	push   $0x804025
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	ff 75 08             	pushl  0x8(%ebp)
  800cd5:	e8 5e 02 00 00       	call   800f38 <printfmt>
  800cda:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cdd:	e9 49 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ce2:	56                   	push   %esi
  800ce3:	68 2e 40 80 00       	push   $0x80402e
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	ff 75 08             	pushl  0x8(%ebp)
  800cee:	e8 45 02 00 00       	call   800f38 <printfmt>
  800cf3:	83 c4 10             	add    $0x10,%esp
			break;
  800cf6:	e9 30 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfe:	83 c0 04             	add    $0x4,%eax
  800d01:	89 45 14             	mov    %eax,0x14(%ebp)
  800d04:	8b 45 14             	mov    0x14(%ebp),%eax
  800d07:	83 e8 04             	sub    $0x4,%eax
  800d0a:	8b 30                	mov    (%eax),%esi
  800d0c:	85 f6                	test   %esi,%esi
  800d0e:	75 05                	jne    800d15 <vprintfmt+0x1a6>
				p = "(null)";
  800d10:	be 31 40 80 00       	mov    $0x804031,%esi
			if (width > 0 && padc != '-')
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	7e 6d                	jle    800d88 <vprintfmt+0x219>
  800d1b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d1f:	74 67                	je     800d88 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d24:	83 ec 08             	sub    $0x8,%esp
  800d27:	50                   	push   %eax
  800d28:	56                   	push   %esi
  800d29:	e8 0c 03 00 00       	call   80103a <strnlen>
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d34:	eb 16                	jmp    800d4c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d36:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d3a:	83 ec 08             	sub    $0x8,%esp
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	50                   	push   %eax
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	ff d0                	call   *%eax
  800d46:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d49:	ff 4d e4             	decl   -0x1c(%ebp)
  800d4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d50:	7f e4                	jg     800d36 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d52:	eb 34                	jmp    800d88 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d58:	74 1c                	je     800d76 <vprintfmt+0x207>
  800d5a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d5d:	7e 05                	jle    800d64 <vprintfmt+0x1f5>
  800d5f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d62:	7e 12                	jle    800d76 <vprintfmt+0x207>
					putch('?', putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	6a 3f                	push   $0x3f
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	ff d0                	call   *%eax
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	eb 0f                	jmp    800d85 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	53                   	push   %ebx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	ff d0                	call   *%eax
  800d82:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d85:	ff 4d e4             	decl   -0x1c(%ebp)
  800d88:	89 f0                	mov    %esi,%eax
  800d8a:	8d 70 01             	lea    0x1(%eax),%esi
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f be d8             	movsbl %al,%ebx
  800d92:	85 db                	test   %ebx,%ebx
  800d94:	74 24                	je     800dba <vprintfmt+0x24b>
  800d96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d9a:	78 b8                	js     800d54 <vprintfmt+0x1e5>
  800d9c:	ff 4d e0             	decl   -0x20(%ebp)
  800d9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da3:	79 af                	jns    800d54 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	eb 13                	jmp    800dba <vprintfmt+0x24b>
				putch(' ', putdat);
  800da7:	83 ec 08             	sub    $0x8,%esp
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	6a 20                	push   $0x20
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	ff d0                	call   *%eax
  800db4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db7:	ff 4d e4             	decl   -0x1c(%ebp)
  800dba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbe:	7f e7                	jg     800da7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dc0:	e9 66 01 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcb:	8d 45 14             	lea    0x14(%ebp),%eax
  800dce:	50                   	push   %eax
  800dcf:	e8 3c fd ff ff       	call   800b10 <getint>
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de3:	85 d2                	test   %edx,%edx
  800de5:	79 23                	jns    800e0a <vprintfmt+0x29b>
				putch('-', putdat);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	6a 2d                	push   $0x2d
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfd:	f7 d8                	neg    %eax
  800dff:	83 d2 00             	adc    $0x0,%edx
  800e02:	f7 da                	neg    %edx
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e11:	e9 bc 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 e8             	pushl  -0x18(%ebp)
  800e1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e1f:	50                   	push   %eax
  800e20:	e8 84 fc ff ff       	call   800aa9 <getuint>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e35:	e9 98 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 0c             	pushl  0xc(%ebp)
  800e40:	6a 58                	push   $0x58
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	ff d0                	call   *%eax
  800e47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	6a 58                	push   $0x58
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	ff d0                	call   *%eax
  800e57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	6a 58                	push   $0x58
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	ff d0                	call   *%eax
  800e67:	83 c4 10             	add    $0x10,%esp
			break;
  800e6a:	e9 bc 00 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e6f:	83 ec 08             	sub    $0x8,%esp
  800e72:	ff 75 0c             	pushl  0xc(%ebp)
  800e75:	6a 30                	push   $0x30
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	ff d0                	call   *%eax
  800e7c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 78                	push   $0x78
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eaa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eb1:	eb 1f                	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 e8             	pushl  -0x18(%ebp)
  800eb9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebc:	50                   	push   %eax
  800ebd:	e8 e7 fb ff ff       	call   800aa9 <getuint>
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ecb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ed2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ed9:	83 ec 04             	sub    $0x4,%esp
  800edc:	52                   	push   %edx
  800edd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ee0:	50                   	push   %eax
  800ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ee7:	ff 75 0c             	pushl  0xc(%ebp)
  800eea:	ff 75 08             	pushl  0x8(%ebp)
  800eed:	e8 00 fb ff ff       	call   8009f2 <printnum>
  800ef2:	83 c4 20             	add    $0x20,%esp
			break;
  800ef5:	eb 34                	jmp    800f2b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	53                   	push   %ebx
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			break;
  800f06:	eb 23                	jmp    800f2b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	6a 25                	push   $0x25
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	ff d0                	call   *%eax
  800f15:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	eb 03                	jmp    800f20 <vprintfmt+0x3b1>
  800f1d:	ff 4d 10             	decl   0x10(%ebp)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	48                   	dec    %eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 25                	cmp    $0x25,%al
  800f28:	75 f3                	jne    800f1d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f2a:	90                   	nop
		}
	}
  800f2b:	e9 47 fc ff ff       	jmp    800b77 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f30:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f3e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4d:	50                   	push   %eax
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	e8 16 fc ff ff       	call   800b6f <vprintfmt>
  800f59:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f5c:	90                   	nop
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	8b 40 08             	mov    0x8(%eax),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8b 10                	mov    (%eax),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	8b 40 04             	mov    0x4(%eax),%eax
  800f7c:	39 c2                	cmp    %eax,%edx
  800f7e:	73 12                	jae    800f92 <sprintputch+0x33>
		*b->buf++ = ch;
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8b 00                	mov    (%eax),%eax
  800f85:	8d 48 01             	lea    0x1(%eax),%ecx
  800f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8b:	89 0a                	mov    %ecx,(%edx)
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	88 10                	mov    %dl,(%eax)
}
  800f92:	90                   	nop
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	01 d0                	add    %edx,%eax
  800fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fba:	74 06                	je     800fc2 <vsnprintf+0x2d>
  800fbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc0:	7f 07                	jg     800fc9 <vsnprintf+0x34>
		return -E_INVAL;
  800fc2:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc7:	eb 20                	jmp    800fe9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fc9:	ff 75 14             	pushl  0x14(%ebp)
  800fcc:	ff 75 10             	pushl  0x10(%ebp)
  800fcf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	68 5f 0f 80 00       	push   $0x800f5f
  800fd8:	e8 92 fb ff ff       	call   800b6f <vprintfmt>
  800fdd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ff1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff4:	83 c0 04             	add    $0x4,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	ff 75 f4             	pushl  -0xc(%ebp)
  801000:	50                   	push   %eax
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	ff 75 08             	pushl  0x8(%ebp)
  801007:	e8 89 ff ff ff       	call   800f95 <vsnprintf>
  80100c:	83 c4 10             	add    $0x10,%esp
  80100f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801012:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80101d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801024:	eb 06                	jmp    80102c <strlen+0x15>
		n++;
  801026:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801029:	ff 45 08             	incl   0x8(%ebp)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	75 f1                	jne    801026 <strlen+0xf>
		n++;
	return n;
  801035:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801047:	eb 09                	jmp    801052 <strnlen+0x18>
		n++;
  801049:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	ff 4d 0c             	decl   0xc(%ebp)
  801052:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801056:	74 09                	je     801061 <strnlen+0x27>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e8                	jne    801049 <strnlen+0xf>
		n++;
	return n;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801072:	90                   	nop
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8d 50 01             	lea    0x1(%eax),%edx
  801079:	89 55 08             	mov    %edx,0x8(%ebp)
  80107c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801082:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801085:	8a 12                	mov    (%edx),%dl
  801087:	88 10                	mov    %dl,(%eax)
  801089:	8a 00                	mov    (%eax),%al
  80108b:	84 c0                	test   %al,%al
  80108d:	75 e4                	jne    801073 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a7:	eb 1f                	jmp    8010c8 <strncpy+0x34>
		*dst++ = *src;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8d 50 01             	lea    0x1(%eax),%edx
  8010af:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b5:	8a 12                	mov    (%edx),%dl
  8010b7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	84 c0                	test   %al,%al
  8010c0:	74 03                	je     8010c5 <strncpy+0x31>
			src++;
  8010c2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010c5:	ff 45 fc             	incl   -0x4(%ebp)
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ce:	72 d9                	jb     8010a9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e5:	74 30                	je     801117 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010e7:	eb 16                	jmp    8010ff <strlcpy+0x2a>
			*dst++ = *src++;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fb:	8a 12                	mov    (%edx),%dl
  8010fd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ff:	ff 4d 10             	decl   0x10(%ebp)
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	74 09                	je     801111 <strlcpy+0x3c>
  801108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	84 c0                	test   %al,%al
  80110f:	75 d8                	jne    8010e9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111d:	29 c2                	sub    %eax,%edx
  80111f:	89 d0                	mov    %edx,%eax
}
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801126:	eb 06                	jmp    80112e <strcmp+0xb>
		p++, q++;
  801128:	ff 45 08             	incl   0x8(%ebp)
  80112b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	84 c0                	test   %al,%al
  801135:	74 0e                	je     801145 <strcmp+0x22>
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 10                	mov    (%eax),%dl
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	38 c2                	cmp    %al,%dl
  801143:	74 e3                	je     801128 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 d0             	movzbl %al,%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	29 c2                	sub    %eax,%edx
  801157:	89 d0                	mov    %edx,%eax
}
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80115e:	eb 09                	jmp    801169 <strncmp+0xe>
		n--, p++, q++;
  801160:	ff 4d 10             	decl   0x10(%ebp)
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801169:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116d:	74 17                	je     801186 <strncmp+0x2b>
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	84 c0                	test   %al,%al
  801176:	74 0e                	je     801186 <strncmp+0x2b>
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 10                	mov    (%eax),%dl
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	38 c2                	cmp    %al,%dl
  801184:	74 da                	je     801160 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801186:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118a:	75 07                	jne    801193 <strncmp+0x38>
		return 0;
  80118c:	b8 00 00 00 00       	mov    $0x0,%eax
  801191:	eb 14                	jmp    8011a7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	0f b6 d0             	movzbl %al,%edx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	0f b6 c0             	movzbl %al,%eax
  8011a3:	29 c2                	sub    %eax,%edx
  8011a5:	89 d0                	mov    %edx,%eax
}
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    

008011a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 04             	sub    $0x4,%esp
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b5:	eb 12                	jmp    8011c9 <strchr+0x20>
		if (*s == c)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011bf:	75 05                	jne    8011c6 <strchr+0x1d>
			return (char *) s;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	eb 11                	jmp    8011d7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c6:	ff 45 08             	incl   0x8(%ebp)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	84 c0                	test   %al,%al
  8011d0:	75 e5                	jne    8011b7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e5:	eb 0d                	jmp    8011f4 <strfind+0x1b>
		if (*s == c)
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ef:	74 0e                	je     8011ff <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011f1:	ff 45 08             	incl   0x8(%ebp)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	75 ea                	jne    8011e7 <strfind+0xe>
  8011fd:	eb 01                	jmp    801200 <strfind+0x27>
		if (*s == c)
			break;
  8011ff:	90                   	nop
	return (char *) s;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801217:	eb 0e                	jmp    801227 <memset+0x22>
		*p++ = c;
  801219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121c:	8d 50 01             	lea    0x1(%eax),%edx
  80121f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801222:	8b 55 0c             	mov    0xc(%ebp),%edx
  801225:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801227:	ff 4d f8             	decl   -0x8(%ebp)
  80122a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80122e:	79 e9                	jns    801219 <memset+0x14>
		*p++ = c;

	return v;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801247:	eb 16                	jmp    80125f <memcpy+0x2a>
		*d++ = *s++;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	8d 50 01             	lea    0x1(%eax),%edx
  80124f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801255:	8d 4a 01             	lea    0x1(%edx),%ecx
  801258:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80125b:	8a 12                	mov    (%edx),%dl
  80125d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	8d 50 ff             	lea    -0x1(%eax),%edx
  801265:	89 55 10             	mov    %edx,0x10(%ebp)
  801268:	85 c0                	test   %eax,%eax
  80126a:	75 dd                	jne    801249 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801283:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801286:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801289:	73 50                	jae    8012db <memmove+0x6a>
  80128b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801296:	76 43                	jbe    8012db <memmove+0x6a>
		s += n;
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80129e:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a4:	eb 10                	jmp    8012b6 <memmove+0x45>
			*--d = *--s;
  8012a6:	ff 4d f8             	decl   -0x8(%ebp)
  8012a9:	ff 4d fc             	decl   -0x4(%ebp)
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012af:	8a 10                	mov    (%eax),%dl
  8012b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	75 e3                	jne    8012a6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c3:	eb 23                	jmp    8012e8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d7:	8a 12                	mov    (%edx),%dl
  8012d9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	75 dd                	jne    8012c5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ff:	eb 2a                	jmp    80132b <memcmp+0x3e>
		if (*s1 != *s2)
  801301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801304:	8a 10                	mov    (%eax),%dl
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	38 c2                	cmp    %al,%dl
  80130d:	74 16                	je     801325 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f b6 d0             	movzbl %al,%edx
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f b6 c0             	movzbl %al,%eax
  80131f:	29 c2                	sub    %eax,%edx
  801321:	89 d0                	mov    %edx,%eax
  801323:	eb 18                	jmp    80133d <memcmp+0x50>
		s1++, s2++;
  801325:	ff 45 fc             	incl   -0x4(%ebp)
  801328:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80132b:	8b 45 10             	mov    0x10(%ebp),%eax
  80132e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801331:	89 55 10             	mov    %edx,0x10(%ebp)
  801334:	85 c0                	test   %eax,%eax
  801336:	75 c9                	jne    801301 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801345:	8b 55 08             	mov    0x8(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801350:	eb 15                	jmp    801367 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f b6 d0             	movzbl %al,%edx
  80135a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135d:	0f b6 c0             	movzbl %al,%eax
  801360:	39 c2                	cmp    %eax,%edx
  801362:	74 0d                	je     801371 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801364:	ff 45 08             	incl   0x8(%ebp)
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80136d:	72 e3                	jb     801352 <memfind+0x13>
  80136f:	eb 01                	jmp    801372 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801371:	90                   	nop
	return (void *) s;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80137d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801384:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138b:	eb 03                	jmp    801390 <strtol+0x19>
		s++;
  80138d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 20                	cmp    $0x20,%al
  801397:	74 f4                	je     80138d <strtol+0x16>
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	3c 09                	cmp    $0x9,%al
  8013a0:	74 eb                	je     80138d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	3c 2b                	cmp    $0x2b,%al
  8013a9:	75 05                	jne    8013b0 <strtol+0x39>
		s++;
  8013ab:	ff 45 08             	incl   0x8(%ebp)
  8013ae:	eb 13                	jmp    8013c3 <strtol+0x4c>
	else if (*s == '-')
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	3c 2d                	cmp    $0x2d,%al
  8013b7:	75 0a                	jne    8013c3 <strtol+0x4c>
		s++, neg = 1;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
  8013bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c7:	74 06                	je     8013cf <strtol+0x58>
  8013c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013cd:	75 20                	jne    8013ef <strtol+0x78>
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	3c 30                	cmp    $0x30,%al
  8013d6:	75 17                	jne    8013ef <strtol+0x78>
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	40                   	inc    %eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	3c 78                	cmp    $0x78,%al
  8013e0:	75 0d                	jne    8013ef <strtol+0x78>
		s += 2, base = 16;
  8013e2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013ed:	eb 28                	jmp    801417 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f3:	75 15                	jne    80140a <strtol+0x93>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	3c 30                	cmp    $0x30,%al
  8013fc:	75 0c                	jne    80140a <strtol+0x93>
		s++, base = 8;
  8013fe:	ff 45 08             	incl   0x8(%ebp)
  801401:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801408:	eb 0d                	jmp    801417 <strtol+0xa0>
	else if (base == 0)
  80140a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140e:	75 07                	jne    801417 <strtol+0xa0>
		base = 10;
  801410:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	3c 2f                	cmp    $0x2f,%al
  80141e:	7e 19                	jle    801439 <strtol+0xc2>
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 39                	cmp    $0x39,%al
  801427:	7f 10                	jg     801439 <strtol+0xc2>
			dig = *s - '0';
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	0f be c0             	movsbl %al,%eax
  801431:	83 e8 30             	sub    $0x30,%eax
  801434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801437:	eb 42                	jmp    80147b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 60                	cmp    $0x60,%al
  801440:	7e 19                	jle    80145b <strtol+0xe4>
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	3c 7a                	cmp    $0x7a,%al
  801449:	7f 10                	jg     80145b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	83 e8 57             	sub    $0x57,%eax
  801456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801459:	eb 20                	jmp    80147b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	3c 40                	cmp    $0x40,%al
  801462:	7e 39                	jle    80149d <strtol+0x126>
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 5a                	cmp    $0x5a,%al
  80146b:	7f 30                	jg     80149d <strtol+0x126>
			dig = *s - 'A' + 10;
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	0f be c0             	movsbl %al,%eax
  801475:	83 e8 37             	sub    $0x37,%eax
  801478:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801481:	7d 19                	jge    80149c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801483:	ff 45 08             	incl   0x8(%ebp)
  801486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801489:	0f af 45 10          	imul   0x10(%ebp),%eax
  80148d:	89 c2                	mov    %eax,%edx
  80148f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801492:	01 d0                	add    %edx,%eax
  801494:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801497:	e9 7b ff ff ff       	jmp    801417 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80149c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80149d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a1:	74 08                	je     8014ab <strtol+0x134>
		*endptr = (char *) s;
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014af:	74 07                	je     8014b8 <strtol+0x141>
  8014b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b4:	f7 d8                	neg    %eax
  8014b6:	eb 03                	jmp    8014bb <strtol+0x144>
  8014b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <ltostr>:

void
ltostr(long value, char *str)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d5:	79 13                	jns    8014ea <ltostr+0x2d>
	{
		neg = 1;
  8014d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f2:	99                   	cltd   
  8014f3:	f7 f9                	idiv   %ecx
  8014f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fb:	8d 50 01             	lea    0x1(%eax),%edx
  8014fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801501:	89 c2                	mov    %eax,%edx
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	01 d0                	add    %edx,%eax
  801508:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80150b:	83 c2 30             	add    $0x30,%edx
  80150e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801510:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801513:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801518:	f7 e9                	imul   %ecx
  80151a:	c1 fa 02             	sar    $0x2,%edx
  80151d:	89 c8                	mov    %ecx,%eax
  80151f:	c1 f8 1f             	sar    $0x1f,%eax
  801522:	29 c2                	sub    %eax,%edx
  801524:	89 d0                	mov    %edx,%eax
  801526:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801531:	f7 e9                	imul   %ecx
  801533:	c1 fa 02             	sar    $0x2,%edx
  801536:	89 c8                	mov    %ecx,%eax
  801538:	c1 f8 1f             	sar    $0x1f,%eax
  80153b:	29 c2                	sub    %eax,%edx
  80153d:	89 d0                	mov    %edx,%eax
  80153f:	c1 e0 02             	shl    $0x2,%eax
  801542:	01 d0                	add    %edx,%eax
  801544:	01 c0                	add    %eax,%eax
  801546:	29 c1                	sub    %eax,%ecx
  801548:	89 ca                	mov    %ecx,%edx
  80154a:	85 d2                	test   %edx,%edx
  80154c:	75 9c                	jne    8014ea <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80154e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801555:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801558:	48                   	dec    %eax
  801559:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80155c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801560:	74 3d                	je     80159f <ltostr+0xe2>
		start = 1 ;
  801562:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801569:	eb 34                	jmp    80159f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80156b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 c2                	add    %eax,%edx
  801580:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	01 c8                	add    %ecx,%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80158c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	01 c2                	add    %eax,%edx
  801594:	8a 45 eb             	mov    -0x15(%ebp),%al
  801597:	88 02                	mov    %al,(%edx)
		start++ ;
  801599:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80159c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015a5:	7c c4                	jl     80156b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ad:	01 d0                	add    %edx,%eax
  8015af:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 54 fa ff ff       	call   801017 <strlen>
  8015c3:	83 c4 04             	add    $0x4,%esp
  8015c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	e8 46 fa ff ff       	call   801017 <strlen>
  8015d1:	83 c4 04             	add    $0x4,%esp
  8015d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e5:	eb 17                	jmp    8015fe <strcconcat+0x49>
		final[s] = str1[s] ;
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	01 c2                	add    %eax,%edx
  8015ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	01 c8                	add    %ecx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015fb:	ff 45 fc             	incl   -0x4(%ebp)
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801601:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801604:	7c e1                	jl     8015e7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801606:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80160d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801614:	eb 1f                	jmp    801635 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801616:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801619:	8d 50 01             	lea    0x1(%eax),%edx
  80161c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161f:	89 c2                	mov    %eax,%edx
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	01 c2                	add    %eax,%edx
  801626:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162c:	01 c8                	add    %ecx,%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801632:	ff 45 f8             	incl   -0x8(%ebp)
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801638:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80163b:	7c d9                	jl     801616 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80163d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	c6 00 00             	movb   $0x0,(%eax)
}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80164e:	8b 45 14             	mov    0x14(%ebp),%eax
  801651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801657:	8b 45 14             	mov    0x14(%ebp),%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166e:	eb 0c                	jmp    80167c <strsplit+0x31>
			*string++ = 0;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	8d 50 01             	lea    0x1(%eax),%edx
  801676:	89 55 08             	mov    %edx,0x8(%ebp)
  801679:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	84 c0                	test   %al,%al
  801683:	74 18                	je     80169d <strsplit+0x52>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	50                   	push   %eax
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	e8 13 fb ff ff       	call   8011a9 <strchr>
  801696:	83 c4 08             	add    $0x8,%esp
  801699:	85 c0                	test   %eax,%eax
  80169b:	75 d3                	jne    801670 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8a 00                	mov    (%eax),%al
  8016a2:	84 c0                	test   %al,%al
  8016a4:	74 5a                	je     801700 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	83 f8 0f             	cmp    $0xf,%eax
  8016ae:	75 07                	jne    8016b7 <strsplit+0x6c>
		{
			return 0;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 66                	jmp    80171d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ba:	8b 00                	mov    (%eax),%eax
  8016bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8016bf:	8b 55 14             	mov    0x14(%ebp),%edx
  8016c2:	89 0a                	mov    %ecx,(%edx)
  8016c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ce:	01 c2                	add    %eax,%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d5:	eb 03                	jmp    8016da <strsplit+0x8f>
			string++;
  8016d7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 8b                	je     80166e <strsplit+0x23>
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f be c0             	movsbl %al,%eax
  8016eb:	50                   	push   %eax
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	e8 b5 fa ff ff       	call   8011a9 <strchr>
  8016f4:	83 c4 08             	add    $0x8,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	74 dc                	je     8016d7 <strsplit+0x8c>
			string++;
	}
  8016fb:	e9 6e ff ff ff       	jmp    80166e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801700:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801701:	8b 45 14             	mov    0x14(%ebp),%eax
  801704:	8b 00                	mov    (%eax),%eax
  801706:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80170d:	8b 45 10             	mov    0x10(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801718:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801725:	a1 04 50 80 00       	mov    0x805004,%eax
  80172a:	85 c0                	test   %eax,%eax
  80172c:	74 1f                	je     80174d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80172e:	e8 1d 00 00 00       	call   801750 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	68 90 41 80 00       	push   $0x804190
  80173b:	e8 55 f2 ff ff       	call   800995 <cprintf>
  801740:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801743:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80174a:	00 00 00 
	}
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801756:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80175d:	00 00 00 
  801760:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801767:	00 00 00 
  80176a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801771:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801774:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80177b:	00 00 00 
  80177e:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801785:	00 00 00 
  801788:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80178f:	00 00 00 
	uint32 arr_size = 0;
  801792:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801799:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8017a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017a8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017ad:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8017b2:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8017b9:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8017bc:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017c3:	a1 20 51 80 00       	mov    0x805120,%eax
  8017c8:	c1 e0 04             	shl    $0x4,%eax
  8017cb:	89 c2                	mov    %eax,%edx
  8017cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d0:	01 d0                	add    %edx,%eax
  8017d2:	48                   	dec    %eax
  8017d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017de:	f7 75 ec             	divl   -0x14(%ebp)
  8017e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e4:	29 d0                	sub    %edx,%eax
  8017e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8017e9:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8017f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017f8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017fd:	83 ec 04             	sub    $0x4,%esp
  801800:	6a 06                	push   $0x6
  801802:	ff 75 f4             	pushl  -0xc(%ebp)
  801805:	50                   	push   %eax
  801806:	e8 fc 04 00 00       	call   801d07 <sys_allocate_chunk>
  80180b:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80180e:	a1 20 51 80 00       	mov    0x805120,%eax
  801813:	83 ec 0c             	sub    $0xc,%esp
  801816:	50                   	push   %eax
  801817:	e8 71 0b 00 00       	call   80238d <initialize_MemBlocksList>
  80181c:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  80181f:	a1 48 51 80 00       	mov    0x805148,%eax
  801824:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801827:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801831:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801834:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  80183b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80183f:	75 14                	jne    801855 <initialize_dyn_block_system+0x105>
  801841:	83 ec 04             	sub    $0x4,%esp
  801844:	68 b5 41 80 00       	push   $0x8041b5
  801849:	6a 33                	push   $0x33
  80184b:	68 d3 41 80 00       	push   $0x8041d3
  801850:	e8 8c ee ff ff       	call   8006e1 <_panic>
  801855:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801858:	8b 00                	mov    (%eax),%eax
  80185a:	85 c0                	test   %eax,%eax
  80185c:	74 10                	je     80186e <initialize_dyn_block_system+0x11e>
  80185e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801861:	8b 00                	mov    (%eax),%eax
  801863:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801866:	8b 52 04             	mov    0x4(%edx),%edx
  801869:	89 50 04             	mov    %edx,0x4(%eax)
  80186c:	eb 0b                	jmp    801879 <initialize_dyn_block_system+0x129>
  80186e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801871:	8b 40 04             	mov    0x4(%eax),%eax
  801874:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801879:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187c:	8b 40 04             	mov    0x4(%eax),%eax
  80187f:	85 c0                	test   %eax,%eax
  801881:	74 0f                	je     801892 <initialize_dyn_block_system+0x142>
  801883:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801886:	8b 40 04             	mov    0x4(%eax),%eax
  801889:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80188c:	8b 12                	mov    (%edx),%edx
  80188e:	89 10                	mov    %edx,(%eax)
  801890:	eb 0a                	jmp    80189c <initialize_dyn_block_system+0x14c>
  801892:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801895:	8b 00                	mov    (%eax),%eax
  801897:	a3 48 51 80 00       	mov    %eax,0x805148
  80189c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018af:	a1 54 51 80 00       	mov    0x805154,%eax
  8018b4:	48                   	dec    %eax
  8018b5:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8018ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018be:	75 14                	jne    8018d4 <initialize_dyn_block_system+0x184>
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	68 e0 41 80 00       	push   $0x8041e0
  8018c8:	6a 34                	push   $0x34
  8018ca:	68 d3 41 80 00       	push   $0x8041d3
  8018cf:	e8 0d ee ff ff       	call   8006e1 <_panic>
  8018d4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8018da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018dd:	89 10                	mov    %edx,(%eax)
  8018df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e2:	8b 00                	mov    (%eax),%eax
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	74 0d                	je     8018f5 <initialize_dyn_block_system+0x1a5>
  8018e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8018ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018f0:	89 50 04             	mov    %edx,0x4(%eax)
  8018f3:	eb 08                	jmp    8018fd <initialize_dyn_block_system+0x1ad>
  8018f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8018fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801900:	a3 38 51 80 00       	mov    %eax,0x805138
  801905:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801908:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80190f:	a1 44 51 80 00       	mov    0x805144,%eax
  801914:	40                   	inc    %eax
  801915:	a3 44 51 80 00       	mov    %eax,0x805144
}
  80191a:	90                   	nop
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801923:	e8 f7 fd ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801928:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80192c:	75 07                	jne    801935 <malloc+0x18>
  80192e:	b8 00 00 00 00       	mov    $0x0,%eax
  801933:	eb 61                	jmp    801996 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801935:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80193c:	8b 55 08             	mov    0x8(%ebp),%edx
  80193f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801942:	01 d0                	add    %edx,%eax
  801944:	48                   	dec    %eax
  801945:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194b:	ba 00 00 00 00       	mov    $0x0,%edx
  801950:	f7 75 f0             	divl   -0x10(%ebp)
  801953:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801956:	29 d0                	sub    %edx,%eax
  801958:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80195b:	e8 75 07 00 00       	call   8020d5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801960:	85 c0                	test   %eax,%eax
  801962:	74 11                	je     801975 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801964:	83 ec 0c             	sub    $0xc,%esp
  801967:	ff 75 e8             	pushl  -0x18(%ebp)
  80196a:	e8 e0 0d 00 00       	call   80274f <alloc_block_FF>
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801975:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801979:	74 16                	je     801991 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80197b:	83 ec 0c             	sub    $0xc,%esp
  80197e:	ff 75 f4             	pushl  -0xc(%ebp)
  801981:	e8 3c 0b 00 00       	call   8024c2 <insert_sorted_allocList>
  801986:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198c:	8b 40 08             	mov    0x8(%eax),%eax
  80198f:	eb 05                	jmp    801996 <malloc+0x79>
	}

    return NULL;
  801991:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80199e:	83 ec 04             	sub    $0x4,%esp
  8019a1:	68 04 42 80 00       	push   $0x804204
  8019a6:	6a 6f                	push   $0x6f
  8019a8:	68 d3 41 80 00       	push   $0x8041d3
  8019ad:	e8 2f ed ff ff       	call   8006e1 <_panic>

008019b2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 38             	sub    $0x38,%esp
  8019b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bb:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019be:	e8 5c fd ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  8019c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019c7:	75 0a                	jne    8019d3 <smalloc+0x21>
  8019c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ce:	e9 8b 00 00 00       	jmp    801a5e <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8019d3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e0:	01 d0                	add    %edx,%eax
  8019e2:	48                   	dec    %eax
  8019e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ee:	f7 75 f0             	divl   -0x10(%ebp)
  8019f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f4:	29 d0                	sub    %edx,%eax
  8019f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8019f9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a00:	e8 d0 06 00 00       	call   8020d5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a05:	85 c0                	test   %eax,%eax
  801a07:	74 11                	je     801a1a <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801a09:	83 ec 0c             	sub    $0xc,%esp
  801a0c:	ff 75 e8             	pushl  -0x18(%ebp)
  801a0f:	e8 3b 0d 00 00       	call   80274f <alloc_block_FF>
  801a14:	83 c4 10             	add    $0x10,%esp
  801a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801a1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a1e:	74 39                	je     801a59 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a23:	8b 40 08             	mov    0x8(%eax),%eax
  801a26:	89 c2                	mov    %eax,%edx
  801a28:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a2c:	52                   	push   %edx
  801a2d:	50                   	push   %eax
  801a2e:	ff 75 0c             	pushl  0xc(%ebp)
  801a31:	ff 75 08             	pushl  0x8(%ebp)
  801a34:	e8 21 04 00 00       	call   801e5a <sys_createSharedObject>
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801a3f:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801a43:	74 14                	je     801a59 <smalloc+0xa7>
  801a45:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801a49:	74 0e                	je     801a59 <smalloc+0xa7>
  801a4b:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801a4f:	74 08                	je     801a59 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a54:	8b 40 08             	mov    0x8(%eax),%eax
  801a57:	eb 05                	jmp    801a5e <smalloc+0xac>
	}
	return NULL;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a66:	e8 b4 fc ff ff       	call   80171f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801a6b:	83 ec 08             	sub    $0x8,%esp
  801a6e:	ff 75 0c             	pushl  0xc(%ebp)
  801a71:	ff 75 08             	pushl  0x8(%ebp)
  801a74:	e8 0b 04 00 00       	call   801e84 <sys_getSizeOfSharedObject>
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801a7f:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801a83:	74 76                	je     801afb <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a85:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a92:	01 d0                	add    %edx,%eax
  801a94:	48                   	dec    %eax
  801a95:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa0:	f7 75 ec             	divl   -0x14(%ebp)
  801aa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aa6:	29 d0                	sub    %edx,%eax
  801aa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801aab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801ab2:	e8 1e 06 00 00       	call   8020d5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	74 11                	je     801acc <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801abb:	83 ec 0c             	sub    $0xc,%esp
  801abe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ac1:	e8 89 0c 00 00       	call   80274f <alloc_block_FF>
  801ac6:	83 c4 10             	add    $0x10,%esp
  801ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801acc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ad0:	74 29                	je     801afb <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad5:	8b 40 08             	mov    0x8(%eax),%eax
  801ad8:	83 ec 04             	sub    $0x4,%esp
  801adb:	50                   	push   %eax
  801adc:	ff 75 0c             	pushl  0xc(%ebp)
  801adf:	ff 75 08             	pushl  0x8(%ebp)
  801ae2:	e8 ba 03 00 00       	call   801ea1 <sys_getSharedObject>
  801ae7:	83 c4 10             	add    $0x10,%esp
  801aea:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801aed:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801af1:	74 08                	je     801afb <sget+0x9b>
				return (void *)mem_block->sva;
  801af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af6:	8b 40 08             	mov    0x8(%eax),%eax
  801af9:	eb 05                	jmp    801b00 <sget+0xa0>
		}
	}
	return NULL;
  801afb:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

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
  801b08:	e8 12 fc ff ff       	call   80171f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b0d:	83 ec 04             	sub    $0x4,%esp
  801b10:	68 28 42 80 00       	push   $0x804228
  801b15:	68 f1 00 00 00       	push   $0xf1
  801b1a:	68 d3 41 80 00       	push   $0x8041d3
  801b1f:	e8 bd eb ff ff       	call   8006e1 <_panic>

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
  801b2d:	68 50 42 80 00       	push   $0x804250
  801b32:	68 05 01 00 00       	push   $0x105
  801b37:	68 d3 41 80 00       	push   $0x8041d3
  801b3c:	e8 a0 eb ff ff       	call   8006e1 <_panic>

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
  801b4a:	68 74 42 80 00       	push   $0x804274
  801b4f:	68 10 01 00 00       	push   $0x110
  801b54:	68 d3 41 80 00       	push   $0x8041d3
  801b59:	e8 83 eb ff ff       	call   8006e1 <_panic>

00801b5e <shrink>:

}
void shrink(uint32 newSize)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	68 74 42 80 00       	push   $0x804274
  801b6c:	68 15 01 00 00       	push   $0x115
  801b71:	68 d3 41 80 00       	push   $0x8041d3
  801b76:	e8 66 eb ff ff       	call   8006e1 <_panic>

00801b7b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b81:	83 ec 04             	sub    $0x4,%esp
  801b84:	68 74 42 80 00       	push   $0x804274
  801b89:	68 1a 01 00 00       	push   $0x11a
  801b8e:	68 d3 41 80 00       	push   $0x8041d3
  801b93:	e8 49 eb ff ff       	call   8006e1 <_panic>

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
  8021ff:	68 84 42 80 00       	push   $0x804284
  802204:	e8 8c e7 ff ff       	call   800995 <cprintf>
  802209:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80220c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802213:	83 ec 0c             	sub    $0xc,%esp
  802216:	68 b0 42 80 00       	push   $0x8042b0
  80221b:	e8 75 e7 ff ff       	call   800995 <cprintf>
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
  80226c:	68 c5 42 80 00       	push   $0x8042c5
  802271:	e8 1f e7 ff ff       	call   800995 <cprintf>
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
  8022b6:	68 d4 42 80 00       	push   $0x8042d4
  8022bb:	e8 d5 e6 ff ff       	call   800995 <cprintf>
  8022c0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8022c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8022ca:	83 ec 0c             	sub    $0xc,%esp
  8022cd:	68 f8 42 80 00       	push   $0x8042f8
  8022d2:	e8 be e6 ff ff       	call   800995 <cprintf>
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
  802323:	68 c5 42 80 00       	push   $0x8042c5
  802328:	e8 68 e6 ff ff       	call   800995 <cprintf>
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
  80236d:	68 10 43 80 00       	push   $0x804310
  802372:	e8 1e e6 ff ff       	call   800995 <cprintf>
  802377:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80237a:	83 ec 0c             	sub    $0xc,%esp
  80237d:	68 84 42 80 00       	push   $0x804284
  802382:	e8 0e e6 ff ff       	call   800995 <cprintf>
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
  8023d1:	68 38 43 80 00       	push   $0x804338
  8023d6:	6a 46                	push   $0x46
  8023d8:	68 5b 43 80 00       	push   $0x80435b
  8023dd:	e8 ff e2 ff ff       	call   8006e1 <_panic>
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
  802513:	68 38 43 80 00       	push   $0x804338
  802518:	6a 6b                	push   $0x6b
  80251a:	68 5b 43 80 00       	push   $0x80435b
  80251f:	e8 bd e1 ff ff       	call   8006e1 <_panic>
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
  80258e:	68 74 43 80 00       	push   $0x804374
  802593:	6a 6f                	push   $0x6f
  802595:	68 5b 43 80 00       	push   $0x80435b
  80259a:	e8 42 e1 ff ff       	call   8006e1 <_panic>
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
  802608:	68 ac 43 80 00       	push   $0x8043ac
  80260d:	6a 73                	push   $0x73
  80260f:	68 5b 43 80 00       	push   $0x80435b
  802614:	e8 c8 e0 ff ff       	call   8006e1 <_panic>
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
  8026b5:	68 d0 43 80 00       	push   $0x8043d0
  8026ba:	6a 7f                	push   $0x7f
  8026bc:	68 5b 43 80 00       	push   $0x80435b
  8026c1:	e8 1b e0 ff ff       	call   8006e1 <_panic>
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
  802789:	68 04 44 80 00       	push   $0x804404
  80278e:	68 93 00 00 00       	push   $0x93
  802793:	68 5b 43 80 00       	push   $0x80435b
  802798:	e8 44 df ff ff       	call   8006e1 <_panic>
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
  80283f:	68 04 44 80 00       	push   $0x804404
  802844:	68 9b 00 00 00       	push   $0x9b
  802849:	68 5b 43 80 00       	push   $0x80435b
  80284e:	e8 8e de ff ff       	call   8006e1 <_panic>
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
  80295d:	68 04 44 80 00       	push   $0x804404
  802962:	68 b7 00 00 00       	push   $0xb7
  802967:	68 5b 43 80 00       	push   $0x80435b
  80296c:	e8 70 dd ff ff       	call   8006e1 <_panic>
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
  802a70:	68 04 44 80 00       	push   $0x804404
  802a75:	68 c7 00 00 00       	push   $0xc7
  802a7a:	68 5b 43 80 00       	push   $0x80435b
  802a7f:	e8 5d dc ff ff       	call   8006e1 <_panic>
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
  802b74:	68 04 44 80 00       	push   $0x804404
  802b79:	68 e0 00 00 00       	push   $0xe0
  802b7e:	68 5b 43 80 00       	push   $0x80435b
  802b83:	e8 59 db ff ff       	call   8006e1 <_panic>
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
  802c35:	68 04 44 80 00       	push   $0x804404
  802c3a:	68 e9 00 00 00       	push   $0xe9
  802c3f:	68 5b 43 80 00       	push   $0x80435b
  802c44:	e8 98 da ff ff       	call   8006e1 <_panic>
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
  802d65:	68 04 44 80 00       	push   $0x804404
  802d6a:	68 fc 00 00 00       	push   $0xfc
  802d6f:	68 5b 43 80 00       	push   $0x80435b
  802d74:	e8 68 d9 ff ff       	call   8006e1 <_panic>
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
  802e26:	68 04 44 80 00       	push   $0x804404
  802e2b:	68 04 01 00 00       	push   $0x104
  802e30:	68 5b 43 80 00       	push   $0x80435b
  802e35:	e8 a7 d8 ff ff       	call   8006e1 <_panic>
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
  802f51:	68 04 44 80 00       	push   $0x804404
  802f56:	68 14 01 00 00       	push   $0x114
  802f5b:	68 5b 43 80 00       	push   $0x80435b
  802f60:	e8 7c d7 ff ff       	call   8006e1 <_panic>
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
  803012:	68 04 44 80 00       	push   $0x804404
  803017:	68 1c 01 00 00       	push   $0x11c
  80301c:	68 5b 43 80 00       	push   $0x80435b
  803021:	e8 bb d6 ff ff       	call   8006e1 <_panic>
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
  803136:	68 38 43 80 00       	push   $0x804338
  80313b:	68 38 01 00 00       	push   $0x138
  803140:	68 5b 43 80 00       	push   $0x80435b
  803145:	e8 97 d5 ff ff       	call   8006e1 <_panic>
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
  8031d3:	68 04 44 80 00       	push   $0x804404
  8031d8:	68 3c 01 00 00       	push   $0x13c
  8031dd:	68 5b 43 80 00       	push   $0x80435b
  8031e2:	e8 fa d4 ff ff       	call   8006e1 <_panic>
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
  803269:	68 38 43 80 00       	push   $0x804338
  80326e:	68 3f 01 00 00       	push   $0x13f
  803273:	68 5b 43 80 00       	push   $0x80435b
  803278:	e8 64 d4 ff ff       	call   8006e1 <_panic>
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
  803329:	68 38 43 80 00       	push   $0x804338
  80332e:	68 49 01 00 00       	push   $0x149
  803333:	68 5b 43 80 00       	push   $0x80435b
  803338:	e8 a4 d3 ff ff       	call   8006e1 <_panic>
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
  803391:	68 ac 43 80 00       	push   $0x8043ac
  803396:	68 4c 01 00 00       	push   $0x14c
  80339b:	68 5b 43 80 00       	push   $0x80435b
  8033a0:	e8 3c d3 ff ff       	call   8006e1 <_panic>
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
  803482:	68 04 44 80 00       	push   $0x804404
  803487:	68 5c 01 00 00       	push   $0x15c
  80348c:	68 5b 43 80 00       	push   $0x80435b
  803491:	e8 4b d2 ff ff       	call   8006e1 <_panic>
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
  803518:	68 38 43 80 00       	push   $0x804338
  80351d:	68 5f 01 00 00       	push   $0x15f
  803522:	68 5b 43 80 00       	push   $0x80435b
  803527:	e8 b5 d1 ff ff       	call   8006e1 <_panic>
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
  8035a3:	68 38 43 80 00       	push   $0x804338
  8035a8:	68 64 01 00 00       	push   $0x164
  8035ad:	68 5b 43 80 00       	push   $0x80435b
  8035b2:	e8 2a d1 ff ff       	call   8006e1 <_panic>
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
  80362d:	68 74 43 80 00       	push   $0x804374
  803632:	68 69 01 00 00       	push   $0x169
  803637:	68 5b 43 80 00       	push   $0x80435b
  80363c:	e8 a0 d0 ff ff       	call   8006e1 <_panic>
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
  8036a5:	68 04 44 80 00       	push   $0x804404
  8036aa:	68 6b 01 00 00       	push   $0x16b
  8036af:	68 5b 43 80 00       	push   $0x80435b
  8036b4:	e8 28 d0 ff ff       	call   8006e1 <_panic>
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
  80373b:	68 38 43 80 00       	push   $0x804338
  803740:	68 6e 01 00 00       	push   $0x16e
  803745:	68 5b 43 80 00       	push   $0x80435b
  80374a:	e8 92 cf ff ff       	call   8006e1 <_panic>
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
  8037a9:	68 d0 43 80 00       	push   $0x8043d0
  8037ae:	68 73 01 00 00       	push   $0x173
  8037b3:	68 5b 43 80 00       	push   $0x80435b
  8037b8:	e8 24 cf ff ff       	call   8006e1 <_panic>
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
