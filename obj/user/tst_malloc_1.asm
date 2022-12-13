
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
  80008d:	68 20 3a 80 00       	push   $0x803a20
  800092:	6a 14                	push   $0x14
  800094:	68 3c 3a 80 00       	push   $0x803a3c
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
  8000ca:	e8 23 1b 00 00       	call   801bf2 <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d2:	e8 bb 1b 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
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
  800105:	68 50 3a 80 00       	push   $0x803a50
  80010a:	6a 23                	push   $0x23
  80010c:	68 3c 3a 80 00       	push   $0x803a3c
  800111:	e8 cb 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800116:	e8 d7 1a 00 00       	call   801bf2 <sys_calculate_free_frames>
  80011b:	89 c2                	mov    %eax,%edx
  80011d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800120:	39 c2                	cmp    %eax,%edx
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 80 3a 80 00       	push   $0x803a80
  80012c:	6a 27                	push   $0x27
  80012e:	68 3c 3a 80 00       	push   $0x803a3c
  800133:	e8 a9 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 55 1b 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 ec 3a 80 00       	push   $0x803aec
  80014a:	6a 28                	push   $0x28
  80014c:	68 3c 3a 80 00       	push   $0x803a3c
  800151:	e8 8b 05 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 97 1a 00 00       	call   801bf2 <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015e:	e8 2f 1b 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
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
  8001a6:	68 50 3a 80 00       	push   $0x803a50
  8001ab:	6a 2d                	push   $0x2d
  8001ad:	68 3c 3a 80 00       	push   $0x803a3c
  8001b2:	e8 2a 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001b7:	e8 36 1a 00 00       	call   801bf2 <sys_calculate_free_frames>
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	39 c2                	cmp    %eax,%edx
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 80 3a 80 00       	push   $0x803a80
  8001cd:	6a 2f                	push   $0x2f
  8001cf:	68 3c 3a 80 00       	push   $0x803a3c
  8001d4:	e8 08 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001d9:	e8 b4 1a 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
  8001de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 ec 3a 80 00       	push   $0x803aec
  8001eb:	6a 30                	push   $0x30
  8001ed:	68 3c 3a 80 00       	push   $0x803a3c
  8001f2:	e8 ea 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f7:	e8 f6 19 00 00       	call   801bf2 <sys_calculate_free_frames>
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 8e 1a 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
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
  80024a:	68 50 3a 80 00       	push   $0x803a50
  80024f:	6a 35                	push   $0x35
  800251:	68 3c 3a 80 00       	push   $0x803a3c
  800256:	e8 86 04 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80025b:	e8 92 19 00 00       	call   801bf2 <sys_calculate_free_frames>
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 80 3a 80 00       	push   $0x803a80
  800271:	6a 37                	push   $0x37
  800273:	68 3c 3a 80 00       	push   $0x803a3c
  800278:	e8 64 04 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80027d:	e8 10 1a 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
  800282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 ec 3a 80 00       	push   $0x803aec
  80028f:	6a 38                	push   $0x38
  800291:	68 3c 3a 80 00       	push   $0x803a3c
  800296:	e8 46 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029b:	e8 52 19 00 00       	call   801bf2 <sys_calculate_free_frames>
  8002a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a3:	e8 ea 19 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
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
  800302:	68 50 3a 80 00       	push   $0x803a50
  800307:	6a 3d                	push   $0x3d
  800309:	68 3c 3a 80 00       	push   $0x803a3c
  80030e:	e8 ce 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800313:	e8 da 18 00 00       	call   801bf2 <sys_calculate_free_frames>
  800318:	89 c2                	mov    %eax,%edx
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	74 14                	je     800335 <_main+0x2fd>
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	68 80 3a 80 00       	push   $0x803a80
  800329:	6a 3f                	push   $0x3f
  80032b:	68 3c 3a 80 00       	push   $0x803a3c
  800330:	e8 ac 03 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800335:	e8 58 19 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
  80033a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 ec 3a 80 00       	push   $0x803aec
  800347:	6a 40                	push   $0x40
  800349:	68 3c 3a 80 00       	push   $0x803a3c
  80034e:	e8 8e 03 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800353:	e8 9a 18 00 00       	call   801bf2 <sys_calculate_free_frames>
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035b:	e8 32 19 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
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
  8003be:	68 50 3a 80 00       	push   $0x803a50
  8003c3:	6a 45                	push   $0x45
  8003c5:	68 3c 3a 80 00       	push   $0x803a3c
  8003ca:	e8 12 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003cf:	e8 1e 18 00 00       	call   801bf2 <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	74 14                	je     8003f1 <_main+0x3b9>
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 80 3a 80 00       	push   $0x803a80
  8003e5:	6a 47                	push   $0x47
  8003e7:	68 3c 3a 80 00       	push   $0x803a3c
  8003ec:	e8 f0 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003f1:	e8 9c 18 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
  8003f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003f9:	74 14                	je     80040f <_main+0x3d7>
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 ec 3a 80 00       	push   $0x803aec
  800403:	6a 48                	push   $0x48
  800405:	68 3c 3a 80 00       	push   $0x803a3c
  80040a:	e8 d2 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80040f:	e8 de 17 00 00       	call   801bf2 <sys_calculate_free_frames>
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800417:	e8 76 18 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
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
  800479:	68 50 3a 80 00       	push   $0x803a50
  80047e:	6a 4d                	push   $0x4d
  800480:	68 3c 3a 80 00       	push   $0x803a3c
  800485:	e8 57 02 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80048a:	e8 63 17 00 00       	call   801bf2 <sys_calculate_free_frames>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <_main+0x474>
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 1a 3b 80 00       	push   $0x803b1a
  8004a0:	6a 4e                	push   $0x4e
  8004a2:	68 3c 3a 80 00       	push   $0x803a3c
  8004a7:	e8 35 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ac:	e8 e1 17 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
  8004b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004b4:	74 14                	je     8004ca <_main+0x492>
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 ec 3a 80 00       	push   $0x803aec
  8004be:	6a 4f                	push   $0x4f
  8004c0:	68 3c 3a 80 00       	push   $0x803a3c
  8004c5:	e8 17 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ca:	e8 23 17 00 00       	call   801bf2 <sys_calculate_free_frames>
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d2:	e8 bb 17 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
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
  80053e:	68 50 3a 80 00       	push   $0x803a50
  800543:	6a 54                	push   $0x54
  800545:	68 3c 3a 80 00       	push   $0x803a3c
  80054a:	e8 92 01 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80054f:	e8 9e 16 00 00       	call   801bf2 <sys_calculate_free_frames>
  800554:	89 c2                	mov    %eax,%edx
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 1a 3b 80 00       	push   $0x803b1a
  800565:	6a 55                	push   $0x55
  800567:	68 3c 3a 80 00       	push   $0x803a3c
  80056c:	e8 70 01 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800571:	e8 1c 17 00 00       	call   801c92 <sys_pf_calculate_allocated_pages>
  800576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 ec 3a 80 00       	push   $0x803aec
  800583:	6a 56                	push   $0x56
  800585:	68 3c 3a 80 00       	push   $0x803a3c
  80058a:	e8 52 01 00 00       	call   8006e1 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	68 30 3b 80 00       	push   $0x803b30
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
  8005ab:	e8 22 19 00 00       	call   801ed2 <sys_getenvindex>
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
  800616:	e8 c4 16 00 00       	call   801cdf <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	68 84 3b 80 00       	push   $0x803b84
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
  800646:	68 ac 3b 80 00       	push   $0x803bac
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
  800677:	68 d4 3b 80 00       	push   $0x803bd4
  80067c:	e8 14 03 00 00       	call   800995 <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800684:	a1 20 50 80 00       	mov    0x805020,%eax
  800689:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	68 2c 3c 80 00       	push   $0x803c2c
  800698:	e8 f8 02 00 00       	call   800995 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	68 84 3b 80 00       	push   $0x803b84
  8006a8:	e8 e8 02 00 00       	call   800995 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b0:	e8 44 16 00 00       	call   801cf9 <sys_enable_interrupt>

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
  8006c8:	e8 d1 17 00 00       	call   801e9e <sys_destroy_env>
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
  8006d9:	e8 26 18 00 00       	call   801f04 <sys_exit_env>
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
  800702:	68 40 3c 80 00       	push   $0x803c40
  800707:	e8 89 02 00 00       	call   800995 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070f:	a1 00 50 80 00       	mov    0x805000,%eax
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	50                   	push   %eax
  80071b:	68 45 3c 80 00       	push   $0x803c45
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
  80073f:	68 61 3c 80 00       	push   $0x803c61
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
  80076b:	68 64 3c 80 00       	push   $0x803c64
  800770:	6a 26                	push   $0x26
  800772:	68 b0 3c 80 00       	push   $0x803cb0
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
  80083d:	68 bc 3c 80 00       	push   $0x803cbc
  800842:	6a 3a                	push   $0x3a
  800844:	68 b0 3c 80 00       	push   $0x803cb0
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
  8008ad:	68 10 3d 80 00       	push   $0x803d10
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 b0 3c 80 00       	push   $0x803cb0
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
  800907:	e8 25 12 00 00       	call   801b31 <sys_cputs>
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
  80097e:	e8 ae 11 00 00       	call   801b31 <sys_cputs>
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
  8009c8:	e8 12 13 00 00       	call   801cdf <sys_disable_interrupt>
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
  8009e8:	e8 0c 13 00 00       	call   801cf9 <sys_enable_interrupt>
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
  800a32:	e8 7d 2d 00 00       	call   8037b4 <__udivdi3>
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
  800a82:	e8 3d 2e 00 00       	call   8038c4 <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 74 3f 80 00       	add    $0x803f74,%eax
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
  800bdd:	8b 04 85 98 3f 80 00 	mov    0x803f98(,%eax,4),%eax
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
  800cbe:	8b 34 9d e0 3d 80 00 	mov    0x803de0(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 85 3f 80 00       	push   $0x803f85
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
  800ce3:	68 8e 3f 80 00       	push   $0x803f8e
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
  800d10:	be 91 3f 80 00       	mov    $0x803f91,%esi
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
  801736:	68 f0 40 80 00       	push   $0x8040f0
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
  801806:	e8 6a 04 00 00       	call   801c75 <sys_allocate_chunk>
  80180b:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80180e:	a1 20 51 80 00       	mov    0x805120,%eax
  801813:	83 ec 0c             	sub    $0xc,%esp
  801816:	50                   	push   %eax
  801817:	e8 df 0a 00 00       	call   8022fb <initialize_MemBlocksList>
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
  801844:	68 15 41 80 00       	push   $0x804115
  801849:	6a 33                	push   $0x33
  80184b:	68 33 41 80 00       	push   $0x804133
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
  8018c3:	68 40 41 80 00       	push   $0x804140
  8018c8:	6a 34                	push   $0x34
  8018ca:	68 33 41 80 00       	push   $0x804133
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
  80195b:	e8 e3 06 00 00       	call   802043 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801960:	85 c0                	test   %eax,%eax
  801962:	74 11                	je     801975 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801964:	83 ec 0c             	sub    $0xc,%esp
  801967:	ff 75 e8             	pushl  -0x18(%ebp)
  80196a:	e8 4e 0d 00 00       	call   8026bd <alloc_block_FF>
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
  801981:	e8 aa 0a 00 00       	call   802430 <insert_sorted_allocList>
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
  8019a1:	68 64 41 80 00       	push   $0x804164
  8019a6:	6a 6f                	push   $0x6f
  8019a8:	68 33 41 80 00       	push   $0x804133
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
  8019c7:	75 07                	jne    8019d0 <smalloc+0x1e>
  8019c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ce:	eb 7c                	jmp    801a4c <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8019d0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019dd:	01 d0                	add    %edx,%eax
  8019df:	48                   	dec    %eax
  8019e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019eb:	f7 75 f0             	divl   -0x10(%ebp)
  8019ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f1:	29 d0                	sub    %edx,%eax
  8019f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8019f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8019fd:	e8 41 06 00 00       	call   802043 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a02:	85 c0                	test   %eax,%eax
  801a04:	74 11                	je     801a17 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801a06:	83 ec 0c             	sub    $0xc,%esp
  801a09:	ff 75 e8             	pushl  -0x18(%ebp)
  801a0c:	e8 ac 0c 00 00       	call   8026bd <alloc_block_FF>
  801a11:	83 c4 10             	add    $0x10,%esp
  801a14:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801a17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a1b:	74 2a                	je     801a47 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a20:	8b 40 08             	mov    0x8(%eax),%eax
  801a23:	89 c2                	mov    %eax,%edx
  801a25:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a29:	52                   	push   %edx
  801a2a:	50                   	push   %eax
  801a2b:	ff 75 0c             	pushl  0xc(%ebp)
  801a2e:	ff 75 08             	pushl  0x8(%ebp)
  801a31:	e8 92 03 00 00       	call   801dc8 <sys_createSharedObject>
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801a3c:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801a40:	74 05                	je     801a47 <smalloc+0x95>
			return (void*)virtual_address;
  801a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a45:	eb 05                	jmp    801a4c <smalloc+0x9a>
	}
	return NULL;
  801a47:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a54:	e8 c6 fc ff ff       	call   80171f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a59:	83 ec 04             	sub    $0x4,%esp
  801a5c:	68 88 41 80 00       	push   $0x804188
  801a61:	68 b0 00 00 00       	push   $0xb0
  801a66:	68 33 41 80 00       	push   $0x804133
  801a6b:	e8 71 ec ff ff       	call   8006e1 <_panic>

00801a70 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a76:	e8 a4 fc ff ff       	call   80171f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a7b:	83 ec 04             	sub    $0x4,%esp
  801a7e:	68 ac 41 80 00       	push   $0x8041ac
  801a83:	68 f4 00 00 00       	push   $0xf4
  801a88:	68 33 41 80 00       	push   $0x804133
  801a8d:	e8 4f ec ff ff       	call   8006e1 <_panic>

00801a92 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a98:	83 ec 04             	sub    $0x4,%esp
  801a9b:	68 d4 41 80 00       	push   $0x8041d4
  801aa0:	68 08 01 00 00       	push   $0x108
  801aa5:	68 33 41 80 00       	push   $0x804133
  801aaa:	e8 32 ec ff ff       	call   8006e1 <_panic>

00801aaf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ab5:	83 ec 04             	sub    $0x4,%esp
  801ab8:	68 f8 41 80 00       	push   $0x8041f8
  801abd:	68 13 01 00 00       	push   $0x113
  801ac2:	68 33 41 80 00       	push   $0x804133
  801ac7:	e8 15 ec ff ff       	call   8006e1 <_panic>

00801acc <shrink>:

}
void shrink(uint32 newSize)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	68 f8 41 80 00       	push   $0x8041f8
  801ada:	68 18 01 00 00       	push   $0x118
  801adf:	68 33 41 80 00       	push   $0x804133
  801ae4:	e8 f8 eb ff ff       	call   8006e1 <_panic>

00801ae9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aef:	83 ec 04             	sub    $0x4,%esp
  801af2:	68 f8 41 80 00       	push   $0x8041f8
  801af7:	68 1d 01 00 00       	push   $0x11d
  801afc:	68 33 41 80 00       	push   $0x804133
  801b01:	e8 db eb ff ff       	call   8006e1 <_panic>

00801b06 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	57                   	push   %edi
  801b0a:	56                   	push   %esi
  801b0b:	53                   	push   %ebx
  801b0c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b15:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b18:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b1b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b1e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b21:	cd 30                	int    $0x30
  801b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b29:	83 c4 10             	add    $0x10,%esp
  801b2c:	5b                   	pop    %ebx
  801b2d:	5e                   	pop    %esi
  801b2e:	5f                   	pop    %edi
  801b2f:	5d                   	pop    %ebp
  801b30:	c3                   	ret    

00801b31 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 04             	sub    $0x4,%esp
  801b37:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b3d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	52                   	push   %edx
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	50                   	push   %eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	e8 b2 ff ff ff       	call   801b06 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	90                   	nop
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_cgetc>:

int
sys_cgetc(void)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 01                	push   $0x1
  801b69:	e8 98 ff ff ff       	call   801b06 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	52                   	push   %edx
  801b83:	50                   	push   %eax
  801b84:	6a 05                	push   $0x5
  801b86:	e8 7b ff ff ff       	call   801b06 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	56                   	push   %esi
  801b94:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b95:	8b 75 18             	mov    0x18(%ebp),%esi
  801b98:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	56                   	push   %esi
  801ba5:	53                   	push   %ebx
  801ba6:	51                   	push   %ecx
  801ba7:	52                   	push   %edx
  801ba8:	50                   	push   %eax
  801ba9:	6a 06                	push   $0x6
  801bab:	e8 56 ff ff ff       	call   801b06 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb6:	5b                   	pop    %ebx
  801bb7:	5e                   	pop    %esi
  801bb8:	5d                   	pop    %ebp
  801bb9:	c3                   	ret    

00801bba <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	52                   	push   %edx
  801bca:	50                   	push   %eax
  801bcb:	6a 07                	push   $0x7
  801bcd:	e8 34 ff ff ff       	call   801b06 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	ff 75 0c             	pushl  0xc(%ebp)
  801be3:	ff 75 08             	pushl  0x8(%ebp)
  801be6:	6a 08                	push   $0x8
  801be8:	e8 19 ff ff ff       	call   801b06 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 09                	push   $0x9
  801c01:	e8 00 ff ff ff       	call   801b06 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 0a                	push   $0xa
  801c1a:	e8 e7 fe ff ff       	call   801b06 <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 0b                	push   $0xb
  801c33:	e8 ce fe ff ff       	call   801b06 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	ff 75 0c             	pushl  0xc(%ebp)
  801c49:	ff 75 08             	pushl  0x8(%ebp)
  801c4c:	6a 0f                	push   $0xf
  801c4e:	e8 b3 fe ff ff       	call   801b06 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
	return;
  801c56:	90                   	nop
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	6a 10                	push   $0x10
  801c6a:	e8 97 fe ff ff       	call   801b06 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c72:	90                   	nop
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	ff 75 10             	pushl  0x10(%ebp)
  801c7f:	ff 75 0c             	pushl  0xc(%ebp)
  801c82:	ff 75 08             	pushl  0x8(%ebp)
  801c85:	6a 11                	push   $0x11
  801c87:	e8 7a fe ff ff       	call   801b06 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8f:	90                   	nop
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 0c                	push   $0xc
  801ca1:	e8 60 fe ff ff       	call   801b06 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	ff 75 08             	pushl  0x8(%ebp)
  801cb9:	6a 0d                	push   $0xd
  801cbb:	e8 46 fe ff ff       	call   801b06 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 0e                	push   $0xe
  801cd4:	e8 2d fe ff ff       	call   801b06 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	90                   	nop
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 13                	push   $0x13
  801cee:	e8 13 fe ff ff       	call   801b06 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	90                   	nop
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 14                	push   $0x14
  801d08:	e8 f9 fd ff ff       	call   801b06 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	90                   	nop
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 04             	sub    $0x4,%esp
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d1f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	50                   	push   %eax
  801d2c:	6a 15                	push   $0x15
  801d2e:	e8 d3 fd ff ff       	call   801b06 <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
}
  801d36:	90                   	nop
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 16                	push   $0x16
  801d48:	e8 b9 fd ff ff       	call   801b06 <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	90                   	nop
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	50                   	push   %eax
  801d63:	6a 17                	push   $0x17
  801d65:	e8 9c fd ff ff       	call   801b06 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	52                   	push   %edx
  801d7f:	50                   	push   %eax
  801d80:	6a 1a                	push   $0x1a
  801d82:	e8 7f fd ff ff       	call   801b06 <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	52                   	push   %edx
  801d9c:	50                   	push   %eax
  801d9d:	6a 18                	push   $0x18
  801d9f:	e8 62 fd ff ff       	call   801b06 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	90                   	nop
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	52                   	push   %edx
  801dba:	50                   	push   %eax
  801dbb:	6a 19                	push   $0x19
  801dbd:	e8 44 fd ff ff       	call   801b06 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	90                   	nop
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
  801dcb:	83 ec 04             	sub    $0x4,%esp
  801dce:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dd4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dd7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	6a 00                	push   $0x0
  801de0:	51                   	push   %ecx
  801de1:	52                   	push   %edx
  801de2:	ff 75 0c             	pushl  0xc(%ebp)
  801de5:	50                   	push   %eax
  801de6:	6a 1b                	push   $0x1b
  801de8:	e8 19 fd ff ff       	call   801b06 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801df5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	52                   	push   %edx
  801e02:	50                   	push   %eax
  801e03:	6a 1c                	push   $0x1c
  801e05:	e8 fc fc ff ff       	call   801b06 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e12:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	51                   	push   %ecx
  801e20:	52                   	push   %edx
  801e21:	50                   	push   %eax
  801e22:	6a 1d                	push   $0x1d
  801e24:	e8 dd fc ff ff       	call   801b06 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	52                   	push   %edx
  801e3e:	50                   	push   %eax
  801e3f:	6a 1e                	push   $0x1e
  801e41:	e8 c0 fc ff ff       	call   801b06 <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 1f                	push   $0x1f
  801e5a:	e8 a7 fc ff ff       	call   801b06 <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	6a 00                	push   $0x0
  801e6c:	ff 75 14             	pushl  0x14(%ebp)
  801e6f:	ff 75 10             	pushl  0x10(%ebp)
  801e72:	ff 75 0c             	pushl  0xc(%ebp)
  801e75:	50                   	push   %eax
  801e76:	6a 20                	push   $0x20
  801e78:	e8 89 fc ff ff       	call   801b06 <syscall>
  801e7d:	83 c4 18             	add    $0x18,%esp
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	50                   	push   %eax
  801e91:	6a 21                	push   $0x21
  801e93:	e8 6e fc ff ff       	call   801b06 <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
}
  801e9b:	90                   	nop
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	50                   	push   %eax
  801ead:	6a 22                	push   $0x22
  801eaf:	e8 52 fc ff ff       	call   801b06 <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 02                	push   $0x2
  801ec8:	e8 39 fc ff ff       	call   801b06 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 03                	push   $0x3
  801ee1:	e8 20 fc ff ff       	call   801b06 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 04                	push   $0x4
  801efa:	e8 07 fc ff ff       	call   801b06 <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <sys_exit_env>:


void sys_exit_env(void)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 23                	push   $0x23
  801f13:	e8 ee fb ff ff       	call   801b06 <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	90                   	nop
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f24:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f27:	8d 50 04             	lea    0x4(%eax),%edx
  801f2a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	52                   	push   %edx
  801f34:	50                   	push   %eax
  801f35:	6a 24                	push   $0x24
  801f37:	e8 ca fb ff ff       	call   801b06 <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
	return result;
  801f3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f48:	89 01                	mov    %eax,(%ecx)
  801f4a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	c9                   	leave  
  801f51:	c2 04 00             	ret    $0x4

00801f54 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	ff 75 10             	pushl  0x10(%ebp)
  801f5e:	ff 75 0c             	pushl  0xc(%ebp)
  801f61:	ff 75 08             	pushl  0x8(%ebp)
  801f64:	6a 12                	push   $0x12
  801f66:	e8 9b fb ff ff       	call   801b06 <syscall>
  801f6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f6e:	90                   	nop
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 25                	push   $0x25
  801f80:	e8 81 fb ff ff       	call   801b06 <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	83 ec 04             	sub    $0x4,%esp
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f96:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	50                   	push   %eax
  801fa3:	6a 26                	push   $0x26
  801fa5:	e8 5c fb ff ff       	call   801b06 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
	return ;
  801fad:	90                   	nop
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <rsttst>:
void rsttst()
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 28                	push   $0x28
  801fbf:	e8 42 fb ff ff       	call   801b06 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc7:	90                   	nop
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	83 ec 04             	sub    $0x4,%esp
  801fd0:	8b 45 14             	mov    0x14(%ebp),%eax
  801fd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fd6:	8b 55 18             	mov    0x18(%ebp),%edx
  801fd9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fdd:	52                   	push   %edx
  801fde:	50                   	push   %eax
  801fdf:	ff 75 10             	pushl  0x10(%ebp)
  801fe2:	ff 75 0c             	pushl  0xc(%ebp)
  801fe5:	ff 75 08             	pushl  0x8(%ebp)
  801fe8:	6a 27                	push   $0x27
  801fea:	e8 17 fb ff ff       	call   801b06 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff2:	90                   	nop
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <chktst>:
void chktst(uint32 n)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	ff 75 08             	pushl  0x8(%ebp)
  802003:	6a 29                	push   $0x29
  802005:	e8 fc fa ff ff       	call   801b06 <syscall>
  80200a:	83 c4 18             	add    $0x18,%esp
	return ;
  80200d:	90                   	nop
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <inctst>:

void inctst()
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 2a                	push   $0x2a
  80201f:	e8 e2 fa ff ff       	call   801b06 <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
	return ;
  802027:	90                   	nop
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <gettst>:
uint32 gettst()
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 2b                	push   $0x2b
  802039:	e8 c8 fa ff ff       	call   801b06 <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 2c                	push   $0x2c
  802055:	e8 ac fa ff ff       	call   801b06 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
  80205d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802060:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802064:	75 07                	jne    80206d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802066:	b8 01 00 00 00       	mov    $0x1,%eax
  80206b:	eb 05                	jmp    802072 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80206d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 2c                	push   $0x2c
  802086:	e8 7b fa ff ff       	call   801b06 <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
  80208e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802091:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802095:	75 07                	jne    80209e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802097:	b8 01 00 00 00       	mov    $0x1,%eax
  80209c:	eb 05                	jmp    8020a3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80209e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 2c                	push   $0x2c
  8020b7:	e8 4a fa ff ff       	call   801b06 <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
  8020bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020c2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020c6:	75 07                	jne    8020cf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8020cd:	eb 05                	jmp    8020d4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 2c                	push   $0x2c
  8020e8:	e8 19 fa ff ff       	call   801b06 <syscall>
  8020ed:	83 c4 18             	add    $0x18,%esp
  8020f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020f3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020f7:	75 07                	jne    802100 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fe:	eb 05                	jmp    802105 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802100:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	ff 75 08             	pushl  0x8(%ebp)
  802115:	6a 2d                	push   $0x2d
  802117:	e8 ea f9 ff ff       	call   801b06 <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
	return ;
  80211f:	90                   	nop
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802126:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802129:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80212c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	6a 00                	push   $0x0
  802134:	53                   	push   %ebx
  802135:	51                   	push   %ecx
  802136:	52                   	push   %edx
  802137:	50                   	push   %eax
  802138:	6a 2e                	push   $0x2e
  80213a:	e8 c7 f9 ff ff       	call   801b06 <syscall>
  80213f:	83 c4 18             	add    $0x18,%esp
}
  802142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80214a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	52                   	push   %edx
  802157:	50                   	push   %eax
  802158:	6a 2f                	push   $0x2f
  80215a:	e8 a7 f9 ff ff       	call   801b06 <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80216a:	83 ec 0c             	sub    $0xc,%esp
  80216d:	68 08 42 80 00       	push   $0x804208
  802172:	e8 1e e8 ff ff       	call   800995 <cprintf>
  802177:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80217a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802181:	83 ec 0c             	sub    $0xc,%esp
  802184:	68 34 42 80 00       	push   $0x804234
  802189:	e8 07 e8 ff ff       	call   800995 <cprintf>
  80218e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802191:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802195:	a1 38 51 80 00       	mov    0x805138,%eax
  80219a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219d:	eb 56                	jmp    8021f5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80219f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021a3:	74 1c                	je     8021c1 <print_mem_block_lists+0x5d>
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	8b 50 08             	mov    0x8(%eax),%edx
  8021ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ae:	8b 48 08             	mov    0x8(%eax),%ecx
  8021b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b7:	01 c8                	add    %ecx,%eax
  8021b9:	39 c2                	cmp    %eax,%edx
  8021bb:	73 04                	jae    8021c1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021bd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	8b 50 08             	mov    0x8(%eax),%edx
  8021c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8021cd:	01 c2                	add    %eax,%edx
  8021cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d2:	8b 40 08             	mov    0x8(%eax),%eax
  8021d5:	83 ec 04             	sub    $0x4,%esp
  8021d8:	52                   	push   %edx
  8021d9:	50                   	push   %eax
  8021da:	68 49 42 80 00       	push   $0x804249
  8021df:	e8 b1 e7 ff ff       	call   800995 <cprintf>
  8021e4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021ed:	a1 40 51 80 00       	mov    0x805140,%eax
  8021f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f9:	74 07                	je     802202 <print_mem_block_lists+0x9e>
  8021fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fe:	8b 00                	mov    (%eax),%eax
  802200:	eb 05                	jmp    802207 <print_mem_block_lists+0xa3>
  802202:	b8 00 00 00 00       	mov    $0x0,%eax
  802207:	a3 40 51 80 00       	mov    %eax,0x805140
  80220c:	a1 40 51 80 00       	mov    0x805140,%eax
  802211:	85 c0                	test   %eax,%eax
  802213:	75 8a                	jne    80219f <print_mem_block_lists+0x3b>
  802215:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802219:	75 84                	jne    80219f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80221b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80221f:	75 10                	jne    802231 <print_mem_block_lists+0xcd>
  802221:	83 ec 0c             	sub    $0xc,%esp
  802224:	68 58 42 80 00       	push   $0x804258
  802229:	e8 67 e7 ff ff       	call   800995 <cprintf>
  80222e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802231:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	68 7c 42 80 00       	push   $0x80427c
  802240:	e8 50 e7 ff ff       	call   800995 <cprintf>
  802245:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802248:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80224c:	a1 40 50 80 00       	mov    0x805040,%eax
  802251:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802254:	eb 56                	jmp    8022ac <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802256:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80225a:	74 1c                	je     802278 <print_mem_block_lists+0x114>
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 50 08             	mov    0x8(%eax),%edx
  802262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802265:	8b 48 08             	mov    0x8(%eax),%ecx
  802268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226b:	8b 40 0c             	mov    0xc(%eax),%eax
  80226e:	01 c8                	add    %ecx,%eax
  802270:	39 c2                	cmp    %eax,%edx
  802272:	73 04                	jae    802278 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802274:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	8b 50 08             	mov    0x8(%eax),%edx
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	8b 40 0c             	mov    0xc(%eax),%eax
  802284:	01 c2                	add    %eax,%edx
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 40 08             	mov    0x8(%eax),%eax
  80228c:	83 ec 04             	sub    $0x4,%esp
  80228f:	52                   	push   %edx
  802290:	50                   	push   %eax
  802291:	68 49 42 80 00       	push   $0x804249
  802296:	e8 fa e6 ff ff       	call   800995 <cprintf>
  80229b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022a4:	a1 48 50 80 00       	mov    0x805048,%eax
  8022a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b0:	74 07                	je     8022b9 <print_mem_block_lists+0x155>
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	8b 00                	mov    (%eax),%eax
  8022b7:	eb 05                	jmp    8022be <print_mem_block_lists+0x15a>
  8022b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022be:	a3 48 50 80 00       	mov    %eax,0x805048
  8022c3:	a1 48 50 80 00       	mov    0x805048,%eax
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	75 8a                	jne    802256 <print_mem_block_lists+0xf2>
  8022cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d0:	75 84                	jne    802256 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022d2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022d6:	75 10                	jne    8022e8 <print_mem_block_lists+0x184>
  8022d8:	83 ec 0c             	sub    $0xc,%esp
  8022db:	68 94 42 80 00       	push   $0x804294
  8022e0:	e8 b0 e6 ff ff       	call   800995 <cprintf>
  8022e5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022e8:	83 ec 0c             	sub    $0xc,%esp
  8022eb:	68 08 42 80 00       	push   $0x804208
  8022f0:	e8 a0 e6 ff ff       	call   800995 <cprintf>
  8022f5:	83 c4 10             	add    $0x10,%esp

}
  8022f8:	90                   	nop
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802301:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802308:	00 00 00 
  80230b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802312:	00 00 00 
  802315:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80231c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80231f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802326:	e9 9e 00 00 00       	jmp    8023c9 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80232b:	a1 50 50 80 00       	mov    0x805050,%eax
  802330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802333:	c1 e2 04             	shl    $0x4,%edx
  802336:	01 d0                	add    %edx,%eax
  802338:	85 c0                	test   %eax,%eax
  80233a:	75 14                	jne    802350 <initialize_MemBlocksList+0x55>
  80233c:	83 ec 04             	sub    $0x4,%esp
  80233f:	68 bc 42 80 00       	push   $0x8042bc
  802344:	6a 46                	push   $0x46
  802346:	68 df 42 80 00       	push   $0x8042df
  80234b:	e8 91 e3 ff ff       	call   8006e1 <_panic>
  802350:	a1 50 50 80 00       	mov    0x805050,%eax
  802355:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802358:	c1 e2 04             	shl    $0x4,%edx
  80235b:	01 d0                	add    %edx,%eax
  80235d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802363:	89 10                	mov    %edx,(%eax)
  802365:	8b 00                	mov    (%eax),%eax
  802367:	85 c0                	test   %eax,%eax
  802369:	74 18                	je     802383 <initialize_MemBlocksList+0x88>
  80236b:	a1 48 51 80 00       	mov    0x805148,%eax
  802370:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802376:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802379:	c1 e1 04             	shl    $0x4,%ecx
  80237c:	01 ca                	add    %ecx,%edx
  80237e:	89 50 04             	mov    %edx,0x4(%eax)
  802381:	eb 12                	jmp    802395 <initialize_MemBlocksList+0x9a>
  802383:	a1 50 50 80 00       	mov    0x805050,%eax
  802388:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238b:	c1 e2 04             	shl    $0x4,%edx
  80238e:	01 d0                	add    %edx,%eax
  802390:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802395:	a1 50 50 80 00       	mov    0x805050,%eax
  80239a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239d:	c1 e2 04             	shl    $0x4,%edx
  8023a0:	01 d0                	add    %edx,%eax
  8023a2:	a3 48 51 80 00       	mov    %eax,0x805148
  8023a7:	a1 50 50 80 00       	mov    0x805050,%eax
  8023ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023af:	c1 e2 04             	shl    $0x4,%edx
  8023b2:	01 d0                	add    %edx,%eax
  8023b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8023c0:	40                   	inc    %eax
  8023c1:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8023c6:	ff 45 f4             	incl   -0xc(%ebp)
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023cf:	0f 82 56 ff ff ff    	jb     80232b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8023d5:	90                   	nop
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	8b 00                	mov    (%eax),%eax
  8023e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023e6:	eb 19                	jmp    802401 <find_block+0x29>
	{
		if(va==point->sva)
  8023e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023eb:	8b 40 08             	mov    0x8(%eax),%eax
  8023ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023f1:	75 05                	jne    8023f8 <find_block+0x20>
		   return point;
  8023f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023f6:	eb 36                	jmp    80242e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	8b 40 08             	mov    0x8(%eax),%eax
  8023fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802401:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802405:	74 07                	je     80240e <find_block+0x36>
  802407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	eb 05                	jmp    802413 <find_block+0x3b>
  80240e:	b8 00 00 00 00       	mov    $0x0,%eax
  802413:	8b 55 08             	mov    0x8(%ebp),%edx
  802416:	89 42 08             	mov    %eax,0x8(%edx)
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	8b 40 08             	mov    0x8(%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	75 c5                	jne    8023e8 <find_block+0x10>
  802423:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802427:	75 bf                	jne    8023e8 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802429:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802436:	a1 40 50 80 00       	mov    0x805040,%eax
  80243b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80243e:	a1 44 50 80 00       	mov    0x805044,%eax
  802443:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802449:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80244c:	74 24                	je     802472 <insert_sorted_allocList+0x42>
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	8b 50 08             	mov    0x8(%eax),%edx
  802454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802457:	8b 40 08             	mov    0x8(%eax),%eax
  80245a:	39 c2                	cmp    %eax,%edx
  80245c:	76 14                	jbe    802472 <insert_sorted_allocList+0x42>
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	8b 50 08             	mov    0x8(%eax),%edx
  802464:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802467:	8b 40 08             	mov    0x8(%eax),%eax
  80246a:	39 c2                	cmp    %eax,%edx
  80246c:	0f 82 60 01 00 00    	jb     8025d2 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802472:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802476:	75 65                	jne    8024dd <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802478:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80247c:	75 14                	jne    802492 <insert_sorted_allocList+0x62>
  80247e:	83 ec 04             	sub    $0x4,%esp
  802481:	68 bc 42 80 00       	push   $0x8042bc
  802486:	6a 6b                	push   $0x6b
  802488:	68 df 42 80 00       	push   $0x8042df
  80248d:	e8 4f e2 ff ff       	call   8006e1 <_panic>
  802492:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	89 10                	mov    %edx,(%eax)
  80249d:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a0:	8b 00                	mov    (%eax),%eax
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	74 0d                	je     8024b3 <insert_sorted_allocList+0x83>
  8024a6:	a1 40 50 80 00       	mov    0x805040,%eax
  8024ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ae:	89 50 04             	mov    %edx,0x4(%eax)
  8024b1:	eb 08                	jmp    8024bb <insert_sorted_allocList+0x8b>
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	a3 44 50 80 00       	mov    %eax,0x805044
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	a3 40 50 80 00       	mov    %eax,0x805040
  8024c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024cd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024d2:	40                   	inc    %eax
  8024d3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024d8:	e9 dc 01 00 00       	jmp    8026b9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8024dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e0:	8b 50 08             	mov    0x8(%eax),%edx
  8024e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e6:	8b 40 08             	mov    0x8(%eax),%eax
  8024e9:	39 c2                	cmp    %eax,%edx
  8024eb:	77 6c                	ja     802559 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8024ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024f1:	74 06                	je     8024f9 <insert_sorted_allocList+0xc9>
  8024f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024f7:	75 14                	jne    80250d <insert_sorted_allocList+0xdd>
  8024f9:	83 ec 04             	sub    $0x4,%esp
  8024fc:	68 f8 42 80 00       	push   $0x8042f8
  802501:	6a 6f                	push   $0x6f
  802503:	68 df 42 80 00       	push   $0x8042df
  802508:	e8 d4 e1 ff ff       	call   8006e1 <_panic>
  80250d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802510:	8b 50 04             	mov    0x4(%eax),%edx
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	89 50 04             	mov    %edx,0x4(%eax)
  802519:	8b 45 08             	mov    0x8(%ebp),%eax
  80251c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80251f:	89 10                	mov    %edx,(%eax)
  802521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802524:	8b 40 04             	mov    0x4(%eax),%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	74 0d                	je     802538 <insert_sorted_allocList+0x108>
  80252b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252e:	8b 40 04             	mov    0x4(%eax),%eax
  802531:	8b 55 08             	mov    0x8(%ebp),%edx
  802534:	89 10                	mov    %edx,(%eax)
  802536:	eb 08                	jmp    802540 <insert_sorted_allocList+0x110>
  802538:	8b 45 08             	mov    0x8(%ebp),%eax
  80253b:	a3 40 50 80 00       	mov    %eax,0x805040
  802540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802543:	8b 55 08             	mov    0x8(%ebp),%edx
  802546:	89 50 04             	mov    %edx,0x4(%eax)
  802549:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80254e:	40                   	inc    %eax
  80254f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802554:	e9 60 01 00 00       	jmp    8026b9 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802559:	8b 45 08             	mov    0x8(%ebp),%eax
  80255c:	8b 50 08             	mov    0x8(%eax),%edx
  80255f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802562:	8b 40 08             	mov    0x8(%eax),%eax
  802565:	39 c2                	cmp    %eax,%edx
  802567:	0f 82 4c 01 00 00    	jb     8026b9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80256d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802571:	75 14                	jne    802587 <insert_sorted_allocList+0x157>
  802573:	83 ec 04             	sub    $0x4,%esp
  802576:	68 30 43 80 00       	push   $0x804330
  80257b:	6a 73                	push   $0x73
  80257d:	68 df 42 80 00       	push   $0x8042df
  802582:	e8 5a e1 ff ff       	call   8006e1 <_panic>
  802587:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	89 50 04             	mov    %edx,0x4(%eax)
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	8b 40 04             	mov    0x4(%eax),%eax
  802599:	85 c0                	test   %eax,%eax
  80259b:	74 0c                	je     8025a9 <insert_sorted_allocList+0x179>
  80259d:	a1 44 50 80 00       	mov    0x805044,%eax
  8025a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a5:	89 10                	mov    %edx,(%eax)
  8025a7:	eb 08                	jmp    8025b1 <insert_sorted_allocList+0x181>
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	a3 40 50 80 00       	mov    %eax,0x805040
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	a3 44 50 80 00       	mov    %eax,0x805044
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025c7:	40                   	inc    %eax
  8025c8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025cd:	e9 e7 00 00 00       	jmp    8026b9 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8025d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8025d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025df:	a1 40 50 80 00       	mov    0x805040,%eax
  8025e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e7:	e9 9d 00 00 00       	jmp    802689 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	8b 50 08             	mov    0x8(%eax),%edx
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 40 08             	mov    0x8(%eax),%eax
  802600:	39 c2                	cmp    %eax,%edx
  802602:	76 7d                	jbe    802681 <insert_sorted_allocList+0x251>
  802604:	8b 45 08             	mov    0x8(%ebp),%eax
  802607:	8b 50 08             	mov    0x8(%eax),%edx
  80260a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80260d:	8b 40 08             	mov    0x8(%eax),%eax
  802610:	39 c2                	cmp    %eax,%edx
  802612:	73 6d                	jae    802681 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802618:	74 06                	je     802620 <insert_sorted_allocList+0x1f0>
  80261a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80261e:	75 14                	jne    802634 <insert_sorted_allocList+0x204>
  802620:	83 ec 04             	sub    $0x4,%esp
  802623:	68 54 43 80 00       	push   $0x804354
  802628:	6a 7f                	push   $0x7f
  80262a:	68 df 42 80 00       	push   $0x8042df
  80262f:	e8 ad e0 ff ff       	call   8006e1 <_panic>
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 10                	mov    (%eax),%edx
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	89 10                	mov    %edx,(%eax)
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	8b 00                	mov    (%eax),%eax
  802643:	85 c0                	test   %eax,%eax
  802645:	74 0b                	je     802652 <insert_sorted_allocList+0x222>
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 00                	mov    (%eax),%eax
  80264c:	8b 55 08             	mov    0x8(%ebp),%edx
  80264f:	89 50 04             	mov    %edx,0x4(%eax)
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 55 08             	mov    0x8(%ebp),%edx
  802658:	89 10                	mov    %edx,(%eax)
  80265a:	8b 45 08             	mov    0x8(%ebp),%eax
  80265d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802660:	89 50 04             	mov    %edx,0x4(%eax)
  802663:	8b 45 08             	mov    0x8(%ebp),%eax
  802666:	8b 00                	mov    (%eax),%eax
  802668:	85 c0                	test   %eax,%eax
  80266a:	75 08                	jne    802674 <insert_sorted_allocList+0x244>
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
  80266f:	a3 44 50 80 00       	mov    %eax,0x805044
  802674:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802679:	40                   	inc    %eax
  80267a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80267f:	eb 39                	jmp    8026ba <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802681:	a1 48 50 80 00       	mov    0x805048,%eax
  802686:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802689:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268d:	74 07                	je     802696 <insert_sorted_allocList+0x266>
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	eb 05                	jmp    80269b <insert_sorted_allocList+0x26b>
  802696:	b8 00 00 00 00       	mov    $0x0,%eax
  80269b:	a3 48 50 80 00       	mov    %eax,0x805048
  8026a0:	a1 48 50 80 00       	mov    0x805048,%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	0f 85 3f ff ff ff    	jne    8025ec <insert_sorted_allocList+0x1bc>
  8026ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b1:	0f 85 35 ff ff ff    	jne    8025ec <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026b7:	eb 01                	jmp    8026ba <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026b9:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026ba:	90                   	nop
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
  8026c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026c3:	a1 38 51 80 00       	mov    0x805138,%eax
  8026c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026cb:	e9 85 01 00 00       	jmp    802855 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d9:	0f 82 6e 01 00 00    	jb     80284d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e8:	0f 85 8a 00 00 00    	jne    802778 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8026ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f2:	75 17                	jne    80270b <alloc_block_FF+0x4e>
  8026f4:	83 ec 04             	sub    $0x4,%esp
  8026f7:	68 88 43 80 00       	push   $0x804388
  8026fc:	68 93 00 00 00       	push   $0x93
  802701:	68 df 42 80 00       	push   $0x8042df
  802706:	e8 d6 df ff ff       	call   8006e1 <_panic>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	85 c0                	test   %eax,%eax
  802712:	74 10                	je     802724 <alloc_block_FF+0x67>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 00                	mov    (%eax),%eax
  802719:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271c:	8b 52 04             	mov    0x4(%edx),%edx
  80271f:	89 50 04             	mov    %edx,0x4(%eax)
  802722:	eb 0b                	jmp    80272f <alloc_block_FF+0x72>
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 04             	mov    0x4(%eax),%eax
  80272a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 40 04             	mov    0x4(%eax),%eax
  802735:	85 c0                	test   %eax,%eax
  802737:	74 0f                	je     802748 <alloc_block_FF+0x8b>
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 40 04             	mov    0x4(%eax),%eax
  80273f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802742:	8b 12                	mov    (%edx),%edx
  802744:	89 10                	mov    %edx,(%eax)
  802746:	eb 0a                	jmp    802752 <alloc_block_FF+0x95>
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	a3 38 51 80 00       	mov    %eax,0x805138
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802765:	a1 44 51 80 00       	mov    0x805144,%eax
  80276a:	48                   	dec    %eax
  80276b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	e9 10 01 00 00       	jmp    802888 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 40 0c             	mov    0xc(%eax),%eax
  80277e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802781:	0f 86 c6 00 00 00    	jbe    80284d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802787:	a1 48 51 80 00       	mov    0x805148,%eax
  80278c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 50 08             	mov    0x8(%eax),%edx
  802795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802798:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80279b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279e:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a1:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a8:	75 17                	jne    8027c1 <alloc_block_FF+0x104>
  8027aa:	83 ec 04             	sub    $0x4,%esp
  8027ad:	68 88 43 80 00       	push   $0x804388
  8027b2:	68 9b 00 00 00       	push   $0x9b
  8027b7:	68 df 42 80 00       	push   $0x8042df
  8027bc:	e8 20 df ff ff       	call   8006e1 <_panic>
  8027c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c4:	8b 00                	mov    (%eax),%eax
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	74 10                	je     8027da <alloc_block_FF+0x11d>
  8027ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cd:	8b 00                	mov    (%eax),%eax
  8027cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d2:	8b 52 04             	mov    0x4(%edx),%edx
  8027d5:	89 50 04             	mov    %edx,0x4(%eax)
  8027d8:	eb 0b                	jmp    8027e5 <alloc_block_FF+0x128>
  8027da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dd:	8b 40 04             	mov    0x4(%eax),%eax
  8027e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e8:	8b 40 04             	mov    0x4(%eax),%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	74 0f                	je     8027fe <alloc_block_FF+0x141>
  8027ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f2:	8b 40 04             	mov    0x4(%eax),%eax
  8027f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f8:	8b 12                	mov    (%edx),%edx
  8027fa:	89 10                	mov    %edx,(%eax)
  8027fc:	eb 0a                	jmp    802808 <alloc_block_FF+0x14b>
  8027fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802801:	8b 00                	mov    (%eax),%eax
  802803:	a3 48 51 80 00       	mov    %eax,0x805148
  802808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802814:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281b:	a1 54 51 80 00       	mov    0x805154,%eax
  802820:	48                   	dec    %eax
  802821:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 50 08             	mov    0x8(%eax),%edx
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	01 c2                	add    %eax,%edx
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 40 0c             	mov    0xc(%eax),%eax
  80283d:	2b 45 08             	sub    0x8(%ebp),%eax
  802840:	89 c2                	mov    %eax,%edx
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284b:	eb 3b                	jmp    802888 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80284d:	a1 40 51 80 00       	mov    0x805140,%eax
  802852:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802859:	74 07                	je     802862 <alloc_block_FF+0x1a5>
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	eb 05                	jmp    802867 <alloc_block_FF+0x1aa>
  802862:	b8 00 00 00 00       	mov    $0x0,%eax
  802867:	a3 40 51 80 00       	mov    %eax,0x805140
  80286c:	a1 40 51 80 00       	mov    0x805140,%eax
  802871:	85 c0                	test   %eax,%eax
  802873:	0f 85 57 fe ff ff    	jne    8026d0 <alloc_block_FF+0x13>
  802879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287d:	0f 85 4d fe ff ff    	jne    8026d0 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802883:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802888:	c9                   	leave  
  802889:	c3                   	ret    

0080288a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
  80288d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802890:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802897:	a1 38 51 80 00       	mov    0x805138,%eax
  80289c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289f:	e9 df 00 00 00       	jmp    802983 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ad:	0f 82 c8 00 00 00    	jb     80297b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028bc:	0f 85 8a 00 00 00    	jne    80294c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8028c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c6:	75 17                	jne    8028df <alloc_block_BF+0x55>
  8028c8:	83 ec 04             	sub    $0x4,%esp
  8028cb:	68 88 43 80 00       	push   $0x804388
  8028d0:	68 b7 00 00 00       	push   $0xb7
  8028d5:	68 df 42 80 00       	push   $0x8042df
  8028da:	e8 02 de ff ff       	call   8006e1 <_panic>
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	74 10                	je     8028f8 <alloc_block_BF+0x6e>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 00                	mov    (%eax),%eax
  8028ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f0:	8b 52 04             	mov    0x4(%edx),%edx
  8028f3:	89 50 04             	mov    %edx,0x4(%eax)
  8028f6:	eb 0b                	jmp    802903 <alloc_block_BF+0x79>
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 40 04             	mov    0x4(%eax),%eax
  8028fe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 40 04             	mov    0x4(%eax),%eax
  802909:	85 c0                	test   %eax,%eax
  80290b:	74 0f                	je     80291c <alloc_block_BF+0x92>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 40 04             	mov    0x4(%eax),%eax
  802913:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802916:	8b 12                	mov    (%edx),%edx
  802918:	89 10                	mov    %edx,(%eax)
  80291a:	eb 0a                	jmp    802926 <alloc_block_BF+0x9c>
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 00                	mov    (%eax),%eax
  802921:	a3 38 51 80 00       	mov    %eax,0x805138
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802939:	a1 44 51 80 00       	mov    0x805144,%eax
  80293e:	48                   	dec    %eax
  80293f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	e9 4d 01 00 00       	jmp    802a99 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 40 0c             	mov    0xc(%eax),%eax
  802952:	3b 45 08             	cmp    0x8(%ebp),%eax
  802955:	76 24                	jbe    80297b <alloc_block_BF+0xf1>
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 40 0c             	mov    0xc(%eax),%eax
  80295d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802960:	73 19                	jae    80297b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802962:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 40 0c             	mov    0xc(%eax),%eax
  80296f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 40 08             	mov    0x8(%eax),%eax
  802978:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80297b:	a1 40 51 80 00       	mov    0x805140,%eax
  802980:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802983:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802987:	74 07                	je     802990 <alloc_block_BF+0x106>
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 00                	mov    (%eax),%eax
  80298e:	eb 05                	jmp    802995 <alloc_block_BF+0x10b>
  802990:	b8 00 00 00 00       	mov    $0x0,%eax
  802995:	a3 40 51 80 00       	mov    %eax,0x805140
  80299a:	a1 40 51 80 00       	mov    0x805140,%eax
  80299f:	85 c0                	test   %eax,%eax
  8029a1:	0f 85 fd fe ff ff    	jne    8028a4 <alloc_block_BF+0x1a>
  8029a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ab:	0f 85 f3 fe ff ff    	jne    8028a4 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8029b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029b5:	0f 84 d9 00 00 00    	je     802a94 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029bb:	a1 48 51 80 00       	mov    0x805148,%eax
  8029c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8029c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029c9:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8029cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d2:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8029d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029d9:	75 17                	jne    8029f2 <alloc_block_BF+0x168>
  8029db:	83 ec 04             	sub    $0x4,%esp
  8029de:	68 88 43 80 00       	push   $0x804388
  8029e3:	68 c7 00 00 00       	push   $0xc7
  8029e8:	68 df 42 80 00       	push   $0x8042df
  8029ed:	e8 ef dc ff ff       	call   8006e1 <_panic>
  8029f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	74 10                	je     802a0b <alloc_block_BF+0x181>
  8029fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a03:	8b 52 04             	mov    0x4(%edx),%edx
  802a06:	89 50 04             	mov    %edx,0x4(%eax)
  802a09:	eb 0b                	jmp    802a16 <alloc_block_BF+0x18c>
  802a0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a0e:	8b 40 04             	mov    0x4(%eax),%eax
  802a11:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a19:	8b 40 04             	mov    0x4(%eax),%eax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	74 0f                	je     802a2f <alloc_block_BF+0x1a5>
  802a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a23:	8b 40 04             	mov    0x4(%eax),%eax
  802a26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a29:	8b 12                	mov    (%edx),%edx
  802a2b:	89 10                	mov    %edx,(%eax)
  802a2d:	eb 0a                	jmp    802a39 <alloc_block_BF+0x1af>
  802a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a32:	8b 00                	mov    (%eax),%eax
  802a34:	a3 48 51 80 00       	mov    %eax,0x805148
  802a39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4c:	a1 54 51 80 00       	mov    0x805154,%eax
  802a51:	48                   	dec    %eax
  802a52:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a57:	83 ec 08             	sub    $0x8,%esp
  802a5a:	ff 75 ec             	pushl  -0x14(%ebp)
  802a5d:	68 38 51 80 00       	push   $0x805138
  802a62:	e8 71 f9 ff ff       	call   8023d8 <find_block>
  802a67:	83 c4 10             	add    $0x10,%esp
  802a6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a70:	8b 50 08             	mov    0x8(%eax),%edx
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	01 c2                	add    %eax,%edx
  802a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a7b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a81:	8b 40 0c             	mov    0xc(%eax),%eax
  802a84:	2b 45 08             	sub    0x8(%ebp),%eax
  802a87:	89 c2                	mov    %eax,%edx
  802a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a8c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a92:	eb 05                	jmp    802a99 <alloc_block_BF+0x20f>
	}
	return NULL;
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a99:	c9                   	leave  
  802a9a:	c3                   	ret    

00802a9b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a9b:	55                   	push   %ebp
  802a9c:	89 e5                	mov    %esp,%ebp
  802a9e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802aa1:	a1 28 50 80 00       	mov    0x805028,%eax
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	0f 85 de 01 00 00    	jne    802c8c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802aae:	a1 38 51 80 00       	mov    0x805138,%eax
  802ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab6:	e9 9e 01 00 00       	jmp    802c59 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac4:	0f 82 87 01 00 00    	jb     802c51 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad3:	0f 85 95 00 00 00    	jne    802b6e <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802ad9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802add:	75 17                	jne    802af6 <alloc_block_NF+0x5b>
  802adf:	83 ec 04             	sub    $0x4,%esp
  802ae2:	68 88 43 80 00       	push   $0x804388
  802ae7:	68 e0 00 00 00       	push   $0xe0
  802aec:	68 df 42 80 00       	push   $0x8042df
  802af1:	e8 eb db ff ff       	call   8006e1 <_panic>
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 00                	mov    (%eax),%eax
  802afb:	85 c0                	test   %eax,%eax
  802afd:	74 10                	je     802b0f <alloc_block_NF+0x74>
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b07:	8b 52 04             	mov    0x4(%edx),%edx
  802b0a:	89 50 04             	mov    %edx,0x4(%eax)
  802b0d:	eb 0b                	jmp    802b1a <alloc_block_NF+0x7f>
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 04             	mov    0x4(%eax),%eax
  802b15:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 40 04             	mov    0x4(%eax),%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	74 0f                	je     802b33 <alloc_block_NF+0x98>
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 40 04             	mov    0x4(%eax),%eax
  802b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2d:	8b 12                	mov    (%edx),%edx
  802b2f:	89 10                	mov    %edx,(%eax)
  802b31:	eb 0a                	jmp    802b3d <alloc_block_NF+0xa2>
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 00                	mov    (%eax),%eax
  802b38:	a3 38 51 80 00       	mov    %eax,0x805138
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b50:	a1 44 51 80 00       	mov    0x805144,%eax
  802b55:	48                   	dec    %eax
  802b56:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 40 08             	mov    0x8(%eax),%eax
  802b61:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	e9 f8 04 00 00       	jmp    803066 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 40 0c             	mov    0xc(%eax),%eax
  802b74:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b77:	0f 86 d4 00 00 00    	jbe    802c51 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b7d:	a1 48 51 80 00       	mov    0x805148,%eax
  802b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	8b 50 08             	mov    0x8(%eax),%edx
  802b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b94:	8b 55 08             	mov    0x8(%ebp),%edx
  802b97:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b9e:	75 17                	jne    802bb7 <alloc_block_NF+0x11c>
  802ba0:	83 ec 04             	sub    $0x4,%esp
  802ba3:	68 88 43 80 00       	push   $0x804388
  802ba8:	68 e9 00 00 00       	push   $0xe9
  802bad:	68 df 42 80 00       	push   $0x8042df
  802bb2:	e8 2a db ff ff       	call   8006e1 <_panic>
  802bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bba:	8b 00                	mov    (%eax),%eax
  802bbc:	85 c0                	test   %eax,%eax
  802bbe:	74 10                	je     802bd0 <alloc_block_NF+0x135>
  802bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc8:	8b 52 04             	mov    0x4(%edx),%edx
  802bcb:	89 50 04             	mov    %edx,0x4(%eax)
  802bce:	eb 0b                	jmp    802bdb <alloc_block_NF+0x140>
  802bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd3:	8b 40 04             	mov    0x4(%eax),%eax
  802bd6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bde:	8b 40 04             	mov    0x4(%eax),%eax
  802be1:	85 c0                	test   %eax,%eax
  802be3:	74 0f                	je     802bf4 <alloc_block_NF+0x159>
  802be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be8:	8b 40 04             	mov    0x4(%eax),%eax
  802beb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bee:	8b 12                	mov    (%edx),%edx
  802bf0:	89 10                	mov    %edx,(%eax)
  802bf2:	eb 0a                	jmp    802bfe <alloc_block_NF+0x163>
  802bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	a3 48 51 80 00       	mov    %eax,0x805148
  802bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c11:	a1 54 51 80 00       	mov    0x805154,%eax
  802c16:	48                   	dec    %eax
  802c17:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1f:	8b 40 08             	mov    0x8(%eax),%eax
  802c22:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	8b 50 08             	mov    0x8(%eax),%edx
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	01 c2                	add    %eax,%edx
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3e:	2b 45 08             	sub    0x8(%ebp),%eax
  802c41:	89 c2                	mov    %eax,%edx
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4c:	e9 15 04 00 00       	jmp    803066 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c51:	a1 40 51 80 00       	mov    0x805140,%eax
  802c56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5d:	74 07                	je     802c66 <alloc_block_NF+0x1cb>
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 00                	mov    (%eax),%eax
  802c64:	eb 05                	jmp    802c6b <alloc_block_NF+0x1d0>
  802c66:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6b:	a3 40 51 80 00       	mov    %eax,0x805140
  802c70:	a1 40 51 80 00       	mov    0x805140,%eax
  802c75:	85 c0                	test   %eax,%eax
  802c77:	0f 85 3e fe ff ff    	jne    802abb <alloc_block_NF+0x20>
  802c7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c81:	0f 85 34 fe ff ff    	jne    802abb <alloc_block_NF+0x20>
  802c87:	e9 d5 03 00 00       	jmp    803061 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c8c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c94:	e9 b1 01 00 00       	jmp    802e4a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 50 08             	mov    0x8(%eax),%edx
  802c9f:	a1 28 50 80 00       	mov    0x805028,%eax
  802ca4:	39 c2                	cmp    %eax,%edx
  802ca6:	0f 82 96 01 00 00    	jb     802e42 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb5:	0f 82 87 01 00 00    	jb     802e42 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc4:	0f 85 95 00 00 00    	jne    802d5f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cce:	75 17                	jne    802ce7 <alloc_block_NF+0x24c>
  802cd0:	83 ec 04             	sub    $0x4,%esp
  802cd3:	68 88 43 80 00       	push   $0x804388
  802cd8:	68 fc 00 00 00       	push   $0xfc
  802cdd:	68 df 42 80 00       	push   $0x8042df
  802ce2:	e8 fa d9 ff ff       	call   8006e1 <_panic>
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	8b 00                	mov    (%eax),%eax
  802cec:	85 c0                	test   %eax,%eax
  802cee:	74 10                	je     802d00 <alloc_block_NF+0x265>
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 00                	mov    (%eax),%eax
  802cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf8:	8b 52 04             	mov    0x4(%edx),%edx
  802cfb:	89 50 04             	mov    %edx,0x4(%eax)
  802cfe:	eb 0b                	jmp    802d0b <alloc_block_NF+0x270>
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d03:	8b 40 04             	mov    0x4(%eax),%eax
  802d06:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 40 04             	mov    0x4(%eax),%eax
  802d11:	85 c0                	test   %eax,%eax
  802d13:	74 0f                	je     802d24 <alloc_block_NF+0x289>
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 40 04             	mov    0x4(%eax),%eax
  802d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1e:	8b 12                	mov    (%edx),%edx
  802d20:	89 10                	mov    %edx,(%eax)
  802d22:	eb 0a                	jmp    802d2e <alloc_block_NF+0x293>
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	a3 38 51 80 00       	mov    %eax,0x805138
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d41:	a1 44 51 80 00       	mov    0x805144,%eax
  802d46:	48                   	dec    %eax
  802d47:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	8b 40 08             	mov    0x8(%eax),%eax
  802d52:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5a:	e9 07 03 00 00       	jmp    803066 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 40 0c             	mov    0xc(%eax),%eax
  802d65:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d68:	0f 86 d4 00 00 00    	jbe    802e42 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d6e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d73:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 50 08             	mov    0x8(%eax),%edx
  802d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d85:	8b 55 08             	mov    0x8(%ebp),%edx
  802d88:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d8f:	75 17                	jne    802da8 <alloc_block_NF+0x30d>
  802d91:	83 ec 04             	sub    $0x4,%esp
  802d94:	68 88 43 80 00       	push   $0x804388
  802d99:	68 04 01 00 00       	push   $0x104
  802d9e:	68 df 42 80 00       	push   $0x8042df
  802da3:	e8 39 d9 ff ff       	call   8006e1 <_panic>
  802da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dab:	8b 00                	mov    (%eax),%eax
  802dad:	85 c0                	test   %eax,%eax
  802daf:	74 10                	je     802dc1 <alloc_block_NF+0x326>
  802db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db4:	8b 00                	mov    (%eax),%eax
  802db6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802db9:	8b 52 04             	mov    0x4(%edx),%edx
  802dbc:	89 50 04             	mov    %edx,0x4(%eax)
  802dbf:	eb 0b                	jmp    802dcc <alloc_block_NF+0x331>
  802dc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc4:	8b 40 04             	mov    0x4(%eax),%eax
  802dc7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dcf:	8b 40 04             	mov    0x4(%eax),%eax
  802dd2:	85 c0                	test   %eax,%eax
  802dd4:	74 0f                	je     802de5 <alloc_block_NF+0x34a>
  802dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd9:	8b 40 04             	mov    0x4(%eax),%eax
  802ddc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ddf:	8b 12                	mov    (%edx),%edx
  802de1:	89 10                	mov    %edx,(%eax)
  802de3:	eb 0a                	jmp    802def <alloc_block_NF+0x354>
  802de5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de8:	8b 00                	mov    (%eax),%eax
  802dea:	a3 48 51 80 00       	mov    %eax,0x805148
  802def:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e02:	a1 54 51 80 00       	mov    0x805154,%eax
  802e07:	48                   	dec    %eax
  802e08:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e10:	8b 40 08             	mov    0x8(%eax),%eax
  802e13:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	8b 50 08             	mov    0x8(%eax),%edx
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	01 c2                	add    %eax,%edx
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2f:	2b 45 08             	sub    0x8(%ebp),%eax
  802e32:	89 c2                	mov    %eax,%edx
  802e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e37:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3d:	e9 24 02 00 00       	jmp    803066 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e42:	a1 40 51 80 00       	mov    0x805140,%eax
  802e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4e:	74 07                	je     802e57 <alloc_block_NF+0x3bc>
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	8b 00                	mov    (%eax),%eax
  802e55:	eb 05                	jmp    802e5c <alloc_block_NF+0x3c1>
  802e57:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5c:	a3 40 51 80 00       	mov    %eax,0x805140
  802e61:	a1 40 51 80 00       	mov    0x805140,%eax
  802e66:	85 c0                	test   %eax,%eax
  802e68:	0f 85 2b fe ff ff    	jne    802c99 <alloc_block_NF+0x1fe>
  802e6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e72:	0f 85 21 fe ff ff    	jne    802c99 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e78:	a1 38 51 80 00       	mov    0x805138,%eax
  802e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e80:	e9 ae 01 00 00       	jmp    803033 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 50 08             	mov    0x8(%eax),%edx
  802e8b:	a1 28 50 80 00       	mov    0x805028,%eax
  802e90:	39 c2                	cmp    %eax,%edx
  802e92:	0f 83 93 01 00 00    	jae    80302b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ea1:	0f 82 84 01 00 00    	jb     80302b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802ead:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb0:	0f 85 95 00 00 00    	jne    802f4b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802eb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eba:	75 17                	jne    802ed3 <alloc_block_NF+0x438>
  802ebc:	83 ec 04             	sub    $0x4,%esp
  802ebf:	68 88 43 80 00       	push   $0x804388
  802ec4:	68 14 01 00 00       	push   $0x114
  802ec9:	68 df 42 80 00       	push   $0x8042df
  802ece:	e8 0e d8 ff ff       	call   8006e1 <_panic>
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	85 c0                	test   %eax,%eax
  802eda:	74 10                	je     802eec <alloc_block_NF+0x451>
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee4:	8b 52 04             	mov    0x4(%edx),%edx
  802ee7:	89 50 04             	mov    %edx,0x4(%eax)
  802eea:	eb 0b                	jmp    802ef7 <alloc_block_NF+0x45c>
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	8b 40 04             	mov    0x4(%eax),%eax
  802ef2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	8b 40 04             	mov    0x4(%eax),%eax
  802efd:	85 c0                	test   %eax,%eax
  802eff:	74 0f                	je     802f10 <alloc_block_NF+0x475>
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 40 04             	mov    0x4(%eax),%eax
  802f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0a:	8b 12                	mov    (%edx),%edx
  802f0c:	89 10                	mov    %edx,(%eax)
  802f0e:	eb 0a                	jmp    802f1a <alloc_block_NF+0x47f>
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	8b 00                	mov    (%eax),%eax
  802f15:	a3 38 51 80 00       	mov    %eax,0x805138
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2d:	a1 44 51 80 00       	mov    0x805144,%eax
  802f32:	48                   	dec    %eax
  802f33:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 40 08             	mov    0x8(%eax),%eax
  802f3e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	e9 1b 01 00 00       	jmp    803066 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f51:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f54:	0f 86 d1 00 00 00    	jbe    80302b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f5a:	a1 48 51 80 00       	mov    0x805148,%eax
  802f5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	8b 50 08             	mov    0x8(%eax),%edx
  802f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f71:	8b 55 08             	mov    0x8(%ebp),%edx
  802f74:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f7b:	75 17                	jne    802f94 <alloc_block_NF+0x4f9>
  802f7d:	83 ec 04             	sub    $0x4,%esp
  802f80:	68 88 43 80 00       	push   $0x804388
  802f85:	68 1c 01 00 00       	push   $0x11c
  802f8a:	68 df 42 80 00       	push   $0x8042df
  802f8f:	e8 4d d7 ff ff       	call   8006e1 <_panic>
  802f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	85 c0                	test   %eax,%eax
  802f9b:	74 10                	je     802fad <alloc_block_NF+0x512>
  802f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa0:	8b 00                	mov    (%eax),%eax
  802fa2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fa5:	8b 52 04             	mov    0x4(%edx),%edx
  802fa8:	89 50 04             	mov    %edx,0x4(%eax)
  802fab:	eb 0b                	jmp    802fb8 <alloc_block_NF+0x51d>
  802fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb0:	8b 40 04             	mov    0x4(%eax),%eax
  802fb3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbb:	8b 40 04             	mov    0x4(%eax),%eax
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	74 0f                	je     802fd1 <alloc_block_NF+0x536>
  802fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc5:	8b 40 04             	mov    0x4(%eax),%eax
  802fc8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fcb:	8b 12                	mov    (%edx),%edx
  802fcd:	89 10                	mov    %edx,(%eax)
  802fcf:	eb 0a                	jmp    802fdb <alloc_block_NF+0x540>
  802fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	a3 48 51 80 00       	mov    %eax,0x805148
  802fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fee:	a1 54 51 80 00       	mov    0x805154,%eax
  802ff3:	48                   	dec    %eax
  802ff4:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ff9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffc:	8b 40 08             	mov    0x8(%eax),%eax
  802fff:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	8b 50 08             	mov    0x8(%eax),%edx
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	01 c2                	add    %eax,%edx
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 40 0c             	mov    0xc(%eax),%eax
  80301b:	2b 45 08             	sub    0x8(%ebp),%eax
  80301e:	89 c2                	mov    %eax,%edx
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803026:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803029:	eb 3b                	jmp    803066 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80302b:	a1 40 51 80 00       	mov    0x805140,%eax
  803030:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803033:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803037:	74 07                	je     803040 <alloc_block_NF+0x5a5>
  803039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	eb 05                	jmp    803045 <alloc_block_NF+0x5aa>
  803040:	b8 00 00 00 00       	mov    $0x0,%eax
  803045:	a3 40 51 80 00       	mov    %eax,0x805140
  80304a:	a1 40 51 80 00       	mov    0x805140,%eax
  80304f:	85 c0                	test   %eax,%eax
  803051:	0f 85 2e fe ff ff    	jne    802e85 <alloc_block_NF+0x3ea>
  803057:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305b:	0f 85 24 fe ff ff    	jne    802e85 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803061:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803066:	c9                   	leave  
  803067:	c3                   	ret    

00803068 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803068:	55                   	push   %ebp
  803069:	89 e5                	mov    %esp,%ebp
  80306b:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80306e:	a1 38 51 80 00       	mov    0x805138,%eax
  803073:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803076:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80307b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80307e:	a1 38 51 80 00       	mov    0x805138,%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	74 14                	je     80309b <insert_sorted_with_merge_freeList+0x33>
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	8b 50 08             	mov    0x8(%eax),%edx
  80308d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803090:	8b 40 08             	mov    0x8(%eax),%eax
  803093:	39 c2                	cmp    %eax,%edx
  803095:	0f 87 9b 01 00 00    	ja     803236 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80309b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309f:	75 17                	jne    8030b8 <insert_sorted_with_merge_freeList+0x50>
  8030a1:	83 ec 04             	sub    $0x4,%esp
  8030a4:	68 bc 42 80 00       	push   $0x8042bc
  8030a9:	68 38 01 00 00       	push   $0x138
  8030ae:	68 df 42 80 00       	push   $0x8042df
  8030b3:	e8 29 d6 ff ff       	call   8006e1 <_panic>
  8030b8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	89 10                	mov    %edx,(%eax)
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	8b 00                	mov    (%eax),%eax
  8030c8:	85 c0                	test   %eax,%eax
  8030ca:	74 0d                	je     8030d9 <insert_sorted_with_merge_freeList+0x71>
  8030cc:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d4:	89 50 04             	mov    %edx,0x4(%eax)
  8030d7:	eb 08                	jmp    8030e1 <insert_sorted_with_merge_freeList+0x79>
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e4:	a3 38 51 80 00       	mov    %eax,0x805138
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f3:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f8:	40                   	inc    %eax
  8030f9:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803102:	0f 84 a8 06 00 00    	je     8037b0 <insert_sorted_with_merge_freeList+0x748>
  803108:	8b 45 08             	mov    0x8(%ebp),%eax
  80310b:	8b 50 08             	mov    0x8(%eax),%edx
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	8b 40 0c             	mov    0xc(%eax),%eax
  803114:	01 c2                	add    %eax,%edx
  803116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803119:	8b 40 08             	mov    0x8(%eax),%eax
  80311c:	39 c2                	cmp    %eax,%edx
  80311e:	0f 85 8c 06 00 00    	jne    8037b0 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	8b 50 0c             	mov    0xc(%eax),%edx
  80312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312d:	8b 40 0c             	mov    0xc(%eax),%eax
  803130:	01 c2                	add    %eax,%edx
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803138:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80313c:	75 17                	jne    803155 <insert_sorted_with_merge_freeList+0xed>
  80313e:	83 ec 04             	sub    $0x4,%esp
  803141:	68 88 43 80 00       	push   $0x804388
  803146:	68 3c 01 00 00       	push   $0x13c
  80314b:	68 df 42 80 00       	push   $0x8042df
  803150:	e8 8c d5 ff ff       	call   8006e1 <_panic>
  803155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	85 c0                	test   %eax,%eax
  80315c:	74 10                	je     80316e <insert_sorted_with_merge_freeList+0x106>
  80315e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803166:	8b 52 04             	mov    0x4(%edx),%edx
  803169:	89 50 04             	mov    %edx,0x4(%eax)
  80316c:	eb 0b                	jmp    803179 <insert_sorted_with_merge_freeList+0x111>
  80316e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803171:	8b 40 04             	mov    0x4(%eax),%eax
  803174:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317c:	8b 40 04             	mov    0x4(%eax),%eax
  80317f:	85 c0                	test   %eax,%eax
  803181:	74 0f                	je     803192 <insert_sorted_with_merge_freeList+0x12a>
  803183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803186:	8b 40 04             	mov    0x4(%eax),%eax
  803189:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80318c:	8b 12                	mov    (%edx),%edx
  80318e:	89 10                	mov    %edx,(%eax)
  803190:	eb 0a                	jmp    80319c <insert_sorted_with_merge_freeList+0x134>
  803192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	a3 38 51 80 00       	mov    %eax,0x805138
  80319c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031af:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b4:	48                   	dec    %eax
  8031b5:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8031ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8031c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8031ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d2:	75 17                	jne    8031eb <insert_sorted_with_merge_freeList+0x183>
  8031d4:	83 ec 04             	sub    $0x4,%esp
  8031d7:	68 bc 42 80 00       	push   $0x8042bc
  8031dc:	68 3f 01 00 00       	push   $0x13f
  8031e1:	68 df 42 80 00       	push   $0x8042df
  8031e6:	e8 f6 d4 ff ff       	call   8006e1 <_panic>
  8031eb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f4:	89 10                	mov    %edx,(%eax)
  8031f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	85 c0                	test   %eax,%eax
  8031fd:	74 0d                	je     80320c <insert_sorted_with_merge_freeList+0x1a4>
  8031ff:	a1 48 51 80 00       	mov    0x805148,%eax
  803204:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803207:	89 50 04             	mov    %edx,0x4(%eax)
  80320a:	eb 08                	jmp    803214 <insert_sorted_with_merge_freeList+0x1ac>
  80320c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803217:	a3 48 51 80 00       	mov    %eax,0x805148
  80321c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803226:	a1 54 51 80 00       	mov    0x805154,%eax
  80322b:	40                   	inc    %eax
  80322c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803231:	e9 7a 05 00 00       	jmp    8037b0 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	8b 50 08             	mov    0x8(%eax),%edx
  80323c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323f:	8b 40 08             	mov    0x8(%eax),%eax
  803242:	39 c2                	cmp    %eax,%edx
  803244:	0f 82 14 01 00 00    	jb     80335e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80324a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324d:	8b 50 08             	mov    0x8(%eax),%edx
  803250:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803253:	8b 40 0c             	mov    0xc(%eax),%eax
  803256:	01 c2                	add    %eax,%edx
  803258:	8b 45 08             	mov    0x8(%ebp),%eax
  80325b:	8b 40 08             	mov    0x8(%eax),%eax
  80325e:	39 c2                	cmp    %eax,%edx
  803260:	0f 85 90 00 00 00    	jne    8032f6 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803266:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803269:	8b 50 0c             	mov    0xc(%eax),%edx
  80326c:	8b 45 08             	mov    0x8(%ebp),%eax
  80326f:	8b 40 0c             	mov    0xc(%eax),%eax
  803272:	01 c2                	add    %eax,%edx
  803274:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803277:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803284:	8b 45 08             	mov    0x8(%ebp),%eax
  803287:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80328e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803292:	75 17                	jne    8032ab <insert_sorted_with_merge_freeList+0x243>
  803294:	83 ec 04             	sub    $0x4,%esp
  803297:	68 bc 42 80 00       	push   $0x8042bc
  80329c:	68 49 01 00 00       	push   $0x149
  8032a1:	68 df 42 80 00       	push   $0x8042df
  8032a6:	e8 36 d4 ff ff       	call   8006e1 <_panic>
  8032ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	89 10                	mov    %edx,(%eax)
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	8b 00                	mov    (%eax),%eax
  8032bb:	85 c0                	test   %eax,%eax
  8032bd:	74 0d                	je     8032cc <insert_sorted_with_merge_freeList+0x264>
  8032bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8032c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ca:	eb 08                	jmp    8032d4 <insert_sorted_with_merge_freeList+0x26c>
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8032eb:	40                   	inc    %eax
  8032ec:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032f1:	e9 bb 04 00 00       	jmp    8037b1 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032fa:	75 17                	jne    803313 <insert_sorted_with_merge_freeList+0x2ab>
  8032fc:	83 ec 04             	sub    $0x4,%esp
  8032ff:	68 30 43 80 00       	push   $0x804330
  803304:	68 4c 01 00 00       	push   $0x14c
  803309:	68 df 42 80 00       	push   $0x8042df
  80330e:	e8 ce d3 ff ff       	call   8006e1 <_panic>
  803313:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	89 50 04             	mov    %edx,0x4(%eax)
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	8b 40 04             	mov    0x4(%eax),%eax
  803325:	85 c0                	test   %eax,%eax
  803327:	74 0c                	je     803335 <insert_sorted_with_merge_freeList+0x2cd>
  803329:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80332e:	8b 55 08             	mov    0x8(%ebp),%edx
  803331:	89 10                	mov    %edx,(%eax)
  803333:	eb 08                	jmp    80333d <insert_sorted_with_merge_freeList+0x2d5>
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	a3 38 51 80 00       	mov    %eax,0x805138
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80334e:	a1 44 51 80 00       	mov    0x805144,%eax
  803353:	40                   	inc    %eax
  803354:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803359:	e9 53 04 00 00       	jmp    8037b1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80335e:	a1 38 51 80 00       	mov    0x805138,%eax
  803363:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803366:	e9 15 04 00 00       	jmp    803780 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80336b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336e:	8b 00                	mov    (%eax),%eax
  803370:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803373:	8b 45 08             	mov    0x8(%ebp),%eax
  803376:	8b 50 08             	mov    0x8(%eax),%edx
  803379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337c:	8b 40 08             	mov    0x8(%eax),%eax
  80337f:	39 c2                	cmp    %eax,%edx
  803381:	0f 86 f1 03 00 00    	jbe    803778 <insert_sorted_with_merge_freeList+0x710>
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	8b 50 08             	mov    0x8(%eax),%edx
  80338d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803390:	8b 40 08             	mov    0x8(%eax),%eax
  803393:	39 c2                	cmp    %eax,%edx
  803395:	0f 83 dd 03 00 00    	jae    803778 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80339b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339e:	8b 50 08             	mov    0x8(%eax),%edx
  8033a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a7:	01 c2                	add    %eax,%edx
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	8b 40 08             	mov    0x8(%eax),%eax
  8033af:	39 c2                	cmp    %eax,%edx
  8033b1:	0f 85 b9 01 00 00    	jne    803570 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	8b 50 08             	mov    0x8(%eax),%edx
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c3:	01 c2                	add    %eax,%edx
  8033c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c8:	8b 40 08             	mov    0x8(%eax),%eax
  8033cb:	39 c2                	cmp    %eax,%edx
  8033cd:	0f 85 0d 01 00 00    	jne    8034e0 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8033d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033df:	01 c2                	add    %eax,%edx
  8033e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e4:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033eb:	75 17                	jne    803404 <insert_sorted_with_merge_freeList+0x39c>
  8033ed:	83 ec 04             	sub    $0x4,%esp
  8033f0:	68 88 43 80 00       	push   $0x804388
  8033f5:	68 5c 01 00 00       	push   $0x15c
  8033fa:	68 df 42 80 00       	push   $0x8042df
  8033ff:	e8 dd d2 ff ff       	call   8006e1 <_panic>
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	8b 00                	mov    (%eax),%eax
  803409:	85 c0                	test   %eax,%eax
  80340b:	74 10                	je     80341d <insert_sorted_with_merge_freeList+0x3b5>
  80340d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803415:	8b 52 04             	mov    0x4(%edx),%edx
  803418:	89 50 04             	mov    %edx,0x4(%eax)
  80341b:	eb 0b                	jmp    803428 <insert_sorted_with_merge_freeList+0x3c0>
  80341d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803420:	8b 40 04             	mov    0x4(%eax),%eax
  803423:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803428:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342b:	8b 40 04             	mov    0x4(%eax),%eax
  80342e:	85 c0                	test   %eax,%eax
  803430:	74 0f                	je     803441 <insert_sorted_with_merge_freeList+0x3d9>
  803432:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803435:	8b 40 04             	mov    0x4(%eax),%eax
  803438:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80343b:	8b 12                	mov    (%edx),%edx
  80343d:	89 10                	mov    %edx,(%eax)
  80343f:	eb 0a                	jmp    80344b <insert_sorted_with_merge_freeList+0x3e3>
  803441:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803444:	8b 00                	mov    (%eax),%eax
  803446:	a3 38 51 80 00       	mov    %eax,0x805138
  80344b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803457:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345e:	a1 44 51 80 00       	mov    0x805144,%eax
  803463:	48                   	dec    %eax
  803464:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803469:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803473:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803476:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80347d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803481:	75 17                	jne    80349a <insert_sorted_with_merge_freeList+0x432>
  803483:	83 ec 04             	sub    $0x4,%esp
  803486:	68 bc 42 80 00       	push   $0x8042bc
  80348b:	68 5f 01 00 00       	push   $0x15f
  803490:	68 df 42 80 00       	push   $0x8042df
  803495:	e8 47 d2 ff ff       	call   8006e1 <_panic>
  80349a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a3:	89 10                	mov    %edx,(%eax)
  8034a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a8:	8b 00                	mov    (%eax),%eax
  8034aa:	85 c0                	test   %eax,%eax
  8034ac:	74 0d                	je     8034bb <insert_sorted_with_merge_freeList+0x453>
  8034ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8034b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034b6:	89 50 04             	mov    %edx,0x4(%eax)
  8034b9:	eb 08                	jmp    8034c3 <insert_sorted_with_merge_freeList+0x45b>
  8034bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034be:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c6:	a3 48 51 80 00       	mov    %eax,0x805148
  8034cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d5:	a1 54 51 80 00       	mov    0x805154,%eax
  8034da:	40                   	inc    %eax
  8034db:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8034e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8034e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ec:	01 c2                	add    %eax,%edx
  8034ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f1:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8034fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803501:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803508:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80350c:	75 17                	jne    803525 <insert_sorted_with_merge_freeList+0x4bd>
  80350e:	83 ec 04             	sub    $0x4,%esp
  803511:	68 bc 42 80 00       	push   $0x8042bc
  803516:	68 64 01 00 00       	push   $0x164
  80351b:	68 df 42 80 00       	push   $0x8042df
  803520:	e8 bc d1 ff ff       	call   8006e1 <_panic>
  803525:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80352b:	8b 45 08             	mov    0x8(%ebp),%eax
  80352e:	89 10                	mov    %edx,(%eax)
  803530:	8b 45 08             	mov    0x8(%ebp),%eax
  803533:	8b 00                	mov    (%eax),%eax
  803535:	85 c0                	test   %eax,%eax
  803537:	74 0d                	je     803546 <insert_sorted_with_merge_freeList+0x4de>
  803539:	a1 48 51 80 00       	mov    0x805148,%eax
  80353e:	8b 55 08             	mov    0x8(%ebp),%edx
  803541:	89 50 04             	mov    %edx,0x4(%eax)
  803544:	eb 08                	jmp    80354e <insert_sorted_with_merge_freeList+0x4e6>
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	a3 48 51 80 00       	mov    %eax,0x805148
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803560:	a1 54 51 80 00       	mov    0x805154,%eax
  803565:	40                   	inc    %eax
  803566:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80356b:	e9 41 02 00 00       	jmp    8037b1 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803570:	8b 45 08             	mov    0x8(%ebp),%eax
  803573:	8b 50 08             	mov    0x8(%eax),%edx
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	8b 40 0c             	mov    0xc(%eax),%eax
  80357c:	01 c2                	add    %eax,%edx
  80357e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803581:	8b 40 08             	mov    0x8(%eax),%eax
  803584:	39 c2                	cmp    %eax,%edx
  803586:	0f 85 7c 01 00 00    	jne    803708 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80358c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803590:	74 06                	je     803598 <insert_sorted_with_merge_freeList+0x530>
  803592:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803596:	75 17                	jne    8035af <insert_sorted_with_merge_freeList+0x547>
  803598:	83 ec 04             	sub    $0x4,%esp
  80359b:	68 f8 42 80 00       	push   $0x8042f8
  8035a0:	68 69 01 00 00       	push   $0x169
  8035a5:	68 df 42 80 00       	push   $0x8042df
  8035aa:	e8 32 d1 ff ff       	call   8006e1 <_panic>
  8035af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b2:	8b 50 04             	mov    0x4(%eax),%edx
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	89 50 04             	mov    %edx,0x4(%eax)
  8035bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035c1:	89 10                	mov    %edx,(%eax)
  8035c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c6:	8b 40 04             	mov    0x4(%eax),%eax
  8035c9:	85 c0                	test   %eax,%eax
  8035cb:	74 0d                	je     8035da <insert_sorted_with_merge_freeList+0x572>
  8035cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d0:	8b 40 04             	mov    0x4(%eax),%eax
  8035d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d6:	89 10                	mov    %edx,(%eax)
  8035d8:	eb 08                	jmp    8035e2 <insert_sorted_with_merge_freeList+0x57a>
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	a3 38 51 80 00       	mov    %eax,0x805138
  8035e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e8:	89 50 04             	mov    %edx,0x4(%eax)
  8035eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8035f0:	40                   	inc    %eax
  8035f1:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8035f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8035fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803602:	01 c2                	add    %eax,%edx
  803604:	8b 45 08             	mov    0x8(%ebp),%eax
  803607:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80360a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80360e:	75 17                	jne    803627 <insert_sorted_with_merge_freeList+0x5bf>
  803610:	83 ec 04             	sub    $0x4,%esp
  803613:	68 88 43 80 00       	push   $0x804388
  803618:	68 6b 01 00 00       	push   $0x16b
  80361d:	68 df 42 80 00       	push   $0x8042df
  803622:	e8 ba d0 ff ff       	call   8006e1 <_panic>
  803627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	74 10                	je     803640 <insert_sorted_with_merge_freeList+0x5d8>
  803630:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803633:	8b 00                	mov    (%eax),%eax
  803635:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803638:	8b 52 04             	mov    0x4(%edx),%edx
  80363b:	89 50 04             	mov    %edx,0x4(%eax)
  80363e:	eb 0b                	jmp    80364b <insert_sorted_with_merge_freeList+0x5e3>
  803640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803643:	8b 40 04             	mov    0x4(%eax),%eax
  803646:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80364b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364e:	8b 40 04             	mov    0x4(%eax),%eax
  803651:	85 c0                	test   %eax,%eax
  803653:	74 0f                	je     803664 <insert_sorted_with_merge_freeList+0x5fc>
  803655:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803658:	8b 40 04             	mov    0x4(%eax),%eax
  80365b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80365e:	8b 12                	mov    (%edx),%edx
  803660:	89 10                	mov    %edx,(%eax)
  803662:	eb 0a                	jmp    80366e <insert_sorted_with_merge_freeList+0x606>
  803664:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803667:	8b 00                	mov    (%eax),%eax
  803669:	a3 38 51 80 00       	mov    %eax,0x805138
  80366e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803677:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803681:	a1 44 51 80 00       	mov    0x805144,%eax
  803686:	48                   	dec    %eax
  803687:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80368c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803699:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036a4:	75 17                	jne    8036bd <insert_sorted_with_merge_freeList+0x655>
  8036a6:	83 ec 04             	sub    $0x4,%esp
  8036a9:	68 bc 42 80 00       	push   $0x8042bc
  8036ae:	68 6e 01 00 00       	push   $0x16e
  8036b3:	68 df 42 80 00       	push   $0x8042df
  8036b8:	e8 24 d0 ff ff       	call   8006e1 <_panic>
  8036bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c6:	89 10                	mov    %edx,(%eax)
  8036c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cb:	8b 00                	mov    (%eax),%eax
  8036cd:	85 c0                	test   %eax,%eax
  8036cf:	74 0d                	je     8036de <insert_sorted_with_merge_freeList+0x676>
  8036d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8036d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036d9:	89 50 04             	mov    %edx,0x4(%eax)
  8036dc:	eb 08                	jmp    8036e6 <insert_sorted_with_merge_freeList+0x67e>
  8036de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8036ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8036fd:	40                   	inc    %eax
  8036fe:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803703:	e9 a9 00 00 00       	jmp    8037b1 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803708:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80370c:	74 06                	je     803714 <insert_sorted_with_merge_freeList+0x6ac>
  80370e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803712:	75 17                	jne    80372b <insert_sorted_with_merge_freeList+0x6c3>
  803714:	83 ec 04             	sub    $0x4,%esp
  803717:	68 54 43 80 00       	push   $0x804354
  80371c:	68 73 01 00 00       	push   $0x173
  803721:	68 df 42 80 00       	push   $0x8042df
  803726:	e8 b6 cf ff ff       	call   8006e1 <_panic>
  80372b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372e:	8b 10                	mov    (%eax),%edx
  803730:	8b 45 08             	mov    0x8(%ebp),%eax
  803733:	89 10                	mov    %edx,(%eax)
  803735:	8b 45 08             	mov    0x8(%ebp),%eax
  803738:	8b 00                	mov    (%eax),%eax
  80373a:	85 c0                	test   %eax,%eax
  80373c:	74 0b                	je     803749 <insert_sorted_with_merge_freeList+0x6e1>
  80373e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803741:	8b 00                	mov    (%eax),%eax
  803743:	8b 55 08             	mov    0x8(%ebp),%edx
  803746:	89 50 04             	mov    %edx,0x4(%eax)
  803749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374c:	8b 55 08             	mov    0x8(%ebp),%edx
  80374f:	89 10                	mov    %edx,(%eax)
  803751:	8b 45 08             	mov    0x8(%ebp),%eax
  803754:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803757:	89 50 04             	mov    %edx,0x4(%eax)
  80375a:	8b 45 08             	mov    0x8(%ebp),%eax
  80375d:	8b 00                	mov    (%eax),%eax
  80375f:	85 c0                	test   %eax,%eax
  803761:	75 08                	jne    80376b <insert_sorted_with_merge_freeList+0x703>
  803763:	8b 45 08             	mov    0x8(%ebp),%eax
  803766:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80376b:	a1 44 51 80 00       	mov    0x805144,%eax
  803770:	40                   	inc    %eax
  803771:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803776:	eb 39                	jmp    8037b1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803778:	a1 40 51 80 00       	mov    0x805140,%eax
  80377d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803784:	74 07                	je     80378d <insert_sorted_with_merge_freeList+0x725>
  803786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803789:	8b 00                	mov    (%eax),%eax
  80378b:	eb 05                	jmp    803792 <insert_sorted_with_merge_freeList+0x72a>
  80378d:	b8 00 00 00 00       	mov    $0x0,%eax
  803792:	a3 40 51 80 00       	mov    %eax,0x805140
  803797:	a1 40 51 80 00       	mov    0x805140,%eax
  80379c:	85 c0                	test   %eax,%eax
  80379e:	0f 85 c7 fb ff ff    	jne    80336b <insert_sorted_with_merge_freeList+0x303>
  8037a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037a8:	0f 85 bd fb ff ff    	jne    80336b <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037ae:	eb 01                	jmp    8037b1 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037b0:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037b1:	90                   	nop
  8037b2:	c9                   	leave  
  8037b3:	c3                   	ret    

008037b4 <__udivdi3>:
  8037b4:	55                   	push   %ebp
  8037b5:	57                   	push   %edi
  8037b6:	56                   	push   %esi
  8037b7:	53                   	push   %ebx
  8037b8:	83 ec 1c             	sub    $0x1c,%esp
  8037bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037cb:	89 ca                	mov    %ecx,%edx
  8037cd:	89 f8                	mov    %edi,%eax
  8037cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037d3:	85 f6                	test   %esi,%esi
  8037d5:	75 2d                	jne    803804 <__udivdi3+0x50>
  8037d7:	39 cf                	cmp    %ecx,%edi
  8037d9:	77 65                	ja     803840 <__udivdi3+0x8c>
  8037db:	89 fd                	mov    %edi,%ebp
  8037dd:	85 ff                	test   %edi,%edi
  8037df:	75 0b                	jne    8037ec <__udivdi3+0x38>
  8037e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8037e6:	31 d2                	xor    %edx,%edx
  8037e8:	f7 f7                	div    %edi
  8037ea:	89 c5                	mov    %eax,%ebp
  8037ec:	31 d2                	xor    %edx,%edx
  8037ee:	89 c8                	mov    %ecx,%eax
  8037f0:	f7 f5                	div    %ebp
  8037f2:	89 c1                	mov    %eax,%ecx
  8037f4:	89 d8                	mov    %ebx,%eax
  8037f6:	f7 f5                	div    %ebp
  8037f8:	89 cf                	mov    %ecx,%edi
  8037fa:	89 fa                	mov    %edi,%edx
  8037fc:	83 c4 1c             	add    $0x1c,%esp
  8037ff:	5b                   	pop    %ebx
  803800:	5e                   	pop    %esi
  803801:	5f                   	pop    %edi
  803802:	5d                   	pop    %ebp
  803803:	c3                   	ret    
  803804:	39 ce                	cmp    %ecx,%esi
  803806:	77 28                	ja     803830 <__udivdi3+0x7c>
  803808:	0f bd fe             	bsr    %esi,%edi
  80380b:	83 f7 1f             	xor    $0x1f,%edi
  80380e:	75 40                	jne    803850 <__udivdi3+0x9c>
  803810:	39 ce                	cmp    %ecx,%esi
  803812:	72 0a                	jb     80381e <__udivdi3+0x6a>
  803814:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803818:	0f 87 9e 00 00 00    	ja     8038bc <__udivdi3+0x108>
  80381e:	b8 01 00 00 00       	mov    $0x1,%eax
  803823:	89 fa                	mov    %edi,%edx
  803825:	83 c4 1c             	add    $0x1c,%esp
  803828:	5b                   	pop    %ebx
  803829:	5e                   	pop    %esi
  80382a:	5f                   	pop    %edi
  80382b:	5d                   	pop    %ebp
  80382c:	c3                   	ret    
  80382d:	8d 76 00             	lea    0x0(%esi),%esi
  803830:	31 ff                	xor    %edi,%edi
  803832:	31 c0                	xor    %eax,%eax
  803834:	89 fa                	mov    %edi,%edx
  803836:	83 c4 1c             	add    $0x1c,%esp
  803839:	5b                   	pop    %ebx
  80383a:	5e                   	pop    %esi
  80383b:	5f                   	pop    %edi
  80383c:	5d                   	pop    %ebp
  80383d:	c3                   	ret    
  80383e:	66 90                	xchg   %ax,%ax
  803840:	89 d8                	mov    %ebx,%eax
  803842:	f7 f7                	div    %edi
  803844:	31 ff                	xor    %edi,%edi
  803846:	89 fa                	mov    %edi,%edx
  803848:	83 c4 1c             	add    $0x1c,%esp
  80384b:	5b                   	pop    %ebx
  80384c:	5e                   	pop    %esi
  80384d:	5f                   	pop    %edi
  80384e:	5d                   	pop    %ebp
  80384f:	c3                   	ret    
  803850:	bd 20 00 00 00       	mov    $0x20,%ebp
  803855:	89 eb                	mov    %ebp,%ebx
  803857:	29 fb                	sub    %edi,%ebx
  803859:	89 f9                	mov    %edi,%ecx
  80385b:	d3 e6                	shl    %cl,%esi
  80385d:	89 c5                	mov    %eax,%ebp
  80385f:	88 d9                	mov    %bl,%cl
  803861:	d3 ed                	shr    %cl,%ebp
  803863:	89 e9                	mov    %ebp,%ecx
  803865:	09 f1                	or     %esi,%ecx
  803867:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80386b:	89 f9                	mov    %edi,%ecx
  80386d:	d3 e0                	shl    %cl,%eax
  80386f:	89 c5                	mov    %eax,%ebp
  803871:	89 d6                	mov    %edx,%esi
  803873:	88 d9                	mov    %bl,%cl
  803875:	d3 ee                	shr    %cl,%esi
  803877:	89 f9                	mov    %edi,%ecx
  803879:	d3 e2                	shl    %cl,%edx
  80387b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80387f:	88 d9                	mov    %bl,%cl
  803881:	d3 e8                	shr    %cl,%eax
  803883:	09 c2                	or     %eax,%edx
  803885:	89 d0                	mov    %edx,%eax
  803887:	89 f2                	mov    %esi,%edx
  803889:	f7 74 24 0c          	divl   0xc(%esp)
  80388d:	89 d6                	mov    %edx,%esi
  80388f:	89 c3                	mov    %eax,%ebx
  803891:	f7 e5                	mul    %ebp
  803893:	39 d6                	cmp    %edx,%esi
  803895:	72 19                	jb     8038b0 <__udivdi3+0xfc>
  803897:	74 0b                	je     8038a4 <__udivdi3+0xf0>
  803899:	89 d8                	mov    %ebx,%eax
  80389b:	31 ff                	xor    %edi,%edi
  80389d:	e9 58 ff ff ff       	jmp    8037fa <__udivdi3+0x46>
  8038a2:	66 90                	xchg   %ax,%ax
  8038a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038a8:	89 f9                	mov    %edi,%ecx
  8038aa:	d3 e2                	shl    %cl,%edx
  8038ac:	39 c2                	cmp    %eax,%edx
  8038ae:	73 e9                	jae    803899 <__udivdi3+0xe5>
  8038b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038b3:	31 ff                	xor    %edi,%edi
  8038b5:	e9 40 ff ff ff       	jmp    8037fa <__udivdi3+0x46>
  8038ba:	66 90                	xchg   %ax,%ax
  8038bc:	31 c0                	xor    %eax,%eax
  8038be:	e9 37 ff ff ff       	jmp    8037fa <__udivdi3+0x46>
  8038c3:	90                   	nop

008038c4 <__umoddi3>:
  8038c4:	55                   	push   %ebp
  8038c5:	57                   	push   %edi
  8038c6:	56                   	push   %esi
  8038c7:	53                   	push   %ebx
  8038c8:	83 ec 1c             	sub    $0x1c,%esp
  8038cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038e3:	89 f3                	mov    %esi,%ebx
  8038e5:	89 fa                	mov    %edi,%edx
  8038e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038eb:	89 34 24             	mov    %esi,(%esp)
  8038ee:	85 c0                	test   %eax,%eax
  8038f0:	75 1a                	jne    80390c <__umoddi3+0x48>
  8038f2:	39 f7                	cmp    %esi,%edi
  8038f4:	0f 86 a2 00 00 00    	jbe    80399c <__umoddi3+0xd8>
  8038fa:	89 c8                	mov    %ecx,%eax
  8038fc:	89 f2                	mov    %esi,%edx
  8038fe:	f7 f7                	div    %edi
  803900:	89 d0                	mov    %edx,%eax
  803902:	31 d2                	xor    %edx,%edx
  803904:	83 c4 1c             	add    $0x1c,%esp
  803907:	5b                   	pop    %ebx
  803908:	5e                   	pop    %esi
  803909:	5f                   	pop    %edi
  80390a:	5d                   	pop    %ebp
  80390b:	c3                   	ret    
  80390c:	39 f0                	cmp    %esi,%eax
  80390e:	0f 87 ac 00 00 00    	ja     8039c0 <__umoddi3+0xfc>
  803914:	0f bd e8             	bsr    %eax,%ebp
  803917:	83 f5 1f             	xor    $0x1f,%ebp
  80391a:	0f 84 ac 00 00 00    	je     8039cc <__umoddi3+0x108>
  803920:	bf 20 00 00 00       	mov    $0x20,%edi
  803925:	29 ef                	sub    %ebp,%edi
  803927:	89 fe                	mov    %edi,%esi
  803929:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80392d:	89 e9                	mov    %ebp,%ecx
  80392f:	d3 e0                	shl    %cl,%eax
  803931:	89 d7                	mov    %edx,%edi
  803933:	89 f1                	mov    %esi,%ecx
  803935:	d3 ef                	shr    %cl,%edi
  803937:	09 c7                	or     %eax,%edi
  803939:	89 e9                	mov    %ebp,%ecx
  80393b:	d3 e2                	shl    %cl,%edx
  80393d:	89 14 24             	mov    %edx,(%esp)
  803940:	89 d8                	mov    %ebx,%eax
  803942:	d3 e0                	shl    %cl,%eax
  803944:	89 c2                	mov    %eax,%edx
  803946:	8b 44 24 08          	mov    0x8(%esp),%eax
  80394a:	d3 e0                	shl    %cl,%eax
  80394c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803950:	8b 44 24 08          	mov    0x8(%esp),%eax
  803954:	89 f1                	mov    %esi,%ecx
  803956:	d3 e8                	shr    %cl,%eax
  803958:	09 d0                	or     %edx,%eax
  80395a:	d3 eb                	shr    %cl,%ebx
  80395c:	89 da                	mov    %ebx,%edx
  80395e:	f7 f7                	div    %edi
  803960:	89 d3                	mov    %edx,%ebx
  803962:	f7 24 24             	mull   (%esp)
  803965:	89 c6                	mov    %eax,%esi
  803967:	89 d1                	mov    %edx,%ecx
  803969:	39 d3                	cmp    %edx,%ebx
  80396b:	0f 82 87 00 00 00    	jb     8039f8 <__umoddi3+0x134>
  803971:	0f 84 91 00 00 00    	je     803a08 <__umoddi3+0x144>
  803977:	8b 54 24 04          	mov    0x4(%esp),%edx
  80397b:	29 f2                	sub    %esi,%edx
  80397d:	19 cb                	sbb    %ecx,%ebx
  80397f:	89 d8                	mov    %ebx,%eax
  803981:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803985:	d3 e0                	shl    %cl,%eax
  803987:	89 e9                	mov    %ebp,%ecx
  803989:	d3 ea                	shr    %cl,%edx
  80398b:	09 d0                	or     %edx,%eax
  80398d:	89 e9                	mov    %ebp,%ecx
  80398f:	d3 eb                	shr    %cl,%ebx
  803991:	89 da                	mov    %ebx,%edx
  803993:	83 c4 1c             	add    $0x1c,%esp
  803996:	5b                   	pop    %ebx
  803997:	5e                   	pop    %esi
  803998:	5f                   	pop    %edi
  803999:	5d                   	pop    %ebp
  80399a:	c3                   	ret    
  80399b:	90                   	nop
  80399c:	89 fd                	mov    %edi,%ebp
  80399e:	85 ff                	test   %edi,%edi
  8039a0:	75 0b                	jne    8039ad <__umoddi3+0xe9>
  8039a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8039a7:	31 d2                	xor    %edx,%edx
  8039a9:	f7 f7                	div    %edi
  8039ab:	89 c5                	mov    %eax,%ebp
  8039ad:	89 f0                	mov    %esi,%eax
  8039af:	31 d2                	xor    %edx,%edx
  8039b1:	f7 f5                	div    %ebp
  8039b3:	89 c8                	mov    %ecx,%eax
  8039b5:	f7 f5                	div    %ebp
  8039b7:	89 d0                	mov    %edx,%eax
  8039b9:	e9 44 ff ff ff       	jmp    803902 <__umoddi3+0x3e>
  8039be:	66 90                	xchg   %ax,%ax
  8039c0:	89 c8                	mov    %ecx,%eax
  8039c2:	89 f2                	mov    %esi,%edx
  8039c4:	83 c4 1c             	add    $0x1c,%esp
  8039c7:	5b                   	pop    %ebx
  8039c8:	5e                   	pop    %esi
  8039c9:	5f                   	pop    %edi
  8039ca:	5d                   	pop    %ebp
  8039cb:	c3                   	ret    
  8039cc:	3b 04 24             	cmp    (%esp),%eax
  8039cf:	72 06                	jb     8039d7 <__umoddi3+0x113>
  8039d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039d5:	77 0f                	ja     8039e6 <__umoddi3+0x122>
  8039d7:	89 f2                	mov    %esi,%edx
  8039d9:	29 f9                	sub    %edi,%ecx
  8039db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039df:	89 14 24             	mov    %edx,(%esp)
  8039e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039ea:	8b 14 24             	mov    (%esp),%edx
  8039ed:	83 c4 1c             	add    $0x1c,%esp
  8039f0:	5b                   	pop    %ebx
  8039f1:	5e                   	pop    %esi
  8039f2:	5f                   	pop    %edi
  8039f3:	5d                   	pop    %ebp
  8039f4:	c3                   	ret    
  8039f5:	8d 76 00             	lea    0x0(%esi),%esi
  8039f8:	2b 04 24             	sub    (%esp),%eax
  8039fb:	19 fa                	sbb    %edi,%edx
  8039fd:	89 d1                	mov    %edx,%ecx
  8039ff:	89 c6                	mov    %eax,%esi
  803a01:	e9 71 ff ff ff       	jmp    803977 <__umoddi3+0xb3>
  803a06:	66 90                	xchg   %ax,%ax
  803a08:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a0c:	72 ea                	jb     8039f8 <__umoddi3+0x134>
  803a0e:	89 d9                	mov    %ebx,%ecx
  803a10:	e9 62 ff ff ff       	jmp    803977 <__umoddi3+0xb3>
