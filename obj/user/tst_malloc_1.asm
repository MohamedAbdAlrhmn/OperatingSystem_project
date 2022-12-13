
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
  80008d:	68 00 3a 80 00       	push   $0x803a00
  800092:	6a 14                	push   $0x14
  800094:	68 1c 3a 80 00       	push   $0x803a1c
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
  8000ca:	e8 fb 1a 00 00       	call   801bca <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d2:	e8 93 1b 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
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
  800105:	68 30 3a 80 00       	push   $0x803a30
  80010a:	6a 23                	push   $0x23
  80010c:	68 1c 3a 80 00       	push   $0x803a1c
  800111:	e8 cb 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800116:	e8 af 1a 00 00       	call   801bca <sys_calculate_free_frames>
  80011b:	89 c2                	mov    %eax,%edx
  80011d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800120:	39 c2                	cmp    %eax,%edx
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 60 3a 80 00       	push   $0x803a60
  80012c:	6a 27                	push   $0x27
  80012e:	68 1c 3a 80 00       	push   $0x803a1c
  800133:	e8 a9 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 2d 1b 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 cc 3a 80 00       	push   $0x803acc
  80014a:	6a 28                	push   $0x28
  80014c:	68 1c 3a 80 00       	push   $0x803a1c
  800151:	e8 8b 05 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 6f 1a 00 00       	call   801bca <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015e:	e8 07 1b 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
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
  8001a6:	68 30 3a 80 00       	push   $0x803a30
  8001ab:	6a 2d                	push   $0x2d
  8001ad:	68 1c 3a 80 00       	push   $0x803a1c
  8001b2:	e8 2a 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001b7:	e8 0e 1a 00 00       	call   801bca <sys_calculate_free_frames>
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	39 c2                	cmp    %eax,%edx
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 60 3a 80 00       	push   $0x803a60
  8001cd:	6a 2f                	push   $0x2f
  8001cf:	68 1c 3a 80 00       	push   $0x803a1c
  8001d4:	e8 08 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001d9:	e8 8c 1a 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
  8001de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 cc 3a 80 00       	push   $0x803acc
  8001eb:	6a 30                	push   $0x30
  8001ed:	68 1c 3a 80 00       	push   $0x803a1c
  8001f2:	e8 ea 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f7:	e8 ce 19 00 00       	call   801bca <sys_calculate_free_frames>
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 66 1a 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
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
  80024a:	68 30 3a 80 00       	push   $0x803a30
  80024f:	6a 35                	push   $0x35
  800251:	68 1c 3a 80 00       	push   $0x803a1c
  800256:	e8 86 04 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80025b:	e8 6a 19 00 00       	call   801bca <sys_calculate_free_frames>
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 60 3a 80 00       	push   $0x803a60
  800271:	6a 37                	push   $0x37
  800273:	68 1c 3a 80 00       	push   $0x803a1c
  800278:	e8 64 04 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80027d:	e8 e8 19 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
  800282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 cc 3a 80 00       	push   $0x803acc
  80028f:	6a 38                	push   $0x38
  800291:	68 1c 3a 80 00       	push   $0x803a1c
  800296:	e8 46 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029b:	e8 2a 19 00 00       	call   801bca <sys_calculate_free_frames>
  8002a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a3:	e8 c2 19 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
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
  800302:	68 30 3a 80 00       	push   $0x803a30
  800307:	6a 3d                	push   $0x3d
  800309:	68 1c 3a 80 00       	push   $0x803a1c
  80030e:	e8 ce 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800313:	e8 b2 18 00 00       	call   801bca <sys_calculate_free_frames>
  800318:	89 c2                	mov    %eax,%edx
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	74 14                	je     800335 <_main+0x2fd>
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	68 60 3a 80 00       	push   $0x803a60
  800329:	6a 3f                	push   $0x3f
  80032b:	68 1c 3a 80 00       	push   $0x803a1c
  800330:	e8 ac 03 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800335:	e8 30 19 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
  80033a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 cc 3a 80 00       	push   $0x803acc
  800347:	6a 40                	push   $0x40
  800349:	68 1c 3a 80 00       	push   $0x803a1c
  80034e:	e8 8e 03 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800353:	e8 72 18 00 00       	call   801bca <sys_calculate_free_frames>
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035b:	e8 0a 19 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
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
  8003be:	68 30 3a 80 00       	push   $0x803a30
  8003c3:	6a 45                	push   $0x45
  8003c5:	68 1c 3a 80 00       	push   $0x803a1c
  8003ca:	e8 12 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003cf:	e8 f6 17 00 00       	call   801bca <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	74 14                	je     8003f1 <_main+0x3b9>
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 60 3a 80 00       	push   $0x803a60
  8003e5:	6a 47                	push   $0x47
  8003e7:	68 1c 3a 80 00       	push   $0x803a1c
  8003ec:	e8 f0 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003f1:	e8 74 18 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
  8003f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003f9:	74 14                	je     80040f <_main+0x3d7>
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 cc 3a 80 00       	push   $0x803acc
  800403:	6a 48                	push   $0x48
  800405:	68 1c 3a 80 00       	push   $0x803a1c
  80040a:	e8 d2 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80040f:	e8 b6 17 00 00       	call   801bca <sys_calculate_free_frames>
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800417:	e8 4e 18 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
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
  800479:	68 30 3a 80 00       	push   $0x803a30
  80047e:	6a 4d                	push   $0x4d
  800480:	68 1c 3a 80 00       	push   $0x803a1c
  800485:	e8 57 02 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80048a:	e8 3b 17 00 00       	call   801bca <sys_calculate_free_frames>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <_main+0x474>
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 fa 3a 80 00       	push   $0x803afa
  8004a0:	6a 4e                	push   $0x4e
  8004a2:	68 1c 3a 80 00       	push   $0x803a1c
  8004a7:	e8 35 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ac:	e8 b9 17 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
  8004b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004b4:	74 14                	je     8004ca <_main+0x492>
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 cc 3a 80 00       	push   $0x803acc
  8004be:	6a 4f                	push   $0x4f
  8004c0:	68 1c 3a 80 00       	push   $0x803a1c
  8004c5:	e8 17 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ca:	e8 fb 16 00 00       	call   801bca <sys_calculate_free_frames>
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d2:	e8 93 17 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
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
  80053e:	68 30 3a 80 00       	push   $0x803a30
  800543:	6a 54                	push   $0x54
  800545:	68 1c 3a 80 00       	push   $0x803a1c
  80054a:	e8 92 01 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80054f:	e8 76 16 00 00       	call   801bca <sys_calculate_free_frames>
  800554:	89 c2                	mov    %eax,%edx
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 fa 3a 80 00       	push   $0x803afa
  800565:	6a 55                	push   $0x55
  800567:	68 1c 3a 80 00       	push   $0x803a1c
  80056c:	e8 70 01 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800571:	e8 f4 16 00 00       	call   801c6a <sys_pf_calculate_allocated_pages>
  800576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 cc 3a 80 00       	push   $0x803acc
  800583:	6a 56                	push   $0x56
  800585:	68 1c 3a 80 00       	push   $0x803a1c
  80058a:	e8 52 01 00 00       	call   8006e1 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	68 10 3b 80 00       	push   $0x803b10
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
  8005ab:	e8 fa 18 00 00       	call   801eaa <sys_getenvindex>
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
  800616:	e8 9c 16 00 00       	call   801cb7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	68 64 3b 80 00       	push   $0x803b64
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
  800646:	68 8c 3b 80 00       	push   $0x803b8c
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
  800677:	68 b4 3b 80 00       	push   $0x803bb4
  80067c:	e8 14 03 00 00       	call   800995 <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800684:	a1 20 50 80 00       	mov    0x805020,%eax
  800689:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	68 0c 3c 80 00       	push   $0x803c0c
  800698:	e8 f8 02 00 00       	call   800995 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	68 64 3b 80 00       	push   $0x803b64
  8006a8:	e8 e8 02 00 00       	call   800995 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b0:	e8 1c 16 00 00       	call   801cd1 <sys_enable_interrupt>

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
  8006c8:	e8 a9 17 00 00       	call   801e76 <sys_destroy_env>
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
  8006d9:	e8 fe 17 00 00       	call   801edc <sys_exit_env>
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
  800702:	68 20 3c 80 00       	push   $0x803c20
  800707:	e8 89 02 00 00       	call   800995 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070f:	a1 00 50 80 00       	mov    0x805000,%eax
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	50                   	push   %eax
  80071b:	68 25 3c 80 00       	push   $0x803c25
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
  80073f:	68 41 3c 80 00       	push   $0x803c41
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
  80076b:	68 44 3c 80 00       	push   $0x803c44
  800770:	6a 26                	push   $0x26
  800772:	68 90 3c 80 00       	push   $0x803c90
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
  80083d:	68 9c 3c 80 00       	push   $0x803c9c
  800842:	6a 3a                	push   $0x3a
  800844:	68 90 3c 80 00       	push   $0x803c90
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
  8008ad:	68 f0 3c 80 00       	push   $0x803cf0
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 90 3c 80 00       	push   $0x803c90
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
  800907:	e8 fd 11 00 00       	call   801b09 <sys_cputs>
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
  80097e:	e8 86 11 00 00       	call   801b09 <sys_cputs>
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
  8009c8:	e8 ea 12 00 00       	call   801cb7 <sys_disable_interrupt>
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
  8009e8:	e8 e4 12 00 00       	call   801cd1 <sys_enable_interrupt>
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
  800a32:	e8 55 2d 00 00       	call   80378c <__udivdi3>
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
  800a82:	e8 15 2e 00 00       	call   80389c <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 54 3f 80 00       	add    $0x803f54,%eax
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
  800bdd:	8b 04 85 78 3f 80 00 	mov    0x803f78(,%eax,4),%eax
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
  800cbe:	8b 34 9d c0 3d 80 00 	mov    0x803dc0(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 65 3f 80 00       	push   $0x803f65
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
  800ce3:	68 6e 3f 80 00       	push   $0x803f6e
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
  800d10:	be 71 3f 80 00       	mov    $0x803f71,%esi
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
  801736:	68 d0 40 80 00       	push   $0x8040d0
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
  801806:	e8 42 04 00 00       	call   801c4d <sys_allocate_chunk>
  80180b:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80180e:	a1 20 51 80 00       	mov    0x805120,%eax
  801813:	83 ec 0c             	sub    $0xc,%esp
  801816:	50                   	push   %eax
  801817:	e8 b7 0a 00 00       	call   8022d3 <initialize_MemBlocksList>
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
  801844:	68 f5 40 80 00       	push   $0x8040f5
  801849:	6a 33                	push   $0x33
  80184b:	68 13 41 80 00       	push   $0x804113
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
  8018c3:	68 20 41 80 00       	push   $0x804120
  8018c8:	6a 34                	push   $0x34
  8018ca:	68 13 41 80 00       	push   $0x804113
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
  801920:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801923:	e8 f7 fd ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801928:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80192c:	75 07                	jne    801935 <malloc+0x18>
  80192e:	b8 00 00 00 00       	mov    $0x0,%eax
  801933:	eb 14                	jmp    801949 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801935:	83 ec 04             	sub    $0x4,%esp
  801938:	68 44 41 80 00       	push   $0x804144
  80193d:	6a 46                	push   $0x46
  80193f:	68 13 41 80 00       	push   $0x804113
  801944:	e8 98 ed ff ff       	call   8006e1 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	68 6c 41 80 00       	push   $0x80416c
  801959:	6a 61                	push   $0x61
  80195b:	68 13 41 80 00       	push   $0x804113
  801960:	e8 7c ed ff ff       	call   8006e1 <_panic>

00801965 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 38             	sub    $0x38,%esp
  80196b:	8b 45 10             	mov    0x10(%ebp),%eax
  80196e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801971:	e8 a9 fd ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801976:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80197a:	75 0a                	jne    801986 <smalloc+0x21>
  80197c:	b8 00 00 00 00       	mov    $0x0,%eax
  801981:	e9 9e 00 00 00       	jmp    801a24 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801986:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80198d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801993:	01 d0                	add    %edx,%eax
  801995:	48                   	dec    %eax
  801996:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801999:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199c:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a1:	f7 75 f0             	divl   -0x10(%ebp)
  8019a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a7:	29 d0                	sub    %edx,%eax
  8019a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8019ac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8019b3:	e8 63 06 00 00       	call   80201b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	74 11                	je     8019cd <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8019bc:	83 ec 0c             	sub    $0xc,%esp
  8019bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8019c2:	e8 ce 0c 00 00       	call   802695 <alloc_block_FF>
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8019cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019d1:	74 4c                	je     801a1f <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8019d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d6:	8b 40 08             	mov    0x8(%eax),%eax
  8019d9:	89 c2                	mov    %eax,%edx
  8019db:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8019df:	52                   	push   %edx
  8019e0:	50                   	push   %eax
  8019e1:	ff 75 0c             	pushl  0xc(%ebp)
  8019e4:	ff 75 08             	pushl  0x8(%ebp)
  8019e7:	e8 b4 03 00 00       	call   801da0 <sys_createSharedObject>
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8019f2:	83 ec 08             	sub    $0x8,%esp
  8019f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8019f8:	68 8f 41 80 00       	push   $0x80418f
  8019fd:	e8 93 ef ff ff       	call   800995 <cprintf>
  801a02:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801a05:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801a09:	74 14                	je     801a1f <smalloc+0xba>
  801a0b:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801a0f:	74 0e                	je     801a1f <smalloc+0xba>
  801a11:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801a15:	74 08                	je     801a1f <smalloc+0xba>
			return (void*) mem_block->sva;
  801a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1a:	8b 40 08             	mov    0x8(%eax),%eax
  801a1d:	eb 05                	jmp    801a24 <smalloc+0xbf>
	}
	return NULL;
  801a1f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a2c:	e8 ee fc ff ff       	call   80171f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	68 a4 41 80 00       	push   $0x8041a4
  801a39:	68 ab 00 00 00       	push   $0xab
  801a3e:	68 13 41 80 00       	push   $0x804113
  801a43:	e8 99 ec ff ff       	call   8006e1 <_panic>

00801a48 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a4e:	e8 cc fc ff ff       	call   80171f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a53:	83 ec 04             	sub    $0x4,%esp
  801a56:	68 c8 41 80 00       	push   $0x8041c8
  801a5b:	68 ef 00 00 00       	push   $0xef
  801a60:	68 13 41 80 00       	push   $0x804113
  801a65:	e8 77 ec ff ff       	call   8006e1 <_panic>

00801a6a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a70:	83 ec 04             	sub    $0x4,%esp
  801a73:	68 f0 41 80 00       	push   $0x8041f0
  801a78:	68 03 01 00 00       	push   $0x103
  801a7d:	68 13 41 80 00       	push   $0x804113
  801a82:	e8 5a ec ff ff       	call   8006e1 <_panic>

00801a87 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	68 14 42 80 00       	push   $0x804214
  801a95:	68 0e 01 00 00       	push   $0x10e
  801a9a:	68 13 41 80 00       	push   $0x804113
  801a9f:	e8 3d ec ff ff       	call   8006e1 <_panic>

00801aa4 <shrink>:

}
void shrink(uint32 newSize)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aaa:	83 ec 04             	sub    $0x4,%esp
  801aad:	68 14 42 80 00       	push   $0x804214
  801ab2:	68 13 01 00 00       	push   $0x113
  801ab7:	68 13 41 80 00       	push   $0x804113
  801abc:	e8 20 ec ff ff       	call   8006e1 <_panic>

00801ac1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ac7:	83 ec 04             	sub    $0x4,%esp
  801aca:	68 14 42 80 00       	push   $0x804214
  801acf:	68 18 01 00 00       	push   $0x118
  801ad4:	68 13 41 80 00       	push   $0x804113
  801ad9:	e8 03 ec ff ff       	call   8006e1 <_panic>

00801ade <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	57                   	push   %edi
  801ae2:	56                   	push   %esi
  801ae3:	53                   	push   %ebx
  801ae4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801af3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801af6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801af9:	cd 30                	int    $0x30
  801afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	5b                   	pop    %ebx
  801b05:	5e                   	pop    %esi
  801b06:	5f                   	pop    %edi
  801b07:	5d                   	pop    %ebp
  801b08:	c3                   	ret    

00801b09 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 04             	sub    $0x4,%esp
  801b0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b12:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b15:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	52                   	push   %edx
  801b21:	ff 75 0c             	pushl  0xc(%ebp)
  801b24:	50                   	push   %eax
  801b25:	6a 00                	push   $0x0
  801b27:	e8 b2 ff ff ff       	call   801ade <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	90                   	nop
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 01                	push   $0x1
  801b41:	e8 98 ff ff ff       	call   801ade <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	52                   	push   %edx
  801b5b:	50                   	push   %eax
  801b5c:	6a 05                	push   $0x5
  801b5e:	e8 7b ff ff ff       	call   801ade <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	56                   	push   %esi
  801b6c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b6d:	8b 75 18             	mov    0x18(%ebp),%esi
  801b70:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	56                   	push   %esi
  801b7d:	53                   	push   %ebx
  801b7e:	51                   	push   %ecx
  801b7f:	52                   	push   %edx
  801b80:	50                   	push   %eax
  801b81:	6a 06                	push   $0x6
  801b83:	e8 56 ff ff ff       	call   801ade <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8e:	5b                   	pop    %ebx
  801b8f:	5e                   	pop    %esi
  801b90:	5d                   	pop    %ebp
  801b91:	c3                   	ret    

00801b92 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 07                	push   $0x7
  801ba5:	e8 34 ff ff ff       	call   801ade <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	6a 08                	push   $0x8
  801bc0:	e8 19 ff ff ff       	call   801ade <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 09                	push   $0x9
  801bd9:	e8 00 ff ff ff       	call   801ade <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 0a                	push   $0xa
  801bf2:	e8 e7 fe ff ff       	call   801ade <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 0b                	push   $0xb
  801c0b:	e8 ce fe ff ff       	call   801ade <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	ff 75 0c             	pushl  0xc(%ebp)
  801c21:	ff 75 08             	pushl  0x8(%ebp)
  801c24:	6a 0f                	push   $0xf
  801c26:	e8 b3 fe ff ff       	call   801ade <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
	return;
  801c2e:	90                   	nop
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	ff 75 08             	pushl  0x8(%ebp)
  801c40:	6a 10                	push   $0x10
  801c42:	e8 97 fe ff ff       	call   801ade <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4a:	90                   	nop
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	ff 75 10             	pushl  0x10(%ebp)
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	ff 75 08             	pushl  0x8(%ebp)
  801c5d:	6a 11                	push   $0x11
  801c5f:	e8 7a fe ff ff       	call   801ade <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
	return ;
  801c67:	90                   	nop
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 0c                	push   $0xc
  801c79:	e8 60 fe ff ff       	call   801ade <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	ff 75 08             	pushl  0x8(%ebp)
  801c91:	6a 0d                	push   $0xd
  801c93:	e8 46 fe ff ff       	call   801ade <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 0e                	push   $0xe
  801cac:	e8 2d fe ff ff       	call   801ade <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	90                   	nop
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 13                	push   $0x13
  801cc6:	e8 13 fe ff ff       	call   801ade <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
}
  801cce:	90                   	nop
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 14                	push   $0x14
  801ce0:	e8 f9 fd ff ff       	call   801ade <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	90                   	nop
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_cputc>:


void
sys_cputc(const char c)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cf7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	50                   	push   %eax
  801d04:	6a 15                	push   $0x15
  801d06:	e8 d3 fd ff ff       	call   801ade <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	90                   	nop
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 16                	push   $0x16
  801d20:	e8 b9 fd ff ff       	call   801ade <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	90                   	nop
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	ff 75 0c             	pushl  0xc(%ebp)
  801d3a:	50                   	push   %eax
  801d3b:	6a 17                	push   $0x17
  801d3d:	e8 9c fd ff ff       	call   801ade <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	52                   	push   %edx
  801d57:	50                   	push   %eax
  801d58:	6a 1a                	push   $0x1a
  801d5a:	e8 7f fd ff ff       	call   801ade <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	52                   	push   %edx
  801d74:	50                   	push   %eax
  801d75:	6a 18                	push   $0x18
  801d77:	e8 62 fd ff ff       	call   801ade <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	90                   	nop
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	52                   	push   %edx
  801d92:	50                   	push   %eax
  801d93:	6a 19                	push   $0x19
  801d95:	e8 44 fd ff ff       	call   801ade <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
}
  801d9d:	90                   	nop
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 04             	sub    $0x4,%esp
  801da6:	8b 45 10             	mov    0x10(%ebp),%eax
  801da9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801daf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	6a 00                	push   $0x0
  801db8:	51                   	push   %ecx
  801db9:	52                   	push   %edx
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	50                   	push   %eax
  801dbe:	6a 1b                	push   $0x1b
  801dc0:	e8 19 fd ff ff       	call   801ade <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	52                   	push   %edx
  801dda:	50                   	push   %eax
  801ddb:	6a 1c                	push   $0x1c
  801ddd:	e8 fc fc ff ff       	call   801ade <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801dea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ded:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	51                   	push   %ecx
  801df8:	52                   	push   %edx
  801df9:	50                   	push   %eax
  801dfa:	6a 1d                	push   $0x1d
  801dfc:	e8 dd fc ff ff       	call   801ade <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	52                   	push   %edx
  801e16:	50                   	push   %eax
  801e17:	6a 1e                	push   $0x1e
  801e19:	e8 c0 fc ff ff       	call   801ade <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 1f                	push   $0x1f
  801e32:	e8 a7 fc ff ff       	call   801ade <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	6a 00                	push   $0x0
  801e44:	ff 75 14             	pushl  0x14(%ebp)
  801e47:	ff 75 10             	pushl  0x10(%ebp)
  801e4a:	ff 75 0c             	pushl  0xc(%ebp)
  801e4d:	50                   	push   %eax
  801e4e:	6a 20                	push   $0x20
  801e50:	e8 89 fc ff ff       	call   801ade <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	50                   	push   %eax
  801e69:	6a 21                	push   $0x21
  801e6b:	e8 6e fc ff ff       	call   801ade <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
}
  801e73:	90                   	nop
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	50                   	push   %eax
  801e85:	6a 22                	push   $0x22
  801e87:	e8 52 fc ff ff       	call   801ade <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 02                	push   $0x2
  801ea0:	e8 39 fc ff ff       	call   801ade <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 03                	push   $0x3
  801eb9:	e8 20 fc ff ff       	call   801ade <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 04                	push   $0x4
  801ed2:	e8 07 fc ff ff       	call   801ade <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_exit_env>:


void sys_exit_env(void)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 23                	push   $0x23
  801eeb:	e8 ee fb ff ff       	call   801ade <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	90                   	nop
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801efc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801eff:	8d 50 04             	lea    0x4(%eax),%edx
  801f02:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	52                   	push   %edx
  801f0c:	50                   	push   %eax
  801f0d:	6a 24                	push   $0x24
  801f0f:	e8 ca fb ff ff       	call   801ade <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
	return result;
  801f17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f20:	89 01                	mov    %eax,(%ecx)
  801f22:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	c9                   	leave  
  801f29:	c2 04 00             	ret    $0x4

00801f2c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	ff 75 10             	pushl  0x10(%ebp)
  801f36:	ff 75 0c             	pushl  0xc(%ebp)
  801f39:	ff 75 08             	pushl  0x8(%ebp)
  801f3c:	6a 12                	push   $0x12
  801f3e:	e8 9b fb ff ff       	call   801ade <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
	return ;
  801f46:	90                   	nop
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 25                	push   $0x25
  801f58:	e8 81 fb ff ff       	call   801ade <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 04             	sub    $0x4,%esp
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f6e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	50                   	push   %eax
  801f7b:	6a 26                	push   $0x26
  801f7d:	e8 5c fb ff ff       	call   801ade <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
	return ;
  801f85:	90                   	nop
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <rsttst>:
void rsttst()
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 28                	push   $0x28
  801f97:	e8 42 fb ff ff       	call   801ade <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9f:	90                   	nop
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	83 ec 04             	sub    $0x4,%esp
  801fa8:	8b 45 14             	mov    0x14(%ebp),%eax
  801fab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fae:	8b 55 18             	mov    0x18(%ebp),%edx
  801fb1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fb5:	52                   	push   %edx
  801fb6:	50                   	push   %eax
  801fb7:	ff 75 10             	pushl  0x10(%ebp)
  801fba:	ff 75 0c             	pushl  0xc(%ebp)
  801fbd:	ff 75 08             	pushl  0x8(%ebp)
  801fc0:	6a 27                	push   $0x27
  801fc2:	e8 17 fb ff ff       	call   801ade <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801fca:	90                   	nop
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <chktst>:
void chktst(uint32 n)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	6a 29                	push   $0x29
  801fdd:	e8 fc fa ff ff       	call   801ade <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe5:	90                   	nop
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <inctst>:

void inctst()
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 2a                	push   $0x2a
  801ff7:	e8 e2 fa ff ff       	call   801ade <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
	return ;
  801fff:	90                   	nop
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <gettst>:
uint32 gettst()
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 2b                	push   $0x2b
  802011:	e8 c8 fa ff ff       	call   801ade <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 2c                	push   $0x2c
  80202d:	e8 ac fa ff ff       	call   801ade <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
  802035:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802038:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80203c:	75 07                	jne    802045 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80203e:	b8 01 00 00 00       	mov    $0x1,%eax
  802043:	eb 05                	jmp    80204a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802045:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 2c                	push   $0x2c
  80205e:	e8 7b fa ff ff       	call   801ade <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
  802066:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802069:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80206d:	75 07                	jne    802076 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80206f:	b8 01 00 00 00       	mov    $0x1,%eax
  802074:	eb 05                	jmp    80207b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 2c                	push   $0x2c
  80208f:	e8 4a fa ff ff       	call   801ade <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
  802097:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80209a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80209e:	75 07                	jne    8020a7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a5:	eb 05                	jmp    8020ac <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 2c                	push   $0x2c
  8020c0:	e8 19 fa ff ff       	call   801ade <syscall>
  8020c5:	83 c4 18             	add    $0x18,%esp
  8020c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020cb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020cf:	75 07                	jne    8020d8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d6:	eb 05                	jmp    8020dd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	ff 75 08             	pushl  0x8(%ebp)
  8020ed:	6a 2d                	push   $0x2d
  8020ef:	e8 ea f9 ff ff       	call   801ade <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f7:	90                   	nop
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802101:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802104:	8b 55 0c             	mov    0xc(%ebp),%edx
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	6a 00                	push   $0x0
  80210c:	53                   	push   %ebx
  80210d:	51                   	push   %ecx
  80210e:	52                   	push   %edx
  80210f:	50                   	push   %eax
  802110:	6a 2e                	push   $0x2e
  802112:	e8 c7 f9 ff ff       	call   801ade <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802122:	8b 55 0c             	mov    0xc(%ebp),%edx
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	52                   	push   %edx
  80212f:	50                   	push   %eax
  802130:	6a 2f                	push   $0x2f
  802132:	e8 a7 f9 ff ff       	call   801ade <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802142:	83 ec 0c             	sub    $0xc,%esp
  802145:	68 24 42 80 00       	push   $0x804224
  80214a:	e8 46 e8 ff ff       	call   800995 <cprintf>
  80214f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802152:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802159:	83 ec 0c             	sub    $0xc,%esp
  80215c:	68 50 42 80 00       	push   $0x804250
  802161:	e8 2f e8 ff ff       	call   800995 <cprintf>
  802166:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802169:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80216d:	a1 38 51 80 00       	mov    0x805138,%eax
  802172:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802175:	eb 56                	jmp    8021cd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802177:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80217b:	74 1c                	je     802199 <print_mem_block_lists+0x5d>
  80217d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802180:	8b 50 08             	mov    0x8(%eax),%edx
  802183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802186:	8b 48 08             	mov    0x8(%eax),%ecx
  802189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218c:	8b 40 0c             	mov    0xc(%eax),%eax
  80218f:	01 c8                	add    %ecx,%eax
  802191:	39 c2                	cmp    %eax,%edx
  802193:	73 04                	jae    802199 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802195:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 50 08             	mov    0x8(%eax),%edx
  80219f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a5:	01 c2                	add    %eax,%edx
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	8b 40 08             	mov    0x8(%eax),%eax
  8021ad:	83 ec 04             	sub    $0x4,%esp
  8021b0:	52                   	push   %edx
  8021b1:	50                   	push   %eax
  8021b2:	68 65 42 80 00       	push   $0x804265
  8021b7:	e8 d9 e7 ff ff       	call   800995 <cprintf>
  8021bc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021c5:	a1 40 51 80 00       	mov    0x805140,%eax
  8021ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d1:	74 07                	je     8021da <print_mem_block_lists+0x9e>
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	8b 00                	mov    (%eax),%eax
  8021d8:	eb 05                	jmp    8021df <print_mem_block_lists+0xa3>
  8021da:	b8 00 00 00 00       	mov    $0x0,%eax
  8021df:	a3 40 51 80 00       	mov    %eax,0x805140
  8021e4:	a1 40 51 80 00       	mov    0x805140,%eax
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	75 8a                	jne    802177 <print_mem_block_lists+0x3b>
  8021ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f1:	75 84                	jne    802177 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021f3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021f7:	75 10                	jne    802209 <print_mem_block_lists+0xcd>
  8021f9:	83 ec 0c             	sub    $0xc,%esp
  8021fc:	68 74 42 80 00       	push   $0x804274
  802201:	e8 8f e7 ff ff       	call   800995 <cprintf>
  802206:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802209:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802210:	83 ec 0c             	sub    $0xc,%esp
  802213:	68 98 42 80 00       	push   $0x804298
  802218:	e8 78 e7 ff ff       	call   800995 <cprintf>
  80221d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802220:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802224:	a1 40 50 80 00       	mov    0x805040,%eax
  802229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80222c:	eb 56                	jmp    802284 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80222e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802232:	74 1c                	je     802250 <print_mem_block_lists+0x114>
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	8b 50 08             	mov    0x8(%eax),%edx
  80223a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223d:	8b 48 08             	mov    0x8(%eax),%ecx
  802240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802243:	8b 40 0c             	mov    0xc(%eax),%eax
  802246:	01 c8                	add    %ecx,%eax
  802248:	39 c2                	cmp    %eax,%edx
  80224a:	73 04                	jae    802250 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80224c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	8b 50 08             	mov    0x8(%eax),%edx
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	8b 40 0c             	mov    0xc(%eax),%eax
  80225c:	01 c2                	add    %eax,%edx
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	8b 40 08             	mov    0x8(%eax),%eax
  802264:	83 ec 04             	sub    $0x4,%esp
  802267:	52                   	push   %edx
  802268:	50                   	push   %eax
  802269:	68 65 42 80 00       	push   $0x804265
  80226e:	e8 22 e7 ff ff       	call   800995 <cprintf>
  802273:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80227c:	a1 48 50 80 00       	mov    0x805048,%eax
  802281:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802284:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802288:	74 07                	je     802291 <print_mem_block_lists+0x155>
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 00                	mov    (%eax),%eax
  80228f:	eb 05                	jmp    802296 <print_mem_block_lists+0x15a>
  802291:	b8 00 00 00 00       	mov    $0x0,%eax
  802296:	a3 48 50 80 00       	mov    %eax,0x805048
  80229b:	a1 48 50 80 00       	mov    0x805048,%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	75 8a                	jne    80222e <print_mem_block_lists+0xf2>
  8022a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a8:	75 84                	jne    80222e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022aa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022ae:	75 10                	jne    8022c0 <print_mem_block_lists+0x184>
  8022b0:	83 ec 0c             	sub    $0xc,%esp
  8022b3:	68 b0 42 80 00       	push   $0x8042b0
  8022b8:	e8 d8 e6 ff ff       	call   800995 <cprintf>
  8022bd:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022c0:	83 ec 0c             	sub    $0xc,%esp
  8022c3:	68 24 42 80 00       	push   $0x804224
  8022c8:	e8 c8 e6 ff ff       	call   800995 <cprintf>
  8022cd:	83 c4 10             	add    $0x10,%esp

}
  8022d0:	90                   	nop
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8022d9:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022e0:	00 00 00 
  8022e3:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8022ea:	00 00 00 
  8022ed:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022f4:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8022f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022fe:	e9 9e 00 00 00       	jmp    8023a1 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802303:	a1 50 50 80 00       	mov    0x805050,%eax
  802308:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230b:	c1 e2 04             	shl    $0x4,%edx
  80230e:	01 d0                	add    %edx,%eax
  802310:	85 c0                	test   %eax,%eax
  802312:	75 14                	jne    802328 <initialize_MemBlocksList+0x55>
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	68 d8 42 80 00       	push   $0x8042d8
  80231c:	6a 46                	push   $0x46
  80231e:	68 fb 42 80 00       	push   $0x8042fb
  802323:	e8 b9 e3 ff ff       	call   8006e1 <_panic>
  802328:	a1 50 50 80 00       	mov    0x805050,%eax
  80232d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802330:	c1 e2 04             	shl    $0x4,%edx
  802333:	01 d0                	add    %edx,%eax
  802335:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80233b:	89 10                	mov    %edx,(%eax)
  80233d:	8b 00                	mov    (%eax),%eax
  80233f:	85 c0                	test   %eax,%eax
  802341:	74 18                	je     80235b <initialize_MemBlocksList+0x88>
  802343:	a1 48 51 80 00       	mov    0x805148,%eax
  802348:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80234e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802351:	c1 e1 04             	shl    $0x4,%ecx
  802354:	01 ca                	add    %ecx,%edx
  802356:	89 50 04             	mov    %edx,0x4(%eax)
  802359:	eb 12                	jmp    80236d <initialize_MemBlocksList+0x9a>
  80235b:	a1 50 50 80 00       	mov    0x805050,%eax
  802360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802363:	c1 e2 04             	shl    $0x4,%edx
  802366:	01 d0                	add    %edx,%eax
  802368:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80236d:	a1 50 50 80 00       	mov    0x805050,%eax
  802372:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802375:	c1 e2 04             	shl    $0x4,%edx
  802378:	01 d0                	add    %edx,%eax
  80237a:	a3 48 51 80 00       	mov    %eax,0x805148
  80237f:	a1 50 50 80 00       	mov    0x805050,%eax
  802384:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802387:	c1 e2 04             	shl    $0x4,%edx
  80238a:	01 d0                	add    %edx,%eax
  80238c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802393:	a1 54 51 80 00       	mov    0x805154,%eax
  802398:	40                   	inc    %eax
  802399:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80239e:	ff 45 f4             	incl   -0xc(%ebp)
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a7:	0f 82 56 ff ff ff    	jb     802303 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8023ad:	90                   	nop
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	8b 00                	mov    (%eax),%eax
  8023bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023be:	eb 19                	jmp    8023d9 <find_block+0x29>
	{
		if(va==point->sva)
  8023c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023c3:	8b 40 08             	mov    0x8(%eax),%eax
  8023c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023c9:	75 05                	jne    8023d0 <find_block+0x20>
		   return point;
  8023cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023ce:	eb 36                	jmp    802406 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	8b 40 08             	mov    0x8(%eax),%eax
  8023d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023dd:	74 07                	je     8023e6 <find_block+0x36>
  8023df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023e2:	8b 00                	mov    (%eax),%eax
  8023e4:	eb 05                	jmp    8023eb <find_block+0x3b>
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ee:	89 42 08             	mov    %eax,0x8(%edx)
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	8b 40 08             	mov    0x8(%eax),%eax
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	75 c5                	jne    8023c0 <find_block+0x10>
  8023fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023ff:	75 bf                	jne    8023c0 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802401:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802406:	c9                   	leave  
  802407:	c3                   	ret    

00802408 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
  80240b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80240e:	a1 40 50 80 00       	mov    0x805040,%eax
  802413:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802416:	a1 44 50 80 00       	mov    0x805044,%eax
  80241b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80241e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802421:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802424:	74 24                	je     80244a <insert_sorted_allocList+0x42>
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	8b 50 08             	mov    0x8(%eax),%edx
  80242c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242f:	8b 40 08             	mov    0x8(%eax),%eax
  802432:	39 c2                	cmp    %eax,%edx
  802434:	76 14                	jbe    80244a <insert_sorted_allocList+0x42>
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	8b 50 08             	mov    0x8(%eax),%edx
  80243c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243f:	8b 40 08             	mov    0x8(%eax),%eax
  802442:	39 c2                	cmp    %eax,%edx
  802444:	0f 82 60 01 00 00    	jb     8025aa <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80244a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80244e:	75 65                	jne    8024b5 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802450:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802454:	75 14                	jne    80246a <insert_sorted_allocList+0x62>
  802456:	83 ec 04             	sub    $0x4,%esp
  802459:	68 d8 42 80 00       	push   $0x8042d8
  80245e:	6a 6b                	push   $0x6b
  802460:	68 fb 42 80 00       	push   $0x8042fb
  802465:	e8 77 e2 ff ff       	call   8006e1 <_panic>
  80246a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	89 10                	mov    %edx,(%eax)
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	8b 00                	mov    (%eax),%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	74 0d                	je     80248b <insert_sorted_allocList+0x83>
  80247e:	a1 40 50 80 00       	mov    0x805040,%eax
  802483:	8b 55 08             	mov    0x8(%ebp),%edx
  802486:	89 50 04             	mov    %edx,0x4(%eax)
  802489:	eb 08                	jmp    802493 <insert_sorted_allocList+0x8b>
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	a3 44 50 80 00       	mov    %eax,0x805044
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	a3 40 50 80 00       	mov    %eax,0x805040
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024aa:	40                   	inc    %eax
  8024ab:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024b0:	e9 dc 01 00 00       	jmp    802691 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	8b 50 08             	mov    0x8(%eax),%edx
  8024bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024be:	8b 40 08             	mov    0x8(%eax),%eax
  8024c1:	39 c2                	cmp    %eax,%edx
  8024c3:	77 6c                	ja     802531 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8024c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c9:	74 06                	je     8024d1 <insert_sorted_allocList+0xc9>
  8024cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024cf:	75 14                	jne    8024e5 <insert_sorted_allocList+0xdd>
  8024d1:	83 ec 04             	sub    $0x4,%esp
  8024d4:	68 14 43 80 00       	push   $0x804314
  8024d9:	6a 6f                	push   $0x6f
  8024db:	68 fb 42 80 00       	push   $0x8042fb
  8024e0:	e8 fc e1 ff ff       	call   8006e1 <_panic>
  8024e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e8:	8b 50 04             	mov    0x4(%eax),%edx
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	89 50 04             	mov    %edx,0x4(%eax)
  8024f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f7:	89 10                	mov    %edx,(%eax)
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	8b 40 04             	mov    0x4(%eax),%eax
  8024ff:	85 c0                	test   %eax,%eax
  802501:	74 0d                	je     802510 <insert_sorted_allocList+0x108>
  802503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802506:	8b 40 04             	mov    0x4(%eax),%eax
  802509:	8b 55 08             	mov    0x8(%ebp),%edx
  80250c:	89 10                	mov    %edx,(%eax)
  80250e:	eb 08                	jmp    802518 <insert_sorted_allocList+0x110>
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	a3 40 50 80 00       	mov    %eax,0x805040
  802518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251b:	8b 55 08             	mov    0x8(%ebp),%edx
  80251e:	89 50 04             	mov    %edx,0x4(%eax)
  802521:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802526:	40                   	inc    %eax
  802527:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80252c:	e9 60 01 00 00       	jmp    802691 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	8b 50 08             	mov    0x8(%eax),%edx
  802537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253a:	8b 40 08             	mov    0x8(%eax),%eax
  80253d:	39 c2                	cmp    %eax,%edx
  80253f:	0f 82 4c 01 00 00    	jb     802691 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802545:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802549:	75 14                	jne    80255f <insert_sorted_allocList+0x157>
  80254b:	83 ec 04             	sub    $0x4,%esp
  80254e:	68 4c 43 80 00       	push   $0x80434c
  802553:	6a 73                	push   $0x73
  802555:	68 fb 42 80 00       	push   $0x8042fb
  80255a:	e8 82 e1 ff ff       	call   8006e1 <_panic>
  80255f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802565:	8b 45 08             	mov    0x8(%ebp),%eax
  802568:	89 50 04             	mov    %edx,0x4(%eax)
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	8b 40 04             	mov    0x4(%eax),%eax
  802571:	85 c0                	test   %eax,%eax
  802573:	74 0c                	je     802581 <insert_sorted_allocList+0x179>
  802575:	a1 44 50 80 00       	mov    0x805044,%eax
  80257a:	8b 55 08             	mov    0x8(%ebp),%edx
  80257d:	89 10                	mov    %edx,(%eax)
  80257f:	eb 08                	jmp    802589 <insert_sorted_allocList+0x181>
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	a3 40 50 80 00       	mov    %eax,0x805040
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	a3 44 50 80 00       	mov    %eax,0x805044
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80259f:	40                   	inc    %eax
  8025a0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025a5:	e9 e7 00 00 00       	jmp    802691 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8025aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8025b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025b7:	a1 40 50 80 00       	mov    0x805040,%eax
  8025bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bf:	e9 9d 00 00 00       	jmp    802661 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8025cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cf:	8b 50 08             	mov    0x8(%eax),%edx
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 40 08             	mov    0x8(%eax),%eax
  8025d8:	39 c2                	cmp    %eax,%edx
  8025da:	76 7d                	jbe    802659 <insert_sorted_allocList+0x251>
  8025dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025df:	8b 50 08             	mov    0x8(%eax),%edx
  8025e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025e5:	8b 40 08             	mov    0x8(%eax),%eax
  8025e8:	39 c2                	cmp    %eax,%edx
  8025ea:	73 6d                	jae    802659 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8025ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f0:	74 06                	je     8025f8 <insert_sorted_allocList+0x1f0>
  8025f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025f6:	75 14                	jne    80260c <insert_sorted_allocList+0x204>
  8025f8:	83 ec 04             	sub    $0x4,%esp
  8025fb:	68 70 43 80 00       	push   $0x804370
  802600:	6a 7f                	push   $0x7f
  802602:	68 fb 42 80 00       	push   $0x8042fb
  802607:	e8 d5 e0 ff ff       	call   8006e1 <_panic>
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 10                	mov    (%eax),%edx
  802611:	8b 45 08             	mov    0x8(%ebp),%eax
  802614:	89 10                	mov    %edx,(%eax)
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	8b 00                	mov    (%eax),%eax
  80261b:	85 c0                	test   %eax,%eax
  80261d:	74 0b                	je     80262a <insert_sorted_allocList+0x222>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	8b 55 08             	mov    0x8(%ebp),%edx
  802627:	89 50 04             	mov    %edx,0x4(%eax)
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 55 08             	mov    0x8(%ebp),%edx
  802630:	89 10                	mov    %edx,(%eax)
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802638:	89 50 04             	mov    %edx,0x4(%eax)
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	8b 00                	mov    (%eax),%eax
  802640:	85 c0                	test   %eax,%eax
  802642:	75 08                	jne    80264c <insert_sorted_allocList+0x244>
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	a3 44 50 80 00       	mov    %eax,0x805044
  80264c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802651:	40                   	inc    %eax
  802652:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802657:	eb 39                	jmp    802692 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802659:	a1 48 50 80 00       	mov    0x805048,%eax
  80265e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802665:	74 07                	je     80266e <insert_sorted_allocList+0x266>
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	eb 05                	jmp    802673 <insert_sorted_allocList+0x26b>
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
  802673:	a3 48 50 80 00       	mov    %eax,0x805048
  802678:	a1 48 50 80 00       	mov    0x805048,%eax
  80267d:	85 c0                	test   %eax,%eax
  80267f:	0f 85 3f ff ff ff    	jne    8025c4 <insert_sorted_allocList+0x1bc>
  802685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802689:	0f 85 35 ff ff ff    	jne    8025c4 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80268f:	eb 01                	jmp    802692 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802691:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802692:	90                   	nop
  802693:	c9                   	leave  
  802694:	c3                   	ret    

00802695 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80269b:	a1 38 51 80 00       	mov    0x805138,%eax
  8026a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a3:	e9 85 01 00 00       	jmp    80282d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b1:	0f 82 6e 01 00 00    	jb     802825 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c0:	0f 85 8a 00 00 00    	jne    802750 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8026c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ca:	75 17                	jne    8026e3 <alloc_block_FF+0x4e>
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	68 a4 43 80 00       	push   $0x8043a4
  8026d4:	68 93 00 00 00       	push   $0x93
  8026d9:	68 fb 42 80 00       	push   $0x8042fb
  8026de:	e8 fe df ff ff       	call   8006e1 <_panic>
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 00                	mov    (%eax),%eax
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	74 10                	je     8026fc <alloc_block_FF+0x67>
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f4:	8b 52 04             	mov    0x4(%edx),%edx
  8026f7:	89 50 04             	mov    %edx,0x4(%eax)
  8026fa:	eb 0b                	jmp    802707 <alloc_block_FF+0x72>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 04             	mov    0x4(%eax),%eax
  802702:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 40 04             	mov    0x4(%eax),%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	74 0f                	je     802720 <alloc_block_FF+0x8b>
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 40 04             	mov    0x4(%eax),%eax
  802717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271a:	8b 12                	mov    (%edx),%edx
  80271c:	89 10                	mov    %edx,(%eax)
  80271e:	eb 0a                	jmp    80272a <alloc_block_FF+0x95>
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	a3 38 51 80 00       	mov    %eax,0x805138
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273d:	a1 44 51 80 00       	mov    0x805144,%eax
  802742:	48                   	dec    %eax
  802743:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	e9 10 01 00 00       	jmp    802860 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 0c             	mov    0xc(%eax),%eax
  802756:	3b 45 08             	cmp    0x8(%ebp),%eax
  802759:	0f 86 c6 00 00 00    	jbe    802825 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80275f:	a1 48 51 80 00       	mov    0x805148,%eax
  802764:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 50 08             	mov    0x8(%eax),%edx
  80276d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802770:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802776:	8b 55 08             	mov    0x8(%ebp),%edx
  802779:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80277c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802780:	75 17                	jne    802799 <alloc_block_FF+0x104>
  802782:	83 ec 04             	sub    $0x4,%esp
  802785:	68 a4 43 80 00       	push   $0x8043a4
  80278a:	68 9b 00 00 00       	push   $0x9b
  80278f:	68 fb 42 80 00       	push   $0x8042fb
  802794:	e8 48 df ff ff       	call   8006e1 <_panic>
  802799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	74 10                	je     8027b2 <alloc_block_FF+0x11d>
  8027a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a5:	8b 00                	mov    (%eax),%eax
  8027a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027aa:	8b 52 04             	mov    0x4(%edx),%edx
  8027ad:	89 50 04             	mov    %edx,0x4(%eax)
  8027b0:	eb 0b                	jmp    8027bd <alloc_block_FF+0x128>
  8027b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b5:	8b 40 04             	mov    0x4(%eax),%eax
  8027b8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c0:	8b 40 04             	mov    0x4(%eax),%eax
  8027c3:	85 c0                	test   %eax,%eax
  8027c5:	74 0f                	je     8027d6 <alloc_block_FF+0x141>
  8027c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ca:	8b 40 04             	mov    0x4(%eax),%eax
  8027cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d0:	8b 12                	mov    (%edx),%edx
  8027d2:	89 10                	mov    %edx,(%eax)
  8027d4:	eb 0a                	jmp    8027e0 <alloc_block_FF+0x14b>
  8027d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d9:	8b 00                	mov    (%eax),%eax
  8027db:	a3 48 51 80 00       	mov    %eax,0x805148
  8027e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f3:	a1 54 51 80 00       	mov    0x805154,%eax
  8027f8:	48                   	dec    %eax
  8027f9:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 50 08             	mov    0x8(%eax),%edx
  802804:	8b 45 08             	mov    0x8(%ebp),%eax
  802807:	01 c2                	add    %eax,%edx
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 40 0c             	mov    0xc(%eax),%eax
  802815:	2b 45 08             	sub    0x8(%ebp),%eax
  802818:	89 c2                	mov    %eax,%edx
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802823:	eb 3b                	jmp    802860 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802825:	a1 40 51 80 00       	mov    0x805140,%eax
  80282a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802831:	74 07                	je     80283a <alloc_block_FF+0x1a5>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	eb 05                	jmp    80283f <alloc_block_FF+0x1aa>
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	a3 40 51 80 00       	mov    %eax,0x805140
  802844:	a1 40 51 80 00       	mov    0x805140,%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	0f 85 57 fe ff ff    	jne    8026a8 <alloc_block_FF+0x13>
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	0f 85 4d fe ff ff    	jne    8026a8 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80285b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802860:	c9                   	leave  
  802861:	c3                   	ret    

00802862 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
  802865:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802868:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80286f:	a1 38 51 80 00       	mov    0x805138,%eax
  802874:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802877:	e9 df 00 00 00       	jmp    80295b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 40 0c             	mov    0xc(%eax),%eax
  802882:	3b 45 08             	cmp    0x8(%ebp),%eax
  802885:	0f 82 c8 00 00 00    	jb     802953 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 40 0c             	mov    0xc(%eax),%eax
  802891:	3b 45 08             	cmp    0x8(%ebp),%eax
  802894:	0f 85 8a 00 00 00    	jne    802924 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80289a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289e:	75 17                	jne    8028b7 <alloc_block_BF+0x55>
  8028a0:	83 ec 04             	sub    $0x4,%esp
  8028a3:	68 a4 43 80 00       	push   $0x8043a4
  8028a8:	68 b7 00 00 00       	push   $0xb7
  8028ad:	68 fb 42 80 00       	push   $0x8042fb
  8028b2:	e8 2a de ff ff       	call   8006e1 <_panic>
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 00                	mov    (%eax),%eax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	74 10                	je     8028d0 <alloc_block_BF+0x6e>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c8:	8b 52 04             	mov    0x4(%edx),%edx
  8028cb:	89 50 04             	mov    %edx,0x4(%eax)
  8028ce:	eb 0b                	jmp    8028db <alloc_block_BF+0x79>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 40 04             	mov    0x4(%eax),%eax
  8028d6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 40 04             	mov    0x4(%eax),%eax
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	74 0f                	je     8028f4 <alloc_block_BF+0x92>
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 40 04             	mov    0x4(%eax),%eax
  8028eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ee:	8b 12                	mov    (%edx),%edx
  8028f0:	89 10                	mov    %edx,(%eax)
  8028f2:	eb 0a                	jmp    8028fe <alloc_block_BF+0x9c>
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	a3 38 51 80 00       	mov    %eax,0x805138
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802911:	a1 44 51 80 00       	mov    0x805144,%eax
  802916:	48                   	dec    %eax
  802917:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	e9 4d 01 00 00       	jmp    802a71 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 40 0c             	mov    0xc(%eax),%eax
  80292a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292d:	76 24                	jbe    802953 <alloc_block_BF+0xf1>
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	8b 40 0c             	mov    0xc(%eax),%eax
  802935:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802938:	73 19                	jae    802953 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80293a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 40 0c             	mov    0xc(%eax),%eax
  802947:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 40 08             	mov    0x8(%eax),%eax
  802950:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802953:	a1 40 51 80 00       	mov    0x805140,%eax
  802958:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295f:	74 07                	je     802968 <alloc_block_BF+0x106>
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	8b 00                	mov    (%eax),%eax
  802966:	eb 05                	jmp    80296d <alloc_block_BF+0x10b>
  802968:	b8 00 00 00 00       	mov    $0x0,%eax
  80296d:	a3 40 51 80 00       	mov    %eax,0x805140
  802972:	a1 40 51 80 00       	mov    0x805140,%eax
  802977:	85 c0                	test   %eax,%eax
  802979:	0f 85 fd fe ff ff    	jne    80287c <alloc_block_BF+0x1a>
  80297f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802983:	0f 85 f3 fe ff ff    	jne    80287c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802989:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80298d:	0f 84 d9 00 00 00    	je     802a6c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802993:	a1 48 51 80 00       	mov    0x805148,%eax
  802998:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80299b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029a1:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8029a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029aa:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8029ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029b1:	75 17                	jne    8029ca <alloc_block_BF+0x168>
  8029b3:	83 ec 04             	sub    $0x4,%esp
  8029b6:	68 a4 43 80 00       	push   $0x8043a4
  8029bb:	68 c7 00 00 00       	push   $0xc7
  8029c0:	68 fb 42 80 00       	push   $0x8042fb
  8029c5:	e8 17 dd ff ff       	call   8006e1 <_panic>
  8029ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	74 10                	je     8029e3 <alloc_block_BF+0x181>
  8029d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d6:	8b 00                	mov    (%eax),%eax
  8029d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029db:	8b 52 04             	mov    0x4(%edx),%edx
  8029de:	89 50 04             	mov    %edx,0x4(%eax)
  8029e1:	eb 0b                	jmp    8029ee <alloc_block_BF+0x18c>
  8029e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e6:	8b 40 04             	mov    0x4(%eax),%eax
  8029e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f1:	8b 40 04             	mov    0x4(%eax),%eax
  8029f4:	85 c0                	test   %eax,%eax
  8029f6:	74 0f                	je     802a07 <alloc_block_BF+0x1a5>
  8029f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029fb:	8b 40 04             	mov    0x4(%eax),%eax
  8029fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a01:	8b 12                	mov    (%edx),%edx
  802a03:	89 10                	mov    %edx,(%eax)
  802a05:	eb 0a                	jmp    802a11 <alloc_block_BF+0x1af>
  802a07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a0a:	8b 00                	mov    (%eax),%eax
  802a0c:	a3 48 51 80 00       	mov    %eax,0x805148
  802a11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a24:	a1 54 51 80 00       	mov    0x805154,%eax
  802a29:	48                   	dec    %eax
  802a2a:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a2f:	83 ec 08             	sub    $0x8,%esp
  802a32:	ff 75 ec             	pushl  -0x14(%ebp)
  802a35:	68 38 51 80 00       	push   $0x805138
  802a3a:	e8 71 f9 ff ff       	call   8023b0 <find_block>
  802a3f:	83 c4 10             	add    $0x10,%esp
  802a42:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a48:	8b 50 08             	mov    0x8(%eax),%edx
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	01 c2                	add    %eax,%edx
  802a50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a53:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a59:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5c:	2b 45 08             	sub    0x8(%ebp),%eax
  802a5f:	89 c2                	mov    %eax,%edx
  802a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a64:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6a:	eb 05                	jmp    802a71 <alloc_block_BF+0x20f>
	}
	return NULL;
  802a6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a71:	c9                   	leave  
  802a72:	c3                   	ret    

00802a73 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a73:	55                   	push   %ebp
  802a74:	89 e5                	mov    %esp,%ebp
  802a76:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802a79:	a1 28 50 80 00       	mov    0x805028,%eax
  802a7e:	85 c0                	test   %eax,%eax
  802a80:	0f 85 de 01 00 00    	jne    802c64 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a86:	a1 38 51 80 00       	mov    0x805138,%eax
  802a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8e:	e9 9e 01 00 00       	jmp    802c31 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	8b 40 0c             	mov    0xc(%eax),%eax
  802a99:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a9c:	0f 82 87 01 00 00    	jb     802c29 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aab:	0f 85 95 00 00 00    	jne    802b46 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802ab1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab5:	75 17                	jne    802ace <alloc_block_NF+0x5b>
  802ab7:	83 ec 04             	sub    $0x4,%esp
  802aba:	68 a4 43 80 00       	push   $0x8043a4
  802abf:	68 e0 00 00 00       	push   $0xe0
  802ac4:	68 fb 42 80 00       	push   $0x8042fb
  802ac9:	e8 13 dc ff ff       	call   8006e1 <_panic>
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	8b 00                	mov    (%eax),%eax
  802ad3:	85 c0                	test   %eax,%eax
  802ad5:	74 10                	je     802ae7 <alloc_block_NF+0x74>
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 00                	mov    (%eax),%eax
  802adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adf:	8b 52 04             	mov    0x4(%edx),%edx
  802ae2:	89 50 04             	mov    %edx,0x4(%eax)
  802ae5:	eb 0b                	jmp    802af2 <alloc_block_NF+0x7f>
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	8b 40 04             	mov    0x4(%eax),%eax
  802aed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	8b 40 04             	mov    0x4(%eax),%eax
  802af8:	85 c0                	test   %eax,%eax
  802afa:	74 0f                	je     802b0b <alloc_block_NF+0x98>
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 40 04             	mov    0x4(%eax),%eax
  802b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b05:	8b 12                	mov    (%edx),%edx
  802b07:	89 10                	mov    %edx,(%eax)
  802b09:	eb 0a                	jmp    802b15 <alloc_block_NF+0xa2>
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	a3 38 51 80 00       	mov    %eax,0x805138
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b28:	a1 44 51 80 00       	mov    0x805144,%eax
  802b2d:	48                   	dec    %eax
  802b2e:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 40 08             	mov    0x8(%eax),%eax
  802b39:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	e9 f8 04 00 00       	jmp    80303e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b4f:	0f 86 d4 00 00 00    	jbe    802c29 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b55:	a1 48 51 80 00       	mov    0x805148,%eax
  802b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b60:	8b 50 08             	mov    0x8(%eax),%edx
  802b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b66:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b76:	75 17                	jne    802b8f <alloc_block_NF+0x11c>
  802b78:	83 ec 04             	sub    $0x4,%esp
  802b7b:	68 a4 43 80 00       	push   $0x8043a4
  802b80:	68 e9 00 00 00       	push   $0xe9
  802b85:	68 fb 42 80 00       	push   $0x8042fb
  802b8a:	e8 52 db ff ff       	call   8006e1 <_panic>
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	8b 00                	mov    (%eax),%eax
  802b94:	85 c0                	test   %eax,%eax
  802b96:	74 10                	je     802ba8 <alloc_block_NF+0x135>
  802b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9b:	8b 00                	mov    (%eax),%eax
  802b9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba0:	8b 52 04             	mov    0x4(%edx),%edx
  802ba3:	89 50 04             	mov    %edx,0x4(%eax)
  802ba6:	eb 0b                	jmp    802bb3 <alloc_block_NF+0x140>
  802ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bab:	8b 40 04             	mov    0x4(%eax),%eax
  802bae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb6:	8b 40 04             	mov    0x4(%eax),%eax
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	74 0f                	je     802bcc <alloc_block_NF+0x159>
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	8b 40 04             	mov    0x4(%eax),%eax
  802bc3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc6:	8b 12                	mov    (%edx),%edx
  802bc8:	89 10                	mov    %edx,(%eax)
  802bca:	eb 0a                	jmp    802bd6 <alloc_block_NF+0x163>
  802bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	a3 48 51 80 00       	mov    %eax,0x805148
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be9:	a1 54 51 80 00       	mov    0x805154,%eax
  802bee:	48                   	dec    %eax
  802bef:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf7:	8b 40 08             	mov    0x8(%eax),%eax
  802bfa:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 50 08             	mov    0x8(%eax),%edx
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	01 c2                	add    %eax,%edx
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 40 0c             	mov    0xc(%eax),%eax
  802c16:	2b 45 08             	sub    0x8(%ebp),%eax
  802c19:	89 c2                	mov    %eax,%edx
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c24:	e9 15 04 00 00       	jmp    80303e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c29:	a1 40 51 80 00       	mov    0x805140,%eax
  802c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c35:	74 07                	je     802c3e <alloc_block_NF+0x1cb>
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 00                	mov    (%eax),%eax
  802c3c:	eb 05                	jmp    802c43 <alloc_block_NF+0x1d0>
  802c3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c43:	a3 40 51 80 00       	mov    %eax,0x805140
  802c48:	a1 40 51 80 00       	mov    0x805140,%eax
  802c4d:	85 c0                	test   %eax,%eax
  802c4f:	0f 85 3e fe ff ff    	jne    802a93 <alloc_block_NF+0x20>
  802c55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c59:	0f 85 34 fe ff ff    	jne    802a93 <alloc_block_NF+0x20>
  802c5f:	e9 d5 03 00 00       	jmp    803039 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c64:	a1 38 51 80 00       	mov    0x805138,%eax
  802c69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6c:	e9 b1 01 00 00       	jmp    802e22 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	8b 50 08             	mov    0x8(%eax),%edx
  802c77:	a1 28 50 80 00       	mov    0x805028,%eax
  802c7c:	39 c2                	cmp    %eax,%edx
  802c7e:	0f 82 96 01 00 00    	jb     802e1a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c8d:	0f 82 87 01 00 00    	jb     802e1a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 40 0c             	mov    0xc(%eax),%eax
  802c99:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c9c:	0f 85 95 00 00 00    	jne    802d37 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ca2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca6:	75 17                	jne    802cbf <alloc_block_NF+0x24c>
  802ca8:	83 ec 04             	sub    $0x4,%esp
  802cab:	68 a4 43 80 00       	push   $0x8043a4
  802cb0:	68 fc 00 00 00       	push   $0xfc
  802cb5:	68 fb 42 80 00       	push   $0x8042fb
  802cba:	e8 22 da ff ff       	call   8006e1 <_panic>
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	85 c0                	test   %eax,%eax
  802cc6:	74 10                	je     802cd8 <alloc_block_NF+0x265>
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd0:	8b 52 04             	mov    0x4(%edx),%edx
  802cd3:	89 50 04             	mov    %edx,0x4(%eax)
  802cd6:	eb 0b                	jmp    802ce3 <alloc_block_NF+0x270>
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8b 40 04             	mov    0x4(%eax),%eax
  802cde:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 04             	mov    0x4(%eax),%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	74 0f                	je     802cfc <alloc_block_NF+0x289>
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf6:	8b 12                	mov    (%edx),%edx
  802cf8:	89 10                	mov    %edx,(%eax)
  802cfa:	eb 0a                	jmp    802d06 <alloc_block_NF+0x293>
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 00                	mov    (%eax),%eax
  802d01:	a3 38 51 80 00       	mov    %eax,0x805138
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d19:	a1 44 51 80 00       	mov    0x805144,%eax
  802d1e:	48                   	dec    %eax
  802d1f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 40 08             	mov    0x8(%eax),%eax
  802d2a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	e9 07 03 00 00       	jmp    80303e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d40:	0f 86 d4 00 00 00    	jbe    802e1a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d46:	a1 48 51 80 00       	mov    0x805148,%eax
  802d4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	8b 50 08             	mov    0x8(%eax),%edx
  802d54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d57:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d60:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d63:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d67:	75 17                	jne    802d80 <alloc_block_NF+0x30d>
  802d69:	83 ec 04             	sub    $0x4,%esp
  802d6c:	68 a4 43 80 00       	push   $0x8043a4
  802d71:	68 04 01 00 00       	push   $0x104
  802d76:	68 fb 42 80 00       	push   $0x8042fb
  802d7b:	e8 61 d9 ff ff       	call   8006e1 <_panic>
  802d80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d83:	8b 00                	mov    (%eax),%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	74 10                	je     802d99 <alloc_block_NF+0x326>
  802d89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d91:	8b 52 04             	mov    0x4(%edx),%edx
  802d94:	89 50 04             	mov    %edx,0x4(%eax)
  802d97:	eb 0b                	jmp    802da4 <alloc_block_NF+0x331>
  802d99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9c:	8b 40 04             	mov    0x4(%eax),%eax
  802d9f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802da4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da7:	8b 40 04             	mov    0x4(%eax),%eax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	74 0f                	je     802dbd <alloc_block_NF+0x34a>
  802dae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db1:	8b 40 04             	mov    0x4(%eax),%eax
  802db4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802db7:	8b 12                	mov    (%edx),%edx
  802db9:	89 10                	mov    %edx,(%eax)
  802dbb:	eb 0a                	jmp    802dc7 <alloc_block_NF+0x354>
  802dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc0:	8b 00                	mov    (%eax),%eax
  802dc2:	a3 48 51 80 00       	mov    %eax,0x805148
  802dc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dda:	a1 54 51 80 00       	mov    0x805154,%eax
  802ddf:	48                   	dec    %eax
  802de0:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802de5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de8:	8b 40 08             	mov    0x8(%eax),%eax
  802deb:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 50 08             	mov    0x8(%eax),%edx
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	01 c2                	add    %eax,%edx
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	8b 40 0c             	mov    0xc(%eax),%eax
  802e07:	2b 45 08             	sub    0x8(%ebp),%eax
  802e0a:	89 c2                	mov    %eax,%edx
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e15:	e9 24 02 00 00       	jmp    80303e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e1a:	a1 40 51 80 00       	mov    0x805140,%eax
  802e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e26:	74 07                	je     802e2f <alloc_block_NF+0x3bc>
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	8b 00                	mov    (%eax),%eax
  802e2d:	eb 05                	jmp    802e34 <alloc_block_NF+0x3c1>
  802e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e34:	a3 40 51 80 00       	mov    %eax,0x805140
  802e39:	a1 40 51 80 00       	mov    0x805140,%eax
  802e3e:	85 c0                	test   %eax,%eax
  802e40:	0f 85 2b fe ff ff    	jne    802c71 <alloc_block_NF+0x1fe>
  802e46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4a:	0f 85 21 fe ff ff    	jne    802c71 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e50:	a1 38 51 80 00       	mov    0x805138,%eax
  802e55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e58:	e9 ae 01 00 00       	jmp    80300b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 50 08             	mov    0x8(%eax),%edx
  802e63:	a1 28 50 80 00       	mov    0x805028,%eax
  802e68:	39 c2                	cmp    %eax,%edx
  802e6a:	0f 83 93 01 00 00    	jae    803003 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 40 0c             	mov    0xc(%eax),%eax
  802e76:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e79:	0f 82 84 01 00 00    	jb     803003 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 40 0c             	mov    0xc(%eax),%eax
  802e85:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e88:	0f 85 95 00 00 00    	jne    802f23 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e92:	75 17                	jne    802eab <alloc_block_NF+0x438>
  802e94:	83 ec 04             	sub    $0x4,%esp
  802e97:	68 a4 43 80 00       	push   $0x8043a4
  802e9c:	68 14 01 00 00       	push   $0x114
  802ea1:	68 fb 42 80 00       	push   $0x8042fb
  802ea6:	e8 36 d8 ff ff       	call   8006e1 <_panic>
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 00                	mov    (%eax),%eax
  802eb0:	85 c0                	test   %eax,%eax
  802eb2:	74 10                	je     802ec4 <alloc_block_NF+0x451>
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	8b 00                	mov    (%eax),%eax
  802eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebc:	8b 52 04             	mov    0x4(%edx),%edx
  802ebf:	89 50 04             	mov    %edx,0x4(%eax)
  802ec2:	eb 0b                	jmp    802ecf <alloc_block_NF+0x45c>
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	8b 40 04             	mov    0x4(%eax),%eax
  802eca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	8b 40 04             	mov    0x4(%eax),%eax
  802ed5:	85 c0                	test   %eax,%eax
  802ed7:	74 0f                	je     802ee8 <alloc_block_NF+0x475>
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 40 04             	mov    0x4(%eax),%eax
  802edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee2:	8b 12                	mov    (%edx),%edx
  802ee4:	89 10                	mov    %edx,(%eax)
  802ee6:	eb 0a                	jmp    802ef2 <alloc_block_NF+0x47f>
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 00                	mov    (%eax),%eax
  802eed:	a3 38 51 80 00       	mov    %eax,0x805138
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f05:	a1 44 51 80 00       	mov    0x805144,%eax
  802f0a:	48                   	dec    %eax
  802f0b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	8b 40 08             	mov    0x8(%eax),%eax
  802f16:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	e9 1b 01 00 00       	jmp    80303e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 40 0c             	mov    0xc(%eax),%eax
  802f29:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f2c:	0f 86 d1 00 00 00    	jbe    803003 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f32:	a1 48 51 80 00       	mov    0x805148,%eax
  802f37:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	8b 50 08             	mov    0x8(%eax),%edx
  802f40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f43:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f49:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f53:	75 17                	jne    802f6c <alloc_block_NF+0x4f9>
  802f55:	83 ec 04             	sub    $0x4,%esp
  802f58:	68 a4 43 80 00       	push   $0x8043a4
  802f5d:	68 1c 01 00 00       	push   $0x11c
  802f62:	68 fb 42 80 00       	push   $0x8042fb
  802f67:	e8 75 d7 ff ff       	call   8006e1 <_panic>
  802f6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6f:	8b 00                	mov    (%eax),%eax
  802f71:	85 c0                	test   %eax,%eax
  802f73:	74 10                	je     802f85 <alloc_block_NF+0x512>
  802f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f78:	8b 00                	mov    (%eax),%eax
  802f7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f7d:	8b 52 04             	mov    0x4(%edx),%edx
  802f80:	89 50 04             	mov    %edx,0x4(%eax)
  802f83:	eb 0b                	jmp    802f90 <alloc_block_NF+0x51d>
  802f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f88:	8b 40 04             	mov    0x4(%eax),%eax
  802f8b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f93:	8b 40 04             	mov    0x4(%eax),%eax
  802f96:	85 c0                	test   %eax,%eax
  802f98:	74 0f                	je     802fa9 <alloc_block_NF+0x536>
  802f9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9d:	8b 40 04             	mov    0x4(%eax),%eax
  802fa0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fa3:	8b 12                	mov    (%edx),%edx
  802fa5:	89 10                	mov    %edx,(%eax)
  802fa7:	eb 0a                	jmp    802fb3 <alloc_block_NF+0x540>
  802fa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	a3 48 51 80 00       	mov    %eax,0x805148
  802fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc6:	a1 54 51 80 00       	mov    0x805154,%eax
  802fcb:	48                   	dec    %eax
  802fcc:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd4:	8b 40 08             	mov    0x8(%eax),%eax
  802fd7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdf:	8b 50 08             	mov    0x8(%eax),%edx
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	01 c2                	add    %eax,%edx
  802fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fea:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff3:	2b 45 08             	sub    0x8(%ebp),%eax
  802ff6:	89 c2                	mov    %eax,%edx
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803001:	eb 3b                	jmp    80303e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803003:	a1 40 51 80 00       	mov    0x805140,%eax
  803008:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300f:	74 07                	je     803018 <alloc_block_NF+0x5a5>
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 00                	mov    (%eax),%eax
  803016:	eb 05                	jmp    80301d <alloc_block_NF+0x5aa>
  803018:	b8 00 00 00 00       	mov    $0x0,%eax
  80301d:	a3 40 51 80 00       	mov    %eax,0x805140
  803022:	a1 40 51 80 00       	mov    0x805140,%eax
  803027:	85 c0                	test   %eax,%eax
  803029:	0f 85 2e fe ff ff    	jne    802e5d <alloc_block_NF+0x3ea>
  80302f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803033:	0f 85 24 fe ff ff    	jne    802e5d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803039:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80303e:	c9                   	leave  
  80303f:	c3                   	ret    

00803040 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803040:	55                   	push   %ebp
  803041:	89 e5                	mov    %esp,%ebp
  803043:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803046:	a1 38 51 80 00       	mov    0x805138,%eax
  80304b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80304e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803053:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803056:	a1 38 51 80 00       	mov    0x805138,%eax
  80305b:	85 c0                	test   %eax,%eax
  80305d:	74 14                	je     803073 <insert_sorted_with_merge_freeList+0x33>
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	8b 50 08             	mov    0x8(%eax),%edx
  803065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803068:	8b 40 08             	mov    0x8(%eax),%eax
  80306b:	39 c2                	cmp    %eax,%edx
  80306d:	0f 87 9b 01 00 00    	ja     80320e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803073:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803077:	75 17                	jne    803090 <insert_sorted_with_merge_freeList+0x50>
  803079:	83 ec 04             	sub    $0x4,%esp
  80307c:	68 d8 42 80 00       	push   $0x8042d8
  803081:	68 38 01 00 00       	push   $0x138
  803086:	68 fb 42 80 00       	push   $0x8042fb
  80308b:	e8 51 d6 ff ff       	call   8006e1 <_panic>
  803090:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	89 10                	mov    %edx,(%eax)
  80309b:	8b 45 08             	mov    0x8(%ebp),%eax
  80309e:	8b 00                	mov    (%eax),%eax
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	74 0d                	je     8030b1 <insert_sorted_with_merge_freeList+0x71>
  8030a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ac:	89 50 04             	mov    %edx,0x4(%eax)
  8030af:	eb 08                	jmp    8030b9 <insert_sorted_with_merge_freeList+0x79>
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	a3 38 51 80 00       	mov    %eax,0x805138
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d0:	40                   	inc    %eax
  8030d1:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030da:	0f 84 a8 06 00 00    	je     803788 <insert_sorted_with_merge_freeList+0x748>
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	8b 50 08             	mov    0x8(%eax),%edx
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ec:	01 c2                	add    %eax,%edx
  8030ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f1:	8b 40 08             	mov    0x8(%eax),%eax
  8030f4:	39 c2                	cmp    %eax,%edx
  8030f6:	0f 85 8c 06 00 00    	jne    803788 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	8b 50 0c             	mov    0xc(%eax),%edx
  803102:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803105:	8b 40 0c             	mov    0xc(%eax),%eax
  803108:	01 c2                	add    %eax,%edx
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803110:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803114:	75 17                	jne    80312d <insert_sorted_with_merge_freeList+0xed>
  803116:	83 ec 04             	sub    $0x4,%esp
  803119:	68 a4 43 80 00       	push   $0x8043a4
  80311e:	68 3c 01 00 00       	push   $0x13c
  803123:	68 fb 42 80 00       	push   $0x8042fb
  803128:	e8 b4 d5 ff ff       	call   8006e1 <_panic>
  80312d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803130:	8b 00                	mov    (%eax),%eax
  803132:	85 c0                	test   %eax,%eax
  803134:	74 10                	je     803146 <insert_sorted_with_merge_freeList+0x106>
  803136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803139:	8b 00                	mov    (%eax),%eax
  80313b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80313e:	8b 52 04             	mov    0x4(%edx),%edx
  803141:	89 50 04             	mov    %edx,0x4(%eax)
  803144:	eb 0b                	jmp    803151 <insert_sorted_with_merge_freeList+0x111>
  803146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803149:	8b 40 04             	mov    0x4(%eax),%eax
  80314c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803154:	8b 40 04             	mov    0x4(%eax),%eax
  803157:	85 c0                	test   %eax,%eax
  803159:	74 0f                	je     80316a <insert_sorted_with_merge_freeList+0x12a>
  80315b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315e:	8b 40 04             	mov    0x4(%eax),%eax
  803161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803164:	8b 12                	mov    (%edx),%edx
  803166:	89 10                	mov    %edx,(%eax)
  803168:	eb 0a                	jmp    803174 <insert_sorted_with_merge_freeList+0x134>
  80316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	a3 38 51 80 00       	mov    %eax,0x805138
  803174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803177:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80317d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803180:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803187:	a1 44 51 80 00       	mov    0x805144,%eax
  80318c:	48                   	dec    %eax
  80318d:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803195:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80319c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8031a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031aa:	75 17                	jne    8031c3 <insert_sorted_with_merge_freeList+0x183>
  8031ac:	83 ec 04             	sub    $0x4,%esp
  8031af:	68 d8 42 80 00       	push   $0x8042d8
  8031b4:	68 3f 01 00 00       	push   $0x13f
  8031b9:	68 fb 42 80 00       	push   $0x8042fb
  8031be:	e8 1e d5 ff ff       	call   8006e1 <_panic>
  8031c3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cc:	89 10                	mov    %edx,(%eax)
  8031ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 0d                	je     8031e4 <insert_sorted_with_merge_freeList+0x1a4>
  8031d7:	a1 48 51 80 00       	mov    0x805148,%eax
  8031dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031df:	89 50 04             	mov    %edx,0x4(%eax)
  8031e2:	eb 08                	jmp    8031ec <insert_sorted_with_merge_freeList+0x1ac>
  8031e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ef:	a3 48 51 80 00       	mov    %eax,0x805148
  8031f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fe:	a1 54 51 80 00       	mov    0x805154,%eax
  803203:	40                   	inc    %eax
  803204:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803209:	e9 7a 05 00 00       	jmp    803788 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	8b 50 08             	mov    0x8(%eax),%edx
  803214:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803217:	8b 40 08             	mov    0x8(%eax),%eax
  80321a:	39 c2                	cmp    %eax,%edx
  80321c:	0f 82 14 01 00 00    	jb     803336 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803225:	8b 50 08             	mov    0x8(%eax),%edx
  803228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322b:	8b 40 0c             	mov    0xc(%eax),%eax
  80322e:	01 c2                	add    %eax,%edx
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 40 08             	mov    0x8(%eax),%eax
  803236:	39 c2                	cmp    %eax,%edx
  803238:	0f 85 90 00 00 00    	jne    8032ce <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80323e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803241:	8b 50 0c             	mov    0xc(%eax),%edx
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	8b 40 0c             	mov    0xc(%eax),%eax
  80324a:	01 c2                	add    %eax,%edx
  80324c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324f:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803266:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80326a:	75 17                	jne    803283 <insert_sorted_with_merge_freeList+0x243>
  80326c:	83 ec 04             	sub    $0x4,%esp
  80326f:	68 d8 42 80 00       	push   $0x8042d8
  803274:	68 49 01 00 00       	push   $0x149
  803279:	68 fb 42 80 00       	push   $0x8042fb
  80327e:	e8 5e d4 ff ff       	call   8006e1 <_panic>
  803283:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	89 10                	mov    %edx,(%eax)
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	85 c0                	test   %eax,%eax
  803295:	74 0d                	je     8032a4 <insert_sorted_with_merge_freeList+0x264>
  803297:	a1 48 51 80 00       	mov    0x805148,%eax
  80329c:	8b 55 08             	mov    0x8(%ebp),%edx
  80329f:	89 50 04             	mov    %edx,0x4(%eax)
  8032a2:	eb 08                	jmp    8032ac <insert_sorted_with_merge_freeList+0x26c>
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	a3 48 51 80 00       	mov    %eax,0x805148
  8032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032be:	a1 54 51 80 00       	mov    0x805154,%eax
  8032c3:	40                   	inc    %eax
  8032c4:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032c9:	e9 bb 04 00 00       	jmp    803789 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d2:	75 17                	jne    8032eb <insert_sorted_with_merge_freeList+0x2ab>
  8032d4:	83 ec 04             	sub    $0x4,%esp
  8032d7:	68 4c 43 80 00       	push   $0x80434c
  8032dc:	68 4c 01 00 00       	push   $0x14c
  8032e1:	68 fb 42 80 00       	push   $0x8042fb
  8032e6:	e8 f6 d3 ff ff       	call   8006e1 <_panic>
  8032eb:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	89 50 04             	mov    %edx,0x4(%eax)
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	8b 40 04             	mov    0x4(%eax),%eax
  8032fd:	85 c0                	test   %eax,%eax
  8032ff:	74 0c                	je     80330d <insert_sorted_with_merge_freeList+0x2cd>
  803301:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803306:	8b 55 08             	mov    0x8(%ebp),%edx
  803309:	89 10                	mov    %edx,(%eax)
  80330b:	eb 08                	jmp    803315 <insert_sorted_with_merge_freeList+0x2d5>
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	a3 38 51 80 00       	mov    %eax,0x805138
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803326:	a1 44 51 80 00       	mov    0x805144,%eax
  80332b:	40                   	inc    %eax
  80332c:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803331:	e9 53 04 00 00       	jmp    803789 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803336:	a1 38 51 80 00       	mov    0x805138,%eax
  80333b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80333e:	e9 15 04 00 00       	jmp    803758 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803346:	8b 00                	mov    (%eax),%eax
  803348:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	8b 50 08             	mov    0x8(%eax),%edx
  803351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803354:	8b 40 08             	mov    0x8(%eax),%eax
  803357:	39 c2                	cmp    %eax,%edx
  803359:	0f 86 f1 03 00 00    	jbe    803750 <insert_sorted_with_merge_freeList+0x710>
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	8b 50 08             	mov    0x8(%eax),%edx
  803365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803368:	8b 40 08             	mov    0x8(%eax),%eax
  80336b:	39 c2                	cmp    %eax,%edx
  80336d:	0f 83 dd 03 00 00    	jae    803750 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	8b 50 08             	mov    0x8(%eax),%edx
  803379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337c:	8b 40 0c             	mov    0xc(%eax),%eax
  80337f:	01 c2                	add    %eax,%edx
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	8b 40 08             	mov    0x8(%eax),%eax
  803387:	39 c2                	cmp    %eax,%edx
  803389:	0f 85 b9 01 00 00    	jne    803548 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	8b 50 08             	mov    0x8(%eax),%edx
  803395:	8b 45 08             	mov    0x8(%ebp),%eax
  803398:	8b 40 0c             	mov    0xc(%eax),%eax
  80339b:	01 c2                	add    %eax,%edx
  80339d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a0:	8b 40 08             	mov    0x8(%eax),%eax
  8033a3:	39 c2                	cmp    %eax,%edx
  8033a5:	0f 85 0d 01 00 00    	jne    8034b8 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8033ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ae:	8b 50 0c             	mov    0xc(%eax),%edx
  8033b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b7:	01 c2                	add    %eax,%edx
  8033b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bc:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c3:	75 17                	jne    8033dc <insert_sorted_with_merge_freeList+0x39c>
  8033c5:	83 ec 04             	sub    $0x4,%esp
  8033c8:	68 a4 43 80 00       	push   $0x8043a4
  8033cd:	68 5c 01 00 00       	push   $0x15c
  8033d2:	68 fb 42 80 00       	push   $0x8042fb
  8033d7:	e8 05 d3 ff ff       	call   8006e1 <_panic>
  8033dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033df:	8b 00                	mov    (%eax),%eax
  8033e1:	85 c0                	test   %eax,%eax
  8033e3:	74 10                	je     8033f5 <insert_sorted_with_merge_freeList+0x3b5>
  8033e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e8:	8b 00                	mov    (%eax),%eax
  8033ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ed:	8b 52 04             	mov    0x4(%edx),%edx
  8033f0:	89 50 04             	mov    %edx,0x4(%eax)
  8033f3:	eb 0b                	jmp    803400 <insert_sorted_with_merge_freeList+0x3c0>
  8033f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f8:	8b 40 04             	mov    0x4(%eax),%eax
  8033fb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803400:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803403:	8b 40 04             	mov    0x4(%eax),%eax
  803406:	85 c0                	test   %eax,%eax
  803408:	74 0f                	je     803419 <insert_sorted_with_merge_freeList+0x3d9>
  80340a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340d:	8b 40 04             	mov    0x4(%eax),%eax
  803410:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803413:	8b 12                	mov    (%edx),%edx
  803415:	89 10                	mov    %edx,(%eax)
  803417:	eb 0a                	jmp    803423 <insert_sorted_with_merge_freeList+0x3e3>
  803419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	a3 38 51 80 00       	mov    %eax,0x805138
  803423:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803426:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80342c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803436:	a1 44 51 80 00       	mov    0x805144,%eax
  80343b:	48                   	dec    %eax
  80343c:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803441:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803444:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80344b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803455:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803459:	75 17                	jne    803472 <insert_sorted_with_merge_freeList+0x432>
  80345b:	83 ec 04             	sub    $0x4,%esp
  80345e:	68 d8 42 80 00       	push   $0x8042d8
  803463:	68 5f 01 00 00       	push   $0x15f
  803468:	68 fb 42 80 00       	push   $0x8042fb
  80346d:	e8 6f d2 ff ff       	call   8006e1 <_panic>
  803472:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803478:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347b:	89 10                	mov    %edx,(%eax)
  80347d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803480:	8b 00                	mov    (%eax),%eax
  803482:	85 c0                	test   %eax,%eax
  803484:	74 0d                	je     803493 <insert_sorted_with_merge_freeList+0x453>
  803486:	a1 48 51 80 00       	mov    0x805148,%eax
  80348b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80348e:	89 50 04             	mov    %edx,0x4(%eax)
  803491:	eb 08                	jmp    80349b <insert_sorted_with_merge_freeList+0x45b>
  803493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803496:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80349b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349e:	a3 48 51 80 00       	mov    %eax,0x805148
  8034a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8034b2:	40                   	inc    %eax
  8034b3:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8034b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8034be:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c4:	01 c2                	add    %eax,%edx
  8034c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c9:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034e4:	75 17                	jne    8034fd <insert_sorted_with_merge_freeList+0x4bd>
  8034e6:	83 ec 04             	sub    $0x4,%esp
  8034e9:	68 d8 42 80 00       	push   $0x8042d8
  8034ee:	68 64 01 00 00       	push   $0x164
  8034f3:	68 fb 42 80 00       	push   $0x8042fb
  8034f8:	e8 e4 d1 ff ff       	call   8006e1 <_panic>
  8034fd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803503:	8b 45 08             	mov    0x8(%ebp),%eax
  803506:	89 10                	mov    %edx,(%eax)
  803508:	8b 45 08             	mov    0x8(%ebp),%eax
  80350b:	8b 00                	mov    (%eax),%eax
  80350d:	85 c0                	test   %eax,%eax
  80350f:	74 0d                	je     80351e <insert_sorted_with_merge_freeList+0x4de>
  803511:	a1 48 51 80 00       	mov    0x805148,%eax
  803516:	8b 55 08             	mov    0x8(%ebp),%edx
  803519:	89 50 04             	mov    %edx,0x4(%eax)
  80351c:	eb 08                	jmp    803526 <insert_sorted_with_merge_freeList+0x4e6>
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803526:	8b 45 08             	mov    0x8(%ebp),%eax
  803529:	a3 48 51 80 00       	mov    %eax,0x805148
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803538:	a1 54 51 80 00       	mov    0x805154,%eax
  80353d:	40                   	inc    %eax
  80353e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803543:	e9 41 02 00 00       	jmp    803789 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803548:	8b 45 08             	mov    0x8(%ebp),%eax
  80354b:	8b 50 08             	mov    0x8(%eax),%edx
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	8b 40 0c             	mov    0xc(%eax),%eax
  803554:	01 c2                	add    %eax,%edx
  803556:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803559:	8b 40 08             	mov    0x8(%eax),%eax
  80355c:	39 c2                	cmp    %eax,%edx
  80355e:	0f 85 7c 01 00 00    	jne    8036e0 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803564:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803568:	74 06                	je     803570 <insert_sorted_with_merge_freeList+0x530>
  80356a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80356e:	75 17                	jne    803587 <insert_sorted_with_merge_freeList+0x547>
  803570:	83 ec 04             	sub    $0x4,%esp
  803573:	68 14 43 80 00       	push   $0x804314
  803578:	68 69 01 00 00       	push   $0x169
  80357d:	68 fb 42 80 00       	push   $0x8042fb
  803582:	e8 5a d1 ff ff       	call   8006e1 <_panic>
  803587:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358a:	8b 50 04             	mov    0x4(%eax),%edx
  80358d:	8b 45 08             	mov    0x8(%ebp),%eax
  803590:	89 50 04             	mov    %edx,0x4(%eax)
  803593:	8b 45 08             	mov    0x8(%ebp),%eax
  803596:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803599:	89 10                	mov    %edx,(%eax)
  80359b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80359e:	8b 40 04             	mov    0x4(%eax),%eax
  8035a1:	85 c0                	test   %eax,%eax
  8035a3:	74 0d                	je     8035b2 <insert_sorted_with_merge_freeList+0x572>
  8035a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a8:	8b 40 04             	mov    0x4(%eax),%eax
  8035ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ae:	89 10                	mov    %edx,(%eax)
  8035b0:	eb 08                	jmp    8035ba <insert_sorted_with_merge_freeList+0x57a>
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	a3 38 51 80 00       	mov    %eax,0x805138
  8035ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c0:	89 50 04             	mov    %edx,0x4(%eax)
  8035c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8035c8:	40                   	inc    %eax
  8035c9:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	8b 50 0c             	mov    0xc(%eax),%edx
  8035d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035da:	01 c2                	add    %eax,%edx
  8035dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035df:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035e6:	75 17                	jne    8035ff <insert_sorted_with_merge_freeList+0x5bf>
  8035e8:	83 ec 04             	sub    $0x4,%esp
  8035eb:	68 a4 43 80 00       	push   $0x8043a4
  8035f0:	68 6b 01 00 00       	push   $0x16b
  8035f5:	68 fb 42 80 00       	push   $0x8042fb
  8035fa:	e8 e2 d0 ff ff       	call   8006e1 <_panic>
  8035ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803602:	8b 00                	mov    (%eax),%eax
  803604:	85 c0                	test   %eax,%eax
  803606:	74 10                	je     803618 <insert_sorted_with_merge_freeList+0x5d8>
  803608:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360b:	8b 00                	mov    (%eax),%eax
  80360d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803610:	8b 52 04             	mov    0x4(%edx),%edx
  803613:	89 50 04             	mov    %edx,0x4(%eax)
  803616:	eb 0b                	jmp    803623 <insert_sorted_with_merge_freeList+0x5e3>
  803618:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361b:	8b 40 04             	mov    0x4(%eax),%eax
  80361e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803623:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803626:	8b 40 04             	mov    0x4(%eax),%eax
  803629:	85 c0                	test   %eax,%eax
  80362b:	74 0f                	je     80363c <insert_sorted_with_merge_freeList+0x5fc>
  80362d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803630:	8b 40 04             	mov    0x4(%eax),%eax
  803633:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803636:	8b 12                	mov    (%edx),%edx
  803638:	89 10                	mov    %edx,(%eax)
  80363a:	eb 0a                	jmp    803646 <insert_sorted_with_merge_freeList+0x606>
  80363c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363f:	8b 00                	mov    (%eax),%eax
  803641:	a3 38 51 80 00       	mov    %eax,0x805138
  803646:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803649:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80364f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803652:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803659:	a1 44 51 80 00       	mov    0x805144,%eax
  80365e:	48                   	dec    %eax
  80365f:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803664:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803667:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80366e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803671:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803678:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80367c:	75 17                	jne    803695 <insert_sorted_with_merge_freeList+0x655>
  80367e:	83 ec 04             	sub    $0x4,%esp
  803681:	68 d8 42 80 00       	push   $0x8042d8
  803686:	68 6e 01 00 00       	push   $0x16e
  80368b:	68 fb 42 80 00       	push   $0x8042fb
  803690:	e8 4c d0 ff ff       	call   8006e1 <_panic>
  803695:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80369b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369e:	89 10                	mov    %edx,(%eax)
  8036a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a3:	8b 00                	mov    (%eax),%eax
  8036a5:	85 c0                	test   %eax,%eax
  8036a7:	74 0d                	je     8036b6 <insert_sorted_with_merge_freeList+0x676>
  8036a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8036ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036b1:	89 50 04             	mov    %edx,0x4(%eax)
  8036b4:	eb 08                	jmp    8036be <insert_sorted_with_merge_freeList+0x67e>
  8036b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8036c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8036d5:	40                   	inc    %eax
  8036d6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036db:	e9 a9 00 00 00       	jmp    803789 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8036e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e4:	74 06                	je     8036ec <insert_sorted_with_merge_freeList+0x6ac>
  8036e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ea:	75 17                	jne    803703 <insert_sorted_with_merge_freeList+0x6c3>
  8036ec:	83 ec 04             	sub    $0x4,%esp
  8036ef:	68 70 43 80 00       	push   $0x804370
  8036f4:	68 73 01 00 00       	push   $0x173
  8036f9:	68 fb 42 80 00       	push   $0x8042fb
  8036fe:	e8 de cf ff ff       	call   8006e1 <_panic>
  803703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803706:	8b 10                	mov    (%eax),%edx
  803708:	8b 45 08             	mov    0x8(%ebp),%eax
  80370b:	89 10                	mov    %edx,(%eax)
  80370d:	8b 45 08             	mov    0x8(%ebp),%eax
  803710:	8b 00                	mov    (%eax),%eax
  803712:	85 c0                	test   %eax,%eax
  803714:	74 0b                	je     803721 <insert_sorted_with_merge_freeList+0x6e1>
  803716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803719:	8b 00                	mov    (%eax),%eax
  80371b:	8b 55 08             	mov    0x8(%ebp),%edx
  80371e:	89 50 04             	mov    %edx,0x4(%eax)
  803721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803724:	8b 55 08             	mov    0x8(%ebp),%edx
  803727:	89 10                	mov    %edx,(%eax)
  803729:	8b 45 08             	mov    0x8(%ebp),%eax
  80372c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80372f:	89 50 04             	mov    %edx,0x4(%eax)
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	8b 00                	mov    (%eax),%eax
  803737:	85 c0                	test   %eax,%eax
  803739:	75 08                	jne    803743 <insert_sorted_with_merge_freeList+0x703>
  80373b:	8b 45 08             	mov    0x8(%ebp),%eax
  80373e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803743:	a1 44 51 80 00       	mov    0x805144,%eax
  803748:	40                   	inc    %eax
  803749:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80374e:	eb 39                	jmp    803789 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803750:	a1 40 51 80 00       	mov    0x805140,%eax
  803755:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80375c:	74 07                	je     803765 <insert_sorted_with_merge_freeList+0x725>
  80375e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803761:	8b 00                	mov    (%eax),%eax
  803763:	eb 05                	jmp    80376a <insert_sorted_with_merge_freeList+0x72a>
  803765:	b8 00 00 00 00       	mov    $0x0,%eax
  80376a:	a3 40 51 80 00       	mov    %eax,0x805140
  80376f:	a1 40 51 80 00       	mov    0x805140,%eax
  803774:	85 c0                	test   %eax,%eax
  803776:	0f 85 c7 fb ff ff    	jne    803343 <insert_sorted_with_merge_freeList+0x303>
  80377c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803780:	0f 85 bd fb ff ff    	jne    803343 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803786:	eb 01                	jmp    803789 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803788:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803789:	90                   	nop
  80378a:	c9                   	leave  
  80378b:	c3                   	ret    

0080378c <__udivdi3>:
  80378c:	55                   	push   %ebp
  80378d:	57                   	push   %edi
  80378e:	56                   	push   %esi
  80378f:	53                   	push   %ebx
  803790:	83 ec 1c             	sub    $0x1c,%esp
  803793:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803797:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80379b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80379f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037a3:	89 ca                	mov    %ecx,%edx
  8037a5:	89 f8                	mov    %edi,%eax
  8037a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037ab:	85 f6                	test   %esi,%esi
  8037ad:	75 2d                	jne    8037dc <__udivdi3+0x50>
  8037af:	39 cf                	cmp    %ecx,%edi
  8037b1:	77 65                	ja     803818 <__udivdi3+0x8c>
  8037b3:	89 fd                	mov    %edi,%ebp
  8037b5:	85 ff                	test   %edi,%edi
  8037b7:	75 0b                	jne    8037c4 <__udivdi3+0x38>
  8037b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8037be:	31 d2                	xor    %edx,%edx
  8037c0:	f7 f7                	div    %edi
  8037c2:	89 c5                	mov    %eax,%ebp
  8037c4:	31 d2                	xor    %edx,%edx
  8037c6:	89 c8                	mov    %ecx,%eax
  8037c8:	f7 f5                	div    %ebp
  8037ca:	89 c1                	mov    %eax,%ecx
  8037cc:	89 d8                	mov    %ebx,%eax
  8037ce:	f7 f5                	div    %ebp
  8037d0:	89 cf                	mov    %ecx,%edi
  8037d2:	89 fa                	mov    %edi,%edx
  8037d4:	83 c4 1c             	add    $0x1c,%esp
  8037d7:	5b                   	pop    %ebx
  8037d8:	5e                   	pop    %esi
  8037d9:	5f                   	pop    %edi
  8037da:	5d                   	pop    %ebp
  8037db:	c3                   	ret    
  8037dc:	39 ce                	cmp    %ecx,%esi
  8037de:	77 28                	ja     803808 <__udivdi3+0x7c>
  8037e0:	0f bd fe             	bsr    %esi,%edi
  8037e3:	83 f7 1f             	xor    $0x1f,%edi
  8037e6:	75 40                	jne    803828 <__udivdi3+0x9c>
  8037e8:	39 ce                	cmp    %ecx,%esi
  8037ea:	72 0a                	jb     8037f6 <__udivdi3+0x6a>
  8037ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037f0:	0f 87 9e 00 00 00    	ja     803894 <__udivdi3+0x108>
  8037f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037fb:	89 fa                	mov    %edi,%edx
  8037fd:	83 c4 1c             	add    $0x1c,%esp
  803800:	5b                   	pop    %ebx
  803801:	5e                   	pop    %esi
  803802:	5f                   	pop    %edi
  803803:	5d                   	pop    %ebp
  803804:	c3                   	ret    
  803805:	8d 76 00             	lea    0x0(%esi),%esi
  803808:	31 ff                	xor    %edi,%edi
  80380a:	31 c0                	xor    %eax,%eax
  80380c:	89 fa                	mov    %edi,%edx
  80380e:	83 c4 1c             	add    $0x1c,%esp
  803811:	5b                   	pop    %ebx
  803812:	5e                   	pop    %esi
  803813:	5f                   	pop    %edi
  803814:	5d                   	pop    %ebp
  803815:	c3                   	ret    
  803816:	66 90                	xchg   %ax,%ax
  803818:	89 d8                	mov    %ebx,%eax
  80381a:	f7 f7                	div    %edi
  80381c:	31 ff                	xor    %edi,%edi
  80381e:	89 fa                	mov    %edi,%edx
  803820:	83 c4 1c             	add    $0x1c,%esp
  803823:	5b                   	pop    %ebx
  803824:	5e                   	pop    %esi
  803825:	5f                   	pop    %edi
  803826:	5d                   	pop    %ebp
  803827:	c3                   	ret    
  803828:	bd 20 00 00 00       	mov    $0x20,%ebp
  80382d:	89 eb                	mov    %ebp,%ebx
  80382f:	29 fb                	sub    %edi,%ebx
  803831:	89 f9                	mov    %edi,%ecx
  803833:	d3 e6                	shl    %cl,%esi
  803835:	89 c5                	mov    %eax,%ebp
  803837:	88 d9                	mov    %bl,%cl
  803839:	d3 ed                	shr    %cl,%ebp
  80383b:	89 e9                	mov    %ebp,%ecx
  80383d:	09 f1                	or     %esi,%ecx
  80383f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803843:	89 f9                	mov    %edi,%ecx
  803845:	d3 e0                	shl    %cl,%eax
  803847:	89 c5                	mov    %eax,%ebp
  803849:	89 d6                	mov    %edx,%esi
  80384b:	88 d9                	mov    %bl,%cl
  80384d:	d3 ee                	shr    %cl,%esi
  80384f:	89 f9                	mov    %edi,%ecx
  803851:	d3 e2                	shl    %cl,%edx
  803853:	8b 44 24 08          	mov    0x8(%esp),%eax
  803857:	88 d9                	mov    %bl,%cl
  803859:	d3 e8                	shr    %cl,%eax
  80385b:	09 c2                	or     %eax,%edx
  80385d:	89 d0                	mov    %edx,%eax
  80385f:	89 f2                	mov    %esi,%edx
  803861:	f7 74 24 0c          	divl   0xc(%esp)
  803865:	89 d6                	mov    %edx,%esi
  803867:	89 c3                	mov    %eax,%ebx
  803869:	f7 e5                	mul    %ebp
  80386b:	39 d6                	cmp    %edx,%esi
  80386d:	72 19                	jb     803888 <__udivdi3+0xfc>
  80386f:	74 0b                	je     80387c <__udivdi3+0xf0>
  803871:	89 d8                	mov    %ebx,%eax
  803873:	31 ff                	xor    %edi,%edi
  803875:	e9 58 ff ff ff       	jmp    8037d2 <__udivdi3+0x46>
  80387a:	66 90                	xchg   %ax,%ax
  80387c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803880:	89 f9                	mov    %edi,%ecx
  803882:	d3 e2                	shl    %cl,%edx
  803884:	39 c2                	cmp    %eax,%edx
  803886:	73 e9                	jae    803871 <__udivdi3+0xe5>
  803888:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80388b:	31 ff                	xor    %edi,%edi
  80388d:	e9 40 ff ff ff       	jmp    8037d2 <__udivdi3+0x46>
  803892:	66 90                	xchg   %ax,%ax
  803894:	31 c0                	xor    %eax,%eax
  803896:	e9 37 ff ff ff       	jmp    8037d2 <__udivdi3+0x46>
  80389b:	90                   	nop

0080389c <__umoddi3>:
  80389c:	55                   	push   %ebp
  80389d:	57                   	push   %edi
  80389e:	56                   	push   %esi
  80389f:	53                   	push   %ebx
  8038a0:	83 ec 1c             	sub    $0x1c,%esp
  8038a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038bb:	89 f3                	mov    %esi,%ebx
  8038bd:	89 fa                	mov    %edi,%edx
  8038bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038c3:	89 34 24             	mov    %esi,(%esp)
  8038c6:	85 c0                	test   %eax,%eax
  8038c8:	75 1a                	jne    8038e4 <__umoddi3+0x48>
  8038ca:	39 f7                	cmp    %esi,%edi
  8038cc:	0f 86 a2 00 00 00    	jbe    803974 <__umoddi3+0xd8>
  8038d2:	89 c8                	mov    %ecx,%eax
  8038d4:	89 f2                	mov    %esi,%edx
  8038d6:	f7 f7                	div    %edi
  8038d8:	89 d0                	mov    %edx,%eax
  8038da:	31 d2                	xor    %edx,%edx
  8038dc:	83 c4 1c             	add    $0x1c,%esp
  8038df:	5b                   	pop    %ebx
  8038e0:	5e                   	pop    %esi
  8038e1:	5f                   	pop    %edi
  8038e2:	5d                   	pop    %ebp
  8038e3:	c3                   	ret    
  8038e4:	39 f0                	cmp    %esi,%eax
  8038e6:	0f 87 ac 00 00 00    	ja     803998 <__umoddi3+0xfc>
  8038ec:	0f bd e8             	bsr    %eax,%ebp
  8038ef:	83 f5 1f             	xor    $0x1f,%ebp
  8038f2:	0f 84 ac 00 00 00    	je     8039a4 <__umoddi3+0x108>
  8038f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8038fd:	29 ef                	sub    %ebp,%edi
  8038ff:	89 fe                	mov    %edi,%esi
  803901:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803905:	89 e9                	mov    %ebp,%ecx
  803907:	d3 e0                	shl    %cl,%eax
  803909:	89 d7                	mov    %edx,%edi
  80390b:	89 f1                	mov    %esi,%ecx
  80390d:	d3 ef                	shr    %cl,%edi
  80390f:	09 c7                	or     %eax,%edi
  803911:	89 e9                	mov    %ebp,%ecx
  803913:	d3 e2                	shl    %cl,%edx
  803915:	89 14 24             	mov    %edx,(%esp)
  803918:	89 d8                	mov    %ebx,%eax
  80391a:	d3 e0                	shl    %cl,%eax
  80391c:	89 c2                	mov    %eax,%edx
  80391e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803922:	d3 e0                	shl    %cl,%eax
  803924:	89 44 24 04          	mov    %eax,0x4(%esp)
  803928:	8b 44 24 08          	mov    0x8(%esp),%eax
  80392c:	89 f1                	mov    %esi,%ecx
  80392e:	d3 e8                	shr    %cl,%eax
  803930:	09 d0                	or     %edx,%eax
  803932:	d3 eb                	shr    %cl,%ebx
  803934:	89 da                	mov    %ebx,%edx
  803936:	f7 f7                	div    %edi
  803938:	89 d3                	mov    %edx,%ebx
  80393a:	f7 24 24             	mull   (%esp)
  80393d:	89 c6                	mov    %eax,%esi
  80393f:	89 d1                	mov    %edx,%ecx
  803941:	39 d3                	cmp    %edx,%ebx
  803943:	0f 82 87 00 00 00    	jb     8039d0 <__umoddi3+0x134>
  803949:	0f 84 91 00 00 00    	je     8039e0 <__umoddi3+0x144>
  80394f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803953:	29 f2                	sub    %esi,%edx
  803955:	19 cb                	sbb    %ecx,%ebx
  803957:	89 d8                	mov    %ebx,%eax
  803959:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80395d:	d3 e0                	shl    %cl,%eax
  80395f:	89 e9                	mov    %ebp,%ecx
  803961:	d3 ea                	shr    %cl,%edx
  803963:	09 d0                	or     %edx,%eax
  803965:	89 e9                	mov    %ebp,%ecx
  803967:	d3 eb                	shr    %cl,%ebx
  803969:	89 da                	mov    %ebx,%edx
  80396b:	83 c4 1c             	add    $0x1c,%esp
  80396e:	5b                   	pop    %ebx
  80396f:	5e                   	pop    %esi
  803970:	5f                   	pop    %edi
  803971:	5d                   	pop    %ebp
  803972:	c3                   	ret    
  803973:	90                   	nop
  803974:	89 fd                	mov    %edi,%ebp
  803976:	85 ff                	test   %edi,%edi
  803978:	75 0b                	jne    803985 <__umoddi3+0xe9>
  80397a:	b8 01 00 00 00       	mov    $0x1,%eax
  80397f:	31 d2                	xor    %edx,%edx
  803981:	f7 f7                	div    %edi
  803983:	89 c5                	mov    %eax,%ebp
  803985:	89 f0                	mov    %esi,%eax
  803987:	31 d2                	xor    %edx,%edx
  803989:	f7 f5                	div    %ebp
  80398b:	89 c8                	mov    %ecx,%eax
  80398d:	f7 f5                	div    %ebp
  80398f:	89 d0                	mov    %edx,%eax
  803991:	e9 44 ff ff ff       	jmp    8038da <__umoddi3+0x3e>
  803996:	66 90                	xchg   %ax,%ax
  803998:	89 c8                	mov    %ecx,%eax
  80399a:	89 f2                	mov    %esi,%edx
  80399c:	83 c4 1c             	add    $0x1c,%esp
  80399f:	5b                   	pop    %ebx
  8039a0:	5e                   	pop    %esi
  8039a1:	5f                   	pop    %edi
  8039a2:	5d                   	pop    %ebp
  8039a3:	c3                   	ret    
  8039a4:	3b 04 24             	cmp    (%esp),%eax
  8039a7:	72 06                	jb     8039af <__umoddi3+0x113>
  8039a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039ad:	77 0f                	ja     8039be <__umoddi3+0x122>
  8039af:	89 f2                	mov    %esi,%edx
  8039b1:	29 f9                	sub    %edi,%ecx
  8039b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039b7:	89 14 24             	mov    %edx,(%esp)
  8039ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039c2:	8b 14 24             	mov    (%esp),%edx
  8039c5:	83 c4 1c             	add    $0x1c,%esp
  8039c8:	5b                   	pop    %ebx
  8039c9:	5e                   	pop    %esi
  8039ca:	5f                   	pop    %edi
  8039cb:	5d                   	pop    %ebp
  8039cc:	c3                   	ret    
  8039cd:	8d 76 00             	lea    0x0(%esi),%esi
  8039d0:	2b 04 24             	sub    (%esp),%eax
  8039d3:	19 fa                	sbb    %edi,%edx
  8039d5:	89 d1                	mov    %edx,%ecx
  8039d7:	89 c6                	mov    %eax,%esi
  8039d9:	e9 71 ff ff ff       	jmp    80394f <__umoddi3+0xb3>
  8039de:	66 90                	xchg   %ax,%ax
  8039e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039e4:	72 ea                	jb     8039d0 <__umoddi3+0x134>
  8039e6:	89 d9                	mov    %ebx,%ecx
  8039e8:	e9 62 ff ff ff       	jmp    80394f <__umoddi3+0xb3>
